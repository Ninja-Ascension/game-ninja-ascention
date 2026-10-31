# Auditoria da lista de funcionalidades

Inspeção do checkout atual e execução de 18 testes selecionados. Não houve edição do jogo, alteração de contas, publicação ou reinício. Os testes usam bancos temporários. Logs desta rodada: `jogo/build/auditoria-lista/`.

## Como interpretar

- **Base presente:** há implementação; o OK informado pelo usuário é mantido para o fluxo que ele testou. Não significa certificação de todas as ações ou de PC e Android.
- **Teste passou:** execução automatizada nesta auditoria, sem comprovar aparência ou interação no jogo.
- **Parcial:** existem ações ou regras explicitamente ausentes.
- **Revisar:** exige validação adicional, decisão de regra ou correção.

## Comparação com a lista

| Área | Estado encontrado | Evidência / restante |
|---|---|---|
| Weapon: upgrade, awaken, quench | Base presente; manter OK informado | `equipment_local.py`, `equipment_development_local.py`; não reexecutados nesta rodada. |
| Ninja: advance, upgrade, promote, skill, cursed seal | Base presente; manter OK informado | Módulos `hero_*`; documentação registra confirmações e correções anteriores. Não revalidados integralmente nesta rodada. |
| Eight Gates | Base presente; manter OK informado | `hero_gates_local.py`; custos e requisitos documentados. |
| Ninja Soul | **Parcial, apesar do OK da lista** | Equipar, retirar, transferir e bloquear implementados; teste `fight_spirit_local` passou. Fortalecer, despertar, refinar, sintetizar e decompor não estão cobertos pela implementação; conjuntos em combate precisam de revisão. |
| Bag: abertura | Base presente; manter OK informado | Uso de itens e baús nos módulos de inventário/loja. |
| Bag: venda | **Implementada e testada agora** | `prop_sell` em `shop_local.py`; `prop_sales_local` passou, incluindo saldo, inventário e repetição. Falta aceite visual. |
| Recruit: 1x / 10x | Base presente; OK informado pelo usuário | Documentação antiga mantém pendências visuais do 1x. A confirmação atual do usuário é mais recente; não houve reprodução visual nesta auditoria. |
| Recruit: shop | **Implementada e testada agora** | `recruit_shop_local.py`; teste passou. A pendência de compra na passagem antiga foi superada. |
| Daily Quest | Implementada; **horário ainda em revisão** | Reset definido em `quest_local.py` como 05:00 UTC. Teste de data não executou o cenário: falta `01_conteudo_apk/assets/src/cocos/cocos2d/json.lua` no caminho esperado. É bloqueio do teste, não prova de defeito no resgate. |
| Main Quest | Implementada para condições e prêmios suportados | `main_quest_local` passou: ordem, progresso, prêmio único. `achievements_local.py` aceita prêmios de tipos 1, 2, 6 e 7; condições não rastreadas e outros tipos continuam limitados. Não certificar toda a cadeia. |
| Fight: Arena | Implementada; teste de recompensas passou | Há armazenamento e leitor de replay histórico. Relatos antigos sem arquivo não são reconstruídos. Replay/renderização e controles exigem validação visual; Arena 5x é recusada explicitamente. |
| Fight: outras modalidades | **Ainda não completas** | Abrir botão por configuração de teste não implementa modalidade. Conservar condições originais de nível/dia e auditar cada fluxo. |
| Ninja School: Index | Implementado com limite | `index_local` passou. Cartas combinadas com condições especiais são recusadas explicitamente. |
| Talent, Mudra, Shamanism, Sculpture Mountain, Team Spirit | Base presente; OK informado | Módulos específicos e testes disponíveis. Não reexecutados nesta rodada; existem regras reconstruídas documentadas, sem prova de equivalência integral ao servidor oficial. |
| Achievements | Implementado parcialmente por fonte de progresso | Calcula tipos registrados pelo servidor; tipos sem rastreamento continuam em zero. OK da interface não certifica todas as conquistas. |
| Ninja Tool / Combo Card | Manter OK informado, sem certificação adicional | Esta rodada não verificou todas as ações dessas abas. Não confundir Combo Card com as condições especiais das cartas do Index. |
| Aid Team | **Implementado e testado agora, com limites** | `soul_guard_local.py`; desbloquear, melhorar e escolher ninja. Teste passou. Percentuais extras de evolução/qualidade/outros ficam em zero por falta de regra recuperada. |
| Ninja Saga | Base presente; manter OK informado | `saga_local.py`, incluindo ranking. |
| Tailed Beasts | **Parcial, apesar do OK da lista** | `mythical_local` passou; ativação, estrelas, forja e técnicas presentes. Destino continua explicitamente não implementado. |
| Trial Room: Great Shinobi | **Implementação adicionada** | `great_shinobi_local` passou; desafios usam catálogo original de cenas. Falta validação visual completa. |
| Trial Room: Ninja Trial | **Implementação presente, revisão obrigatória** | Inicialização, liquidação, progresso e recompensas existem. Teste de baús passou; teste principal falhou ao extrair NPCs da resposta inicial. Investigar contrato/teste antes de atribuir a falha ao jogo. |
| Trial Room: White Zetsu | **Parcial** | `worldboss_local.py` só fornece estado vazio, sem agenda de surgimento. Há fluxo adicional em `purify_local.py` com formação, equipe, tentativas e confirmação de vitória; matchmaking e conteúdo de baús pagos não estão completos. |
| Trial Room: Daily / Weekly Tower | **Parcial; não falta fazer do zero** | `fury_tower_local` passou: abrir, iniciar e persistir resultado por período. Recompensas de andar, boosts pagos, compra de reset e ranking não implementados. |
| Adventure | **Campanha e recompensas presentes; revisão restante** | `scene_rewards` e `normal_campaign_persistence` passaram. Há `one_key_draw_scene_reward`. Isso não comprova todas as fases, chamas, recompensas nem o clique visual de Claim all. |
| Clan: base | Implementada | Criar, buscar, entrar, membros, cargos, sair e configurações em `clan_local.py`. Não significa batalhas e progressão completas. |
| Clan: doação / ciência | **Parcial** | `clan_science_open` passou para abertura do painel. Só trilha 1 reflete nível/EXP do clã; demais doações/pesquisas ainda não têm lógica completa. |
| Clan: assistance | **Implementada e testada agora** | `clan_assistance` passou. Doação de assistência entre membros é diferente da doação de EXP/ciência do clã. |
| Ranking: power, stage, team spirit, ninja, clan | Base presente; manter OK informado | Não foi executada auditoria integral dos critérios de cada ranking nesta rodada. |
| Ranking: Ninja King | **Provisório / incompleto** | `ranking_local.kings_tokens`: pontos de todos em zero, ordenação por poder porque ainda não há partidas do modo. A tela não representa uma competição funcional. |
| Friends: adicionar, lista, pedidos | **Implementados e testados agora** | `friends_local` passou; inclui aceitar e remover. Falta aceite visual dos fluxos. |
| Friends: stamina | **Implementada e testada agora** | Módulo inclui enviar e receber com registro diário; pendência antiga foi superada. |
| Sign in: diário e acumulativo | **Implementado; prêmios ainda precisam de decisão** | `signin_local.py` e `signin_rewards.json`. Premiação é escolha local, não recuperada do servidor original. Calendário usa relógio local do processo, enquanto Quest documenta UTC: unificar regra antes do aceite. |
| Chat | **Sem implementação funcional identificada no servidor auditado** | Ausência de handlers de envio/listagem; recursos de interface não provam funcionamento. |
| Email | **Não implementado funcionalmente** | `email_init` permanece ACK neutro de inicialização; não fornece caixa postal, envio ou recebimento de anexos. Entrega GM por email continua pendente. |
| Ryo, gold, stamina, perfil, power, VIP, level | Base presente; manter OK dos fluxos informados | Sistemas persistentes existem. Não foi feita validação completa de limites, de todas as telas VIP ou da paridade visual PC/Android. |

