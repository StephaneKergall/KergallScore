#!/usr/bin/env python3
"""Transcription vectorielle (référence Maestro, 4 voix S/A/T/B).

Variables d'environnement :
  PDF_JSON   parsed.json produit par parse_pdf.py (défaut /tmp/pdftoly/parsed.json)
  FONT_TTF   police musicale extraite (défaut /tmp/pdftoly/fonts/R7_Maestro.ttf)
  OUT_DIR    dossier de sortie (défaut /tmp/pdftoly)
  BEATS      temps par mesure (défaut 4)
  CLEFS      clés par voix, ex. treble,treble,treble,bass
  TOPNAMES   note de la ligne supérieure par voix, ex. F5,F5,F5,A3
  TRANSPOSE  décalage d'octave par voix, ex. 0,0,-1,0 (ténor)
  MUSIC_FONT ressource de la police musicale (défaut R7)
  NOTE_CODES codes de têtes de note (défaut 6,9,11)
  REST_CODES codes de silences (défaut 16)
  ACC_CODES  altérations code:nom (défaut 4:flat,12:natural,13:sharp)
  DOT_CODE   code du point de prolongation (défaut 15)
"""
import json, math, re, html, subprocess, os, sys
from collections import defaultdict
from pathlib import Path
from fontTools.ttLib import TTFont

BASE=Path(os.environ.get('SCORE_DIR', Path.cwd()))
WORK=Path(os.environ.get('OUT_DIR', '/tmp/pdftoly'))
PDF_JSON=Path(os.environ.get('PDF_JSON', WORK/'parsed.json'))
FONT_TTF=Path(os.environ.get('FONT_TTF', WORK/'fonts'/'R7_Maestro.ttf'))
BEATS=float(os.environ.get('BEATS','4'))
CLEFS=os.environ.get('CLEFS','treble,treble,treble,bass').split(',')
TOPNAMES=os.environ.get('TOPNAMES','F5,F5,F5,A3').split(',')
TRANSPOSE=[int(x) for x in os.environ.get('TRANSPOSE','0,0,-1,0').split(',')]
NOTE_CODES=tuple(int(x) for x in os.environ.get('NOTE_CODES','6,9,11').split(','))
REST_CODES=tuple(int(x) for x in os.environ.get('REST_CODES','16').split(','))
ACC_CODES={int(k):v for k,v in (x.split(':') for x in os.environ.get('ACC_CODES','4:flat,12:natural,13:sharp').split(','))}
DOT_CODE=int(os.environ.get('DOT_CODE','15'))
MUSIC_FONT=os.environ.get('MUSIC_FONT','R7')
WORK.mkdir(parents=True, exist_ok=True)

pages=json.load(open(PDF_JSON))
font=TTFont(str(FONT_TTF)); glyf=font['glyf']
codes=list(range(1,24))
bbox={c:(glyf[f'uniF{c:03X}'].xMin,glyf[f'uniF{c:03X}'].yMin,glyf[f'uniF{c:03X}'].xMax,glyf[f'uniF{c:03X}'].yMax) for c in codes if f'uniF{c:03X}' in glyf}
def mul(m1,m2):
    a1,b1,c1,d1,e1,f1=m1; a2,b2,c2,d2,e2,f2=m2
    return (a1*a2+b1*c2,a1*b2+b1*d2,c1*a2+d1*c2,c1*b2+d1*d2,e1*a2+f1*c2+e2,e1*b2+f1*d2+f2)
def gb(g):
    M=mul(tuple(g['Tm']),tuple(g['ctm'])); s=g['size']/1000.0
    x0,y0,x1,y1=bbox[g['code']]
    pts=[(M[0]*(x*s)+M[2]*(y*s)+M[4],M[1]*(x*s)+M[3]*(y*s)+M[5]) for x,y in [(x0,y0),(x1,y0),(x0,y1),(x1,y1)]]
    xs=[p[0] for p in pts]; ys=[p[1] for p in pts]
    return min(xs),min(ys),max(xs),max(ys)
