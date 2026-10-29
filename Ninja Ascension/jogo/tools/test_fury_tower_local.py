"""Temporary SQLite regression for local Daily/Weekly Tower fight progression."""
import pathlib
import sqlite3
import sys
import threading
import types

ROOT = pathlib.Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'port' / 'server'))

import fury_tower_local as tower


class FakeBanco:
    def __init__(self):
        self._conn = sqlite3.connect(':memory:')
        self._conn.row_factory = sqlite3.Row
        self._lock = threading.RLock()
        self._conn.execute('CREATE TABLE contas(id INTEGER PRIMARY KEY)')
        self._conn.execute('INSERT INTO contas(id) VALUES (1)')

    def sessao_de(self, _token):
        return {'conta_id': 1}

    def perfil(self, _account):
        return {'user_id': 777, 'user_name': 'tower_test'}


class Server:
    BANCO = FakeBanco()
    MINIMOS = {}
    _contas = types.SimpleNamespace(ErroConta=type('ErroConta', (Exception,), {}))

    @staticmethod
    def _sessao_da_conexao():
        return 'temporary-session'

    @staticmethod
    def _linhas(text):
        return [line.strip() for line in text.split('\r\n')][2:]

    @staticmethod
    def recusa(cmd, seq, message):
        return f'{seq} {cmd} -1 {message}'

    @staticmethod
    def log(_message):
        pass


server = Server()
tower.install(server)


def send(command, seq, *args):
    text = '\r\n'.join([str(seq), command, '777', *map(str, args)])
    return server.MINIMOS[command](str(seq), text)


def parsed_floor(response):
    fields = response.split()
    assert fields[2] == '0', response
    assert fields[3] == '29120', response
    return int(fields[6])


# Verify every appearance ID from play_config 56 resolves to original NPCs.
groups = tower._npc_groups()
assert all(groups[model] for model in tower.MODELS)
for model in tower.MODELS:
    npc = groups[model][0]
    assert tower._enemy_power(npc) > 0

view = send('fury_tower_view', 1, 1)
assert parsed_floor(view) == 0
assert int(view.split()[5]) == 100
assert view.split()[-1] == '0'  # No unreviewed floor reward list.

start = send('fury_tower_start', 2, 1, 1)
assert parsed_floor(start) == 0
assert int(start.split()[15]) > 0  # NPC ID for the next floor.
assert int(start.split()[16]) > 0  # Enemy power from the NPC formations.
assert send('fury_tower_start', 2, 1, 1) == start  # Same request is idempotent.

won = send('fury_tower_result', 3, 1, 1, 1)
assert parsed_floor(won) == 1
assert send('fury_tower_result', 3, 1, 1, 1) == won
assert parsed_floor(send('fury_tower_view', 4, 1)) == 1
# A separate retry after the active fight was settled must not clear floor 1 again.
assert parsed_floor(send('fury_tower_result', 5, 1, 1, 1)) == 1

send('fury_tower_start', 6, 1, 2)
lost = send('fury_tower_result', 7, 1, 2, 0)
assert parsed_floor(lost) == 1
assert send('fury_tower_result', 7, 1, 2, 0) == lost
assert parsed_floor(send('fury_tower_view', 8, 1)) == 1

weekly = send('fury_tower_view', 9, 2)
assert parsed_floor(weekly) == 0
assert int(weekly.split()[5]) == 200
send('fury_tower_start', 10, 2, 1)
assert parsed_floor(send('fury_tower_result', 11, 2, 1, 1)) == 1

assert server.BANCO._conn.execute('PRAGMA integrity_check').fetchone()[0] == 'ok'
print('FURY_TOWER_LOCAL_OK: daily/weekly fights, NPC data, win/loss, retry idempotency, no placeholder rewards, integrity ok')
