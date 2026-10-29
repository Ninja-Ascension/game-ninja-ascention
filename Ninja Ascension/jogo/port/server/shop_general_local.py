"""General shop: saved offers, stock and atomic purchases.

Local rotation policy: up to eight groups from secret_shop_info, one weighted
offer each; refresh times come from shop_config 1. Prices are unmodified.
"""
import datetime,json,re,secrets,time
import shop_local as shop

def schema(db):
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_general_shop(conta_id INTEGER PRIMARY KEY,period INTEGER,offers TEXT,refresh_day TEXT,refreshes INTEGER NOT NULL DEFAULT 0)')

def boundary():
    now=datetime.datetime.now(datetime.timezone.utc)
    times=[now.replace(hour=int(t.split(':')[0]),minute=0,second=0,microsecond=0) for t in shop.CONFIG['1'].split(',')]
    past=[t for t in times if t<=now];future=[t for t in times if t>now]
    return int((past[-1] if past else times[-1]-datetime.timedelta(days=1)).timestamp()),int((future[0] if future else times[0]+datetime.timedelta(days=1)).timestamp())

def make_offers(level):
    groups={}
    for r in shop.data.tabela('secret_shop_info.txt').values():
        low,high=map(int,r[9].split(','))
        if int(r[2]) in (0,2) and int(r[3]) in (1,2) and low<=level<=high:
            groups.setdefault(int(r[8]),[]).append(r)
    offers=[]
    for group,rows in sorted(groups.items())[:8]:
        roll=secrets.randbelow(sum(int(r[6]) for r in rows))
        for r in rows:
            roll-=int(r[6])
            if roll<0:
                offers.append({'id':int(r[0]),'stock':1});break
    return offers

def state(db,account):
    period,next_time=boundary()
    row=db._conn.execute('SELECT period,offers,refresh_day,refreshes FROM local_general_shop WHERE conta_id=?',(account,)).fetchone()
    if not row or row[0]!=period:
        grade=db._conn.execute('SELECT grade FROM local_campaign WHERE conta_id=?',(account,)).fetchone()
        offers=make_offers(grade[0] if grade else 1)
        count=row[3] if row and row[2]==shop.day() else 0
        db._conn.execute('INSERT INTO local_general_shop VALUES (?,?,?,?,?) ON CONFLICT(conta_id) DO UPDATE SET period=excluded.period,offers=excluded.offers,refresh_day=excluded.refresh_day,refreshes=excluded.refreshes',(account,period,json.dumps(offers),shop.day(),count))
    else:offers=json.loads(row[1]);count=row[3] if row[2]==shop.day() else 0
    return offers,count,next_time

def tokens(db,account):
    offers,count,next_time=state(db,account);result=['197',str(len(offers))]
    for index,offer in enumerate(offers):
        r=shop.data.tabela('secret_shop_info.txt')[str(offer['id'])]
        result += list(map(str,[index,int(r[2]),int(r[1]),int(r[3]),int(r[4]),offer['stock'],int(r[5]),int(r[7])]))
    return result+[str(max(0,next_time-int(time.time()))*1000),str(count)]

