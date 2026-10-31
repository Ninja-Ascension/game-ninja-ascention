"""Friends: list/search/requests plus daily stamina gifts, using original parsers."""
import datetime
import time
from pathlib import Path

COMMANDS = ('friend_update', 'random_user_list', 'search_user', 'friend_request', 'friend_pass', 'friend_del',
            'present_endurance', 'draw_endurance_init', 'draw_endurance')
MAX_FRIENDS = 50


def schema(db):
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_friend (a INTEGER NOT NULL, b INTEGER NOT NULL, since INTEGER NOT NULL, PRIMARY KEY(a, b))')
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_friend_request (sender INTEGER NOT NULL, target INTEGER NOT NULL, at INTEGER NOT NULL, PRIMARY KEY(sender, target))')
    db._conn.execute('''CREATE TABLE IF NOT EXISTS local_friend_endurance (
        id INTEGER PRIMARY KEY AUTOINCREMENT, sender INTEGER NOT NULL, target INTEGER NOT NULL,
        day TEXT NOT NULL, created INTEGER NOT NULL, claimed INTEGER NOT NULL DEFAULT 0,
        UNIQUE(sender,target,day))''')


def account_by_uid(db, uid):
    r = db._conn.execute('SELECT conta_id FROM perfis WHERE user_id=?', (int(uid),)).fetchone()
    if not r:
        raise ValueError('jogador_inexistente')
    return r[0]


def config():
    import dados_batalha as data
    path = Path(data.MOULD).parent / 'configs' / 'friend_config.txt'
    rows = {}
    for line in path.read_text(encoding='utf-8', errors='replace').splitlines():
        f = line.split('\t')
        if len(f) >= 4 and f[0].isdigit():
            rows[int(f[0])] = f[3]
    send_limit = int(rows[3])
    max_receive, reward = map(int, rows[4].split(','))
    return send_limit, max_receive, reward


def game_day():
    # The game day rolls at 05:00 UTC, matching the server's existing energy cycle.
    import energia
    return energia.cycle()[0]


def gift_sent(db, sender, target):
    return bool(db._conn.execute(
        'SELECT 1 FROM local_friend_endurance WHERE sender=? AND target=? AND day=?',
        (sender, target, game_day())).fetchone())


def info(db, a, with_send, viewer=None):
    import profile_local, ranking_local
    p = db.perfil(a)
    g = db._conn.execute('SELECT grade FROM local_campaign WHERE conta_id=?', (a,)).fetchone()
    c = db._conn.execute('SELECT clan_name FROM local_clan_membership WHERE conta_id=?', (a,)).fetchone()
    last = db._conn.execute('SELECT MAX(criada_em) FROM sessoes WHERE conta_id=?', (a,)).fetchone()[0] or 0
    out = [str(p['user_id']), '0', str(profile_local.head(db, a)), '-', profile_local.wire_name(p['user_name']),
           str(g[0] if g else 1), str(ranking_local.power(db, a)), profile_local.wire_name(c[0]) if c else '-']
    if with_send:
        out.append('1' if viewer is not None and gift_sent(db, viewer, a) else '0')
    return out + [str(last)]


def friends(db, account):
    return [r[0] for r in db._conn.execute('SELECT b FROM local_friend WHERE a=? ORDER BY since', (account,))]


def friend_tokens(db, account):
    fs = friends(db, account)
    out = ['69', str(len(fs))]
    for a in fs:
        out += info(db, a, True, account) + ['-1', '-1']
    return out


def request_tokens(db, account):
    rs = [r[0] for r in db._conn.execute('SELECT sender FROM local_friend_request WHERE target=? ORDER BY at', (account,))]
    out = ['378', str(len(rs))]
    for a in rs:
        out += info(db, a, False) + ['-1', '-1']
    return out


def find_tokens(db, ids):
    out = ['67', str(len(ids))]
    for a in ids:
        out += info(db, a, False) + ['-1', '-1']
    return out


