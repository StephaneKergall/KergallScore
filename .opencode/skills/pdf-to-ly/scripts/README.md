# Scripts `pdf-to-ly`

Pipeline de transcription d'un PDF de partition vers LilyPond.

## Dépendances

```bash
./setup_venv.sh          # crée /tmp/pdftoly/venv (pypdf, fontTools, Pillow, numpy)
```

`py.sh` choisit automatiquement un Python disposant de `pypdf` + `fontTools`
(variable `PYTHON` prioritaire). Exemple :

```bash
./py.sh reference/parse_pdf.py <partition.pdf> --out /tmp/parsed.json
```

## Diagnostic

```bash
./py.sh detect_pdf.py <partition.pdf> [--json] [--bbox /tmp/bbox.html]
```

Classe le PDF en `vector` ou `scanned`, liste les polices et indique si
Audiveris / `musicxml2ly` sont disponibles.

## PDF scanné

```bash
scanned_to_ly.sh <partition.pdf> <dossier_sortie> <nom_piece>
```

Audiveris (Java) est requis. Sans Audiveris, le script s'arrête avec un code 2 :
ne jamais deviner les notes.

## PDF vectoriel — scripts de référence

Ces scripts sont la version généralisée de la transcription de
*Christus factus est* (Palestrina, Maestro, 4 voix, 4/4). Ils restent
**spécialisés** : pour un autre PDF, adapter les codes de glyphes, la police,
les clés, le nombre de voix et la répartition des systèmes.

```bash
WORK=/tmp/pdftoly

./py.sh reference/parse_pdf.py <partition.pdf> \
  --out "$WORK/parsed.json" --font-dir "$WORK/fonts"

PDF_JSON="$WORK/parsed.json" FONT_TTF="$WORK/fonts/<police>.ttf" \
OUT_DIR="$WORK" ./py.sh reference/transcribe.py

pdftotext -bbox <partition.pdf> "$WORK/bbox.html"
PDF_JSON="$WORK/parsed.json" FONT_TTF="$WORK/fonts/<police>.ttf" \
OUT_DIR="$WORK" BBOX_HTML="$WORK/bbox.html" \
  ./py.sh reference/lyrics_json.py

PDF_JSON="$WORK/parsed.json" FONT_TTF="$WORK/fonts/<police>.ttf" \
OUT_DIR="$WORK" LY_OUT="/chemin/<Nom>.ly" \
TITLE="<Titre>" SUBTITLE="<sous-titre>" ARRANGER="<arrangeur>" \
COMPOSER='\<compositeur>' TOC_TITLE="<Titre>" TOC_COMPOSER="<Compositeur>" \
KEY='f \major' TIME='4/4' TEMPO='"Adagio" 4=70' \
  ./py.sh reference/write_ly.py
```

### Variables d'environnement

| Script | Variables |
|---|---|
| `parse_pdf.py` | `--out`, `--font-dir` |
| `transcribe.py` | `PDF_JSON`, `FONT_TTF`, `OUT_DIR`, `BEATS`, `CLEFS`, `TOPNAMES`, `TRANSPOSE`, `MUSIC_FONT`, `NOTE_CODES`, `REST_CODES`, `ACC_CODES`, `DOT_CODE`, `SCORE_DIR` |
| `lyrics_json.py` | `PDF_JSON`, `FONT_TTF`, `OUT_DIR`, `BBOX_HTML` |
| `write_ly.py` | `PDF_JSON`, `FONT_TTF`, `OUT_DIR`, `LY_OUT`, `TITLE`, `SUBTITLE`, `ARRANGER`, `COMPOSER`, `TOC_TITLE`, `TOC_COMPOSER`, `KEY`, `TIME`, `TEMPO` |

`FONT_TTF` doit pointer vers le `.ttf` extrait par `parse_pdf.py` (voir
`$WORK/fonts.json`). Les polices musicales CFF/OTF sont extraites en `.otf`.

### Sorties intermédiaires

- `parsed.json` : glyphes et segments par page.
- `fonts.json` : polices embarquées extraites.
- `voices.txt` : mesures LilyPond par voix.
- `transcription.json` : données structurées (notes, paroles).
- `lyrics.json` : syllabes alignées par `(page, système, voix)`.

### Limites connues

- Détection des silences par somme de durées et plus grand intervalle x.
- Les codes de glyphes sont ceux de Maestro ; vérifier avec `pdffonts` et un
  rendu image pour une autre police.
- Les paroles reposent sur `pdftotext -bbox` ; une police sans `/Widths`
  (Times) donne des positions approximatives.
- Pas de vérification visuelle automatique : contrôler le PDF et le MIDI.
