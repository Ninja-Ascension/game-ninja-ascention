"""Local single-character fragment synthesis, using original prop table costs."""
import dados_batalha as data
import recruitment_local as heroes
from hero_training_local import inventory_tokens

def install(server):
    db=server.BANCO
    def compound(seq,text):
        try:
            account=db.sessao_de(server._sessao_da_conexao())['conta_id']
            lines=server._linhas(text)
            if len(lines)!=4 or lines[0]!=str(db.perfil(account)['user_id']) or lines[2:]!=['1','1']:
                raise ValueError('sintese_individual_invalida')
            already_owned={m for _,m in heroes.all_owned(db,account)}
            with db._lock:
                item=db._conn.execute('SELECT mould,quantity FROM local_inventory WHERE conta_id=? AND instance_id=?',
                                      (account,int(lines[1]))).fetchone()
                if not item:raise ValueError('fragmento_nao_pertence_a_conta')
                row=data.tabela('prop_mould.txt').get(str(item[0]))
                if not row or len(row)<40:raise ValueError('fragmento_invalido')
                mould,cost=int(row[39]),int(row[9])
                if str(mould) not in data.tabela('ship_mould.txt') or cost<=0:raise ValueError('item_nao_sintetiza_personagem')
                saved=db._conn.execute('SELECT ship_id FROM local_synthesized WHERE conta_id=? AND mould=?',(account,mould)).fetchone()
                if saved:ship=saved[0]
                else:
                    if mould in already_owned:raise ValueError('personagem_ja_possuido')
                    if item[1]<cost:raise ValueError('fragmentos_insuficientes')
                    ship=1000000000+account*100000+mould
                    with db._conn:
                        db._conn.execute('UPDATE local_inventory SET quantity=quantity-? WHERE conta_id=? AND mould=?',(cost,account,item[0]))
                        db._conn.execute('INSERT INTO local_synthesized VALUES (?,?,?)',(account,mould,ship))
            return ' '.join([str(seq),'prop_compound','0']+inventory_tokens(db,account)+heroes.one_ship_tokens(db,account,(ship,mould)))
        except (server._contas.ErroConta,ValueError,IndexError) as exc:
            return server.recusa('prop_compound',seq,str(exc))
    server.MINIMOS['prop_compound']=compound
