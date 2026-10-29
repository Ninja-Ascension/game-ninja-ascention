# Auditoria de poder — APK de referência, 28/10/2026

Referência local: `origem_apk/NinjaRevolution64-1.1.1-64bits.apk`. Nenhuma conexão com servidores externos. Nenhuma alteração nas contas ou fórmulas.

## Confirmado

- A função `calPowerForNotOwn` de `assets/src/client/loader/EnvironmentDatas.lua` é idêntica à função do cliente local, após normalizar finais de linha.
- Os coeficientes 1–18 de `fight_config`, configurações 80–83 de `play_config` e todos os campos do personagem 382 em `ship_mould` coincidem com os dados usados pelo servidor local.
- `constellation_group` coincide após remover o terminador NUL do APK. A função `attributeNumClt` usa a mesma soma das porcentagens de estrelas, qualidade e quantidade de bênçãos compradas. As diferenças observadas na janela são chamadas para mascarar personagens ocultos, não mudanças nessa fórmula.
- O teste `python jogo/tools/test_power_parity.py` passou: 12 vetores da fórmula Lua, soma da formação e ranking.
- O Rinne (382) é do tipo 6. O bônus local do Sculpture é aplicado por `constellation_local.bonus` -> `ninja_school_local.combat_bonus` -> `hero_stats_local.effective` -> atributos enviados ao cliente.
- Na primeira leitura, os atributos do servidor correspondiam ao print: PV 3.721.828, ATQ 721.013, DEF 110.435. O estado mudou durante a investigação, pois o jogador continuou evoluindo sistemas.
- Na leitura posterior, retirar apenas o Sculpture em memória reduziu PV de 3.938.552,59545 para 3.660.699,44295, ATQ de 761.640,5159 para 729.317,8699 e DEF de 116.987,8296 para 108.519,7396. Esses números representam esse instante, não o estado do print.

## Limite da conclusão

O parser do cliente original recebe os atributos finais pela rede e os guarda em `ship_base_health`, `ship_base_courage` e `ship_base_intellect`. A fórmula completa do servidor original que produz esses atributos não foi recuperada. `hero_stats_local.effective` declara explicitamente uma reconstrução local do crescimento. Igualdade da fórmula de poder não comprova igualdade de todos os bônus.

Os prints mostram personagens e progressos diferentes; servem como evidência da discrepância, não como vetores equivalentes de teste. Não foi demonstrado que esculturas inferiores expliquem a diferença. Não se deve multiplicar poder para atingir artificialmente os números do original.

Próxima investigação: decompor as parcelas e percentuais de cada sistema em ATQ/DEF/PV e compará-las com as regras e tabelas do APK. Se necessário, obter os painéis de bônus da mesma conta/personagem no original, sem contatar seu servidor automaticamente.

## Bestas com Cauda: erro confirmado e corrigido
O APK soma os incrementos de todas as estrelas em MythicalAnimalsHandle.getAnimalsUpStarPropertyById. mythical_local.bonus usava apenas a estrela atual. Corrigido para acumular as estrelas 1 ate a atual. Regressao: Kurama 5 estrelas, antes de forja, soma PV 518397, ATQ 77756 e DEF 25917. test_mythical_local.py passou, incluindo pedidos repetidos e custos. Backup consistente feito antes de recarregar as regras no servidor; recarga confirmou OK sem encerrar as sessoes. Destino das bestas permanece nao implementado. Esta correcao nao demonstra paridade de todos os sistemas.

## Destiny implementado nesta etapa
Ativacao em lote persistente com custos sequenciais de magical_animals_fate_mould (99 etapas x 5 pontos), saldo real, recibo idempotente e parser 12678. Bonus categoria 0 entram nos atributos dos ninjas; categoria 1 continua disponivel ao cliente para o painel das bestas, sem mistura com os atributos dos ninjas. Missoes de Destiny e suas recompensas continuam pendentes. RenegadoBR recebeu saldo minimo de 11111 gemas 2329 e 14099 gemas 2239, sem ativar o progresso. Backup SQLite verificado antes da alteracao e migracao; recarga local OK, Lua validado e publicado. Teste temporario passou para saldo insuficiente, custo exato, 495 pontos, pedido repetido e limite maximo.
