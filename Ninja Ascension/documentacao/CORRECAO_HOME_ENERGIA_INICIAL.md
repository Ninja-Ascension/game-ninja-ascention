# Erro após entrar no jogo — 25/10/2026

Log real: Home.lua:2136 chama zstring.split(_ED._add_enger_info,"|") antes
da resposta assíncrona de power_swallow. O valor nil gera utils.lua:9.

O login agora inclui o parser original 194 com seus três campos e os quatro
períodos de energia derivados de activity_config. Isso inicializa o estado
antes de Home:onEnterTransitionFinish, sem ocultar a exceção no cliente.

get_web_recharge_state estava pendente e causava repetições de login. Agora
recebe o parser original 476, estado 0 (sem recarga web), servidor especial 0.
Não foram implementados nem executados pagamentos ou compras.

tools/test_login_layout_native.py passou nos casos vazio/com itens e também
verifica os quatro períodos e o parser 476 no executável. Servidor reiniciado
com a correção. Nenhuma conta, moeda ou personagem foi apagado ou alterado.
