import os,sys,tempfile
from pathlib import Path
root=Path(__file__).resolve().parents[1];sys.path.insert(0,str(root/'port/server'))
with tempfile.TemporaryDirectory(prefix='synthesis-',dir=root/'build') as folder:
    os.environ['NR_ACCOUNTS_DIR']=folder
    import local_server as server
    import dados_batalha as data
    import recruitment_local as heroes
    db=server.BANCO
    try:
        account=db.criar_conta('synthesis_test','Temporary123!')['id']
        uid=str(db.perfil(account)['user_id']);server._sessao_conexao['token']=db.abrir_sessao(account)
        row=data.tabela('prop_mould.txt')['2'];cost=int(row[9]);mould=int(row[39]);item=account*1000000+2
        db._conn.execute('INSERT INTO local_inventory VALUES (?,?,?,?)',(account,2,item,cost));db._conn.commit()
        request='1\r\nprop_compound\r\n'+uid+'\r\n'+str(item)+'\r\n1\r\n1'
        reply=server.despacha(request);assert reply.startswith('1 prop_compound 0 '),reply
        assert db._conn.execute('SELECT quantity FROM local_inventory').fetchone()[0]==0
        assert (1000000000+account*100000+mould,mould) in heroes.all_owned(db,account)
        assert server.despacha(request)==reply,'Replay consumed fragments twice'
        bad=request.replace(str(item),str(item+999999))
        assert ' -1 ' in server.despacha(bad)
        (root/'build/synthesis-test-reply.txt').write_text(reply,encoding='utf8')
        (root/'build/synthesis-test-login.txt').write_text(server.resposta_login_init('2',''),encoding='utf8')
        assert db._conn.execute('PRAGMA foreign_key_check').fetchall()==[]
    finally:db.fechar()
print('TUTORIAL_SYNTHESIS_PASSED original costs, owned fragments, consume once, character saved, replay')
