# Event e 7-day Party

Configuração: `events_local.json`. Regras marcadas como locais são provisórias.
O Fundo de nível foi conferido na wiki oficial: VIP 3, custo 200 Gold,
13 metas de nível e retorno total de 8.000 Gold.

Fonte: https://pay-ninjarevolution.ryzengames.com/wiki/pt_BR/index.html#event/27

As outras campanhas transacionais usam preços, metas e prêmios locais,
explicitados em suas descrições. O 7-day Party usa a criação do perfil,
como solicitado: dias 1 a 7 e encerramento das coletas no fim do dia 8.
As contagens diárias viram às 05:00 do servidor; mensais usam esse mesmo ciclo.

Recargas locais só são confirmadas pelo administrador. Exemplo:

    python jogo/tools/creditar_evento.py NomeDoPersonagem 300 referencia-unica

A ferramenta gera backup consistente antes da alteração. Uma referência
repetida não adiciona Gold de novo. Nunca há confirmação de pagamentos pelo cliente.

Compras e prêmios possuem recibos por pedido e limite por campanha/período.
Respostas repetidas não cobram ou entregam novamente. As metas de consumo
e de baús contam alterações reais de saldo e abertura depois desta atualização.

Pendências de fidelidade à wiki: calendário por servidor, edições, ofertas,
trocas de festival, envio de prêmios de recarga por correio e metas oficiais
do 7-day Party. Bônus automáticos de Ryo, EXP e Drop foram desativados até
que os respectivos sistemas usem as regras corretas da wiki.
