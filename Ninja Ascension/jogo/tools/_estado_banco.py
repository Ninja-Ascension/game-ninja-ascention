import sqlite3

c = sqlite3.connect('file:N:/port/dados/contas.sqlite3?mode=ro', uri=True)
triggers = c.execute("SELECT name FROM sqlite_master WHERE type='trigger'").fetchall()
print('triggers:', triggers if triggers else 'nenhum (pode criar contas)')
print('contas  :', c.execute('SELECT id,display_name FROM contas').fetchall())
print('nivel   :', c.execute('SELECT grade,silver FROM local_campaign').fetchall())
print('eventos :', c.execute('SELECT COUNT(*) FROM tutorial_events').fetchone()[0])
