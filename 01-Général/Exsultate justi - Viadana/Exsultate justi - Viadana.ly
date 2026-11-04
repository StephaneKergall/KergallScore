\version "2.26.0"
\include "settings.ily"
\include "composers.ily"

global = {
  \autoBeamOff
  \mergeDifferentlyHeadedOn
  \mergeDifferentlyDottedOn
  \key g \major
  \time 3/4
  \tempo "Vivace"
}

soprano = \relative c'' {
  \global
  g2 4 |
  2 a4 |
  b b d |
  c2 4 |
  b d c |
  b2 g4 |
  a2 b4 |
  a2 4 |
  \bar "||" \time 4/4
  b2 4 4 |
  c4 8 8 b4 c |
  d2 4 4 |
  e4 8 8 d4 a |
  2 b |
  c8 [ b c d ] e [ d c b ] |
  a4 b a4. 8 |
  b2 d4 4 |
  e4 8 8 d4 cis |
  d1 |
  r4 e4 8 [ d c b ] |
  a4 g2 fis4 |
  g d'2 4 |
  c4 8 8 b4 8 8 |
  a4 4 d d |
  c4 8 8 b4 8 8 |
  a2 g |
  r b ~ |
  4 a8 g a4 d,
  R1
  d'1 ~ |
  2 c4 b |
  a2 d, |
  r4 d'4 4 4 |
  c2 b |
  r2 r4 d |
  4 4 c2 |
  b r |
  r2 r4 a ~ |
  8 8 4 b8 [ c d b ] |
  c [ d e a, ] b [ c d b ] |
  cis4 d2 cis4 |
  d1 |
  r2 4 4 |
  c4 8 8 b2 |
  a4 4 g g |
  fis b2 g4 |
  fis2 e |
  fis r
  R1
  r2 d'4 4 |
  c4 8 8 b2 |
  a r |
  b2. 4 |
  a4 8 8 g2 |
  fis r4 d' |
  b4 8 8 4 a |
  g2 4 d' |
  b4 8 8 4 a |
  g8 [ a b c ] d2 |
  4 4 4 8 c |
  b2 a ~ |
  4 g4 2 ~ |
  4 fis8 [ e ] fis2 |
  g1 |
  \bar "||" \time 3/4
  2 4 |
  2 a4 |
  b4 4 d |
  c2 4 |
  b d c |
  b2 g4 |
  a2 b4 |
  a2 4 |
  \bar "||" \time 4/4
  b1 |
  c | b |
  a2. 4 |
  g1 |\bar "|."
}

sopranoVerseOne = \lyricmode {
  Ex -- sul -- tá -- te jús -- ti
  in Dó -- mi -- no,
  réc -- tos dé -- cet
  col -- lau -- dá -- ti -- o.
  Con -- fi -- té -- mi -- ni
  Dó -- mi -- no,
  con -- fi -- té -- mi -- ni
  Dó -- mi -- no,
  in cí -- _ _ _ _ tha -- ra,
  con -- fi -- té -- mi -- ni
  Dó -- mi -- no,
  in cí -- _ _ tha -- ra_;
  in psal -- té -- ri -- o
  dé -- cem chor -- dá -- rum,
  in psal -- té -- ri -- o
  dé -- cem chor -- dá -- rum,
  psál -- li -- te íl -- li,
  psál -- li -- te íl -- li.
  Cán -- ta -- te é -- i,
  cán -- ta -- te é -- i,
  cán -- ti -- cum nó -- _ _ _ _ _ vum_;
  bé -- ne psál -- li -- te é -- i
  in vo -- ci -- fe -- ra -- ti -- ó -- _ ne,
  bé -- ne psál -- li -- te é -- i,
  bé -- ne psál -- li -- te é -- i
  in vo -- ci -- fe -- ra -- ti -- ó -- ne,
  in vo -- ci -- fe -- ra -- ti -- ó -- _ ne,
  in vo -- ci -- fe -- ra -- _ ti -- ó -- _ _ ne.
  Ex -- sul -- tá -- te jús -- ti
  in Dó -- mi -- no,
  réc -- tos dé -- cet
  col -- lau -- dá -- ti -- o,
  col -- lau -- dá -- ti -- o.
}


