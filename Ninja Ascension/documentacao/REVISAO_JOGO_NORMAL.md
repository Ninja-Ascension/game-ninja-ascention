# Revisão do jogo normal — 25/10/2026

Objetivo: estabilizar menu, formação, ninjas e missões, com tutorial desligado.
Conta real preservada; as verificações usam bancos temporários.

## Alterações desta revisão

- Notificação de talentos retorna zero enquanto não chega a inicialização
  original de páginas/pontos, evitando acesso a `digital_talent_page_is_lock`
  inexistente. Não desbloqueia nem implementa talentos.
- Formação aceita também remoção pelo modo -1, além da posição zero já
  suportada. Valida se o ninja realmente ocupa a posição indicada.
- Fixtures antigas ajustadas para seu contexto: a convocação inicial é
  testada com tutorial ligado; o login atual inicia pelos estados de cenas.

## Verificações aprovadas

- Login nativo vazio, com inventário, e nível 100 com dez personagens.
- Formação com seis ninjas, troca e remoção; posições preservadas no login.
- Convocação inicial e persistência (fixture antiga com tutorial ligado).
- Melhorias no servidor e no cliente nativo, incluindo restauração.
- Desbloqueio de cenas e baús com elegibilidade/registro de recebimento.
- Missão normal sem tutorial: iniciar, receber resultado, salvar estrelas,
  impedir recompensa duplicada, relogar e reabrir o banco.

Logs da rodada: `build/audit-test_*.log`. Teste novo:
`tools/test_normal_campaign_persistence.py`.

## Limites e próxima validação

Os testes de protocolo não comprovam a animação e a interação de uma batalha
completa. A captura ao vivo de computer use está indisponível por erro de
permissão do runtime no caminho com colchetes. Próxima etapa visual: abrir
Main Instance Challenge, selecionar uma fase desbloqueada, iniciar/vencer,
voltar ao mapa e conferir a persistência. Acompanhar logs nesse percurso.
Talentos e recompensas do presente online permanecem sem implementação
completa. Presente online e sua animação foram ocultados temporariamente.
