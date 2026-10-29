"""Normal mission completion/relogin in a private DB, tutorial disabled."""
import os,sys,tempfile
from pathlib import Path
root=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(root/'port/server'))
os.environ['NR_ENABLE_TUTORIAL']='0'
with tempfile.TemporaryDirectory(prefix='normal-campaign-',dir=root/'build') as folder:
    os.environ['NR_ACCOUNTS_DIR']=folder
    import local_server as server
    import recruitment_local as heroes
    import tutorial_campaign as campaign
    db=server.BANCO
    try:
        account=db.criar_conta('normal_campaign','Temporary123!')['id']
        server._sessao_conexao['token']=db.abrir_sessao(account)
        uid=str(db.perfil(account)['user_id'])
        def request(command,*args):
            return server.despacha('\r\n'.join(['7',command,uid]+list(map(str,args))))
        before=heroes.formation_tokens(db,account)
        assert request('battle_result_start',0,1,1,1,'1,4001,1,2')=='7 battle_result_start 0'
        result=request('battle_result_verify',0,1,'1-1',3,1,1)
        assert result.startswith('7 battle_result_verify 0 '),result
        first=db._conn.execute('SELECT grade,silver FROM local_campaign WHERE conta_id=?',(account,)).fetchone()[:]
        assert db._conn.execute('SELECT stars FROM local_pve_clears WHERE conta_id=? AND scene=1 AND npc=1',(account,)).fetchone()[0]==3
        request('battle_result_verify',0,1,'1-1',3,1,1)
        assert db._conn.execute('SELECT grade,silver FROM local_campaign WHERE conta_id=?',(account,)).fetchone()[:]==first,'Repeated result duplicated rewards'
        server.resposta_login_init('8','')
        assert heroes.formation_tokens(db,account)==before
        assert campaign.resume_record(db,account)==''
        path=db.caminho
    finally:db.fechar()
    from contas import Banco
    db=Banco(path)
    try:
        assert db._conn.execute('SELECT grade,silver FROM local_campaign WHERE conta_id=?',(account,)).fetchone()[:]==first
        assert db._conn.execute('SELECT stars FROM local_pve_clears WHERE conta_id=?',(account,)).fetchone()[0]==3
        assert heroes.formation_tokens(db,account)==before
    finally:db.fechar()
print('NORMAL_CAMPAIGN_PERSISTENCE_PASSED mission, no duplicate rewards, login, database reopen')
