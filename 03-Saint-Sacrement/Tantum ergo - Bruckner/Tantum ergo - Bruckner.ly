\version "2.26.0"
\include "settings.ily"
\include "composers.ily"

global = {
  \autoBeamOff
  \mergeDifferentlyHeadedOn
  \mergeDifferentlyDottedOn
  \key d \major
  \time 2/2
  \tempo "Andante"
  \dynamicUp
}

soprano = \fixed c {
  \global
  \bar ".|:"
  \repeat volta 2 {
    fis'2\p fis'2 |
  % bar 2
  g'2 fis'4(  a'4)  |
  % bar 3
  b'2.\> a'4 |
  % bar 4
  a'4(\<  g'4)  fis'2\> |
  % bar 5
  fis'2.\f cis''4 |
  % bar 6
  d''4(  cis''4)  b'4(  a'4)  |
  
  % bar 7
  a'4(\>  g'4)  fis'2 |
  % bar 8
  e'2\! r2 |
  % bar 9
  fis'2.\p fis'4 |
  % bar 10
  g'2 fis'2 |
  % bar 11
  b'2. cis''4\< |
  % bar 12
  cis''4(  d''4)  cis''2 |
  % bar 13
  fis''2\f fis'2 |
  
  % bar 14
  fis'4(  e''4)  e''4(  d''4)  |
  % bar 15
  d''4(  cis''4)  b'4(  ais'4)  |
  % bar 16
  b'2 r2 |
  % bar 17
  b'2.\p a'4 |
  % bar 18
  g'4(  a'4)  fis'2 |
  % bar 19
  d''2.\f c''4 |
  % bar 20
  b'4(  c''4)  a'2 |
  
  % bar 21
  b'2\p g'2 |
  % bar 22
  a'2 fis'2 |
  % bar 23
  b'4(  a'4 g'4)  fis'4 |
  % bar 24
  fis'2(  e'2)  |
  % bar 25
  r1 |
  % bar 26
  r1 |
  % bar 27
  d''2. cis''4 |
  
  % bar 28
  b'4(  cis''4)  ais'2 |
  % bar 29
  b'2. b'4 |
  % bar 30
  b'4( a'4) g'4( fis'4) |
  % bar 31
  fis'4( e'4 d'4) e'4 |
  % bar 32
  fis'2 fis''4. e''8
  
  % bar 33
  e''4( d''4) cis''4 b'4 |
  % bar 34
  b'4( a'4) g'4( fis'4) |
  % bar 35
  fis'4( e'4) d'4( e'4) |
  % bar 36
  d'2 r2 |
  }
  % bar 37
  d'2( g'2) |
  % bar 38
  fis'1\fermata \bar "|." |
}

alto = \fixed c {
  \global
  % bar 1
  d'2 d'2 |
  % bar 2
  e'2 d'2 |
  % bar 3
  d'2. d'4 |
  % bar 4
  cis'4( e'4) d'2 |
  % bar 5
  e'2. e'4 |
  % bar 6
  d'2 e'4( fis'4) |
  % bar 7
  cis'2 d'2 |
  % bar 8
  cis'2 r2 |
  % bar 9
  d'2. d'4 |
  % bar 10
  e'2 d'2 |
  % bar 11
  fis'2. fis'4 |
  % bar 12
  fis'2 fis'2 |
  % bar 13
  fis'2 fis'2 |
  % bar 14
  fis'2 fis'2 |
  % bar 15
  fis'4( e'4) d'4( cis'4) |
  % bar 16
  d'2 r2 |
  % bar 17
  d'2 e'2 |
  % bar 18
  d'2 d'2 |
  % bar 19
  b'2. a'4 |
  % bar 20
  g'4( a'4) fis'2 |
  % bar 21
  fis'2 e'2 |
  % bar 22
  e'2 d'2 |
  % bar 23
  g'4( fis'4 cis'4) d'4 |
  % bar 24
  d'2( cis'2) |
  % bar 25
  r1 |
  % bar 26
  a'4\f a'4 a'4 g'4 |
  % bar 27
  fis'2. e'4 |
  % bar 28
  d'4( e'4) cis'4( fis'4) |
  % bar 29
  fis'2( e'4) d'4 |
  % bar 30
  cis'2 d'2 |
  % bar 31
  b2( a4) cis'4 |
  % bar 32
  d'4( fis'4) fis'4. fis'8 |
  % bar 33
  fis'2 a'4 g'4 |
  % bar 34
  g'4( fis'4) cis'4( d'4) |
  % bar 35
  b2 a2 |
  % bar 36
  a2 r2 |
  % bar 37
  b2( d'2) |
  % bar 38
  d'1\fermata |
}

tenor = \fixed c {
  \global
  % bar 1
  a2 a2 |
  % bar 2
  a2 a4( fis4) |
  % bar 3
  g2. fis4 |
  % bar 4
  e4( a4) a2 |
  % bar 5
  ais2 cis'2 |
  % bar 6
  b4( a4) g4( fis4) |
  % bar 7
  a2 a4( b4) |
  % bar 8
  cis'2 r2 |
  % bar 9
  a2. a4 |
  % bar 10
  a2 a2 |
  % bar 11
  fis2. ais4 |
  % bar 12
  ais4( b4) a2 |
  % bar 13
  a2 a4( fis4) |
  % bar 14
  e'4( cis'4) cis'4( b4) |
  % bar 15
  g2 fis2 |
  % bar 16
  fis2 r2 |
  % bar 17
  g2 e4( c'4) |
  % bar 18
  b4( c'4) a4( d'4) |
  % bar 19
  d'2 e'2 |
  % bar 20
  d'2 d'2 |
  % bar 21
  b2 b2 |
  % bar 22
  a2 a2 |
  % bar 23
  d'2 a2 |
  % bar 24
  a1 |
  % bar 25
  fis'2.\f e'4 |
  % bar 26
  d'4( e'4) cis'2 |
  % bar 27
  d'4( ais4 b4) g4 |
  % bar 28
  fis2 fis2 |
  % bar 29
  b2. a4 |
  % bar 30
  a2 a2 |
  % bar 31
  g2 fis4( a4) |
  % bar 32
  a2 ais4. ais8 |
  % bar 33
  ais4( b4) e'4 e'4 |
  % bar 34
  d'2 a2 |
  % bar 35
  a4( g4) fis4( g4) |
  % bar 36
  fis2 r2 |
  % bar 37
  g2( b2) |
  % bar 38
  a1\fermata |
}

