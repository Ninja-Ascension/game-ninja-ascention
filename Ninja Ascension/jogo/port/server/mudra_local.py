"""Ninja School > Mudra (Alloy Matrix / 数码合金), following the client rules.

Client sources: client/l_digital/cultivate/matrix/*.lua.

Tables (0-based columns):
  ship_metal_mould   0 id, 2 head (1 = ATK/DEF piece, 2 = damage/reduction
                     piece), 3 mould_type (shape used by matrices), 4 add_type
                     (ship_metal_param group), 5 quality
  ship_metal_param   1 group, 2 metal_grade (level), 3 metal_level (rank),
                     4 metal_add, 5 next_need_exp, 6 next_level_gold
  ship_matrix_mould  2 metal_need "mould_type,count|...", 3 group
  ship_matrix_param  1 group, 2 quality, 3 add
  ship_mould[67]     matrices this ninja can activate
  ship_config 35/36  quality factor for stats+essence / for Ryo
              37     dissolve refund (essence, Ryo)
              39     slot unlock ninja level per matrix
              40     first-activation reward of a matrix
              41     daily draws per recruit template (partner_bounty_param)

Rules (AlloyMatrixStrengthenOne/All.lua): a level costs
next_need_exp * f35 essence; a row with next_need_exp == -1 is a rank gate
costing next_level_gold * f36 Ryo (rank + 1, same level); both -1 = max.
Dissolve returns 100% of the essence and 80% of the Ryo spent on the piece.
Matrix choice (not in the client, reconstructed): among the ninja's matrices
fully satisfied by the pieces of that slot group, the one using most pieces,
then higher quality, then higher id; quality = lowest quality used.
"""
import json, re, secrets, time
import dados_batalha as data

COMMANDS = ('ship_metal_set', 'ship_metal_escalate', 'ship_metal_onekey_escalate',
            'ship_metal_dissolve', 'draw_matrix_reward')
ID_BASE = 300000000
# (command, client type) -> (partner_bounty_param id, position in ship_config 41, draws)
DRAWS = {('ship_bounty', '4'): ('13', 0, 1), ('ship_bounty', '5'): ('16', 3, 1),
         ('ship_batch_bounty', '5'): ('14', 1, 10), ('ship_batch_bounty', '6'): ('15', 2, 50),
         ('ship_batch_bounty', '7'): ('17', 4, 10)}


def schema(db):
    c = db._conn
    c.execute('CREATE TABLE IF NOT EXISTS local_metals (id INTEGER PRIMARY KEY AUTOINCREMENT, conta_id INTEGER NOT NULL REFERENCES contas(id) ON DELETE CASCADE, mould INTEGER NOT NULL, rank INTEGER NOT NULL DEFAULT 0, level INTEGER NOT NULL DEFAULT 1, exp INTEGER NOT NULL DEFAULT 0, silver_spent INTEGER NOT NULL DEFAULT 0, essence_spent INTEGER NOT NULL DEFAULT 0)')
    c.execute('CREATE TABLE IF NOT EXISTS local_metal_slots (conta_id INTEGER NOT NULL REFERENCES contas(id) ON DELETE CASCADE, ship INTEGER NOT NULL, idx INTEGER NOT NULL, pos INTEGER NOT NULL, metal INTEGER NOT NULL UNIQUE, PRIMARY KEY(conta_id, ship, idx, pos))')
    c.execute('CREATE TABLE IF NOT EXISTS local_metal_essence (conta_id INTEGER PRIMARY KEY REFERENCES contas(id) ON DELETE CASCADE, amount INTEGER NOT NULL DEFAULT 0)')
    c.execute('CREATE TABLE IF NOT EXISTS local_matrix_reward (conta_id INTEGER NOT NULL REFERENCES contas(id) ON DELETE CASCADE, ship INTEGER NOT NULL, matrix INTEGER NOT NULL, claimed INTEGER NOT NULL DEFAULT 0, PRIMARY KEY(conta_id, ship, matrix))')
    c.execute('CREATE TABLE IF NOT EXISTS local_metal_recruit (conta_id INTEGER PRIMARY KEY REFERENCES contas(id) ON DELETE CASCADE, day TEXT, used TEXT, free_silver TEXT, free_gold TEXT, draws INTEGER NOT NULL DEFAULT 0)')
    c.execute('CREATE TABLE IF NOT EXISTS local_mudra_receipts (conta_id INTEGER, request_id TEXT, signature TEXT, reply TEXT, PRIMARY KEY(conta_id, request_id))')


