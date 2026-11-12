\version "2.26.0"
\include "settings.ily"
\include "composers.ily"

global = {
  \key g \major
  \time 4/4
  \autoBeamOff
  \tempo "Maestoso"
  \dynamicUp
}

soprano = \fixed c' {
  \global
  \bar".|:" d'2\f 4 4 g'4. d'8 2
  e'2 d'4 c' b2 a
  c'4 4 b4. 8 e'4. 8 d'2
  c'4 d' b(c')a2. r4\bar":|.|:"\break
  
  \repeat volta 3 {
    a2\mf 4 b g2 4 a b2 4 c' a2 b2
    4 a8 g d'4 8 8 4 e'8 fis' g'4 fis'8[e']
    d'4 c'8[b]a4 4 \bar "||"
  }
  \alternative {
    \volta 1,3 {g2. r4 \break}
    \volta 2 {
      g2. r4
      r4 g4 g fis e e'4 4 d' c'4 4 4 b a1~4
      g g a b b cis' d' e'(fis' g'2~4)
      4 fis' e' d' d' d' cis' d'2 r2\bar ":|."
    }
  }
}

alto = \fixed c' {
  \global
  d2 g4 fis g4. b8 2 2 a4 4 g2 fis
  g4 a g4. 8 4. a8 d2
  a4 4 g(a)fis2. r4
  
  fis2 4 4 e2 4 d4 2 g4 4 fis2 g2
  4 fis8 e d4 g8 a b4 c'8 d' e'4 d'8[c']
  b4 g g fis d2. r4 d2. r4
  
  r4 e e d c c'4 4 b a a a g
  fis4 4 4 e d d d c b, d e fis
  g(a b2~4) 4 a g fis b a a4  2 r2
}

tenor = \fixed c {
  \global
  b2 4 c' d'4. 8 2 g'2 d'4 4 2 2
  g4 d'4 4. 8  e'4. fis'8 g'2
  e'4 d'4 4(e') d'2. r4
  
  a2 d'4 4 b2 4 a g2 b4 e' d'2 2
  b4 c' d' c' b a g a b e' d'4 4
  b2. r4 4 4 4 a
  
  g1~1~4 fis g b d' r r2 R1
  r4 b b a g g'4 4 fis' e' a b cis' a d' fis' e' d'2 r2
  
}

bass = \fixed c {
  \global
  \clef bass
  g2 4 a b4. g8 2
  e fis4 d g2 d
  e4 fis g4. 8 c'4. 8 b2
  a4 fis g(c)d2. r4
  
  d2 4 b, e2 4 fis g2 e4 c d2 g2
  4 a b a g fis e fis g c d d g,2.
  
  r4 g,2. r4 R1*3 r4
  d4 d c b, b b a g g g fis e e'4 4 d' cis'
  cis d e fis g a a, d2 r2
}

verseAlto = \lyricmode {
  Tól -- li -- te hó -- sti -- as, et a -- do -- rá -- te
  Dó -- mi -- num in á -- tri -- o
  sánc -- to é -- jus.
  Læ -- tén -- tur cóe -- li,
  et e -- xúl -- tet tér -- ra
  a fá -- ci -- e Dó -- mi -- ni,
  quó -- ni -- am vé -- nit,
  al -- le -- lú -- ia. -_ia,
  al -- le -- lú -- ia,
  \repeat unfold 6 { al -- le -- lú -- ia, }
  al -- le -- lú -- ia. 
}

verseTenor = \lyricmode {
  \repeat unfold 47 \skip1
  al -- le -- lú -- ia,
}

verseBass = \lyricmode {
  \repeat unfold 33 \skip1
  quó -- ni -- am vé -- nit, al -- le -- lú -- ia,
  \repeat unfold 17 \skip1
  al -- le -- lú -- ia,
}

\tocItemComposer "Tollite Hostias" "Saint-Saëns"
\score {
  \header {
    title = "TOLLITE HOSTIAS"
    composer = \stsaens
  }
  \new ChoirStaff <<
    
    \new Staff \with {
      midiInstrument = "choir aahs"
      \consists Merge_rests_engraver
    }  <<
        \new Voice = "soprano" { \voiceOne \soprano }
        \new Voice = "alto" { \voiceTwo \alto }
    >>
    \new Lyrics \with {\override VerticalAxisGroup.staff-affinity = #CENTER
    } \lyricsto "alto" \verseAlto
    
    \new Staff = "downStaff" \with {
      midiInstrument = "choir aahs"
      \consists Merge_rests_engraver
  }  <<
        \new Voice = "tenor" { \voiceOne \tenor }
        \new Voice = "bass" { \voiceTwo \bass }
      >>
    \new Lyrics \with {
      \override VerticalAxisGroup.staff-affinity = #CENTER
      alignAboveContext = #"downStaff"
    } \lyricsto "tenor" \verseTenor
    \new Lyrics \with {\override VerticalAxisGroup.staff-affinity = #CENTER
    } \lyricsto "bass" \verseBass
  >>
  \layout {\context{\Staff \RemoveAllEmptyStaves}}
  \midi { \tempo 2=60 }
}
\markup \wordwrap {
  Prenez vos offrandes et adorez le Seigneur dans son sanctuaire.
  Que les Cieux se réjouissent, et que la Terre exulte devant la face du Seigneur,
  car Il vient. Alleluia.
}