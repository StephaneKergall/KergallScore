---
name: pdf-to-ly
description: Use when transcribing a sheet-music PDF (vector or scanned) into a LilyPond .ly file in the KergallScore repository, including OMR/Audiveris, Maestro glyph extraction, lyrics alignment, and LilyPond compilation. Triggers on "PDF partition", "transcrire", "OMR", "générer le .ly", "pdf-to-ly".
---

# PDF partition → LilyPond

Cette skill décrit le pipeline utilisé pour transcrire
`02-Carême-Pâques/Christus factus est - Palestrina/christus-factus-est_palestrina.pdf`
en `.ly`. Elle sert de référence pour tout PDF de partition du dépôt.

## 0. Contexte dépôt

Lire `AGENTS.md`. Points critiques :

- LilyPond local : `.prog/lilypond-2.26.0/bin/lilypond` (pas de `lilypond` global).
- Un morceau = `NN-Catégorie/<Nom>/<Nom>.ly` + `.pdf` + `.midi`, même nom partout.
- `\version "2.26.0"`, `\include "settings.ily"`, `\include "composers.ily"`.
- Voix : `soprano`, `alto`, `tenor`, `bass` ; `\clef "treble_8"` pour le ténor.
- `\key`, `\time`, `\tempo`, `\layout { \context { \Staff \RemoveAllEmptyStaves } }`, `\midi {}`.
- Ne pas commit sans demande explicite.

## 1. Diagnostic

```bash
pdfinfo   "<score.pdf>"
pdffonts  "<score.pdf>"
pdfimages -list "<score.pdf>"
pdftotext -bbox "<score.pdf>" /tmp/score_bbox.html
```

Décision :

| Indice | Pipeline |
|---|---|
| Polices `Maestro`, `Opus`, `Emmentaler`, `Sonata`, `Petrucci` ; texte extractible ; beaucoup de segments vectoriels | **Vectoriel** |
| Pages = images, pas de polices musicales, pas de texte musical | **Scanné / OCR** |
| PDF mixte | Traiter page par page, signaler les pages image |

Pour un PDF vectoriel, identifier :

- la police musicale et ses codes de glyphes (noteheads, silences, altérations) ;
- le nombre de portées par système et l'ordre des voix ;
- les clés (aigu, `treble_8`, basse) ;
- l'armure, la mesure, le tempo ;
- le nombre de pages et de systèmes.

## 2. Pipeline vectoriel (référence Maestro)

Le dossier `scripts/reference/` contient les scripts qui ont servi à
*Christus factus est*. Ils sont **spécialisés** : PDF Maestro, 4 voix S/A/T/B,
4/4, page A4. Pour un autre PDF, adapter les constantes après inspection.

Ordre d'exécution :

```bash
WORK=/tmp/pdftoly; mkdir -p "$WORK"

# 1. Extraire glyphes + segments (adapter les objets de page / la police)
PDF_JSON="$WORK/parsed.json" python3 scripts/reference/parse_pdf.py

# 2. Transcrire les notes / mesures / silences
PDF_JSON="$WORK/parsed.json" OUT_DIR="$WORK" python3 scripts/reference/transcribe.py

# 3. Extraire et aligner les paroles
PDF_JSON="$WORK/parsed.json" BBOX_HTML=/tmp/score_bbox.html OUT_DIR="$WORK" \
  python3 scripts/reference/lyrics_json.py

# 4. Générer le .ly
PDF_JSON="$WORK/parsed.json" OUT_DIR="$WORK" LY_OUT="<dossier>/<Nom>.ly" \
  python3 scripts/reference/write_ly.py
```

### Codes Maestro utiles

| Code | Signification |
|---|---|
| 1 | clé de sol |
| 2 | clé de sol avec 8 en dessous (ténor) |
| 3 | clé de fa |
| 4 | bémol |
| 5 | C (mesure à 4/4) |
| 6 | tête de blanche ronde (ronde) |
| 9 | tête de blanche |
| 11 | tête de noire |
| 12 | bécarre |
| 13 | dièse |
| 14 | point d'orgue |
| 15 | point de prolongation |
| 16 | soupir (quart de silence) |
| 17 | respiration |
| 18 | forte |
| 19 | accent / articulation |
| 20 | piano |
| 22 | point d'orgue (variante) |

