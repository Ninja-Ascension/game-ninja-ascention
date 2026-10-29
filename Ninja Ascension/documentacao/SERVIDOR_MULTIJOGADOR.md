# Servidor para vários jogadores — etapa 1 (sessão por jogador)

Data: 27/10/2026.

## Problema encontrado
- O servidor guardava **uma única sessão global** (`_sessao_conexao`). Todo pedido era tratado como sendo da última conta que fez login. Com dois jogadores, as ações de um cairiam na conta do outro.
- `search_user_platform` sem sessão **criava uma sessão válida da conta com mais progresso** (a conta principal) para quem perguntasse.
- Um login "lembrado" (`@tk1:<token>`) com chave inválida **reemitia sessão** sabendo só o nome da conta.
- A batalha em andamento era uma só para o servidor inteiro.
- O protocolo original não envia credencial em cada pedido, só o `user_id`, que não é secreto.

## Correção
- **Modo público** (`port/server/local_server.py`): ativo quando `NR_HOST` não é `127.0.0.1`/`localhost`/`::1`, ou com `NR_EXIGIR_SESSAO=1`.
  - Cada pedido é identificado pela chave da sessão em `?s=<token>` no endereço. Não há sessão global nem conta "lembrada".
  - `search_user_platform` sem chave responde ACK sem conta; a janela de login original já está aberta e pede usuário/senha.
  - Login lembrado com chave inválida é recusado.
- **Modo local** (padrão atual, `127.0.0.1`): o comportamento antigo continua, mas uma chave presente no pedido tem prioridade.
- A batalha em andamento passou a ser guardada por sessão.
- **Cliente** (`port/lua/session_url.lua`, armado em `boot_map.lua`, etapa 3b3b): anexa `?s=<userLoginToken>` a cada pedido HTTP no momento do envio. `userLoginToken` é a variável que o próprio jogo preenche no parser 327. O corpo do protocolo não muda. O gancho é reinstalado se o jogo recarregar `frameworks.network.NetworkAdaptor`.
- O mesmo módulo deverá ser incluído no APK quando ele for gerado (os scripts do APK são texto, não criptografados).

## Testes
- `tools/test_sessao_publica.py`: servidor real em modo público, banco temporário, escutando só em 127.0.0.1. **PASSOU**. Cobre dois jogadores intercalados e isolados, nenhuma conta entregue sem chave, chave inventada/ausente recusada, login lembrado inválido recusado e senha errada recusada.
- `session_url.lua` testado no LuaJIT do próprio jogo (`lua51.dll` via ctypes): **PASSOU**. Cobre anexar, trocar, remover e recusar chave malformada, não mexer em WebSocket e reinstalar após recarga.
- Regressão do modo local: `test_ninja_school_local`, `test_hero_stats_local`, `test_shop_local`, `test_quest_local`, `test_hero_level_local`, `test_login_token`, `test_sessao_perfil` e `test_contas_e2e` passaram.
  - `test_local_server`, `test_search_user_platform` e `test_saved_profiles` já falhavam com o arquivo original: esperam um comportamento de login anterior ao ajuste de sessão única.
- Não testado no executável (o cliente não abre nesta VPS) nem no celular (APK ainda não gerado).

## Etapa 2 — jogo pela internet (27/10/2026) — FUNCIONANDO

Confirmado pelo usuário: o cliente PC em outro computador conectou na VPS (181.215.236.218:18080) e entrou no jogo.

- Servidor: `INICIAR_SERVIDOR_PUBLICO.cmd` (janela visível, `NR_HOST=0.0.0.0`). O usuário criou a regra de firewall de entrada TCP 18080.
- Lista de servidores (`new_get_server_list`):
  - Nome "Servidor 1" (`NR_SERVER_NAME`). O espaço vai como U+00A0 porque o protocolo separa campos por espaço ASCII.
  - `server_link` = o Host pelo qual o jogador chegou, ou `NR_PUBLIC_URL`. Antes era sempre 127.0.0.1, e o START ficava carregando para sempre.
  - O XHR nativo do cliente envia `Host` sem porta; o servidor completa com a porta própria.
