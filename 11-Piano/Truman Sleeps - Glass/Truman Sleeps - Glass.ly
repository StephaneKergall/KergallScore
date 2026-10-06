\version "2.26.0"
\include "settings.ily"
\include "composers.ily"

global = {
  \mergeDifferentlyHeadedOn
  \mergeDifferentlyDottedOn
  \key as \major
  \time 2/2
  \set Timing.beamExceptions = #'()
  \set Timing.beatBase = #1/8
  \set Timing.beatStructure = #'(4 4)
  \tempo 2=56
  \dynamicUp
}

right = \fixed c'' {
  \global
  R1*8
  \oct {
    r4 f\mf ( g as |
    bes2 c'4 des' |
    c'1 ~ |
    1 ) |
    r4 f\f ( g as |
    bes2 c'4 des' |
    es'1  |
    e' ) |
  }
  r4 <c as>\mf ( <bes, g> <as, f> )|
  1 |
  <es, c es> |
  <e, c e> |
  r4 <c as>\f ( <bes, g> <as, f> )|
  1 |
  <es, as, c> |
  <e, g, c> |
  r4
  <<{\voiceTwo \oct{
    f4 g as |
    bes2 c'4 des' |}
    <c es>1 |
    <c e>  |
    r4 \oct{f4  g as |
    bes2 c'4 des' |}
    <c' es>1 |
    <c' e> |
  }\\{\voiceOne
    as,2.^\mf  |
    des1 |
    c'1~1 |
    r4 as,2.^\mp  |
    des1 |
    es'1 e'1 
  }>>
  <des, f,>4-- 4-- 4-- 4-- |
  <des, fes,>4-- 4-- 4-- 4-- |
  <bes,, es,>4-- 4-- 4-- 4-- |
  <bes,, des,>4-- 4-- 4-- 4-- |
  <as,, c, es,>-- 4-- 4-- 4-- |
  <as,, ces, es,>-- 4-- 4-- 4-- |
  <f,, bes,, d,>-- 4-- 4-- 4-- |
  <f,, as,, d,>-- 4-- 4-- 4-- |\clef bass
  \repeat unfold 12 { f,,8 as,, }
  \repeat unfold 4 { fes,,8 as,, }\clef treble
  r2 \oct{ as'4 ( g' |
  f'1 ) |
  r2 des'4 ( c' |
  bes1\fermata ) }\bar "|."
}

left = \fixed c {
  \global
  \set Timing.beatStructure = #'(3 3 2)
  f8\mp\sustainOn \< as c' f as c' f as |
  f as des' f as des' f as |
  es\! as c' es as c' es as |
  e\> g c' e g c' e g |
  f8\< as c' f as c' f as |
  f as des' f as des' f as |
  es\! as c' es as c' es as |
  e\> g c' e g c' e g |
  f8_\< as c' f as c' f as |
  f as des' f as des' as des' |
  es\! as c' es as c' es as |
  e_\> g c' e g c' e g |
  f8\< as c' f as c' f as |
  f as des' f as des' as des' |
  es\! as c' es as c' es as |
  e\> g c' e g c' e g |
  
  f8\< as c' f as c' f as |
  f as des' f as des' as des' |
  es\! as c' es as c' as c' |
  e\> g c' e g c' e g |
  f8\< as c' f as c' f as |
  f as des' f as des' as des' |
  es\! as c' es as c' es as |
  e\> g c' e g c' e g |
  f8\< as c' f as c' f as |
  f as des' f as des' as des' |
  es\! as c' es as c' es as |
  e\> g c' e g c' e g |
  f8\< as c' f as c' f as |
  f as des' f as des' as des' |
  es\! as c' es as c' es as |
  e\> g c' e g c' e g |\bar "||"
  <des f as>4--\!\f 4-- 4-- 4-- |
  
  <des fes as>--\> 4-- 4-- 4-- |
  <bes, es g>4--\f 4-- 4-- 4-- |
  <bes, des g>4--\< 4-- 4-- 4-- |
  <as, c es>--\sf 4-- 4--\> 4-- |
  <as, ces es>-- 4-- 4-- 4-- |
  <f, bes, d>--\mf\< 4-- 4-- 4-- |
  <f, bes, d>--\> 4-- 4-- 4-- |
  \set Timing.beatStructure = #'(4 4)
  \repeat unfold 2 {
    bes,8\< d \repeat unfold 3 { bes, d } |
    bes,\> des! bes, des bes, des bes, des\! |
  }
  <bes, des! f>\mp\< as
  \repeat unfold 3 { <bes, des f> as }
  \repeat unfold 4 { <des f> as }
  <bes, des f>\mf as \repeat unfold 3 { <bes, des f> as }
  <des fes!>\mp as
  \repeat unfold 2 { <des fes> as } <des fes> as\fermata
}

ClavierPart = \new PianoStaff \with {
  instrumentName = "Piano"
  midiInstrument = "acoustic grand"
} <<
  \new Staff = "right" { \right }
  \new Staff = "left" { \clef bass \left }
>>

\tocItemComposer "Truman Sleeps" "Glass"
\score {
  \header {
    title = "TRUMAN SLEEPS"
    composer = \glass
    poet = "The Truman Show (1998)"
  }
  \ClavierPart
  \layout {\context{\Staff \RemoveAllEmptyStaves }}
  \midi {}
}
