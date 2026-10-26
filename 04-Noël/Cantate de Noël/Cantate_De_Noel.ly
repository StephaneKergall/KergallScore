\version "2.26.0"
\include "settings.ily"
\include "composers.ily"

global = {
  \time 4/4
  \key g \major
  \partial 2
  \autoBeamOff
}

choeur = \textMark \markup \italic \huge "Chœur"
solo = \textMark \markup \italic \huge "Solo"

PartPOneVoiceOne = \relative b' {
  \global
  \markChanson "I. SOLO"
   \solo b4  b4 | % 1
   a4  g4  d'4  d4 | % 2
   b4.  c8  d4  g,4 | % 3
   c4  b4  a2 | % 4
   g2 b4  b4 | % 5
   a4  g4  d'4  d4 | % 6
   b4  b8 [  c8 ] d4  g,4 | % 7
   c8 [  d8 ] b8 [ c8 ]  a2 | % 8
   g2  g'4  g4 | % 9

 fis4  fis4  e4  e4 | % 10
   d2  d4 ( e4 ) | % 11
   d4  c8 [  b8 ]  c4  d4 | % 12
   b4  b8 [  c8 ]  d4  d4 | % 13
   d4  b8 [  c8 ]  d4  d4 | % 14
   d4  b8 [  c8 ]  d4  b8 [  c8 ] | % 15
   d4  d4  e2 | % 16
   d2 g,4.  a8 | % 17
   b4  c4  a2 | % 18
   g2 \bar "||" \break
   \choeur g'4  g4 | % 19

  fis4  fis4  e4  e4 | % 20
   d2  d4 ( e4 ) | % 21
   d4  c8 [  b8 ] c4  d4 | % 22
   b4  b8 [  c8 ]  d4  d4 | % 23
   d4 r4 r2 | % 24
  r4  b8 [  c8 ] d4  b8 [  c8 ] | % 25
   d4  d4  e2 | % 26
   d2 g,4.  a8 | % 27
   b4  c4  a2 | % 28
  g2 \bar "||" \break r2 | % 29

  R1*17
  
  r2  \bar "||" \break 
  \choeur g'4  g4 | % 47
   fis4  fis4  e4  e4 | % 48
   d2  d4 ( e4 ) | % 49

  d4  c8 [  b8 ] c4  d4 | % 50
   b4  b8 [  c8 ]  d4  d4 | % 51
   d4 r4 r2 | % 52
  r4  b8 [  c8 ] d4  b8 [  c8 ] | % 53
   d4  d4  e2 | % 54
   d2 g,4.  a8 | % 55
   b4  c4  a2 | % 56
  g2 \bar "||" \break
  
  r2 | % 57
  
  R1*17
  
  r2 \choeur d'4
  d4 | % 75
   d4  d4  e4  e4 | % 76
   fis4 ( e4 ) d4 ( g,4 ) | % 77
   g'4  d8 [  e8 ] d4  a4 | % 78
   b4  r4 r2 | % 79

  r4  b8 [  c8 ]  d4  d4 | % 80
  d4  g4 d4  g4 | % 81
   d4  b4  c8 [  d8  e8  c8 ] | % 82
   b2 r2 | % 83
   g4  g4  c2 | % 84
  b2 \bar "||" \pageBreak
  
  \markChanson "IV. QUATUOR"
  \solo b4  b4 | % 85
  a4  g4  d'4  d4 | % 86
   b4.  c8  d4  g,4 | % 87
   c4  b4  a2 | % 88
   g2  b4  b4 | % 89

 a4  g4  d'4  d4 | % 90
   b4  b8 [  c8 ] d4  g,4 | % 91
   c4  b4  a2 | % 92
  g2  g'4  g4 | % 93
   fis4  fis4  e4  e4 | % 94
   d2  d4 ( e4 ) | % 95
   e8 [  d8 ] c8 [ b8 ]  c4  d4 | % 96
   b4  b8 [  c8 ]  d4  d4 | % 97
   d4  b8 [  c8 ]  d4  d4 | % 98
   d4  b8 [  c8 ]  d4  b8 [  c8 ] | % 99

 d4  d4  e2 | % 100
   d2 g,4.  a8 | % 101
   b4  c4  a2 | % 102
   g2 \bar "||" \break
   \choeur g'4  g4 | % 103
   fis4  fis4  e4  e4 | % 104
   d2  d4 ( e4 ) | % 105
   e8 [  d8 ] c8 [ b8 ] c4  d4 | % 106
   b4  b8 [  c8 ]  d4  d4 | % 107
   d4  b8 [  c8 ]  d4  d4 | % 108
   d4  b8 [  c8 ] d4  b8 [  c8 ] | % 109

  d4  d4  e2 | % 110
   d2 g,4.  a8 | % 111
   b4  c4  a2 | % 112
  g1 \bar "|."
}

