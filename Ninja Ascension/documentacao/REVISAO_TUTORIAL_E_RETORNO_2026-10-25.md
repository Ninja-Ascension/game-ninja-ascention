# Revisão do tutorial e retomada da conta — 25/10/2026

Este documento atualiza o diagnóstico anterior de continuidade. O projeto
recebeu mudanças entre as sessões; não presumir que o banco ainda está vazio
ou que aceita apenas uma conta.

## Estado encontrado

- Banco íntegro, com cinco contas (IDs 52 a 56), todas preservadas.
- Conta mais recente: ID 56, personagem ID 5, nível 4, três missões vencidas,
  Sakura recrutada, formação salva, primeira qualidade de Naruto concluída.
- Checkpoint mais recente dessa conta: mission3 grupo 5, evento 30506,
  botão de receber recompensa. Conta 54 chegou ao evento 305016.
- A introdução ainda aparece com experiência 0 em tutorial_progress para essas
  contas, enquanto o nível de campanha já está entre 2 e 4. Não zerar ou
  promover perfis para mascarar isso: distinguir experiência da introdução,
  nível da campanha e etapa do guia ao escolher a rota de login.
- Auditoria detalhada sem nomes/senhas/tokens: `build/tutorial-audit.json`.
  Regerar com `tools/audit_tutorial.py` (somente leitura).

## Correções aplicadas nesta revisão

1. **Perfil recebido depois da pausa do carregador.** A checagem anterior só
   atuava na etapa 8. Se o login chegasse depois de o pai marcar `_unload`,
   o onUpdate original retornava antes da correção e a tela permanecia nos 9%.
   Agora FightLoading.onUpdate verifica a conta restaurada ANTES desse retorno.
   O LoginLoading filho distingue a rota inicial de uma batalha normal.
   A transição é agendada uma única vez, fecha o carregador obsoleto e usa
   `menu_window_open_mission`. Conta nova e luta normal mantêm a rota original.

2. **Inventário na posição errada do login.** O parser 3 lê o contador de
   itens no campo 90 e imediatamente lê sete campos por item. O servidor
   anexava os itens depois dos contadores 91–96. Com itens salvos, o parser
   lia valores deslocados e podia quebrar em ProtocolParserCopy.lua:494.
   Agora: cabeçalho até 90 -> itens -> contadores restantes -> demais blocos.

3. **Checkpoint devolvido no login.** tutorial_events já era persistido,
   mas new_user_teach_record era enviado vazio. Agora esse campo inclui a
   entrada LOCAL `nr_local_resume&personagem,grupo,evento`, pelo parser
   original. `tutorial_resume.lua` valida a identidade, confirma o evento
   nas tabelas originais e restaura a lição ao consultar mission3.
   Não regrede uma lição posterior naturalmente desbloqueada.
   IMPORTANTE: a interface da lição é reconstruída a partir do início dela;
   algumas instruções podem reaparecer. Não significa retomar um widget
   isolado sem recriar suas janelas, nem repetir/apagar melhorias salvas.

4. **Conta versus personagem.** Neste banco os IDs são distintos (52->1,
   53->2, etc.). O checkpoint enviado ao cliente usa o ID do personagem;
   as consultas ao banco usam o ID da conta autenticada.

Arquivos: `port/lua/battle_lifecycle.lua`, `tutorial_resume.lua`,
`profile_parser_dependencies.lua`, `menu_boot_probe.lua`,
`port/server/local_server.py`, `tutorial_campaign.py`.

Servidor atualizado e reiniciado nesta revisão. Reiniciar o jogo para
carregar Lua novo, usando a MESMA conta. Não criar outro perfil para testar.

## Validação realizada

- `tools/test_damage_hooks.py`: passou, incluindo perfil ausente/recebido
  tarde, pai pausado, transição única, conta nova, batalha normal, isolamento
  do checkpoint e ausência de regressão para lições já desbloqueadas.
- `tools/test_tutorial_campaign.py`: passou, incluindo checkpoint no login,
  progresso monotônico, vitórias, duplicações e isolamento entre contas.
- `tools/test_cold_login.py`: passou no executável; caso de resposta com ordem
  incorreta falha como esperado e resposta corrigida passa.