- Cliente PC:
  - `port/resources/servidor.txt` define o endereço, lido pelo caminho absoluto. Sem ele, o padrão continua localhost.
  - A trava de rede aceita apenas loopback e o servidor configurado.
  - `EditBox.touchDownAction` → `openKeyboard` (campos de login no Axmol).
  - `quest_local` espera a tabela de protocolo existir antes de instalar.
- Pacote de distribuição: `distribuicao/NinjaRevolution` e `NinjaRevolution_PC.zip`.
  - Só `Ninja Revolution.exe` fica visível; o resto vai na pasta oculta `dados`.
  - O iniciador abre o jogo sem console, com a pasta de trabalho na raiz `dados`, porque o Axmol resolve `res`/`src` a partir do diretório de trabalho.
  - Ele também recria as junções `res`/`src` quando a pasta é movida.
  - `DIAGNOSTICO.cmd` grava `diagnostico.txt`.
- Limitação: o executável continua Debug e exige o runtime de depuração do Visual Studio. Para "qualquer Windows" falta a compilação Release.

## Atualização automática do cliente PC (27/10/2026)
- O iniciador `Ninja Revolution.exe` atualiza antes de abrir o jogo:
  - baixa `GET /atualizacao/manifesto.json` do servidor de `servidor.txt`;
  - compara o SHA-256 de cada arquivo e baixa só os diferentes de `/atualizacao/arquivos/<caminho>`;
  - confere o hash e substitui o arquivo; sabe trocar a si mesmo (renomeia para `.old` e abre o novo);
  - registra o que fez em `dados/atualizacao.log`;
  - se o servidor não responder, avisa e abre o jogo com os arquivos atuais.
- Servidor: `port/server/atualizacao_cliente.py`, que serve a pasta `jogo/atualizacao/` (ou `NR_ATUALIZACAO_DIR`).
  - Só aceita caminhos em `port/`, `01_conteudo_apk/`, `build/windows-probe-native/`, `Ninja Revolution.exe` e `DIAGNOSTICO.cmd`.
  - Tentativas de sair da pasta (`..`, `%2e%2e`, barra invertida, letra de unidade) devolvem 404. Isso foi testado.
- **Publicar uma correção do cliente:** `python tools/publicar_atualizacao.py --automatico`, ou passando os caminhos dos arquivos. A ferramenta copia para `atualizacao/` e para `distribuicao/NinjaRevolution`. Não precisa reiniciar o servidor para publicar.
- Testado na VPS com cliente e servidor isolados: script substituído, arquivo novo criado, iniciador autoatualizado e segunda execução sem nada a baixar.
- Não dá para atualizar com o jogo aberto: a atualização acontece na próxima vez que o jogador abrir pelo iniciador.

## Nomes de personagem únicos (27/10/2026)
- `contas.apelido_em_uso` / `apelido_livre`: o nome do personagem é único no servidor, sem diferenciar maiúsculas.
  - `register` acrescenta um número quando o nome está em uso.
  - `user_info_modify` recusa nome em uso (`nome_em_uso`).
  - `get_random_name` sorteia um nome livre. Antes era fixo por índice, e todas as contas viravam "Kage_Ninja".
- Teste: `tools/test_nomes_unicos.py`. Nomes já repetidos antes da correção (contas 62 e 63, "Kage_Ninja") não foram alterados.

## Compilação Release (27/10/2026) — PUBLICADA (funcionou no PC de um colega sem Visual Studio)
- Ferramentas: VS 2019 Build Tools (MSVC 14.29), já instaladas na VPS, e CMake 3.31.6 portátil, baixado com autorização e conferido por SHA-256, em `build/ferramentas/`.
- A pasta com espaço quebra os scripts da engine. É preciso `subst W: "...\Ninja Ascension\jogo"`, que é temporário e some ao reiniciar.
- Configurar e compilar:
  - `cmake -S W:/port -B W:/build/windows-release -G "Visual Studio 16 2019" -A x64 -DAX_ROOT=W:/build/deps/axmol -DNR_REFERENCE_ROOT=W:/`
  - `cmake --build W:/build/windows-release --config Release --target NinjaResourceProbe`
