\version "2.26.0"
\include "settings.ily"
\include "composers.ily"

global = {
  \autoBeamOff
  \mergeDifferentlyHeadedOn
  \mergeDifferentlyDottedOn
  \key es \major
  \time 4/4
}

soprano = \relative c'' {
  \global
  R1
  bes2 2 |
  es,4 f g8 [ as bes g ] |
  as2 f |
  es4 bes'2 4 ~ |
  8 8 4 es2 |
  d bes4 c |
  as2 g4 es' |
  d es c2 |
  bes r4 4 |
  2 g4 f |
  es2 d4 d' ~ |
  4 4 4 4 |
  es2 d4 c ~ |
  8 [ bes ] 2 a4 |
  bes1 |\bar "||"
  es2. d4 |
  c bes c2 |
  bes4 4 c2 |
  bes4 g f2 |
  g es |
  f g |
  4 as2 g4 |
  f2 g4 es' ~ |
  4 d c2 |
  bes1 |
  r4 es2 d4 |
  c4. 8 bes4 c ~ |
  8 bes8 2 a4 |
  bes4 4 4 4 ~ |
  4 as g es ~ |
  8 [ f g es ] f2 |
  g1 
  es2 f |
  g as |
  f1 |
  g4. as8 bes2 |
  r2 r4 4 ~ |
  4 as bes es, |
  f g as2 ~ |
  4 g f2 |
  es4 r r es' ~ |
  4 d es c |
  des2 c |
  bes1 |
  1 |\bar "|."
}

sopranoVerseOne = \lyricmode {
  Re -- dem -- ptó -- ris Má -- _ _ ter,
  quæ pér -- vi -- a coé -- li
  pór -- ta má -- nes,
  et stél -- la má -- ris,
  suc -- cú -- re ca -- dén -- ti,
  súr -- ge -- re qui cú -- rat pó -- _ pu -- lo.
  Tu quæ ge -- nu -- ís -- ti,
  na -- tú -- ra mi -- rán -- te,
  tú -- um sánc -- tum Ge -- ni -- tó -- rem.
  Vír -- go prí -- us
  ac pos -- té -- ri -- us,
  ac __ pos -- té -- ri -- us,
  Ga -- bri -- é -- lis ab ó -- _ re,
  Sú -- mens íl -- lud A -- ve, __ _ _
  pec -- ca -- tó -- rum mi -- se -- ré -- _ _ re,
  pec -- ca -- tó -- rum mi -- se -- ré -- re.
}


alto = \fixed c' {
  \global
  R1
  g2 2 |
  4 f es8 [ f g es ] |
  f [ es ] 2 d4 |
  es g2 4 ~ |
  8 8 4 bes2 |
  4 f g es ~ |
  8 [ d16 c ] d4 es bes |
  4 4 as2 |
  g r4 4 |
  2 es4 d |
  c2 f4 bes ~ |
  4 4 4 4 |
  2. as4 |
  g2 f4. 8 |
  1 |
  bes2. 4 |
  g4 4 as2 |
  g4 4 2 |
  4 es d2 |
  es2 r4 4 ~ |
  4 d es2 |
  4 2 4 |
  c2 es4 8 [ f ] |
  g [ as ] bes2 as4 |
  g2. f4 |
  r4 es8 [ f ] g [ as ] bes4 ~ |
  4 as g f8 [ es ] |
  g4 f4 2 |
  r4 g g g ~ |
  4 f es g ~ |
  8 [ f ] es2 d4 |
  es1 |
  bes,2 d |
  es2 4 4 ~ |
  4 d8 [ c ] d2 |
  es4 g2 f8 [ es ] |
  f2. 4 |
  g f es4. d8 |
  c4 bes, as,4.bes,8 |
  c8 [ d ] es2 d4 |
  es4 g2 f8 [ es ] |
  g4 f es8 [ f g as ] |
  bes2 es4 f ~ |
  4 es2 d4 |
  es1 |
}

altoVerseOne = \lyricmode {
  Re -- dem -- ptó -- ris Má -- _ _ _ ter,
  quæ pér -- vi -- a coé -- li
  pór -- ta má -- _ nes,
  et stél -- la má -- ris,
  suc -- cú -- re ca -- dén -- ti,
  súr -- ge -- re qui cú -- rat pó -- _ pu -- lo.
  Tu quæ ge -- nu -- ís -- ti,
  na -- tú -- ra mi -- rán -- te,
  tú -- um sánc -- tum Ge -- ni -- tó -- rem.
  Vír -- _ _ go prí -- us
  ac __ _ _ pos -- té -- _ _ ri -- us,
  Ga -- bri -- é -- lis ab ó -- _ _ re,
  Sú -- mens íl -- lud A -- _ _ ve,
  pec -- _ _ ca -- tó -- rum mi -- _ _ se -- ré -- _ _ _ _ re,
  pec -- _ _ ca -- tó -- _ rum mi -- se -- ré -- re.
}


