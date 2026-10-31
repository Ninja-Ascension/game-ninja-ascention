"""Ninja Soul inventory and equipment: original parsers 14130/14131.

This module implements initialization, lock and four equipment seats only.
No invented synthesis, refinement or reward probabilities.
"""
import json
import re
import time
import dados_batalha as data

COMMANDS = ('fight_spirit_init', 'fight_spirit_change', 'fight_spirit_lock')


def schema(db):
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_fight_spirits(id INTEGER PRIMARY KEY AUTOINCREMENT,conta_id INTEGER NOT NULL,mould INTEGER NOT NULL,state TEXT NOT NULL)')
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_fight_spirit_seats(conta_id INTEGER,ship_id INTEGER,seats TEXT NOT NULL,PRIMARY KEY(conta_id,ship_id))')
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_fight_spirit_receipts(conta_id INTEGER,request_id TEXT,signature TEXT,reply TEXT,PRIMARY KEY(conta_id,request_id))')
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_fight_spirit_grants(conta_id INTEGER,grant_id TEXT,ids TEXT,PRIMARY KEY(conta_id,grant_id))')


def owned(db, account):
    return {rid: dict(json.loads(state), mould=mould) for rid, mould, state in db._conn.execute('SELECT id,mould,state FROM local_fight_spirits WHERE conta_id=? ORDER BY id', (account,))}


def seats(db, account):
    return {ship: json.loads(value) for ship, value in db._conn.execute('SELECT ship_id,seats FROM local_fight_spirit_seats WHERE conta_id=?', (account,))}


def tokens(db, account):
    souls = owned(db, account)
    equipped = seats(db, account)
    ship_for = {rid: ship for ship, values in equipped.items() for rid in values if rid > 0}
    result = ['14130', str(len(souls))]
    uid = db.perfil(account)['user_id']
    for rid, state in souls.items():
        row = data.tabela('fight_spirit_mould.txt')[str(state['mould'])]
        result += list(map(str, [rid, uid, ship_for.get(rid, -1), state['mould'], state['level'], state['exp'], state['created'], state['locked'], int(row[3])]))
        result += [state['main'], state['random'], str(state['random_count']), state['random_ids'], '-1', '0', '-1', 'false']
    result += ['14131', json.dumps([dict(shipId=ship, seatInfo=','.join(map(str, values))) for ship, values in equipped.items()], separators=(',', ':'))]
    return result


def bonus(db, account, ship):
    values = seats(db, account).get(ship, [])
    souls = owned(db, account)
    result = {}
    for rid in values:
        if rid <= 0:
            continue
        state = souls[rid]
        for text in (state['main'], state['random']):
            for item in text.split('|'):
                kind, base, strength = item.split(',')
                kind = int(kind)
                result[kind] = result.get(kind, 0) + float(base) + float(strength)
    # Set bonuses are selected by the client from its suit table. They are
    # intentionally not converted into guessed flat attributes here.
    return result


def grant_test_set(db, account, grant_id):
    """Explicit admin test fixture, not a normal random reward generator."""
    existing = db._conn.execute('SELECT ids FROM local_fight_spirit_grants WHERE conta_id=? AND grant_id=?', (account, grant_id)).fetchone()
    if existing:
        return json.loads(existing[0])
    result = []
    for position in range(1, 5):
        row = next(r for r in data.tabela('fight_spirit_mould.txt').values() if r[1] == '1' and int(r[2]) == position and r[3] == '3')
        main = next(r for r in data.tabela('fight_spirit_talent_mould.txt').values() if r[1] == '2' and r[2] == row[5] and r[3] == row[3])
        # Fixed selection from the original library solely for this admin grant;
        # this does not assert any original random probability distribution.
        random = next(r for r in data.tabela('fight_spirit_talent_mould.txt').values() if r[1] == '1' and r[2] == row[4] and r[3] == row[3])
        def attrs(r):
            return '|'.join(item.split(':')[0] + ',0' for item in r[5].split('|'))
        state = dict(level=0, exp=0, created=int(time.time()), locked=0, main=attrs(main), random=attrs(random), random_count=0, random_ids=random[0])
        result.append(db._conn.execute('INSERT INTO local_fight_spirits(conta_id,mould,state) VALUES (?,?,?)', (account, int(row[0]), json.dumps(state))).lastrowid)
    db._conn.execute('INSERT INTO local_fight_spirit_grants VALUES (?,?,?)', (account, grant_id, json.dumps(result)))
    return result


