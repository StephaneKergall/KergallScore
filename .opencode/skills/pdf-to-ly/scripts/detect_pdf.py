#!/usr/bin/env python3
"""Diagnostic d'un PDF de partition : vectoriel ou scanné.

Usage:
    python3 detect_pdf.py chemin/vers/partition.pdf [--json]

Ne modifie rien. Affiche les métadonnées, les polices, les images et une
recommandation de pipeline.
"""
import argparse
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


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("pdf")
    ap.add_argument("--json", action="store_true", help="sortie JSON uniquement")
    ap.add_argument("--bbox", default="", help="écrire pdftotext -bbox dans ce fichier")
    args = ap.parse_args()

    pdf = Path(args.pdf)
    if not pdf.exists():
        sys.exit(f"PDF introuvable : {pdf}")

    info = parse_info(run(["pdfinfo", str(pdf)]))
    fonts = parse_fonts(run(["pdffonts", str(pdf)]))
    images_txt = run(["pdfimages", "-list", str(pdf)])
    text = run(["pdftotext", "-layout", str(pdf), "-"])

    if args.bbox:
        run(["pdftotext", "-bbox", str(pdf), args.bbox])

    pages = int(info.get("Pages", "0") or 0)
    image_rows = max(0, len([l for l in images_txt.splitlines() if l.strip()]) - 2)
    words = len(re.findall(r"[A-Za-zÀ-ÿ]{2,}", text))
    music_fonts = [f for f in fonts if any(m in f["name"].lower() for m in MUSIC_FONTS)]

    # Heuristique : un PDF scanné a des images plein-page et très peu de texte.
    scanned = pages > 0 and image_rows >= pages and words < 20 and not music_fonts
    kind = "scanned" if scanned else "vector"

    result = {
        "pdf": str(pdf.resolve()),
        "pages": pages,
        "page_size": info.get("Page size", ""),
        "title": info.get("Title", ""),
        "author": info.get("Author", ""),
        "music_fonts": music_fonts,
        "fonts": fonts,
        "image_rows": image_rows,
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

    if args.json:
        print(json.dumps(result, ensure_ascii=False, indent=1))
        return

    print(f"PDF          : {result['pdf']}")
    print(f"Pages        : {pages}  ({result['page_size']})")
    print(f"Titre        : {result['title'] or '(inconnu)'}")
    print(f"Polices      : {', '.join(f['name'] for f in fonts) or '(aucune)'}")
    print(f"Polices musi.: {', '.join(f['name'] for f in music_fonts) or '(aucune)'}")
    print(f"Images       : {image_rows} ligne(s) pdfimages")
    print(f"Mots texte   : {words}")
    print(f"Type détecté : {kind.upper()}")
    if scanned:
        print("  -> pipeline OCR (Audiveris requis) :")
        print("     audiveris -batch -export -output /tmp/pdftoly <pdf>")
        print("     .prog/lilypond-2.26.0/bin/musicxml2ly -o <Nom>.ly <fichier>.mxl")
        if not result["tools"]["audiveris"]:
            print("  !! Audiveris absent : installer Audiveris/Java, ne pas deviner les notes.")
    else:
        print("  -> pipeline vectoriel :")
        print("     utiliser scripts/reference/ (adapter constantes/police/clés)")
    if not result["tools"]["musicxml2ly"]:
        print("  note : musicxml2ly absent du PATH ; utiliser .prog/lilypond-2.26.0/bin/musicxml2ly")


if __name__ == "__main__":
    main()
