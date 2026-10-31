"""First quality lesson: original costs with a one-time local tutorial kit."""
import dados_batalha as data

def requirement():
    row=data.tabela('ship_mould.txt')['13']
    group=[r for r in data.tabela('ship_grow_requirement.txt').values() if r[30]==row[47]]
    return sorted(group,key=lambda r:int(r[0]))[0]

def prepare(db,account):
    """Local port policy: fund exactly the first lesson once, from level 3."""
    from gameplay_mode import tutorial_enabled
    if not tutorial_enabled(db,account):
        # Retain the existing upgrade-state schema, without granting the
        # educational starter kit or invoking any tutorial mission.
        with db._lock,db._conn:
            db._conn.execute('INSERT OR IGNORE INTO tutorial_training VALUES (?,1,0)',(account,))
        return
    with db._lock,db._conn:
        __import__('initial_tutorial').prepare_star(db,account)
    r=requirement()
    with db._lock:
        grade=db._conn.execute('SELECT grade FROM local_campaign WHERE conta_id=?',(account,)).fetchone()
        if not grade or grade[0]<3:return
        with db._conn:
            db._conn.execute('INSERT OR IGNORE INTO tutorial_training(conta_id) VALUES (?)',(account,))
            state=db._conn.execute('SELECT kit FROM tutorial_training WHERE conta_id=?',(account,)).fetchone()
            if state[0]:return
            db._conn.execute('UPDATE local_campaign SET silver=silver+? WHERE conta_id=?',(int(r[1]),account))
            for index in (2,4,6,8):
                mould,quantity=int(r[index]),int(r[index+1])
                db._conn.execute('INSERT INTO local_inventory VALUES (?,?,?,?) ON CONFLICT(conta_id,mould) DO UPDATE SET quantity=quantity+excluded.quantity',
                                 (account,mould,account*1000000+mould,quantity))
            db._conn.execute('UPDATE tutorial_training SET kit=1 WHERE conta_id=?',(account,))

def inventory_tokens(db,account):
    with db._lock:
        rows=db._conn.execute('SELECT instance_id,mould,quantity FROM local_inventory WHERE conta_id=? AND quantity>0 ORDER BY mould',(account,)).fetchall()
    result=['6024',str(len(rows))]
    for row in rows:result+=list(map(str,row))
    return result

def install(server):
    db=server.BANCO
    import fight_spirit_local
    fight_spirit_local.install(server)
    import recruit_shop_local
    recruit_shop_local.install(server)
    import ninja_school_local
    ninja_school_local.install(server)
    import index_local
    index_local.install(server)
    import artifact_local
    artifact_local.install(server)
    import constellation_local
    constellation_local.install(server)
    import saga_local
    saga_local.install(server)
    import mythical_local
    mythical_local.install(server)
    import achievements_local
    achievements_local.install(server)
    import clan_local
    clan_local.install(server)
    import clan_science_local
    clan_science_local.install(server)
    import ranking_local
    ranking_local.install(server)
    import soul_guard_local
    soul_guard_local.install(server)
    import arena_local
    arena_local.install(server)
    import fury_tower_local
    fury_tower_local.install(server)
    import signin_local
    signin_local.install(server)
    import prop_use_local
    prop_use_local.install(server)
    import potential_local
    potential_local.install(server)
    import hero_quality_local
    import hero_gates_local
    hero_gates_local.install(server)
    import hero_stats_local
    hero_stats_local.install(server)
    import hero_level_local
    import equipment_local
    equipment_local.install(server)
    import treasure_local
    treasure_local.install(server)
    import equipment_development_local
    equipment_development_local.install(server)
    import hero_development_local
    with db._lock,db._conn:hero_development_local.schema(db)
    for command in hero_development_local.COMMANDS:
        server.MINIMOS[command]=lambda seq,text,cmd=command:hero_development_local.execute(server,cmd,seq,text)
    with db._lock,db._conn:hero_level_local.schema(db)
    server.MINIMOS["ship_escalate"]=lambda seq,text:hero_level_local.upgrade(server,seq,text)
    with db._lock,db._conn:hero_quality_local.schema(db)
    def upgrade(seq,text):
        from gameplay_mode import tutorial_enabled
        if not tutorial_enabled():return hero_quality_local.upgrade(server,seq,text)
        try:
            session=db.sessao_de(server._sessao_da_conexao());account=session['conta_id']
            lines=server._linhas(text)
            if len(lines)!=6 or lines[0]!=str(db.perfil(account)['user_id']) or lines[1]!=str(account*100000+13) or lines[5]!='1':
                raise ValueError('melhoria_inicial_invalida')
            prepare(db,account)
            r=requirement();provided=sorted(x for x in lines[3].split(',') if x)
            expected=sorted(str(account*1000000+int(r[i])) for i in (2,4,6,8))
            if provided!=expected:raise ValueError('materiais_incorretos')
            with db._lock:
                with db._conn:
                    state=db._conn.execute('SELECT quality,kit FROM tutorial_training WHERE conta_id=?',(account,)).fetchone()
                    if not state or not state[1]:raise ValueError('licao_ainda_bloqueada')
                    if state[0]==0:
                        silver=db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?',(account,)).fetchone()[0]
                        if silver<int(r[1]):raise ValueError('prata_insuficiente')
                        for index in (2,4,6,8):
                            item=db._conn.execute('SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=?',(account,int(r[index]))).fetchone()
                            if not item or item[0]<int(r[index+1]):raise ValueError('materiais_insuficientes')
                        db._conn.execute('UPDATE local_campaign SET silver=silver-? WHERE conta_id=?',(int(r[1]),account))
                        for index in (2,4,6,8):
                            db._conn.execute('UPDATE local_inventory SET quantity=quantity-? WHERE conta_id=? AND mould=?',(int(r[index+1]),account,int(r[index])))
                        db._conn.execute('UPDATE tutorial_training SET quality=1 WHERE conta_id=?',(account,))
                    silver=db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?',(account,)).fetchone()[0]
            import recruitment_local
            character=recruitment_local.ship_tokens(db,account,only_mould=13)
            metadata=character[character.index('14104'):]
            server.log('TUTORIAL_QUALITY saved conta_id=%s quality=1' % account)
            return ' '.join([str(seq),'ship_grow_up','0','22',str(silver)]+inventory_tokens(db,account)+metadata)
        except (server._contas.ErroConta,ValueError) as exc:
            return server.recusa('ship_grow_up',seq,str(exc))
    server.MINIMOS['ship_grow_up']=upgrade
