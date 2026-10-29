"""Mostra a resposta bruta que o servidor local devolve para comandos pendentes.

`local_server.despacha` nao exige sessao: ela e montada pelo proprio login.
Objetivo: saber se union_info chega com campos ou vazio, porque o cadeado da
tela FIGHT depende de _ED.union.union_info.union_grade
(EnvironmentDatas.lua:5286).
"""
import sys

sys.path.insert(0, 'N:/port/server')

import local_server as srv  # noqa: E402

comandos = ['union_init', 'artifact_init', 'user_card_info_init',
            'union_list', 'user_card_info_activate', 'file_island_task_info']

for indice, cmd in enumerate(comandos, start=1):
    pedido = '%d\r\n%s\r\n' % (indice, cmd)
    try:
        resposta = srv.despacha(pedido)
    except Exception as erro:  # noqa: BLE001
        print('%-24s ERRO %s' % (cmd, erro))
        continue
    campos = resposta.split()
    print('%-24s %d campos' % (cmd, len(campos)))
    print('    %r' % resposta[:200])
    print()
