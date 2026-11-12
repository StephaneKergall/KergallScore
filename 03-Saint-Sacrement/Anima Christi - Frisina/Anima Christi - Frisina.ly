%{
  Le pdf et le midi ne sont pas disponibles publiquement
  pour des raisons morales. Contactez-nous à l'adresse
  stef.kergall@gmail.com pour les obtenir.
%}
\version "2.26.0"
\include "settings.ily"
\include "composers.ily"

global = {
  \key d \major
  \time 4/4
  \autoBeamOff
  R1
  \partial 2
}

globalO = {
  \key d \major
  \time 4/4
  \autoBeamOn
}

sopranoVoice = \fixed c' {
  \global
  \dynamicUp
  r2 R1*8
  b4 8[ 8] 4 cis'8[ d'] d'[ cis'] b [a] b4~4
  \set Staff.shortInstrumentName = ""
   a8[g] fis e g4 fis8[ b,] fis4 e fis2
  fis4 g8[a] b4 cis'8[ d'] d'4( cis') b2
  a8[g fis e] g4( fis8[ b,]) d4( cis) b,2
}

verseOne = \lyricmode {
   2  1*9
  \set stanza = "1."
  Pas4 -- si8 -- o8 Chri4 -- sti8 con8 -- for4 -- ta4 me,2
  o4 bo8 -- ne Je4 -- su8 e -- xau4 -- di me,2
  in4 -- tra vul -- ne8 -- ra tu2 -- a ab -- scon4 -- de,8 ab -- scon4 -- de me.2
}

verseTwo = \lyricmode {
  2 1*9
  \override LyricText.font-shape = #'italic
  \set stanza = \markup \italic 2.
  Ne4 per4 -- mit4 -- tas8 a8 te8 me8 se8 -- pa8 -- ra4 -- ri,4
  ab8 hos -- te ma -- li4 -- gno8 de -- fen4 -- de me,2
  in4 ho8 -- ra mor4 -- tis me2 -- æ vo4 -- ca me,2 vo4 -- ca me.2
}

verseThree = \lyricmode {
   2 1*9
  \set stanza = "3."
  Et4 ju8 -- be me4 ve -- ni -- re8 ad te,2
  ut8 cum sanc -- tis tu4 -- is lau -- dem te,2
  per4 in8 -- fi -- ni4 -- ta sæ -- cu -- la2 sæ4 -- cu -- lo -- rum. A2 -- men.
}

soprano = \fixed c' {
  \global
  \markChanson "Refrain"
  fis4 8 8 b4 8 8 a4 8 g fis2
  e4 fis8[g] d4 e fis4. e8 fis2
  fis4 4 b cis'8 d' d'[cis'] b a b2
  4 fis a8[g] fis e d4 e fis4. 8 2\bar "||"

  \markChanson "Couplets"
  fis2 g fis2. e8[d] e4 b,2 d4 4 e fis2
  2. e4 2 d2 4 cis2 b,4 d cis b,2
}

alto = \fixed c' {
  \global
  d4 8 8 4 e8 8 4 8 8 d2
  b,4 4 4 4 d4. 8 cis2
  d4 fis fis e8 8 4 8 8 d2
  fis4 4 e b,8 8 4 4 cis4. 8 d2

  d1 cis2 d4 b,4 1 2 cis d1 cis2 b, b, fis, b,4 a, b,2
}

tenor = \fixed c {
  \global
  b4 8 8 4 8 8 d'4 cis'8 8 d'2
  g4 4 fis4 4 g4. b8 ais2
  fis4 4 b4 8 8 a4 cis'8 8 b2
  4 4 4 g8 8 b4 4 ais4. 8 b2

  b1 fis g2 fis g4 b2 ais4 b1 a2. g8[fis] g4 e fis2 e4 fis fis2
}

