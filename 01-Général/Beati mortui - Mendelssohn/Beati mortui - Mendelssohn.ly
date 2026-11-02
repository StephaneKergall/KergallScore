\version "2.26.0"
\include "settings.ily"
\include "composers.ily"

global = {
  \autoBeamOff
  \mergeDifferentlyHeadedOn
  \mergeDifferentlyDottedOn
  \key c \major
  \time 4/4
  \partial 4
  \tempo "Andante sostenuto" 4=84
  \dynamicUp
}

tenorOne = \relative e' {
  \global
  e4 \p  e2  d2
  | % 1
  f4.  f8  e4  c4 | % 2
  c4  c8 c d4  e4 | % 3
  d2  g,4  g4 | % 4
  a2  a2 |
  g4.  g8  g4 r4 | % 6
  r2 r4  d'4 \cresc |
  e2  e4  e4 | % 8
  e4 \f  e8 e d4  e4 | % 9
  f2 e4 d | % 10
  e1 |
  e2 r4  a,4 \p | % 12
  d1\espressivo | % 13
  d2 r4  c4 \pp | % 14
  b1 | % 15
  a2 r2
  R1 
  r2  c4. \f  c8 | % 18
  f4  c4  d4.  d8 | % 19

  c4  c4 \p  c4  c4 | % 20
  bes2  a2 | % 21
  g4  g4  bes4  a8 g | % 22
  g1 | 
  a2  a4. \f  bes8
  c4  a4  d4.  e8 | % 25
  e4  e4  e4  e4 | % 26
  f2  e2 | % 27
  d4  d4  f4  e8 d | % 28
  e2  e4  c4 \p |
  d4.  d8  d4  d4 | % 30
  d2  d2 | % 31
  r4  e4 \cresc
  e4  e4 |
  f2  f2 | % 33
  r4  fis4 \f  fis4  fis4 | % 34
  g1 | % 35
  g,2. \fermata  e'4 \p | % 36
  e2  d2 | % 37
  f4.  f8  e4  c4 | % 38
  c4  c8 c8 d4  e4 | % 39

  d2  g,4  e'4 \p | % 40
  e2 \<  g2 <>\! |
  g4. \>  f8  f4  e4\! | % 42
  d1 | % 43
  e2 r2 | % 44
  r2 r4  d4 | % 45
  g4  f4  e4  d4 | % 46
  c2 (  d4 )  e4 | % 47
  d2. ( e4 ) | % 48
  e2 r2 | % 49
  r2 r4  d4 | % 50
  g4  f4  e2 ~ | % 51
  e4.  e8  f4  d4 | % 52
  d1 ( \p | % 53
  c1 ) | % 54
  c1 \fermata \pp \bar "|."
}

tenorOneLyricsOne = \lyricmode {
  Be -- a -- ti mor -- tu -- i
  in Do -- mi -- no mo -- ri -- en -- tes,
  be -- a -- ti mor -- tu -- i,
  be -- a -- ti in Do -- mi -- no
  mo -- ri -- en -- tes
  de in -- ceps,
  be -- a -- ti, be -- a -- ti_!
  Di -- cit e -- nim spi -- ri -- tus,
  ut re -- qui -- e -- scant
  a la -- bo -- ri -- bus su -- is,
  di -- cit e -- nim spi -- ri -- tus,
  ut re -- qui -- e -- scant
  a la -- bo -- ri -- bus su -- is,
  et o -- pe -- ra il -- lo -- rum
  se -- quun -- tur ip -- sos,
  se -- quun -- tur ip -- sos.
  Be -- a -- ti mor -- tu -- i
  in Do -- mi -- no mo -- ri -- en -- tes,
  be -- a -- ti mor -- tu -- i,
  be -- a -- ti, be -- a -- ti mor -- tu -- i __
  de in -- ceps,
  be -- a -- ti mor --  tu -- i
  de in --  ceps_!
}