sopranoLyrics = \lyricmode {
  Pour sau -- ver l'hu -- ma -- ni -- té,
  Jé -- sus vient sur la Ter -- re,
  il re -- vêt d'hu -- mi -- li -- té,
  le plus tou -- chant mys -- tè -- re.
  À la crèche ac -- cou -- rons tous,
  Jé -- sus est né pour nous,
  l'au -- gus -- te_En -- fant,
  si frêle et doux,
  sou -- rit par -- mi ses lar -- mes_;
  ô sub -- li -- mes char -- mes_!
  À la crèche ac -- cou -- rons tous,
  Jé -- sus est né pour nous,
  l'au -- gus -- te_En -- fant,
  
  sou -- rit par -- mi ses lar -- mes_;
  ô sub -- li -- mes char -- mes_!
  
  %2
  Que nos voix a -- vec trans -- port
  pro -- cla -- ment le Dieu fort_!
  Verbe é -- ter -- nel,
  a fait jail -- lir les mon -- des
  et peu -- plé les on -- des.
  
  %3
  Dé -- sor -- mais de no -- tre cœur,
  re -- çois, ô Dieu vain -- queur,
  et la fer -- veur
  que ton a -- mour ré -- cla -- me.
  dans no -- tre_â -- me_!
  
  %4
  Doux Sau -- veur, il souf -- fri -- ra,
  la mort pour nous l'at -- ti -- re.
  Mais il res -- sus -- ci -- te -- ra,
  of -- frons, of -- frons la myr -- rhre.
  Les cé -- les -- tes mes -- sa -- gers
  ap -- pel -- lent les ber -- gers_:
  nous de pré -- sents, les bras char -- gés,
  por -- tons -_lui nos hom -- ma -- ges_:
  i -- mi -- tons les Ma -- ges.
  
  Les cé -- les -- tes mes -- sa -- gers
  ap -- pel -- lent les ber -- gers_:
  nous de pré -- sents, les bras char -- gés,
  por -- tons -_lui nos hom -- ma -- ges_:
  i -- mi -- tons les Ma -- ges.
}

