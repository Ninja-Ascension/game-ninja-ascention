"""Initialize the clan Donation/Research Institute panel from local clan data.

The Naruto client parser 14627 consumes two nine-entry, pipe-separated
science snapshots. The source moulds define the nine tracks; only track 1 is
backed by persistent clan level/experience in this local server today.
"""
COMMAND = 'union_science_init'
PARSER = '14627'
TRACKS = 9


def snapshot(db, account):
    row = db._conn.execute(
        'SELECT c.level,c.exp FROM local_clan_member m JOIN local_clan c ON c.id=m.clan WHERE m.conta_id=?',
        (account,)).fetchone()
    if not row:
        raise ValueError('jogador_sem_cla')
    # Track 1 is clan level; the other tracks start at level 1 and remain at
    # zero XP until their donation rules are implemented.
    union = ['%d,%d,0,0,0,0' % (int(row[0]), int(row[1]))]
    union.extend(['1,0,0,0,0,0'] * (TRACKS - 1))
    personal = ['0,0,0,0,0,0'] * TRACKS
    return '|'.join(union), '|'.join(personal)


def execute(server, seq, text):
    db = server.BANCO
    try:
        account = db.sessao_de(server._sessao_da_conexao())['conta_id']
        fields = server._linhas(text)
        if len(fields) != 2 or fields[0] != str(db.perfil(account)['user_id']):
            raise ValueError('pedido_de_ciencia_do_cla_invalido')
        with db._lock:
            member = db._conn.execute('SELECT clan FROM local_clan_member WHERE conta_id=?', (account,)).fetchone()
            if not member or str(member[0]) != fields[1]:
                raise ValueError('cla_invalido')
            union, personal = snapshot(db, account)
        return ' '.join([str(seq), COMMAND, '0', PARSER, union, personal])
    except (server._contas.ErroConta, ValueError, KeyError, IndexError, TypeError) as exc:
        return server.recusa(COMMAND, seq, str(exc) or 'ciencia_do_cla_indisponivel')


def install(server):
    server.MINIMOS[COMMAND] = lambda seq, text: execute(server, seq, text)
