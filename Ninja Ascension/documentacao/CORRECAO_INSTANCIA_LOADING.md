# Carregamento e criação dos participantes — 24/10/2026

O log de 19:27:46 registra uma ação do inimigo na posição 6, onda 1,
mas a formação visual inimiga está vazia. Os dados possuem duas ondas e
os seis espaços visuais existem. Isso não prova que os personagens foram
criados: uma exceção anterior pode interromper a montagem.

O mesmo teste registrou erros na abertura de ActivityWindow, no painel
Panel_battle_hand e em FightUI.changeBattleHetiState. Portanto a batalha
completa ainda não está validada.

## Alterações

- O escopo de pré-carregamento segue os argumentos do contrato original
  (`baseWindow` presente, `loginIn == false`), sem depender do nome do peer.
- Ao anexar LoginLoading, reaplica os métodos corrigidos à instância nativa.
  Window.new copia métodos; mudar apenas a classe não atualiza peers antigos.
- nextBattle, initHero e initMaster registram início, resultado e traceback
  completo de falha em build/probe-writable/battle-lifecycle.log.
- Uma ação sem participante continua produzindo erro explícito; nenhum
  personagem ou resultado de combate é inventado para contornar a falha.

## Validação

tools/test_battle_lifecycle.py passou, incluindo peer com métodos antigos,
limpeza do escopo após exceção e preservação da falha original de construção.
Os sete casos nativos de tools/test_layout_editor.py retornaram zero;
resultados em build/layout-tests-18e65fb88ae54dcfafc8313283fb9e41/results.json.
Esses testes não percorrem todo o tutorial autenticado.

As alterações são Lua carregado do workspace. Fechar e abrir o jogo pelo
port/server/jogar_local.bat é necessário para carregar os métodos novos.
No próximo percurso, verificar o primeiro FAILED do battle-lifecycle.log,
e não apenas o erro posterior Missing actor.

## Falha identificada no novo percurso de 19:36

initHero falha em FightQTEController.addRole, linha 696: ListView não tem
refreshView. Isso interrompe nextBattle antes de initMaster; portanto os
dados inimigos existem, mas a formação visual permanece vazia.

boot_map.lua agora adapta refreshView para requestDoLayout + forceDoLayout,
e requestRefreshView para requestDoLayout. A implementação foi comparada
com UIListView.cpp do Cocos 3.5 e com o caminho de layout do Axmol instalado.
Não é uma função vazia: recalcula o layout dos retratos. O teste nativo
render-contract cria três itens e verifica que suas posições são atualizadas.

## Percurso de 19:54 — atores criados, ataque interrompido pelo HUD

O log confirma initHero e initMaster concluídos, com três aliados e cinco
inimigos registrados. A falha seguinte é Panel_battle_hand ausente em
FightQTEController.onEnterTransitionFinish; o layout contém
Panel_battle_hand_pr2. A exceção impede inicializar totalHurtRoot, que é
acessado durante o ataque e causa outra exceção às 19:55:07.

FightUI.changeBattleHetiState também procura Button_htj_tg e
Panel_hetijiguangx; os nomes reais terminam em _pr1. Foram adicionados
aliases explícitos para esses três nós, inclusive na busca de descendentes
que aceita o sufixo *actionTag. O teste nativo verifica esses nós e o
container Panel_bishashanghai nos layouts originais da batalha.

## Percurso de 20:07 — contador de golpes

O primeiro erro do contador ocorre em DrawHitDamage:509 ao procurar Panel_4.
Os dois layouts injury_settlement_batter possuem Panel_4_pr2. A montagem é
interrompida antes de preencher self.actions; playExitAction:370 falha
depois repetidamente porque self.actions[1] não foi criado.

Foram adicionados aliases explícitos para Panel_4, Panel_hetiji_1,
Panel_hetiji_2 e Panel_right, conforme os nomes reais nos layouts.
Os últimos três também corrigem as falhas registradas em FightUI:2488,
FightUI:1163 e SkillCloseupWindow:145. A busca exata continua prioritária.

Validação: sete casos nativos passaram, incluindo os dois layouts do
contador, a existência de combo_damage_move_xs nas timelines e os painéis
das habilidades. Resultados:
build/layout-tests-aa07b06d955d4584abb2d7aabbe0ed5c/results.json.
O combate completo ainda requer validação no percurso autenticado.