PartPTwoVoiceOne = \relative b' {
  \global
  r2
  R1*17
  r2  b4  b4 | % 19

  a4  a4  g4  g4 | % 20
   fis2  g2 | % 21
   g4  fis8 [  g8 ]  a4  fis4 | % 22
   g4  g8 [  a8 ]  b4  b4 | % 23
   b4 r4 r2 | % 24
  r4  g8 [  a8 ]  b4  g8 [  a8 ] | % 25
   b4  b4  g2 | % 26
   g2  g4.  d8 | % 27
   g4  g4  fis2 | % 28
   d2 r2 | % 29

  R1*17
  
  r2  b'4  b4 | % 47
   a4  a4  g4  g4 | % 48
   fis2  g2 | % 49

   g4  fis8 [  g8 ]  a4  fis4 | % 50
   g4  g8 [  a8 ]  b4  b4 | % 51
   b4 r4 r2 | % 52
  r4  g8 [  a8 ]  b4  g8 [  a8 ] | % 53
   b4  b4  g2 | % 54
   g2  g4.  d8 | % 55
   g4  g4  fis2 | % 56
   d2  
   
   \markChanson "III. TRIO"
   \solo  d8 [  e8 ] d8 [ e8 ] | % 57
   fis4  g4  a4  fis4 | % 58
   d2  g4  g4 | % 59

   fis4  g4  fis8 [  e8  d8  c8 ] | % 60
   b2  d8 [  e8 ] d8 [ e8 ] | % 61
   fis4  g4  a4  fis4 | % 62
   d2  g8 [  a8 ] b8 d8 | % 63
   g,4  g4  fis8 [  e8  d8  c8 ] | % 64
   b2  b'4  b4 | % 65
   a4  a4  cis8 [  b8 ] a8 [ g8 ] | % 66
   fis2  g2 | % 67
   g4  fis8 [  g8 ]  a4  fis4 | % 68
   g4  g8 [  a8 ]  b4  b4 | % 69

   b4  b8 [  c8 ]  d4  d4 | % 70
   d4  g,8 [  a8 ]  b4  g8 [  a8 ] | % 71
   b4  b4  g2 | % 72
   b2 r2 | % 73
   d,4  e4  fis2 | % 74
   g2 \bar "||" \break
   b4  b4 | % 75
   a4  a4  cis8 [  b8 ] a8 [ g8 ] | % 76
   fis2  g2 | % 77
   g4  fis8 [  g8 ]  a4  fis4 | % 78
   g4  g8 [  a8 ]  b4  b4 | % 79

  b4  g8 [  a8 ]  b4  b4 | % 80
   b4  g8 [  a8 ]  b4  g8 [  a8 ] | % 81
   b4  b4  g2 | % 82
   g2 r2 | % 83
   d4  e4  fis2 | % 84
   g2  g4  g4 | % 85
   fis4  g4  a4  fis4 | % 86
   g4.  g8  g4  g4 | % 87
   fis4  g4  fis2 | % 88
   d2  g4  g4 | % 89

   fis4  g4  a4  fis4 | % 90
   g4  g4  g4  g4 | % 91
   g4  g4  fis2 | % 92
   d2  b'4  b4 | % 93
   b4  b4  b4  a8 [  g8 ] | % 94
   fis2  b2 | % 95
   a4  a8 [  fis8 ]  a8 [  g8 ]  fis4 | % 96
   g4  g8 [  a8 ]  b4  b4 | % 97
   b4  g8 [  a8 ]  b4  b4 | % 98
   b4  g8 [  a8 ]  b4  g8 [  a8 ] | % 99

   b4  b4  g2 | % 100
   g2  g4.  d8 | % 101
   g4  g4  fis2 | % 102
   d2  b'4  b4 | % 103
   b4  b4  b4  a8 [  g8 ] | % 104
   fis2  b2 | % 105
   a4  a8 [  e8 ]  a8 [  g8 ]  fis4 | % 106
   g4  g8 [  a8 ]  b4  b4 | % 107
   b4  g8 [  a8 ]  b4  b4 | % 108
   b4  g8 [  a8 ]  b4  g8 [  a8 ] | % 109

   b4  b4  g2 | % 110
   g2  g4.  d8 | % 111
   g4  g4  fis2 | % 112
  d1
}

altoLyrics = \lyricmode {
  À la crèche ac -- cou -- rons tous,
  Jé -- sus est né pour nous,
  l'au -- gus -- te_En -- fant,
  
  sou -- rit par -- mi ses lar -- mes_;
  ô sub -- li -- mes char -- mes_!
  
  %2
  Que nos voix a -- vec trans -- port
  pro -- cla -- ment le Dieu fort_!
  Verbe é -- ter -- nel,
  a fait jail -- lir les mon -- des
  et peu -- plé les on -- des.
  
  %3
  Il est roi, de son pou -- voir
  l'or se -- ra l'em -- blè -- me.
  Mais que doux est le de -- voir,
  il veut sur -- tout qu'on l'ai -- me.
  Dé -- sor -- mais de no -- tre cœur,
  re -- çois, ô Dieu vain -- queur,
  le tendre a -- mour et la fer -- veur
  que ton a -- mour ré -- cla -- me.
  dans no -- tre_â -- me_!
  
  Dé -- sor -- mais de no -- tre cœur,
  re -- çois, ô Dieu vain -- queur,
  le tendre a -- mour et la fer -- veur
  que ton a -- mour ré -- cla -- me.
  dans no -- tre_â -- me_!
  
  %4
  Doux Sau -- veur, il souf -- fri -- ra,
  la mort pour nous l'at -- ti -- re.
  Mais il res -- sus -- ci -- te -- ra,
  of -- frons, of -- frons la myr -- rhre.
  Les cé -- les -- tes mes -- sa -- gers
  ap -- pel -- lent les ber -- gers_:
  nous de pré -- sents, les bras char -- gés,
  por -- tons -_lui nos hom -- ma -- ges_:
  i -- mi -- tons les Ma -- ges.
  
  Les cé -- les -- tes mes -- sa -- gers
  ap -- pel -- lent les ber -- gers_:
  nous de pré -- sents, les bras char -- gés,
  por -- tons -_lui nos hom -- ma -- ges_:
  i -- mi -- tons les Ma -- ges.
}

