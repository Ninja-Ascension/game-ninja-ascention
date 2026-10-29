# Janela redimensionável

O RenderView desktop agora é criado com `resizable=true`. Pode maximizar,
restaurar e redimensionar pelas bordas/cantos do Windows. Tamanho mínimo
da área do jogo: 640 × 426. Resolução lógica global: 960 × 640. A etapa de
inicialização `desktop_layout.lua` aplica EXACT_FIT na abertura e a cada
redimensionamento, preenchendo a área inteira em todas as telas. As
escalas horizontal e vertical se adaptam à proporção da janela. Não há
faixas laterais reservadas para os layouts antigos. Os atores e atalhos
da cidade mantêm seus ajustes locais sobre essa mesma resolução lógica.

Implementação: `port/native/ResourceProbe.cpp`. Requer reconstruir o
executável; não modifica conta, personagens ou progresso.
