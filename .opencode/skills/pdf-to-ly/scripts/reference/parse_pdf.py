#!/usr/bin/env python3
"""Extraction générique des glyphes et segments d'un PDF vectoriel.

Usage:
    python3 parse_pdf.py <partition.pdf> --out /tmp/pdftoly/parsed.json \
        [--font-dir /tmp/pdftoly/fonts] [--jobs N] [--force]

Sortie:
    - parsed.json : liste de pages {page, glyphs, segments} (JSON compact)
    - fonts.json  : mapping ressource PDF -> fichier de police extrait
    - font-dir/*  : polices embarquées extraites

Le parsing des pages est parallélisé (multiprocessing) et mis en cache dans
`<out>.meta.json` : un second appel sur le même PDF ne reparse rien.

Dépendance : pypdf (déjà utilisé par le projet pour l'extraction PDF).
"""
import argparse
import concurrent.futures
import os
import re
from pathlib import Path

import jsonio

CACHE_VERSION = 3

# Largeurs Maestro (codes 1..23) utilisées par le PDF de référence.
MAESTRO_WIDTHS = {
    i: w for i, w in enumerate(
        [None, 709, 682, 723, 210, 422, 421, 331, 380, 328, 390, 319, 198,
         236, 287, 155, 330, 214, 730, 330, 770, 333, 662, 750]
    )
}


def mat_mul(m1, m2):
    a1, b1, c1, d1, e1, f1 = m1
    a2, b2, c2, d2, e2, f2 = m2
    return (
        a1 * a2 + b1 * c2, a1 * b2 + b1 * d2,
        c1 * a2 + d1 * c2, c1 * b2 + d1 * d2,
        e1 * a2 + f1 * c2 + e2, e1 * b2 + f1 * d2 + f2,
    )


def pt(m, x, y):
    a, b, c, d, e, f = m
    return (a * x + c * y + e, b * x + d * y + f)


def lex(s):
    i = 0
    n = len(s)
    while i < n:
        ch = s[i]
        if ch in b" \t\r\n\f\x00":
            i += 1
            continue
        if ch == 37:  # %
            while i < n and s[i] not in b"\r\n":
                i += 1
            continue
        if ch == 40:  # (
            i += 1
            depth = 1
            out = bytearray()
            while i < n and depth:
                c = s[i]
                if c == 92:  # backslash
                    i += 1
                    if i >= n:
                        break
                    c = s[i]
                    mp = {ord("n"): 10, ord("r"): 13, ord("t"): 9, ord("b"): 8,
                          ord("f"): 12, ord("("): 40, ord(")"): 41, ord("\\"): 92}
                    if c in mp:
                        out.append(mp[c])
                        i += 1
                    elif 48 <= c <= 55:
                        oct_ = bytearray()
                        while i < n and len(oct_) < 3 and 48 <= s[i] <= 55:
                            oct_.append(s[i])
                            i += 1
                        out.append(int(oct_, 8) & 0xFF)
                    elif c in (10, 13):
                        if c == 13 and i + 1 < n and s[i + 1] == 10:
                            i += 1
                        i += 1
                    else:
                        out.append(c)
                        i += 1
                elif c == 40:
                    depth += 1
                    out.append(c)
                    i += 1
                elif c == 41:
                    depth -= 1
                    if depth:
                        out.append(c)
                    i += 1
                else:
                    out.append(c)
                    i += 1
            yield ("str", bytes(out))
            continue
        if ch == 60:
            if s[i:i + 2] == b"<<":
                i += 2
                yield ("dict_start", None)
                continue
            i += 1
            hexd = bytearray()
            while i < n and s[i] != 62:
                c = s[i]
                if c not in b" \t\r\n\f":
                    hexd.append(c)
                i += 1
            i += 1
            hx = bytes(hexd)
            if len(hx) % 2:
                hx += b"0"
            yield ("str", bytes.fromhex(hx.decode()))
            continue
        if ch == 62:
            if s[i:i + 2] == b">>":
                i += 2
                yield ("dict_end", None)
                continue
            i += 1
            continue
        if ch == 91:
            i += 1
            yield ("arr_start", None)
            continue
        if ch == 93:
            i += 1
            yield ("arr_end", None)
            continue
        if ch == 47:  # name
            i += 1
            st = i
            while i < n and s[i] not in b" \t\r\n\f/[]<>(){}%":
                i += 1
            yield ("name", s[st:i].decode("latin1"))
            continue
        st = i
        while i < n and s[i] not in b" \t\r\n\f/[]<>(){}%":
            i += 1
        tok = s[st:i]
        try:
            yield ("num", float(tok)) if b"." in tok else ("num", int(tok))
        except ValueError:
            yield ("op", tok.decode("latin1"))


