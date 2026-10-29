"""Recovered Eight Gates requirements, levels, costs and skill selection."""
import json,re
import dados_batalha as data
COMMANDS=('mega_unblock','mega_level_up','mega_use_skill')
def schema(db):
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_hero_gates(conta_id INTEGER,ship_id INTEGER,state TEXT,PRIMARY KEY(conta_id,ship_id))')
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_hero_gate_receipts(conta_id INTEGER,request_id TEXT,signature TEXT,reply TEXT,PRIMARY KEY(conta_id,request_id))')
def state(db,account,ship):
    row=db._conn.execute('SELECT state FROM local_hero_gates WHERE conta_id=? AND ship_id=?',(account,ship)).fetchone()
    return json.loads(row[0]) if row else dict(megaLevel={},megaUse=[])
def row_for(file,ability,page):
    row=next((v for v in data.tabela(file).values() if int(v[1])==ability and int(v[2])==page),None)
    if row is None:raise ValueError('portao_sem_configuracao')
    return row

def check(db,account,ship,mould,page,s):
    import hero_development_local as dev
    import hero_quality_local as quality
    import recruitment_local as heroes
    r=data.tabela('ship_mould.txt')[str(mould)];develop=dev.state(db,account,ship,mould);order=quality.quality(db,account,ship,mould)
    for condition in row_for('mega_unblock.txt',int(r[8]),page)[3].split('|'):
        kind,a,b=map(int,condition.split(','));valid=False
        if kind==1:valid=develop['star']>=b
        elif kind==2:valid=order>=b
        elif kind==3:
            valid=sum(v[0] for i,v in enumerate(develop['souls']) if order>=int(data.tabela('ship_soul_mould.txt')[r[74].split(',')[i]][1]))>=b
        elif kind==4:valid=int(s['megaLevel'].get(str(a),-1))>=b
        elif kind==5:
            # Total awakening stars of the ninja's equipment (MegaBigTree.judgeType 5).
            import equipment_development_local as ed
            valid=sum(ed.appearance(db,account,ship,mould)[0])>=b
        elif kind in (6,9):
            # 6: total level of the mudras equipped; 9: 18 mudras, all quality >= b.
            import mudra_local as mu
            ids=[i for g in mu.slots(db,account,ship).values() for i in g.values()]
            rows=[db._conn.execute('SELECT mould,level FROM local_metals WHERE id=?',(i,)).fetchone() for i in ids]
            rows=[x for x in rows if x]
            if kind==6:valid=sum(int(x[1]) for x in rows)>=b
            else:valid=len(rows)>=18 and all(int(mu.metal_row(x[0])[5])>=b for x in rows)
        elif kind in (7,8):
            required=data.tabela('mega_ship.txt')[str(mould)][5].split(',');owned={str(m):sid for sid,m in heroes.all_owned(db,account)}
            valid=all(k in owned for k in required)
            if valid:
                if kind==7:valid=all(quality.quality(db,account,owned[k],int(k))>=b for k in required)
                else:valid=all(int(state(db,account,owned[k])['megaLevel'].get(str(a),-1))>=b for k in required)
        if not valid:raise ValueError('requisito_do_portao_nao_cumprido_'+str(kind))

def snapshot(db,account):
    import recruitment_local as heroes
    return ['15996',json.dumps([dict(shipId=str(ship),info=state(db,account,ship)) for ship,mould in heroes.all_owned(db,account)],separators=(',',':'))]

