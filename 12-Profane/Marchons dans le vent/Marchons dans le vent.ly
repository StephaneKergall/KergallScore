\version "2.26.0"
\include "settings.ily"
\include "composers.ily"

global = {
  \autoBeamOff
  \mergeDifferentlyHeadedOn
  \mergeDifferentlyDottedOn
  \key a \major
  \time 4/4
  \partial 8
}

soprano = \relative c' {
  \global
  \repeat volta 2 {
    \markChanson "Refrain"
    \bar ".|:" e8 cis'8 4 8 4 a |
    b8 4 8 4 cis |
    a8 4 8 4 fis |
    \alternative{
      \volta 1 {
        \partial 1
        e4. fis8 e2
      }
      \volta 2 {
        \partial 1
        a2. r8
        \bar "||"
      }
    }
  }
  \break \markChanson "Couplets" e8 |
  e'8. 16 8 8 4. fis8 |
  d8. cis16 b8 cis d4. e8 |
  cis8. b16 a8 b cis4. d8 |
  b a gis a b4. \bar "|."
}


alto = \fixed c' {
  \global
  e8 e8 4 8 4 4 |
  gis8 4 8 4 4 |
  fis8 4 8 4 4 |
  e4. 8 d2 e2. r8 e8 |
  e8. 16 8 8 4. fis8 |
  8. 16 8 8 4. e8 |
  8. 16 8 8 4. 8 |
  gis8 8 8 8 4.
}


tenor = \relative c {
  \global
  e'8 cis8 4 8 4 4 |
  fis8 e4 8 d4 4 |
  8 4 8 4 4 |
  cis4. 8 b2 cis2. r8 8 |
  8. 16 8 8 4. 8 |
  a8. 16 8 8 4. 8 |
  cis8. 16 8 8 4. 8 |
  e8 8 8 8 d4.
}


bass = \fixed c {
  \global
  e8 a,8 4 8 4 4 |
  e8 4 8 4 4 |
  d8 4 8 4 4 |
  a,4. 8 gis,2 |
  a,2. r8
  
  a,8 8. 16 8 8 4. 8 |
  d8. 16 8 8 4. 8 |
  a,8. 16 8 8 4. 8 |
  e8 8 8 8 4.
}

guitar = \chordmode {
  s8 a1 e2 e2:7 d1 a2 e a1
  a1 d a e2 e4.:7
}

refrain = \lyricmode {
  Mar -- chons dans le vent,
  du ma -- tin le -- vant,
  mar -- chons dans le vent,
  chan -- tant gaie -- ment,
  tant_!
}
refrainTwo = \lyricmode {
  \repeat unfold 5 \skip1
  jus -- qu'au soir cou -- chant,
}

verseOne = \strophemode 1 ##f 20 \lyricmode {
  Ro -- sée per -- lant les prés,
  cris d'a -- louettes au tour -- nant,
  che -- veux au vent lé -- ger,
  der -- rière le la -- pin blanc.
}
verseTwo = \strophemode 2 ##t 20 \lyricmode {
  Noi -- set -- tes du che -- min,
  qu'on ar -- rache en pas -- sant,
  eau fraîche au creux des mains,
  et bon -- jour aux pas -- sants.
}

ChoeurPart = \new ChoirStaff \with {
	midiInstrument = "choir aahs"
} <<
  \new ChordNames \with {
    midiInstrument = "acoustic guitar (nylon)"
  } \guitar
  \new Staff \with {
    \consists Merge_rests_engraver
  } <<
    \new Voice = "soprano" {\voiceOne \soprano }
    \new Voice = "alto" {\voiceTwo \alto }
  >>
  
  \new Lyrics \with {
    \override VerticalAxisGroup.staff-affinity = #CENTER
  } \lyricsto "soprano" \refrain
  \new Lyrics \with {
    \override VerticalAxisGroup.staff-affinity = #CENTER
  } \lyricsto "soprano" \refrainTwo
  
  \new Lyrics \with {
    \override VerticalAxisGroup.staff-affinity = #CENTER
  } \lyricsto "soprano" \verseOne
  \new Lyrics \with {
    \override VerticalAxisGroup.staff-affinity = #CENTER
  } \lyricsto "soprano" \verseTwo
  
  \new Staff \with {
    \consists Merge_rests_engraver
    \clef bass
  } <<
    \new Voice = "tenor" {\voiceOne \tenor }
    \new Voice = "bass" {\voiceTwo \bass }
  >>
>>

\tocItem \markup "Marchons dans le vent"
\score {
  \header {
    title = "MARCHONS DANS LE VENT"
  }
  \ChoeurPart
  \layout {\context{\Staff \RemoveAllEmptyStaves }}
  \midi {\tempo 2=60 }
}

\markup \couplets-markup #3 #2 {
  \column {
    "Cheveux de raisin mûr,"
    "De mes amis d'été,"
    "Et cette joie qui dure,"
    "Dans les buis, attardée."
  }
  \column {
    "Grillons qui nous guettez,"
    "Aux creux des chemins roux,"
    "L'Angélus a sonné,"
    "Amis, rentrons chez nous !"
  }
}