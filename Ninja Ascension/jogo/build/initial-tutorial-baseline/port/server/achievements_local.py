"""Ninja School > Achievements, plus the general achievement progress that
unlocks Shamanism artifacts.

1) Ninja School tab (table `achievement`, parser 12565 "score" + "id:progress,..",
   progress -1 = reward taken; draw_achievement_reward(id) claims one).
   Columns (0-based): 3 tab (1/2/3), 4 judge, 5 type, 6 param2, 7 param3,
   8 points earned, 9 level needed. Target = param3 for (tab 2, type 27),
   otherwise param2 (SmCultivateAchieveWindow.lua:232).
2) General table `achieve` (parser 3501 "p1,p2,..", one value per id). The
   Shamanism window compares _ED.all_achieve[id] with param2 (param3 for
   types 25/27, 1 for type 35) - SmCultivateArtifactInfo.lua:545-551.

Progress is computed from what this server records; condition types that
depend on systems this port does not track yet stay at 0 (never faked).
Implemented types:
  achievement: 0 (function opened, by level), 25 daily missions done,
               27 ninjas with N stars, 34 stage stars, 36 cursed seals at
               max level, 37 sculptures bought, 30 Team Spirit gifts sent
               (counted from this version on), 13 team power.
  achieve:     0 team level, 25 ninjas at quality, 26 ninjas owned,
               27 ninjas with N stars, 34 stage stars, 35 owns a ninja,
               39 ninjas with aptitude, 107 (type 1) stage of chapter cleared.
"""
import json
import dados_batalha as data

COMMANDS = ('draw_achievement_reward', 'draw_achieve_reward')
MAIN_REWARD_KINDS = {1, 2, 6, 7}   # Ryo, gold, item, equipment


def schema(db):
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_achieve_claims (conta_id INTEGER NOT NULL REFERENCES contas(id) ON DELETE CASCADE, achieve INTEGER NOT NULL, PRIMARY KEY(conta_id, achieve))')
    db._conn.execute('CREATE TABLE IF NOT EXISTS local_achievement_claims (conta_id INTEGER NOT NULL REFERENCES contas(id) ON DELETE CASCADE, achievement INTEGER NOT NULL, PRIMARY KEY(conta_id, achievement))')


# ------------------------------------------------------------ account facts --

def facts(db, account):
    import recruitment_local as heroes, hero_development_local as dev
    owned = heroes.all_owned(db, account)
    grade = db._conn.execute('SELECT grade FROM local_campaign WHERE conta_id=?', (account,)).fetchone()
    stars, quality, souls = [], [], []
    for ship, mould in owned:
        s = dev.state(db, account, ship, mould)
        stars.append(int(s['star']))
        souls += [int(x[0]) for x in s.get('souls', [])]
        try:
            import hero_quality_local
            quality.append(int(hero_quality_local.quality(db, account, ship, mould)))
        except Exception:
            quality.append(0)
    pve = db._conn.execute('SELECT scene, npc, stars FROM local_pve_clears WHERE conta_id=?', (account,)).fetchall()
    tasks = db._conn.execute("SELECT COUNT(*) FROM local_quest_claim WHERE conta_id=? AND kind='task'", (account,)).fetchone()[0]
    try:
        sculptures = db._conn.execute('SELECT COUNT(*) FROM local_constellation WHERE conta_id=?', (account,)).fetchone()[0]
    except Exception:
        sculptures = 0
    moulds = [m for _, m in owned]
    try:
        school = db._conn.execute('SELECT state FROM local_ninja_school WHERE conta_id=?', (account,)).fetchone()
        gifts = int(json.loads(school[0]).get('spiritGifts', 0)) if school else 0
    except Exception:
        gifts = 0
    try:
        import ranking_local
        team_power = int(ranking_local.power(db, account))
    except Exception:
        team_power = 0
    aptitude = [int(data.tabela('ship_mould.txt')[str(m)][8]) for m in moulds]
    return dict(grade=grade[0] if grade else 1, stars=stars, quality=quality, souls=souls, moulds=moulds,
                aptitude=aptitude, stage_stars=sum(r[2] for r in pve), pve=pve, tasks=tasks, sculptures=sculptures,
                gifts=gifts, team_power=team_power)


