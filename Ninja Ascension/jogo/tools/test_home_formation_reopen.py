"""Actual FormationTigerGate open/close/reopen, with a private temporary profile."""
import os
from pathlib import Path
import subprocess
import sys
import tempfile

root=Path(__file__).resolve().parents[1]
output=root/'build/formation-reopen'
output.mkdir(exist_ok=True)
sys.path.insert(0,str(root/'port/server'))
os.environ['NR_ENABLE_TUTORIAL']='0'
with tempfile.TemporaryDirectory(prefix='formation-reopen-db-',dir=root/'build') as folder:
    os.environ['NR_ACCOUNTS_DIR']=folder
    import local_server as server
    db=server.BANCO
    try:
        account=db.criar_conta('formationcheck','Temporary123!')['id']
        server._sessao_conexao['token']=db.abrir_sessao(account)
        (output/'login.txt').write_text(server.resposta_login_init('7',''),encoding='utf8')
    finally:db.fechar()
(output/'trace.txt').write_text('',encoding='utf8')
env={k:v for k,v in os.environ.items() if not k.startswith('NR_')}
env.update(NR_GAME_ROOT=str(root),NR_PROBE_WRITABLE=str(output),
           NR_PROBE_FORMATION_REOPEN='1',NR_PROBE_MENU_TEST='1',
           NR_PROBE_BOOT_MAP='1',NR_PROBE_TEST_MODE='host',NR_PROBE_SHOT=str(output))
run=subprocess.run([str(root/'build/windows-release/bin/NinjaResourceProbe/Release/NinjaResourceProbe.exe')],
                   cwd=root,env=env,capture_output=True,timeout=35)
(output/'native-after.log').write_bytes(run.stdout+run.stderr)
assert run.returncode==0,run.returncode
trace=(output/'trace.txt').read_text(encoding='utf8')
assert 'PASSED repeated formation openings and closes' in trace,trace
assert 'FAILED' not in trace,trace
print('HOME_FORMATION_REOPEN_PASSED three actual native openings and closes without access violation')