# ---------------------------------------------------------------- tables --

_CFG = {}


def cfg(n):
    if not _CFG:
        from pathlib import Path
        path = Path(data.MOULD).parent / 'configs' / 'ship_config.txt'
        for line in path.read_text(encoding='utf-8').splitlines():
            row = line.split('\t')
            if len(row) > 3:
                _CFG[row[0]] = row[3]
    if str(n) not in _CFG:
        raise ValueError('ship_config_%s_ausente' % n)
    return _CFG[str(n)]


def factor(n, quality):
    return float(dict(p.split(',') for p in cfg(n).split('|'))[str(quality)])


def metal_row(mould):
    return data.tabela('ship_metal_mould.txt')[str(mould)]


_PARAMS = {}


def param_row(mould, level, rank):
    if not _PARAMS:
        for r in data.tabela('ship_metal_param.txt').values():
            _PARAMS[(r[1], int(r[2]), int(r[3]))] = r
    return _PARAMS.get((metal_row(mould)[4], level, rank))


def slot_count(idx):
    return (idx + 1) * 2


def unlock_level(idx, pos):
    groups = cfg(39).split('!')
    for part in groups[idx - 1].split('|'):
        if part and part.split(':')[0] == str(pos):
            return int(part.split(':')[1])
    return 10 ** 9


def day():
    return time.strftime('%Y-%m-%d')


# ----------------------------------------------------------------- state --

def wire_id(rowid):
    return ID_BASE + int(rowid)


def row_id(wire):
    n = int(wire) - ID_BASE
    if n <= 0:
        raise ValueError('peca_invalida')
    return n


def essence(db, account):
    r = db._conn.execute('SELECT amount FROM local_metal_essence WHERE conta_id=?', (account,)).fetchone()
    return r[0] if r else 0


def add_essence(db, account, delta):
    db._conn.execute('INSERT INTO local_metal_essence VALUES (?,0) ON CONFLICT(conta_id) DO NOTHING', (account,))
    db._conn.execute('UPDATE local_metal_essence SET amount=amount+? WHERE conta_id=?', (delta, account))


def silver(db, account):
    r = db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?', (account,)).fetchone()
    return r[0] if r else 0


def metal(db, account, wire):
    r = db._conn.execute('SELECT id,mould,rank,level,exp,silver_spent,essence_spent FROM local_metals WHERE conta_id=? AND id=?',
                         (account, row_id(wire))).fetchone()
    if not r:
        raise ValueError('peca_nao_possuida')
    return dict(zip(('id', 'mould', 'rank', 'level', 'exp', 'silver', 'essence'), r))


def equipped_ship(db, account, rowid):
    r = db._conn.execute('SELECT ship FROM local_metal_slots WHERE conta_id=? AND metal=?', (account, rowid)).fetchone()
    return r[0] if r else -1


def metal_fields(db, account, m):
    uid = db.perfil(account)['user_id']
    return [str(wire_id(m['id'])), str(m['rank']), str(m['exp']), str(uid), str(m['silver']), str(m['essence']),
            str(equipped_ship(db, account, m['id'])), str(m['mould']), str(m['level'])]


def all_metals(db, account):
    rows = db._conn.execute('SELECT id,mould,rank,level,exp,silver_spent,essence_spent FROM local_metals WHERE conta_id=? ORDER BY id', (account,)).fetchall()
    return [dict(zip(('id', 'mould', 'rank', 'level', 'exp', 'silver', 'essence'), r)) for r in rows]


def slots(db, account, ship):
    out = {1: {}, 2: {}, 3: {}}
    for idx, pos, m in db._conn.execute('SELECT idx,pos,metal FROM local_metal_slots WHERE conta_id=? AND ship=?', (account, ship)):
        out.setdefault(idx, {})[pos] = m
    return out


