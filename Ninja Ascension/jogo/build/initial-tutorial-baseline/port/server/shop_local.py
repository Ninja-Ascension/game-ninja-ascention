"""Persistent local weapon chests and fragment exchange from recovered tables.

Local policy: daily free chest at 05:00 UTC, then keys before gold. Bounty
value is used as a relative draw weight; ten-draw groups follow VIP 0's row.
Fragment offers select one saved item per slot, rotating every ten days.
"""
import datetime,json,re,secrets,time,os
import dados_batalha as data
from hero_training_local import inventory_tokens

with open(os.path.join(data.MOULD,'..','configs','shop_config.txt'),encoding='utf8') as f:
    CONFIG={r[0]:r[3] for r in (line.rstrip('\n').split('\t') for line in f) if len(r)>3}

def day():
    return (datetime.datetime.now(datetime.timezone.utc)-datetime.timedelta(hours=5)).date().isoformat()

def schema(db):
    for sql in (
        'CREATE TABLE IF NOT EXISTS local_shop_state(conta_id INTEGER PRIMARY KEY,free_day TEXT NOT NULL DEFAULT "",draws INTEGER NOT NULL DEFAULT 0)',
        'CREATE TABLE IF NOT EXISTS local_shop_receipts(conta_id INTEGER,request_id TEXT,command TEXT,reply TEXT,PRIMARY KEY(conta_id,request_id))',
        'CREATE TABLE IF NOT EXISTS local_shop_equipment(id INTEGER PRIMARY KEY AUTOINCREMENT,conta_id INTEGER NOT NULL,mould INTEGER NOT NULL)',
        'CREATE TABLE IF NOT EXISTS local_shop_offers(conta_id INTEGER,period INTEGER,slot INTEGER,good INTEGER,bought INTEGER NOT NULL DEFAULT 0,PRIMARY KEY(conta_id,period,slot))'):
        db._conn.execute(sql)

def equipment(rowid,mould):
    r=data.tabela('equipment_mould.txt')[str(mould)]
    result=dict(user_equiment_id=str(2000000000+rowid),user_equiment_template=str(mould),
                user_equiment_name=r[1],sell_price=r[11],user_equiment_influence_type=r[3],equipment_type=r[4],
                user_equiment_ability=r[5],user_equiment_grade=r[27],user_equiment_exprience='0',
                user_equiment_growup_grade='0',growup_value='0',adorn_need_ship=r[10],equiment_picture=r[16],
                equiment_track_remark=r[18],equiment_track_scene=r[19],equiment_track_npc=r[20],
                equiment_track_npc_index=r[21],ship_id='0',grow_level=r[8],equiment_refine_param='0',
                current_star_level=r[7],current_star_exp='0',add_attribute='0',luck_value=0)
    for field in ('equiment_refine_level','refining_times','prop_timestamp','refining_value_life','refining_value_temp_life',
                  'refining_value_attack','refining_value_temp_attack','refining_value_physical_defence',
                  'refining_value_temp_physical_defence','refining_value_skill_defence','refining_value_temp_skill_defence',
                  'refining_value_final_damange','refining_value_temp_final_damange','refining_value_final_lessen_damange',
                  'refining_value_temp_final_lessen_damange'):
        result[field]='0'
    return result

def state_tokens(db,account,results=None,removed_equipment=None):
    with db._lock:
        schema(db)
        state=db._conn.execute('SELECT free_day,draws FROM local_shop_state WHERE conta_id=?',(account,)).fetchone()
        # Compact list [rowid, mould]: every other field is static
        # equipment_mould data the client rebuilds (shop_local.lua 15990).
        # Full objects made a 1000-item bag a 1.1 MB login on mobile.
        payload={'equipmentCompact':[list(r) for r in db._conn.execute('SELECT id,mould FROM local_shop_equipment WHERE conta_id=?',(account,))],
                 'free':int(not state or state[0]!=day()),'draws':state[1] if state else 0}
    if results is not None:payload['results']=results
    if removed_equipment:payload['removedEquipment']=list(map(str,removed_equipment))
    return ['15990',json.dumps(payload,separators=(',',':'))]

