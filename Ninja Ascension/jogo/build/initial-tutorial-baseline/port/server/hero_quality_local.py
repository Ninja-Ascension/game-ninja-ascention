"""Normal character advancement; original per-character material group costs."""
import re
import dados_batalha as data

def schema(db):
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_hero_quality(conta_id INTEGER,ship_id INTEGER,quality INTEGER NOT NULL,PRIMARY KEY(conta_id,ship_id))')
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_hero_quality_receipts(conta_id INTEGER,request_id TEXT,signature TEXT,reply TEXT,PRIMARY KEY(conta_id,request_id))')

def quality(db,account,ship,mould):
    row=db._conn.execute('SELECT quality FROM local_hero_quality WHERE conta_id=? AND ship_id=?',(account,ship)).fetchone()
    if row:return int(row[0])
    rank=db._conn.execute('SELECT rank_level FROM local_ship_rank WHERE conta_id=? AND ship_id=?',(account,ship)).fetchone()
    value=int(rank[0]) if rank else int(data.tabela('ship_mould.txt')[str(mould)][44])
    if mould==13:
        legacy=db._conn.execute('SELECT quality FROM tutorial_training WHERE conta_id=?',(account,)).fetchone()
        if legacy:value=max(value,int(legacy[0]))
    return value

def requirements(mould):
    group=data.tabela('ship_mould.txt')[str(mould)][47]
    return sorted([r for r in data.tabela('ship_grow_requirement.txt').values() if r[30]==group],key=lambda r:int(r[0]))

def upgrade(server,seq,text):
    import recruitment_local as heroes
    from hero_training_local import inventory_tokens
    db=server.BANCO
    try:
        account=db.sessao_de(server._sessao_da_conexao())['conta_id'];fields=server._linhas(text)
        if len(fields)!=7 or fields[0]!=str(db.perfil(account)['user_id']) or not re.fullmatch(r'[0-9A-Za-z:-]{1,100}',fields[-1]):raise ValueError('pedido_de_avanco_invalido')
        ship,count=int(fields[1]),int(fields[5]);key=fields[-1];signature='|'.join(fields[1:-1])
        if not 1<=count<=100:raise ValueError('quantidade_de_avancos_invalida')
        if fields[2] or fields[4]:raise ValueError('consumo_de_personagens_ou_equipamentos_nao_suportado')
        with db._lock,db._conn:
            saved=db._conn.execute('SELECT signature,reply FROM local_hero_quality_receipts WHERE conta_id=? AND request_id=?',(account,key)).fetchone()
            if saved:
                if saved[0]!=signature:raise ValueError('identificador_reutilizado')
                return str(seq)+' '+saved[1].split(' ',1)[1]
            owned=dict(heroes.all_owned(db,account));mould=owned.get(ship)
            if not mould:raise ValueError('personagem_nao_pertence_a_conta')
            current=quality(db,account,ship,mould);rows=requirements(mould)
            if current+count>len(rows):raise ValueError('qualidade_maxima')
            level=db._conn.execute('SELECT level FROM local_ship_rank WHERE conta_id=? AND ship_id=?',(account,ship)).fetchone();level=int(level[0]) if level else 1
            provided=[int(x) for x in fields[3].split(',') if x]
            costs={};silver_cost=0
            for row in rows[current:current+count]:
                if level<int(row[18]):raise ValueError('nivel_do_personagem_insuficiente')
                # This flow is the quality tab (four material slots), not the
                # separate star/evolution UI which consumes heroes/equipment.
                if any(int(row[i])>0 for i in (13,15,19,20,22,24,26,28)):raise ValueError('requisito_de_evolucao_nao_suportado')
                silver_cost+=int(row[1])
                for index in (2,4,6,8,10):
                    prop,amount=int(row[index]),int(row[index+1])
                    if prop>0 and amount>0:costs[prop]=costs.get(prop,0)+amount
            if provided:
                expected={account*1000000+prop for prop in costs}
                if count!=1 or len(provided)!=len(set(provided)) or set(provided)!=expected:raise ValueError('materiais_incorretos')
            silver=db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?',(account,)).fetchone()
            if not silver or silver[0]<silver_cost:raise ValueError('ryo_insuficiente')
            for prop,amount in costs.items():
                item=db._conn.execute('SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=?',(account,prop)).fetchone()
                if not item or item[0]<amount:raise ValueError('materiais_insuficientes')
            for prop,amount in costs.items():db._conn.execute('UPDATE local_inventory SET quantity=quantity-? WHERE conta_id=? AND mould=?',(amount,account,prop))
            db._conn.execute('UPDATE local_campaign SET silver=silver-? WHERE conta_id=?',(silver_cost,account))
            db._conn.execute('INSERT INTO local_hero_quality VALUES (?,?,?) ON CONFLICT(conta_id,ship_id) DO UPDATE SET quality=excluded.quality',(account,ship,current+count))
            character=heroes.one_ship_tokens(db,account,(ship,mould));metadata=character[character.index('14104'):]
            reply=' '.join([str(seq),'ship_grow_up','0','22',str(silver[0]-silver_cost)]+inventory_tokens(db,account)+metadata)
            db._conn.execute('INSERT INTO local_hero_quality_receipts VALUES (?,?,?,?)',(account,key,signature,reply))
        server.log('HERO_QUALITY conta=%s ship=%s qualidade=%s->%s ryo=%s'%(account,ship,current,current+count,silver_cost));return reply
    except (server._contas.ErroConta,ValueError,IndexError) as exc:return server.recusa('ship_grow_up',seq,str(exc))
