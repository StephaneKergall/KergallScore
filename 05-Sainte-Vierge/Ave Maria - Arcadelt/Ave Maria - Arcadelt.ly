\version "2.26.0"
\include "settings.ily"
\include "composers.ily"

global = {
  \autoBeamOff
  \mergeDifferentlyHeadedOn
  \mergeDifferentlyDottedOn
  \key f \major
  \time 4/4
  \partial 2.
}

soprano = \fixed c' {
  \global
  a4 g4 a4 |
  f4 g4 a2 |
  a4 c'4 c'2 |
  bes4 a4 g2 |
  r4 a4 g4 a4 |
  f4 g4 a2 |
  g4 a4 bes8[ a8 ] g [ f ] |
  g2 f2 |
  f4 c'4 c'2 |
  d'4 e'4 f'2 |
  e'4 c'4 c'4 d'4 |
  e'4 f'4 f'8[ e' ] d' [ c' ] |
  d'4. d'8 c'4 f4 |
  c'4 c'4 d'4 e'4 |
  f'2 e'4 c'4 |
  c'4 d'4 e'4 f'4 ~ |
  8 [ e' ] d' [ c' ] d'2 |
  c'2 r2 |
  r4 f'4 f'4 e'4 |
  d'2 cis'2 |
  c'!2 d'2 |
  d'2 c'4 bes8[ a8] |
  bes2 a2 |
  r4 a4 c'4 d'4 |
  c'2 bes2 |
  a2 g4 a4 |
  bes8[ a ] g [ f ] g2 |
  f2 f4 a4 |
  c'4 d'4 c'4 bes4 |
  a2 g4 a4 |
  bes8 [ a ] g [ f ] g2 |
  f1 | f1 f \bar "|."
}

alto = \fixed c' {
  \global
  f4 e4 c4 |
  d4 e4 f2 |
  f4 f4 f2 |
  f2 e2 |
  r4 f4 e4 c4 |
  d4 e4 f2 |
  e4 f4 f4 d4 |
  e2 f2 |
  f4 f4 f2 |
  f4 a4 a2 |
  a4 e4 e4 g4 |
  g4 a4 g4 e4 |
  g4. g8 e4 f4 |
  f4 f4 f4 a4 |
  a2 a4 e4 |
  e4 g4 g4 a4 ( |
  g4 ) e4 g2 |
  e2 r2 |
  r4 a4 a4 a4 |
  f2 e2 |
  e2 f2 |
  f2 f4 f4 |
  f2 f2 |
  r4 f4 f4 f4 |
  f2 d2 |
  f2 c4 4 |
  d4 a, c2 |
  2 d4 f |
  e4 f4 f4 d |
  f2 c4 4 |
  d a, c2 |
  1 | d c
}

tenor = \fixed c' {
  \global
  c4 c4 a,4 |
  a,4 c4 c2 |
  c4 a,4 a,2 |
  d4 c4 c2 |
  r4 c4 c4 a,4 |
  a,4 c4 c2 |
  c2 d4 a,4 |
  c2 a,2 |
  a,4 a,4 a,2 |
  a,4 cis4 d2 |
  c!4 c4 c4 b,!4 |
  c4 c4 c4 c4 |
  b,!4 b,4 c4 a,4 |
  a,4 a,4 a,4 cis4 | 
  d2 c!4 c4 |
  c4 b,!4 c4 c4 |
  c2 c4 b,!4 |
  c2 r2 |
  r4 c4 c4 c4 |
  a,2 a,2 |
  g,2 bes,2 |
  2 a,4 c4 |
  d2 c2 |
  r4 c4 a,4 bes, |
  a,2 g,2 |
  a,2 c4 f,4 |
  f,4 f,4 f,4 e,4 |
  f,2 a,4 f,4 |
  g,4 bes, a,4 g,4 |
  a,2 c4 f,4 |
  f,4 f,4 f,4 e,4 |
  f,1 | bes, | a,1
}

bass = \fixed c' {
  \global
  f,4 c,4 f,4 |
  d,4 c,4 f,2 |
  f,4 f,4 f,2 |
  bes,,4 f,4 c,2 |
  r4 f,4 c,4 f,4 |
  d,4 c,4 f,2 |
  c,4 f,4 bes,, d, |
  c,2 f,, |
  f,4 f,4 f,2 |
  d,4 a,,4 d,2 |
  a,4 a,4 a,4 g,4 |
  c,4 f,4 c,4 a,4 |
  g,4 g,,4 c,4 f,4 |
  f,4 f,4 d,4 a,,4 |
  d,2 a,4 a,4 |
  a,4 g,4 c,4 f,4 |
  c,4 ( a, ) g,2 |
  c,2 r2 |
  r4 f,4 f,4 a,4 |
  d,2 a,,2 |
  c,2 bes,, |
  2 f,4 f,4 |
  bes,,2 f, |
  r4 f,4 f,4 bes,, |
  f,2 g,2 |
  d,2 e,4 f,4 |
  bes,,4 d,4 c,2 |
  f,,2 f,4 d,4 |
  c,4 bes,, f, g, |
  d,2 e,4 f,4 |
  bes,, d, c,2 |
  f,,1 | bes,, | f,,
}

VerseOne = \lyricmode {
  A -- ve Ma -- rí -- _ a
  grá -- ti -- a plé -- _ na,
  Dó -- mi -- nus té -- _ cum,
  A -- _ ve Ma -- rí -- a_;
  be -- ne -- dí -- cta _ tu,
  be -- ne -- dí -- cta tu
  in mu -- li -- é -- ri -- bus,
  et be -- ne -- dí -- _ ctus
  frú -- ctus vén -- _ tris
  tú -- i Jé -- sus.
  Sán -- cta Ma -- rí -- a,
  ó -- ra, ó -- ra pro nó -- bis,
  Sán -- cta Ma -- rí -- a,
  ó -- ra, ó -- ra pro nó -- bis,
  Sán _ -- cta Ma -- rí -- a,
  ó -- ra, ó -- ra pro nó -- bis.
  A -- men.
}

ChoeurPart = \new ChoirStaff \with {
	midiInstrument = "choir aahs"
} <<
  \new Staff \with {
    \consists Merge_rests_engraver
  } <<
    \new Voice = "soprano" {\voiceOne \soprano }
    \new Voice = "alto" {\voiceTwo \alto }
  >>
  \new Lyrics \with {
    \override VerticalAxisGroup.staff-affinity = #CENTER
  } \lyricsto "soprano" \VerseOne

  \new Staff \with {
    \consists Merge_rests_engraver
    \clef bass
  } <<
    \new Voice = "tenor" {\voiceOne \tenor }
    \new Voice = "bass" {\voiceTwo \bass }
  >>
>>

\tocItemComposer "Ave Maria" "Arcadelt"
\score {
  \header {
    title = "AVE MARIA"
    composer = \arcadelt
  }
  \ChoeurPart
  \layout {\context{\Staff \RemoveAllEmptyStaves }}
  \midi {\tempo 4=100 }
}
