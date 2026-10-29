\version "2.26.0"
\include "settings.ily"
\include "composers.ily"

global = {
  \autoBeamOff
  \mergeDifferentlyHeadedOn
  \mergeDifferentlyDottedOn
  \key c \major
  \time 4/4
}

soprano = \relative c'' {
  \global
  a1 |
  gis |
  a |
  b |
  c |
  a |
  gis |
  c |
  b2 a ~ |
  2 g ~ |
  4 4 2 |
  1 |
  2 r |\break
  c2 4 4 |
  2 b |
  2 a |
  2 gis ~ |
  2 a ~ |
  4 4 2 |
  g f ~ |
  2 e ~ |
  2 r4 gis |\break
  4 4 a2 |
  b ( c ) |
  d g, |
  r4 c2 b4 |
  1 |
  a2. fis4 |
  2 g ~ |
  4 f! e d |
  e1 |
  1 |\bar "|."
}

verseSoprano = \lyricmode {
  A -- do -- rá -- mus te, Chrí -- ste,
  et be -- ne -- dí -- ci -- mus tí -- bi,
  quí -- a per sán -- ctam crú -- cem tú -- am
  re -- de -- mí -- sti mún -- dum,
  qui pás -- sus es pro nó -- bis,
  Dó -- mi -- ne,
  Dó -- mi -- ne,
  mi -- se -- ré -- re nó -- bis.
}

alto = \fixed c' {
  \global
  e1 |
  e |
  c2 ( d ) |
  b,1 |
  e |
  4 ( d8 [ c ] d2 ) |
  e1 |
  1 |
  d4 ( g ) e2 ~ |
  2 2 ~ |
  4 4 2 |
  4 ( d8 [ c ] d2 ) |
  e2 r |
  a2 4 4 |
  2 g |
  e e |
  1 |
  2 2 ~ |
  4 4 f2 |
  e a, ( |
  d4 a2. ) |
  gis2 r4 e4 |
  4 4 4 fis |
  g!1 ( |
  f!2 ) d |
  e d |
  g1 |
  e2 ( fis4 ) d |
  2 b, |
  d c4 a, |
  b,1 |
  cis |
}

verseAlto = \lyricmode {
  A -- do -- rá -- mus te, Chrí -- ste,
  et be -- ne -- dí -- ci -- mus tí -- bi,
  quí -- a per sán -- ctam crú -- cem tú -- am
  re -- de -- mí -- sti mún -- dum,
  qui pás -- sus es pro nó -- bis,
  Dó -- mi -- ne,
  Dó -- mi -- ne,
  mi -- se -- ré -- re nó -- bis.
}

tenor = \relative c' {
  \global
  c1 |
  b |
  a |
  gis |
  a |
  a |
  b |
  g |
  b2 c ~ |
  2 2 ~ |
  4 4 2 |
  2. ( b4 ) |
  c2 r |
  2 4 4 |
  d2 2 |
  2 c |
  2 b ~ |
  2 c ~ |
  4 4 d2 |
  4 ( cis ) d2 ( |
  a c! ) |
  b r4 4 |
  4 4 c2 |
  d ( e ) |
  a, ( b ) |
  g4 2 b4 |
  d1 |
  c2 a |
  2 g4 4 |
  a2 g4 a ( ~ |
  2 gis ) |
  a1 |
}

verseTenor = \lyricmode {
  A -- do -- rá -- mus te, Chrí -- ste,
  et be -- ne -- dí -- ci -- mus tí -- bi,
  quí -- a per sán -- ctam crú -- cem tú -- am
  re -- de -- mí -- sti mún -- dum,
  qui pás -- sus es pro nó -- bis,
  Dó -- mi -- ne,
  Dó -- mi -- ne,
  mi -- se -- ré -- re nó -- bis.
}

bass = \fixed c {
  \global
  a1 |
  e |
  f |
  e |
  a |
  f |
  e |
  c |
  g2 a ~ |
  2 e ~ |
  4 c4 2 |
  g1 |
  c2 r |
  f2 4 4 |
  fis2 g |
  gis a |
  e1 |
  2 a ~ |
  4 4 d2 |
  e d ( ~ |
  2 a ) |
  e r4 e |
  e4 4 a2 |
  g ( e ) |
  f g |
  c g |
  1 |
  a2 d |
  d e |
  d e4 f |
  e1 |
  a, |
}

verseBass = \lyricmode {
  A -- do -- rá -- mus te, Chrí -- ste,
  et be -- ne -- dí -- ci -- mus tí -- bi,
  quí -- a per sán -- ctam crú -- cem tú -- am
  re -- de -- mí -- sti mún -- dum,
  qui pás -- sus es pro nó -- bis,
  Dó -- mi -- ne,
  Dó -- mi -- ne,
  mi -- se -- ré -- re nó -- bis.
}


ChoeurPart = \new ChoirStaff \with {
	midiInstrument = "choir aahs"
} <<
  \new Staff \with {
    instrumentName = "S."
    \consists "Ambitus_engraver"
  } \new Voice = "soprano" \soprano
  \new Lyrics \with {
    \override VerticalAxisGroup.staff-affinity = #CENTER
  } \lyricsto "soprano" \verseSoprano

  \new Staff \with {
    instrumentName = "A."
    \consists "Ambitus_engraver"
  } \new Voice = "alto" \alto
  \new Lyrics \with {
    \override VerticalAxisGroup.staff-affinity = #CENTER
  } \lyricsto "alto" \verseAlto
  
  \new Staff \with {
    instrumentName = "T."
    \consists "Ambitus_engraver"
    \clef "treble_8"
  } \new Voice = "tenor" \tenor
  \new Lyrics \with {
    \override VerticalAxisGroup.staff-affinity = #CENTER
  } \lyricsto "tenor" \verseTenor

  \new Staff \with {
    instrumentName = "B."
    \consists "Ambitus_engraver"
    \clef bass
  } \new Voice = "bass" \bass
  \new Lyrics \with {
    \override VerticalAxisGroup.staff-affinity = #CENTER
  } \lyricsto "bass" \verseBass
>>

\tocItemComposer "Adoramus te" "Palestrina"
\score {
  \header {
    title = "ADORAMUS TE"
    composer = \palestrina
  }
  \ChoeurPart
  \layout {\context{\Staff \RemoveAllEmptyStaves }}
  \midi {\tempo 4=70 }
}
