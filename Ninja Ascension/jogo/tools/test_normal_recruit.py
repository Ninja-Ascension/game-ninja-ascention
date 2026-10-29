"""Normal x1/x10, duplicates, costs, retries, rollback and persistence."""
import os,sys,tempfile,json
from pathlib import Path
root=Path(__file__).resolve().parents[1];sys.path.insert(0,str(root/'port/server'))
os.environ['NR_ENABLE_TUTORIAL']='0'
with tempfile.TemporaryDirectory(prefix='normal-recruit-',dir=root/'build') as folder:
    os.environ['NR_ACCOUNTS_DIR']=folder
    import local_server as server
    import normal_recruit as recruit
    import recruitment_local as heroes
    db=server.BANCO
    try:
        account=db.criar_conta('recruit_normal','Temporary123!')['id']
        server._sessao_conexao['token']=db.abrir_sessao(account)
        uid=str(db.perfil(account)['user_id'])
        server.resposta_login_init('1','')
        with db._conn:db._conn.execute('UPDATE local_resources SET gold=100000 WHERE conta_id=?',(account,))
        (root/'build/normal-recruit-login.txt').write_text(server.resposta_login_init('1',''),encoding='utf8')
        def request(count,key):
            return server.despacha('\r\n'.join(['2','new_recruitment_system',uid,str(count),key]))
        original=recruit.choose
        recruit.choose=lambda group:[13,1,1,2]
        first=request(1,'free-one');assert first.startswith('2 new_recruitment_system 0 '),first
        assert db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?',(account,)).fetchone()[0]==100000
        assert request(1,'free-one')==first
        assert ' -1 ' in request(10,'free-one')
        second=request(1,'paid-one');assert second.startswith('2 new_recruitment_system 0 '),second
        assert db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?',(account,)).fetchone()[0]==99760
        prop,quantity=recruit.fragment(1)
        assert db._conn.execute('SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=?',(account,prop)).fetchone()[0]==quantity
        calls=[]
        def choose(group):
            calls.append(group)
            return [13,2,1,2] if len(calls)==10 else [6,14,5]
        recruit.choose=choose
        ten=request(10,'paid-ten');assert ten.startswith('2 new_recruitment_system 0 '),ten
        assert db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?',(account,)).fetchone()[0]==97480
        assert len(calls)==10 and 3 in calls,'SR pity group never selected'
        assert request(10,'paid-ten')==ten
        with db._conn:db._conn.execute('UPDATE local_resources SET gold=0 WHERE conta_id=?',(account,))
        assert ' -1 ' in request(10,'insufficient')
        assert db._conn.execute('SELECT total FROM local_recruit_state WHERE conta_id=?',(account,)).fetchone()[0]==12
        assert len(heroes.all_owned(db,account))==5
        assert db._conn.execute('SELECT COUNT(*) FROM tutorial_recruit').fetchone()[0]==0
        assert server.despacha('7\r\neducation_change\r\n'+uid+'\r\n30208')=='7 education_change 0'
        assert db._conn.execute('SELECT COUNT(*) FROM tutorial_events').fetchone()[0]==0
        for name,value in [('one',first),('duplicate',second),('ten',ten)]:
            (root/('build/normal-recruit-'+name+'.txt')).write_text(value,encoding='utf8')
        recruit.choose=original
        for group in (3,4,5):assert original(group)[0] in (6,13)
        path=db.caminho
    finally:db.fechar()
    from contas import Banco
    db=Banco(path)
    try:
        assert len(heroes.all_owned(db,account))==5
        assert db._conn.execute('SELECT total FROM local_recruit_state').fetchone()[0]==12
        assert db._conn.execute('SELECT COUNT(*) FROM local_recruit_receipt').fetchone()[0]==3
    finally:db.fechar()
print('NORMAL_RECRUIT_SERVER_PASSED')
