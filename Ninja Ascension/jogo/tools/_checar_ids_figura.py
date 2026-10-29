"""Verifica se dms.element acha os ids da tela FIGHT na tabela do acervo.

funOpenDrawTip (EnvironmentDatas.lua:5219) faz:

    local element = dms.element(dms["fun_open_condition"], _openId)
    if element == nil then return true end   -- trancado

Ou seja: id ausente = cadeado. Aqui conferimos quais ids o arquivo realmente
tem na PRIMEIRA COLUNA (a chave que o dms usa).
"""
import io
import os

CAMINHO = 'N:/01_conteudo_apk/assets/res/data/mould/fun_open_condition.txt'
ALVOS = ['91', '92', '93', '94', '186', '187', '188', '189', '190']

if not os.path.exists(CAMINHO):
    raise SystemExit('arquivo nao encontrado: ' + CAMINHO)

linhas = io.open(CAMINHO, encoding='utf8', errors='replace').read().splitlines()
print('linhas totais:', len(linhas))

# Coluna 1 (indice 0) e a chave. Coluna 3 (indice 2) tambem repete o id.
chave = {}
for linha in linhas:
    campos = linha.split('\t')
    if not campos or not campos[0].strip():
        continue
    chave.setdefault(campos[0].strip(), []).append(campos)

print()
for alvo in ALVOS:
    achado = chave.get(alvo)
    if achado is None:
        print('  id %-4s AUSENTE na coluna 1' % alvo)
    else:
        linha = achado[0]
        print('  id %-4s ok  level=%-4s tip=%r'
              % (alvo, linha[3], linha[6][:52]))

print()
todos = sorted(chave, key=lambda v: int(v) if v.isdigit() else 99999)
print('menor id:', todos[0], ' maior id:', todos[-1])
print('faixa 90-95 presente:', [i for i in todos if i.isdigit() and 90 <= int(i) <= 95])
print('faixa 185-191 presente:', [i for i in todos if i.isdigit() and 185 <= int(i) <= 191])
