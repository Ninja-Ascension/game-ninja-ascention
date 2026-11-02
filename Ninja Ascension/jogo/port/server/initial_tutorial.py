"""Per-profile initial tutorial, shared grant catalogue and atomic skip.

The local walkthrough and skip share these entitlements. Official server-only
drop groups are not guessed. Lesson kits fund only the costs consumed by the
mandatory quality/star lessons and do not inflate the final wallet.
"""
import json
import os
import sqlite3
import time
import dados_batalha as data

ACTIVE = ('choice', 'playing')


def schema(db):
    db._conn.execute("CREATE TABLE IF NOT EXISTS local_initial_tutorial (conta_id INTEGER PRIMARY KEY REFERENCES contas(id), state TEXT NOT NULL CHECK(state IN ('choice','playing','completed','skipped')), star_kit INTEGER NOT NULL DEFAULT 0, updated INTEGER NOT NULL)")


def state(db, account):
    with db._lock:
        if not db._conn.execute("SELECT 1 FROM sqlite_master WHERE name='local_initial_tutorial'").fetchone():return 'legacy'
        row=db._conn.execute('SELECT state FROM local_initial_tutorial WHERE conta_id=?',(account,)).fetchone()
    return row[0] if row else 'legacy'


def managed(db, account):
    from gameplay_mode import test_override
    if test_override() is not None:return False
    return state(db,account)!='legacy'


def enroll(db, account):
    from gameplay_mode import test_override
    if test_override() is not None:return
    schema(db)
    db._conn.execute("INSERT OR IGNORE INTO local_initial_tutorial VALUES (?,'choice',0,?)",(account,int(time.time())))
    db._conn.execute('INSERT OR IGNORE INTO local_resources(conta_id,food,endurance) VALUES (?,60,150)',(account,))


def chest_items():
    """APK scene_reward_drop group 1, deterministic items; old UI omits book."""
    row=data.tabela('scene_reward.txt')['1']
    items=[[-1,k,int(v)] for k,v in enumerate(row[2:7],1) if int(v)>0]
    for entry in row[7].split('|'):
        n,prop,prob=entry.split(',')
        if prob!='1/1':raise ValueError('premio_inicial_nao_deterministico')
        items.append([int(prop),6,int(n)])
    # The original delivery library (scene_reward_drop, library_group=1)
    # explicitly includes one Recruit Book, unlike the old preview table.
    items.append([239,6,1])
    return items


def star_cost():
    ship=data.tabela('ship_mould.txt')['13']
    row=next(r for r in data.tabela('awaken_requirement.txt').values() if r[1]==ship[60] and int(r[2])==int(ship[48]))
    if any(int(x)>0 for x in row[4:8]):raise ValueError('custo_de_estrela_inicial_incompativel')
    costs={}
    if int(row[8])>0 and int(row[9])>0:costs[int(row[8])]=int(row[9])
    if int(row[10])>0:
        prop=next(r for r in data.tabela('prop_mould.txt').values() if r[39]=='13' and r[42]=='1')
        costs[int(prop[0])]=costs.get(int(prop[0]),0)+int(row[10])
    return int(row[11]),costs


def prepare_star(db, account):
    if not managed(db,account) or state(db,account)!='playing':return
    grade=db._conn.execute('SELECT grade FROM local_campaign WHERE conta_id=?',(account,)).fetchone()
    if not grade or grade[0]<6:return
    row=db._conn.execute('SELECT star_kit FROM local_initial_tutorial WHERE conta_id=?',(account,)).fetchone()
    if row[0]:return
    silver,costs=star_cost()
    db._conn.execute('UPDATE local_campaign SET silver=silver+? WHERE conta_id=?',(silver,account))
    for prop,n in costs.items():
        db._conn.execute('INSERT INTO local_inventory VALUES (?,?,?,?) ON CONFLICT(conta_id,mould) DO UPDATE SET quantity=quantity+excluded.quantity',(account,prop,account*1000000+prop,n))
    db._conn.execute('UPDATE local_initial_tutorial SET star_kit=1 WHERE conta_id=?',(account,))


