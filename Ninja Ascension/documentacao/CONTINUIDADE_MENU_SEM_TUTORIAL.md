# Continuidade atual — menu sem tutorial (25/10/2026)

Este é o estado MAIS RECENTE. Documentos antigos que mandam concluir o tutorial
não representam mais o objetivo do usuário. O usuário pediu desativá-lo.

## Objetivo

Jogo local Windows em Axmol 2.11.5 + LuaJIT + Spine 2.1.25. Cliente e assets
recuperados do Ninja Revolution, backend Python/SQLite. Entrar no menu após
autenticação, com Naruto, Sasuke e Sakura, e testar/corrigir uma área por vez.
Não criar um jogo novo nem substituir recursos originais por placeholders.

## Conta e modo atual: não apagar novamente

- port/gameplay.json: tutorial_enabled=false; starter_moulds=[13,35,50].
- Os seis perfis antigos foram apagados em uma etapa ANTERIOR, a pedido do
  usuário. Ele JÁ criou uma nova conta: na última consulta, conta ID 58.
  Preserve a conta atual, seus ninjas, recursos, formação e vitórias.
- Não executar ferramentas de reset/zerar_conta/grant_local_resources sem
  um novo pedido. Não aumentar account_reset_version (hoje 1): ele limpa
  credenciais lembradas uma única vez após a limpeza já realizada.
- Naruto molde 13, Sasuke 35, Sakura 50: formação inicial posições 2,4,6.
  O login não deve recolocar um personagem removido pelo jogador.
- Todo teste que cria contas deve usar SQLite temporário, não o banco ativo.
- Não religar o tutorial. NR_ENABLE_TUTORIAL=1 serve só a fixtures antigas,
  em processos de teste isolados. O modo padrão do servidor/jogo é sem tutorial.

## Último problema corrigido

Usuário mostrou três personagens no cenário, mas só Naruto/Sasuke listados
como integrantes. Causa comprovada em ProtocolParserCopyExx.lua:
parse_return_red_alert_formation (6012) lê as seis vagas em _ED.formetion[2..7],
mas procurava cada herói apenas em [2..6], omitindo a última vaga (Sakura).
Além disso, marcava todos os incluídos com formation_index="1".

Correção aplicada diretamente no original recuperado:
01_conteudo_apk/assets/src/client/protocol/ProtocolParserCopyExx.lua
- Laço agora 2..7.
- formation_index passa a ser tostring(n-1), posição real de 1 a 6.
- Herói fora da formação mantém o estado de reserva original.

Reabrir o jogo para ler Lua novo. Não precisa recompilar nem resetar conta.

Validação:
- Probe nativo direct-menu verificou três ninjas ativos e índice correto
  para cada posição, incluindo Sakura na posição 6. Log:
  build/formation-starter-count.log (DIRECT_MENU_NATIVE_PASSED).
- tools/test_formation_slots.py passou: seis posições, troca/remoção,
  inclusão com cinco campos do cliente, propriedade e persistência.
- Probe de seis vagas verifica também formation_index individual:
  build/formation-six-count.log.
- Esses testes de parser não substituem conferir a lista visual após relogin.

## O que já está implementado

1. Conta/login local persistente; retorno do perfil sem o ciclo antigo em 9%.
2. Tutorial desativado em tutorial_disabled.lua: missões educativas e roteiros
   de tutorial de batalha não iniciam. Não é apenas esconder os círculos.
3. Três personagens iniciais com IDs distintos e avatar inicial válido.
4. Inventário do login inserido na posição correta entre os campos do parser 3.
5. Combo-card parser 471 inicializa coleção/limite, corrigindo contador nil.
6. Seis posições persistentes em local_formation_slots; troca, remoção e relogin.
7. manual_formation.lua fornece seleção manual sem depender da construção de
   uma página pelo tutorial; formation_empty_slots.lua mantém “+” nas vagas.
8. Síntese individual prop_compound: custos das tabelas, consumo uma vez,
   personagem persistente; IDs separados dos iniciais. Não cobre todas as
   composições nem múltiplas cópias do mesmo ninja.
9. Primeira qualidade de Naruto (implementação local limitada); não é sistema
   completo de evolução/estrelas de todos os personagens.
10. Liberação de mapas usa open_level (coluna 5) e by_open_scene (17), em vez
    da coluna 16 que aponta para capítulos seguintes. Catálogo com 500
    definições, incluindo modos especiais. Não significa 500 mapas validados.
11. draw_scene_rewad concede moedas/itens e salva recibo único/flags. Valida
    estrelas. Baús com equipamentos/personagens diretos ainda são recusados.
12. Sakura aparece na recompensa antes de tocar: esqueleto original e camada
    inicial estacionária; remover apresentação inicial se o clique a substituir.
