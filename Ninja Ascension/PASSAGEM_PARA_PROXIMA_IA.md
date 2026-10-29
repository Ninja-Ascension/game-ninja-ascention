# Passagem de trabalho - NinjaAscension (28/10/2026)

Leia também `AGENTS.md`, que tem as regras fixas: preservar contas, fazer backup pela API SQLite, publicar com `python jogo/tools/publicar_atualizacao.py --automatico` e reiniciar o servidor.

## Ordem combinada com o usuário
Fazer as correções primeiro no **PC**. Depois passar para o **APK**, que recebe as mudanças pelo atualizador em `port/lua/mobile_boot.lua`.

## Feito nesta sessão (falta o usuário confirmar no jogo)
- **Animação do poder** (`01_conteudo_apk/assets/src/client/red_alert_time/utils/combatEffectivenessUp.lua`, bloco de reserva usado porque `fight_up.csb` não carrega):
  - o número sobe do poder antigo até o novo em 0,7 s;
  - o `+valor` fica ao lado do total;
  - depois a caixa pisca 2 vezes e some subindo, em cerca de 3 s no total.
  - Se o usuário aprovar, tirar a pendência do `AGENTS.md`.
- **Atualizador do celular** (`port/lua/mobile_boot.lua`):
  - baixa scripts e imagens (`assets/res`) durante a tela "verificando atualização", com a barra `update_loading.csb`;
  - espera no máximo 25 s;
  - recarrega na hora as telas `client.*` que mudaram.
  - Imagens só entram no manifesto se forem publicadas explicitamente, por exemplo: `python jogo/tools/publicar_atualizacao.py 01_conteudo_apk/assets/res/images/ui/bg/home_bg_1.png`.
- **Celular**: `desktop_layout.aspectCorrection()` devolve 1 no celular (os quadros dos ninjas estavam achatados) e não aplica o deslocamento de +18.
- **Loja de recrutamento**: `newRecruitmentShop` agora é uma string `"2,2,..."` (de `new_draw_card_shop.txt`) em `normal_recruit.py` e `recruitment_local.py`. Antes era `[]`, e o jogo travava no `zstring.split`. A proteção também está em `push_notification_shop.lua`.
- **Banner "Main Instance Challenge"** na tela inicial: `Home:showFinder()` foi desativado em `client/home/Home.lua`.
- **VIP**:
  - nova tabela `local_vip` com o módulo `port/server/vip_local.py`;
  - o campo 62 do `login_init` virou `vip_grade`;
  - RenegadoBR (conta 62) está com VIP 20.
  - Outros lugares que leem VIP (recarga, telas de VIP) não foram revisados.
- **Bag do RenegadoBR esvaziada** (todos os 357 tipos em `local_inventory`), para testar eventos. Backup em `jogo/port/dados/contas-backup-antes-limpar-bag-20261028-002755.sqlite3`.
- **Painel GM**:
  - arquivo `jogo/port/server/painel_gm.py`, aberto em `http://127.0.0.1:18090`, só dentro da VPS;
  - senha em `jogo/port/dados/painel_gm_senha.txt`;
  - atalho `ABRIR_PAINEL_GM.cmd`;
  - dá item, moedas e VIP e limpa a bag, com backup antes de cada alteração.
  - Pendente: entrega pelo e-mail do jogo (o e-mail não funciona no servidor) e outras melhorias.

## Pendências que restam
1. O usuário vai conferir no PC e depois no celular: Recruit, quadros da tela Ninja, banner removido, VIP 20, bag vazia e animação do poder.
2. Comprar na loja de recrutamento ainda não está implementado no servidor.
3. Sistema de reinício do servidor com aviso ou tempo, pedido para depois.
4. Painel GM: entrega por e-mail do jogo.
5. Não implementados (responder com sinceridade, nunca com sucesso falso):
   - destino das Bestas com Cauda;
   - batalhas, cópias, doações e ciência de clã;
   - stamina dos amigos;
   - ranking King of War;
   - recompensas 3/18/34/75 da missão principal.

## Adicionado depois
- **Conta/Sair nas Configurações** (`client/l_digital/player/SmPlayerSystemSetPage.lua`):
  - função global `nrSwitchAccount()`;
  - "Conta" (Button_tuisong_11) e "Sair" (Button_tuisong_7) voltam para a janela de conta;
  - a bolinha flutuante de conta (`AccountSysFloatingWindow:onUpdate`) fica sempre escondida.
  - Publicado, mas ainda não testado.
