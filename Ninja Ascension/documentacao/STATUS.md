# STATUS — port Ninja Revolution (Windows / Axmol 2.11.5)

## Fase 3.1 — vínculo sessão/conta/perfil (estado de hoje)

Rodada de correção sobre a Fase 3. O que estava **errado** e foi corrigido:

| Antes | Agora |
|---|---|
| `vali_register` aceitava qualquer conta que **existisse** no banco | exige **sessão válida da mesma conta**; conta sem sessão → `-1` |
| `login_init` usava `_token_lembrado`, um global do processo que atravessava contas | identidade vem **do próprio pedido** (`userLoginToken`/`m_sUin`, que o acervo já envia) |
| `user_id` do `login_init` era **`"1"` fixo** para todas as contas | é o **perfil real** da conta autenticada |
| sem sessão, caía no perfil **"Convidado"** | sem sessão → **recusado** (`sem_sessao_valida`); o rótulo não existe mais |
| `vali_register` devolvia `platform_id = "1"` | devolve o **id real** da conta |
| logout não revogava nada no servidor | `local_logout` revoga a sessão; cliente limpa `m_sUin`/token/`_ED.user_platform` |
| token lembrado valia para sempre | `@tk1:` **rotaciona**: revoga o antigo e emite novo |
| `login_get_server_list` era chamado sozinho (auto-login) | o jogo **sempre começa na tela de conta** |

### Como a identidade viaja (adaptação documentada, nada inventado no protocolo)
O acervo **já manda** o necessário em todo `login_init`
(`ProtocolCommanderCopy.lua:100-129`): versão, idioma, param_list,
`userLoginPackageName`, **`userLoginToken`**, `getPlatformParam()`, **`m_sUin`**,
`m_sSessionId`. `userLoginToken` é global preenchida pelo parser 327
(`ProtocolParser.lua:1197`), logo o token da sessão viaja nos pedidos
seguintes. `vali_register` manda `platform_account` (`login.lua:706/708/745`).

O servidor procura conta e token no corpo (`_identidade_do_pedido`) e valida
com `Banco.sessao_de(token, conta)`, que recusa:
`sessao_invalida` (token inexistente/malformado), `sessao_expirada` (linha
apagada) e `sessao_de_outra_conta` (token da conta A pedindo a conta B).

Fallback `_sessao_da_conexao` existe **só** para pedidos sem token (o C2S 3
`search_user_platform` não leva credencial) e é **sempre revalidado** no banco.

### Por que o GAME START sumia depois de "login success"
`AccountSysManager:onUpdataDraw` (`AccountSysManager.lua:278-308`), com
`account_automatic_login == "2"` e um nome salvo, **esconde** a janela
(`setVisible(false)`) e entra sozinho. O jogo já abria autenticado como a
conta lembrada, `login_get_server_list` disparava sem lista visível e o
jogador ficava sem a tela de conta e sem o START. O adaptador agora grava
`account_automatic_login = "1"` (desmarcado) e imprime
`HOST_ACCOUNT_UI login automatico desativado`.

### Botão Voltar
O vigia de 1 s reabria a janela no tick seguinte, o que fazia o Voltar
parecer quebrado. Agora, fechada pelo jogador, ela **só** reabre pelo caminho
do acervo no GAME START (`login.lua:407-414`) — o adaptador deixa de competir.

### Comandos entre login e menu
- **Implementados com resposta real**: `new_get_server_list` (58),
  `platform_user_register` (326), `platform_user_login`/`search_user_platform`
  (327), `vali_register` (57), `login_init` (3), `user_create_time` (1602),
  `get_system_notice` (999), `local_logout` (extensão local).
- **ACK neutro só da lista explícita** (`SEM_OPERACAO`): `record_crash`,
  `keep_alive`, `email_init`, `union_init` — cada um com justificativa medida
  (os dois últimos têm callback vazio: `LoginLoading.lua:650-666`, e não há
  parser S2C 49/127).
