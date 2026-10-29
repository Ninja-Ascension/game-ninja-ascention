"""Formacao e ninjas da conta ativa, com os nomes das tabelas originais."""
import sqlite3

BANCO = 'E:/[code]/nk/port/dados/contas.sqlite3'
c = sqlite3.connect('file:%s?mode=ro' % BANCO, uri=True)
c.row_factory = sqlite3.Row

conta = c.execute('SELECT id, display_name FROM contas').fetchone()
print('conta:', conta['id'], conta['display_name'])

print('\nformacao (local_formation_slots):')
for r in c.execute('SELECT position, ship_id FROM local_formation_slots'
                   ' WHERE conta_id=? ORDER BY position', (conta['id'],)):
    print('  posicao %s -> ship_id %s' % (r['position'], r['ship_id']))

print('\nrecursos (local_resources):')
for r in c.execute('SELECT * FROM local_resources WHERE conta_id=?', (conta['id'],)):
    print('  ', dict(r))

print('\ncampanha (local_campaign):')
for r in c.execute('SELECT * FROM local_campaign WHERE conta_id=?', (conta['id'],)):
    print('  ', dict(r))

print('\ninventario:')
for r in c.execute('SELECT mould, instance_id, quantity FROM local_inventory'
                   ' WHERE conta_id=? ORDER BY instance_id', (conta['id'],)):
    print('  molde=%s id=%s qtd=%s' % (r['mould'], r['instance_id'], r['quantity']))
