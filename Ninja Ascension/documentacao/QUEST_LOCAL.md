# Quest diária local

Implementado em `quest_local.py`: `daily_mission_init`, `draw_daily_mission_reward` (uma ou várias tarefas) e `draw_liveness_reward`. Catálogo, requisitos e recompensas vêm de `daily_mission_param` e `active_reward`; não usa o arquivo ausente `daily_task_mould` para fabricar dados.

Renovação local às 05:00 UTC. Estado por conta/dia, progresso e recibos no SQLite. Uma recompensa só é concedida uma vez por dia; repetição devolve o estado atual e a descrição do prêmio, sem conceder novamente. Resgate múltiplo inválido faz rollback inteiro. Itens, EXP, Ryo, gold, honra, pontos da prova, contribuição do clã, talentos e essência têm armazenamento persistente. EXP usa o armazenamento já lido pelo login; esta mudança não redefine nível, conta, formação ou recursos.

Progresso medido após comandos com sucesso, por diferenças persistidas: recrutamento normal, abertura de baús, compra na General Shop, gold gasto, primeira conclusão de cada NPC e primeira melhoria de qualidade já implementada. Login/recompensas diretas usam condição 25; tempo online conta desde a primeira atividade registrada no dia. Sistemas não implementados não geram progresso fictício. Progresso anterior à instalação não é reconstruído sem evidência de data. Batalhas repetidas contra o mesmo NPC ainda precisam de um registro de conclusão por batalha para contar além da primeira vitória.

Cliente: extensão 15992 substitui a lista e chama o parser original 361, atualizando as células e avisos. A lista diária local não exige o antigo desbloqueio após a fase 3-3. Incluída dependência explícita de ActionUtils e omitidas tarefas artificiais de assinatura mensal sem assinatura local. Tutorial permanece desativado.

Limites: a aba de conquistas/história é um fluxo separado (`PlotTaskWindow`, tabela `achieve`) e ainda precisa de catálogo/progresso/resgate próprios. Fontes de progresso de arena, prova, clã, habilidades e outras atividades dependem de seus sistemas. O saldo adicional de talentos/essência recebido aqui é enviado no login e na atualização de Quest; futuros consumidores precisam atualizar esse mesmo armazenamento.

Testes: `tools/test_quest_local.py` (resgates, repetição, rollback, progresso por recrutamento/baú, renovação e persistência) e `tools/test_quest_native.py` (tela, células reais, estados salvos e resposta de recompensa). Dados de teste ficam em bancos temporários, sem gasto na conta do jogador.
