# Barras e cabeçalho da cidade

- Sete atalhos inferiores com centros mais próximos (78 unidades lógicas).
  Seta à esquerda de Ninja recolhe os outros seis. Trial Room e Adventure
  formam um grupo compacto à direita e permanecem visíveis. Centros em
  largura-124 e largura-48, respectivamente, com margem lateral.
- Botão `^` acima de Sign in recolhe Friends/Ranking/Clan, mantendo Sign in;
  inverte a direção ao recolher. As duas setas usam traços brancos, sombra
  preta e disco discreto translúcido, sem depender de glifos da fonte.
- Recursos: os três widgets reais Image_13/Image_14/Image_11 são reduzidos
  a 90%, compensam a proporção e ficam 18 unidades abaixo, por seus centros.
- Correio/chat: proporção compensada, 14 unidades abaixo e 8 à direita.
- Grupo do perfil: compensação horizontal mantendo a borda esquerda e Y.
  Panel_zuo_2_xr1 é nome/Power, não os recursos; mantém sua altura original.
- `Panel_effice_piaoluo` oculto e criação do efeito de flocos desativada.

Aplicação em `desktop_layout.lua` e `Home.lua`. Mudanças de posição são
calculadas com valores de base para não acumular ao redimensionar. Não
alteram conta, recursos nem progresso.

Teste nativo verifica existência das duas setas, recolhimento/expansão,
elementos que permanecem visíveis, grupos distintos do cabeçalho e flocos
ocultos. Três cenários de login passaram. Posicionamento visual final
deve ser confirmado no menu normal após reiniciar o cliente.
