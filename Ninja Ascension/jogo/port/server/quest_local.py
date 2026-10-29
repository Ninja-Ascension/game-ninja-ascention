"""Daily Quest catalog, authoritative progress and once-per-day rewards.

Local reset is 05:00 UTC. Progress starts when this module is installed;
unsupported activities remain incomplete, never auto-completed.
"""
import json,time
import shop_local as shop
import shop_special_local as special
DEFINITIONS=shop.data.tabela('daily_mission_param.txt')

def schema(db):
    for sql in (
        'CREATE TABLE IF NOT EXISTS local_quest_day(conta_id INTEGER,day TEXT,started INTEGER,PRIMARY KEY(conta_id,day))',
        'CREATE TABLE IF NOT EXISTS local_quest_progress(conta_id INTEGER,day TEXT,condition INTEGER,progress INTEGER NOT NULL DEFAULT 0,PRIMARY KEY(conta_id,day,condition))',
        'CREATE TABLE IF NOT EXISTS local_quest_claim(conta_id INTEGER,day TEXT,kind TEXT,id INTEGER,rewards TEXT,PRIMARY KEY(conta_id,day,kind,id))',
        'CREATE TABLE IF NOT EXISTS local_quest_wallet(conta_id INTEGER,kind INTEGER,amount INTEGER NOT NULL DEFAULT 0,PRIMARY KEY(conta_id,kind))'):
        db._conn.execute(sql)

def add(db,account,condition,value):
    if value>0:db._conn.execute('INSERT INTO local_quest_progress VALUES (?,?,?,?) ON CONFLICT(conta_id,day,condition) DO UPDATE SET progress=progress+excluded.progress',(account,shop.day(),condition,value))

def prepare(db,account):
    db._conn.execute('INSERT OR IGNORE INTO local_quest_day VALUES (?,?,?)',(account,shop.day(),int(time.time())))

