\version "2.26.0"
\include "settings.ily"
\include "composers.ily"

#(set-global-staff-size 18 )

global = {
  \key c \major
  \time 4/4
  \set Timing.beamExceptions = #'()
  \set Timing.beatBase = #1/16
  \set Timing.beatStructure = #'(2 3 3 2 3 3)
}

\paper {
  page-count = 2
  systems-per-page = 6
}

sopranoVoice = \fixed c'' {
  \global
  \autoBeamOff
  R1*4
  e1 f2~4. 8 g2.(d4) e2. r4
  a2_(~8[a,]) b, c d4.(e8) d4. r8
  g2_(~8[g,]) a, b, c4.(d8) c4. r8
  c'2_(~8[c]) d[e] fis4.(e8 d4) a, b,2 r4
  d4 e2~8 e[f g] a4.. a,16 4. r8
  d2~8 8[e] f g2 g,4. r8
  c2~8 8[d e] f2~8 8[g a] b4. a8 g4(d) e2. r4

  g2 e4.. 16 a2 a,4. r8
  a2 c4.. a16 c'2 es4. r16
  c'16 2 d4. r8
  d2~8 8[c] b, g4.(e8) c4. r8
  f2~8 8 e d d'4. b8 g4. r8
  a2~8 8[b] c' e'2_(~8[c']) g e d2_(~8[a])
  b[a] g[d'] b[g] f[d] b,[g,] c1 2. r4
  g1 1\fermata \bar "|."

}

verse = \lyricmode {
  A -- ve Ma -- ri -- a, gra -- ti -- a ple -- na, Do -- mi -- nus te -- cum,
  be -- ne -- dic -- ta tu in mu -- li -- e -- ri -- bus,
  et be -- ne -- dic -- tus fruc -- tus ven -- tris tu -- i, Je -- sus.
  Sanc -- ta Ma -- ri -- a, Sanc -- ta Ma -- ri -- a, Ma -- ri -- a,
  o -- ra pro no -- bis, no -- bis pec -- ca -- to -- ri -- bus,
  nunc, et in ho -- ra, in ho -- ra mor -- tis nos -- trae.
  A -- men. A -- men.

}

right = \fixed c' {
  \global

  r8 g16    c'   e'   g    c'   e'   r8   g16    c'   e'   g    c'   e'
  r8 a16    d'   f'   a    d'   f'   r8   a16    d'   f'   a    d'   f'
  r8 g16    d'   f'   g    d'   f'   r8   g16    d'   f'   g    d'   f'
  r8 g16    c'   e'   g    c'   e'   r8   g16    c'   e'   g    c'   e'
  r8 g16    c'   e'   g    c'   e'   r8   g16    c'   e'   g    c'   e'
  r8 a16    d'   f'   a    d'   f'   r8   a16    d'   f'   a    d'   f'
  r8 g16    d'   f'   g    d'   f'   r8   g16    d'   f'   g    d'   f'
  r8 g16    c'   e'   g    c'   e'   r8   g16    c'   e'   g    c'   e'
  r8 a16	  e'   a'   a    e'   a'   r8   a16    e'   a'   a    e'   a'
  r8 fis16  a    d'   fis  a    d'   r8   fis16  a    d'   fis  a    d'
  r8 g16    d'   g'   g    d'   g'   r8   g16    d'   g'   g    d'   g'
  r8 e16    g    c'   e    g    c'   r8   e16    g    c'   e    g    c'
  r8 e16    g    c'   e    g    c'   r8   e16    g    c'   e    g    c'
  r8 d16    fis  c'   d    fis  c'   r8   d16    fis  c'   d    fis  c'
  r8 d16    g    b    d    g    b    r8   d16    g    b    d    g    b
  r8 e16    g    cis' e    g    cis' r8   e16    g    cis' e    g    cis'
  r8 d16    a    d'   d    a    d'   r8   d16    a    d'   d    a    d'
  r8 d16    f    b    d    f    b    r8   d16    f    b    d    f    b
  r8 c16    g    c'   c    g    c'   r8   c16    g    c'   c    g    c'
  r8 a,16   c    f    a,   c    f    r8   a,16   c    f    a,   c    f
  r8 a,16   c    f    a,   c    f    r8   a,16   c    f    a,   c    f
  r8 g,16   b,   f    g,   b,   f    r8   g,16   b,   f    g,   b,   f
  r8 g,16   c    e    g,   c    e    r8   g,16   c    e    g,   c    e
  r8 bes,16 c    e    bes, c    e    r8   bes,16 c    e    bes, c    e
  r8 a,16   c    e    a,   c    e    r8   a,16   c    e    a,   c    e
  r8 a,16   c    es   a,   c    es   r8   a,16   c    es   a,   c    es
  r8 b,16   c    es   b,   c    es   r8   b,16   c    es   b,   c    es
  r8 b,16   c    d    b,   c    d    r8   b,16   c    d    b,   c    d
  r8 g,16   b,   d    g,   b,   d    r8   g,16   b,   d    g,   b,   d
  r8 g,16   c    e    g,   c    e    r8   g,16   c    e    g,   c    e
  r8 g,16   c    f    g,   c    f    r8   g,16   c    f    g,   c    f
  r8 g,16   b,   f    g,   b,   f    r8   g,16   b,   f    g,   b,   f
  r8 a,16   c    fis  a,   c    fis  r8   a,16   c    fis  a,   c    fis
  r8 g,16   c    g    g,   c    g    r8   g,16   c    g    g,   c    g
  r8 g,16   c    f    g,   c    f    r8   g,16   c    f    g,   c    f
  r8 g,16   b,   f    g,   b,   f    r8   g,16   b,   f    g,   b,   f
  r8 g,16   bes, e    g,   bes, e    r8   g,16   bes, e    g,   bes, e
  r8 f,16   a,   c    a,   c    f    c a, c      a,   f,   a,   f,   d,
  r8 g16    b    d'   f'   d'   b    d' b g      b    d    f    e    d
  <e g c'>1 \fermata
}

left = \fixed c {
  \global

  \repeat unfold 2 { <<
    { r16 e'8.~4 r16 e'8.~4
      r16 d'8.~4 r16 d'8.~4
      r16 d'8.~4 r16 d'8.~4
      r16 e'8.~4 r16 e'8.~4
    }
    \\
    { c'2 2 2 2 b b c'2 2 }
  >>}

  <<
    { r16 e'8.~4 r16 e'8.~4
      r16 d'8.~4 r16 d'8.~4
      r16 d'8.~4 r16 d'8.~4
      r16 c'8.~4 r16 c'8.~4
      r16 c'8.~4 r16 c'8.~4
      r16 c'8.~4 r16 c'8.~4
      r16 b8.~4 r16 b8.~4
      r16 bes8.~4 r16 bes8.~4
      r16 a8.~4 r16 a8.~4
      r16 as8.~4 r16 as8.~4
      r16 g8.~4 r16 g8.~4
      r16 f8.~4 r16 f8.~4
      r16 f8.~4 r16 f8.~4
      r16 d8.~4 r16 d8.~4
      r16 e8.~4 r16 e8.~4
      r16 g8.~4 r16 g8.~4
      r16 f8.~4 r16 f8.~4
      r16 c8.~4 r16 c8.~4
      r16 es8.~4 r16 es8.~4
      r16 f8.~4 r16 f8.~4
      r16 f8.~4 r16 f8.~4
      r16 e8.~4 r16 e8.~4
      r16 d8.~4 r16 d8.~4
      r16 d8.~4 r16 d8.~4
      r16 es8.~4 r16 es8.~4
      r16 e8.~4 r16 e8.~4
      r16 d8.~4 r16 d8.~4
      r16 d8.~4 r16 d8.~4
      r16 c8.~4 r16 c8.~4.
      r16 c8.~4~2
      r16 b,8.~4~2
    }
    \\
    { c'2 2 2 2 b b b b a a d d g g g g f f f f e e e e
      d d g, g, c c c c f, f, fis,2 2 g,2 2 as,2 2
      g,2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 c,2 2 1 1
      <c, c c'>\fermata}
  >>


}

sopranoVoicePart = \new Staff \with {
  instrumentName = "Soprano"
  midiInstrument = "flute"
} {\sopranoVoice }
\addlyrics { \verse }

pianoPart = \new PianoStaff \with {
  instrumentName = "Orgue"
  midiMinimumVolume = #0.2
  midiMaximumVolume = #0.4
  midiInstrument = "church organ"
} <<
  \new Staff = "right" \right
  \new Staff = "left" {\clef bass \left}
>>

\score {
  \header {
    title = "AVE MARIA"
    composer = \gounod
    poet = "D'après le prélude en Do majeur (BWV 846)"
    meter = \markup{de \bach}
  }
<<
    \sopranoVoicePart
    \pianoPart
  >>
  \layout {\context{\Staff \RemoveAllEmptyStaves }}
  \midi { \tempo 4 = 80 }
}