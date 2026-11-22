\version "2.26.0"
\include "settings.ily"
\include "composers.ily"

global = {
  \mergeDifferentlyHeadedOn
  \mergeDifferentlyDottedOn
  \key d \major
  \time 3/4
  \partial 2
  \set Timing.beamExceptions = #'()
}

violon = \fixed c' {
  \global
  r2
  R2.*11
  r4 fis4\mf 4 |
  g8 b d'4 g |
  fis fis'4 4 |
  4 e'8 d' cis' b |
  cis'2. |
  b4. b'8 a' g' |
  fis'4. 8 4 ~ |
  8 gis' eis'4 cis' |
  d'4. cis'8 b4 ~ |
  4 d' cis'8 b |
  a4 gis8 fis eis4 |
  fis8 fis' e'? d' cis'4 |
  d'4 cis'8 b ais4 |
  b4 r2 |
  r4 a a |
  b8 d' fis'4 b |
  a a'4 4 |
  4 g'8 fis' e' d' |
  e'2. |
  d'2 cis'8 b |
  a4. a'8 4 ~ |
  8 b' gis'4 e' |
  fis'4. e'8 d'4 ~ |
  4 fis' e'8 d' |
  cis'4 b8 a gis4 |
  a b8 cis' dis'4 |
  e' b8 c' b a |
  g4. fis8 e4 ~ |
  4 d fis ~ |
  4 r2 |
  R2.
  r4 r8 e' dis' cis' |
  b4 fis'8 e' dis'4 |
  e' b8 a g4 |
  r r8 e'8 4 ~ |
  8 fis' dis'4 b |\break
  c'4. b8 a4 ~ |
  4 c' b8 a |
  g4 a b8 c' |
  b4 r2 |
  g'4 a'8 g' fis' e' |
  d'2. |\pageBreak
  4 cis' b |
  a2 e'4 ~ |
  4 d' cis' |
  b r2 |
  cis'4 b a8 b |
  cis'4 r8 e' d' cis' |\break
  b4 r8 d' cis' b |
  ais4 r8 fis' e' d' |
  cis' 4 r8 e' d' cis' |
  b4 r8 d' cis' b |
  a4 b cis'8 dis' |
  e'4 r8 e' fis' gis' |\break
  a'4 r r8 g' |
  fis' e' d' fis' e' d' |
  8 cis'8 16 d' cis' b cis'4 \fermata \bar "|."
}

ViolonPart = \new Staff \with {
	instrumentName = "Violon"
	shortInstrumentName = "Vl."
	midiInstrument = "violin"
} <<
  \new Voice = "violon" { \violon }
>>

flute = \transpose c g
\relative c' {
  \key g \major
  r2
  R2.*5
  r4 e4\mf 4 |
  g8 b d4 g, |
  fis fis'4 4 |
  4 e8 d cis b |
  cis2. |
  b2 fis8 e |
  d4 e8 fis b a |
  g4 r8 e'8 4 ~ |
  8 fis dis4 b |
  c4. b8 a4 ~ |
  4 c b8 a |
  g2 a4 |
  b4. cis8 d e |
  fis4. e8 d cis |
  b2. |
  ais |
  b4 fis8 g fis e |
  d4 d'2 ~ |
  4 b8 c b a |
  g4 d'8 e d c |
  b2. ~ |
  4 r2 |
  r4 a8 g a4 |
  b e8 c d e |
  fis4 e8 d e fis |
  g4 g, g |
  b8 d fis4 b, |
  a a' a |
  a g8 fis e d |
  e2. |
  d4 a8 b a g |
  fis4. e8 d4 ~ |
  4 c e ~ |
  4 r2 |
  e' fis4 |
  e4. d8 cis4 |
  b4 cis8 b ais4 |
  b8 fis b cis dis4 |
  e4. f8 e d |
  c4 b a ~ |
  4 r8 b c d |
  e4 d c8 b |
  a2. |
  gis |
  a |
  b4 c d |
  e2 d4 ~ |
  4 e d |
  c4. d8 e fis |
  g4 fis e8 cis |
  d4 e fis8 g |
  a4 g fis8 e |
  d4 c8 b a4 ~ |
  2. |
  c4 d e |
  fis2 b,4 ~ |
  4 cis dis |
  e r2 |
  gis, d'4 ~ |
  4 c a8 g |
  fis4. dis8 e fis |
  g a b a b cis |
  dis2.\fermata
}

