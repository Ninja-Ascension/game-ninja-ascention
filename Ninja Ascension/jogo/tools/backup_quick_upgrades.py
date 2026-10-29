"""Consistent pre-deploy backup and protected-account verification, no game imports."""
import datetime,hashlib,json,sqlite3,sys
from pathlib import Path
root=Path(__file__).resolve().parents[1]
source=root/'port/dados/contas.sqlite3'
record=root/'build/quick-upgrades-backup.json'


def snapshot(conn):
    accounts=conn.execute("SELECT c.id,p.user_name FROM contas c JOIN perfis p ON p.conta_id=c.id WHERE lower(p.user_name) IN ('itachibr','renegadobr','aeglos') ORDER BY c.id").fetchall()
    if {name.lower() for _,name in accounts}!={'itachibr','renegadobr','aeglos'}:raise RuntimeError('Conta protegida ausente')
    result={}
    for account,name in accounts:
        tables={}
        for (table,) in conn.execute("SELECT name FROM sqlite_master WHERE type='table' ORDER BY name"):
            if table=='sessoes':continue
            quoted='"'+table.replace('"','""')+'"'
            columns=[r[1] for r in conn.execute('PRAGMA table_info('+quoted+')')]
            key='conta_id' if 'conta_id' in columns else ('id' if table=='contas' else None)
            if key:
                rows=conn.execute('SELECT * FROM '+quoted+' WHERE '+key+'=?',(account,)).fetchall()
                if rows:tables[table]=hashlib.sha256(repr(sorted(rows,key=repr)).encode()).hexdigest()
        result[name]={'id':account,'tables':tables}
    return result


if sys.argv[1:] == ['--verify']:
    saved=json.loads(record.read_text(encoding='utf8'))
    with sqlite3.connect(source.as_uri()+'?mode=ro',uri=True) as live:
        assert live.execute('PRAGMA integrity_check').fetchone()[0]=='ok'
        assert snapshot(live)==saved['accounts'],'Estado das contas protegidas mudou'
    print('PROTECTED_ACCOUNTS_PRESERVED ItachiBR RenegadoBR Aeglos; integrity_check=ok')
else:
    target=root/'build'/('contas-before-quick-upgrades-'+datetime.datetime.now().strftime('%Y%m%d-%H%M%S')+'.sqlite3')
    with sqlite3.connect(source.as_uri()+'?mode=ro',uri=True) as live,sqlite3.connect(target) as backup:
        live.backup(backup)
        assert backup.execute('PRAGMA integrity_check').fetchone()[0]=='ok'
        accounts=snapshot(backup)
    record.write_text(json.dumps({'backup':str(target),'accounts':accounts},indent=2),encoding='utf8')
    print('SQLITE_API_BACKUP '+str(target))
    print('PROTECTED_ACCOUNTS_SNAPSHOTTED '+', '.join(accounts))