- **PENDENTE, tela de resultado do Recruit no PC** (print do usuário "You Got" com 10 ninjas):
  - não tem o fundo escuro;
  - os ícones estão espalhados pela tela inteira (esticamento do EXACT_FIT no PC);
  - "You Got" fica por cima do título "Ninja Courier";
  - botões "Draw ten times" / "Aceitar" ficam por cima dos botões Draw da tela de trás.
  - Achar a janela de resultado do NewRecruitMain e ajustar o layout no PC.

## Adicionado em 28/10 (segunda parte)
- **Login**: o botão Entrar exige nome e senha (`AccountSysManager.lua`). O token salvo só serve para o login automático. "Sair" e "Conta" apagam o token.
- **Painel GM** (`port/server/painel_gm.py`), já descrito acima.
- **VIP**: tabela `local_vip` e `vip_local.py`.
- **Nível**:
  - conta 62 (RenegadoBR) no nível 200;
  - `hero_level_local.HERO_MAX_LEVEL = 200` (antes 100). O usuário quer testar até onde o jogo deixa, ele acha que é 110. Se der problema acima de 100, voltar o limite.
- **Itens dados ao RenegadoBR (conta 62)**, com backups `dados/contas-backup-antes-*.sqlite3`:
  - pergaminhos de arma 117-140 x500;
  - Tomoes 72-113;
  - 8 armas 412 do Rinne;
  - 160 Pedras do Despertar (223);
  - 1000 fragmentos do Rinne (1055);
  - 20000 Onigiri XXG (234).
- **Mudras do Rinne Sharingan** (navio 1006200382, mould 382):
  - 18 peças vermelhas no nível 120, rank 11;
  - combinações 13, 35 e 44 ativas.
- **Conquistas**:
  - tipo 30 (presentes do Espírito de Equipe; contador `spiritGifts` no estado da ninja school, conta a partir de agora);
  - tipo 13 (poder da equipe).
- **Sculpture Mountain** (`constellation_local.bonus`):
  - Regra da tela de regras: a escultura dá bônus a **todos os ninjas do tipo da montanha**. Tipo do ninja = `ship_mould[4]` (hero_gender, ver FormationTigerGate.lua:4820); tipo da montanha = `constellation_mould[3]`.
  - Multiplicador do cliente (`attributeNumClt`): 1 + (estrela% play_config 81 + qualidade% 82 + compradas na posição% 83)/100.
  - **Dúvida em aberto**: os ninjas do usuário são todos dos tipos 4, 5 e 6, então as montanhas 1, 2 e 3 não dão bônus a ninguém. Confirmar com o original.
  - RenegadoBR com todas as esculturas compradas, usando as melhores.
- **Portões (`hero_gates_local.py`)**:
  - condições 5 (estrelas de equipamento), 6 (soma dos níveis dos mudras) e 9 (18 mudras com qualidade mínima) implementadas;
  - custos 4, 5 e 7 (equipamento do despertar dos slots 6, 5 e 1) e 6 (fragmento) implementados.
  - Portões 4, 5 e 8 do Rinne exigem os ninjas 351, 376 e 369, que a conta não tem.

## IMPORTANTE: o APK original tem dados MAIS NOVOS que o nosso cliente
- Os APKs originais (32 e 64 bits, iguais entre si) têm **229 tabelas de `assets/res/data/mould/` diferentes** das nossas (`01_conteudo_apk/assets/res/data/mould` e `jogo/res/data/mould`). Exemplos:
  - `ship_mould` 2154 x 2052 linhas (cerca de 100 ninjas novos, ids 2053-2153);
  - `equipment_mould` 625 x 422;
  - `skill_mould`, `talent_mould`, `word_mould`, `card_mould`, `mega_ship`, `ship_spirit_group`, etc.
- O `constellation_mould` do APK tem 45 montanhas. Copiei só as 29 cujos ninjas já existem no nosso `ship_mould`. As montanhas 30-45 usam os ninjas novos.
  - Cópia anterior em `constellation_mould.txt.antes46`.
  - Publicado com `publicar_atualizacao.py 01_conteudo_apk/assets/res/data/mould/constellation_mould.txt`.
- Próximo passo grande, a combinar com o usuário: importar os ninjas e tabelas novas do APK. Antes, conferir se as imagens e spines desses ninjas existem no nosso `res`, e testar o login, porque o servidor lê `jogo/res/data/mould`.

## TAREFA INICIAL DA PRÓXIMA IA: trazer o conteúdo novo do APK original
APK de referência: `origem_apk/NinjaRevolution64-1.1.1-64bits.apk` (os `assets/` são idênticos aos do APK de 32 bits na raiz). Comparação completa com `jogo/01_conteudo_apk/assets` em `DIFERENCAS_APK_ORIGINAL.txt`, na raiz.

