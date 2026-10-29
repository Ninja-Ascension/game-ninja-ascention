# Ordem de animação do Recruit

Referência: código e assets extraídos em `01_conteudo_apk/assets`.
Não foi executado um APK Android nem feita comparação visual lado a lado.

O modo normal 15 usa `sprite_fudanquality` com sete animações selecionadas
pela raridade/conjunto de raridades. O callback de conclusão original abre
o painel x1 ou chama `openNewShowAction` para revelar os itens do x10.

A adaptação de visibilidade no port forçava o personagem antes desse
callback. Agora aguarda a abertura. A conclusão é executada uma vez e
eventuais chamadas síncronas durante a criação são ignoradas. Não usa
temporizador de duração inventada nem modifica probabilidades ou saldos.

As funções originais retornam o próprio nó Spine para diagnóstico. O
teste `tools/test_recruit_animation_native.py` verifica x1/x10: início
pendente, nenhum resultado antecipado, avanço em quadros de 1/60 segundo
pela duração do asset e conclusão/revelação por callback real. Verifica
também erros que o runtime captura em `Legacy Spine callback`.

A validação cobre a ordem da abertura e a entrada na revelação. Não
comprova equivalência visual completa, efeitos de cada raridade ou todos
os cliques da sequência inteira de dez cartas.

Correção do resumo x10 (26/10/2026):
- Ao concluir as dez revelações no recrutamento normal (mIndex=15), closePageEvent monta uma grade de dez ResourcesIconCell com as recompensas já recebidas.
- Oculta os dez Panel_show_hero para impedir que o detalhe do último ninja fique sobre o resumo; mantém os controles originais acima da grade.
- Instalação idempotente em recruit_visible_hero.installTen, via battle_lifecycle.
- Teste nativo ampliado: abre um detalhe de personagem, conclui, verifica dez células, detalhes ocultos e repetição do evento sem duplicar grade.
- tools/test_recruit_animation_native.py passou nos modos single e ten. Não foi feita comparação visual automatizada com o APK.
