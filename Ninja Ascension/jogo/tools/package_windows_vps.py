"""Create a self-contained Windows transfer folder; leave research originals in place."""
import json, os, shutil, sqlite3, time, subprocess
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
DEST=ROOT/os.environ.get('NR_VPS_PACKAGE_NAME', 'VPS_WINDOWS_'+time.strftime('%Y%m%d_%H%M%S'))
if DEST.parent!=ROOT or not DEST.name.startswith('VPS_WINDOWS_'):raise RuntimeError('Destino deve ser uma pasta VPS_WINDOWS_ dentro do projeto')
GAME=DEST/'jogo'
DEST.mkdir(exist_ok=True); GAME.mkdir(exist_ok=True)
report={'source':str(ROOT),'destination':str(DEST),'copied_files':0,'bytes':0,'removed_caches':[],'excluded':['APK/ZIP/JADX originais','Java/Smali decompilados','auditorias e layouts de referência','builds intermediários, fixtures, logs e backups antigos','PDB e caches Python']}
def copy_tree(src,dst,skip_git=False):
    src=Path(src);dst=Path(dst)
    if not src.exists():raise FileNotFoundError(src)
    if os.name=='nt':
        result=subprocess.run(['robocopy',str(src),str(dst),'/E','/XJ','/MT:16','/R:1','/W:1','/NFL','/NDL','/NJH','/NJS','/NP','/XF','*.pyc','*.pyo','*.log','*.pdb','*.dmp','/XD','__pycache__']+(['.git'] if skip_git else []),capture_output=True)
        if result.returncode>=8:raise RuntimeError('Falha ao copiar '+str(src)+': '+result.stdout.decode(errors='replace')[-1200:])
        return
    for base,dirs,files in os.walk(src,followlinks=False):
        dirs[:]=[n for n in dirs if n not in ('__pycache__',) and not (skip_git and n=='.git') and not (Path(base)/n).is_junction() and not (Path(base)/n).is_symlink()]
        target=dst/Path(base).relative_to(src);target.mkdir(parents=True,exist_ok=True)
        for name in files:
            p=Path(base)/name
            if p.is_symlink() or p.suffix.lower() in ('.pyc','.pyo','.log','.pdb','.dmp'):continue
            shutil.copy2(p,target/name);report['copied_files']+=1;report['bytes']+=p.stat().st_size
def copy_file(src,dst):
    dst.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(src,dst)
    report['copied_files']+=1;report['bytes']+=src.stat().st_size
print('Destino: '+str(DEST),flush=True)
for name in ('res','src'):
    print('Copiando assets/'+name,flush=True)
    copy_tree(ROOT/'01_conteudo_apk/assets'/name,GAME/'01_conteudo_apk/assets'/name)
for name in ('lua','native','resources','server','data','tests'):
    print('Copiando port/'+name,flush=True);copy_tree(ROOT/'port'/name,GAME/'port'/name)
for name in ('gameplay.json','CMakeLists.txt'):copy_file(ROOT/'port'/name,GAME/'port'/name)
copy_tree(ROOT/'tools',GAME/'tools')
for folder in (ROOT/'port',ROOT/'port/docs'):
    if folder.exists():
        for p in folder.glob('*.md'):copy_file(p,DEST/'documentacao'/p.name)
for name in ('axmol','spine-2.1.25'):
    print('Copiando dependencia '+name,flush=True)
    copy_tree(ROOT/'build/deps'/name,GAME/'build/deps'/name)
BIN=Path('build/windows-probe-native/bin/NinjaResourceProbe/Debug')
for p in (ROOT/BIN).iterdir():
    if p.is_file() and p.suffix.lower() in ('.exe','.dll'):copy_file(p,GAME/BIN/p.name)
copy_tree(ROOT/'build/windows-probe-native/runtime/axslc',GAME/'build/windows-probe-native/runtime/axslc')
db=GAME/'port/dados/contas.sqlite3';db.parent.mkdir(parents=True,exist_ok=True)
with sqlite3.connect(ROOT/'port/dados/contas.sqlite3') as live,sqlite3.connect(db) as backup:live.backup(backup)
# Preserve only persistent client preferences, not diagnostic/test databases.
writable=ROOT/'build/probe-writable'
if writable.exists():
    for p in writable.iterdir():
        if p.is_file() and p.suffix.lower()=='.xml':copy_file(p,GAME/'build/probe-writable'/p.name)
for name in ('INICIAR_JOGO.cmd','INICIAR_SERVIDOR.cmd','iniciar.ps1','LEIA_PRIMEIRO.md'):
    copy_file(ROOT/'tools/vps_windows'/name,DEST/name)
# Delete only regenerable Python caches under owned source directories.
for folder in (ROOT/'port/server',ROOT/'tools'):
    for base,dirs,files in os.walk(folder,topdown=False,followlinks=False):
        for name in dirs:
            p=Path(base)/name
            if name!='__pycache__' or p.is_symlink() or p.is_junction():continue
            resolved=p.resolve()
            if not resolved.is_relative_to(folder.resolve()):raise RuntimeError('Cache fora da pasta autorizada')
            entries=list(p.iterdir())
            if any(not q.is_file() or q.suffix!='.pyc' for q in entries):continue
            for q in entries:q.unlink();report['removed_caches'].append(str(q.relative_to(ROOT)))
            p.rmdir()
manifest=[]
for base,dirs,files in os.walk(DEST):
    for name in files:
        p=Path(base)/name;manifest.append({'path':p.relative_to(DEST).as_posix(),'bytes':p.stat().st_size})
(DEST/'MANIFESTO.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2),encoding='utf8')
report['copied_files']=len(manifest);report['bytes']=sum(r['bytes'] for r in manifest)
(DEST/'RELATORIO.json').write_text(json.dumps(report,ensure_ascii=False,indent=2),encoding='utf8')
(ROOT/'build/ultimo-pacote-vps.txt').write_text(str(DEST),encoding='utf8')
print(json.dumps(report,ensure_ascii=False),flush=True)
