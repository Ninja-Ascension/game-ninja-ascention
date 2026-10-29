# Adventure e avanço de qualidade — 26/10/2026

Erros observados: `FightSpiritHandle.lua:115` consultava uma coleção ausente de espíritos ao criar os participantes da batalha. `ship_grow_up` era atendido exclusivamente pelo handler da primeira aula do Naruto e recusava outros personagens e avanço automático.

Cliente: coleções opcionais de espíritos têm retorno vazio; posições -1 não são consultadas como espíritos reais. `FightObject:initWithUserData` agora isola `heroinfo` por personagem e aceita o estado de megaevolução como string ou tabela, evitando reutilizar/decode de tabela de outro participante.

Servidor: `hero_quality_local.py` atende `ship_grow_up` no modo normal; o tutorial privado mantém seu handler anterior. Valida propriedade do personagem, grupo e ordem de requisitos de `ship_grow_requirement`, nível do personagem, materiais e Ryo. Suporta avanço único com os IDs dos materiais e avanço automático com campos vazios. Custo e qualidade são salvos atomicamente; recibo por requisição impede cobrança dupla. Não consome personagens ou equipamentos de outros fluxos; requisitos que os exijam são recusados explicitamente. Não remove requisitos de nível nem pula fases da história.

`local_hero_quality` preserva a qualidade por personagem, devolvida pelo parser 14104 nas atualizações e no login. Estrelas, formação, nível e saldos não são aumentados artificialmente. A evolução de estrelas do `HeroAdvancedPage` é um fluxo distinto do avanço de qualidade de `SmRoleStrengthenTabUpProduct`.

Validação: `test_hero_quality_local.py` (iniciais e seis R17, manual/automático, cobrança, repetição, material ausente e persistência), `test_quality_battle_native.py` (parser de qualidade salvo e inicialização real de batalha normal com seis R17 sem espíritos), `test_normal_campaign_persistence.py` (resultado, progresso e relogin), `test_quest_native.py` (regressão). O teste de batalha inicializa o cache e seus participantes; a animação e conclusão de uma luta completa ainda devem ser conferidas no jogo.
