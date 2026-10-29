"""Clan (union) core: list/search, create, apply/one-key join, approvals,
members, posts/kick, exit/dismiss, notice and settings, messages.

Client parsers (ProtocolParserCopy.lua, Naruto branch): 1001 union_init (14),
1002 union_list (max, pages, n, 13 per clan), 238 members (12 + 3 per member),
239 user clan info (10), 245 applications (9 per entry), 246 clan log
(n, 5 per entry). union_config: 1 create cost (gold), 8 max open applications,
12 clans per page. Posts: 1 leader, 2 vice, 3 member.
Not implemented here: clan battles, copies, shop extras, science, red packets.
"""
import time
import dados_batalha as data

COMMANDS = ('union_init', 'union_list', 'union_search', 'union_create', 'union_apply', 'union_one_key_join',
            'union_examine_list', 'union_persion_manage', 'union_persion_list', 'union_appoint', 'union_exit',
            'union_dismiss', 'union_message', 'union_setting_manage', 'union_content_update', 'union_order')
MAX_MEMBERS = 30


def schema(db):
    c = db._conn
    c.execute('CREATE TABLE IF NOT EXISTS local_clan (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT UNIQUE NOT NULL, icon INTEGER NOT NULL DEFAULT 1, level INTEGER NOT NULL DEFAULT 1, exp INTEGER NOT NULL DEFAULT 0, notice TEXT NOT NULL DEFAULT "-", declaration TEXT NOT NULL DEFAULT "-", verify INTEGER NOT NULL DEFAULT 0, need_level INTEGER NOT NULL DEFAULT 0, need_fight INTEGER NOT NULL DEFAULT 0, created INTEGER NOT NULL)')
    c.execute('CREATE TABLE IF NOT EXISTS local_clan_member (conta_id INTEGER PRIMARY KEY REFERENCES contas(id) ON DELETE CASCADE, clan INTEGER NOT NULL, post INTEGER NOT NULL DEFAULT 3, contribution INTEGER NOT NULL DEFAULT 0, joined INTEGER NOT NULL)')
    c.execute('CREATE TABLE IF NOT EXISTS local_clan_apply (conta_id INTEGER NOT NULL REFERENCES contas(id) ON DELETE CASCADE, clan INTEGER NOT NULL, at INTEGER NOT NULL, PRIMARY KEY(conta_id, clan))')
    c.execute('CREATE TABLE IF NOT EXISTS local_clan_log (clan INTEGER NOT NULL, kind INTEGER NOT NULL, name TEXT NOT NULL, v1 TEXT NOT NULL, v2 TEXT NOT NULL, at INTEGER NOT NULL)')
    c.execute('CREATE TABLE IF NOT EXISTS local_clan_membership (conta_id INTEGER PRIMARY KEY, clan_id INTEGER, clan_name TEXT)')


_CFG = {}


def cfg(n):
    if not _CFG:
        from pathlib import Path
        for line in (Path(data.MOULD).parent / 'configs' / 'union_config.txt').read_text(encoding='utf-8').splitlines():
            row = line.split('\t')
            if len(row) > 3:
                _CFG[row[0]] = row[3]
    return _CFG[str(n)]


def now_ms():
    return int(time.time() * 1000)


def wire(text):
    return (text or '-').replace('&', '&amp;').replace(' ', '&nbsp;') or '-'


def unwire(text):
    import html
    return html.unescape((text or '').replace('&nbsp;', ' ')).strip()


def member(db, account):
    return db._conn.execute('SELECT clan, post, contribution FROM local_clan_member WHERE conta_id=?', (account,)).fetchone()


def clan(db, cid):
    r = db._conn.execute('SELECT id,name,icon,level,exp,notice,declaration,verify,need_level,need_fight FROM local_clan WHERE id=?', (cid,)).fetchone()
    return dict(zip(('id', 'name', 'icon', 'level', 'exp', 'notice', 'declaration', 'verify', 'need_level', 'need_fight'), r)) if r else None


