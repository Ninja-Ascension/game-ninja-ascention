"""Local Ninja School account state. Unknown operations are never acknowledged as rewards.

Implemented operations (all validated, atomic and protected against repeats):
- talents: init, level up, reset with refund;
- digital spirit: init per ninja, gift one item, gift all, batch gift.
Combat effects of talents and spirit are returned by combat_bonus() and folded
into the authoritative hero attributes by hero_stats_local.
"""
import json
import re
from pathlib import Path
from functools import lru_cache
import dados_batalha as data

INIT_COMMANDS = ('ship_talent_init', 'artifact_init', 'combine_ship_init',
                 'user_card_info_init', 'biographies_init', 'magical_animals_init')
OPERATIONS = ('ship_talent_level_up', 'ship_talent_reset', 'ship_spirit_level_up',
              'ship_spirit_batch_level_up')
COMMANDS = INIT_COMMANDS + ('ship_spirit_init',) + OPERATIONS

# Value printed in the original cultivate_talent_reset.csb next to the diamond
# icon (Text_title_0 = "500"); the client never sends or checks it.
TALENT_RESET_GOLD = 500
FRONT_ROW, BACK_ROW = (1, 2, 3), (4, 5, 6)
# ship_talent_param.effective_condition -> ship_mould.camp_preference.
# Icons sm_type_bar_1/2/3 are sword (ATK), shield (DEF) and scroll (Skill);
# talent descriptions name condition 3/4/5 as Ninja(ATK)/(Skill)/(DEF).
CLASS_CONDITION = {3: 1, 4: 3, 5: 2}
# Conditions 9..13 only apply inside Arena, Ninja King, Clan Battle and the
# cross-server modes. Those battles are not part of this local port, so they are
# kept in the talent state but never added to campaign/home attributes.
MODE_CONDITIONS = range(9, 14)


def schema(db):
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_ninja_school(conta_id INTEGER PRIMARY KEY,state TEXT NOT NULL)')
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_ninja_school_receipts(conta_id INTEGER,request_id TEXT,signature TEXT,reply TEXT,PRIMARY KEY(conta_id,request_id))')


def state(db, account):
    row = db._conn.execute('SELECT state FROM local_ninja_school WHERE conta_id=?', (account,)).fetchone()
    # Test account policy, one allocation persisted on first initialization.
    value = json.loads(row[0]) if row else {'talents': {}, 'talentPoints': 10000}
    value.setdefault('spirits', {})
    return value


def save(db, account, value):
    db._conn.execute('INSERT INTO local_ninja_school VALUES (?,?) ON CONFLICT(conta_id) DO UPDATE SET state=excluded.state', (account, json.dumps(value)))


# ---------------------------------------------------------------- talents --

def page_of(ident):
    return 1 if ident < 8 else 2 if ident < 18 else 3 if ident < 28 else 4


@lru_cache(maxsize=None)
def talent_row(ident, level):
    return next((v for v in data.tabela('ship_talent_param.txt').values()
                 if v[1] == str(ident) and int(v[2]) == level), None)


def level_costs(ident, level):
    """Silver and talent points paid to reach `level` of talent `ident`."""
    silver = points = 0
    for cost in talent_row(ident, level)[3].split('|'):
        kind, _, amount = map(int, cost.split(','))
        if kind == 1: silver += amount
        elif kind == 34: points += amount
        else: raise ValueError('custo_de_talento_desconhecido')
    return silver, points


def used_points(talents):
    points = [0]*4
    for ident, level in talents.items():
        for target in range(1, int(level)+1):
            points[page_of(int(ident))-1] += level_costs(int(ident), target)[1]
    return points


def talent_refund(talents):
    silver = points = 0
    for ident, level in talents.items():
        for target in range(1, int(level)+1):
            s, p = level_costs(int(ident), target)
            silver += s; points += p
    return silver, points


# ----------------------------------------------------------------- spirit --

@lru_cache(maxsize=None)
def spirit_levels():
    """stall -> {level: exp needed for the next level} from ship_spirit_param."""
    result = {}
    for row in data.tabela('ship_spirit_param.txt').values():
        result.setdefault(int(row[3]), {})[int(row[1])] = int(row[2])
    return result


@lru_cache(maxsize=None)
def spirit_attributes():
    return {(int(r[1]), int(r[2]), int(r[3])): r for r in data.tabela('ship_spirit_mould.txt').values()}