def tasks(db,account):
    prepare(db,account)
    grade=db._conn.execute('SELECT grade FROM local_campaign WHERE conta_id=?',(account,)).fetchone();level=grade[0] if grade else 1
    progress={r[0]:r[1] for r in db._conn.execute('SELECT condition,progress FROM local_quest_progress WHERE conta_id=? AND day=?',(account,shop.day()))}
    progress[25]=1
    start=db._conn.execute('SELECT started FROM local_quest_day WHERE conta_id=? AND day=?',(account,shop.day())).fetchone()[0]
    progress[35]=max(0,(int(time.time())-start)//60)
    claimed={r[0] for r in db._conn.execute("SELECT id FROM local_quest_claim WHERE conta_id=? AND day=? AND kind='task'",(account,shop.day()))}
    result=[]
    for ident,row in DEFINITIONS.items():
        if not ident.isdigit() or not int(row[7])<=level<=int(row[8]):continue
        result.append({'daily_task_id':ident,'daily_task_mould_id':ident,'daily_task_complete_count':str(progress.get(int(row[4]),0)),'daily_task_param':str(int(int(ident) in claimed))})
    return sorted(result,key=lambda r:int(r['daily_task_id']))

def wallet(db,account,kind,value):
    db._conn.execute('INSERT INTO local_quest_wallet VALUES (?,?,?) ON CONFLICT(conta_id,kind) DO UPDATE SET amount=amount+excluded.amount',(account,kind,value))

def rewards(db,account,entries):
    for mould,kind,amount in entries:
        if amount<=0:raise ValueError('recompensa_invalida')
        if kind in (1,6,7):shop.grant(db,account,kind,mould,amount)
        elif kind in (2,3):
            field='gold' if kind==2 else 'honour'
            db._conn.execute('UPDATE local_resources SET '+field+'='+field+'+? WHERE conta_id=?',(amount,account))
        elif kind==8:db._conn.execute('INSERT INTO tutorial_progress VALUES (?,?) ON CONFLICT(conta_id) DO UPDATE SET experiencia=experiencia+excluded.experiencia',(account,amount))
        elif kind in (18,28):
            db._conn.execute('INSERT OR IGNORE INTO local_special_wallet(conta_id) VALUES (?)',(account,))
            field='trial' if kind==18 else 'clan'
            db._conn.execute('UPDATE local_special_wallet SET '+field+'='+field+'+? WHERE conta_id=?',(amount,account))
        elif kind in (34,63,67):wallet(db,account,kind,amount)
        else:raise ValueError('tipo_de_recompensa_nao_suportado')

def state_tokens(db,account):
    entries=tasks(db,account)
    extra={str(r[0]):r[1] for r in db._conn.execute('SELECT kind,amount FROM local_quest_wallet WHERE conta_id=?',(account,))}
    flags=['1' if db._conn.execute("SELECT 1 FROM local_quest_claim WHERE conta_id=? AND day=? AND kind='active' AND id=?",(account,shop.day(),i)).fetchone() else '0' for i in range(1,6)]
    return ['1602',str(db.perfil(account)['criada_em']//1000),'15992',json.dumps({'tasks':entries,'points':points(db,account),'boxes':flags,'wallet':extra,'day':shop.day()},separators=(',',':'))]

def points(db,account):
    return sum(item[2] for row in db._conn.execute('SELECT rewards FROM local_quest_claim WHERE conta_id=? AND day=?',(account,shop.day())) for item in json.loads(row[0]) if item[1]==63)

def snapshot(db,account):
    def value(sql):
        row=db._conn.execute(sql,(account,)).fetchone();return int(row[0] or 0) if row else 0
    return {'gold':value('SELECT gold FROM local_resources WHERE conta_id=?'),
            'recruit':value('SELECT total FROM local_recruit_state WHERE conta_id=?'),
            'chest':value('SELECT draws FROM local_shop_state WHERE conta_id=?'),
            'pve':value('SELECT count(*) FROM local_pve_clears WHERE conta_id=?'),
            'advance':value('SELECT count(*) FROM local_hero_quality_receipts WHERE conta_id=?'),
            'purchases':value("SELECT count(*) FROM local_shop_receipts WHERE conta_id=? AND command LIKE 'secret_shop_exchange:%'")}

def install(server):
    db=server.BANCO
    with db._lock,db._conn:
        schema(db)
        import normal_recruit
        normal_recruit.schema(db)
    def handle(command):
        def run(seq,text):
            try:
                account=db.sessao_de(server._sessao_da_conexao())['conta_id'];fields=server._linhas(text)
                while fields and fields[-1]=='':fields.pop()
                if not fields or fields[0]!=str(db.perfil(account)['user_id']):raise ValueError('perfil_invalido')
                with db._lock,db._conn:
                    prepare(db,account)
                    if command=='daily_mission_init':
                        if len(fields)!=1:raise ValueError('pedido_invalido')
                        return ' '.join([str(seq),command,'0']+state_tokens(db,account))
                    if len(fields)!=2:raise ValueError('pedido_invalido')
                    kind='active' if command=='draw_liveness_reward' else 'task'
                    ids=[int(fields[1])+1] if kind=='active' else [int(v) for v in fields[1].split(',')]
                    if not ids or len(ids)!=len(set(ids)):raise ValueError('pedido_duplicado')
                    available={int(t['daily_task_id']):t for t in tasks(db,account)};all_rewards=[]
                    for ident in ids:
                        saved=db._conn.execute('SELECT rewards FROM local_quest_claim WHERE conta_id=? AND day=? AND kind=? AND id=?',(account,shop.day(),kind,ident)).fetchone()
                        if saved:all_rewards.extend(json.loads(saved[0]));continue
                        if kind=='task':
                            task=available.get(ident);row=DEFINITIONS.get(str(ident))
                            if not task or int(task['daily_task_complete_count'])<int(row[5].split(',')[-1]):raise ValueError('tarefa_nao_concluida')
                            for previous in DEFINITIONS.values():
                                if previous[11]==str(ident) and not db._conn.execute("SELECT 1 FROM local_quest_claim WHERE conta_id=? AND day=? AND kind='task' AND id=?",(account,shop.day(),int(previous[0]))).fetchone():raise ValueError('tarefa_anterior_pendente')
                            entries=[]
                            for item in row[6].split('!'):
                                resource,amount=item.split(',');resource_type,mould=map(int,resource.split('-'))
                                entries.append([mould,resource_type,int(amount)])
                        else:
                            row=shop.data.tabela('active_reward.txt').get(str(ident))
                            if not row or points(db,account)<int(row[1]):raise ValueError('pontos_insuficientes')
                            entries=[]
                            for item in row[2].split('|'):
                                resource,mould,amount=map(int,item.split(','));entries.append([mould,resource,amount])
                        db._conn.execute('INSERT OR IGNORE INTO local_campaign(conta_id) VALUES (?)',(account,))
                        rewards(db,account,entries)
                        db._conn.execute('INSERT INTO local_quest_claim VALUES (?,?,?,?,?)',(account,shop.day(),kind,ident,json.dumps(entries)))
                        all_rewards.extend(entries)
                    xp=server.BANCO.experiencia_tutorial(account)
                    tokens=[str(seq),command,'0']+shop.inventory_tokens(db,account)+shop.balances(db,account)+['41',str(xp)]+special.wallet_tokens(db,account)+state_tokens(db,account)+['171','42',str(len(all_rewards))]
                    for item in all_rewards:tokens+=list(map(str,item))
                    return ' '.join(tokens)
            except (server._contas.ErroConta,ValueError,IndexError) as exc:return server.recusa(command,seq,str(exc))
        return run
    for command in ('daily_mission_init','draw_daily_mission_reward','draw_liveness_reward'):server.MINIMOS[command]=handle(command)
    original=getattr(server.despacha,'__quest_original',server.despacha)
    def dispatch(text):
        try:account=db.sessao_de(server._sessao_da_conexao())['conta_id']
        except server._contas.ErroConta:return original(text)
        with db._lock:
            before=snapshot(db,account);reply=original(text)
            if len(reply.split(' ',3))>=3 and reply.split(' ',3)[2]=='0':
                after=snapshot(db,account)
                with db._conn:
                    prepare(db,account)
                    for key,condition in [('recruit',15),('chest',44),('pve',0),('advance',27),('purchases',47)]:add(db,account,condition,max(0,after[key]-before[key]))
                    add(db,account,26,max(0,before['gold']-after['gold']))
            return reply
    dispatch.__quest_original=original;server.despacha=dispatch
