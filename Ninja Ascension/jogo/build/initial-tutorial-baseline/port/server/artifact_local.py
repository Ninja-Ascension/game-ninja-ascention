"""Ninja School > Shamanism (artifact / 神器), following the client rules.

Client: client/l_digital/cultivate/artifact/*.lua. Parsers 12563 (lock states
"id:state|..." + attributes "id=key:value,...|..."), 12564 (pending practice
"id=key:value,...|..." one group per practice).

artifact_mould (0-based): 0 id, 3 achievements needed to unlock (-1 = open),
4/5/6 cost of basic/intermediate/advanced practice "kind,id,count|...",
7 limit group per attribute "key,group|...", 8 random group per attribute.
artifact_param: 1 group, 2 player level, 3 attribute limit (from level 32).
artifact_random_library: 1 max, 2 min of one practice roll.

Practice (artifact_culture id, method 0/1/2, times): pays the method cost per
practice and rolls every attribute; nothing changes until artifact_confirm
(id, 0, "i,j") applies the chosen practices, or (id, -1, 1) discards them.
Values stay between 0 and the limit of the player's level.
Reconstruction (not in the client): the help text only says advanced
practice gives the best effect; here method m rolls m+1 times and keeps the
best roll.
"""
import json, secrets
import dados_batalha as data

COMMANDS = ('artifact_unlock', 'artifact_culture', 'artifact_confirm')
PER_PRACTICE = 3   # attribute slots per result row in the client


def schema(db):
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_artifacts (conta_id INTEGER NOT NULL REFERENCES contas(id) ON DELETE CASCADE, artifact INTEGER NOT NULL, unlocked INTEGER NOT NULL DEFAULT 0, attrs TEXT NOT NULL DEFAULT "{}", pending TEXT NOT NULL DEFAULT "[]", PRIMARY KEY(conta_id, artifact))')
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_artifact_receipts (conta_id INTEGER, request_id TEXT, signature TEXT, reply TEXT, PRIMARY KEY(conta_id, request_id))')


def moulds():
    return data.tabela('artifact_mould.txt')


def pairs(text):
    return [tuple(p.split(',')) for p in text.split('|') if p]


def keys(art):
    return [int(k) for k, _ in pairs(moulds()[str(art)][7])]


def grade(db, account):
    r = db._conn.execute('SELECT grade FROM local_campaign WHERE conta_id=?', (account,)).fetchone()
    return r[0] if r else 1


_LIMITS = {}


def limit(art, key, level):
    if not _LIMITS:
        for r in data.tabela('artifact_param.txt').values():
            _LIMITS[(r[1], int(r[2]))] = float(r[3])
    group = dict(pairs(moulds()[str(art)][7]))[str(key)]
    levels = sorted(l for g, l in _LIMITS if g == group)
    level = min(max(level, levels[0]), levels[-1])
    return _LIMITS[(group, max(l for l in levels if l <= level))]


def num(v):
    v = round(float(v), 2)
    return str(int(v)) if v.is_integer() else str(v)


def state(db, account, art):
    r = db._conn.execute('SELECT unlocked, attrs, pending FROM local_artifacts WHERE conta_id=? AND artifact=?', (account, art)).fetchone()
    open_ = moulds()[str(art)][3] == '-1'
    if not r:
        return dict(unlocked=open_, attrs={str(k): 0 for k in keys(art)}, pending=[])
    attrs = {str(k): 0 for k in keys(art)}
    attrs.update(json.loads(r[1]))
    return dict(unlocked=bool(r[0]) or open_, attrs=attrs, pending=json.loads(r[2]))


def save(db, account, art, s):
    db._conn.execute('INSERT INTO local_artifacts VALUES (?,?,?,?,?) ON CONFLICT(conta_id, artifact) DO UPDATE SET unlocked=excluded.unlocked, attrs=excluded.attrs, pending=excluded.pending',
                     (account, art, int(s['unlocked']), json.dumps(s['attrs']), json.dumps(s['pending'])))


def info_tokens(db, account):
    locks, attrs = [], []
    for art in sorted(moulds(), key=int):
        s = state(db, account, int(art))
        locks.append('%s:%d' % (art, 1 if s['unlocked'] else 0))
        attrs.append('%s=%s' % (art, ','.join('%s:%s' % (k, num(v)) for k, v in sorted(s['attrs'].items(), key=lambda x: int(x[0])))))
    return ['12563', '|'.join(locks), '|'.join(attrs)]


