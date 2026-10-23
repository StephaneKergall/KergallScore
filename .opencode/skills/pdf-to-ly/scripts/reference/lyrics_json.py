import re, html, json, importlib.util, io, contextlib, os
from pathlib import Path
from collections import defaultdict
WORK=Path(os.environ.get('OUT_DIR','/tmp/pdftoly'))
BBOX=Path(os.environ.get('BBOX_HTML', WORK/'bbox.html'))
s=BBOX.read_text()
pages=re.findall(r'<page .*?</page>', s, re.S)
spec=importlib.util.spec_from_file_location('tr', Path(__file__).with_name('transcribe.py'))
tr=importlib.util.module_from_spec(spec)
with contextlib.redirect_stdout(io.StringIO()): spec.loader.exec_module(tr)
staff_bottoms={}
for sysd in tr.all_systems:
    page = sysd['page']
    local = sysd['sysno']
    for v in range(4):
        staff_bottoms[(page,local*4+v)] = sysd['staves'][v][-1]
def is_lyric(t):
    if t in ('-','--'): return True
    if t in ('dim.','rit.','rit','molto','piu','mosso','dim'): return False
    if t in ('Soprano','Alto','Ténor','Basse','Annotations'): return False
    if re.fullmatch(r'[A-Za-zÀ-ÿ]+[,.]?',t):
        if len(re.sub(r'[,.]','',t))==1:
            return t[0].lower() in ('o','a','e','i')
        return True
    return False
out={}
for pageno,pagehtml in enumerate(pages,1):
    words=[]
    for m in re.finditer(r'<word xMin="([\d.]+)" yMin="([\d.]+)" xMax="([\d.]+)" yMax="([\d.]+)">([^<]*)</word>',pagehtml):
        x0,y0,x1,y1=map(float,m.groups()[:4]); text=html.unescape(m.group(5))
        words.append((x0,y0,x1,y1,text))
    lines=defaultdict(list)
    for w in words: lines[round(w[1])].append(w)
    for y in sorted(lines):
        ws=sorted(lines[y],key=lambda w:w[0])
        kept=[w for w in ws if is_lyric(w[4])]
        if len(kept)<2: continue
        if not any(re.fullmatch(r'[A-Za-zÀ-ÿ]{2,}[,.]?',w[4]) for w in kept): continue
        best=None
        for (pg,st),bot in staff_bottoms.items():
            if pg!=pageno: continue
            top=842-bot
            if top < y <= top+35:
                if best is None or y-top < y-best[1]: best=(st,top)
        if best:
            st,top=best
            local_sys=st//4
            voice=st%4
            out[f'{pageno},{local_sys},{voice}']=[(round(w[0],1),w[4]) for w in kept]
WORK.mkdir(parents=True, exist_ok=True)
json.dump(out,open(WORK/'lyrics.json','w'),ensure_ascii=False,indent=1)
for k,v in out.items(): print(k, ' '.join(t for x,t in v))
print(f'écrit {WORK}/lyrics.json')