PartPThreeVoiceOne = \relative d' {
  \global r2
  R1*17
  r2  d4  d4 | % 19

  d4  d4  cis4  cis4 | % 20
   d2  d2 | % 21
   d2  d2 | % 22
   d4 r4 r2 | % 23
  r4  b8 [  c8 ]  d4  d4 | % 24
   d4  b8 [  c8 ]  d4  b8 [  c8 ] | % 25
   d4  d4  c2 | % 26
   b2  b4.  d8 | % 27
   d4  e4  c2 | % 28
  b2  
  
  \markChanson "II. DUO"
  \solo b4  b4 | % 29

   a4  g4 d'4  d4 | % 30
   b2  d4  g,8 g8 | % 31
   c4  b4  a2 | % 32
   g2  b4  b4 | % 33
   a4  g4  d'4  d4 | % 34
   b4  b8 [  c8 ]  d4  g,4 | % 35
   c8 [  d8 ] b8 [ c8 ]  a4. ( g16 [  a16 ] ) | % 36
   g2 g'4  g4 | % 37
   fis4  fis4  e4  e4 | % 38
   d4 r4  d4 ( e4 ) | % 39

  d4  c8 [  b8 ]  c4  d4 | % 40
   b4  b8 [  c8 ]  d4  d4 | % 41
   d4  b8 [  c8 ]  d4  d4 | % 42
   d4  b8 [  c8 ]  d4  b8 [  c8 ] | % 43
   d4  d4  e2 | % 44
   d2  g,4.  a8 | % 45
   b4  c4  a2 | % 46
   g2 d'4  d4 | % 47
   d4  d4  cis4  cis4 | % 48
   d2  d2 | % 49

  d2  d2 | % 50
   d4 r4 r2 | % 51
  r4  b8 [  c8 ]  d4  d4 | % 52
   d4  b8 [  c8 ]  d4  b8 [  c8 ] | % 53
   d4  d4  c2 | % 54
   b2  b4.  d8 | % 55
   d4  e4  c2 | % 56
  b2  b4  b4 | % 57
   a4  g4 d'4  d4 | % 58
   b2  d4  g,4 | % 59

  c4  b4  a2 | % 60
   g2  b4  b4 | % 61
   a4  g4 d'4  d4 | % 62
   b4.  c8  d4  g,4 | % 63
   c4  b4  a2 | % 64
   g2  g'4  g4 | % 65
   fis4  fis4  e4  e4 | % 66
   d2  d4 ( e4 ) | % 67
   d4  c8 [  b8 ]  c4  d4 | % 68
   b4  b8 [  c8 ]  d4  d4 | % 69

  d4  g,8 [  a8 ]  b4  b4 | % 70
   b4  b8 [  c8 ]  d4  b8 [  c8 ] | % 71
   d4  d4  e2 | % 72
   d2  g,4.  a8 | % 73
   b4  c4  a2 | % 74
   g2  g'4  g4 | % 75
   fis4  fis4  e4  e4 | % 76
   d2  d4 ( e4 ) | % 77
   d4  c8 [  b8 ]  c4  d4 | % 78
   b4  b8 [  c8 ]  d4  d4 | % 79

   d4 r4 r2 | % 80
  r4  b8 [  c8 ]  d4  b8 [  c8 ] | % 81
   d4  d4  e2 | % 82
   d2  g,4.  a8 | % 83
   b4  c4  a2 | % 84
   g2  d'4  d4 | % 85
   d8 [  c8 ]  b4  a4  d4 | % 86
   d2  d2 | % 87
   d4  d4  c2 | % 88
   b2  d4  d4 | % 89

   d8 [  c8 ]  b4  a4  d4 | % 90
   d2  b2 | % 91
   e4  d4  c2 | % 92
   b2  e4  e4 | % 93
   d8 [  e8 ] fis8 [ d8 ]  g4  cis,4 | % 94
   d2  fis4  e8 [  d8 ] | % 95
   c4  e2  d4 | % 96
   d4 r2 b8 [  c8 ] | % 97
   d4  d4  d4  b8 [  c8 ] | % 98
   d4  d4  b8 [  c8 ]  d4 | % 99

   b8 [  c8 ]  d4  c2 | % 100
   b2  b4.  d8 | % 101
   d4  e4  c2 | % 102
   b2  e4  e4 | % 103
   d8 [  e8 ] fis8 [ d8 ]  g4  cis,4 | % 104
   d2  fis4  e8 [  b8 ] | % 105
   c4  e2  d4 | % 106
   d4 r4 r4  b8 [  c8 ] | % 107
   d4  d4  d4  b8 [  c8 ] | % 108
   d4  d4  b8 [  c8 ]  d4 | % 109

  b8 [  c8 ]  d4  c2 | % 110
   b2  b4.  d8 | % 111
   d4  e4  c2 | % 112
  b1
}

