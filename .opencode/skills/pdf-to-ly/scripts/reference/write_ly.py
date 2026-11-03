#!/usr/bin/env python3
"""Génération du `.ly` complet (mode from scratch, hors squelette `new.py`).

Importable : l'import n'exécute rien. Utiliser `render_ly()` avec un modèle de
`transcribe` et les paroles de `lyrics_json`, ou la CLI.

Variables d'environnement (CLI) :
  OUT_DIR, PDF_JSON, FONT_TTF   (via transcribe.model_from_env)
  LY_OUT        fichier .ly de sortie (défaut OUT_DIR/score.ly)
  TITLE, SUBTITLE, ARRANGER, COMPOSER, TOC_TITLE, TOC_COMPOSER
  KEY, TIME, TEMPO
  SYSTEMS_PER_PAGE  systèmes par page du PDF source (défaut 3)
"""
import os
from pathlib import Path

import jsonio
import transcribe as tr

DEFAULT_SYSTEMS_PER_PAGE = 3


def align_system(notes, words):
    # source-driven hyphen flags
    syls = []
    hyph = []
    last = None
    for x, t in words:
        if t in ("-", "--"):
            if last is not None:
                hyph[last] = True
        else:
            syls.append((x, t))
            hyph.append(False)
            last = len(syls) - 1
    assign = {}
    prev = -1
    for si, (sx, st) in enumerate(syls):
        best = None
        for i in range(prev + 1, len(notes)):
            if i in assign:
                continue
            d = abs(notes[i] - sx)
            if best is None or d < best[0]:
                best = (d, i)
        i = best[1] if best else len(notes) - 1
        assign[i] = (st, si)
        prev = i
    toks = []
    assigned_order = sorted(assign)
    for i in range(len(notes)):
        if i in assign:
            st, si = assign[i]
            toks.append(st)
            if hyph[si] and not st.endswith((",", ".", ";", ":")):
                # only put -- if next assigned note is immediately next (no melisma)
                j = assigned_order.index(i)
                if j + 1 < len(assigned_order) and assigned_order[j + 1] == i + 1:
                    toks.append("--")
                elif j + 1 == len(assigned_order):
                    # last syllable of system; add -- for cross-system continuation
                    toks.append("--")
        else:
            toks.append("__")
    return toks


def build_voice_lyrics(model, lyrics, systems_per_page=DEFAULT_SYSTEMS_PER_PAGE):
    spp = max(1, int(systems_per_page))
    systems = model.get("systems") or []
    voice_lyrics = {0: [], 1: [], 2: [], 3: []}
    for si, voice, measures in model["data"]:
        if 0 <= si < len(systems):
            page = systems[si]["page"]
            local = systems[si]["sysno"]
        else:  # repli pour un modèle sans métadonnées de systèmes
            page = 1 + si // spp
            local = si % spp
        notes = []
        for meas in measures:
            for tok in meas:
                p, d, br, x = tok
                if p not in ("r", "R") and x is not None:
                    notes.append(x)
        words = lyrics.get(f"{page},{local},{voice}", [])
        voice_lyrics[voice].extend(align_system(notes, words))
    return voice_lyrics


def fix_source_typos(voice_lyrics):
    """Corrige la coquille d'extraction `quod ... est` -> `quod ... et`."""
    for v in range(4):
        for i, t in enumerate(voice_lyrics[v]):
            if t == "est":
                j = i - 1
                while j >= 0 and voice_lyrics[v][j] == "--":
                    j -= 1
                if j >= 0 and voice_lyrics[v][j] == "quod":
                    voice_lyrics[v][i] = "et"


