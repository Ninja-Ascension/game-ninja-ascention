import os,sys,tempfile,json
from pathlib import Path
root=Path(__file__).resolve().parents[1];sys.path.insert(0,str(root/'port/server'));os.environ['NR_ENABLE_TUTORIAL']='0'
with tempfile.TemporaryDirectory(prefix='development-',dir=root/'build') as folder:
    os.environ['NR_ACCOUNTS_DIR']=folder
    import local_server as server
    import hero_development_local as dev
    import recruitment_local as heroes
    db=server.BANCO
    try:
        account=db.criar_conta('development_test','Temporary123!')['id'];server._sessao_conexao['token']=db.abrir_sessao(account);uid=str(db.perfil(account)['user_id'])
        server.resposta_login_init('1','')
        ship,mould=heroes.all_owned(db,account)[0]
        with db._conn:
            db._conn.execute('INSERT OR REPLACE INTO local_campaign VALUES (?,100,100000000)',(account,))
            db._conn.execute('INSERT OR REPLACE INTO local_ship_rank VALUES (?,?,0,100)',(account,ship))
            db._conn.execute('INSERT OR REPLACE INTO local_hero_quality VALUES (?,?,20)',(account,ship))
            for ident in dev.data.tabela('prop_mould.txt'):db._conn.execute('INSERT OR REPLACE INTO local_inventory VALUES (?,?,?,?)',(account,int(ident),account*1000000+int(ident),1000000))
        def call(cmd,args,key):return server.MINIMOS[cmd]('2','\r\n'.join(['2',cmd,uid,str(ship)]+args+[key]))
        promote=call('ship_awaken',[],'promote');assert promote.startswith('2 ship_awaken 0 '),promote
        assert dev.state(db,account,ship,mould)['star']==2
        assert call('ship_awaken',[],'promote')==promote
        r=dev.data.tabela('ship_mould.txt')[str(mould)];evo=dev.data.tabela('ship_evo_mould.txt')[r[71].split(',')[0]]
        talent=evo[7].split('|')[0].split(',')[2]
        skill=call('ship_skill_level_up',['1',talent],'skill');assert skill.startswith('2 ship_skill_level_up 0 '),skill
        assert dev.state(db,account,ship,mould)['skills'][0]==2
        auto=call('ship_skill_level_up_one_key',['1:3',talent],'auto');assert auto.startswith('2 ship_skill_level_up_one_key 0 '),auto
        assert dev.state(db,account,ship,mould)['skills'][0]==5
        prop=dev.data.tabela('prop_mould.txt')['243']
        soul=call('ship_soul_level_up',['0','0',str(account*1000000+int(prop[0]))+',1000'],'soul');assert soul.startswith('2 ship_soul_level_up 0 '),soul
        assert dev.state(db,account,ship,mould)['souls'][0][0]>1
        assert call('ship_soul_level_up',['0','0',str(account*1000000+int(prop[0]))+',1000'],'soul')==soul
        before=dev.state(db,account,ship,mould)
        assert ' -1 ' in call('ship_soul_level_up',['0','1',str(account*1000000+68)+',1'],'invalid-soul-material')
        assert dev.state(db,account,ship,mould)==before
        assert ' -1 ' in call('ship_skill_level_up',['1','999999'],'bad-talent')
        assert dev.state(db,account,ship,mould)==before
        (root/'build/hero-development-login.txt').write_text(server.resposta_login_init('9',''),encoding='utf8')
        (root/'build/hero-development-reply.txt').write_text(soul,encoding='utf8')
        print('HERO_DEVELOPMENT_TEST_PASSED: Promote, skill single/auto, cursed seal, retry and persisted state')
    finally:db._conn.close()
