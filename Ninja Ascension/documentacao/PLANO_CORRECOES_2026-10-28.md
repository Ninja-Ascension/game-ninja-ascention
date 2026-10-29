# Revisão do jogo — 28/10/2026

Fonte: lista e sete imagens enviadas pelo usuário. Usar código, recursos e tabelas originais. Não inventar regras ou recompensas ausentes. Preservar contas. Testar operações em banco temporário, inclusive repetição. Publicar e reiniciar apenas após testes.

## Prioridade 1 — resolução
- [x] Removidas compensações de escala/posição por tela. Base original 960x640 com proporção uniforme no PC (SHOW_ALL no Axmol), Android mantém escala nativa original. Publicado em 28/10; servidor reiniciado PID 15464. PC validado em 960x640, 1280x720 e 800x600; Lua 5.1 válida. Validação visual das abas e Android fica com o usuário. No Android, após baixar os módulos, fechar e abrir novamente para carregar a alteração. Demais correções abaixo permanecem pendentes.

## Ninja
- Confirmados pelo usuário: filtro; arma (upgrade, awaken, quench); melhora (advance, upgrade, promote, skill, cursed seal).
- [ ] Ninja Soul: aguardando teste visual do usuário. Implementados inventário persistido, inicialização original 14130/14131, equipar/desequipar/transferir entre ninjas, bloqueio, validação de posição/propriedade e repetição por recibo. Atributos básicos persistidos entram no cálculo do servidor. Entregues quatro Souls nível 0, qualidade 3, conjunto 1, posições 1–4 ao RenegadoBR (IDs 1–4), via concessão administrativa única autorizada; atributos selecionados das bibliotecas originais, sem alegar probabilidades de sorteio. Demais ações (fortalecer, despertar, refinar, sintetizar e decompor) permanecem não implementadas; não marcar o sistema completo como pronto. Efeitos de conjunto em combate ainda precisam de revisão.
- [ ] Eight Gates: verificação de servidor passou (desbloqueio, dez upgrades, custos, limites, requisitos e repetição). Aguardar conclusão de Ninja Soul antes de avançar na sequência.
- Publicação deste lote: 28/10, servidor PID 12468. Backups consistentes antes da concessão e antes do reinício; demais dados protegidos conferidos sem alterações. Auditoria: jogo/build/soul-test-grant-20261028.json. Teste: jogo/tools/test_fight_spirit_local.py.

## Bag
- Confirmado pelo usuário: OK.

## Recruit
- [ ] Restaurar animação do personagem no draw individual (Naruto invisível no print).
- [ ] Restaurar centralização e espaçamento original do draw 10x.
- [ ] Corrigir escala dos personagens no draw individual (Gai muito grande).
- [ ] Corrigir compra de ninja por moedas do recruit.

## Shop
- [ ] Investigar tokens de troca ao abrir.
- [ ] Corrigir erro ao abrir troca.
- [ ] Corrigir rolagem que retorna ao início em General, Arena, Trial e Clan Shop.

## Quest
- [ ] Corrigir resgate de stamina que dá erro e mantém carregamento.

## Fight / Arena
- [ ] Nome do adversário no desafio.
- [ ] Skip conforme tempo e VIP originais (comparar configurações).
- [ ] Recompensas visíveis e animação do pergaminho encerrando.
- [ ] Battle report com vitória/derrota e replay persistido.
- [ ] Entrega de pontos.
- [ ] Liberar demais modalidades dessa categoria para testes, de forma explícita e reversível; registrar regras originais.

## Ninja School
- [ ] Mudra 1x/10x deve revelar itens de mudra, como no 50x, conforme protocolo original.
- [ ] Shamanism treino 10x.
- [ ] Aid team.
- [ ] Ranking de Ninja Saga.
- [ ] Equipar técnicas de Tailed Beasts.

## Trial Room
- [ ] Great Shinobi: Ryo Challenge até Skill Challenge.
- [ ] Ninja Trial.
- [ ] White Zetsu Army vazio.
- [ ] Daily Tower e Weekly Tower carregando sem concluir.

