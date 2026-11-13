\version "2.26.0"
\include "settings.ily"
\include "composers.ily"
\include "cache/notes.ily"

ChoeurPart = \new ChoirStaff \with {
	midiInstrument = "choir aahs"
} <<
  \new Staff \with {
    instrumentName = "S."
    \consists "Ambitus_engraver"
  }  \new Voice = "soprano" {\soprano \sopranoSuite }
  \new Lyrics \with {
    \override VerticalAxisGroup.staff-affinity = #CENTER
  } \lyricsto "soprano" {\sopranoVerseOne \sopranoVerseSuite }

  \new Staff \with {
    instrumentName = "A."
    \consists "Ambitus_engraver"
  }  \new Voice = "alto" {\alto \altoSuite }
  \new Lyrics \with {
    \override VerticalAxisGroup.staff-affinity = #CENTER
  } \lyricsto "alto" {\altoVerseOne \altoVerseSuite }

  \new Staff \with {
    instrumentName = "T."
    \consists "Ambitus_engraver"
    \clef "treble_8"
  }  \new Voice = "tenor" {\tenor \tenorSuite }
  \new Lyrics \with {
    \override VerticalAxisGroup.staff-affinity = #CENTER
  } \lyricsto "tenor" {\tenorVerseOne \tenorVerseSuite }

  \new Staff \with {
    instrumentName = "B."
    \consists "Ambitus_engraver"
    \clef bass
  }  \new Voice = "bass" {\bass \bassSuite }
  \new Lyrics \with {
    \override VerticalAxisGroup.staff-affinity = #CENTER
  } \lyricsto "bass" {\bassVerseOne \bassVerseSuite }

>>
\paper {
  page-count = 6
  systems-per-page = 4
}
\tocItemComposer "Sicut cervus" "Palestrina"
\score {
  \header {
    title = "SICUT CERVUS"
    composer = \palestrina
  }
  \ChoeurPart
  \layout { }
  \midi {\tempo 4=90 }
}
