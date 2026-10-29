\version "2.26.0"
\include "settings.ily"
\include "composers.ily"

global = {
  \autoBeamOff
  \mergeDifferentlyHeadedOn
  \mergeDifferentlyDottedOn
  \key bes \major
  \time 2/2
}

soprano = \fixed c {
  \global
  g'2 d''2
  d''1
  c''2 bes'2
  c''1
  a'1
  bes'2 f''2
  d''2 es''2
  d''2 c''2
  a'1
  a'1
  g'2 d''2
  d''1
  c''2 bes'2
  c''1
  a'1
  bes'2 f''2
  d''2 es''2
  d''2 c''2
  a'1
  bes'1
  g'2 a'2
  c''2 bes'2
  \time 3/2
  a'2 c''2 d''2
  \time 2/2
  d''1
  f''2 d''2
  d''1
  c''2 bes'2
  c''1
  a'2 <a' d''>2
  <g' d''>1 <d'' bes'>1 \bar "|."
}

alto = \fixed c {
  \global
  g'2 d'2
  g'1
  g'2 f'2
  g'1
  fis'
  g'2 a'2
  bes'2 g'2
  g'2 g'2
  fis'1 1
  g'2 d'2
  g'1
  g'2 f'2
  g'1
  fis'1
  g'2 a'2
  bes'2 g'2
  g'2 g'2
  fis'1
  d'1
  es'2 d'2
  g'2 f'2
  f'2 a'2 f'2
  f'1
  a'2 g'2
  fis'1
  g'2 f'2
  es'1
  d'2 d'2
  d'1
  d'1
}

tenor = \fixed c {
  \global
  g2 d'2
  d'1
  es'2 d'2
  c'1
  d'1
  bes2 c'2
  bes2 c'2
  bes2 c'2
  d'1
  d'1
  g2 d'2
  d'1
  es'2 d'2
  c'1
  d'1
  bes2 c'2
  bes2 c'2
  bes2 c'2
  d'1
  g1
  g2 f2
  g2 bes2
  c'1 bes2
  bes1
  c'2 bes2
  a1
  g2 bes2
  a2 g2
  fis2 f2
  g1 1
}

bass = \fixed c {
  \global
  g,2 d2
  g1
  c2 d2
  es1
  d1
  g2 f2
  g2 c2
  d2 es2
  d1
  d1
  g,2 d2
  g1
  c2 d2
  es1
  d1
  g2 f2
  g2 c2
  d2 es2
  d1
  g,1
  es2 f2
  es2 d2
  f1 bes,2
  1
  f2 g2
  d1
  es2 d2
  c1
  d2 d2
  g,1 1
}

verse = \lyricmode {
  Haec __ _ est cla -- ra di -- es, 
  cla -- ra -- rum cla -- ra die -- e -- rum.
  Haec __ _ est fes -- ta di -- es,
  fes -- ta -- rum fes -- ta di -- e -- rum.
  No -- bi -- le no -- bi _ -- li -- um,
  ru -- ti -- lans di -- a de -- ma, di -- e -- rum.
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
  } \lyricsto "soprano" \verse

  \new Staff \with {
    \consists Merge_rests_engraver
    \clef bass
  } <<
    \new Voice = "tenor" {\voiceOne \tenor }
    \new Voice = "bass" {\voiceTwo \bass }
  >>
>>

\tocItemComposer "Haec est clara dies" "Pierre de Corbeil"
\score {
  \header {
    title = "HAEC EST CLARA DIES"
    composer = \corbeil
  }
  \ChoeurPart
  \layout {\context{\Staff \RemoveAllEmptyStaves }}
  \midi {\tempo 2=70 }
}
