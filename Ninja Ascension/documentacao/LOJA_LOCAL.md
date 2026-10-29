# Loja local — 26/10/2026

Implementado: baú de armas x1/x10 (`ship_bounty`, `ship_batch_bounty`), troca de fragmentos (`shop_frags_init`, `shop_frags_exchange`), catálogo e compra da General Shop (`secret_shop_init`, `secret_shop_exchange`).

Custos originais: baú x1 grátis uma vez por dia; depois uma chave ou 80 gold. Baú x10 usa dez chaves ou 680 gold. Sem chaves suficientes para cobrir a abertura inteira, usa gold; não consome chaves parcialmente. Itens, equipamentos, Ryo e saldos são persistidos. Não altera formação, personagens ou tutorial.

As transações validam sessão, saldo, quantidade e estoque. Um identificador por compra/abertura permite repetir a mesma requisição sem cobrar ou sortear novamente. Falhas fazem rollback. Equipamentos recebidos retornam também no login, via extensão local 15990 (`port/lua/shop_local.lua`), sem depender do tutorial.

Tabelas recuperadas: `partner_bounty_param`, `bounty_hero_param`, `avatar_shop`, `secret_shop_info` e `shop_config`. Políticas locais explícitas, sem afirmar equivalência com o servidor original: peso relativo pela coluna `value`, grupos x10 da linha VIP 0; grátis renova às 05:00 UTC. Troca de fragmentos escolhe uma oferta por posição a cada dez dias. General Shop escolhe até oito grupos; a rotação automática usa os horários de `shop_config` 1. Preços e quantidades vêm das tabelas.

General Shop: pedido original com param_list vazio aceito; a aba consulta o servidor em cada entrada para recuperar estoque e rotação. Atualização manual (`secret_shop_refresh`) implementada, limite de 20 por dia e custos de `shop_config` 3: 20, 30, 50, 50, 80, 80, 100, repetindo o último valor. Cobrança e catálogo são atualizados na mesma transação; reenvio não cobra duas vezes. Uma compra de catálogo vencido é recusada antes de trocar a oferta, para não cobrar um item diferente do mostrado; reabra a aba para consultar o catálogo atual.

Arena, Prova e Clã: `shop_special_local.py` implementa catálogo, compra e atualização manual, usando `arena_shop_info`, `glories_shop_info` e `union_shop_library`. Honra da Arena usa `local_resources.honour`; pontos da Prova e contribuição de Clã ficam em `local_special_wallet`, sem concessão automática. A seleção local usa um item por posição/grupo das tabelas e a mesma agenda de atualização da General Shop. Estoque, limites, recibos e custos são persistidos. Corrigidas as colunas de preço, quantidade e limite da Trial Shop no cliente.

A Clan Shop exige registro em `local_clan_membership` no servidor e clã no cliente, conforme pedido do usuário. Não foi criado nem atribuído clã ao jogador. Criação/entrada em clã e obtenção de pontos por batalhas são fluxos separados e ainda precisam ser integrados a esses saldos/registros. A tabela de vínculo não é uma implementação do sistema completo de clãs. Os testes usam um clã e moedas somente no banco temporário.

Testes adicionais: `tools/test_shop_special.py` verifica compras, saldos separados, reenvio, atualização, persistência e recusa sem clã ou sem moeda. `tools/test_shop_special_native.py` verifica as três abas e seus diálogos de compra e atualização no executável, incluindo preço de 30 gold na segunda atualização. O jogador ainda deve conferir visualmente o fluxo completo.

Validação: `tools/test_shop_local.py` cobre custos, chaves, dez recompensas, equipamento, persistência, estoque, repetição de requisição e rollback. `tools/test_shop_native.py` inicializa as telas reais de baú x1/x10, equipamento, General Shop e fragmentos. O teste nativo não substitui a conferência visual de toda a animação pelo jogador. `tools/test_recruit_animation_native.py` passou após a alteração.
