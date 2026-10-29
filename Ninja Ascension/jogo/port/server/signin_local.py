"""Monthly sign-in (activity 38, parse_active_activity code 85; claim with
get_activity_reward activity_id, index, x). Entries 1..days-in-month are the
daily rewards; entries after 31 are the cumulative rewards
(SmCheckInInfoWindow.lua claims index = entry - 1 for those).

The original server defined the prizes; the client files do not have them.
They are a local choice in signin_rewards.json (edit freely, restart server).
Only today's day can be signed (no catch-up).
"""
import calendar, json, os, time

ACTIVITY = 38
REWARDS_FILE = os.path.join(os.path.dirname(__file__), 'signin_rewards.json')
DEFAULT = {'daily': {'silver': 20000, 'gold': 10}, 'every_7_days': {'silver': 100000, 'gold': 50},
           'cumulative': [{'days': 7, 'gold': 100}, {'days': 15, 'gold': 200}, {'days': 25, 'gold': 300}]}


def rewards():
    if not os.path.exists(REWARDS_FILE):
        with open(REWARDS_FILE, 'w', encoding='utf8') as f:
            json.dump(DEFAULT, f, indent=2)
    with open(REWARDS_FILE, encoding='utf8') as f:
        return json.load(f)


def schema(db):
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_signin (conta_id INTEGER NOT NULL REFERENCES contas(id) ON DELETE CASCADE, month TEXT NOT NULL, day INTEGER NOT NULL, PRIMARY KEY(conta_id, month, day))')
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_signin_total (conta_id INTEGER NOT NULL REFERENCES contas(id) ON DELETE CASCADE, month TEXT NOT NULL, step INTEGER NOT NULL, PRIMARY KEY(conta_id, month, step))')


def month():
    return time.strftime('%Y-%m')


def day_prize(d):
    r = rewards()
    return r['every_7_days'] if d % 7 == 0 else r['daily']


def tokens(db, account):
    r = rewards(); m = month(); today = time.localtime()
    days = calendar.monthrange(today.tm_year, today.tm_mon)[1]
    signed = {x[0] for x in db._conn.execute('SELECT day FROM local_signin WHERE conta_id=? AND month=?', (account, m))}
    steps = {x[0] for x in db._conn.execute('SELECT step FROM local_signin_total WHERE conta_id=? AND month=?', (account, m))}
    cumulative = r['cumulative']
    nxt = next((c['days'] for i, c in enumerate(cumulative) if i not in steps), cumulative[-1]['days'] if cumulative else 0)
    entries = []
    for d in range(1, 32):
        p = day_prize(d) if d <= days else {}
        entries.append(('Dia&nbsp;%d' % d, p, int(d in signed or d > days), d))
    for i, c in enumerate(cumulative):
        entries.append(('%d&nbsp;dias' % c['days'], c, int(i in steps), c['days']))
    out = ['85', str(ACTIVITY), str(ACTIVITY), '-', '0', '%d,%d' % (len(signed), nxt), str(len(entries))]
    for name, p, done, need in entries:
        out += [name, str(p.get('silver', 0)), str(p.get('gold', 0)), '0', '0', '0', '0', '0', '0', str(done), str(need), '0']
    return out + [str(len(signed)), str(days)]


def claim(db, account, index):
    r = rewards(); m = month(); today = time.localtime()
    if index < 31:
        # the cell may send the day 0- or 1-based; only today is accepted
        d = today.tm_mday if index in (today.tm_mday, today.tm_mday - 1) else -1
        if d < 1:
            raise ValueError('so_o_dia_de_hoje')
        if db._conn.execute('SELECT 1 FROM local_signin WHERE conta_id=? AND month=? AND day=?', (account, m, d)).fetchone():
            raise ValueError('ja_assinado_hoje')
        db._conn.execute('INSERT INTO local_signin VALUES (?,?,?)', (account, m, d))
        prize = day_prize(d)
    else:
        step = index - 31
        if not 0 <= step < len(r['cumulative']):
            raise ValueError('recompensa_inexistente')
        need = r['cumulative'][step]['days']
        count = db._conn.execute('SELECT COUNT(*) FROM local_signin WHERE conta_id=? AND month=?', (account, m)).fetchone()[0]
        if count < need:
            raise ValueError('dias_insuficientes')
        if db._conn.execute('SELECT 1 FROM local_signin_total WHERE conta_id=? AND month=? AND step=?', (account, m, step)).fetchone():
            raise ValueError('recompensa_ja_recebida')
        db._conn.execute('INSERT INTO local_signin_total VALUES (?,?,?)', (account, m, step))
        prize = r['cumulative'][step]
    silver, gold = int(prize.get('silver', 0)), int(prize.get('gold', 0))
    db._conn.execute('INSERT OR IGNORE INTO local_campaign(conta_id) VALUES (?)', (account,))
    db._conn.execute('INSERT OR IGNORE INTO local_resources(conta_id) VALUES (?)', (account,))
    db._conn.execute('UPDATE local_campaign SET silver=silver+? WHERE conta_id=?', (silver, account))
    db._conn.execute('UPDATE local_resources SET gold=gold+? WHERE conta_id=?', (gold, account))
    s = db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?', (account,)).fetchone()[0]
    g = db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?', (account,)).fetchone()[0]
    shown = [x for x in ((-1, 1, silver), (-1, 2, gold)) if x[2] > 0]
    return ['22', str(s), '25', str(gold), str(g), '171', '7', str(len(shown))] + [str(v) for x in shown for v in x]


def execute(server, cmd, seq, text, fallback):
    db = server.BANCO
    try:
        account = db.sessao_de(server._sessao_da_conexao())['conta_id']
        f = server._linhas(text)
        body = f[1:] if f and f[0] == str(db.perfil(account)['user_id']) else f
        if not body or body[0] != str(ACTIVITY):
            return fallback(seq, text) if fallback else server.recusa(cmd, seq, 'atividade_ainda_nao_implementada')
        with db._lock, db._conn:
            out = claim(db, account, int(body[1]))
            reply = ' '.join([str(seq), cmd, '0'] + out + tokens(db, account))
        server.log('SIGN_IN conta=%s indice=%s' % (account, body[1]))
        return reply
    except (server._contas.ErroConta, ValueError, KeyError, IndexError, TypeError) as exc:
        return server.recusa(cmd, seq, str(exc) or 'sign_in_indisponivel')


def install(server):
    with server.BANCO._lock, server.BANCO._conn:
        schema(server.BANCO)
    rewards()
    previous = server.MINIMOS.get('get_activity_reward')
    server.MINIMOS['get_activity_reward'] = lambda seq, text: execute(server, 'get_activity_reward', seq, text, previous)
    original = server.despacha

    def dispatch(text):
        reply = original(text)
        command = text.split('\r\n')[1] if '\r\n' in text else ''
        if command in ('login_init', 'login_init_again') and len(reply.split(' ', 3)) >= 3 and reply.split(' ', 3)[2] == '0':
            try:
                session = server.BANCO.sessao_de(server._sessao_da_conexao())
                with server.BANCO._lock:
                    reply += ' ' + ' '.join(tokens(server.BANCO, session['conta_id']))
            except Exception as exc:
                server.log('SIGN_IN aviso: atividade 38 nao enviada no login (%s)' % exc)
        return reply
    server.despacha = dispatch