def parse_content(content, page_no, widths_by_font, font_names):
    stack = []
    arr_stack = []
    ctm = (1, 0, 0, 1, 0, 0)
    ctm_stack = []
    font = None
    fontsize = 0
    Tm = (1, 0, 0, 1, 0, 0)
    Tlm = Tm
    TL = 0
    charspace = wordspace = 0
    glyphs = []
    segments = []
    paths = []
    path_segs = []
    cur_path = []

    def show_string(sbytes):
        nonlocal Tm
        for code in sbytes:
            gx, gy = pt(mat_mul(Tm, ctm), 0, 0)
            fname = (font_names.get(font) or "").lower()
            widths = widths_by_font.get(font, {})
            if not widths and ("maestro" in fname or font == "R7"):
                widths = MAESTRO_WIDTHS
            glyphs.append({
                "page": page_no, "code": code, "x": gx, "y": gy,
                "font": font, "font_name": font_names.get(font, ""),
                "size": fontsize, "ctm": ctm, "Tm": Tm,
            })
            adv = (widths.get(code, 0) / 1000.0 * fontsize
                   + charspace + (wordspace if code == 32 else 0))
            Tm = mat_mul((1, 0, 0, 1, adv, 0), Tm)

    for kind, val in lex(content):
        if kind == "arr_start":
            arr_stack.append(stack)
            stack = []
            continue
        if kind == "arr_end":
            arr = stack
            stack = arr_stack.pop() if arr_stack else []
            stack.append(("array", arr))
            continue
        if kind != "op":
            stack.append(val)
            continue
        op = val
        if op == "q":
            ctm_stack.append(ctm)
        elif op == "Q":
            if ctm_stack:
                ctm = ctm_stack.pop()
        elif op == "cm":
            m = tuple(stack[-6:])
            ctm = mat_mul(m, ctm)
        elif op == "BT":
            Tm = (1, 0, 0, 1, 0, 0)
            Tlm = Tm
        elif op == "Tf":
            font = stack[-2]
            fontsize = float(stack[-1])
        elif op == "Tm":
            Tm = tuple(stack[-6:])
            Tlm = Tm
        elif op == "Td":
            tx, ty = stack[-2], stack[-1]
            Tlm = mat_mul((1, 0, 0, 1, tx, ty), Tlm)
            Tm = Tlm
        elif op == "TD":
            tx, ty = stack[-2], stack[-1]
            TL = -ty
            Tlm = mat_mul((1, 0, 0, 1, tx, ty), Tlm)
            Tm = Tlm
        elif op == "T*":
            Tlm = mat_mul((1, 0, 0, 1, 0, -TL), Tlm)
            Tm = Tlm
        elif op == "TL":
            TL = stack[-1]
        elif op == "Tc":
            charspace = stack[-1]
        elif op == "Tw":
            wordspace = stack[-1]
        elif op == "Tj":
            if stack and isinstance(stack[-1], bytes):
                show_string(stack[-1])
        elif op == "'":
            Tlm = mat_mul((1, 0, 0, 1, 0, -TL), Tlm)
            Tm = Tlm
            if stack and isinstance(stack[-1], bytes):
                show_string(stack[-1])
        elif op == '"':
            if len(stack) >= 3 and isinstance(stack[-1], bytes):
                wordspace = stack[-3]
                charspace = stack[-2]
                Tlm = mat_mul((1, 0, 0, 1, 0, -TL), Tlm)
                Tm = Tlm
                show_string(stack[-1])
        elif op == "TJ":
            if stack and isinstance(stack[-1], tuple) and stack[-1][0] == "array":
                for item in stack[-1][1]:
                    if isinstance(item, bytes):
                        show_string(item)
                    elif isinstance(item, (int, float)):
                        Tm = mat_mul((1, 0, 0, 1, -item / 1000.0 * fontsize, 0), Tm)
        elif op in ("m", "l", "c"):
            if op == "m":
                cur_path.append((stack[-2], stack[-1]))
            elif op == "l":
                x, y = stack[-2], stack[-1]
                if cur_path:
                    x0, y0 = cur_path[-1]
                    seg = (pt(ctm, x0, y0), pt(ctm, x, y))
                    segments.append(seg)
                    path_segs.append(seg)
                cur_path.append((x, y))
            else:  # c: approximation par l'extrémité
                x, y = stack[-2], stack[-1]
                if cur_path:
                    x0, y0 = cur_path[-1]
                    seg = (pt(ctm, x0, y0), pt(ctm, x, y))
                    segments.append(seg)
                    path_segs.append(seg)
                cur_path.append((x, y))
        elif op == "re":
            # Rectangle (barres de mesure, silences, lignes supplémentaires) :
            # émettre ses 4 arêtes pour que la géométrie soit complète.
            if len(stack) >= 4:
                rx, ry, rw, rh = stack[-4:]
                p1 = pt(ctm, rx, ry)
                p2 = pt(ctm, rx + rw, ry)
                p3 = pt(ctm, rx + rw, ry + rh)
                p4 = pt(ctm, rx, ry + rh)
                for a, b in ((p1, p2), (p2, p3), (p3, p4), (p4, p1)):
                    seg = (a, b)
                    segments.append(seg)
                    path_segs.append(seg)
                cur_path = [(rx, ry)]
        elif op in ("S", "s", "f", "F", "f*", "B", "b", "B*", "b*", "n"):
            if path_segs:
                paths.append(path_segs)
                path_segs = []
            cur_path = []
        stack = []
    if path_segs:
        paths.append(path_segs)
    return glyphs, segments, paths


