\version "2.26.0"
\include "settings.ily"
\include "composers.ily"

global = {
  \autoBeamOff
  \mergeDifferentlyHeadedOn
  \mergeDifferentlyDottedOn
  \key es \major
  \time 4/4
}

soprano = \fixed c'' {
  \global
  as,8 es,8 f,8 f,8 c8 [ des ] c4 |\bar "||"
  c2 bes,4 as,4 |
  bes,2 c2 |
  r4 c4 bes,4 as,4 |
  g,2 as,4 c4 |
  bes,4 as,4 g,2 |
  f,4 as,4 g,8 f,4 e,8 |
  f,2 r8 g,4 g,8 |
  as,4 g,4 as,2 |
  R1 |
  r2 r4 as,4 |
  g,4 as,4 bes,8 [ as, ] as, [ g,16 f, ] |
  g,4 g,4 as,4 as,4 |
  bes,4 c4 bes,4 as,4 |
  g,4 as,4 bes,4 as,4 |
  g,4 f,4 r2 |
  g,2 as,4. g,8 |
  f,4 g,4. f,8 f,4~ |
  f,4 e,4 f,2 |\bar "||"
  \time 3/4
  c4 c4
  c4 es2
  d4 c4 c4
  b,4 c2 
  r4 c4 c4
  c4 es2 d4 |
  c4 c4 b,4 |
  c2 r4 |
  as,4 as,4 bes,4 |
  c2 bes,4 |
  as,4 as,4 bes,4 |
  c2 bes,4 |\bar "||"
  \time 4/4
  as,4 as,4 as,4 g,4 |
  as,2 c2 |
  c4 bes,4 bes,2 |
  bes,4 c4 es4 d4~ |
  d8 [ c ] c4. b,16 [ a, ] b,4 |
  c4 c8 [ bes, ] as, [ g,16 f, ] g,4~ |
  g,8 [ f, ] f,2 e,4 |
  f,1~ |
  f,1~ |
  f,1 |\bar "|."
}

sopranoVerseOne = \lyricmode {
  A -- ve Ma -- rí -- _ a, grá -- ti -- a plé -- na,
  grá -- ti -- a plé -- na, Dó -- mi -- nus té -- cum,
  Dó -- mi -- nus té -- cum, be -- ne -- díc -- ta tu in
  mu -- li -- é -- _ _ ri -- bus, et be -- ne -- díc -- tus
  frúc -- tus vén -- tris tú -- i, Jé -- _ _ _ _ sus Chrís -- _ tus.
  Sánc -- ta Ma -- rí -- a, má -- ter Dé -- i,
  sánc -- ta Ma -- rí -- a, má -- ter Dé -- i,
  ó -- ra pro nó -- bis, ó -- ra pro nó -- bis,
  pec -- ca -- tó -- ri -- bus nunc et in hó -- ra
  mór -- tis nó -- _ _ _ strae.
  A -- _ _ _ _ men. __
}


alto = \fixed c' {
  \global
  R1 |
  r2 r4 as4 |
  g4 f4 g4 c4 |
  r4 as4 g4 f4 |
  f4 e4 f4 as4 |
  g4 f2 e4 |
  f4 es4 es8 c8 c4 |
  c2 r8 es4 es8 |
  es4 es4 es2 |
  R1 |
  r2 r4 f4 |
  e4 f4 g8 [ f ] f4~ |
  f4 e4 f4 f4 |
  es4. f8 g [ f ] es4 |
  d4 es2 f8 [ es ] |
  d [ c ] c4 d4 f4~ |
  f8 e e4 f c~ |
  c4 es4 c2~ |
  c2  c2 |
  as4 g4 
  a4 bes2
  bes4 g4 as4 
  g4 g2
  r4 as4 g4
  a4 bes2 bes4
  g4 as4 g4
  g2 r4
  f4 f4 g4
  as2 g4
  f4 f4 g4
  as2 g4
  f4 f4 es4. es8
  es2 r4 as4
  as4 g4 f2
  g4 es2 bes4
  g2 g2
  g4. f8 es4. des8
  c1
  c1
  des1
  c1
}

altoVerseOne = \lyricmode {
  grá -- ti -- a plé -- na, grá -- ti -- a plé -- _ na,
  Dó -- mi -- nus té -- cum, Dó -- mi -- nus té -- cum,
  be -- ne -- díc -- ta tu in mu -- li -- é -- _ ri -- bus,
  et be -- _ _ ne -- díc -- tus frúc -- _ _ tus vén -- tris
  tú -- i, Jé -- sus Chrís -- tus. Sánc -- ta Ma -- rí -- a,
  má -- ter Dé -- i, sánc -- ta Ma -- rí -- a, má -- ter Dé -- i,
  ó -- ra pro nó -- bis, ó -- ra pro nó -- bis,
  pec -- ca -- tó -- ri -- bus nunc et in hó -- ra
  mór -- tis nó -- strae. A -- _ _ _ _ men, á -- men.
}