def ship_matrices(mould):
    row = data.tabela('ship_mould.txt').get(str(mould))
    text = row[67] if row and len(row) > 67 else ''
    return [int(x) for x in text.split(',') if x.strip().lstrip('-').isdigit() and int(x) > 0]


def active_matrix(db, account, mould, metal_ids):
    """(matrix id, quality) satisfied by the pieces of one slot group, or None."""
    pieces = []
    for rowid in metal_ids:
        r = db._conn.execute('SELECT mould FROM local_metals WHERE id=?', (rowid,)).fetchone()
        if r:
            mr = metal_row(r[0])
            pieces.append((int(mr[3]), int(mr[5])))
    best = None
    for mid in ship_matrices(mould):
        row = data.tabela('ship_matrix_mould.txt').get(str(mid))
        if not row:
            continue
        need = [tuple(map(int, p.split(','))) for p in row[2].split('|')]
        quality = 99; ok = True; used = 0
        for kind, count in need:
            have = sorted((q for k, q in pieces if k == kind), reverse=True)
            if len(have) < count:
                ok = False; break
            quality = min(quality, have[count - 1]); used += count
        if ok:
            key = (used, quality, mid)
            if best is None or key > best[0]:
                best = (key, mid, quality)
    return (best[1], best[2]) if best else None


def refresh_rewards(db, account, ship, mould):
    """A matrix activated for the first time becomes claimable (mr = 0)."""
    for idx, group in slots(db, account, ship).items():
        act = active_matrix(db, account, mould, group.values())
        if act:
            db._conn.execute('INSERT OR IGNORE INTO local_matrix_reward VALUES (?,?,?,0)', (account, ship, act[0]))


def alloy_json(db, account, ship, mould):
    """ship.alloyMatrix of the 14104 block (mmi/ma/mr)."""
    group = slots(db, account, ship)
    mmi = {str(i): {str(p): wire_id(m) for p, m in sorted(group.get(i, {}).items())} for i in (1, 2, 3)}
    ma = {}
    for i in (1, 2, 3):
        act = active_matrix(db, account, mould, group.get(i, {}).values())
        ma[str(i)] = {str(act[0]): act[1]} if act else {}
    mr = {str(m): c for m, c in db._conn.execute('SELECT matrix, claimed FROM local_matrix_reward WHERE conta_id=? AND ship=?', (account, ship))}
    return json.dumps({'mmi': mmi, 'ma': ma, 'mr': mr}, separators=(',', ':'))


def recruit_state(db, account):
    limits = [p.split(',') for p in cfg(41).split('|')]
    r = db._conn.execute('SELECT day,used,free_silver,free_gold,draws FROM local_metal_recruit WHERE conta_id=?', (account,)).fetchone()
    today = day()
    used = [int(x) for x in r[1].split(',')] if r and r[0] == today and r[1] else [0] * len(limits)
    free_silver = int(not r or r[2] != today)
    free_gold = int(not r or r[3] != today)
    return used, free_silver, free_gold, (r[4] if r else 0), limits


def recruit_tokens(db, account):
    used, fs, fg, _, _ = recruit_state(db, account)
    return ['14113', str(fs), str(fg), ','.join(map(str, used))]


def bonus(db, account, ship, mould):
    """Mudra effects for one ninja: list of (kind, amount)."""
    out = []
    with db._lock:
        group = slots(db, account, ship)
        for idx, ids in group.items():
            for rowid in ids.values():
                r = db._conn.execute('SELECT mould,rank,level FROM local_metals WHERE id=?', (rowid,)).fetchone()
                if not r:
                    continue
                p = param_row(r[0], r[2], r[1])
                f = factor(35, int(metal_row(r[0])[5]))
                for part in (p[4].split('|') if p else []):
                    k, v = part.split(',')
                    out.append((int(k), float(v) * f))
            act = active_matrix(db, account, mould, ids.values())
            if act:
                g = data.tabela('ship_matrix_mould.txt')[str(act[0])][3]
                prow = next((x for x in data.tabela('ship_matrix_param.txt').values() if x[1] == g and int(x[2]) == act[1]), None)
                for part in (prow[3].split('|') if prow else []):
                    k, v = part.split(',')
                    out.append((int(k), float(v)))
    return out


