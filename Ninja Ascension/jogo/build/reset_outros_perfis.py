"""One-shot reset requested by the user; defaults to a backup-only rehearsal."""
import argparse
import datetime
import hashlib
import json
import pathlib
import sqlite3
import sys
from types import SimpleNamespace

ROOT = pathlib.Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'port/server'))
DB = ROOT / 'port/dados/contas.sqlite3'
PROTECTED = {'itachibr', 'renegadobr'}


def quote(name):
    return '"' + name.replace('"', '""') + '"'


def digest(rows):
    return hashlib.sha256(repr(sorted(rows, key=repr)).encode()).hexdigest()


def reset(conn):
    conn.execute('BEGIN IMMEDIATE')
    import initial_tutorial
    initial_tutorial.schema(SimpleNamespace(_conn=conn))
    profiles = conn.execute('SELECT conta_id,user_name FROM perfis').fetchall()
    keep = {a for a, name in profiles if name.casefold() in PROTECTED}
    assert len(keep) == 2, 'Protected characters missing or ambiguous'
    targets = {a for a, name in profiles if a not in keep}
    assert targets == set(range(63, 75)), 'Account list changed; review required'
    placeholders = ','.join('?' for _ in targets)
    args = sorted(targets)
    identities = {t: digest(conn.execute('SELECT * FROM '+quote(t)).fetchall())
                  for t in ('contas', 'perfis')}
    owned = {}
    protected = {}
    for (table,) in conn.execute("SELECT name FROM sqlite_master WHERE type='table'").fetchall():
        cols = [r[1] for r in conn.execute('PRAGMA table_info('+quote(table)+')')]
        if table in ('contas', 'perfis') or 'conta_id' not in cols:
            continue
        owned[table] = cols
        protected[table] = digest(conn.execute(
            'SELECT * FROM '+quote(table)+' WHERE conta_id IN (?,?)', sorted(keep)).fetchall())
    deleted = {}
    for table in owned:
        count = conn.execute('DELETE FROM '+quote(table)+' WHERE conta_id IN ('+placeholders+')', args).rowcount
        if count:
            deleted[table] = count
    # Shared social/clan/team data is retained: deleting shared records could
    # remove history or relationships belonging to either protected character.
    # Only relationships entirely between reset accounts are removed here.
    for table, left, right in (
        ('local_friend', 'a', 'b'), ('local_friend_request', 'sender', 'target'),
        ('local_friend_endurance', 'sender', 'target'),
        ('local_account_copy', 'origem', 'destino')):
        exists = conn.execute('SELECT 1 FROM sqlite_master WHERE type=\'table\' AND name=?', (table,)).fetchone()
        if exists:
            count = conn.execute('DELETE FROM '+quote(table)+' WHERE '+quote(left)+' IN ('+placeholders+') AND '+quote(right)+' IN ('+placeholders+')', args+args).rowcount
            if count:
                deleted[table] = count
    for table, expected in protected.items():
        assert digest(conn.execute('SELECT * FROM '+quote(table)+' WHERE conta_id IN (?,?)', sorted(keep)).fetchall()) == expected, table
        assert conn.execute('SELECT count(*) FROM '+quote(table)+' WHERE conta_id IN ('+placeholders+')', args).fetchone()[0] == 0, table
    import initial_tutorial
    wrapper=SimpleNamespace(_conn=conn)
    for account in targets:
        initial_tutorial.enroll(wrapper,account)
    assert conn.execute("SELECT count(*) FROM local_initial_tutorial WHERE state='choice' AND conta_id IN ("+placeholders+')',args).fetchone()[0]==12
    for table, expected in identities.items():
        assert digest(conn.execute('SELECT * FROM '+quote(table)).fetchall()) == expected, table
    assert conn.execute('PRAGMA integrity_check').fetchone()[0] == 'ok'
    conn.commit()
    return {'protected_ids': sorted(keep), 'reset_profiles': [{'id': a, 'character': n} for a, n in profiles if a in targets],
            'deleted_rows': deleted, 'protected_hashes': protected, 'identity_hashes': identities,
            'integrity': 'ok', 'shared_relationships': 'preserved',
            'tutorial': 'choice enrolled; initial tutorial or complete atomic skip'}


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--apply', action='store_true')
    parser.add_argument('--verify', action='store_true')
    opts = parser.parse_args()
    record=ROOT/'build/reset-12-aplicado.json'
    if opts.verify:
        saved=json.loads(record.read_text(encoding='utf8'))
        live=sqlite3.connect(DB.resolve().as_uri()+'?mode=ro',uri=True)
        for table,expected in saved['protected_hashes'].items():
            actual=digest(live.execute('SELECT * FROM '+quote(table)+' WHERE conta_id IN (?,?)',saved['protected_ids']).fetchall())
            assert actual==expected,'Protected state changed: '+table
        for table,expected in saved['identity_hashes'].items():
            assert digest(live.execute('SELECT * FROM '+quote(table)).fetchall())==expected,'Logins changed: '+table
        assert live.execute('PRAGMA integrity_check').fetchone()[0]=='ok'
        assert not live.execute('PRAGMA foreign_key_check').fetchall()
        print('VERIFIED protected progress and all login hashes unchanged; integrity and foreign keys OK')
        live.close()
        raise SystemExit(0)
    if opts.apply and record.exists() and json.loads(record.read_text(encoding='utf8')).get('applied'):
        raise SystemExit('Reset already applied; refusing a second destructive reset')
    stamp = datetime.datetime.now().strftime('%Y%m%d-%H%M%S')
    backups = DB.parent / 'backups'
    backups.mkdir(exist_ok=True)
    backup = backups / ('contas-antes-reset-12-'+stamp+'.sqlite3')
    source = sqlite3.connect(DB.resolve().as_uri()+'?mode=ro', uri=True)
    copy = sqlite3.connect(backup)
    source.backup(copy)
    source.close()
    assert copy.execute('PRAGMA integrity_check').fetchone()[0] == 'ok'
    rehearsal = sqlite3.connect(':memory:')
    copy.backup(rehearsal)
    copy.close()
    result = reset(rehearsal)
    repeated = reset(rehearsal)
    assert repeated['protected_hashes']==result['protected_hashes']
    assert repeated['identity_hashes']==result['identity_hashes']
    assert rehearsal.execute("SELECT count(*) FROM local_initial_tutorial WHERE state='choice'").fetchone()[0]==12
    rehearsal.close()
    if opts.apply:
        live = sqlite3.connect(DB, timeout=30)
        result = reset(live)
        live.close()
    result.update(applied=opts.apply, backup=str(backup), repeated_request='passed')
    output = ROOT / 'build' / ('reset-12-'+('aplicado' if opts.apply else 'ensaio')+'.json')
    output.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding='utf8')
    print(json.dumps({'applied': opts.apply, 'accounts': len(result['reset_profiles']), 'rows': sum(result['deleted_rows'].values()), 'integrity': 'ok', 'report': str(output)}, ensure_ascii=False))
