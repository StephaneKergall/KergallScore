\version "2.26.0"
\include "settings.ily"
\include "composers.ily"

global = {
  \mergeDifferentlyHeadedOn
  \mergeDifferentlyDottedOn
  \key g \major
  \time 4/4
  \tempo 4=86
}

flute = \fixed c' {
  \global \autoBeamOff
  R1*3
  r2. b8 a |
  b2 ~ 8 e c' b |
  c'2 ~ 8 b a g |
  fis2 d8 d b a |
  b2 r4 a8 g |
  g4. e8 g4 b |
  a2 ~ 8 g fis e | 
  e4. fis16 g fis4 e |
  fis2 r4 g8 fis |
  g4. fis8 g a b c' |
  d'2 ~ 8 8 c' b |
  c'4. a8 g fis g a |
  b2 r4 b8 a |
  b2 ~ 8 e c' b |
  c'2 ~ 8 b a g |
  fis2 d8 8 b a |
  b2 r4 a8 g |
  g4 e g b |
  a2 r8 c' b a |
  g4 8 a b4 dis |
  e2 r |
  e r |
  R1
}

fluteVerseOne = \strophemode 1 ##f \lyricmode {
  Je con -- nais les bru -- mes claires,
  la nei -- ge rose des ma -- tins d'hi -- ver_;
  je pour -- rais te re -- trou -- ver_:
  le liè -- vre blanc qu'on ne voit ja -- mais.
  
  Mais l'oi -- seau, l'oi -- seau s'est en -- vo -- lé,
  et moi ja -- mais je ne le trou -- ve -- rai.
  
  Car j'ai vu l'oi -- seau vo -- ler,
  j'ai vu l'oi -- seau, je sais qu'il par -- tait,
  je l'ai en -- ten -- du pleu -- rer
  Le bel oi -- seau que le vent chas -- sait.
}

fluteVerseTwo = \strophemode 2 ##t \lyricmode {
  Je vou -- drais tout te don -- ner,
  mais toi pour -- quoi ne me dis -_tu rien_?
  Quel est -_il ton grand se -- cret_?
  Un se -- cret d'homme, je le com -- prends bien.
  
  Moi tu sais je peux te ra -- con -- ter
  com -- bien l'oi -- seau est par -- ti à re -- gret. 
  
  Si un jour tu m'é -- cou -- tais,
  tu ap -- pren -- drais tout ce que je sais,
  l'oi -- seau part et puis re -- vient,
  tu le ver -- ras peut -_êt -- re de -- main.
}

fluteVerseThree = \strophemode 3 ##f \lyricmode {
  Si ja -- mais je ren -- con -- trais
  le bel oi -- seau qui s'est en -- vo -- lé,
  s'il re -- vient de son voy -- age
  tout près de toi le long du ri -- vage,
  moi tu vois, je lui ra -- con -- te -- rais
  com -- bien pour toi je sais qu'il a comp -- té.
  
  C'est l'oi -- seau que tu ai -- mais,
  l'oi -- seau ja -- loux, je l'ai de -- vi -- né,
  si ja -- mais il re -- ve -- nait,
  je lui di -- rais que tu l'at -- ten _ -- dais.
}

FlûtePart = \new Staff \with {
  instrumentName = "Flûte"
  midiInstrument = "flute"
} \flute
\addlyrics \fluteVerseOne
\addlyrics \fluteVerseTwo
\addlyrics \fluteVerseThree

arp = \arpeggio

right = \relative c' {
  \global
  r8 b e fis  <g e b>\arp a b c |
  \repeat volta 2 { 
    <d b fis>\arp fis, b c <d b fis>\arp e fis g |
    <a fis c>\arp a, c fis <e c a>\arp a, c fis |
    <e b a>4\arp  dis r2 |
    r8 b, <b' g> <a fis> <g e>2 |
    r8 c, <c' a> <b g> <a fis>2 |
    r8 a, <a' fis> <g e> <fis d>2 |
    r8 b, <b' g> <a fis> <g e>2 |
    r8 b, <b' g> <g e> r8 c, <b' g> <g e> |
    r8 c, <e a c> c r c q c |
    r cis <e ais cis> cis r cis q cis |
    \tuplet 3/2 {b\fermata e fis} b e fis [ b\fermata ] g,[ fis ] |
    <g e b>\arp b, e fis q\arp a b c |
    <d b fis>\arp fis, b c q\arp e fis g |
    <a fis c>\arp a, c fis <e c a>\arp a, c fis |
    <e b a>4\arp dis r2 |
    r8 b, <b' g> <a fis> <e g>2 |
    r8 c <a' c> <g b> <fis a>2 |
    r8 a, <fis' a> <e g> <d fis>2 |
    r8 b <g' b> <fis a> <e g>2 |
    r8 b <g' b> <e g> r c <g' b> <e g> |
    r8 e <c' e> <a c> r <fis a> <g b> <a c> |
    r b, <g' b> <fis a> <g e b>4\arp <fis dis a>\arp |
    \alternative{
      \volta 1,2 {
        r8 b, e fis  <g e b>\arp a b c |
      }
      \volta 3 {
        r b, <g' b> <fis a> <g e b>4\arp <fis dis a>\arp |
        <e b g>1\arp\fermata |\bar "|."
      }
    }
  }
}

left = \fixed c {
  \global
  \oct {e1 b a2 2 b b, e~}
  8 8 a g |
  \oct a2 ~ 8 a,  b, c |
  \oct d2 ~ 8 8 b a |
  \oct g2 ~ 8 g, a, b, |
  \oct c2 b,8 c d e |
  \oct fis 2 e8 c d e |
  \oct {fis2 2 b, r e1 b fis2 a b b, e2 ~ }
  8 8 a g |
  \oct a2 ~ 8 a, b, c |
  \oct d2 ~ 8 8 b a |
  \oct g2 ~ 8 g, a, b, |
  \oct c2 e8 c d e |
  \oct {a4 g fis e | b2 b, e1 2 4 b, e1}
}

ClavierPart = \new PianoStaff \with {
  instrumentName = "Piano"
  midiInstrument = "acoustic grand"
} <<
  \new Staff = "right" { \right }
  \new Staff = "left" { \clef bass \left }
>>

\tocItem \markup "L'oiseau"
\score {
  \header {
    title = "L'OISEAU"
    subtitle = "Belle et Sébastien"
    poet = "Paroles : Cécile Aubry"
  }
  <<
    \FlûtePart
    \ClavierPart
  >>
  \layout {\context{\Staff \RemoveAllEmptyStaves }}
  \midi {}
}
