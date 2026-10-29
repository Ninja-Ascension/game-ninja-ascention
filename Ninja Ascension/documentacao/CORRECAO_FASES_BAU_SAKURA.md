# Fases, baú e Sakura — atualização aplicada em 25/10/2026

## Liberação de fases

O servidor confundia open_scene (coluna 16: capítulos seguintes) com
by_open_scene (coluna 17: capítulos anteriores). Isso criava dependências
invertidas e impedia a abertura dos próximos mapas.

scene_tokens agora usa open_level (coluna 5) e by_open_scene, verifica todas
as vitórias do capítulo anterior e preserva vitórias já salvas. As 500
definições do acervo continuam no catálogo. Isso inclui mapas de modos
especiais: não significa que os serviços exclusivos desses modos estejam
todos implementados. Mapas com nível 999 continuam indisponíveis.

O catálogo para consulta está em build/scene-catalog.json. Os capítulos
normais, elite e nightmare usam as dependências originais. Não foram
marcadas vitórias artificiais nem aumentados os níveis das contas.

O adaptador tutorial_resume não força mais o último grupo quando não existe
uma lição natural para o nível/gatilho atual. Isso impedia sair de lições
antigas. Reabrir uma lição ainda em andamento pode reconstruir sua interface;
não confundir com repetição de uma batalha já vencida.

## Entrega do baú

Handler original draw_scene_rewad implementado em scene_rewards_local.py.
Valida conta/sessão, capítulo, índice zero-based e estrelas exigidas.
Lê scene_reward, grava prata, ouro, honra, almas, jade e itens, e registra um
recibo único em local_scene_rewards. Sorteios de itens são feitos somente
na primeira concessão e preservados no recibo. Reenvios não duplicam prêmios.

Os parsers originais 22/25/6024/6020/171 atualizam moedas, inventário, flag e
apresentação da recompensa. O bit da caixa recebida também volta no login.

Teste concreto do primeiro baú: 6000 prata, 50 ouro, item 68 x5 e item 57 x10.
Não houve concessão dessas recompensas às contas reais durante os testes.
Baús que exigem equipamentos/personagens diretamente ainda são recusados
explicitamente; não retornar sucesso vazio para esses tipos não suportados.

## Exibição da Sakura

O resultado inicial do recrutamento podia exibir nome/habilidade sem criar
o personagem visível, aguardando uma ação de carta. O layout também usa uma
animação character_display_open ausente, deixando o painel original fora
da área visível. A correção recruit_visible_hero cria a apresentação com
o esqueleto real, evolução/skin e animação standby originais, em uma camada
estacionária e sem captura de toque. Amostra a geometria antes do primeiro
toque. Ao substituir pela apresentação original após clique, remove a
instância inicial para não duplicar o personagem.

Captura de teste inspecionada: Sakura aparece na área central esquerda,
antes de qualquer toque. Os painéis do Inspector aparecem apenas nessa
captura diagnóstica; não constituem elementos novos do fluxo do jogador.

## Validações

- test_scene_unlocks.py: 500 definições, próximo capítulo, três dificuldades,
  nível mínimo e vitórias preservadas.
- test_scene_rewards.py: elegibilidade, moedas/itens reais, recibo único,
  máscara de recebido e relogin.
- build/chest-native.log: SCENE_CHEST_NATIVE_PASSED, parsers originais e
  capítulo seguinte liberado após vitórias.
- test_damage_hooks.py: passou com a regra de não forçar lição antiga.
- test_recruitment_native.py: guia, recrutamento, geometria do personagem
  visível antes do toque e restauração passaram.
- Captura: build/recruit-native-e0ae03fdb0724b559b11ca3792d22988/draw.png.
- test_tutorial_campaign.py: passou após a atualização.

Servidor reiniciado com estas mudanças. Reabrir o jogo e entrar na mesma
conta; não criar outra nem apagar o progresso. Próximos testes por área:
vencer último NPC de um capítulo -> próximo capítulo; coletar baú elegível
-> verificar inventário; recrutar/abrir resultado -> personagem visível.
Evolução de estrelas e fim completo do tutorial ainda exigem implementação
e validação. Não declarar todas as fases jogadas ou tutorial completo.