## Adventure
- [ ] Claim all das caixas.
- [ ] Conferir ganho de chamas nas tabelas originais.
- [ ] Auditar inclusão das fases e respectivas recompensas originais; distinguir dados disponíveis de lógica ausente do servidor.

## Clan / social / login
- [ ] Doação não abre.
- [ ] Organize assistance dá erro.
- [ ] Kakashi Hatake slot.
- [ ] Friends: adicionar, aceitar, enviar e receber stamina.
- [ ] Sign in: conferir prêmios semanais, diários e acumulativos.

## Evidência inicial
- APK original NinjaRevolution-1.1.1-32bits.apk: app.config define winSize/designSize/resourceSize 960x640, frameSize 909x512, política FIXED_HEIGHT. O framework calcula uma escala uniforme pelo menor eixo.
- Port PC: desktop_layout força EXACT_FIT e acrescenta compensações horizontais e reposicionamento por tela. Essas adaptações precisam ser retiradas para recuperar a geometria original.
- Não marcar testes existentes como aprovação automática: reproduzir os erros e verificar os fluxos reais.

## Reset autorizado de Eight Gates — RenegadoBR
- 28/10: zerados 1.088 portões de 136 ninjas apenas do RenegadoBR; 38 recibos antigos preservados e invalidados. Nenhum saldo, material ou outro progresso alterado. Backup SQLite e comparação completa com o backup confirmaram o escopo.
- Corrigida apenas no PC a exibição do fragmento no custo tipo 6; o cliente usava a categoria 1 como molde de item.
- Teste temporário: reset, recusa de repetição anterior ao reset, novo desbloqueio e saldo preservado passaram. APK não reconstruído.

## Advance e Recruit — 28/10
- Usuário confirmou Portões e Ninja Soul funcionando.
- Advance do Sasuke 382 já está em 24/24 (limite da biblioteca original grupo 19); corrigido no PC o progresso 0/0 para 24/24, sem reset de avanço. Teste de custos/idempotência de Advance passou.
- Recruit PC: retirado multiplicador extra 1,8; esqueleto animado existente é transferido do painel fora da tela para o painel visível. Resumo 10x centralizado pelo tamanho real das células. Falta validação visual do usuário.
- Implementado new_recruitment_shop_buy (comando original 9329), antes ausente. Usa new_draw_card_shop, custo 3105, limites semanais da tabela, persistência e recibos contra repetição. Conversão de ninja repetido reutiliza a regra local já existente no draw. O início da semana usa calendário ISO sobre o dia de reset existente do servidor; o cliente só informa limite semanal, sem regra de virada recuperada. Teste temporário passou: compra, saldo, repetição, limite, moedas insuficientes e ninja repetido.
- As outras abas permanecem pendentes na ordem da lista. Sem reconstruir APK.

## Retorno Recruit — 28/10
- Usuário confirmou draw 10x e compra por moedas funcionando.
- PC 1x: Button_ok habilitado e ligado ao terminal original de retorno, uma única vez por clique, sem novo sorteio/cobrança.
- Pergaminho: abertura effect executa uma vez e muda para effect_loop no evento real de conclusão. Aceitar após a última página fecha a janela uma vez.
- Verificação Lua do clique/fechamento e sintaxe passou. Publicado, servidor PID 35272. Validação visual pendente do usuário. APK não reconstruído.

## Shop — 28/10
- Recruit 1x permanece pendente; usuário pediu para voltar nele depois. 10x e compra Recruit confirmados funcionando; pergaminho aguarda confirmação.
- Shop: corrigido shop_frags_init com linha vazia final conforme pedido real do cliente.
- Baús: 1 token (jade) por abertura, regra confirmada explicitamente pelo usuário; 10x entrega 10. Transação e recibo existentes impedem duplicação; falha de compra não concede tokens. Sem compensação retroativa.
- PC: SmShopTab usa setInnerContainerSize para manter limites de rolagem corretos nas lojas Geral/Arena/Trial/Clan e conserva a posição ao atualizar. Corrigido também o clamp das setas.
- Teste temporário de compras/troca/saldo/repetição/abertura com linha vazia passou; Lua compilada. Visual da rolagem fica para usuário. Publicado, servidor PID 18428, sem reconstruir APK.
- Próxima etapa: Quest / resgate de stamina.