bass = \fixed c {
  \global
  b4 8 a g4 8 8 a4 a,8 8 b,2
  e4 d8[cis] b,4 4 4. 8 fis2
  b,4 4 g, g8 8 a4 fis8 8 g2
  d4 d e4 8 8 fis4 4 4. 8 b,2
  b,2 g, a, b, e d g4~4 fis2 d g, a, b, e d g,4 a, b,2
}

verse = \lyricmode {
  A -- ni -- ma Chri -- sti, san -- cti -- fi -- ca -- me.
  Cor -- pus Chri -- sti, sal -- va me.
  San -- guis Chri -- sti, i -- ne -- bri -- a me.
  A -- qua la -- te -- ris Chri -- sti, la -- va me.
  \markup { \italic B.F. }
}

rightOne = \fixed c' {
  \globalO
  fis1~\bar".|"2 g2 e d e d4 e fis4. e8 fis2
  2 b4 cis'8 d' d' cis' b a b2 4 fis a8 g fis e d4 e fis2 2

  fis g fis2. e8 d e4 b,2 d4 4 e fis2
  fis2. e4 2 d2 4 cis2 b,4 d cis d2\bar"|."
}

rightTwo = \fixed c' {
  \globalO
  fis4 e d2~2~2. cis4 b,1~2 d2 cis
  d4 fis4~4 e4 2 d fis e4 b,4 2 cis d

  d1 cis2 d4 b,4 1 2 cis
  d1 cis2 b, b, fis, b,4 a, b,2
}

leftOne = \fixed c {
  \globalO
  r2 d'4 cis' b2~2a4. g8 fis2 g fis g4.b8 ais2
  b~2 a4 cis' b1~4 g b2 ais b

  b1 fis g2 fis g4 b2 ais4
  b1 a2. g8 fis g4 e fis2 e4 fis4 2
}

leftTwo = \fixed c, {
  \globalO
  r2 s2 b4. a8 g2 a b e'4 d'8 cis' b2 2 fis'
  b g4 g' a' fis' g'2 d' e' fis'~2 b

  b g a b e' d' g' fis'
  d' g a b e' d' g4 a b2
}

sopranoVoicePart = << \new Staff \with {
  shortInstrumentName = "Sl."
  midiInstrument = "choir aahs"
} \new Voice = "sopranoVoice" \sopranoVoice
  \new Lyrics \verseOne
  \new Lyrics \verseTwo
  \new Lyrics \verseThree
>>


choirPart = \new ChoirStaff <<
      \new Staff \with {
        midiInstrument = "choir aahs"
        \consists Merge_rests_engraver
        instrumentName =  \markup \center-column { "S." "A." }
      } <<
        \new Voice = "soprano" { \voiceOne \soprano }
        \new Voice = "alto" { \voiceTwo \alto }
      >>
      \new Lyrics \with {
        \override VerticalAxisGroup.staff-affinity = #CENTER
      } \lyricsto "soprano" \verse
      
      \new Staff \with {
        midiInstrument = "choir aahs"
        \consists Merge_rests_engraver
        instrumentName =  \markup \center-column { "T." "B." }
      } <<
        \clef bass
        \new Voice = "tenor" { \voiceOne \tenor }
        \new Voice = "bass" { \voiceTwo \bass }
      >>
    >>


orguePart = \new PianoStaff \with {
  instrumentName = "Orgue"
  \consists Merge_rests_engraver
} <<
  \new Staff = "right" \with {
    midiInstrument = "church organ"
  } << \rightOne \\ \rightTwo >>
  \new Staff = "left" \with {
    midiInstrument = "church organ"
  } { \clef bass << \leftOne \\ \leftTwo >> }
>>

\score {
  \header {
    title = "ANIMA CHRISTI"
    composer = \frisina
  }
  <<
    \sopranoVoicePart
    \choirPart
    \orguePart
  >>
  \layout {\context{\Staff \RemoveAllEmptyStaves }}
  \midi { \tempo 4=85 }
}