# --------------------------------------------------------- `achieve` table --

def achieve_progress(f, row):
    kind, t, p2, p3 = row[4], int(row[5]), int(row[6]), int(row[7])
    if kind == '0':
        if t == 0: return f['grade']
        if t == 25: return sum(1 for q in f['quality'] if q >= p2)
        if t == 26: return len(f['moulds'])
        if t == 27: return sum(1 for s in f['stars'] if s >= p2)
        if t == 34: return f['stage_stars']
        if t == 35: return int(p2 in f['moulds'])
        if t == 39: return sum(1 for a in f['aptitude'] if a >= p3)
    if kind == '1' and t == 107:
        # "Conclua 12-10": ten stages of chapter 12 cleared
        return int(sum(1 for s, _, _ in f['pve'] if s == 12) >= 10)
    return 0


def achieve_target(row):
    t = int(row[5])
    if t in (25, 27): return int(row[7])
    if t == 35: return 1
    return int(row[6])


def completed(db, account, ident):
    row = data.tabela('achieve.txt').get(str(ident))
    if not row:
        return False
    return achieve_progress(facts(db, account), row) >= achieve_target(row)


def all_achieve_tokens(db, account):
    f = facts(db, account)
    rows = data.tabela('achieve.txt')
    top = max(int(k) for k in rows)
    done = main_claimed(db, account)
    values = [('-1' if i in done else str(achieve_progress(f, rows[str(i)]))) if str(i) in rows else '0' for i in range(1, top + 1)]
    return ['3501', ','.join(values)]


def main_claimed(db, account):
    return {r[0] for r in db._conn.execute('SELECT achieve FROM local_achieve_claims WHERE conta_id=?', (account,))}


def main_claim(db, account, ident):
    """Main quest (achievement_list_cell_new.lua): -1 in _ED.all_achieve = taken;
    reward window type 24 (DrawRareReward:init(24))."""
    import shop_local
    row = data.tabela('achieve.txt').get(str(ident))
    if not row:
        raise ValueError('missao_inexistente')
    if row[9] not in ('-1', '0') and int(row[9]) not in main_claimed(db, account):
        raise ValueError('missao_anterior_nao_recebida')
    f = facts(db, account)
    if f['grade'] < int(row[11] or 0):
        raise ValueError('nivel_insuficiente')
    if achieve_progress(f, row) < achieve_target(row):
        raise ValueError('missao_incompleta')
    rewards = [tuple(int(x) for x in p.split(',')) for p in row[8].split('|') if p and p != '-1']
    if any(k not in MAIN_REWARD_KINDS for k, _, _ in rewards):
        raise ValueError('premio_da_missao_ainda_nao_suportado')
    db._conn.execute('INSERT OR IGNORE INTO local_campaign(conta_id) VALUES (?)', (account,))
    db._conn.execute('INSERT OR IGNORE INTO local_resources(conta_id) VALUES (?)', (account,))
    shown = []
    for kind, ident_, n in rewards:
        if kind == 2:
            db._conn.execute('UPDATE local_resources SET gold=gold+? WHERE conta_id=?', (n, account))
            shown.append((-1, 2, n))
        else:
            got = shop_local.grant(db, account, kind, ident_, n)
            shown.append((ident_ if kind in (6, 7) else -1, kind, n))
    db._conn.execute('INSERT INTO local_achieve_claims VALUES (?,?)', (account, int(ident)))
    from hero_training_local import inventory_tokens
    silver = db._conn.execute('SELECT silver FROM local_campaign WHERE conta_id=?', (account,)).fetchone()[0]
    gold = db._conn.execute('SELECT gold FROM local_resources WHERE conta_id=?', (account,)).fetchone()[0]
    gained_gold = sum(n for k, _, n in rewards if k == 2)
    return (inventory_tokens(db, account) + ['22', str(silver), '25', str(gained_gold), str(gold)]
            + shop_local.state_tokens(db, account)
            + ['171', '24', str(len(shown))] + [str(x) for r in shown for x in r])