FlûtePart = \new Staff \with {
	instrumentName = "Flûte"
	shortInstrumentName = "Fl."
	midiInstrument = "flute"
} <<
  \new Voice = "flute" { \flute }
>>

right = \relative c {
  \global
  fis4\mf 4 |
  g8 b d4 g, |
  fis fis'4 4 |
  4 e8 d cis b |
  cis2. |
  b4 fis8 g fis e | \break
  d2. ~ |
  4 r8 fis'8 4 ~ |
  8 gis eis4 cis |
  d4. cis8 b4 ~ |
  4 d cis8 b |
  a4 gis8 fis eis4 | \break
  fis gis ais |
  b4. cis8 d e |
  fis4 e d8 cis |
  b2. |
  ais |
  b2 cis4 |\pageBreak
  d e fis |
  gis2 eis4 |
  fis2 d4 |
  b2 gis4 |
  cis8 b a2 |
  r4 a8 b a g |\break
  fis4 r2 |
  g'8 fis e d cis4 |
  d4 a8 b a g |
  fis4. e8 fis g |
  a4. g'8 fis e |
  d2. |\break
  a'2 e4 |
  fis r2 |
  a,2. |
  b2 cis8 b |
  a2 fis'4 |
  e2. ~ |\pageBreak
  4 r2 |
  r4 a8 g fis4 |
  e2 fis4 |
  e4. d8 cis4 |
  b cis8 b ais4 |
  b cis8 dis eis4 |\break
  fis cis8 d cis b |
  ais4. gis8 4 |
  fis2 b4 ~ |
  4 cis8 dis e4 |
  g, r2 |
  b4. cis8 dis4 |
  e8 d c2 ~ |
  8 b a b b4 |
  c e2 ~ |
  4 dis e |
  b4. c8 d e |
  fis4 c8 d e fis |
  g2. |
  fis4 e d |
  cis2 e4 ~ |
  4 fis gis |
  a2. |
  g4 fis e |
  d2 g4 ~ |
  4 fis gis |
  ais gis fis8 e |
  d4 b a8 g |
  fis4 r8 a g fis |
  e2 r8 b'8 |
  a gis fis4 r8 ais |
  b cis d b cis d |
  e2.\fermata
}

left = \relative c {
  \global
  r2
  R2.*16
  r4 b4\mf 4 |
  d8 fis a4 d, |
  cis cis'4 4 |
  4 b8 a gis fis |
  gis2. |
  fis8 gis, a b cis4 |
  d fis,8 g a4 |
  b8 cis d e fis4 |
  g4. fis8 e4 |
  d e8 d cis4 |
  d4. d'8 4 ~ |
  8 e cis4 a |
  b4. a8 g4 ~ |
  4 b a8 g |
  fis2. ~ |
  2. |
  e4 r2 |
  fis2. |
  g4. fis8 g4 |
  a2 e4 |
  fis2 b,4 |
  e fis8 e dis4 |
  e fis8 gis ais4 |
  b fis8 g fis e |
  d4. cis8 b4 ~ |
  4 a gis |
  fis2 fis'8 e |
  dis4 r2 |
  r4 b4 4 |
  c8 e g4 c, |
  b b'4 4 |
  4 a8 g fis e |
  fis2. |
  e4. fis8 g a |
  b4 a g8 fis |
  e2 fis4 ~ |
  4 e d8 c |
  b4 cis? d8 e |
  fis4 r2 |
  r4 r8 cis' b a |
  gis4. fis8 e d |
  cis4. d8 cis b |
  ais4. fis8 gis ais |
  b4 a? g? |
  <fis fis'>2. ~ 2. ~ 2. ~ 2. ~ 2. ~ 2. ~ 2. ~ 2.\fermata
}

ClavierPart = \new PianoStaff \with {
	instrumentName = "Orgue"
	shortInstrumentName = "Org."
	midiMinimumVolume = #0.2
  midiMaximumVolume = #0.4
  midiInstrument = "church organ"
	\clef bass
} <<
  \new Staff = "right" { \right }
  \new Staff = "left" { \left }
>>

\tocItemComposer "Fugue 6" "Bergeron"
\score {
  \header {
    title = "FUGUE 6"
    composer = \bergeron
  }
  <<
    \ViolonPart
    \FlûtePart
    \ClavierPart
  >>
  \layout { }
  \midi {\tempo 4=85 }
}