def execute(server, command, seq, text):
    db = server.BANCO
    try:
        account = db.sessao_de(server._sessao_da_conexao())['conta_id']
        f = server._linhas(text)
        if not f or f[0] != str(db.perfil(account)['user_id']):
            raise ValueError('conta_da_soul_invalida')
        with db._lock, db._conn:
            if command == 'fight_spirit_init':
                if len(f) != 1:
                    raise ValueError('pedido_de_soul_invalido')
                return ' '.join([str(seq), command, '0'] + tokens(db, account))
            if len(f) != 4 or not re.fullmatch(r'[0-9A-Za-z:-]{1,100}', f[-1]):
                raise ValueError('pedido_de_soul_invalido')
            key = f[-1]
            signature = command + '|' + '|'.join(f[1:-1])
            receipt = db._conn.execute('SELECT signature,reply FROM local_fight_spirit_receipts WHERE conta_id=? AND request_id=?', (account, key)).fetchone()
            if receipt:
                if receipt[0] != signature:
                    raise ValueError('identificador_reutilizado')
                return str(seq) + ' ' + receipt[1].split(' ', 1)[1]
            souls = owned(db, account)
            if command == 'fight_spirit_lock':
                rid, locked = int(f[1]), int(f[2])
                if rid not in souls or locked not in (0, 1):
                    raise ValueError('soul_ou_estado_invalido')
                state = souls[rid]
                state['locked'] = locked
                state.pop('mould')
                db._conn.execute('UPDATE local_fight_spirits SET state=? WHERE id=? AND conta_id=?', (json.dumps(state), rid, account))
            else:
                import recruitment_local as heroes
                ship = int(f[1])
                if ship not in dict(heroes.all_owned(db, account)):
                    raise ValueError('personagem_nao_pertence_a_conta')
                values = list(map(int, f[2].split(',')))
                if len(values) != 4 or any(v == 0 or v < -1 for v in values) or len([v for v in values if v > 0]) != len(set(v for v in values if v > 0)):
                    raise ValueError('posicoes_de_soul_invalidas')
                for position, rid in enumerate(values, 1):
                    if rid == -1:
                        continue
                    if rid not in souls:
                        raise ValueError('soul_nao_pertence_a_conta')
                    if int(data.tabela('fight_spirit_mould.txt')[str(souls[rid]['mould'])][2]) != position:
                        raise ValueError('soul_na_posicao_incorreta')
                # Equipping an already-used soul transfers it from the former
                # ninja. A soul can occupy exactly one seat in this account.
                for other, previous in seats(db, account).items():
                    if other != ship and any(v > 0 and v in values for v in previous):
                        previous = [-1 if v > 0 and v in values else v for v in previous]
                        db._conn.execute('UPDATE local_fight_spirit_seats SET seats=? WHERE conta_id=? AND ship_id=?', (json.dumps(previous), account, other))
                db._conn.execute('INSERT INTO local_fight_spirit_seats VALUES (?,?,?) ON CONFLICT(conta_id,ship_id) DO UPDATE SET seats=excluded.seats', (account, ship, json.dumps(values)))
            reply = ' '.join([str(seq), command, '0'] + tokens(db, account))
            db._conn.execute('INSERT INTO local_fight_spirit_receipts VALUES (?,?,?,?)', (account, key, signature, reply))
            return reply
    except (server._contas.ErroConta, ValueError, KeyError, IndexError) as exc:
        return server.recusa(command, seq, str(exc))


def install(server):
    with server.BANCO._lock, server.BANCO._conn:
        schema(server.BANCO)
    for command in COMMANDS:
        server.MINIMOS[command] = lambda seq, text, cmd=command: execute(server, cmd, seq, text)
