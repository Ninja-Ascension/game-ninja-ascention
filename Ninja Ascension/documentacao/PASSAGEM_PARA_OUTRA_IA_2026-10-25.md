# Continuidade do Ninja Revolution — 25/10/2026

## Objetivo e escopo autorizado

Estamos portando o cliente recuperado do Ninja Revolution para Windows, com
Axmol 2.11.5, LuaJIT e ponte Spine 2.1.25. Não é um jogo novo: recuperar as
telas, animações, protocolos e missões do cliente original é a prioridade.
O backend local Python/SQLite substitui serviços indisponíveis. Regras locais
devem ser explicitamente documentadas; não fingir respostas oficiais.

Concluir o tutorial inicial até liberar menu e missões normais. O usuário NÃO
pediu toda a história do primeiro capítulo. A primeira melhoria de personagem
é o ponto atual. NÃO declarar o tutorial completo baseado na abertura de telas.

## Mapa de trabalho

Ninja Revolution Windows
  1. Base nativa: Axmol + LuaJIT + Spine e recursos recuperados
  2. Entrada: conta única -> autenticação -> restauração do perfil
  3. Introdução: batalhas -> Secret Jutsu/TAP -> Pain -> cutscene
  4. Retorno: descarregar batalha/carregamento -> menu original -> guia
  5. Tutorial do menu: missão -> recrutamento -> formação -> melhoria
  6. Próximas etapas: baús/síntese/recompensas conforme mission3
  7. Conclusão: guia encerrado -> missões normais -> progresso após relogin

## Caminhos e execução

- Workspace: `E:\[code]\nk`; a unidade `N:` aponta para ele.
- Inicializador: `E:\[code]\nk\port\server\jogar_local.bat`.
- Executável: `E:\[code]\nk\build\windows-probe-native\bin\NinjaResourceProbe\Debug\NinjaResourceProbe.exe`.
- Backend: `port/server/local_server.py`, HTTP loopback `127.0.0.1:18080/iniServer`.
- Banco ativo: `port/dados/contas.sqlite3`.
- Originais: `01_conteudo_apk/assets/src` e `01_conteudo_apk/assets/res`.
- Adaptações preferidas: `port/lua`, `port/server`, `port/native`; testes em `tools`.
- Python disponível:
  `C:\Users\! I T A C H I\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe`.
- PowerShell: usar `Set-Location -LiteralPath 'E:\[code]\nk'`; os colchetes
  do caminho exigem LiteralPath. Start-Process funciona com WorkingDirectory N:\.
- Há MUITAS mudanças locais anteriores. NÃO usar git reset/clean/checkout
  para apagá-las. NÃO recompilar a engine por simples alteração Lua/Python.

## Contas: preservar a atual

Foram apagadas 48 contas antigas por solicitação explícita. O banco recebeu
o trigger persistente `nr_single_account`: permite criar a primeira conta na
tela e recusa outras. O usuário JÁ criou sua nova conta. Na última consulta,
o perfil de id 52 estava no nível 3, com 5198 de prata, e tutorial_progress
registrava 0 para a introdução. Isso exige conferir a coerência entre progresso
de campanha, introdução e cache de missões; NÃO corrigir apagando a conta.

Usar Entrar na mesma conta. Não criar contas reais de teste. Testes usam bancos
temporários. Não expor senhas ou tokens nos relatórios. Backups antigos foram
preservados: a revisão automática recusou removê-los por eliminar recuperação.
Não repetir o reset nem excluir esses backups.

## O que já foi implementado e testado em etapas anteriores

1. Recursos nativos, renderização Spine e compatibilidade de animações.
2. Tratamento de callbacks de fim de animação, números de dano e Total DMG.
3. Espera do TAP/Secret Jutsu e transição de ondas, sem avançar por um timer
   arbitrário. Parte dos atrasos/duplicações foi corrigida; validar o percurso.
4. Transição após Pain/cutscene para comando original de menu.
5. Menu: normalização numérica de relógio de energia.
6. Mapas: aliases de PageView, espera por páginas prontas e abertura adiada
   para evitar a antiga asserção de iteradores de vector no C++.
7. Efeitos: compatibilidade de blend aditivo de assets Spine modernos.
8. Máscaras do guia: remover preenchimento preto das cinco imagens da máscara,
   mantendo mão/círculo e bloqueio de entrada. Há testes, confirmar visualmente.
9. Botão de pular batalhas do tutorial, com liquidação e progresso persistidos.
   Escopo restrito ao tutorial; não libera vitórias em batalhas arbitrárias.