## Projeto pretendido e adições fora da lista

A documentação descreve um port do jogo original para Windows/Axmol, usando recursos, tabelas, layouts e combate originais, com servidor Python e persistência SQLite. O trabalho posterior acrescenta Android, atualização de recursos e operação multijogador. A meta continua sendo preservar comportamento e progresso, evitando respostas de sucesso para ações ausentes.

Adições documentadas no pacote: autenticação vinculada à conta/sessão, formação persistente, painel GM, atualizador PC/Android, ajustes de resolução, extensão de nível/VIP, combate e replay da Arena, e importação de conteúdo mais novo do APK. A passagem registra 491 recursos novos, 28 tabelas atualizadas, 245 personagens jogáveis e 45 montanhas; esses números são registro histórico, não foram recontados nesta rodada.

Importação não significa conclusão: merge dos scripts existentes, idiomas e interfaces alteradas do APK ficou pendente. Eventos Fury completos também não podem ser considerados prontos só pela presença dos cinco scripts importados.

A animação de power é descrita na passagem como implementada (contagem, +valor junto, piscar e saída), mas ainda depende do aceite visual. O AGENTS.md mantém a pendência: não removê-la sem confirmação.

## Resultado dos testes desta auditoria

**16 passaram:** prop_sales_local, main_quest_local, soul_guard_local, friends_local, clan_assistance, clan_science_open, great_shinobi_local, ninja_trial_chest_rewards, fury_tower_local, scene_rewards, fight_spirit_local, index_local, mythical_local, recruit_shop_local, arena_rewards e normal_campaign_persistence.

**2 não passaram:**

1. `daily_quest_date`: dependência Lua não encontrada no caminho esperado pelo bootstrap. Não valida nem invalida o horário atual do jogo.
2. `ninja_trial_local`: assertion na extração da lista de NPCs após `three_kingdoms_init`. A resposta contém a lista `1303,1304,1306`; pode haver incompatibilidade na posição esperada pelo teste. Não corrigido durante esta auditoria.

Não foram executados testes visuais, uma recompilação geral ou uma instalação Android. Os resultados se referem ao checkout e aos testes selecionados, não à versão que está carregada em um servidor já em execução.

## Próxima ordem recomendada

1. Resolver os dois testes pendentes; definir fuso/horário de reset e premiação Sign in.
2. Validar no jogo os itens já implementados: venda, Aid Team, Friends, assistência e desafios; conferir PC e Android separadamente.
3. Completar Ninja Soul, destino das bestas, condições especiais do Index e fontes faltantes de conquistas/quest.
4. Concluir Trial Room, Adventure e Fight por modalidade, respeitando desbloqueios originais.
5. Implementar doação/ciência e demais modos de clã; competição real Ninja King; chat e email.
6. Consolidar a documentação: STATUS/KNOWN_ISSUES/PORTING_STATUS e o início da passagem contêm estados antigos já superados. Usar implementação atual, testes e os adendos mais recentes para resolver contradições.

Fontes principais: `PASSAGEM_PARA_PROXIMA_IA.md`, `documentacao/PLANO_CORRECOES_2026-10-28.md`, `NINJA_SCHOOL_ESTADO.md`, `QUEST_LOCAL.md`, `TESTES_POR_AREA.md`, `REVISAO_JOGO_NORMAL.md`, `PORTING_STATUS.md`, `ENGINE_DECISION.md`, `KNOWN_ISSUES.md` e módulos citados na tabela.
