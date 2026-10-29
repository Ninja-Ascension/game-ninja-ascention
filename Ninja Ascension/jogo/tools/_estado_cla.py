"""Mostra o vinculo de cla da conta 61 (base do union_grade usado no cadeado)."""
import sqlite3

c = sqlite3.connect('N:/port/dados/contas.sqlite3')

cur = c.execute('PRAGMA table_info(local_clan_membership)')
cols = [d[1] for d in cur]
print('colunas:', cols)

linhas = c.execute('SELECT * FROM local_clan_membership').fetchall()
print('linhas  :', len(linhas))
for linha in linhas:
    for k, v in zip(cols, linha):
        print('  %-18s %s' % (k, v))
    print('  ---')