def init_tokens(db, account):
    ms = all_metals(db, account)
    out = ['14111', str(len(ms))]
    for m in ms:
        out += metal_fields(db, account, m)
    return out + ['12047', str(essence(db, account))] + recruit_tokens(db, account)


# ------------------------------------------------------------ operations --

def owned_ship(db, account, ship):
    import recruitment_local as heroes
    entry = next((e for e in heroes.all_owned(db, account) if e[0] == int(ship)), None)
    if not entry:
        raise ValueError('ninja_nao_possuido')
    return entry


def ship_level(db, account, ship, mould):
    import hero_level_local
    return hero_level_local.state(db, account, ship, mould)[0]


def place(db, account, ship, mould, idx, pos, wire):
    if not 1 <= idx <= 3 or not 1 <= pos <= slot_count(idx):
        raise ValueError('posicao_invalida')
    if ship_level(db, account, ship, mould) < unlock_level(idx, pos):
        raise ValueError('posicao_bloqueada')
    db._conn.execute('DELETE FROM local_metal_slots WHERE conta_id=? AND ship=? AND idx=? AND pos=?', (account, ship, idx, pos))
    if int(wire) != -1:
        m = metal(db, account, wire)
        db._conn.execute('DELETE FROM local_metal_slots WHERE conta_id=? AND metal=?', (account, m['id']))
        db._conn.execute('INSERT INTO local_metal_slots VALUES (?,?,?,?,?)', (account, ship, idx, pos, m['id']))


def metal_set(db, account, fields):
    ship, mould = owned_ship(db, account, fields[1])
    idx, kind, info = int(fields[2]), fields[3], fields[4]
    before = {m for g in slots(db, account, ship).values() for m in g.values()}
    if kind == '0':
        wire, pos = info.split(',')
        place(db, account, ship, mould, idx, int(pos), wire)
    elif kind == '1':
        db._conn.execute('DELETE FROM local_metal_slots WHERE conta_id=? AND ship=? AND idx=?', (account, ship, idx))
        for part in info.strip('|').split('|'):
            if part:
                wire, pos = part.split(',')
                place(db, account, ship, mould, idx, int(pos), wire)
    elif kind == '2':
        db._conn.execute('DELETE FROM local_metal_slots WHERE conta_id=? AND ship=? AND idx=?', (account, ship, idx))
    else:
        raise ValueError('tipo_de_colocacao_invalido')
    refresh_rewards(db, account, ship, mould)
    after = {m for g in slots(db, account, ship).values() for m in g.values()}
    changed = [metal(db, account, wire_id(r)) for r in sorted(before | after)
               if db._conn.execute('SELECT 1 FROM local_metals WHERE id=?', (r,)).fetchone()]
    return change_tokens(db, account, changed) + ship_tokens(db, account, ship, mould)


def change_tokens(db, account, ms):
    out = ['14112', str(len(ms))]
    for m in ms:
        out += metal_fields(db, account, m)
    return out


def ship_tokens(db, account, ship, mould):
    import recruitment_local as heroes
    character = heroes.one_ship_tokens(db, account, (ship, mould))
    return character[character.index('14104'):]


def level_step(db, account, m, allow_rank, budget):
    """One step of a piece. Returns (essence used, Ryo used) or None."""
    p = param_row(m['mould'], m['level'], m['rank'])
    if not p:
        return None
    q = int(metal_row(m['mould'])[5])
    need_exp, need_gold = int(p[5]), int(p[6])
    if need_exp == -1 and need_gold == -1:
        return None
    if need_exp == -1:
        if not allow_rank:
            return None
        cost = int(need_gold * factor(36, q))
        if budget['silver'] < cost:
            return None
        m['rank'] += 1; m['silver'] += cost; budget['silver'] -= cost
        return 0, cost
    need = int(need_exp * factor(35, q)) - m['exp']
    if budget['essence'] <= 0:
        return None
    used = min(need, budget['essence'])
    m['exp'] += used; m['essence'] += used; budget['essence'] -= used
    if m['exp'] >= int(need_exp * factor(35, q)):
        m['level'] += 1; m['exp'] = 0
    return used, 0


def save_metal(db, m):
    db._conn.execute('UPDATE local_metals SET rank=?,level=?,exp=?,silver_spent=?,essence_spent=? WHERE id=?',
                     (m['rank'], m['level'], m['exp'], m['silver'], m['essence'], m['id']))


