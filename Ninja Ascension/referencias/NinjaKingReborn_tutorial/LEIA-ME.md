# Tutorial inicial — extração do APK fornecido

Fonte: `C:/Users/Administrator/Desktop/Ninja Ascension/[APKS]/NinjaKingReborn (1).apk`.

Extraídos e comparados byte a byte com o ZIP do APK: **47 arquivos, 3.339.884 bytes**. Hashes por arquivo em `extracao_verificada.json`. Esta pasta é referência, não é carregada pelo cliente nem pelo publicador automático.

## Fluxo confirmado no APK

1. `client/mission/Mission.lua` carrega `TutorialSkip` e instala a interceptação de `executeMissionExt`.
2. A janela aparece para a missão tuition `l1e0` quando o jogador está em nível 1/EXP 0 e não há decisão em memória.
3. Fazer tutorial fecha a janela e executa a missão original pendente. A decisão desse caminho é apenas em memória no código do APK.
4. Pular pede confirmação e envia `tutorial_skip` (9993), com `user_id`, pelo `ProtocolCommanderCopyExxx.lua`.
5. Somente após sucesso do servidor o APK solicita novo `login_init`, limpa caches e reabre `LoginLoading`.
6. O texto promete os mesmos prêmios e início após 2-2. O APK não contém a implementação desse comando no servidor: a mensagem não comprova entrega de recursos nem especifica uma transação de concessão.
7. `SevenDaysManager.lua` chama `postersAfterTutorial`; é uma integração de banners posterior, não requisito para inventar recompensas.

## Comparação com o projeto

- `mission1.txt`, `mission2.txt` e `mission3.txt` são byte a byte iguais aos arquivos atuais em `jogo/res/data/mould`.
- `jogo/src/client/mission/TutorialSkip.lua` já é uma adaptação muito próxima deste APK, traduzida. Diferenças completas em `TutorialSkip.lua.diff`.
- As 11 imagens referenciadas pela janela já existem e são iguais. A fonte `ReggaeOne-Regular.ttf` não existe em `jogo/res/fonts` e foi extraída para esta referência.
- Não substituir `Mission.lua` inteiro: o atual contém adaptações existentes. Comparação em `Mission.lua.diff`.
- Servidor: `gameplay_mode.tutorial_enabled()` retorna falso fora de bancos de teste, independentemente da escolha do jogador.
- Cliente: `port/lua/tutorial_disabled.lua` bloqueia globalmente missões de educação/batalha fora do modo de probe. Copiar a janela não remove esse bloqueio.
- Servidor: `tutorial_skip.py` só grava `tutorial_skip_choice`; não concede os prêmios anunciados, não conclui a campanha até 2-2 e não restringe a primeira decisão a perfis novos.
- O login atual não consulta essa escolha para selecionar o fluxo individual. O comentário do handler que afirma essa integração não corresponde à implementação observada.
- Inventário inicial, formação, recrutamento e treinamento dependem do mesmo modo global. Habilitá-lo globalmente alteraria o que contas antigas recebem no login; isso não foi feito.

## Verificação inicial do servidor existente

`NR_ENABLE_TUTORIAL=1 python jogo/tools/test_tutorial_campaign.py`, com banco temporário: passos iniciais, checkpoint e recusa de resultado sem batalha executaram; o teste terminou com falha na assertion `login[4+18] == '3'`. É necessário revisar a posição do campo no teste antes de afirmar que existe reset de nível no jogo. Não foi usado banco real.

## Trabalho ainda necessário para aplicar

1. Estado autoritativo por perfil: elegível, fazendo, concluído ou pulado. Perfis anteriores à implantação devem permanecer fora do tutorial, inclusive se estiverem em nível 1.
2. Integrar login e todos os consumidores do modo tutorial à identidade autenticada; não usar um booleano global que mistura contas.
3. Persistir também a escolha de fazer tutorial e retomar checkpoints após reconectar.
4. Mapear as concessões efetivas do percurso até 2-2 pelas tabelas e handlers existentes; separar recursos originais de kits locais de teste. Só prometer equivalência depois de verificar o estado final dos dois caminhos.
5. Aplicar pulo e concessões em uma transação idempotente, com validação de perfil novo e proteção contra repetições e concorrência.
6. Integrar o sinal individual no cliente, incluindo troca de conta, e preservar as adaptações PC/Android. Importar a fonte e publicar explicitamente os recursos necessários.
7. Backup consistente SQLite, integridade, comparação das contas protegidas, testes temporários dos dois caminhos, compilação Lua, publicação e reinício somente ao terminar.

**Estado desta etapa:** extração e rastreamento inicial concluídos; tutorial ainda não aplicado nem publicado. Nenhum progresso real alterado.
