"""Full initial protocol walkthrough vs atomic skip in a temporary database."""
import json
import os
from pathlib import Path
import sys
import tempfile

ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'port/server'))
os.environ.pop('NR_ENABLE_TUTORIAL',None)
with tempfile.TemporaryDirectory(prefix='initial-tutorial-',dir=ROOT/'build') as folder:
    os.environ['NR_ACCOUNTS_DIR']=folder
    import local_server as server
    import initial_tutorial as initial
    import hero_training_local as training
    import recruitment_local as heroes
    import tutorial_campaign as campaign
    db=server.BANCO
    try:
        os.environ['NR_ENABLE_TUTORIAL']='0'
        legacy=db.criar_conta('oldprofile','Temporary123!')['id']
        os.environ.pop('NR_ENABLE_TUTORIAL')
        play=db.criar_conta('playprofile','Temporary123!')['id']
        skip=db.criar_conta('skipprofile','Temporary123!')['id']
        sessions={a:db.abrir_sessao(a) for a in (legacy,play,skip)}

        def request(a,cmd,*args):
            server._sessao_conexao['token']=sessions[a]
            return server.despacha('\r\n'.join(['17',cmd,str(db.perfil(a)['user_id'])]+list(map(str,args))))

        def success(a,cmd,*args):
            response=request(a,cmd,*args)
            assert response.split(' ')[2]=='0',(cmd,response)
            return response

        def wallet(a):
            return tuple(db._conn.execute('SELECT gold,food,endurance,honour,soul,jade FROM local_resources WHERE conta_id=?',(a,)).fetchone())

        assert initial.state(db,legacy)=='legacy'
        assert initial.state(db,play)=='choice'
        assert request(play,'get_resource','8-0,1').split(' ')[2]=='-1'
        assert request(legacy,'tutorial_skip').split(' ')[2]=='-1'
        (ROOT/'build/initial-tutorial-choice-login.txt').write_text(success(play,'login_init'),encoding='utf8')
        success(play,'tutorial_start')
        success(play,'tutorial_start')
        assert request(play,'tutorial_skip').split(' ')[2]=='-1'
        success(play,'get_resource','8-0,1')
        success(play,'get_resource','8-0,1')
        for npc in range(1,6):
            scene=1 if npc<=3 else 2
            success(play,'battle_result_start',0,scene,npc,1,'1,4001,1,2')
            success(play,'battle_result_verify',0,scene,f'{npc}-{npc}',3,1,1)
            if npc==1:
                success(play,'new_recruitment_system',1)
                success(play,'formation_change',play*100000+1,6,1)
            if npc==2:
                r=training.requirement()
                materials=','.join(str(play*1000000+int(r[i])) for i in (2,4,6,8))
                success(play,'ship_grow_up',play*100000+13,'',materials,'',1)
            if npc==3:
                success(play,'draw_scene_rewad',1,0)
                success(play,'draw_scene_rewad',1,0)
                success(play,'prop_compound',play*1000000+57,1,1)
                success(play,'formation_change',1000000000+play*100000+56,1,1)
        success(play,'ship_awaken',play*100000+13,'initial-star-test')
        success(play,'education_change',307013)
        assert initial.state(db,play)=='completed'
        assert request(play,'tutorial_skip').split(' ')[2]=='-1'
        success(skip,'login_init')
        success(skip,'tutorial_skip')
        assert request(skip,'get_resource','8-0,1').split(' ')[2]=='-1'
        (ROOT/'build/initial-tutorial-skipped-login.txt').write_text(success(skip,'login_init'),encoding='utf8')

        def outcome(a):
            inventory=db._conn.execute('SELECT mould,quantity FROM local_inventory WHERE conta_id=? AND quantity>0 ORDER BY mould',(a,)).fetchall()
            owned=dict(heroes.all_owned(db,a))
            formation=[owned.get(int(x),0) for x in heroes._slots_locked(db,a)]
            development=db._conn.execute('SELECT state FROM local_hero_development WHERE conta_id=? AND ship_id=?',(a,a*100000+13)).fetchone()[0]
            grade,silver,clears=campaign.campaign(db,a)
            return {'campaign':(grade,silver,[tuple(x) for x in clears]),'wallet':wallet(a),'inventory':[tuple(x) for x in inventory],
                    'heroes':sorted(owned.values()),'formation':formation,'naruto':json.loads(development),
                    'quality':db._conn.execute('SELECT quality FROM tutorial_training WHERE conta_id=?',(a,)).fetchone()[0]}

        natural=outcome(play)
        skipped=outcome(skip)
        assert natural==skipped,(natural,skipped)
        before=json.dumps(skipped,sort_keys=True)
        success(skip,'tutorial_skip')
        assert json.dumps(outcome(skip),sort_keys=True)==before
        import sqlite3
        second=sqlite3.connect(db.caminho)
        assert second.execute('SELECT state FROM local_initial_tutorial WHERE conta_id=?',(skip,)).fetchone()[0]=='skipped'
        second.close()
        assert sorted(dict(heroes.all_owned(db,legacy)).values())==[13,35,50]
        assert skipped['heroes']==[13,50,56]
        assert skipped['campaign'][:2]==(6,6495)
        assert skipped['inventory']==[(68,5),(239,1)]
        # A failed transaction cannot mark skipped or deliver a partial grant.
        failed=db.criar_conta('rollbackprofile','Temporary123!')['id']
        sessions[failed]=db.abrir_sessao(failed)
        with db._lock,db._conn:
            db._conn.execute("CREATE TRIGGER fail_tutorial_skip BEFORE INSERT ON local_synthesized WHEN NEW.conta_id=%d BEGIN SELECT RAISE(ABORT,'injected failure'); END"%failed)
        import sqlite3
        try:
            with db._lock,db._conn:initial.skip(db,failed)
            raise AssertionError('failure injection did not run')
        except sqlite3.IntegrityError:pass
        assert initial.state(db,failed)=='choice'
        assert not db._conn.execute('SELECT 1 FROM local_campaign WHERE conta_id=?',(failed,)).fetchone()
        assert not db._conn.execute('SELECT 1 FROM local_inventory WHERE conta_id=?',(failed,)).fetchone()
        assert wallet(failed)==(0,60,150,0,0,0)
        assert db._conn.execute('PRAGMA integrity_check').fetchone()[0]=='ok'
        assert not db._conn.execute('PRAGMA foreign_key_check').fetchall()
        (ROOT/'build/initial-tutorial-outcome.json').write_text(json.dumps(skipped,ensure_ascii=False,indent=2),encoding='utf8')
        print('INITIAL_TUTORIAL_PASSED full protocol walkthrough equals skip; repeat, legacy isolation, rollback, integrity')
    finally:db.fechar()