def bonus(db, account):
    """Every unlocked artifact boosts every ninja: list of (kind, amount).
    Keys >= 4 are shown as percentages ("4.7%"): kinds 4/5 go to the panel
    as whole percentages (ninja_school_local.combat_bonus), the rest as
    fractions like the other battle properties."""
    out = []
    with db._lock:
        for art in moulds():
            s = state(db, account, int(art))
            if not s['unlocked']:
                continue
            for k, v in s['attrs'].items():
                k = int(k); v = float(v)
                if v:
                    out.append((k, v if k < 6 else v / 100.0))
    return out


def achievements_done(db, account, ids):
    try:
        import achievements_local
    except ImportError:
        return False
    return all(achievements_local.completed(db, account, int(i)) for i in ids)


def unlock(db, account, art):
    s = state(db, account, art)
    if s['unlocked']:
        raise ValueError('xamanismo_ja_liberado')
    ids = moulds()[str(art)][3].split(',')
    if not achievements_done(db, account, ids):
        raise ValueError('conquistas_do_xamanismo_incompletas')
    s['unlocked'] = True
    save(db, account, art, s)
    return []


def affordable(db, account, cost):
    """How many practices the player can pay for with this cost."""
    n = 10 ** 9
    for kind, ident, count in pairs(cost):
        kind, ident, count = int(kind), int(ident), int(count)
        if count <= 0:
            continue
        if kind == 6:
            r = db._conn.execute('SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=?', (account, ident)).fetchone()
        elif kind == 1:
            r = db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?', (account,)).fetchone()
        elif kind == 2:
            r = db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?', (account,)).fetchone()
        else:
            continue
        n = min(n, (r[0] if r else 0) // count)
    return n


def pay(db, account, cost, times):
    from hero_training_local import inventory_tokens
    tokens = []
    for kind, ident, count in pairs(cost):
        kind, ident, count = int(kind), int(ident), int(count) * times
        if kind == 6:
            r = db._conn.execute('SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=?', (account, ident)).fetchone()
            if not r or r[0] < count:
                raise ValueError('itens_insuficientes')
            db._conn.execute('UPDATE local_inventory SET quantity=quantity-? WHERE conta_id=? AND mould=?', (count, account, ident))
        elif kind == 1:
            r = db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?', (account,)).fetchone()
            if not r or r[0] < count:
                raise ValueError('ryo_insuficiente')
            db._conn.execute('UPDATE local_campaign SET silver=silver-? WHERE conta_id=?', (count, account))
            tokens += ['22', str(r[0] - count)]
        elif kind == 2:
            r = db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?', (account,)).fetchone()
            if not r or r[0] < count:
                raise ValueError('gold_insuficiente')
            db._conn.execute('UPDATE local_resources SET gold=gold-? WHERE conta_id=?', (count, account))
            tokens += ['25', str(-count), str(r[0] - count)]
        else:
            raise ValueError('custo_de_xamanismo_nao_suportado')
    return inventory_tokens(db, account) + tokens


def roll(group, method):
    row = data.tabela('artifact_random_library.txt')[str(group)]
    hi, lo = int(row[1]), int(row[2])
    best = max(lo + secrets.randbelow(hi - lo + 1) for _ in range(method + 1))
    return best / 10.0 if row[3] == '1' else best


def culture(db, account, art, method, times):
    s = state(db, account, art)
    if not s['unlocked']:
        raise ValueError('xamanismo_bloqueado')
    import saga_local
    top = int(saga_local.cfg(291))  # one-click training limit (SmCultivateArtifactConfirmTrain.lua:253)
    if method not in (0, 1, 2) or not 1 <= times <= max(10, top):
        raise ValueError('pratica_invalida')
    cost = moulds()[str(art)][4 + method]
    if times == 10:
        # The 10x button always sends 10; the client only warns "you can train
        # N times" (SmCultivateArtifactInfo.lua:120, text 295) when the material
        # covers fewer, so the server trains as many as affordable (1..10).
        times = max(1, min(10, affordable(db, account, cost)))
    tokens = pay(db, account, cost, times)
    groups = dict(pairs(moulds()[str(art)][8]))
    # The result row (cultivate_artifact_tab_1_list.csb) has 3 attribute
    # slots: each practice changes 3 of the artifact's attributes.
    def pick():
        keys = sorted(s['attrs'], key=int)
        chosen = []
        while len(chosen) < min(PER_PRACTICE, len(keys)):
            k = keys[secrets.randbelow(len(keys))]
            if k not in chosen:
                chosen.append(k)
        return {k: roll(int(groups[k]), method) for k in sorted(chosen, key=int)}
    s['pending'] = [pick() for _ in range(times)]
    save(db, account, art, s)
    text = '|'.join(','.join('%s:%s' % (k, num(v)) for k, v in p.items()) for p in s['pending'])
    return tokens + ['12564', '%d=%s' % (art, text)]


def confirm(db, account, art, kind, choice):
    s = state(db, account, art)
    if not s['pending']:
        raise ValueError('nenhuma_pratica_pendente')
    if kind == '0':
        picks = sorted({int(x) for x in choice.split(',') if x.strip()})
        if not picks or any(not 1 <= i <= len(s['pending']) for i in picks):
            raise ValueError('escolha_invalida')
        level = grade(db, account)
        for i in picks:
            for k, v in s['pending'][i - 1].items():
                s['attrs'][k] = max(0.0, min(limit(art, k, level), float(s['attrs'].get(k, 0)) + float(v)))
    elif kind != '-1':
        raise ValueError('confirmacao_invalida')
    s['pending'] = []
    save(db, account, art, s)
    return info_tokens(db, account)


def execute(server, cmd, seq, text):
    import re, hero_stats_local
    db = server.BANCO
    try:
        account = db.sessao_de(server._sessao_da_conexao())['conta_id']
        fields = server._linhas(text)
        if not fields or fields[0] != str(db.perfil(account)['user_id']):
            raise ValueError('conta_do_xamanismo_invalida')
        if not re.fullmatch(r'[0-9A-Za-z:-]{1,100}', fields[-1]):
            raise ValueError('identificador_de_pedido_invalido')
        key = fields[-1]; body = fields[1:-1]; signature = cmd + '|' + '|'.join(body)
        art = int(body[0]); moulds()[str(art)]
        changes_combat_stats = cmd == 'artifact_confirm' and len(body) == 3 and body[1] == '0'
        with db._lock, db._conn:
            receipt = db._conn.execute('SELECT signature, reply FROM local_artifact_receipts WHERE conta_id=? AND request_id=?', (account, key)).fetchone()
            if receipt:
                if receipt[0] != signature:
                    raise ValueError('identificador_reutilizado')
                return str(seq) + ' ' + receipt[1].split(' ', 1)[1]
            if cmd == 'artifact_unlock' and len(body) == 1:
                result = unlock(db, account, art) + info_tokens(db, account)
            elif cmd == 'artifact_culture' and len(body) == 3:
                result = culture(db, account, art, int(body[1]), int(body[2]))
            elif cmd == 'artifact_confirm' and len(body) == 3:
                result = confirm(db, account, art, body[1], body[2])
            else:
                raise ValueError('pedido_invalido')
            # Cultivation only creates pending choices; unlock/cancel do not
            # change the combat sheet either. Sending the full attribute
            # snapshot for a 10x practice needlessly inflated some responses
            # to ~100 KB and could stall the client parser. Only a save applies
            # attributes and needs the refreshed combat sheet.
            attributes = hero_stats_local.attribute_tokens(db, account) if changes_combat_stats else []
            reply = ' '.join([str(seq), cmd, '0'] + result + attributes)
            db._conn.execute('INSERT INTO local_artifact_receipts VALUES (?,?,?,?)', (account, key, signature, reply))
        server.log('XAMANISMO cmd=%s conta=%s pedido=%s' % (cmd, account, '|'.join(body)))
        return reply
    except (server._contas.ErroConta, ValueError, KeyError, IndexError, TypeError) as exc:
        return server.recusa(cmd, seq, str(exc) or 'xamanismo_indisponivel')


def install(server):
    with server.BANCO._lock, server.BANCO._conn:
        schema(server.BANCO)
    for command in COMMANDS:
        server.MINIMOS[command] = lambda seq, text, cmd=command: execute(server, cmd, seq, text)
