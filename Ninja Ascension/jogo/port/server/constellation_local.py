"""Ninja School > Sculpture Mountain (constellation / 诸神赐福), following the client.

Client: client/l_digital/cultivate/constellation/*.lua and
cells/cultivate/constellation/constellation_star_activation_cell.lua.
State = _ED.constellation_info {hba: {mould: {slot: [bought group rows]}},
uc: {mould: {slot: row in use}}, ctv: total guard value} (parser 12566;
12567/12568 send {ccid, cmIndex, cmList, cugid, ctv} for one slot).

constellation_mould (0-based): 0 id, 2 open level, 3 type, 4 the 5 ninjas of
the slots, 5 library group of each slot.
constellation_group: 1 group, 2 quality (play_config 80 = player level per
quality), 3 tier, 4 lock (1 = must own the slot's ninja), 5 cost
"kind,-1,amount" (1 Ryo, 2 gold), 6 stats "key,value|...", 7 guard value.

constellation_buy (mould, slot, row) pays and starts using the row;
constellation_exchange (mould, slot, row) switches to an already bought row.
Reconstruction (not in the client): the stats of the row in use go to the
slot's own ninja; ctv is the sum of the guard values of the rows in use.
"""
import json
import dados_batalha as data

COMMANDS = ('constellation_buy', 'constellation_exchange')


def schema(db):
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_constellation (conta_id INTEGER NOT NULL REFERENCES contas(id) ON DELETE CASCADE, mould INTEGER NOT NULL, slot INTEGER NOT NULL, row INTEGER NOT NULL, used INTEGER NOT NULL DEFAULT 0, PRIMARY KEY(conta_id, mould, slot, row))')
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_constellation_receipts (conta_id INTEGER, request_id TEXT, signature TEXT, reply TEXT, PRIMARY KEY(conta_id, request_id))')


def mould_row(m):
    return data.tabela('constellation_mould.txt')[str(m)]


def group_row(r):
    return data.tabela('constellation_group.txt')[str(r)]


def quality_level(q):
    from pathlib import Path
    path = Path(data.MOULD).parent / 'configs' / 'play_config.txt'
    for line in path.read_text(encoding='utf-8').splitlines():
        row = line.split('\t')
        if row[0] == '80':
            return dict(p.split(',') for p in row[3].split('|')).get(str(q), '999')
    return '999'


def info(db, account):
    hba, uc, ctv = {}, {}, 0
    for m, s, r, u in db._conn.execute('SELECT mould, slot, row, used FROM local_constellation WHERE conta_id=? ORDER BY mould, slot, row', (account,)):
        hba.setdefault(str(m), {}).setdefault(str(s), []).append(r)
        if u:
            uc.setdefault(str(m), {})[str(s)] = r
            ctv += int(group_row(r)[7])
    return {'hba': hba, 'uc': uc, 'ctv': ctv}


def init_tokens(db, account):
    return ['12566', json.dumps(info(db, account), separators=(',', ':'))]


def slot_tokens(db, account, code, m, s):
    i = info(db, account)
    return [code, json.dumps({'ccid': m, 'cmIndex': s, 'cmList': i['hba'].get(str(m), {}).get(str(s), []),
                              'cugid': i['uc'].get(str(m), {}).get(str(s), -1), 'ctv': i['ctv']}, separators=(',', ':'))]


def _cfg_list(n):
    import saga_local
    return [float(x.split(',')[1]) for x in saga_local.cfg(n).split('|') if ',' in x]


def ninja_type(mould):
    """Sculpture type of a ninja (FormationTigerGate.lua: ship_mould.hero_gender
    is the xz_sx_icon type); 0 when the ninja has none."""
    row = data.tabela('ship_mould.txt').get(str(mould))
    return int(row[4]) if row and len(row) > 4 and row[4].isdigit() else 0


def bonus(db, account, mould):
    """Rule screen: a Sculpture boosts every ninja of the kind its Mountain
    favours (constellation_mould type == ninja type). Per Mountain the total is
    SmCultivateConstellationWindow:attributeNumClt: each slot's row in use x
    (1 + (slot ninja star% [play_config 81] + quality% [82] + rows bought in
    the slot% [83]) / 100)."""
    import recruitment_local as heroes, hero_development_local as dev, hero_quality_local as hq
    kind = ninja_type(mould)
    if not kind:
        return []
    out = []
    with db._lock:
        rows = db._conn.execute('SELECT mould, slot, row FROM local_constellation WHERE conta_id=? AND used=1', (account,)).fetchall()
        owned = {m: s for s, m in heroes.all_owned(db, account)}
        stars, quals, counts = _cfg_list(81), _cfg_list(82), _cfg_list(83)
        for m, s, r in rows:
            mr = mould_row(m)
            if int(mr[3]) != kind:
                continue
            ships = mr[4].split(',')
            pct = 0
            n = db._conn.execute('SELECT COUNT(*) FROM local_constellation WHERE conta_id=? AND mould=? AND slot=?', (account, m, s)).fetchone()[0]
            pct += counts[n - 1] if 1 <= n <= len(counts) else 0
            slot_mould = int(ships[s]) if s < len(ships) else 0
            ship = owned.get(slot_mould)
            if ship:
                star = int(dev.state(db, account, ship, slot_mould)['star'])
                order = int(hq.quality(db, account, ship, slot_mould))
                pct += stars[star - 1] if 1 <= star <= len(stars) else 0
                pct += quals[order] if 0 <= order < len(quals) else 0
            for part in group_row(r)[6].split('|'):
                k, v = part.split(',')
                out.append((int(k), float(v) * (1 + pct / 100)))
    return out


