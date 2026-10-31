"""Arena state, original rewards and once-only local battle settlement.

Historical replay is available only when the actual init/report packets were
archived for that match. Legacy opponent snapshots are not battle replays.
Packet storage is a local extension; the original server's storage is unknown.
"""
import time
import json
import uuid
import hashlib
from pathlib import Path
import dados_batalha as data

COMMANDS = ('arena_init', 'arena_order', 'arena_lounch_refresh', 'buy_arena_launch_count',
            'arena_launch_clear_cd', 'arena_launch', 'arena_sweep', 'arena_worship',
            'draw_arena_score_reward', 'battlefield_report_get', 'battlefield_report_battle_info_get',
            'draw_arena_order_reward')
_CFG = {}


def cfg(n):
    if not _CFG:
        for line in (Path(data.MOULD).parent / 'configs' / 'arena_config.txt').read_text(encoding='utf-8').splitlines():
            row = line.split('\t')
            if len(row) > 3:
                _CFG[row[0]] = row[3]
    return _CFG[str(n)]


def schema(db):
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_arena_worship (conta_id INTEGER NOT NULL, day TEXT NOT NULL, target INTEGER NOT NULL, PRIMARY KEY(conta_id, day, target))')
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_arena_claims (conta_id INTEGER NOT NULL, kind TEXT NOT NULL, idx INTEGER NOT NULL, PRIMARY KEY(conta_id, kind, idx))')
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_arena (conta_id INTEGER PRIMARY KEY REFERENCES contas(id) ON DELETE CASCADE, rank INTEGER NOT NULL UNIQUE, day TEXT, remain INTEGER NOT NULL, bought INTEGER NOT NULL DEFAULT 0, refresh INTEGER NOT NULL DEFAULT 0, cd INTEGER NOT NULL DEFAULT 0, best INTEGER NOT NULL)')
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_arena_matches(id TEXT PRIMARY KEY,conta_id INTEGER,target INTEGER,rank INTEGER,started INTEGER,settled INTEGER NOT NULL DEFAULT 0,win INTEGER,payload TEXT NOT NULL)')
    db._conn.execute('''CREATE TABLE IF NOT EXISTS local_arena_reports(
        id TEXT PRIMARY KEY, conta_id INTEGER NOT NULL, target INTEGER NOT NULL,
        old_rank INTEGER NOT NULL, new_rank INTEGER NOT NULL, result INTEGER NOT NULL,
        started INTEGER NOT NULL, opponent TEXT NOT NULL)''')
    report_columns={r[1] for r in db._conn.execute('PRAGMA table_info(local_arena_reports)')}
    if 'replay' not in report_columns:db._conn.execute('ALTER TABLE local_arena_reports ADD COLUMN replay TEXT')
    if 'report_time' not in report_columns:db._conn.execute('ALTER TABLE local_arena_reports ADD COLUMN report_time INTEGER NOT NULL DEFAULT 0')
    if 'score' not in [r[1] for r in db._conn.execute('PRAGMA table_info(local_arena)')]:
        db._conn.execute('ALTER TABLE local_arena ADD COLUMN score INTEGER NOT NULL DEFAULT 0')


def score(db, account):
    cols = [r[1] for r in db._conn.execute('PRAGMA table_info(local_arena)')]
    if 'score' not in cols:
        db._conn.execute('ALTER TABLE local_arena ADD COLUMN score INTEGER NOT NULL DEFAULT 0')
    r = db._conn.execute('SELECT score FROM local_arena WHERE conta_id=?', (account,)).fetchone()
    return r[0] if r else 0


def claims(db, account, kind):
    return sorted(r[0] for r in db._conn.execute('SELECT idx FROM local_arena_claims WHERE conta_id=? AND kind=?', (account, kind)))