def pay(db, account, budget, start):
    used_e = start['essence'] - budget['essence']; used_s = start['silver'] - budget['silver']
    if used_e:
        add_essence(db, account, -used_e)
    if used_s:
        db._conn.execute('UPDATE local_campaign SET silver=silver-? WHERE conta_id=?', (used_s, account))
    return used_e, used_s


def escalate(db, account, fields):
    m = metal(db, account, fields[1]); kind = fields[2]
    budget = {'essence': essence(db, account), 'silver': silver(db, account)}; start = dict(budget)
    p = param_row(m['mould'], m['level'], m['rank'])
    if not p or (int(p[5]) == -1 and int(p[6]) == -1):
        raise ValueError('peca_no_nivel_maximo')
    if kind == '0':
        if level_step(db, account, m, True, budget) is None:
            raise ValueError('recursos_insuficientes')
    elif kind == '1':
        steps = 0
        while level_step(db, account, m, False, budget):
            steps += 1
        if not steps:
            raise ValueError('essencia_insuficiente')
    else:
        raise ValueError('tipo_de_fortalecimento_invalido')
    save_metal(db, m); pay(db, account, budget, start)
    out = ['14115'] + metal_fields(db, account, m)
    return out + ['12047', str(essence(db, account)), '22', str(silver(db, account))]


def onekey(db, account, fields):
    ship, mould = owned_ship(db, account, fields[1])
    idx, target = int(fields[2]), int(fields[3])
    ids = list(slots(db, account, ship).get(idx, {}).values())
    if not ids:
        raise ValueError('formacao_vazia')
    budget = {'essence': essence(db, account), 'silver': silver(db, account)}; start = dict(budget)
    changed = []
    for rowid in ids:
        m = metal(db, account, wire_id(rowid))
        while m['level'] < target and level_step(db, account, m, True, budget):
            pass
        if m['level'] < target:
            raise ValueError('recursos_insuficientes')
        changed.append(m)
    for m in changed:
        save_metal(db, m)
    pay(db, account, budget, start)
    return (change_tokens(db, account, changed) + ['12047', str(essence(db, account)), '22', str(silver(db, account))]
            + ship_tokens(db, account, ship, mould))


def dissolve(db, account, fields):
    wires = [x for x in fields[1].split(',') if x.strip()]
    if not wires or len(set(wires)) != len(wires):
        raise ValueError('pecas_invalidas')
    back_e = back_s = 0; ids = []
    re_e, re_s = (float(x) for x in cfg(37).split(','))
    for w in wires:
        m = metal(db, account, w)
        if equipped_ship(db, account, m['id']) != -1:
            raise ValueError('peca_equipada')
        back_e += int(m['essence'] * re_e); back_s += int(m['silver'] * re_s); ids.append(m['id'])
    for rowid in ids:
        db._conn.execute('DELETE FROM local_metals WHERE id=?', (rowid,))
    if back_e:
        add_essence(db, account, back_e)
    if back_s:
        db._conn.execute('UPDATE local_campaign SET silver=silver+? WHERE conta_id=?', (back_s, account))
    rewards = [r for r in ((-1, 67, back_e), (-1, 1, back_s)) if r[2] > 0]
    out = ['14114', str(len(ids))] + [str(wire_id(i)) for i in ids]
    out += ['12047', str(essence(db, account)), '22', str(silver(db, account))]
    if rewards:
        out += ['171', '7', str(len(rewards))] + [str(x) for r in rewards for x in r]
    return out


