\version "2.26.0"
\include "settings.ily"
\include "composers.ily"

global = {
  \autoBeamOff
  \mergeDifferentlyHeadedOn
  \mergeDifferentlyDottedOn
  \key bes \major
  \time 4/4
}

soprano = \relative c'' {
  \global
  bes1 |
  c |
  es ~ |
  2 d |
  c bes |
  c d |
  bes2. a4 | \break
  g1 ~ |
  2 c |
  c d |
  bes g |
  bes a |
  bes4. a8 g2 ~ |
  2 fis |
  g r4 g ~ |\break
  4 4 bes2 |
  g f ~ |
  2 bes |
  c es ~ |
  4 d c bes ~ |
  4 a8 [ g ] a4 4 |
  bes2 r |
  c1 |\break
  es |
  c |
  d |
  bes2 g |
  bes a |
  bes1 |
  a4 g4 2 ~ |
  4 fis8 [ e ] fis4 4 |
  g1\bar "|."
}

sopranoVerseOne = \lyricmode {
  O Crux a  _ _ -- ve,
  spes __ _ u -- ní -- ca, __
  hoc pas -- si -- ó _ _ -- nis
  tem _ _ -- pó -- re,
  aú -- ge pí -- is
  ju -- stí _ _ _ _ _ _ _ -- ti -- am
  re -- ís -- que __ _ dó _ -- na, __ _ _
  vé _ _ _ _ -- ni -- am.
}


alto = \fixed c' {
  \global
  f1 |
  1 |
  g2. f4 |
  es d8 [ c ] f2 ~ |
  2 d |
  g f |
  d4 es f4. es8 |
  d2. 4 |
  e2 f |
  f f |
  g1 ~ |
  2 f |
  2. es4 |
  d1 ~ |
  2 g |
  es2 f |
  bes,1 |
  bes2 g |
  as1 |
  g2. 4 |
  f2 2 ~ |
  2 es |
  f1 |
  g |
  f ~ |
  1 |
  r2 g ~ |
  2 fis |
  g1 |
  es2 2 |
  d2. 4 |
  1
}

altoVerseOne = \lyricmode {
  O Crux a _ _ _ _ -- ve,
  spes __ _ u _ _ _ _ -- ní -- ca, __
  hoc pas -- si -- ó -- nis
  tem -- pó -- re,
  aú -- ge pí -- is
  ju _ -- stí _ -- ti -- am
  re -- ís -- que dó -- na, __
  re -- ís -- que dó -- na,
  vé -- ni -- am.
}


tenor = \relative c' {
  \global
  d2. bes4 ~ |
  4 a8 [ g ] a2 |
  bes g ~ |
  4 a bes2 |
  a g ~ |
  2 a4 d ~ |
  4 c8 [ d ] d4 c ~ |
  4 b8 [ a ] b4 4 |
  c2 a |
  a bes4 d ~ |
  4 c8 [ bes ] c2 |
  d1 |
  2. c4 |
  bes a8 [ g ] a4 4 |
  g2 bes |
  c2 d |
  es2. d8 [ c ] |
  d [ es f d ] es2 ~ |
  2c |
  es2. d4 |
  c2 2 |
  bes2 2 ~ |
  2 a |
  bes es, |
  f1
  r2 d' ~ |
  2 c |
  d1 |
  bes4 g8 [ a ] bes [ c ] d4 |
  c2. bes4 a2. 4 |
  g1
}

tenorVerseOne = \lyricmode {
  O Crux __ _ _ a _ _ _ _ -- ve, __
  spes u _ _ _ _ _ -- ní -- ca, __
  hoc pas -- si -- ó _ _ -- nis
  tem _ _ _ _ -- pó -- re,
  aú -- ge pí -- is __ _ _ _
  ju -- stí _ _ -- ti -- am
  re -- ís -- que dó -- na,
  re -- ís -- que dó _ _ -- na,
  vé _ _ -- ni -- am.
}


bass = \fixed c {
  \global
  bes,1 |
  f |
  es2. d4 |
  c2 bes, |
  f g |
  es d |
  g f |
  g1 |
  r2 f |
  f bes, |
  es1 |
  d |
  bes,2. c4 |
  d1 |
  r2 es |
  c bes, |
  es8 [ f g a ] bes2 ~ |
  2 es |
  as2. g8 [ f ] |
  es2 2 |
  f1 |
  g |
  f |
  es2 bes ~ |
  2 a |
  bes1 |
  g4. f8 es2 |
  d1 |
  g |
  c |
  d2. 4 |
  g1
}

bassVerseOne = \lyricmode {
  O Crux a _ _ -- ve, a -- ve,
  spes __ _ u -- ní -- ca, __
  hoc pas -- si -- ó -- nis
  tem -- pó -- re,
  aú -- ge pí -- is __ _
  ju -- stí _ _ -- ti -- am
  re -- ís -- que,
  re -- ís -- que dó _ _ -- na, __ _
  vé _ -- ni -- am.
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

\tocItemComposer "O Crux ave" "Palestrina"
\score {
  \header {
    title = "O CRUX AVE"
    composer = \palestrina
  }
  \ChoeurPart
  \layout {\context{\Staff \RemoveAllEmptyStaves }}
  \midi {\tempo 4=70 }
}
