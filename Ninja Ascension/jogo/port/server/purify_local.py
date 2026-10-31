"""White Zetsu Army (Digital Purify) server flow based on the APK protocol.

The APK performs scene-53 combat locally. This module persists the roster,
team membership, daily attempts and the confirmation sent after a victory.
It deliberately does not invent the unavailable server-side matchmaking or
the paid chest contents.
"""
import json
from pathlib import Path
import secrets
import time

import dados_batalha as data


def _schema(db):
    db._conn.executescript('''
      CREATE TABLE IF NOT EXISTS local_purify_rosters(
        conta_id INTEGER PRIMARY KEY REFERENCES contas(id) ON DELETE CASCADE,
        roster TEXT NOT NULL, updated INTEGER NOT NULL);
      CREATE TABLE IF NOT EXISTS local_purify_teams(
        team_key TEXT PRIMARY KEY, team_type INTEGER NOT NULL,
        captain INTEGER NOT NULL, join_state INTEGER NOT NULL DEFAULT 0,
        param_id INTEGER NOT NULL DEFAULT 0,
        updated INTEGER NOT NULL);
      CREATE INDEX IF NOT EXISTS idx_local_purify_open
        ON local_purify_teams(team_type,join_state,updated);
      CREATE TABLE IF NOT EXISTS local_purify_members(
        team_key TEXT NOT NULL REFERENCES local_purify_teams(team_key) ON DELETE CASCADE,
        position INTEGER NOT NULL CHECK(position BETWEEN 1 AND 5),
        conta_id INTEGER NOT NULL REFERENCES contas(id) ON DELETE CASCADE,
        mould INTEGER NOT NULL, formation TEXT NOT NULL,
        reset_day TEXT NOT NULL, complete_count INTEGER NOT NULL DEFAULT 0,
        pending INTEGER NOT NULL DEFAULT 0,
        PRIMARY KEY(team_key,position), UNIQUE(team_key,conta_id));
      CREATE TABLE IF NOT EXISTS local_purify_daily(
        conta_id INTEGER PRIMARY KEY REFERENCES contas(id) ON DELETE CASCADE,
        reset_day TEXT NOT NULL, complete_count INTEGER NOT NULL DEFAULT 0,
        pending INTEGER NOT NULL DEFAULT 0);
      CREATE TABLE IF NOT EXISTS local_purify_chest_receipts(
        conta_id INTEGER NOT NULL REFERENCES contas(id) ON DELETE CASCADE,
        team_key TEXT NOT NULL, battle_id TEXT NOT NULL,
        reply TEXT NOT NULL, PRIMARY KEY(conta_id,team_key,battle_id));
    ''')


def _candidates():
    """Group original purification records by visible character mould."""
    ships = data.tabela('ship_mould.txt')
    result = {}
    for key, row in data.tabela('digital_purify_param.txt').items():
        try:
            if len(row) < 7:
                continue
            # The original table's third column separates the candidate tiers.
            # Tier 6 is the high-rank Kage pool (Minato, Madara, etc.); the
            # requested A-rank rotation uses only original tiers 0 through 5.
            tier = int(row[2])
            if tier < 0 or tier > 5:
                continue
            mould = int(row[3])
            if str(mould) not in ships or not row[4]:
                continue
            # `ship_type` is column 36 in the original ship_mould schema
            # (LocalDatas.lua); index 11 is wisdom, not character rank.
            if len(ships[str(mould)]) <= 35 or int(ships[str(mould)][35]) != 0:
                continue
            npcs = [int(v) for v in row[4].split(',') if v.strip()]
            if len(npcs) not in (3, 4) or any(v <= 0 for v in npcs):
                continue
            result.setdefault(mould, []).append({
                'param_id': int(key), 'npcs': npcs,
            })
        except (IndexError, TypeError, ValueError):
            continue
    # Several rows represent the same clone at different parameter tiers.
    # The APK has no rule mapping player power to those tiers, so keep the
    # first original row as the deterministic baseline rather than guessing.
    return {mould: [min(rows, key=lambda item: item['param_id'])]
            for mould, rows in result.items()}


