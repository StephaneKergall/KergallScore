#!/usr/bin/env python3
"""Extraction et alignement des paroles depuis `pdftotext -bbox`.

Importable : l'import n'exécute rien. Utiliser `extract_lyrics()` avec un modèle
issu de `transcribe_pages()` / `transcribe.model_from_env()`, ou la CLI.

Variables d'environnement (CLI) :
  OUT_DIR    dossier de sortie (défaut /tmp/pdftoly)
  BBOX_HTML  fichier produit par `pdftotext -bbox` (défaut OUT_DIR/bbox.html)
  PDF_JSON   parsed.json (via transcribe.model_from_env)
  FONT_TTF   police musicale extraite (via transcribe.model_from_env)
"""
import html
import os
import re
from collections import defaultdict
from pathlib import Path

import jsonio
import transcribe as tr

PAGE_RE = re.compile(r"<page .*?</page>", re.S)
WORD_RE = re.compile(
    r'<word xMin="([\d.]+)" yMin="([\d.]+)" xMax="([\d.]+)" yMax="([\d.]+)">([^<]*)</word>'
)


def is_lyric(t):
    if t in ("-", "--"):
        return True
    if t in ("dim.", "rit.", "rit", "molto", "piu", "mosso", "dim"):
        return False
    if t in ("Soprano", "Alto", "Ténor", "Basse", "Annotations"):
        return False
    if re.fullmatch(r"[A-Za-zÀ-ÿ]+[,.]?", t):
        if len(re.sub(r"[,.]", "", t)) == 1:
            return t[0].lower() in ("o", "a", "e", "i")
        return True
    return False


def extract_lyrics(bbox_text, model):
    """Associe les mots aux systèmes/voix : {(page, système, voix): [(x, mot)]}."""
    pages = PAGE_RE.findall(bbox_text)
    staff_bottoms = {}
    for sysd in model["systems"]:
        page = sysd["page"]
        local = sysd["sysno"]
        for v in range(4):
            staff_bottoms[(page, local * 4 + v)] = sysd["staves"][v][-1]
    out = {}
    for pageno, pagehtml in enumerate(pages, 1):
        words = []
        for m in WORD_RE.finditer(pagehtml):
            x0, y0, x1, y1 = map(float, m.groups()[:4])
            text = html.unescape(m.group(5))
            words.append((x0, y0, x1, y1, text))
        lines = defaultdict(list)
        for w in words:
            lines[round(w[1])].append(w)
        for y in sorted(lines):
            ws = sorted(lines[y], key=lambda w: w[0])
            kept = [w for w in ws if is_lyric(w[4])]
            if len(kept) < 2:
                continue
            if not any(re.fullmatch(r"[A-Za-zÀ-ÿ]{2,}[,.]?", w[4]) for w in kept):
                continue
            best = None
            for (pg, st), bot in staff_bottoms.items():
                if pg != pageno:
                    continue
                top = 842 - bot
                if top < y <= top + 35:
                    if best is None or y - top < y - best[1]:
                        best = (st, top)
            if best:
                st, top = best
                local_sys = st // 4
                voice = st % 4
                out[f"{pageno},{local_sys},{voice}"] = [
                    (round(w[0], 1), w[4]) for w in kept
                ]
    return out


def run(bbox_path, model, work, quiet=False):
    """Lit le bbox, écrit lyrics.json (compact) et affiche le résumé."""
    work = Path(work)
    out = extract_lyrics(Path(bbox_path).read_text(), model)
    work.mkdir(parents=True, exist_ok=True)
    jsonio.dump(out, work / "lyrics.json")
    if not quiet:
        for k, v in out.items():
            print(k, " ".join(t for x, t in v))
        print(f"écrit {work}/lyrics.json")
    return out


def main():
    work = Path(os.environ.get("OUT_DIR", "/tmp/pdftoly"))
    bbox = Path(os.environ.get("BBOX_HTML", work / "bbox.html"))
    run(bbox, tr.model_from_env(), work)


if __name__ == "__main__":
    main()