def read_font_widths(page):
    """Largeurs par ressource de police (approximatif mais suffisant)."""
    widths_by_font = {}
    font_names = {}
    font_files = {}
    try:
        resources = page["/Resources"]
        if hasattr(resources, "get_object"):
            resources = resources.get_object()
        fonts = resources.get("/Font", {})
        if hasattr(fonts, "get_object"):
            fonts = fonts.get_object()
    except Exception:
        return widths_by_font, font_names, font_files
    for res_name, ref in fonts.items():
        try:
            font = ref.get_object()
        except Exception:
            continue
        key = str(res_name).lstrip("/")
        base = str(font.get("/BaseFont", res_name))
        font_names[key] = base
        first = int(font.get("/FirstChar", 0) or 0)
        widths = font.get("/Widths", []) or []
        try:
            widths = widths.get_object()
        except Exception:
            pass
        widths_by_font[key] = {
            first + i: float(w) for i, w in enumerate(widths)
        }
        # police embarquée
        try:
            desc = font.get("/FontDescriptor", {})
            desc = desc.get_object() if hasattr(desc, "get_object") else desc
            for fk in ("/FontFile2", "/FontFile3", "/FontFile"):
                if fk in desc:
                    stream = desc[fk].get_object()
                    data = stream.get_data()
                    ext = {"/FontFile2": ".ttf", "/FontFile3": ".otf"}.get(fk, ".bin")
                    font_files[key] = (base, ext, data)
                    break
        except Exception:
            pass
    return widths_by_font, font_names, font_files


def font_filename(key, base, ext):
    safe = re.sub(r"[^A-Za-z0-9_.-]+", "_", key + "_" + base)
    return safe + ext


def _parse_chunk(args):
    """Parse un bloc de pages dans un process : le PDF est ouvert par chemin."""
    pdf_path, page_numbers = args
    from pypdf import PdfReader

    reader = PdfReader(pdf_path)
    pages = []
    fonts = {}
    for no in page_numbers:
        page = reader.pages[no - 1]
        content = page.get_contents()
        data = content.get_data() if content is not None else b""
        widths_by_font, font_names, font_files = read_font_widths(page)
        glyphs, segments, paths = parse_content(data, no, widths_by_font, font_names)
        pages.append({"page": no, "glyphs": glyphs, "segments": segments,
                      "paths": paths})
        for key, (base, ext, fdata) in font_files.items():
            fonts[key] = (base, ext, fdata)
    return pages, fonts


