"""Ninja School > Aid Team (Soul Guard / 灵魂守卫), following the client.

Client: client/l_digital/cultivate/soulward/SoulWardingWindow.lua.
State sent as _ED.soul_warding_formation_hero (parser 12661, json):
  {"<slot>": {level, onUseShipMouldId, addBaseProperty [[1,atk],[2,def],[0,hp]],
              addExtraPropertyPercent [evo, quality, other], addFinalProperty}}
Only unlocked slots are present; with none unlocked the field is not sent
(the window indexes slot 1 directly when the table exists).

Tables (0-based): soul_guard_group_mould 0 slot, 2 unlock condition ids;
soul_guard_unlock_mould 0 id, 1 type, 2 count/level, 3 value
  (1 ninjas with N gates opened, 2 previous slot level, 3 ninjas at quality,
   5 team level, 6 ninjas at level);
soul_guard_level_mould 1 level, 2 cost "kind,id,n|..." (1 Ryo, 6 item),
  3 attributes "kind,value|..." of that level, 4 slot.
The guard's final attributes are added to every ninja (window: "all").
Reconstruction: the extra percentages (evolution/quality/other of the guard
ninja) are not in the client data, so they stay 0 until known.
"""
import json
import dados_batalha as data

COMMANDS = ('soul_gruad_un_lock', 'soul_gruad_level_up', 'soul_gruad_use_ship_mould')
ORDER = ('1', '2', '0')     # atk, def, hp as the window lists them


def schema(db):
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_soul_guard (conta_id INTEGER NOT NULL REFERENCES contas(id) ON DELETE CASCADE, slot INTEGER NOT NULL, level INTEGER NOT NULL DEFAULT 0, ship_mould INTEGER NOT NULL DEFAULT -1, PRIMARY KEY(conta_id, slot))')


def pairs(text):
    return [p.split(',') for p in text.split('|') if p and p != '-1']


def level_row(slot, level):
    return next((r for r in data.tabela('soul_guard_level_mould.txt').values() if int(r[4]) == slot and int(r[1]) == level), None)


def max_level(slot):
    return max(int(r[1]) for r in data.tabela('soul_guard_level_mould.txt').values() if int(r[4]) == slot)


def slots(db, account):
    schema(db)
    return {r[0]: (r[1], r[2]) for r in db._conn.execute('SELECT slot, level, ship_mould FROM local_soul_guard WHERE conta_id=?', (account,))}


def entry(slot, level, ship):
    row = level_row(slot, level)
    attrs = dict((k, float(v)) for k, v in pairs(row[3])) if row else {}
    base = [[int(k), attrs.get(k, 0)] for k in ORDER]
    extra = [0, 0, 0]
    final = [[k, round(v * (1 + sum(extra)))] for k, v in base]
    base = [[k, round(v)] for k, v in base]
    return {'level': level, 'onUseShipMouldId': ship, 'addBaseProperty': base,
            'addExtraPropertyPercent': extra, 'addFinalProperty': final}


def info(db, account):
    """Value for soul_warding_formation_hero, or None when nothing is unlocked."""
    s = slots(db, account)
    return {str(k): entry(k, lv, ship) for k, (lv, ship) in s.items()} or None


def tokens(db, account):
    i = info(db, account)
    return ['12661', json.dumps(i if i is not None else {}, separators=(',', ':'))]


def bonus(db, account):
    out = []
    with db._lock:
        for k, (lv, ship) in slots(db, account).items():
            for kind, value in entry(k, lv, ship)['addFinalProperty']:
                out.append((kind, float(value)))
    return out


def condition_ok(db, account, cid, s):
    row = data.tabela('soul_guard_unlock_mould.txt').get(str(cid))
    if not row:
        return False
    kind, count, value = int(row[1]), int(row[2]), int(row[3])
    import recruitment_local as heroes
    owned = heroes.all_owned(db, account)
    if kind == 1:
        import hero_gates_local as gates
        return sum(1 for ship, _ in owned if len(gates.state(db, account, ship)['megaLevel']) >= value) >= count
    if kind == 2:
        prev = s.get(0)  # filled by caller
        return prev is not None and prev >= count
    if kind == 3:
        import hero_quality_local as hq
        return sum(1 for ship, m in owned if int(hq.quality(db, account, ship, m)) >= value) >= count
    if kind == 5:
        g = db._conn.execute('SELECT grade FROM local_campaign WHERE conta_id=?', (account,)).fetchone()
        return (g[0] if g else 1) >= count
    if kind == 6:
        import hero_level_local as hl
        return sum(1 for ship, m in owned if int(hl.state(db, account, ship, m)[0]) >= value) >= count
    return False


