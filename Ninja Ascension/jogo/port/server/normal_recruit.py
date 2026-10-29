"""Local normal recruitment, independent of educational missions.

Uses recovered pools/weights and costs. Local pity policy: SR at ten,
SSR at one hundred draws without those qualities. Not the old server's
unrecovered global/double/wishlist algorithm.
"""
import datetime,json,re,secrets
from pathlib import Path
import dados_batalha as data

CONFIG={r[0]:r[3] for line in (Path(data.MOULD).parent/'configs/play_config.txt').read_text(encoding='utf8').splitlines() if len(r:=line.split('\t'))>=4}
def schema(db):
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_recruit_state (conta_id INTEGER PRIMARY KEY REFERENCES contas(id) ON DELETE CASCADE,total INTEGER NOT NULL DEFAULT 0,since_sr INTEGER NOT NULL DEFAULT 0,since_ssr INTEGER NOT NULL DEFAULT 0,free_day TEXT NOT NULL DEFAULT "")')
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_recruit_receipt (conta_id INTEGER NOT NULL REFERENCES contas(id) ON DELETE CASCADE,request_id TEXT NOT NULL,count INTEGER NOT NULL,reply TEXT NOT NULL,results TEXT NOT NULL,PRIMARY KEY(conta_id,request_id))')

def day():
    return (datetime.datetime.now(datetime.timezone.utc)-datetime.timedelta(hours=5)).date().isoformat()

def state_payload(db,account):
    with db._lock:
        schema(db)
        row=db._conn.execute('SELECT total,free_day FROM local_recruit_state WHERE conta_id=?',(account,)).fetchone()
    return {'totalDraw':int(row[0]) if row else 0,'totalFreeDraw':0 if row and row[1]==day() else 1,'newRecruitmentShop':__import__('recruit_shop_local').remaining(db,account)}

def choose(group):
    rows=[r for r in data.tabela('new_draw_card_library_group.txt').values() if int(r[1])==group and int(r[6])>0]
    total=sum(int(r[6]) for r in rows)
    if not total:raise ValueError('biblioteca_de_recrutamento_vazia')
    value=secrets.randbelow(total)
    for row in rows:
        value-=int(row[6])
        if value<0:return list(map(int,row[4].split(',')))

def fragment(mould):
    for row in data.tabela('prop_mould.txt').values():
        if int(row[42])==1 and int(row[39])==mould and int(row[9])>0:
            return int(row[0]),int(row[9])
    raise ValueError('fragmento_do_personagem_ausente')