bass = \fixed c {
  \global
  % bar 1
  d2 d2 |
  % bar 2
  cis2 d2 |
  % bar 3
  g,2. d4 |
  % bar 4
  a,2 d2 |
  % bar 5
  fis2 ais,2 |
  % bar 6
  b,2 cis4( d4) |
  % bar 7
  e2 fis4( g4) |
  % bar 8
  a2 r2 |
  % bar 9
  d2 d2 |
  % bar 10
  cis2 d2 |
  % bar 11
  d2. cis4 |
  % bar 12
  b,2 fis2 |
  % bar 13
  d2 d2 |
  % bar 14
  cis4( ais,4) b,2 |
  % bar 15
  e2 fis2 |
  % bar 16
  b,2 r2 |
  % bar 17
  b,2 c2 |
  % bar 18
  d2 d2 |
  % bar 19
  g,2 c2 |
  % bar 20
  d2 d2 |
  % bar 21
  dis2 e2 |
  % bar 22
  cis2 d2 |
  % bar 23
  g,4( d4) e4( fis8[ g8)] |
  % bar 24
  a2( a,2) |
  % bar 25
  a2. g4 |
  % bar 26
  fis4( g4) e2 |
  % bar 27
  b,4( cis4 d4) e4 |
  % bar 28
  fis2 fis2 |
  % bar 29
  g2. fis4 |
  % bar 30
  e2 fis2 |
  % bar 31
  g4( g,4) a,2 |
  % bar 32
  d2 cis4. cis8 |
  % bar 33
  b,2 cis4 cis4 |
  % bar 34
  d2 e4( fis4) |
  % bar 35
  g,2 a,2 |
  % bar 36
  d2 r2 |
  % bar 37
  g,2.( b,4) |
  % bar 38
  d1\fermata |
}

VerseOne = \strophemode 1 ##f \lyricmode {
  Tán -- tum ér -- go sa -- cra -- mén -- tum
  Ve -- ne -- ré -- mur cér -- nu -- i:
  Et an -- tí -- quum do -- cu -- mén -- tum
  Nó -- vo cé -- dat rí -- tu -- i.
  Prǽ -- stet fí -- des sup -- ple -- mén -- tum
  Sén -- su -- um de -- féc -- tu -- i.
  Prǽ -- stet fí -- des sup -- ple -- mén -- tum
  Sén -- su -- um de -- féc -- tu -- i,
  sén -- su -- um, sén -- su -- um de -- féc -- tu -- i.
}

VerseOneMen = \lyricmode {
  \repeat unfold 45 \skip1
  Prǽ -- stet fí -- des
}

VerseTwo = \strophemode 2 ##t \lyricmode {
  Ge -- ni -- tó -- ri ge -- ni -- tó -- que
  Laus et ju -- bi -- lá -- ti -- o,
  Sá -- lus, hó -- nor, vír -- tus quó -- que
  Sit et be -- ne -- díc -- ti -- o:
  Pro -- ce -- dén -- ti ab u -- tró -- que
  Cóm -- par sit lau -- dá -- ti -- o.
  Pro -- ce -- dén -- ti ab u -- tró -- que
  Cóm -- par -- sit lau -- dá -- ti -- o,
  cóm -- par sit, cóm -- par sit lau -- dá -- ti -- o.
  A -- men.
}

VerseTwoMen = \lyricmode {
\override LyricText.font-shape = #'italic
  \repeat unfold 45 \skip1
  Pro -- ce -- dén -- ti
}

ChoeurPart = \new ChoirStaff \with {
  midiInstrument = "choir aahs"
} <<
  \new Staff \with {
    \consists Merge_rests_engraver
  } <<
    \new Voice = "soprano" { \voiceOne \soprano }
    \new Voice = "alto" { \voiceTwo \alto }
  >>
  \new Lyrics \with {
    \override VerticalAxisGroup.staff-affinity = #CENTER
  } \lyricsto "alto" \VerseOne
  \new Lyrics \with {
    \override VerticalAxisGroup.staff-affinity = #CENTER
  } \lyricsto "alto" \VerseTwo

  \new Staff \with {
    \clef bass
    \consists Merge_rests_engraver
  } <<
    \new Voice = "tenor" { \voiceOne \tenor }
    \new Voice = "bass" { \voiceTwo \bass }
  >>
  \new Lyrics \with {
    \override VerticalAxisGroup.staff-affinity = #CENTER
  } \lyricsto "tenor" \VerseOneMen
  \new Lyrics \with {
    \override VerticalAxisGroup.staff-affinity = #CENTER
  } \lyricsto "tenor" \VerseTwoMen
>>

\paper {
  page-count = 1
}

\tocItemComposer "Tantum ergo" "Bruckner"
\score {
  \header {
    title = "TANTUM ERGO"
    composer = \bruckner
    poet = \markup {"Paroles :" \stthomas}
  }
  \ChoeurPart
  \layout {\context{\Staff \RemoveAllEmptyStaves }}
  \midi {\tempo 4=70 }
}