tenor = \fixed c'' {
  \global
  R1 |
  r2 r4 f,4 |
  es,4 d,4 e,2 |
  f,2 r2 |
  r2 f,4. c,8 |
  es,4 f,4 c,2 |
  r4 c,4 bes,,8 as,,8 g,,4 |
  a,,2 r8 bes,,4 bes,,8 |
  c,4 bes,,4 as,,4 c,4 |
  bes,,4 c,4 des,8 [ c, ] f,4~ |
  4 e, f,2 |
  r4 f,4 es,!4 f,4 |
  c,4. c,8 f,,4 r4 |
  r2 r4 as,,4 |
  bes,,4 c,4 bes,,4 c,4 |
  g,,4 as,,4 bes,,4 as,,4 |
  g,,2 f,,4 as,,4~ |
  as,,4 bes,,4 as,,4 g,,8 [ f,, ] |
  g,,2 a,, |
  f,4 e,4 
  f,4 g,2 
  f,4 es,4 f,4 
  d,4 e,2
  r4 f,4 e,4
  f,4 g,2 f,4
  es, f, d,
  e,2 r4
  c,4 c,4 es,4
  es,2 es,4
  c,4 c,4 es,4
  es,2 es,4
  c,4 des,4 c,4 bes,,4
  as,,2 r4 es,4
  es,4 es,2 d,4
  es,4. d,8 c,4 f,4~
  f,4 es,4 d,2
  es,2 c,4. bes,,8
  as,,4 g,,8 [ f,, ] g,,2
  a,,1
  bes,,1
  a,,1
}

tenorVerseOne = \lyricmode {
  grá -- ti -- a plé -- na, Dó -- mi -- nus té -- cum,
  Dó -- mi -- nus té -- cum, be -- ne -- díc -- ta tu in
  mu -- li -- é -- _ ri -- bus, in mu -- li -- é -- ri -- bus,
  et be -- ne -- díc -- tus frúc -- tus vén -- tris tú -- i,
  Jé -- sus Chrís -- _ _ tus. Sánc -- ta Ma -- rí -- a,
  má -- ter Dé -- i, sánc -- ta Ma -- rí -- a, má -- ter Dé -- i,
  O -- ra pro nó -- bis, o -- ra pro nó -- bis,
  pec -- ca -- tó -- ri -- bus nunc et in hó -- ra __ _ _
  mór -- tis nó -- strae.
  A -- _ _ _ _ men, á -- men.
}


bass = \fixed c' {
  \global
  R1*2
  r2 r4 c4 |
  bes,4 as,4 bes,2 |
  c2 r2 |
  R1 |
  r4 as,4 es,8 f,8 c,4 |
  f,2 r8 es,4 es,8 |
  as,4 es,4 as,,4 as,4 |
  g,4 as,4 bes,8 [ as, ] as, [ g,16 f, ] |
  g,4 g,4 f,2 |
  R1*2
  r4 as,4 bes,4 c4 |
  bes,4 as,4 g,4 as,4 |
  bes,4 as,4 g,4 f,4 |
  c,2 f,2~ |
  f,4 es,4 f,2 |
  c,2 f, |
  f,4 c4 
  f,4 es,2 
  bes,4 c4 f,4 
  g,4 c,2 
  r4 f,4 c4
  f,4 es,2 bes,4
  c4 f,4 g,4
  c,2 r4
  f,4 f,4 es,4
  as,2 es,4
  f,4 f,4 es,4
  as,2 es,4
  f,4 des,4 as,,4 es,4
  as,,2 as,2
  as,4 es,4 bes,2
  es,4 as,2 bes,4
  c2 g,2
  c,1~
  c,1
  f,1
  bes,,1
  <f, f,,>1
}

bassVerseOne = \lyricmode {
  grá -- ti -- a plé -- na, Dó -- mi -- nus té -- cum,
  be -- ne -- díc -- ta tu in mu -- li -- é -- _ _ ri -- bus,
  et be -- ne -- díc -- tus frúc -- tus vén -- tris tú -- i,
  Jé -- _ sus Chrís -- _ tus. Sánc -- ta Ma -- rí -- a,
  má -- ter Dé -- i, sánc -- ta Ma -- rí -- a má -- ter Dé -- i,
  ó -- ra pro nó -- bis, ó -- ra pro nó -- bis
  pec -- ca -- tó -- ri -- bus, nunc et in hó -- ra
  mór -- tis nó -- strae.
  A -- men, á -- men.
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

\tocItemComposer "Ave Maria" "Victoria"
\score {
  \header {
    title = "AVE MARIA"
    composer = \victoria
  }
  \ChoeurPart
  \layout {\context{\Staff \RemoveAllEmptyStaves }}
  \midi {\tempo 4=70 }
}
