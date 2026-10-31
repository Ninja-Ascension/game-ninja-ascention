"""Guild assistance protocol backed by the original union and reward tables."""
import json
import secrets
import time

import dados_batalha as data

COMMANDS = ('union_assistance_init', 'union_assistance_seek_help',
            'union_assistance_donate', 'union_assistance_all_record')


def schema(db):
    c = db._conn
    c.execute('''CREATE TABLE IF NOT EXISTS local_clan_assistance_request(
        id INTEGER PRIMARY KEY AUTOINCREMENT, clan INTEGER NOT NULL,
        conta_id INTEGER NOT NULL, prop INTEGER NOT NULL, got INTEGER NOT NULL DEFAULT 0,
        created INTEGER NOT NULL)''')
    c.execute('''CREATE TABLE IF NOT EXISTS local_clan_assistance_daily(
        conta_id INTEGER NOT NULL, day TEXT NOT NULL, kind TEXT NOT NULL,
        requests INTEGER NOT NULL DEFAULT 0, reward INTEGER NOT NULL DEFAULT 0,
        PRIMARY KEY(conta_id,day,kind))''')
    c.execute('''CREATE TABLE IF NOT EXISTS local_clan_assistance_record(
        id INTEGER PRIMARY KEY AUTOINCREMENT, clan INTEGER NOT NULL,
        donor INTEGER NOT NULL, beneficiary INTEGER NOT NULL, prop INTEGER NOT NULL,
        at INTEGER NOT NULL)''')


def _day():
    # The game's daily counters are keyed to its local server day.
    return time.strftime('%Y-%m-%d', time.localtime())


def _cfg_map(key):
    raw = __import__('clan_local').cfg(key)
    return {int(pair.split(',')[0]): int(pair.split(',')[1])
            for pair in raw.split('|') if pair}


def _kind(prop):
    row = data.tabela('prop_mould.txt').get(str(prop))
    if not row:
        raise ValueError('fragmento_invalido')
    if len(row) <= 52 or int(row[52] or 0) != 18:
        raise ValueError('item_nao_e_fragmento_de_ajuda')
    ship = int(row[39] or 0)
    if ship > 0:
        mould = data.tabela('ship_mould.txt').get(str(ship))
        if not mould:
            raise ValueError('fragmento_de_ninja_invalido')
        return 'ship', int(mould[8])
    return 'weapon', 0


def _limit(prop):
    kind, ability = _kind(prop)
    if kind == 'weapon':
        return int(__import__('clan_local').cfg(70)), kind
    limits = _cfg_map(66)
    if ability not in limits:
        raise ValueError('limite_de_ajuda_ausente')
    return limits[ability], kind


def _profile(db, account):
    p = db.perfil(account)
    import profile_local
    return p, profile_local.head(db, account)


def _row(db, req):
    import clan_local
    p, head = _profile(db, req[1])
    return {'userId': int(p['user_id']), 'userName': clan_local.wire(p['user_name']),
            'headPic': head, 'askTime': int(req[5]),
            'askPropId': int(req[3]), 'gotPropNum': int(req[4])}


def _info(db, account):
    import clan_local
    m = clan_local.member(db, account)
    if not m:
        raise ValueError('sem_cla')
    cid = m[0]
    now = _day()
    daily = {r[0]: int(r[1]) for r in db._conn.execute(
        'SELECT kind,reward FROM local_clan_assistance_daily WHERE conta_id=? AND day=?',
        (account, now))}
    requests = {r[0]: int(r[1]) for r in db._conn.execute(
        'SELECT kind,requests FROM local_clan_assistance_daily WHERE conta_id=? AND day=?',
        (account, now))}
    ship_reward = sum(v for k, v in daily.items() if k.startswith('ship:'))
    weapon_reward = daily.get('weapon', 0)
    today_ms = int(time.time()*1000) - 86400000
    mine = db._conn.execute(
        'SELECT id,clan,conta_id,prop,got,created FROM local_clan_assistance_request '
        'WHERE clan=? AND conta_id=? AND created>=? ORDER BY created DESC',
        (cid, account, today_ms)).fetchall()
    all_rows = db._conn.execute(
        'SELECT id,clan,conta_id,prop,got,created FROM local_clan_assistance_request '
        'WHERE clan=? AND created>=? ORDER BY created DESC',
        (cid, today_ms)).fetchall()
    my_ids = {r[0] for r in mine}
    active = any(r[4] < _limit(r[3])[0] for r in mine)
    eligible = False
    for mould, in db._conn.execute(
            'SELECT mould FROM local_inventory WHERE conta_id=? AND quantity>0', (account,)):
        try:
            cap, category = _limit(mould)
        except ValueError:
            continue
        _, ability = _kind(mould)
        key = 'ship:%s' % ability if category == 'ship' else 'weapon'
        if requests.get(key, 0) < cap:
            eligible = True
            break
    return {'assistanceInfo': [_row(db, r) for r in all_rows if r[0] not in my_ids],
            'myAssistanceInfo': [_row(db, r) for r in mine],
            'rewardNumShip': ship_reward,
            'rewardNumEquipment': weapon_reward,
            'userState': int(eligible and not active),
            'contribution': int(m[2])}