def _play_config(row_id):
    path = Path(data.MOULD).parent / 'configs' / 'play_config.txt'
    for line in path.read_text(encoding='utf-8').splitlines():
        row = line.split('\t')
        if row and row[0] == str(row_id):
            return row[-1]
    raise ValueError('config_play_config_%s_ausente' % row_id)


def _daily_key(timestamp=None):
    # Use the original reset hour (play_config 22) in server-local time.
    hour, minute, second = map(int, _play_config(22).split(':'))
    offset = hour * 3600 + minute * 60 + second
    moment = time.time() if timestamp is None else float(timestamp)
    return time.strftime('%Y-%m-%d', time.localtime(moment - offset))


def _daily_limit():
    # play_config 20: total clones per day, attempts per player.
    values = list(map(int, _play_config(20).split(',')))
    if len(values) < 2 or values[1] < 1:
        raise ValueError('limite_diario_zetsu_invalido')
    return values[1]


def _roster(db, account, candidates):
    row = db._conn.execute('SELECT roster,updated FROM local_purify_rosters WHERE conta_id=?',
                           (account,)).fetchone()
    if row:
        try:
            values = json.loads(row[0])
            current_day = _daily_key()
            roster_day = _daily_key(row[1])
            if (roster_day == current_day and len(values) == 6 and
                    len({int(v['mould']) for v in values}) == 6 and
                    all(int(v['mould']) in candidates and
                        any(int(c['param_id']) == int(v['param_id']) for c in candidates[int(v['mould'])])
                        for v in values)):
                return values
        except (TypeError, ValueError, json.JSONDecodeError):
            pass
    if len(candidates) < 6:
        raise ValueError('lista_original_de_ninjas_indisponivel')
    rng = secrets.SystemRandom()
    moulds = rng.sample(sorted(candidates), 6)
    values = [dict(mould=mould, **rng.choice(candidates[mould])) for mould in moulds]
    db._conn.execute('''INSERT INTO local_purify_rosters VALUES (?,?,?)
      ON CONFLICT(conta_id) DO UPDATE SET roster=excluded.roster,updated=excluded.updated''',
      (account, json.dumps(values), int(time.time())))
    return values


def _owned(db, account):
    import recruitment_local
    return dict(recruitment_local.all_owned(db, account))


def _hero_info(db, account, mould, selected_ship=None):
    """Build the original 11-field card descriptor from this account's data."""
    import hero_power_local, hero_quality_local, hero_level_local
    import hero_development_local, hero_stats_local, recruitment_local
    owned = [(ship, mid) for ship, mid in recruitment_local.all_owned(db, account)
             if int(mid) == int(mould)]
    if not owned:
        raise ValueError('personagem_zetsu_nao_pertence_a_conta')
    selected = next((pair for pair in owned
                     if selected_ship is not None and int(pair[0]) == int(selected_ship)), None)
    ship, _ = selected or max(owned, key=lambda pair: hero_power_local.character(db, account, *pair))
    level = hero_level_local.state(db, account, ship, mould)[0]
    quality = hero_quality_local.quality(db, account, ship, mould)
    dev = hero_development_local.state(db, account, ship, mould)
    # Preserve any saved seal progress, but guarantee the one-entry-per-faction
    # shape consumed by FightObject for every unlocked soul slot.
    soul_count = len(data.tabela('ship_mould.txt')[str(mould)][74].split(','))
    souls = list(dev.get('souls', []))[:soul_count]
    souls.extend([[1, 0] for _ in range(soul_count - len(souls))])
    fighting_spirit = hero_development_local.soul_text(dict(dev, souls=souls))
    stats = hero_stats_local.effective(db, account, ship, mould)
    rank = int(dev.get('star', 0))
    star_rating = max(0, rank)
    power = hero_power_local.character(db, account, ship, mould)
    skin = 0
    return {
        'ship': ship, 'mould': int(mould), 'level': int(level),
        # Advancement quality is not the evolution-status string consumed by
        # PurifyTeamWindow:fight(); a fresh mould starts at its first form.
        'evolution': '1', 'star': star_rating,
        'order': int(quality), 'power': int(power), 'speed': int(stats['speed']),
        # FightObject:initWithUserData parses one ``level,exp`` pair per
        # ship_soul_mould faction. A scalar "0" makes the battle crash when
        # it reaches the second unlocked seal.
        'spirit': fighting_spirit,
        'skill': 1, 'skin': skin,
        'attributes': [int(round(stats['health'])), int(round(stats['courage'])),
                       int(round(stats['intellect'])), 0, 0, 0, 0, 0, 0, 0, 0,
                       stats.get('property_values', '0:0')],
    }


