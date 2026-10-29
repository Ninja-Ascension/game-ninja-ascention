"""Campaign protocol/state integration in a fresh DB; never player data."""
import os,sys,tempfile
from pathlib import Path
root=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(root/'port/server'))
with tempfile.TemporaryDirectory(prefix='campaign-test-',dir=root/'build') as folder:
    os.environ['NR_ACCOUNTS_DIR']=folder
    import local_server as server
    import tutorial_campaign as campaign
    db=server.BANCO
    try:
        a=db.criar_conta('campaign_test_a','Temporary123!')['id']
        b=db.criar_conta('campaign_test_b','Temporary123!')['id']
        token=db.abrir_sessao(a);server._sessao_conexao['token']=token
        uid=str(db.perfil(a)['user_id'])
        def request(cmd,*args):
            return server.despacha('\r\n'.join(['7',cmd,uid]+list(map(str,args))))
        assert ' -1 ' in request('battle_result_verify',0,1,'1-1',3,1,1)
        assert request('education_change',30208)=='7 education_change 0'
        assert request('education_change',30201)=='7 education_change 0'
        assert db._conn.execute('SELECT progress FROM tutorial_events WHERE conta_id=?',(a,)).fetchone()[0]==30208
        assert campaign.resume_record(db,a)=='nr_local_resume&%s,2,30208'%a
        assert campaign.resume_record(db,b)==''
        assert campaign.resume_record(db,a) in server.resposta_login_init('7','')
        assert ' -1 ' in request('education_change',987654321)
        assert request('battle_result_start',0,1,1,1,'1,4001,1,2')=='7 battle_result_start 0'
        result=request('battle_result_verify',0,1,'1-1',3,1,1)
        (root/'build/campaign-test-reply.txt').write_text(result,encoding='utf8')
        assert ' 40 2 ' in result and ' 6020 1,' in result,result[:160]
        assert campaign.campaign(db,a)[:2]==(2,99)
        assert request('battle_result_verify',0,1,'1-1',3,1,1).count(' 40 ')==0
        assert campaign.campaign(db,a)[:2]==(2,99),'Duplicate result granted reward twice'
        assert campaign.campaign(db,b)==(1,0,[]),'Progress leaked to other account'
        assert ' -1 ' in request('battle_result_verify',0,1,'2-2',3,1,1)
        assert request('get_copy_clear_user_info',1)=='7 get_copy_clear_user_info 0 12406 0'
        assert request('battle_result_start',0,1,2,1,'1,4002,1,2')=='7 battle_result_start 0'
        assert ' 40 ' not in request('battle_result_verify',0,1,'2-2',0,1,1)
        assert campaign.campaign(db,a)[:2]==(2,99),'Loss advanced tutorial'
        assert ' 40 3 ' in request('battle_result_verify',0,1,'2-2',3,1,1)
        assert campaign.campaign(db,a)[:2]==(3,5198),'One-time first-quality kit missing'
        login_text=server.resposta_login_init('9','')
        (root/'build/campaign-test-login.txt').write_text(login_text,encoding='utf8')
        login=login_text.split(' ')
        assert login.index('6020')<login.index('6022'),'NPC parser requires scenes to be parsed first'
        assert login[4+18]=='3','Relogin reset the campaign level'
        assert '6022' in login and '6020' in login,'Relogin omitted cleared NPCs/map'
        assert ' -1 ' in request('battle_result_verify',0,1,'2-2',3,0,1)
        path=db.caminho
    finally:
        db.fechar()
    from contas import Banco
    reopened=Banco(path)
    try:
        assert campaign.campaign(reopened,a)[:2]==(3,5198)
        assert len(campaign.campaign(reopened,a)[2])==2
    finally: reopened.fechar()
print('TUTORIAL_CAMPAIGN_PASSED victory, loss, duplicate, auth, isolation, persisted levels and map')
