# Scripts `pdf-to-ly`

Pipeline de transcription d'un PDF de partition vers LilyPond.

## Fast path (une commande)

```bash
./pipeline.sh <partition.pdf> --out-dir "<NN-Catégorie>/<Nom>" \
  --title "<Titre>" --composer '\palestrina' \
  --key 'f \major' --time '4/4' --tempo '"Adagio" 4=70'
```

`pipeline.py` (appelé par `pipeline.sh`) enchaîne diagnostic → parse →
transcription → paroles → `.ly` → compilation, avec :

- cache disque invalidé par SHA-1 du PDF et empreinte des scripts ;
- chargement unique de `parsed.json` (transcription, paroles et génération
  partagent le même modèle en mémoire) ;
- une seule compilation finale (`-dno-point-and-click`) ;
- arrêt sur erreur et aucun écrasement d'un `.ly` existant sans `--force` ;
- sortie concise par défaut (`-v` pour le détail des scripts, `-q` pour tout taire) ;
- un échec LilyPond n'est pas masqué par le cache : le statut est mémorisé et
  la compilation est retentée au run suivant.

Cache par défaut : `<out-dir>/cache/pdf-to-ly/<sha1-pdf>-<scripts>/`.
Le déplacer avec `--cache-dir` ou `PDFTOLY_CACHE` (ex. `/tmp`).

Options principales : `--stop-after {detect,parse,transcribe,lyrics,write,compile}`,
`--validate` (`-dno-print-pages`, itérations, pas de PDF), `--force`, `--jobs`, `--font`,
`--systems-per-page`, `--beats`, `--clefs`, `--topnames`, `--transpose`,
`--music-font`, `--note-codes`, `--rest-codes`, `--acc-codes`, `--dot-code`,
`-q`, `-v`, `--json`. Les variables d'environnement historiques restent
prioritaires sur les défauts, mais les options de `pipeline.py` priment sur
l'environnement.

## Dépendances

```bash
./setup_venv.sh          # idempotent : teste les imports avant d'installer
```

`py.sh` choisit rapidement un Python disposant de `pypdf` + `fontTools`
(`PYTHON` prioritaire, puis `/tmp/pdftoly/venv`, puis `python3`). Le résultat
est mémorisé par `/tmp/pdftoly/venv/.deps-ok`.

## Diagnostic

```bash
./py.sh detect_pdf.py <partition.pdf> [--fast] [--json] [--bbox /tmp/bbox.html]
```

Classe le PDF en `vector` ou `scanned`, liste les polices et indique si
Audiveris / `musicxml2ly` sont disponibles. Les commandes externes sont lancées
en parallèle ; `--fast` saute `pdfimages -list` quand le PDF est clairement
vectoriel.

## PDF scanné

```bash
scanned_to_ly.sh <partition.pdf> <dossier_sortie> <nom_piece>
```

Audiveris (Java) est requis. Sans Audiveris, le script s'arrête avec un code 2 :
ne jamais deviner les notes.

## PDF vectoriel — scripts de référence

Ces scripts restent **spécialisés** (Maestro, 4 voix S/A/T/B, 4/4). Ils sont
importables : l'import n'exécute rien. Pour un autre PDF, adapter les codes de
glyphes, la police, les clés, le nombre de voix et les systèmes par page.

```bash
WORK=/tmp/pdftoly

./py.sh reference/parse_pdf.py <partition.pdf> \
  --out "$WORK/parsed.json" --font-dir "$WORK/fonts" [--jobs N]

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
| `parse_pdf.py` | `--out`, `--font-dir`, `--jobs`, `--force`, `--no-cache`, `PDFTOLY_JOBS` |
| `transcribe.py` | `PDF_JSON`, `FONT_TTF`, `OUT_DIR`, `BEATS`, `CLEFS`, `TOPNAMES`, `TRANSPOSE`, `MUSIC_FONT`, `NOTE_CODES`, `REST_CODES`, `ACC_CODES`, `DOT_CODE`, `SCORE_DIR` |
| `lyrics_json.py` | `PDF_JSON`, `FONT_TTF`, `OUT_DIR`, `BBOX_HTML` |
| `write_ly.py` | `PDF_JSON`, `FONT_TTF`, `OUT_DIR`, `LY_OUT`, `TITLE`, `SUBTITLE`, `ARRANGER`, `COMPOSER`, `TOC_TITLE`, `TOC_COMPOSER`, `KEY`, `TIME`, `TEMPO`, `SYSTEMS_PER_PAGE` |
| `pipeline.py` | toutes les précédentes + `PDFTOLY_CACHE`, `LILYPOND`, `LILYPOND_FLAGS` |

`FONT_TTF` doit pointer vers le `.ttf` extrait par `parse_pdf.py` (voir
`fonts.json`). Les polices CFF/OTF sont extraites en `.otf` ; `fontTools` ne
lit pas les flux Type1C, utiliser la police TrueType quand elle existe.

### Sorties intermédiaires

- `parsed.json` : glyphes et segments par page (JSON compact + `.meta.json` de cache).
- `fonts.json` : polices embarquées extraites.
- `voices.txt` : mesures LilyPond par voix.
- `transcription.json` : données structurées (notes, paroles).
- `lyrics.json` : syllabes alignées par `(page, système, voix)`.
- `detect.json` : diagnostic mis en cache par `pipeline.py`.

### Limites connues

- Détection des silences par somme de durées et plus grand intervalle x.
- Les codes de glyphes sont ceux de Maestro ; vérifier avec `pdffonts` et un
  rendu image pour une autre police.
- Les paroles reposent sur `pdftotext -bbox` ; une police sans `/Widths`
  (Times) donne des positions approximatives.
- Les PDF dont le contenu est dans des Form XObjects ne produisent aucun glyphe.
- Pas de vérification visuelle automatique : contrôler le PDF et le MIDI.
