# Roteiro para concluir o tutorial inicial e liberar as missões

Atualização: a máscara transparente, a primeira convocação de Sakura e sua
formação inicial foram implementadas após a elaboração deste roteiro.
Consulte CORRECAO_CAMPANHA_E_EFEITOS.md e os testes de recrutamento para o
estado atual. A lista de bloqueios abaixo descreve o diagnóstico original.

## Escopo e estado verificado

Projeto: `E:\[code]\nk`. Axmol 2.11.5, LuaJIT e Spine 2.1.25.
Escopo confirmado pelo jogador: tutorial inicial e liberação do menu e das
missões normais. Os tutoriais de funcionalidades desbloqueadas depois não
devem ser forçados na criação da conta.

Este é um roteiro de implementação e validação. As etapas abaixo ainda não
estão todas implementadas. O usuário não consegue resolver a falta de dados
do recrutamento apenas clicando nos botões.

Fontes principais:

- `01_conteudo_apk/assets/src/client/mission/Mission.lua`.
- `res/data/mould/mission1.txt`, `mission2.txt`, `mission3.txt` e suas versões
  em `res/language/pt_BR/data/mould`, quando disponíveis nos caminhos ativos.
- `01_conteudo_apk/assets/src/client/mission/tuition/TuitionController.lua`.
- `01_conteudo_apk/assets/src/client/shop/newrecruit/NewRecruitMain.lua`.
- `01_conteudo_apk/assets/src/client/protocol/ProtocolParserCopyExx.lua`.
- `port/server/tutorial_campaign.py`, `local_server.py` e `contas.py`.

Bloqueios atuais comprovados nos logs:

1. `NewRecruitMain.lua:673`: cálculo de progresso com `cur_draw_times=nil`.
2. `NewRecruitMain.lua:574`: comparação com `free_times=nil`.
3. A máscara do guia cobre a tela fora do alvo; o jogador quer somente o
   efeito de indicação, mantendo a interface visível.

## Sequência de implementação

### 1. Preparar um teste completo e preservar a conta

- Fazer backup consistente do SQLite; preservar contas, sessões, assets,
  layouts e alterações locais. Não executar reset/clean.
- Usar conta e banco temporários na automação. Não testar concessões de
  recursos na conta do jogador.
- Registrar etapa, janela, alvo de clique, comando enviado, resultado e próximo
  evento, sem senha ou token completo.
- Manter um checklist único para todo o percurso até o controle livre.

### 2. Corrigir a apresentação do guia

- Investigar `Panel_4`, `Panel_5`, `Panel_6`, `Panel_7` e `Panel_black` no layout
  `utils/teaching` e no `TuitionController`.
- Aplicar no adaptador do port o estilo pedido: fundo sem preenchimento preto
  durante a indicação de escolha; manter mão, círculo, seta e textos visíveis.
- Alterar somente os fundos da máscara. Não zerar a opacidade da janela pai,
  pois isso pode apagar também os efeitos e textos.
- Preservar o encaminhamento do clique e o bloqueio dos alvos errados quando
  exigido pela etapa. Transparência visual e captura de input são independentes.
- Reaplicar a aparência quando o guia reaproveitar a janela ou o timeline
  restaurar propriedades do layout.
- Validar no botão Recruit, Draw x1, retrato do ninja e botão da missão, em
  mais de um tamanho de janela. Nenhum deles pode deixar o restante preto.

### 3. Inicializar o recrutamento pelo protocolo real

- Rastrear o comando que deve entregar o parser 15005 antes de abrir a janela.
  `parse_new_recruitment_system_enter` lê um JSON com `totalDraw`,
  `totalFreeDraw` e `newRecruitmentShop`; ele preenche `cur_draw_times`,
  `free_times` e `shopRemainInfo`.
- Implementar esse contrato no servidor local com estado persistente por conta.
- Derivar custos, limites e configuração das tabelas originais; documentar
  separadamente regras locais quando o comportamento oficial não foi recuperado.
- Abrir a tela somente depois de receber e validar os dados. Mostrar falha
  recuperável se a inicialização não chegar.
