"""Replay temporary-account Recruit responses through the real native result UI."""
import os
import subprocess
import sys
import tempfile
import shutil
from pathlib import Path

root = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(root / 'port/server'))
output = root / 'build/legacy-recruit-native'
output.mkdir(exist_ok=True)
os.environ['NR_ENABLE_TUTORIAL'] = '0'

with tempfile.TemporaryDirectory(prefix='legacy-recruit-ui-', dir=root / 'build') as folder:
    os.environ['NR_ACCOUNTS_DIR'] = folder
    import local_server as server
    import legacy_recruit_local as recruit
    db = server.BANCO
    try:
        account = db.criar_conta('legacy_ui_test', 'Temporary123!')['id']
        server._sessao_conexao['token'] = db.abrir_sessao(account)
        uid = str(db.perfil(account)['user_id'])
        server.resposta_login_init('1', '')
        with db._conn:
            db._conn.execute('INSERT OR IGNORE INTO local_campaign(conta_id,grade,silver) VALUES (?,1,5000000)', (account,))
            db._conn.execute('UPDATE local_resources SET gold=100000 WHERE conta_id=?', (account,))
            db._conn.execute('UPDATE local_campaign SET silver=5000000 WHERE conta_id=?', (account,))
        (output / 'login.txt').write_text(server.resposta_login_init('1', ''), encoding='utf8')
        for case,kind,draws in [
            ('gold', '2', [[13, 1, 1], [13, 1, 1], [6, 68, 3], [13, 2, 1]] + [[6, 68, 3]] * 6),
            ('gold-last', '2', [[6, 68, 3]] * 9 + [[13, 4, 1]]),
            ('ryo', '1', [[6, 68, 3]] * 10),
        ]:
            (output / (case+'-login.txt')).write_text(server.resposta_login_init('1', ''), encoding='utf8')
            rewards = iter(draws)
            recruit._choose = lambda group, allowed_kinds=None: (1, next(rewards))
            payload='\r\n'.join(['11', 'ship_batch_bounty', uid, kind, 'ui-'+case+'-ten'])
            reply = server.despacha(payload)
            assert reply.startswith('11 ship_batch_bounty 0 '), reply
            assert server.despacha(payload) == reply
            (output / (case+'.txt')).write_text(reply, encoding='utf8')
        assert db._conn.execute('PRAGMA integrity_check').fetchone()[0] == 'ok'
    finally:
        db.fechar()

env = {k: v for k, v in os.environ.items() if not k.startswith('NR_PROBE_')}
env.pop('NR_ACCOUNTS_DIR', None)
env.update(NR_GAME_ROOT=str(root), NR_PROBE_LEGACY_RECRUIT_UI='1', NR_PROBE_NO_DIALOG='1',
           NR_PROBE_RECRUIT_RESULTS='1',
           NR_PROBE_TEST_MODE='host', NR_PROBE_BOOT_MAP='1', NR_PROBE_MENU_TEST='1',
           NR_PROBE_SHOT=str(output))
exe = root / 'build/windows-release/bin/NinjaResourceProbe/Release/NinjaResourceProbe.exe'
for case in ('gold','gold-last','ryo','gold-skip'):
    env['NR_PROBE_LEGACY_RECRUIT_CASE']=case
    (output / 'result.txt').write_text('not run',encoding='utf8')
    run = subprocess.run([str(exe)], cwd=root, env=env, capture_output=True, timeout=45)
    text = run.stdout.decode('utf8', errors='replace') + run.stderr.decode('utf8', errors='replace')
    (output / (case+'-native.log')).write_text(text, encoding='utf8')
    result = (output / 'result.txt').read_text(encoding='utf8')
    assert run.returncode == 0 and result.startswith('true'), (case,run.returncode,result)
    trace=(output / 'trace.txt').read_text(encoding='utf8')
    assert 'ERROR ' not in trace, trace
    shutil.copy2(output / 'trace.txt',output / (case+'-trace.txt'))
    shutil.copy2(output / 'logo-host-shot.png',output / (case+'-summary.png'))
    print('LEGACY_RECRUIT_NATIVE_PASSED',case,flush=True)
