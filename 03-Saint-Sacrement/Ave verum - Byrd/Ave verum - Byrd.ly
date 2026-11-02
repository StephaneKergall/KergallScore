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
  g1 |
  fis2 a ~ |
  4 g fis g ~ |
  8 [ fis16 e ] fis4 g2 |
  a bes |
  c4 4 d2 ~ |
  4 c bes4. 8 |
  a2 r4 g ~ |
  4 f es2 |
  d r4 f ~ |
  4 g a2 |
  2 r4 g |
  bes2 a ~ |
  4 bes g4. 8 |
  fis2 r4 g ~ |
  4 4 a2 | 
  g4 bes4. a8 4 ~ |
  4 g a2 |
  c bes4 a ~ |
  4 g f4. 8 |
  4 2 4 |
  2 r4 g ~ |
  4 4 2 |
  4 a2 4 |
  bes2 a4 4 |
  c2. bes4 ~ |
  4 a2 bes4 ~ |
  4 a bes f |
  \repeat volta 2 {
    bes2 g |
    r4 g bes2 |
    a r4 g |
    d'2. c4 ~ |
    4 bes2 a8 [ g ] |
    a4 4 bes4. a8 |
    g2 fis
    R1
    r2 g4. bes8 |
    a4 g fis2 |
    g4 r r2 |
    a4. c8 bes4 a |
    a g fis a ~ |
    8 [ g ] 2 fis4\bar "||"
    \alternative {
      \volta 1 {
        g2 r4 d |
      }
      \volta 2 {
        g1 |
      }
    }
  }
  1 1 ~ 1\bar "|."
}

sopranoVerseOne = \lyricmode {
  A -- ve vé -- rum cór -- _  _ pus,
  ná -- tum de Ma -- rí -- a Vír -- gi -- ne,
  Vé -- re pás -- sum, im -- mo -- lá -- tum
  in Crú -- ce __
  pro hó -- mi -- ne_:
  Cú -- jus lá -- tus per -- fo -- rá -- _ tum,
  ún -- da flú -- xit
  sán -- gui -- ne,
  sán -- gui -- ne_;
  Es -- to nó -- bis præ -- gus -- tá -- tum
  in mór -- tis __
  e -- xá -- mi -- ne.
  O dúl -- cis, o pí -- e,
  o Jé -- su __ Fí -- _ li
  Ma -- rí -- _ _ æ_;
  mi -- se -- ré -- re mé -- i,
  mi -- se -- ré -- re mé -- _ i,
  mé -- _ _ i.
  O
  -_i.
  A -- men. __
}


alto = \fixed c' {
  \global
  d1 |
  2 c ~ |
  4 4 d2 ~ |
  2 2 |
  f f |
  4 4 2 ~ |
  4 4 d4. 8 |
  2 r4 bes, ~ |
  4 4 2 |
  2 d ~ |
  4 e f2 ~ |
  2 c |
  r4 bes, f4. 8 |
  c4 d2 c4 |
  d2 r4 e4 ~ |
  4 4 f2 |
  e4 f2 e4 |
  f e8 [ d ] c4 f ~ |
  4 es d2 |
  c d4. 8 |
  2 c4. 8 |
  d2 r4 es ~ |
  4 4 d2 |
  e4 f2 4 |
  2 4 4 |
  g2 4 bes, |
  f2 4 4 |
  4. es8 d2 |
  r4 d es2 |
  d r4 4 |
  2 b, |
  r4 bes,? f2 |
  es4 d2 c4 |
  r4 f, bes,2 ~ |
  4 a,8 [ g, ] a,2 |
  bes,4. d8 c4 bes, |
  a,2 bes, |
  c4. es8 d4 a, |
  d4. f8 es4 d |
  c a, d4. c8 |
  a,4 bes,8 [ c ] d4 es |
  d c d2 |
  b,1 |
  2 c ~ |
  4 bes, es2 ~ |
  4 d8 [ c ] d2 ~ |
  1 |
}

altoVerseOne = \lyricmode {
  A -- ve vé -- rum cór -- pus,
  ná -- tum de Ma -- rí -- a Vír -- gi -- ne,
  Vé -- re pás -- sum, im -- mo -- lá -- tum
  in Crú -- ce pro hó -- mi -- ne_:
  Cú -- jus lá -- tus per -- fo -- rá -- _ tum,
  ún -- da flú -- xit
  sán -- gui -- ne,
  sán -- gui -- ne_;
  Es -- to nó -- bis præ -- gus -- tá -- tum
  in mór -- tis,
  in mór -- tis
  e -- xá -- mi -- ne.
  O dúl -- cis, o pí -- e,
  o Jé -- su Fí -- li
  Ma -- rí -- _ æ_;
  mi -- se -- ré -- re mé -- i,
  mi -- se -- ré -- re,
  mi -- se -- ré -- re mé -- i,
  mi -- se -- ré -- re mé -- _ _ _ _ i.
  -_i.
  A -- _ _ _ men. __
}


