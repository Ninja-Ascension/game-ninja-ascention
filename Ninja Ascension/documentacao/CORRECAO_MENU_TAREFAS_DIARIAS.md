# Menu incompleto após login no nível 100

Acesso de 25/10/2026 às 19:17:08: `getActivityActivePush`, linha 7094,
tentava percorrer `daily_task_draw_index`, cujo valor padrão no cliente é
numérico. A exceção interrompia a montagem do menu.

O login local agora envia o protocolo original 361 antes do perfil 3,
inicializando pontos em zero e listas vazias de índices e tarefas. Isto não
implementa nem concede recompensas diárias. Conta e saldos são preservados.

Validação: `tools/test_login_layout_native.py` passou nos casos vazio,
inventário preenchido e nível 100 com 900 milhões de Ryo. O probe verifica
o tipo da lista e executa a função original `getActivityActivePush`.
Esses testes validam o protocolo e a checagem; a aparência completa do menu
precisa ser confirmada no acesso normal. Servidor reiniciado com logs em
`build/server-daily-init.log`.