tenorLyrics = \lyricmode {
  %1
  À la crèche ac -- cou -- rons tous,
  Jé -- sus est né.
  
  si frêle et doux,
  sou -- rit par -- mi ses lar -- mes_;
  ô sub -- li -- mes char -- mes_!
  
  %2
  Il est Dieu, voi -- ci l'en -- cens
  dont le par -- fum l'ad -- o -- re.
  La priè -- re aux purs ac -- cents
  en s'ex -- hal -- ant l'im -- plo -- re.
  Que nos voix a -- vec trans -- port
  pro -- cla -- ment le Dieu fort_!
  Verbe é -- ter -- nel, ton seul ef -- fort
  a fait jail -- lir les mon -- des
  et peu -- plé les on -- des.
  
  Que nos voix a -- vec trans -- port
  pro -- cla -- ment Dieu_!
  
  ton seul ef -- fort
  a fait jail -- lir les mon -- des
  et peu -- plé les on -- des.
  
  %3
  Il est roi, de son pou -- voir
  l'or se -- ra l'em -- blè -- me.
  Mais que doux est le de -- voir,
  il veut sur -- tout qu'on l'ai -- me.
  Dé -- sor -- mais de no -- tre cœur,
  re -- çois, ô Dieu vain -- queur,
  le tendre a -- mour et la fer -- veur
  que ton a -- mour ré -- cla -- me.
  Rè -- gne dans no -- tre_â -- me_!
  
  Dé -- sor -- mais de no -- tre cœur,
  re -- çois, ô Dieu vain -- queur,
  le tendre a -- mour
  que ton a -- mour ré -- cla -- me.
  Rè -- gne dans no -- tre_â -- me_!
  
  %4
  Doux Sau -- veur, il souf -- fri -- ra,
  la mort l'at -- ti -- re.
  Mais il res -- sus -- ci -- te -- ra,
  of -- frons la myr -- rhre.
  Les cé -- les -- tes mes -- sa -- gers
  ap -- pel -- lent les ber -- gers_:
  nous de pré -- sents, les bras char -- gés,
  por -- tons l'hom -- ma -- ge_:
  i -- mi -- tons les Ma -- ges.
  
  Les cé -- les -- tes mes -- sa -- gers
  ap -- pel -- lent les ber -- gers_:
  nous de pré -- sents, les bras char -- gés,
  por -- tons l'hom -- ma -- ge_:
  i -- mi -- tons les Ma -- ges.
}

