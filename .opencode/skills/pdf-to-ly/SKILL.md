---
name: pdf-to-ly
description: Use when transcribing a sheet-music PDF (vector or scanned) into a LilyPond .ly file in the KergallScore repository, including OMR/Audiveris, Maestro glyph extraction, lyrics alignment, and LilyPond compilation. Triggers on "PDF partition", "transcrire", "OMR", "générer le .ly", "pdf-to-ly".
---

# PDF partition → LilyPond (fast path)

## Règles absolues

- Ne commit jamais, ne push jamais, sauf demande explicite.
- LilyPond local uniquement : `.prog/lilypond-2.26.0/bin/lilypond`.
- `\version "2.26.0"`, `\include "settings.ily"`, `\include "composers.ily"`.
- Ne jamais inventer de notes, paroles, mesures ou nuances absentes du PDF.
- Ne pas régénérer un `.ly` existant sans l'avoir lu (le pipeline refuse sans `--force`).
- Une seule compilation finale complète ; pas de relectures inutiles.

## 0. Contexte minimal (ne pas relire tout `AGENTS.md`)

Utile seulement : gotcha 1 (LilyPond local), 2 (copie `.utils/`), 3 (2.26.0),
5 (noms accentués), 7 (`composers.ily`). Sortie attendue :

```
<NN-Catégorie>/<Nom>/<Nom>.ly  (+ .pdf, .midi)
```

Dossier == nom du fichier. Si le PDF ne donne pas clairement catégorie/nom,
demander. Si le PDF contient plusieurs pièces, demander laquelle.

## 1. Fast path : une commande

```bash
.opencode/skills/pdf-to-ly/scripts/pipeline.sh "<pdf>" \
  --out-dir "<NN-Catégorie>/<Nom>" \
  --title "<Titre>" --composer '\palestrina' \
  --key 'f \major' --time '4/4' --tempo '"Adagio" 4=70'
```

Le pipeline enchaîne **une seule fois** : diagnostic → parse → transcription →
paroles → `.ly` → compilation. Il :

- met en cache chaque étape sous `<out-dir>/cache/pdf-to-ly/<sha1-pdf>-<scripts>/`
  (ou `--cache-dir` / `PDFTOLY_CACHE`) et saute ce qui n'a pas changé ;
- ne charge `parsed.json` qu'une fois et ne recompile qu'à la fin ;
- utilise `-dno-point-and-click` par défaut (`LILYPOND_FLAGS` pour changer) ;
- ne remplace pas un `.ly` existant sans `--force` ;
- reste concis par défaut (`-v` pour le détail, `-q` pour tout taire) et retente
  une compilation en échec au lieu de la considérer comme à jour.

Options utiles : `--stop-after {detect,parse,transcribe,lyrics,write,compile}`,
`--validate` (compilation rapide `-dno-print-pages`, pas de PDF), `--font`,
`--systems-per-page`, `--beats`, `--clefs`, `--topnames`, `--transpose`,
`--music-font`, `--note-codes`, `--rest-codes`, `--acc-codes`, `--dot-code`,
`--jobs`, `-q`, `-v`, `--json`.

Dépendances manquantes (`pypdf`, `fontTools`) : une fois
`.opencode/skills/pdf-to-ly/scripts/setup_venv.sh`, puis relancer.

## 2. Choisir le pipeline

Le diagnostic du pipeline classe le PDF :

| Diagnostic | Action |
|---|---|
| `VECTOR` | continuer le fast path |
| `SCANNED` | `scripts/scanned_to_ly.sh "<pdf>" "<dossier>" "<Nom>"` (Audiveris requis) |
| `SCANNED` mais polices/texte présents | relancer avec `--assume-vector` |
| PDF mixte | traiter page par page, signaler les pages image |

Sans Audiveris : ne pas deviner, expliquer l'installation (Java) ou demander un
PDF vectoriel / MusicXML / MIDI.

## 3. Références à ouvrir seulement si nécessaire

- `scripts/reference/MAESTRO_CODES.md` — **seulement** si police non-Maestro,
  notes/silences faux, ou adaptation des constantes (`BEATS`, `CLEFS`, codes…).
- `scripts/reference/LATIN_STRESS.md` — **seulement** pour des paroles latines.
- `scripts/reference/SKELETON_MODE.md` — **seulement** si un squelette
  `.prog/new.py` existe : injection uniquement, jamais de régénération.
- `scripts/README.md` — variables d'environnement, cache, scripts un par un.

## 4. Contrôles qualité (après le pipeline)

- zéro warning et zéro erreur LilyPond (le pipeline les affiche ; code retour 1
  même si LilyPond renvoie 0 sur une erreur de programmation) ;
- chaque mesure totalise l'armure ; `\clef "treble_8"` pour le ténor ;
- altérations cohérentes ; paroles alignées, `--` et `__` exacts ;
- `.pdf` et `.midi` présents et plus récents que le `.ly` ;
- contrôle visuel du premier et du dernier système ;
- si `.utils/` a été modifié : recopier dans l'installation LilyPond (gotcha 2).

Si une correction manuelle est nécessaire, ne recompiler **qu'une fois** à la fin :

```bash
.prog/lilypond-2.26.0/bin/lilypond -dno-point-and-click \
  -o "<dossier>/<Nom>" "<dossier>/<Nom>.ly"
```

## 5. Si le pipeline échoue

- **0 glyphe extrait** : contenu en XObjects ou PDF scanné → ne pas inventer ;
  adapter `parse_pdf.py` ou demander un PDF vectoriel.
- **Aucune police musicale** : `--font <police.ttf|otf>` (voir `fonts.json`).
- **Diagnostic scanné** : `scanned_to_ly.sh`, puis adapter le `.ly` aux
  conventions du dépôt.
- **Squelette `new.py`** : `--stop-after lyrics`, puis
  `scripts/reference/SKELETON_MODE.md`.

## 6. Scripts

| Script | Rôle |
|---|---|
| `scripts/pipeline.sh` / `pipeline.py` | fast path complet, cache, une compilation |
| `scripts/detect_pdf.py` | diagnostic rapide (`--fast`, `--json`, `--bbox`) |
| `scripts/scanned_to_ly.sh` | Audiveris + `musicxml2ly` |
| `scripts/reference/parse_pdf.py` | glyphes/segments, multiprocessing, cache |
| `scripts/reference/transcribe.py` | portées, notes, ligatures, silences |
| `scripts/reference/lyrics_json.py` | paroles + alignement |
| `scripts/reference/write_ly.py` | `.ly` complet (hors squelette) |
| `scripts/py.sh` / `setup_venv.sh` | choix du Python / venv idempotent |
