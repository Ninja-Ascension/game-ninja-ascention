"""Check a transfer folder and smoke-test executable resource loading there."""
import hashlib,json,os,sqlite3,subprocess
from pathlib import Path
root=Path(__file__).resolve().parents[1]
bundle=Path((root/'build/ultimo-pacote-vps.txt').read_text(encoding='utf8'))
game=bundle/'jogo';exe=game/'build/windows-probe-native/bin/NinjaResourceProbe/Debug/NinjaResourceProbe.exe'
def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
original=root/exe.relative_to(game)
if sha(original)!=sha(exe):raise RuntimeError('Executável copiado não corresponde à última compilação')
rows=json.loads((bundle/'MANIFESTO.json').read_text(encoding='utf8'))
for row in rows:
    p=bundle/row['path']
    assert p.is_file() and p.stat().st_size==row['bytes'],str(p)
db=game/'port/dados/contas.sqlite3'
with sqlite3.connect(db) as connection:
    assert connection.execute('PRAGMA integrity_check').fetchone()[0]=='ok'
    tables=connection.execute("SELECT count(*) FROM sqlite_master WHERE type='table'").fetchone()[0]
env={k:v for k,v in os.environ.items() if not k.startswith('NR_PROBE_')}
env.update(NR_GAME_ROOT=str(game),NR_ENABLE_TUTORIAL='0',NR_PROBE_AUTO_REAL_CHAIN='1',NR_PROBE_NO_DIALOG='1',NR_PROBE_WRITABLE=str(game/'build/validacao-portabilidade'))
proc=subprocess.Popen([str(exe)],cwd=exe.parent,env=env,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
try:
    out,err=proc.communicate(timeout=18)
except subprocess.TimeoutExpired:
    proc.terminate();out,err=proc.communicate(timeout=10)
text=out.decode('utf8','replace')
(bundle/'VALIDACAO_INICIAL.log').write_text(text+'\n'+err.decode('utf8','replace'),encoding='utf8')
normalized=text.replace('\\','/')
assert str(game).replace('\\','/') in normalized,'Novo caminho não apareceu na inicialização; confira VALIDACAO_INICIAL.log'
assert 'BOOT_MAP_STEP\t0.arch\tOK' in text,'Assets da cópia não carregaram'
assert 'LUA ERROR:' not in text,'Erro Lua na abertura; conferir log'
summary={'manifest_files':len(rows),'database_integrity':'ok','database_tables':tables,'executable_sha256':sha(exe),'portable_root':str(game),'initial_boot':'passed','limits':'Smoke test only; does not validate all gameplay or a clean Windows VPS environment.'}
(bundle/'VALIDACAO.json').write_text(json.dumps(summary,ensure_ascii=False,indent=2),encoding='utf8')
print(json.dumps(summary,ensure_ascii=False))