tenor = \relative c' {
  \global
  bes1 |
  a |
  c2. bes4 |
  a2 b |
  c d |
  f,4 4 bes2 ~ |
  4 a g4. 8 |
  fis2 r4 g8 [ a ] |
  bes4 f g2 |
  f bes |
  a4 c2 f,4 |
  r c' es2 ~ |
  4 d2 c4 |
  f4. f,8 g4 4 |
  a2 r4 c ~ |
  4 4 2 |
  c4 d2 c4 |
  bes2 a
  R1
  r4 c2 bes4 |
  a8. f16 bes2 a4 |
  bes2 r4 4 |
  g c2 b4 |
  c2 a4 4 |
  d2 c4 4 |
  es2. d4 ~ |
  4 c d c8 [ bes ] |
  c4 4 bes2 |
  r4 4 c2 |
  b r4 g |
  fis2 g ~ |
  2 r |
  r4 bes f'4. es8 |
  d4 c f d ~ |
  4 c d2 |
  g,4. bes8 a4 g |
  fis2 g |
  r a4. c8 |
  bes4 a4. g8 4 ~ |
  4 fis g4 fis4 ~ |
  4 g a4. c8 |
  bes4 a8 [ g ] a2 |
  g1 |
  2 es' ~ |
  4 d4. c8 4 ~ |
  4 b8 [ a ] b2 ~ |
  1 |
}

tenorVerseOne = \lyricmode {
  A -- ve vé -- rum cór -- pus,
  ná -- tum de Ma -- rí -- a Vír -- gi -- ne,
  Vé -- _ re pás -- sum, im -- mo -- lá -- tum
  in Crú -- ce pro hó -- _ _ mi -- ne_:
  Cú -- jus lá -- tus per -- fo -- rá -- tum,
  ún -- da flú -- xit
  sán -- gui -- ne_;
  Es -- to nó -- _ bis
  præ -- gus -- tá -- tum
  in mór -- tis __
  e -- xá -- _ _ mi -- ne.
  O dúl -- cis, o pí -- e, __
  o Jé -- su Fí -- li
  Ma -- rí -- _ æ_;
  mi -- se -- ré -- re mé -- i,
  mi -- se -- ré -- re mé -- _ _ i,
  mé -- i,
  mi -- se -- ré -- re mé -- i.
  -_i.
  A -- _ _ _ _ men. __
}


bass = \fixed c {
  \global
  g1 |
  d2 f ~ |
  4 es d2 ~ |
  2 g |
  f bes,4 bes ~ |
  4 a bes bes, |
  f4. es16 [ f ] g4 g, |
  d2 r4 es ~ |
  4 d es2 |
  bes,2. d4 ~ |
  4 c f2 |
  f, r4 c |
  g2 f ~ |
  4 bes, es4. 8 |
  d2 r4 c ~ |
  4 4 f2 |
  c4 bes,2 c4 |
  d e f2 |
  r r4 f ~ |
  4 es d2 ~ |
  4 bes, f4. 8 |
  bes,2 r4 es ~ |
  4 c g2 |
  c4 f2 d4 |
  bes,2 f |
  r4 c g2 |
  f4 4 2 ~ |
  4 4 bes,2 |
  r4 g, c2 |
  g r4 4 |
  d2 g,4 g |
  bes2. a4 |
  g2 f |
  2 g4. f8 |
  es2 d
  R1
  d4. f?8 es4. d8 |
  c2 d |
  g,4 d c bes, |
  a,2 g,4 d ~ |
  8 f? es4 d c |
  d es d2 |
  g,1 |
  2 c4. d8 |
  es [ f ] g4 es c |
  g1 ~ |
  1 |
}

bassVerseOne = \lyricmode {
  A -- ve vé -- rum cór -- pus,
  ná -- tum de __
  Ma -- rí -- a Vír -- _ _ gi -- ne,
  Vé -- re pás -- sum, im -- mo -- lá -- tum
  in Crú -- ce __
  pro hó -- mi -- ne_:
  Cú -- jus lá -- tus
  per -- fo -- rá -- _ tum,
  ún -- da flú -- xit
  sán -- gui -- ne_;
  Es -- to nó -- bis
  præ -- gus -- tá -- tum
  in mór -- tis
  e -- xá -- mi -- ne.
  O dúl -- cis, o pí -- e,
  o Jé -- su Fí -- li
  Ma -- rí -- _ _ æ_;
  mi -- se -- ré -- re mé -- i,
  mi -- se -- ré -- re mé -- i,
  mi -- se -- ré -- re mé -- _ _ _ i.
  -_i.
  A -- _ _ _ _ _ men. __
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

\tocItemComposer "Ave verum" "Byrd"
\score {
  \header {
    title = "AVE VERUM"
    composer = \byrd
  }
  \ChoeurPart
  \layout {\context{\Staff \RemoveAllEmptyStaves }}
  \midi {\tempo 4=70 }
}