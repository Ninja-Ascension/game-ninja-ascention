"""Persistent Promote, skill and cursed-seal operations from recovered tables."""
import json,re
import dados_batalha as data
COMMANDS=('ship_awaken','ship_skill_level_up','ship_skill_level_up_one_key','ship_soul_level_up')
def schema(db):
    db._conn.execute("CREATE TABLE IF NOT EXISTS local_hero_skill_points(conta_id INTEGER PRIMARY KEY,points INTEGER NOT NULL DEFAULT 1000000)")
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_hero_development(conta_id INTEGER,ship_id INTEGER,state TEXT,PRIMARY KEY(conta_id,ship_id))')
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_hero_development_receipts(conta_id INTEGER,request_id TEXT,signature TEXT,reply TEXT,PRIMARY KEY(conta_id,request_id))')
def state(db,account,ship,mould):
    r=data.tabela('ship_mould.txt')[str(mould)]
    row=db._conn.execute('SELECT state FROM local_hero_development WHERE conta_id=? AND ship_id=?',(account,ship)).fetchone()
    return json.loads(row[0]) if row else dict(star=int(r[48]),skills=[1]*6,souls=[[1,0] for _ in r[74].split(',')])
def soul_text(s):return '|'.join(','.join(map(str,v)) for v in s['souls'])
def execute(server,cmd,seq,text):
    import recruitment_local as heroes
    import hero_level_local as levels
    import hero_quality_local as quality
    from hero_training_local import inventory_tokens
    db=server.BANCO
    try:
        account=db.sessao_de(server._sessao_da_conexao())['conta_id'];f=server._linhas(text)
        lengths={'ship_awaken':3,'ship_skill_level_up':5,'ship_skill_level_up_one_key':5,'ship_soul_level_up':6}
        if len(f)!=lengths[cmd] or f[0]!=str(db.perfil(account)['user_id']) or not re.fullmatch(r'[0-9A-Za-z:-]{1,100}',f[-1]):raise ValueError('pedido_de_melhoria_invalido')
        key=f[-1];signature=cmd+'|'+ '|'.join(f[1:-1]);ship=int(f[1])
        with db._lock,db._conn:
            old=db._conn.execute('SELECT signature,reply FROM local_hero_development_receipts WHERE conta_id=? AND request_id=?',(account,key)).fetchone()
            if old:
                if old[0]!=signature:raise ValueError('identificador_reutilizado')
                return str(seq)+' '+old[1].split(' ',1)[1]
            mould=dict(heroes.all_owned(db,account)).get(ship)
            if not mould:raise ValueError('personagem_nao_pertence_a_conta')
            r=data.tabela('ship_mould.txt')[str(mould)];s=state(db,account,ship,mould)
            level=levels.state(db,account,ship,mould)[0];order=quality.quality(db,account,ship,mould)
            costs={};silver=0;spent_points=0
            def cost(prop,n):
                if int(prop)>0 and int(n)>0:costs[int(prop)]=costs.get(int(prop),0)+int(n)
            if cmd=='ship_awaken':
                row=next((v for v in data.tabela('awaken_requirement.txt').values() if v[1]==r[60] and int(v[2])==s['star']),None)
                if s['star']>=7 or not row:raise ValueError('promocao_maxima')
                if level<int(row[3]):raise ValueError('nivel_insuficiente')
                if any(int(v)>0 for v in row[4:8]):raise ValueError('promocao_exige_equipamentos')
                cost(row[8],row[9]);silver=int(row[11])
                if int(row[10])>0:
                    prop=next((v for v in data.tabela('prop_mould.txt').values() if v[39]==str(mould) and v[42]=='1'),None)
                    if not prop:raise ValueError('fragmento_nao_encontrado')
                    cost(prop[0],row[10])
                s['star']+=1
            elif cmd.startswith('ship_skill'):
                entries=[(int(f[2]),1)] if cmd=='ship_skill_level_up' else [tuple(map(int,x.split(':'))) for x in f[2].split('|')]
                supplied=f[3].split('|')
                if len(entries)!=len(supplied) or len({i for i,n in entries})!=len(entries):raise ValueError('habilidades_invalidas')
                # Evo talents are the exact six skills used by this client.
                evo=data.tabela('ship_evo_mould.txt')[r[71].split(',')[0]]
                # Column is checked against the authoritative LocalDatas definition.
                talents=evo[TALENT_COLUMN].split('|')
                for (index,count),talent in zip(entries,supplied):
                    if not 1<=index<=len(talents) or not 1<=count<=100:raise ValueError('habilidade_invalida')
                    if talents[index-1].split(',')[2]!=talent:raise ValueError('talento_incorreto')
                    if s['skills'][index-1]+count>level:raise ValueError('habilidade_limitada_ao_nivel')
                    t=data.tabela('talent_mould.txt')[talent];group=int(t[17])
                    for current in range(s['skills'][index-1],s['skills'][index-1]+count):
                        req=next(v for v in data.tabela('talent_level_requirement.txt').values() if int(v[1])==current)
                        silver+=int(req[group+1])
                    s['skills'][index-1]+=count
                    spent_points+=count
            else:
                if f[2]!='0':raise ValueError('modo_de_selo_nao_suportado')
                index=int(f[3]);factions=r[74].split(',');groups=r[75].split(',')
                if not 0<=index<len(factions):raise ValueError('selo_invalido')
                if order<int(data.tabela('ship_soul_mould.txt')[factions[index]][1]):raise ValueError('avance_o_personagem_para_liberar_o_selo')
                lv,exp=s['souls'][index]
                if lv>=20:raise ValueError('selo_no_nivel_maximo')
                for entry in f[4].split('|'):
                    ident,n=map(int,entry.split(','))
                    if not 1<=n<=1000000:raise ValueError('quantidade_invalida')
                    inv=db._conn.execute('SELECT mould FROM local_inventory WHERE conta_id=? AND instance_id=?',(account,ident)).fetchone()
                    if not inv:raise ValueError('item_nao_pertence_a_conta')
                    prop=data.tabela('prop_mould.txt')[str(inv[0])]
                    # The recovered UI accepts every material with positive soul EXP,
                    # including the primary essence 243 (use_type 7).
                    if int(prop[59])<=0:raise ValueError('material_de_selo_invalido')
                    cost(inv[0],n);exp+=int(prop[59])*n
                while lv<20:
                    req=next(v for v in data.tabela('ship_soul_experience_param.txt').values() if v[1]==groups[index] and int(v[2])==lv)
                    if exp<int(req[3]):break
                    exp-=int(req[3]);lv+=1
                s['souls'][index]=[lv,0 if lv==20 else exp]
            db._conn.execute('INSERT OR IGNORE INTO local_hero_skill_points(conta_id) VALUES (?)',(account,))
            points=db._conn.execute('SELECT points FROM local_hero_skill_points WHERE conta_id=?',(account,)).fetchone()[0]
            if points<spent_points:raise ValueError('pontos_de_habilidade_insuficientes')
            balance=db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?',(account,)).fetchone()[0]
            if balance<silver:raise ValueError('ryo_insuficiente')
            for prop,n in costs.items():
                inv=db._conn.execute('SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=?',(account,prop)).fetchone()
                if not inv or inv[0]<n:raise ValueError('materiais_insuficientes')
            for prop,n in costs.items():db._conn.execute('UPDATE local_inventory SET quantity=quantity-? WHERE conta_id=? AND mould=?',(n,account,prop))
            db._conn.execute('UPDATE local_campaign SET silver=silver-? WHERE conta_id=?',(silver,account))
            db._conn.execute('UPDATE local_hero_skill_points SET points=points-? WHERE conta_id=?',(spent_points,account))
            db._conn.execute('INSERT INTO local_hero_development VALUES (?,?,?) ON CONFLICT(conta_id,ship_id) DO UPDATE SET state=excluded.state',(account,ship,json.dumps(s)))
            character=heroes.one_ship_tokens(db,account,(ship,mould));metadata=character[character.index('14104'):]
            reply=' '.join([str(seq),cmd,'0','22',str(balance-silver)]+inventory_tokens(db,account)+metadata+['15994',json.dumps(dict(ship=str(ship),soul=soul_text(s)),separators=(',',':'))])
            db._conn.execute('INSERT INTO local_hero_development_receipts VALUES (?,?,?,?)',(account,key,signature,reply))
        server.log('HERO_DEVELOPMENT conta=%s ship=%s cmd=%s salvo'%(account,ship,cmd));return reply
    except (server._contas.ErroConta,ValueError,KeyError,IndexError,StopIteration) as exc:return server.recusa(cmd,seq,str(exc) or 'configuracao_de_melhoria_indisponivel')
TALENT_COLUMN=7
