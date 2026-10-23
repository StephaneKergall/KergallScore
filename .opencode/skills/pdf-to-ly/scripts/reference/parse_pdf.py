#!/usr/bin/env python3
"""Extraction générique des glyphes et segments d'un PDF vectoriel.

Usage:
    python3 parse_pdf.py <partition.pdf> --out /tmp/pdftoly/parsed.json \
        [--font-dir /tmp/pdftoly/fonts]

Sortie:
    - parsed.json : liste de pages {page, glyphs, segments}
    - fonts.json  : mapping ressource PDF -> fichier de police extrait
    - font-dir/*  : polices embarquées extraites (si --font-dir)

Les glyphes contiennent le code brut, la ressource de police, la taille, et les
matrices PDF. Les codes de glyphes dépendent de la police : pour Maestro, voir
la table de la skill pdf-to-ly.

Dépendance : pypdf (déjà utilisé par le projet pour l'extraction PDF).
"""
import argparse
import json
import re
import zlib
from pathlib import Path

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
                    segments.append((pt(ctm, x0, y0), pt(ctm, x, y)))
                cur_path.append((x, y))
            else:  # c: approximation par l'extrémité
                x, y = stack[-2], stack[-1]
                if cur_path:
                    x0, y0 = cur_path[-1]
                    segments.append((pt(ctm, x0, y0), pt(ctm, x, y)))
                cur_path.append((x, y))
        elif op in ("S", "s", "f", "F", "f*", "B", "b", "B*", "b*", "n"):
            cur_path = []
        stack = []
    return glyphs, segments


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


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("pdf")
    ap.add_argument("--out", default="/tmp/pdftoly/parsed.json")
    ap.add_argument("--font-dir", default="")
    args = ap.parse_args()

    try:
        from pypdf import PdfReader
    except ImportError as exc:
        raise SystemExit("pypdf est requis : pip install pypdf") from exc

    reader = PdfReader(args.pdf)
    out = Path(args.out)
    out.parent.mkdir(parents=True, exist_ok=True)
    font_dir = Path(args.font_dir) if args.font_dir else out.parent / "fonts"
    font_dir.mkdir(parents=True, exist_ok=True)

    pages = []
    all_fonts = {}
    for i, page in enumerate(reader.pages, 1):
        content = page.get_contents()
        data = content.get_data() if content is not None else b""
        widths_by_font, font_names, font_files = read_font_widths(page)
        for res_name, (base, ext, fdata) in font_files.items():
            key = str(res_name).lstrip("/")
            safe = re.sub(r"[^A-Za-z0-9_.-]+", "_", key + "_" + base)
            path = font_dir / (safe + ext)
            path.write_bytes(fdata)
            all_fonts[key] = {"base": base, "file": str(path)}
        glyphs, segments = parse_content(data, i, widths_by_font, font_names)
        pages.append({"page": i, "glyphs": glyphs, "segments": segments})
        print(f"page {i}: {len(glyphs)} glyphes, {len(segments)} segments")

    out.write_text(json.dumps(pages, ensure_ascii=False))
    (out.parent / "fonts.json").write_text(json.dumps(all_fonts, ensure_ascii=False, indent=1))
    print(f"écrit {out} et {out.parent / 'fonts.json'}")


if __name__ == "__main__":
    main()
