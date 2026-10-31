"""Local online gift: safely close the original UI without inventing rewards.

The recovered content has no verified online-gift reward schedule. Persist
the acknowledgement per account/day; report an empty original reward list.
"""
import datetime
import time

def install(server):
    db=server.BANCO
    with db._lock, db._conn:
        db._conn.execute('CREATE TABLE IF NOT EXISTS local_online_gift (conta_id INTEGER NOT NULL REFERENCES contas(id) ON DELETE CASCADE, day TEXT NOT NULL, PRIMARY KEY(conta_id,day))')
    def draw(seq,text):
        try:
            account=db.sessao_de(server._sessao_da_conexao())['conta_id']
            if server._linhas(text)!=[str(db.perfil(account)['user_id']),'1','1']:
                raise ValueError('pedido_de_presente_invalido')
            today=datetime.datetime.now(datetime.timezone.utc).date()
            with db._lock, db._conn:
                db._conn.execute('INSERT OR IGNORE INTO local_online_gift VALUES (?,?)',(account,today.isoformat()))
            next_time=int(time.time()*1000)+86400000
            server.log('presente online: acervo sem tabela validada; nenhuma recompensa concedida')
            return ' '.join(map(str,[seq,'trigger_scene_surprise',0,12561,5,next_time,12562,0,171,1,0]))
        except (server._contas.ErroConta,ValueError) as exc:
            return server.recusa('trigger_scene_surprise',seq,str(exc))
    server.MINIMOS['trigger_scene_surprise']=draw