def _formation_from_hero(hero, saved=None):
    # The client reads the second @-section as the representative hero and
    # the third as a seven-position formation map.
    descriptor = ':'.join(str(v) for v in (
        hero['mould'], hero['level'], hero['evolution'], hero['star'],
        hero['order'], hero['power'], hero['ship'], hero['speed'],
        hero['spirit'], hero['skill'], hero['skin']))
    layout = '-1,1,2,3,4,5,6'
    if saved and '@' in saved:
        layout = saved.rsplit('@', 1)[1]
    return '@'.join((descriptor, descriptor, layout))


def _formation(db, account, mould, selected_ship=None):
    return _formation_from_hero(_hero_info(db, account, mould, selected_ship))


def _formation_ship_id(saved):
    """Read the selected owned hero id from the original descriptor section."""
    try:
        fields = str(saved).split('@')[1].split(':')
        ship_id = int(fields[6])
        return ship_id if ship_id > 0 else None
    except (IndexError, TypeError, ValueError):
        return None


def _team(db, account):
    return db._conn.execute('''SELECT t.team_key,t.team_type,t.captain,t.join_state,
      m.position,m.mould,m.formation,m.reset_day,m.complete_count,m.pending
      ,t.param_id
      FROM local_purify_members m JOIN local_purify_teams t USING(team_key)
      WHERE m.conta_id=?''', (account,)).fetchone()


def _cleanup_daily(db, team_key):
    members = db._conn.execute('SELECT conta_id FROM local_purify_members WHERE team_key=?',
                               (team_key,)).fetchall()
    for (account,) in members:
        _daily_state(db, account)


def _daily_state(db, account):
    day = _daily_key()
    db._conn.execute('INSERT OR IGNORE INTO local_purify_daily(conta_id,reset_day) VALUES (?,?)',
                     (account, day))
    db._conn.execute('''UPDATE local_purify_daily SET reset_day=?,complete_count=0,pending=0
      WHERE conta_id=? AND reset_day<>?''', (day, account, day))
    return db._conn.execute('SELECT complete_count,pending FROM local_purify_daily WHERE conta_id=?',
                            (account,)).fetchone()


def _team_tokens(db, account, own_key=None):
    row = _team(db, account)
    if not row:
        return ['12557', '0', '-1', '0', '0', '5'] + ['-1'] * 5
    key, team_type, captain, join_state, *_ = row
    if own_key and own_key != key:
        raise ValueError('equipe_nao_encontrada')
    _cleanup_daily(db, key)
    members = db._conn.execute('''SELECT m.position,m.conta_id,m.mould,m.formation,
      p.user_id,p.user_name
      FROM local_purify_members m JOIN perfis p ON p.conta_id=m.conta_id
      WHERE m.team_key=? ORDER BY m.position''', (key,)).fetchall()
    by_pos = {int(m[0]): m for m in members}
    tokens = ['12557', str(key), str(team_type), str(row[10]), str(join_state), '5']
    for position in range(1, 6):
        member = by_pos.get(position)
        if not member:
            tokens.append('-1')
            continue
        _, member_account, mould, formation, user_id, username = member
        count = _daily_state(db, member_account)[0]
        hero = _hero_info(db, member_account, mould, _formation_ship_id(formation))
        # Stored team rows may predate current hero metadata (for example, a
        # scalar spirit placeholder). Rebuild both original 11-field hero
        # descriptors from live state, while preserving the saved seat map.
        formation_info = _formation_from_hero(hero, formation)
        is_captain = int(member_account) == int(captain)
        tokens += [str(user_id), '1' if is_captain else '0', str(position),
                   str(username), '0', '1', '0', '0', formation_info, '0', str(count),
                   ','.join(map(str, hero['attributes']))]
    return tokens