def _reward76(db, account):
    # scene_reward_ex references drop table 76; parse the original guaranteed
    # group rather than duplicating or inventing its contents.
    ex = data.tabela('scene_reward_ex.txt').get('76')
    if not ex or len(ex) <= 6:
        raise ValueError('recompensa_76_ausente')
    drop_id = int(ex[6].split('-')[0].split(',')[0])
    drop = data.tabela('scene_reward_drop.txt').get(str(drop_id))
    if not drop:
        raise ValueError('recompensa_76_ausente')
    rewards = []
    for entry in drop[4].split('|'):
        if not entry:
            continue
        ident, kind, amount, chance = entry.split(',')
        lo, hi = map(int, amount.split('-'))
        cn, cd = map(int, chance.split('-'))
        if cd <= 0 or not 0 <= cn <= cd:
            raise ValueError('probabilidade_de_recompensa_invalida')
        if secrets.randbelow(cd) < cn:
            rewards.append((int(ident), int(kind), lo if hi == lo else lo + secrets.randbelow(hi-lo+1)))
    for ident, kind, amount in rewards:
        if kind == 1:
            db._conn.execute('UPDATE local_campaign SET silver=silver+? WHERE conta_id=?', (amount, account))
        elif kind == 2:
            db._conn.execute('UPDATE local_resources SET gold=gold+? WHERE conta_id=?', (amount, account))
        elif kind == 6:
            db._conn.execute('INSERT INTO local_inventory VALUES (?,?,?,?) '
                             'ON CONFLICT(conta_id,mould) DO UPDATE SET quantity=quantity+excluded.quantity',
                             (account, ident, account*1000000+ident, amount))
        elif kind == 34:
            import ninja_school_local
            s = ninja_school_local.state(db, account)
            s['talentPoints'] = int(s.get('talentPoints', 0)) + amount
            ninja_school_local.save(db, account, s)
        else:
            raise ValueError('tipo_de_recompensa_76_nao_suportado')
    return rewards


def _tokens(db, account, rewards=None):
    import clan_local, hero_training_local
    out = ['14679', json.dumps(_info(db, account), ensure_ascii=False, separators=(',', ':'))]
    m = clan_local.member(db, account)
    out += clan_local.init_tokens(db, account)
    out += hero_training_local.inventory_tokens(db, account)
    silver = db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?', (account,)).fetchone()
    gold = db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?', (account,)).fetchone()
    out += ['22', str(silver[0] if silver else 0), '25', '0', str(gold[0] if gold else 0)]
    if rewards:
        if any(k == 34 for _, k, _ in rewards):
            import ninja_school_local
            out += ['6043', '5', str(ninja_school_local.state(db, account)['talentPoints'])]
        out += ['171', '7', str(len(rewards))]
        for ident, kind, amount in rewards:
            out += [str(ident if kind == 6 else -1), str(kind), str(amount)]
    return out


