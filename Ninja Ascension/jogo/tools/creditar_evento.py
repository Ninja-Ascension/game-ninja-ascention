"""Admin local credit: profile_name amount unique_source. Never exposed in-game."""
import argparse
import datetime
from pathlib import Path
import sqlite3
import sys

root=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(root/'port/server'))

def main():
    parser=argparse.ArgumentParser(description='Credita Gold e registra recarga local de eventos; use uma referência única por operação.')
    parser.add_argument('personagem')
    parser.add_argument('quantidade',type=int)
    parser.add_argument('referencia')
    args=parser.parse_args()
    if not 0<args.quantidade<=1000000000: parser.error('Quantidade inválida')
    source=root/'port/dados/contas.sqlite3'
    backup=root/'build'/('contas-before-event-credit-'+datetime.datetime.now().strftime('%Y%m%d-%H%M%S-%f')+'.sqlite3')
    with sqlite3.connect(source.as_uri()+'?mode=ro',uri=True) as live:
        row=live.execute('SELECT conta_id FROM perfis WHERE user_name=? COLLATE NOCASE',(args.personagem,)).fetchone()
        if not row: parser.error('Personagem não encontrado')
        account=row[0]
        with sqlite3.connect(backup) as dest:
            live.backup(dest)
            assert dest.execute('PRAGMA integrity_check').fetchone()[0]=='ok'
    from contas import Banco
    import events_local
    db=Banco(str(source))
    try:
        events_local.schema(db)
        with db._lock,db._conn:
            changed=events_local.credit(db,account,args.referencia,args.quantidade)
        assert db._conn.execute('PRAGMA integrity_check').fetchone()[0]=='ok'
        print('CREDITADO' if changed else 'JÁ CREDITADO; sem duplicação')
        print('Backup:',backup)
    finally:
        db.fechar()

if __name__=='__main__':main()
