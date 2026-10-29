"""Explicit local resource grant, preserving levels, tutorial and characters."""
import argparse,sys
from pathlib import Path
root=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(root/'port/server'))
from contas import Banco
import dados_batalha as data
parser=argparse.ArgumentParser();parser.add_argument('--account',type=int,required=True)
args=parser.parse_args();account=args.account
db=Banco(str(root/'port/dados/contas.sqlite3'))
try:
    assert db._conn.execute('SELECT 1 FROM contas WHERE id=?',(account,)).fetchone(),'Unknown account'
    props=[int(key) for key in data.tabela('prop_mould.txt') if key.isdigit() and 1<=int(key)<=150]
    with db._conn:
        db._conn.execute('INSERT INTO local_campaign VALUES (?,1,10000000) ON CONFLICT(conta_id) DO UPDATE SET silver=MAX(silver,10000000)',(account,))
        db._conn.execute('INSERT INTO local_resources VALUES (?,1000000,10000,10000,1000000,1000000,1000000) ON CONFLICT(conta_id) DO UPDATE SET gold=MAX(gold,1000000),food=MAX(food,10000),endurance=MAX(endurance,10000),honour=MAX(honour,1000000),soul=MAX(soul,1000000),jade=MAX(jade,1000000)',(account,))
        for mould in props:
            db._conn.execute('INSERT INTO local_inventory VALUES (?,?,?,10000) ON CONFLICT(conta_id,mould) DO UPDATE SET quantity=MAX(quantity,10000)',
                             (account,mould,account*1000000+mould))
    print('LOCAL_RESOURCE_GRANT account_id=%s silver=10000000 gold=1000000 food=10000 endurance=10000 item_types=%s quantity_each=10000'%(account,len(props)))
    assert db._conn.execute('PRAGMA integrity_check').fetchone()[0]=='ok'
finally:db.fechar()
