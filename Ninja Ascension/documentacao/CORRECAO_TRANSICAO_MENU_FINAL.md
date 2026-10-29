# Final da introdução e menu

O roteiro original mission2.txt, grupo 1/NPC 1196v1, termina assim:
2010131 juqing_cg1 → 3010132 música → 2010133 recursos → 2010134 restaura
parâmetro da simulação → 2010135 juqing_cg3 → 2010136 executa
state_machine.excute("menu_window_open_mission",0,0).

A correção intro_menu_transition.lua intercepta somente essa chamada
durante a batalha introdutória, se FightSceneClass ainda está registrada.
Fecha MenuClass antigo, caso exista, e limpa as camadas de batalha antes
de delegar ao comando original. Window.new pode omitir o construtor se uma
instância antiga da mesma classe estiver registrada. Reabrir sem limpar
também pode manter a arena cobrindo a nova página.

O comando original abre Menu, executa resetMission e seleciona as próximas
missões de ensino/história conforme nível/experiência. Não foram forçados
vitória, recompensas, progresso ou ID de missão. A correção não dispara o
comando final por tempo nem ignora a conclusão da cutscene.

Log específico: build/probe-writable/intro-menu.log. A ausência da linha
desse evento numa nova reprodução significa que a etapa 2010136 ainda não
foi atingida e requer rastrear os callbacks das etapas anteriores.

tools/test_damage_hooks.py verifica limpeza, remoção do menu antigo,
delegação ao comando original e ausência de limpeza repetida fora da arena.
A entrada visual e o percurso das próximas missões ainda exigem teste real.
