"""Rankings (order_get_info type, first, last) for the players of this server.

type 0 -> 12600 combat power (SmRankCombatPower), type 1 -> 12602 stages
(SmRankCheckMark). Other types (beasts, King of War, ...) are refused.
Power follows the original client formula via hero_power_local.
Stage ranking = stages cleared, then stars.
"""

COMMANDS = ('order_get_info',)


def power(db, account):
    import hero_power_local
    return hero_power_local.formation(db,account)


def players(db):
    return [r[0] for r in db._conn.execute('SELECT conta_id FROM perfis ORDER BY conta_id')]


def base(db, a):
    import profile_local
    p = db.perfil(a)
    g = db._conn.execute('SELECT grade FROM local_campaign WHERE conta_id=?', (a,)).fetchone()
    c = db._conn.execute('SELECT clan_id, clan_name FROM local_clan_membership WHERE conta_id=?', (a,)).fetchone()
    return dict(uid=p['user_id'], name=profile_local.wire_name(p['user_name']), head=profile_local.head(db, a),
                level=g[0] if g else 1, clan=profile_local.wire_name(c[1]) if c else '-', clan_id=c[0] if c else 0)


def fight_tokens(db, account, first, last):
    rows = sorted(((power(db, a), a) for a in players(db)), reverse=True)
    mine = next((i for i, (_, a) in enumerate(rows, 1) if a == account), 0)
    part = rows[max(0, first - 1):last]
    out = ['12600', str(mine), str(mine), str(power(db, account)), str(len(part))]
    for i, (pw, a) in enumerate(part, first):
        b = base(db, a)
        out += [str(b['uid']), b['name'], '-', '0', str(i), str(i), '0', str(b['head']), str(b['level']), '0', '0',
                str(pw), b['clan'], str(b['clan_id']), '-1', '-1', '0']
    return out


def stage_tokens(db, account, first, last):
    def score(a):
        r = db._conn.execute('SELECT COUNT(*), COALESCE(SUM(stars),0) FROM local_pve_clears WHERE conta_id=?', (a,)).fetchone()
        return r[0], r[1]
    rows = sorted(((score(a), a) for a in players(db)), reverse=True)
    mine = next((i for i, (_, a) in enumerate(rows, 1) if a == account), 0)
    part = rows[max(0, first - 1):last]
    out = ['12602', str(mine), '0', str(score(account)[0]), str(len(part))]
    for (count, stars), a in part:
        b = base(db, a)
        out += [str(b['uid']), b['name'], '0', str(b['head']), '0', str(b['level']), '0', '0', str(power(db, a)),
                b['clan'], str(b['clan_id']), str(count), str(stars), '-', '-1', '-1']
    return out


def ships(db, a):
    import hero_power_local, recruitment_local as heroes, hero_level_local as lv, hero_development_local as dev
    out = []
    with db._lock:
        for ship, mould in heroes.all_owned(db, a):
            pw = hero_power_local.character(db,a,ship,mould)
            out.append((pw, ship, mould, lv.state(db, a, ship, mould)[0], dev.state(db, a, ship, mould)['star']))
    return sorted(out, reverse=True)


def common(db, a, rank):
    b = base(db, a)
    return b, [str(b['uid']), b['name']]


def team_speed(db, a):
    """Same total the login sends in 12042: speed of every owned ninja."""
    import hero_stats_local as stats, recruitment_local as heroes
    with db._lock:
        import achievements_local
        return int(sum(stats.effective(db, a, s, m)['speed'] for s, m in heroes.all_owned(db, a)) + achievements_local.score(db, a))


def cards_tokens(db, account, first, last):
    """12605 Team Spirit: ordered by team speed; also sends ninjas owned."""
    rows = sorted(((team_speed(db, a), len(ships(db, a)), a) for a in players(db)), reverse=True)
    mine = next((i for i, (_, _, a) in enumerate(rows, 1) if a == account), 0)
    part = rows[max(0, first - 1):last]
    out = ['12605', str(mine), '0', str(team_speed(db, account)), str(len(ships(db, account))), str(len(part))]
    for speed, n, a in part:
        b = base(db, a)
        out += [str(b['uid']), b['name'], '-', '0', str(b['head']), '0', str(b['level']), '0', '0', str(power(db, a)),
                b['clan'], str(b['clan_id']), '0', '0', str(n), str(speed), '-1', '-1']
    return out


def ship_info(s):
    pw, ship, mould, level, star = s
    return '%d:%d:1|0,0,0,0:%d:0:%d:0' % (mould, level, star, pw)


def strongest_tokens(db, account, first, last):
    """12606 strongest ninja of each player (Ninja tab)."""
    rows = sorted(((ships(db, a)[0], a) for a in players(db) if ships(db, a)), key=lambda x: -x[0][0])
    mine = next((i for i, (_, a) in enumerate(rows, 1) if a == account), 0)
    part = rows[max(0, first - 1):last]
    my = ships(db, account)
    out = ['12606']
    out += [str(my[0][1]), str(mine), ship_info(my[0]), str(my[0][0])] if my else ['-1']
    out.append(str(len(part)))
    for s, a in part:
        b = base(db, a)
        out += [str(b['uid']), b['name'], '0', str(b['head']), '0', str(b['level']), '0', '0', str(power(db, a)),
                b['clan'], str(b['clan_id']), '0', '0', '-', '-1', '-1', str(s[1]), ship_info(s), str(s[0])]
    return out


