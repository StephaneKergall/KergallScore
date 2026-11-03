#!/usr/bin/env python3
"""Fast path pdf-to-ly : diagnostic → parse → transcription → paroles → `.ly` → compilation.

Une seule commande, cache disque invalidé par empreinte du PDF + version des
scripts, chargement unique de `parsed.json`, une seule compilation finale.

Exemple :
    scripts/pipeline.sh partition.pdf --out-dir "02-Carême-Pâques/Ma pièce" \
        --title "Ma pièce" --composer '\\palestrina' --key 'f \\major' \
        --time 4/4 --tempo '"Adagio" 4=70'

Le cache va par défaut dans `<out-dir>/cache/pdf-to-ly/`. Utiliser `--cache-dir`
ou `PDFTOLY_CACHE` pour le déplacer (ex. /tmp). Ne commit rien.
"""
import argparse
import concurrent.futures
import hashlib
import json
import os
import re
import shlex
import shutil
import subprocess
import sys
import time
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
REF_DIR = SCRIPT_DIR / "reference"
ROOT = SCRIPT_DIR.parents[3]
sys.path.insert(0, str(REF_DIR))

import detect_pdf  # noqa: E402
import jsonio  # noqa: E402
import lyrics_json  # noqa: E402
import parse_pdf  # noqa: E402
import transcribe  # noqa: E402
import write_ly  # noqa: E402

STAGES = ("detect", "parse", "transcribe", "lyrics", "write", "compile")
SCRIPT_FILES = (
    SCRIPT_DIR / "pipeline.py",
    SCRIPT_DIR / "detect_pdf.py",
    REF_DIR / "parse_pdf.py",
    REF_DIR / "transcribe.py",
    REF_DIR / "lyrics_json.py",
    REF_DIR / "write_ly.py",
)


def sha1_file(path):
    h = hashlib.sha1()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def scripts_fingerprint():
    parts = []
    for f in SCRIPT_FILES:
        try:
            st = f.stat()
        except FileNotFoundError:
            continue
        parts.append(f"{f.name}:{st.st_size}:{st.st_mtime_ns}")
    return hashlib.sha1("|".join(parts).encode()).hexdigest()


MUSIC_FONT_NAMES = (
    "maestro", "opus", "sonata", "petrucci", "emmentaler",
    "bravura", "gonville", "feta",
)


def pick_font(fonts_json, explicit, music_font):
    """Retourne (chemin, clé de police) de la police musicale la plus probable."""
    try:
        fonts = jsonio.load(fonts_json)
    except Exception:
        fonts = {}
    if explicit:
        path = Path(explicit)
        for key, value in fonts.items():
            if value.get("file") and Path(value["file"]) == path:
                return path, key
        return path, music_font or "R7"
    entries = [
        (k, v.get("base", ""), Path(v["file"]))
        for k, v in fonts.items()
        if v.get("file") and Path(v["file"]).exists()
    ]
    if not entries:
        return None

    def rank(entry):
        key, base, path = entry
        low = base.lower()
        named_music = any(name in low for name in MUSIC_FONT_NAMES)
        if music_font:
            return (
                0 if key == music_font else 1,
                0 if named_music else 1,
                0 if path.suffix.lower() == ".ttf" else 1,
                key,
            )
        return (
            0 if named_music else 1,
            0 if path.suffix.lower() == ".ttf" else 1,
            key,
        )

    key, _, path = sorted(entries, key=rank)[0]
    return path, key


def run_bbox(pdf, out):
    out = Path(out)
    out.parent.mkdir(parents=True, exist_ok=True)
    p = subprocess.run(
        ["pdftotext", "-bbox", str(pdf), str(out)],
        capture_output=True, text=True, check=False,
    )
    if p.returncode != 0:
        raise RuntimeError(f"pdftotext -bbox a échoué : {p.stderr.strip()}")
    return out