def execute(server,cmd,seq,text):
    import recruitment_local as heroes
    from hero_training_local import inventory_tokens
    db=server.BANCO
    try:
        account=db.sessao_de(server._sessao_da_conexao())['conta_id'];f=server._linhas(text)
        if len(f)!=(5 if cmd=='mega_use_skill' else 4) or f[0]!=str(db.perfil(account)['user_id']) or not re.fullmatch(r'[0-9A-Za-z:-]{1,100}',f[-1]):raise ValueError('pedido_de_portao_invalido')
        ship,page=int(f[1]),int(f[2]);key=f[-1];signature=cmd+'|'+ '|'.join(f[1:-1])
        if not 1<=page<=8:raise ValueError('portao_invalido')
        with db._lock,db._conn:
            receipt=db._conn.execute('SELECT signature,reply FROM local_hero_gate_receipts WHERE conta_id=? AND request_id=?',(account,key)).fetchone()
            if receipt:
                if receipt[0]!=signature:raise ValueError('identificador_reutilizado')
                return str(seq)+' '+receipt[1].split(' ',1)[1]
            mould=dict(heroes.all_owned(db,account)).get(ship)
            if not mould:raise ValueError('personagem_nao_pertence_a_conta')
            s=state(db,account,ship);r=data.tabela('ship_mould.txt')[str(mould)];ability=int(r[8]);pagekey=str(page);silver=0;costs={};equip_costs={}
            if cmd=='mega_unblock':
                if pagekey in s['megaLevel']:raise ValueError('portao_ja_desbloqueado')
                check(db,account,ship,mould,page,s);s['megaLevel'][pagekey]=0
            elif cmd=='mega_level_up':
                if pagekey not in s['megaLevel']:raise ValueError('desbloqueie_o_portao')
                level=int(s['megaLevel'][pagekey])
                if level>=10:raise ValueError('portao_no_nivel_maximo')
                for pair in row_for('mega_expend.txt',ability,page)[level+3].split('|'):
                    kind,n=map(int,pair.split(','))
                    if kind==2:silver+=n
                    elif kind==1:
                        prop=next(v for v in data.tabela('prop_mould.txt').values() if v[39]==str(mould) and v[8]=='1');ident=int(prop[0]);costs[ident]=costs.get(ident,0)+n
                    elif kind==3:costs[223]=costs.get(223,0)+n
                    elif kind==6:
                        # MegaSmallTree.judgeType 6 shows the ninja's own fragment card.
                        prop=next(v for v in data.tabela('prop_mould.txt').values() if v[39]==str(mould) and v[8]=='1');ident=int(prop[0]);costs[ident]=costs.get(ident,0)+n
                    elif kind in (4,5,7):
                        # Second cost item of the awakening table of equipment slot 6/5/1.
                        tpl=data.tabela('ship_mould.txt')[str(mould)][72].split(',')[{4:5,5:4,7:0}[kind]]
                        eq=data.tabela('equipment_mould.txt')[tpl];seat=data.tabela('equipment_mould.txt')[eq[42]] if eq[42] in data.tabela('equipment_mould.txt') else eq
                        group=seat[46]
                        star=next(v for v in data.tabela('equipment_star.txt').values() if v[1]==group and v[5] not in ('-1',''))
                        ck,item,_=map(int,star[5].split('|')[1].split(','))
                        if ck==7:equip_costs[item]=equip_costs.get(item,0)+n
                        else:costs[item]=costs.get(item,0)+n
                    else:raise ValueError('custo_de_portao_desconhecido_'+str(kind))
                s['megaLevel'][pagekey]=level+1
            else:
                if page not in (2,4,6) or int(s['megaLevel'].get(pagekey,-1))<10 or f[3] not in ('1','2'):raise ValueError('habilidade_do_portao_nao_liberada')
                s['megaUse']=[v for v in s['megaUse'] if int(v)!=page]
                if f[3]=='1':s['megaUse'].append(page)
            balance=db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?',(account,)).fetchone()[0]
            if balance<silver:raise ValueError('ryo_insuficiente')
            for ident,n in costs.items():
                inv=db._conn.execute('SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=?',(account,ident)).fetchone()
                if not inv or inv[0]<n:raise ValueError('materiais_insuficientes')
            for ident,n in equip_costs.items():
                got=db._conn.execute('SELECT id FROM local_shop_equipment WHERE conta_id=? AND mould=? ORDER BY id LIMIT ?',(account,ident,n)).fetchall()
                if len(got)<n:raise ValueError('equipamentos_insuficientes')
            for ident,n in costs.items():db._conn.execute('UPDATE local_inventory SET quantity=quantity-? WHERE conta_id=? AND mould=?',(n,account,ident))
            for ident,n in equip_costs.items():
                for (rid,) in db._conn.execute('SELECT id FROM local_shop_equipment WHERE conta_id=? AND mould=? ORDER BY id LIMIT ?',(account,ident,n)).fetchall():
                    db._conn.execute('DELETE FROM local_shop_equipment WHERE id=?',(rid,))
            db._conn.execute('UPDATE local_campaign SET silver=silver-? WHERE conta_id=?',(silver,account))
            db._conn.execute('INSERT INTO local_hero_gates VALUES (?,?,?) ON CONFLICT(conta_id,ship_id) DO UPDATE SET state=excluded.state',(account,ship,json.dumps(s)))
            reply=' '.join([str(seq),cmd,'0','22',str(balance-silver)]+inventory_tokens(db,account)+snapshot(db,account))
            db._conn.execute('INSERT INTO local_hero_gate_receipts VALUES (?,?,?,?)',(account,key,signature,reply))
        server.log('HERO_GATES conta=%s ship=%s portao=%s cmd=%s salvo'%(account,ship,page,cmd));return reply
    except (server._contas.ErroConta,ValueError,KeyError,IndexError,StopIteration) as exc:return server.recusa(cmd,seq,str(exc) or 'configuracao_de_portao_indisponivel')

def install(server):
    with server.BANCO._lock,server.BANCO._conn:schema(server.BANCO)
    for command in COMMANDS:server.MINIMOS[command]=lambda seq,text,cmd=command:execute(server,cmd,seq,text)