tenorTwo = \relative c' {
  \global
  c4 \p  c2  b2 | % 1
  c4.  c8  c4  g4 | % 2
  a4  g8 g a [ b ] c4 | % 3
  c2  b4 r4 | % 4
  R1 | % 5
  r2 r4  d4 \cresc |
  d2  d2 | % 7
  d4.  d8  c4  b4 | % 8
  c4 \f  c8 c d4  c4 | % 9
  b2 c4 d4 | % 10
  c2 (  b2 ) | % 11
  c2 r4  a4 \p | % 12
  a1\espressivo | % 13
  gis2 r4  a4 \pp | % 14
  a2 _(  gis2 ) | % 15
  a2 r2
  R1
  r2  a4. \f  bes8 | % 18
  c4  a4  f4  g4 | % 19
  a4  a4 \p  a4  a4 | % 20
  g2  f2 | % 21
  f4  f4  f4  f8 f | % 22
  f2 _(  e2 ) | % 23
  f2  a4. \f  bes8 |
  c4  a4  d4.  cis8 | % 25
  cis4  cis4  cis4  cis4 | % 26
  d2  b!2 | % 27
  d4  d4  d4  c!8 b8 | % 28
  b2  c4  a4 \p | % 29
  a4.  a8  a4  a4 | % 30
  a2  a2 | % 31
  r4  bes4 \cresc
  bes4  bes4 | % 32
  c2  c2 | % 33
  r4  d4 \f  d4  d4 | % 34
  e2 (  d4  c4 ) | % 35
  d2. \fermata  c4 \p | % 36
  c2  b2 | % 37
  c4  d4  e4  c4 | % 38
  c4  c8 c8 b4  c4 | % 39
  c2  b4  c4 \p | % 40
  c2 \<  c2 <>\! | % 41
  c4. \>  c8  c4  c4 \! | % 42
  c2 (  b2 ) | % 43
  c2 r4  c4 | % 44
  f4  e4  d4  c4 | % 45
  b2.  gis4 | % 46
  a2  c4  c4 | % 47
  c2 (  b2 ) | % 48
  c2 r4  c4 | % 49
  f4  e4  d4  c4 | % 50
  b2.  d4 | % 51
  c2  c4  c4 | % 52
  c2 ( \p  b2 ) | % 53
  c2  a2 \pp | % 54
  a2  g2 \fermata
}

tenorTwoLyricsOne = \lyricmode {
  Be -- a -- ti mor -- tu -- i
  in Do -- mi -- no mo -- ri -- en -- tes,
  be -- a -- ti mor -- tu -- i
  in Do -- mi -- no
  mo -- ri -- en -- tes
  de in -- ceps,
  be -- a -- ti, be -- a -- ti_!
  Di -- cit e -- nim spi -- ri -- tus,
  ut re -- qui -- e -- scant
  a la -- bo -- ri -- bus su -- is,
  di -- cit e -- nim spi -- ri -- tus,
  ut re -- qui -- e -- scant
  a la -- bo -- ri -- bus su -- is,
  et o -- pe -- ra il -- lo -- rum
  se -- quun -- tur ip -- sos,
  se -- quun -- tur ip -- sos.
  Be -- a -- ti mor -- tu -- i
  in Do -- mi -- no mo -- ri -- en -- tes,
  be -- a -- ti mor -- tu -- i,
  be -- a -- ti, be -- a -- ti mor -- tu -- i __
  be -- a -- ti de in -- ceps,
  be -- a -- ti mor --  tu -- i,
  be -- a -- ti,
  be -- a -- ti,
  be -- a -- ti_!
}

