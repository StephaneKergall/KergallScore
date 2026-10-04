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
  <e g, c> |
  r4
  <<{\voiceTwo \oct{
    f4\mf g as |
    bes2 c'4 des' |}
    <c es>1 |
    <c e> |
    r4 \oct{f4\mp g as |
    bes2 c'4 des' |}
    <c' es>1 |
    <c' e> |
  }\\{\voiceOne
    as,2. |
    des1 |
    c'1~1 |
    r4 as,2. |
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
  <f,, as,, d,>-- 4-- 4-- 4-- |
  
}

left = \fixed c {
  \global
  \set Timing.beatStructure = #'(3 3 2)
  f8 as c' f as c' f as |
  f as des' f as des' f as |
  es as c' es as c' es as |
  e g c' e g c' e g |\break
  f8 as c' f as c' f as |
  f as des' f as des' f as |
  es as c' es as c' es as |
  e g c' e g c' e g |\break
  f8 as c' f as c' f as |
  f as des' f as des' as des' |
  es as c' es as c' es as |
  e g c' e g c' e g |\break
  f8 as c' f as c' f as |
  f as des' f as des' as des' |
  es as c' es as c' es as |
  e g c' e g c' e g |\pageBreak
  
  f8 as c' f as c' f as |
  f as des' f as des' as des' |
  es as c' es as c' as c' |
  e g c' e g c' e g |\break
  f8 as c' f as c' f as |
  f as des' f as des' as des' |
  es as c' es as c' es as |
  e g c' e g c' e g |\break
  f8 as c' f as c' f as |
  f as des' f as des' as des' |
  es as c' es as c' es as |
  e g c' e g c' e g |\break
  f8 as c' f as c' f as |
  f as des' f as des' as des' |
  es as c' es as c' es as |
  e g c' e g c' e g |\bar "||"
  <des f as>4-- 4-- 4-- 4-- |\pageBreak
  
  <des fes as>-- 4-- 4-- 4-- |
  <bes, es g>4-- 4-- 4-- 4-- |
  <bes, des g>4-- 4-- 4-- 4-- |
  <as, c es>-- 4-- 4-- 4-- |
  <as, ces es>-- 4-- 4-- 4-- |
  <f, bes, d>-- 4-- 4-- 4-- |
  <f, bes, d>-- 4-- 4-- 4-- |\break
  \set Timing.beatStructure = #'(4 4)
  \repeat unfold 2 {
    \repeat unfold 4 { bes,8 d } |
    \repeat unfold 4 { bes,8 des } |
  }
}

ClavierPart = \new PianoStaff \with {
  instrumentName = "Pian."
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
  }
  \ClavierPart
  \layout {\context{\Staff \RemoveAllEmptyStaves }}
  \midi {}
}
