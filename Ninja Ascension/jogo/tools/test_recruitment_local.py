from pathlib import Path
import os,sys,tempfile
os.environ['NR_ENABLE_TUTORIAL']='1' # This fixture exercises the legacy first Sakura draw.
root=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(root/'port/server'))
with tempfile.TemporaryDirectory(prefix='recruit-test-',dir=root/'build') as folder:
    os.environ['NR_ACCOUNTS_DIR']=folder
    import local_server as server
    import recruitment_local as recruit
    db=server.BANCO
    try:
        account=db.criar_conta('recruit_test','Temporary123!')['id']
        server._sessao_conexao['token']=db.abrir_sessao(account)
        uid=str(db.perfil(account)['user_id'])
        (root/'build/recruit-test-login.txt').write_text(server.resposta_login_init('1',''),encoding='utf8')
        request='2\r\nnew_recruitment_system\r\n'+uid+'\r\n1'
        reply=server.despacha(request)
        assert 'new_recruitment_system 0 15005 ' in reply and ' 9 ' in reply and ' 14104 ' in reply
        first=recruit.owned(db,account)
        assert first and first[1]==50
        assert reply==server.despacha(request),'Replayed draw changed the reward'
        assert db._conn.execute('SELECT COUNT(*) FROM tutorial_recruit').fetchone()[0]==1
        (root/'build/recruit-test-draw.txt').write_text(reply,encoding='utf8')
        assert '"totalFreeDraw":0' in server.resposta_login_init('3','')
        assert ' -1 ' in server.despacha(request[:-1]+'10')
        formation='4\r\nformation_change\r\n'+uid+'\r\n'+str(first[0])+'\r\n6\r\n1'
        formation_reply=server.despacha(formation)
        assert ' formation_change 0 56 '+str(first[0])+' 6 0 -1 6012 ' in formation_reply
        positions=recruit.formation_tokens(db,account)
        assert server.despacha(formation).startswith('4 formation_change 0 ')
        assert positions==recruit.formation_tokens(db,account),'Repeated inclusion changed formation'
        (root/'build/recruit-test-formation.txt').write_text(formation_reply,encoding='utf8')
        assert str(first[0]) in recruit.formation_tokens(db,account)
        (root/'build/recruit-test-relogin.txt').write_text(server.resposta_login_init('5',''),encoding='utf8')
        path=db.caminho
    finally:db.fechar()
    from contas import Banco
    db=Banco(path)
    try:
        assert recruit.owned(db,account)==first
        assert str(first[0]) in recruit.formation_tokens(db,account)
    finally:db.fechar()
print('RECRUITMENT_SERVER_PASSED initial state, draw, replay, persistence, unsupported ten draw')