bassOne = \relative g {
  \global
  g4 \p  g2  g2 | % 1
  a4.  a8  g4  e4 | % 2
  f4  e8 e f4  g4 | % 3
  g2  g4 r4 |
  r2 r4  c4\cresc | % 5
  c2  c2 | % 6
  c4.  b8  b4  a4 | % 7
  gis2  gis4  gis4 | % 8
  a4 \f  a8 a a4  a4 | % 9
  a2 4 4 | % 10
  a2 (  gis2 ) | % 11
  a2 r4  a4 \p | % 12
  f1\espressivo | % 13
  e2 r4  e4 \pp | % 14
  e1 | % 15
  a,2  a'4. \f  bes8 | % 16
  c4  a4  f4  g4 | % 17
  a2  f4.  g8 | % 18
  a4  f4  bes4.  bes8 | % 19
  f4  f4 \p  f4  f4 | % 20
  d4 (  e4 )  f2 | % 21
  bes,4  bes4  d4  c8 bes8 | % 22
  c1 | % 23
  f,2  a'4. \f  bes8 | % 24
  c4  a4  f4.  e8 | % 25
  e4  a4  a4  a4 | % 26
  a2  gis2 | % 27
  a4  a4  a4  a8 a | % 28
  gis2  a4 r4 | % 29
  r2 r4  c4 \p | % 30
  c4.  c8  c4  c4 | % 31
  c2 \cresc 2 |
  r4  c4 \f  c4  c4 | % 33
  c2  c2 | % 34
  c2 (  b4  a4 ) | % 35
  b2. \fermata  g4 \p | % 36
  g2  g2 | % 37
  a4  b4  c4  g4 | % 38
  a4  g8 g8 g4  g4 | % 39
  g2  g4  g4 \p | % 40
  g2 \< bes2 <>\! | % 41
  bes4.\>  a8  a4  a4 \! |
  a2. (  d,4 ) | % 43
  e4  g4  c4  b!4 | % 44
  a4  g4  f2 ~ | % 45
  f4  a4  gis4  gis4 | % 46
  a4.  a8  a4  a4 | % 47
  a2 (  g!2 ) | % 48
  g4  g4  c4  b4 |
  a4  g4  f2 ~ | % 50
  f4  a4  gis4  gis4 | % 51
  a4.  a8  a4  a4 | % 52
  g!1 \p | % 53
  g2  f2 \pp | % 54
  f2  e2 \fermata
}

bassOneLyricsOne = \lyricmode {
  Be -- a -- ti mor -- tu -- i
  in Do -- mi -- no mo -- ri -- en -- tes,
  be -- a -- ti mor -- tu -- i,
  be -- a -- ti in Do -- mi -- no
  mo -- ri -- en -- tes
  de in -- ceps,
  be -- a -- ti, be -- a -- ti_!
  Di -- cit e -- nim spi -- ri -- tus,
  di -- cit e -- nim spi -- ri -- tus,
  ut re -- qui -- e -- scant
  a la -- bo -- ri -- bus su -- is,
  di -- cit e -- nim spi -- ri -- tus,
  ut re -- qui -- e -- scant
  a la -- bo -- ri -- bus su -- is,
  et o -- pe -- ra il -- lo -- rum
  se -- quun -- tur ip -- sos,
  ip -- sos.
  Be -- a -- ti mor -- tu -- i
  in Do -- mi -- no mo -- ri -- en -- tes,
  be -- a -- ti mor -- tu -- i,
  be -- a -- ti, be -- a -- ti mor -- tu -- i __
  be -- a -- ti mor --  tu -- i
  de in --  ceps,
  be -- a -- ti mor -- tu -- i __
  be -- a -- ti mor --  tu -- i
  de in --  ceps,
  be -- a -- ti_!
}