Resumo da comparação:
- **496 arquivos novos** no APK:
  - 134 imagens de interface (`res/images/ui`);
  - 14 rostos (`res/images/face`);
  - efeitos `res/effect/effice_15xxxx*` e `effice_512xxx*` (spine);
  - textos por idioma (9 por idioma);
  - `res/data/EggPromRecharge.lua`;
  - 5 scripts novos: `l_digital/activity/event_banner/FuryEventBanner.lua`, `l_digital/activity/server_recharge_rank/FuryServerRechargeRank.lua`, `l_digital/campaign/furytower/FuryModePass.lua`, `l_digital/system/FuryProgressRank.lua` e `utils/FuryHelpPopup.lua`.
- **1595 arquivos diferentes**:
  - 230 tabelas em `res/data/mould`: cerca de 101 ninjas novos (ids 2053-2153), equipamentos, habilidades, talentos, cartas, mega_ship, ship_spirit_group, constellation (45 montanhas) e word_mould;
  - 25 em `res/data/configs`;
  - cerca de 76 por idioma;
  - csb de activity/campaign/cultivate;
  - 112 scripts em `src/client/l_digital` e outros em activity, packs, cells, battle, protocol, login, frameworks/network...
  - **ATENÇÃO**: muitos scripts "diferentes" são correções NOSSAS (port). Não sobrescrever às cegas. Para cada `.lua`, comparar com o APK de 32 bits na raiz (a base que usamos) e fazer merge só do que o APK mudou.
- Só nosso: `res/data/mould/constellation_mould.txt.antes46` (backup meu, pode ignorar).

Plano sugerido:
1. Copiar os **arquivos novos** (imagens, efeitos, rostos, textos) para `01_conteudo_apk/assets`.
2. Copiar as **tabelas `res/data/mould` e `res/data/configs`** do APK para o cliente (`01_conteudo_apk/assets/res/data`) e para o servidor (`jogo/res/data`). Fazer backup antes e rodar os testes do servidor (`jogo/tools/test_*.py`) para ver o que quebra (colunas novas).
3. Fazer merge dos scripts alterados, com cuidado com as nossas correções. Depois os 5 scripts Fury novos (precisam de comandos novos no servidor? conferir o protocolo).
4. Depois disso, adicionar as montanhas 30-45 na Sculpture Mountain e liberar os ninjas novos.
5. Publicar: imagens e tabelas precisam ser publicadas explicitamente (`publicar_atualizacao.py <caminho>`), porque o modo `--automatico` só pega `src`, `port/lua` e `port/gameplay.json`. Arquivos grandes podem exigir um APK novo (`tools/montar_apk.py`).


## Importacao publicada em 28/10/2026 — etapa encerrada a pedido do usuario
- 491 recursos novos importados sem sobrescrever arquivos existentes e publicados explicitamente.
- 28 tabelas com diferencas de conteudo atualizadas (mould/configs), incluindo face_mould; duplicatas de ID dessa tabela foram conferidas e ja eram identicas no acervo anterior. Diferencas apenas de CRLF/NUL foram ignoradas.
- jogo/res e junction para 01_conteudo_apk/assets/res; cliente e servidor usam as mesmas tabelas.
- 245 personagens jogaveis nas tabelas, incluindo 101 novos; referencias de evolucao/equipamento e calculo de atributos validados em copia do banco para todos.
- 45 montanhas do Sculpture disponiveis nas tabelas.
- Cinco scripts Fury novos adicionados e sintaxe Lua validada. Funcionalidade completa dos eventos Fury continua pendente (comandos do servidor e integracao).
- 12 testes de regressao passaram. test_constellation_local foi corrigido para escolher uma montanha do mesmo tipo do ninja ao verificar bonus (antes escolhia tipo incompativel). Resultados/logs em jogo/build/apk-import-tests; novo teste de Sculpture passou separadamente.
- 524 arquivos publicados e SHA-256 conferido contra fonte, atualizador e distribuicao. Servidor recarregado via controle local sem encerrar sessoes.
- Backup das tabelas: jogo/build/apk-tables-before-20261028-020211.zip. Backup SQLite feito antes da recarga; caminho em jogo/build/apk-import-published.json.
- Pendentes: comparacao/merge dos scripts existentes alterados (preservar ajustes do port), arquivos de idiomas e interfaces existentes diferentes. Nenhum desses arquivos existentes foi substituido cegamente.
- Usuario pediu encerrar nesta etapa e apenas publicar. Nao continuar importacoes automaticamente.
