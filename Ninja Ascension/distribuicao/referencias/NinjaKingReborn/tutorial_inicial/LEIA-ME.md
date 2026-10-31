# Tutorial inicial — Ninja King: Reborn

Extração isolada para análise e futura adaptação ao NinjaAscension. Nenhum arquivo do jogo ativo, conta, banco ou configuração de tutorial foi alterado.

## Arquivo principal

`originais/assets/src/client/mission/TutorialSkip.lua` contém a interface inteira, criada em Lua: dois cartões (NEWBIE / VETERAN), botões Play Tutorial / Skip Tutorial e confirmação antes de pular. Não há um CSB próprio dessa tela.

## Fluxo identificado

1. `Mission.lua` carrega `TutorialSkip` e chama `install()`. O arquivo original contém duas chamadas de instalação; o módulo usa guardas para evitar envolver as funções novamente.
2. O módulo envolve `executeMissionExt` e `missionIsOver`. A escolha aparece para a missão inicial `mission_mould_tuition`, com conta nível 1 e experiência 0 (`l1e0`), sem outra missão em andamento.
3. **Fazer tutorial:** guarda em memória o user_id que já escolheu, fecha a tela e retoma os sete argumentos originais da missão pendente.
4. **Pular:** abre confirmação e envia `tutorial_skip` (código 9993), com o user_id. Enquanto espera, `busy` impede novo clique.
5. Só após resposta de sucesso, fecha a escolha, solicita `login_init`, limpa as janelas e reabre o carregamento normal. Erro libera uma nova tentativa.
6. `SevenDaysManager.lua` chama `postersAfterTutorial()` para reapresentar os anúncios quando a Home estiver pronta.

Pedido identificado, antes da compressão/transporte:

```text
<sequência>\r\ntutorial_skip\r\n<user_id>
```

## Recompensas e ponto final

A interface promete as mesmas recompensas do tutorial e início após a fase 2-2. Isso é texto do cliente: a implementação que concede os itens, avança as etapas e evita recompensas duplicadas pertence ao servidor externo e não vem neste APK. Não foi inventada uma resposta de sucesso nem um pacote de recompensas.

Para integrar depois, será preciso implementar essa operação no servidor do NinjaAscension com transação, proteção contra repetição e preservação de contas existentes, além de conferir as recompensas nas etapas de `mission3.txt`.

## Conteúdo separado

- Tela de escolha e scripts de missões/tutorial em `originais/assets/src/client/mission/`.
- Pontos de entrada, ligação do protocolo e ciclo de carregamento em `client/login`, `client/battle`, `client/protocol` e `client/activity/sevendaysnew`.
- Bases de Window, fwin e máquina de estados para consulta de dependências.
- Fonte, cartões, retratos, botões e fundo usados pela tela.
- `mission3.txt` base e versões de idioma, inclusive português.
- `inventario.json` com hash do APK e hash de cada arquivo extraído, para conferência de integridade.

Os arquivos são cópias originais, sem renomear marca, traduzir textos ou habilitar o tutorial no NinjaAscension. Não é um plugin pronto para instalar: usa as APIs e demais recursos do próprio jogo.