bassTwo = \relative c {
  \global
  c4 \p  c2  g2 | % 1
  f4.  f8  c'4  e4 | % 2
  f4  e8 e d4  c4 | % 3
  g'2  g,4  g'4\cresc |
  g2  f2 | % 5
  f4.  e8  e4  d4 | % 6
  g2. (  f4 ) | % 7
  e2.  e4 | % 8
  a4 \f  g8 f f4  e4 | % 9
  d2 e4 f |
  e1 | % 11
  a,2 r4  a4 \p | % 12
  d1\espressivo | % 13
  e2 r4  a,4 \pp | % 14
  <e e'>1 | % 15
  a2  a'4. \f  bes8 |
  c4  a4  f4  g4 | % 17
  a2  f4.  g8 | % 18
  a4  f4  <bes, bes'!>4.  <bes bes'>8 | % 19
  f'4  f4 \p  f4  f,4 | % 20
  g2  a2 | % 21
  bes4  bes4  d4  c8 bes | % 22
  c1 | % 23
  f,2  a'4. \f  bes8 | % 24
  c4  a4  d,4.  a8 | % 25
  a1 | % 26
  d2  e2 | % 27
  f2 (  d4 )  e8 f | % 28
  e2  a,4  a'4 \p | % 29
  f4.  f8  f4  f4 | % 30
  f2  f2 | % 31
  r4 g\cresc g g |
  a2  a2 | % 33
  r4  d,4 \f  d4  d4 | % 34
  g1 | % 35
  g,2. \fermata  c4 \p | % 36
  c1 ~ | % 37
  c2  c4  e4 | % 38
  f4  e8 e8 d4  c4 | % 39
  g'2  g,4  c4 \p | % 40
  c2  c2 | % 41
  f4. \>  f8  f4  f,4 \! | % 42
  g1 | % 43
  c2  c2 ~ | % 44
  c2  d2 ~ | % 45
  d2  e4  e4 | % 46
  a4 (  g4 )  f4  e4 | % 47
  f2 (  g2 ) | % 48
  c,2  c2 ~ | % 49
  c2  d2 ~ | % 50
  d2  e2 | % 51
  a4.  a8  f4  f4 | % 52
  g1 ( \p | % 53
  c,1 ) | % 54
  c1 \fermata \pp
}

bassTwoLyricsOne = \lyricmode {
  Be -- a -- ti mor -- tu -- i
  in Do -- mi -- no mo -- ri -- en -- tes,
  be -- a -- ti mor -- tu -- i,
  be -- a -- ti in Do -- mi -- no
  mo -- ri -- en -- tes
  de in -- ceps,
  be -- a -- ti, be -- a -- ti_!
  Di -- cit e -- nim spi -- ri -- tus,
  di -- cit e -- nim spi -- ri -- tus,
  ut re -- qui -- e -- scant
  a la -- bo -- ri -- bus su -- is,
  di -- cit e -- nim spi -- ri -- tus,
  a la -- bo -- ri -- bus su -- is,
  et o -- pe -- ra il -- lo -- rum
  se -- quun -- tur ip -- sos,
  se -- quun -- tur ip -- sos.
  Be -- a -- ti
  in Do -- mi -- no mo -- ri -- en -- tes,
  be -- a -- ti mor -- tu -- i,
  be -- a -- ti, be -- a -- ti mor -- tu -- i __
  de in -- ceps,
  be -- a -- ti mor --  tu -- i
  de in --  ceps_!
}


ChoeurPart = \new ChoirStaff \with {
  midiInstrument = "choir aahs"
} <<
  \new Staff \with {
    instrumentName = "T1."
    \consists "Ambitus_engraver"
    \clef "treble_8"
  }  \new Voice = "tenorOne" {\tenorOne }
  \new Lyrics \with {
    \override VerticalAxisGroup.staff-affinity = #CENTER
  } \lyricsto "tenorOne" \tenorOneLyricsOne

  \new Staff \with {
    instrumentName = "T2."
    \consists "Ambitus_engraver"
    \clef "treble_8"
  }  \new Voice = "tenorTwo" {\tenorTwo }
  \new Lyrics \with {
    \override VerticalAxisGroup.staff-affinity = #CENTER
  } \lyricsto "tenorTwo" \tenorTwoLyricsOne

  \new Staff \with {
    instrumentName = "B1."
    \consists "Ambitus_engraver"
    \clef bass
  }  \new Voice = "bassOne" {\bassOne }
  \new Lyrics \with {
    \override VerticalAxisGroup.staff-affinity = #CENTER
  } \lyricsto "bassOne" \bassOneLyricsOne

  \new Staff \with {
    instrumentName = "B2."
    \consists "Ambitus_engraver"
    \clef bass
  }  \new Voice = "bassTwo" {\bassTwo }
  \new Lyrics \with {
    \override VerticalAxisGroup.staff-affinity = #CENTER
  } \lyricsto "bassTwo" \bassTwoLyricsOne

>>

\tocItemComposer "Beati mortui" "Mendelssohn"
\score {
  \header {
    title = "BEATI MORTUI"
    composer = \mendelssohn
  }
  \ChoeurPart
  \layout {\context{\Staff \RemoveAllEmptyStaves }}
  \midi { }
}