def claim(db, account, fields):
    ship, mould = owned_ship(db, account, fields[1])
    ids = [int(x) for x in fields[2].split(',') if x.strip()]
    if not ids:
        raise ValueError('nada_para_receber')
    reward = [tuple(map(int, p.split(','))) for p in cfg(40).split('|')]
    total = {}
    for mid in ids:
        r = db._conn.execute('SELECT claimed FROM local_matrix_reward WHERE conta_id=? AND ship=? AND matrix=?', (account, ship, mid)).fetchone()
        if not r or r[0] != 0:
            raise ValueError('recompensa_indisponivel')
        db._conn.execute('UPDATE local_matrix_reward SET claimed=1 WHERE conta_id=? AND ship=? AND matrix=?', (account, ship, mid))
        for kind, _, n in reward:
            total[kind] = total.get(kind, 0) + n
    for kind, n in total.items():
        if kind == 67:
            add_essence(db, account, n)
        elif kind == 1:
            db._conn.execute('UPDATE local_campaign SET silver=silver+? WHERE conta_id=?', (n, account))
        else:
            raise ValueError('recompensa_nao_suportada')
    out = ['12047', str(essence(db, account)), '22', str(silver(db, account)),
           '171', '7', str(len(total))] + [str(x) for k, n in total.items() for x in (-1, k, n)]
    return out + ship_tokens(db, account, ship, mould)


def choose_row(group):
    """shop_local.choose, also returning the bounty_hero_param id (parser 166)."""
    rows = [r for r in data.tabela('bounty_hero_param.txt').values() if int(r[1]) == group and int(r[5]) > 0]
    if not rows:
        raise ValueError('biblioteca_de_compra_ausente')
    roll = secrets.randbelow(sum(int(r[5]) for r in rows))
    for r in rows:
        roll -= int(r[5])
        if roll < 0:
            return int(r[0]), list(map(int, r[6].split(',')))[:3]


