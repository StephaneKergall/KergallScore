# AGENTS.md — KergallScore

A LilyPond sheet-music repository (French choral / Gregorian / profane scores) plus a small
Python toolbox in `.prog/`. **There is no build system, no test suite, no linter and no CI.**
The only meaningful verification is *compiling the score with LilyPond* and checking the output.

## Layout

- `NN-Catégorie/` — one folder per category: `01-Général`, `02-Carême-Pâques`, `03-Saint-Sacrement`,
  `04-Noël`, `05-Sainte-Vierge`, `08-Assemblages`, `09-Grégorien`, `11-Piano`, `12-Profane`,
  `13-Autres`, `99-Commandes`.
- One piece = one folder `<category>/<piece name>/` holding `<piece name>.ly` plus the generated
  `<piece name>.pdf` and `<piece name>.midi`. Folder name == file name (the GUI enforces this).
- Category prefixes are semantic:
  - `08-Assemblages` — one `.ly` that `\include`s two existing pieces to print them on one page.
  - `09-Grégorien` — Gregorian sources: `.gabc` + `.pdf`, **no `.ly`**; LilyPond 2.26 cannot read
    `.gabc` (it parses it as LilyPond and fails), so these come from an external gabc tool.
  - `99-Commandes` — ordered booklets whose `.ly` `\include`s pieces from other categories.
  - `.prog/new.py` refuses to propose `08`, `09`, `99` (`EXCLUDED_CATEGORY_PREFIXES`).
- `cache/` inside a piece folder = intermediate material (scan PNGs, extracted `notes.ily`, `.gabc`).
- `.utils/` — shared LilyPond includes used by every score: `settings.ily` (macros, paper setup,
  KergallScore signature) and `composers.ily` (composer/poet/arranger identifiers).
- `.prog/` — Python toolbox. `.prog/lilypond-2.26.0/` is a local LilyPond install and is gitignored.

## Commands

```bash
# compile one piece -> <name>.pdf + <name>.midi next to the .ly
.prog/lilypond-2.26.0/bin/lilypond -o "12-Profane/L_ours" "12-Profane/L_ours/L_ours.ly"

# compile every .ly in the repo (slow)
python3 .prog/full_compil.py

# REQUIRED after editing .utils/ — see gotcha 2
cp .utils/* .prog/lilypond-2.26.0/share/lilypond/2.26.0/ly/

# GUI: generate a new score skeleton, then opens it in Frescobaldi
python3 .prog/new.py                # customtkinter version (what the VS Code task runs)
python3 ".prog/new copy.py"         # in-progress wxPython rewrite — newer, but not the wired-up one

# play the generated MIDI
timidity "12-Profane/L_ours/L_ours.midi"

# pull + add + commit + push everything (author's script, generic messages)
python3 .prog/save.py
```

`.vscode/tasks.json` holds the intended entry points: `Lilypond`, `Save`, `New`, `Install`,
`Frescobaldi`, `Timidity++`, `Synchroniser .utils/`.

## Gotchas

1. **LilyPond is not on `PATH`.** Use `.prog/lilypond-2.26.0/bin/lilypond` (`installer.py` adds an
   `alias lilypond=...` to `~/.bashrc`). The install is gitignored, so a fresh clone has none:
   run `sudo python3 .prog/installer.py` (network + sudo) or install LilyPond 2.26.0 by hand.
2. **`\include "settings.ily"` resolves only through the local install.** `.utils/*.ily` must be
   copied into `.prog/lilypond-2.26.0/share/lilypond/2.26.0/ly/`; without the copy, compilation
   dies with a fatal error *even though `settings.ily` exists in the repo*. Re-copy after every
   edit to `.utils/` (task `Synchroniser .utils/`; `new.py`'s "new composer" popup does it too).
3. **LilyPond is pinned to 2.26.0** (`\version "2.26.0"` in every file). The installer removes the
   distro package (2.24.4) on purpose; don't downgrade.
4. **`.pdf` and `.midi` are committed artifacts** — regenerate and commit them with the `.ly`
   change (see the "Génération de …" commits). Only `08-Assemblages` and `99-Commandes` have their
   `.midi` gitignored. PDFs are *not* byte-reproducible (LilyPond embeds a creation date/ID), so a
   recompile always shows a binary diff even with unchanged music.
5. **Names are French, with accents, spaces and apostrophes** (`Règne à jamais`, `L'ours`,
   `Ô Croix dressée sur le monde`). Always quote paths; `Ô`/`É` are not `O`/`E`.
6. The repo sits on a mounted Windows filesystem (`/media/stephane/Windows/…`): `.fuse_hidden*`
   junk appears and is gitignored, and every file is mode 777.
7. **Composer names live in `.utils/composers.ily`** as `identifier = "Full Name (dates)"`, used in
   scores as `\bach`, `\laprise`, `\kergall`… The GUI writes those `\identifier` references, so a new
   name needs an entry in `composers.ily` + the copy in gotcha 2.
8. **Reuse the shared macros** in `.utils/settings.ily` instead of hand-rolling equivalents:
   `\strophemode #n ##f \lyricmode {…}` (numbered verse; `##t` = italic stanza),
   `\markChanson "Refrain"`, `\tocItemComposer "Titre" "Compositeur"`, `\couplets-markup`,
   plus `bf`, `rit`, `rinf`, `oct`.
9. **New `.ly` files start with** `\version "2.26.0"`, `\include "settings.ily"`,
   `\include "composers.ily"` — these provide the paper setup, the tagline/signature and the
   composer macros.
10. The tagline in `settings.ily` is the KergallScore "signature" (`.doc/DEVELOPERS.md`): remove it
    when reworking someone else's score.

## Conventions inside a score

- Voices are `soprano`, `alto`, `tenor`, `bass`; mostly absolute pitch (`\fixed c'` / `\fixed c`),
  newer pieces use `\relative`.
- A `global = { \key … \time … \partial … \autoBeamOff }` block is included at the start of each voice.
- Each score ends with `\layout {\context{\Staff \RemoveAllEmptyStaves }}` and `\midi {\tempo 4.=NN }`.
- Lyrics attach to the soprano: one `\new Lyrics` per verse, `\lyricsto "soprano" \verseOne`.
- Optional header fields (`poet`, `arranger`, …) are rendered as `\markup {"Paroles :" \laprise}`.

## Git

- Branch `master`, remote `git@github.com:stefkergall79/KergallScore.git`; `pull.rebase=false`.
- Commit messages are mixed French/English; the author commits via `.prog/save.py`
  ("Modifications" / "Sauvegarde") or by hand.
