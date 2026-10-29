"""Daily/Weekly Tower fights using the game's original NPC and formation data.

Floor rewards, paid boosts, reset purchases, and rankings are intentionally not
implemented here. The current port only opens a tower, starts a fight, and
persists a win/loss for the active daily or weekly period.
"""
import datetime as dt
import time
from pathlib import Path

import dados_batalha as data

COMMANDS = ('fury_tower_view', 'fury_tower_start', 'fury_tower_result')
FLOORS = {1: 100, 2: 200}


def _appearance_models():
    config = Path(data.MOULD).parent / 'configs' / 'play_config.txt'
    for line in config.read_text(encoding='utf-8', errors='replace').splitlines():
        fields = line.split('\t')
        if len(fields) >= 4 and fields[0] == '56':
            models = tuple(int(value) for value in fields[3].split(',') if value.isdigit())
            if models:
                return models
    raise ValueError('play_config_56_ausente')


MODELS = _appearance_models()


def schema(db):
    db._conn.execute('''CREATE TABLE IF NOT EXISTS local_fury_tower (
        conta_id INTEGER NOT NULL REFERENCES contas(id) ON DELETE CASCADE,
        tower INTEGER NOT NULL,
        period TEXT NOT NULL,
        floor INTEGER NOT NULL DEFAULT 0,
        active_floor INTEGER,
        npc_id INTEGER NOT NULL DEFAULT 0,
        enemy_power INTEGER NOT NULL DEFAULT 0,
        last_floor INTEGER,
        last_win INTEGER,
        updated INTEGER NOT NULL,
        PRIMARY KEY(conta_id,tower,period))''')
def _game_day(now=None):
    import energia
    return dt.date.fromisoformat(energia.cycle()[0])


def _period(tower, day):
    if tower == 1:
        return day.strftime('%Y-%m-%d')
    monday = day - dt.timedelta(days=day.weekday())
    return monday.strftime('%Y-%m-%d')


def _seconds_until_reset(tower, day, now=None):
    now = time.time() if now is None else float(now)
    days_ahead = 1 if tower == 1 else 7 - day.weekday()
    reset_day = day + dt.timedelta(days=days_ahead)
    reset = dt.datetime.combine(reset_day, dt.time(5), tzinfo=dt.timezone.utc).timestamp()
    return max(0, int(reset - now))


def _npc_groups():
    """Map play_config 56 appearance IDs to real NPC templates with formations."""
    table = data.tabela('npc.txt')
    groups = {model: [] for model in MODELS}
    for npc_key, row in table.items():
        try:
            npc_id = int(npc_key)
            # head_pic may list a pair of alternate portraits; play_config
            # 56 stores the first portrait of those same original groups.
            model = int(row[2].split(',')[0])
        except (ValueError, IndexError, TypeError):
            continue
        if model not in groups:
            continue
        formations, _ = data.formacao_do_npc(npc_id)
        if not formations or any(not data.inimigos_da_formacao(fid) for fid in formations):
            continue
        groups[model].append(npc_id)
    for values in groups.values():
        values.sort()
    if any(not groups[model] for model in MODELS):
        raise ValueError('dados_originais_de_npc_incompletos')
    return groups


_NPC_GROUPS = None


def _npc_for_floor(tower, floor):
    global _NPC_GROUPS
    if _NPC_GROUPS is None:
        _NPC_GROUPS = _npc_groups()
    model = MODELS[(floor - 1) % len(MODELS)]
    group = _NPC_GROUPS[model]
    limit = FLOORS[tower]
    index = 0 if limit <= 1 else ((floor - 1) * (len(group) - 1)) // (limit - 1)
    return group[index]


def _enemy_power(npc_id):
    """Use configured enemy attributes; no tower buff or fabricated reward data."""
    formations, _ = data.formacao_do_npc(npc_id)
    ships = data.tabela('environment_ship.txt')
    total = 0.0
    for formation_id in formations:
        formation = data.tabela('environment_formation.txt').get(str(formation_id))
        if not formation:
            continue
        for column in range(8, 17):
            try:
                ship_id = int(formation[column - 1])
            except (ValueError, IndexError):
                continue
            ship = ships.get(str(ship_id))
            if not ship:
                continue
            for stat_column in (12, 13, 14, 15):
                try:
                    total += float(ship[stat_column - 1])
                except (ValueError, IndexError):
                    pass
    return max(1, int(round(total)))