def install(server):
    db=server.BANCO
    with db._lock,db._conn:schema(db)
    def handle(command):
        def run(seq,text):
            try:
                account=db.sessao_de(server._sessao_da_conexao())['conta_id'];fields=server._linhas(text)
                if not fields or fields[0]!=str(db.perfil(account)['user_id']):raise ValueError('perfil_invalido')
                with db._lock,db._conn:
                    if command=='secret_shop_init':
                        # Original command serializer appends an empty param_list.
                        while fields and fields[-1]=='':fields.pop()
                        if len(fields)!=1:raise ValueError('pedido_invalido')
                        return ' '.join([str(seq),command,'0']+tokens(db,account))
                    expected=2 if command=='secret_shop_refresh' else 3
                    if len(fields)!=expected or not re.fullmatch(r'[0-9A-Za-z:-]{1,100}',fields[-1]):raise ValueError('pedido_invalido')
                    saved=db._conn.execute('SELECT command,reply FROM local_shop_receipts WHERE conta_id=? AND request_id=?',(account,fields[-1])).fetchone()
                    signature=command+':'+':'.join(fields[1:-1])
                    if saved:
                        if saved[0]!=signature:raise ValueError('identificador_reutilizado')
                        return str(seq)+' '+saved[1].split(' ',1)[1]
                    if command=='secret_shop_exchange':
                        current=db._conn.execute('SELECT period FROM local_general_shop WHERE conta_id=?',(account,)).fetchone()
                        if not current or current[0]!=boundary()[0]:
                            # Never silently replace a displayed offer before
                            # charging for it when an automatic rotation occurs.
                            raise ValueError('loja_desatualizada_reabra_a_aba')
                    offers,count,_=state(db,account)
                    if command=='secret_shop_refresh':
                        if count>=int(shop.CONFIG['2']):raise ValueError('limite_de_atualizacoes')
                        costs=list(map(int,shop.CONFIG['3'].split(',')));cost=costs[min(count,len(costs)-1)]
                        gold=db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?',(account,)).fetchone()
                        if not gold or gold[0]<cost:raise ValueError('gold_insuficiente')
                        grade=db._conn.execute('SELECT grade FROM local_campaign WHERE conta_id=?',(account,)).fetchone()
                        offers=make_offers(grade[0] if grade else 1)
                        if not offers:raise ValueError('catalogo_vazio')
                        db._conn.execute('UPDATE local_resources SET gold=gold-? WHERE conta_id=?',(cost,account))
                        db._conn.execute('UPDATE local_general_shop SET offers=?,refresh_day=?,refreshes=? WHERE conta_id=?',(json.dumps(offers),shop.day(),count+1,account))
                        reply=' '.join([str(seq),command,'0','25',str(-cost),str(gold[0]-cost)]+tokens(db,account))
                        db._conn.execute('INSERT INTO local_shop_receipts VALUES (?,?,?,?)',(account,fields[-1],signature,reply))
                        server.log('SHOP_LOCAL cmd=%s conta=%s atualizacoes=%s gold_gasto=%s'%(command,account,count+1,cost))
                        return reply
                    index=int(fields[1])
                    if index<0 or index>=len(offers):raise ValueError('oferta_ausente')
                    offer=offers[index]
                    if offer['stock']<1:raise ValueError('estoque_esgotado')
                    r=shop.data.tabela('secret_shop_info.txt')[str(offer['id'])];cost=int(r[5]);gold_cost=0
                    db._conn.execute('INSERT OR IGNORE INTO local_campaign(conta_id) VALUES (?)',(account,))
                    if r[3]=='1':
                        gold=db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?',(account,)).fetchone()[0]
                        if gold<cost:raise ValueError('gold_insuficiente')
                        db._conn.execute('UPDATE local_resources SET gold=gold-? WHERE conta_id=?',(cost,account));gold_cost=-cost
                    else:
                        silver=db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?',(account,)).fetchone()[0]
                        if silver<cost:raise ValueError('ryo_insuficiente')
                        db._conn.execute('UPDATE local_campaign SET silver=silver-? WHERE conta_id=?',(cost,account))
                    reward=shop.grant(db,account,6 if r[2]=='0' else 7,int(r[1]),int(r[4]))
                    offer['stock']-=1
                    db._conn.execute('UPDATE local_general_shop SET offers=? WHERE conta_id=?',(json.dumps(offers),account))
                    # Original purchase callback decrements the visible stock;
                    # do not send a second stock decrement in this response.
                    result=[str(seq),command,'0']+shop.inventory_tokens(db,account)+shop.balances(db,account,gold_cost)+shop.state_tokens(db,account,[reward])
                    reply=' '.join(result)
                    db._conn.execute('INSERT INTO local_shop_receipts VALUES (?,?,?,?)',(account,fields[-1],signature,reply))
                server.log('SHOP_LOCAL cmd=%s conta=%s slot=%s'%(command,account,index));return reply
            except (server._contas.ErroConta,ValueError,IndexError) as exc:return server.recusa(command,seq,str(exc))
        return run
    for command in ('secret_shop_init','secret_shop_exchange','secret_shop_refresh'):server.MINIMOS[command]=handle(command)
