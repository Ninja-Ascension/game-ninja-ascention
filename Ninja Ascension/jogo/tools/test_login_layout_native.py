"""Real parsers, empty/populated inventory; entirely private SQLite."""
import os,sys,tempfile,subprocess
from pathlib import Path
root=Path(__file__).resolve().parents[1];sys.path.insert(0,str(root/'port/server'))
os.environ['NR_ENABLE_TUTORIAL']='0'
with tempfile.TemporaryDirectory(prefix='login-layout-',dir=root/'build') as folder:
    os.environ['NR_ACCOUNTS_DIR']=folder
    import local_server as server
    server.log=lambda *args:None
    db=server.BANCO
    try:
        account=db.criar_conta('layout_test','Temporary123!')['id']
        server._sessao_conexao['token']=db.abrir_sessao(account)
        for case in ('empty','items','level100'):
            if case=='items':
                for mould,quantity in ((68,3),(69,7)):
                    db._conn.execute('INSERT INTO local_inventory VALUES (?,?,?,?)',(account,mould,account*1000000+mould,quantity))
                db._conn.commit()
            if case=='level100':
                with db._conn:
                    db._conn.execute('INSERT OR REPLACE INTO local_campaign VALUES (?,100,900000000)',(account,))
                    db._conn.execute('INSERT OR REPLACE INTO tutorial_training VALUES (?,1,0)',(account,))
                    db._conn.execute('UPDATE local_resources SET gold=1000000,food=10000,endurance=10000 WHERE conta_id=?',(account,))
                    for mould in (366,368,372,375,382,383,385):
                        db._conn.execute('INSERT OR IGNORE INTO local_synthesized VALUES (?,?,?)',(account,mould,1000000000+account*100000+mould))
            payload=server.resposta_login_init('1','')
            path=Path(folder)/(case+'.txt');path.write_text(payload,encoding='utf8')
            env={key:value for key,value in os.environ.items() if not key.startswith('NR_PROBE_')}
            env.update(NR_PROBE_DIRECT_MENU='1',NR_PROBE_LOGIN_ONLY='1',NR_PROBE_COLD_STATES='1',NR_PROBE_NO_DIALOG='1',
                       NR_PROBE_TEST_MODE='host',NR_PROBE_BOOT_MAP='1',NR_PROBE_MENU_TEST='1',NR_PROBE_LOGIN_REPLY=str(path))
            if case=='items':env['NR_PROBE_EXPECT_ITEMS']='1'
            if case=='level100':env.update(NR_PROBE_EXPECT_LEVEL='100',NR_PROBE_EXPECT_FOOD='10000',NR_PROBE_EXPECT_ITEMS='1',NR_PROBE_EXPECT_HEROES='10')
            exe=root/'build/windows-probe-native/bin/NinjaResourceProbe/Debug/NinjaResourceProbe.exe'
            run=subprocess.run([str(exe)],cwd=exe.parent,env=env,capture_output=True,timeout=30)
            output=run.stdout.decode('utf8',errors='replace')
            (root/('build/login-layout-'+case+'.log')).write_text(output,encoding='utf8')
            assert run.returncode==0 and 'LOGIN_LAYOUT_NATIVE_PASSED' in output,output[-3000:]
            assert 'LUA ERROR:' not in output and 'MENU_BOOT_PROBE_RESULT false' not in output
            print('LOGIN_LAYOUT_NATIVE_PASSED',case,flush=True)
    finally:db.fechar()