def give(db, account, rewards):
    """Rewards "kind,id,n|...": 1 Ryo, 2 gold, 3 honour (arena currency), 6 item."""
    for part in rewards.split('|'):
        if not part or part == '-1':
            continue
        kind, ident, n = (int(x) for x in part.split(','))
        if kind == 1:
            db._conn.execute('UPDATE local_campaign SET silver=silver+? WHERE conta_id=?', (n, account))
        elif kind == 2:
            db._conn.execute('UPDATE local_resources SET gold=gold+? WHERE conta_id=?', (n, account))
        elif kind == 3:
            db._conn.execute('UPDATE local_resources SET honour=honour+? WHERE conta_id=?', (n, account))
        elif kind == 6:
            db._conn.execute('INSERT INTO local_inventory VALUES (?,?,?,?) ON CONFLICT(conta_id,mould) DO UPDATE SET quantity=quantity+excluded.quantity',
                             (account, ident, account * 1000000 + ident, n))
        elif kind == 34:
            # arena_score.txt uses reward type 34 for Ninja School talent
            # points. Keep this in that system's saved state, just as a normal
            # talent reset/refund does.
            import ninja_school_local
            ninja_school_local.schema(db)
            school = ninja_school_local.state(db, account)
            school['talentPoints'] = int(school.get('talentPoints', 0)) + n
            ninja_school_local.save(db, account, school)
        else:
            raise ValueError('recompensa_nao_suportada')


def claim(db, account, kind, idx):
    """kind 'order': arena_welfare (best rank reached); 'score': arena_score."""
    s = state(db, account)
    table = data.tabela('arena_welfare.txt' if kind == 'order' else 'arena_score.txt')
    row = table.get(str(idx))
    if not row:
        raise ValueError('recompensa_inexistente')
    if idx in claims(db, account, kind):
        raise ValueError('recompensa_ja_recebida')
    ok = s['best'] <= int(row[1]) if kind == 'order' else score(db, account) >= int(row[1])
    if not ok:
        raise ValueError('recompensa_ainda_nao_liberada')
    entries=[list(map(int,part.split(','))) for part in row[2].split('|') if part and part!='-1']
    if any(kind not in (1,2,3,6,34) or amount<=0 or
           (kind==6 and str(ident) not in data.tabela('prop_mould.txt')) or
           (kind==34 and ident!=-1) for kind,ident,amount in entries):
        raise ValueError('recompensa_da_arena_invalida')
    give(db, account, row[2])
    db._conn.execute('INSERT INTO local_arena_claims VALUES (?,?,?)', (account, kind, idx))
    return entries


def today():
    return time.strftime('%Y-%m-%d', time.localtime(time.time() - 5 * 3600))


def seed(db):
    """Every account with a character joins the arena (strongest first), so
    there are opponents even before they open the screen."""
    import ranking_local
    have = {r[0] for r in db._conn.execute('SELECT conta_id FROM local_arena')}
    new = [a for a in ranking_local.players(db) if a not in have]
    if not new:
        return
    new.sort(key=lambda a: -ranking_local.power(db, a))
    rank = db._conn.execute('SELECT COALESCE(MAX(rank),0) FROM local_arena').fetchone()[0]
    for a in new:
        rank += 1
        db._conn.execute('INSERT INTO local_arena(conta_id,rank,day,remain,bought,refresh,cd,best) VALUES (?,?,?,?,0,0,0,?)', (a, rank, today(), int(cfg(2)), rank))


def state(db, account):
    schema(db)
    seed(db)
    r = db._conn.execute('SELECT rank, day, remain, bought, refresh, cd, best FROM local_arena WHERE conta_id=?', (account,)).fetchone()
    if not r:
        rank = (db._conn.execute('SELECT COALESCE(MAX(rank),0) FROM local_arena').fetchone()[0]) + 1
        db._conn.execute('INSERT INTO local_arena(conta_id,rank,day,remain,bought,refresh,cd,best) VALUES (?,?,?,?,0,0,0,?)', (account, rank, today(), int(cfg(2)), rank))
        r = (rank, today(), int(cfg(2)), 0, 0, 0, rank)
    if r[1] != today():
        db._conn.execute('UPDATE local_arena SET day=?, remain=?, bought=0, refresh=0 WHERE conta_id=?', (today(), int(cfg(2)), account))
        r = (r[0], today(), int(cfg(2)), 0, 0, r[5], r[6])
    return dict(rank=r[0], remain=r[2], bought=r[3], refresh=r[4], cd=r[5], best=r[6])


