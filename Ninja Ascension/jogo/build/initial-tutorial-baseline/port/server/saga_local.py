"""Ninja School > Ninja Saga (role biography / 忍列传), following the client.

Client: client/l_digital/cultivate/roleBiography/*.lua.
Parsers: 12668 activated biographies [{biographiesMouldId, biographiesStar}],
12670 {totalAchieveNumber, achieveStatusInfo "0,1,.."}, 12671 chapters
[{index, unlock, canAdvance}], 12672 draw info, 12673 rank, 12674 prize
preview; 32 = one item gained (shows in the draw result), 6024 inventory.

Tables (0-based): biographies_mould 2 marks to activate, 4 chapter,
5 stats, 6 achievement value; biographies_star_mould 1 biography, 2 star,
3 cost, 5 stats; biographies_achieve 1 value needed, 2 unlock type
(1 = chapter param, 2 = star-up of chapter param), 4 stats;
mark_synthesis 1 result, 2 materials. play_config 197 daily draws,
198 free draws, 199-202 buy panel, 203/204 draw tickets, 206 star reset
cost, 207 libraries (scene_reward_ex -> scene_reward_drop), 208 guaranteed
library every N draws, 209/210 extra rewards for advanced draws.
Reconstruction: stats of activated biographies, of their star and of
activated achievements boost every ninja; chapter 1 is open from the start.
"""
import json, secrets, time
import dados_batalha as data

COMMANDS = ('biographies_activate', 'biographies_advance', 'biographies_rebirth', 'biographies_mark_synthesis',
            'biographies_buy_prop', 'biographies_draw', 'biographies_get_extra_reward',
            'biographies_achieve_activate', 'biographies_rank')


def schema(db):
    c = db._conn
    c.execute('CREATE TABLE IF NOT EXISTS local_saga_bio (conta_id INTEGER NOT NULL REFERENCES contas(id) ON DELETE CASCADE, bio INTEGER NOT NULL, star INTEGER NOT NULL DEFAULT 0, PRIMARY KEY(conta_id, bio))')
    c.execute('CREATE TABLE IF NOT EXISTS local_saga_achieve (conta_id INTEGER NOT NULL REFERENCES contas(id) ON DELETE CASCADE, achieve INTEGER NOT NULL, PRIMARY KEY(conta_id, achieve))')
    c.execute('CREATE TABLE IF NOT EXISTS local_saga_draw (conta_id INTEGER PRIMARY KEY REFERENCES contas(id) ON DELETE CASCADE, day TEXT, normal_free INTEGER DEFAULT 0, advance_free INTEGER DEFAULT 0, normal_used INTEGER DEFAULT 0, advance_used INTEGER DEFAULT 0, normal_streak INTEGER DEFAULT 0, advance_streak INTEGER DEFAULT 0, total_advance INTEGER DEFAULT 0, have_get INTEGER DEFAULT 0)')
    c.execute('CREATE TABLE IF NOT EXISTS local_saga_receipts (conta_id INTEGER, request_id TEXT, signature TEXT, reply TEXT, PRIMARY KEY(conta_id, request_id))')


_CFG = {}


def cfg(n):
    if not _CFG:
        from pathlib import Path
        for line in (Path(data.MOULD).parent / 'configs' / 'play_config.txt').read_text(encoding='utf-8').splitlines():
            row = line.split('\t')
            if len(row) > 3:
                _CFG[row[0]] = row[3]
    return _CFG[str(n)]


def triples(text):
    return [tuple(int(float(x)) for x in p.split(',')) for p in text.split('|') if p and p != '-1']


def bio_row(b):
    return data.tabela('biographies_mould.txt')[str(b)]


def star_row(b, star):
    for r in data.tabela('biographies_star_mould.txt').values():
        if r[1] == str(b) and int(r[2]) == star:
            return r
    return None


def day():
    return time.strftime('%Y-%m-%d')


# ----------------------------------------------------------------- state --

def bios(db, account):
    return dict(db._conn.execute('SELECT bio, star FROM local_saga_bio WHERE conta_id=?', (account,)).fetchall())


def achieved(db, account):
    return {r[0] for r in db._conn.execute('SELECT achieve FROM local_saga_achieve WHERE conta_id=?', (account,))}


