"""Ninja Trial (three_kingdoms_*) backed by the original client data tables.

The screen and its battle simulation are client-side in the APK. This module
supplies the persistent state and validates/settles the protocol operations
used by TrialTower.lua, GuanQia.lua and the reward/shop windows.
"""
import hashlib
import json
import math
import random
import re
from pathlib import Path

import dados_batalha as data


def _schema(db):
    db._conn.execute('''CREATE TABLE IF NOT EXISTS local_ninja_trial (
        conta_id INTEGER PRIMARY KEY REFERENCES contas(id) ON DELETE CASCADE,
        floor INTEGER NOT NULL DEFAULT 0,
        stars INTEGER NOT NULL DEFAULT 0,
        score INTEGER NOT NULL DEFAULT 0,
        highest_score INTEGER NOT NULL DEFAULT 0,
        total_score INTEGER NOT NULL DEFAULT 0,
        last_hp TEXT NOT NULL DEFAULT '',
        buffs TEXT NOT NULL DEFAULT '',
        npc_ids TEXT NOT NULL DEFAULT '',
        claimed TEXT NOT NULL DEFAULT '',
        vip_sweep INTEGER NOT NULL DEFAULT 0,
        vip_day TEXT NOT NULL DEFAULT '',
        lost_treasure INTEGER NOT NULL DEFAULT 0,
        lost_treasure_bought INTEGER NOT NULL DEFAULT 0,
        vip_buff_info TEXT NOT NULL DEFAULT '',
        vip_reward_info TEXT NOT NULL DEFAULT '',
        updated INTEGER NOT NULL DEFAULT 0
    )''')
    columns = {r[1] for r in db._conn.execute('PRAGMA table_info(local_ninja_trial)')}
    for name, definition in (
        ('score', 'INTEGER NOT NULL DEFAULT 0'),
        ('highest_score', 'INTEGER NOT NULL DEFAULT 0'),
        ('total_score', 'INTEGER NOT NULL DEFAULT 0'),
        ('buffs', "TEXT NOT NULL DEFAULT ''"),
        ('npc_ids', "TEXT NOT NULL DEFAULT ''"),
        ('claimed', "TEXT NOT NULL DEFAULT ''"),
        ('vip_sweep', 'INTEGER NOT NULL DEFAULT 0'),
        ('vip_day', "TEXT NOT NULL DEFAULT ''"),
        ('lost_treasure', 'INTEGER NOT NULL DEFAULT 0'),
        ('lost_treasure_bought', 'INTEGER NOT NULL DEFAULT 0'),
        ('vip_buff_info', "TEXT NOT NULL DEFAULT ''"),
        ('vip_reward_info', "TEXT NOT NULL DEFAULT ''"),
    ):
        if name not in columns:
            db._conn.execute('ALTER TABLE local_ninja_trial ADD COLUMN %s %s' % (name, definition))
    db._conn.execute('''CREATE TABLE IF NOT EXISTS local_ninja_trial_receipts (
        conta_id INTEGER NOT NULL REFERENCES contas(id) ON DELETE CASCADE,
        signature TEXT NOT NULL,
        reply TEXT NOT NULL,
        PRIMARY KEY(conta_id, signature)
    )''')
    db._conn.execute('''CREATE TABLE IF NOT EXISTS local_ninja_trial_claims (
        conta_id INTEGER NOT NULL REFERENCES contas(id) ON DELETE CASCADE,
        kind TEXT NOT NULL,
        item_id INTEGER NOT NULL,
        payload TEXT NOT NULL DEFAULT '',
        PRIMARY KEY(conta_id, kind, item_id)
    )''')


def _cfg(row_id):
    from pathlib import Path
    path = Path(data.MOULD).parent / 'configs' / 'play_config.txt'
    for line in path.read_text(encoding='utf-8').splitlines():
        cells = line.split('\t')
        if cells and cells[0] == str(row_id):
            return cells[-1]
    raise ValueError('config_play_config_%s_ausente' % row_id)


def _original_table(name):
    table=data.tabela(name+'.txt')
    if table:
        return table
    root=Path(data.MOULD).parents[2]
    source=root/'01_conteudo_apk'/'assets'/'res'/'data'/(name+'.txt')
    if not source.exists():
        source=root/'atualizacao'/'01_conteudo_apk'/'assets'/'res'/'data'/(name+'.txt')
    result={}
    if source.exists():
        for line in source.read_text(encoding='utf-8',errors='replace').splitlines():
            cells=line.split('\t')
            if cells and cells[0].isdigit(): result[cells[0]]=cells
    return result


def _state(db, account):
    row = db._conn.execute('SELECT floor,stars,score,highest_score,total_score,last_hp,buffs,npc_ids,claimed,vip_sweep,vip_day,lost_treasure,lost_treasure_bought,vip_buff_info,vip_reward_info '
                           'FROM local_ninja_trial WHERE conta_id=?', (account,)).fetchone()
    if row:
        return dict(zip(('floor','stars','score','highest_score','total_score','last_hp',
                         'buffs','npc_ids','claimed','vip_sweep','vip_day','lost_treasure','lost_treasure_bought','vip_buff_info','vip_reward_info'), tuple(row)))
    return {'floor': 0, 'stars': 0, 'score': 0, 'highest_score': 0, 'total_score': 0,
            'last_hp': '', 'buffs': '', 'npc_ids': '', 'claimed': '0', 'vip_sweep': 0, 'vip_day': '',
            'lost_treasure': 0, 'lost_treasure_bought': 0, 'vip_buff_info':'', 'vip_reward_info':''}


def _owned_hp(db, account):
    import recruitment_local, hero_stats_local
    import gameplay_mode
    hp = {}
    for ship, mould in recruitment_local.all_owned(db, account):
        stats = hero_stats_local.effective(db, account, ship, mould)
        hp[str(ship)] = {'hp': int(stats['health']), 'percent': 100, 'anger': 0}
    return hp


