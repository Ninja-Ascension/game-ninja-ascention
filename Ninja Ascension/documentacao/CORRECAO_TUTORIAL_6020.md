# Tutorial: estado de fases ausente — 24/10/2026

O erro antigo do nome do NPC foi corrigido por `c87778e` (carregamento de
`word_mould`) e `0eac6f9` (carregamento de `npc`). A execução seguinte falhou em
`Mission.lua:2283`: `pairs(_ED.scene_max_state)` recebia uma string.

`EnvironmentDatas.lua:1345` inicia o campo como string. O parser de batalha
182 não preenche o progresso das fases. O parser ORIGINAL 6020
(`ProtocolParserCopyExx.lua:54`) recebe quatro vetores e cria as tabelas usadas
pelo callback da missão. A resposta de `battle_result_start` era só um ACK:
o callback corria sem ter recebido esses dados.

## Correção

O início específico do tutorial (cena 1, NPC 1196) agora inclui S2C 6020
antes da execução do callback. `dados_batalha.estado_inicial_cenas()` consulta
os IDs de `pve_scene.txt`. Política local explícita: capítulo 1 aberto,
demais capítulos bloqueados, zero estrelas e recompensas. Não é progresso
recuperado de um servidor nem implementação da progressão persistente.
Outros confrontos não recebem essa reinicialização.

Nenhum script, layout ou dado original foi modificado. Não há mudança de
esquema ou escrita no banco de contas do jogador.

## Validação executada

- `tools/test_tutorial_state.py`: passou. Usa banco temporário no E:, chama o
  handler real e verifica a resposta; executa o arquivo de parser ORIGINAL
  com a DLL LuaJIT do jogo, confirma consumo exato dos tokens e o contrato
  de tabela exigido por `Mission.lua`.
- `tools/test_sessao_perfil.py`: 35/35 verificações passaram.
- Os testes com SQLite exigiram execução fora do token restrito, que não
  conseguia abrir o banco temporário. O banco real foi preservado.

## Repetir na aplicação

Fechar e reiniciar o servidor local para carregar os fontes Python novos;
reabrir o jogo e entrar na conta existente. Não precisa recompilar C++.
Conferir o tutorial e o primeiro erro novo, se surgir. O avanço visual completo
do tutorial ainda não foi testado nesta rodada.