def choose(group):
    rows=[r for r in data.tabela('bounty_hero_param.txt').values() if int(r[1])==group and int(r[5])>0]
    if not rows:raise ValueError('biblioteca_de_bau_ausente')
    roll=secrets.randbelow(sum(int(r[5]) for r in rows))
    for r in rows:
        roll-=int(r[5])
        if roll<0:return list(map(int,r[6].split(',')))[:3]

def grant(db,account,kind,mould,quantity):
    if quantity<=0:raise ValueError('quantidade_invalida')
    if kind==6:
        if str(mould) not in data.tabela('prop_mould.txt'):raise ValueError('item_ausente')
        uid=account*1000000+mould
        db._conn.execute('INSERT INTO local_inventory VALUES (?,?,?,?) ON CONFLICT(conta_id,mould) DO UPDATE SET quantity=quantity+excluded.quantity',(account,mould,uid,quantity))
    elif kind==7:
        if str(mould) not in data.tabela('equipment_mould.txt') or quantity!=1:raise ValueError('equipamento_invalido')
        uid=2000000000+db._conn.execute('INSERT INTO local_shop_equipment(conta_id,mould) VALUES (?,?)',(account,mould)).lastrowid
    elif kind==1:
        db._conn.execute('UPDATE local_campaign SET silver=silver+? WHERE conta_id=?',(quantity,account));uid=-1
    else:raise ValueError('recompensa_nao_suportada')
    return {'m_type':kind,'mould_id':uid,'number':quantity}

def balances(db,account,delta=0,jade_delta=0):
    silver=db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?',(account,)).fetchone()[0]
    gold,jade=db._conn.execute('SELECT gold,jade FROM local_resources WHERE conta_id=?',(account,)).fetchone()
    return ['22',str(silver),'25',str(delta),str(gold),('177' if jade_delta>0 else '178'),str(jade_delta),str(jade)]

def offers_tokens(db,account):
    period=int(time.time())//(10*86400)
    rows=db._conn.execute('SELECT slot,good,bought FROM local_shop_offers WHERE conta_id=? AND period=? ORDER BY slot',(account,period)).fetchall()
    if not rows:
        slots={}
        for r in data.tabela('avatar_shop.txt').values():
            if r[1]=='6':slots.setdefault(int(r[4]),[]).append(int(r[0]))
        for slot,ids in sorted(slots.items()):
            db._conn.execute('INSERT INTO local_shop_offers VALUES (?,?,?,?,0)',(account,period,slot,secrets.choice(ids)))
        rows=db._conn.execute('SELECT slot,good,bought FROM local_shop_offers WHERE conta_id=? AND period=? ORDER BY slot',(account,period)).fetchall()
    tokens=['15001',str(period*10*86400*1000),str(len(rows))]
    for slot,good,bought in rows:tokens += [str(good),str(bought)]
    return tokens

