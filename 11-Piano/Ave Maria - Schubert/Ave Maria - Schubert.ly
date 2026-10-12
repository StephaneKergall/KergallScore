\version "2.26.0"
\include "settings.ily"
\include "composers.ily"
#(set-global-staff-size 18.3)


global = {
    \key bes \major
    \time 2/4
    \tempo "Lento"
}

sopranoVoice = \fixed c' {
    \global
    \autoBeamOff
    \tupletUp
    R1*2 \bar ".|:" bes4. a16 bes d'4..(c'16) bes4 r
    c'4  \grace {d'16[c']} bes[a] g[a] bes4 r8 d'
    d'8. c'32[bes] a16[g] d' e' d'8. [ 16 ] cis'8.
    a16 c'8. bes16 \tuplet 6/4 {a[c'] d' es' [c' a ] }
    bes4.
    d'16[c'] c'8. [ a16 ] \tuplet 6/4 {g[b ] d' f' [ d' b ] } c'4 ~
    \tuplet 6/4 {16 g a bes [ \grace{c'32 [ bes ] }  a16 ] g}
    f4 r8 f16 16
    c'8. 16 16. [ b32 ] c'16. [ d'32 ] c'16. [ d'32 ] bes8 r
    bes c'8. 16 \tuplet 6/4 {c' [ b c' es' d' c' ] } bes4 r8
    bes8  c'8. 16 d'16. 32 \tuplet 3/2 {d'16 [ c' ] d' } \acciaccatura f' es'8 8 r
    g16 16 \acciaccatura d' c'8. 16 \tuplet 6/4 {bes [a bes des' c' bes]} c'4. r8
    bes4. a16 bes d'4..(c'16) bes4 r4 r2 R1*2 r2 \bar "|."
}

verseOne = \strophemode 1 ##f 2 \lyricmode {
    A4. -- ve16 Ma16 -- |
    ri2 -- |
    a,4 \skip 4 |
    Gra4 -- \grace { ti8 -- } a8 -- ple8 -- |
    na,4 \skip 8 Ma8 -- |
    ri8. -- a16 Gra8 -- ti16 -- a16 |
    ple4 -- na,8. Ma16 -- |
    ri8. -- a16 \tuplet 6/4 { Gra8 -- ti16 -- a8 ple16 -- } |
    na,4. A8 -- |
    ve,4 \tuplet 6/4 { A8 -- ve_!16 Do8 -- mi16 -- } |
    nus,4 \tuplet 6/4 { \skip 16 Do16 -- mi16 -- nus8 te16 -- } |
    cum,4 \skip 8 be16 -- ne16 -- |
    dic8. -- ta16 tu16. in32 mu16. -- li32 -- |
    e16. -- ri32 -- bus,8 \skip 8 et8 |
    be8. -- ne16 -- dic4 -- |
    tus,4 \skip 8 et8 |
    be8. -- ne16 -- dic16. -- tus32 \tuplet 3/2 { fruc8 -- tus16 } |
    \grace { ven16 -- } \skip 8 tris,8 \skip 8 ve,16 -- tris16 |
    \grace { tu16 -- } \skip 8. i,16 Je4 -- |
    sus.4. \skip 8 |
    A4. -- ve16 Ma16 -- |
    ri2 -- |
    a_!4 \skip 4 |
}

verseTwo = \strophemode 2 ##t 2 \lyricmode {
  A4. -- ve16 Ma -- ri2 -- a,2
  Ma4 -- ter8 De -- i,4.
  O8 -- ra8. pro16 no -- bis pec -- ca -- to8. -- ri16 -- bus,8.
  o16 -- ra,8. o16 -- \tuplet 6/4 {ra8 pro16 no8.} -- bis,4.
  o8 -- ra,8. o16 -- \tuplet 6/4{ra8 pro16 no8.} -- bis4
  \tuplet 6/4 {\skip16 pec16 -- ca -- to8 -- ri16} -- bus,4.
  nunc8 et8. in16 ho8 -- ra mor -- tis,4
  in8 ho8. -- ra16 \tuplet 6/4 {mor8 -- tis16 nos8.} -- træ,4.
  in8 ho8. -- ra16 mor16. -- tis,32
  \tuplet 6/4 {mor8 -- tis16 } nos8 -- træ,8
  \skip8. in16 ho8. -- ra16 \tuplet 6/4 {mor8 -- tis16 nos8.} -- træ2
  A4. -- ve16 Ma16 -- 
    ri2 -- 
    a_!4 \skip 4 
}

arpegeSimple = #(define-music-function
    (parser location n1 n2 n3 n4)
    (ly:music? ly:music? ly:music? ly:music?)
    #{
        \times 4/6 {
            < $n1 $n2 >16
            < $n2 $n3 >
            < $n3 $n4 >
            < $n2 $n3 >
            < $n1 $n2 >
        }
    #})

