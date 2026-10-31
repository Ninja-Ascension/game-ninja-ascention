"""Arena (竞技场), screen part: entry, opponents, refresh, ranking, buying
attempts and clearing the cooldown. Battles (arena_launch / arena_sweep) need
the server-side fight report the client plays back (_ED.attackData), which
this port does not generate yet, so they are refused honestly.

Client: l_digital/campaign/arena/Arena.lua; parsers 45 (arena_init,
ProtocolParserCopy.lua:3019) and 62 (arena_order, :3827).
Rules (arena_config.txt): 2 free attempts per day, 3 buy price list (gold),
4 cooldown after a fight, 5 price to clear it, 6 refresh price list,
10 ranking size.
Ranks: all accounts are seeded by power on first use (no robots).
"""
import time
import json
import uuid
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
        if len(body) not in (3,4) or body[2] not in ('0','1'):
            raise ValueError('resultado_de_batalha_invalido')
        if len(body)==4:
            match=db._conn.execute('SELECT id,target,settled,win FROM local_arena_matches WHERE conta_id=? AND id=?',(account,body[3])).fetchone()
        else:
            # Compatibility for installed clients without a match token.
            match=db._conn.execute('SELECT id,target,settled,win FROM local_arena_matches WHERE conta_id=? AND rank=? ORDER BY started DESC,rowid DESC LIMIT 1',(account,requested_rank)).fetchone()
        if not match:raise ValueError('batalha_da_arena_nao_iniciada')
        win=int(body[2])
        if match[2]:
            if match[3]!=win:raise ValueError('resultado_da_batalha_divergente')
            return init_tokens(db,account)
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


def report_tokens(db, account):
    """Rows for original Arena report parser 14700 (ProtocolParserCopyExx)."""
    rows=db._conn.execute('''SELECT id,target,old_rank,new_rank,result,started,opponent
        FROM local_arena_reports WHERE conta_id=? ORDER BY started DESC LIMIT 100''',(account,)).fetchall()
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
                '0' if int(win) else '1',param,'11',str(int(started)*1000),'0',
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
                body=f[1:] if f and f[0]==str(db.perfil(account)['user_id']) else f
                if len(body)<2 or int(body[0])!=11:raise ValueError('relatorio_de_arena_invalido')
                stamp=int(body[1])
                row=db._conn.execute('''SELECT opponent FROM local_arena_reports
                    WHERE conta_id=? AND started*1000=? LIMIT 1''',(account,stamp)).fetchone()
                if not row:raise ValueError('relatorio_de_arena_inexistente')
                return ' '.join([str(seq),cmd,'0','15980',row[0]])
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
