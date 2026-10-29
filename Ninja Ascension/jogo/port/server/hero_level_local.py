"""Character EXP upgrades, independent of the disabled tutorial."""
import json,re
import dados_batalha as data

def schema(db):
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_hero_exp(conta_id INTEGER,ship_id INTEGER,experience INTEGER NOT NULL DEFAULT 0,PRIMARY KEY(conta_id,ship_id))')
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_hero_level_receipts(conta_id INTEGER,request_id TEXT,signature TEXT,reply TEXT,PRIMARY KEY(conta_id,request_id))')

# Server cap for character level (the client and the account level may stop earlier).
HERO_MAX_LEVEL=200

def needed(mould,level):
    row=data.tabela('ship_mould.txt')[str(mould)]
    if level>=HERO_MAX_LEVEL:return 0
    return int(data.tabela('ship_experience_param.txt')[str(level+1)][int(row[8])-11])

def state(db,account,ship,mould):
    row=db._conn.execute('SELECT level FROM local_ship_rank WHERE conta_id=? AND ship_id=?',(account,ship)).fetchone()
    level=int(row[0]) if row else 1
    exp=db._conn.execute('SELECT experience FROM local_hero_exp WHERE conta_id=? AND ship_id=?',(account,ship)).fetchone()
    return level,int(exp[0]) if exp else 0,needed(mould,level)

def upgrade(server,seq,text):
    import recruitment_local as heroes
    from hero_training_local import inventory_tokens
    db=server.BANCO
    try:
        account=db.sessao_de(server._sessao_da_conexao())['conta_id'];fields=server._linhas(text)
        if len(fields) not in (5,6) or fields[0]!=str(db.perfil(account)['user_id']) or fields[1]!='0' or not re.fullmatch(r'[0-9A-Za-z:-]{1,100}',fields[-1]):raise ValueError('pedido_de_nivel_invalido')
        ship=int(fields[2]);signature='|'.join(fields[1:-1]);key=fields[-1]
        with db._lock,db._conn:
            old=db._conn.execute('SELECT signature,reply FROM local_hero_level_receipts WHERE conta_id=? AND request_id=?',(account,key)).fetchone()
            if old:
                if old[0]!=signature:raise ValueError('identificador_reutilizado')
                return str(seq)+' '+old[1].split(' ',1)[1]
            mould=dict(heroes.all_owned(db,account)).get(ship)
            if not mould:raise ValueError('personagem_nao_pertence_a_conta')
            level,exp,_=state(db,account,ship,mould);before=level
            campaign=db._conn.execute('SELECT grade FROM local_campaign WHERE conta_id=?',(account,)).fetchone()
            cap=min(HERO_MAX_LEVEL,int(campaign[0]) if campaign else int(db.perfil(account).get('user_grade',1)))
            if level>=cap:raise ValueError('nivel_maximo_do_personagem')
            target=int(fields[4]) if len(fields)==6 else cap
            if not level<target<=cap:raise ValueError('nivel_alvo_invalido')
            remaining=max(0,sum(needed(mould,n) for n in range(level,target))-exp)
            costs={};gain=0
            for item in fields[3].split(','):
                if not re.fullmatch(r'\d+:\d+',item):raise ValueError('item_de_exp_invalido')
                instance,count=map(int,item.split(':'))
                if not 1<=count<=100000 or instance in costs:raise ValueError('quantidade_de_exp_invalida')
                inv=db._conn.execute('SELECT mould,quantity FROM local_inventory WHERE conta_id=? AND instance_id=?',(account,instance)).fetchone()
                if not inv or inv[1]<count:raise ValueError('itens_insuficientes')
                prop=data.tabela('prop_mould.txt').get(str(inv[0]))
                food=data.tabela('ship_mould.txt').get(prop[39]) if prop else None
                value=int(food[54]) if food else 0
                if value<=0:raise ValueError('item_nao_fornece_exp')
                # Validate every supplied stack, but only spend enough to reach
                # the selected target (or account cap for older clients).
                consume=min(count,max(0,(remaining-gain+value-1)//value))
                gain+=value*consume;costs[instance]=consume
            exp+=gain
            while level<target and exp>=needed(mould,level):
                requirement=needed(mould,level)
                if requirement<=0:raise ValueError('tabela_de_exp_invalida')
                exp-=requirement;level+=1
            if level>=cap:exp=0
            for instance,count in costs.items():db._conn.execute('UPDATE local_inventory SET quantity=quantity-? WHERE conta_id=? AND instance_id=?',(count,account,instance))
            db._conn.execute('INSERT INTO local_ship_rank(conta_id,ship_id,rank_level,level) VALUES (?,?,?,?) ON CONFLICT(conta_id,ship_id) DO UPDATE SET level=excluded.level',(account,ship,int(data.tabela('ship_mould.txt')[str(mould)][44]),level))
            db._conn.execute('INSERT INTO local_hero_exp VALUES (?,?,?) ON CONFLICT(conta_id,ship_id) DO UPDATE SET experience=excluded.experience',(account,ship,exp))
            row=data.tabela('ship_mould.txt')[str(mould)]
            import hero_stats_local
            effective=hero_stats_local.effective(db,account,ship,mould)
            values=[effective[k] for k in ('health','courage','intellect','quick')]
            payload=dict(ship=str(ship),level=level,experience=exp,needed=needed(mould,level),health=values[0],courage=values[1],intellect=values[2],quick=values[3])
            reply=' '.join([str(seq),'ship_escalate','0']+inventory_tokens(db,account)+['15993',json.dumps(payload,separators=(',',':'))])
            db._conn.execute('INSERT INTO local_hero_level_receipts VALUES (?,?,?,?)',(account,key,signature,reply))
        server.log('HERO_LEVEL conta=%s ship=%s nivel=%s->%s exp=%s'%(account,ship,before,level,exp));return reply
    except (server._contas.ErroConta,ValueError,IndexError,KeyError) as exc:return server.recusa('ship_escalate',seq,str(exc))