def sell_props(server,seq,text):
    """Sell only props the original client marks with silver_price > 0."""
    command='prop_sell'
    try:
        db=server.BANCO
        account=db.sessao_de(server._sessao_da_conexao())['conta_id']
        fields=server._linhas(text)
        if not fields or fields[0]!=str(db.perfil(account)['user_id']):
            raise ValueError('perfil_invalido')
        if len(fields)<3 or (len(fields)-1)%2 or (len(fields)-1)//2>42:
            raise ValueError('parametros_venda_itens_invalidos')
        requests=[];seen=set()
        for offset in range(1,len(fields),2):
            raw_id,raw_quantity=fields[offset:offset+2]
            if not raw_id.isdigit() or not raw_quantity.isdigit():
                raise ValueError('parametros_venda_itens_invalidos')
            instance_id,quantity=int(raw_id),int(raw_quantity)
            if instance_id<=0 or quantity<=0:raise ValueError('quantidade_venda_invalida')
            if instance_id in seen:raise ValueError('item_repetido_na_venda')
            seen.add(instance_id);requests.append((instance_id,quantity))
        with db._lock,db._conn:
            prepared=[];total_silver=0
            for instance_id,quantity in requests:
                item=db._conn.execute('SELECT mould,quantity FROM local_inventory WHERE conta_id=? AND instance_id=?',(account,instance_id)).fetchone()
                if not item:raise ValueError('item_nao_encontrado_na_bag')
                mould,owned=int(item[0]),int(item[1])
                if quantity>owned:raise ValueError('quantidade_maior_que_o_inventario')
                original=data.tabela('prop_mould.txt').get(str(mould))
                if not original or len(original)<=3 or not re.fullmatch(r'\d+',original[3]):
                    raise ValueError('preco_original_do_item_ausente')
                unit_price=int(original[3])
                if unit_price<=0:raise ValueError('item_nao_pode_ser_vendido')
                total_silver+=unit_price*quantity
                if total_silver>9223372036854775807:raise ValueError('valor_venda_excede_limite')
                prepared.append((instance_id,quantity,owned-quantity))
            db._conn.execute('INSERT OR IGNORE INTO local_campaign(conta_id,grade,silver) VALUES (?,1,0)',(account,))
            for instance_id,_quantity,remaining in prepared:
                if remaining:
                    db._conn.execute('UPDATE local_inventory SET quantity=? WHERE conta_id=? AND instance_id=?',(remaining,account,instance_id))
                else:
                    db._conn.execute('DELETE FROM local_inventory WHERE conta_id=? AND instance_id=?',(account,instance_id))
            db._conn.execute('UPDATE local_campaign SET silver=silver+? WHERE conta_id=?',(total_silver,account))
            new_silver=int(db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?',(account,)).fetchone()[0])
            # Original client parsers: 27 adds silver; 37 reduces each stack.
            reply=[str(seq),command,'0','27',str(total_silver),str(new_silver)]
            for instance_id,_quantity,remaining in prepared:reply+=['37',str(instance_id),str(remaining)]
            return ' '.join(reply)
    except (server._contas.ErroConta,ValueError,IndexError,TypeError,KeyError) as exc:
        return server.recusa(command,seq,str(exc) or 'venda_de_itens_indisponivel')

def install(server):
    db=server.BANCO
    with db._lock,db._conn:schema(db)
    server.MINIMOS['prop_sell']=lambda seq,text:sell_props(server,seq,text)
    def handler(command,count=0):
        def run(seq,text):
            try:
                account=db.sessao_de(server._sessao_da_conexao())['conta_id'];fields=server._linhas(text)
                if not fields or fields[0]!=str(db.perfil(account)['user_id']):raise ValueError('perfil_invalido')
                if command=='shop_frags_init':
                    if any(fields[1:]):raise ValueError('pedido_invalido')
                    with db._lock,db._conn:return ' '.join([str(seq),command,'0']+offers_tokens(db,account))
                expected=3 if count else 4
                if len(fields)!=expected or not re.fullmatch(r'[0-9A-Za-z:-]{1,100}',fields[-1]):raise ValueError('pedido_invalido')
                signature=command+':'+':'.join(fields[1:-1]);key=fields[-1]
                with db._lock,db._conn:
                    db._conn.execute('INSERT OR IGNORE INTO local_campaign(conta_id) VALUES (?)',(account,))
                    db._conn.execute('INSERT OR IGNORE INTO local_resources(conta_id) VALUES (?)',(account,))
                    saved=db._conn.execute('SELECT command,reply FROM local_shop_receipts WHERE conta_id=? AND request_id=?',(account,key)).fetchone()
                    if saved:
                        if saved[0]!=signature:raise ValueError('identificador_reutilizado')
                        return str(seq)+' '+saved[1].split(' ',1)[1]
                    delta=0;jade_delta=0;results=[]
                    if count:
                        if fields[1]!='3':raise ValueError('tipo_de_bau_nao_suportado')
                        db._conn.execute('INSERT OR IGNORE INTO local_shop_state(conta_id) VALUES (?)',(account,))
                        free_day,draws=db._conn.execute('SELECT free_day,draws FROM local_shop_state WHERE conta_id=?',(account,)).fetchone()
                        cfg=data.tabela('partner_bounty_param.txt')['10' if count==1 else '11']
                        key_mould=int(CONFIG['8']);keys=db._conn.execute('SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=?',(account,key_mould)).fetchone()
                        free=count==1 and free_day!=day()
                        if free:free_day=day()
                        elif keys and keys[0]>=count:
                            db._conn.execute('UPDATE local_inventory SET quantity=quantity-? WHERE conta_id=? AND mould=?',(count,account,key_mould))
                        else:
                            delta=-int(cfg[4]);gold=db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?',(account,)).fetchone()[0]
                            if gold+delta<0:raise ValueError('gold_insuficiente')
                            db._conn.execute('UPDATE local_resources SET gold=gold+? WHERE conta_id=?',(delta,account))
                        groups=[int(cfg[6] if draws==0 else cfg[7])] if free else [int(cfg[8].split(',')[0])] if count==1 else list(map(int,cfg[10].split('|')[0].split(',')))
                        if len(groups)!=count:raise ValueError('grupos_de_bau_invalidos')
                        for group in groups:results.append(grant(db,account,*choose(group)))
                        db._conn.execute('UPDATE local_shop_state SET free_day=?,draws=draws+? WHERE conta_id=?',(free_day,count,account))
                        # User-confirmed original rule: one exchange token per chest.
                        jade_delta=count
                        db._conn.execute('UPDATE local_resources SET jade=jade+? WHERE conta_id=?',(jade_delta,account))
                    else:
                        offers_tokens(db,account);slot,quantity=map(int,fields[1:3]);period=int(time.time())//864000
                        if not 1<=quantity<=10000:raise ValueError('quantidade_invalida')
                        offer=db._conn.execute('SELECT good,bought FROM local_shop_offers WHERE conta_id=? AND period=? AND slot=?',(account,period,slot)).fetchone()
                        if not offer:raise ValueError('oferta_ausente')
                        r=data.tabela('avatar_shop.txt')[str(offer[0])];reward=list(map(int,r[2].split(',')));cost=list(map(int,r[3].split(',')))
                        if cost[:2]!=[5,-1]:raise ValueError('moeda_da_oferta_nao_suportada')
                        if int(r[5])>0 and offer[1]+quantity>int(r[5]):raise ValueError('limite_da_oferta')
                        jade=db._conn.execute('SELECT jade FROM local_resources WHERE conta_id=?',(account,)).fetchone()[0]
                        if jade<cost[2]*quantity:raise ValueError('fragmentos_insuficientes')
                        db._conn.execute('UPDATE local_resources SET jade=jade-? WHERE conta_id=?',(cost[2]*quantity,account))
                        for _ in range(quantity):results.append(grant(db,account,*reward))
                        db._conn.execute('UPDATE local_shop_offers SET bought=bought+? WHERE conta_id=? AND period=? AND slot=?',(quantity,account,period,slot))
                    tokens=[str(seq),command,'0']+inventory_tokens(db,account)+balances(db,account,delta,jade_delta)+state_tokens(db,account,results)
                    if not count:tokens+=offers_tokens(db,account)
                    reply=' '.join(tokens)
                    db._conn.execute('INSERT INTO local_shop_receipts VALUES (?,?,?,?)',(account,key,signature,reply))
                server.log('SHOP_LOCAL cmd=%s conta=%s resultados=%s gold_delta=%s'%(command,account,len(results),delta))
                return reply
            except (server._contas.ErroConta,ValueError,IndexError) as exc:return server.recusa(command,seq,str(exc))
        return run
    for command,count in [('ship_bounty',1),('ship_batch_bounty',10),('shop_frags_init',0),('shop_frags_exchange',0)]:server.MINIMOS[command]=handler(command,count)