- **Qualquer outro**: `-3 nao_implementado` + `[PENDENTE]` no `server.log`.
  Nada mais é escondido com sucesso genérico.

### Testes automatizados (resultado real desta rodada)
| suite | resultado | cobre |
|---|---|---|
| `tools/test_sessao_perfil.py` (novo) | **36/36** | token de A pedindo B, sem sessão, expirada, revogada, logout, rotação, alternância de 2 contas, `user_id` lido do parser, formato do anúncio, logs sem segredo |
| `tools/test_contas_e2e.py` | **29/29** | cadastro, duplicado, senha errada, PBKDF2, reinício, servidor desligado |
| `tools/test_local_server.py` | OK | formatos 58/3/1602/999/57 contra servidor real |

Corrigido também um bug de teste que travava o servidor: stdout ia para um
`PIPE` sem leitor e o buffer de log (~64 KB) bloqueava dentro de `log()`.

> **O que estes testes NÃO provam**: que a tela de conta e o menu aparecem
> para o jogador. Isso é clique humano (regra 12) e continua pendente.

## Fase 3 — contas reais (Entrar / Criar conta), estado de hoje

> **HISTÓRICO desta seção**: três afirmações abaixo foram SUPERADAS pela
> Fase 3.1 (acima) e ficam registradas só para não se perder o contexto:
> `vali_register` "só aceita conta cadastrada" (agora exige sessão da conta),
> o perfil de `login_init` (antes `user_id` 1 fixo e "Convidado"), e o locking
> como única proteção do START. O texto de diagnóstico da janela de conta
> (shim `getFrameSize`, senhas em claro) continua VÁLIDO.

### O que mudou em relação à Fase 2 (e o que deixou de ser verdade)
A Fase 2 fechava o clique com uma conta de convidado automática
(`convidado_windows`) e um `token_local` constante. Isso foi **removido a
pedido do usuário**: não pode existir login automático que contorne o
cadastro, e o token não pode ser constante.

- `port/server/contas.py` (novo): banco SQLite em
  `port/dados/contas.sqlite3`, PBKDF2-HMAC-SHA256 com salt por conta
  (200k iterações), sessões individuais de 43 chars base64url e perfis
  por conta.
- `port/server/local_server.py`: 9001/9002 deixam de ser provisórios —
  validam de verdade, recusam com status -1 + mensagem (caixa de erro do
  acervo, NetworkProtocol.lua:184), e `vali_register` só aceita conta
  cadastrada.
- `port/lua/local_sdk_guest.lua`: síntese dos branches do SDK sem
  convidado (LOGIN adiado enquanto `m_sUin` está vazio).
- `port/lua/account_ui.lua` (novo): abre a janela de conta ORIGINAL do
  acervo no desktop e corrige três lacunas que a impediam de funcionar.

### Por que a janela de conta não abria no Windows
1. `Login:onEnterTransitionFinish` roda (é ela que monta o fundo e o
   START), mas o bloco de conta (login.lua:1727-1774) morre dentro de
   `AccountSysFloatingWindow:onEnterTransitionFinish`, que chama
   `getOpenGLView():getFrameSize()` (AccountSysFloatingWindow.lua:213) —
   no Axmol `getOpenGLView` é shim de `getRenderView`, que não tem
   `getFrameSize`. O adaptador completa esse shim e abre a janela
   original (`account_sys_manager_open`).
2. START sem conta: o acervo já faz o certo — `login_check_first`
   (login.lua:403-414) reabre a janela quando `login_vali_register` está
   travado. O adaptador aplica o lock (como login.lua:1729) para que o
   GAME START nunca entre sem autenticação.
3. Senhas do cadastro apareciam em claro: para OperatorName `t4` o acervo
   passa `KEYBOARD_RETURNTYPE_DONE` no lugar da bandeira
   (AccountSysRegister.lua:249-254), deixando os EditBox como
   SINGLELINE. O adaptador reaplica `EDITBOX_INPUT_FLAG_PASSWORD`
   (valor 0 no Axmol: `EditBox::InputFlag::PASSWORD`, UIEditBox.h:171).