def price(n, k):
    values = [int(x) for x in cfg(n).split(',')]
    return values[min(k, len(values) - 1)]


def template(db, account):
    import ranking_local, recruitment_local as heroes
    with db._lock:
        slots = set(heroes._slots_locked(db, account))
    ships = [s for s in ranking_local.ships(db, account) if str(s[1]) in slots]
    parts = []
    for pw, sid, mould, level, star in ships:
        # mould:level:evolution:star:quality(Order):power:skin, real values (14104 block)
        m = heroes.one_ship_tokens(db, account, (sid, mould))
        m = m[m.index('14104'):]
        parts.append('%d:%d:%s:%s:%s:%d:0' % (mould, level, m[2], m[4], m[3], pw))
    text = '!'.join(parts) or '0'
    return [text, '0', '0', '0']


def player(db, a):
    import ranking_local, vip_local, profile_local
    b = ranking_local.base(db, a)
    return b, vip_local.grade(db, a), ranking_local.power(db, a)


def worshipped(db, a):
    return db._conn.execute('SELECT COUNT(*) FROM local_arena_worship WHERE target=?', (a,)).fetchone()[0]


def challenger_tokens(db, a, rank):
    # arena_id must be unique per player: the worship state is keyed by it.
    b, vip, pw = player(db, a)
    return ([str(a), str(b['uid']), b['name'], str(b['head'])] + template(db, a) +
            [str(b['level']), str(rank), '0', '0', '0', vip, '0', b['clan'], str(pw), str(worshipped(db, a)), '-1', '-1'])


def opponents(db, account, rank):
    # The original list shows the player too, ordered by rank with the
    # opponents around them.
    # Original layout (arena_ladder_seat_cell.lua:487): the first 10 entries
    # are the top 10 (worship), then the challengers around the player.
    rows = [tuple(r) for r in db._conn.execute('SELECT conta_id, rank FROM local_arena ORDER BY rank')]
    top = rows[:10]
    near = [r for r in rows[10:] if r[1] < rank][-5:] + [r for r in rows[10:] if r[1] == rank]
    return top + near


def init_tokens(db, account):
    s = state(db, account)
    rivals = opponents(db, account, s['rank'])
    import ranking_local
    out = ['45', '0', '-', '0', '0', str(s['rank']), '0', '0', '0', '0', '0', '0', '0', '0',
           str(s['bought']), str(s['remain']), '0', '0', '0', str(len(rivals))]
    for a, rank in rivals:
        out += challenger_tokens(db, a, rank)
    done = [r[0] for r in db._conn.execute('SELECT target FROM local_arena_worship WHERE conta_id=? AND day=?', (account, today()))]
    out += ['0', str(ranking_local.power(db, account)), str(s['cd'] * 1000), str(s['refresh']),
            ','.join([str(len(done))] + [str(x) for x in done]),
            ','.join(str(x) for x in claims(db, account, 'order')) or '0',
            ','.join(str(x) for x in claims(db, account, 'score')) or '0',
            str(score(db, account)), str(s['best'])]
    return out


def order_tokens(db, account):
    s = state(db, account)
    rows = db._conn.execute('SELECT conta_id, rank FROM local_arena ORDER BY rank LIMIT ?', (int(cfg(10)),)).fetchall()
    out = ['62', '0', str(s['rank']), str(len(rows))]
    for a, rank in rows:
        b, vip, pw = player(db, a)
        out += [str(b['uid']), str(b['head'])] + template(db, a) + [str(rank), b['name'], str(b['level']), vip, '0',
                                                                     b['clan'], '0', '0', str(pw), '-1', '-1']
    return out