def check(db, account, m, s, r):
    mr = mould_row(m)
    groups = mr[5].split(',')
    if not 0 <= s < len(groups):
        raise ValueError('posicao_invalida')
    g = group_row(r)
    if g[1] != groups[s]:
        raise ValueError('bencao_fora_da_posicao')
    grade = db._conn.execute('SELECT grade FROM local_campaign WHERE conta_id=?', (account,)).fetchone()
    grade = grade[0] if grade else 1
    if grade < int(mr[2]) or grade < int(quality_level(g[2])):
        raise ValueError('nivel_insuficiente')
    if g[4] == '1':
        import recruitment_local as heroes
        if int(mr[4].split(',')[s]) not in {mm for _, mm in heroes.all_owned(db, account)}:
            raise ValueError('ninja_nao_possuido')
    return g


def use(db, account, m, s, r):
    db._conn.execute('UPDATE local_constellation SET used=0 WHERE conta_id=? AND mould=? AND slot=?', (account, m, s))
    db._conn.execute('UPDATE local_constellation SET used=1 WHERE conta_id=? AND mould=? AND slot=? AND row=?', (account, m, s, r))


def buy(db, account, m, s, r):
    g = check(db, account, m, s, r)
    if db._conn.execute('SELECT 1 FROM local_constellation WHERE conta_id=? AND mould=? AND slot=? AND row=?', (account, m, s, r)).fetchone():
        raise ValueError('bencao_ja_comprada')
    kind, _, amount = (int(x) for x in g[5].split(','))
    tokens = []
    if kind == 1:
        have = db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?', (account,)).fetchone()
        if not have or have[0] < amount:
            raise ValueError('ryo_insuficiente')
        db._conn.execute('UPDATE local_campaign SET silver=silver-? WHERE conta_id=?', (amount, account))
        tokens = ['22', str(have[0] - amount)]
    elif kind == 2:
        have = db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?', (account,)).fetchone()
        if not have or have[0] < amount:
            raise ValueError('gold_insuficiente')
        db._conn.execute('UPDATE local_resources SET gold=gold-? WHERE conta_id=?', (amount, account))
        tokens = ['25', str(-amount), str(have[0] - amount)]
    else:
        raise ValueError('custo_de_bencao_nao_suportado')
    db._conn.execute('INSERT INTO local_constellation VALUES (?,?,?,?,0)', (account, m, s, r))
    use(db, account, m, s, r)
    return tokens + slot_tokens(db, account, '12567', m, s)


def exchange(db, account, m, s, r):
    check(db, account, m, s, r)
    if not db._conn.execute('SELECT 1 FROM local_constellation WHERE conta_id=? AND mould=? AND slot=? AND row=?', (account, m, s, r)).fetchone():
        raise ValueError('bencao_nao_comprada')
    use(db, account, m, s, r)
    return slot_tokens(db, account, '12568', m, s)


def execute(server, cmd, seq, text):
    import re, hero_stats_local
    db = server.BANCO
    try:
        account = db.sessao_de(server._sessao_da_conexao())['conta_id']
        fields = server._linhas(text)
        if not fields or fields[0] != str(db.perfil(account)['user_id']):
            raise ValueError('conta_da_escultura_invalida')
        if len(fields) != 5 or not re.fullmatch(r'[0-9A-Za-z:-]{1,100}', fields[-1]):
            raise ValueError('pedido_invalido')
        m, s, r = (int(x) for x in fields[1:4]); key = fields[-1]
        signature = cmd + '|' + '|'.join(fields[1:4])
        with db._lock, db._conn:
            receipt = db._conn.execute('SELECT signature, reply FROM local_constellation_receipts WHERE conta_id=? AND request_id=?', (account, key)).fetchone()
            if receipt:
                if receipt[0] != signature:
                    raise ValueError('identificador_reutilizado')
                return str(seq) + ' ' + receipt[1].split(' ', 1)[1]
            result = buy(db, account, m, s, r) if cmd == 'constellation_buy' else exchange(db, account, m, s, r)
            reply = ' '.join([str(seq), cmd, '0'] + result + hero_stats_local.attribute_tokens(db, account))
            db._conn.execute('INSERT INTO local_constellation_receipts VALUES (?,?,?,?)', (account, key, signature, reply))
        server.log('ESCULTURA cmd=%s conta=%s pedido=%s' % (cmd, account, '|'.join(fields[1:4])))
        return reply
    except (server._contas.ErroConta, ValueError, KeyError, IndexError, TypeError) as exc:
        return server.recusa(cmd, seq, str(exc) or 'escultura_indisponivel')


def install(server):
    with server.BANCO._lock, server.BANCO._conn:
        schema(server.BANCO)
    for command in COMMANDS:
        server.MINIMOS[command] = lambda seq, text, cmd=command: execute(server, cmd, seq, text)
