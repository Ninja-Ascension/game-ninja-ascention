"""Parse real saved profiles using a private SQLite copy, never mutate player DB."""
import os,sys,sqlite3,tempfile,subprocess
from pathlib import Path
root=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(root/'port/server'))
with tempfile.TemporaryDirectory(prefix='saved-resume-',dir=root/'build') as folder:
    folder=Path(folder)
    source=sqlite3.connect((root/'port/dados/contas.sqlite3').as_uri()+'?mode=ro',uri=True)
    target=sqlite3.connect(folder/'contas.sqlite3');source.backup(target);target.close();source.close()
    os.environ['NR_ACCOUNTS_DIR']=str(folder)
    import local_server as server
    from tutorial_campaign import resume_record
    db=server.BANCO
    try:
        ids=[row[0] for row in db._conn.execute('SELECT id FROM contas ORDER BY id')]
        for account in ids:
            server._sessao_conexao['token']=db.abrir_sessao(account)
            reply=server.resposta_login_init('1','')
            checkpoint=resume_record(db,account)
            assert checkpoint and checkpoint in reply
            path=folder/('profile-%s.txt'%account);path.write_text(reply,encoding='utf8')
            env={key:value for key,value in os.environ.items() if not key.startswith('NR_PROBE_') and not key.startswith('NR_TESTE_')}
            env.update(NR_PROBE_NO_DIALOG='1',NR_PROBE_TEST_MODE='host',NR_PROBE_BOOT_MAP='1',
                       NR_PROBE_MENU_TEST='1',NR_PROBE_SAVED_RESUME='1',NR_PROBE_LOGIN_REPLY=str(path),
                       NR_PROBE_EXPECT_GROUP=checkpoint.split('&')[1].split(',')[1],NR_PROBE_EXPECT_ACCOUNT=str(db.perfil(account)['user_id']))
            exe=root/'build/windows-probe-native/bin/NinjaResourceProbe/Debug/NinjaResourceProbe.exe'
            run=subprocess.run([str(exe)],cwd=exe.parent,env=env,capture_output=True,timeout=30)
            output=run.stdout.decode('utf8',errors='replace')
            (root/('build/saved-profile-%s.log'%account)).write_text(output,encoding='utf8')
            assert run.returncode==0 and 'SAVED_PROFILE_NATIVE_PASSED' in output,output[-3000:]
            assert 'LUA ERROR:' not in output
            print('SAVED_PROFILE_NATIVE_PASSED account_id=%s'%account,flush=True)
    finally:db.fechar()
print('ALL_SAVED_PROFILES_PASSED private copy; player DB untouched')