4. Envios duplicados: `NetworkManager:register` só recusa comando repetido
   enquanto ele está na fila (127-130); dois toques rápidos mandam dois
   9002. O adaptador embrulha 9001/9002 com uma trava de "em voo".

### Telas usadas (todas do acervo, nada recriado)
- `login/register/register_prompt_1.csb`: `Button_login` (Entrar, x=590
  y=186), `Button_register` (Criar conta, x=377 y=186), `TextField_1`
  (usuário, y=382), `TextField_2` (senha, y=308, mascarada),
  `CheckBox_1` (lembrar conta).
- `login/register/register_prompt_2.csb`: `TextField_3` (usuário, y=394),
  `TextField_4` (senha, y=319), `TextField_4_0` (confirmar, y=246),
  `Button_1077` (voltar, x=377 y=186) e `Button_register` (criar, x=590
  y=186). Posições medidas no JSON convertido: não há sobreposição.
- Botão flutuante de conta (`register_prompt_3.csb`): mostra a conta
  conectada (senha em asteriscos) e tem sair/trocar.

### Contrato do protocolo (detalhado em port/server/data_minimos.txt, item 09)
| comando | pedido | resposta | parser |
|---|---|---|---|
| platform_user_register 9001 | usuario, senha, confirmação, pkg | 326 conta | 1161 |
| platform_user_login 9002 | usuario, segredo (senha ou `@tk1:<token>`), pkg | 327 conta, token, pkg, create_time | 1193 |
| search_user_platform 3 | — | 327 da sessão lembrada, ou -1 | 1193 |
| vali_register 7 | conta, servidor, plataforma, tipo | 57 (só conta cadastrada) | 3366 |
| login_init 8 | pkg, versão, idioma | 3 com 96 tokens do PERFIL da conta | 72 |

### Provas automatizadas (não visuais)
- `tools/test_contas_e2e.py`: **26/26** sobre o codec real do jogo —
  cadastro válido, campos vazios, duplicado, senhas diferentes, nome
  inválido, senha errada, usuário inexistente, token de 43 chars único
  por login, login por token, `vali_register` só para conta real,
  perfis isolados, PBKDF2 no banco (senha ausente), logout revoga,
  reinício do servidor preserva a conta, servidor desligado falha.
- `tools/test_local_server.py`: contrato do protocolo contra o servidor
  no ar (58, 96 tokens, 1602, 326/327, ACK neutro, recusas).
- `tools/probe_menu.py`: cadastro → login → lista → vali_register →
  login_init (perfil da conta) → ecos.
- Boot do jogo: `3b3`/`3b4` OK, janela de conta aberta, lock aplicado,
  trava de duplicados ativa, **zero `LUA ERROR`**.

### Avisos de console que restam — o que é cada um (medido no APK)

O console repete `fullPathForFilename: No file found at ...`. Nenhum desses
é extração incompleta: comparei cada um com as 43.316 entradas do APK
original.

