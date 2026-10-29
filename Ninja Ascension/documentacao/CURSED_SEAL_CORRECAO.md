# Cursed Seal e poder da tela inicial

A recusa material_de_selo_invalido era causada pelo filtro do servidor: ele aceitava apenas use_type 3/4/5, mas a essência principal 243 (Mind-Awake Pill) é use_type 7 e dá 10 EXP, conforme prop_mould. O servidor agora aceita os materiais de EXP positiva que a interface original oferece e continua rejeitando EXP zero/negativa e itens que não pertencem à conta.

As interfaces nova e antiga exibem apenas materiais de EXP positiva. O seletor novo normaliza os IDs antes de comparar, para não incluir o item selecionado duas vezes no cálculo de quantidade. A interface antiga não usa variáveis globais temporárias para nível/EXP; nomes ausentes no acervo recebem uma identificação de item sem interromper a lista.

O poder da tela inicial é a soma dos ninjas da formação, conforme o mesmo cálculo usado pelas fichas. O cabeçalho é atualizado após os pacotes de melhoria e ao retornar à tela inicial; as atualizações antigas da interface não substituem o valor sincronizado por um cache anterior. A abreviação em K foi preservada.

Testes: test_hero_development_local.py usa a essência 243, verifica aumento de nível/EXP, persistência, repetição de pedido e rejeição de material sem EXP. test_hero_development_native.py abre as duas interfaces originais e verifica que a essência aparece uma só vez. test_hero_stats_native.py verifica que o total do cabeçalho coincide com a formação e alimenta o controle nativo de texto.
