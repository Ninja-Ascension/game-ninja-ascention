"""Read-only account/tutorial audit. Never includes names, passwords or sessions."""
import json, sqlite3
from pathlib import Path

root=Path(__file__).resolve().parents[1]
source=root/'01_conteudo_apk/assets/res/language/pt_BR/data/mould/mission3.txt'
groups={}
for line in source.read_text(encoding='utf8').splitlines():
    row=line.split('\t')
    if len(row)<17 or row[0] not in map(str,range(1,8)):continue
    groups.setdefault(row[0],[]).append(dict(sequence=int(row[1]),progress=int(row[9]),
        trigger=row[6],condition=row[7],kind=row[12],target=row[14],widget=row[15]))
path=root/'port/dados/contas.sqlite3'
db=sqlite3.connect(path.as_uri()+'?mode=ro',uri=True)
accounts=[]
for (account,) in db.execute('SELECT id FROM contas ORDER BY id'):
    def rows(table,columns='*'):
        return db.execute('SELECT '+columns+' FROM '+table+' WHERE conta_id=?',(account,)).fetchall()
    accounts.append(dict(id=account,campaign=rows('local_campaign','grade,silver'),
        intro=rows('tutorial_progress','experiencia'),events=rows('tutorial_events','mould,progress'),
        recruit=rows('tutorial_recruit','mould'),formation=rows('tutorial_formation','position'),
        training=rows('tutorial_training','kit,quality'),clears=rows('local_pve_clears','scene,npc,stars')))
result=dict(account_count=len(accounts),integrity=db.execute('PRAGMA integrity_check').fetchone()[0],
            accounts=accounts,tutorial_groups=groups)
db.close()
output=root/'build/tutorial-audit.json'
output.write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf8')
print('AUDIT_READ_ONLY',output)
print('accounts',len(accounts),'integrity',result['integrity'])
for account in accounts:
    print('profile',account['id'],'campaign',account['campaign'],'checkpoint',account['events'])