- Não inserir apenas `or 0` no cálculo para mascarar a ausência da resposta;
  isso ainda deixaria o recrutamento sem concessão real do ninja.

### 4. Implementar a primeira convocação e o inventário

- Implementar `new_recruitment_system` (C2S 9328), chamado por Draw x1.
- Conferir a garantia do tutorial nos dados: o grupo 3 da mission3 encaminha
  para Sakura, mas a variante e os atributos devem vir das tabelas, não de
  uma escolha aleatória ou de um ID presumido.
- Salvar o ninja com ID de instância, molde, nível, qualidade, estrelas e
  atributos necessários aos parsers originais.
- Entregar os parsers de aquisição/recompensa exigidos pelo cliente, além do
  15006 quando aplicável. O 15006 sozinho informa crítico e não cria um ninja.
- Atualizar contador, uso da convocação gratuita e inventário na mesma operação.
- Garantir que reenviar uma resposta ou reconectar não conceda Sakura duas vezes.
- Abrir `HeroRecruitSuccessClass` com os dados reais da aquisição e permitir
  confirmar os botões previstos pelo roteiro original.

### 5. Colocar Sakura na formação e recuperar a formação no login

- Implementar `formation_change` e os parsers correspondentes.
- Seguir os slots e condições do grupo 3; não preencher todos os espaços
  automaticamente para pular a orientação.
- Salvar composição e posições no SQLite; reconstruir no login e nas batalhas.
- Remover dependência da equipe provisória do servidor onde ela substitui
  indevidamente a formação do jogador.
- Conferir que a Sakura da batalha é a mesma instância obtida no recrutamento.

### 6. Completar a volta ao mapa e a segunda missão

- Concluir as falas do Iruka, Sakura e Naruto do grupo 3.
- Fechar resultado/recrutamento, retornar ao mapa, selecionar o segundo NPC
  e iniciar a missão original.
- Confirmar vitória, estrelas e avanço uma única vez. Uma derrota não pode
  liberar a próxima etapa nem gerar prêmio de vitória.
- Validar que o NPC concluído não repete o tutorial de ataque na reentrada.

### 7. Implementar a evolução de qualidade — grupo 4, nível 3

- Seguir `HomeHeroClass -> FormationTigerGateClass ->`
  `SmRoleStrengthenTabUpProductClass -> GeneralsStarUpSuccessWindowClass`.
- Implementar a requisição, consumo de materiais/moedas e atualização real do
  ninja. Derivar requisitos das tabelas originais.
- Refletir a evolução no inventário, na formação e na batalha após relogin.
- Retornar ao mapa e concluir a próxima missão indicada pelo grupo 4.

### 8. Implementar o baú de estrelas — grupo 5, nível 4

- Abrir `PVEStarCheatPanelClass`, selecionar o baú e receber por
  `PVESceneStarRewardClass`.
- Calcular elegibilidade com estrelas efetivamente obtidas.
- Salvar a retirada e conceder a recompensa em transação única; o estado do baú
  deve sobreviver ao fechamento e à reconexão.
- Exibir e confirmar a recompensa real em `DrawRareRewardClass`.

### 9. Completar coleção, obtenção e troca de formação — restante do grupo 5

- Seguir a entrada em `HeroListViewClass`, a seleção indicada na lista e a
  aquisição/recompensa prevista pelo evento original.
- Voltar de `HeroStorageClass` e abrir a escolha da formação pelo retrato.
- Permitir selecionar o ninja correto em `HeroFormationChoiceWearClass`.
- Preservar os diálogos e a passagem para a missão apontada no cenário 2.
- Não dar o evento como concluído só porque o clique foi encaminhado: conferir
  aquisição, composição e resposta do servidor.

### 10. Concluir o combate guiado do nível 5 — grupo 6

- Abrir o cenário 2 e seguir a seleção de NPC do grupo 6.
- Carregar a formação persistente, as ondas, os especiais e as falas originais.
- Validar que efeitos/danos terminam, ataques não executam duas vezes e os
  momentos de TAP esperam o jogador quando exigido.