PartPFourVoiceOne = \relative g {
  \global r2
  R1*17
  r2  g8 [  a8 ] b8 [ g8 ] | % 19

  d'4  d4  a4  a4 | % 20
   d,4  d'8 [  c8 ]  b4 ( c4 ) | % 21
   b4 ( a8 [  g8 ] ) fis4  d4 | % 22
   g4 r4 r2 | % 23
  r4  g8 [  a8 ]  b4  b4 | % 24
   b4  g8 [  a8 ]  b4  g8 [  a8 ] | % 25
   b4  b4  c2 | % 26
   g2  e4.  fis8 | % 27
   g4  c,4  d2 | % 28
   <g g,>2  g4  g4 | % 29

  fis4  e4  fis4  d4 | % 30
   g2  f4  f8  f8  | % 31
   e4  c4  d2 | % 32
   g,2  g'4  g4 | % 33
   fis4  e4  fis4  d4 | % 34
   g2  f4  f4 | % 35
   e8 [  fis8 ] g8 c,8   d2 | % 36
   g,2  g8 [  a8 ] b8 [ c8 ] | % 37
   d8 [  e8 ] fis8 [ g8 ]  a4  a,4 | % 38
   d4  d'8 [  c8 ]  b4 ( c4 ) | % 39

   b4  a8 ( [  g8 ] fis4 ) d4 | % 40
   g4  g8 [  a8 ]  b4  b4 | % 41
   b4  g8 [  a8 ]  b4  b4 | % 42
   b4  g8 [  a8 ]  b4  g8 [  a8 ] | % 43
   b4  g4  c4  c,4 | % 44
   g'8 [  a8  g8  fis8 ]  e8 [  d8  e8  fis8 ] | % 45
   g4  c,4  d2 | % 46
   g,2  g8 [  a8 ] b8 [ c8 ] | % 47
   d8 [  e8 ] fis8 [ g8 ]  a4  a,4 | % 48
   d4  d'8 [  c8 ]  b4 ( c4 ) | % 49

   b4  a8 ( [  g8 ]  fis4 ) d4 | % 50
   g4 r4 r2 | % 51
  r4  g8 [  a8 ]  b4  b4 | % 52
   b4  g8 [  a8 ]  b4  g8 [  a8 ] | % 53
   b4  g4  c4  c,4 | % 54
   g'8 [  a8  g8  fis8 ]  e8 [  d8  e8  fis8 ] | % 55
   g4  c,4  d2 | % 56
   <g g,>2  g4  g4 | % 57
   d4  e4  fis4  d4 | % 58
   g2  b4  b4 | % 59

   a4  g4  d2 | % 60
   g2  g4  g4 | % 61
   d4  e4  fis4  d4 | % 62
   g2  f4  f4 | % 63
   e8 [  fis8 ] g8 c,8  d2 | % 64
   g,2  g'8 [  a8 ] b8 [ g8 ] | % 65
   d'4  d4  a4  a4 | % 66
   d,4 d'8 [  c8 ]  b4 ( c4 | % 67
   b4 ) a8 [  g8 ]  fis4  d4 | % 68
   g2  g2 | % 69

   g2  g2 | % 70
   g2  g2 | % 71
   g2  c2 | % 72
   g2  e4.  fis8 | % 73
   g4  c,4  d2 | % 74
   g,2  g'8 [  a8 ] b8 [ g8 ] | % 75
   d'4  d4  a4  a4 | % 76
   d,4  d'8 [  c8 ]  b4 ( c4 | % 77
   b4 ) a8 [  g8 ]  fis4  d4 | % 78
   g2  g2 | % 79

   g2  g2 | % 80
   g2  g2 | % 81
   g2  <c, c'>2 | % 82
   g'2  e4.  fis8 | % 83
   g4  c,4  d2 | % 84
   <g, g'>2  g'4  g4 | % 85
   d4  e4  fis4  d4 | % 86
   g2  b2 | % 87
   a4  g4  d2 | % 88
   g2  g4  g4 | % 89

   d4  e4  fis4  d4 | % 90
   g2  f4  f4 | % 91
   e8 [  fis8 ] g8  c,8  d2 | % 92
   g,2  g'8 [  a8 ] b8 [ g8 ] | % 93
   b8 [  cis8 ] d8 [ b8 ]  g8 [  e8 ]  a4 | % 94
   d,4  d'8 [  c8 ]  b8 [  a8 ]  gis4 | % 95
   a4. ( gis8 ) a4 ( d,4 ) | % 96
   g4 r2  g8 [  a8 ] | % 97
   b4  b4  b4  g8 [  a8 ] | % 98
   b4  b4  g8 [  a8 ]  b4 | % 99

  g8 [  a8 ]  b4  c2 | % 100
   g2  e4.  fis8 | % 101
   g4  c,4  d2 | % 102
   g2  g8 [  a8 ] b8 [ g8 ] | % 103
   b8 [  cis8 ] d8 [ b8 ]  g8 [  e8 ]  a4 | % 104
   d,4  d'8 [  c8 ]  b8 [  a8 ]  gis4 | % 105
   a4. ( gis8 ) a4 ( d,4 ) | % 106
   g4 r4 r4  g8 [  a8 ] | % 107
   b4  b4  b4  g8 [  a8 ] | % 108
   b4  b4  g8 [  a8 ]  b4 | % 109

   g8 [  a8 ]  b4  c2 | % 110
   g2  e4.  fis8 | % 111
   g4  c,4  d2 | % 112
  <g g,>1
}

