# Carregamento preso nos 9% — revisão de 25/10/2026

Esta ocorrência veio de regressões na montagem da resposta de login, após
a correção independente dos caminhos de shader. Não apagar conta/cache/banco.

1. local_server chamava tokens.split() quando tokens era list. A exceção
   interrompia a resposta antes de o cliente receber o perfil. Diagnóstico
   substituído por contagens, sem interpretar uma lista como string.
2. O prefixo enviava o contador de itens na posição 88. Instrumentação nativa
   de npos confirmou: itens 90, equipamentos 91, personagens 92, formação 93,
   companheiros 94 e acumulados de recrutamento 95/96. Quando o campo 90
   recebia a quantidade de personagens, o cliente tentava lê-los como itens.
3. O registro curto de personagem do parser 3 estava sendo usado como se
   fosse o registro do protocolo 9. Esses formatos não são intercambiáveis.
   Agora o parser 3 contém cabeçalho/itens e contadores finais completos;
   os personagens são enviados em blocos 9/14104 próprios, antes de 6012/188.
   A serialização 9 inclui ship_place, crescimento, oito equipamentos,
   relações, talentos, descrição e treino exigidos pelo parser original.
   Nível/rank persistidos continuam sendo lidos do banco.

Validação: tools/test_login_layout_native.py passou nos parsers originais,
com SQLite privado e os casos de inventário vazio e preenchido. Ver
build/login-layout-empty.log e build/login-layout-items.log, ambos com
LOGIN_LAYOUT_NATIVE_PASSED e MENU_BOOT_PROBE_RESULT true.
O probe direto também chegou ao menu com três personagens após as correções.

Limitação separada encontrada: tools/test_direct_menu.py falha posteriormente
no teste de remoção de formação porque a implementação atual aceita modos
1/2 e o teste envia -1. Não atribuir isso ao login nem ocultar a falha. A
validação de login foi isolada em test_login_layout_native.py, sem reduzir
as exigências dos testes de formação.

Servidor atualizado; reabrir o jogo e autenticar a mesma conta. Tutorial
permanece desativado e nenhuma conta foi apagada nesta correção.
