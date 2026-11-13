\version "2.26.0"

global = {
  \autoBeamOff
  \mergeDifferentlyHeadedOn
  \mergeDifferentlyDottedOn
  \key a \major
  \time 2/2
}



% ===== soprano =====
soprano = \fixed c' {
  \global
  R1*3
  r2 a2~ | % 3
  a2 a2 | % 4
  b2 a4 e4 | % 5
  a4. b8 cis'4 cis'4 | % 6
  d'2 cis'4 b4 | % 7
  cis'4 e'4. d'8 cis'4 ~ | % 8
  cis'4 b4 cis'2 | % 9
  e'4. d'8 cis' [ b ] cis'4~ | % 10
  cis'8 [ b ] a2 gis4 | % 11
  a1 | % 12
  R1 | % 13
  r2 a2 ~ | % 14
  a2 a2 | % 15
  b2 a4 e4 | % 16
  a4. b8 cis'4 cis'4 | % 17
  d'2 cis'4 a8 [ b ] | % 18
  cis' [ d' e' cis' ] d'2 | % 19
  cis'4 b4. a8 a4~ | % 20
  a4 gis8 [ fis ] gis2 | % 21
  a1 | % 22
  R1*2
  r2 a2~ | % 25
  a2 gis2 | % 26
  fis4. gis8 a4 b4~ | % 27
  b8 [ a ] a2 gis4 | % 28
  fis4 e4 fis4 fis4 | % 29
  e1 | % 30
  R1*2
  r2 b2 ~ | % 33
  b2 a2 | % 34
  gis4. a8 b4 cis'4~ | % 35
  cis'4 b4 cis'2 ~ | % 36
  cis'4 b8 [ a ] b2 | % 37
  a4. gis8 fis2 | % 38
  r2 d'2~ | % 39
  d'4 cis'4 cis'2 | % 40
  b1 | % 41
  a1 | % 42
  r4 a4 b4 d'4~ | % 43
  d'4 cis'4 b2~ | % 44
  b2 a4. b8 | % 45
  cis'4 b8 [ a ] b2 | % 46
  R1 | % 47
  d'2. cis'4 | % 48
  cis'2 b2~ | % 49
  b2 a2 | % 50
  r4 a4 b4 d'4~ | % 51
  d'4 cis'4 b4. a8 | % 52
  fis8 [ gis ] a2 gis4 | % 53
  a1 ~ 1 ~ 1 ~ 1 |\break
}
  
sopranoSuite = \fixed c' {
  r2 a2 | % 57
  cis'2 e'4 e'4~ | % 58
  e'8 e' e'4 d'2 | % 59
  cis'2. b4 | % 60
  cis'4 d'4 e'2 ~ | % 61
  e'4 cis'4 b2 | % 62
  b2 r4 a8 [ b ] | % 63
  cis' [ d' ] e'4 cis'4 a4 | % 64
  b2 a2 ~ | % 65
  a4 gis4 a4 b4 | % 66
  cis'4 a4 b2 | % 67
  cis'2 r2 | % 68
  r4 b4 cis'4 d'4 | % 69
  e'4 cis'4 b2 | % 70
  a4 b4. a8 a4 ~ | % 71
  a4 gis8 [ fis ] gis2 | % 72
  a2 r4 a4~ | % 73
  a4 b4 cis'4. d'8 | % 74
  e'4 cis'2 d'4 | % 75
  e'4 cis'4. b8 [ cis' a ] | % 76
  b2 a4 fis4~ | % 77
  fis4 gis4 a4. b8 | % 78
  cis'4 a4 b4 cis'4 | % 79
  a2 gis4 b4 | % 80
  cis'4 e'4. d'8 cis'4 | % 81
  b4 a8 [ gis ] a [ gis gis fis16 e ] | % 82
  fis2 e4 gis4 | % 83
  a4 cis'4. b8 a4 | % 84
  gis8 [ a b gis ] a2 | % 85
  a1 ~ 1 | % 87
  r4 a4 cis'4 cis'4 | % 88
  e'2 b2~ | % 89
  b2 r2 | % 90
  R1 | % 91
  fis'2. e'4 | % 92
  e'4. d'8 cis'4 b4 | % 93
  a2 gis2 | % 94
  cis'1 | % 95
  b4 b4 gis4 a4 | % 96
  b4. a16 [ gis ] fis2 | % 97
  gis4 b2 cis'4~ | % 98
  cis'8 8 cis'4 d'2 | % 99
  cis'4 a4 b4. b8 | % 100
  cis'2 r2 | % 101
  r4 fis'4. e'8 d'4 | % 102
  cis'4 b4 a4 b4~ | % 103
  b8 [ a ] a2 gis4 | % 104
  a1 | % 105
  R1*2
  r4 b4 cis'4. cis'8 | % 108
  cis'2 d'2 | % 109
  cis'2 a2 | % 110
  b4 cis'4 fis4 fis'4~ | % 111
  fis'8 e' d'4 cis'4 b4 | % 112
  a4 b4. a8 a4~ | % 113
  a4 gis8 [ fis ] gis2 |
  a1 \bar "|."
}