10. Parser de login: dependências das fórmulas carregadas antes do despacho;
    eventos 6020 antes de 6022. Ordem errada causa erro em pairs e aviso
    “Abnormal data”. Não inverter nem substituir estruturas por strings.
11. Recrutamento inicial: Sakura molde 50, concessão única, persistência,
    contador original, inventário e formação. Draw pago/x10 não está completo.
12. Naruto inicial molde 13 restaurado. Formação padrão na posição 2;
    Sakura pode ocupar posição 6 pelo tutorial.
13. Primeira melhoria de qualidade do Naruto: janela/callback/parsers originais,
    consumo transacional, proteção contra cobrança repetida e restauração.
    Regra LOCAL: no nível >=3, conceder uma vez 5000 prata e materiais 68–71,
    nas quantidades da primeira linha original de ship_grow_requirement.
    Não representa economia oficial. Ainda não há aumento de atributos nessa
    implementação. Não extrapolar isso para todas as evoluções/personagens.
14. Compatibilidade cc.setGray usando shader Axmol real e toque de cc.Layer.
15. Formação: user_fight era enviado como 0; corrigido no login para o número
    de vagas da tabela user_experience_param (6 no nível atual). Proteção da
    referência nativa destruída do cache g_formationTigerGate. A criação da
    janela com o perfil corrigido passou em teste nativo; reabrir após carga
    assíncrona ainda merece validação no fluxo completo.

## Bug atual: diálogo sobre carregamento e travamento

Imagem: Naruto diz “Não vou perder para o Sasuke! Quero ficar mais forte!”
sobre o fundo de carregamento. Essa fala é do mission3 grupo 4/evento 30402,
com gatilho l3e0 e alvo wjmp:13-1, NÃO do widget TuitionController.

A correção anterior tutorial_loading_gate suspendia TuitionController. Ela
foi insuficiente e sua instalação foi REMOVIDA do runtime. O módulo e seu
teste isolado permanecem como histórico; não confundir com a solução ativa.

Último ajuste, em port/lua/battle_lifecycle.lua, installLoading:
- Um FightLoading pode ter sido criado a partir dos valores anteriores ao
  login. Seu LoginLoading filho chega à etapa 8, pausa o pai e dispara uma
  missão. Para uma conta restaurada no nível 3, a missão é de menu e nunca
  emite battle_request para liberar o carregador inicial.
- Se loginIn=false, baseWindow.LoginLoading==self, totalNum==8, identidade
  válida e perfil já progrediu além de l1e0, marcar retorno uma única vez.
- Em serviço de próxima atualização, fechar esse carregador obsoleto e
  LoginLoading registrado, e executar menu_window_open_mission original.
- Não interceptar conta nova l1e0 nem carregador de batalha normal.
- Teste de contrato PASSOU: conta restaurada, um callback, fechamento antes
  do comando de menu, caminhos novo/normal preservados.
- AINDA NÃO confirmado visualmente com a conta real do usuário. Essa é a
  PRIMEIRA prioridade. Não declarar “resolvido visualmente” só pelo teste.

Se persistir: obter o primeiro erro completo, classe/parent dos carregadores,
totalNum, _unload, isBeginLoad, MenuClass e RoleDialogueClass. Verificar se o
diálogo nasceu no LoginLoading regular em vez do filho de FightLoading. Nesse
caso, adiar o início da missão de menu até a conclusão real da carga e criação
do menu. Não apenas esconder RoleDialogue: isso pode impedir o evento que
libera a progressão. Não avançar manualmente o índice nem dar ACK vazio.

## Arquivos principais para consulta

- port/lua/battle_lifecycle.lua: ciclo de carga/atores, instalação de adaptações,
  último retorno de conta salva ao menu.
- port/lua/intro_menu_transition.lua: comando original após a introdução.
- port/lua/formation_lifetime.lua: cache da janela de formação destruída.
- port/lua/profile_parser_dependencies.lua: fórmulas antes do parser.
- port/lua/tutorial_guide_visual.lua: máscara escura do guia.
- port/lua/tutorial_battle_skip.lua e tutorial_tap_wait.lua: pular e espera.
- port/lua/hero_ui_compat.lua: cinza e toque das telas de personagem.
- port/server/contas.py: SQLite, restrição de conta e persistência.
- port/server/tutorial_campaign.py: vitórias, níveis e mapa.
- port/server/recruitment_local.py: personagens, draw e formação.
- port/server/hero_training_local.py: primeira melhoria e kit local.
- port/server/local_server.py: protocolo de login/handlers.
- port/lua/menu_boot_probe.lua: cenários diagnósticos, não fluxo normal.
- Originais importantes: client/login/LoginLoading.lua,
  client/battle/landscape/FightLoading.lua, client/home/Menu.lua,
  client/formation/FormationTigerGate.lua, client/mission/Mission.lua,
  client/mission/missionex/RoleDialogue.lua, TuitionController.lua.
