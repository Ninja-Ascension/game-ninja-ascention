import os,sys,tempfile
from pathlib import Path
root=Path(__file__).resolve().parents[1];sys.path.insert(0,str(root/'port/server'))
with tempfile.TemporaryDirectory(prefix='scene-rewards-',dir=root/'build') as folder:
    os.environ['NR_ACCOUNTS_DIR']=folder
    import local_server as server
    import tutorial_campaign as campaign
    db=server.BANCO
    try:
        account=db.criar_conta('chest_test','Temporary123!')['id'];uid=str(db.perfil(account)['user_id'])
        server._sessao_conexao['token']=db.abrir_sessao(account)
        request='1\r\ndraw_scene_rewad\r\n'+uid+'\r\n1\r\n0'
        assert ' -1 ' in server.despacha(request),'Chest ignored star eligibility'
        for npc in (1,2,3):db._conn.execute('INSERT INTO local_pve_clears VALUES (?,1,?,3)',(account,npc))
        db._conn.commit()
        reply=server.despacha(request)
        assert reply.startswith('1 draw_scene_rewad 0 '),reply
        assert db._conn.execute('SELECT silver FROM local_campaign').fetchone()[0]==6000
        assert db._conn.execute('SELECT gold FROM local_resources').fetchone()[0]==50
        props=dict(db._conn.execute('SELECT mould,quantity FROM local_inventory').fetchall())
        assert props=={68:5,57:10},props
        again=server.despacha(request);assert again.startswith('1 draw_scene_rewad 0 ')
        assert dict(db._conn.execute('SELECT mould,quantity FROM local_inventory').fetchall())==props
        assert db._conn.execute('SELECT silver FROM local_campaign').fetchone()[0]==6000
        assert campaign.scene_tokens(db,account)[4].split(',')[0]=='1'
        (root/'build/chest-test-reply.txt').write_text(reply,encoding='utf8')
        (root/'build/chest-test-login.txt').write_text(server.resposta_login_init('2',''),encoding='utf8')
        path=db.caminho;db.fechar()
        from contas import Banco
        db=Banco(path)
        assert db._conn.execute('SELECT COUNT(*) FROM local_scene_rewards').fetchone()[0]==1
        assert campaign.scene_tokens(db,account)[4].split(',')[0]=='1'
    finally:db.fechar()
print('SCENE_REWARDS_PASSED star eligibility, original silver/gold/items, consume receipt once, flags and relogin')
