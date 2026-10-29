# Regressão da camada do carregamento — 24/10/2026

Log da execução: `FightLoading.lua:294`, `self.totalNum + 1` falhava porque
`totalNum` era nil. Não foi aplicado um valor padrão para ocultar o problema.

O diagnóstico `instalarSondaDeJanelas` redefinia `fwin.open` com a assinatura
`function(janela, layer)` e chamava `original(janela, layer)`. O método original
é `function fwin:open(_windows, _layer)`: uma chamada com `:` passa primeiro
`fwin`, depois a janela e a camada. O wrapper descartava o terceiro argumento.

Consequência comprovada: o loader solicitado em `fwin._windows` acabava em
`fwin._view` por fallback de `push`. `FightLoadingCell:createFight` limpa
`fwin._view` antes de criar a batalha. O próprio loader ficava sujeito à
destruição enquanto seu `onUpdate` ainda estava em execução. Isso explica o
estado inconsistente e a perda de campos durante a transição.

Correção: preservar `self, janela, layer, ...` na entrada e ao chamar o método
original. As sondas já presentes no arquivo foram preservadas.

## Evidências

- `tools/test_window_open_contract.py --verify-old-fails` reproduz a perda da
  camada com a assinatura anterior, sem modificar os arquivos do jogo.
- `tools/test_window_open_contract.py` usa os métodos originais `open` e
  `cleanView` e comprova que o loader permanece em `windows` durante a limpeza
  de `view`. Também confere identidade, retorno e chamada com self explícito.
- Suíte nativa: sete casos com saída 0, incluindo contrato de shaders/Spine.
  Resultado: `build/layout-tests-2d58f1b60fa84a7ca19c34c1897e80af/results.json`.

É mudança Lua: basta reabrir o jogo; não requer recompilação nem reinício do
servidor. Contas e originais preservados. A sequência visual inteira do
tutorial deve ser conferida separadamente após a reabertura.