| aviso | veredito |
|---|---|
| `data/*.txt` (35 itens) | **corrigido**: a lista flat do acervo pede na raiz de `data/`, mas o arquivo está em `data/mould/`. `port/lua/data_paths.lua` carrega do caminho certo — provado com dado real (`equipment_mould[1]` deixa de ser vazio). |
| 13 `data/...` restantes | Não existem em NENHUM lugar dos recursos; eram baixados como patch pelo cliente Android. Ficam como tabela vazia (registrado uma vez, sem repetir o aviso). Lista fechada em `tools/auditar_dados_ausentes.py`. |
| `.\socket/core.lua` | `NetworkAdaptor.lua:10` chama `pcall(require, "socket.core")` só para obter um **relógio com decimais`, com fallback `os.time()`. `socket.core` é módulo nativo C (`libjts.so` no Android) — não existe no Windows e o `pcall` já trata. O caminho LuaSocket/WebSocket está morto neste build: todos os `NetworkAdaptor.socketInit(...)` do cliente estão comentados. |
| `Default/DemoPlayer.ExportJson` | Não está no APK. É a demo de exibição do editor (cocos), opcional. |
| `images/ui/login/button_gongguang.png` | **Asset quebrado no próprio jogo original**: o widget existe em `login.csb` e aponta para esse PNG, mas o APK não tem o arquivo. O motor apenas não desenha a imagem. |
| `images/ui/login/fangchenmi.png` | Botão de anti-vício (China). O jogo procura o widget `Button_fangchenmi`, que **não existe** em `login.json` — o código já faz `if ~= nil`. No APK só existe o layout `tuichu_fangchenmi.csb`, nunca esse PNG. |
| `Arial` / `Helvetica` | Sondagem de fonte do sistema; no Windows cai na fonte embutida. |

### Trafego de rede: somente 127.0.0.1 (corrigido)
O `app.config` original traz nas linhas 27-28 o host real do jogo
(`http://104.251.218.95:18080/iniServer`) em DUAS chaves: `url` e
`urlForAnnounce`. O redirecionamento antigo trocava só `url`; o anúncio do
sistema (`get_system_notice`, comando 66, `login.lua:2017`) saía para a
internet com o nome de conta do jogador. Agora as duas chaves vão para
127.0.0.1, são reafirmadas depois de `ProtocolCommander.replaceDomainName()`
e `NetworkAdaptor.send` **recusa** qualquer URL que não seja
127.0.0.1/localhost, imprimindo `HOST_NET_GUARD bloqueado: <comando> -> <url>`.
Verificado: 0 tentativas fora do loopback.

### Limitações que ainda impedem dizer "fluxo completo validado"

- **Validação visual é do usuário (regra 12)**: eu não clico nem vejo a
  tela (o modelo desta sessão não lê imagens). O que está provado é o
  protocolo e o boot, não o que aparece na tela.
- Recuperação de senha: existe tela no acervo
  (`AccountPasswordRecoveryWindow`) mas **não** foi implementada — não há
  serviço real de e-mail, então nada de recuperação fictícia.
- "Voltar" no cadastro usa o botão do próprio acervo
  (`Button_1077` → `account_sys_register_close`); o fechamento por tecla
  Esc não foi confirmado.
- O `record_crash` do boot (14 envios) é comportamento original do jogo
  (app.lua:385-396 com o texto do erro anterior); não é laço infinito e
  não afeta o login.

---

## Fase 2 — servidor local do fluxo login→menu  (cortes 1–7)


Commits: `dc20aa3` (redirect+prova E2E) → `840057d` (login_init 96 tokens)
→ `0ef4ba6` (vali_register + URL completo no Windows) → `9fe0c81`
(prova: parsers reais 58→57→3 consumindo respostas vivas, resto=0)
→ `86d87e9` (ACK neutro para comandos não previstos) → `bd9a679`
(prova da ordem dos campos do parser 58) → `a390bba` (sistema de conta
próprio + guest de 1 clique).

### Respostas servidas (port/server/local_server.py, v10b)
| comando (C2S) | resposta | parser | fonte |
|---|---|---|---|
| new_get_server_list | 58, 1 servidor "Local", URL completo | parse_get_server_list | ProtocolParserCopy.lua:3469 |
| vali_register | 57 type 2, eco da conta | parse_vali_register | ProtocolParserCopy.lua:3366 |
| search_user_platform / platform_user_login | 327 da conta real + sessão individual | new_platform_user_login_information | ProtocolParser.lua:1193 |
| platform_user_register | 326 (conta criada de verdade) | new_platform_user_registration_information | ProtocolParser.lua:1161 |
| user_create_time | 1602 (ms presente) | parse_user_create_time | ProtocolParserCopyEx.lua:2588 |
| login_init | 3 (96 tokens) | parse_login_init | ProtocolParserCopy.lua:72 |
| ecos (ship/email/union/gm…) | status 0 sem 4º token | — (break :145-148) | NetworkProtocol.lua |
| desconhecido | ACK neutro (status 0) | — | log marcado [AVISO] |