## Retorno da rolagem Shop
- Correção anterior insuficiente, confirmado pelo usuário. PC: interrompe inércia pendente, fixa eixo horizontal, desativa bounce e inércia, propaga arraste dos widgets internos ao ScrollView.
- Teste nativo isolado no CSB real shop_listview_tab_2.csb: viewport 900, conteúdo 2000, movimento programático a 25% conservou X=-275 após 1 segundo. Não foi teste de arraste físico nem validação das quatro lojas completas. O teste anterior sem essas opções também conservava posição programática: ainda precisa da confirmação do usuário sobre o arraste real. Hook temporário do host_logo removido antes da publicação.

## Causa comprovada no vídeo / rolagem lateral
- Vídeo unknown_2026.10.28-14.48.mp4 mostra retorno ao soltar o arraste. Native Release confirmou getTargetPlatform()=1, mas cc.PLATFORM_OS_WINDOWS=0. Todos os ifs anteriores de PC da Shop estavam inativos.
- SmShopTab e SmShopPropBuyListView agora detectam o bridge nativo PC (cc.nrSpineCommand), preservando o Android. Isso ativa de fato as correções de limites, propagação, inércia e setas.
- Teste nativo executou o bloco real extraído de SmShopTab.lua no CSB original: opções PC ativas e X=-275 conservado após 1 segundo; sintaxe dos dois Lua válida. Não houve alteração em compras nem contas. Hook de diagnóstico removido.
- IMPORTANTE para próxima etapa: os guards por PLATFORM_OS_WINDOWS também existem nos fixes de Recruit, Advance e DrawRareReward e podem estar inativos pelo mesmo motivo. Usuário adiou Recruit 1x; não alterar enquanto a tarefa atual for só Shop.

## Quest — stamina / 28/10
- Usuário confirmou rolagem da Shop funcionando.
- Causa do resgate: dinner_time obrigatório não implementado. Agora dinner_time/dinner_init/power_swallow usam identidade autenticada e estado persistido por conta/dia/período.
- activity_config linha 1: quatro períodos 09–11, 12–14, 18–20, 21–24; 60 stamina cada. Linha 2: recuperação de período vencido custa 20 ouro. Reset 05:00 conforme ActivityAddEnergy.lua; UTC acompanha o dia atual usado pelo servidor local. Período futuro e conta criada após o período são recusados.
- Login também devolve flags persistidos (194), evitando reexibir resgates após reconectar. Repetição de resgate não entrega stamina nem cobra novamente. Nenhum saldo de jogador alterado pela implementação.
- Testes temporários test_dinner_time.py e test_energia.py passaram; Python compilado. Publicador executado (sem mudança de cliente); servidor reiniciado PID 14908. Sem construir APK.
- Próxima etapa: Fight/Arena na ordem original da lista.