@lru_cache(maxsize=None)
def spirit_cap():
    path = Path(data.MOULD).parent / 'configs' / 'ship_config.txt'
    for line in path.read_text(encoding='utf-8').splitlines():
        row = line.rstrip('\n').split('\t')
        if row[0] == '48': return int(row[3])
    raise ValueError('limite_de_espirito_ausente')


def spirit_slot(mould):
    """(group, index, attribute group) of the spirit team that lists this mould."""
    base = data.tabela('ship_mould.txt')[str(mould)][52]
    for group, row in data.tabela('ship_spirit_group.txt').items():
        needed = row[3].split(',')
        for index, ident in enumerate(needed):
            if ident == str(mould) or (ident in data.tabela('ship_mould.txt') and data.tabela('ship_mould.txt')[ident][52] == base and int(ident) > 0):
                return int(group), index, int(row[5].split(',')[index])
    return None


def spirit_state(s, ship):
    level, favor, stall = s['spirits'].get(str(ship), (1, 0, 1))
    return int(level), int(favor), int(stall)


def add_favor(level, favor, stall, amount):
    """Apply gift experience following ship_spirit_param and the client rule:
    the last level of a stall leads to level 1 of the next stall."""
    favor += amount
    levels = spirit_levels()
    while True:
        need = levels[stall][level]
        last = level >= len(levels[stall])
        if last and stall + 1 not in levels:
            return level, min(favor, need), stall
        # ship_config 48 is compared with the level inside the stall
        # (SmCultivateSpiritAdd.lua: level >= limit -> "max level").
        if level >= spirit_cap():
            return level, min(favor, need), stall
        if favor < need:
            return level, favor, stall
        favor -= need
        level, stall = (1, stall + 1) if last else (level + 1, stall)


def spirit_token(ship, s):
    level, favor, stall = spirit_state(s, ship)
    return str(ship)+':'+str(level)+','+str(favor)+','+str(stall)


def owned_ships(db, account):
    import recruitment_local as heroes
    return heroes.all_owned(db, account)


# ----------------------------------------------------------- combat effect --

def combat_bonus(db, account, ship, mould):
    """Talent and spirit effects for one ninja.

    Returns flat additions to [HP, ATK, DEF, MDEF], percent additions to the
    same panel stats, extra battle properties (property_values) and speed.
    Percent panel bonuses (types 4/5) are folded into the panel because the
    battle formula uses courage/power percentages as fractions, while the
    tables store them as whole percentages (\"+2%\" is 2)."""
    import recruitment_local as heroes
    s = state(db, account)
    flat = [0.0]*4; percent = [0.0]*4; properties = {}; speed = 0.0
    with db._lock:
        slots = heroes._slots_locked(db, account)
    position = slots.index(str(ship))+1 if str(ship) in slots else 0
    camp = int(data.tabela('ship_mould.txt')[str(mould)][2])

    def add(kind, amount):
        if amount == 0: return
        if 0 <= kind <= 3: flat[kind] += amount
        elif kind in (4, 5): percent[kind-4] += amount
        else: properties[kind] = properties.get(kind, 0) + amount

    for ident, level in s['talents'].items():
        if int(level) <= 0: continue
        row = talent_row(int(ident), int(level))
        for pair, condition in zip(row[4].split('|'), row[5].split('|')):
            kind, amount = pair.split(','); condition = int(condition)
            applies = (condition == 0 or (condition == 1 and position in FRONT_ROW)
                       or (condition == 2 and position in BACK_ROW)
                       or CLASS_CONDITION.get(condition) == camp)
            if applies and condition not in MODE_CONDITIONS:
                add(int(kind), float(amount))
    slot = spirit_slot(mould)
    if slot:
        level, _, stall = spirit_state(s, ship)
        row = spirit_attributes().get((slot[2], stall, level))
        if row:
            for pair in row[4].split('|'):
                kind, amount = pair.split(',')
                add(int(kind), float(amount))
            speed += float(row[5])
    # Ninja School > Index: card levels and score tiers apply to every ninja.
    import index_local, mudra_local
    for kind, amount in index_local.bonus(db, account):
        add(kind, amount)
    # Mudra: pieces equipped on this ninja and its active matrices.
    for kind, amount in mudra_local.bonus(db, account, ship, mould):
        add(kind, amount)
    # Shamanism (artifacts): every practiced attribute boosts every ninja.
    import artifact_local
    for kind, amount in artifact_local.bonus(db, account):
        add(kind, amount)
    # Sculpture Mountain: blessings in use on this ninja's slots.
    import constellation_local
    for kind, amount in constellation_local.bonus(db, account, mould):
        add(kind, amount)
    # Ninja Saga: activated biographies, their stars and saga achievements.
    import saga_local
    for kind, amount in saga_local.bonus(db, account):
        add(kind, amount)
    # Aid Team (Soul Guard): every unlocked guard boosts every ninja.
    import soul_guard_local
    for kind, amount in soul_guard_local.bonus(db, account):
        add(kind, amount)
    # Tailed Beasts: stars, forge stones and links boost every ninja.
    import mythical_local
    for kind, amount in mythical_local.bonus(db, account):
        add(kind, amount)
    # Potential ("Superar+"): per-ninja levels.
    import potential_local
    for kind, amount in potential_local.bonus(db, account, ship):
        add(kind, amount)
    return flat, percent, properties, speed