def draw(server,seq,text):
    db=server.BANCO
    import recruitment_local as heroes
    from hero_training_local import inventory_tokens
    try:
        account=db.sessao_de(server._sessao_da_conexao())['conta_id'];fields=server._linhas(text)
        if len(fields)!=3 or fields[0]!=str(db.perfil(account)['user_id']) or fields[1] not in ('1','10') or not re.fullmatch(r'[0-9A-Za-z:-]{1,100}',fields[2]):
            raise ValueError('pedido_de_recrutamento_invalido')
        count=int(fields[1]);request_id=fields[2]
        with db._lock:
            schema(db)
            saved=db._conn.execute('SELECT count,reply FROM local_recruit_receipt WHERE conta_id=? AND request_id=?',(account,request_id)).fetchone()
            if saved:
                if saved[0]!=count:raise ValueError('identificador_reutilizado')
                return str(seq)+' '+saved[1].split(' ',1)[1]
            with db._conn:
                db._conn.execute('INSERT OR IGNORE INTO local_recruit_state(conta_id) VALUES (?)',(account,))
                total,sr,ssr,free_day=db._conn.execute('SELECT total,since_sr,since_ssr,free_day FROM local_recruit_state WHERE conta_id=?',(account,)).fetchone()
                ticket=int(CONFIG['255'].split(',')[1]);ticket_cost=list(map(int,CONFIG['258'].split(',')))[count==10]
                gold_cost=list(map(int,CONFIG['257'].split(',')))[count==10]
                gold=db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?',(account,)).fetchone()[0]
                ticket_row=db._conn.execute('SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=?',(account,ticket)).fetchone()
                if count==1 and free_day!=day():free_day=day();gold_cost=0
                elif ticket_row and ticket_row[0]>=ticket_cost:
                    db._conn.execute('UPDATE local_inventory SET quantity=quantity-? WHERE conta_id=? AND mould=?',(ticket_cost,account,ticket));gold_cost=0
                elif gold<gold_cost:raise ValueError('gold_insuficiente')
                db._conn.execute('UPDATE local_resources SET gold=gold-? WHERE conta_id=?',(gold_cost,account))
                known={m:s for s,m in heroes.all_owned(db,account)};results=[];new=[]
                def add_item(mould,quantity):
                    if str(mould) not in data.tabela('prop_mould.txt'):raise ValueError('item_de_recrutamento_ausente')
                    db._conn.execute('INSERT INTO local_inventory VALUES (?,?,?,?) ON CONFLICT(conta_id,mould) DO UPDATE SET quantity=quantity+excluded.quantity',(account,mould,account*1000000+mould,quantity))
                premium,ordinary=map(int,CONFIG['243'].split(','))
                for _ in range(count):
                    group=4 if ssr+1>=int(CONFIG['249']) else 3 if sr+1>=int(CONFIG['250']) else 4 if secrets.randbelow(premium+ordinary)<premium else 5
                    reward=choose(group);kind,mould,quantity=reward[:3];quality=0
                    if kind==13:
                        row=data.tabela('ship_mould.txt').get(str(mould))
                        if not row:raise ValueError('personagem_do_recrutamento_ausente')
                        quality=int(row[8])
                        if mould not in known:
                            ship=1000000000+account*100000+mould
                            db._conn.execute('INSERT INTO local_synthesized VALUES (?,?,?)',(account,mould,ship));known[mould]=ship;new.append((ship,mould))
                        else:
                            # Local duplicate policy: award the full synthesis
                            # cost in the character's own fragments, never a
                            # second copy with a colliding identity.
                            mould,quantity=fragment(mould);kind=6
                    if kind==6:add_item(mould,quantity)
                    elif kind!=13:raise ValueError('tipo_de_recompensa_nao_suportado')
                    results.append({'m_type':kind,'mould_id':mould,'number':quantity})
                    total+=1;sr=0 if quality>=16 else sr+1;ssr=0 if quality>=17 else ssr+1
                coin=int(CONFIG['256'].split(',')[1]);add_item(coin,list(map(int,CONFIG['259'].split(',')))[count==10])
                db._conn.execute('UPDATE local_recruit_state SET total=?,since_sr=?,since_ssr=?,free_day=? WHERE conta_id=?',(total,sr,ssr,free_day,account))
                tokens=[str(seq),'new_recruitment_system','0']
                for entry in new:tokens+=heroes.one_ship_tokens(db,account,entry)
                tokens+=inventory_tokens(db,account)+['25',str(-gold_cost),str(gold-gold_cost)]
                payload=state_payload(db,account);payload['localResults']=results
                payload['localNewShips']=[str(s) for s,m in new]
                tokens+=['15005',json.dumps(payload,separators=(',',':')),'15006','-1']
                reply=' '.join(tokens)
                db._conn.execute('INSERT INTO local_recruit_receipt VALUES (?,?,?,?,?)',(account,request_id,count,reply,json.dumps(results)))
        server.log('NORMAL_RECRUIT conta=%s count=%s novos=%s gold_gasto=%s total=%s'%(account,count,len(new),gold_cost,total))
        return reply
    except (server._contas.ErroConta,ValueError,IndexError) as exc:
        return server.recusa('new_recruitment_system',seq,str(exc))


def recruit_shop_remain():
    # Comma list of remaining buys per new_draw_card_shop row (client splits it).
    from pathlib import Path
    import dados_batalha
    p = Path(dados_batalha.MOULD) / 'new_draw_card_shop.txt'
    try:
        rows = [l.split('	') for l in p.read_text(encoding='utf-8').splitlines() if l.strip()]
        return ','.join(r[3] for r in rows if len(r) > 3)
    except OSError:
        return ''