def defender_info(db, defender, rank):
    """The defender's formation in the same shape as the client's user_ship,
    so FightObject:initWithUserData builds the enemy side with the original
    battle engine (client/battle/report/FightObject.lua:1441)."""
    import json, hero_stats_local as stats, recruitment_local as heroes, ranking_local, hero_development_local as dev
    with db._lock:
        slots = heroes._slots_locked(db, defender)
        owned = dict(heroes.all_owned(db, defender))
    b, vip, pw = player(db, defender)
    ships = []
    for pos, sid in enumerate(slots, 1):
        sid = int(sid)
        if sid <= 0 or sid not in owned:
            continue
        mould = owned[sid]
        e = stats.effective(db, defender, sid, mould)
        meta = heroes.one_ship_tokens(db, defender, (sid, mould))
        m = meta[meta.index('14104'):]
        row = data.tabela('ship_mould.txt')[str(mould)]
        ships.append({'pos': pos, 'ship_id': str(9000000000 + sid % 1000000000), 'ship_template_id': str(mould),
                      'evolution_status': m[2], 'Order': m[3], 'StarRating': m[4], 'skillLevel': m[5],
                      'skin_id': '0', 'ship_skin_info': '', 'captain_type': row[3],
                      'ship_wisdom': str(int(e['speed'])), 'ship_leader': '0',
                      'ship_courage': str(int(e['courage'])), 'ship_health': str(int(e['health'])),
                      'ship_intellect': str(int(e['intellect'])), 'ship_quick': str(int(e['quick'])),
                      'property_values': e['property_values'], 'relationship': e['bonds'],
                      # same values the login sends for our own ninjas (recruitment_local fields 6/16)
                      'initial_sp_increase': 0,
                      'ship_fighting_spirit': dev.soul_text(dev.state(db, defender, sid, mould))})
    # Data of the original arena result screen (SmArenaBattleReward, _ED.arena_battle_data).
    battle_data = [{'name': '', 'rank': 0, 'battle_object': ''},
                   {'name': b['name'], 'rank': rank, 'battle_object': template(db, defender)[0]}]
    return json.dumps({'battle_data': battle_data, 'rank': rank, 'uid': b['uid'], 'name': b['name'], 'head': b['head'], 'level': b['level'],
                       'power': pw, 'speed': ranking_local.team_speed(db, defender), 'ships': ships}, separators=(',', ':'))