# --------------------------------------------------------------- snapshot --

def snapshot(db, account):
    s = state(db, account)
    talents = '|'.join(str(k)+':'+str(s['talents'].get(k, 0))+',0' for k in data.tabela('ship_talent_mould.txt'))
    artifacts = {k: {'id': int(k), 'state': 1 if r[3]=='-1' else 0} for k,r in data.tabela('artifact_mould.txt').items()}
    attributes = {k: [{'key': int(pair.split(',')[0]), 'value': 0} for pair in r[7].split('|')] for k,r in data.tabela('artifact_mould.txt').items()}
    ships = owned_ships(db, account)
    info = dict(user_artifact_info=artifacts, user_artifact_attributes=attributes,
                user_artifact_culture_info=[], user_artifact_achieve_all_sorce='0',
                user_artifact_achieve_info=[], digital_spirit_state_info={},
                constellation_info={'hba': {}, 'uc': {}, 'ctv': 0},
                user_alloy_matrix={}, user_alloy_matrix_num='0', maxtrix_essence_num=0,
                alloy_matrix_recruit={'goldFreeNum': '0', 'diamonFreeNum': '0', 'use_num': '0,0,0'},
                silkbag_pack_info=[],
                combine_card_list_info={'comb_mould_list': []}, one_card_solt_infos={},
                user_comb_can_filed_mould_num=1, user_comb_has_field_mould_info=[],
                illustration_info_init=__import__('index_local').info(db, account),
                illustration_comb_card_info={}, all_biographies_info=[],
                biographies_achieve_info={}, biographies_chapter_info=[],
                biographies_draw_info={'normalDrawFreeNumber': 0, 'advanceDrawFreeNumber': 0},
                biographies_rank_info={'allRankInfo': [], 'myRankNumber': -1},
                biographies_draw_rewards_info={'normal': '', 'advance': ''},
                all_mythical_animals_info={}, mythical_animals_skill_info={},
                mythical_animals_fate_info={}, mythical_animals_fate_task_info={},
                # Authoritative per-ninja spirit text, applied to user_ship.shipSpirit.
                local_ship_spirit={str(ship): spirit_token(ship, s) for ship, _ in ships})
    # These are empty *owned* collections; original mould tables supply the catalogue.
    # Never synthesize owned heroes/items or mark an unimplemented purchase successful.
    guard = __import__('soul_guard_local').info(db, account)
    if guard:  # only when a slot is unlocked: the window indexes slot 1 directly
        info['soul_warding_formation_hero'] = guard
    tokens = ['15997', json.dumps(info, separators=(',', ':')), '6043', '5', str(s['talentPoints']), '12559', talents]
    # parse_digital_spirit_state_info splits the whole payload, not each entry,
    # so every ninja is sent in its own 12560 block.
    for ship, mould in ships:
        if spirit_slot(mould): tokens += ['12560', spirit_token(ship, s)]
    # Mudra pieces, essence and recruit counters (original 14111/12047/14113).
    import mudra_local
    with db._lock:
        tokens += mudra_local.init_tokens(db, account)
        # Shamanism: real lock states and practiced attributes (12563).
        tokens += __import__('artifact_local').info_tokens(db, account)
        # Sculpture Mountain: bought/used blessings (12566).
        tokens += __import__('constellation_local').init_tokens(db, account)
        # Ninja Saga: biographies, achievements, chapters, draws (12668-12674).
        tokens += __import__('saga_local').init_tokens(db, account)
        # Tailed Beasts (12675/12677/12678/12679).
        tokens += __import__('mythical_local').init_tokens(db, account)
        # Achievements: Ninja School tab (12565) and general progress (3501).
        tokens += __import__('achievements_local').init_tokens(db, account)
    tokens += __import__('fight_spirit_local').tokens(db, account)
    return tokens


