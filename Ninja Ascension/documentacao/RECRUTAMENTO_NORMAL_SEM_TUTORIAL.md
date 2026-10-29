# Recrutamento normal e tutorial desligado — 26/10/2026

## Causa anterior

`new_recruitment_system` executava a lição inicial da Sakura, com molde
obtido de mission3. Qualquer x1 restaurava o mesmo personagem; x10 era
recusado. Esse caminho agora fica restrito a fixtures privadas de testes.

## Fluxo normal

- x1 e x10 independentes de missões educativas.
- Custos de play_config 257/258: 240/2.280 Gold ou 1/10 cupons.
- Uma convocação individual gratuita por dia (dia muda às 05:00 UTC).
- Resultados e pesos das bibliotecas recuperadas 3/4/5; chances de entrada
  especial do parâmetro 243. Contadores persistentes para garantia SR em
  dez resultados sem SR e SSR em cem sem SSR.
- Personagens novos entram na coleção sem mudar a formação.
- Política local para repetidos: fragmentos do personagem na quantidade
  original necessária para sintetizá-lo. Não cria instâncias duplicadas.
- Moedas de recrutamento conforme play_config 256/259.
- Custos, inventário, coleção, contadores e recibo são transacionais.
- Identificador por solicitação permite repetir a resposta sem cobrar ou
  sortear novamente. O cliente envia o identificador também no x10.
- Parser 15005 carrega resultados locais ordenados após os parsers de
  personagens/inventário. Isso alimenta as telas originais x1/x10.

Esta é implementação local: o algoritmo global de correção, desejos e
críticos duplos do servidor antigo não foi recuperado integralmente. Não
afirmar equivalência completa com a economia do jogo original.

## Tutorial

Desligado na execução normal mesmo com override antigo de ambiente. Guias
tuition não são acionados, education_change não grava avanços e não há
concessão automática do kit de melhoria. Tabelas antigas são preservadas
para compatibilidade e histórico; conta e formação não são apagadas.
Somente testes explícitos com banco privado podem ligar fixtures antigas.

## Verificação

- `tools/test_normal_recruit.py`: novo personagem, repetido, x10, cobrança,
  falta de saldo, reenvio, banco reaberto e ausência de avanços educativos.
- `build/normal-recruit-native.log`: parsers reais, resultados, Gold e
  contadores. `build/normal-recruit-ui.log`: abertura da interface x10.
- Login nativo (três cenários), menu direto e campanha normal aprovados.

O teste de abertura da tela não comprova toda a sequência animada de
revelação e aceitação dos dez itens. Confirmar isso no uso normal.

Também corrigida notificação de constelação sem dados inicializados.
O lock do banco é reentrante para operações atômicas que chamam leitores
de perfil e inventário na mesma thread.
