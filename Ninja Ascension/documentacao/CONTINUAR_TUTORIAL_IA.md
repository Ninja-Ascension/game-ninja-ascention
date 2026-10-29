# Comando para continuar em outro ambiente

ATUALIZAÇÃO 25/10/2026: leia primeiro CORRECAO_CAMPANHA_E_EFEITOS.md.
O ciclo de vitória tinha `battle_result_verify` ausente. O handler agora
persiste nível/mapa/NPCs e foi validado nos parsers originais até a fala do
Iruka que encaminha para Sakura. Efeitos aditivos e duração das animações
também foram corrigidos e os testes nativos passaram. O próximo trabalho é
recrutamento/inventário/formação, não voltar a consertar a introdução do Pain.
O texto abaixo é histórico e contém diagnósticos anteriores já superados.

Continue a implementação do tutorial completo do Ninja Revolution no projeto
E:\[code]\nk. Examine o estado atual antes de modificar qualquer coisa.
Use Axmol 2.11.5, LuaJIT e a ponte nativa Spine 2.1.25 já existentes.
Preserve o APK, os diretórios de originais, contas, sessões e layouts salvos.
Há alterações locais ainda não commitadas: não faça reset, checkout nem clean.

1. Leia LEIA-ME.md, port/CORRECAO_INSTANCIA_LOADING.md, port/lua/boot_map.lua,
   port/lua/native_spine.lua, port/lua/battle_lifecycle.lua e
   port/lua/tutorial_contract.lua. Execute git status e leia os diffs.
2. Leia os logs mais recentes em port/server/server.log e
   build/probe-writable/battle-lifecycle.log. Confira os horários; logs antigos
   não descrevem necessariamente o processo atual. Não exponha credenciais.
3. Estado confirmado: login, diálogos, cenário e personagens carregam;
   a primeira onda progride e a formação da segunda onda é criada.
   O último bloqueio identificado foi FightRound.lua:93: Panel_2 inexistente;
   battle_ready.csb contém Panel_2_pr2. O alias já foi acrescentado.
4. Execute tools/test_battle_lifecycle.py e tools/test_layout_editor.py com
   o Python disponível. O teste nativo render-contract inclui a janela
   original FightRound, a animação Spine animation2 e a liberação da onda 2
   por callback real. Não confunda esse teste com o tutorial inteiro validado.
   ATENÇÃO: esse teste novo ainda FALHA. A animação é criada, mas o teste
   registra closed=0 e started=0 depois de avançar o tempo. Investigue a
   diferença entre o teste e a execução real e o despacho de callbacks;
   não retire a asserção para declarar sucesso. Evidência mais recente em
   build/tutorial-contract-run.log. O último conjunto completo está em
   build/layout-tests-7e5f065a36e9412fb8297a08ee48f606/results.json.
5. Abra port/server/jogar_local.bat e percorra o tutorial: diálogo inicial,
   primeira onda, troca de cenário, segunda onda, chefe, conclusão, resultado,
   continuação das missões e chegada à interface principal. Use perfis de teste
   isolados para automação. Preserve a conta do usuário. Se usar computer use,
   leia a skill e respeite as restrições de autenticação do ambiente.
6. Investigue os efeitos repetidos da captura enviada pelo usuário. A causa
   específica deles ainda NÃO está comprovada. Compare sp.spine,
   sp.initArmature, _LastsCountTurns, _invoke, callbacks e limpeza dos efeitos
   em FightRole.lua com port/native/LegacyCharacter.cpp. Diferencie efeitos
   persistentes intencionais de efeitos temporários que não são removidos.
   Não apague todos os efeitos, não use timeout arbitrário para fingir término,
   não desative callbacks e não transforme falhas em no-op.
7. Corrija sempre a primeira exceção. Exemplos já resolvidos: ListView perdeu
   refreshView/requestRefreshView na engine; alguns painéis têm sufixos _pr1
   ou _pr2; uma falha na construção do contador deixava self.actions vazia.
   Prefira aliases explícitos com busca exata prioritária; valide no layout real.
8. Rastreie os comandos originais de encerramento e continuação em Mission.lua,
   Fight.lua e FightRoleController.lua. Implemente no servidor local apenas os
   contratos realmente necessários. education_change recebe atualmente ACK
   neutro: audite se o progresso necessário para retomar o tutorial é persistido
   por outra via; não presuma que o ACK sozinho salva progresso.
9. Verifique regressões independentes ainda vistas no log: pré-carregamento
   de ActivityWindow/Formation durante a batalha e openLevel nil em
   add_and_lock_cell.lua:79. Não invente níveis, participantes ou vitórias.
10. Teste efeitos finitos, loops intencionais, callbacks, duas ondas, resultado,
    continuação e reabertura do perfil. Execute apenas os testes pertinentes
    após cada correção. Registre evidências e limitações, sem afirmar que o
    tutorial inteiro funciona apenas porque testes parciais passaram.

Faça as alterações necessárias e explique o progresso em português. Ao final,
entregue arquivos alterados, comandos executados, resultados e pendências.

## Comandos iniciais em PowerShell

```powershell
Set-Location -LiteralPath 'E:\[code]\nk'
git status --short
git diff --stat
Get-Content -LiteralPath 'port\CORRECAO_INSTANCIA_LOADING.md'
Get-Content -LiteralPath 'build\probe-writable\battle-lifecycle.log' -Tail 80
Get-Content -LiteralPath 'port\server\server.log' -Tail 80
$nrPython = 'C:\Users\! I T A C H I\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe'
& $nrPython tools/test_battle_lifecycle.py
& $nrPython tools/test_layout_editor.py
```

Se o projeto for copiado para outro computador, ajuste os caminhos e localize
os pré-requisitos de build; os binários atuais não substituem esses requisitos.
As alterações recentes são Lua lido do workspace: reinicie o jogo para aplicá-las.
O tutorial completo e a eliminação dos efeitos repetidos ainda não foram
concluídos. O alias da transição foi aplicado, mas não comprova sua conclusão.