def render_ly(model, lyrics, *, title, subtitle="", arranger="",
              composer=r"\palestrina", toc_title=None, toc_composer="",
              tempo='"Adagio" 4=70', key=r"f \major", time="4/4",
              systems_per_page=DEFAULT_SYSTEMS_PER_PAGE, quiet=False):
    """Retourne le contenu LilyPond complet sous forme de chaîne."""
    toc_title = title if toc_title is None else toc_title
    subtitle_line = f'    subtitle = "{subtitle}"\n' if subtitle else ""
    arranger_line = f'    arranger = "{arranger}"\n' if arranger else ""
    voice_lyrics = build_voice_lyrics(model, lyrics, systems_per_page)
    fix_source_typos(voice_lyrics)
    voices = model["voices"]
    body = {v: tr.fmt_measures(voices[v]) for v in range(4)}
    lyrtext = {v: " ".join(voice_lyrics[v]) for v in range(4)}
    if not quiet:
        for v in range(4):
            print(f"--- v{v}", lyrtext[v])

    ly = r'''\version "2.26.0"
\include "settings.ily"
\include "composers.ily"

global = {
  \autoBeamOff
  \mergeDifferentlyHeadedOn
  \mergeDifferentlyDottedOn
  \key %KEY%
  \time %TIME%
  \tempo %TEMPO%
}

soprano = \fixed c {
  \global
%BODY0%
}

sopranoVerseOne = \lyricmode {
%LYR0%
}

alto = \fixed c {
  \global
%BODY1%
}

altoVerseOne = \lyricmode {
%LYR1%
}

tenor = \fixed c {
  \global
%BODY2%
}

tenorVerseOne = \lyricmode {
%LYR2%
}

bass = \fixed c {
  \global
%BODY3%
}

bassVerseOne = \lyricmode {
%LYR3%
}

ChoeurPart = \new ChoirStaff \with {
	midiInstrument = "choir aahs"
} <<
  \new Staff \with {
    instrumentName = "S."
    \consists "Ambitus_engraver"
  }  \new Voice = "soprano" {\soprano }
  \new Lyrics \with {
    \override VerticalAxisGroup.staff-affinity = #CENTER
  } \lyricsto "soprano" \sopranoVerseOne

  \new Staff \with {
    instrumentName = "A."
    \consists "Ambitus_engraver"
  }  \new Voice = "alto" {\alto }
  \new Lyrics \with {
    \override VerticalAxisGroup.staff-affinity = #CENTER
  } \lyricsto "alto" \altoVerseOne

  \new Staff \with {
    instrumentName = "T."
    \consists "Ambitus_engraver"
    \clef "treble_8"
  }  \new Voice = "tenor" {\tenor }
  \new Lyrics \with {
    \override VerticalAxisGroup.staff-affinity = #CENTER
  } \lyricsto "tenor" \tenorVerseOne

  \new Staff \with {
    instrumentName = "B."
    \consists "Ambitus_engraver"
    \clef bass
  }  \new Voice = "bass" {\bass }
  \new Lyrics \with {
    \override VerticalAxisGroup.staff-affinity = #CENTER
  } \lyricsto "bass" \bassVerseOne
>>

\tocItemComposer "%TOC_TITLE%" "%TOC_COMPOSER%"
\score {
  \header {
    title = "%TITLE%"
%SUBTITLE_LINE%%ARRANGER_LINE%    composer = %COMPOSER%
  }
  \ChoeurPart
  \layout {\context{\Staff \RemoveAllEmptyStaves }}
  \midi {}
}
'''
    for v in range(4):
        ly = ly.replace(f"%BODY{v}%", body[v]).replace(f"%LYR{v}%", lyrtext[v])
    ly = (
        ly.replace("%TITLE%", title)
        .replace("%SUBTITLE%", subtitle)
        .replace("%ARRANGER%", arranger)
        .replace("%COMPOSER%", composer)
        .replace("%TOC_TITLE%", toc_title)
        .replace("%TOC_COMPOSER%", toc_composer)
        .replace("%TEMPO%", tempo)
        .replace("%KEY%", key)
        .replace("%TIME%", time)
        .replace("%SUBTITLE_LINE%", subtitle_line)
        .replace("%ARRANGER_LINE%", arranger_line)
    )
    return ly


def write_ly(ly, ly_out, quiet=False):
    ly_out = Path(ly_out)
    ly_out.parent.mkdir(parents=True, exist_ok=True)
    ly_out.write_text(ly)
    if not quiet:
        print("written", ly_out, len(ly))
    return ly_out


def run(model, lyrics, ly_out, quiet=False, **meta):
    return write_ly(
        render_ly(model, lyrics, quiet=quiet, **meta), ly_out, quiet=quiet
    )


def main():
    work = Path(os.environ.get("OUT_DIR", "/tmp/pdftoly"))
    ly_out = Path(os.environ.get("LY_OUT", work / "score.ly"))
    lyrics = jsonio.load(work / "lyrics.json")
    title = os.environ.get("TITLE", "TITRE")
    run(
        tr.model_from_env(), lyrics, ly_out,
        title=title,
        subtitle=os.environ.get("SUBTITLE", ""),
        arranger=os.environ.get("ARRANGER", ""),
        composer=os.environ.get("COMPOSER", r"\palestrina"),
        toc_title=os.environ.get("TOC_TITLE", title),
        toc_composer=os.environ.get("TOC_COMPOSER", ""),
        tempo=os.environ.get("TEMPO", '"Adagio" 4=70'),
        key=os.environ.get("KEY", r"f \major"),
        time=os.environ.get("TIME", "4/4"),
        systems_per_page=int(os.environ.get(
            "SYSTEMS_PER_PAGE", DEFAULT_SYSTEMS_PER_PAGE
        )),
    )


if __name__ == "__main__":
    main()
