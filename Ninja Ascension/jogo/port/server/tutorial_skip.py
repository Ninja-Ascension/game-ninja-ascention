"""tutorial_skip.py — handler para protocolo tutorial_skip (9993).

Persiste a decisao do jogador de pular o tutorial. O cliente envia apenas o
user_id; o servidor valida a sessao, marca a conta como "decidida" e responde
com ACK de sucesso. A flag e lida pelo login_init para nao mostrar a tela
novamente e para liberar as recompensas do tutorial sem executar as missoes.

Idempotente: reenviar o mesmo pedido nao altera o estado nem concede
recompensas duplicadas.
"""


def install(server):
    db = server.BANCO
    with db._lock, db._conn:
        db._conn.execute(
            'CREATE TABLE IF NOT EXISTS tutorial_skip_choice ('
            'conta_id INTEGER PRIMARY KEY REFERENCES contas(id) ON DELETE CASCADE,'
            'skipped INTEGER NOT NULL DEFAULT 1,'
            'decided_at INTEGER NOT NULL)'
        )

    def handle(seq, text):
        try:
            lines = server._linhas(text)
            session = db.sessao_de(server._sessao_da_conexao())
            account = session['conta_id']
            perfil = db.perfil(account)
            if not lines or lines[0].strip() != str(perfil['user_id']):
                raise ValueError('perfil_invalido')
            import time
            now = int(time.time())
            with db._lock, db._conn:
                existing = db._conn.execute(
                    'SELECT skipped FROM tutorial_skip_choice WHERE conta_id=?',
                    (account,)
                ).fetchone()
                if existing is None:
                    db._conn.execute(
                        'INSERT INTO tutorial_skip_choice (conta_id, skipped, decided_at) VALUES (?, 1, ?)',
                        (account, now)
                    )
                # Se ja existe, nao altera nada (idempotente).
                db._conn.commit()
            server.log('tutorial_skip conta_id=%s user_id=%s -> pulado' % (account, perfil['user_id']))
            return '%s tutorial_skip 0' % seq
        except (server._contas.ErroConta, ValueError) as exc:
            return server.recusa('tutorial_skip', seq, str(exc))

    server.MINIMOS['tutorial_skip'] = handle