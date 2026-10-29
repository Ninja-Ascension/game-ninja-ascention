"""Estado atual: modo de jogo em execucao e a conta preservada.

Le somente o necessario para nao perder contexto:
  * modo efetivo (tutorial ligado ou nao) no banco ativo;
  * contas existentes e seus ninjas/formacao.
Nao altera nada.
"""
import sqlite3
import sys

sys.path.insert(0, 'E:/[code]/nk/port/server')

BANCO = 'E:/[code]/nk/port/dados/contas.sqlite3'

try:
    import gameplay_mode
    print('gameplay_mode: tutorial_enabled =', gameplay_mode.tutorial_habilitado()
          if hasattr(gameplay_mode, 'tutorial_habilitado') else 'sem funcao')
except Exception as exc:
    print('gameplay_mode:', exc)

c = sqlite3.connect('file:%s?mode=ro' % BANCO, uri=True)
c.row_factory = sqlite3.Row

print('\ntabelas:', ', '.join(
    r[0] for r in c.execute("SELECT name FROM sqlite_master WHERE type='table' ORDER BY name")))

print('\ncontas:')
for r in c.execute('SELECT id, display_name FROM contas ORDER BY id'):
    print('  id=%s nome=%s' % (r['id'], r['display_name']))

print('\nperfis:')
for r in c.execute('SELECT conta_id, user_id, user_name FROM perfis ORDER BY conta_id'):
    print('  conta=%s user_id=%s nome=%s' % (r['conta_id'], r['user_id'], r['user_name']))

# Ninjas de cada conta, se a tabela existir.
tabelas = {r[0] for r in c.execute("SELECT name FROM sqlite_master WHERE type='table'")}
for nome in ('local_ships', 'local_heroes', 'local_formation_slots'):
    if nome not in tabelas:
        continue
    try:
        colunas = [d[1] for d in c.execute('PRAGMA table_info(%s)' % nome)]
        print('\n%s colunas: %s' % (nome, ', '.join(colunas)))
        for r in c.execute('SELECT * FROM %s ORDER BY conta_id' % nome):
            print('  ', dict(r))
    except Exception as exc:
        print('%s: %s' % (nome, exc))
