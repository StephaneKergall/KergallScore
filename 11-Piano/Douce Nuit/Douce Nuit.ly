\version "2.26.0"
\include "settings.ily"
\include "composers.ily"

global = {
  \key c \major
  \time 3/4
}

scoreAFluteI = \fixed c'' {
  \global
  \bar ".|:"\repeat segno 2 { g4.(a8) g4 e2.\breathe g4.(a8) g4 e2.\breathe
  d'2 4 b2.\breathe c'2 4 g2.\breathe
  \bar ".|:" a2 4 c'4. b8 a4 g4. a8 g4 e2.\breathe \bar ":|."
  d'2 4 f'4. d'8 b4\breathe c'2.(e')\breathe
  c'4.(g8) e4 g4. f8 d4\breathe c2.}
  \bar ":|."
}

scoreAFluteII = \fixed c'' {
  \global
  \autoBeamOff
  \repeat unfold 2 {g8[c e a] g[c] e[g, c e g, c]\breathe}
  d[d, g, d] d,[g,] b,[d, g, b, d, g,]\breathe c[c e g] c[e] g[c e g g, c]\breathe
  a[c f a] c[f] c'[c f] b a[c] g[c e] a g[c] e[g, c e g, c]\breathe
  d[d, g, b,] d,[g,] f[a, b,] d b,[g,] \breathe c\coda([e, g, c e, g,] e2.)\breathe
  c'8[c e g] e[c] g[b, d] f d[b,]\breathe c2.
}

scoreAFluteIII = \fixed c'' {
  \global
  c2. c\breathe c c\breathe b, g,\breathe c c4. d8 e4\breathe
  f2 c4 f,2~8 f c2. c\breathe
  b, g,\breathe c c\breathe e2 g,4 2 4\breathe c 2.

}

verseOne = \lyricmode {
  Dou -- ce nuit_! Sain -- te nuit_!
  Dans les cieux, l'as -- tre luit.
  Le mys -- tère an -- non -- cé s'ac -- com -- plit_:
  C'est l'A -- mour in -- fi -- ni_!
  C'est l'A -- mour in -- fi -- ni_!
}

verseTwo = \lyricmode {
  \repeat unfold 12 \skip1
  cet En -- fant sur la paille en -- dor -- mi,
}

scoreAFluteIPart = \new Staff \with {
  instrumentName = "Flûte 1"
  midiInstrument = "flute"
} \scoreAFluteI



scoreAFluteIIPart = \new Staff \with {
  instrumentName = "Flûte 2"
  midiInstrument = "flute"
} \scoreAFluteII

scoreAFluteIIIPart = \new Staff \with {
  instrumentName = "Flûte 3"
  midiInstrument = "flute"
} \scoreAFluteIII

\score {
  \header {
    title = "DOUCE NUIT"
    instrument = \markup \center-column {
      "pour 3 flûtes"
      "ou flûte et clavier*"
      \vspace #1
    }
    composer = \gruber
    poet = "Paroles : Abbé Joseph Mohr (1792-1848)"
  }
  \new StaffGroup <<
    \scoreAFluteIPart
    \addlyrics \verseOne
    \addlyrics \verseTwo
    \scoreAFluteIIPart
    \scoreAFluteIIIPart
  >>
  \layout {\context{\Staff \RemoveAllEmptyStaves }}
  \midi { \tempo 4=85 }
}

\markup \column {
  "* L'instrument à clavier joue les parties des flûtes 2 et 3, la troisième partie à l'octave grave."
  \vspace #1
  \line {\coda : Finale pour l'instrument à clavier :}
}

\score {
  \new PianoStaff <<
    \time 3/4
    \new Staff {\fixed c'' \repeat segno 2 {
      \override Staff.TimeSignature.stencil = ##f
      c8([e, g, c e, g,] <e, g, c e>2.\arpeggio)
      c'8[c e g] e[c] g[b, d] f d[b,]
      <c e,>2.\bar "|."
    }}
    \new Staff {\fixed c'' {
      \override Staff.TimeSignature.stencil = ##f
      c2. c e2 g,4 2 4
      <c, g,>2.
    }}
  >>
}