- `tools/test_hero_training_native.py`: melhoria e restauração passaram.
- `tools/test_saved_profiles.py`: as CINCO contas reais passaram no parser
  nativo, a partir de cópia privada do SQLite. Identidade, checkpoint e
  formação restaurados; banco ativo não modificado por esses testes.
- Auditoria final confirmou cinco contas e integridade ok.

Limite da evidência: os testes nativos acima validam o parser e contratos;
não equivalem a percorrer todo o tutorial manualmente. A ferramenta
computer-use falhou ao inicializar com o caminho E:\[code]\nk (erro de glob
de permissões no node_repl), portanto a tela real não foi inspecionada ao vivo
nesta revisão. Não afirmar validação visual de ponta a ponta.

## O que falta para encerrar o tutorial

1. Confirmar visualmente novo login -> menu -> lição salva da conta 56, sem
   ficar no carregador ou repetir a introdução. Se falhar, obter primeiro
   erro completo e estado dos carregadores; não apagar banco/cache de conta.
2. Grupo 5: implementar `draw_scene_rewad` conforme comando original, tabelas
   e parser 171, com elegibilidade, recompensa real, gravação e idempotência.
   Esse handler ainda não está implementado no backend local e o evento
   30506 é o ponto atual de duas contas.
3. Grupo 5: implementar a síntese de personagem/fragmentos com comandos e
   parsers reais, inventário consumido uma única vez, personagem persistido
   e inclusão na formação. Não basta preencher contadores para esconder erros.
4. Grupos 5/6: validar batalhas NPC 4/5 e retornos, sem repetir recompensas.
5. Grupo 7: implementar `ship_star_up` e requisitos/custos originais com
   persistência. A melhoria atual é somente a primeira qualidade; não cobre
   evolução de estrelas. Não reutilizar o handler ship_grow_up como ACK vazio.
6. Grupo 7: validar encerramento do guia, comandos de telas/promos finais
   disponíveis localmente e liberação das missões normais.
7. Testar o percurso completo em banco isolado e interrupções em recrutamento,
   qualidade, recompensa, síntese e estrelas. Relogar em cada etapa e conferir
   que não duplica consumo, prêmio ou personagem.

Não declarar tutorial concluído nem jogo plenamente funcional antes dessas
entregas. Próxima implementação prioritária: recompensa do mapa do grupo 5.

## Atualização posterior: clique na lista e recursos solicitados

O usuário chegou à etapa 305014, mas o guia apontava para a primeira carta
(Naruto possuído). A tabela pede Button_hecheng (síntese), um botão oculto
nessa carta. O callback recebia prop=nil e quebrava em sm_ship_seat_cell:137.
O inventário da conta estava vazio.

- `tutorial_synthesis_target.lua` procura uma carta de fragmentos com botão
  de síntese visível e habilitado, ajustando apenas o alvo do evento 305014.
  Não encaminha o clique para o botão oculto de um personagem possuído.
- `tutorial_synthesis.py` implementa prop_compound individual usando custo
  da coluna 10 e personagem da coluna 40 de prop_mould. Valida sessão,
  propriedade e quantidade; consome uma vez e salva em local_synthesized.
  Reenvio retorna o mesmo personagem sem cobrar novamente. Não implementa
  múltiplas cópias do mesmo personagem, nem todos os tipos de composição.
- recruitment_local inclui os personagens sintetizados no próximo login.
- A pedido explícito, conta 56 (personagem 5) recebeu 10 milhões de prata,
  1 milhão de ouro/honra/almas/jade, 10 mil de alimento/energia de cada tipo
  e 10 mil unidades dos 150 itens válidos de IDs 1–150. Não foram concedidos
  todos os itens do catálogo. Não foram alterados nível, etapas ou personagens.
  Moedas adicionais ficam em local_resources. É uma concessão local de teste,
  não economia recuperada do servidor oficial.
- Ferramenta explícita: tools/grant_local_resources.py --account 56.
  Não executar para outras contas nem repetir sem solicitação.
- Testes: test_tutorial_synthesis.py passou; parser nativo de síntese passou
  (build/synthesis-native.log); testes do alvo passaram; todas as cinco contas
  passaram novamente no login nativo, incluindo a conta abastecida.

Servidor atualizado. Fechar o jogo e relogar na mesma conta para limpar o
terminal de síntese que pode ter ficado bloqueado após a exceção anterior.
As demais pendências de recompensa do mapa e estrelas continuam existentes.