LETTERS=['C','D','E','F','G','A','B']
def note_name(s,topname):
    idx=int(topname[1])*7+LETTERS.index(topname[0])-s
    return LETTERS[idx%7]+str(idx//7)
def ly_pitch(name):
    letter=name[0]; octv=int(name[1])
    # LilyPond absolute: c=C3, c'=C4, c''=C5
    base=letter.lower()
    if octv==3: return base
    if octv==4: return base+"'"
    if octv==5: return base+"''"
    if octv==6: return base+"'''"
    if octv==2: return base+","
    if octv==1: return base+",,"
    return base
def ly_dur(code,beamed,dotted):
    base={6:'1',9:'2',11:('8' if beamed else '4')}[code]
    return base+('.' if dotted else '')

def build(pg):
    hs=[]
    for (x0,y0),(x1,y1) in pg['segments']:
        if abs(y0-y1)<0.3 and abs(x1-x0)>200: hs.append((min(x0,x1),max(x0,x1),(y0+y1)/2))
    ys=sorted(set(round(y,1) for _,_,y in hs),reverse=True)
    staves=[]; cur=[]
    for y in ys:
        if cur and cur[-1]-y>6: staves.append(cur); cur=[]
        cur.append(y)
    if cur: staves.append(cur)
    vlines=[]
    for (x0,y0),(x1,y1) in pg['segments']:
        if abs(x0-x1)<0.4 and 17.5<=abs(y1-y0)<=20.5:
            vlines.append(((x0+x1)/2,min(y0,y1),max(y0,y1)))
    stems=[]
    for (x0,y0),(x1,y1) in pg['segments']:
        if abs(x0-x1)<0.4 and 10<=abs(y1-y0)<=20:
            stems.append(((x0+x1)/2,min(y0,y1),max(y0,y1)))
    heads=[]
    for g in pg['glyphs']:
        if g['font']==MUSIC_FONT and g['code'] in NOTE_CODES:
            xmin,ymin,xmax,ymax=gb(g); cx=(xmin+xmax)/2; cy=(ymin+ymax)/2
            best=min(range(len(staves)), key=lambda i: abs(cy-(staves[i][0]+staves[i][-1])/2))
            h={'x':cx,'y':cy,'code':g['code'],'staff':best,'beamed':False,'dot':False,'accident':None}
            cand=[s for s in stems if abs(s[0]-cx)<=6 and s[1]-2<=cy<=s[2]+2]
            if cand:
                s=min(cand,key=lambda s:abs(s[0]-cx))
                h['stem']=s; h['tip']=s[1] if abs(s[1]-cy)>abs(s[2]-cy) else s[2]
            heads.append(h)
    hsegs=[]
    for (x0,y0),(x1,y1) in pg['segments']:
        if abs(y1-y0)<=2.5 and 5<=abs(x1-x0)<=50:
            hsegs.append((min(x0,x1),max(x0,x1),(y0+y1)/2))
    parent={id(h):id(h) for h in heads}
    def find(x):
        while parent[x]!=x: parent[x]=parent[parent[x]]; x=parent[x]
        return x
    def union(a,b):
        ra,rb=find(id(a)),find(id(b))
        if ra!=rb: parent[ra]=rb
    for xx0,xx1,yy in hsegs:
        touch=[]
        for h in heads:
            if 'tip' not in h: continue
            if (xx0-2.5 <= h['stem'][0] <= xx1+2.5) and abs(h['tip']-yy)<=5.0:
                touch.append(h)
        touch=list({id(h):h for h in touch}.values())
        for i in range(len(touch)):
            for j in range(i+1,len(touch)):
                if touch[i]['staff']==touch[j]['staff']: union(touch[i],touch[j])
    groups=defaultdict(list)
    for h in heads: groups[find(id(h))].append(h)
    for g in groups.values():
        if len(g)>=2:
            for h in g: h['beamed']=True
    dots=[]
    for g in pg['glyphs']:
        if g['font']==MUSIC_FONT and g['code']==DOT_CODE:
            xmin,ymin,xmax,ymax=gb(g); dots.append(((xmin+xmax)/2,(ymin+ymax)/2))
    for h in heads:
        for dx,dy in dots:
            if 0<dx-h['x']<10 and abs(dy-h['y'])<6: h['dot']=True
    accs=[]
    for g in pg['glyphs']:
        if g['font']==MUSIC_FONT and g['code'] in ACC_CODES:
            xmin,ymin,xmax,ymax=gb(g)
            ay=(ymin+ymax)/2-(2.58 if g['code']==4 else 0.0)
            accs.append((g['code'],(xmin+xmax)/2,ay))
    for h in heads:
        best=None
        for code,ax,ay in accs:
            dy=ay-h['y']
            if code==4: dy+=2.58
            if 0< h['x']-ax < 14 and abs(dy)<4:
                if best is None or h['x']-ax<best[0]: best=(h['x']-ax,code)
        if best: h['accident']=ACC_CODES[best[1]]
    systems=[]
    for i in range(0,len(staves),4):
        if i+3<len(staves): systems.append(staves[i:i+4])
    return staves,systems,vlines,heads

all_systems=[]
for pg in pages:
    staves,systems,vlines,heads=build(pg)
    for sysno,st4 in enumerate(systems):
        ytop=st4[0][0]; ybot=st4[-1][-1]
        bars=sorted(set(round(x,1) for x,y0,y1 in vlines if y1>=ybot-1 and y0<=ytop+1))
        merged=[]
        for b in bars:
            if not merged or b-merged[-1]>5: merged.append(b)
        bars=merged
        left=min((min(x0,x1) for (x0,y0),(x1,y1) in pg['segments'] if abs(y0-y1)<0.3 and abs(x1-x0)>200 and abs((y0+y1)/2-ytop)<0.6), default=70)
        all_systems.append({'page':pg['page'],'sysno':sysno,'staves':st4,'bars':bars,'heads':heads,'left':left})

def meld(systems):
    out=[]
    for si,sysd in enumerate(systems):
        for voice in range(4):
            staff=sysd['sysno']*4+voice
            clef=CLEFS[voice]
            nn=sorted([h for h in sysd['heads'] if h['staff']==staff],key=lambda h:h['x'])
            # measures: index by bars; start measure 0
            meas=defaultdict(list)
            for h in nn:
                m=sum(1 for b in sysd['bars'] if h['x']>b)
                meas[m].append(h)
            measures=[]
            for m in range(len(sysd['bars'])):
                ns=meas.get(m,[])
                # base durations
                for h in ns:
                    s=round((sysd['staves'][voice][0]-h['y'])/2.341)
                    h['pitch']=note_name(s,TOPNAMES[voice])
                    if TRANSPOSE[voice]:
                        h['pitch']=h['pitch'][0]+str(int(h['pitch'][1])+TRANSPOSE[voice])
                    h['dur']={6:4,9:2,11:(0.5 if h['beamed'] else 1)}[h['code']]
                total=sum(h['dur']*(1.5 if h['dot'] else 1) for h in ns)
                # if overfull, drop dots first
                if total>BEATS+1e-6 and any(h['dot'] for h in ns):
                    for h in ns: h['dot']=False
                    total=sum(h['dur'] for h in ns)
                # if still overfull, convert quarter->eighth using closest gaps
                tries=0
                while total>BEATS+1e-6 and tries<10:
                    tried=False
                    for k in range(len(ns)-1,-1,-1):
                        h=ns[k]
                        if h['code']==11 and not h['beamed']:
                            h['dur']=0.5; total-=0.5; tried=True; break
                    if not tried: break
                    tries+=1
                # fill underfull with rests at end
                if not ns:
                    measures.append([('R','1','',None)]); continue
                rests=[]
                rest_pos=None
                if total<BEATS-1e-6:
                    need=BEATS-total
                    while need>1e-6:
                        if need>=2: rests.append(2); need-=2
                        elif need>=1: rests.append(1); need-=1
                        else: rests.append(0.5); need-=0.5
                    # choose largest gap between left barline and notes/right barline
                    left=sysd['bars'][m-1] if m>0 else sysd['left']
                    right=sysd['bars'][m] if m<len(sysd['bars']) else sysd['bars'][-1]
                    pts=[h['x'] for h in ns]
                    gaps=[]
                    gaps.append((pts[0]-left,'start'))
                    for k in range(len(pts)-1):
                        gaps.append((pts[k+1]-pts[k],k))
                    gaps.append((right-pts[-1],'end'))
                    rest_pos=max(gaps,key=lambda g:g[0])[1]
                # build tokens with beam brackets, inserting rests at rest_pos
                toks=[]; i=0
                if rest_pos=='start':
                    for r in rests: toks.append(('r',{2:'2',1:'4',0.5:'8'}[r],'',None))
                while i<len(ns):
                    h=ns[i]
                    p=ly_pitch(h['pitch'])
                    acc=h['accident']
                    if acc=='flat': p=p[0]+'f'+p[1:]
                    elif acc=='sharp': p=p[0]+'s'+p[1:]
                    elif acc=='natural': p=p+'!'
                    d=ly_dur(h['code'],h['beamed'],h['dot'])
                    # beam group
                    if h['beamed']:
                        j=i
                        while j+1<len(ns) and ns[j+1]['beamed']: j+=1
                        if j==i:
                            toks.append((p,d,'',h['x'])); i+=1; continue
                        toks.append((p,d,'[',h['x']))
                        for k in range(i+1,j+1):
                            h2=ns[k]
                            p2=ly_pitch(h2['pitch'])
                            if h2['accident']=='flat': p2=p2[0]+'f'+p2[1:]
                            elif h2['accident']=='sharp': p2=p2[0]+'s'+p2[1:]
                            elif h2['accident']=='natural': p2=p2+'!'
                            last=']' if k==j else ''
                            toks.append((p2,ly_dur(h2['code'],True,h2['dot']),last,h2['x']))
                        i=j+1
                    else:
                        toks.append((p,d,'',h['x'])); i+=1
                    if rest_pos==i-1 and rest_pos!='start' and rest_pos!='end':
                        for r in rests: toks.append(('r',{2:'2',1:'4',0.5:'8'}[r],'',None))
                if rest_pos=='end' or (isinstance(rest_pos,int) and rest_pos==len(ns)-1):
                    for r in rests: toks.append(('r',{2:'2',1:'4',0.5:'8'}[r],'',None))
                measures.append(toks)
            out.append((si,voice,measures))
    return out

data=meld(all_systems)
# group per voice
voices={0:[],1:[],2:[],3:[]}
for si,voice,measures in data:
    voices[voice].extend(measures)

def fmt_measures(measures):
    lines=[]
    for toks in measures:
        parts=[]
        for p,d,br,x in toks:
            if p=='r': parts.append('r'+d+br)
            elif p=='R': parts.append('R'+d+br)
            else: parts.append(p+d+br)
        lines.append('  '+' '.join(parts))
    return '\n'.join(lines)

(WORK/'voices.txt').write_text('\n\n'.join(f'% VOICE {v}\n'+fmt_measures(voices[v]) for v in range(4))+'\n')
(WORK/'transcription.json').write_text(json.dumps({'data':data,'voices':voices}, ensure_ascii=False))
for v in range(4):
    print(f'% VOICE {v}')
    print(fmt_measures(voices[v]))
    print()
print(f'écrit {WORK}/voices.txt et {WORK}/transcription.json')