arpegePiano = #(define-music-function
  (parser location n1 n2 n3 n4)
  (ly:music? ly:music? ly:music? ly:music?)
  #{
     \times 4/6 { r16}
     \arpegeSimple $n1 $n2 $n3 $n4
  #})

arpegeFin = #(define-music-function
  (parser location n1 n2 n3 n4)
  (ly:music? ly:music? ly:music? ly:music?)
  #{
      \times 4/6 { r16}
      \change Staff = "left"
      \arpegeSimple $n1 $n2 $n3 $n4
      \change Staff = "right"
  #})


right = \fixed c' {
    \global
    \override TupletNumber.transparent = ##t
    \override TupletBracket.transparent = ##t
    \repeat unfold 2 {\arpegePiano d f bes d'}
    \arpegePiano f bes d' f'
    \arpegePiano as d' f' as'
    \arpegePiano g bes es' g'
    \arpegePiano ges a es' ges'
    \arpegePiano f bes d' f'
    \arpegePiano d f bes d'

    \arpegePiano d f bes d'
    \arpegePiano d e bes d'
    \arpegePiano d f bes d'
    \arpegePiano es a c' es'
    \repeat unfold 2 {\arpegePiano d g bes d'}
    \arpegePiano es g c' es'
    \arpegePiano es f a c'
    \arpegePiano d f bes d'
    \arpegePiano d f bes d'
    \arpegePiano d fis bes d'
    \arpegePiano d g bes d'
    \arpegePiano e g bes d'
    \arpegePiano e g a cis'
    \arpegePiano es a c' es'
    \arpegePiano es a c' es'
    \arpegePiano d g bes d'
    \arpegePiano d e bes d'
    \arpegePiano c f a c'
    \arpegePiano f g b f'
    \arpegePiano f a c' f'
    \arpegePiano e bes c' e'
    \arpegePiano f a c' f'
    \arpegePiano f a c' f'
    \arpegePiano es a c' f'
    \arpegePiano es a c' f'
    \arpegePiano d bes d' f'
    \arpegePiano d bes d' f'
    \arpegePiano es a c' f'
    \arpegePiano es a c' f'
    \arpegePiano d g bes d'
    \arpegePiano bes, d g bes
    \arpegePiano c f a c'
    \arpegePiano d fis a d'
    \arpegePiano es g c' es'
    \arpegePiano es g c' es'
    \arpegePiano c es g c'
    \arpegePiano des e bes des'
    \arpegePiano c f a c'
    \arpegePiano es f a c'
    \arpegePiano d f bes d'
    \arpegePiano d e bes d'
    \arpegePiano d f bes d'
    \arpegePiano es f a c'
    \arpegePiano d f bes d'
    \arpegePiano d f bes d'
    \arpegePiano f bes d' f'
    \arpegePiano as d' f' as'
    \arpegePiano g bes es' g'
    \arpegePiano ges a es' ges'
    \arpegePiano f bes d' f'
    \arpegePiano d f bes d' \bar ":|."
    \arpegePiano bes, d f bes

    \stemUp
    \arpegeFin f, bes, d f
    \arpegeFin d, f, bes, d
    \arpegeFin d, f, bes, d
    s2
}

octave =
#(define-music-function
  (parser location note)
  (ly:music?)
  #{
    \oct $note
    r8
  #})

left = \fixed c, {
    \global
    \repeat unfold 9 {\octave bes8}
    \octave g \octave f \octave f
    \octave g \octave g \octave es \octave f
    \repeat unfold 4 {\octave bes}
    \octave a \octave a \octave fis \octave fis
    \octave g \octave g \octave a \octave d'
    \octave c' \octave c'
    \repeat unfold 8 {\octave f'}
    \octave g' \octave g' \octave f' \octave d'
    \octave c' \octave c' \octave es' \octave g'
    \octave f' \octave f' \octave bes \octave g
    \octave f \octave f
    \repeat unfold 12 {\octave bes}
    <bes, f bes d' f' bes' d''>2 \fermata
}


sopranoVoicePart = <<
    \new Staff = "soprano" \with {
        instrumentName = "Soprano"
        midiInstrument = "flute"
    } { \sopranoVoice }
    \new Lyrics \verseOne
    \new Lyrics \verseTwo
>>

pianoPart = \new PianoStaff \with {
    instrumentName = "Orgue"
    midiMinimumVolume = #0.2
    midiMaximumVolume = #0.4
    midiInstrument = "church organ"
} <<
    \new Staff = "right" \right
    \new Staff = "left" \with {
        \clef bass
    } \left
>>

\score {
    \header {
        title = "AVE MARIA"
        composer = \schubert
    }
    <<
        \sopranoVoicePart
        \pianoPart
    >>
    \layout { \context {\Staff \RemoveAllEmptyStaves }}
    \midi {\tempo 4 = 35 }
}