def launch(server, db, account, s, body):
    if len(body)<2 or body[1] not in ('0','2'):
        raise ValueError('pedido_de_batalha_invalido')
    requested_rank,mode=int(body[0]),body[1]
    if mode=='2':
        if len(body) not in (3,4,5) or body[2] not in ('0','1'):
            raise ValueError('resultado_de_batalha_invalido')
        if len(body)>=4:
            match=db._conn.execute('SELECT id,target,settled,win FROM local_arena_matches WHERE conta_id=? AND id=?',(account,body[3])).fetchone()
        else:
            # Compatibility for installed clients without a match token.
            match=db._conn.execute('SELECT id,target,settled,win FROM local_arena_matches WHERE conta_id=? AND rank=? ORDER BY started DESC,rowid DESC LIMIT 1',(account,requested_rank)).fetchone()
        if not match:raise ValueError('batalha_da_arena_nao_iniciada')
        win=int(body[2])
        if match[2]:
            if match[3]!=win:raise ValueError('resultado_da_batalha_divergente')
            return init_tokens(db,account)
        recorded=recorded_packets(body[4],win) if len(body)==5 else None
        if recorded and recorded.get('version')==2 and recorded.get('matchId')!=match[0]:
            raise ValueError('arquivo_de_batalha_divergente')
        target=match[1]
        rank=db._conn.execute('SELECT rank FROM local_arena WHERE conta_id=?',(target,)).fetchone()[0]
        if win and rank<s['rank']:
            db._conn.execute('UPDATE local_arena SET rank=-1 WHERE conta_id=?',(account,))
            db._conn.execute('UPDATE local_arena SET rank=? WHERE conta_id=?',(s['rank'],target))
            db._conn.execute('UPDATE local_arena SET rank=?,best=MIN(best,?) WHERE conta_id=?',(rank,rank,account))
        import vip_local
        gain=[int(x) for x in cfg(7).split(',')][0 if win else 1]
        if not win and int(vip_local.grade(db,account))>=int(cfg(16)):gain=int(cfg(7).split(',')[0])
        db._conn.execute('UPDATE local_arena SET remain=MAX(0,remain-1),cd=?,score=score+? WHERE conta_id=?',(int(time.time())+int(cfg(4)),gain,account))
        db._conn.execute('UPDATE local_arena_matches SET settled=1,win=? WHERE id=?',(win,match[0]))
        snapshot=db._conn.execute('SELECT payload,started FROM local_arena_matches WHERE id=?',(match[0],)).fetchone()
        opponent=json.loads(snapshot[0])
        new_rank=db._conn.execute('SELECT rank FROM local_arena WHERE conta_id=?',(account,)).fetchone()[0]
        db._conn.execute('''INSERT INTO local_arena_reports
            (id,conta_id,target,old_rank,new_rank,result,started,opponent)
            VALUES (?,?,?,?,?,?,?,?)''',
            (match[0],account,target,s['rank'],new_rank,win,snapshot[1],json.dumps(opponent,separators=(',',':'))))
        last=db._conn.execute('SELECT COALESCE(MAX(report_time),0) FROM local_arena_reports WHERE conta_id=?',(account,)).fetchone()[0]
        stamp=max(int(time.time()*1000),int(last)+1)
        db._conn.execute('UPDATE local_arena_reports SET replay=?,report_time=? WHERE id=?',(json.dumps(recorded,separators=(',',':')) if recorded else None,stamp,match[0]))
        if recorded:
            server.log('ARENA_ARCHIVE conta=%s match=%s formato=%s eventos=%s'%(account,match[0],recorded['version'],len(recorded.get('events',[]))))
        server.log('ARENA_RESULT conta=%s match=%s pontos=%s'%(account,match[0],gain))
        return init_tokens(db,account)
    target=db._conn.execute('SELECT conta_id FROM local_arena WHERE rank=?',(requested_rank,)).fetchone()
    if not target or target[0]==account:raise ValueError('adversario_invalido')
    target=target[0]
    if s['remain']<=0:raise ValueError('sem_tentativas')
    if s['cd']>time.time():raise ValueError('aguarde_o_tempo_de_espera')
    pending=db._conn.execute('SELECT payload FROM local_arena_matches WHERE conta_id=? AND target=? AND settled=0 ORDER BY started DESC LIMIT 1',(account,target)).fetchone()
    if pending:return ['15980',pending[0]]
    import ranking_local
    info=json.loads(defender_info(db,target,requested_rank));me=ranking_local.base(db,account)
    info['battle_data'][0]={'name':me['name'],'rank':s['rank'],'battle_object':template(db,account)[0]}
    info['matchId']=uuid.uuid4().hex
    payload=json.dumps(info,separators=(',',':'))
    db._conn.execute('INSERT INTO local_arena_matches(id,conta_id,target,rank,started,payload) VALUES (?,?,?,?,?,?)',(info['matchId'],account,target,requested_rank,int(time.time()),payload))
    return ['15980',payload]


