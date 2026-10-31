"""Normal character advancement; original per-character material group costs."""
import math
import re
from pathlib import Path
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

def _ship_config(param_id):
    path=Path(data.MOULD).parent/'configs'/'ship_config.txt'
    for line in path.read_text(encoding='utf-8').splitlines():
        row=line.split('\t')
        if row and row[0]==str(param_id) and len(row)>3:
            return row[3]
    raise ValueError('configuracao_de_renascimento_ausente')

def _rebirth_quality_plan(db,account,ship,mould,full_refund):
    """Build the original quality-rebirth preview from the advancement table."""
    base_row=db._conn.execute('SELECT rank_level FROM local_ship_rank WHERE conta_id=? AND ship_id=?',(account,ship)).fetchone()
    base=int(base_row[0]) if base_row else int(data.tabela('ship_mould.txt')[str(mould)][44])
    current=quality(db,account,ship,mould)
    min_quality=int(_ship_config(15))
    if current<min_quality:raise ValueError('qualidade_minima_para_renascer_nao_atingida')
    if current<=base:raise ValueError('personagem_sem_avanco_de_qualidade')
    rows=requirements(mould)
    if current>len(rows) or base<0:raise ValueError('qualidade_do_personagem_invalida')
    silver_spent=0
    materials={}
    for row in rows[base:current]:
        # These columns describe evolution ingredients, which the implemented
        # quality-upgrade handler itself refuses to consume.
        if any(int(row[i])>0 for i in (13,15,19,20,22,24,26,28)):
            raise ValueError('requisito_de_qualidade_nao_suportado')
        silver_spent+=int(row[1])
        for i in (2,4,6,8,10):
            prop,amount=int(row[i]),int(row[i+1])
            if prop>0 and amount>0:materials[prop]=materials.get(prop,0)+amount
    try:
        item_type,item_mould,item_count=map(int,_ship_config(16).split(','))
    except (TypeError,ValueError):
        raise ValueError('custo_de_renascimento_invalido')
    if item_type!=6 or item_mould<=0 or item_count<=0:
        raise ValueError('custo_de_renascimento_invalido')
    ratio=1.0 if full_refund else float(_ship_config(17))
    if not 0.0<=ratio<=1.0:raise ValueError('percentual_de_reembolso_invalido')
    returned_silver=int(math.ceil(silver_spent*ratio))
    returned={prop:int(math.ceil(amount*ratio)) for prop,amount in materials.items()}
    return (current,base,item_type,item_mould,item_count,
            returned_silver,{p:n for p,n in returned.items() if n>0})

def _rebirth_cost_info(item_type,item_mould,item_count):
    return '%d,%d,%d'%(item_type,item_mould,item_count)

def _rebirth_reward_info(silver,materials):
    entries=[]
    if silver>0:entries.append('1,-1,%d'%silver)
    entries.extend('6,%d,%d'%(prop,count) for prop,count in sorted(materials.items()) if count>0)
    return '|'.join(entries) if entries else '0,-1,0'

def rebirth_init(server,seq,text):
    import recruitment_local as heroes
    db=server.BANCO
    try:
        account=db.sessao_de(server._sessao_da_conexao())['conta_id']
        fields=server._linhas(text)
        if len(fields)!=2:raise ValueError('pedido_de_renascimento_invalido')
        ship,category=map(int,fields)
        if category!=0:raise ValueError('tipo_de_renascimento_nao_suportado')
        with db._lock:
            mould=dict(heroes.all_owned(db,account)).get(ship)
            if not mould:raise ValueError('personagem_nao_pertence_a_conta')
            plan=_rebirth_quality_plan(db,account,ship,mould,False)
            full_plan=_rebirth_quality_plan(db,account,ship,mould,True)
            item_type,item_mould,item_count=plan[2:5]
            item=db._conn.execute('SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=?',(account,item_mould)).fetchone()
            if not item or item[0]<item_count:raise ValueError('pedra_de_renascimento_insuficiente')
        cost=_rebirth_cost_info(item_type,item_mould,item_count)
        normal_reward=_rebirth_reward_info(plan[5],plan[6])
        full_reward=_rebirth_reward_info(full_plan[5],full_plan[6])
        return ' '.join([str(seq),'ship_rebirth_init','0','14107',cost,normal_reward,cost,full_reward])
    except (server._contas.ErroConta,ValueError,KeyError,IndexError) as exc:
        return server.recusa('ship_rebirth_init',seq,str(exc) or 'configuracao_de_renascimento_invalida')

def rebirth(server,seq,text):
    import recruitment_local as heroes
    from hero_training_local import inventory_tokens
    db=server.BANCO
    try:
        account=db.sessao_de(server._sessao_da_conexao())['conta_id']
        fields=server._linhas(text)
        if len(fields)!=3:raise ValueError('pedido_de_renascimento_invalido')
        ship,category,mode=map(int,fields)
        if category!=0 or mode not in (0,1):raise ValueError('tipo_de_renascimento_nao_suportado')
        with db._lock,db._conn:
            mould=dict(heroes.all_owned(db,account)).get(ship)
            if not mould:raise ValueError('personagem_nao_pertence_a_conta')
            plan=_rebirth_quality_plan(db,account,ship,mould,mode==1)
            _,base,item_type,item_mould,item_count,returned_silver,returned=plan
            balance=db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?',(account,)).fetchone()
            if not balance:raise ValueError('perfil_de_recursos_ausente')
            item=db._conn.execute('SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=?',(account,item_mould)).fetchone()
            if not item or item[0]<item_count:raise ValueError('pedra_de_renascimento_insuficiente')

            db._conn.execute('UPDATE local_inventory SET quantity=quantity-? WHERE conta_id=? AND mould=?',(item_count,account,item_mould))
            db._conn.execute('UPDATE local_campaign SET silver=silver+? WHERE conta_id=?',(returned_silver,account))
            for prop,count in returned.items():
                db._conn.execute('INSERT INTO local_inventory(conta_id,mould,instance_id,quantity) VALUES (?,?,?,?) ON CONFLICT(conta_id,mould) DO UPDATE SET quantity=local_inventory.quantity+excluded.quantity',
                                 (account,prop,account*1000000+prop,count))
            # Removing the override restores the exact rank baseline used by
            # hero_quality_local.quality(), rather than inventing a new rank.
            db._conn.execute('DELETE FROM local_hero_quality WHERE conta_id=? AND ship_id=?',(account,ship))
            character=heroes.one_ship_tokens(db,account,(ship,mould))
            metadata=character[character.index('14104'):]
            new_balance=int(balance[0])+returned_silver
            reply=' '.join([str(seq),'ship_rebirth','0','22',str(new_balance)]+inventory_tokens(db,account)+metadata)
        server.log('SHIP_REBIRTH_QUALITY conta=%s ship=%s qualidade=%s->%s modo=%s devolvido=%s'%(account,ship,plan[0],base,mode,returned_silver))
        return reply
    except (server._contas.ErroConta,ValueError,KeyError,IndexError) as exc:
        return server.recusa('ship_rebirth',seq,str(exc) or 'configuracao_de_renascimento_invalida')

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