def finish(db, account):
    if state(db,account)!='playing':return False
    ship=account*100000+13
    development=db._conn.execute('SELECT state FROM local_hero_development WHERE conta_id=? AND ship_id=?',(account,ship)).fetchone()
    training=db._conn.execute('SELECT quality FROM tutorial_training WHERE conta_id=?',(account,)).fetchone()
    clears=db._conn.execute('SELECT count(*) FROM local_pve_clears WHERE conta_id=? AND ((scene=1 AND npc IN (1,2,3)) OR (scene=2 AND npc IN (4,5))) AND stars>0',(account,)).fetchone()[0]
    sakura=db._conn.execute('SELECT 1 FROM tutorial_recruit WHERE conta_id=? AND mould=50',(account,)).fetchone()
    konohamaru=db._conn.execute('SELECT 1 FROM local_synthesized WHERE conta_id=? AND mould=56',(account,)).fetchone()
    chest=db._conn.execute('SELECT 1 FROM local_scene_rewards WHERE conta_id=? AND scene=1 AND chest=0',(account,)).fetchone()
    if not (development and json.loads(development[0])['star']>=2 and training and training[0]>=1 and clears==5 and sakura and konohamaru and chest):return False
    db._conn.execute("UPDATE local_initial_tutorial SET state='completed',updated=? WHERE conta_id=?",(int(time.time()),account))
    return True


def finish_after_pain_cutscene(db, account, progress=2010135):
    """Finish when the recovered post-Pain scene starts; accept terminal as fallback."""
    if state(db,account)!='playing':return False
    from tutorial_campaign import MISSIONS
    battle_end=MISSIONS.get(2010134)
    cutscene=MISSIONS.get(2010135)
    final=MISSIONS.get(2010136)
    if not battle_end or battle_end[0]!=2 or battle_end[1][3]!='1196v1' or battle_end[1][12]!='28执行脚本':
        raise ValueError('marcador_fim_batalha_pain_invalido')
    if not cutscene or cutscene[0]!=2 or cutscene[1][3]!='1196v1' or cutscene[1][12]!='5在当前场景背景上面绘制光效' or cutscene[1][14]!='sprite/juqing_cg3':
        raise ValueError('marcador_cg_final_pain_invalido')
    if not final or final[0]!=2 or final[1][3]!='1196v1' or final[1][12]!='28执行脚本':
        raise ValueError('marcador_final_pain_invalido')
    if progress not in (2010135,2010136):return False
    saved=db._conn.execute('SELECT progress FROM tutorial_events WHERE conta_id=? AND mould=?',(account,'2:1')).fetchone()
    if not saved or int(saved[0])!=progress:return False
    previous,terminal=(battle_end,cutscene) if progress==2010135 else (cutscene,final)
    # Each marker is verified against adjacent entries in the original catalog.
    if terminal[2] != previous[2] + 1:return False
    grant_outcome(db,account,'completed')
    return True


