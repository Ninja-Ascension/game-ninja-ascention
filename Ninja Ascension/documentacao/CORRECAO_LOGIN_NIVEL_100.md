# Abnormal data após nível 100 — 25/10/2026

A primeira falha registrada foi EnvironmentDatas.lua:5273, funOpenDrawTip:
scene_current_state era nil. O nível alto permite chegar a verificações que
o nível baixo interrompia antes por curto-circuito. Não foi demonstrado
overflow do saldo de Ryo; 900 milhões cabe no formato numérico utilizado.

O parser de login dispara verificações de funções/atividades antes de o
restante da resposta terminar de ser lido. Agora o bloco original 6020,
independente do perfil, inicializa as fases ANTES do parser 3. O campo 8 do
perfil também contém o vetor completo real de NPCs, não somente sete zeros.
As fases, estrelas e vitórias vêm do banco; não foram concedidas vitórias.

test_login_layout_native.py agora limpa as tabelas de fase antes de ler o
login (o setup anterior pré-inicializava essas tabelas e mascarava o defeito).
Passaram inventário vazio, com itens e perfil nível 100 com 900 milhões de
Ryo, 1 milhão de Gold e 10 mil de stamina. Log: build/login-layout-level100.log.

O servidor foi reiniciado. Banco/conta não foram alterados pela correção.
Não reduzir recursos, apagar a conta ou religar tutorial como contorno.
O teste é dos parsers; áreas de nível alto ainda precisam de testes próprios.