def _success(seq, command, parsers):
    return ' '.join([str(seq), command, '0'] + parsers)


def install(server):
    db = server.BANCO
    _schema(db)
    candidates = _candidates()

    def initialize(seq, text):
        cmd = 'ship_purify_init'
        try:
            account = db.sessao_de(server._sessao_da_conexao())['conta_id']
            lines = [line for line in server._linhas(text) if line.strip()]
            if lines != [str(db.perfil(account)['user_id'])]:
                raise ValueError('perfil_invalido')
            with db._lock, db._conn:
                roster = _roster(db, account, candidates)
                roster_payload = '|'.join(
                    ','.join([str(i), str(candidate['mould'])] +
                             [str(npc) for npc in candidate['npcs']] +
                             (['-1'] if len(candidate['npcs']) == 3 else []))
                    for i, candidate in enumerate(roster))
                return _success(seq, cmd, ['12556', roster_payload] +
                                _team_tokens(db, account))
        except (server._contas.ErroConta, ValueError, IndexError, TypeError) as exc:
            return server.recusa(cmd, seq, str(exc) or 'purify_indisponivel')

    def team_manager(seq, text):
        cmd = 'ship_purify_team_manager'
        try:
            account = db.sessao_de(server._sessao_da_conexao())['conta_id']
            lines = [line for line in server._linhas(text) if line.strip()]
            if not lines or lines[0] != str(db.perfil(account)['user_id']) or len(lines) < 3:
                raise ValueError('pedido_de_equipe_zetsu_invalido')
            mode, team_type = int(lines[1]), int(lines[2])
            params = lines[3:]
            with db._lock, db._conn:
                current = _team(db, account)
                if mode == 0:  # create team with the selected owned Zetsu.
                    if current:
                        raise ValueError('ja_esta_em_uma_equipe_zetsu')
                    roster = _roster(db, account, candidates)
                    if not 0 <= team_type < 6:
                        raise ValueError('selecao_zetsu_invalida')
                    candidate = roster[team_type]
                    mould = int(candidate['mould'])
                    formation = _formation(db, account, mould)
                    team_key = str(int(time.time() * 1000) * 1000 + secrets.randbelow(1000))
                    db._conn.execute('''INSERT INTO local_purify_teams
                      (team_key,team_type,captain,join_state,param_id,updated)
                      VALUES (?,?,?,0,?,?)''',
                                     (team_key, team_type, account, candidate['param_id'], int(time.time())))
                    db._conn.execute('''INSERT INTO local_purify_members
                      (team_key,position,conta_id,mould,formation,reset_day)
                      VALUES (?,1,?,?,?,?)''',
                      (team_key, account, mould, formation, _daily_key()))
                elif mode == 1:  # join an existing public team of this choice.
                    if current:
                        raise ValueError('ja_esta_em_uma_equipe_zetsu')
                    if len(params) > 1:
                        raise ValueError('pedido_de_entrada_zetsu_invalido')
                    roster = _roster(db, account, candidates)
                    if not 0 <= team_type < 6:
                        raise ValueError('selecao_zetsu_invalida')
                    candidate = roster[team_type]
                    mould = int(candidate['mould'])
                    formation = _formation(db, account, mould)
                    if params:
                        target = db._conn.execute('''SELECT t.team_key FROM local_purify_teams t
                          WHERE t.team_key=? AND t.team_type=? AND t.join_state=0 AND
                            (SELECT COUNT(*) FROM local_purify_members m WHERE m.team_key=t.team_key)<5
                            AND NOT EXISTS (SELECT 1 FROM local_purify_members x
                              WHERE x.team_key=t.team_key AND x.conta_id=?)''',
                          (params[0], team_type, account)).fetchone()
                    else:
                        target = db._conn.execute('''SELECT t.team_key FROM local_purify_teams t
                          WHERE t.team_type=? AND t.join_state=0 AND
                            (SELECT COUNT(*) FROM local_purify_members m WHERE m.team_key=t.team_key)<5
                            AND NOT EXISTS (SELECT 1 FROM local_purify_members x
                              WHERE x.team_key=t.team_key AND x.conta_id=?)
                          ORDER BY t.updated,t.team_key LIMIT 1''', (team_type, account)).fetchone()
                    if not target:
                        raise ValueError('nenhuma_equipe_publica_zetsu_disponivel')
                    team_key = target[0]
                    _cleanup_daily(db, team_key)
                    position = db._conn.execute('''SELECT n FROM (
                      SELECT 1 n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5)
                      WHERE n NOT IN (SELECT position FROM local_purify_members WHERE team_key=?)
                      ORDER BY n LIMIT 1''', (team_key,)).fetchone()
                    db._conn.execute('''INSERT INTO local_purify_members
                      (team_key,position,conta_id,mould,formation,reset_day)
                      VALUES (?,?,?,?,?,?)''',
                      (team_key, position[0], account, mould, formation, _daily_key()))
                    db._conn.execute('UPDATE local_purify_teams SET updated=? WHERE team_key=?',
                                     (int(time.time()), team_key))
                elif mode == 2:  # exit team
                    if not current:
                        raise ValueError('nao_esta_em_uma_equipe_zetsu')
                    if _daily_state(db, account)[1]:
                        raise ValueError('resgate_o_premio_antes_de_sair_da_equipe')
                    team_key = current[0]
                    db._conn.execute('DELETE FROM local_purify_members WHERE team_key=? AND conta_id=?',
                                     (team_key, account))
                    remaining = db._conn.execute('SELECT conta_id,position FROM local_purify_members WHERE team_key=? ORDER BY position LIMIT 1',
                                                  (team_key,)).fetchone()
                    if not remaining:
                        db._conn.execute('DELETE FROM local_purify_teams WHERE team_key=?', (team_key,))
                    elif int(current[2]) == account:
                        db._conn.execute('UPDATE local_purify_teams SET captain=?,updated=? WHERE team_key=?',
                                         (remaining[0], int(time.time()), team_key))
                elif mode == 3:  # refresh exact team selected by the client
                    if not current:
                        raise ValueError('nao_esta_em_uma_equipe_zetsu')
                    team_key = str(params[0]) if params else current[0]
                    if str(team_key) != str(current[0]) or int(team_type) != int(current[1]):
                        raise ValueError('equipe_nao_encontrada')
                    _cleanup_daily(db, team_key)
                elif mode == 6:  # change personal fighter within same type
                    if (not current or int(current[1]) != team_type or
                            not 0 <= team_type < 6 or len(params) not in (1, 2)):
                        raise ValueError('troca_de_zetsu_invalida')
                    if len(params) == 2 and str(params[0]) != str(current[0]):
                        raise ValueError('equipe_nao_encontrada')
                    ship_id = int(params[-1])
                    owned = _owned(db, account)
                    if ship_id not in owned:
                        raise ValueError('personagem_nao_pertence_a_conta')
                    mould = int(owned[ship_id])
                    db._conn.execute('UPDATE local_purify_members SET mould=?,formation=? WHERE team_key=? AND conta_id=?',
                                     (mould, _formation(db, account, mould, ship_id), current[0], account))
                elif mode == 7:  # public/private team toggle
                    if (not current or int(current[1]) != team_type or
                            int(current[2]) != account or
                            (params and str(params[0]) != str(current[0]))):
                        raise ValueError('somente_lider_pode_alterar_equipe')
                    db._conn.execute('UPDATE local_purify_teams SET join_state=1-join_state,updated=? WHERE team_key=?',
                                     (int(time.time()), current[0]))
                elif mode == 8:  # captain may remove a member with no completed fights
                    if not current or int(current[2]) != account or len(params) < 2:
                        raise ValueError('acao_de_lideranca_zetsu_invalida')
                    target_key, target_uid = params[0], int(params[1])
                    if str(target_key) != str(current[0]):
                        raise ValueError('equipe_nao_encontrada')
                    target = db._conn.execute('''SELECT m.conta_id,m.complete_count FROM
                      local_purify_members m JOIN perfis p USING(conta_id)
                      WHERE m.team_key=? AND p.user_id=?''', (current[0], target_uid)).fetchone()
                    if not target or target[0] == account or target[1] > 0:
                        raise ValueError('membro_nao_pode_ser_removido')
                    db._conn.execute('DELETE FROM local_purify_members WHERE team_key=? AND conta_id=?',
                                     (current[0], target[0]))
                elif mode == 9:  # original client sends formation slots, 0-based.
                    if (not current or int(current[1]) != team_type or len(params) != 2 or
                            str(params[0]) != str(current[0])):
                        raise ValueError('formacao_zetsu_invalida')
                    mould = int(current[5])
                    selected_ship = _formation_ship_id(current[6])
                    if not _owned(db, account).get(mould):
                        raise ValueError('personagem_zetsu_nao_pertence_a_conta')
                    # FormationChange only permutes six slots and leader -1;
                    # validate shape, then preserve the standard local map.
                    slots = params[1].split(',')
                    if len(slots) != 7 or slots[0] != '-1' or sorted(slots[1:]) != ['1','2','3','4','5','6']:
                        raise ValueError('formacao_zetsu_invalida')
                    db._conn.execute('UPDATE local_purify_members SET formation=? WHERE team_key=? AND conta_id=?',
                                     (_formation(db, account, mould, selected_ship).rsplit('@',1)[0]+'@'+','.join(slots), current[0], account))
                else:
                    raise ValueError('modo_de_equipe_zetsu_nao_suportado')
                return _success(seq, cmd, _team_tokens(db, account))
        except (server._contas.ErroConta, ValueError, IndexError, TypeError, KeyError) as exc:
            return server.recusa(cmd, seq, str(exc) or 'equipe_zetsu_indisponivel')

    def team_launch(seq, text):
        cmd = 'ship_purify_team_launch'
        try:
            account = db.sessao_de(server._sessao_da_conexao())['conta_id']
            fields = [line for line in server._linhas(text) if line.strip()]
            if len(fields) != 4 or fields[0] != str(db.perfil(account)['user_id']):
                raise ValueError('pedido_de_batalha_zetsu_invalido')
            team_type = int(fields[1]); formation = fields[2]; visual = fields[3]
            positions = formation.split(',')
            visuals = visual.split('|')
            if (len(positions) != 7 or positions[0] != '-1' or
                    sorted(positions[1:]) != ['1','2','3','4','5','6'] or
                    len(visuals) != 6 or any(len(cell.split(',')) != 4 for cell in visuals)):
                raise ValueError('formacao_de_batalha_zetsu_invalida')
            with db._lock, db._conn:
                current = _team(db, account)
                if not current or int(current[1]) != team_type:
                    raise ValueError('equipe_zetsu_nao_encontrada')
                _cleanup_daily(db, current[0])
                member = db._conn.execute('SELECT 1 FROM local_purify_members WHERE team_key=? AND conta_id=?',
                                          (current[0], account)).fetchone()
                daily = _daily_state(db, account)
                if not member:
                    raise ValueError('membro_zetsu_nao_encontrado')
                if daily[0] >= _daily_limit():
                    raise ValueError('tentativas_diarias_zetsu_esgotadas')
                if daily[1]:
                    # Victory window may resend launch; don't count twice.
                    return _success(seq, cmd, _team_tokens(db, account))
                db._conn.execute('UPDATE local_purify_daily SET complete_count=complete_count+1,pending=1 WHERE conta_id=?',
                                 (account,))
                db._conn.execute('UPDATE local_purify_members SET complete_count=complete_count+1,pending=1 WHERE team_key=? AND conta_id=?',
                                 (current[0], account))
                return _success(seq, cmd, _team_tokens(db, account))
        except (server._contas.ErroConta, ValueError, IndexError, TypeError) as exc:
            return server.recusa(cmd, seq, str(exc) or 'batalha_zetsu_indisponivel')

    def buy_reward(seq, text):
        cmd = 'ship_purify_buy_battle_reward'
        try:
            account = db.sessao_de(server._sessao_da_conexao())['conta_id']
            fields = [line for line in server._linhas(text) if line.strip()]
            if not fields or fields[0] != str(db.perfil(account)['user_id']) or len(fields) > 2:
                raise ValueError('pedido_de_bau_zetsu_invalido')
            page = int(fields[1]) if len(fields) == 2 else 1
            if page not in (1, 2):
                raise ValueError('bau_zetsu_invalido')
            if page == 2:
                # APK config says this chest costs 50 premium currency, but
                # its server reward payload is absent from the APK. Refuse
                # safely rather than charging or fabricating contents.
                raise ValueError('premio_do_segundo_bau_zetsu_nao_disponivel')
            with db._lock, db._conn:
                current = _team(db, account)
                if not current:
                    raise ValueError('equipe_zetsu_nao_encontrada')
                team_key = current[0]
                member = db._conn.execute('''SELECT complete_count,pending FROM local_purify_members
                  WHERE team_key=? AND conta_id=?''', (team_key, account)).fetchone()
                daily = _daily_state(db, account)
                if not member or not daily[1] or daily[0] < 1:
                    raise ValueError('nenhuma_vitoria_zetsu_pendente')
                battle_id = '%s:%s' % (team_key, daily[0])
                prior = db._conn.execute('''SELECT reply FROM local_purify_chest_receipts
                  WHERE conta_id=? AND team_key=? AND battle_id=?''',
                  (account, team_key, battle_id)).fetchone()
                if prior:
                    return str(seq)+' '+prior[0].split(' ',1)[1]
                reward = data.tabela('scene_reward.txt').get('156')
                if not reward:
                    raise ValueError('recompensa_original_do_zetsu_ausente')
                currencies = list(map(int, reward[2:7]))
                items = []
                for entry in reward[7].split('|'):
                    if not entry or entry in ('0','-1'):
                        continue
                    quantity, mould = map(int, entry.split(',')[:2])
                    items.append((6, mould, quantity))
                db._conn.execute('INSERT OR IGNORE INTO local_campaign(conta_id,grade,silver) VALUES (?,1,0)', (account,))
                db._conn.execute('UPDATE local_campaign SET silver=silver+? WHERE conta_id=?', (currencies[0], account))
                db._conn.execute('INSERT OR IGNORE INTO local_resources(conta_id) VALUES (?)', (account,))
                db._conn.execute('UPDATE local_resources SET gold=gold+?,honour=honour+?,soul=soul+?,jade=jade+? WHERE conta_id=?',
                                 tuple(currencies[1:])+(account,))
                import shop_local
                for kind, ident, amount in items:
                    shop_local.grant(db, account, kind, ident, amount)
                db._conn.execute('UPDATE local_purify_daily SET pending=0 WHERE conta_id=?', (account,))
                db._conn.execute('UPDATE local_purify_members SET pending=0 WHERE team_key=? AND conta_id=?',
                                 (team_key, account))
                from hero_training_local import inventory_tokens
                wallet = shop_local.balances(db, account, currencies[1])
                reply = _success(seq, cmd, inventory_tokens(db, account)+wallet+
                                 _team_tokens(db, account)+['171','2',str(len(items))]+
                                 [str(value) for kind, ident, amount in items
                                  for value in (ident, kind, amount)])
                db._conn.execute('INSERT INTO local_purify_chest_receipts VALUES (?,?,?,?)',
                                 (account, team_key, battle_id, reply))
                return reply
        except (server._contas.ErroConta, ValueError, IndexError, TypeError, KeyError) as exc:
            return server.recusa(cmd, seq, str(exc) or 'bau_zetsu_indisponivel')

    server.MINIMOS['ship_purify_init'] = initialize
    server.MINIMOS['ship_purify_team_manager'] = team_manager
    server.MINIMOS['ship_purify_team_launch'] = team_launch
    server.MINIMOS['ship_purify_buy_battle_reward'] = buy_reward
