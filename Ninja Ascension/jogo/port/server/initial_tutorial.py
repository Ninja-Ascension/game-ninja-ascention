"""Per-profile initial tutorial, shared grant catalogue and atomic skip.

The local walkthrough and skip share these entitlements. Official server-only
drop groups are not guessed. Lesson kits fund only the costs consumed by the
mandatory quality/star lessons and do not inflate the final wallet.
"""
import json
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


def skip(db, account):
    """Caller holds the DB lock and one transaction; no helpers may commit."""
    current=state(db,account)
    if current=='skipped':return False
    if current!='choice':raise ValueError('pulo_disponivel_apenas_na_escolha_inicial')
    # Freshness is server-authoritative; a level-1 old profile is not eligible.
    clears=db._conn.execute('SELECT count(*) FROM local_pve_clears WHERE conta_id=?',(account,)).fetchone()[0]
    grade=db._conn.execute('SELECT grade FROM local_campaign WHERE conta_id=?',(account,)).fetchone()
    if clears or (grade and grade[0]!=1):raise ValueError('perfil_ja_possui_progresso')
    silver=sum(int(data.tabela('npc.txt')[str(npc)][110].split('|')[0].split(',')[0]) for npc in range(1,6))
    prizes=chest_items()
    silver+=sum(n for _,kind,n in prizes if kind==1)
    gold=sum(n for _,kind,n in prizes if kind==2)
    # Mandatory lesson funding is consumed by those lessons, net zero. Ten
    # Konohamaru fragments are consumed by the original synthesis recipe.
    recipe=data.tabela('prop_mould.txt')['57']
    if int(recipe[39])!=56 or int(recipe[9])!=10:raise ValueError('receita_inicial_alterada')
    db._conn.execute('INSERT INTO local_campaign VALUES (?,6,?) ON CONFLICT(conta_id) DO UPDATE SET grade=6,silver=local_campaign.silver+excluded.silver',(account,silver))
    db._conn.execute('INSERT OR IGNORE INTO local_resources(conta_id,food,endurance) VALUES (?,60,150)',(account,))
    db._conn.execute('UPDATE local_resources SET gold=gold+? WHERE conta_id=?',(gold,account))
    for prop,kind,n in prizes:
        if kind!=6:continue
        if prop==57:n-=int(recipe[9])
        if n>0:db._conn.execute('INSERT INTO local_inventory VALUES (?,?,?,?) ON CONFLICT(conta_id,mould) DO UPDATE SET quantity=quantity+excluded.quantity',(account,prop,account*1000000+prop,n))
    db._conn.execute('INSERT INTO tutorial_recruit VALUES (?,?,50)',(account,account*100000+1))
    konohamaru=1000000000+account*100000+56
    db._conn.execute('INSERT INTO local_synthesized VALUES (?,56,?)',(account,konohamaru))
    for pos,ship in ((1,konohamaru),(2,account*100000+13),(6,account*100000+1)):
        db._conn.execute('INSERT INTO local_formation_slots VALUES (?,?,?) ON CONFLICT(conta_id,position) DO UPDATE SET ship_id=excluded.ship_id',(account,pos,ship))
    db._conn.execute('INSERT INTO tutorial_training VALUES (?,1,1) ON CONFLICT(conta_id) DO UPDATE SET kit=1,quality=1',(account,))
    import hero_development_local
    development=hero_development_local.state(db,account,account*100000+13,13)
    development['star']=2
    db._conn.execute('INSERT INTO local_hero_development VALUES (?,?,?)',(account,account*100000+13,json.dumps(development)))
    for npc in range(1,6):
        scene=1 if npc<=3 else 2
        db._conn.execute('INSERT INTO local_pve_clears VALUES (?,?,?,3)',(account,scene,npc))
    db._conn.execute('INSERT INTO local_scene_rewards VALUES (?,1,0,?)',(account,json.dumps(prizes)))
    db._conn.execute('INSERT INTO tutorial_progress VALUES (?,0) ON CONFLICT(conta_id) DO UPDATE SET experiencia=0',(account,))
    db._conn.execute('INSERT INTO local_player_exp VALUES (?,0) ON CONFLICT(conta_id) DO UPDATE SET exp=0',(account,))
    db._conn.execute('INSERT INTO tutorial_skip_choice VALUES (?,1,?) ON CONFLICT(conta_id) DO UPDATE SET skipped=1',(account,int(time.time())))
    db._conn.execute("UPDATE local_initial_tutorial SET state='skipped',star_kit=1,updated=? WHERE conta_id=?",(int(time.time()),account))
    return True


def login_tokens(db, account):
    return ['15989',state(db,account)]
