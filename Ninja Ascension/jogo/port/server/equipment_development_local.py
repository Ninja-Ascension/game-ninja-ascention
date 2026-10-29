"""Equipment awakening and hardening: atomic costs, original tables, durable receipts."""
import json,re,secrets
from functools import lru_cache
from pathlib import Path
import dados_batalha as data

COMMANDS=('equipment_up_star','equipment_harden','equipment_harden_replace','equipment_harden_locking')


def schema(db):
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_equipment_awaken(conta_id INTEGER,ship_id INTEGER,slot INTEGER,star INTEGER NOT NULL,template INTEGER NOT NULL,PRIMARY KEY(conta_id,ship_id,slot))')
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_equipment_harden(conta_id INTEGER,ship_id INTEGER,slot INTEGER,state TEXT NOT NULL,PRIMARY KEY(conta_id,ship_id,slot))')
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_equipment_development_receipts(conta_id INTEGER,request_id TEXT,signature TEXT,reply TEXT,PRIMARY KEY(conta_id,request_id))')


@lru_cache(maxsize=None)
def config(key):
    for line in (Path(data.MOULD).parent/'configs/play_config.txt').read_text(encoding='utf8').splitlines():
        row=line.split('\t')
        if row[0]==str(key):return row[3]
    raise ValueError('configuracao_de_tempera_ausente')


def exists(db,table):
    return db._conn.execute('SELECT 1 FROM sqlite_master WHERE name=?',(table,)).fetchone() is not None


def appearance(db,account,ship,mould):
    templates=list(map(int,data.tabela('ship_mould.txt')[str(mould)][72].split(',')));stars=[0]*6
    if exists(db,'local_equipment_awaken'):
        for slot,star,template in db._conn.execute('SELECT slot,star,template FROM local_equipment_awaken WHERE conta_id=? AND ship_id=?',(account,ship)):
            stars[slot-1]=int(star);templates[slot-1]=int(template)
    return stars,templates


def state(db,account,ship,slot):
    row=db._conn.execute('SELECT state FROM local_equipment_harden WHERE conta_id=? AND ship_id=? AND slot=?',(account,ship,slot)).fetchone() if exists(db,'local_equipment_harden') else None
    return json.loads(row[0]) if row else dict(level=0,exp=0,entries=[],previous=[],lock=-1)


@lru_cache(maxsize=None)
def harden_row(slot,level):
    return next(r for r in data.tabela('equipment_harden.txt').values() if int(r[6])==slot and int(r[1])==level)


def pairs(text):
    return [tuple(map(float,item.split(','))) for item in text.split('|')] if text not in ('-1','0','') else []


def roll_entry(slot,rank,exclude=()):
    rows=[r for r in data.tabela('equipment_harden_param.txt').values() if int(r[1])==slot and int(r[2]) not in exclude]
    row=secrets.choice(rows)
    low=high=0
    for n in range(rank+1):
        a,b=map(float,row[3+n].split(','));low+=a;high+=b
    low,high=round(low*100),round(high*100)
    return [rank,int(row[2]),(low+secrets.randbelow(high-low+1))/100]


def update_entries(slot,saved):
    level=saved['level'];unlocks=list(map(int,config(194).split(',')))
    rank=sum(level>=n for n in map(int,config(195).split(',')))
    count=sum(level>=n for n in unlocks)
    while len(saved['entries'])<count:
        saved['entries'].append(roll_entry(slot,rank,[e[1] for e in saved['entries']]))
    for index,entry in enumerate(saved['entries']):
        if entry[0]<rank:
            # Keep the property type when a tier increases; roll its new range.
            excluded=[int(r[2]) for r in data.tabela('equipment_harden_param.txt').values() if int(r[1])==slot and int(r[2])!=entry[1]]
            saved['entries'][index]=roll_entry(slot,rank,excluded)


def entry_text(entry):return str(entry[0])+'|'+str(entry[1])+','+str(entry[2])


def snapshot(db,account,ship):
    result=['14207','1','6']
    for slot in range(1,7):
        saved=state(db,account,ship,slot)
        base=harden_row(slot,saved['level'])[4]
        if base=='-1':base='|'.join(str(int(kind))+',0' for kind,_ in pairs(harden_row(slot,1)[4]))
        result += [str(saved['level']),str(saved['exp']),base,str(len(saved['entries']))]
        result += [entry_text(e) for e in saved['entries']]+[str(len(saved['previous']))]
        result += [entry_text(e) for e in saved['previous']]+[str(saved['lock'])]
    return result+[str(ship)]