sopranoVerseOne = \lyricmode {
  Sí -- cut cér -- vus
  de -- sí -- de -- rat
  ad fón -- tes
  a -- quá -- _ _ _ _ rum,
  a -- _ _ _ _ quá -- rum,
  sí -- cut cér -- vus
  de -- sí -- de -- rat
  ad fón -- tes a -- _ _ _ quá -- _ _ _ _ rum_:
  í -- ta de -- _ _ sí -- _ _ _ _ _ de -- rat,
  í -- ta de -- _ _ sí -- de -- rat __ _ _ _ _ _
  á -- ni -- ma mé -- a
  ad te Dé -- _ _ us, __ _ _ _ _ 
  á -- ni -- ma mé -- a
  ad te
  Dé -- _ _ _ _ _ _ us. __
}
sopranoVerseSuite = \lyricmode {
  Si -- tí -- vit á -- ni -- ma mé -- a
  ad Dé -- um
  fón -- tem ví -- vum,
  á -- _ _ ni -- ma mé -- a __
  ad Dé -- um
  fón -- tem ví -- vum,
  ad Dé -- um 
  fón -- tem ví -- vum,
  ví -- _ _ _ _ vum_:
  quán -- do vé -- ni -- am
  et ap -- pa -- re -- _ _ bo,
  quán -- do vé -- ni -- am
  et ap -- pa -- ré -- bo
  án -- te fá -- ci -- em De -- _ _ _ i,
  án -- te fá -- ci -- em De -- _ i_? __
  Fu -- é -- runt mí -- hi __
  lá -- chri -- mæ __ _ _ _ mé -- æ
  pá -- nes dí -- e
  ac no -- _ _ cte,
  dum dí -- ci -- tur mí -- hi
  quo -- ti -- dí -- e
  ú -- bi est
  Dé -- us tú -- _ _ _ us,
  dum dí -- ci -- tur
  mí -- hi
  quo -- ti -- dí -- e
  ú -- bi est Dé -- us tu _ _ _ _ _ -- us_?
}

