# Modo sem tutorial — aplicado em 25/10/2026

Solicitação: desativar o tutorial, entrar direto no menu após autenticação,
começar com três personagens fixos e apagar todas as contas anteriores.

- Configuração compartilhada: port/gameplay.json, tutorial_enabled=false.
- Personagens iniciais: Naruto (13), Sasuke (35) e Sakura (50), com IDs
  distintos. Formação inicial nas posições 2, 4 e 6. Mudanças posteriores
  de formação são preservadas; login não preenche de novo uma vaga removida.
- Login fornece experiência de entrada >=1 para evitar a batalha de introdução,
  não devolve checkpoints de tutorial e fornece 60 alimentos/150 de energia
  de resistência iniciais. Nível inicial continua 1; não libera capítulos
  fora dos requisitos originais nem concede vitórias.
- tutorial_disabled.lua intercepta missões de ensino e os roteiros de batalha
  do sistema de tutorial. A narrativa normal continua separada; não foram
  apagados assets ou arquivos originais de missões.
- Pré-carga de atividade/formação carrega módulos sem abrir suas janelas.
  O módulo original Loading é carregado antes do menu quando necessário.
- manual_formation.lua fornece os comandos da seleção manual sem depender
  da construção prévia de uma página de formação pelo tutorial.
- Ao abrir normalmente após a atualização, a versão 1 do reset limpa apenas
  as credenciais locais lembradas, uma vez, para não tentar a conta apagada.

Limpeza executada no banco ATIVO: 6 contas removidas, zero contas e zero
sessões restantes. Foreign keys e integridade conferidas. O banco está pronto
para a conta que o jogador criar na tela; nenhum teste criou conta real.
Arquivos de backup históricos não foram removidos.

Validação: tools/test_direct_menu.py passou em SQLite temporário: três
personagens, IDs distintos, energia, ausência de checkpoint e formação
preservada. Probe nativo marcou DIRECT_MENU_NATIVE_PASSED: menu encontrado,
três personagens lidos, nenhuma janela de tutorial/carregamento da introdução.
O teste inicial identificou Loading ausente e essa dependência foi corrigida.
O percurso manual de todas as áreas e batalhas permanece pendente; não
declarar o jogo completo validado só por entrar no menu.

Para testes antigos específicos do tutorial, usar NR_ENABLE_TUTORIAL=1 apenas
nos processos de teste e bancos temporários. O padrão do jogo permanece
sem tutorial. Não religar o tutorial nem resetar as contas novamente sem pedido.

Próximo teste com o usuário: fechar o jogo, abrir o inicializador habitual,
criar nova conta, entrar, confirmar Naruto/Sasuke/Sakura e acesso manual à
formação e ao mapa. Não é necessário compilar a engine para estas mudanças.
