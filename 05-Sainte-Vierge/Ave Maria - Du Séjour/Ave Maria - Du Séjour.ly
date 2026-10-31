\version "2.26.0"
\include "settings.ily"
\include "composers.ily"

global = {
  \autoBeamOff
  \mergeDifferentlyHeadedOn
  \mergeDifferentlyDottedOn
  \key bes \major
  \time 3/4
  \tempo 4=80
}

soprano = \relative c' {
  \global
  \repeat volta 2 {
    \bar ".|:" f4 4 e8 [ f ] |
    c'4 f,2 |
    bes8 [ g ] f4. es8 |
    f4 2 |
    bes4 ( a8 ) [ g ] a [ bes ] |
    d4 ~ 4 ( bes ) |
    g f8 [ es ] f [ g ] |
    bes2. |
    8 [ g ] f4. g8 |
    f4 ( es d ) |
    f2. |
    2 e 8 f |
    c'4 f,2 |
    fis g8 a |
    d4 bes2 |
    c4 b8 [ c ] d [ c ] |
    a4 f8 [ g ] a [ c ] |
    es4 ( d bes ) |
    g2. |
    d'8 [ c b c bes g ] |
    bes4 ( es, ) d8 [ es ] |
    f4 ~ 4 4 |
    2. |
  }
  4 4 e8 [ f ] |
  c'4 f,2 |
  bes8 [ g ] f4. es8 |
  f4 2 |
  g4 a4. bes8 |
  d4 f,2 |
  8 [ c' ] bes4 a |
  bes4 2 |
  g8 [ a ] bes4. es8 |
  8 [ d ] f,2 |
  8 [ c' ] bes4 a |
  bes2. |
  2.\fermata |\bar"|."
}


alto = \fixed c' {
  \global
  d4 4 4 |
  f4 2 |
  4 es4. c8 |
  d4 2 |
  g4 ~ 4 8 [ 8 ] |
  a4 ~ 2 |
  g4 es4 4 |
  d2. |
  es4 4. 8 |
  d4 ( c bes, ) |
  c2. |
  d2 8 8 |
  f4 2 |
  d es8 fis |
  4 g2 |
  4 4 8 [ 8 ] |
  f4 8 [ 8 ] 4 |
  4 ( 4 4 ) |
  es2. |
  g4 ~ 8 [ 8 8 es ] |
  g4 ( bes, ) 8 [ 8 ] |
  c4 ~ 4 4 |
  2. |
  d4 4 4 |
  f c2 |
  f4 es4. bes,8 |
  d4 2 |
  es4 f4. g8 |
  f4 d2 |
  c4 f f |
  d d f ~ |
  4 g4. 8 |
  f4 d2 |
  c4 4 4 |
  es2. |
  d |
}


tenor = \relative c' {
  \global
  bes4 4 4 |
  c4 2 |
  bes4 4. 8 |
  4 2 |
  d4 ( c8 [ bes ] ) c [ d ] |
  4 ~ 2 |
  es4 bes c |
  d2. |
  bes4 c4. 8 |
  f,4 ( g ) bes |
  a2. |
  bes2 8 8 |
  c4 2 |
  a4 d4 8 c |
  4 d2 |
  es4 4 8 [ 8 ] |
  c4 a8 [ bes ] c4 |
  4 ( bes d ) |
  bes2. |
  b8 [ c d es8 8 8 ] |
  4 ( g, ) 8 [ bes ] |
  4 ~ 4 g |
  a2. |
  bes4 4 4 |
  c4 2 |
  bes4 a4. bes8 |
  4 2 |
  4 es4. bes8 |
  4 2 |
  4 c2 |
  r4 d2 ~ |
  4 es4. bes8 |
  4 2 |
  a4 f f |
  g2. |
  f\fermata |
}


bass = \fixed c {
  \global
  bes4 4 4 |
  a4 2 |
  g4 4. 8 |
  bes4 2 |
  g4 ( 4 ) 8 [ 8 ] |
  f4 ~ 2 |
  es4 4 4 |
  bes,2. |
  g,4 a,4. 8 |
  bes,4 ( es2 ) |
  f2. |
  bes,2 8 8 |
  a,4 2 |
  d2 8 8 |
  g4 2 |
  c4 4 8 [ 8 ] |
  f4 8 [ 8 ] 4 |
  bes,4 ( 4 4 ) |
  es2. |
  es4 ~ 8 [ 8 d d ] |
  c4 ~ 4 8 [ 8 ] |
  f4 ~ 4 4 |
  f,2. |
  bes4 4 4 |
  a4 2 |
  g4 4. 8 |
  bes4 2 |
  es4 4. 8 |
  bes,4 2 |
  f4 4 d |
  g4 2 |
  es4 4. 8 |
  bes,4 2 |
  f,4 4 4 |
  bes,2. |
  2. |
}


