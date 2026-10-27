---
name: pdf-to-ly
description: Use when transcribing a sheet-music PDF (vector or scanned) into a LilyPond .ly file in the KergallScore repository, including OMR/Audiveris, Maestro glyph extraction, lyrics alignment, and LilyPond compilation. Triggers on "PDF partition", "transcrire", "OMR", "générer le .ly", "pdf-to-ly".
---

# PDF partition → LilyPond

Cette skill décrit le pipeline utilisé pour transcrire un PDF de partition en `.ly` dans le dépôt KergallScore.

## 0. Contexte dépôt

Lire `AGENTS.md`. Points critiques :

- LilyPond local : `.prog/lilypond-2.26.0/bin/lilypond` (pas de `lilypond` global).
- Un morceau = `NN-Catégorie/<Nom>/<Nom>.ly` + `.pdf` + `.midi`, même nom partout.
- `\version "2.26.0"`, `\include "settings.ily"`, `\include "composers.ily"`.
- Voix : `soprano`, `alto`, `tenor`, `bass` ; `\clef "treble_8"` pour le ténor.
- `\key`, `\time`, `\tempo`, `\layout { \context { \Staff \RemoveAllEmptyStaves } }`, `\midi {}`.
- Ne pas commit sans demande explicite.

## 1. Modes de travail

Il existe deux modes :

| Mode | Quand l'utiliser | Comportement |
|---|---|---|
| **Génération from scratch** (historique) | Aucun squelette `.ly` fourni. | Générer un `.ly` complet selon les conventions du dépôt (comme pour *Christus factus est*). |
| **Avec squelette `new.py`** (nouveau, prioritaire) | Un fichier `.ly` pré-généré par `.prog/new.py` est fourni (chemin explicite) ou détecté automatiquement à côté du PDF / avec un nom cohérent. | **Parser strictement le squelette et n'injecter que le contenu musical.** Ne pas régénérer la structure. Respecter à la lettre tout ce qui est déjà présent. |

### 1.1 Détection du squelette `new.py`

Accepter un squelette dans les cas suivants :

- Chemin explicite passé en argument (ex. `partition.pdf skeleton.ly` ou `--skeleton path/to/file.ly`).
- Fichier `.ly` présent dans le même dossier que le PDF avec un nom cohérent (même nom de base, ou nom suggéré par `new.py`).
- Fichier `.ly` dont le contenu correspond à la structure générée par `.prog/new.py` (présence de `\include "settings.ily"`, `\include "composers.ily"`, `global = {`, blocs `*Part` comme `ChoeurPart`/`SoloPart`/`FlûtePart`/`ClavierPart`, `\score { ... \layout { \context { \Staff \RemoveAllEmptyStaves } } \midi { ... } }`).

**Si un squelette est détecté ou fourni, ce mode est prioritaire.** Le signaler clairement dans le rapport.

### 1.2 Parsing strict du squelette

Extraire et **conserver intégralement** les éléments suivants depuis le squelette :