def full_tokens(db, account):
    import hero_stats_local
    return snapshot(db, account) + hero_stats_local.attribute_tokens(db, account)


# ------------------------------------------------------------- operations --

def talent_level_up(db, account, s, fields):
    if len(fields) not in (3, 4): raise ValueError('pedido_de_talento_invalido')
    ident = int(fields[1]); amount = int(fields[2]) if len(fields)==4 else 1
    if not 1 <= amount <= 100: raise ValueError('quantidade_de_talento_invalida')
    r = data.tabela('ship_talent_mould.txt')[str(ident)]
    grade, balance = db._conn.execute('SELECT grade,silver FROM local_campaign WHERE conta_id=?', (account,)).fetchone()
    page = page_of(ident); used = used_points(s['talents'])
    for condition in data.tabela('ship_talent_group.txt')[str(page)][4].split('|'):
        c = list(map(int, condition.split(',')))
        if (c[0]==1 and grade<c[1]) or (c[0]==2 and used[c[1]-1]<c[2]):
            raise ValueError('pagina_de_talento_bloqueada')
    for condition in r[5].split('|'):
        c = list(map(int, condition.split(',')))
        if c[0]==1 and grade<c[1]: raise ValueError('nivel_insuficiente')
        if c[0]==4 and s['talents'].get(str(c[1]),0)<c[2]: raise ValueError('talento_anterior_insuficiente')
    level = s['talents'].get(str(ident),0)
    if level+amount>int(r[3]): raise ValueError('talento_no_nivel_maximo')
    silver = points = 0
    for target in range(level+1,level+amount+1):
        a, b = level_costs(ident, target); silver += a; points += b
    if balance<silver or s['talentPoints']<points: raise ValueError('recursos_de_talento_insuficientes')
    s['talents'][str(ident)]=level+amount; s['talentPoints']-=points
    db._conn.execute('UPDATE local_campaign SET silver=silver-? WHERE conta_id=?',(silver,account))
    return ['22', str(balance-silver)]


def talent_reset(db, account, s, fields):
    if len(fields) != 2: raise ValueError('pedido_de_redefinicao_invalido')
    silver, points = talent_refund(s['talents'])
    if points <= 0 and silver <= 0: raise ValueError('nenhum_talento_para_redefinir')
    gold = db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?', (account,)).fetchone()
    if not gold or gold[0] < TALENT_RESET_GOLD: raise ValueError('diamantes_insuficientes')
    balance = db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?', (account,)).fetchone()[0]
    db._conn.execute('UPDATE local_resources SET gold=gold-? WHERE conta_id=?', (TALENT_RESET_GOLD, account))
    db._conn.execute('UPDATE local_campaign SET silver=silver+? WHERE conta_id=?', (silver, account))
    s['talents'] = {}; s['talentPoints'] += points
    rewards = [(-1, kind, n) for kind, n in ((1, silver), (34, points)) if n > 0]
    tokens = ['25', str(-TALENT_RESET_GOLD), str(gold[0]-TALENT_RESET_GOLD), '22', str(balance+silver),
              '171', '7', str(len(rewards))]
    for reward in rewards: tokens += list(map(str, reward))
    return tokens


