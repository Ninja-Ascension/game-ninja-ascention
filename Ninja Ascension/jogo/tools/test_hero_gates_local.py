import os,sys,tempfile,json
from pathlib import Path
root=Path(__file__).resolve().parents[1];sys.path.insert(0,str(root/'port/server'));os.environ['NR_ENABLE_TUTORIAL']='0'
with tempfile.TemporaryDirectory(prefix='gates-',dir=root/'build') as folder:
    os.environ['NR_ACCOUNTS_DIR']=folder
    import local_server as server
    import hero_gates_local as gates
    import hero_development_local as dev
    import hero_stats_local as stats
    import recruitment_local as heroes
    db=server.BANCO
    try:
        account=db.criar_conta('gates_test','Temporary123!')['id'];server._sessao_conexao['token']=db.abrir_sessao(account);uid=str(db.perfil(account)['user_id'])
        server.resposta_login_init('1','');ship,mould=heroes.all_owned(db,account)[0]
        with db._conn:
            db._conn.execute('INSERT OR REPLACE INTO local_campaign VALUES (?,100,100000000)',(account,))
            db._conn.execute('INSERT OR REPLACE INTO local_hero_quality VALUES (?,?,19)',(account,ship))
            db._conn.execute('INSERT OR REPLACE INTO local_ship_rank VALUES (?,?,0,100)',(account,ship))
            develop=dev.state(db,account,ship,mould);develop['star']=7;develop['souls']=[[20,0]]*4
            db._conn.execute('INSERT OR REPLACE INTO local_hero_development VALUES (?,?,?)',(account,ship,json.dumps(develop)))
            for ident in (14,223):db._conn.execute('INSERT OR REPLACE INTO local_inventory VALUES (?,?,?,?)',(account,ident,account*1000000+ident,1000000))
        def call(cmd,page,key,mode=None):return server.despacha('\r\n'.join(['2',cmd,uid,str(ship),str(page)]+([] if mode is None else [str(mode)])+[key]))
        before=stats.effective(db,account,ship,mould)
        reply=call('mega_unblock',1,'unlock');assert reply.startswith('2 mega_unblock 0 '),reply
        assert gates.state(db,account,ship)['megaLevel']=={'1':0}
        assert stats.effective(db,account,ship,mould)['courage']>before['courage']
        assert call('mega_unblock',1,'unlock')==reply
        for i in range(10):
            result=call('mega_level_up',1,'level-'+str(i));assert result.startswith('2 mega_level_up 0 '),result
        assert gates.state(db,account,ship)['megaLevel']['1']==10
        inventory=db._conn.execute('SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=14',(account,)).fetchone()[0]
        assert ' -1 ' in call('mega_level_up',1,'past-max')
        assert db._conn.execute('SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=14',(account,)).fetchone()[0]==inventory
        assert ' -1 ' in call('mega_unblock',2,'requirements')
        assert ' -1 ' in call('mega_use_skill',2,'locked-skill',1)
        (root/'build/gates-login.txt').write_text(server.despacha('9\r\nlogin_init'),encoding='utf8')
        from reset_eight_gates import reset
        before_reset=db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?',(account,)).fetchone()[0]
        with db._lock,db._conn:
            result=reset(db._conn,account)
        assert result['ninjas']==1 and result['gates']==1
        assert gates.state(db,account,ship)==dict(megaLevel={},megaUse=[])
        assert ' -1 ' in call('mega_level_up',1,'level-0')
        assert gates.state(db,account,ship)['megaLevel']=={}
        assert call('mega_unblock',1,'after-reset').startswith('2 mega_unblock 0 ')
        assert db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?',(account,)).fetchone()[0]==before_reset
        print('HERO_GATES_TEST_PASSED unlock, ten upgrades, exact costs, retries, max level and prerequisites')
    finally:db._conn.close()
