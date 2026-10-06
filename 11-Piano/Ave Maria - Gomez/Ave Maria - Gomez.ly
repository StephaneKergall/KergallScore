\version "2.26.0"
\include "settings.ily"
\include "composers.ily"

#(set-global-staff-size 18.7)

global = {
    \key d \major
    \time 4/4
    \tupletSpan 4
}

sopranoVoice = \fixed c' {
    \global
    \dynamicUp
    R1*2
    d4 4 r8 d e fis a4 2 r4
    b4 4~\tuplet 3/2 {8 8 8 8 a g} a4 2 r8
    fis8 \tuplet 3/2 {g8 8 8} 4~\tuplet 3/2 {8 8 8} g16 a a e fis4 4 r4
    b8 cis' \tuplet 3/2 {d'8 8 8 8 4~8 b b b cis' d'} cis'2. r4

    \repeat volta 2 {
        d4 4 r8 d e fis a4 2 r4
        b4 4~\tuplet 3/2 {8 8 8 8 a g} a4 2 r8
        fis8 \tuplet 3/2 {g8 8 8} 4~\tuplet 3/2 {8 8 8} g16 a a e fis4 4 r4
        b8 cis' \tuplet 3/2 {d'8 8 8 8 4~8 b b b cis' d'} e'2. r4

        d'4 2 16 e'8 cis'16 d'4 2 e'16 fis'8 cis'16 d'4 2
        \tuplet 3/2 {d'8 e' d'} fis'2. r4 d'4 b~\tuplet 3/2 {8 8 8}
        16 cis'16 16 b d'4 b~\tuplet 3/2 {4 8} 16 16 cis' b d'4
        b~16 cis'16 16 d' \tuplet 3/2 {e'8 d' cis'}
        \alternative{
            \volta 1 {d'2. r4}
            \volta 2 {
                d'2 r4
              \tuplet 3/2 {8 cis' b} d'2. a4 1~1\fermata \bar "|." }
        }
    }
}

verse = \lyricmode {
    \repeat unfold 2 {
        A -- ve, a -- ve Ma -- ri -- a, lle -- na, lle -- na e -- res de gra -- cia,
        ben -- di -- ta'e -- res tu en -- tre to -- das las mu -- je -- res,
        y ben -- di -- to'es el fruc -- to de tu vien -- tre, Je -- sus.
    }
    San -- ta, San -- ta Ma -- ri -- a, San -- ta Ma -- ri -- a, ma -- dre de Dios,
    rue -- ga por no -- so -- tros pe -- ca -- do -- res
    a -- ho -- ra'y en la ho -- ra de nues -- tra muer -- te A -- men.
    -men, A _ _ -- men, A -- men.
}

right = \fixed c' {
    \global
    r2 r4 <d' fis' a'>4 4 <a d' fis'> <fis a d'> <fis a>
    \tuplet 3/2 {
        fis8 a, d fis d a, r a, d fis d a,
        cis cis fis a fis cis r cis fis a fis cis
        b, d g b g d r cis e a e cis
        d a, d fis d a, r a, d fis d a,
        g, b, e g e b, r a, cis g e cis
        d a, d fis d a, r a, d fis d a,
        d b, d g d b, r b, d g d b,
        cis a, cis e cis a, r cis e a e cis
    }


    \repeat volta 2 {
        \tuplet 3/2 {
            fis8 a, d fis d a, r a, d fis d a,
            cis cis fis a fis cis r cis fis a fis cis
            b, d g b g d r cis e a e cis
            d a, d fis d a, r a, d fis d a,
            g, b, e g e b, r a, cis g e cis
            d a, d fis d a, r a, d fis d a,
            d b, d g d b, r b, d g d b,
            d a, d e d a, r cis e a e cis
        }

        << { \tupletSpan 4 \tuplet 3/2 {
                \repeat unfold 2 {r8 fis, a, d a, fis,}
                \repeat unfold 2 {r fis, b, d b, fis,}
                \repeat unfold 2 {r g, b, d b, g,}
                \repeat unfold 2 {r fis, a, d a, fis,}
                \repeat unfold 2 {r fis, b, d b, fis,
                                  r g, b, d b, g,}
                r g, b, d b, g, r a, cis e g a}

        } \\ {
            <fis, a, d>2 s2 <fis, b, d>2 s2 <g, b, d>2 s2
            <fis, a, d>2 s2 \repeat unfold 2 { <fis, b, d> <g, b, d> }
            <g, b, d>
           }>>

        \alternative {
            \volta 1 {
                \tuplet 3/2 {d'4 cis'16 d' fis'4 eis'16 fis' a'4 gis'16 a'}  d''4
            }
            \volta 2 {
                \tuplet 3/2 {d'4 cis'16 d' fis'4 eis'16 fis' a'4 gis'16 a'}
                d''4
                \tuplet 3/2 {r8 d g b g d r d e a e cis
                             d a, d fis d a,
                             r a, d fis d a,
                }
                <fis, a, d>1\arpeggio\fermata
            }
        }
    }

}

left = \fixed c {
    \global
    \tuplet 3/2 {\repeat unfold 4 { d8 a d' fis' d' a}}
    d2 2 fis,2 2 g, a, <d d,> <d d,> e, a, <d d,> d g,2 2 a,2 2

    \repeat volta 2 {
        <d d,>2 2 <fis, fis>2 2 <g g,> <a a,> <d d,>2 2 <e e,> <a, a,,> <d d,>2
        4 <cis cis,> <b, b,,>2 <g, g,,> <a, a,,>2 2
        <d, d>2 2 <b, b,,>2 2 <g,, g,>2 2 <d, d>2 4 <cis, cis>
        \repeat unfold 2 {<b,, b,>2 <g,, g,>} <e, e> <a,, a,>

        \alternative {
            \volta 1 {
                \repeat unfold 2 {\tuplet 3/2 {
                d8 a d' fis' d' a }}
            }
            \volta 2 {
                \repeat unfold 2 {\tuplet 3/2 {
                d8 a d' fis' d' a }}
                <g, g>2 <a a,> <d d,>2 2 <d, a, d>1\arpeggio\fermata
            }
        }
    }

}

sopranoVoicePart = \new Staff \with {
    instrumentName = "Sop."
    midiInstrument = "flute"
} { \sopranoVoice }
\addlyrics { \verse }

pianoPart = \new PianoStaff \with {
    instrumentName = "Org."
    midiMinimumVolume = #0.2
    midiMaximumVolume = #0.4
    connectArpeggios = ##t
  } <<
    \new Staff = "right" \with {
        midiInstrument = "church organ"
    } \right
    \new Staff = "left" \with {
        midiInstrument = "church organ"
    } { \clef bass \left }
>>

\score {
    \header {
        title = "AVE MARIA"
        composer = \gomez
    }
<<
        \sopranoVoicePart
        \pianoPart
    >>
    \layout {}
    \midi {
        \tempo 4=70
    }
}
