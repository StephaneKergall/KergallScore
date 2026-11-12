%{
  Le pdf et le midi ne sont pas disponibles publiquement
  pour des raisons morales. Contactez-nous à l'adresse
  stef.kergall@gmail.com pour les obtenir.
%}
\version "2.26.0"
\include "settings.ily"
\include "composers.ily"

global = {
  \key g \major
  \time 6/8
  \partial 8
  \autoBeamOff
  \mergeDifferentlyHeadedOn
  \mergeDifferentlyDottedOn
}

soprano = \fixed c' {
  \global
  \markChanson "Couplets"
  e8 g4 8 fis[g] fis e4. 4 8 a4 g8 fis4 8 4
  8 8[g] a g4. fis8[g fis] g4. d4 g8 a4 8 4 g8 fis4. r4 \bar "||" \break

  \markChanson "Refrain"
  e8 b4 8 4 a8 b4. 4 e8 c'4 8 8[b] a b4. 8 e' d' c'4.~8[b] a b4. 4
  g8 fis4 8 8[g] fis e4.~4 \bar "|."
}

alto = \fixed c' {
  \global
  e8 4 8 4 8 4(d8)c4 e8 4 8 4 8 dis4
  8 fis8[e] dis e4. d d d4 8 fis4 8 4 e8 dis4. r4

  e8 g4 8 4 fis8 g4. 4 e8 a4 8 8[g] fis g4. 8 a b e4.~4 8 g4. 8[fis]
  e dis4 8 8[e] fis e4.~4
}

tenor = \fixed c {
  \global
  b8 4 8 a[b] a g4. 4 8 c'4 8 b4 8 4
  8 8[g] fis b4. a8[g a] b4. 4 8 a4 8 4 b8 b4. r4

  8 4 8 4 d'8 4. b4 8 e'4 8 4 8 b4. 8 a g c'[a b c' d'] e'8 4. 4
  8 b4 8 4 a8 g4.~4
}

bass = \fixed c {
  \global
  e8 4 8 4 8 4. c4 b,8 a,4 8 b,4 8 4
  8 4 8 e4. fis8[g fis] g4. 4 8 d4 8 dis4 e8 b,4. r4

  e8 4 8 4 fis8 g4 fis8 e4 8 a4 8 8[g] fis e4. 8 8 8 a4.~4 8 e4. 4
  8 b,4 8 8[cis] dis e4.~4
}

verseOne = \strophemode #1 ##f \lyricmode {
  Vous ê -- tes dans mon â -- me, Jé -- sus, ô Roi des Cieux_!
  Mon cœur d'a -- mour s'en -- flam -- me, au com -- ble de mes vœux_!
  Jé -- sus Eu -- cha -- ris -- ti -- e, ô Fils de l'É -- ter -- nel_!
  Pour moi dans l'humble Hos -- ti -- e, Vous des -- cen -- dez du Ciel.
}

verseTwo = \strophemode #2 ##t \lyricmode {
  Doux Maî -- tre je Vous don -- ne ma foi, mon humble a -- mour,
  que Vo -- tre main si bon -- ne me gui -- de cha -- que jour.
}

verseThree = \strophemode #3 ##f \lyricmode {
  Mon âme est triste et las -- se sans Vo -- tre bon se -- cours_;
  j'im -- plo -- re Vo -- tre grâ -- ce, res -- tez en moi tou -- jours.
}

verseFour = \strophemode #4 ##t \lyricmode {
  Jé -- sus, mon  cœur Vous ai -- me, gar -- dez lui sa fer -- veur,
  Jé -- sus, Bon -- té su -- prê -- me, Jé -- sus, Di -- vin Sau -- veur.
}

\score {
  \header {
    title = "VOUS ÊTES DANS MON ÂME"
    composer = \barbey
  }
  \new ChoirStaff <<
    \new Staff \with {
      midiInstrument = "choir aahs"
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
      midiInstrument = "choir aahs"
      \consists Merge_rests_engraver
    } <<
      \clef bass
      \new Voice = "tenor" { \voiceOne \tenor }
      \new Voice = "bass" { \voiceTwo \bass }
    >>
  >>
  \layout {\context{\Staff \RemoveAllEmptyStaves }}
  \midi { \tempo 4=100 }
}
