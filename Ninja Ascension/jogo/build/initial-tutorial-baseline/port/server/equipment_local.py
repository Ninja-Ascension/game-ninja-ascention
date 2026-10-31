"""Persisted equipment upgrades using the recovered client cost tables."""
import re
import dados_batalha as data


def schema(db):
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_equipment_level(conta_id INTEGER,ship_id INTEGER,slot INTEGER,level INTEGER NOT NULL,quality INTEGER NOT NULL DEFAULT 0,PRIMARY KEY(conta_id,ship_id,slot))')
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_equipment_receipts(conta_id INTEGER,request_id TEXT,signature TEXT,reply TEXT,PRIMARY KEY(conta_id,request_id))')


def levels(db,account,ship):
    # During hot reload stats may run before the installer creates this table.
    if not db._conn.execute("SELECT 1 FROM sqlite_master WHERE name='local_equipment_level'").fetchone():return [1]*6
    saved=dict(db._conn.execute('SELECT slot,level FROM local_equipment_level WHERE conta_id=? AND ship_id=?',(account,ship)).fetchall())
    return [int(saved.get(i,1)) for i in range(1,7)]


def rows(mould,slot):
    group=data.tabela('ship_mould.txt')[str(mould)][73].split(',')[slot-1]
    return {int(r[1]):r for r in data.tabela('equipment_level_param.txt').values() if r[14]==group}


def qualities(db,account,ship):
    if not db._conn.execute("SELECT 1 FROM sqlite_master WHERE name='local_equipment_level'").fetchone():return [0]*6
    saved=dict(db._conn.execute('SELECT slot,quality FROM local_equipment_level WHERE conta_id=? AND ship_id=?',(account,ship)).fetchall())
    return [int(saved.get(i,0)) for i in range(1,7)]


def equip_info(db,account,ship,mould):
    lv=levels(db,account,ship)
    grades=qualities(db,account,ship)
    import treasure_local
    experience=treasure_local.experiences(db,account,ship)
    import equipment_development_local as development
    stars,templates=development.appearance(db,account,ship,mould)
    return '|'.join(','.join(map(str,part)) for part in (lv,grades,experience,stars,templates))


def bonus(db,account,ship,mould,with_properties=False):
    """Increment from starting equipment; same A/B formula as the client."""
    from pathlib import Path
    import math
    config={r[0]:r for r in (line.split('\t') for line in (Path(data.MOULD).parent/'configs/equipment_config.txt').read_text(encoding='utf8').splitlines())}
    factors=[dict((int(k),float(v)) for k,v in (p.split(',') for p in config[str(i)][3].split('|'))) for i in (1,2)]
    result=[0.0]*4
    properties={}
    original_templates=data.tabela('ship_mould.txt')[str(mould)][72].split(',')
    import equipment_development_local as development
    stars,templates=development.appearance(db,account,ship,mould)
    star_factors=dict((int(k),float(v)) for k,v in (p.split(',') for p in config['3'][3].split('|')))
    for slot,level in enumerate(levels(db,account,ship),1):
        grade=qualities(db,account,ship)[slot-1];star=stars[slot-1]
        if level==1 and grade==0 and star==0:continue
        equip=data.tabela('equipment_mould.txt')[str(templates[slot-1])]
        original=data.tabela('equipment_mould.txt')[original_templates[slot-1]]
        starting=dict((int(k),float(v)) for k,v in (p.split(',') for p in original[5].split('|')))
        base=[p.split(',') for p in equip[5].split('|')]
        growth=[p.split(',') for p in equip[9].split('|')]
        star_row=next((r for r in data.tabela('equipment_star.txt').values() if r[1]==equip[46] and int(r[2])==star),None)
        addition=dict((int(k),v) for k,v in development.pairs(star_row[7])) if star_row else {}
        for (kind,amount),(_,grow) in zip(base,growth):
            kind=int(kind);amount=float(amount);grow=float(grow)
            if slot<=4:
                multiplier=star_factors[star]
                delta=math.floor(amount+grow*factors[0][grade]*multiplier+addition.get(kind,0)+grow*(level-1)*factors[1][grade]*multiplier)-math.floor(starting.get(kind,0))
            else:delta=amount+float(config['4'][3])*grade+float(config['5'][3])*star+grow*(level-1)-starting.get(kind,0)
            if 0<=kind<4:result[kind]+=delta
            else:properties[kind]=properties.get(kind,0)+delta
    for kind,amount in development.harden_bonus(db,account,ship,stars).items():
        if 0<=kind<4:result[kind]+=amount
        else:properties[kind]=properties.get(kind,0)+amount
    return (result,properties) if with_properties else result