def _ship_data(db, account, saved):
    ships = _owned_hp(db, account)
    for chunk in (saved or '').split('|'):
        if ':' not in chunk:
            continue
        ship, rest = chunk.split(':', 1)
        parts = rest.split(',')
        if ship in ships and len(parts) >= 3:
            try:
                ships[ship] = {'hp': max(0, int(float(parts[0]))),
                               'anger': max(0, int(float(parts[1]))),
                               'percent': max(0, min(100, int(float(parts[2]))))}
            except ValueError:
                continue
    return '|'.join('%s:%s,%s,%s' % (ship, v['hp'], v['anger'], v['percent'])
                    for ship, v in sorted(ships.items(), key=lambda x: int(x[0])))


def _power(db, account):
    import recruitment_local, hero_power_local, hero_level_local
    minimum = int(_cfg(24))
    ships = []
    for ship, mould in recruitment_local.all_owned(db, account):
        level = hero_level_local.state(db, account, ship, mould)[0]
        if level < minimum:
            continue
        ships.append((hero_power_local.character(db, account, ship, mould), ship, mould))
    total = sum(x[0] for x in sorted(ships, reverse=True)[:6])
    return max(total, int(_cfg(78)))


def _npc_lineup(db, account, floor):
    # Exact strength bands and NPC ranges are play_config row 28 from the APK.
    power = _power(db, account)
    band = None
    for part in _cfg(28).split('|'):
        lo, hi, npc_lo, npc_hi = map(int, part.split(','))
        if power >= lo and (power <= hi or hi < 0):
            band = (npc_lo, npc_hi)
            break
    if not band:
        raise ValueError('faixa_npc_trial_ausente')
    low, high = band
    if high < 0:
        high = max(int(r[0]) for r in data.tabela('npc.txt').values() if r[0].isdigit())
    valid = [n for n in range(low, high + 1) if str(n) in data.tabela('npc.txt')]
    if len(valid) < 3:
        raise ValueError('npcs_trial_originais_ausentes')
    randomizer = random.Random('%s:%s' % (account, floor))
    return ','.join(map(str, randomizer.sample(valid, 3)))


def _battle_choices(db, account, floor, npc_ids, npc):
    """Exact score/star choices from GuanQia.lua and BattleReward.lua."""
    import vip_local
    grade_row=db._conn.execute('SELECT grade FROM local_campaign WHERE conta_id=?',(account,)).fetchone()
    grade=int(grade_row[0]) if grade_row else 1
    intervals=[]
    for item in _cfg(23).split('!'):
        part=item.split('|')
        if len(part)==3: intervals.append(part)
    selected=next((part for part in intervals if grade<=int(part[0].split(',')[1])),intervals[-1])
    base=list(map(int,selected[1].split(','))); tolerance=list(map(int,selected[2].split(',')))
    candidate=list(npc_ids).index(npc)
    score_base=math.floor(base[candidate]+tolerance[candidate]*math.floor(floor/2))
    vip=int(vip_local.grade(db,account)); bonus=1.0
    for rule in _cfg(32).split('|'):
        required,percent=map(int,rule.split(','))
        if vip>=required: bonus=1+percent/100
    multipliers=list(map(float,_cfg(25).split(',')))
    factors=(1,3,5)
    return {(stars*factors[candidate], math.floor(score_base*bonus*multipliers[stars-1]))
            for stars in (1,2,3)}


def _wallet(db, account):
    db._conn.execute('INSERT OR IGNORE INTO local_special_wallet(conta_id) VALUES (?)', (account,))
    return int(db._conn.execute('SELECT trial FROM local_special_wallet WHERE conta_id=?', (account,)).fetchone()[0])


def _sweep_layout(db, account):
    import vip_local
    vip=int(vip_local.grade(db,account))
    consume=data.tabela('base_consume.txt').get('66') or []
    # SmTrialTowerSweep.lua treats base_consume[66] as the last cleared floor,
    # then adds one to obtain the next/current floor. Keep that exact value in
    # the response so both the sweep preview and the submitted request agree.
    jump=int(consume[min(3+vip,len(consume)-1)])+1 if len(consume)>4 else 0
    floors=data.tabela('three_kingdoms_config.txt')
    buffs=[];boxes=[]
    for index in range(1,min(jump,len(floors)+1)):
        row=floors.get(str(index))
        if not row or row[2]!='-1':continue
        if row[3]=='-1':buffs.append('%s:0,0,0'%index)
        else:boxes.append('%s:0'%index)
    return '|'.join(buffs),'|'.join(boxes),jump


def _tokens(db, account, state, seq, command, left=0, lost=0):
    ids = state['npc_ids'] or _npc_lineup(db, account, state['floor'] + 1)
    ships = _ship_data(db, account, state['last_hp'])
    claimed = state['claimed'] or ''
    score_state = str(state['score'])
    highest = str(state['highest_score'])
    total = str(state['total_score'])
    wallet = _wallet(db, account)
    # Parsers 343/347 (ProtocolParser.lua) and 12558 (ProtocolParserCopyExx.lua).
    tokens = [str(seq), command, '0', '343', str(state['stars']), str(state['stars']),
              str(left), state['buffs'], str(state['floor']), '0', str(lost),
              '347', '0', '0', '0', '12558', score_state, highest, total,
              claimed, '0', ships, ids, str(wallet), str(state['vip_sweep']),
              state['vip_buff_info'] or '0', state['vip_reward_info'] or '0']
    if state['lost_treasure']:
        tokens += ['381',str(state['lost_treasure']),str(state['lost_treasure_bought'])]
    return ' '.join(tokens)