def achievement_value(db, account):
    return sum(int(bio_row(b)[6]) for b in bios(db, account))


def chapters(db, account):
    done = achieved(db, account)
    unlock, advance = {1}, set()
    for r in data.tabela('biographies_achieve.txt').values():
        if int(r[0]) in done:
            if r[2] == '1':
                unlock.add(int(r[3]))
            elif r[2] == '2':
                advance.add(int(r[3]))
    count = len(data.tabela('biographies_section_mould.txt'))
    return [{'index': i - 1, 'unlock': int(i in unlock), 'canAdvance': int(i in advance)} for i in range(1, count + 1)]


def draw_state(db, account):
    r = db._conn.execute('SELECT day, normal_free, advance_free, normal_used, advance_used, normal_streak, advance_streak, total_advance, have_get FROM local_saga_draw WHERE conta_id=?', (account,)).fetchone()
    keys = ('day', 'normal_free', 'advance_free', 'normal_used', 'advance_used', 'normal_streak', 'advance_streak', 'total_advance', 'have_get')
    s = dict(zip(keys, r)) if r else dict.fromkeys(keys, 0)
    if s['day'] != day():
        s.update(day=day(), normal_free=0, advance_free=0, normal_used=0, advance_used=0)
    return s


def save_draw(db, account, s):
    db._conn.execute('INSERT OR REPLACE INTO local_saga_draw VALUES (?,?,?,?,?,?,?,?,?,?)',
                     (account, s['day'], s['normal_free'], s['advance_free'], s['normal_used'], s['advance_used'],
                      s['normal_streak'], s['advance_streak'], s['total_advance'], s['have_get']))


def draw_info(db, account):
    s = draw_state(db, account); free = [int(x) for x in cfg(198).split(',')]
    limits = [int(x) for x in cfg(197).split(',')]
    return {'normalDrawFreeNumber': max(0, free[0] - s['normal_free']), 'advanceDrawFreeNumber': max(0, free[1] - s['advance_free']),
            'normalDrawMaxNumber': max(0,limits[0]-s['normal_used']), 'advanceDrawMaxNumber': max(0,limits[1]-s['advance_used']),
            'totalAdvanceDrawNumber': s['total_advance'], 'haveGet': s['have_get']}


def rank(db, account):
    show, minimum = (int(x) for x in cfg(205).split(','))
    import profile_local
    rows = []
    for (conta,) in db._conn.execute('SELECT DISTINCT conta_id FROM local_saga_bio').fetchall():
        v = achievement_value(db, conta)
        if v >= minimum:
            p = db.perfil(conta)
            rows.append({'nickName': p['user_name'].replace(' ', ' '), 'headPic': profile_local.head(db, conta),
                         'serverNumber': 1, 'activateNumber': v, 'userId': p['user_id']})
    rows.sort(key=lambda r: -r['activateNumber'])
    for i, r in enumerate(rows, 1):
        r['rankNumber'] = i
    mine = next((r['rankNumber'] for r in rows if r['userId'] == db.perfil(account)['user_id']), -1)
    return {'allRankInfo': rows[:show], 'myRankNumber': mine}


def preview():
    out = {}
    for name, lib in (('normal', cfg(207).split(',')[0]), ('advance', cfg(207).split(',')[2])):
        shown = data.tabela('scene_reward_ex.txt')[lib][2]
        out[name] = '|'.join('%s,%s,%s' % (k, m, n) for m, k, n in (p.split(',') for p in shown.split('|') if p))
    return out


def j(v):
    return json.dumps(v, separators=(',', ':'), ensure_ascii=False)


def init_tokens(db, account):
    status = ','.join('1' if int(r[0]) in achieved(db, account) else '0'
                      for r in sorted(data.tabela('biographies_achieve.txt').values(), key=lambda r: int(r[0])))
    return ['12668', j([{'biographiesMouldId': b, 'biographiesStar': s} for b, s in sorted(bios(db, account).items())]),
            '12670', j({'totalAchieveNumber': achievement_value(db, account), 'achieveStatusInfo': status}),
            '12671', j(chapters(db, account)), '12672', j(draw_info(db, account)),
            '12673', j(rank(db, account)), '12674', j(preview())]