def upgrade(server,seq,text):
    import recruitment_local as heroes
    from hero_training_local import inventory_tokens
    db=server.BANCO
    try:
        account=db.sessao_de(server._sessao_da_conexao())['conta_id'];fields=server._linhas(text)
        if len(fields)!=7 or fields[0]!=str(db.perfil(account)['user_id']) or fields[2]!='0' or fields[4] not in ('0','1') or not re.fullmatch(r'[0-9A-Za-z:-]{1,100}',fields[6]):raise ValueError('pedido_de_equipamento_invalido')
        ship,slot,target=int(fields[1]),int(fields[3]),int(fields[5]);mode=int(fields[4]);key=fields[6];signature='|'.join(fields[1:6])
        if not 1<=slot<=4 or (mode==0 and target!=-1) or (mode==1 and target!=-1 and target<1):raise ValueError('modo_ou_slot_invalido')
        with db._lock,db._conn:
            old=db._conn.execute('SELECT signature,reply FROM local_equipment_receipts WHERE conta_id=? AND request_id=?',(account,key)).fetchone()
            if old:
                if old[0]!=signature:raise ValueError('identificador_reutilizado')
                return str(seq)+' '+old[1].split(' ',1)[1]
            mould=dict(heroes.all_owned(db,account)).get(ship)
            if mould is None:raise ValueError('personagem_nao_pertence_a_conta')
            table=rows(mould,slot);level=levels(db,account,ship)[slot-1];before=level;quality=qualities(db,account,ship)[slot-1];before_quality=quality
            if target>max(table):raise ValueError('nivel_alvo_invalido')
            campaign=db._conn.execute('SELECT grade,silver FROM local_campaign WHERE conta_id=?',(account,)).fetchone()
            if not campaign:raise ValueError('progresso_ausente')
            grade,silver=map(int,campaign);cost=0;materials={};reason='nivel_maximo_do_equipamento'
            stop=level+1 if mode==0 else (target if target!=-1 else max(table))
            while level<stop and level+1 in table:
                row=table[level];promotion=quality<int(table[level+1][12])
                # The ordinary quick button stops at the next promotion.
                if mode==1 and target==-1 and promotion:break
                required=row[15].split(',');required=int(required[slot-1] if len(required)>1 else required[0])
                if promotion and required>grade:reason='nivel_do_jogador_insuficiente';break
                price=int(row[13] if promotion else row[2])
                if price<0:raise ValueError('custo_de_equipamento_invalido')
                if cost+price>silver:reason='prata_insuficiente';break
                step={}
                if promotion:
                    for i in (3,5,7,9):
                        item,count=int(row[i]),int(row[i+1])
                        if item>0 and count>0:step[item]=step.get(item,0)+count
                if any((db._conn.execute('SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=?',(account,item)).fetchone() or [0])[0]<materials.get(item,0)+count for item,count in step.items()):reason='materiais_insuficientes';break
                cost+=price
                for item,count in step.items():materials[item]=materials.get(item,0)+count
                if promotion:quality=int(table[level+1][12])
                else:level+=1
                if mode==0:break
            if (level,quality)==(before,before_quality):raise ValueError(reason)
            db._conn.execute('UPDATE local_campaign SET silver=silver-? WHERE conta_id=?',(cost,account))
            for item,count in materials.items():db._conn.execute('UPDATE local_inventory SET quantity=quantity-? WHERE conta_id=? AND mould=?',(count,account,item))
            db._conn.execute('INSERT INTO local_equipment_level VALUES (?,?,?,?,?) ON CONFLICT(conta_id,ship_id,slot) DO UPDATE SET level=excluded.level,quality=excluded.quality',(account,ship,slot,level,quality))
            metadata=heroes.one_ship_tokens(db,account,(ship,mould));metadata=metadata[metadata.index('14104'):]
            import hero_stats_local
            reply=' '.join([str(seq),'equipment_escalate','0','22',str(silver-cost)]+inventory_tokens(db,account)+metadata+hero_stats_local.attribute_tokens(db,account))
            db._conn.execute('INSERT INTO local_equipment_receipts VALUES (?,?,?,?)',(account,key,signature,reply))
        server.log('EQUIPMENT_LEVEL conta=%s ship=%s slot=%s nivel=%s->%s custo=%s'%(account,ship,slot,before,level,cost))
        return reply
    except (server._contas.ErroConta,ValueError,KeyError,IndexError) as exc:return server.recusa('equipment_escalate',seq,str(exc))


def install(server):
    with server.BANCO._lock,server.BANCO._conn:schema(server.BANCO)
    server.MINIMOS['equipment_escalate']=lambda seq,text:upgrade(server,seq,text)
