# Sincronia e entrada no menu — 25/10/2026

## Sincronia

FightRole.changeActtackToAttackBegan atribui _actionIndex e _nextAction e
chama playWithIndex diretamente. Nesse caminho o callback inicial inicia
executeAttacking/efeitos e seleciona o próximo estado. Suprimir esse callback
para todos os nós atrasava a lógica até a conclusão da animação.

O adaptador agora preserva o início apenas para o nó principal de um
FightRole com dados de ataque ativos, índice atual/próximo correspondente
e fora de uma mudança reentrante. Nos demais nós, callbacks de conclusão
continuam restritos à conclusão real. As animações finitas permanecem
sem loop. O teste nativo cria o nó real, passa pelo callback original de
cocostudio e verifica um início imediato, sem segundo início após avançar
240 quadros. Isso não substitui verificar a sincronia visual no jogo.

## Entrada no menu

O log de 02:03:04 registra Menu.onEnterTransitionFinish → Loading.loading:75
→ TextureCache.addImageAsync com cinco argumentos. O binding instalado
aceita arquivo e callback(texture), enquanto o cliente usa
arquivo, callback(target,texture), target, flags.

texture_async_compat.lua adapta a assinatura e preserva o carregamento
assíncrono nativo. O teste usa o Loading.loading original e uma textura
real. A suíte exige MENU_RESOURCE_LOADING_PASSED para aprovar o caso nativo.

Validação: tools/test_damage_hooks.py passou. Os sete casos nativos passaram
em build/layout-tests-8c4419d106704290a80ec42d77ef945b/results.json.
Uma execução anterior teve timeout no caso de escrita de layout, repetido
com sucesso. Não foram alteradas contas ou forçados eventos de conclusão.

Pendente: confirmar visualmente a entrada no menu após a luta, executar
as missões seguintes e auditar a persistência do progresso após reiniciar.
