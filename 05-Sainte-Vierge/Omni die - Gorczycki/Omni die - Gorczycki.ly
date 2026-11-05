\version "2.26.0"
\include "settings.ily"
\include "composers.ily"

global = {
  \autoBeamOff
  \mergeDifferentlyHeadedOn
  \mergeDifferentlyDottedOn
  \key a \major
  \time 3/2
  \tempo "Andante"
  \dynamicUp
}

soprano = \relative c' {
  \global
  fis1 gis2 | % 1
  a1 a2 | % 2
  gis1 fis2 | % 3
  fis1 eis2 | % 4
  a1 fis2 | % 5
  b1 a2 | % 6
  a1 gis2 | % 7
  a1.\fermata |\break
  a1 a2 | % 9
  a1 gis2 | % 10
  gis2 fis1 | % 11
  cis'1 cis2 | % 12
  cis2. b4 a2 | % 13
  d2 cis2. b4 | % 14
  a1.\fermata |\bar "||"\break
  \time 2/2 \tempo "Moderato"
  fis4\f a4 fis4 a4 | % 16
  gis4 fis4 gis4 fis4 | % 17
  a4 gis4 a4 b4 | % 18
  gis4. gis8 fis2 | % 19
  fis4 b4 b4 ais4 | % 20
  a4 d4 d4 cis4 | % 21
  d4 d4 b4 b4 | % 22
  a4. a8 a2 | % 23
  cis4 cis4 b4 a4 | % 24
  a4 gis4 a2\fermata \bar "|." % 25
}

alto = \fixed c' {
  \global
  cis1 e2 | % 1
  e1 e2 | % 2
  e1 cis2 | % 3
  cis1 cis2 | % 4
  e1 fis2 | % 5
  fis1 cis2 | % 6
  e1 e2 | % 7
  cis1. | % 8
  e1 e2 | % 9
  e1 e2 | % 10
  cis1 fis2 | % 11
  fis1 eis2 | % 12
  fis2. gis4 a2 | % 13
  gis4 ( fis ) fis2 eis2 | % 14
  fis1. | % 15
  fis4 e4 fis4 e4 | % 16
  e4 b,4 e4 dis4 | % 17
  cis4 eis4 cis4 fis4 | % 18
  fis4 eis4 fis2 | % 19
  fis4 fis4 fis4 fis4 | % 20
  fis4 fis4 fis4 e4 | % 21
  fis4 fis4 d4 g4 | % 22
  e4. e8 fis2 | % 23
  e4 e4 fis4 fis8[ e8] | % 24
  e4. e8 e2
}

tenor = \relative c {
  \global
  a'1 b2 | % 1
  cis1 cis2 | % 2
  b1 a2 | % 3
  gis1 gis2 | % 4
  cis1 a2 | % 5
  d1 cis2~ | % 6
  cis2 b2. b4 | % 7
  a1.\fermata | % 8
  cis1 cis2 | % 9
  b1 b2 | % 10
  a1 a2 | % 11
  gis1 gis2 | % 12
  a2. b4 cis2 | % 13
  b4 ( a ) gis2. gis4 | % 14
  fis1.\fermata | % 15
  a4 a4 a4 a4 | % 16
  b4 b4 b4 b4 | % 17
  cis4 cis4 cis4 d4 | % 18
  cis4. cis8 cis2 | % 19
  d4 d4 cis4 cis4 | % 20
  d4 d4 a4 a4 | % 21
  a4 a4 b8[ cis ] d4 | % 22
  d4 cis4 d2 | % 23
  a4 e'4 d4 d8[ cis ] | % 24
  b4. b8 cis2\fermata
}

bass = \fixed c {
  \global
  fis1 e2 | % 1
  a1 a2 | % 2
  e1 fis2 | % 3
  cis1 cis2 | % 4
  a,1 d2 | % 5
  b,1 cis2 | % 6
  cis4 ( d e2 ) e, |
  a,1. | % 8
  a1 a2 | % 9
  e1 e2 | % 10
  fis1 fis2 | % 11
  cis1 cis2 | % 12
  fis2. fis4 fis2 | % 13
  b,2 cis2. cis4 | % 14
  fis,1. | % 15
  d4 cis4 d4 a,4 | % 16
  e4 dis4 e4 b,4 | % 17
  fis4 eis4 fis4 b,4 | % 18
  cis4. cis8 fis,2 | % 19
  b,8[ cis ] d8[ e8] fis4 fis4 | % 20
  d8[ e8] fis8[ g8] a4 a,4 | % 21
  d4 fis4 g4 g4 | % 22
  a4 a,4 d2 | % 23
  cis4 cis4 d4 d4 | % 24
  e4 e,4 a,2
}

VerseOne = \strophemode 1 ##f \lyricmode {
  Om -- ni dí -- e dic Ma -- rí -- æ
  mé -- a láu -- des á -- ni -- ma.
  E -- jus fé -- sta, é -- jus gé -- sta
  co -- lé -- de vo -- tís -- si -- ma.
  Con -- tem -- plá -- re, et mi -- rá -- re
  é -- jus cel -- si -- tú -- di -- nem_:
  dic fe -- lí -- cem Gen -- i -- trí -- cem,
  dic be -- á -- tam Vír -- gi -- nem,
  dic be -- á -- tam Vír -- gi -- nem.
}

VerseTwo = \strophemode 2 ##t \lyricmode {
  I -- psam có -- le, ut de -- mó -- le
  crí -- mi -- num te li -- bé -- ret.
  Hanc ap -- pél -- la ne pro -- cél -- la
  vi -- ti -- ó -- rum sú -- pe -- ret.
  Hæc per -- só -- na nó -- bis dó -- na
  con -- tú -- lit cœ -- le -- stí -- a,
  hæc Re -- gí -- na nos di -- ví -- na
  il -- lus -- trá -- vit grá -- ti -- a,
  il -- lus -- trá -- vit grá -- ti -- a.
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
  \new Lyrics \with {
    \override VerticalAxisGroup.staff-affinity = #CENTER
  } \lyricsto "soprano" \VerseTwo

  \new Staff \with {
    \consists Merge_rests_engraver
    \clef bass
  } <<
    \new Voice = "tenor" {\voiceOne \tenor }
    \new Voice = "bass" {\voiceTwo \bass }
  >>
>>

\tocItemComposer "Omni die" "Gorczycki"
\score {
  \header {
    title = "OMNI DIE"
    composer = \gorczycki
  }
  \ChoeurPart
  \layout {\context{\Staff \RemoveAllEmptyStaves }}
  \midi {\tempo 2=90 }
}