% ===== alto =====
alto = \fixed c' {
  \global
  R1 | % 1
  R1 | % 2
  e1 |
  e2 fis2 | % 3
  e4 cis4 fis4. e8 | % 4
  fis4 gis4 a2 | % 5
  e2 e4 fis4~ | % 6
  fis8 [ e fis gis ] a4 gis4 | % 7
  a2 gis2 | % 8
  R1 | % 9
  a1 | % 10
  a2 b2 | % 11
  a4 a,4 cis4. d8 | % 12
  e4 fis4. e8 d4~ | % 13
  d8 [ cis ] 4 fis2 | % 14
  e4 e4 a,2 | % 15
  e2. cis4 | % 16
  cis4. d8 e4 e4 | % 17
  fis2 e2 | % 18
  a2 a2~ | % 19
  a4 gis4 fis2 | % 20
  e1 | % 21
  cis4. b,8 cis8 [ d ] cis4 ~ | % 22
  4 b,8 [ a, ] b,2 | % 23
  a,1 | % 24
  R1*2
  d1 | % 27
  cis2 b,4. cis8 | % 28
  d4 e4. d8 d4~ | % 29
  d4 cis8 [ b, ] cis2~ | % 30
  cis4 cis4 b,2 | % 31
  fis1 ~ | % 32
  fis2 e2 ~ | % 33
  e2 r2 | % 34
  1 | % 35
  d2 cis4. d8 | % 36
  e4 fis2 e4 | % 37
  fis2. e8 [ d ] | % 38
  e2 d2 | % 39
  r2 a2~ | % 40
  a4 gis4 gis2 | % 41
  fis2 e2 ~ | % 42
  e2 d4. e8 | % 43
  fis4 e4 e2 | % 44
  e2 r4 a4~ | % 45
  a4 gis4 gis2 | % 46
  fis2 e2 | % 47
  d4. e8 fis4 e4~ | % 48
  e4 a2 gis4 | % 49
  fis1 ~ | % 50
  fis2 d4. e8 | % 51
  fis2 d4 fis4 ~ | % 52
  fis4 e4 e2 | % 53
  r4 e4 fis4 a4 ~ | % 54
  a8 [ gis fis e ] d4 e4 | % 55
  fis1 | % 56
  e1 |
}
altoSuite = \fixed c' {
  e2 fis2 | % 57
  a4 a4. a8 a4 | % 58
  gis2 fis2~ | % 59
  fis4 e4 fis4 gis4 | % 60
  a4 fis4 e8 [ d cis b, ] | % 61
  a,4 a2 gis8 [ fis ] | % 62
  gis2 a4 fis4 | % 63
  e4 cis8 [ d ] e [ cis ] fis4 ~ | % 64
  fis8 [ e ] e4 fis2 | % 65
  b,2 r2 | % 66
  e2 fis2 | % 67
  a4 a4. a8 a4 | % 68
  gis2 fis2 | % 69
  r4 e4 fis4 gis4 | % 70
  a4 gis8 [ fis ] e4 d4 | % 71
  e1 | % 72
  cis4 d2 e4 | % 73
  fis4. gis8 a4 fis4 | % 74
  gis4 a4 fis2 | % 75
  e4. fis8 gis4 a4~ | % 76
  a4 gis4 a4. gis8 | % 77
  fis4 e8 [ d ] cis4 fis | % 78
  e4 fis4 e4 e4 | % 79
  a,2 b,2 | % 80
  r4 e4 gis4 a4 | % 81
  gis4 fis4. e8 e4~ | % 82
  e4 d4 cis4 b,4 | % 83
  a,4. b,8 cis2 | % 84
  r4 e4 fis4 a4~ | % 85
  a8 gis8 fis4 e2 | % 86
  fis4 d4 fis4 fis4 | % 87
  a2 e2~ | % 88
  e2 g2~ | % 89
  g4 fis4 fis2 ~ | % 90
  fis4 e4 d4 cis4 ~ | % 91
  cis4 b,4 cis2 | % 92
  r2 a,2~ | % 93
  a,2 b,4 e4 | % 94
  e8 [ d cis b, ] a,4 a | % 95
  gis4 fis4. e8 e4~ | % 96
  e4 dis8 [ cis ] dis2 | % 97
  e4 gis2 a4~ | % 98
  a8 a8 a4 a2 | % 99
  a4 e4 fis4 gis4 | % 100
  a4 fis4 e4. e8 | % 101
  fis2 r4 a4 ~ | % 102
  a8 gis8 fis4 e4 d4 | % 103
  e4 fis2 e8 [ d ] | % 104
  cis4. b,8 a,2 | % 105
  r4 fis4. e8 d4 | % 106
  cis4 b,4 cis4 d4 | % 107
  b,2 a,4 e4 | % 108
  a4. a8 a2 | % 109
  a2 e4 fis4 | % 110
  e4 e4 a4. gis8 | % 111
  fis2 r4 fis4 ~ | % 112
  fis8 fis8 e4 e4 fis4 | % 113
  e1 |
  e1 |
}

