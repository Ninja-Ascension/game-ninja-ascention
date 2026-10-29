# Renderização da batalha: shaders e ponte Spine — 24/10/2026

## Causas verificadas

1. `app.setSearchPaths` recompõe os caminhos após a escolha de idioma a
   partir de `app.searchPaths`, que fora salvo antes da restauração do host.
   Assim os shaders `positionColorLengthTexture_vs/fs`, existentes no disco,
   ficavam inacessíveis. CSLoader falhava em `formation/line_up.csb` e
   `utils/teaching.csb`, interrompendo a construção do combate/tutorial.
2. `boot_map.lua` criava `sp.SkeletonAnimation` com um Node vazio e métodos
   sem ação. O Spine 2.1 da prévia existia, mas não atendia às chamadas Lua
   usadas pelos scripts originais. Personagens e efeitos podiam ficar invisíveis.

## Alterações

- Caminho `runtime/axslc` preservado em `app.searchPaths` e reafirmado após
  chamadas de mudança de idioma, com verificação dos dois shaders necessários.
- Ponte `port/lua/native_spine.lua` cria `LegacyCharacter` real, com JSON,
  atlas e escala dos dados solicitados pelo jogo.
- `LegacyCharacter` registra as funções de criação/comando para Lua e utiliza
  o `AnimationState` do runtime original 2.1 para tracks, filas, mix e eventos.
- Suporte para animação, fila, skin, velocidade, setup pose, duração, contagem
  de animações e callbacks start/end/complete/event. Eventos carregam dados
  de frame e a identidade do nó, usados por `display.lua`.
- O substituto invisível foi removido; asset ou animação ausente falha de
  forma explícita. Não se troca um personagem ausente por outro silenciosamente.
- Registro nativo antecipado ao boot exploratório, que antes selecionava
  shims antes de os bindings estarem disponíveis.

## Testes

`NATIVE_SPINE_BRIDGE_PASSED` exige geometria não vazia e callback real de
conclusão. `NATIVE_RENDER_CONTRACT_PASSED` muda o idioma pelos métodos originais,
verifica shaders e cria os layouts originais de formação/tutorial. O caso
`render-contract` agora é obrigatório em `tools/test_layout_editor.py` e falha
quando qualquer uma dessas evidências está ausente, mesmo com saída 0.

As regressões de editor, persistência e batalha continuam na suíte.

Binário final compilado com saída 0. Execução final:
`build/layout-tests-4a4dd66566c94d558a7172c5267585f4/results.json` — sete
casos com saída 0, incluindo `render-contract` obrigatório. Uma tentativa
anterior detectou a ordem incorreta de registro no boot e foi corrigida
antes desta execução final.

## Limites

Ainda é necessário testar visualmente o fluxo inteiro da conta até a batalha.
Os testes de componentes não comprovam todos os modelos, efeitos, mapas ou
eventos de missão. APIs futuras não suportadas precisam de adaptação real;
não devem voltar a usar nós vazios. Contornos de depuração Spine não são
desenhados; os setters guardam apenas a opção. Eventos interrupt/dispose do
Spine moderno não são sintetizados pelo runtime antigo.

Nenhum arquivo original ou banco de contas foi alterado. O executável precisa
ser fechado e reaberto para usar a nova ponte nativa. O servidor não precisa
ser reiniciado por esta mudança.