def spirit_gift(db, account, s, fields, cmd):
    if len(fields) != 5: raise ValueError('pedido_de_espirito_invalido')
    group, ship = int(fields[1]), int(fields[2])
    entry = next((e for e in owned_ships(db, account) if e[0] == ship), None)
    if not entry: raise ValueError('ninja_nao_possuido')
    slot = spirit_slot(entry[1])
    if not slot or slot[0] != group: raise ValueError('ninja_fora_do_grupo_de_espirito')
    props = [tuple(map(int, p.split(','))) for p in data.tabela('ship_spirit_group.txt')[str(group)][4].split('|')]
    if any(p[0] != 6 for p in props): raise ValueError('presente_de_espirito_nao_suportado')
    owned = {}
    for _, prop, _, _ in props:
        row = db._conn.execute('SELECT quantity FROM local_inventory WHERE conta_id=? AND mould=?', (account, prop)).fetchone()
        owned[prop] = row[0] if row else 0
    if cmd == 'ship_spirit_batch_level_up':
        counts = [int(x) for x in fields[3].split(',')]
        if len(counts) != len(props) or any(n < 0 for n in counts): raise ValueError('quantidades_invalidas')
    else:
        choice = int(fields[3])
        if choice == -1: counts = [owned[p[1]] for p in props]
        elif 0 <= choice < len(props): counts = [1 if i == choice else 0 for i in range(len(props))]
        else: raise ValueError('presente_invalido')
    if sum(counts) <= 0: raise ValueError('presente_ausente')
    level, favor, stall = spirit_state(s, ship)
    if level >= spirit_cap() or (level >= len(spirit_levels()[stall]) and stall+1 not in spirit_levels()):
        raise ValueError('espirito_no_nivel_maximo')
    gained = 0
    for (_, prop, per_use, exp), n in zip(props, counts):
        if owned[prop] < n * per_use: raise ValueError('presentes_insuficientes')
        gained += n * exp
    for (_, prop, per_use, _), n in zip(props, counts):
        if n: db._conn.execute('UPDATE local_inventory SET quantity=quantity-? WHERE conta_id=? AND mould=?', (n*per_use, account, prop))
    s['spirits'][str(ship)] = list(add_favor(level, favor, stall, gained))
    # Gifts sent, for the Team Spirit achievement (achievement type 30).
    s['spiritGifts'] = int(s.get('spiritGifts', 0)) + sum(n * p[2] for p, n in zip(props, counts))
    import hero_training_local
    return hero_training_local.inventory_tokens(db, account)


def execute(server, cmd, seq, text):
    db = server.BANCO
    try:
        account = db.sessao_de(server._sessao_da_conexao())['conta_id']
        fields = server._linhas(text)
        if not fields or fields[0] != str(db.perfil(account)['user_id']):
            raise ValueError('conta_da_escola_invalida')
        with db._lock, db._conn:
            s = state(db, account)
            if cmd in INIT_COMMANDS:
                save(db, account, s)
                return ' '.join([str(seq), cmd, '0'] + snapshot(db, account))
            if cmd == 'ship_spirit_init':
                ship = int(fields[1])
                entry = next((e for e in owned_ships(db, account) if e[0] == ship), None)
                if not entry or not spirit_slot(entry[1]): raise ValueError('ninja_sem_espirito')
                return ' '.join([str(seq), cmd, '0', '12560', spirit_token(ship, s)])
            if not re.fullmatch(r'[0-9A-Za-z:-]{1,100}', fields[-1]):
                raise ValueError('identificador_de_pedido_invalido')
            key = fields[-1]; signature = cmd+'|'+'|'.join(fields[1:-1])
            receipt = db._conn.execute('SELECT signature,reply FROM local_ninja_school_receipts WHERE conta_id=? AND request_id=?', (account,key)).fetchone()
            if receipt:
                if receipt[0] != signature: raise ValueError('identificador_reutilizado')
                return str(seq)+' '+receipt[1].split(' ',1)[1]
            if cmd == 'ship_talent_level_up': result = talent_level_up(db, account, s, fields)
            elif cmd == 'ship_talent_reset': result = talent_reset(db, account, s, fields)
            else: result = spirit_gift(db, account, s, fields, cmd)
            save(db, account, s)
            reply = ' '.join([str(seq), cmd, '0'] + result + full_tokens(db, account))
            db._conn.execute('INSERT INTO local_ninja_school_receipts VALUES (?,?,?,?)',(account,key,signature,reply))
            server.log('NINJA_SCHOOL cmd=%s conta=%s pedido=%s' % (cmd, account, '|'.join(fields[1:-1])))
            return reply
    except (server._contas.ErroConta, ValueError, KeyError, IndexError, StopIteration, TypeError) as exc:
        return server.recusa(cmd,seq,str(exc) or 'configuracao_da_escola_indisponivel')


def install(server):
    with server.BANCO._lock,server.BANCO._conn: schema(server.BANCO)
    for command in COMMANDS:
        server.MINIMOS[command]=lambda seq,text,cmd=command:execute(server,cmd,seq,text)
