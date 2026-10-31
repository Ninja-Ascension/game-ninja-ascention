"""Arena, Trial and Clan shops with separate currencies and saved stock.

Local offer rotation: one weighted entry per recovered slot/group, using the
same schedule and manual refresh price table as General Shop. No currency
is granted automatically. Local Clan Shop access is configured separately.
"""
import json,re
import shop_local as shop
import shop_general_local as general

TABLES={3:'arena_shop_info.txt',4:'glories_shop_info.txt',5:'union_shop_library.txt'}
INITS={'arena_shop_init':3,'glories_shop_init':4,'union_shop_init':5}
BUYS={'arena_shop_exchange':3,'glories_shop_exchange':4,'union_shop_exchange':5}

def schema(db):
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_clan_membership(conta_id INTEGER PRIMARY KEY,clan_id INTEGER NOT NULL CHECK(clan_id>0),clan_name TEXT NOT NULL)')
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_special_wallet(conta_id INTEGER PRIMARY KEY,trial INTEGER NOT NULL DEFAULT 0,clan INTEGER NOT NULL DEFAULT 0)')
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_special_shop(conta_id INTEGER,page INTEGER,period INTEGER,offers TEXT,refresh_day TEXT,refreshes INTEGER NOT NULL DEFAULT 0,PRIMARY KEY(conta_id,page))')

def definition(page,row):
    if page==3:return int(row[1]),6,int(row[3]),int(row[4]),int(row[5])
    if page==4:return int(row[1]),6,int(row[3]),int(row[4]),int(row[5])
    return int(row[3]),6 if row[2]=='0' else 7,int(row[4]),int(row[11]),int(row[9])

def make_offers(page,level):
    groups={}
    for row in shop.data.tabela(TABLES[page]).values():
        if page==3:
            if row[7]!='0':continue
            slot,weight=int(row[15]),int(row[16]);low,high=map(int,row[17].split(','))
        elif page==4:slot,weight=int(row[9]),int(row[10]);low,high=map(int,row[11].split(','))
        else:slot,weight=int(row[1]),int(row[10]);low,high=map(int,row[12].split(','))
        if low<=level<=high and weight>0:groups.setdefault(slot,[]).append((row,weight))
    offers=[]
    for slot,rows in sorted(groups.items()):
        roll=shop.secrets.randbelow(sum(w for _,w in rows))
        for row,weight in rows:
            roll-=weight
            if roll<0:offers.append({'id':int(row[0]),'bought':0});break
    return offers

def balance(db,account,page):
    if page==3:
        row=db._conn.execute('SELECT honour FROM local_resources WHERE conta_id=?',(account,)).fetchone();return row[0] if row else 0
    db._conn.execute('INSERT OR IGNORE INTO local_special_wallet(conta_id) VALUES (?)',(account,))
    return db._conn.execute('SELECT '+('trial' if page==4 else 'clan')+' FROM local_special_wallet WHERE conta_id=?',(account,)).fetchone()[0]

def wallet_tokens(db,account):
    with db._lock,db._conn:
        schema(db)
        clan=db._conn.execute('SELECT clan_id,clan_name FROM local_clan_membership WHERE conta_id=?',(account,)).fetchone()
        return ['15991',json.dumps({'wallet':{str(p):balance(db,account,p) for p in TABLES},'clan':{'id':clan[0],'nameHex':clan[1].encode('utf8').hex()} if clan else False},separators=(',',':'))]

def require_clan(db,account,page):
    if page==5 and not db._conn.execute('SELECT 1 FROM local_clan_membership WHERE conta_id=?',(account,)).fetchone():raise ValueError('participacao_em_cla_obrigatoria')

def state(db,account,page):
    period,_=general.boundary()
    saved=db._conn.execute('SELECT period,offers,refresh_day,refreshes FROM local_special_shop WHERE conta_id=? AND page=?',(account,page)).fetchone()
    count=saved[3] if saved and saved[2]==shop.day() else 0
    if not saved or saved[0]!=period:
        grade=db._conn.execute('SELECT grade FROM local_campaign WHERE conta_id=?',(account,)).fetchone()
        offers=make_offers(page,grade[0] if grade else 1)
        db._conn.execute('INSERT INTO local_special_shop VALUES (?,?,?,?,?,?) ON CONFLICT(conta_id,page) DO UPDATE SET period=excluded.period,offers=excluded.offers,refresh_day=excluded.refresh_day,refreshes=excluded.refreshes',(account,page,period,json.dumps(offers),shop.day(),count))
    else:offers=json.loads(saved[1])
    return offers,count

def tokens(db,account,page):
    offers,count=state(db,account,page)
    return ['15991',json.dumps({'page':page,'offers':offers,'refreshes':count,'wallet':{str(p):balance(db,account,p) for p in TABLES}},separators=(',',':'))]

