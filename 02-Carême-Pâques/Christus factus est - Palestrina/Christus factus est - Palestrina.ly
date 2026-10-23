\version "2.26.0"
\include "settings.ily"
\include "composers.ily"

global = {
  \autoBeamOff
  \mergeDifferentlyHeadedOn
  \mergeDifferentlyDottedOn
  \key f \major
  \time 4/4
  \tempo "Adagio"
}

soprano = \fixed c {
  \global
  a'1
  a'2 bes'2 ~
  bes'4 a'4 g'2
  c''2 bes'2
  a'2 a'2
  a'2. a'4
  a'2 bes'2 ~
  bes'2 a'2
  c''2 bes'4. a'8
  g'4 a'4 g'2
  a'1
  f'2 g'2
  a'2. b'4
  c''4 c'8 [ d' ] e' [ f' ] g'4
  g'4 a'4 g'2
  a'1
  g'2. g'4
  g'4 g'4 a'2
  a'2 bes'4. bes'8
  bes'4 c''4 bes'2
  a'2 r4 c''4
  b'4. c''8 a'4 a'4
  g'2 g'2
  r4 a'4 a'4 g'4 ~
  g'4 a'4 bes'4 c''4
  bes'2 a'4. g'16 [ f'16 ]
  g'2 a'2\bar "|."
}

sopranoVerseOne = \lyricmode {
  Chris -- tus fac -- tus est pro no -- bis
  o -- be -- di -- ens us -- que
  ad mor _ _ _ _ -- tem,
  mor -- tem au _ -- tem
  cru _ _ _ _ _ -- cis.
  Prop -- ter quod et De -- us
  e -- xal -- ta -- vit il -- lum,
  et de -- dit il -- li no -- men
  quod et su -- per
  om -- ne no _ _ _ -- men.
}

alto = \fixed c {
  \global
  f'1
  f'2 g'2 ~
  g'4 f'4 e'!2 ~
  e'4 fis'4 g'2
  c'2 f'!2
  e'2. e'4
  fis'2 g'2 ~
  g'2 f'!2
  e'4 f'2 g'4 ~
  g'4 f'2 e'4
  f'1
  d'2. e'4
  f'1
  e'4. d'8 c'8[ d'8 e'8 f'8]
  g'4 f'2 e'4
  f'1
  e'2. e'4
  e'4 e'4 f'2
  fis'2 g'4. g'8
  g'4 a'4 f'!2
  f'2 r4 a'4
  g'4 g' f' f'
  e'2 e'
  r4 f' f' e' ~
  4 f' g' a'
  f'4 g'4. f'8 4 ~
  4 e'4 f'2
}

altoVerseOne = \lyricmode {
  Chris -- tus fac -- tus est
  pro no -- bis o -- be -- di -- ens
  us -- que ad mor -- _ _ _ tem,
  mor -- tem au -- tem __ _
  cru -- _ _ _ cis.
  Prop -- ter quod et De -- us
  e -- xal -- ta -- vit il -- lum,
  et de -- dit il -- li no -- men
  quod et su -- per om -- ne no _ _ _ _ -- men.
}

tenor = \fixed c {
  \global
  c'1
  c'2 es'2 ~
  es'4 c'4 c'2
  r4 c'4 d'4. e'!8
  f'2 f'4 d'4
  d'4 cis'8[ b!8] cis'4 4
  d'1 ~
  d'2 c'!2 ~ 
  2 d'4 d'4
  c'1
  c'1
  r4 bes2 4
  c'2 f2
  g1
  c'1
  c'1
  c'2. c'4
  c'4 c'4 c'2
  d'2 4. 8
  d'4 f'4 d'2
  c'2 r4 f'4
  d'4 e'4 c'4 c'4
  c'2 c'2
  r4 c'4 c'2
  c'4. 8 d'4 f'4
  d'2 c'2 ~
  2 2
}

tenorVerseOne = \lyricmode {
  Chris -- tus fac -- tus est
  pro no _ _ -- bis o -- be _ _ -- di -- ens
  us -- que ad mor -- tem, mor -- tem
  au _ -- tem cru -- cis.
  Prop -- ter quod
  et De -- us e -- xal -- ta -- vit il -- lum,
  et de -- dit il -- li no -- men
  quod et su -- per
  om -- ne no _ -- men.
}

bass = \fixed c {
  \global
  f1
  f2 es2 ~
  4 f4 c'4 c'4 ~
  8 [ bes ] a4 g2
  f2 d2
  a2. a4
  d2 g2 ~
  2 a2 ~
  2 bes
  c'1
  f1
  bes2 g
  f d'
  c'1 ~ 1
  f
  c'2. c'4
  c'4 c'4 f2
  d2 g4. 8
  g4 f bes2
  f2 r4 f4
  g4 e4 f4 f4
  c'2 c'
  r4 f f c' ~
  4 a4 g4 f4
  bes2 c' ~
  c' f
}

bassVerseOne = \lyricmode {
  Chris -- tus fac -- tus est
  pro __ _ no -- bis o -- be -- di ens
  us -- que ad mor -- tem,
  mor -- tem au -- tem cru -- cis.
  Prop -- ter quod et De -- us
  e -- xal -- ta -- vit il -- lum,
  et de -- dit il -- li no -- men
  quod et su -- per
  om -- ne no _ -- men.
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

\tocItemComposer "Christus factus est" "Palestrina"
\score {
  \header {
    title = "CHRISTUS FACTUS EST"
    composer = \palestrina
  }
  \ChoeurPart
  \layout {\context{\Staff \RemoveAllEmptyStaves }}
  \midi {}
}