def harden_bonus(db,account,ship,stars):
    result={}
    for slot in range(1,7):
        if stars[slot-1]<int(config(196)):continue
        saved=state(db,account,ship,slot)
        values=pairs(harden_row(slot,saved['level'])[4])+[(e[1],e[2]) for e in saved['entries']]
        for kind,amount in values:
            kind=int(kind);result[kind]=result.get(kind,0)+amount
    return result


def consume(db,account,costs):
    """Validate every resource before touching any of them."""
    removed=[]
    for (kind,mould),amount in costs.items():
        if amount<0:raise ValueError('custo_invalido')
        if kind==6:
            row=db._conn.execute('SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=?',(account,mould)).fetchone()
            if not row or row[0]<amount:raise ValueError('materiais_insuficientes')
        elif kind==7:
            rows=db._conn.execute('SELECT id FROM local_shop_equipment WHERE conta_id=? AND mould=? ORDER BY id LIMIT ?',(account,mould,amount)).fetchall()
            if len(rows)<amount:raise ValueError('equipamentos_insuficientes')
            removed.extend(2000000000+r[0] for r in rows)
        elif kind in (1,2):
            table,column=('local_campaign','silver') if kind==1 else ('local_resources','gold')
            row=db._conn.execute('SELECT '+column+' FROM '+table+' WHERE conta_id=?',(account,)).fetchone()
            if not row or row[0]<amount:raise ValueError('saldo_insuficiente')
        else:raise ValueError('tipo_de_custo_nao_suportado')
    for (kind,mould),amount in costs.items():
        if kind==6:db._conn.execute('UPDATE local_inventory SET quantity=quantity-? WHERE conta_id=? AND mould=?',(amount,account,mould))
        elif kind in (1,2):
            table,column=('local_campaign','silver') if kind==1 else ('local_resources','gold')
            db._conn.execute('UPDATE '+table+' SET '+column+'='+column+'-? WHERE conta_id=?',(amount,account))
    for ident in removed:db._conn.execute('DELETE FROM local_shop_equipment WHERE conta_id=? AND id=?',(account,ident-2000000000))
    return removed


