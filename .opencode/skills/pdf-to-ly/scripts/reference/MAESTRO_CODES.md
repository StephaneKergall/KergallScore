# Codes Maestro et constantes de transcription

À ouvrir **seulement** si la police n'est pas Maestro, si les notes/silences sont
faux, ou s'il faut adapter les constantes de `reference/transcribe.py`.

## Codes de glyphes (PDF Maestro de référence)

| Code | Signification |
|---|---|
| 1 | clé de sol |
| 2 | clé de sol avec 8 en dessous (ténor) |
| 3 | clé de fa |
| 4 | bémol |
| 5 | C (mesure à 4/4) |
| 6 | tête de ronde |
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

Ces codes valent pour le PDF de référence. **Toujours vérifier** sur le PDF cible
avec `pdffonts`, `parsed.json` et un rendu image avant de conclure.

## Variables d'environnement / options du pipeline

| Constante | Env | Option `pipeline.sh` | Défaut |
|---|---|---|---|
| temps par mesure | `BEATS` | `--beats` | `4` |
| clés par voix | `CLEFS` | `--clefs` | `treble,treble,treble,bass` |
| ligne supérieure par voix | `TOPNAMES` | `--topnames` | `F5,F5,F5,A3` |
| octaves (ténor) | `TRANSPOSE` | `--transpose` | `0,0,-1,0` |
| ressource de police | `MUSIC_FONT` | `--music-font` | `R7` |
| têtes de note | `NOTE_CODES` | `--note-codes` | `6,9,11` |
| silences | `REST_CODES` | `--rest-codes` | `16` |
| altérations | `ACC_CODES` | `--acc-codes` | `4:flat,12:natural,13:sharp` |
| point | `DOT_CODE` | `--dot-code` | `15` |
| systèmes/page | `SYSTEMS_PER_PAGE` | `--systems-per-page` | `3` |

## Pièges rencontrés

- **Clé de ténor** : code 2 = `treble_8`. Calculer la hauteur écrite depuis la
  ligne supérieure (F5), puis descendre d'une octave pour la hauteur réelle ;
  écrire la hauteur réelle avec `\clef "treble_8"`.
- **Altérations** : le suffixe précède les marques d'octave (`cs'`, `ef'`, `bn'`).
- **Ligatures** : vérifier que la hampe est dans l'intervalle horizontal de la
  ligature, sinon les croches sont fausses.
- **Silences** : certains sont des chemins vectoriels, pas des glyphes. Les
  déduire par la somme des durées, dans le plus grand espace x (début/milieu/fin).
- **Paroles** : `pdftotext -bbox` perd les largeurs de Times-Roman (pas de
  `/Widths`). Utiliser les mots `<word>` et aligner chaque syllabe sur la note
  la plus proche. Les `--` et `__` viennent de la source.
- **Mesures** : fusionner les barres séparées de moins de 5 pt ; vérifier que
  chaque mesure totalise exactement l'armure.
- **PDF en XObjects** : si `parsed.json` ne contient aucun glyphe, le contenu
  est dans des Form XObjects. Ne pas inventer : adapter `parse_pdf.py` ou
  demander un PDF vectoriel plus simple.

## Parallélisme et cache

- `parse_pdf.py` parallélise les pages (`--jobs`, `PDFTOLY_JOBS`) et met en
  cache `<out>.meta.json` (taille + mtime du PDF).
- `pipeline.py` met tout le reste en cache sous
  `<out-dir>/cache/pdf-to-ly/<sha1-pdf>-<empreinte-scripts>/`.
- `PDFTOLY_CACHE` ou `--cache-dir` déplace le cache (ex. `/tmp`).
