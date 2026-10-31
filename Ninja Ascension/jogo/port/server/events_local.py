"""Editable local Event and 7-day Party campaigns; all claims are transactional."""
import datetime as dt
import json
import re
import time
from pathlib import Path

CONFIG = Path(__file__).with_name('events_local.json')
PARSER = '16981'


def configuration():
    entries = json.loads(CONFIG.read_text(encoding='utf8'))['campaigns']
    if len({x['id'] for x in entries}) != len(entries):
        raise ValueError('campanha_duplicada')
    return [entry for entry in entries if entry.get('enabled',True)]


def effect_enabled(effect):
    return any(c.get('effect')==effect for c in configuration())


def encode_payload(info):
    # The original transport separates tokens on literal spaces.
    # JSON4Lua in the recovered client does not understand Unicode escapes.
    return json.dumps(info,separators=(',',':'),ensure_ascii=False).replace(' ','&nbsp;')


def schema(db):
    db._conn.executescript('''
    CREATE TABLE IF NOT EXISTS local_event_claims(
      conta_id INTEGER NOT NULL, campaign TEXT NOT NULL, period TEXT NOT NULL,
      entry TEXT NOT NULL, rewards TEXT NOT NULL, PRIMARY KEY(conta_id,campaign,period,entry));
    CREATE TABLE IF NOT EXISTS local_event_receipts(
      conta_id INTEGER NOT NULL, request TEXT NOT NULL, signature TEXT NOT NULL,
      reply TEXT NOT NULL, PRIMARY KEY(conta_id,request));
    CREATE TABLE IF NOT EXISTS local_event_metrics(
      conta_id INTEGER NOT NULL, day TEXT NOT NULL, metric TEXT NOT NULL, value INTEGER NOT NULL,
      PRIMARY KEY(conta_id,day,metric));
    CREATE TABLE IF NOT EXISTS local_event_credits(
      conta_id INTEGER NOT NULL, source TEXT NOT NULL, day TEXT NOT NULL, amount INTEGER NOT NULL,
      PRIMARY KEY(conta_id,source));
    ''')


def day_key(now=None):
    return (dt.datetime.fromtimestamp(time.time() if now is None else now)-dt.timedelta(hours=5)).date().isoformat()


def age(db, account):
    created = db.perfil(account)['criada_em']/1000
    return (dt.datetime.now().date()-dt.datetime.fromtimestamp(created).date()).days+1


def period(c):
    today=day_key()
    return today if c['period']=='daily' else today[:7] if c['period']=='monthly' else 'once'


def metric(db, account, c, kind):
    if kind=='none': return 0
    if kind=='level':
        row=db._conn.execute('SELECT grade FROM local_campaign WHERE conta_id=?',(account,)).fetchone()
        return int(row[0]) if row else 1
    if kind=='stages':
        return db._conn.execute('SELECT COUNT(*) FROM local_pve_clears WHERE conta_id=? AND scene BETWEEN 1 AND 24 AND stars>0',(account,)).fetchone()[0]
    key=period(c)
    pattern='%' if c['period']=='forever' else key+'%'
    if kind=='recharge':
        return db._conn.execute('SELECT COALESCE(SUM(amount),0) FROM local_event_credits WHERE conta_id=? AND day LIKE ?',(account,pattern)).fetchone()[0]
    return db._conn.execute('SELECT COALESCE(SUM(value),0) FROM local_event_metrics WHERE conta_id=? AND metric=? AND day LIKE ?',(account,kind,pattern)).fetchone()[0]


def record(db, account, kind, value):
    if value>0:
        db._conn.execute('INSERT INTO local_event_metrics VALUES(?,?,?,?) ON CONFLICT(conta_id,day,metric) DO UPDATE SET value=value+excluded.value',(account,day_key(),kind,int(value)))


