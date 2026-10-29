"""Ninja potential ("Superar+", ship_potential_up ship_id, slot 1-3).

SmRoleStrengthenTabRisingStar.lua: ship.qianNeng = "lv1,lv2,lv3" (14104).
ship_config 33: "minLv-maxLv,fragments,Ryo|..." cost of each level;
ship_config 34: star needed (7). Fragments = prop_mould whose use_of_ship
(column 40, 0-based 39) is the ninja's mould.
potential_attribute (slot): column 4 "kind,value|..." - reconstruction: added
once per level above 1 (the client only shows the values).
"""
COMMANDS = ('ship_potential_up',)
MAX_LEVEL = 210


def schema(db):
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_potential (conta_id INTEGER NOT NULL REFERENCES contas(id) ON DELETE CASCADE, ship INTEGER NOT NULL, levels TEXT NOT NULL, PRIMARY KEY(conta_id, ship))')


def cfg(n):
    import mudra_local
    return mudra_local.cfg(n)


def levels(db, account, ship):
    r = db._conn.execute('SELECT levels FROM local_potential WHERE conta_id=? AND ship=?', (account, ship)).fetchone()
    return [int(x) for x in r[0].split(',')] if r else [1, 1, 1]


def text(db, account, ship):
    with db._lock:
        return ','.join(map(str, levels(db, account, ship)))


def cost(level):
    for part in cfg(33).split('|'):
        span, frags, silver = part.split(',')
        lo, hi = (int(x) for x in span.split('-'))
        if lo <= level <= hi:
            return int(frags), int(silver)
    return None


def fragment(mould):
    import dados_batalha as data
    return next((int(r[0]) for r in data.tabela('prop_mould.txt').values() if len(r) > 39 and r[39] == str(mould)), None)


def bonus(db, account, ship):
    import dados_batalha as data
    out = []
    with db._lock:
        lv = levels(db, account, ship)
    for slot, level in enumerate(lv, 1):
        row = data.tabela('potential_attribute.txt').get(str(slot))
        if row and level > 1:
            for p in row[4].split('|'):
                k, v = p.split(',')
                out.append((int(k), float(v) * (level - 1)))
    return out


def up(db, account, ship, slot):
    import recruitment_local as heroes, hero_development_local as dev
    entry = next((e for e in heroes.all_owned(db, account) if e[0] == ship), None)
    if not entry:
        raise ValueError('ninja_nao_possuido')
    if slot not in (1, 2, 3):
        raise ValueError('potencial_invalido')
    if dev.state(db, account, ship, entry[1])['star'] < int(cfg(34)):
        raise ValueError('estrelas_insuficientes')
    lv = levels(db, account, ship)
    if lv[slot - 1] >= MAX_LEVEL:
        raise ValueError('potencial_no_maximo')
    c = cost(lv[slot - 1])
    if not c:
        raise ValueError('potencial_no_maximo')
    frags, silver = c
    prop = fragment(entry[1])
    if prop is None:
        raise ValueError('fragmento_do_ninja_inexistente')
    have = db._conn.execute('SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=?', (account, prop)).fetchone()
    if not have or have[0] < frags:
        raise ValueError('fragmentos_insuficientes')
    money = db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?', (account,)).fetchone()
    if not money or money[0] < silver:
        raise ValueError('ryo_insuficiente')
    db._conn.execute('UPDATE local_inventory SET quantity=quantity-? WHERE conta_id=? AND mould=?', (frags, account, prop))
    db._conn.execute('UPDATE local_campaign SET silver=silver-? WHERE conta_id=?', (silver, account))
    lv[slot - 1] += 1
    db._conn.execute('INSERT OR REPLACE INTO local_potential VALUES (?,?,?)', (account, ship, ','.join(map(str, lv))))
    from hero_training_local import inventory_tokens
    character = heroes.one_ship_tokens(db, account, entry)
    return inventory_tokens(db, account) + ['22', str(money[0] - silver)] + character[character.index('14104'):]


def execute(server, cmd, seq, text_):
    import hero_stats_local
    db = server.BANCO
    try:
        account = db.sessao_de(server._sessao_da_conexao())['conta_id']
        f = server._linhas(text_)
        body = f[1:] if f and f[0] == str(db.perfil(account)['user_id']) else f
        ship, slot = int(body[0]), int(body[1])
        with db._lock, db._conn:
            reply = ' '.join([str(seq), cmd, '0'] + up(db, account, ship, slot) + hero_stats_local.attribute_tokens(db, account))
        server.log('POTENCIAL conta=%s ninja=%s slot=%s' % (account, ship, slot))
        return reply
    except (server._contas.ErroConta, ValueError, KeyError, IndexError, TypeError) as exc:
        return server.recusa(cmd, seq, str(exc) or 'potencial_indisponivel')


def install(server):
    with server.BANCO._lock, server.BANCO._conn:
        schema(server.BANCO)
    for command in COMMANDS:
        server.MINIMOS[command] = lambda seq, text, cmd=command: execute(server, cmd, seq, text)
