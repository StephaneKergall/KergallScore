# Accentuation des paroles latines

À ouvrir **seulement** si les paroles sont en latin (*Tantum ergo*, *Pange
lingua*, *Adoro te*…).

Ajouter l'accent aigu sur la **seule syllabe tonique** de chaque mot de **plus
d'une syllabe**, sauf si la voyelle tonique est une majuscule. Les monosyllabes
(`Et`, `Laus`, `Sit`, `Com`, `Sum`…) ne prennent **jamais** d'accent, et une
seule syllabe est accentuée par mot (jamais d'accent secondaire).

## Règle (prosodie latine ecclésiastique)

- accent sur la **pénultième** si elle est longue : voyelle longue par nature,
  syllabe fermée par une consonne, ou diphtongue (`æ`, `œ`, `au`, `eu`) ;
- sinon accent sur l'**antépénultième** ;
- les mots à enclitique `-que` sont accentués sur la syllabe qui précède
  l'enclitique (`Ge -- ni -- tó -- que`, `u -- tró -- que`, `quó -- que`).
- attention : il existe des exception. Vérifier en cas de doute sur le web.

## Exemples

| Latin | Paroles |
|---|---|
| Tantum | `Tán -- tum` |
| Veneremur | `Ve -- ne -- ré -- mur` |
| cernui | `cér -- nu -- i` |
| Præstet | `Prǽ -- stet` |

## Règle des majuscules

- les lettres majuscules ne prennent **jamais** d'accent : aucune majuscule
  accentuée (`Á`, `É`, `Í`, `Ó`, `Ú`, `Ý`, `Ǽ`…) dans les paroles ;
- une consonne majuscule en début de mot n'empêche pas l'accent sur la voyelle
  minuscule (`Tán -- tum`, `Ve -- né -- re -- mur`).

## Contraintes

- ne pas modifier la division en syllabes, les `--`, les `__`, l'ordre des mots,
  ni `\strophemode` / `\lyricsto`, les en-têtes ou la musique ;
- pour les minuscules, utiliser de préférence les caractères précomposés
  (`á é í ó ú ý`, `ǽ` U+01FD), sinon une base + U+0301 ;
- recompiler une fois et vérifier qu'aucun nouvel avertissement de paroles
  n'apparaît.