def _chunks(seq, n):
    n = max(1, n)
    size = max(1, len(seq) // n)
    for i in range(0, len(seq), size):
        yield seq[i:i + size]


def _fingerprint(pdf):
    st = Path(pdf).stat()
    return st.st_size, st.st_mtime_ns


def _default_jobs():
    try:
        return max(1, int(os.environ.get("PDFTOLY_JOBS", "0")) or os.cpu_count() or 1)
    except ValueError:
        return os.cpu_count() or 1


def _cache_paths(out):
    out = Path(out)
    return out, out.with_name(out.name + ".meta.json"), out.parent / "fonts.json"


def _cache_meta(pdf, out, fonts_json, meta_path, font_dir):
    if not (out.exists() and fonts_json.exists() and meta_path.exists()):
        return None
    try:
        meta = jsonio.load(meta_path)
    except Exception:
        return None
    size, mtime_ns = _fingerprint(pdf)
    if (
        meta.get("version") != CACHE_VERSION
        or meta.get("pdf") != str(Path(pdf).resolve())
        or meta.get("size") != size
        or meta.get("mtime_ns") != mtime_ns
        or meta.get("font_dir") != str(Path(font_dir).resolve())
    ):
        return None
    if not all(Path(f).exists() for f in meta.get("font_files", [])):
        return None
    return meta


def parse(pdf, out, font_dir=None, jobs=None, force=False, use_cache=True,
          quiet=False, load_cached=True):
    """Parse `pdf` vers `out` (et les polices vers `font_dir`). Retourne les pages."""
    def say(*args):
        if not quiet:
            print(*args)
    try:
        from pypdf import PdfReader
    except ImportError as exc:
        raise SystemExit("pypdf est requis : pip install pypdf") from exc

    pdf = Path(pdf)
    out, meta_path, fonts_json = _cache_paths(out)
    font_dir = Path(font_dir) if font_dir else out.parent / "fonts"
    out.parent.mkdir(parents=True, exist_ok=True)
    font_dir.mkdir(parents=True, exist_ok=True)

    meta = _cache_meta(pdf, out, fonts_json, meta_path, font_dir) if (
        use_cache and not force
    ) else None
    if meta is not None:
        counts = meta.get("counts", [])
        say(f"cache: {out} ({len(counts)} page(s))")
        for page_no, n_glyphs, n_segments in counts:
            say(f"page {page_no}: {n_glyphs} glyphes, {n_segments} segments (cache)")
        return jsonio.load(out) if load_cached else None

    reader = PdfReader(str(pdf))
    page_count = len(reader.pages)
    jobs = jobs or _default_jobs()
    jobs = max(1, min(jobs, page_count))
    if page_count < 4:  # le lancement de process coûte plus cher que le parsing
        jobs = 1

    if jobs == 1:
        pages, fonts = _parse_chunk((str(pdf), list(range(1, page_count + 1))))
    else:
        chunks = list(_chunks(list(range(1, page_count + 1)), jobs))
        with concurrent.futures.ProcessPoolExecutor(max_workers=jobs) as ex:
            results = list(ex.map(_parse_chunk, [(str(pdf), c) for c in chunks]))
        pages = [pg for chunk, _ in results for pg in chunk]
        fonts = {}
        for _, chunk_fonts in results:
            fonts.update(chunk_fonts)

    for key, (base, ext, fdata) in fonts.items():
        path = font_dir / font_filename(key, base, ext)
        path.write_bytes(fdata)

    jsonio.dump(
        {k: {"base": base, "file": str(font_dir / font_filename(k, base, ext))}
         for k, (base, ext, _) in fonts.items()},
        fonts_json,
    )
    jsonio.dump(pages, out)
    size, mtime_ns = _fingerprint(pdf)
    jsonio.dump({
        "version": CACHE_VERSION,
        "pdf": str(pdf.resolve()),
        "size": size,
        "mtime_ns": mtime_ns,
        "font_dir": str(font_dir.resolve()),
        "font_files": [
            str(font_dir / font_filename(k, base, ext))
            for k, (base, ext, _) in fonts.items()
        ],
        "counts": [[pg["page"], len(pg["glyphs"]), len(pg["segments"])]
                   for pg in pages],
    }, meta_path)

    for pg in pages:
        say(f"page {pg['page']}: {len(pg['glyphs'])} glyphes, "
            f"{len(pg['segments'])} segments")
    if not any(pg["glyphs"] for pg in pages):
        say("attention: aucun glyphe extrait (contenu en XObjects ou PDF scanné ?)")
    say(f"écrit {out} et {fonts_json}")
    return pages


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("pdf")
    ap.add_argument("--out", default="/tmp/pdftoly/parsed.json")
    ap.add_argument("--font-dir", default="")
    ap.add_argument("--jobs", type=int, default=0, help="processus (défaut CPU, env PDFTOLY_JOBS)")
    ap.add_argument("--force", action="store_true", help="ignorer le cache")
    ap.add_argument("--no-cache", action="store_true", help="ne pas lire le cache")
    args = ap.parse_args()
    parse(
        args.pdf, args.out, args.font_dir or None,
        jobs=args.jobs or None, force=args.force, use_cache=not args.no_cache,
        load_cached=False,
    )


if __name__ == "__main__":
    main()