def recorded_packets(text,win):
    """Local archive envelope; never a reconstruction of original server storage."""
    record=json.loads(text)
    if isinstance(record,dict) and record.get('version')==2:
        return recorded_events(record,win)
    if not isinstance(record,dict) or record.get('version')!=1:raise ValueError('formato_de_replay_invalido')
    for key,command,parser in [('initHex','battle_field_init','182'),('fightHex','environment_fight','39')]:
        encoded=record.get(key)
        if not isinstance(encoded,str) or len(encoded)>8*1024*1024:raise ValueError('pacote_de_replay_invalido')
        try:raw=bytes.fromhex(encoded);packet=raw.decode('utf8')
        except (ValueError,UnicodeError):raise ValueError('codificacao_de_replay_invalida')
        fields=packet.split()
        if len(fields)<4 or fields[1]!=command or fields[2]!='0' or fields[3]!=parser:raise ValueError('pacote_de_batalha_invalido')
        if key=='fightHex' and win is not None and (len(fields)<7 or fields[4]!=str(win)):raise ValueError('resultado_do_replay_divergente')
        digest=hashlib.sha256(raw).hexdigest()
        if key+'Sha256' in record and record[key+'Sha256']!=digest:raise ValueError('integridade_do_replay_invalida')
        record[key+'Sha256']=digest
    return record


def recorded_events(record,win):
    """Versioned local journal of actual engine output, not an original-server format.

    Stored atomically with settlement. The version-1 replay reader must not
    interpret this incremental journal as a complete protocol-39 battle.
    """
    if not isinstance(record.get('matchId'),str) or len(record['matchId'])!=32:
        raise ValueError('identificador_de_arquivo_invalido')
    if record.get('win') not in ('0','1') or (win is not None and record['win']!=str(win)):
        raise ValueError('resultado_do_arquivo_divergente')
    events=record.get('events')
    if not isinstance(events,list) or not 2<=len(events)<=4096:
        raise ValueError('eventos_de_batalha_invalidos')
    total=0
    def decode(encoded):
        nonlocal total
        if not isinstance(encoded,str) or not encoded or len(encoded)>2*1024*1024 or len(encoded)%2:
            raise ValueError('evento_de_batalha_invalido')
        try:
            raw=bytes.fromhex(encoded)
            if raw.hex()!=encoded.lower():raise ValueError()
            raw.decode('utf8')
        except (ValueError,UnicodeError):raise ValueError('codificacao_de_evento_invalida')
        total+=len(raw)
        if total>2*1024*1024:raise ValueError('arquivo_de_batalha_muito_grande')
        return raw
    init=decode(record.get('initHex'))
    fields=init.decode().split()
    if len(fields)<4 or fields[1:4]!=['battle_field_init','0','182']:
        raise ValueError('inicio_de_batalha_invalido')
    has_action=False
    for event in events:
        if not isinstance(event,dict) or event.get('kind') not in ('protocol','round','action','skip'):
            raise ValueError('tipo_de_evento_invalido')
        decode(event.get('dataHex'))
        has_action=has_action or event['kind']!='protocol'
    if not has_action:raise ValueError('arquivo_sem_acoes_de_batalha')
    canonical={k:record[k] for k in ('version','matchId','win','initHex','events')}
    digest=hashlib.sha256(json.dumps(canonical,sort_keys=True,separators=(',',':')).encode()).hexdigest()
    if 'archiveSha256' in record and record['archiveSha256']!=digest:
        raise ValueError('integridade_do_arquivo_invalida')
    canonical['archiveSha256']=digest
    return canonical