def execute(server, cmd, seq, text):
    db = server.BANCO
    try:
        account = db.sessao_de(server._sessao_da_conexao())['conta_id']
        f = server._linhas(text)
        body = f[1:] if f and f[0] == str(db.perfil(account)['user_id']) else f
        with db._lock, db._conn:
            out = []
            if cmd == 'random_user_list':
                mine = set(friends(db, account)) | {account}
                others = [r[0] for r in db._conn.execute('SELECT conta_id FROM perfis ORDER BY RANDOM()') if r[0] not in mine]
                out = find_tokens(db, others[:10])
            elif cmd == 'search_user':
                q = (body[-1] if body else '').replace('&nbsp;', ' ').strip().lower()
                ids = [r[0] for r in db._conn.execute('SELECT conta_id, user_name, user_id FROM perfis')
                       if q and r[0] != account and (q in r[1].lower() or q == str(r[2]))]
                out = find_tokens(db, ids[:10])
            elif cmd == 'friend_request':
                target = account_by_uid(db, body[0])
                if target == account or target in friends(db, account):
                    raise ValueError('pedido_de_amizade_invalido')
                if len(friends(db, account)) >= MAX_FRIENDS:
                    raise ValueError('lista_de_amigos_cheia')
                db._conn.execute('INSERT OR IGNORE INTO local_friend_request VALUES (?,?,?)', (account, target, int(time.time() * 1000)))
            elif cmd == 'friend_pass':
                sender = account_by_uid(db, body[0])
                if not db._conn.execute('SELECT 1 FROM local_friend_request WHERE sender=? AND target=?', (sender, account)).fetchone():
                    raise ValueError('pedido_inexistente')
                db._conn.execute('DELETE FROM local_friend_request WHERE sender=? AND target=?', (sender, account))
                if body[1] == '1':
                    if len(friends(db, account)) >= MAX_FRIENDS or len(friends(db, sender)) >= MAX_FRIENDS:
                        raise ValueError('lista_de_amigos_cheia')
                    now = int(time.time() * 1000)
                    db._conn.execute('INSERT OR IGNORE INTO local_friend VALUES (?,?,?)', (account, sender, now))
                    db._conn.execute('INSERT OR IGNORE INTO local_friend VALUES (?,?,?)', (sender, account, now))
                out = request_tokens(db, account)
            elif cmd == 'friend_del':
                other = account_by_uid(db, body[0])
                db._conn.execute('DELETE FROM local_friend WHERE (a=? AND b=?) OR (a=? AND b=?)', (account, other, other, account))
            elif cmd == 'present_endurance':
                config()
                if len(body) not in (1, 2) or (len(body) == 2 and body[1] != '1'):
                    raise ValueError('pedido_de_stamina_invalido')
                targets = friends(db, account) if body[0] == '-1' else [account_by_uid(db, body[0])]
                if body[0] != '-1' and targets[0] not in friends(db, account):
                    raise ValueError('destinatario_nao_e_amigo')
                now = int(time.time() * 1000)
                for target in targets:
                    sent = db._conn.execute(
                        'SELECT 1 FROM local_friend_endurance WHERE sender=? AND target=? AND day=?',
                        (account, target, game_day())).fetchone()
                    if sent:
                        continue
                    # The source config's value 1 is the per-friend daily cap;
                    # it is not a cap on the number of friends in a bulk send.
                    db._conn.execute('INSERT INTO local_friend_endurance(sender,target,day,created) VALUES (?,?,?,?)',
                                     (account, target, game_day(), now))
                # Parser 198 consumes (friend user_id, sent state); repeat the
                # block for the original "send all" request.
                for target in targets:
                    if gift_sent(db, account, target):
                        out += ['198', str(db.perfil(target)['user_id']), '1']
                if not out:
                    out = ['198', '0', '0']
            elif cmd == 'draw_endurance_init':
                _, max_receive, _ = config()
                today = game_day()
                rows = db._conn.execute(
                    'SELECT id,sender,created,claimed FROM local_friend_endurance WHERE target=? AND day=? ORDER BY id',
                    (account, today)).fetchall()
                claimed = sum(1 for row in rows if row[3])
                out = ['199', str(max(0, max_receive - claimed)), str(len(rows))]
                import profile_local, ranking_local, vip_local
                for gift_id, sender, created, was_claimed in rows:
                    p = db.perfil(sender)
                    grade = db._conn.execute('SELECT grade FROM local_campaign WHERE conta_id=?', (sender,)).fetchone()
                    clan = db._conn.execute('SELECT clan_name FROM local_clan_membership WHERE conta_id=?', (sender,)).fetchone()
                    last = db._conn.execute('SELECT MAX(criada_em) FROM sessoes WHERE conta_id=?', (sender,)).fetchone()[0] or created
                    out += [str(gift_id), str(p['user_id']), vip_local.grade(db, sender),
                            str(profile_local.head(db, sender)), '-1', profile_local.wire_name(p['user_name']),
                            str(grade[0] if grade else 1), str(ranking_local.power(db, sender)),
                            profile_local.wire_name(clan[0]) if clan else '-',
                            str(max(0, int(time.time() * 1000) - int(last))), str(int(bool(was_claimed)))]
            elif cmd == 'draw_endurance':
                _, max_receive, reward = config()
                if len(body) not in (1, 2):
                    raise ValueError('pedido_de_resgate_de_stamina_invalido')
                today = game_day()
                if body[0] == '-1':
                    rows = db._conn.execute(
                        'SELECT id,claimed FROM local_friend_endurance WHERE target=? AND day=? ORDER BY id',
                        (account, today)).fetchall()
                else:
                    ids = [int(x) for x in body[0].split(',') if x]
                    if not ids:
                        raise ValueError('presente_de_stamina_ausente')
                    marks = ','.join('?' for _ in ids)
                    rows = db._conn.execute(
                        f'SELECT id,claimed FROM local_friend_endurance WHERE target=? AND day=? AND id IN ({marks}) ORDER BY id',
                        (account, today, *ids)).fetchall()
                    if len(rows) != len(set(ids)):
                        raise ValueError('presente_de_stamina_invalido')
                claimed_today = db._conn.execute(
                    'SELECT COUNT(*) FROM local_friend_endurance WHERE target=? AND day=? AND claimed=1',
                    (account, today)).fetchone()[0]
                eligible = [gift_id for gift_id, was_claimed in rows if not was_claimed]
                remaining = max(0, max_receive - claimed_today)
                if body[0] == '-1':
                    eligible = eligible[:remaining]
                elif len(eligible) > remaining:
                    raise ValueError('limite_diario_de_resgate_atingido')
                # Claiming an already processed packet is idempotent: it only
                # returns the same removal IDs and never adds stamina twice.
                if eligible:
                    db._conn.executemany('UPDATE local_friend_endurance SET claimed=1 WHERE id=?',
                                         [(gift_id,) for gift_id in eligible])
                    db._conn.execute('INSERT OR IGNORE INTO local_resources(conta_id) VALUES (?)', (account,))
                    db._conn.execute('UPDATE local_resources SET food=food+? WHERE conta_id=?',
                                     (len(eligible) * reward, account))
                all_claimed = claimed_today + len(eligible)
                out = ['200', str(max(0, max_receive - all_claimed)), '1',
                       ','.join(str(gift_id) for gift_id, _ in rows)]
                if eligible:
                    food = db._conn.execute('SELECT food FROM local_resources WHERE conta_id=?', (account,)).fetchone()[0]
                    out += ['29', str(len(eligible) * reward), str(food)]
            if cmd not in ('random_user_list', 'search_user'):
                out += friend_tokens(db, account) + (request_tokens(db, account) if cmd != 'friend_pass' else [])
            reply = ' '.join([str(seq), cmd, '0'] + out)
        if cmd in ('friend_request', 'friend_pass', 'friend_del'):
            server.log('AMIGOS cmd=%s conta=%s pedido=%s' % (cmd, account, '|'.join(body)))
        return reply
    except (server._contas.ErroConta, ValueError, KeyError, IndexError, TypeError) as exc:
        return server.recusa(cmd, seq, str(exc) or 'amigos_indisponivel')


def install(server):
    with server.BANCO._lock, server.BANCO._conn:
        schema(server.BANCO)
    for command in COMMANDS:
        server.MINIMOS[command] = lambda seq, text, cmd=command: execute(server, cmd, seq, text)
