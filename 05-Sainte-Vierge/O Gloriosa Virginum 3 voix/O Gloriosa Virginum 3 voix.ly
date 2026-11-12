\version "2.26.0"
\include "settings.ily"
global = {
  \key es \major
  \time 4/4
  \autoBeamOff
  \partial 2.
}

soprano = \fixed c' {
  \global
  es4 g as bes c' bes as g
  bes es'4 4 d' f'8[es']d'4 c' bes4 \breathe
  4 es' bes c'4 4 bes as g
  f g bes as g as f es2\bar "|."
}

alto = \fixed c' {
  \global
  es4 4 4 4 4 d es8[f] es4
  f g8[f]g[a]bes4 4 8[g] a4 bes4
  8[as]g4 g as4 8[g]f4 es8[f] es4
  d es4 4 4 4 4. d8 es2
}

bass = \fixed c {
  \global
  es4 c c g, as, bes, c8[d] es4
  d c c bes, d8[c] f4 8[es] d4 \breathe
  bes, c es as8[g]f[es]d4 c8[d]es4
  bes,4 es g, f, c f,8[g,]as,[bes,]es2
}

verseOne = \strophemode #1 ##f \lyricmode {
  O glo -- ri -- ó -- sa vir -- gí -- num,
  su -- blí -- mis in -- ter sí -- de -- ra,
  qui te cre -- á -- vit pár -- vu -- lum
  lac -- tén -- te nú -- tris ú -- be -- re.
}

verseTwo = \strophemode #2 ##t \lyricmode {
  Quod Hé -- va trís -- tis ábs -- tu -- lit,
  tu réd -- dis ál -- mo gér -- mi -- ne_;
  in -- trent ut ás -- tra flé -- bi -- les
  cǽ -- li re -- clú -- dis cár -- di -- nes.
}

verseThree = \strophemode #3 ##f \lyricmode {
  Tu Ré -- gis ál -- ti já -- nu -- a,
  et áu -- la lú -- cis fúl -- gi -- da_;
  ví -- tam dá -- tam per Vír -- gi -- nem,
  gén -- tes re -- dém -- ptæ, pláu -- di -- te.
}

verseFour = \strophemode #4 ##t \lyricmode {
  Jé -- su, tí -- bi sit gló -- ri -- a,
  qui ná -- tus est de Vír -- gi -- ne,
  cum Pá -- tr(e),_et ál -- mo Spí -- ri -- tu,
  in sem -- pi -- tér -- na sǽ -- cu -- la.
}

\tocItem \markup "O Gloriosa Virginum"
\score {
  \header {
    title = "O GLORIOSA VIRGINUM"
    composer = "Anonyme"
  }
  \new ChoirStaff \with {
    midiInstrument = "choir aahs"
  } <<
      \new Staff \with {
        instrumentName = \markup \center-column { "S." "A." }
        \consists Merge_rests_engraver
      } <<
        \new Voice = "soprano" { \voiceOne \soprano }
        \new Voice = "alto" { \voiceTwo \alto }
      >>
      \new Lyrics \with {
        \override VerticalAxisGroup.staff-affinity = #CENTER
      } \lyricsto "soprano" \verseOne
      \new Lyrics \with {
        \override VerticalAxisGroup.staff-affinity = #CENTER
      } \lyricsto "soprano" \verseTwo
      \new Lyrics \with {
        \override VerticalAxisGroup.staff-affinity = #CENTER
      } \lyricsto "soprano" \verseThree
      \new Lyrics \with {
        \override VerticalAxisGroup.staff-affinity = #CENTER
      } \lyricsto "soprano" \verseFour
      
      \new Staff \with {
        instrumentName = "H."
        \clef bass
      } \bass
    >>
    \layout {\context{\Staff \RemoveAllEmptyStaves}}
    \midi {\tempo 4=70 }
  }