def kings_tokens(db, account, first, last):
    """12609 Ninja King: no matches are played on this server yet, so every
    player has 0 points (ordered by power)."""
    rows = sorted(((power(db, a), a) for a in players(db)), reverse=True)
    mine = next((i for i, (_, a) in enumerate(rows, 1) if a == account), 0)
    part = rows[max(0, first - 1):last]
    out = ['12609', str(mine), '0', '0', str(len(part))]
    for pw, a in part:
        b = base(db, a)
        out += [str(b['uid']), b['name'], '0', str(b['head']), '0', str(b['level']), '0', '0', str(pw), b['clan'],
                str(b['clan_id']), '0', '0', '0', '0', '0', '0', '-', '-1', '-1']   # score..current gold, odds
    return out


def trial_tokens(db, account, first, last):
    """12607 Ninja Trial ranking, ordered by original score then cleared floor."""
    import ninja_trial_local
    ninja_trial_local._schema(db)
    scores = {r[0]: (int(r[1]), int(r[2])) for r in db._conn.execute(
        'SELECT conta_id,score,floor FROM local_ninja_trial')}
    rows = sorted(((scores.get(a, (0, 0))[0], scores.get(a, (0, 0))[1], a)
                   for a in players(db)), key=lambda x: (-x[0], -x[1], x[2]))
    mine = next((i for i, (_, _, a) in enumerate(rows, 1) if a == account), 0)
    my_score, my_floor = scores.get(account, (0, 0))
    page = rows[max(0, first - 1):last]
    out = ['12607', str(mine), str(my_score), str(my_floor), str(len(page))]
    for rank, (score, floor, a) in enumerate(page, max(1, first)):
        b = base(db, a)
        out += [str(b['uid']), b['name'], '0', str(b['head']), '0', str(b['level']),
                '0', '0', str(power(db, a)), b['clan'], str(b['clan_id']),
                str(score), str(floor), '-1', '-1']
    return out


def achieve_tokens(db, account, first, last):
    """12610 Ninja School achievement score (sum of claimed achievement points)."""
    import achievements_local, vip_local
    rows = sorted(((achievements_local.score(db, a), a) for a in players(db)), reverse=True)
    mine = next((i for i, (_, a) in enumerate(rows, 1) if a == account), 0)
    part = rows[max(0, first - 1):last]
    out = ['12610', str(mine), str(achievements_local.score(db, account)), str(len(part))]
    for sc, a in part:
        b = base(db, a)
        out += [str(b['uid']), b['name'], '0', str(b['head']), '0', str(b['level']), vip_local.grade(db, a), '0',
                str(power(db, a)), b['clan'], str(b['clan_id']), str(sc), '-1', '-1']
    return out


def sculpture_tokens(db, account, first, last):
    """12611 Sculpture Mountain: total guard value (ctv) and sculptures carved."""
    import constellation_local, vip_local
    def value(a):
        try:
            ctv = constellation_local.info(db, a)['ctv']
        except Exception:
            ctv = 0
        n = db._conn.execute("SELECT COUNT(*) FROM local_constellation WHERE conta_id=?", (a,)).fetchone()[0]             if db._conn.execute("SELECT 1 FROM sqlite_master WHERE name='local_constellation'").fetchone() else 0
        return ctv, n
    rows = sorted(((value(a), a) for a in players(db)), reverse=True)
    mine = next((i for i, (_, a) in enumerate(rows, 1) if a == account), 0)
    part = rows[max(0, first - 1):last]
    my = value(account)
    out = ['12611', str(mine), str(my[0]), str(my[1]), str(len(part))]
    for (ctv, n), a in part:
        b = base(db, a)
        out += [str(b['uid']), b['name'], '0', str(b['head']), '0', str(b['level']), vip_local.grade(db, a), '0',
                str(power(db, a)), b['clan'], str(b['clan_id']), str(ctv), str(n), '-1', '-1']
    return out


def execute(server, cmd, seq, text):
    db = server.BANCO
    try:
        account = db.sessao_de(server._sessao_da_conexao())['conta_id']
        f = server._linhas(text)
        body = f[1:] if f and f[0] == str(db.perfil(account)['user_id']) else f
        kind, first, last = int(body[0]), max(1, int(body[1])), int(body[2])
        if last < first or last - first > 100:
            raise ValueError('faixa_invalida')
        if kind == 0:
            out = fight_tokens(db, account, first, last)
        elif kind == 1:
            out = stage_tokens(db, account, first, last)
        elif kind == 3:
            out = cards_tokens(db, account, first, last)
        elif kind == 4:
            out = strongest_tokens(db, account, first, last)
        elif kind == 5:
            out = trial_tokens(db, account, first, last)
        elif kind == 7:
            out = kings_tokens(db, account, first, last)
        elif kind == 9:
            out = sculpture_tokens(db, account, first, last)
        elif kind == 8:
            out = achieve_tokens(db, account, first, last)
        else:
            raise ValueError('ranking_ainda_nao_implementado')
        return ' '.join([str(seq), cmd, '0'] + out)
    except (server._contas.ErroConta, ValueError, KeyError, IndexError, TypeError) as exc:
        return server.recusa(cmd, seq, str(exc) or 'ranking_indisponivel')


def install(server):
    for command in COMMANDS:
        server.MINIMOS[command] = lambda seq, text, cmd=command: execute(server, cmd, seq, text)
