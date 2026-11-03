#!/usr/bin/env python3
"""Diagnostic d'un PDF de partition : vectoriel ou scanné.

Usage:
    python3 detect_pdf.py chemin/vers/partition.pdf [--json] [--bbox fichier]
                                [--fast]

`--fast` saute `pdfimages -list` quand le PDF est clairement vectoriel (polices
musicales ou texte abondant). Les commandes externes sont lancées en parallèle.
Ne modifie rien d'autre que le fichier `--bbox` demandé.
"""
import argparse
import concurrent.futures
import json
import re
import shutil
import subprocess
import sys
from pathlib import Path

MUSIC_FONTS = (
    "maestro", "opus", "emmentaler", "sonata", "petrucci", "feta",
    "segoe", "bravura", "lilypond", "smufl",
)


def run(cmd):
    try:
        p = subprocess.run(cmd, capture_output=True, text=True, check=False)
        return p.stdout + p.stderr
    except FileNotFoundError:
        return ""


def parse_info(text):
    out = {}
    for line in text.splitlines():
        if ":" in line:
            k, v = line.split(":", 1)
            out[k.strip()] = v.strip()
    return out


def parse_fonts(text):
    fonts = []
    for line in text.splitlines()[2:]:
        parts = line.split()
        if len(parts) >= 2:
            fonts.append({"name": parts[0], "type": parts[1], "embedded": "yes" in line})
    return fonts


def detect(pdf, bbox=None, fast=False):
    """Diagnostique `pdf` et retourne un dictionnaire (sans rien imprimer)."""
    pdf = Path(pdf)
    if not pdf.exists():
        raise FileNotFoundError(f"PDF introuvable : {pdf}")
    if bbox:
        Path(bbox).parent.mkdir(parents=True, exist_ok=True)

    with concurrent.futures.ThreadPoolExecutor(max_workers=4) as ex:
        f_info = ex.submit(run, ["pdfinfo", str(pdf)])
        f_fonts = ex.submit(run, ["pdffonts", str(pdf)])
        f_text = ex.submit(run, ["pdftotext", "-layout", str(pdf), "-"])
        f_bbox = ex.submit(run, ["pdftotext", "-bbox", str(pdf), str(bbox)]) if bbox else None
        info = parse_info(f_info.result())
        fonts = parse_fonts(f_fonts.result())
        text = f_text.result()
        if f_bbox:
            f_bbox.result()

    pages = int(info.get("Pages", "0") or 0)
    words = len(re.findall(r"[A-Za-zÀ-ÿ]{2,}", text))
    music_fonts = [f for f in fonts if any(m in f["name"].lower() for m in MUSIC_FONTS)]

    # `pdfimages -list` est coûteux : en mode rapide on ne le lance que si le
    # diagnostic est ambigu (ni police musicale, ni texte).
    ambiguous = not music_fonts and words < 20
    if fast and not ambiguous:
        images_txt = ""
        images_skipped = True
    else:
        images_txt = run(["pdfimages", "-list", str(pdf)])
        images_skipped = False

    image_rows = max(0, len([l for l in images_txt.splitlines() if l.strip()]) - 2)
    scanned = (
        pages > 0
        and (image_rows >= pages if not images_skipped else True)
        and words < 20
        and not music_fonts
    )
    kind = "scanned" if scanned else "vector"

    return {
        "pdf": str(pdf.resolve()),
        "pages": pages,
        "page_size": info.get("Page size", ""),
        "title": info.get("Title", ""),
        "author": info.get("Author", ""),
        "music_fonts": music_fonts,
        "fonts": fonts,
        "image_rows": image_rows,
        "images_skipped": images_skipped,
        "text_words": words,
        "kind": kind,
        "tools": {
            "audiveris": bool(shutil.which("audiveris") or shutil.which("Audiveris")),
            "musicxml2ly": bool(
                shutil.which("musicxml2ly")
                or (Path(__file__).resolve().parents[4]
                    / ".prog/lilypond-2.26.0/bin/musicxml2ly").exists()
            ),
        },
    }


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("pdf")
    ap.add_argument("--json", action="store_true", help="sortie JSON uniquement")
    ap.add_argument("--bbox", default="", help="écrire pdftotext -bbox dans ce fichier")
    ap.add_argument("--fast", "--no-images", dest="fast", action="store_true",
                    help="sauter pdfimages -list si le PDF est clairement vectoriel")
    args = ap.parse_args()

    result = detect(args.pdf, args.bbox or None, args.fast)

    if args.json:
        print(json.dumps(result, ensure_ascii=False, indent=1))
        return

    print(f"PDF          : {result['pdf']}")
    print(f"Pages        : {result['pages']}  ({result['page_size']})")
    print(f"Titre        : {result['title'] or '(inconnu)'}")
    print(f"Polices      : {', '.join(f['name'] for f in result['fonts']) or '(aucune)'}")
    print(f"Polices musi.: {', '.join(f['name'] for f in result['music_fonts']) or '(aucune)'}")
    if result["images_skipped"]:
        print("Images       : (non analysées, mode rapide)")
    else:
        print(f"Images       : {result['image_rows']} ligne(s) pdfimages")
    print(f"Mots texte   : {result['text_words']}")
    print(f"Type détecté : {result['kind'].upper()}")
    if result["kind"] == "scanned":
        print("  -> pipeline OCR (Audiveris requis) :")
        print("     audiveris -batch -export -output /tmp/pdftoly <pdf>")
        print("     .prog/lilypond-2.26.0/bin/musicxml2ly -o <Nom>.ly <fichier>.mxl")
        if not result["tools"]["audiveris"]:
            print("  !! Audiveris absent : installer Audiveris/Java, ne pas deviner les notes.")
    else:
        print("  -> pipeline vectoriel :")
        print("     scripts/pipeline.sh <pdf> --out-dir <dossier> [--title ...]")
    if not result["tools"]["musicxml2ly"]:
        print("  note : musicxml2ly absent du PATH ; utiliser .prog/lilypond-2.26.0/bin/musicxml2ly")


if __name__ == "__main__":
    main()
