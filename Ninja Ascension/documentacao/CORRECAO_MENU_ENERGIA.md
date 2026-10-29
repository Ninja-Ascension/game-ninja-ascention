# Menu após Pain: relógio de energia ausente

Menu.lua:2394 divide _ED._next_energy_recover_time por 1000. O valor inicial
em EnvironmentDatas.lua:1620 é a string vazia. O parser 223 só a transforma
em número quando recebe uma atualização de recuperação de energia.

menu_energy_compat.lua adapta em memória apenas essa expressão do método
original Menu.onUpdate. Usa tonumber para horários numéricos e ignora a
condição de recuperação quando o valor está ausente ou inválido. O valor
original em _ED não é substituído por um horário inventado. O ramo de
keep-alive de 120 segundos e a continuação das etapas do menu permanecem.

O arquivo original é lido, não modificado. A transformação exige a assinatura
e a expressão conhecidas, falhando explicitamente se o fonte mudar. A
instalação acontece via battle_lifecycle após o carregamento de Menu.

tools/test_damage_hooks.py executa o Menu.onUpdate original e reproduz o erro;
depois verifica o método adaptado com valores vazios, inválidos, numéricos,
horários futuros e passados, incremento do estado do menu e keep-alive.

A recuperação de energia no servidor e a progressão persistente das missões
não são implementadas por essa proteção. A continuação visual após Pain
ainda exige verificação no jogo.
