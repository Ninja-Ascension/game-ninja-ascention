# Campanha local e efeitos — 25/10/2026

Regressão adicional corrigida: o fluxo local recebia a formação antes de
`client.loader.formula` definir `getUserFight`. `profile_parser_dependencies.lua`
agora carrega o módulo original antes do despacho de protocolos, quando
necessário. O teste deixou de carregar formula.lua antecipadamente e exige
explicitamente `COLD_LOGIN_FORMULA_BEFORE nil` seguido da carga pelo adaptador.
Aquisição, confirmação e restauração da Sakura também usam esse fluxo real.

## Correção de regressão do login

O parser 6022 (`parse_user_npc_states`) percorre `_ED.scene_max_state` na
linha 215. No primeiro login esse campo ainda é string. O servidor deve
entregar 6020 (cenas) ANTES de 6022 (NPCs), tanto no login quanto no resultado
da batalha. O teste anterior de mapa já inicializava essas tabelas e ocultava
a dependência. `tools/test_cold_login.py` agora reproduz a falha antiga e
valida a resposta inteira corrigida nos parsers originais do executável,
sem tabelas pré-inicializadas. Contas e progresso não precisam ser apagados.

## Correções aplicadas

- `battle_result_verify` era obrigatório e não implementado. Após três erros,
  o servidor respondia sucesso vazio e não salvava a vitória, repetindo a luta.
  `server/tutorial_campaign.py` agora valida a conta e a batalha iniciada,
  salva a primeira vitória, estrelas, nível e prata, e entrega os parsers
  originais 22, 40, 41, 6022 e 6020. Repetir o resultado não duplica recompensas.
- O login recupera o nível, os NPCs concluídos e o avanço do mapa no SQLite.
- `education_change` salva os eventos reconhecidos nas três tabelas originais
  de missões, por conta e grupo, sem regredir ao receber um evento anterior.
  Esse registro é um histórico persistente; a retomada da história usa nível,
  NPCs e cenas. Não existe ainda retomada no meio de cada fala de um diálogo.
- A consulta de formação de outro jogador retorna ausência de ranking local
  com o parser 12406, inicializando a tabela esperada pela interface.
- Duração e execução de animações agora usam a mesma tradução dos índices do
  enum para nomes reais. Corrige `getAnimationDurationEx(nil)` nos ataques.
- 121 arquivos de efeitos usam `blend: additive`, ignorado pelo leitor Spine
  2.1. `LegacyCharacter.cpp` interpreta essa informação antes da renderização.
  O teste verifica a mistura aditiva real (`dst=ONE`) e geometria visível.
- Notificações opcionais de presença diária e constelações não interrompem a subida de
  nível quando esses serviços não têm dados locais; com dados, preservam os
  handlers originais.

## Política explícita do port

O servidor oficial não está disponível. A campanha guiada local concede um
nível por primeira vitória em NPC, com experiência corrente zero na subida,
para disparar cada lição original `l2e0`, `l3e0`, etc. A prata vem da tabela
do NPC. Essa regra é uma adaptação local para a sequência didática, não uma
recuperação comprovada da economia original. Não considerar o balanceamento
de experiência completo.

## Validação realizada

- `tools/test_tutorial_campaign.py`: vitória, derrota, reenvio do resultado,
  nível, mapa, NPC, relogin, isolamento e recuperação do SQLite.
- `tools/test_intro_reward.py` e `tools/test_sessao_perfil.py` (35/35).
- `tools/test_damage_hooks.py`, incluindo serviços opcionais da campanha.
- Sete testes nativos em
  `build/layout-tests-54541d3a5db6438eadd91822c305078f/results.json`.
- `build/menu-map-probe/campaign-reply2.log`: a resposta do servidor de teste
  foi interpretada pelos parsers originais do executável; nível 2, cena 1 com
  primeiro NPC concluído. A tela abriu a fala do Iruka indicando Sakura.

## Atualização: guia, convocação e formação

`tutorial_guide_visual.lua` remove o preenchimento preto e as cinco imagens
da máscara, preservando input e efeitos. Foi renderizado sobre a tela original
de recrutamento. `recruitment_local.py` entrega 15005 no login e implementa
Draw x1 do tutorial, com Sakura (molde 50 indicado pelo evento 46 do grupo 3),
parsers originais 9/14104/15006 e formação persistente (6012/188/56).
O teste passou pelo callback original de Draw x1, animação de aquisição,
revelação de Sakura/confirmar e reconstrução após relogin. Reenvios recuperam
a mesma aquisição; não geram duplicatas. Pool pago e Draw x10 não implementados.
Testes: `tools/test_recruitment_local.py` e `tools/test_recruitment_native.py`.

## Ainda não concluído

Não declarar o tutorial inteiro validado. O próximo trecho original é
O recrutamento e a formação inicial do grupo 3 agora têm handlers e testes.
Ainda precisam ser percorridas as missões seguintes e implementadas as ações
de evolução/qualidade, baús e outras aquisições dos grupos seguintes. Não
devolver ACK vazio para fingir essas ações. Não declarar o tutorial inteiro
validado com base apenas nos testes de recrutamento.

## Atualização: conta única e primeira melhoria

A pedido do usuário, foram apagadas 48 contas do banco ativo, suas sessões e
seu progresso. O banco ficou vazio e recebeu a restrição persistente
`nr_single_account`: a primeira conta deve ser criada na tela do jogo; as
seguintes são recusadas. Nos próximos acessos, usar Entrar com a mesma conta
para recuperar o progresso. Os testes usam bancos temporários separados.
Os backups anteriores foram preservados; a revisão automática recusou sua
remoção por eliminar a possibilidade de recuperação.

O Naruto inicial (molde 13) foi restaurado no inventário e na formação. A
primeira melhoria de qualidade usa os custos das tabelas originais. Uma regra
local explícita concede, uma única vez a partir do nível 3, 5000 de prata e
os quatro materiais dessa lição; a melhoria consome esses recursos e salva
a qualidade. Reenvios não cobram novamente. Não representa recuperação da
economia oficial. Não há aumento de atributos implementado nesta etapa.

Validação: melhoria pela janela e callback originais no executável nativo,
restauração após login, consumo dos materiais, concessão única e conta única.
Baús, síntese e etapas posteriores ainda exigem implementação e validação;
o tutorial inteiro não está concluído. Inicializador: `server/jogar_local.bat`.