def _state(db, account, tower, period, now):
    db._conn.execute(
        'INSERT OR IGNORE INTO local_fury_tower(conta_id,tower,period,updated) VALUES (?,?,?,?)',
        (account, tower, period, int(now * 1000)))
    row = db._conn.execute(
        '''SELECT floor,active_floor,npc_id,enemy_power,last_floor,last_win
           FROM local_fury_tower WHERE conta_id=? AND tower=? AND period=?''',
        (account, tower, period)).fetchone()
    return row


def _tokens(db, account, tower, period, day, now, notice=0):
    row = _state(db, account, tower, period, now)
    completed, active, saved_npc, saved_power = map(lambda x: x or 0, row[:4])
    floors = FLOORS[tower]
    next_floor = completed + 1
    if active and active == next_floor:
        npc_id, power = saved_npc, saved_power
    elif next_floor <= floors:
        npc_id = _npc_for_floor(tower, next_floor)
        power = _enemy_power(npc_id)
    else:
        npc_id, power = 0, 0
    # Purchases and rewards are intentionally disabled until their original
    # data is reviewed. Values here make the client render no purchasable perk.
    fields = [tower, floors, completed, notice, 0, 1, 1, 1, 0, 3, 3,
              npc_id, power, _seconds_until_reset(tower, day, now), 0]
    return ['29120'] + list(map(str, fields)) + ['0']


def execute(server, cmd, seq, text):
    db = server.BANCO
    try:
        account = db.sessao_de(server._sessao_da_conexao())['conta_id']
        lines = server._linhas(text)
        expected_user_id = str(db.perfil(account)['user_id'])
        if len(lines) < 2 or lines[0] != expected_user_id:
            raise ValueError('perfil_invalido')
        tower = int(lines[1])
        if tower not in FLOORS:
            raise ValueError('torre_invalida')
        day = _game_day()
        period = _period(tower, day)
        now = time.time()

        with db._lock, db._conn:
            row = _state(db, account, tower, period, now)
            if cmd == 'fury_tower_view':
                if len(lines) != 2:
                    raise ValueError('pedido_de_torre_invalido')
                notice = 0
            elif cmd == 'fury_tower_start':
                if len(lines) != 3:
                    raise ValueError('pedido_de_luta_invalido')
                floor = int(lines[2])
                completed, active = int(row[0]), row[1]
                if active is not None and int(active) != floor:
                    raise ValueError('outra_luta_em_andamento')
                if active is None and (floor != completed + 1 or floor > FLOORS[tower]):
                    raise ValueError('piso_invalido')
                if active is None:
                    npc_id = _npc_for_floor(tower, floor)
                    power = _enemy_power(npc_id)
                    db._conn.execute(
                        '''UPDATE local_fury_tower SET active_floor=?,npc_id=?,enemy_power=?,updated=?
                           WHERE conta_id=? AND tower=? AND period=?''',
                        (floor, npc_id, power, int(now * 1000), account, tower, period))
                notice = 0
            elif cmd == 'fury_tower_result':
                if len(lines) != 4 or lines[3] not in ('0', '1'):
                    raise ValueError('resultado_de_luta_invalido')
                floor, won = int(lines[2]), int(lines[3])
                completed, active, last_floor, last_win = int(row[0]), row[1], row[4], row[5]
                if active is None and last_floor == floor and last_win == won:
                    pass  # Idempotent re-send after the original response was lost.
                elif active is None or int(active) != floor:
                    raise ValueError('luta_nao_iniciada')
                else:
                    new_floor = floor if won else completed
                    db._conn.execute(
                        '''UPDATE local_fury_tower SET floor=?,active_floor=NULL,npc_id=0,
                           enemy_power=0,last_floor=?,last_win=?,updated=?
                           WHERE conta_id=? AND tower=? AND period=?''',
                        (new_floor, floor, won, int(now * 1000), account, tower, period))
                notice = 0
            else:
                raise ValueError('comando_de_torre_nao_suportado')

            response = ' '.join([str(seq), cmd, '0'] +
                                _tokens(db, account, tower, period, day, now, notice))
            return response
    except (server._contas.ErroConta, ValueError, IndexError, TypeError) as exc:
        return server.recusa(cmd, seq, str(exc) or 'torre_indisponivel')


def install(server):
    with server.BANCO._lock, server.BANCO._conn:
        schema(server.BANCO)
    for command in COMMANDS:
        server.MINIMOS[command] = lambda seq, text, cmd=command: execute(server, cmd, seq, text)
