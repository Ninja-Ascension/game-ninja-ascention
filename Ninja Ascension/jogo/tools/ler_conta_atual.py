"""Leitura SOMENTE LEITURA do progresso da conta atual (nunca escreve)."""
import sqlite3
import sys

caminho = r'N:\port\dados\contas.sqlite3'
conn = sqlite3.connect('file:%s?mode=ro' % caminho.replace('\\', '/'), uri=True)
conn.row_factory = sqlite3.Row
saida = []


def q(titulo, sql, *args):
    saida.append('--- ' + titulo)
    try:
        for linha in conn.execute(sql, args):
            saida.append('  ' + ' | '.join('%s=%s' % (k, linha[k]) for k in linha.keys()))
    except Exception as exc:
        saida.append('  ERRO: %s' % exc)


q('contas', 'SELECT id,display_name,criada_em FROM contas')
q('perfis', 'SELECT conta_id,user_id,user_name FROM perfis')
q('tutorial_progress', 'SELECT * FROM tutorial_progress')
q('tutorial_events', 'SELECT * FROM tutorial_events ORDER BY conta_id,mould,progress')
q('local_campaign', 'SELECT * FROM local_campaign')
q('local_pve_clears', 'SELECT * FROM local_pve_clears')
q('tutorial_recruit', 'SELECT * FROM tutorial_recruit')
q('tutorial_formation', 'SELECT * FROM tutorial_formation')
q('tutorial_training', 'SELECT * FROM tutorial_training')
q('local_inventory', 'SELECT * FROM local_inventory')
conn.close()
texto = '\n'.join(saida)
open(r'N:\build\conta-atual.txt', 'w', encoding='utf8').write(texto)
print(texto)