def reconcile_advanced_profile(db, account):
    """Repair a profile that already exited the Pain scene into Advance.

    Some clients saved only 2010134 (Pain battle end), then continued the old
    tutorial through the normal Advance checkpoint 202008. On login, that is
    authoritative evidence that the post-Pain cutoff was passed. Back up via
    SQLite's online backup API before applying the same outcome as skip.
    """
    if state(db,account)!='playing':return False
    with db._lock:
        saved=dict(db._conn.execute(
            'SELECT mould,progress FROM tutorial_events WHERE conta_id=? AND mould IN (?,?)',
            (account,'2:1','2:20')).fetchall())
        campaign=db._conn.execute(
            'SELECT grade FROM local_campaign WHERE conta_id=?',(account,)).fetchone()
        clear=db._conn.execute(
            'SELECT stars FROM local_pve_clears WHERE conta_id=? AND scene=1 AND npc=1',
            (account,)).fetchone()
        if not (int(saved.get('2:1',0))==2010134 and
                int(saved.get('2:20',0))>=202008 and
                campaign and int(campaign[0])>=2 and
                clear and int(clear[0])>0):
            return False
        # This profile has already entered ordinary campaign play. Preserve
        # its current team and any post-tutorial character/player experience;
        # the cutoff only supplies missing tutorial entitlements/progression.
        formation=db._conn.execute(
            'SELECT position,ship_id FROM local_formation_slots WHERE conta_id=? ORDER BY position',
            (account,)).fetchall()
        hero_progress=db._conn.execute(
            'SELECT state FROM local_hero_development WHERE conta_id=? AND ship_id=?',
            (account,account*100000+13)).fetchone()
        tutorial_exp=db._conn.execute(
            'SELECT experiencia FROM tutorial_progress WHERE conta_id=?',(account,)).fetchone()
        player_exp=db._conn.execute(
            'SELECT exp FROM local_player_exp WHERE conta_id=?',(account,)).fetchone()

        backup_dir=os.path.join(os.path.dirname(os.path.abspath(db.caminho)),
                                 'backups_tutorial_reconcile')
        os.makedirs(backup_dir,exist_ok=True)
        backup_path=os.path.join(backup_dir,
            'contas-%s-account-%s.sqlite3' % (time.strftime('%Y%m%d-%H%M%S'),account))
        target=sqlite3.connect(backup_path)
        try:
            db._conn.backup(target)
            check=target.execute('PRAGMA integrity_check').fetchone()[0]
            if check!='ok':
                raise RuntimeError('backup_tutorial_invalido: '+str(check))
        finally:
            target.close()
        with db._conn:
            grant_outcome(db,account,'completed')
            if formation:
                db._conn.execute('DELETE FROM local_formation_slots WHERE conta_id=?',(account,))
                db._conn.executemany(
                    'INSERT INTO local_formation_slots VALUES (?,?,?)',
                    [(account,int(position),int(ship_id)) for position,ship_id in formation])
            if hero_progress:
                db._conn.execute('UPDATE local_hero_development SET state=? WHERE conta_id=? AND ship_id=?',
                                 (hero_progress[0],account,account*100000+13))
            if tutorial_exp:
                db._conn.execute('UPDATE tutorial_progress SET experiencia=? WHERE conta_id=?',
                                 (tutorial_exp[0],account))
            if player_exp:
                db._conn.execute('UPDATE local_player_exp SET exp=? WHERE conta_id=?',
                                 (player_exp[0],account))
        return True