def run_detect(pdf, out, fast=True):
    result = detect_pdf.detect(pdf, fast=fast)
    jsonio.dump(result, out)
    return result


def esc(value):
    return str(value).replace('"', '\\"')


def build_config(args):
    cfg = transcribe.config_from_env()
    if args.beats is not None:
        cfg["beats"] = args.beats
    if args.clefs:
        cfg["clefs"] = args.clefs.split(",")
    if args.topnames:
        cfg["topnames"] = args.topnames.split(",")
    if args.transpose:
        cfg["transpose"] = [int(x) for x in args.transpose.split(",")]
    if args.music_font:
        cfg["music_font"] = args.music_font
    if args.note_codes:
        cfg["note_codes"] = tuple(int(x) for x in args.note_codes.split(","))
    if args.rest_codes:
        cfg["rest_codes"] = tuple(int(x) for x in args.rest_codes.split(","))
    if args.acc_codes:
        cfg["acc_codes"] = {
            int(k): v for k, v in (x.split(":") for x in args.acc_codes.split(","))
        }
    if args.dot_code is not None:
        cfg["dot_code"] = args.dot_code
    return cfg


def compile_ly(ly, out_base, lilypond, flags, validate, verbose=False, quiet=False):
    flags = list(flags)
    if validate:
        flags.append("-dno-print-pages")
    cmd = [str(lilypond)] + [str(f) for f in flags] + [
        "-o", str(out_base), str(ly)
    ]
    t0 = time.perf_counter()
    p = subprocess.run(cmd, capture_output=True, text=True, check=False)
    out = p.stdout + p.stderr
    warnings = len(re.findall(r"warning|avertissement", out, re.I))
    errors = len(re.findall(r"\berror\b|erreur", out, re.I))
    if not quiet:
        print(f"lilypond: {p.returncode} ({time.perf_counter() - t0:.2f}s, "
              f"{warnings} warning(s), {errors} erreur(s))")
        if verbose:
            if out.strip():
                print(out.strip())
        else:
            lines = [
                l for l in out.splitlines()
                if re.search(r"warning|avertissement|error|erreur", l, re.I)
            ]
            if lines:
                print("\n".join(lines[:20]))
    status = p.returncode or (1 if errors else 0)
    return status, warnings, errors


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("pdf")
    ap.add_argument("--out-dir", "-o", default="", help="dossier de la pièce")
    ap.add_argument("--name", default="", help="nom du .ly/.pdf/.midi (défaut : dossier ou PDF)")
    ap.add_argument("--category", default="", help="<catégorie>/<nom> (alternative à --out-dir)")
    ap.add_argument("--cache-dir", default="", help="racine du cache (env PDFTOLY_CACHE)")
    ap.add_argument("--force", action="store_true", help="ignorer caches et écraser le .ly")
    ap.add_argument("--no-cache", action="store_true", help="ne pas lire le cache de parsing")
    ap.add_argument("--stop-after", choices=STAGES, default="compile",
                    help="s'arrêter après une étape (défaut : compile)")
    ap.add_argument("--jobs", type=int, default=0, help="processus de parsing (défaut CPU)")
    ap.add_argument("--no-compile", action="store_true")
    ap.add_argument("--validate", action="store_true",
                    help="compilation rapide -dno-print-pages (pas de PDF)")
    ap.add_argument("--lilypond", default=os.environ.get(
        "LILYPOND", str(ROOT / ".prog/lilypond-2.26.0/bin/lilypond")))
    ap.add_argument("--lilypond-flags", default=os.environ.get(
        "LILYPOND_FLAGS", "-dno-point-and-click"))
    ap.add_argument("--font", default="", help="police musicale .ttf/.otf explicite")
    ap.add_argument("--systems-per-page", type=int, default=int(
        os.environ.get("SYSTEMS_PER_PAGE", write_ly.DEFAULT_SYSTEMS_PER_PAGE)))
    ap.add_argument("--title", default=os.environ.get("TITLE", ""))
    ap.add_argument("--subtitle", default=os.environ.get("SUBTITLE", ""))
    ap.add_argument("--arranger", default=os.environ.get("ARRANGER", ""))
    ap.add_argument("--composer", default=os.environ.get("COMPOSER", r"\palestrina"))
    ap.add_argument("--toc-title", default=os.environ.get("TOC_TITLE", ""))
    ap.add_argument("--toc-composer", default=os.environ.get("TOC_COMPOSER", ""))
    ap.add_argument("--key", default=os.environ.get("KEY", r"f \major"))
    ap.add_argument("--time", default=os.environ.get("TIME", "4/4"))
    ap.add_argument("--tempo", default=os.environ.get("TEMPO", '"Adagio" 4=70'))
    ap.add_argument("--assume-vector", action="store_true",
                    help="continuer même si le diagnostic conclut 'scanned'")
    ap.add_argument("--fast", dest="fast", action="store_true", default=True)
    ap.add_argument("--no-fast", dest="fast", action="store_false")
    ap.add_argument("-q", "--quiet", action="store_true")
    ap.add_argument("-v", "--verbose", action="store_true",
                    help="afficher toute la sortie LilyPond")
    ap.add_argument("--json", action="store_true", help="résumé JSON final")
    # constantes de transcription (prioritaires sur les variables d'env)
    ap.add_argument("--beats", type=float)
    ap.add_argument("--clefs")
    ap.add_argument("--topnames")
    ap.add_argument("--transpose")
    ap.add_argument("--music-font")
    ap.add_argument("--note-codes")
    ap.add_argument("--rest-codes")
    ap.add_argument("--acc-codes")
    ap.add_argument("--dot-code", type=int)
    args = ap.parse_args()

    def say(*a, **k):
        if not args.quiet:
            print(*a, **k)

    t_start = time.perf_counter()
    timing = {}
    skipped = []
    pdf = Path(args.pdf).resolve()
    if not pdf.exists():
        sys.exit(f"PDF introuvable : {pdf}")
    stop_idx = STAGES.index(args.stop_after)

    if args.out_dir:
        out_dir = Path(args.out_dir)
    elif args.category:
        out_dir = Path(args.category)
    else:
        out_dir = pdf.parent
    name = args.name or (out_dir.name if args.out_dir else pdf.stem)
    if args.category and not args.out_dir:
        out_dir = out_dir / name
    if not args.name and not args.out_dir and out_dir.name != name:
        out_dir = out_dir / name
    ly_path = out_dir / f"{name}.ly"
    pdf_out = out_dir / f"{name}.pdf"
    midi_out = out_dir / f"{name}.midi"

    cache_root = Path(
        args.cache_dir or os.environ.get("PDFTOLY_CACHE")
        or out_dir / "cache" / "pdf-to-ly"
    )
    pdf_hash = sha1_file(pdf)
    cache_dir = cache_root / f"{pdf_hash[:16]}-{scripts_fingerprint()[:12]}"
    cache_dir.mkdir(parents=True, exist_ok=True)

    parsed = cache_dir / "parsed.json"
    fonts_dir = cache_dir / "fonts"
    fonts_json = cache_dir / "fonts.json"
    bbox = cache_dir / "bbox.html"
    detect_json = cache_dir / "detect.json"
    transcription = cache_dir / "transcription.json"
    voices_txt = cache_dir / "voices.txt"
    lyrics_path = cache_dir / "lyrics.json"
    compile_stamp = cache_dir / "compile.json"

    def timed(name, fn):
        t0 = time.perf_counter()
        result = fn()
        timing[name] = round(time.perf_counter() - t0, 3)
        return result

    # 1. diagnostic + bbox + parse en parallèle (uniquement si nécessaire)
    stage = args.stop_after
    stop_detect = STAGES.index("detect")
    stop_parse = STAGES.index("parse")
    stop_transcribe = STAGES.index("transcribe")
    stop_lyrics = STAGES.index("lyrics")
    stop_write = STAGES.index("write")

    write_requested = stop_idx >= stop_write
    will_write = write_requested and (args.force or not ly_path.exists())
    if write_requested and ly_path.exists() and not args.force:
        say(f"note: {ly_path} existe déjà (non modifié) ; --force pour le régénérer")

    upstream = will_write or stage in ("parse", "transcribe", "lyrics")
    need_detect = stage == "detect" or upstream
    need_parse = upstream and stop_idx >= stop_parse and (
        args.force or not (parsed.exists() and fonts_json.exists())
    )
    need_bbox = (will_write or stage == "lyrics") and stop_idx >= stop_lyrics and (
        args.force or not bbox.exists()
    )
    pages = None
    detect_result = None
    if need_detect or need_bbox or need_parse:
        futures = []
        with concurrent.futures.ThreadPoolExecutor(max_workers=2) as ex:
            if need_detect:
                futures.append(("detect", ex.submit(
                    timed, "detect", lambda: run_detect(pdf, detect_json, args.fast))))
            if need_bbox:
                futures.append(("bbox", ex.submit(
                    timed, "bbox", lambda: run_bbox(pdf, bbox))))
            if need_parse:
                pages = timed("parse", lambda: parse_pdf.parse(
                    pdf, parsed, fonts_dir,
                    jobs=args.jobs or None, force=args.force,
                    use_cache=not args.no_cache, quiet=not args.verbose,
                ))
            for _, f in futures:
                f.result()
    if detect_json.exists() and (stage == "detect" or upstream):
        detect_result = jsonio.load(detect_json)
    if pages is not None and not any(pg.get("glyphs") for pg in pages):
        say("attention: aucun glyphe extrait (contenu en XObjects ou PDF scanné ?)")

    if detect_result and detect_result.get("kind") == "scanned" and not args.assume_vector:
        print("PDF détecté comme scanné : utiliser scripts/scanned_to_ly.sh "
              "(Audiveris requis), ou --assume-vector si le diagnostic est faux.")
        sys.exit(2)
    if stage == "detect":
        say(f"cache: {cache_dir}")
        return

    # 2. transcription + paroles (modèle chargé une seule fois)
    need_transcribe = (will_write or stage in ("transcribe", "lyrics")) and (
        stop_idx >= stop_transcribe
    ) and (args.force or not (transcription.exists() and voices_txt.exists()))
    need_lyrics = (will_write or stage == "lyrics") and (
        args.force or not lyrics_path.exists()
    )
    need_model = need_transcribe or need_lyrics or will_write

    model = None
    if need_model:
        def build_model():
            nonlocal pages
            if pages is None:
                pages = jsonio.load(parsed)
            if not any(pg.get("glyphs") for pg in pages):
                sys.exit("Aucun glyphe musical extrait : vérifier le PDF "
                         "(contenu en XObjects/scanné) ou fournir un PDF vectoriel.")
            picked = pick_font(fonts_json, args.font, args.music_font or "")
            if picked is None:
                sys.exit("Aucune police musicale extraite : fournir --font <police.ttf>.")
            font_ttf, font_key = picked
            cfg = build_config(args)
            if not (args.music_font or os.environ.get("MUSIC_FONT")):
                cfg["music_font"] = font_key
            return transcribe.transcribe_pages(pages, font_ttf, cfg)

        model = timed("transcribe", build_model) if need_transcribe else build_model()
        if need_transcribe:
            timed("write_outputs", lambda: transcribe.write_outputs(
                model, cache_dir, quiet=not args.verbose))
    lyrics_data = None
    if need_lyrics:
        lyrics_data = timed("lyrics", lambda: lyrics_json.run(
            bbox, model, cache_dir, quiet=not args.verbose))
    elif lyrics_path.exists() and (will_write or stage == "lyrics"):
        lyrics_data = jsonio.load(lyrics_path)

    # 3. génération du .ly
    if will_write:
        if lyrics_data is None:
            lyrics_data = jsonio.load(lyrics_path)
        title = args.title or pdf.stem
        meta = {
            "title": esc(title),
            "subtitle": esc(args.subtitle),
            "arranger": esc(args.arranger),
            "composer": args.composer,
            "toc_title": esc(args.toc_title or title),
            "toc_composer": esc(args.toc_composer),
            "tempo": args.tempo,
            "key": args.key,
            "time": args.time,
            "systems_per_page": args.systems_per_page,
        }
        timed("write_ly", lambda: write_ly.write_ly(
            write_ly.render_ly(model, lyrics_data, quiet=not args.verbose, **meta),
            ly_path, quiet=not args.verbose))
    if stop_idx < STAGES.index("compile"):
        say(f"cache: {cache_dir}")
        if args.json:
            print(json.dumps({
                "cache": str(cache_dir), "files": [str(ly_path)],
                "timing": timing, "skipped": skipped,
            }, ensure_ascii=False))
        return

    # 4. une seule compilation finale
    if args.no_compile:
        timing["total"] = round(time.perf_counter() - t_start, 3)
        say("compilation ignorée (--no-compile)")
        say(f"cache: {cache_dir}")
        if timing:
            say("temps : " + ", ".join(f"{k}={v}s" for k, v in timing.items()))
        if args.json:
            print(json.dumps({
                "pdf": str(pdf), "ly": str(ly_path), "pdf_out": str(pdf_out),
                "midi": str(midi_out), "cache": str(cache_dir),
                "timing": timing, "skipped": skipped, "status": 0,
            }, ensure_ascii=False))
        return
    if not ly_path.exists():
        sys.exit(f"fichier LilyPond absent : {ly_path}")
    rc = 0
    previous = None
    if compile_stamp.exists():
        try:
            previous = jsonio.load(compile_stamp)
        except Exception:
            previous = None
    ly_mtime = ly_path.stat().st_mtime_ns
    fresh = (
        pdf_out.exists() and midi_out.exists()
        and pdf_out.stat().st_mtime >= ly_path.stat().st_mtime
        and previous is not None
        and previous.get("status") == 0
        and previous.get("ly_mtime_ns") == ly_mtime
    )
    if fresh and not args.force and not args.validate:
        skipped.append("compile")
        say(f"compilation à jour : {pdf_out.name}")
    else:
        rc, warnings, errors = timed("compile", lambda: compile_ly(
            ly_path, out_dir / name, args.lilypond,
            shlex.split(args.lilypond_flags or ""), args.validate, args.verbose,
            args.quiet,
        ))
        if args.validate:
            if rc and compile_stamp.exists():
                compile_stamp.unlink()
        else:
            jsonio.dump({
                "ly_mtime_ns": ly_mtime,
                "status": rc,
                "warnings": warnings,
                "errors": errors,
            }, compile_stamp)
        if not args.validate and pdf_out.exists() and shutil.which("pdfinfo"):
            pages_out = subprocess.run(
                ["pdfinfo", str(pdf_out)], capture_output=True, text=True
            ).stdout
            for line in pages_out.splitlines():
                if line.startswith("Pages:"):
                    say(f"pdf: {line.split(':', 1)[1].strip()} page(s)")

    timing["total"] = round(time.perf_counter() - t_start, 3)
    say(f"cache: {cache_dir}")
    if timing:
        say("temps : " + ", ".join(f"{k}={v}s" for k, v in timing.items()))
    if args.json:
        print(json.dumps({
            "pdf": str(pdf), "ly": str(ly_path), "pdf_out": str(pdf_out),
            "midi": str(midi_out), "cache": str(cache_dir),
            "timing": timing, "skipped": skipped,
            "status": rc,
        }, ensure_ascii=False))
    if rc:
        sys.exit(rc)


if __name__ == "__main__":
    main()