def bonus(db, account):
    out = []
    with db._lock:
        for b, star in bios(db, account).items():
            for k, v in triples_pairs(bio_row(b)[5]):
                out.append((k, v))
            sr = star_row(b, star)
            for k, v in triples_pairs(sr[5] if sr else '-1'):
                out.append((k, v))
        for a in achieved(db, account):
            for k, v in triples_pairs(data.tabela('biographies_achieve.txt')[str(a)][4]):
                out.append((k, v))
    return out


def triples_pairs(text):
    if not text or text == '-1':
        return []
    return [(int(k), float(v)) for k, v in (p.split(',') for p in text.split('|') if p)]


# ------------------------------------------------------------ operations --

def item_count(db, account, prop):
    r = db._conn.execute('SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=?', (account, prop)).fetchone()
    return r[0] if r else 0


def give_item(db, account, prop, n):
    if str(prop) not in data.tabela('prop_mould.txt'):
        raise ValueError('item_ausente')
    db._conn.execute('INSERT INTO local_inventory VALUES (?,?,?,?) ON CONFLICT(conta_id,mould) DO UPDATE SET quantity=quantity+excluded.quantity',
                     (account, prop, account * 1000000 + prop, n))


def pay(db, account, costs, times=1):
    out = []
    for kind, ident, count in costs:
        count *= times
        if kind == 6:
            if item_count(db, account, ident) < count:
                raise ValueError('marcas_insuficientes')
            db._conn.execute('UPDATE local_inventory SET quantity=quantity-? WHERE conta_id=? AND mould=?', (count, account, ident))
        elif kind == 1:
            have = db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?', (account,)).fetchone()
            if not have or have[0] < count:
                raise ValueError('ryo_insuficiente')
            db._conn.execute('UPDATE local_campaign SET silver=silver-? WHERE conta_id=?', (count, account))
            out += ['22', str(have[0] - count)]
        elif kind == 2:
            have = db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?', (account,)).fetchone()
            if not have or have[0] < count:
                raise ValueError('gold_insuficiente')
            db._conn.execute('UPDATE local_resources SET gold=gold-? WHERE conta_id=?', (count, account))
            out += ['25', str(-count), str(have[0] - count)]
        else:
            raise ValueError('custo_nao_suportado')
    return out


def reward_window(rewards):
    return ['171', '7', str(len(rewards))] + [str(x) for kind, ident, n in rewards for x in (ident if kind == 6 else -1, kind, n)]