VerseOne = \strophemode 1 ##f \lyricmode {
  A4 -- ve Ma -- rí -- a,2
  gra4 -- tí4. -- a8 plé4 -- na,2
  gra2 -- tí8 -- a plé2. -- na,4
  Ma -- rí -- a,2.
  gra4 -- tí4. -- a8 plé2. -- na,
  Dó2 -- mi8 -- nus Té4 -- cum,2
  Dó2 -- mi8 -- nus Té4 -- cum,2
  be4 -- ne -- díc -- ta Tu8
  in mu4 -- li -- é -- ri -- bus,2.
  et4 be8 -- ne -- díc -- tus
  frúc4 -- tus vén8 -- tris Tú4 -- i,
  Jé -- sus.2.
  
  A4 -- ve Ma -- rí -- a,2
  gra4 -- tí4. -- a8 plé4 -- na,2
  a4 -- ve4. Ma8 -- rí4 -- a,2
  a4 -- ve Ma -- rí -- a,
  a2 -- ve4. Ma8 -- rí4 -- a,2
  a4 -- ve Ma -- rí2. -- a.
}

VerseTwo = \strophemode 2 ##t \lyricmode {
  Sánc4 -- ta Ma -- rí -- a,2
  Sánc4 -- ta4. Ma8 -- rí4 -- a,2
  Má4 -- ter Dé -- i,
  ó2 -- ra4 pro nó -- bis,2.
  pec4 -- ca4. -- to8 -- rí2. -- bus,
  nunc2 et8 in hó4 -- ra,2
  nunc et8 in hó4 -- ra,2
  nunc4 et in8 hó -- ra4
  mór -- tis nós2. -- træ,
  mór -- tis2 nós4 -- træ.2
  A4 -- men.2.
}

tiboutSop = \lyricmode {
  \repeat unfold 66 \skip1
  a -- ve
}

tiboutBass = \lyricmode {
  \repeat unfold 61 \skip1
  a -- ve Ma -- rí -- a,
  a -- ve
}

tiboutTenor = \lyricmode {
  \repeat unfold 63 \skip1
  a -- ve,
  a -- ve
}

ChoeurPart = \new ChoirStaff \with {
	midiInstrument = "choir aahs"
} <<
  \new Staff = "upStaff" \with {
    \consists Merge_rests_engraver
  } <<
    \new Voice = "soprano" {\voiceOne \soprano }
    \new Voice = "alto" {\voiceTwo \alto }
  >>
  \new Lyrics \with {
    \override VerticalAxisGroup.staff-affinity = #CENTER
    alignAboveContext = #"upStaff"
  } \lyricsto "soprano" \tiboutSop
  
  \new Lyrics \with {
    \override VerticalAxisGroup.staff-affinity = #CENTER
  } \VerseOne
  \new Lyrics \with {
    \override VerticalAxisGroup.staff-affinity = #CENTER
  } \VerseTwo

  \new Staff = "downStaff" \with {
    \consists Merge_rests_engraver
    \clef bass
  } <<
    \new Voice = "tenor" {\voiceOne \tenor }
    \new Voice = "bass" {\voiceTwo \bass }
  >>
  \new Lyrics \with {
    \override VerticalAxisGroup.staff-affinity = #CENTER
    alignAboveContext = #"downStaff"
  } \lyricsto "tenor" \tiboutTenor
  \new Lyrics \with {
    \override VerticalAxisGroup.staff-affinity = #CENTER
  } \lyricsto "bass" \tiboutBass
>>

\paper {
  page-count = 1
}

\tocItemComposer "Ave Maria" "Séjour"
\score {
  \header {
    title = "AVE MARIA"
    composer = \dusejour
  }
  \ChoeurPart
  \layout {\context{\Staff \RemoveAllEmptyStaves }}
  \midi {}
}