def execute(server, cmd, seq, text):
    db = server.BANCO
    try:
        account = db.sessao_de(server._sessao_da_conexao())['conta_id']
        f = server._linhas(text)
        uid = str(db.perfil(account)['user_id'])
        if not f or f[0] != uid:
            raise ValueError('perfil_invalido')
        body = f[1:]
        rewards = []
        with db._lock, db._conn:
            import clan_local
            m = clan_local.member(db, account)
            if not m:
                raise ValueError('sem_cla')
            if cmd == 'union_assistance_init':
                pass
            elif cmd == 'union_assistance_all_record':
                records = db._conn.execute(
                    'SELECT donor,beneficiary,prop,at FROM local_clan_assistance_record '
                    'WHERE clan=? ORDER BY at DESC LIMIT 100', (m[0],)).fetchall()
                rows = []
                mine = []
                for donor, beneficiary, prop, at in records:
                    dn = clan_local.wire(db.perfil(donor)['user_name'])
                    bn = clan_local.wire(db.perfil(beneficiary)['user_name'])
                    item = {'time': at, 'donor': dn, 'beneficiary': bn, 'propId': prop}
                    rows.append(item)
                    if donor == account or beneficiary == account:
                        mine.append(item)
                return ' '.join([str(seq), cmd, '0', '14680', json.dumps(
                    {'totalRecord': rows, 'myRecord': mine}, ensure_ascii=False, separators=(',', ':'))]
                    + clan_local.init_tokens(db, account))
            elif cmd == 'union_assistance_seek_help':
                if len(body) != 1:
                    raise ValueError('pedido_de_ajuda_invalido')
                instance_id = int(body[0])
                item = db._conn.execute(
                    'SELECT mould,quantity FROM local_inventory WHERE conta_id=? AND instance_id=? AND quantity>0',
                    (account, instance_id)).fetchone()
                if not item:
                    raise ValueError('fragmento_nao_possuido')
                prop = int(item[0]); cap, kind = _limit(prop)
                day_start = int(time.time()*1000) - 86400000
                mine = db._conn.execute(
                    'SELECT 1 FROM local_clan_assistance_request WHERE conta_id=? AND created>=? LIMIT 1',
                    (account, day_start)).fetchone()
                if mine:
                    raise ValueError('pedido_de_ajuda_ja_aberto')
                ability_key = 'ship:%s' % _kind(prop)[1] if kind == 'ship' else 'weapon'
                asked = db._conn.execute(
                    'SELECT requests FROM local_clan_assistance_daily WHERE conta_id=? AND day=? AND kind=?',
                    (account, _day(), ability_key)).fetchone()
                if asked and asked[0] >= cap:
                    raise ValueError('limite_diario_de_pedidos')
                db._conn.execute('INSERT INTO local_clan_assistance_request(clan,conta_id,prop,created) VALUES (?,?,?,?)',
                                 (m[0], account, prop, int(time.time()*1000)))
                day = _day()
                db._conn.execute('INSERT INTO local_clan_assistance_daily(conta_id,day,kind,requests) VALUES (?,?,?,1) '
                                 'ON CONFLICT(conta_id,day,kind) DO UPDATE SET requests=requests+1',
                                 (account, day, ability_key))
            elif cmd == 'union_assistance_donate':
                if len(body) != 2:
                    raise ValueError('doacao_de_ajuda_invalida')
                beneficiary = clan_local.account_by_uid(db, body[0])
                fields = body[1].split(',')
                if len(fields) != 3 or fields[0] != '6' or int(fields[2]) != 1:
                    raise ValueError('doacao_de_ajuda_invalida')
                prop = int(fields[1])
                if beneficiary == account:
                    raise ValueError('nao_pode_doar_para_si')
                other = clan_local.member(db, beneficiary)
                if not other or other[0] != m[0]:
                    raise ValueError('jogador_fora_do_cla')
                request = db._conn.execute(
                    'SELECT id,got,created FROM local_clan_assistance_request WHERE clan=? AND conta_id=? AND prop=? '
                    'AND created>=? ORDER BY created DESC LIMIT 1',
                    (m[0], beneficiary, prop, int(time.time()*1000)-86400000)).fetchone()
                if not request:
                    raise ValueError('pedido_de_ajuda_ausente')
                cap, kind = _limit(prop)
                if request[1] >= cap:
                    raise ValueError('pedido_de_ajuda_completo')
                own = db._conn.execute('SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=?',
                                       (account, prop)).fetchone()
                if not own or own[0] < 1:
                    raise ValueError('fragmento_insuficiente')
                db._conn.execute('UPDATE local_inventory SET quantity=quantity-1 WHERE conta_id=? AND mould=?', (account, prop))
                db._conn.execute('UPDATE local_clan_assistance_request SET got=got+1 WHERE id=?', (request[0],))
                reward_rate = (_cfg_map(67).get(_kind(prop)[1], 0) if kind == 'ship'
                               else int(__import__('clan_local').cfg(71)))
                cap_reward = int(__import__('clan_local').cfg(68 if kind == 'ship' else 72))
                if kind == 'ship':
                    already = int(db._conn.execute(
                        "SELECT COALESCE(SUM(reward),0) FROM local_clan_assistance_daily "
                        "WHERE conta_id=? AND day=? AND kind LIKE 'ship:%'", (account, _day())).fetchone()[0])
                else:
                    row = db._conn.execute(
                        'SELECT reward FROM local_clan_assistance_daily WHERE conta_id=? AND day=? AND kind=?',
                        (account, _day(), 'weapon')).fetchone()
                    already = int(row[0]) if row else 0
                contribution = min(reward_rate, max(0, cap_reward-already))
                if contribution:
                    db._conn.execute('UPDATE local_clan_member SET contribution=contribution+? WHERE conta_id=?',
                                     (contribution, account))
                reward_key = ('ship:%s' % _kind(prop)[1]) if kind == 'ship' else 'weapon'
                db._conn.execute('INSERT INTO local_clan_assistance_daily(conta_id,day,kind,reward) VALUES (?,?,?,?) '
                                 'ON CONFLICT(conta_id,day,kind) DO UPDATE SET reward=reward+excluded.reward',
                                 (account, _day(), reward_key, contribution))
                db._conn.execute('INSERT INTO local_clan_assistance_record(clan,donor,beneficiary,prop,at) VALUES (?,?,?,?,?)',
                                 (m[0], account, beneficiary, prop, int(time.time()*1000)))
                rewards = _reward76(db, account)
            else:
                raise ValueError('comando_de_ajuda_desconhecido')
            return ' '.join([str(seq), cmd, '0'] + _tokens(db, account, rewards))
    except (server._contas.ErroConta, ValueError, KeyError, IndexError, TypeError) as exc:
        return server.recusa(cmd, seq, str(exc) or 'ajuda_do_cla_indisponivel')


def install(server):
    with server.BANCO._lock, server.BANCO._conn:
        schema(server.BANCO)
    for command in COMMANDS:
        server.MINIMOS[command] = lambda seq, text, cmd=command: execute(server, cmd, seq, text)