def draw(db, account, command, kind):
    import shop_local
    template, pos, count = DRAWS[(command, kind)]
    row = data.tabela('partner_bounty_param.txt')[template]
    used, free_s, free_g, draws, limits = recruit_state(db, account)
    if used[pos] + 1 > int(limits[pos][1]):
        raise ValueError('limite_diario_de_compras')
    cost_s, cost_g = int(row[3]), int(row[4])
    free = count == 1 and row[2] == '1' and (free_s if cost_s else free_g)
    delta = 0
    if not free:
        if cost_s:
            if silver(db, account) < cost_s:
                raise ValueError('ryo_insuficiente')
            db._conn.execute('UPDATE local_campaign SET silver=silver-? WHERE conta_id=?', (cost_s, account))
        if cost_g:
            gold = db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?', (account,)).fetchone()
            if not gold or gold[0] < cost_g:
                raise ValueError('gold_insuficiente')
            db._conn.execute('UPDATE local_resources SET gold=gold-? WHERE conta_id=?', (cost_g, account))
            delta = -cost_g
    if count == 1:
        groups = [int(row[6] if draws == 0 else row[7])] if free else [int(row[8].split(',')[0])]
    else:
        sets = row[10].split('|')
        groups = [int(g) for s in sets[:count // 10] for g in s.split(',')]
    if len(groups) != count:
        raise ValueError('grupos_de_compra_invalidos')
    # One reward event per prize, in prize order, then 166 with the whole list
    # (parse_return_ship_bounty_batch fills _ED.random_Patch; HeroRecruitReward
    # walks it against _ED.new_reward_object and only shows its buttons after
    # the last prize). 27 = Ryo prize, 12047 = essence total, 14112 = piece.
    events = []; prizes = []
    for g in groups:
        bounty_id, (rkind, rmould, rq) = choose_row(g)
        # random_patch_id must be -1 for every Mudra prize: HeroRecruitSuccess(Ten)
        # shows any other id as a CHARACTER card; the piece itself goes in
        # new_reward_object via the events below (14112 / 12047 / 27).
        prizes.append((-1, bounty_id))
        if rkind == 66:
            if str(rmould) not in data.tabela('ship_metal_mould.txt') or rq != 1:
                raise ValueError('peca_ausente')
            rid = db._conn.execute('INSERT INTO local_metals(conta_id, mould) VALUES (?,?)', (account, rmould)).lastrowid
            events += change_tokens(db, account, [metal(db, account, wire_id(rid))])
        elif rkind == 67:
            add_essence(db, account, rq)
            events += ['12047', str(essence(db, account))]
        elif rkind == 1:
            db._conn.execute('UPDATE local_campaign SET silver=silver+? WHERE conta_id=?', (rq, account))
            events += ['27', str(rq), str(silver(db, account))]
        else:
            raise ValueError('premio_de_mudra_nao_suportado')
    used[pos] += 1
    today = day()
    r = db._conn.execute('SELECT free_silver, free_gold FROM local_metal_recruit WHERE conta_id=?', (account,)).fetchone()
    fs_day, fg_day = (r if r else (None, None))
    if free and cost_s:
        fs_day = today
    if free and cost_g:
        fg_day = today
    db._conn.execute('INSERT INTO local_metal_recruit VALUES (?,?,?,?,?,?) ON CONFLICT(conta_id) DO UPDATE SET day=excluded.day, used=excluded.used, free_silver=excluded.free_silver, free_gold=excluded.free_gold, draws=excluded.draws',
                     (account, today, ','.join(map(str, used)), fs_day, fg_day, draws + count))
    tokens = events + ['166', str(len(prizes))] + [str(x) for pr in prizes for x in pr]
    return tokens + shop_local.balances(db, account, delta) + recruit_tokens(db, account)


# --------------------------------------------------------------- dispatch --

def execute(server, cmd, seq, text, fallback=None):
    db = server.BANCO
    try:
        account = db.sessao_de(server._sessao_da_conexao())['conta_id']
        fields = server._linhas(text)
        if cmd in ('ship_bounty', 'ship_batch_bounty'):
            if len(fields) < 2 or (cmd, fields[1]) not in DRAWS:
                return fallback(seq, text)
        if not fields or fields[0] != str(db.perfil(account)['user_id']):
            raise ValueError('conta_do_mudra_invalida')
        if not re.fullmatch(r'[0-9A-Za-z:-]{1,100}', fields[-1]):
            raise ValueError('identificador_de_pedido_invalido')
        key = fields[-1]; body = fields[:-1]; signature = cmd + '|' + '|'.join(body[1:])
        import hero_stats_local
        with db._lock, db._conn:
            receipt = db._conn.execute('SELECT signature, reply FROM local_mudra_receipts WHERE conta_id=? AND request_id=?', (account, key)).fetchone()
            if receipt:
                if receipt[0] != signature:
                    raise ValueError('identificador_reutilizado')
                return str(seq) + ' ' + receipt[1].split(' ', 1)[1]
            db._conn.execute('INSERT OR IGNORE INTO local_campaign(conta_id) VALUES (?)', (account,))
            if cmd == 'ship_metal_set':
                if len(body) != 5: raise ValueError('pedido_invalido')
                result = metal_set(db, account, body)
            elif cmd == 'ship_metal_escalate':
                if len(body) != 3: raise ValueError('pedido_invalido')
                result = escalate(db, account, body)
            elif cmd == 'ship_metal_onekey_escalate':
                if len(body) != 4: raise ValueError('pedido_invalido')
                result = onekey(db, account, body)
            elif cmd == 'ship_metal_dissolve':
                if len(body) != 2: raise ValueError('pedido_invalido')
                result = dissolve(db, account, body)
            elif cmd == 'draw_matrix_reward':
                if len(body) != 3: raise ValueError('pedido_invalido')
                result = claim(db, account, body)
            else:
                if len(body) != 2: raise ValueError('pedido_invalido')
                result = draw(db, account, cmd, body[1])
            reply = ' '.join([str(seq), cmd, '0'] + result + hero_stats_local.attribute_tokens(db, account))
            db._conn.execute('INSERT INTO local_mudra_receipts VALUES (?,?,?,?)', (account, key, signature, reply))
        server.log('MUDRA cmd=%s conta=%s pedido=%s' % (cmd, account, '|'.join(body[1:])))
        return reply
    except (server._contas.ErroConta, ValueError, KeyError, IndexError, TypeError) as exc:
        return server.recusa(cmd, seq, str(exc) or 'mudra_indisponivel')


def install(server):
    with server.BANCO._lock, server.BANCO._conn:
        schema(server.BANCO)
    for command in COMMANDS:
        server.MINIMOS[command] = lambda seq, text, cmd=command: execute(server, cmd, seq, text)
    for command in ('ship_bounty', 'ship_batch_bounty'):
        original = server.MINIMOS.get(command)
        if original is not None and not getattr(original, '_mudra', False):
            wrapped = lambda seq, text, cmd=command, orig=original: execute(server, cmd, seq, text, orig)
            wrapped._mudra = True
            server.MINIMOS[command] = wrapped
