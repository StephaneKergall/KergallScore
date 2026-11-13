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
  }  \new Voice = "soprano" {\soprano }
  \new Lyrics \with {
    \override VerticalAxisGroup.staff-affinity = #CENTER
  } \lyricsto "soprano" {\sopranoVerseOne }

  \new Staff \with {
    instrumentName = "A."
    \consists "Ambitus_engraver"
  }  \new Voice = "alto" {\alto }
  \new Lyrics \with {
    \override VerticalAxisGroup.staff-affinity = #CENTER
  } \lyricsto "alto" {\altoVerseOne }

  \new Staff \with {
    instrumentName = "T."
    \consists "Ambitus_engraver"
    \clef "treble_8"
  }  \new Voice = "tenor" {\tenor }
  \new Lyrics \with {
    \override VerticalAxisGroup.staff-affinity = #CENTER
  } \lyricsto "tenor" {\tenorVerseOne }

  \new Staff \with {
    instrumentName = "B."
    \consists "Ambitus_engraver"
    \clef bass
  }  \new Voice = "bass" {\bass }
  \new Lyrics \with {
    \override VerticalAxisGroup.staff-affinity = #CENTER
  } \lyricsto "bass" {\bassVerseOne }

>>

\paper {
  page-count = 3
  systems-per-page = 3
}
\tocItemComposer "Sicut cervus - début" "Palestrina"
\score {
  \header {
    title = "SICUT CERVUS  - Partie I."
    composer = \palestrina
  }
  \ChoeurPart
  \layout { }
  \midi {\tempo 4=90 }
}