### Caminho do clique (Windows, t4-quick) — HISTÓRICO da Fase 2
> Substituído na Fase 3: não há mais conta de convidado nem `token_local`,
> e a janela de conta abre pela via descrita no topo deste arquivo.
> O texto abaixo fica como registro do que foi medido na Fase 2.
handlePlatformRequest termina em `app.lua_bridge:call` (inexistente no
desktop) — `Login:onEnterTransitionFinish` não dispara no boot deste
build, então a janela de conta original não abre sozinha. O adaptador
`port/lua/local_sdk_guest.lua` (stage 3b3, gated por
`app.configJson.local_sdk_adapter=true`) semeia a conta convidada
persistida (`convidado_windows`) → `fury_sdk_local_listo` (login.lua:16)
marca o SDK pronto → **1 clique no GAME START**: vali_register (57) →
login_init (3, 96 tokens) → registerUrl(server_link) → Menu +
LoginLoading → user_create_time (1602) + ecos.

Cadeia auditada linha a linha (login.lua): `Button_play` →
`login_check_first` (1577-1587 → 415; o lock do vali vive só no bloco da
transição que não roda) → terminal `login_vali_register` (422-431:
fury_sdk_local_listo ✓) → gate de precarga (444-451, marca
`_isClickLoginEnterGame` e devolve) → `onUpdate` completa a precarga
LOCAL (1793-1846, tabelas `data_path`, sem rede) e RE-INVOCÁ velho
terminal sozinho (2033-2034) — sem segundo clique → vali (57) →
responseValiRegisterCallback (456, `is_registered=true` via 57)
→ login_enter_game (575) → login_init (3).

### Provas feitas (não visuais)
- Harness opt-in (`NR_PROBE_PARSE_CHAIN`): os próprios parsers do acervo
  consomem as respostas vivas do servidor via o transporte do jogo
  (lista58 selecionado=1; vali57 convidado_local; login3
  Convidado/nível 1; resto=0 nos três; seq/lock restaurados).
- Suíte standalone: 9 formatos; fumaça do exe: wrapper instalado,
  zero trackbacks; server.log marca (`[AVISO]`) qualquer comando não
  previsto (ACK neutro, sem diálogo de erro — NetworkProtocol.lua:184).
- **Auditoria LoginLoading→Menu (conta nova, zero naves)**:
  `checkLoginLoading` com loginIn=true NÃO passa pelo ramo de
  criação/missões (LoginLoading.lua:385-395); `_ED.user_ship` existe
  vazio (EnvironmentDatas.lua:484/5882 e o próprio parse 3,
  ProtocolParserCopy.lua:515) → o loop de %50-65 (410-413) itera zero
  vezes; `loadingSuccess` (428) só dispara os ecos já servidos e abre o
  Menu (app.load + fwin:open + menu_show_home_page). Nenhum comando
  novo no caminho até a tela abrir.

### Pendente
- Validação visual do usuário (regra 12): START → lista "Local" →
  LoginLoading → Menu.
- Comandos novos que apareçam com `[AVISO]` no server.log viram respostas
  reais do acervo na sequência.

### Onda do Menu (pós-abertura) — por que ACK neutro basta
Os ~20 registros de rede do `client/home` (order/secret_shop/destiny/
union/first_charge/week_active/reward_center/...) são de células e
janelas específicas; os callbacks rodam no mesmo ramo de sucesso que
rodariam com dados VAZIOS de servidor real — e a existência de contas
novas no jogo original prova que todo esse código tolera estado vazio
(EnvironmentDatas pré-cria os defaults, `ProtocolParserCopy.lua:515`).
O ACK neutro (status 0 sem 4º token, NetworkProtocol.lua:145-148)
os coloca exatamente nesse ramo. Qualquer exceção que reste sai no
console com TRACKBACK e vira resposta real na hora.