def give(db, account, rewards):
    out = []
    for kind, ident, n in rewards:
        if kind == 6:
            give_item(db, account, ident, n)
        elif kind == 1:
            db._conn.execute('UPDATE local_campaign SET silver=silver+? WHERE conta_id=?', (n, account))
            out += ['22', str(db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?', (account,)).fetchone()[0])]
        else:
            raise ValueError('recompensa_nao_suportada')
    return out


def chapter_of(b):
    return int(bio_row(b)[4])


def activate(db, account, b):
    if b in bios(db, account):
        raise ValueError('saga_ja_ativada')
    if not chapters(db, account)[chapter_of(b) - 1]['unlock']:
        raise ValueError('capitulo_bloqueado')
    out = pay(db, account, triples(bio_row(b)[2]))
    db._conn.execute('INSERT INTO local_saga_bio VALUES (?,?,0)', (account, b))
    return out


def advance(db, account, b):
    have = bios(db, account)
    if b not in have:
        raise ValueError('saga_nao_ativada')
    if not chapters(db, account)[chapter_of(b) - 1]['canAdvance']:
        raise ValueError('estrelas_do_capitulo_bloqueadas')
    nxt = star_row(b, have[b] + 1)
    if not nxt:
        raise ValueError('saga_no_maximo')
    out = pay(db, account, triples(nxt[3]))
    db._conn.execute('UPDATE local_saga_bio SET star=star+1 WHERE conta_id=? AND bio=?', (account, b))
    return out


def rebirth(db, account, b):
    have = bios(db, account)
    if have.get(b, 0) <= 0:
        raise ValueError('nada_para_redefinir')
    out = pay(db, account, triples(cfg(206)))
    refund = {}
    for star in range(1, have[b] + 1):
        for kind, ident, n in triples(star_row(b, star)[3]):
            refund[(kind, ident)] = refund.get((kind, ident), 0) + n
    rewards = [(k, i, n) for (k, i), n in refund.items()]
    out += give(db, account, rewards)
    db._conn.execute('UPDATE local_saga_bio SET star=0 WHERE conta_id=? AND bio=?', (account, b))
    return out + reward_window(rewards)


def synthesis(db, account, prop):
    row = next((r for r in data.tabela('mark_synthesis.txt').values() if int(r[1].split(',')[1]) == prop), None)
    if not row:
        raise ValueError('marca_sem_receita')
    out = pay(db, account, triples(row[2]))
    reward = triples(row[1])
    give(db, account, reward)
    return out + reward_window(reward)


def buy(db, account, kind, size, count):
    if kind not in (0, 1) or size not in (0, 1) or not 1 <= count <= (999 if size == 0 else 99):
        raise ValueError('compra_invalida')
    cost, gain = cfg(199 + 2 * kind + size).split('|')
    out = pay(db, account, triples(cost), count)
    reward = [(k, i, n * count) for k, i, n in triples(gain)]
    give(db, account, reward)
    return out + reward_window(reward)


_DROPS = {}


def drop_groups():
    """scene_reward_drop indexed by library group (built once)."""
    if not _DROPS:
        for r in data.tabela('scene_reward_drop.txt').values():
            _DROPS.setdefault(r[1], []).append(r)
    return _DROPS


def roll_library(lib):
    """scene_reward_ex row -> scene_reward_drop groups -> one prize (kind, id, n)."""
    prizes = []
    for part in data.tabela('scene_reward_ex.txt')[str(lib)][6].split('|'):
        group, times = part.split(',')
        rows = drop_groups().get(group, [])
        for r in rows:
            entries = [e.split(',') for e in r[4].split('|') if e]
            for _ in range(int(times.split('-')[0]) * int(r[3])):
                if r[2] == '2':
                    top = max(int(e[3].split('-')[1]) for e in entries)
                    roll = 1 + secrets.randbelow(top)
                    e = next(e for e in entries if int(e[3].split('-')[0]) <= roll <= int(e[3].split('-')[1]))
                    lo, hi = (int(x) for x in e[2].split('-'))
                    prizes.append((int(e[1]), int(e[0]), lo + secrets.randbelow(hi - lo + 1)))
                else:
                    for e in entries:
                        lo, hi = (int(x) for x in e[2].split('-'))
                        prizes.append((int(e[1]), int(e[0]), lo + secrets.randbelow(hi - lo + 1)))
    return prizes


def prop_add_tokens(db, account, prop):
    r = data.tabela('prop_mould.txt')[str(prop)]
    return ['32', str(account * 1000000 + prop), str(prop), '-', '-', r[3], r[8], str(item_count(db, account, prop)),
            r[24] or '0', '-', '0', '0', '0', r[8], '0', str(int(time.time() * 1000))]


def draw(db, account, kind, times):
    if kind not in (0, 1) or times not in (1, 10):
        raise ValueError('sorteio_invalido')
    s = draw_state(db, account)
    name = 'normal' if kind == 0 else 'advance'
    limit = int(cfg(197).split(',')[kind])
    if s[name + '_used'] + times > limit:
        raise ValueError('limite_diario_de_sorteios')
    free_total = int(cfg(198).split(',')[kind])
    out = []
    if times == 1 and s[name + '_free'] < free_total:
        s[name + '_free'] += 1
    else:
        out += pay(db, account, triples(cfg(203 + kind)), times)
    libs = cfg(207).split(','); every = int(cfg(208).split(',')[kind])
    events = []
    for _ in range(times):
        s[name + '_streak'] += 1
        lib = libs[2 * kind + 1] if s[name + '_streak'] >= every else libs[2 * kind]
        if s[name + '_streak'] >= every:
            s[name + '_streak'] = 0
        for pk, pid, pn in roll_library(lib):
            if pk != 6:
                raise ValueError('premio_nao_suportado')
            give_item(db, account, pid, pn)
            events += prop_add_tokens(db, account, pid)
    s[name + '_used'] += times
    if kind == 1:
        s['total_advance'] += times
    save_draw(db, account, s)
    from hero_training_local import inventory_tokens
    return events + inventory_tokens(db, account) + out + ['12672', j(draw_info(db, account))]


def extra_reward(db, account):
    s = draw_state(db, account)
    steps = [int(x) for x in cfg(209).split('|')]
    used = sum(steps[i % len(steps)] for i in range(s['have_get']))
    nxt = s['have_get'] % len(steps)
    if s['total_advance'] - used < steps[nxt]:
        raise ValueError('recompensa_extra_indisponivel')
    reward = [triples(cfg(210))[nxt]]
    out = give(db, account, reward)
    s['have_get'] += 1
    save_draw(db, account, s)
    return out + reward_window(reward) + ['12672', j(draw_info(db, account))]


def achieve(db, account, a):
    row = data.tabela('biographies_achieve.txt')[str(a)]
    if a in achieved(db, account):
        raise ValueError('conquista_ja_ativada')
    if achievement_value(db, account) < int(row[1]):
        raise ValueError('valor_de_conquista_insuficiente')
    db._conn.execute('INSERT INTO local_saga_achieve VALUES (?,?)', (account, a))
    return []


def execute(server, cmd, seq, text):
    import re, hero_stats_local
    from hero_training_local import inventory_tokens
    db = server.BANCO
    try:
        account = db.sessao_de(server._sessao_da_conexao())['conta_id']
        fields = server._linhas(text)
        if not fields or fields[0] != str(db.perfil(account)['user_id']):
            raise ValueError('conta_da_saga_invalida')
        if cmd == 'biographies_rank':
            with db._lock:
                return ' '.join([str(seq), cmd, '0', '12673', j(rank(db, account))])
        if not re.fullmatch(r'[0-9A-Za-z:-]{1,100}', fields[-1]):
            raise ValueError('identificador_de_pedido_invalido')
        key = fields[-1]; body = fields[1:-1]; signature = cmd + '|' + '|'.join(body)
        nums = [int(x) for x in body]
        with db._lock, db._conn:
            receipt = db._conn.execute('SELECT signature, reply FROM local_saga_receipts WHERE conta_id=? AND request_id=?', (account, key)).fetchone()
            if receipt:
                if receipt[0] != signature:
                    raise ValueError('identificador_reutilizado')
                return str(seq) + ' ' + receipt[1].split(' ', 1)[1]
            db._conn.execute('INSERT OR IGNORE INTO local_campaign(conta_id) VALUES (?)', (account,))
            if cmd == 'biographies_activate': result = activate(db, account, nums[0])
            elif cmd == 'biographies_advance': result = advance(db, account, nums[0])
            elif cmd == 'biographies_rebirth': result = rebirth(db, account, nums[0])
            elif cmd == 'biographies_mark_synthesis': result = synthesis(db, account, nums[0])
            elif cmd == 'biographies_buy_prop': result = buy(db, account, *nums[:3])
            elif cmd == 'biographies_draw': result = draw(db, account, *nums[:2])
            elif cmd == 'biographies_get_extra_reward': result = extra_reward(db, account)
            else: result = achieve(db, account, nums[0])
            if cmd != 'biographies_draw':
                result = inventory_tokens(db, account) + result
            reply = ' '.join([str(seq), cmd, '0'] + result + init_tokens(db, account) + hero_stats_local.attribute_tokens(db, account))
            db._conn.execute('INSERT INTO local_saga_receipts VALUES (?,?,?,?)', (account, key, signature, reply))
        server.log('SAGA cmd=%s conta=%s pedido=%s' % (cmd, account, '|'.join(body)))
        return reply
    except (server._contas.ErroConta, ValueError, KeyError, IndexError, TypeError, StopIteration) as exc:
        return server.recusa(cmd, seq, str(exc) or 'saga_indisponivel')


def install(server):
    with server.BANCO._lock, server.BANCO._conn:
        schema(server.BANCO)
    for command in COMMANDS:
        server.MINIMOS[command] = lambda seq, text, cmd=command: execute(server, cmd, seq, text)