## Arena — auditoria e correção segura de histórico, 28/10
- Conferido o APK original 64 bits em origem_apk. O callback pede nType/time, exige response.node.roots[1], marca playback e abre luta tipo 11. ProtocolCommander deste APK declara 6137 para o nome battlefield_report_battle_info_get (diferente do número 6125 informado); mantido o nome real do comando.
- Removida a reconstrução de uma nova luta a partir do snapshot do adversário no callback de replay. Relatórios antigos sem dados históricos retornam erro explícito.
- Criado armazenamento local opcional dos pacotes reais completos 182/39, com checksum, acesso por conta e timestamp exclusivo. Não é o formato recuperado do servidor original. O motor incremental do PC também produz dados por ação/round que NÃO equivalem ao relatório completo 39; nesse caso não é salvo replay. Reprodução histórica integral continua pendente, não validada no jogo.
- Corrigida a identificação do PC em DrawRareReward: a ponte nativa substitui a comparação incompatível de enum de plataforma. Ativa a abertura única e o fechamento já existentes; visual ainda depende do teste do usuário.
- test_arena_rewards.py passou em banco temporário: pontos de vitória/derrota, recompensas originais, liquidação repetida sem duplicação, relatório, isolamento entre contas e checksum. test_arena_replay_client.py passou com fixture de contrato (não certifica renderização real), sem simulação e mantendo roots/tipo 11.
- Compilação Lua 5.1 dos seis módulos envolvidos passou. Backup SQLite consistente anterior preservado; integridade e hashes das três contas protegidas conferidos.
- Não concluídos nesta etapa: replay do motor incremental, liberação funcional das outras modalidades de Fight, Ninja School, Trial Room, Adventure e Clan. Não marcar esses itens como funcionando com base nos testes de contrato.
- Publicação PC automática concluída. Reinício encontrou dois processos do mesmo local_server.py na porta 18080; ambos substituídos por uma instância PID 15232. Script de reinício agora trata múltiplas instâncias pelo caminho exato do projeto e usa taskkill após falha interna do Stop-Process. Integridade e contas protegidas confirmadas após o reinício; APK não reconstruído.

## Skip / replay — retorno 18:45–18:46
- Log real: crash 18:45:23 em FightRole.lua:7984, callback do buff 137 acessando params._self após remoção do efeito. Sete callbacks da mesma família agora conservam token e dono do buff em Lua, cancelam ao excluir o efeito e verificam se a batalha/dono/efeito ainda correspondem antes da limpeza. Mantidos os tipos e tempos originais. Não usa pcall para ocultar erro.
- test_skip_buff_cleanup.py passou: limpeza normal, cancelamento, batalha encerrada, efeito substituído e efeito destruído; módulo completo compilou em Lua 5.1. Validação visual do Skip ainda necessária.
- Replay 18:46:46 recusado por dados_historicos_de_replay_nao_disponiveis; não houve outro crash nesse pedido. Vitória liquidada às 18:46:36 com 2 pontos. Não há pacote completo gravado dessa luta; permanece indisponível sem simular nova luta.
- Backup SQLite API consistente 18:48:22 antes da publicação/reinício; nenhuma edição de progresso feita por esta correção.

## Armazenamento dos eventos reais da Arena — 28/10
- Pedido específico: criar o armazenamento. Arquivo físico: jogo/port/dados/contas.sqlite3; tabela local_arena_reports, coluna replay, chave id igual ao matchId. Sem novo banco e sem apagar relatórios anteriores.
- Novo envelope local version=2: matchId, win, initHex, events ordenados (kind/dataHex), archiveSha256. Guarda bytes efetivamente emitidos pelo motor original em rountdFight/fightObjectAttack/jumpFight/jumpCurrentFight e os pacotes de protocolo de batalha observados. Captura inicia antes de initBattleField; chamadas internas aninhadas não duplicam a saída. Não simula novamente e não altera valores de combate.
- Envio ocorre junto da liquidação existente de arena_launch; registro e pontos são persistidos na mesma transação. Repetir liquidação não sobrescreve o arquivo nem entrega pontos/tentativas novamente. MatchId é conferido; checksum verificado; limites 4096 eventos/1 MiB de bytes capturados no cliente; captura truncada é descartada sem impedir liquidação.
- Armazenamento versão 2 ainda não possui leitor de reprodução: pedido de replay retorna eventos_armazenados_reproducao_pendente. Não apresentar o diário como protocolo original de replay nem prometer reprodução histórica integral validada. Lutas antigas não são reconstruídas.
- Testes temporários passaram: eventos exatos, ordem, Skip, não duplicação de chamadas aninhadas, métodos/restornos originais conservados, descarte de captura truncada, checksum, liquidação repetida e persistência confirmada por segunda conexão SQLite. Lua dos dois módulos compilada. Backup consistente 18:52:45 e integridade/contas protegidas verificados.

