from pathlib import Path
import os,sys,tempfile
root=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(root/'port/server'))
with tempfile.TemporaryDirectory(prefix='hero-training-',dir=root/'build') as folder:
    os.environ['NR_ACCOUNTS_DIR']=folder
    import local_server as server
    import hero_training_local as training
    db=server.BANCO
    try:
        account=db.criar_conta('training_test','Temporary123!')['id']
        server._sessao_conexao['token']=db.abrir_sessao(account)
        uid=str(db.perfil(account)['user_id']);ship=str(account*100000+13)
        r=training.requirement()
        materials=','.join(str(account*1000000+int(r[i])) for i in (2,4,6,8))
        request='2\r\nship_grow_up\r\n'+uid+'\r\n'+ship+'\r\n \r\n'+materials+'\r\n \r\n1'
        assert ' -1 ' in server.despacha(request),'Lesson bypassed its unlock level'
        db._conn.execute('INSERT INTO local_campaign VALUES (?,?,?)',(account,3,198));db._conn.commit()
        login=server.resposta_login_init('1','')
        assert db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?',(account,)).fetchone()[0]==5198
        training.prepare(db,account)
        assert db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?',(account,)).fetchone()[0]==5198
        (root/'build/hero-training-login.txt').write_text(login,encoding='utf8')
        response=server.despacha(request)
        assert 'ship_grow_up 0 22 198 6024 0 14104' in response
        assert db._conn.execute('SELECT quality FROM tutorial_training').fetchone()[0]==1
        assert db._conn.execute('SELECT SUM(quantity) FROM local_inventory').fetchone()[0]==0
        assert response==server.despacha(request),'Replayed upgrade charged twice'
        (root/'build/hero-training-upgrade.txt').write_text(response,encoding='utf8')
        (root/'build/hero-training-after.txt').write_text(server.resposta_login_init('3',''),encoding='utf8')
        path=db.caminho
    finally:db.fechar()
    from contas import Banco
    db=Banco(path)
    try:
        assert db._conn.execute('SELECT quality,kit FROM tutorial_training').fetchone()[:]==(1,1)
        assert db._conn.execute('PRAGMA foreign_key_check').fetchall()==[]
    finally:db.fechar()
print('HERO_TRAINING_SERVER_PASSED unlock, starter, exact costs, kit once, consume once, saved quality')