tenor = \relative c {
  \global
  es4 g8 [ as bes c ] bes4 \bar "||"
  es2 2 |
  bes4 4 2 |
  c bes |
  r4 es2 4 ~ |
  8 8 4 g2 |
  f4 d es2 |
  f bes,4 g' |
  f g es2 |
  2 r4 4 |
  2 bes4 4 |
  g a bes f' ~ |
  4 4 4 4 |
  g2 f4. es8 |
  d8 [ c16 d ] es4 c4. 8 |
  d1 |
  g2. f4 |
  es4 4 2 |
  4 4 2 |
  4 bes4 2 |
  2 g |
  bes2 2 |
  c4 2 bes4 |
  as2 g
  R1
  r4 es'2 d4 |
  c2 bes |
  r2 es ~ |
  4 d c4. 8 |
  bes4 es4 4 4 ~ |
  4 c c2 |
  bes1 |
  1 |
  g2 bes |
  2 c |
  bes1 |
  4 es2 d8 [ c ] |
  d4 c d2 |
  es4 c bes as8 [ bes ] |
  c [ d ] es2 d4 |
  es2 r |
  bes2. a4 |
  bes2 es, |
  f4 g as?2 ~ |
  4 g f2 |
  g1 |
}

tenorVerseOne = \lyricmode {
  Al -- _ ma
  Re -- dem -- ptó -- ris Má -- _ ter,
  quæ pér -- vi -- a coé -- li
  pór -- ta má -- nes,
  et stél -- la má -- ris,
  suc -- cú -- re ca -- dén -- _ ti,
  súr -- ge -- re qui cú -- _ _ _ rat pó -- pu -- lo.
  Tu quæ ge -- nu -- ís -- ti,
  na -- tú -- ra mi -- rán -- te,
  tú -- um sánc -- tum Ge -- ni -- tó -- rem.
  Vír -- go prí -- us
  ac __ pos -- té -- ri -- us,
  Ga -- bri -- é -- lis ab ó -- re,
  Sú -- mens íl -- lud A -- ve,
  pec -- _ _ ca -- tó -- rum mi -- se -- ré -- _ _ _ re,
  pec -- ca -- tó -- rum mi -- se -- ré -- _ _ re.
}


bass = \fixed c {
  \global
  R1
  es2 2 |
  4 d es2 |
  as, bes, |
  es2. 4 ~ |
  8 8 4 8 [ f g as ] |
  bes4 4 g as |
  f2 es4 4 |
  bes g as2 |
  es r4 4 |
  2 4 bes, |
  c2 bes, |
  bes4. 8 4 4 |
  es8 [ f g as ] bes4 f |
  g es f2 |
  bes,1 |
  es2. bes,4 |
  c es as,2 |
  es4 4 c2 |
  es4 4 bes,2 |
  es2 2 |
  bes, es |
  c4 as,2 es4 |
  f2 es 
  R1
  r4 es8 [ f g as ] bes4 ~ |
  4 as g4. f8 |
  es4 f g as |
  bes4. 8 f2 |
  r4 es4 4 4 ~ |
  4f c4. d8 |
  es2 bes, |
  es1 |
  2 bes, |
  es as, |
  bes,1 |
  es2 r4 bes4 ~ |
  4 as bes2 |
  es4 f g as ~ |
  4 g f2 |
  es bes, |
  es c |
  bes, c |
  bes, as, |
  bes,1 \oct es1
}

bassVerseOne = \lyricmode {
  Re -- dem -- ptó -- ris Má -- _ ter,
  quæ pér -- vi -- a coé -- _ li
  pór -- ta má -- nes,
  et stél -- la má -- ris,
  suc -- cú -- re ca -- dén -- ti,
  súr -- ge -- re qui cú -- _ rat pó -- pu -- lo. __ _
  Tu quæ ge -- nu -- ís -- ti,
  na -- tú -- ra mi -- rán -- te,
  tú -- um sánc -- tum Ge -- ni -- tó -- rem.
  Vír -- _ go prí -- us
  ac pos -- té -- _ _ ri -- us,
  Ga -- bri -- é -- lis ab ó -- _ _ re,
  Sú -- mens íl -- lud A -- ve,
  pec -- ca -- tó -- rum mi -- se -- ré -- _ _ re,
  pec -- _ ca -- tó -- rum mi -- se -- ré -- re.
}



ChoeurPart = \new ChoirStaff \with {
	midiInstrument = "choir aahs"
} <<
  \new Staff \with {
    instrumentName = "S."
    \consists "Ambitus_engraver"
  }  \new Voice = "soprano" {\soprano }
  \new Lyrics \with {
    \override VerticalAxisGroup.staff-affinity = #CENTER
  } \lyricsto "soprano" \sopranoVerseOne

  \new Staff \with {
    instrumentName = "A."
    \consists "Ambitus_engraver"
  }  \new Voice = "alto" {\alto }
  \new Lyrics \with {
    \override VerticalAxisGroup.staff-affinity = #CENTER
  } \lyricsto "alto" \altoVerseOne

  \new Staff \with {
    instrumentName = "T."
    \consists "Ambitus_engraver"
    \clef "treble_8"
  }  \new Voice = "tenor" {\tenor }
  \new Lyrics \with {
    \override VerticalAxisGroup.staff-affinity = #CENTER
  } \lyricsto "tenor" \tenorVerseOne

  \new Staff \with {
    instrumentName = "B."
    \consists "Ambitus_engraver"
    \clef bass
  }  \new Voice = "bass" {\bass }
  \new Lyrics \with {
    \override VerticalAxisGroup.staff-affinity = #CENTER
  } \lyricsto "bass" \bassVerseOne

>>

\tocItemComposer "Alma Redemptoris" "Palestrina"
\score {
  \header {
    title = "ALMA REDEMPTORIS"
    composer = \palestrina
  }
  \ChoeurPart
  \layout {\context{\Staff \RemoveAllEmptyStaves }}
  \midi {\tempo 4=100 }
}