- `\version` (doit rester `"2.26.0"`)
- `\include "settings.ily"`, `\include "composers.ily"`
- Bloc `global = { ... }` (clé, mesure, anacrouse `\partial`, `\tempo` textuel, `\autoBeamOff`, `\mergeDifferentlyHeadedOn`, `\mergeDifferentlyDottedOn` s'ils sont présents). **Ne pas réécrire** sauf si explicitement nécessaire et justifié ; préférer respecter strictement.
- Bloc `\header { ... }` entier (titre, sous-titres, compositeur/parolier/arrangeur sous forme d'identifiants `\...` ou de chaînes, dédicace, copyright, tagline, etc.). **Conserver intégralement les valeurs.**
- Variables musicales existantes : `soprano`, `alto`, `tenor`, `bass`, `sopranoOne`, `sopranoTwo`, ..., `altoOne`/`Two`..., `tenorOne`/`Two`..., `bassOne`/`Two`..., `soloVoice`, `flute`, `right`, `rightOne`/`Two`..., `left`, `leftOne`/`Two`..., `pedal`, `pedalOne`/`Two`... et toute autre variable musicale déclarée.
- Variables de paroles existantes : `VerseOne`/`VerseTwo`/... (paroles partagées), `sopranoVerseOne`/..., `altoVerseOne`/..., `tenorVerseOne`/..., `bassVerseOne`/..., `soloVerseOne`/..., `fluteVerse`, etc., selon l'usage de `\strophemode`.
- Blocs parties avec leur structure exacte : `ChoeurPart`, `SoloPart`, `FlûtePart`, `ClavierPart` (et tout autre `*Part` présent). Conserver l'ordre, les `\with { ... }`, `instrumentName`/`shortInstrumentName`, `midiInstrument`, graveurs (`Merge_rests_engraver`, `Ambitus_engraver`), clefs, `\voiceOne`/`\voiceTwo`, structure `<< >>`, `\new Staff`, `\new Voice`, `\new Lyrics`, `\lyricsto`.
- Bloc `\score { \header { ... } ... \layout { \context { \Staff \RemoveAllEmptyStaves } } \midi { \tempo ... } }` dans son intégralité. **Ne pas modifier** `\layout` ni `\midi` sauf si une erreur de compilation l'impose de manière minimale et justifiée.
- `\tocItem...` / `\tocItemComposer...` s'ils sont présents.

### 1.3 Règles d'injection (mode squelette)

**Injection uniquement.** Interdictions strictes :

- Ne PAS renommer de variables
- Ne PAS changer l'ordre des parties
- Ne PAS réécrire le `\header`
- Ne PAS modifier `\layout`/`\midi`
- Ne PAS changer `\version`/includes
- Ne PAS ajouter/supprimer de blocs `*Part` ou restructurer le `\score`

**Autorisations :**

- Remplir **uniquement le contenu entre `{ }`** des variables musicales existantes (`soprano`, `alto`, `tenor`, `bass`, `soloVoice`, `flute`, `right`/`left`/`pedal` et variantes numérotées) avec la musique extraite du PDF (notes, rythmes, durées, altérations, silences, liaisons/indications si présentes dans la source et cohérentes avec le style du dépôt).
- Remplir **uniquement le contenu entre `{ }`** des variables de paroles existantes avec les syllabes alignées depuis le PDF.
- Respecter strictement le mode d'écriture déjà utilisé : `\fixed c'` / `\fixed c` ou `\relative ...` tel qu'employé dans le squelette. Ne pas convertir d'un mode à l'autre.
- Respecter `\clef "treble_8"` si le ténor l'utilise déjà (ou s'il est requis par la structure). Respecter `\voiceOne`/`\voiceTwo` si des voix sont superposées.
- Respecter `\lyricsto`, `\strophemode` déjà présents. Utiliser `--` pour les traits d'union et `__` pour les mélismes, exactement comme dans la source et de manière cohérente avec l'alignement.
- Conserver `\autoBeamOff` s'il est dans `global`.
- Si le squelette impose un schéma/voix différent de ce que montre le PDF (nombre de voix, répartition SA/TB, présence de solo/flûte/piano/orgue), **signaler clairement les écarts** et demander confirmation avant d'injecter, ou adapter l'injection au schéma existant sans le restructurer.

## 2. Diagnostic

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

**Si un squelette `new.py` est présent** : comparer avec le PDF (voix, schéma, nombre de couplets, présence de parties). Signaler tout écart.

## 3. Pipeline vectoriel (référence Maestro)

Le dossier `scripts/reference/` contient les scripts qui ont servi à
*Christus factus est*. Ils sont **spécialisés** : PDF Maestro, 4 voix S/A/T/B,
4/4, page A4. Pour un autre PDF, adapter les constantes après inspection.

### 3.1 Mode from scratch (sans squelette)

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

### 3.2 Mode avec squelette `new.py` (injection)

**Ne pas utiliser `write_ly.py` pour régénérer le fichier.** Adapter le pipeline pour produire des données prêtes à injecter dans le squelette existant.

Étapes recommandées :

1. **Parser le squelette** : lire le `.ly` squelette et extraire (de manière déterministe) :
   - `global` (clé/mesure/anacrouse/tempo)
   - toutes les variables musicales déclarées et leur mode (`\fixed`/`\relative`), leur octave, leur contenu actuel (à remplacer)
   - toutes les variables de paroles déclarées et leur type (`\lyricmode` / `\strophemode`)
   - structure des `*Part` et mapping voix ↔ portées ↔ `\lyricsto`
   - `\header`, `\layout`, `\midi`, includes, `\version`
2. **Extraire/transcrire depuis le PDF** (mêmes étapes 1-3 que ci-dessus : `parse_pdf.py`, `transcribe.py`, `lyrics_json.py`) en adaptant aux constantes du PDF cible (police, codes glyphes, nombre de voix, clés, mesure).
3. **Mapper** la transcription aux variables du squelette. Si le nombre de voix diffère, **signaler l'écart**. Respecter l'ordre des voix tel qu'il apparaît dans les `*Part` du squelette.
4. **Injecter** uniquement dans le contenu `{ }` des variables musicales et paroles existantes. Préserver tout le reste byte-à-byte dans la mesure du possible (indentation, commentaires s'ils existent).
5. **Vérifier** la cohérence (mesures, clés, `\clef "treble_8"` pour ténor si requis, alignement paroles).

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

## 4. Pipeline scanné / OCR

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

### 4.1 Mode from scratch
Après `musicxml2ly`, adapter le `.ly` aux conventions KergallScore :
includes, en-tête, tagline, noms de voix, paroles, `\layout`, `\midi`.

### 4.2 Mode avec squelette `new.py` (injection)
**Ne pas remplacer le squelette par le `.ly` brut généré par `musicxml2ly`.** 

Options :
- Soit importer/convertir le MusicXML vers des données mappables et injecter uniquement dans les variables du squelette existant.
- Soit utiliser `musicxml2ly` vers un fichier temporaire pour inspection, puis extraire notes/paroles/structure et les réinjecter dans le squelette en respectant strictement ses variables, ses `*Part`, son `\header`, son `\layout`/`\midi`.

Dans tous les cas : conserver `\version`, includes, `global`, `\header`, ordre des parties, `\layout`, `\midi`, `\tocItem...`. N'injecter que le contenu musical/paroles dans les variables existantes. Signaler les écarts si le schéma diffère.

## 5. Contrôles qualité

```bash
.prog/lilypond-2.26.0/bin/lilypond -o "<dossier>/<Nom>" "<dossier>/<Nom>.ly"

pdfinfo "<dossier>/<Nom>.pdf" | grep Pages
```

Vérifier :

- zéro erreur et zéro warning LilyPond ;
- chaque mesure = 4 temps (ou armure) ;
- clés correctes, notamment `\clef "treble_8"` pour le ténor si requis ;
- altérations cohérentes avec la source ;
- paroles complètes et alignées syllabe par syllabe ; mélismes `__` et traits d'union `--` corrects ;
- `.pdf` et `.midi` générés à côté du `.ly` ;
- `.pdf`/`.midi` régénérés après la dernière modification du `.ly` ;
- **En mode squelette** : `\header` inchangé, includes/version inchangés, `\layout`/`\midi` inchangés, ordre des parties inchangé, seules les variables musicales/paroles ont été modifiées.

## 6. Scripts

- `scripts/setup_venv.sh` — crée un venv avec pypdf/fontTools.
- `scripts/py.sh` — choisit le Python adéquat.
- `scripts/detect_pdf.py` — diagnostic rapide (vectoriel/scanné, polices, pages).
- `scripts/scanned_to_ly.sh` — pipeline Audiveris + `musicxml2ly`.
- `scripts/reference/parse_pdf.py` — extraction glyphes/segments (référence).
- `scripts/reference/transcribe.py` — portées, notes, ligatures, silences (référence).
- `scripts/reference/lyrics_json.py` — paroles + alignement (référence).
- `scripts/reference/write_ly.py` — génération du `.ly` (référence, **ne pas utiliser en mode squelette**).

Les scripts `reference/` contiennent des chemins et constantes du cas Palestrina ;
les adapter au PDF cible avant de les exécuter.
