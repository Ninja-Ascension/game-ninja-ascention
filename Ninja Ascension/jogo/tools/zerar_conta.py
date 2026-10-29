"""Zera o progresso de tutorial da conta informada, mantendo a identidade.

Pedido do jogador: "recomece a conta que tenho, zere ela" (para testar o
tutorial do início com os diálogos ocultos).

O que é preservado:
  * contas   (nome de exibição e hash da senha) — o login continua igual;
  * perfis   (user_id e user_name)               — a conta é a mesma.

O que é apagado (progresso de tutorial/campanha):
  tutorial_events, tutorial_progress, tutorial_recruit, tutorial_training,
  tutorial_formation, local_campaign, local_inventory, local_pve_clears,
  local_battle_pending e as sessões abertas (o cliente precisa logar de novo).

Uso:
    python tools/zerar_conta.py            # simulação (mostra o que mudaria)
    python tools/zerar_conta.py --aplicar  # executa
"""
import sqlite3
import sys
from pathlib import Path

raiz = Path(__file__).resolve().parents[1]
BANCO = raiz / 'port/dados/contas.sqlite3'

# Tabelas de progresso: tudo o que precisa voltar ao começo.
PROGRESSO = [
    'tutorial_events', 'tutorial_progress', 'tutorial_recruit',
    'tutorial_training', 'tutorial_formation', 'local_campaign',
    'local_inventory', 'local_pve_clears', 'local_battle_pending',
]
# `sessoes` NÃO entra na lista: apagá-la invalida o token que o cliente guardou
# no UserDefault e o próximo login morre com "Sessao invalida." (era o "erro
# desconhecido" na tela). A sessão é credencial, não progresso.

aplicar = '--aplicar' in sys.argv
conta = 52

conn = sqlite3.connect('file:%s?mode=ro' % BANCO.as_posix(), uri=True) if not aplicar \
    else sqlite3.connect(str(BANCO))
conn.row_factory = sqlite3.Row

print('conta:')
for linha in conn.execute('SELECT id, display_name FROM contas'):
    print('  id=%s nome=%s' % (linha['id'], linha['display_name']))
for linha in conn.execute('SELECT conta_id, user_id, user_name FROM perfis'):
    print('  perfil conta=%s user_id=%s nick=%s'
          % (linha['conta_id'], linha['user_id'], linha['user_name']))

print('\nprogresso ANTES:')
for tabela in PROGRESSO:
    n = conn.execute('SELECT COUNT(*) FROM %s WHERE conta_id=?' % tabela, (conta,)).fetchone()[0]
    print('  %-22s %d registro(s)' % (tabela, n))
for linha in conn.execute('SELECT grade, silver FROM local_campaign WHERE conta_id=?', (conta,)):
    print('  campanha: nivel=%s prata=%s' % (linha['grade'], linha['silver']))

if not aplicar:
    print('\nSIMULAÇÃO. Nada foi alterado. Rode com --aplicar para zerar.')
    sys.exit(0)

with conn:
    for tabela in PROGRESSO:
        conn.execute('DELETE FROM %s WHERE conta_id=?' % tabela, (conta,))

print('\nprogresso DEPOIS:')
for tabela in PROGRESSO:
    n = conn.execute('SELECT COUNT(*) FROM %s WHERE conta_id=?' % tabela, (conta,)).fetchone()[0]
    print('  %-22s %d registro(s)' % (tabela, n))
restantes = conn.execute('SELECT COUNT(*) FROM contas').fetchone()[0]
perfis = conn.execute('SELECT COUNT(*) FROM perfis').fetchone()[0]
print('\nidentidade preservada: contas=%d perfis=%d' % (restantes, perfis))
conn.close()
print('CONTA_ZERADA conta=%d' % conta)
