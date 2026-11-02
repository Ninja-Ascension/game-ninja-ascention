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
        pain=db.criar_conta('painprofile','Temporary123!')['id']
        sessions={a:db.abrir_sessao(a) for a in (legacy,play,skip,pain)}

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
        no_recruit=db.criar_conta('norecruitprofile','Temporary123!')['id']
        sessions[no_recruit]=db.abrir_sessao(no_recruit)
        assert request(play,'get_resource','8-0,1').split(' ')[2]=='-1'
        assert request(legacy,'tutorial_skip').split(' ')[2]=='-1'
        (ROOT/'build/initial-tutorial-choice-login.txt').write_text(success(play,'login_init'),encoding='utf8')
        success(pain,'login_init')
        success(pain,'tutorial_start')
        success(pain,'education_change',2010135)
        assert initial.state(db,pain)=='completed'
        success(pain,'education_change',2010136)
        assert initial.state(db,pain)=='completed'
        assert initial.login_tokens(db,pain)==['15989','completed']
        assert campaign.campaign(db,pain)[0]==6
        assert len(campaign.campaign(db,pain)[2])==5
        success(play,'tutorial_start')
        success(play,'tutorial_start')
        # The original client records progress codes from mission1, mission2,
        # and mission3 while a new account is in the tutorial. All are valid
        # catalog markers and must not trigger the generic error response.
        for progress in (10101,20101,30101,30201):
            success(play,'education_change',progress)
        saved=dict(db._conn.execute(
            'SELECT mould,progress FROM tutorial_events WHERE conta_id=?',(play,)).fetchall())
        assert saved['1:1']==10101 and saved['2:1']==20101
        assert saved['3:1']==30101 and saved['3:2']==30201

        # Exercise the UI's new path: after the first mandatory battle, mark
        # the Recruit/Sakura segment as skipped without drawing or changing
        # formation, then prove the following campaign battle remains usable.
        success(no_recruit,'login_init')
        success(no_recruit,'tutorial_start')
        for progress in (10101,20101,30101,30201):
            success(no_recruit,'education_change',progress)
        success(no_recruit,'battle_result_start',0,1,1,1,'1,4001,1,2')
        success(no_recruit,'battle_result_verify',0,1,'1-1',3,1,1)
        for progress in (303013,303014,303015,303016,303017):
            success(no_recruit,'education_change',progress)
        assert initial.state(db,no_recruit)=='playing'
        assert not db._conn.execute('SELECT 1 FROM tutorial_recruit WHERE conta_id=?',(no_recruit,)).fetchone()
        assert not db._conn.execute('SELECT 1 FROM local_formation_slots WHERE conta_id=? AND ship_id=?',
                                    (no_recruit,no_recruit*100000+50)).fetchone()
        success(no_recruit,'battle_result_start',0,1,2,1,'1,4001,1,2')
        success(no_recruit,'battle_result_verify',0,1,'2-2',3,1,1)
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
        advanced=db.criar_conta('advancedprofile','Temporary123!')['id']
        with db._lock,db._conn:
            db._conn.execute("UPDATE local_initial_tutorial SET state='playing' WHERE conta_id=?",(advanced,))
            db._conn.execute('INSERT INTO local_campaign VALUES (?,2,2099) ON CONFLICT(conta_id) DO UPDATE SET grade=2,silver=2099',(advanced,))
            db._conn.execute('INSERT INTO local_pve_clears VALUES (?,?,?,3)',(advanced,1,1))
            db._conn.executemany('INSERT INTO tutorial_events VALUES (?,?,?)',[
                (advanced,'2:1',2010134),(advanced,'2:20',202008)])
            db._conn.execute('INSERT INTO local_formation_slots VALUES (?,?,?)',(advanced,1,advanced*100000+13))
            db._conn.execute('INSERT INTO local_formation_slots VALUES (?,?,?)',(advanced,2,advanced*100000+35))
            db._conn.execute('INSERT INTO tutorial_progress VALUES (?,17)',(advanced,))
            db._conn.execute('INSERT INTO local_player_exp VALUES (?,23)',(advanced,))
        formation_before=[tuple(x) for x in db._conn.execute(
            'SELECT position,ship_id FROM local_formation_slots WHERE conta_id=? ORDER BY position',(advanced,))]
        assert initial.reconcile_advanced_profile(db,advanced)
        assert initial.state(db,advanced)=='completed'
        assert campaign.campaign(db,advanced)[0]==6
        assert len(campaign.campaign(db,advanced)[2])==5
        assert sorted(dict(heroes.all_owned(db,advanced)).values())==[13,50,56]
        assert [tuple(x) for x in db._conn.execute(
            'SELECT position,ship_id FROM local_formation_slots WHERE conta_id=? ORDER BY position',(advanced,))]==formation_before
        assert db._conn.execute('SELECT experiencia FROM tutorial_progress WHERE conta_id=?',(advanced,)).fetchone()[0]==17
        assert db._conn.execute('SELECT exp FROM local_player_exp WHERE conta_id=?',(advanced,)).fetchone()[0]==23
        migration_backups=list((Path(db.caminho).parent/'backups_tutorial_reconcile').glob('*.sqlite3'))
        assert len(migration_backups)==1
        import sqlite3
        backup_db=sqlite3.connect(migration_backups[0])
        assert backup_db.execute('PRAGMA integrity_check').fetchone()[0]=='ok'
        assert backup_db.execute('SELECT state FROM local_initial_tutorial WHERE conta_id=?',(advanced,)).fetchone()[0]=='playing'
        backup_db.close()
        advanced_after=json.dumps(outcome(advanced),sort_keys=True)
        with db._lock,db._conn:
            assert not initial.reconcile_advanced_profile(db,advanced)
        assert json.dumps(outcome(advanced),sort_keys=True)==advanced_after
        pain_outcome=outcome(pain)
        assert pain_outcome==skipped,(pain_outcome,skipped)
        before=json.dumps(pain_outcome,sort_keys=True)
        with db._lock,db._conn:
            assert not initial.finish_after_pain_cutscene(db,pain)
        assert json.dumps(outcome(pain),sort_keys=True)==before,'Post-Pain completion was not idempotent'
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