## Leitor do replay armazenado — 28/10
- Implementado arena_journal_reader.lua para versão 2. Decodifica os bytes salvos com os separadores originais (preservando campos vazios), usa parse_environment_fight_role_round_attack_data e parse_environment_fight_round_attack_data para montar a fila histórica e aplica os protocolos de influências originais. Nenhum FightModule é criado, nenhuma seleção de alvo/dano é recalculada.
- Leitor conectado aos dois callbacks: Replay do relatório e Replay novamente na tela de resultado. Preservados o guard response.node.roots[1], os parâmetros nType/time, estado playback e entrada tipo 11. Extensão PC journal-v2 avisa ao servidor que o leitor está instalado; clientes antigos recebem aviso de atualização em vez de um arquivo incompatível.
- Servidor devolve o diário verificado e os nomes/formações/ranks do snapshot salvo daquela luta. Recuperação por conta e timestamp; chamadas repetidas de replay não liquidam luta nem entregam pontos/tentativas novamente. Lutas sem arquivo continuam recusadas.
- Luta real 6e56e9a84a6241bea3d0302341a42c75 lida do banco somente para teste: 19 eventos, 2 rodadas, 16 ações. Interpretada com os parsers atuais e também com ProtocolParserCopy.lua extraído diretamente do APK original64: ambos passaram. Diferenças existentes no parser atual em relação ao APK se limitam, nos trechos utilizados, a hooks battle_stats; não alterados nesta tarefa.
- Testes: inicialização histórica, duas leituras da mesma fila após consumo, sequência/campos dos ataques inalterados, formato Skip usando bytes reais de rodada, ausência de simulador/chamada de liquidação, checksum e compatibilidade com clientes antigos passaram. test_arena_rewards.py e test_skip_buff_cleanup.py passaram; quatro arquivos Lua compilaram em Lua 5.1. Renderização completa e controles ainda precisam de teste visual no PC do usuário.
- Backup SQLite consistente 19:14:42; integridade e contas protegidas verificadas. Não reconstruído APK nem restauradas lutas antigas sem dados.

## Nome do inimigo na Arena — retorno do usuário
- FightUI:updateDrawPlayerInfo preenchia Label_2p_name e depois apagava seu texto para substituí-lo por RichText no tipo 11. Isso também executava após o preenchimento inicial do cabeçalho, explicando a correção anterior insuficiente.
- PC: conserva o rótulo nativo do cabeçalho e usa o adversário da luta ativa ou o nome persistido em battleData no replay. O caminho de RichText do Android e as regras de nomes PvE permanecem existentes. Sem alteração de banco/progresso.
- test_arena_enemy_name.py passou para combate ativo, replay, nome numérico e PvE. Os três arquivos Lua envolvidos neste lote compilaram em Lua 5.1. Confirmação visual no PC do usuário ainda necessária.

## Continuação da lista — inspeção antes da prioridade do nome
- Acesso de teste ao menu Fight PC disponibilizado por port/resources/fight_test_access.json (enabled=false reverte). IDs 81,82,83,84,195,196. Não inventa respostas nem implementa modalidades ausentes no servidor.
- Regras originais de fun_open_condition: 81 Lv35/dia3; 82 Lv35/terceira terça após abertura; 83 Lv45/dia5; 84 Lv42/dia5; 195 Lv48/dia7; 196 Lv50/dia9. Tabela original preservada.
- Mudra, Shamanism 10x, Tailed Beasts e ranking Saga já possuíam correções no servidor. Testes temporários test_mudra_local.py, test_artifact_local.py, test_mythical_local.py e test_saga_local.py passaram nesta inspeção. Isso não substitui validação visual do usuário. Aid Team ainda em inspeção, sem nova alteração nesta etapa.
