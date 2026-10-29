\version "2.26.0"
\include "settings.ily"
\include "composers.ily"

global = {
  \autoBeamOff
  \mergeDifferentlyHeadedOn
  \mergeDifferentlyDottedOn
  \key g \major
  \time 3/4
}

soprano = \relative c'' {
  \global
  \repeat segno 2 {
    \repeat volta 2 {
      \bar ".|:"
      g4 a g |
      a2. |
      b2 d4 |
      4. c16 [ b ] a4 |
      b2 d4 |
      4. c16 [ b ] a4 |
      b2 c4 |
      b4 a2 |
      b2. |
      e |
      d4 2 |
      2. |\bar "|." \fine \break
      \alternative {
        \volta 1 {
          \time 2/2
          g,2 d'4 4 |
          e d c2 |
          b4 g a2 |
          g4 d' e2 |
          d c | 
          b4 g a4. g8 |
          fis4 e8 [ d ] e2 |
          fis1 |\break
        }
        \volta 2 {
          \time 2/2
          c'1 |
          a4 b4. a8 b [ c ] |
          d1 |
          g,4 c2 b4 |
          a2 g4 4 ~ |
          4 fis e2 |
          d4 d'4 4 4 |
          c2 b |
          e2. d4 |
          c8 b8 8 [ a16 g ] a2 |
          b4 d d d |
          c2 b4 d |
          d d c2 |
          b1 |
          d2 g,4. a8 |
          b4 a g fis |
          a2 2 |\bar ":|."
        }
      }
    }
  }
}

sopranoVerseOne = \lyricmode {
  Re -- gí -- na cǽ -- li,
  læ -- tá _ _ -- re,
  læ -- tá _ _ -- re,
  al -- le -- lú -- ja,
  al -- le -- lú -- ja.
  Quí -- a quem
  me -- ru -- í -- sti
  por -- tá -- re,
  quem me -- ru -- í -- sti
  por -- tá _ _ _ _ -- re.
  Re -- su -- ré _ _ _ -- xit
  sí -- cut dí -- xit,
  sí -- cut dí -- xit.
  O -- ra pro nó -- bis
  Dé -- um, al -- le -- lú _ -- ja.
  O -- ra pro nó -- bis,
  o -- ra pro nó -- bis,
  Dé _ _ _ -- um, al -- le -- lú -- ja.
}


alto = \fixed c' {
  \global
  g4 fis e |
  fis2. |
  g2 4 |
  fis4. g8 a4 |
  g2 4 |
  fis4. g8 a4 |
  g2 4 |
  4 fis2 |
  g2. |
  2. |
  4 fis2 |
  g2. |
  r2 g,2 |
  c4 d e fis |
  g2 fis4 4 |
  g fis g a |
  b g a e8 [ fis ] |
  g [ fis e d ] c [ d ] e4 ~ |
  8 [ d ] 2 cis4 |
  d1 |
  g1 |
  fis2 e |
  fis4 d4 2 |
  e2 fis4 g ~ |
  4 fis e2 |
  b, r |
  r2 r4 d |
  e fis g2 ~ |
  4 4 4. fis8 |
  a8 g g2 fis4 |
  g2 r4 d |
  e fis g4. fis16 [ e ] |
  d8 [ e fis d ] e4 fis |
  g2 e |
  fis4 d e d |
  2 4. 8 |
  e2 d |
}

altoVerseOne = \lyricmode {
  Re -- gí -- na cǽ -- li,
  læ -- tá _ _ -- re,
  læ -- tá _ _ -- re,
  al -- le -- lú -- ja,
  al -- le -- lú -- ja.
  Quí -- a quem
  me -- ru -- í -- sti,
  quí -- a quem me -- ru -- í -- sti
  por -- tá _ _ _ _ _ -- re.
  Re -- su -- ré -- xit,
  re -- su -- ré -- xit
  sí -- cut dí -- xit,
  O -- ra pro nó -- bis
  Dé -- um, al -- le -- lú _ -- ja.
  O -- ra pro nó _ _ _ -- bis,
  Dé _ -- um,
  al -- le -- lú -- ja,
  al -- le -- lú -- ja.
}


tenor = \relative c' {
  \global
  b4 d b |
  d d d |
  4. c8 d4 |
  a d2 |
  4. c8 b4 |
  a4 d2 |
  2 e4 |
  d4 4 4 |
  2. |
  c2. |
  b4 a2 |
  b2. |
  R1*2
  g2 d'4 4 |
  e d c2 |
  b a |
  g4 c a2 |
  b4 d a2 |
  d,1 |
  e'2. 4 |
  d2 g, |
  a4 b2 a4 |
  b a8 [ g ] d'2 |
  2 b4 e,8 [ fis ] |
  g [ a ] b2 a4 |
  b4 4 4 4 |
  a2 g |
  c2. b4 |
  c e d2 |
  g,1 |
  r2 r4 b |
  4 4 a2 |
  g g |
  a4 b c b8 [ a ] |
  g4 a b d ~ |
  8 [ cis16 b ] cis4 d2 |
}

tenorVerseOne = \lyricmode {
  Re -- gí -- na cǽ -- li,
  læ -- tá _ _ -- re,
  læ -- tá _ _ -- re,
  læ -- tá -- re,
  al -- le -- lú -- ja,
  al -- le -- lú -- ja.
  Quí -- a quem
  me -- ru -- í -- sti,
  quem me -- ru -- í -- sti
  por -- tá -- re.
  Re -- su -- ré _ -- xit
  sí -- cut dí _ _ -- xit,
  sí -- cut __ _ _ dí -- xit.
  O -- ra pro nó -- bis
  Dé -- um, al -- le -- lú -- ja.
  O -- ra pro nó -- bis,
  Dé -- um,
  al -- le _ _ -- lú _ _ _ -- ja.
}


bass = \fixed c {
  \global
  g4 d e |
  d2. |
  g,2 4 |
  d4. e8 fis4 |
  g2 g,4 |
  d4. e8 fis4 |
  g2 c4 |
  g, d2 |
  g,2. |
  c |
  g,4 d2 |
  g,2.
  R1*8
  c1 |
  d2 e |
  d4 g2 fis4 |
  e2 d ~ |
  2 e ~ |
  4 d c2 |
  b, r |
  R1*3
  r4 b4 4 4 |
  a2 g |
  R1
  r4 e e e |
  d2 c4 g ~ |
  4 fis g b |
  a2 d |
}

bassVerseOne = \lyricmode {
  Re -- gí -- na cǽ -- li,
  læ -- tá _ _ -- re,
  læ -- tá _ _ -- re,
  al -- le -- lú -- ja,
  al -- le -- lú -- ja.
  
  Re -- su -- ré -- xit
  sí -- cut dí -- xit, __
  sí -- cut dí -- xit.
  O -- ra pro nó -- bis,
  o -- ra pro nó -- bis
  Dé -- um, al -- le -- lú -- ja.
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

\tocItemComposer "Regina Cæli" "Aichinger"
\score {
  \header {
    title = "REGINA CÆLI"
    composer = \aichinger
  }
  \ChoeurPart
  \layout {\context{\Staff \RemoveAllEmptyStaves }}
  \midi {\tempo 2.=50 }
}
