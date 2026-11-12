\version "2.26.0"
\include "settings.ily"
\include "composers.ily"

global = {
	\key f \major
	\time 3/2
}

#(set-global-staff-size 17.7 )

rightOne = \fixed c' {
  \global \bar ".|:"
  \repeat segno 2 { \repeat volta 2 {
    <a, d f>2 2 r4 <e g>4 |
    <a, cis e>2 2 r2 |
    <c f a>2 2 r4 <g bes> |
    <c e g>2 2 r4 <fis a> |
    <d g bes>2 2 r4 <a c'>4 |
    <d f a>2 2 r4 a |
    <d' a>2 <d' g> r4 e'4 |
    <e a cis'>2 2 r |
    
    <a, d f>2 2 r4 <e g>4 |
    <a, cis e>2 2 r2 |
    <c f a>2 2 r4 <g bes> |
    <c e g>2 2 r4 <f a> |
    <d g bes>2 <c g bes>2 r4 <a c'>4 |
    <c f a>2. a4 d' cis' |
    d' e' f'2 e'4 d' |
    <f a d'>2 2 r | \fine \bar ":|." \break
  
    \alternative {
    \volta 1 {
    <<{
      f2 d r |
      e cis r |
      a2. c'4 bes a |
      g2 e r4 a |
      bes2. d'4 c' bes |
      a2 r1 |
      d'2. f'4 e' d' |
    }\\{
      r4 a, r a g f |
      r4 b, r2 r2 |
      r4 c f2 r2 |
      r4 d r b, c2 |
      r4 d g2 r  |
      r4 g f e d a~ |
      4 4 g2 r |
    }>>
    cis'4 e' a cis' e g | 
    <<{
      f2 d r |
      e cis r |
      a2. c'4 bes a |
      g2 e c |
      bes2. d'4 c' bes |
      a2. 4 d'2~ |
      4 e' f'2 e' |
      d'1 r2 |
    }\\{
      r4 a, r a g f |
      r b, r2 r2|
      r4 c f2 r |
      r4 d r b, r a |
      r d g2 r |
      r4 g f e r f |
      g bes a d' cis' g |
      r bes a g f e |
    }>>\break
  }
  \volta 2 {
  <f d a,>2 1 |
  <cis e>2 1 |
  <c a>2 1 |
  <e g>2 1 |
  <d bes>2 <g bes>1 |
  <a f>2 1 |
  <a d'>2 <<{e'2. d'4}\\{g1}>> |
  <e a cis'>1 r2 |
  <f d a,>2 1 |
  <cis e>2 1 |
  <f a>2 1 |
  <e g>2 1 |
  <d bes>2 <g bes>1 |
  <f a>2. a4 <<{d'4 cis'}\\{g2}>> |
  d'4 e' <<{f'2 e'}\\{a4 d' cis' a}>> |
  <f a d'>1 r2 |
  }
  }}}\bar ":|."
}

leftOne = \fixed c {
	\global
	d2 d, r |
	a,2. bes,4 a, g, |
	<f f,>2 2 r |
	c2. 4 bes, a, |
	g,2 g g, |
	d d r4 c |
	bes,2 bes r |
	a <<{r4 g}\\{a,2}>> f4 e |
	d2 d, r |
	a,2. bes,4 a, g, |
	<f f,>2 2 r |
	c2. 4 bes, a, |
	g, g e g c e |
	f2. d4 bes2 |
	g a a, |
	d d, r |
	
	d2 f d |
	a <<{r4 g a e}\\{a,2 r}>> |
	f2 a f |
	c r r4 fis |
	g2 bes g |
	d' d r4 c' |
	bes2 bes, bes |
	a2. g4 f e |
	d2 f d |
	a <<{r4 g a e}\\{a,2 r}>> |
	f a f |
	c r r4 fis |
	g2 bes g |
	d' r4 c' bes a |
	bes g a2 a, |
	d1 d,2 |
	
	d4-2 cis d e f-3 g |
	a g a e-2 cis a, |
	f-2 e f g a-3 bes |
	c' g e-4 g c e |
	g-2 fis g a bes-3 c' |
	d' a f-4 a d f-2 |
	bes, f bes a g bes-2 |
	a bes a g f-1 e |
	d-1 a, f,-4 a, d, f, |
	a,-2 e a-2 g-1 f e |
	f-1 c a,-4 c f, a, |
	c-2 bes, c d e-3 f |
	g d-2 bes,-4 d g, bes, |
	d e d c-1 bes, a, |
	bes, g,-5 a g a a, |
	d' a f a d2
}

ClavierPart = \new PianoStaff \with {
	midiInstrument = "church organ"
} <<
	\new Staff = "right" \with {
	  \consists Merge_rests_engraver
	} \rightOne
	\new Staff = "left" \with {
	  \consists Merge_rests_engraver
	  \clef bass
	} \leftOne 
>>


\tocItemComposer "Sarabande" "Häendel"
\score {
	\header {
		title = "SARABANDE"
		subsubtitle = "extrait de la suite n°1"
		composer = \haendel
	}
	\ClavierPart
	\layout {\context{\Staff \RemoveAllEmptyStaves }}
	\midi {\tempo 2=70 }
}
