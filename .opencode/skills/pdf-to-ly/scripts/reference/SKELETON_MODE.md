# Mode squelette `new.py` (injection)

À ouvrir **seulement** si un `.ly` pré-généré par `.prog/new.py` est fourni ou
détecté à côté du PDF. Le fast path `pipeline.sh` ne écrase **jamais** un `.ly`
existant sans `--force` : il produit les intermédiaires puis l'agent injecte.

## 1. Détection du squelette

Accepter un squelette si :

- chemin explicite (`--skeleton` / argument) ;
- `.ly` dans le même dossier que le PDF, nom cohérent ;
- contenu typique de `new.py` : `\version "2.26.0"`, `\include "settings.ily"`,
  `\include "composers.ily"`, `global = { ... }`, blocs `*Part`
  (`ChoeurPart`, `SoloPart`, `FlûtePart`, `ClavierPart`), `\score` avec
  `\layout { \context { \Staff \RemoveAllEmptyStaves } }` et `\midi`.

Si un squelette est détecté, **ce mode est prioritaire**. Le signaler.

## 2. Signatures à conserver intégralement

- `\version "2.26.0"` et les deux `\include` ;
- bloc `global` entier (`\key`, `\time`, `\partial`, `\tempo`, `\autoBeamOff`,
  `\mergeDifferentlyHeadedOn`, `\mergeDifferentlyDottedOn`) ;
- bloc `\header` entier (titre, sous-titres, compositeur/parolier/arrangeur,
  dédicace, copyright, tagline) ;
- variables musicales avec leur mode exact (`\fixed c'` / `\fixed c` /
  `\relative ...`) et leur octave ;
- variables de paroles avec leur type exact (`\lyricmode`,
  `\strophemode N ##f/##t \lyricmode`) ;
- blocs `*Part` avec `\with {}`, `instrumentName`, `midiInstrument`, graveurs,
  clefs, `\voiceOne`/`\voiceTwo`, `<< >>`, `\new Staff`, `\new Voice`,
  `\new Lyrics`, `\lyricsto` ;
- bloc `\score` entier, `\layout`, `\midi`, `\tocItem...`.

## 3. Règles d'injection

**Principe : injection uniquement.**

Interdictions : renommer des variables, changer l'ordre des parties ou du
`\score`, réécrire `\header`, modifier `\layout`/`\midi`, changer `\version` ou
les includes, ajouter/supprimer des `*Part`, restructurer `<< >>`, convertir
`\fixed` ↔ `\relative`, supprimer/déplacer `\global`.

Autorisations : remplir **seulement** le contenu `{ }` des variables musicales
et de paroles existantes. Respecter `\clef "treble_8"`, `\voiceOne`/`\voiceTwo`,
`\lyricsto`, `\strophemode`. Utiliser `--` et `__` comme dans la source.
Préserver indentation, espaces et commentaires (édition chirurgicale).

Si le squelette impose un schéma différent du PDF (nombre de voix, solo, flûte,
piano…), **signaler l'écart** et demander confirmation avant d'injecter.

## 4. Workflow recommandé avec le fast path

```bash
# 1. produire les intermédiaires sans toucher au .ly existant
scripts/pipeline.sh "<pdf>" --out-dir "<dossier>" --stop-after lyrics \
  --key '...' --time ... --beats ...

# 2. lire le squelette (obligatoire avant modification)
# 3. mapper les voix et injecter uniquement dans les variables existantes
# 4. compiler une seule fois
.prog/lilypond-2.26.0/bin/lilypond -dno-point-and-click \
  -o "<dossier>/<Nom>" "<dossier>/<Nom>.ly"
```

Le pipeline peut être relancé avec `--stop-after transcribe` ou `--stop-after
lyrics` : le cache évite de tout recalculer.

## 5. Checklist avant compilation

- [ ] squelette identifié comme généré par `new.py`
- [ ] `\version`, includes, `global`, `\header` lus et non modifiés
- [ ] variables musicales et paroles listées avec leur mode/type
- [ ] structure des `*Part` et mapping `\lyricsto` compris
- [ ] écarts PDF ↔ squelette signalés
- [ ] injection limitée au contenu `{ }`
- [ ] `\header`, `\layout`, `\midi`, ordre des parties, includes inchangés
- [ ] une seule compilation finale, zéro warning/erreur

## 6. Pipeline scanné + squelette

`musicxml2ly` produit un `.ly` brut : **ne pas remplacer le squelette**.
Convertir/importer le MusicXML vers des données mappables, puis injecter
uniquement dans les variables existantes. Conserver `\version`, includes,
`global`, `\header`, ordre des parties, `\layout`, `\midi`, `\tocItem...`.
Signaler les écarts de schéma.
