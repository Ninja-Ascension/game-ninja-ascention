"""Descobre o primeiro NPC do mapa (o lobo) e se ele tem dados de batalha.

O tutorial esta desativado, entao o jogador entra direto no mapa/campanha.
O primeiro NPC e o de menor id em pve_scene / npc com formacao valida.

Le as tabelas originais e testa montar_parser_182 para cada canditado.
"""
import sys

sys.path.insert(0, 'E:/[code]/nk/port/server')
import dados_batalha as db

print('=== NPCs com formacao nas tabelas ===')
try:
    tabela_npc = db.tabela('npc.txt')
    print('npc.txt: %d linhas' % len(tabela_npc))
except Exception as exc:
    print('npc.txt:', exc)
    tabela_npc = {}

try:
    pve = db.tabela('pve_scene.txt')
    print('pve_scene.txt: %d linhas' % len(pve))
except Exception as exc:
    print('pve_scene.txt:', exc)
    pve = {}

# Colunas conhecidas de npc: 1=id, 2=nome... verificamos montando o parser.
print('\n=== testando montar_parser_182 para os primeiros NPCs ===')
ids = sorted((k for k in tabela_npc if str(k).isdigit()), key=int)[:12]
for npc_id in ids:
    try:
        formacoes, nome = db.formacao_do_npc(str(npc_id))
    except Exception as exc:
        print('  npc %-5s ERRO formacao_do_npc: %s' % (npc_id, exc))
        continue
    jogador = [{'_id': '1', '_pos': '1', '_head': '1', '_power_skill_id': '0',
                '_fit_skill_id': '0', '_quality': '1', '_hp': '10000',
                '_sp': '0', '_type': '0', '_mouldId': '0', '_scale': '1',
                '_name': 'Kage', '_evolution_level': '0', '_hero_speed': '100',
                '_max_hp': '10000'}]
    try:
        toks = db.montar_parser_182(str(npc_id), '0', jogador, 'Kage', 10000)
    except Exception as exc:
        print('  npc %-5s nome=%-12s parser 182 ERRO: %s' % (npc_id, nome, exc))
        continue
    estado = ('%d tokens' % len(toks)) if toks else 'SEM FORMACOES -> None'
    print('  npc %-5s nome=%-12s formacoes=%s  %s'
          % (npc_id, nome, formacoes, estado))
