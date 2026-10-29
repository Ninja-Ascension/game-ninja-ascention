"""Le a tabela fun_open_condition e mostra todas as colunas dos botoes da tela FIGHT.

O cadeado do ExploreWindow (tela FIGHT) vem de funOpenDrawTip
(EnvironmentDatas.lua:5202). As colunas que bloqueiam sao:
  level, vip_level, scene_id, npc_id, open_day, union_level
Este script imprime os valores crus para nao adivinhar indices.
"""
import io

CAMINHO = 'N:/01_conteudo_apk/assets/res/data/mould/fun_open_condition.txt'
ALVOS = {'91', '92', '93', '94', '186', '187', '188', '189', '190'}

linhas = io.open(CAMINHO, encoding='utf8', errors='replace').read().splitlines()

print('=== cabecalho (2 primeiras linhas) ===')
for linha in linhas[:2]:
    print(repr(linha))

print()
print('=== linhas dos botoes da tela FIGHT ===')
for linha in linhas:
    campos = linha.split('\t')
    if campos and campos[0].strip() in ALVOS:
        print('id=%-4s campos=%d' % (campos[0].strip(), len(campos)))
        for i, valor in enumerate(campos):
            marca = ''
            if i == 3:
                marca = '  <- level'
            elif i == 4:
                marca = '  <- vip_level'
            elif i == 7:
                marca = '  <- scene_id'
            elif i == 8:
                marca = '  <- npc_id'
            elif i == 9:
                marca = '  <- ? (open_day?)'
            elif i == 10:
                marca = '  <- ? (union_level?)'
            print('    [%d] %r%s' % (i, valor, marca))
        print()
