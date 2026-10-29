# Pré-carga do combate e contrato dos participantes — 24/10/2026

O fundo “Event” tem origem identificável no carregador:
`LoginLoading:loadingActivity()` abre `activity_window_open` e logo em seguida
executa `activity_window_hide`. A abertura pode passar por `Loading.loading`
e só abrir depois do hide e da limpeza das camadas da batalha. A pré-carga
de formação também abre uma janela real (`formation_open_instance_window`).

`battle_lifecycle.lua` isola a chamada `checkLoginLoading(baseWindow,false)`
quando baseWindow é um FightLoadingCell. Nesse escopo, carrega os módulos de
atividade/formação e marca suas etapas concluídas, sem instanciar janelas de
menu. A pré-carga e abertura normal fora da batalha continuam originais.
Não há um loop escondendo janelas nem bloqueio global do sistema de eventos.

O controlador também recebe uma fronteira tipada para lado/assento, convertendo
identificadores numéricos válidos para as chaves string exigidas pelo código
original. Não são fabricados participantes. Se o assento não estiver no
elenco renderizado, a ação falha explicitamente e registra lado, assento,
onda, chaves dos elencos, heróis/ondas recebidos e quantidade de slots em
`build/probe-writable/battle-lifecycle.log`. Esse diagnóstico ainda precisa
ser conferido no próximo teste da conta, se o participante continuar ausente.

## Testes executados

- `tools/test_battle_lifecycle.py`: passou no LuaJIT do jogo, cobrindo o
  escopo da pré-carga, preservação do caminho normal, restauração após erro,
  identidades de atores e erro explícito para participante ausente.
- Suíte nativa: sete casos com saída 0 em
  `build/layout-tests-8c8b5bd2e9014be287e507d6d03723b5/results.json`.

Não foi feita validação visual completa da conta nessa rodada. A skill de
computer use foi consultada, mas o kernel falha na inicialização por causa
do caminho com colchetes do workspace. Não foi usado outro método de
automação de interface como contorno.

Mudanças apenas em Lua: reabrir o jogo carrega o adaptador; não precisa
recompilar nem reiniciar o servidor. Contas e recursos originais preservados.