def report_tokens(db, account):
    """Rows for original Arena report parser 14700 (ProtocolParserCopyExx)."""
    rows=db._conn.execute('''SELECT id,target,old_rank,new_rank,result,CASE WHEN report_time>0 THEN report_time ELSE started*1000 END,opponent
        FROM local_arena_reports WHERE conta_id=? ORDER BY CASE WHEN report_time>0 THEN report_time ELSE started*1000 END DESC LIMIT ?''',(account,int(cfg(11)))).fetchall()
    out=['14700',str(len(rows))]
    own_uid=str(db.perfil(account)['user_id'])
    for match_id,target,old_rank,new_rank,win,started,payload in rows:
        other=json.loads(payload)
        # ArenaWarReportSeatCell uses param[4:6] for rank movement and to
        # determine which side was this account. As the caller is always the
        # challenger, result=1 denotes a loss and 0 a win in the original UI.
        param='0,0,0,%d,%d,%s'%(old_rank,new_rank,own_uid)
        out += [str(other.get('uid',0)),str(other.get('head',0)),'0',str(other.get('level',1)),
                '0','0',other.get('name',''),str(other.get('power',0)),
                '0' if int(win) else '1',param,'11',str(int(started)),'0',
                str(other.get('speed',0)),'0','0']
    return out


def pay_gold(db, account, n):
    g = db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?', (account,)).fetchone()
    if not g or g[0] < n:
        raise ValueError('ouro_insuficiente')
    db._conn.execute('UPDATE local_resources SET gold=gold-? WHERE conta_id=?', (n, account))


