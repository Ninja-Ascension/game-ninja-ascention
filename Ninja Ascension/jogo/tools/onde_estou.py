"""Mostra onde cada conta está no tutorial, em ordem cronologica."""
import sqlite3

c = sqlite3.connect('file:N:/port/dados/contas.sqlite3?mode=ro', uri=True)
c.row_factory = sqlite3.Row

for conta in c.execute('SELECT id, display_name FROM contas ORDER BY id'):
    cid = conta['id']
    print('=' * 60)
    print('CONTA %s  (id %s)' % (conta['display_name'], cid))
    print('=' * 60)
    camp = c.execute('SELECT grade, silver FROM local_campaign WHERE conta_id=?', (cid,)).fetchone()
    print('  nivel/prata : %s' % (dict(camp) if camp else 'sem campanha'))
    inv = c.execute('SELECT COUNT(*) FROM local_inventory WHERE conta_id=?', (cid,)).fetchone()[0]
    pve = c.execute('SELECT COUNT(*) FROM local_pve_clears WHERE conta_id=?', (cid,)).fetchone()[0]
    print('  inventario  : %s itens' % inv)
    print('  fases ganhas: %s' % pve)
    linhas = c.execute(
        'SELECT mould, progress FROM tutorial_events WHERE conta_id=? ORDER BY mould',
        (cid,)).fetchall()
    print('  eventos do tutorial (%d):' % len(linhas))
    for r in linhas:
        print('    %s -> etapa %s' % (r['mould'], r['progress']))
    # O ultimo evento diz onde parou.
    if linhas:
        ultimo = linhas[-1]
        print('  >> PAROU EM: grupo %s, etapa %s' % (ultimo['mould'], ultimo['progress']))
    print()