Les codes sont ceux du PDF de référence ; **toujours vérifier** sur le PDF cible
avec `pdffonts`, l'extraction des glyphes et un rendu image.

### Pièges rencontrés

- **Clé de ténor** : code 2 = `treble_8`. Calculer la hauteur **écrite** depuis
  la ligne supérieure (F5), puis descendre d'une octave pour la hauteur réelle ;
  écrire la hauteur réelle avec `\clef "treble_8"`.
- **Altérations** : le suffixe doit précéder les marques d'octave (`cs'`, `ef'`,
  `bn'` — en anglais, `b!` pour un bécarre forcé).
- **Ligatures** : vérifier que la hampe est bien dans l'intervalle horizontal de
  la ligature ; sinon les croches sont fausses.
- **Silences** : certains silences sont des **chemins vectoriels**, pas des
  glyphes. Les déduire par la somme des durées de la mesure, en plaçant le
  silence dans le plus grand espace x (début / milieu / fin).
- **Paroles** : `pdftotext -bbox` perd les largeurs de la police Times-Roman
  (pas de `/Widths`). Utiliser les mots `<word>` avec leurs x, filtrer les
  glyphes musicaux, et aligner chaque syllabe sur la note la plus proche.
  Les traits d'union et mélismes doivent venir de la source, pas de la simple
  adjacence des notes.
- **Mesures** : fusionner les barres de mesure séparées de moins de 5 pt ;
  vérifier que chaque mesure totalise exactement 4 temps (ou l'armure).

## 3. Pipeline scanné / OCR

Audiveris est l'outil recommandé (Java, export MusicXML) :

```bash
# installation : voir https://audiveris.github.io/audiveris/
audiveris -batch -export -output /tmp/pdftoly "<score.pdf>"
# puis
.prog/lilypond-2.26.0/bin/musicxml2ly -o "<Nom>.ly" /tmp/pdftoly/<score>.mxl
```

Si Audiveris n'est pas installé, ne pas inventer la musique. Le signaler à
l'utilisateur et proposer :

- installer Audiveris (Java) ;
- ou fournir un PDF vectoriel / MusicXML / MIDI.

Après `musicxml2ly`, adapter le `.ly` aux conventions KergallScore :
includes, en-tête, tagline, noms de voix, paroles, `\layout`, `\midi`.

## 4. Contrôles qualité

```bash
.prog/lilypond-2.26.0/bin/lilypond -o "<dossier>/<Nom>" "<dossier>/<Nom>.ly"

pdfinfo "<dossier>/<Nom>.pdf" | grep Pages
```

Vérifier :

- zéro erreur et zéro warning LilyPond ;
- chaque mesure = 4 temps (ou armure) ;
- notes/altérations cohérentes avec la source ;
- paroles complètes et alignées ;
- `.pdf` et `.midi` générés à côté du `.ly` ;
- `.pdf`/`.midi` régénérés après la dernière modification du `.ly`.

## 5. Scripts

- `scripts/setup_venv.sh` — crée un venv avec pypdf/fontTools.
- `scripts/py.sh` — choisit le Python adéquat.
- `scripts/detect_pdf.py` — diagnostic rapide (vectoriel/scanné, polices, pages).
- `scripts/scanned_to_ly.sh` — pipeline Audiveris + `musicxml2ly`.
- `scripts/reference/parse_pdf.py` — extraction glyphes/segments (référence).
- `scripts/reference/transcribe.py` — portées, notes, ligatures, silences (référence).
- `scripts/reference/lyrics_json.py` — paroles + alignement (référence).
- `scripts/reference/write_ly.py` — génération du `.ly` (référence).

Les scripts `reference/` contiennent des chemins et constantes du cas Palestrina ;
les adapter au PDF cible avant de les exécuter.
