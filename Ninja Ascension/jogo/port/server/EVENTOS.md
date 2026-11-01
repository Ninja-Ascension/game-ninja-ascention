# Eventos locais e dados da wiki

As telas de Evento e 7-day Party usam `events_local.json` e o protocolo local
`local_event_*`. Resgates são transacionais, persistem recibos por conta e
pedido e são testados em banco temporário. A implementação não credita prêmios
ao abrir a tela.

## Dados oficiais integrados

- **Fundo de nível (evento 27):** VIP 3, compra única por 200 Gold, 13 metas
  entre os níveis 15 e 90, total de 8.000 Gold.
- **Desconto diário (evento 93):** edição do Servidor 12 exibida pela wiki,
  de 31/10/2026 11:00 a 07/11/2026 02:00 (UTC−3). São 14 ofertas, duas
  liberadas por dia. Cada compra verifica o dia, VIP, Gold e Ryo, debita as
  duas moedas e entrega o item ou equipamento. Ofertas liberadas continuam
  disponíveis até o fim da edição. A compra é idempotente por pedido.

Fonte oficial: <https://pay-ninjarevolution.ryzengames.com/wiki/pt_BR/index.html#events>

O calendário e as datas pertencem a cada servidor. `server_id` e `schedule`
no catálogo identificam a edição consultada; antes de usar outro servidor ou
edição, os dados precisam ser atualizados a partir da wiki. A janela é
configurável, calculada pelo fuso do servidor e bloqueia compras fora do prazo.

## Regras locais mantidas explicitamente

As demais campanhas transacionais do catálogo ainda estão identificadas como
regras locais nas descrições. O 7-day Party atual usa a data de criação do
perfil, dias 1 a 7, com coleta até o fim do dia 8. A wiki descreve o evento a
partir da abertura do servidor e não expõe, na página consultada, a lista
completa de metas e prêmios de cada dia; portanto essa campanha não é declarada
fiel ao original. Os contadores locais viram às 05:00.

Recargas locais são confirmadas apenas pelo administrador e não representam
pagamentos reais. Exemplo:

    python jogo/tools/creditar_evento.py NomeDoPersonagem 300 referencia-unica

A ferramenta gera backup consistente antes da alteração. Uma referência
repetida não adiciona Gold novamente. As metas de consumo e de baús contam
alterações reais de saldo e aberturas feitas após a atualização.

## Ainda por integrar

- calendário completo por servidor e recorrência das edições;
- troca do Festival (evento 121), após confirmar os limites por jogador e os
  itens de custo no catálogo local;
- correio para prêmios de recarga e metas completas oficiais do 7-day Party;
- efeitos de Ryo, EXP e Drop, que permanecem desativados até serem ligados às
  regras exatas da wiki.
