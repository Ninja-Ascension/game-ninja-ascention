"""Daily catalog, real activity progress, atomic rewards, reset and retries."""
import os,sys,tempfile,json
from pathlib import Path
root=Path(__file__).resolve().parents[1];sys.path.insert(0,str(root/'port/server'))
os.environ['NR_ENABLE_TUTORIAL']='0'
with tempfile.TemporaryDirectory(prefix='quest-',dir=root/'build') as folder:
    os.environ['NR_ACCOUNTS_DIR']=folder
    import local_server as server
    import quest_local as quest
    db=server.BANCO
    try:
        account=db.criar_conta('quest_test','Temporary123!')['id'];server._sessao_conexao['token']=db.abrir_sessao(account)
        uid=str(db.perfil(account)['user_id'])
        login=server.resposta_login_init('1','')
        with db._conn:
            db._conn.execute('UPDATE local_resources SET gold=10000 WHERE conta_id=?',(account,))
            db._conn.execute('INSERT OR REPLACE INTO local_campaign VALUES (?,100,0)',(account,))
        def request(command,*args):return server.despacha('\r\n'.join(['2',command,uid]+list(map(str,args))))
        init=request('daily_mission_init','');assert init.startswith('2 daily_mission_init 0 '),init
        expected_created=str(db.perfil(account)['criada_em']//1000)
        assert init.split()[3:5]==['1602',expected_created],init[:100]
        assert request('user_create_time').split()[3:]==['1602',expected_created]
        assert len(quest.tasks(db,account))>10
        assert ' -1 ' in request('draw_daily_mission_reward',5)
        claimed=request('draw_daily_mission_reward',1);assert claimed.startswith('2 draw_daily_mission_reward 0 '),claimed
        xp=db.experiencia_tutorial(account);assert xp==90
        assert request('draw_daily_mission_reward',1)==claimed and db.experiencia_tutorial(account)==xp
        key=request('draw_daily_mission_reward',16);assert key.startswith('2 draw_daily_mission_reward 0 '),key
        assert db._conn.execute('SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=240',(account,)).fetchone()[0]==1
        assert request('draw_daily_mission_reward',16)==key
        assert ' -1 ' in request('draw_daily_mission_reward','17,5')
        assert not db._conn.execute('SELECT 1 FROM local_quest_wallet WHERE conta_id=? AND kind=34',(account,)).fetchone(),'Partial multi-claim escaped rollback'
        assert request('draw_daily_mission_reward',17).startswith('2 draw_daily_mission_reward 0 ')
        assert db._conn.execute('SELECT amount FROM local_quest_wallet WHERE conta_id=? AND kind=34',(account,)).fetchone()[0]==1
        for nonce in ('one','two'):
            assert request('new_recruitment_system',1,nonce).startswith('2 new_recruitment_system 0 ')
        recruit_task=next(t for t in quest.tasks(db,account) if t['daily_task_id']=='8');assert recruit_task['daily_task_complete_count']=='2'
        assert request('new_recruitment_system',1,'two').startswith('2 new_recruitment_system 0 ')
        assert next(t for t in quest.tasks(db,account) if t['daily_task_id']=='8')['daily_task_complete_count']=='2'
        assert request('draw_daily_mission_reward',8).startswith('2 draw_daily_mission_reward 0 ')
        assert request('ship_bounty',3,'chest').startswith('2 ship_bounty 0 ')
        assert request('draw_daily_mission_reward',40).startswith('2 draw_daily_mission_reward 0 ')
        assert quest.points(db,account)==5
        assert ' -1 ' in request('draw_liveness_reward',0)
        with db._conn:
            # Only the fixture simulates completed activities unavailable in the local game.
            quest.add(db,account,26,1000)
            quest.add(db,account,44,10)
        assert request('draw_daily_mission_reward','11,21,41,22').startswith('2 draw_daily_mission_reward 0 ')
        assert quest.points(db,account)==25
        box=request('draw_liveness_reward',0);assert box.startswith('2 draw_liveness_reward 0 '),box
        assert request('draw_liveness_reward',0)==box
        (root/'build/quest-login.txt').write_text(server.resposta_login_init('1',''),encoding='utf8')
        (root/'build/quest-init.txt').write_text(request('daily_mission_init',''),encoding='utf8')
        (root/'build/quest-reward.txt').write_text(claimed,encoding='utf8')
        original_day=quest.shop.day
        quest.shop.day=lambda:'2099-01-02'
        reset=request('daily_mission_init','');assert reset.startswith('2 daily_mission_init 0 ')
        assert quest.points(db,account)==0 and all(t['daily_task_param']=='0' for t in quest.tasks(db,account))
        quest.shop.day=original_day
        path=db.caminho
    finally:db.fechar()
    from contas import Banco
    db=Banco(path)
    try:assert db._conn.execute('SELECT count(*) FROM local_quest_claim').fetchone()[0]>=9
    finally:db.fechar()
print('QUEST_SERVER_PASSED')