def _save(db, account, s):
    db._conn.execute('''INSERT INTO local_ninja_trial
        (conta_id,floor,stars,score,highest_score,total_score,last_hp,buffs,npc_ids,claimed,vip_sweep,vip_day,lost_treasure,lost_treasure_bought,vip_buff_info,vip_reward_info,updated)
        VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,strftime('%s','now'))
        ON CONFLICT(conta_id) DO UPDATE SET floor=excluded.floor,stars=excluded.stars,
        score=excluded.score,highest_score=excluded.highest_score,total_score=excluded.total_score,
        last_hp=excluded.last_hp,buffs=excluded.buffs,npc_ids=excluded.npc_ids,
        claimed=excluded.claimed,vip_sweep=excluded.vip_sweep,vip_day=excluded.vip_day,
        lost_treasure=excluded.lost_treasure,lost_treasure_bought=excluded.lost_treasure_bought,
        vip_buff_info=excluded.vip_buff_info,vip_reward_info=excluded.vip_reward_info,updated=excluded.updated''',
        (account,s['floor'],s['stars'],s['score'],s['highest_score'],s['total_score'],
         s['last_hp'],s['buffs'],s['npc_ids'],s['claimed'],s['vip_sweep'],s['vip_day'],s['lost_treasure'],s['lost_treasure_bought'],s['vip_buff_info'],s['vip_reward_info']))


def _receipt(db, account, fields):
    signature = hashlib.sha256('\n'.join(fields).encode('utf-8')).hexdigest()
    return signature, db._conn.execute('SELECT reply FROM local_ninja_trial_receipts WHERE conta_id=? AND signature=?',
                                        (account, signature)).fetchone()


def _reward(db, account, rewards):
    import shop_local
    import dados_batalha as d
    result = []
    for part in rewards.split('|'):
        if not part or part in ('-1','0'):
            continue
        kind, ident, amount = map(int, part.split(','))
        if amount <= 0:
            raise ValueError('quantidade_recompensa_invalida')
        if kind == 1:
            db._conn.execute('INSERT OR IGNORE INTO local_campaign(conta_id,grade,silver) VALUES (?,1,0)', (account,))
            db._conn.execute('UPDATE local_campaign SET silver=silver+? WHERE conta_id=?', (amount,account))
        elif kind == 2:
            db._conn.execute('INSERT OR IGNORE INTO local_resources(conta_id) VALUES (?)', (account,))
            db._conn.execute('UPDATE local_resources SET gold=gold+? WHERE conta_id=?', (amount,account))
        elif kind == 3:
            db._conn.execute('INSERT OR IGNORE INTO local_resources(conta_id) VALUES (?)', (account,))
            db._conn.execute('UPDATE local_resources SET honour=honour+? WHERE conta_id=?', (amount,account))
        elif kind in (6,7):
            result.append(shop_local.grant(db, account, kind, ident, amount))
        elif kind == 18:
            db._conn.execute('INSERT OR IGNORE INTO local_special_wallet(conta_id) VALUES (?)', (account,))
            db._conn.execute('UPDATE local_special_wallet SET trial=trial+? WHERE conta_id=?', (amount,account))
        else:
            raise ValueError('tipo_recompensa_trial_nao_suportado_%s' % kind)
    return result


