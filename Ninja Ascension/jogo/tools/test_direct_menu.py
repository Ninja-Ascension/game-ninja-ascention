import os,sys,tempfile
from pathlib import Path
root=Path(__file__).resolve().parents[1];sys.path.insert(0,str(root/'port/server'))
os.environ['NR_ENABLE_TUTORIAL']='0'
with tempfile.TemporaryDirectory(prefix='direct-menu-',dir=root/'build') as folder:
    os.environ['NR_ACCOUNTS_DIR']=folder
    import local_server as server
    import recruitment_local as heroes
    import tutorial_campaign as campaign
    db=server.BANCO
    try:
        account=db.criar_conta('direct_menu_test','Temporary123!')['id']
        server._sessao_conexao['token']=db.abrir_sessao(account)
        uid=str(db.perfil(account)['user_id'])
        login=server.resposta_login_init('1','')
        assert {m for _,m in heroes.all_owned(db,account)}=={13,35,50}
        assert len({ship for ship,_ in heroes.all_owned(db,account)})==3
        slots=heroes.formation_tokens(db,account)[2:8]
        assert sum(ship!='0' for ship in slots)==3
        assert campaign.resume_record(db,account)==''
        assert db._conn.execute('SELECT food,endurance FROM local_resources').fetchone()[:]==(60,150)
        (root/'build/direct-menu-login.txt').write_text(login,encoding='utf8')
        # Scene/daily-state initialization intentionally precedes profile 3;
        # the native login test checks the complete parser stream.
        assert login.split(' ')[3]=='6020'
        sakura=str(account*100000+1)
        reply=server.despacha('2\r\nformation_change\r\n'+uid+'\r\n'+sakura+'\r\n6\r\n-1\r\n0')
        assert reply.startswith('2 formation_change 0 ')
        assert heroes.formation_tokens(db,account)[7]=='0'
        server.resposta_login_init('3','')
        assert heroes.formation_tokens(db,account)[7]=='0','Login reset the player formation'
        assert len(heroes.all_owned(db,account))==3
        assert db._conn.execute('PRAGMA foreign_key_check').fetchall()==[]
    finally:db.fechar()
print('DIRECT_MENU_SERVER_PASSED three fixed heroes, unique IDs, energy, no tutorial checkpoint, formation preserved')
