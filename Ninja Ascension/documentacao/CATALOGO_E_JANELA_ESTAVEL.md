# Catálogo Ninja e janela estável — 26/10/2026

Catálogo vazio: `tem_nome` usava `dms.atoi` com tabela inteira e três
argumentos; essa API espera uma linha e a coluna. Também acessava índices
de tabelas diretamente por string, sem a resolução de `dms.element`.
Agora resolve linha de evolução, ID de nome e palavra com as APIs corretas.

Teste nativo encontrou 134 entradas não possuídas no cenário de nível 100,
sem exigir fragmentos, sem conceder personagens e sem incluir os possuídos.
Os três cenários de login verificam o catálogo.

Cartões de Ninja deslocados 18 unidades lógicas à direita. Preservam a
compensação de proporção e o layout das demais categorias.

Preferência confirmada: manter o tamanho escolhido entre telas, sem
maximizar automaticamente. EXACT_FIT é definido uma vez na instalação;
o motor mantém a política ao redimensionar. O observador de tamanho só
recalcula posições/proporções após mudança física da janela. Criar os
layouts Ninja, mochila e loja não altera suas dimensões (teste nativo).