def execute(server, cmd, seq, text):
    db = server.BANCO
    try:
        account = db.sessao_de(server._sessao_da_conexao())['conta_id']
        with db._lock, db._conn:
            s = state(db, account)
            visual_rewards=[]
            if cmd == 'battlefield_report_get':
                return ' '.join([str(seq),cmd,'0']+report_tokens(db,account))
            if cmd == 'battlefield_report_battle_info_get':
                f=server._linhas(text)
                while f and f[-1]=='':f.pop()
                if len(f) not in (3,4) or f[0]!=str(db.perfil(account)['user_id']) or f[1]!='11' or (len(f)==4 and f[3]!='journal-v2'):
                    raise ValueError('relatorio_de_arena_invalido')
                body=f[1:]
                stamp=int(body[1])
                rows=db._conn.execute("""SELECT replay,id FROM local_arena_reports
                    WHERE conta_id=? AND (report_time=? OR (report_time=0 AND started*1000=?))""",(account,stamp,stamp)).fetchall()
                if not rows:raise ValueError('relatorio_de_arena_inexistente')
                if len(rows)!=1:raise ValueError('horario_de_relatorio_ambiguo')
                if not rows[0][0]:raise ValueError('dados_historicos_de_replay_nao_disponiveis')
                record=json.loads(rows[0][0])
                recorded_packets(json.dumps(record),None)
                if record.get('version')==2 and len(f)!=4:
                    raise ValueError('atualize_o_cliente_para_reproduzir_o_relatorio')
                historical=db._conn.execute('SELECT payload FROM local_arena_matches WHERE id=? AND conta_id=?',(rows[0][1],account)).fetchone()
                if historical:
                    ui=json.loads(historical[0]).get('battle_data')
                    if ui:record['uiBattleData']=ui
                return ' '.join([str(seq),cmd,'0','15981',json.dumps(record,separators=(',',':'))])
            if cmd == 'arena_order':
                out = order_tokens(db, account)
            elif cmd == 'arena_launch':
                f = server._linhas(text)
                while f and f[-1]=='':f.pop()
                if len(f)<3 or f[0]!=str(db.perfil(account)['user_id']):raise ValueError('pedido_de_arena_invalido')
                body=f[1:]
                out = launch(server, db, account, s, body)
            elif cmd == 'arena_sweep':
                raise ValueError('arena_5x_ainda_nao_implementada')
            else:
                if cmd == 'buy_arena_launch_count':
                    pay_gold(db, account, price(3, s['bought']))
                    db._conn.execute('UPDATE local_arena SET remain=remain+1, bought=bought+1 WHERE conta_id=?', (account,))
                elif cmd == 'arena_launch_clear_cd':
                    if s['cd'] > time.time():
                        pay_gold(db, account, int(cfg(5)))
                    db._conn.execute('UPDATE local_arena SET cd=0 WHERE conta_id=?', (account,))
                elif cmd == 'arena_lounch_refresh':
                    cost = price(6, s['refresh'])
                    if cost:
                        pay_gold(db, account, cost)
                    db._conn.execute('UPDATE local_arena SET refresh=refresh+1 WHERE conta_id=?', (account,))
                elif cmd == 'arena_worship':
                    f = server._linhas(text)
                    body = f[1:] if f and f[0] == str(db.perfil(account)['user_id']) else f
                    rank = int(body[-1])
                    done = {r[0] for r in db._conn.execute('SELECT target FROM local_arena_worship WHERE conta_id=? AND day=?', (account, today()))}
                    top = [r[0] for r in db._conn.execute('SELECT conta_id FROM local_arena WHERE rank<=10 ORDER BY rank')]
                    if rank == -1:
                        # Quick worship (Arena.lua sends 0, 1, -1): every top-10 player not worshipped today.
                        targets = [a for a in top if a != account and a not in done]
                    else:
                        target = db._conn.execute('SELECT conta_id FROM local_arena WHERE rank=?', (rank,)).fetchone()
                        if not target or rank > 10 or target[0] == account or target[0] in done:
                            raise ValueError('nao_pode_venerar')
                        targets = [target[0]]
                    targets = targets[:max(0, 10 - len(done))]
                    if not targets:
                        raise ValueError('nada_para_venerar')
                    reward = int(cfg(9).split(',')[0])
                    for target in targets:
                        db._conn.execute('INSERT INTO local_arena_worship VALUES (?,?,?)', (account, today(), target))
                    db._conn.execute('UPDATE local_resources SET gold=gold+? WHERE conta_id=?', (reward * len(targets), account))
                elif cmd in ('draw_arena_order_reward', 'draw_arena_score_reward'):
                    f = server._linhas(text)
                    idx = int(f[-1])
                    kind = 'order' if cmd == 'draw_arena_order_reward' else 'score'
                    if idx == -1:
                        table=data.tabela('arena_welfare.txt' if kind=='order' else 'arena_score.txt')
                        for key in sorted(table,key=int):
                            row=table[key];ident=int(key)
                            unlocked=s['best']<=int(row[1]) if kind=='order' else score(db,account)>=int(row[1])
                            if unlocked and ident not in claims(db,account,kind):
                                visual_rewards+=claim(db,account,kind,ident)
                        if not visual_rewards:raise ValueError('nenhuma_recompensa_disponivel')
                    else:
                        visual_rewards+=claim(db,account,kind,idx)
                elif cmd == 'nunca':
                    raise ValueError('recurso_da_arena_ainda_nao_implementado')
                out = init_tokens(db, account)
            if visual_rewards:
                import shop_local,shop_special_local
                out+=shop_local.inventory_tokens(db,account)+shop_local.balances(db,account)+shop_special_local.wallet_tokens(db,account)
                if any(kind == 34 for kind, _, _ in visual_rewards):
                    import ninja_school_local
                    school = ninja_school_local.state(db, account)
                    out += ['6043', '5', str(int(school.get('talentPoints', 0)))]
                out+=['171','14',str(len(visual_rewards))]
                out+=[str(v) for kind,ident,amount in visual_rewards for v in (ident,kind,amount)]
            gold = db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?', (account,)).fetchone()
            if cmd not in ('arena_order',) and not (out and out[0] == '15980'):
                out += ['25', '0', str(gold[0] if gold else 0)]
        return ' '.join([str(seq), cmd, '0'] + out)
    except (server._contas.ErroConta, ValueError, KeyError, IndexError, TypeError) as exc:
        return server.recusa(cmd, seq, str(exc) or 'arena_indisponivel')


def install(server):
    with server.BANCO._lock, server.BANCO._conn:
        schema(server.BANCO)
    for command in COMMANDS:
        server.MINIMOS[command] = lambda seq, text, cmd=command: execute(server, cmd, seq, text)
