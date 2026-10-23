---
description: Transcrit un PDF de partition en fichier LilyPond et le compile.
agent: pdf-to-ly
---

Transcris le PDF de partition suivant en fichier LilyPond, en respectant
`AGENTS.md` et la skill `pdf-to-ly` :

$ARGUMENTS

Donne le chemin exact du PDF, et si possible la catégorie et le nom de la pièce.
Lance le diagnostic du PDF, choisis le pipeline vectoriel ou scanné, génère le
`.ly`, compile-le avec `.prog/lilypond-2.26.0/bin/lilypond`, vérifie la sortie,
puis fais un rapport. Ne commit rien.