- Confirmar a vitória e encaminhar para o treinamento do nível 6.

### 11. Implementar a evolução de estrelas — grupo 7, nível 6

- Seguir `HeroDevelopClass -> SmRoleStrengthenTabRisingStarClass ->`
  `GeneralsStarUpSuccessWindowClass`.
- Validar requisitos e consumir somente os recursos previstos nas tabelas.
- Salvar a alteração, atualizar o retrato/atributos e retornar ao fluxo original.
- Conferir o encerramento das falas e as chamadas finais do grupo 7.

### 12. Encerrar o guia e liberar o controle normal

- Remover mão, círculo, painéis do guia, locks, callbacks e serviços exclusivos
  da etapa concluída. Não fechar janelas necessárias à interface principal.
- Tratar os avisos opcionais finais (sete dias, banners e primeira recarga)
  conforme os serviços locais disponíveis; eles não podem bloquear o acesso
  ao menu por ausência de dados ou exigir uma compra para concluir o tutorial.
- Confirmar menu, personagens, inventário, formação e mapa funcionando com
  interação livre; o usuário deve conseguir iniciar uma missão normalmente.
- Persistir a conclusão real. Reabrir o jogo não deve reiniciar a introdução,
  convocar outro ninja nem reabrir uma máscara sem alvo.

### 13. Validar o percurso inteiro em uma única rodada

- Conta nova: introdução -> Iruka -> primeiro combate -> recrutamento ->
  Sakura na formação -> missões -> qualidade -> baú -> coleção/formação ->
  combate seguinte -> estrelas -> menu e missões livres.
- Fazer também testes de reconexão no recrutamento, após uma aquisição, após
  uma vitória e após a conclusão do guia.
- Validar com os parsers originais sem pré-preencher os dados que o servidor
  deveria enviar. Manter o teste do login frio: 6020 antes de 6022.
- Conferir ausência de exceções Lua, dados nil, progresso regressivo, efeitos
  pretos indevidos, recompensas duplicadas e locks órfãos.
- Só marcar “tutorial inicial completo” depois de percorrer todas essas etapas.

## Orientações que ficam para desbloqueios posteriores

Os grupos 8 a 13 incluem habilidades, ruptura, equipamento, elite e tarefas
diárias por condições de progresso. Os grupos 14 a 19 introduzem recursos
em níveis posteriores (15, 18, 20, 24, 26 e 30). O grupo 193 contém história
adicional. São parte do conteúdo recuperado, mas não devem ser disparados
todos de uma vez para liberar uma conta nova.

## Comando para a IA executar o trabalho

Continue a implementação em E:\[code]\nk seguindo este roteiro na ordem.
O objetivo é concluir o tutorial inicial e liberar menu e missões normais.
Primeiro corrija os fundos pretos do guia e implemente a inicialização real
do recrutamento, pois os logs mostram cur_draw_times e free_times nil.
Depois implemente convocação, inventário, formação, evolução, recompensas,
progressão e encerramento do guia conforme mission3 grupos 1 a 7, sem pular
as etapas nem substituir dados por ACKs vazios. Preserve os originais e as
contas; faça adaptações em port e testes isolados em tools/build. Use os
parsers originais e estado transacional persistente, distinguindo qualquer
regra local de um comportamento comprovado do jogo original. Execute o
percurso inteiro com uma conta de teste, além de reconexão e reenvio das
requisições. Corrija as falhas encontradas antes de declarar conclusão.
Atualização de estado: as 48 contas antigas foram apagadas por solicitação
do usuário. O banco ativo aceita somente a primeira nova conta criada pela
tela do jogo. Preserve essa conta e seu progresso; não execute novo reset.
A primeira melhoria de qualidade de Naruto e sua persistência foram testadas
no executável. A concessão única dos recursos dessa lição é uma regra local.
Baús, síntese e conclusão das etapas posteriores continuam pendentes.

Entregue os arquivos alterados, resultados dos testes, inicializador e uma
lista explícita das pendências que ainda impedirem o término. Não declare
o tutorial completo baseado apenas na abertura das telas.