def install(server):
    def initialize(seq, text):
        try:
            account = server.BANCO.sessao_de(server._sessao_da_conexao())['conta_id']
            fields = server._linhas(text)
            if not fields or fields[0] != str(server.BANCO.perfil(account)['user_id']):
                raise ValueError('perfil_invalido')
            if not data.tabela('three_kingdoms_config.txt'):
                raise ValueError('configuracao_ninja_trial_indisponivel')
            db = server.BANCO
            with db._lock, db._conn:
                _schema(db)
                s = _state(db, account)
                import shop_local
                if s['vip_day'] != shop_local.day():
                    s['vip_day'] = shop_local.day()
                    s['vip_sweep'] = 0
                    s['vip_buff_info'],s['vip_reward_info'],_=_sweep_layout(db,account)
                if not s['npc_ids']:
                    s['npc_ids'] = _npc_lineup(db, account, s['floor'] + 1)
                    _save(db, account, s)
                return _tokens(db, account, s, seq, 'three_kingdoms_init')
        except (server._contas.ErroConta, ValueError, IndexError, TypeError, KeyError) as exc:
            return server.recusa('three_kingdoms_init', seq, str(exc) or 'ninja_trial_indisponivel')

    def launch(seq, text):
        command = 'three_kingdoms_launch'
        try:
            db = server.BANCO
            account = db.sessao_de(server._sessao_da_conexao())['conta_id']
            fields = server._linhas(text)
            uid = str(db.perfil(account)['user_id'])
            if not fields or fields[0] != uid:
                raise ValueError('perfil_invalido')
            args = fields[1:]
            # Keep empty protocol fields: the APK deliberately sends them.
            if len(args) < 10:
                raise ValueError('parametros_ninja_trial_invalidos')
            kind, scene, npc, stars, difficulty, floor = map(int, args[:6])
            hp, _empty, buffs, score = args[6:10]
            formation = args[10] if len(args) > 10 else ''
            if kind != 54 or scene != int(_cfg(26)):
                raise ValueError('cena_ou_tipo_trial_invalido')
            if len(args) not in (10, 11):
                raise ValueError('campos_trial_invalidos')
            floor_cfg = data.tabela('three_kingdoms_config.txt').get(str(floor)) if floor > 0 else None
            with db._lock, db._conn:
                _schema(db)
                sig, prior = _receipt(db, account, fields[1:])
                if prior:
                    return str(seq) + prior[0][len(prior[0].split(' ', 1)[0]):]
                s = _state(db, account)
                success = npc > 0 and floor > 0 and difficulty == 1 and int(score) > 0
                defeat = npc == 0 and floor == -1 and int(score) == 0
                chest = npc == 0 and stars == 0 and difficulty == 0 and floor > 0 and hp == '' and buffs == '' and int(score) == 0
                buff = npc == 0 and stars == 0 and difficulty == 0 and floor > 0 and (hp != '' or buffs != '') and int(score) == 0
                sweep = npc == 1 and floor > 0 and difficulty == 1 and int(score) >= 0
                display_rewards = []
                if success or sweep:
                    if not floor_cfg or floor_cfg[2] == '-1':
                        raise ValueError('piso_trial_nao_e_luta')
                    if (success and floor != int(s['floor'])+1) or (sweep and floor < int(s['floor'])+1):
                        raise ValueError('piso_trial_ainda_bloqueado')
                    ids = [int(x) for x in (s['npc_ids'] or _npc_lineup(db, account, floor)).split(',')]
                    if npc not in ids and not sweep:
                        raise ValueError('npc_fora_da_formacao_trial')
                    if success and (stars,int(score)) not in _battle_choices(db,account,floor,ids,npc):
                        raise ValueError('pontuacao_ou_estrelas_trial_invalidas')
                    s['floor'] = max(int(s['floor']), floor)
                    s['stars'] += stars
                    s['score'] += int(score)
                    s['highest_score'] = max(s['highest_score'], s['score'])
                    s['total_score'] += int(score)
                    s['last_hp'] = hp.split('-', 1)[0] if hp else s['last_hp']
                    if buffs:
                        s['buffs'] = buffs
                    s['npc_ids'] = _npc_lineup(db, account, s['floor'] + 1) if s['floor'] < len(data.tabela('three_kingdoms_config.txt')) else s['npc_ids']
                    s['vip_sweep'] = 0 if sweep else s['vip_sweep']
                elif defeat:
                    s['last_hp'] = hp.split('-', 1)[0] if hp else s['last_hp']
                    goods=[r for r in _original_table('unparalleled_reward_param').values() if int(r[7])>0]
                    if goods:
                        picked=random.choices(goods,weights=[int(r[7]) for r in goods],k=1)[0]
                        s['lost_treasure']=int(picked[0]);s['lost_treasure_bought']=0
                elif chest:
                    if not floor_cfg or floor_cfg[2] != '-1' or floor > int(s['floor']) + 1:
                        raise ValueError('bau_trial_indisponivel')
                    if db._conn.execute('SELECT 1 FROM local_ninja_trial_claims WHERE conta_id=? AND kind=? AND item_id=?', (account,'chest',floor)).fetchone():
                        raise ValueError('bau_trial_ja_recebido')
                    reward_field = floor_cfg[3]
                    selected = None
                    if '!' in reward_field:
                        group, levels = reward_field.split('!', 1)
                        level = int((db._conn.execute('SELECT grade FROM local_campaign WHERE conta_id=?',(account,)).fetchone() or [1])[0])
                        for entry in levels.split('|'):
                            bounds, rid = entry.split(',', 1)
                            lo, hi = map(int, bounds.split('-'))
                            if lo <= level <= hi:
                                selected = rid
                                break
                        if selected is None:
                            raise ValueError('faixa_recompensa_bau_nao_encontrada')
                    else:
                        selected = reward_field
                    reward_row = data.tabela('scene_reward.txt').get(str(selected))
                    if not reward_row:
                        raise ValueError('recompensa_original_trial_ausente')
                    entries = []
                    # scene_reward: currencies cols 3-7, item drops col 8.
                    for idx, amount in enumerate(reward_row[2:7], 1):
                        if int(amount or 0) > 0:
                            entries.append((idx, -1, int(amount)))
                            display_rewards.append((-1, idx, int(amount)))
                    for entry in reward_row[7].split('|'):
                        if entry in ('','0','-1'):
                            continue
                        parts=entry.split(','); amount,mould=map(int,parts[:2])
                        chance=parts[2] if len(parts)>2 else '1/1'
                        numerator,denominator=map(int,chance.split('/')) if '/' in chance else (int(chance),1)
                        if denominator<=0 or not 0<=numerator<=denominator: raise ValueError('chance_item_bau_trial_invalida')
                        if random.randrange(denominator)<numerator:
                            entries.append((6, mould, amount)); display_rewards.append((mould,6,amount))
                    _apply_scene_reward(db, account, entries)
                    db._conn.execute('INSERT INTO local_ninja_trial_claims(conta_id,kind,item_id,payload) VALUES (?,?,?,?)', (account,'chest',floor,json.dumps(entries)))
                    s['floor']=max(int(s['floor']),floor)
                    if s['floor']<len(data.tabela('three_kingdoms_config.txt')):
                        s['npc_ids']=_npc_lineup(db,account,s['floor']+1)
                elif buff:
                    if not floor_cfg or floor_cfg[4] in ('-1','0','') or floor > int(s['floor']) + 1:
                        raise ValueError('buff_trial_indisponivel')
                    # AdditionSelect sends selected id:ship pairs in the
                    # otherwise-empty field; values come from the floor's
                    # attribute_add_id table, as in the original client.
                    allowed = data.tabela('three_kingdoms_attribute.txt')
                    parsed = []
                    config_ids, config_values = floor_cfg[4].split('|', 1)
                    values = dict(zip(config_ids.split(','), config_values.split(',')))
                    for item in _empty.split('|'):
                        if not item:
                            continue
                        pair = item.split(':')
                        buff_id = pair[0] if pair else ''
                        if len(pair) != 2 or not buff_id.isdigit() or buff_id not in allowed or buff_id not in values:
                            raise ValueError('buff_trial_invalido')
                        parsed.append('%s,%s' % (item, values[buff_id]))
                    if not parsed:
                        raise ValueError('buff_trial_vazio')
                    s['buffs'] = '|'.join(parsed)
                    s['last_hp'] = hp.split('-', 1)[0] if hp else s['last_hp']
                    s['floor']=max(int(s['floor']),floor)
                    if s['floor']<len(data.tabela('three_kingdoms_config.txt')):
                        s['npc_ids']=_npc_lineup(db,account,s['floor']+1)
                else:
                    raise ValueError('acao_trial_nao_suportada')
                _save(db, account, s)
                reply = _tokens(db, account, s, seq, command, stars if success else 0, -1 if defeat else 0)
                if chest:
                    reward_tokens=['171','37',str(len(display_rewards))]
                    for reward in display_rewards: reward_tokens.extend(map(str,reward))
                    reply += ' ' + ' '.join(reward_tokens)
                db._conn.execute('INSERT INTO local_ninja_trial_receipts(conta_id,signature,reply) VALUES (?,?,?)', (account,sig,reply))
                return reply
        except (server._contas.ErroConta, ValueError, IndexError, TypeError, KeyError) as exc:
            return server.recusa(command, seq, str(exc) or 'ninja_trial_indisponivel')

    def draw_score(seq, text):
        cmd = 'three_kingdoms_draw_score_reward'
        try:
            db = server.BANCO
            account = db.sessao_de(server._sessao_da_conexao())['conta_id']
            fields = [x for x in server._linhas(text) if x.strip()]
            if len(fields) != 2 or fields[0] != str(db.perfil(account)['user_id']):
                raise ValueError('perfil_invalido')
            wanted = fields[1]
            with db._lock, db._conn:
                _schema(db); s = _state(db, account)
                table = data.tabela('three_kingdoms_score_reward_param.txt')
                ids = sorted(table, key=int) if wanted == '-1' else [wanted]
                granted = []
                for ident in ids:
                    row = table.get(str(ident))
                    if not row: raise ValueError('recompensa_trial_inexistente')
                    if int(s['score']) < int(row[1]):
                        if wanted != '-1': raise ValueError('pontuacao_trial_insuficiente')
                        continue
                    if db._conn.execute('SELECT 1 FROM local_ninja_trial_claims WHERE conta_id=? AND kind=? AND item_id=?',(account,'score',int(ident))).fetchone():
                        if wanted != '-1': raise ValueError('recompensa_trial_ja_recebida')
                        continue
                    granted.extend(_reward(db,account,row[2]))
                    db._conn.execute('INSERT INTO local_ninja_trial_claims(conta_id,kind,item_id,payload) VALUES (?,?,?,?)',(account,'score',int(ident),row[2]))
                    claimed=set(filter(None,s['claimed'].split(','))); claimed.add(str(ident)); s['claimed']=','.join(sorted(claimed,key=int))
                _save(db,account,s)
                return _tokens(db,account,s,seq,cmd)
        except (server._contas.ErroConta,ValueError,IndexError,TypeError,KeyError) as exc:
            return server.recusa(cmd,seq,str(exc) or 'recompensa_trial_indisponivel')

    def dignified_buy(seq,text):
        cmd='dignified_shop_buy'
        try:
            db=server.BANCO;account=db.sessao_de(server._sessao_da_conexao())['conta_id']
            fields=server._linhas(text);uid=str(db.perfil(account)['user_id'])
            if len(fields)!=3 or fields[0]!=uid:raise ValueError('parametros_loja_trial_invalidos')
            item_id,quantity=map(int,fields[1:])
            if quantity<1 or quantity>100:raise ValueError('quantidade_loja_trial_invalida')
            table=_original_table('dignified_shop_model');row=table.get(str(item_id))
            if not row or len(row)<15:raise ValueError('produto_trial_ausente')
            with db._lock,db._conn:
                _schema(db);s=_state(db,account)
                signature,prior=_receipt(db,account,[cmd,str(seq)]+fields[1:])
                if prior:return str(seq)+prior[0][len(prior[0].split(' ',1)[0]):]
                prop=int(row[1]);kind=int(row[2]);count=int(row[7])*quantity
                required_stars=int(row[6]);limit=int(row[8]);reset=int(row[9])==1
                cost=int(row[10])*quantity;gold_cost=int(row[11])*quantity
                min_level=int(row[12]);extra=int(row[13]);extra_count=int(row[14])*quantity
                if s['stars']<required_stars:raise ValueError('estrelas_trial_insuficientes')
                level_row=db._conn.execute('SELECT grade FROM local_campaign WHERE conta_id=?',(account,)).fetchone()
                if min_level>0 and (int(level_row[0]) if level_row else 1)<min_level:raise ValueError('nivel_insuficiente_para_produto_trial')
                old=db._conn.execute("SELECT payload FROM local_ninja_trial_claims WHERE conta_id=? AND kind='shop' AND item_id=?",(account,item_id)).fetchone()
                purchases=json.loads(old[0]) if old else {'count':0,'day':''}
                import shop_local
                today=shop_local.day()
                purchased=0 if reset and purchases.get('day')!=today else int(purchases.get('count',0))
                if limit>=0 and purchased+quantity>limit:raise ValueError('limite_de_compra_trial_atingido')
                wallet=_wallet(db,account)
                gold_row=db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?',(account,)).fetchone()
                gold=int(gold_row[0]) if gold_row else 0
                if cost<0 or wallet<cost:raise ValueError('moeda_trial_insuficiente')
                if gold_cost<0 or gold<gold_cost:raise ValueError('gold_insuficiente')
                if extra_count:
                    held=db._conn.execute('SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=?',(account,extra)).fetchone()
                    if not held or int(held[0])<extra_count:raise ValueError('item_adicional_trial_insuficiente')
                    db._conn.execute('UPDATE local_inventory SET quantity=quantity-? WHERE conta_id=? AND mould=?',(extra_count,account,extra))
                result=[]
                if kind==0:
                    if str(prop) not in data.tabela('prop_mould.txt'):raise ValueError('item_trial_invalido')
                    result.append(__import__('shop_local').grant(db,account,6,prop,count))
                elif kind==2:
                    result.append(__import__('shop_local').grant(db,account,7,prop,count))
                else:
                    raise ValueError('tipo_personagem_na_loja_trial_nao_suportado')
                db._conn.execute('UPDATE local_special_wallet SET trial=trial-? WHERE conta_id=?',(cost,account))
                db._conn.execute('INSERT OR IGNORE INTO local_resources(conta_id) VALUES (?)',(account,))
                db._conn.execute('UPDATE local_resources SET gold=gold-?+? WHERE conta_id=?',(gold_cost,int(row[5])*quantity,account))
                db._conn.execute('INSERT OR IGNORE INTO local_campaign(conta_id,grade,silver) VALUES (?,1,0)',(account,))
                db._conn.execute('UPDATE local_campaign SET silver=silver+? WHERE conta_id=?',(int(row[4])*quantity,account))
                purchases={'count':purchased+quantity,'day':today if reset else purchases.get('day','')}
                db._conn.execute("INSERT INTO local_ninja_trial_claims(conta_id,kind,item_id,payload) VALUES (?,?,?,?) ON CONFLICT(conta_id,kind,item_id) DO UPDATE SET payload=excluded.payload",(account,'shop',item_id,json.dumps(purchases)))
                _save(db,account,s)
                import shop_local
                from hero_training_local import inventory_tokens
                reply=' '.join([str(seq),cmd,'0']+inventory_tokens(db,account)+shop_local.balances(db,account)+shop_local.state_tokens(db,account,result)+_tokens(db,account,s,seq,cmd).split(' ',2)[2:])
                db._conn.execute('INSERT INTO local_ninja_trial_receipts(conta_id,signature,reply) VALUES (?,?,?)',(account,signature,reply))
                return reply
        except (server._contas.ErroConta,ValueError,IndexError,TypeError,KeyError) as exc:
            return server.recusa(cmd,seq,str(exc) or 'compra_trial_indisponivel')

    def unparallel_buy(seq,text):
        cmd='unparallel_purchase'
        try:
            db=server.BANCO;account=db.sessao_de(server._sessao_da_conexao())['conta_id']
            fields=server._linhas(text);uid=str(db.perfil(account)['user_id'])
            if len(fields)!=2 or fields[0]!=uid or not fields[1].isdigit():raise ValueError('parametros_tesouro_trial_invalidos')
            item_id=int(fields[1]);row=_original_table('unparalleled_reward_param').get(str(item_id))
            if not row or len(row)<8:raise ValueError('tesouro_trial_ausente')
            kind,mould,count,silver,cost,discount=map(int,(row[1],row[2],row[3],row[4],row[5],row[6]))
            with db._lock,db._conn:
                _schema(db);s=_state(db,account)
                signature,prior=_receipt(db,account,[cmd,str(seq)]+fields[1:])
                if prior:return str(seq)+prior[0][len(prior[0].split(' ',1)[0]):]
                if item_id!=int(s['lost_treasure']) or int(s['lost_treasure_bought']):
                    raise ValueError('tesouro_trial_nao_disponivel')
                goldrow=db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?',(account,)).fetchone()
                gold=int(goldrow[0]) if goldrow else 0
                if discount<=0 or gold<discount:raise ValueError('gold_insuficiente')
                import shop_local
                if silver>0:
                    db._conn.execute('INSERT OR IGNORE INTO local_campaign(conta_id,grade,silver) VALUES (?,1,0)',(account,))
                    db._conn.execute('UPDATE local_campaign SET silver=silver+? WHERE conta_id=?',(silver,account));result=[{'m_type':1,'mould_id':-1,'number':silver}]
                elif kind==0:
                    if str(mould) not in data.tabela('prop_mould.txt'):raise ValueError('item_tesouro_trial_invalido')
                    result=[shop_local.grant(db,account,6,mould,count)]
                elif kind==2:
                    result=[shop_local.grant(db,account,7,mould,count)]
                else:raise ValueError('tipo_personagem_tesouro_trial_nao_suportado')
                db._conn.execute('UPDATE local_resources SET gold=gold-? WHERE conta_id=?',(discount,account))
                s['lost_treasure_bought']=1;_save(db,account,s)
                from hero_training_local import inventory_tokens
                reply=' '.join([str(seq),cmd,'0','381',str(item_id),'1']+inventory_tokens(db,account)+shop_local.balances(db,account,-discount)+shop_local.state_tokens(db,account,result)+_tokens(db,account,s,seq,cmd).split(' ',2)[2:])
                db._conn.execute('INSERT INTO local_ninja_trial_receipts(conta_id,signature,reply) VALUES (?,?,?)',(account,signature,reply))
                return reply
        except (server._contas.ErroConta,ValueError,IndexError,TypeError,KeyError) as exc:
            return server.recusa(cmd,seq,str(exc) or 'compra_tesouro_trial_indisponivel')

    def sweep(seq, text):
        cmd='three_kingdoms_sweep'
        try:
            db=server.BANCO; account=db.sessao_de(server._sessao_da_conexao())['conta_id']
            fields=server._linhas(text)
            if len(fields)<8 or fields[0]!=str(db.perfil(account)['user_id']): raise ValueError('parametros_varredura_trial_invalidos')
            mode=int(fields[1])
            with db._lock,db._conn:
                _schema(db); s=_state(db,account)
                if mode==0:
                    import vip_local
                    import shop_local
                    vip=int(vip_local.grade(db,account))
                    level_row=db._conn.execute('SELECT grade FROM local_campaign WHERE conta_id=?',(account,)).fetchone()
                    if (int(level_row[0]) if level_row else 1)<int(_cfg(57)): raise ValueError('nivel_insuficiente_para_varredura_trial')
                    today=shop_local.day()
                    if s['vip_day']==today and s['vip_sweep']:
                        raise ValueError('varredura_vip_trial_ja_usada_hoje')
                    consume=data.tabela('base_consume.txt').get('66')
                    if not consume: raise ValueError('config_varredura_trial_ausente')
                    # Original client uses base_consume[66] + 1 for jumpFloor.
                    jump=int(consume[min(3+vip,len(consume)-1)])+1
                    if jump<=0: raise ValueError('vip_sem_pisos_de_varredura_configurados')
                    scene_grade=db._conn.execute('SELECT grade FROM local_campaign WHERE conta_id=?',(account,)).fetchone()
                    grade=int(scene_grade[0]) if scene_grade else 1
                    interval=None
                    for item in _cfg(23).split('!'):
                        parts=item.split('|'); levels=list(map(int,parts[0].split(',')))
                        if grade<=levels[1]: interval=parts;break
                    if interval is None: interval=_cfg(23).split('!')[-1].split('|')
                    base=list(map(int,interval[1].split(','))); tolerance=list(map(int,interval[2].split(',')))
                    mult=list(map(float,_cfg(25).split(',')))
                    bonus=1.0
                    for item in _cfg(32).split('|'):
                        need,percent=map(int,item.split(','))
                        if vip>=need: bonus=1+percent/100
                    fights=0; expected_score=0
                    for idx in range(1,min(jump,len(data.tabela('three_kingdoms_config.txt'))+1)):
                        row=data.tabela('three_kingdoms_config.txt').get(str(idx))
                        if row and row[2]!='-1':
                            expected_score+=math.floor((base[2]+tolerance[2]*fights)*bonus*mult[2]);fights+=1
                    expected_stars=fights*15
                    if (int(fields[2]),int(fields[3]),int(fields[4]))!=(expected_stars,expected_score,jump):
                        raise ValueError('dados_varredura_trial_nao_correspondem_ao_original')
                    s['floor']=max(int(s['floor']),min(jump-1,len(data.tabela('three_kingdoms_config.txt'))))
                    s['stars']+=expected_stars;s['score']+=expected_score
                    s['total_score']+=expected_score;s['highest_score']=max(s['highest_score'],s['score'])
                    s['vip_sweep']=1
                    s['vip_day']=today
                    s['npc_ids']=_npc_lineup(db,account,s['floor']+1) if s['floor']<len(data.tabela('three_kingdoms_config.txt')) else s['npc_ids']
                    _save(db,account,s)
                    return _tokens(db,account,s,seq,cmd,expected_stars)
                if mode==1:
                    if not s['vip_sweep']: raise ValueError('varredura_trial_nao_ativada')
                    import shop_local
                    s['last_hp']=fields[6].split('-',1)[0]; s['vip_sweep']=1; s['vip_day']=shop_local.day(); _save(db,account,s)
                    return _tokens(db,account,s,seq,cmd)
                if mode==2:
                    if not s['vip_sweep']: raise ValueError('varredura_trial_nao_ativada')
                    if len(fields)!=8: raise ValueError('parametros_buff_varredura_trial_invalidos')
                    floor=int(fields[4]);config=data.tabela('three_kingdoms_config.txt').get(str(floor))
                    if not config or config[4] in ('','-1','0'): raise ValueError('buff_varredura_trial_indisponivel')
                    allowed,levels=config[4].split('|',1);level_by_id=dict(zip(allowed.split(','),levels.split(',')))
                    attributes=data.tabela('three_kingdoms_attribute.txt');parsed=[]
                    for item in fields[5].split('|'):
                        if not item:continue
                        if item=='-1:-1':continue
                        pair=item.split(':')
                        if len(pair)!=2 or pair[0] not in level_by_id or pair[0] not in attributes or pair[1]!='-1':
                            raise ValueError('buff_varredura_trial_invalido')
                        parsed.append('%s,%s' % (item,level_by_id[pair[0]]))
                    if len(parsed)>3:raise ValueError('limite_de_buffs_trial')
                    s['buffs']='|'.join(parsed)
                    s['last_hp']=fields[6].split('-',1)[0]
                    layout={}
                    for entry in s['vip_buff_info'].split('|'):
                        if ':' in entry:
                            floor_key,values=entry.split(':',1);layout[floor_key]=values
                    choices=fields[5]
                    selected={item.split(':',1)[0] for item in choices.split('|') if ':' in item and item!='-1:-1'}
                    ids=allowed.split(',')
                    layout[str(floor)]=','.join(ident if ident in selected else '0' for ident in ids)
                    s['vip_buff_info']='|'.join('%s:%s'%(key,layout[key]) for key in sorted(layout,key=int))
                    sig,prior=_receipt(db,account,[cmd,str(seq)]+fields[1:])
                    if prior:return str(seq)+prior[0][len(prior[0].split(' ',1)[0]):]
                    _save(db,account,s)
                    reply=_tokens(db,account,s,seq,cmd)
                    db._conn.execute('INSERT INTO local_ninja_trial_receipts(conta_id,signature,reply) VALUES (?,?,?)',(account,sig,reply))
                    return reply
                if mode==4:
                    if not s['vip_sweep']: raise ValueError('varredura_trial_nao_ativada')
                    import shop_local
                    from hero_training_local import inventory_tokens
                    if len(fields)<8:raise ValueError('parametros_bau_varredura_invalidos')
                    times=int(fields[7])
                    if times not in (1,2,5,10):raise ValueError('quantidade_bau_varredura_invalida')
                    sig,prior=_receipt(db,account,[cmd,str(seq)]+fields[1:])
                    if prior:return str(seq)+prior[0][len(prior[0].split(' ',1)[0]):]
                    cost_table=list(map(int,_cfg(27).split(',')))
                    level_row=db._conn.execute('SELECT grade FROM local_campaign WHERE conta_id=?',(account,)).fetchone()
                    level=int(level_row[0]) if level_row else 1
                    updated={};total_cost=0;display=[]
                    for entry in s['vip_reward_info'].split('|'):
                        if not entry:continue
                        floor_text,count_text=entry.split(':',1);chest_floor=int(floor_text);bought=int(count_text)
                        floor_cfg=data.tabela('three_kingdoms_config.txt').get(floor_text)
                        if not floor_cfg or floor_cfg[2]!='-1' or floor_cfg[3]=='-1':raise ValueError('bau_varredura_trial_invalido')
                        for index in range(times):
                            price_index=min(max(0,bought+index),len(cost_table)-1)
                            total_cost+=cost_table[price_index]
                            reward_field=floor_cfg[3];selected=None
                            if '!' in reward_field:
                                _group,level_list=reward_field.split('!',1)
                                for band in level_list.split('|'):
                                    bounds,rid=band.split(',',1);lo,hi=map(int,bounds.split('-'))
                                    if lo<=level<=hi:selected=rid;break
                            else:selected=reward_field
                            reward_row=data.tabela('scene_reward.txt').get(str(selected)) if selected else None
                            if not reward_row:raise ValueError('recompensa_bau_trial_ausente')
                            entries=[]
                            for kind,value in enumerate(reward_row[2:7],1):
                                amount=int(value or 0)
                                if amount>0:entries.append((kind,-1,amount));display.append((-1,kind,amount))
                            for loot in reward_row[7].split('|'):
                                if loot in ('','0','-1'):continue
                                parts=loot.split(',');amount,mould=map(int,parts[:2]);chance=parts[2] if len(parts)>2 else '1/1'
                                numerator,denominator=map(int,chance.split('/')) if '/' in chance else (int(chance),1)
                                if denominator<=0 or not 0<=numerator<=denominator:raise ValueError('chance_item_bau_trial_invalida')
                                if random.randrange(denominator)<numerator:entries.append((6,mould,amount));display.append((mould,6,amount))
                            _apply_scene_reward(db,account,entries)
                        updated[chest_floor]=bought+times
                    wallet=db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?',(account,)).fetchone()
                    if not wallet or int(wallet[0])<total_cost:raise ValueError('gold_insuficiente_para_baus_trial')
                    db._conn.execute('UPDATE local_resources SET gold=gold-? WHERE conta_id=?',(total_cost,account))
                    s['vip_reward_info']='|'.join('%s:%s'%(floor,updated[floor]) for floor in sorted(updated))
                    _save(db,account,s)
                    reward_tokens=['171','37',str(len(display))]
                    for reward in display:reward_tokens.extend(map(str,reward))
                    reply=' '.join([str(seq),cmd,'0']+inventory_tokens(db,account)+shop_local.balances(db,account,-total_cost)+_tokens(db,account,s,seq,cmd).split(' ',2)[2:]+reward_tokens)
                    db._conn.execute('INSERT INTO local_ninja_trial_receipts(conta_id,signature,reply) VALUES (?,?,?)',(account,sig,reply))
                    return reply
                if mode==5:
                    import shop_local
                    level_row=db._conn.execute('SELECT grade FROM local_campaign WHERE conta_id=?',(account,)).fetchone()
                    if (int(level_row[0]) if level_row else 1)<int(_cfg(57)): raise ValueError('nivel_insuficiente_para_varredura_trial')
                    _buffs,_boxes,jump=_sweep_layout(db,account)
                    if jump<=0: raise ValueError('vip_sem_pisos_de_varredura_configurados')
                    s['vip_sweep']=1; s['vip_day']=shop_local.day(); _save(db,account,s)
                    return _tokens(db,account,s,seq,cmd)
                if mode in (2,4):
                    raise ValueError('acao_varredura_nao_disponivel_sem_estado_original')
                raise ValueError('modo_varredura_trial_invalido')
        except (server._contas.ErroConta,ValueError,IndexError,TypeError) as exc:
            return server.recusa(cmd,seq,str(exc) or 'varredura_trial_indisponivel')

    server.MINIMOS['three_kingdoms_init'] = initialize
    server.MINIMOS['three_kingdoms_launch'] = launch
    server.MINIMOS['three_kingdoms_draw_score_reward'] = draw_score
    server.MINIMOS['three_kingdoms_sweep'] = sweep
    server.MINIMOS['dignified_shop_buy'] = dignified_buy
    server.MINIMOS['unparallel_purchase'] = unparallel_buy


def _apply_scene_reward(db, account, entries):
    import shop_local
    db._conn.execute('INSERT OR IGNORE INTO local_campaign(conta_id,grade,silver) VALUES (?,1,0)', (account,))
    db._conn.execute('INSERT OR IGNORE INTO local_resources(conta_id) VALUES (?)', (account,))
    for kind, ident, amount in entries:
        if kind == 1: db._conn.execute('UPDATE local_campaign SET silver=silver+? WHERE conta_id=?',(amount,account))
        elif kind == 2: db._conn.execute('UPDATE local_resources SET gold=gold+? WHERE conta_id=?',(amount,account))
        elif kind == 3: db._conn.execute('UPDATE local_resources SET honour=honour+? WHERE conta_id=?',(amount,account))
        elif kind == 4: db._conn.execute('UPDATE local_resources SET soul=soul+? WHERE conta_id=?',(amount,account))
        elif kind == 5: db._conn.execute('UPDATE local_resources SET jade=jade+? WHERE conta_id=?',(amount,account))
        elif kind == 6: shop_local.grant(db,account,6,ident,amount)
        else: raise ValueError('tipo_recompensa_bau_trial_nao_suportado')