13. Correções anteriores de danos/Total DMG, TAP, callbacks de animação,
    transição de ondas, blend de efeitos e dependências numéricas do menu.
14. FightObject.lua trata ausência de informação opcional de mega-evolução.

## Limitações reais / ordem de trabalho

1. Conferir o patch atual: três ninjas na lista e contagem, em batalha e reservas
   coerentes. Verificar relogin e formação sem recolocar herói removido.
2. Testar seleção pelo “+” e a inclusão manual: abrir janela, escolher ninja,
   mover, retirar, substituir, salvar e relogar. O fallback existe, mas o
   percurso visual completo ainda precisa de teste com o usuário.
3. Testar o primeiro NPC do mapa (o usuário chamou de lobo), abrir preparação,
   iniciar luta, concluir e voltar. O tutorial não deve bloquear cliques.
4. Testar todo um capítulo e a abertura do seguinte por nível/pré-requisito.
5. Recompensa elegível: mostrar itens e aumentar inventário; reenvio/relogin
   não pode duplicar. Não fingir sucesso de tipos ainda sem implementação.
6. Recrutamento normal: o backend anterior cobre a Sakura inicial e casos
   limitados; draw pago/x10 e economia geral não estão completos. No modo
   atual Sakura já existe; não tratá-la como única recompensa universal.
7. Melhorias/estrelas, equipamentos, skills, perfil e demais menus por área,
   com dados e custos originais, persistência e validações do servidor.
8. Verificar combate com várias formações, animações/efeitos, Total DMG,
   vitória/derrota e retomada. Não declarar paridade total ou jogo finalizado.

## Arquivos importantes

- port/gameplay.json; port/server/gameplay_mode.py
- port/lua/tutorial_disabled.lua; manual_formation.lua
- port/lua/battle_lifecycle.lua; profile_parser_dependencies.lua
- port/server/contas.py; local_server.py; recruitment_local.py
- port/server/tutorial_campaign.py; tutorial_synthesis.py; scene_rewards_local.py
- port/lua/formation_empty_slots.lua; formation_lifetime.lua
- port/lua/recruit_visible_hero.lua
- Originais modificados: ProtocolParserCopyExx.lua (6012) e
  client/battle/report/FightObject.lua (mega-info opcional).
- port/lua/menu_boot_probe.lua contém cenários diagnósticos, não o fluxo normal.

## Ambiente e ferramentas

Workspace E:\[code]\nk; N: mapeia esse diretório. PowerShell precisa de
LiteralPath por causa dos colchetes. Há muitas mudanças locais, feitas em
sessões anteriores: não usar git reset/clean/checkout para descartá-las.

Inicializador: E:\[code]\nk\port\server\jogar_local.bat
Executável: build/windows-probe-native/bin/NinjaResourceProbe/Debug/NinjaResourceProbe.exe
Banco ativo: port/dados/contas.sqlite3
Servidor: 127.0.0.1:18080; controle local opcional 18081.
Identificar o dono da porta antes de reiniciar; não abrir servidores duplicados.
Lua/Python não exigem recompilar a engine. Reabrir jogo após mudar Lua;
reiniciar servidor após mudar Python (recarga só cobre módulos específicos).

```powershell
Set-Location -LiteralPath 'E:\[code]\nk'
$nrPython = 'C:\Users\! I T A C H I\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe'
& $nrPython tools/test_direct_menu.py
& $nrPython tools/test_formation_slots.py
```

Ler os outros testes antes de executar: alguns são específicos do antigo modo
de tutorial e exigem NR_ENABLE_TUTORIAL=1 apenas em seu processo temporário.
Não alterar o modo de produção para fazer um teste legado passar.

Assets: build/assets-audit.json registra 38.547 arquivos e 753 retratos;
uma página ausente conhecida: sprite/sprite_fudan2.png. Não inventar imagem
substituta sem conferir atlas. As texturas devem carregar por tela.

Se usar computer-use, ler a skill disponível primeiro. O node_repl apresentou
erro de glob de permissões com E:\[code]\nk em tentativa anterior; não
confundir isso com falha do jogo. Capturas dos testes nativos são artefatos
do diagnóstico, não prova de interação visual ao vivo.

## Pedido para a próxima IA

Continue este projeto a partir do código atual e deste documento. Primeiro
confirme a correção da contagem da Sakura/sexta vaga. Depois teste e corrija
seleção manual da formação e primeiro NPC do mapa. Mantenha o tutorial
DESATIVADO e os três personagens iniciais. Preserve a conta atual e todas as
mudanças locais. Trabalhe por área conforme o usuário relatar. Use janelas,
assets, protocolos e tabelas originais; faça testes isolados e não retorne
ACK vazio para disfarçar comando essencial não implementado. Informe o que
foi corrigido, testado e o que ainda não foi validado visualmente.