def grant_outcome(db, account, final_state):
    """Apply the same accessible-game starting outcome to tutorial completion.

    The caller holds the database lock and transaction. Existing battle clears
    and the initial chest receipt are checked first, so the post-Pain callback
    can safely be retried without double-paying rewards.
    """
    if final_state not in ('completed','skipped'):raise ValueError('estado_final_invalido')
    prizes=chest_items()
    silver_delta=0
    clear_rows={int(npc):int(stars) for npc,stars in db._conn.execute(
        'SELECT npc,stars FROM local_pve_clears WHERE conta_id=? AND scene IN (1,2)',(account,)).fetchall()
        if 1<=int(npc)<=5}
    for npc in range(1,6):
        if npc not in clear_rows:
            silver_delta+=int(data.tabela('npc.txt')[str(npc)][110].split('|')[0].split(',')[0])
        scene=1 if npc<=3 else 2
        db._conn.execute('INSERT INTO local_pve_clears VALUES (?,?,?,3) ON CONFLICT(conta_id,scene,npc) DO UPDATE SET stars=MAX(stars,excluded.stars)',(account,scene,npc))
    chest=db._conn.execute('SELECT 1 FROM local_scene_rewards WHERE conta_id=? AND scene=1 AND chest=0',(account,)).fetchone()
    gold=0
    if not chest:
        silver_delta+=sum(n for _,kind,n in prizes if kind==1)
        gold=sum(n for _,kind,n in prizes if kind==2)
    # Mandatory lesson funding is consumed by those lessons, net zero. Ten
    # Konohamaru fragments are consumed by the original synthesis recipe.
    recipe=data.tabela('prop_mould.txt')['57']
    if int(recipe[39])!=56 or int(recipe[9])!=10:raise ValueError('receita_inicial_alterada')
    current_grade=db._conn.execute('SELECT grade FROM local_campaign WHERE conta_id=?',(account,)).fetchone()
    grade=max(6,int(current_grade[0]) if current_grade else 1)
    db._conn.execute('INSERT INTO local_campaign VALUES (?,?,?) ON CONFLICT(conta_id) DO UPDATE SET grade=MAX(local_campaign.grade,excluded.grade),silver=local_campaign.silver+excluded.silver',(account,grade,silver_delta))
    db._conn.execute('INSERT OR IGNORE INTO local_resources(conta_id,food,endurance) VALUES (?,60,150)',(account,))
    if gold:db._conn.execute('UPDATE local_resources SET gold=gold+? WHERE conta_id=?',(gold,account))
    if not chest:
        for prop,kind,n in prizes:
            if kind!=6:continue
            if prop==57:n-=int(recipe[9])
            if n>0:db._conn.execute('INSERT INTO local_inventory VALUES (?,?,?,?) ON CONFLICT(conta_id,mould) DO UPDATE SET quantity=quantity+excluded.quantity',(account,prop,account*1000000+prop,n))
    db._conn.execute('INSERT OR IGNORE INTO tutorial_recruit VALUES (?,?,50)',(account,account*100000+1))
    konohamaru=1000000000+account*100000+56
    db._conn.execute('INSERT OR IGNORE INTO local_synthesized VALUES (?,56,?)',(account,konohamaru))
    for pos,ship in ((1,konohamaru),(2,account*100000+13),(6,account*100000+1)):
        db._conn.execute('INSERT INTO local_formation_slots VALUES (?,?,?) ON CONFLICT(conta_id,position) DO UPDATE SET ship_id=excluded.ship_id',(account,pos,ship))
    db._conn.execute('INSERT INTO tutorial_training VALUES (?,1,1) ON CONFLICT(conta_id) DO UPDATE SET kit=MAX(tutorial_training.kit,1),quality=MAX(tutorial_training.quality,1)',(account,))
    import hero_development_local
    development=hero_development_local.state(db,account,account*100000+13,13)
    development['star']=2
    db._conn.execute('INSERT INTO local_hero_development VALUES (?,?,?)',(account,account*100000+13,json.dumps(development)))
    db._conn.execute('INSERT OR IGNORE INTO local_scene_rewards VALUES (?,1,0,?)',(account,json.dumps(prizes)))
    db._conn.execute('INSERT INTO tutorial_progress VALUES (?,0) ON CONFLICT(conta_id) DO UPDATE SET experiencia=0',(account,))
    db._conn.execute('INSERT INTO local_player_exp VALUES (?,0) ON CONFLICT(conta_id) DO UPDATE SET exp=0',(account,))
    if final_state=='skipped':
        db._conn.execute('INSERT INTO tutorial_skip_choice VALUES (?,1,?) ON CONFLICT(conta_id) DO UPDATE SET skipped=1',(account,int(time.time())))
    db._conn.execute("UPDATE local_initial_tutorial SET state=?,star_kit=1,updated=? WHERE conta_id=?",(final_state,int(time.time()),account))


def skip(db, account):
    """Caller holds the DB lock and one transaction; no helpers may commit."""
    current=state(db,account)
    if current=='skipped':return False
    if current!='choice':raise ValueError('pulo_disponivel_apenas_na_escolha_inicial')
    # Freshness is server-authoritative; a level-1 old profile is not eligible.
    clears=db._conn.execute('SELECT count(*) FROM local_pve_clears WHERE conta_id=?',(account,)).fetchone()[0]
    grade=db._conn.execute('SELECT grade FROM local_campaign WHERE conta_id=?',(account,)).fetchone()
    if clears or (grade and grade[0]!=1):raise ValueError('perfil_ja_possui_progresso')
    grant_outcome(db,account,'skipped')
    return True


def login_tokens(db, account):
    return ['15989',state(db,account)]
