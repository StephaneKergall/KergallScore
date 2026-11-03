---
description: Transcrit un PDF de partition en fichier LilyPond et le compile.
agent: pdf-to-ly
---

Transcris le PDF de partition suivant en fichier LilyPond, en suivant le fast
path de la skill `pdf-to-ly` :

$ARGUMENTS

Donne le chemin exact du PDF, et si possible la catégorie et le nom de la pièce.
Utilise une seule fois `.opencode/skills/pdf-to-ly/scripts/pipeline.sh` (cache,
diagnostic, transcription, paroles, `.ly`, une compilation finale). Ne relance
pas les étapes si le cache existe. Pour un PDF scanné, utilise
`scanned_to_ly.sh` (Audiveris). Compile avec
`.prog/lilypond-2.26.0/bin/lilypond`, vérifie warnings/erreurs et le PDF, puis
fais un rapport. Ne commit rien.