- Dados do tutorial: assets/res/language/pt_BR/data/mould/mission3.txt;
  consultar também as tabelas base e seus índices originais.

## Validações e evidência

Executar no PowerShell com o Python acima, usando bancos temporários:

```powershell
Set-Location -LiteralPath 'E:\[code]\nk'
$nrPython = 'C:\Users\! I T A C H I\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe'
& $nrPython tools/test_damage_hooks.py
& $nrPython tools/test_single_account.py
& $nrPython tools/test_tutorial_campaign.py
& $nrPython tools/test_hero_training_local.py
& $nrPython tools/test_hero_training_native.py
& $nrPython tools/test_recruitment_native.py
& $nrPython tools/test_cold_login.py
```

Alguns testes nativos/SQLite precisam de execução fora do sandbox. Ler qualquer
rejeição automática e não contorná-la com exclusões mais amplas.

Última execução tools/test_damage_hooks.py passou incluindo
SAVED_LOGIN_ROUTE_PASSED e os testes de callbacks/TAP/guia/mapa.
Primeira melhoria + restauração nativa passaram anteriormente em
build/hero-training-native-5651c9c6d44d4bc5af03023629ddb89c.
Não equivalem a validação de ponta a ponta do tutorial inteiro.
Logs recentes: build/probe-writable/battle-lifecycle.log,
build/probe-writable/turnos-batalha.log, build/intro-menu.log.
O servidor pode ter sido iniciado pelo usuário em outro processo; conferir
o dono da porta 18080 e o comando antes de reiniciar. Não abrir duas instâncias.
Alterações Lua exigem reiniciar o jogo; Python exige reiniciar o servidor.

## Ordem das próximas entregas

1. Confirmar visualmente o login da conta atual -> menu sem fundo de carga,
   fala 30402 clicável, sem erro/espera circular. Preservar a conta atual.
2. Percorrer a melhoria apontada pelo guia: selecionar Naruto -> janela de
   qualidade -> materiais/custo -> confirmação -> próximo evento original.
3. Relogar e provar que prata, materiais, qualidade e etapa permanecem salvos,
   sem repetir tutorial já concluído nem conceder kit novamente.
4. Enumerar TODOS os eventos dos grupos restantes de mission3 até o fim do
   tutorial inicial. Criar checklist: gatilho, janela, comando cliente,
   handler servidor, parser, dados persistidos, critério de conclusão.
5. Implementar um por vez os handlers faltantes, especialmente baús/recompensas
   e síntese de fragmentos quando exigidos; draw_scene_rewad era pendência.
   Validar campos reais antes de criar resposta. Não retornar ACK neutro.
6. Persistir cada aquisição e transição com transações e idempotência. Validar
   limite, propriedade do personagem, sessão e custo. Não reexecutar concessões.
7. Chegar ao fim do guia, liberar menu e missões normais conforme dados originais.
8. Teste completo em perfil ISOLADO e mais um relogin da conta existente sem
   alterar o progresso dela. Conferir máscara, input, Total DMG, TAP, efeitos,
   tempos de animação e fechamento de janelas. Documentar limitações restantes.

## Comando para a próxima IA

Continue a implementação local de Ninja Revolution em E:\[code]\nk. Leia
este documento inteiro e confira o código atual antes de editar. Prioridade:
validar e concluir a correção do diálogo sobre carregamento que trava a conta
salva de nível 3; o último ajuste em battle_lifecycle.lua passou no contrato,
mas não foi validado visualmente. Depois percorra a primeira melhoria do
Naruto, a persistência e todos os eventos restantes do tutorial inicial até
liberar as missões normais. Preserve a única conta atual e todas as mudanças
locais. Use parsers/janelas/tabelas originais, adapte em port, teste com bancos
temporários e mantenha um checklist de eventos. Não pule etapas, não dê ACKs
vazios, não esconda diálogos para mascarar deadlocks e não declare o tutorial
inteiro concluído sem executar o percurso. Informe evidência de cada entrega
e o que ainda depender de teste visual. Para controlar a tela, leia e use a
skill computer-use disponível; não use captura de contexto exclusiva de voz.
