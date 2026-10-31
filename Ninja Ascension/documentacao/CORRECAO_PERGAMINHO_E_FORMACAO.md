# Pergaminho de Recruit e reabertura da formacao

## Pergaminho

Causa: as telas legadas liam os slots 13/14 de pirates_config 273, que estao como -1 neste APK. O item valido e o 239, indicado por shop_config 4. O servidor legacy_recruit_local so descontava moedas; o uso do item existia apenas no recrutamento novo.

Corrigidos os contadores/validacoes nas duas telas e a cobranca do servidor legado. Depois da gratuidade diaria, 1 pergaminho paga 1 giro premium e 10 pagam o lote de 10. Sem quantidade suficiente para o lote, permanece a compra integral por gold da regra existente, sem consumo parcial dos pergaminhos. O Recruit por Ryo nao consome esse item.

Consumo, premio e recibo ficam na transacao existente. A atualizacao da bolsa usa parser 6024, sem apresentar o item gasto como premio. O botao de repetir no resultado mostra o custo em pergaminhos quando aplicavel.

Testes: test_recruit_ticket.py passou para 1x, 10x, repeticao, falta do decimo item, alternativa em gold, prioridade da gratuidade e rollback forcado. Parser real no executavel confirmou 11 -> 10 pergaminhos e gold inalterado.

## Formacao

Reproduzido no executavel Release, com perfil temporario: abrir, fechar, reabrir produzia encerramento nativo 0xC0000005 (3221225477). Evidencia antes: jogo/build/formation-reopen/trace-before.txt e native-before.log.

O cache g_formationTigerGate mantinha um retain do objeto depois de fwin fechar e limpar seus recursos nativos. Verificar apenas tolua.isnull nao detectava essa janela parcialmente destruida. O adaptador agora marca o fechamento, libera a referencia do cache e cria uma janela nova; a abertura termina no proximo ciclo do fwin, depois da inicializacao da lista de icones. Dependencias reais das verificacoes de equipamento sao carregadas antes de abrir.

Testes: test_home_formation_reopen.py abriu/fechou a tela real tres vezes sem access violation. Trace e logs em jogo/build/formation-reopen. Teste de slots de formacao e regressao do tutorial passaram.

A suite antiga de Recruit foi atualizada para reconhecer o bounty original nas conversoes de ninja repetido em fragmentos, comportamento que ja existia antes desta correcao. Nenhuma regra de premio/probabilidade foi alterada nesta tarefa.

## Preservacao e validacao

Nenhuma concessao, compensacao ou reset feito em contas reais. Backup pela API SQLite e hashes de ItachiBR, RenegadoBR e Aeglos, verificados por backup_quick_upgrades.py. Fontes Lua alteradas compiladas em Lua 5.1. Testes de recrutamento normal, legado, tutorial e slots passaram. O teste nativo foi no PC; conferencias manuais no jogo do usuario e no Android permanecem necessarias.