- `port/CMakeLists.txt` ajustado:
  - sem `.git`, a versão do Axmol é conferida por `axmolver.h.in` + `CHANGELOG`, e o Spine pelos 26 fontes + header (o `axmolver.h` é regenerado pela engine a cada configuração e não prova nada);
  - `/NODEFAULTLIB:MSVCRT` passou a valer só no Debug.
- Saída: `build/windows-release/bin/NinjaResourceProbe/Release/`.
  - Não depende de DLLs de depuração.
  - `msvcp140.dll`, `vcruntime140.dll` e `vcruntime140_1.dll` (redistribuíveis do VC142) vão junto, no mesmo diretório.
- **Causa do 0xC0000005 ao criar a janela (VPS e PC do colega):**
  - O ANGLE (`libGLESv2.dll`) foi linkado com MSVC 14.44 e quebra em `MSVCP140!Thrd_yield` quando carrega uma `msvcp140.dll` antiga.
  - Pilha: `EGL_QueryString` → `glfwInitEGL` → `RenderViewImpl::createWithRect`.
  - O VC142 14.29 que tinha sido incluído no pacote era antigo demais.
  - Passaram a ir junto `msvcp140.dll`, `vcruntime140.dll` e `vcruntime140_1.dll` **14.40.33617.1**, cópias oficiais e assinadas do redistribuível da Microsoft. Com elas, o Release abre na própria VPS, conecta ao servidor e roda. Primeira execução do cliente nesta VPS.
- O Release agora deixa `stdout`/`stderr` sem buffer e gera um PDB (`build/windows-release/.../NinjaResourceProbe.pdb`, mantido aqui, não distribuído).
- `falha-nativa.txt` traz `modulo+offset` em cada quadro da pilha, para resolver aqui relatórios vindos de outros PCs.
- Distribuição: os binários Release substituem os da pasta `.../NinjaResourceProbe/Debug/`, para não mudar o caminho usado pelo iniciador. Só publicar pela atualização automática depois do teste manual (`TESTE_RELEASE_NinjaRevolution.zip`).

## Proteção dos assets (decisão do usuário)
- A pasta `dados` é necessária ao cliente; deixá-la oculta é só cosmético. Servidor e banco não vão no pacote.
- **Último passo antes de distribuir:** compilar os scripts Lua em bytecode LuaJIT, para que o código não fique legível.
- Empacotar e criptografar imagens e sons fica junto com a compilação Release, porque exige alterar o motor.

## Ainda não feito (próximas etapas, com autorização)
- Servidor escutar fora de `127.0.0.1` e abrir a porta no firewall.
- Domínio/proxy (ex.: Cloudflare) e HTTPS.
- APK e cliente PC apontando para o endereço da VPS.

Reinício: o servidor carrega isso ao ser iniciado. O cliente PC precisa ser reaberto para carregar `session_url.lua`.

## Caixa de texto, avatar e EXP do jogador (2026-10-27)

- **Digitação dentro do jogo** (`port/lua/editbox_inline.lua`): todo `ccui.EditBox` ganha um
  `ccui.TextField` por cima, com cursor `|`, senha `*` e limite de caracteres. A caixa branca
  nativa do Windows não abre mais. Testado no VPS (login e cadastro).
- **Troca de avatar** (`port/server/profile_local.py`): `user_info_modify` tipo 1 valida contra
  a mesma regra do cliente (avatares básicos de `user_config` 15 + forma de evolução dos ninjas
  que a conta possui), grava em `local_profile_head` e o login devolve o avatar no campo 31.
  Tipos 2 (assinatura) e 3 (imagem) continuam recusados; molduras de avatar não implementadas.
- **EXP do jogador** (`port/server/player_level_local.py`): regra original — cada vitória dá EXP
  igual à energia da batalha (`npc.attack_need_food`). Tabela `user_experience_param`: EXP
  necessária, capacidade de energia e recompensas de subida (energia/resistência/ouro).
  Respostas usam os parsers originais 40 (subiu de nível), 41 (EXP) e 29 (energia).
  Resultado de batalha repetido não dá EXP de novo (`local_battle_done`).
- **Limitações**: energia ainda não é descontada no servidor; contas existentes começam com EXP 0
  na nova tabela (nível mantido); nomes duplicados antigos (contas 62/63) não foram alterados.
- Teste: `jogo/tools/test_perfil_e_nivel.py`.
