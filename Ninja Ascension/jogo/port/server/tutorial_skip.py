"""Authenticated, persistent initial choice; skip grants the complete outcome."""
import time
import initial_tutorial as initial


def install(server):
    db=server.BANCO
    with db._lock,db._conn:
        initial.schema(db)
        db._conn.execute('CREATE TABLE IF NOT EXISTS tutorial_skip_choice (conta_id INTEGER PRIMARY KEY REFERENCES contas(id) ON DELETE CASCADE, skipped INTEGER NOT NULL DEFAULT 1, decided_at INTEGER NOT NULL)')

    def handle(cmd,seq,text):
        try:
            account=db.sessao_de(server._sessao_da_conexao())['conta_id']
            lines=server._linhas(text)
            if lines!=[str(db.perfil(account)['user_id'])]:raise ValueError('perfil_invalido')
            with db._lock,db._conn:
                current=initial.state(db,account)
                if cmd=='tutorial_start':
                    if current not in ('choice','playing'):raise ValueError('tutorial_indisponivel_para_este_perfil')
                    db._conn.execute("UPDATE local_initial_tutorial SET state='playing',updated=? WHERE conta_id=?",(int(time.time()),account))
                else:
                    initial.skip(db,account)
            return ' '.join([str(seq),cmd,'0']+initial.login_tokens(db,account))
        except (server._contas.ErroConta,ValueError,StopIteration) as exc:
            return server.recusa(cmd,seq,str(exc) or 'tutorial_incompativel_com_as_tabelas')

    for cmd in ('tutorial_start','tutorial_skip'):
        server.MINIMOS[cmd]=lambda seq,text,cmd=cmd:handle(cmd,seq,text)