altoVerseOne = \lyricmode {
  Sí -- cut cér -- vus
  de -- sí -- de -- rat
  ad fón -- tes a -- quá -- _ _ _ rum,
  sí -- cut cér -- vus
  de -- sí -- de -- rat
  ad __ _ _ _ fón -- tes
  a -- quá -- rum,
  de -- sí -- de -- rat
  ad fón -- tes
  a -- quá -- _ _ _ _ _ _ _ _ _ rum_:
  í -- ta de -- _ _ sí -- _ _ _ _ de -- rat,
  í -- ta, í -- ta
  de -- _ _ sí -- de -- rat __ _ _ _
  á -- ni -- ma mé -- a
  ad __ _ _ te Dé -- us,
  á -- ni -- ma mé -- a
  ad __ _ _ te __ Dé -- _ us __
  ad __ _ _ te Dé -- _ us,
  ad te
  Dé -- _ _ _ us.
}
altoVerseSuite = \lyricmode {
  Si -- tí -- vit
  á -- ni -- ma mé -- a __
  ad Dé -- um
  fón -- __ __ __ tem ví -- _ _ _ _ vum,
  á -- ni -- ma __ _ _ _ mé -- a,
  si -- tí -- vit
  á -- ni -- ma mé -- a
  ad Dé -- um
  fón -- _ _ tem ví -- vum_:
  quán -- do vé -- ni -- am
  et ap -- pa -- ré -- bo, __ _ _
  quán -- do
  vé -- _ _ _ _ ni -- am
  et ap -- pa -- ré -- bo
  án -- te fá -- ci -- em __ _ _ _
  De -- _ i, __ _ _
  án -- te fá -- ci -- em Dé -- i_?
  Fu -- é -- runt mí -- hi __
  lá -- chri -- mæ __ _ _ mé -- _ æ
  pá -- nes  dí -- e __ _
  ac no -- _ _ _ _ _ cte,
  dum dí -- ci -- tur
  mí -- hi quo -- ti -- dí -- e,
  quo -- ti -- dí -- e
  ú -- bi est
  Dé -- us tú -- _ _ _ _ us,
  ú -- bi est
  Dé -- us tú -- _ _ us,
  dum dí -- ci -- tur mí -- hi
  quo -- ti -- dí -- e __ _ _
  ú -- bi est
  Dé -- us tú -- us_?
}