def credit(db, account, source, amount):
    """Administrator integration only: not exposed by a game command."""
    if not source or not isinstance(amount,int) or amount<=0: raise ValueError('credito_invalido')
    previous=db._conn.execute('SELECT amount FROM local_event_credits WHERE conta_id=? AND source=?',(account,source)).fetchone()
    if previous:
        if previous[0]!=amount: raise ValueError('credito_reutilizado')
        return False
    db._conn.execute('INSERT INTO local_event_credits VALUES(?,?,?,?)',(account,source,day_key(),amount))
    db._conn.execute('INSERT OR IGNORE INTO local_resources(conta_id) VALUES(?)',(account,))
    db._conn.execute('UPDATE local_resources SET gold=gold+? WHERE conta_id=?',(amount,account))
    return True


def balance(db, account):
    silver=db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?',(account,)).fetchone()
    resources=db._conn.execute('SELECT gold,food FROM local_resources WHERE conta_id=?',(account,)).fetchone()
    return {'ryo':int(silver[0]) if silver else 0,'gold':int(resources[0]) if resources else 0,'food':int(resources[1]) if resources else 0}


def claimed(db,account,c,entry):
    return db._conn.execute('SELECT 1 FROM local_event_claims WHERE conta_id=? AND campaign=? AND period=? AND entry=?',(account,c['id'],period(c),entry)).fetchone() is not None


def payload(db,account,mode='event',reward=None):
    import vip_local
    wallet=balance(db,account);days=age(db,account);pages=[]
    for c in configuration():
        if (c['period']=='seven') != (mode=='seven'): continue
        page=dict(c);page['rows']=[]
        invested=claimed(db,account,c,'invest') if c.get('investment') else True
        page['invested']=invested
        page['canInvest']=not invested and int(vip_local.grade(db,account))>=c.get('vip',0) and wallet['gold']>=c.get('investment',0)
        for r in c['rows']:
            row=dict(r);row['claimed']=claimed(db,account,c,r['id'])
            row['progress']=metric(db,account,c,r['metric'])
            row['available']=not row['claimed'] and invested and row['progress']>=r['target'] and wallet['gold']>=r.get('cost',0)
            row['reason']=''
            if c['period']=='seven' and not c['day']<=days<=8:
                row['available']=False;row['reason']='Evento encerrado' if days>8 else 'Dia ainda bloqueado'
            elif not invested: row['reason']='Adquira o Fundo (VIP %s)'%c['vip']
            elif row['progress']<r['target']: row['reason']='Meta incompleta'
            elif wallet['gold']<r.get('cost',0): row['reason']='Gold insuficiente'
            page['rows'].append(row)
        pages.append(page)
    return dict(mode=mode,pages=pages,balance=wallet,accountDay=days,serverTime=int(time.time()),rewards=reward or [])


def grant(db,account,rewards):
    from scene_rewards_local import _apply_npc_reward
    normal=[]
    for ident,kind,n in rewards:
        if n<=0: raise ValueError('premio_invalido')
        if kind==12: db._conn.execute('UPDATE local_resources SET food=food+? WHERE conta_id=?',(n,account))
        else: normal.append((ident,kind,n))
    _apply_npc_reward(db,account,normal)


def mutate(db,account,cid,entry):
    c=next((x for x in configuration() if x['id']==cid),None)
    if not c: raise ValueError('campanha_invalida')
    if claimed(db,account,c,entry): raise ValueError('premio_ja_coletado')
    if c['period']=='seven' and not c['day']<=age(db,account)<=8: raise ValueError('dia_indisponivel')
    if entry=='invest':
        import vip_local
        if not c.get('investment'): raise ValueError('investimento_invalido')
        if int(vip_local.grade(db,account))<c['vip']: raise ValueError('vip_insuficiente')
        cost=c['investment'];rewards=[]
    else:
        r=next((x for x in c['rows'] if x['id']==entry),None)
        if not r: raise ValueError('premio_invalido')
        if c.get('investment') and not claimed(db,account,c,'invest'): raise ValueError('fundo_nao_adquirido')
        if metric(db,account,c,r['metric'])<r['target']: raise ValueError('meta_incompleta')
        cost=r.get('cost',0);rewards=r['rewards']
    if balance(db,account)['gold']<cost: raise ValueError('gold_insuficiente')
    db._conn.execute('UPDATE local_resources SET gold=gold-? WHERE conta_id=?',(cost,account))
    record(db,account,'spend',cost)
    grant(db,account,rewards)
    db._conn.execute('INSERT INTO local_event_claims VALUES(?,?,?,?,?)',(account,cid,period(c),entry,json.dumps(rewards)))
    return rewards