def members(db, cid):
    return db._conn.execute('SELECT conta_id, post, contribution FROM local_clan_member WHERE clan=? ORDER BY post, joined', (cid,)).fetchall()


def grade(db, account):
    r = db._conn.execute('SELECT grade FROM local_campaign WHERE conta_id=?', (account,)).fetchone()
    return r[0] if r else 1


def name_of(db, account):
    return db.perfil(account)['user_name']


def log(db, cid, kind, name, v1='-', v2='-'):
    db._conn.execute('INSERT INTO local_clan_log VALUES (?,?,?,?,?,?)', (cid, kind, wire(name), str(v1), str(v2), now_ms()))


def sync_membership(db, account):
    m = member(db, account)
    if m:
        db._conn.execute('INSERT OR REPLACE INTO local_clan_membership VALUES (?,?,?)', (account, m[0], clan(db, m[0])['name']))
    else:
        db._conn.execute('DELETE FROM local_clan_membership WHERE conta_id=?', (account,))


def ranked(db):
    rows = db._conn.execute('SELECT id FROM local_clan ORDER BY level DESC, exp DESC, id').fetchall()
    return [r[0] for r in rows]


# ---------------------------------------------------------------- tokens --

def init_tokens(db, account):
    m = member(db, account)
    if not m:
        return ['1001', '0', '0', '0', '0', '-', '-', '-', '0', '0', '0', '0', '0', '0', '0']
    c = clan(db, m[0])
    rank = ranked(db).index(c['id']) + 1
    return (['1001', str(c['id']), str(c['level']), str(c['icon']), '0', wire(c['name']), wire(c['notice']), wire(c['declaration']),
             str(len(members(db, c['id']))), str(c['exp']), '0', '0', '0', str(c['verify']), str(rank)]
            + ['239', str(m[1]), str(m[2]), '0', '0', '0', '0', '0', str(now_ms()), '0', '0']
            + science_tokens())


def science_tokens():
    """14627 research institute: level 1, no exp, no donations (not implemented).
    Each entry is "union part" + "my part" -> "level,exp,count,my_count"."""
    n = len(data.tabela('union_science_mould.txt'))
    return ['14627', '|'.join(['1,0,0'] * n), '|'.join(['0'] * n)]


