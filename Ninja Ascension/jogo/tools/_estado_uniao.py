"""Le tabelas e estado de uniao/cla para explicar o cadeado da tela FIGHT."""
import sqlite3

caminho = 'N:/port/dados/contas.sqlite3'
c = sqlite3.connect(caminho)

print('== tabelas ==')
for (nome,) in c.execute(
        "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name"):
    print(' ', nome)

print()
print('== tabelas de uniao ==')
for (nome,) in c.execute(
        "SELECT name FROM sqlite_master WHERE type='table' "
        "AND (name LIKE '%union%' OR name LIKE '%clan%')"):
    print(' ', nome)

print()
print('== recursos da conta 61 ==')
cur = c.execute('PRAGMA table_info(local_resources)')
cols = [d[1] for d in cur]
linha = c.execute('SELECT * FROM local_resources').fetchone()
for k, v in zip(cols, linha):
    print('  %-16s %s' % (k, v))