# ----------------------------------------------------- `achievement` table --

def target(row):
    return int(row[7]) if (row[5] == '27' and row[3] == '2') else int(row[6])


def progress(f, row):
    tab, t, p2, p3 = row[3], int(row[5]), int(row[6]), int(row[7])
    if f['grade'] < int(row[9]):
        return 0
    if t == 0 and row[0] == '1': return target(row)
    if t == 25: return f['tasks']
    if t == 27 and tab == '2': return sum(1 for s in f['stars'] if s >= p2)
    if t == 34 and tab == '1': return f['stage_stars']
    if t == 36 and tab == '2': return sum(1 for s in f['souls'] if s >= p3)
    if t == 37 and tab == '2': return f['sculptures']
    if t == 30 and tab == '2': return f['gifts']
    if t == 13 and tab == '2': return f['team_power']
    return 0


def claimed(db, account):
    return {r[0] for r in db._conn.execute('SELECT achievement FROM local_achievement_claims WHERE conta_id=?', (account,))}


def score(db, account):
    rows = data.tabela('achievement.txt')
    return sum(int(rows[str(a)][8]) for a in claimed(db, account) if str(a) in rows)


def school_tokens(db, account):
    f = facts(db, account); done = claimed(db, account)
    items = []
    for k, row in sorted(data.tabela('achievement.txt').items(), key=lambda x: int(x[0])):
        items.append('%s:%d' % (k, -1 if int(k) in done else min(progress(f, row), target(row))))
    return ['12565', str(score(db, account)), ','.join(items)]


def init_tokens(db, account):
    with db._lock:
        return school_tokens(db, account) + all_achieve_tokens(db, account)


def claim(db, account, ident):
    row = data.tabela('achievement.txt').get(str(ident))
    if not row:
        raise ValueError('conquista_inexistente')
    if ident in claimed(db, account):
        raise ValueError('conquista_ja_recebida')
    if progress(facts(db, account), row) < target(row):
        raise ValueError('conquista_incompleta')
    db._conn.execute('INSERT INTO local_achievement_claims VALUES (?,?)', (account, ident))


def execute(server, cmd, seq, text):
    db = server.BANCO
    try:
        account = db.sessao_de(server._sessao_da_conexao())['conta_id']
        fields = server._linhas(text)
        if len(fields) < 2 or fields[0] != str(db.perfil(account)['user_id']) or not fields[1].isdigit():
            raise ValueError('pedido_invalido')
        ident = int(fields[1])
        if cmd == 'draw_achieve_reward':
            with db._lock, db._conn:
                if ident in main_claimed(db, account):
                    # repeated tap or retry after success: current state, nothing new
                    return ' '.join([str(seq), cmd, '0'] + all_achieve_tokens(db, account))
                result = main_claim(db, account, ident)
                reply = ' '.join([str(seq), cmd, '0'] + result + all_achieve_tokens(db, account))
            server.log('MISSAO_PRINCIPAL conta=%s id=%s' % (account, ident))
            return reply
        with db._lock, db._conn:
            if ident in claimed(db, account):
                # repeated tap or retry after success: same state, nothing new
                return ' '.join([str(seq), cmd, '0'] + school_tokens(db, account))
            claim(db, account, ident)
            import hero_stats_local
            # Updated team speed (12042) so the speed shown grows right away.
            reply = ' '.join([str(seq), cmd, '0'] + school_tokens(db, account) + hero_stats_local.attribute_tokens(db, account))
        server.log('CONQUISTA conta=%s id=%s' % (account, ident))
        return reply
    except (server._contas.ErroConta, ValueError, KeyError, IndexError, TypeError) as exc:
        return server.recusa(cmd, seq, str(exc) or 'conquista_indisponivel')


def install(server):
    with server.BANCO._lock, server.BANCO._conn:
        schema(server.BANCO)
    for command in COMMANDS:
        server.MINIMOS[command] = lambda seq, text, cmd=command: execute(server, cmd, seq, text)