bassLyrics = \lyricmode {
  %1
  À la crèche ac -- cou -- rons tous,
  Jé -- sus est né pour nous.
  
  si frêle et doux,
  sou -- rit par -- mi ses lar -- mes_;
  ô sub -- li -- mes char -- mes_!
  
  %2
  Il est Dieu, voi -- ci l'en -- cens
  dont le par -- fum l'ad -- o -- re.
  La priè -- re aux purs ac -- cents
  en s'ex -- hal -- ant l'im -- plo -- re.
  Que nos voix a -- vec trans -- port
  pro -- cla -- ment le Dieu fort_!
  Verbe é -- ter -- nel, ton seul ef -- fort
  a fait jail -- lir les mon -- des
  et peu -- plé les on -- des.
  
  Que nos voix a -- vec trans -- port
  pro -- cla -- ment le Dieu fort_!
  
  ton seul ef -- fort
  a fait jail -- lir les mon -- des
  et peu -- plé les on -- des.
  
  %3
  Il est roi, de son pou -- voir
  l'or se -- ra l'em -- blè -- me.
  Mais que doux est le de -- voir,
  il veut sur -- tout qu'on l'ai -- me.
  Dé -- sor -- mais de no -- tre cœur,
  re -- çois, ô Dieu vain -- queur,
  le tendre a -- mour et la fer -- veur
  Rè -- gne dans no -- tre_â -- me_!
  
  Dé -- sor -- mais de no -- tre cœur,
  re -- çois, ô Dieu vain -- queur,
  le tendre a -- mour et la fer -- veur
  Rè -- gne dans no -- tre_â -- me_!
  
  %4
  Doux Sau -- veur, il souf -- fri -- ra,
  la mort l'at -- ti -- re.
  Mais il res -- sus -- ci -- te -- ra,
  of -- frons, of -- frons la myr -- rhre.
  Les cé -- les -- tes mes -- sa -- gers
  ap -- pel -- lent les ber -- gers_:
  nous de pré -- sents, les bras char -- gés,
  por -- tons l'hom -- ma -- ge_:
  i -- mi -- tons les Ma -- ges.
  
  Les cé -- les -- tes mes -- sa -- gers
  ap -- pel -- lent les ber -- gers_:
  nous de pré -- sents, les bras char -- gés,
  por -- tons l'hom -- ma -- ge_:
  i -- mi -- tons les Ma -- ges.
}


\tocItemComposer "Cantate de Noël" "Daquin"
\score {
  \header {
    title = "CANTATE DE NOËL"
    composer = \daquin
    poet = \markup \column {
      "Paroles : Chanoine Gustave Gaillardon (1864–1925)"
      \vspace #1
    }
  }
  \new ChoirStaff \with {
    midiInstrument = "choir aahs"
  } <<
    \new Staff \with {
      shortInstrumentName = "S."
      instrumentName = "S."
    } \new Voice = "soprano" \PartPOneVoiceOne
    \new Lyrics \with {
      \override VerticalAxisGroup.staff-affinity = #CENTER
    } \lyricsto "soprano"  \sopranoLyrics
    
    \new Staff \with {
      shortInstrumentName = "A."
    } \new Voice = "alto" \PartPTwoVoiceOne
    \new Lyrics \with {
      \override VerticalAxisGroup.staff-affinity = #CENTER
    } \lyricsto "alto"  \altoLyrics
    
    \new Staff \with {
      shortInstrumentName = "T."
      \clef "treble_8"
    } \new Voice = "tenor" \PartPThreeVoiceOne
    \new Lyrics \with {
      \override VerticalAxisGroup.staff-affinity = #CENTER
    } \lyricsto "tenor"  \tenorLyrics
    
    \new Staff \with {
      shortInstrumentName = "B."
      \clef bass
    } \new Voice = "bass" \PartPFourVoiceOne
    \new Lyrics \with {
      \override VerticalAxisGroup.staff-affinity = #CENTER
    } \lyricsto "bass"  \bassLyrics
    
  >>
  \layout {\context{\Staff \RemoveAllEmptyStaves }}
  \midi { \tempo 4 = 120 }
}