def install(server):
    db=server.BANCO
    import vip_local
    with db._lock:
        schema(db)
        vip_local.schema(db)
    def handle(cmd,seq,text):
        try:
            account=db.sessao_de(server._sessao_da_conexao())['conta_id'];f=server._linhas(text)
            if not f or f[0]!=str(db.perfil(account)['user_id']): raise ValueError('perfil_invalido')
            if cmd=='local_event_init':
                if len(f)!=2 or f[1] not in ('event','seven'): raise ValueError('modo_invalido')
                with db._lock: info=payload(db,account,f[1])
                return ' '.join([str(seq),cmd,'0',PARSER,encode_payload(info)])
            if len(f)!=5 or f[1] not in ('event','seven') or not re.fullmatch(r'[A-Za-z0-9:-]{1,100}',f[4]): raise ValueError('pedido_invalido')
            signature='|'.join(f[1:4])
            with db._lock,db._conn:
                old=db._conn.execute('SELECT signature,reply FROM local_event_receipts WHERE conta_id=? AND request=?',(account,f[4])).fetchone()
                if old:
                    if old[0]!=signature: raise ValueError('identificador_reutilizado')
                    return str(seq)+' '+old[1].split(' ',1)[1]
                db._conn.execute('INSERT OR IGNORE INTO local_campaign(conta_id) VALUES(?)',(account,))
                db._conn.execute('INSERT OR IGNORE INTO local_resources(conta_id) VALUES(?)',(account,))
                rewards=mutate(db,account,f[2],f[3]);info=payload(db,account,f[1],rewards)
                from hero_training_local import inventory_tokens
                from shop_local import state_tokens
                wallet=info['balance']
                tokens=[str(seq),cmd,'0','22',str(wallet['ryo']),'25','0',str(wallet['gold'])]
                if any(r[1]==12 for r in rewards):tokens+=['29',str(sum(r[2] for r in rewards if r[1]==12)),str(wallet['food'])]
                tokens+=inventory_tokens(db,account)+state_tokens(db,account)+[PARSER,encode_payload(info)]
                reply=' '.join(tokens)
                db._conn.execute('INSERT INTO local_event_receipts VALUES(?,?,?,?)',(account,f[4],signature,reply))
            return reply
        except (server._contas.ErroConta,ValueError,KeyError,IndexError,TypeError) as exc:
            return server.recusa(cmd,seq,str(exc))
    for cmd in ('local_event_init','local_event_action'):
        server.MINIMOS[cmd]=lambda seq,text,cmd=cmd:handle(cmd,seq,text)
    original=getattr(server,'_events_original_dispatch',None)
    if original is None:
        original=server.despacha
        server._events_original_dispatch=original
    def dispatch(text):
        # Observe actual server wallet/draw changes, never client counters.
        with db._lock:
            try:
                account=db.sessao_de(server._sessao_da_conexao())['conta_id']
            except (server._contas.ErroConta,KeyError):
                return original(text)
            before=balance(db,account)['gold']
            old=db._conn.execute('SELECT draws FROM local_shop_state WHERE conta_id=?',(account,)).fetchone()
            old_draws=int(old[0]) if old else 0
            reply=original(text)
            parts=reply.split(' ',3)
            command=text.splitlines()[1] if len(text.splitlines())>1 else ''
            if len(parts)>=3 and parts[2]=='0' and command!='local_event_action':
                after=balance(db,account)['gold']
                new=db._conn.execute('SELECT draws FROM local_shop_state WHERE conta_id=?',(account,)).fetchone()
                draws=int(new[0]) if new else 0
                with db._conn:
                    record(db,account,'spend',max(0,before-after))
                    record(db,account,'weapon',max(0,draws-old_draws))
            return reply
    server.despacha=dispatch