alto = \fixed c' {
  \global
  d2 4 |
  e2 fis4 |
  g g fis |
  a2 e4 |
  g g e |
  g fis e |
  2 g4 |
  fis2 4 |
  g2 4 4 |
  4 8 8 4 4 |
  fis2 g4 4 |
  4 8 8 4 e |
  fis2 g |
  e8 [ d e fis ] g4 e |
  fis g2 fis4 |
  g2 4 4 |
  4 8 8 4 4 |
  fis2 g |
  e8 [ d e fis ] g4 e |
  fis d4 4. 8 |
  d1 |
  r2 d4 g |
  e4 8 8 d4 g8 8 |
  e4 4 d g |
  e4 8 8 d4 8 8 |
  e2 g |
  r r4 g ~ |
  4 fis8 e d2 |
  2 r4 g ~ |
  4 fis8 e fis4 g ~ |
  4 fis8 [ e ] fis2 |
  g1 |
  r4 4 4 4 |
  e2 d |
  r r4 g4 |
  4 4 2 |
  2 fis ~ |
  2 g |
  e g ~ |
  4 fis e2 |
  fis2 4 4 |
  g4 8 e fis4 d |
  r2 g4 4 |
  fis4 8 8 e4 4 |
  d4 8 8 4 e ~ |
  8 d8 2 cis4 |
  d2 fis4 4 |
  g4 8 e fis4 g |
  a2 r |
  r g4 4 |
  fis4 8 8 e2 |
  d4 g2 4 |
  fis4 8 8 e2 |
  d r |
  d1 |
  2 4 fis |
  d2 2 |
  2 2 |
  r4 b,4 4 8 a, |
  g,4 g e2 |
  d4 4 4 8 8 |
  4 4 2 |
  1 |
  2 4 |
  e2 fis4 |
  g4 4 fis |
  a2 e4 |
  g4 4 e |
  g fis e |
  e2 g4 |
  fis2 4 |
  g1 |
  1 ~ |
  2 fis |
  e2. 4 |
  d1 |
}

altoVerseOne = \lyricmode {
  Ex -- sul -- tá -- te jús -- ti
  in Dó -- mi -- no,
  réc -- tos dé -- _ cet
  col -- lau -- dá -- ti -- o.
  Con -- fi -- té -- mi -- ni
  Dó -- mi -- no,
  con -- fi -- té -- mi -- ni
  Dó -- mi -- no,
  in cí -- _ _ _ _ tha -- ra,
  con -- fi -- té -- mi -- ni
  Dó -- mi -- no,
  in cí -- _ tha -- ra,
  in cí -- tha -- ra_;
  in psal -- té -- ri -- o
  dé -- cem chor -- dá -- rum,
  in psal -- té -- ri -- o
  dé -- cem chor -- dá -- rum,
  psál -- li -- te íl -- li,
  psál -- li -- te íl -- _ _ _ li.
  Cán -- ta -- te é -- i,
  cán -- ta -- te é -- i,
  cán -- ti -- cum nó -- _ _ vum_;
  bé -- ne psál -- li -- te é -- i,
  bé -- ne psál -- li -- te é -- i
  in vo -- ci -- fe -- ra -- ti -- ó -- _ ne,
  bé -- ne psál -- li -- te é -- _ i,
  bé -- ne psál -- li -- te é -- i,
  bé -- ne psál -- li -- te é -- i
  in vo -- ci -- fe -- ra -- ti -- ó -- ne,
  in vo -- ci -- fe -- ra -- ti -- ó -- ne,
  in vo -- ci -- fe -- ra -- ti -- ó -- ne.
  Ex -- sul -- tá -- te jús -- ti
  in Dó -- mi -- no,
  réc -- tos dé -- _ cet
  col -- lau -- dá -- ti -- o,
  col -- lau -- dá -- ti -- o.
}


tenor = \relative c' {
  \global
  b2 4 |
  2 d4 |
  4 4 4 |
  e2 c4 |
  d b c |
  d2 e4 |
  c2 d4 |
  d2 4 |
  2 4 4 |
  e4 8 8 d4 e |
  a,2 b4 4 |
  c4 8 8 b4 cis |
  d2 g, |
  c1 |
  d |
  g,2 b4 4 |
  c4 8 8 b4 g |
  a2 b |
  c8 [ b c d ] c4 g |
  d' b a4. 8 |
  g2 r |
  r g4 4 |
  a4 8 8 b4 8 8 |
  c4 4 g g |
  a4 8 8 b4 8 8 |
  c2 d |
  2. c8 b |
  a4 4 b2 ~ |
  2 a4 g |
  a b a d ~ |
  4 c8 b a2 |
  b1 |
  r4 e4 d d |
  c2 b |
  r2 r4 c |
  d d e2 |
  d2 2 ~ |
  4 4 2
  R1
  r2 a |
  2 d4 4 |
  c4 8 8 b2 |
  a4 4 g8 [ a b c ] |
  d4 d, e8 [ fis g b ] |
  b2 g4 e |
  fis4. g8 a2 |
  d,1 |
  r2 d'4 4 |
  c4 8 8 b2 |
  a r
  R1
  r4 d2 4 |
  4 8 8 b2 ~ |
  2 a |
  r2 r4 d, |
  g4 8 8 4 a |
  b2 g4 d |
  g4 8 8 4 a |
  b4. c8 d2 |
  2 c |
  b2 4 4 |
  a b a2 |
  g1 |
  b2 4 |
  2 d4 |
  4 4 4 |
  e2 c4 |
  d b c |
  d2 e4 |
  c2 d4 |
  d2 4 |
  1 |
  e ~ |
  2 d |
  c2. 4 |
  b1 |
}