% ===== tenor =====
tenor = \fixed c {
  \global
  a1 |
  a2 b2 | % 1
  a4 e4 a4. b8 | % 2
  cis'4 cis'4 d'2 | % 3
  cis'4 a4 d'4. cis'8 | % 4
  d'4 e'4 cis'2~ | % 5
  cis'2 r2 | % 6
  r2 e'2~ | % 7
  e'2 e'2 | % 8
  fis'2 e'4 a4 | % 9
  cis'4. d'8 e'4 e'4 | % 10
  fis'2 e'2 | % 11
  cis'4. d'8 e'4 a4 | % 12
  cis'2 d'4. e'8 | % 13
  fis'4 e'4. d'8 d'4~ | % 14
  d'4 cis'8 [ b ] cis'4 a4~ | % 15
  a4 gis4 a2 ~ | % 16
  a2 r2 | % 17
  r4 a4 cis'4. d'8 | % 18
  e'4 e'4 fis'2 | % 19
  e'4. d'8 cis'4 d'4 | % 20
  b1 | % 21
  a2 r2 | % 22
  e'1 | % 23
  d'2 cis'4. d'8 | % 24
  e'4 fis'4. e'8 e'4~ | % 25
  e'4 d'4 e'2 | % 26
  a2 r2 | % 27
  r2 r4 b4 | % 28
  b4 cis'4 d'4 d'4 | % 29
  a2 r2 | % 30
  e'1 | % 31
  d'2 cis'4 d'4~ | % 32
  d'8 [ cis'8 ] 4 b4 4 | % 33
  e4 b4 cis'4 cis'4 | % 34
  b2 r2 | % 35
  r2 a2~ | % 36
  a2 gis2 | % 37
  fis4. gis8 a4 b4~ | % 38
  b8 [ a ] a2 gis4 | % 39
  a4. b8 cis'4. d'8 | % 40
  e'2 r2 | % 41
  r4 d'2 cis'4 | % 42
  cis'2 b2 | % 43
  a2 e2~ | % 44
  e4 b4 cis'4 d'4 | % 45
  e'4 e8 [ fis ] gis [ a b gis ] | % 46
  a4 b4. a8 a4 ~ | % 47
  a4 gis4 a2 | % 48
  R1 | % 49
  r4 d'2 cis'4 | % 50
  cis'2 b2 | % 51
  a4 a4 b4 d'4~ | % 52
  d'4 cis'4 b2 | % 53
  a2 r4 cis'4 | % 54
  d'4 fis'2 e'4 | % 55
  d'1 | % 56
  cis'1 |\bar "||"
}
tenorSuite = \fixed c {
  R1*4
  r2 a2 | % 61
  cis'2 e'4 e'4~ | % 62
  e'8 8 4 d'2 | % 63
  cis'1 | % 64
  r4 b4 cis'4 d'4 | % 65
  e'2 d'2 | % 66
  cis'8 [ d' e' cis' ] d' [ e' ] fis'4~ | % 67
  8 [ e' ] 2 dis'4 | % 68
  e'2 r4 b4 | % 69
  cis'4. cis'8 d'4 e'4 | % 70
  cis'4 b4 cis'4 b8 [ a ] | % 71
  b1 | % 72
  a1 | % 73
  R1 | % 74
  r4 a2 b4 | % 75
  cis'4. d'8 e'4 cis'4 | % 76
  d'4 e'4 cis'4 d'4~ | % 77
  d'4 cis'8 [ b ] a4 d'4 | % 78
  cis'2 b4 e'4~ | % 79
  e'8 [ dis'16 cis' ] dis'4 e'2 ~ | % 80
  e'2 r4 a4 | % 81
  b4 d'4. e'8 cis'4 | % 82
  b2 e'2 | % 83
  r2 a2 | % 84
  b2 d'4. d'8 | % 85
  cis'4 d'4. cis'16 [ b ] cis'4 | % 86
  d'1 | % 87
  r2 r4 a4 | % 88
  cis'4 cis'4 e'2 | % 89
  d'4 d'2 cis'4 | % 90
  cis'4. b8 a4 gis4 | % 91
  fis2 gis2 | % 92
  cis'1 | % 93
  d'2 e'4. d'8 | % 94
  cis'8 [ b a b ] cis' [ d' ] e'4 ~ | % 95
  4 d' e'2 |
  fis'2 b2 | % 97
  r4 b4 e'4. e'8 | % 98
  e'2 fis'2 | % 99
  e'4 cis'4 d'4 e'4 | % 100
  a4 a4 b4 cis'4 | % 101
  d'2 r4 fis'4~ | % 102
  fis'8 e'8 d'4 cis'4 b4 | % 103
  cis'4 d'4 b2 | % 104
  a2 r4 fis'4~ | % 105
  fis'8 e'8 d'4 cis'4 b4 | % 106
  a4 b4. a8 a4~ | % 107
  a4 gis4 a4 cis'4 | % 108
  fis'4. fis'8 fis'2 | % 109
  e'2 cis'4 d'4 | % 110
  d'4 cis'4 d'2 | % 111
  r4 fis'4. e'8 d'4 | % 112
  cis'4 b4 cis'4 d'4 | % 113
  b1 |
  cis'
}

tenorVerseOne = \lyricmode {
  Sí -- cut cér -- vus
  de -- sí -- dé -- rat
  ad fón -- tes a -- quá -- _ _ _ rum, __
  sí -- cut cér -- vus
  de -- sí -- de -- rat
  ad fón -- tes
  a -- _ _ _ quá -- _ _ _ _ _ _ _ _ _ _ rum, __ de --
  sí -- de -- rat
  ad fón -- tes __ _ _
  a -- quá -- rum_:
  í -- ta de -- _ _ sí -- _ _ de -- rat, __ _
  í -- ta de -- sí -- de -- rat,
  í -- ta de -- sí -- _ _ de -- rat,
  de -- sí -- de -- rat,
  í -- ta de -- _ _ sí -- _ de -- rat, __ _ _ _ _
  á -- ni -- ma mé -- _ a __
  ad __ _ te __ _
  Dé -- _ _ _ _ _ _ us,
  á -- ni -- ma mé -- a
  ad te Dé -- _ _ us,
  ad te Dé -- _ _ us.
}
tenorVerseSuite = \lyricmode {
  Si -- tí -- vit
  á -- ni -- ma mé -- a
  ad Dé -- um
  fón -- tem
  ví -- _ _ _ _ vum,
  ad Dé -- um fón -- tem
  ví -- _ _ _ _ vum_:
  quán -- do vé -- ni -- am
  et ap -- pa -- ré -- bo, __ _ _
  et ap -- pa -- re -- _ bo __
  án -- te fá -- ci -- em Dé -- i,
  án -- te fá -- ci -- em De -- _ _ i_?
  Fu -- é -- runt mí -- hi
  lá -- chri -- mæ __ _ _ _
  mé -- æ
  pá -- nes di -- _ _ _ _ e
  ac nó -- cte,
  dum dí -- ci -- tur
  mí -- hi quo -- ti -- dí -- e,
  quo -- ti -- dí -- e
  ú -- bi est Dé -- us tú -- _ _ us,
  ú -- bi est Dé -- us
  tú -- _ _ _ _ us,
  dum dí -- ci -- tur mí -- hi
  quo -- ti -- dí -- e
  ú -- bi est Dé -- us tú -- _ _ us_?
}

% ===== bass =====
bass = \fixed c {
  \global
  R1*5
  r2 a2~ | % 5
  a2 a2 | % 6
  b2 a4 e4 | % 7
  a4. b8 cis'4 cis'4 | % 8
  d'2 cis'4 cis'4 | % 9
  a2 a2 | % 10
  R1 | % 11
  a1 | % 12
  a2 b2 | % 13
  a2 d2 | % 14
  a4. gis8 fis4 fis4 | % 15
  e2 a,2 | % 16
  r4 a4 a4 a4 | % 17
  d8 [ e fis gis ] a2 | % 18
  a2 d2 | % 19
  e4 e4 fis4 d4 | % 20
  e1 | % 21
  r2 a2~ | % 22
  a2 gis2 | % 23
  fis4. gis8 a4 fis4 | % 24
  gis4 a4. gis8 fis [ e ] | % 25
  fis2 e2 | % 26
  d4. e8 fis4 gis4 | % 27
  a2 e2 | % 28
  R1 | % 29
  r2 a2~ | % 30
  a2 gis2 | % 31
  fis4. gis8 a4 b4~ | % 32
  b8 [ a ] a2 gis8 [ fis ] | % 33
  gis2 a2 | % 34
  e1 | % 35
  R1*2
  d1 | % 38
  cis2 b,2 | % 39
  fis4. gis8 a4 a4 | % 40
  e2. e4 | % 41
  fis4 d4 a2 ~ | % 42
  a2 r2 | % 43
  r4 a2 gis4 | % 44
  gis2 fis2 | % 45
  e2 e2 | % 46
  fis4 d2 cis4 | % 47
  b,2 a,2 | % 48
  a2 e4 e4 | % 49
  b2 fis2 | % 50
  fis2 b,4. cis8 | % 51
  d8 [ e ] fis4 b,4. cis8 | % 52
  d4 a,4 e4 e4 | % 53
  fis4 a4. gis8 fis [ e ] | % 54
  d2. cis4 | % 55
  d1 | % 56
  a,1 | % 57
}
bassSuite = \fixed c {
  R1*6
  e2 fis2 | % 63
  a4 a4. a8 a4 | % 64
  gis2 fis2 | % 65
  e2 fis4 gis4 | % 66
  a4 cis'4 b2 | % 67
  a4. gis8 fis2 | % 68
  e2 r2 | % 69
  r2 r4 e4 | % 70
  fis4 gis4 a4 fis4 | % 71
  e1 | % 72
  a,4 d2 cis4 | % 73
  d4 b,4 fis2 | % 74
  R1*2
  r2 r4 d4~ | % 77
  d4 e4 fis4. gis8 | % 78
  a4 fis4 gis4 a4 | % 79
  fis2 e4. d8 | % 80
  cis2 r2 | % 81
  R1 | % 82
  r2 r4 e4 | % 83
  fis4 a4. gis8 fis4 | % 84
  e2 d8 [ 8 fis gis ] | % 85
  a1 | % 86
  r2 d2 | % 87
  fis4 fis4 a2 | % 88
  a2 r2 | % 89
  b2. a4 | % 90
  a4. gis8 fis4 e4 | % 91
  d2 cis2~ | % 92
  cis2 fis2~ | % 93
  fis2 e2 | % 94
  a1 | % 95
  b2 cis'2 | % 96
  b1 | % 97
  e4 e2 a4~ | % 98
  a8 8 a4 d2 | % 99
  a2 r2 | % 100
  r4 fis4 g4 a4 | % 101
  d1 | % 102
  R1 | % 103
  r4 d4 d4 e4 | % 104
  fis4 fis4. e8 d4 | % 105
  cis4 b,4 a,4 b,4 | % 106
  fis4 g4 fis4 d4 | % 107
  e2 r4 a4 | % 108
  fis4. 8 d2 | % 109
  a2 a4 fis | % 110
  g a d d'~ | % 111
  d'8 cis'8 b4 ais4 b4 | % 112
  fis4 gis a d | % 113
  e1 | % 114
  a,
}

bassVerseOne = \lyricmode {
  Sí -- cut cér -- vus
  de -- sí -- de -- rat ad fón -- tes a -- quá --
  rum,
  sí -- cut cér -- vus
  de -- sí -- de -- rat
  ad fón -- tes,
  de -- sí -- de -- rat __ _
  ad fón -- tes
  a -- quá -- _ rum
  í -- ta de -- _ _ _ _ sí -- _ _ _ _ _ _ _ de -- rat, __ _
  í -- ta de -- _ _ sí -- _ _ _ de -- rat,
  í -- ta de -- sí -- _ _ de -- rat,
  de -- sí -- de -- rat __
  á -- ni -- ma mé -- a
  ad te Dé -- _ _ us,
  á -- ni -- ma mé -- a
  ad te __ _ _ _ Dé -- _ _ _ us,
  ad te Dé -- _ _ _ _ _ us.
}
bassVerseSuite = \lyricmode {
  Si -- tí -- vit
  á -- ni -- ma mé -- a
  ad Dé -- um fón -- tem
  ví -- _ _ _ vum,
  ad Dé -- um fón -- tem ví -- vum_:
  quán -- do vé -- ni -- am,
  quán -- do vé -- ni -- am
  et ap -- pa -- ré -- bo __ _ _
  án -- te fá -- ci -- em
  Dé -- i_? __ _
  Fu -- é -- runt mí -- hi
  lá -- chri -- mæ __ _ _ _
  mé -- æ __
  pá -- nes dí -- e
  ac nó -- cte,
  dum dí -- ci -- tur mí -- hi
  quo -- ti -- dí -- e,
  quo -- ti -- dí -- e
  ú -- bi est Dé -- us tú -- _ _ _ _ _ us,
  dum dí -- ci -- tur mí -- hi
  quo -- ti -- dí -- e
  ú -- bi est
  Dé -- us tú _ _ _ _ -- us_?
}
