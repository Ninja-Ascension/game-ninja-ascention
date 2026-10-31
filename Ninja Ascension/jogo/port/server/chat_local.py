"""Clan chat backed by the local clan membership and chat history tables."""
import html
import re
import time

MAX_MESSAGE_CHARS = 120
HISTORY_LIMIT = 50
_CURSORS = {}


def schema(db):
    db._conn.execute(
        'CREATE TABLE IF NOT EXISTS local_clan_chat ('
        'id INTEGER PRIMARY KEY AUTOINCREMENT, '
        'clan INTEGER NOT NULL, conta_id INTEGER NOT NULL '
        'REFERENCES contas(id) ON DELETE CASCADE, '
        'user_id INTEGER NOT NULL, name TEXT NOT NULL, head INTEGER NOT NULL DEFAULT 0, '
        'content TEXT NOT NULL, created INTEGER NOT NULL)')
    db._conn.execute(
        'CREATE INDEX IF NOT EXISTS idx_local_clan_chat_history '
        'ON local_clan_chat(clan,id)')


def _identity(server, db, text):
    token = server._sessao_da_conexao()
    session = db.sessao_de(token)
    profile = db.perfil(session['conta_id'])
    fields = server._linhas(text)
    if not fields or fields[0].strip() != str(profile['user_id']):
        raise ValueError('perfil_invalido')
    return token, session['conta_id'], profile, fields[1:]


def _membership(db, account):
    import clan_local
    current = clan_local.member(db, account)
    if not current:
        raise ValueError('sem_cla')
    clan = db._conn.execute(
        'SELECT id FROM local_clan WHERE id=?', (current[0],)).fetchone()
    if not clan:
        raise ValueError('cla_indisponivel')
    return int(current[0])


def _decode_message(value):
    value = html.unescape((value or '').replace('&nbsp;', ' ')).replace('\xa0', ' ')
    value = ''.join(ch for ch in value if ch in '\t' or ord(ch) >= 32)
    value = re.sub(r'\s+', ' ', value).strip()
    if not value:
        raise ValueError('mensagem_vazia')
    if len(value) > MAX_MESSAGE_CHARS:
        raise ValueError('mensagem_longa')
    return value


def _wire(value):
    return str(value).replace('&', '&amp;').replace(' ', '&nbsp;')


def _records(db, clan, after_id=0, initial=False):
    if initial:
        rows = db._conn.execute(
            'SELECT id,user_id,name,head,content,created FROM local_clan_chat '
            'WHERE clan=? ORDER BY id DESC LIMIT ?', (clan, HISTORY_LIMIT)).fetchall()
        rows = list(reversed(rows))
    else:
        rows = db._conn.execute(
            'SELECT id,user_id,name,head,content,created FROM local_clan_chat '
            'WHERE clan=? AND id>? ORDER BY id LIMIT ?', (clan, after_id, HISTORY_LIMIT)).fetchall()
    return rows


def _tokens(rows):
    out = ['90', str(len(rows))]
    for row in rows:
        _id, user_id, name, head, content, created = row
        # parse_accept_chat_information consumes exactly eight fields per row.
        out += ['2', '0', str(user_id), _wire(name), '0', str(head), _wire(content), str(created)]
    return out


def handle(server, cmd, seq, text):
    db = server.BANCO
    try:
        token, account, profile, fields = _identity(server, db, text)
        with db._lock, db._conn:
            try:
                clan = _membership(db, account)
            except ValueError:
                if cmd == 'refush_msg':
                    return ' '.join([str(seq), cmd, '0'] + _tokens([]))
                raise
            cursor_key = (token, clan)
            if cmd == 'refush_msg':
                initial = cursor_key not in _CURSORS
                after_id = _CURSORS.get(cursor_key, 0)
                rows = _records(db, clan, after_id=after_id, initial=initial)
                if rows:
                    _CURSORS[cursor_key] = int(rows[-1][0])
                elif initial:
                    latest = db._conn.execute(
                        'SELECT COALESCE(MAX(id),0) FROM local_clan_chat WHERE clan=?',
                        (clan,)).fetchone()[0]
                    _CURSORS[cursor_key] = int(latest)
                return ' '.join([str(seq), cmd, '0'] + _tokens(rows))

            if cmd != 'send_message' or len(fields) < 2 or fields[1].strip() != '2':
                return server.recusa(cmd, seq, 'canal_nao_suportado')
            content = _decode_message(fields[0])
            import profile_local
            name = profile['user_name'] or '-'
            head = profile_local.head(db, account)
            created = int(time.time() * 1000)
            cursor = db._conn.execute(
                'INSERT INTO local_clan_chat(clan,conta_id,user_id,name,head,content,created) '
                'VALUES (?,?,?,?,?,?,?)',
                (clan, account, int(profile['user_id']), name, head, content, created))
            message_id = int(cursor.lastrowid)
            # Keep a bounded history per clan while retaining recent messages.
            db._conn.execute(
                'DELETE FROM local_clan_chat WHERE clan=? AND id NOT IN '
                '(SELECT id FROM local_clan_chat WHERE clan=? ORDER BY id DESC LIMIT 500)',
                (clan, clan))
            _CURSORS[cursor_key] = message_id
            rows = db._conn.execute(
                'SELECT id,user_id,name,head,content,created FROM local_clan_chat WHERE id=?',
                (message_id,)).fetchall()
        server.log('CHAT clan=%s conta=%s caracteres=%s' % (clan, account, len(content)))
        return ' '.join([str(seq), cmd, '0'] + _tokens(rows))
    except (server._contas.ErroConta, ValueError, KeyError, IndexError, TypeError) as exc:
        return server.recusa(cmd, seq, str(exc) or 'chat_indisponivel')


def install(server):
    with server.BANCO._lock, server.BANCO._conn:
        schema(server.BANCO)
    for command in ('send_message', 'refush_msg'):
        server.MINIMOS[command] = lambda seq, text, cmd=command: handle(server, cmd, seq, text)