def install(server):
    db=server.BANCO
    with db._lock,db._conn:schema(db)
    def handler(command):
        def run(seq,text):
            try:
                fields=server._linhas(text);account=db.sessao_de(server._sessao_da_conexao())['conta_id']
                if not fields or fields[0]!=str(db.perfil(account)['user_id']):raise ValueError('perfil_invalido')
                with db._lock,db._conn:
                    if command in INITS:
                        require_clan(db,account,INITS[command])
                        tail=fields[1:]
                        if tail not in ([],[''],['0','0']):raise ValueError('pedido_invalido')
                        return ' '.join([str(seq),command,'0']+tokens(db,account,INITS[command]))
                    if not re.fullmatch(r'[0-9A-Za-z:-]{1,100}',fields[-1]):raise ValueError('pedido_invalido')
                    signature=command+':'+':'.join(fields[1:-1]);key=fields[-1]
                    saved=db._conn.execute('SELECT command,reply FROM local_shop_receipts WHERE conta_id=? AND request_id=?',(account,key)).fetchone()
                    if saved:
                        if signature!=saved[0]:raise ValueError('identificador_reutilizado')
                        return str(seq)+' '+saved[1].split(' ',1)[1]
                    refresh=command=='shop_request_product_refresh'
                    if refresh:
                        if len(fields)!=3 or fields[1] not in ('2','3','4'):raise ValueError('pedido_invalido')
                        page=int(fields[1])+1
                    else:
                        page=BUYS[command]
                        expected=5 if page==5 else 4
                        if len(fields)!=expected or fields[-2]!='1' or (page==5 and fields[2]!='2'):raise ValueError('quantidade_ou_tipo_invalido')
                        previous=db._conn.execute('SELECT period FROM local_special_shop WHERE conta_id=? AND page=?',(account,page)).fetchone()
                        if not previous or previous[0]!=general.boundary()[0]:raise ValueError('loja_desatualizada_reabra_a_aba')
                    require_clan(db,account,page)
                    offers,count=state(db,account,page);delta=0;results=None
                    if refresh:
                        if count>=int(shop.CONFIG['2']):raise ValueError('limite_de_atualizacoes')
                        costs=list(map(int,shop.CONFIG['3'].split(',')));cost=costs[min(count,len(costs)-1)]
                        gold=db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?',(account,)).fetchone()
                        if not gold or gold[0]<cost:raise ValueError('gold_insuficiente')
                        level=db._conn.execute('SELECT grade FROM local_campaign WHERE conta_id=?',(account,)).fetchone()
                        offers=make_offers(page,level[0] if level else 1);count+=1;delta=-cost
                        db._conn.execute('UPDATE local_resources SET gold=gold-? WHERE conta_id=?',(cost,account))
                    else:
                        index=int(fields[1])-(0 if page==5 else 1)
                        if not 0<=index<len(offers):raise ValueError('oferta_ausente')
                        offer=offers[index];row=shop.data.tabela(TABLES[page])[str(offer['id'])]
                        mould,kind,quantity,cost,limit=definition(page,row)
                        if cost<0 or limit>0 and offer['bought']>=limit:raise ValueError('estoque_esgotado')
                        if balance(db,account,page)<cost:raise ValueError('moeda_da_loja_insuficiente')
                        if page==3:db._conn.execute('UPDATE local_resources SET honour=honour-? WHERE conta_id=?',(cost,account))
                        else:db._conn.execute('UPDATE local_special_wallet SET '+('trial' if page==4 else 'clan')+'='+('trial' if page==4 else 'clan')+'-? WHERE conta_id=?',(cost,account))
                        results=[shop.grant(db,account,kind,mould,quantity)];offer['bought']+=1
                    db._conn.execute('UPDATE local_special_shop SET offers=?,refresh_day=?,refreshes=? WHERE conta_id=? AND page=?',(json.dumps(offers),shop.day(),count,account,page))
                    reply=' '.join([str(seq),command,'0']+shop.inventory_tokens(db,account)+shop.balances(db,account,delta)+shop.state_tokens(db,account,results)+tokens(db,account,page))
                    db._conn.execute('INSERT INTO local_shop_receipts VALUES (?,?,?,?)',(account,key,signature,reply))
                server.log('SHOP_SPECIAL cmd=%s conta=%s page=%s'%(command,account,page));return reply
            except (server._contas.ErroConta,ValueError,IndexError) as exc:return server.recusa(command,seq,str(exc))
        return run
    for command in list(INITS)+list(BUYS)+['shop_request_product_refresh']:server.MINIMOS[command]=handler(command)