def pay(db, account, cost):
    items = []
    for p in pairs(cost):
        kind, ident, n = int(p[0]), int(p[1]), int(p[2])
        if kind == 1:
            have = db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?', (account,)).fetchone()
            if not have or have[0] < n:
                raise ValueError('ryo_insuficiente')
            items.append(('silver', None, n))
        elif kind == 6:
            have = db._conn.execute('SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=?', (account, ident)).fetchone()
            if not have or have[0] < n:
                raise ValueError('materiais_insuficientes')
            items.append(('item', ident, n))
        else:
            raise ValueError('custo_nao_suportado')
    for what, ident, n in items:
        if what == 'silver':
            db._conn.execute('UPDATE local_campaign SET silver=silver-? WHERE conta_id=?', (n, account))
        else:
            db._conn.execute('UPDATE local_inventory SET quantity=quantity-? WHERE conta_id=? AND mould=?', (n, account, ident))


def execute(server, cmd, seq, text):
    db = server.BANCO
    try:
        account = db.sessao_de(server._sessao_da_conexao())['conta_id']
        f = server._linhas(text)
        body = f[1:] if f and f[0] == str(db.perfil(account)['user_id']) else f
        slot = int(body[0])
        group = data.tabela('soul_guard_group_mould.txt').get(str(slot))
        if not group:
            raise ValueError('posicao_invalida')
        with db._lock, db._conn:
            s = slots(db, account)
            if cmd == 'soul_gruad_un_lock':
                if slot in s:
                    raise ValueError('ja_desbloqueado')
                prev = s.get(slot - 1, (None,))[0]
                for cid in group[2].split(','):
                    if not condition_ok(db, account, cid, {0: prev}):
                        raise ValueError('condicao_nao_cumprida')
                db._conn.execute('INSERT INTO local_soul_guard VALUES (?,?,0,-1)', (account, slot))
            elif cmd == 'soul_gruad_level_up':
                if slot not in s:
                    raise ValueError('desbloqueie_primeiro')
                lv = s[slot][0]
                if lv >= max_level(slot):
                    raise ValueError('nivel_maximo')
                pay(db, account, level_row(slot, lv + 1)[2])
                db._conn.execute('UPDATE local_soul_guard SET level=? WHERE conta_id=? AND slot=?', (lv + 1, account, slot))
            else:
                if slot not in s:
                    raise ValueError('desbloqueie_primeiro')
                mould = int(body[1])
                import recruitment_local as heroes
                if mould not in {m for _, m in heroes.all_owned(db, account)}:
                    raise ValueError('ninja_nao_possuido')
                db._conn.execute('UPDATE local_soul_guard SET ship_mould=-1 WHERE conta_id=? AND ship_mould=?', (account, mould))
                db._conn.execute('UPDATE local_soul_guard SET ship_mould=? WHERE conta_id=? AND slot=?', (mould, account, slot))
            out = tokens(db, account)
            silver = db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?', (account,)).fetchone()
            import hero_training_local
            out += ['22', str(silver[0] if silver else 0)] + hero_training_local.inventory_tokens(db, account)
        server.log('AID_TEAM conta=%s cmd=%s slot=%s' % (account, cmd, slot))
        return ' '.join([str(seq), cmd, '0'] + out)
    except (server._contas.ErroConta, ValueError, KeyError, IndexError, TypeError) as exc:
        return server.recusa(cmd, seq, str(exc) or 'aid_team_indisponivel')


def install(server):
    with server.BANCO._lock, server.BANCO._conn:
        schema(server.BANCO)
    for command in COMMANDS:
        server.MINIMOS[command] = lambda seq, text, cmd=command: execute(server, cmd, seq, text)
