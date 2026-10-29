# Como jogar e testar o local (Fase 2 / Fase 3 — contas)

## 1. Ligar o servidor e abrir o jogo
Duplo-clique em **`port\server\jogar_local.bat`**.
- Ele sobe o servidor local (janela minimizada) se a porta 18080 estiver
  livre, e então abre o jogo.
- Se aparecer "porta 18080 ocupada — pode fechar a janela", já existe um
  servidor no ar: continue normalmente.

Alternativa manual:
1. `port\server\ligar_local_server.bat` (mantém a janela do servidor aberta
   para ver as linhas em tempo real);
2. abrir `build\windows-probe-native\bin\NinjaResourceProbe\Debug\NinjaResourceProbe.exe`.

O banco de contas é criado na primeira execução em
**`E:\[code]\nk\port\dados\contas.sqlite3`** (fora dos recursos originais e
fora do disco C). Apagar esse arquivo zera todas as contas.

## 2. Criar a primeira conta
1. Espere a tela de login e o fundo original aparecerem.
2. Se o **popup de idioma** abrir por cima, escolha o idioma e confirme —
   ele é modal e bloqueia os toques enquanto está aberto.
3. A **janela de conta** abre sozinha sobre o login (tela do próprio jogo):
   **Entrar** e **Criar conta**.
4. **Criar conta** → nome de usuário, senha, confirmar senha → **Criar conta**.
   - Nome: 3 a 20 caracteres, letras sem acento, números, `.` `-` `_`.
   - Senha: 6 a 32 caracteres, sem espaço e sem `|` (quebra o protocolo).
   - As duas senhas de cadastro ficam **mascaradas**.
5. Deu certo → volta para o login com o nome preenchido e a mensagem de
   confirmação do próprio jogo.

## 3. Entrar e chegar ao menu
1. Digite a senha → **Entrar**.
2. O jogo busca a lista de servidores → escolha **Local**.
3. **GAME START**. Sem conta autenticada ele reabre a janela de conta em vez
   de entrar (o `login_vali_register` fica travado, como no original).
4. Com a conta autenticada: validação da conta → `login_init` → **Menu**.

> **Mudança desta rodada**: o jogo **não entra mais sozinho** com a conta
> lembrada (`account_automatic_login`). Antes, ao abrir, ele autenticava a
> última conta, escondia a janela de conta e o GAME START "sumia". Agora ele
> sempre começa na tela de conta; o console mostra
> `HOST_ACCOUNT_UI login automatico desativado`.
> Se você fechar a janela no **Voltar**, ela **não** volta sozinha — só
> reaparece quando você aperta GAME START sem conta.

## 4. Trocar de conta / sair
- O botão flutuante de conta (lateral) mostra a conta conectada (senha
  sempre em asteriscos) e tem a opção de sair/trocar: ela **revoga a sessão
  no servidor**, zera a sessão local, volta ao Login e a janela de conta
  reabre.
- Sair de uma conta não afeta a outra: cada conta tem sessão e perfil
  próprios (`user_id` diferente).

## 5. Reportar problemas
- `powershell -File tools\diag_fase2.ps1` resume o que o jogo pediu ao
  servidor e em que passo a sessão parou.
- Console do jogo: procure `HOST_ACCOUNT_UI`, `HOST_LOCAL_SDK` e
  `HOST_SDK_TRACE` — eles dizem qual janela abriu e onde o fluxo está.
- `port\server\server.log` mostra cada comando servido (`cmd=... status=...`)
  e cada recusa de conta. Senhas e tokens completos NUNCA são registrados.

## 6. Testes automatizados
```
python tools\test_sessao_perfil.py   # 35 verificações: sessão/conta/perfil
python tools\test_contas_e2e.py      # 29 verificações, banco temporário
python tools\test_local_server.py    # contrato do protocolo (servidor no ar)
python tools\probe_menu.py           # cadastro -> login -> vali_register -> login_init
python tools\protocol_probe.py register USUARIO SENHA   # sonda manual
```
Todos rodam em porta e banco temporários no disco **E:** e não tocam no
`contas.sqlite3` real.

## Estado atual do login (leia antes de testar)
O ciclo **ainda não chega ao menu**. Isso está diagnosticado e documentado em
[DIAGNOSTICO_LOGIN_CSB.md](DIAGNOSTICO_LOGIN_CSB.md). Resumo: o acervo salva os
widgets com o sufixo de tag do Cocos Studio (`Label_server_name*11`) e o código
procura sem o sufixo; parte disso já foi corrigida, e o erro que resta é a
janela usar `self.roots[1]` quando existem duas `LoginClass` vivas.

O que **funciona** hoje: a tela de conta abre sozinha, criar conta, entrar,
a lista de servidores é buscada, e o servidor responde `vali_register` /
`login_init` com o `user_id` real.

## O que está provado por teste (não por inspeção visual)
- Os parsers REAIS do jogo consomem as respostas do servidor com
  alinhamento exato (`NR_PROBE_PARSE_CHAIN`).
- Cadastro/login/sessão/perfil isolado por conta, sobre o mesmo codec de
  rede do jogo (zlib + swap modo 0): `tools\test_contas_e2e.py`.
- `vali_register` e `login_init` **exigem sessão da própria conta**; o token
  da conta A pedindo a conta B é recusado; sessão expirada, revogada e
  inexistente são recusadas; `user_id` entregue ao parser é o perfil real;
  alternar duas contas 8 vezes não mistura perfis
  (`tools\test_sessao_perfil.py`).
- Recusas: nome vazio/ inválido/ duplicado, senhas diferentes, senha errada,
  usuário inexistente, servidor desligado, token revogado, envio duplicado.
- Comando desconhecido **não** vira sucesso: resposta `-3 nao_implementado`.

## O que NÃO está provado (pendente, depende de clique humano)
- Que a tela de conta, a lista de servidores e o **menu** aparecem e são
  clicáveis na sua máquina.
- Iniciar e terminar uma batalha a partir do menu e voltar.
- Progresso por conta salvo/reaberto.