tenorVerseOne = \lyricmode {
  Ex -- sul -- tá -- te jús -- ti
  in Dó -- mi -- no,
  réc -- tos dé -- cet
  col -- lau -- dá -- ti -- o.
  Con -- fi -- té -- mi -- ni
  Dó -- mi -- no,
  con -- fi -- té -- mi -- ni
  Dó -- mi -- no,
  in cí -- tha -- ra,
  con -- fi -- té -- mi -- ni
  Dó -- mi -- no,
  in cí -- _ tha -- ra,
  in cí -- tha -- ra_;
  in psal -- té -- ri -- o
  dé -- cem chor -- dá -- rum,
  in psal -- té -- ri -- o
  dé -- cem chor -- dá -- rum,
  psál -- li -- te íl -- li,
  psál -- li -- te íl -- _ li,
  psál -- li -- te íl -- li.
  Cán -- ta -- te é -- i,
  cán -- ta -- te é -- i,
  cán -- ti -- cum nó -- vum_;
  bé -- ne psál -- li -- te é -- i
  in vo -- _ ci -- fe -- _ ra -- ti -- ó -- _ _ ne,
  bé -- ne psál -- li -- te é -- i,
  bé -- ne psál -- li -- te é -- i
  in vo -- ci -- fe -- ra -- ti -- ó -- ne,
  in vo -- ci -- fe -- ra -- ti -- ó -- _ _ ne,
  in vo -- ci -- fe -- ra -- ti -- ó -- ne.
  Ex -- sul -- tá -- te jús -- ti
  in Dó -- mi -- no,
  réc -- tos dé -- cet
  col -- lau -- dá -- ti -- o,
  col -- lau -- dá -- ti -- o.
}


bass = \fixed c {
  \global
  g2 4 |
  e2 d4 |
  g g b |
  a2 4 |
  g g a |
  b2 c'4 |
  a2 g4 |
  d2 4 |
  g,2 g4 4 |
  c4 8 8 g4 e |
  d2 g4 4 |
  c4 8 8 g4 a |
  d2 r
  R1*2
  r2 g4 4 |
  c4 8 8 g4 e |
  d2 g, |
  c1 |
  d |
  g,2 g4 4 |
  a4 8 8 b4 8 8 |
  c'4 4 g g |
  a4 8 8 b4 8 8 |
  c'2 g |
  r2 g ~ |
  4 fis8 e d2 |
  2 g ~ |
  2 fis4 e |
  d1 ~ |
  1 |
  g, |
  r4 c g g |
  c2 g |
  r r4 c |
  g g c'2 |
  g d ~ |
  2 g |
  a g |
  a1 |
  d
  R1*5
  r2 d'4 4 |
  c'4 8 8 b2 |
  a2 r |
  r g4 4 |
  d'4 8 8 c'2 |
  g2 4 4 |
  d4 8 8 e2 |
  b, d |
  g4 8 8 4 a |
  b2 g4 d |
  g4 8 8 4 a |
  b2 g4 d |
  b,4 8 a, g,2 ~ |
  2 a, |
  b,2. c4 |
  d1 |
  g, |
  g2 4 |
  e2 d4 |
  g4 4 b |
  a2 4 |
  g4 4 a |
  b2 c'4 |
  a2 g4 |
  d2 4 |
  g,1 |
  c2. d4 |
  e2 b, |
  c2. 4 |
  g,1 |
}

bassVerseOne = \lyricmode {
  Ex -- sul -- tá -- te jús -- ti
  in Dó -- mi -- no,
  réc -- tos dé -- cet
  col -- lau -- dá -- ti -- o.
  Con -- fi -- té -- mi -- ni
  Dó -- mi -- no,
  con -- fi -- té -- mi -- ni
  Dó -- mi -- no,
  con -- fi -- té -- mi -- ni
  Dó -- mi -- no,
  in cí -- tha -- ra_;
  in psal -- té -- ri -- o
  dé -- cem chor -- dá -- rum,
  in psal -- té -- ri -- o
  dé -- cem chor -- dá -- rum,
  psál -- li -- te íl -- li,
  psál -- li -- te íl -- li.
  Cán -- ta -- te é -- i,
  cán -- ta -- te é -- i,
  cán -- ti -- _ cum nó -- vum_;
  bé -- ne psál -- li -- te é -- i,
  bé -- ne psál -- li -- te é -- i,
  bé -- ne psál -- li -- te é -- i
  in vo -- ci -- fe -- ra -- ti -- ó -- ne,
  in vo -- ci -- fe -- ra -- ti -- ó -- ne,
  in vo -- ci -- fe -- ra -- ti -- ó -- _ _ ne.
  Ex -- sul -- tá -- te jús -- ti
  in Dó -- mi -- no,
  réc -- tos dé -- cet
  col -- lau -- dá -- ti -- o,
  col -- _ _ lau -- dá -- ti -- o.
}

\paper {
  page-count = 3
  systems-per-page = 4
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

\tocItemComposer "Exsultate justi" "Viadana"
\score {
  \header {
    title = "EXSULTATE JUSTI"
    composer = \viadana
  }
  \ChoeurPart
  \layout {\context{\Staff \RemoveAllEmptyStaves }}
  \midi {\tempo 2.=55 }
}
