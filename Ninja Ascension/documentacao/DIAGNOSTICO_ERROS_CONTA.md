# Revisão das logs — 26/10/2026

Fonte: build/server-adventure-quality.log. Os contadores são históricos, anteriores ao reinício com as correções.

## Erros Lua encontrados
- 82 ocorrências: `...lient/notification/push_notification_sm_hero_develop.lua:783: attempt to index local 'ship' (a nil value)`
- 1 ocorrências: `.../src/client/packs/hero/SmRoleStrengthenTabRisingStar.lua:757: attempt to index local 'Text_skill_lv' (a nil value)`
- 2 ocorrências: `...teudo_apk/assets/src/frameworks/external/utils/utils.lua:9: attempt to index local 'str' (a nil value)`
- 2 ocorrências: `...de]/nk/01_conteudo_apk/assets/src/cocos/cocos2d/json.lua:320: bad argument #1 to 'len' (string expected, got table)`

## Correções aplicadas
- Equipamentos sem personagem vinculado não consultam notificações de evolução; estados de notificação ainda não recebidos retornam falso.
- Biografias sem estados de conquistas carregam uma lista vazia.
- Habilidades sem snapshot de recuperação inicializam zero pontos no horário atual.
- Espírito ainda não inicializado usa nível inicial e zero experiência para os slots ausentes.
- A tela de estrelas procura o campo de nível também nos descendentes do painel.
- Mega: tabelas já decodificadas não passam novamente pelo decodificador JSON; listas ausentes começam vazias.
- Vitória de campanha local não solicita tarefas online File Island sem implementação. Esta alteração não implementa o recurso File Island.

## Comandos pendentes encontrados
- `file_island_task_info`: 389 solicitações registradas.
- `ship_escalate`: 2 solicitações registradas.

`ship_escalate` permanece sem implementação: abrir a tela não significa que a operação de elevação de estrelas esteja disponível. Não foi devolvido sucesso fictício.

Validação: teste de inicialização nativa de batalha e compilação Lua dos arquivos alterados; teste de notificações com equipamento sem ninja. As interações completas de todas as abas ainda precisam ser confirmadas na sessão real. A conta do jogador não foi apagada ou substituída.

## Atualização: upgrade de nível

`ship_escalate` é o comando de nível por itens de EXP, não de estrelas. Foi implementado em hero_level_local.py com consumo transacional, limite de nível do jogador/máximo 100, proteção contra pedidos repetidos e EXP restante persistida. O login agora devolve nível, EXP e atributos correspondentes. Testes: tools/test_hero_level_local.py e tools/test_hero_level_native.py passaram. Servidor reiniciado com backup da conta em build/contas-before-hero-level-20261026-145607.sqlite3. As tentativas antigas recusadas não foram convertidas retroativamente em upgrades.