def execute(server,command,seq,text):
    import recruitment_local as heroes
    import hero_stats_local,shop_local
    from hero_training_local import inventory_tokens
    db=server.BANCO
    try:
        account=db.sessao_de(server._sessao_da_conexao())['conta_id'];fields=server._linhas(text)
        count={'equipment_up_star':4,'equipment_harden':5,'equipment_harden_replace':4,'equipment_harden_locking':6}[command]
        if len(fields)!=count or fields[0]!=str(db.perfil(account)['user_id']) or not re.fullmatch(r'[0-9A-Za-z:-]{1,100}',fields[-1]):raise ValueError('pedido_de_equipamento_invalido')
        ship,slot=int(fields[1]),int(fields[2]);key=fields[-1];signature=command+'|'+'|'.join(fields[1:-1])
        if slot not in range(1,7):raise ValueError('slot_invalido')
        with db._lock,db._conn:
            old=db._conn.execute('SELECT signature,reply FROM local_equipment_development_receipts WHERE conta_id=? AND request_id=?',(account,key)).fetchone()
            if old:
                if old[0]!=signature:raise ValueError('identificador_reutilizado')
                return str(seq)+' '+old[1].split(' ',1)[1]
            mould=dict(heroes.all_owned(db,account)).get(ship)
            if mould is None:raise ValueError('personagem_nao_pertence_a_conta')
            stars,templates=appearance(db,account,ship,mould);removed=[];boom=1
            if command=='equipment_up_star':
                star=stars[slot-1];template=templates[slot-1];equip=data.tabela('equipment_mould.txt')[str(template)]
                row=next((r for r in data.tabela('equipment_star.txt').values() if r[1]==equip[46] and int(r[2])==star),None)
                if star>=5 or not row or row[3]=='-1' or row[5]=='-1':raise ValueError('despertar_no_limite')
                if int(row[11])!=100:raise ValueError('tabela_de_despertar_nao_deterministica')
                costs={}
                for resource in row[5].split('|'):
                    kind,item,amount=map(int,resource.split(','));costs[kind,item]=costs.get((kind,item),0)+amount
                removed=consume(db,account,costs)
                new_template=int(equip[42]) if int(equip[42])>0 else template
                if str(new_template) not in data.tabela('equipment_mould.txt'):raise ValueError('molde_despertado_ausente')
                db._conn.execute('INSERT INTO local_equipment_awaken VALUES (?,?,?,?,?) ON CONFLICT(conta_id,ship_id,slot) DO UPDATE SET star=excluded.star,template=excluded.template',(account,ship,slot,star+1,new_template))
            else:
                if stars[slot-1]<int(config(196)):raise ValueError('despertar_insuficiente_para_quench')
                saved=state(db,account,ship,slot)
                if command=='equipment_harden':
                    mode=int(fields[3])
                    if mode not in (1,2):raise ValueError('modo_de_quench_invalido')
                    max_level=int(config(182));steps=0;starting_level=saved['level']
                    while saved['level']<max_level:
                        row=harden_row(slot,saved['level']);price=int(row[3]);item=int(config(182+slot))
                        if price<0:raise ValueError('custo_de_quench_invalido')
                        silver=db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?',(account,)).fetchone()
                        quantity=db._conn.execute('SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=?',(account,item)).fetchone()
                        if not silver or silver[0]<price or not quantity or quantity[0]<1:break
                        consume(db,account,{(1,0):price,(6,item):1});steps+=1
                        critical=secrets.randbelow(10000)<round(float(config(193))*10000)
                        boom=2 if critical else boom
                        saved['exp']+=int(config(191))*(int(config(192)) if critical else 1)
                        while saved['level']<max_level and saved['exp']>=int(harden_row(slot,saved['level'])[2]):
                            needed=int(harden_row(slot,saved['level'])[2])
                            if needed<=0:raise ValueError('tabela_de_quench_invalida')
                            saved['exp']-=needed;saved['level']+=1;update_entries(slot,saved)
                        if saved['level']==max_level:saved['exp']=0
                        if mode==1 or saved['level']>starting_level:break
                    if not steps:raise ValueError('quench_no_limite_ou_saldo_material_insuficiente')
                    saved['previous']=[]
                elif command=='equipment_harden_replace':
                    if len(saved['entries'])<=int(saved['lock']>=0):raise ValueError('nenhum_atributo_livre')
                    costs={(6,int(config(190))):1}
                    if saved['lock']>=0:costs[6,int(config(189))]=1
                    consume(db,account,costs);saved['previous']=[e[:] for e in saved['entries']]
                    locked_types=[e[1] for i,e in enumerate(saved['entries']) if i==saved['lock']]
                    for i,entry in enumerate(saved['entries']):
                        if i!=saved['lock']:
                            saved['entries'][i]=roll_entry(slot,entry[0],locked_types)
                            locked_types.append(saved['entries'][i][1])
                else:
                    index,mode=int(fields[3])-1,int(fields[4])
                    if not 0<=index<len(saved['entries']) or mode not in (1,2):raise ValueError('bloqueio_invalido')
                    if mode==1:
                        available=db._conn.execute('SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=?',(account,int(config(189)))).fetchone()
                        if not available or available[0]<1:raise ValueError('pedra_de_bloqueio_insuficiente')
                        saved['lock']=index
                    else:
                        if saved['lock']!=index:raise ValueError('atributo_nao_bloqueado')
                        saved['lock']=-1
                db._conn.execute('INSERT INTO local_equipment_harden VALUES (?,?,?,?) ON CONFLICT(conta_id,ship_id,slot) DO UPDATE SET state=excluded.state',(account,ship,slot,json.dumps(saved,separators=(',',':'))))
            metadata=heroes.one_ship_tokens(db,account,(ship,mould));metadata=metadata[metadata.index('14104'):]
            silver=db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?',(account,)).fetchone()
            gold=db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?',(account,)).fetchone()
            reply=' '.join([str(seq),command,'0','22',str(silver[0] if silver else 0),'25','0',str(gold[0] if gold else 0)]+inventory_tokens(db,account)+metadata+['14208',str(boom)]+shop_local.state_tokens(db,account,removed_equipment=removed)+hero_stats_local.attribute_tokens(db,account))
            db._conn.execute('INSERT INTO local_equipment_development_receipts VALUES (?,?,?,?)',(account,key,signature,reply))
        server.log('EQUIPMENT_DEVELOPMENT conta=%s ship=%s slot=%s cmd=%s salvo'%(account,ship,slot,command));return reply
    except (server._contas.ErroConta,ValueError,KeyError,IndexError,StopIteration) as exc:return server.recusa(command,seq,str(exc))


def install(server):
    with server.BANCO._lock,server.BANCO._conn:schema(server.BANCO)
    for command in COMMANDS:server.MINIMOS[command]=lambda seq,text,cmd=command:execute(server,cmd,seq,text)
