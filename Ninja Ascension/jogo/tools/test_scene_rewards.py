import os,sys,tempfile
from pathlib import Path
root=Path(__file__).resolve().parents[1];sys.path.insert(0,str(root/'port/server'))
with tempfile.TemporaryDirectory(prefix='scene-rewards-',dir=root/'build') as folder:
    os.environ['NR_ACCOUNTS_DIR']=folder
    # Isolated reward tests use the original campaign flow, outside the new
    # first-login tutorial gate. This override is limited to this temp DB.
    os.environ['NR_ENABLE_TUTORIAL']='0'
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
        reward_marker=reply.rfind('171 ')
        assert reward_marker>=0 and reply[reward_marker:].split()[1]=='0',reply
        assert db._conn.execute('SELECT silver FROM local_campaign').fetchone()[0]==6000
        assert db._conn.execute('SELECT gold FROM local_resources').fetchone()[0]==50
        props=dict(db._conn.execute('SELECT mould,quantity FROM local_inventory').fetchall())
        assert props=={68:5,57:10},props
        again=server.despacha(request);assert again.startswith('1 draw_scene_rewad 0 ')
        assert reply[reward_marker:].split()[2].isdigit(),reply
        assert dict(db._conn.execute('SELECT mould,quantity FROM local_inventory').fetchall())==props
        assert db._conn.execute('SELECT silver FROM local_campaign').fetchone()[0]==6000
        assert campaign.scene_tokens(db,account)[4].split(',')[0]=='1'
        # Scene 2 has original NPC reward mappings in pve_scene.txt.
        for npc in (4,6,8,10):
            db._conn.execute('INSERT INTO local_pve_clears VALUES (?,2,?,3)',(account,npc))
        db._conn.commit()
        before_all=(db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?',(account,)).fetchone()[0],
                    db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?',(account,)).fetchone()[0],
                    dict(db._conn.execute('SELECT mould,quantity FROM local_inventory WHERE conta_id=?',(account,)).fetchall()))
        all_request='2\r\none_key_draw_scene_reward\r\n'+uid+'\r\n0'
        all_reply=server.despacha(all_request)
        assert all_reply.startswith('2 one_key_draw_scene_reward 0 '),all_reply
        all_tokens=all_reply.split();all_marker=all_tokens.index('171')
        all_count=int(all_tokens[all_marker+2])
        all_items=[tuple(map(int,all_tokens[i:i+3])) for i in range(all_marker+3,all_marker+3+all_count*3,3)]
        assert all_tokens[2]=='0' and all_count>0,all_reply
        gold_pos=all_tokens.index('25')
        gold_delta=int(all_tokens[gold_pos+1]);gold_total=int(all_tokens[gold_pos+2])
        assert gold_delta==sum(quantity for _,kind,quantity in all_items if kind==2),all_reply
        assert gold_total==db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?',(account,)).fetchone()[0]
        after_all_inventory=dict(db._conn.execute('SELECT mould,quantity FROM local_inventory WHERE conta_id=?',(account,)).fetchall())
        expected_inventory=dict(before_all[2])
        for ident,kind,quantity in all_items:
            if kind==6:expected_inventory[ident]=expected_inventory.get(ident,0)+quantity
        assert db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?',(account,)).fetchone()[0] == before_all[0]+sum(quantity for _,kind,quantity in all_items if kind==1)
        assert gold_total==before_all[1]+gold_delta
        assert after_all_inventory==expected_inventory,'Claim All did not credit exactly the unclaimed item rows'
        resources_after_all=(db._conn.execute('SELECT silver FROM local_campaign').fetchone()[0],
                             db._conn.execute('SELECT gold FROM local_resources').fetchone()[0],
                             dict(db._conn.execute('SELECT mould,quantity FROM local_inventory').fetchall()))
        (root/'build/claim-all-reply.txt').write_text(all_reply,encoding='utf8')
        (root/'build/claim-all-login.txt').write_text(server.resposta_login_init('2',''),encoding='utf8')
        all_again=server.despacha('3\r\none_key_draw_scene_reward\r\n'+uid+'\r\n0')
        assert all_again.startswith('3 one_key_draw_scene_reward 0 '),all_again
        again_fields=all_again[all_again.rfind('171 '):].split()
        assert again_fields[1:3]==['0','0'],all_again
        again_tokens=all_again.split();again_gold_pos=again_tokens.index('25')
        assert int(again_tokens[again_gold_pos+1])==0,all_again
        assert resources_after_all==(db._conn.execute('SELECT silver FROM local_campaign').fetchone()[0],
                                     db._conn.execute('SELECT gold FROM local_resources').fetchone()[0],
                                     dict(db._conn.execute('SELECT mould,quantity FROM local_inventory').fetchall()))
        # Reproduce the NPC chest shown on chapter 11 in the user's screenshot.
        db._conn.execute('INSERT INTO local_pve_clears VALUES (?,11,91,3)',(account,))
        db._conn.commit()
        npc_request='4\r\ndraw_scene_npc_rewad\r\n'+uid+'\r\n11\r\n0\r\n0'
        npc_reply=server.despacha(npc_request)
        assert npc_reply.startswith('4 draw_scene_npc_rewad 0 '),npc_reply
        npc_marker=npc_reply.rfind('171 ')
        npc_fields=npc_reply[npc_marker:].split()
        assert npc_marker>=0 and npc_fields[1]=='0' and int(npc_fields[2])>0,npc_reply
        npc_resources=(db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?',(account,)).fetchone()[0],
                       db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?',(account,)).fetchone()[0],
                       dict(db._conn.execute('SELECT mould,quantity FROM local_inventory WHERE conta_id=?',(account,)).fetchall()))
        npc_again=server.despacha('5\r\ndraw_scene_npc_rewad\r\n'+uid+'\r\n11\r\n0\r\n0')
        assert npc_again.startswith('5 draw_scene_npc_rewad 0 '),npc_again
        assert npc_resources==(db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?',(account,)).fetchone()[0],
                               db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?',(account,)).fetchone()[0],
                               dict(db._conn.execute('SELECT mould,quantity FROM local_inventory WHERE conta_id=?',(account,)).fetchall()))
        # The latest screenshot is on chapter 15, NPC 134 (index 1).
        for npc in (131,134,136):
            db._conn.execute('INSERT INTO local_pve_clears VALUES (?,15,?,3)',(account,npc))
        db._conn.commit()
        chapter15=server.despacha('6\r\ndraw_scene_npc_rewad\r\n'+uid+'\r\n15\r\n1\r\n0')
        assert chapter15.startswith('6 draw_scene_npc_rewad 0 '),chapter15
        chapter15_fields=chapter15[chapter15.rfind('171 '):].split()
        assert chapter15_fields[1]=='0' and int(chapter15_fields[2])>0,chapter15
        chapter15_tokens=chapter15.split();gold_pos=chapter15_tokens.index('25')
        assert int(chapter15_tokens[gold_pos+1])==10 and int(chapter15_tokens[gold_pos+2])>0,chapter15
        chapter15_again=server.despacha('7\r\ndraw_scene_npc_rewad\r\n'+uid+'\r\n15\r\n1\r\n0')
        repeat_tokens=chapter15_again.split();repeat_gold_pos=repeat_tokens.index('25')
        assert int(repeat_tokens[repeat_gold_pos+1])==0,chapter15_again
        (Path(folder)/'chest-test-reply.txt').write_text(reply,encoding='utf8')
        (Path(folder)/'chest-test-login.txt').write_text(server.resposta_login_init('2',''),encoding='utf8')
        path=db.caminho;db.fechar()
        from contas import Banco
        db=Banco(path)
        assert db._conn.execute('SELECT COUNT(*) FROM local_scene_rewards').fetchone()[0]>=2
        assert campaign.scene_tokens(db,account)[4].split(',')[0]=='1'
    finally:db.fechar()
print('SCENE_REWARDS_PASSED star eligibility, original silver/gold/items, consume receipt once, flags and relogin')
