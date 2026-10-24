import json, importlib.util, io, contextlib, re, os
from pathlib import Path
WORK=Path(os.environ.get('OUT_DIR','/tmp/pdftoly'))
LY_OUT=Path(os.environ.get('LY_OUT', WORK/'score.ly'))
TITLE=os.environ.get('TITLE','TITRE')
SUBTITLE=os.environ.get('SUBTITLE','')
ARRANGER=os.environ.get('ARRANGER','')
COMPOSER=os.environ.get('COMPOSER', r'\palestrina')
TOC_TITLE=os.environ.get('TOC_TITLE', TITLE)
TOC_COMPOSER=os.environ.get('TOC_COMPOSER', '')
SUBTITLE_LINE=(f'    subtitle = "{SUBTITLE}"\n' if SUBTITLE else '')
ARRANGER_LINE=(f'    arranger = "{ARRANGER}"\n' if ARRANGER else '')
TEMPO=os.environ.get('TEMPO', '"Adagio" 4=70')
KEY=os.environ.get('KEY', r'f \major')
TIME=os.environ.get('TIME', '4/4')
spec=importlib.util.spec_from_file_location('tr', Path(__file__).with_name('transcribe.py'))
tr=importlib.util.module_from_spec(spec)
with contextlib.redirect_stdout(io.StringIO()): spec.loader.exec_module(tr)
lyr=json.load(open(WORK/'lyrics.json'))

def align_system(notes, words):
    # source-driven hyphen flags
    syls=[]; hyph=[]; last=None
    for x,t in words:
        if t in ('-','--'):
            if last is not None: hyph[last]=True
        else:
            syls.append((x,t)); hyph.append(False); last=len(syls)-1
    assign={}; prev=-1
    for si,(sx,st) in enumerate(syls):
        best=None
        for i in range(prev+1,len(notes)):
            if i in assign: continue
            d=abs(notes[i]-sx)
            if best is None or d<best[0]: best=(d,i)
        i=best[1] if best else len(notes)-1
        assign[i]=(st,si); prev=i
    toks=[]
    assigned_order=sorted(assign)
    for i in range(len(notes)):
        if i in assign:
            st,si=assign[i]
            toks.append(st)
            if hyph[si] and not st.endswith((',','.',';',':')):
                # only put -- if next assigned note is immediately next (no melisma)
                j=assigned_order.index(i)
                if j+1<len(assigned_order) and assigned_order[j+1]==i+1:
                    toks.append('--')
                elif j+1==len(assigned_order):
                    # last syllable of system; add -- for cross-system continuation
                    toks.append('--')
        else:
            toks.append('__')
    return toks

voice_lyrics={0:[],1:[],2:[],3:[]}
for si,voice,measures in tr.data:
    page=1 if si<3 else 2
    local=si if si<3 else si-3
    notes=[]
    for meas in measures:
        for tok in meas:
            p,d,br,x=tok
            if p not in ('r','R') and x is not None:
                notes.append(x)
    words=lyr.get(f'{page},{local},{voice}',[])
    voice_lyrics[voice].extend(align_system(notes,words))

# correct tenor 'quod ... est' -> 'quod ... et' (source extraction typo)
for v in range(4):
    for i,t in enumerate(voice_lyrics[v]):
        if t=='est':
            # previous syllable ignoring '--'
            j=i-1
            while j>=0 and voice_lyrics[v][j]=='--': j-=1
            if j>=0 and voice_lyrics[v][j]=='quod':
                voice_lyrics[v][i]='et'

def fmt_measures(measures):
    lines=[]
    for toks in measures:
        parts=[p+d+br for p,d,br,x in toks]
        lines.append('  '+' '.join(parts))
    return '\n'.join(lines)

body={v:fmt_measures(tr.voices[v]) for v in range(4)}
lyrtext={v:' '.join(voice_lyrics[v]) for v in range(4)}
for v in range(4):
    print(f'--- v{v}', lyrtext[v])

ly = r'''\version "2.26.0"
\include "settings.ily"
\include "composers.ily"

global = {
  \autoBeamOff
  \mergeDifferentlyHeadedOn
  \mergeDifferentlyDottedOn
  \key %KEY%
  \time %TIME%
  \tempo %TEMPO%
}

soprano = \fixed c {
  \global
%BODY0%
}

sopranoVerseOne = \lyricmode {
%LYR0%
}

alto = \fixed c {
  \global
%BODY1%
}

altoVerseOne = \lyricmode {
%LYR1%
}

tenor = \fixed c {
  \global
%BODY2%
}

tenorVerseOne = \lyricmode {
%LYR2%
}

bass = \fixed c {
  \global
%BODY3%
}

bassVerseOne = \lyricmode {
%LYR3%
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

\tocItemComposer "%TOC_TITLE%" "%TOC_COMPOSER%"
\score {
  \header {
    title = "%TITLE%"
%SUBTITLE_LINE%%ARRANGER_LINE%    composer = %COMPOSER%
  }
  \ChoeurPart
  \layout {\context{\Staff \RemoveAllEmptyStaves }}
  \midi {}
}
'''
for v in range(4):
    ly=ly.replace(f'%BODY{v}%',body[v]).replace(f'%LYR{v}%',lyrtext[v])
ly=(ly.replace('%TITLE%',TITLE).replace('%SUBTITLE%',SUBTITLE).replace('%ARRANGER%',ARRANGER)
      .replace('%COMPOSER%',COMPOSER).replace('%TOC_TITLE%',TOC_TITLE).replace('%TOC_COMPOSER%',TOC_COMPOSER)
      .replace('%TEMPO%',TEMPO).replace('%KEY%',KEY).replace('%TIME%',TIME)
      .replace('%SUBTITLE_LINE%',SUBTITLE_LINE).replace('%ARRANGER_LINE%',ARRANGER_LINE))
LY_OUT.parent.mkdir(parents=True, exist_ok=True)
LY_OUT.write_text(ly)
print('written',LY_OUT,len(ly))