def list_tokens(db, account, ids, page_size):
    applied = {r[0] for r in db._conn.execute('SELECT clan FROM local_clan_apply WHERE conta_id=?', (account,))}
    order = ranked(db)
    out = ['1002', str(len(order)), str(max(1, (len(order) + page_size - 1) // page_size)), str(len(ids))]
    for cid in ids:
        c = clan(db, cid); ms = members(db, cid)
        leader = next((a for a, p, _ in ms if p == 1), ms[0][0] if ms else None)
        out += [str(order.index(cid) + 1), str(cid), wire(c['name']), str(c['level']), str(c['icon']), '0',
                wire(name_of(db, leader) if leader else '-'), str(len(ms)), wire(c['declaration']), str(c['verify']), '0',
                str(int(cid in applied)), '0']
    return out


def member_tokens(db, cid):
    import profile_local
    ms = members(db, cid)
    out = ['238', str(len(ms))]
    for a, post, contrib in ms:
        p = db.perfil(a)
        out += [str(p['user_id']), wire(p['user_name']), str(grade(db, a)), str(profile_local.head(db, a)), '0', '0', '0',
                str(post), '0', str(contrib), str(contrib), '0', '0', '-1', '-1']
    return out


def apply_tokens(db, cid):
    import profile_local
    rows = db._conn.execute('SELECT conta_id, at FROM local_clan_apply WHERE clan=? ORDER BY at', (cid,)).fetchall()
    out = ['245', str(len(rows))]
    for a, at in rows:
        p = db.perfil(a)
        out += [str(p['user_id']), str(profile_local.head(db, a)), '0', wire(p['user_name']), str(grade(db, a)), '0', '0', '0', str(at)]
    return out


def log_tokens(db, cid):
    rows = db._conn.execute('SELECT kind,name,v1,v2,at FROM local_clan_log WHERE clan=? ORDER BY at DESC LIMIT 50', (cid,)).fetchall()
    out = ['246', str(len(rows))]
    for r in rows:
        out += [str(x) for x in r]
    return out


def order_tokens(db, account, first, last, kind):
    """14601 parse_red_alert_union_rank (Naruto branch)."""
    import ranking_local
    order = ranked(db)
    def leader(cid):
        ms = members(db, cid)
        return next((a for a, p, _ in ms if p == 1), ms[0][0] if ms else None)
    def fight(cid):
        return sum(ranking_local.power(db, a) for a, _, _ in members(db, cid))
    m = member(db, account)
    out = ['14601', str(kind), str(m[0] if m else 0)]
    if m:
        c = clan(db, m[0]); l = leader(c['id'])
        out += [str(order.index(c['id']) + 1), str(c['icon']), str(c['level']), wire(c['name']),
                wire(name_of(db, l) if l else '-'), str(fight(c['id']))]
    part = order[max(0, first - 1):max(first, last)]
    out.append(str(len(part)))
    for i, cid in enumerate(part, max(1, first)):
        c = clan(db, cid); l = leader(cid)
        out += [str(i), str(i), str(cid), wire(c['name']), str(c['level']), str(c['exp']), '0',
                wire(name_of(db, l) if l else '-'), str(len(members(db, cid))), '0', wire(c['declaration']),
                str(c['verify']), str(c['need_level']), str(c['need_fight']), str(fight(cid)), str(c['icon']), '0']
    return out


# ------------------------------------------------------------ operations --

def account_by_uid(db, uid):
    r = db._conn.execute('SELECT conta_id FROM perfis WHERE user_id=?', (int(uid),)).fetchone()
    if not r:
        raise ValueError('jogador_inexistente')
    return r[0]


def need_post(db, account, posts):
    m = member(db, account)
    if not m or m[1] not in posts:
        raise ValueError('sem_permissao_no_cla')
    return m


def join(db, account, cid):
    if member(db, account):
        raise ValueError('ja_esta_em_um_cla')
    if len(members(db, cid)) >= MAX_MEMBERS:
        raise ValueError('cla_cheio')
    db._conn.execute('INSERT INTO local_clan_member VALUES (?,?,3,0,?)', (account, cid, now_ms()))
    db._conn.execute('DELETE FROM local_clan_apply WHERE conta_id=?', (account,))
    sync_membership(db, account)
    log(db, cid, 1, name_of(db, account))


def apply(db, account, cid):
    c = clan(db, cid)
    if not c:
        raise ValueError('cla_inexistente')
    if member(db, account):
        raise ValueError('ja_esta_em_um_cla')
    if grade(db, account) < c['need_level']:
        raise ValueError('nivel_insuficiente')
    if not c['verify']:
        join(db, account, cid)
        return
    open_ = db._conn.execute('SELECT COUNT(*) FROM local_clan_apply WHERE conta_id=?', (account,)).fetchone()[0]
    if open_ >= int(cfg(8)):
        raise ValueError('limite_de_pedidos')
    db._conn.execute('INSERT OR IGNORE INTO local_clan_apply VALUES (?,?,?)', (account, cid, now_ms()))


def create(db, account, name, icon):
    name = unwire(name)
    if member(db, account):
        raise ValueError('ja_esta_em_um_cla')
    if not name or len(name) > int(cfg(6).split(',')[0]):
        raise ValueError('nome_de_cla_invalido')
    if db._conn.execute('SELECT 1 FROM local_clan WHERE lower(name)=lower(?)', (name,)).fetchone():
        raise ValueError('nome_de_cla_em_uso')
    cost = int(cfg(1))
    gold = db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?', (account,)).fetchone()
    if not gold or gold[0] < cost:
        raise ValueError('gold_insuficiente')
    db._conn.execute('UPDATE local_resources SET gold=gold-? WHERE conta_id=?', (cost, account))
    cid = db._conn.execute('INSERT INTO local_clan(name, icon, created) VALUES (?,?,?)', (name, max(1, int(icon)), now_ms())).lastrowid
    db._conn.execute('INSERT INTO local_clan_member VALUES (?,?,1,0,?)', (account, cid, now_ms()))
    db._conn.execute('DELETE FROM local_clan_apply WHERE conta_id=?', (account,))
    sync_membership(db, account)
    log(db, cid, 0, name_of(db, account))
    return ['25', str(-cost), str(gold[0] - cost)]


def leave(db, account, kind=2):
    m = member(db, account)
    if not m:
        raise ValueError('sem_cla')
    cid = m[0]
    db._conn.execute('DELETE FROM local_clan_member WHERE conta_id=?', (account,))
    sync_membership(db, account)
    rest = members(db, cid)
    if not rest:
        db._conn.execute('DELETE FROM local_clan WHERE id=?', (cid,))
        db._conn.execute('DELETE FROM local_clan_apply WHERE clan=?', (cid,))
    elif m[1] == 1:            # leader left: highest post, then contribution
        heir = sorted(rest, key=lambda r: (r[1], -r[2]))[0][0]
        db._conn.execute('UPDATE local_clan_member SET post=1 WHERE conta_id=?', (heir,))
    log(db, cid, kind, name_of(db, account))


def dismiss(db, account):
    m = need_post(db, account, (1,))
    for a, _, _ in members(db, m[0]):
        db._conn.execute('DELETE FROM local_clan_member WHERE conta_id=?', (a,))
        sync_membership(db, a)
    db._conn.execute('DELETE FROM local_clan_apply WHERE clan=?', (m[0],))
    db._conn.execute('DELETE FROM local_clan WHERE id=?', (m[0],))


def review(db, account, uid, kind):
    m = need_post(db, account, (1, 2))
    targets = ([r[0] for r in db._conn.execute('SELECT conta_id FROM local_clan_apply WHERE clan=?', (m[0],))]
               if str(uid) == '-1' else [account_by_uid(db, uid)])
    for t in targets:
        if kind == 1:
            join(db, t, m[0])
        db._conn.execute('DELETE FROM local_clan_apply WHERE conta_id=? AND clan=?', (t, m[0]))


def appoint(db, account, uid, kind):
    m = need_post(db, account, (1, 2))
    target = account_by_uid(db, uid)
    tm = member(db, target)
    if not tm or tm[0] != m[0] or target == account:
        raise ValueError('membro_invalido')
    if tm[1] <= m[1]:
        raise ValueError('sem_permissao_no_cla')
    if kind == 3:
        db._conn.execute('DELETE FROM local_clan_member WHERE conta_id=?', (target,))
        sync_membership(db, target)
        log(db, m[0], 3, name_of(db, target))
    elif kind == 1 and m[1] == 1:
        db._conn.execute('UPDATE local_clan_member SET post=2 WHERE conta_id=?', (target,))
    elif kind == 2 and m[1] == 1:
        db._conn.execute('UPDATE local_clan_member SET post=3 WHERE conta_id=?', (target,))
    elif kind == 4 and m[1] == 1:
        db._conn.execute('UPDATE local_clan_member SET post=1 WHERE conta_id=?', (target,))
        db._conn.execute('UPDATE local_clan_member SET post=3 WHERE conta_id=?', (account,))
    else:
        raise ValueError('cargo_invalido')


def execute(server, cmd, seq, text):
    db = server.BANCO
    try:
        account = db.sessao_de(server._sessao_da_conexao())['conta_id']
        f = server._linhas(text)
        body = f[1:] if f and f[0] == str(db.perfil(account)['user_id']) else f
        page = int(cfg(12))
        with db._lock, db._conn:
            out = []
            m = member(db, account)
            if cmd == 'union_init':
                pass
            elif cmd == 'union_list':
                n = max(0, int(body[0]) if body and body[0].lstrip('-').isdigit() else 0)
                order = ranked(db)
                out = list_tokens(db, account, order[n * page:(n + 1) * page] if n else order[:page], page)
            elif cmd == 'union_search':
                q = unwire(body[0] if body else '').lower()
                ids = [cid for cid in ranked(db) if q and (q in clan(db, cid)['name'].lower() or q == str(cid))]
                out = list_tokens(db, account, ids[:page], page)
            elif cmd == 'union_create':
                out = create(db, account, body[0], body[1] if len(body) > 1 else 1)
            elif cmd == 'union_apply':
                apply(db, account, int(body[0]))
                out = list_tokens(db, account, [int(body[0])], page) if clan(db, int(body[0])) else []
            elif cmd == 'union_one_key_join':
                free = [cid for cid in ranked(db) if not clan(db, cid)['verify'] and len(members(db, cid)) < MAX_MEMBERS
                        and grade(db, account) >= clan(db, cid)['need_level']]
                if not free:
                    raise ValueError('nenhum_cla_disponivel')
                join(db, account, free[0])
            elif cmd == 'union_examine_list':
                mm = need_post(db, account, (1, 2)); out = apply_tokens(db, mm[0])
            elif cmd == 'union_persion_manage':
                review(db, account, body[0], int(body[1])); out = apply_tokens(db, member(db, account)[0])
            elif cmd == 'union_persion_list':
                out = member_tokens(db, m[0]) if m else ['238', '0']   # no clan yet: empty list
            elif cmd == 'union_appoint':
                appoint(db, account, body[0], int(body[1])); out = member_tokens(db, member(db, account)[0])
            elif cmd == 'union_exit':
                leave(db, account)
            elif cmd == 'union_dismiss':
                dismiss(db, account)
            elif cmd == 'union_message':
                out = log_tokens(db, m[0]) if m else ['246', '0']
            elif cmd == 'union_setting_manage':
                mm = need_post(db, account, (1, 2))
                db._conn.execute('UPDATE local_clan SET notice=?, declaration=?, verify=?, need_level=?, need_fight=? WHERE id=?',
                                 (unwire(body[0]) or '-', unwire(body[1]) or '-', int(body[2]), int(body[3]), int(body[4]), mm[0]))
            elif cmd == 'union_order':
                out = order_tokens(db, account, int(body[0]), int(body[1]), int(body[2]) if len(body) > 2 else 0)
            elif cmd == 'union_content_update':
                mm = need_post(db, account, (1, 2))
                db._conn.execute('UPDATE local_clan SET notice=? WHERE id=?', (unwire(body[0]) or '-', mm[0]))
            reply = ' '.join([str(seq), cmd, '0'] + out + init_tokens(db, account))
        if cmd not in ('union_init', 'union_list', 'union_search', 'union_persion_list', 'union_message', 'union_examine_list'):
            server.log('CLA cmd=%s conta=%s pedido=%s' % (cmd, account, '|'.join(body)))
        return reply
    except (server._contas.ErroConta, ValueError, KeyError, IndexError, TypeError) as exc:
        return server.recusa(cmd, seq, str(exc) or 'cla_indisponivel')


def install(server):
    with server.BANCO._lock, server.BANCO._conn:
        schema(server.BANCO)
    for command in COMMANDS:
        server.MINIMOS[command] = lambda seq, text, cmd=command: execute(server, cmd, seq, text)
    import clan_assistance_local
    clan_assistance_local.install(server)
