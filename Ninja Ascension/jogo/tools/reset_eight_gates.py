"""Explicit administrative reset of one character's Eight Gates, with backup."""
import argparse
import datetime
import json
import sqlite3
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def reset(conn, account):
    rows = conn.execute('SELECT ship_id,state FROM local_hero_gates WHERE conta_id=?', (account,)).fetchall()
    conn.execute('UPDATE local_hero_gates SET state=? WHERE conta_id=?',
                 (json.dumps(dict(megaLevel={}, megaUse=[]), separators=(',', ':')), account))
    receipts = conn.execute('SELECT request_id,signature FROM local_hero_gate_receipts WHERE conta_id=?', (account,)).fetchall()
    for key, signature in receipts:
        command = signature.split('|', 1)[0]
        if command not in ('mega_unblock', 'mega_level_up', 'mega_use_skill'):
            raise ValueError('Unexpected gate receipt command')
        # Preserve receipt history and deduplication. A retry from before the
        # reset must not report stale success or restore the former UI state.
        conn.execute('UPDATE local_hero_gate_receipts SET reply=? WHERE conta_id=? AND request_id=?',
                     ('0 ' + command + ' -1 pedido_anterior_ao_reset', account, key))
    return dict(ninjas=len(rows), gates=sum(len(json.loads(row[1]).get('megaLevel', {})) for row in rows), retired_requests=len(receipts))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--character', required=True)
    args = parser.parse_args()
    path = ROOT / 'port/dados/contas.sqlite3'
    stamp = datetime.datetime.now().strftime('%Y%m%d-%H%M%S-%f')
    backup = ROOT / 'build' / ('contas-before-gates-reset-' + stamp + '.sqlite3')
    with sqlite3.connect(path.resolve().as_uri() + '?mode=rw', uri=True) as conn:
        with sqlite3.connect(backup) as copy:
            conn.backup(copy)
            assert copy.execute('PRAGMA integrity_check').fetchone()[0] == 'ok'
        conn.execute('BEGIN IMMEDIATE')
        row = conn.execute('SELECT conta_id,user_name FROM perfis WHERE user_name=? COLLATE NOCASE', (args.character,)).fetchone()
        if not row:
            raise ValueError('Character not found')
        result = reset(conn, row[0])
        assert conn.execute('PRAGMA integrity_check').fetchone()[0] == 'ok'
    result.update(character=row[1], backup=str(backup))
    audit = ROOT / 'build' / ('gates-reset-' + stamp + '.json')
    audit.write_text(json.dumps(result, indent=2), encoding='utf8')
    print(json.dumps(result, ensure_ascii=False))


if __name__ == '__main__':
    main()
