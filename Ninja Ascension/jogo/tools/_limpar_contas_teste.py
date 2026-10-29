"""Limpa contas de teste criadas pelos simuladores."""
import sqlite3

c = sqlite3.connect('E:/[code]/nk/port/dados/contas.sqlite3')
c.execute('PRAGMA foreign_keys=ON')
antes = c.execute('SELECT id, display_name FROM contas').fetchall()
print('antes:', antes)
c.execute("DELETE FROM contas WHERE display_name LIKE 'teste_%'"
          " OR display_name LIKE 'simul_%'")
c.commit()
depois = c.execute('SELECT id, display_name FROM contas').fetchall()
print('depois:', depois)
c.close()
