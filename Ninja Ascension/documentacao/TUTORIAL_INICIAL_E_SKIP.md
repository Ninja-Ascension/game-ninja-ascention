# Tutorial inicial e Skip

A escolha visual usa o NinjaKingReborn fornecido pelo usuario. O roteiro inicial foi conferido no NinjaRevolution64: grupos 1-7 da mission3, introducao, fases 1-1 ate 2-2, Sakura, qualidade de Naruto, primeiro bau, Konohamaru e Naruto com duas estrelas. Os outros sistemas do jogo foram mantidos.

## Resultado equivalente verificado

O teste percorre os comandos reais do tutorial em uma conta temporaria e compara com o Skip de outra conta. Resultado liquido igual:

- Nivel 6; fases ate 2-2 concluidas com 3 estrelas na execucao de referencia.
- Naruto (13), Sakura (50), Konohamaru (56), sem o Kakashi do pacote inicial antigo.
- Naruto qualidade 1 e duas estrelas.
- Formacao: Konohamaru na posicao 1, Naruto na 2, Sakura na 6.
- 6.495 Ryo, 50 gold, 60 stamina, 150 endurance.
- Inventario restante: 5 Pocoes de Aprimoramento (68), 1 livro de recrutamento (239).
- Os 10 fragmentos de Konohamaru do bau sao consumidos na sintese.

Este e o resultado comprovado do servidor local implementado. Nao e certificacao do saldo do servidor oficial, que nao foi fornecido. Nao somamos grupos de primeira vitoria cujas referencias nao puderam ser comprovadas.

## Custos e premios

initial_tutorial.chest_items fornece os mesmos itens ao bau jogado e ao Skip. O livro consta da biblioteca original scene_reward_drop, grupo 1, mas nao da previa antiga.

O custeio da primeira melhoria de qualidade ja era politica local do port. A licao obrigatoria de duas estrelas tambem recebe exatamente seus custos de tabela uma vez, consumidos pela melhoria. Esses kits nao sao anunciados como premios oficiais recuperados do APK e nao deixam saldo adicional. O Skip nao devolve materiais gastos nas licoes.

Os 495 Ryo das cinco fases seguem a liquidacao existente do port. Bibliotecas oficiais inconsistentes nao foram interpretadas por suposicao.

## Contas e seguranca

local_initial_tutorial registra choice, playing, completed ou skipped. Ausencia de linha significa perfil legado. Apenas perfis novos entram automaticamente; estar no nivel 1 nao basta. A escolha de fazer tambem e persistida e nao pode ser trocada por Skip no meio do percurso.

O reset autorizado das outras 12 contas mantem logins, senhas e nomes, apaga progresso e inscreve esses perfis na escolha. RenegadoBR e ItachiBR ficam fora do reset e do tutorial. A autorizacao atual inclui Aeglos. Relatorios de ensaio/aplicacao ficam em jogo/build/reset-12-*.json.

Skip aplica personagens, moedas, inventario, fases e conclusao na mesma transacao SQLite. Uma falha desfaz tudo. Repetir nao duplica premios. A retomada e a troca de conta obedecem ao estado entregue no login.

No tutorial escolhido, dialogos e mascara original ficam visiveis; o botao local de pular uma luta nao e oferecido. Correcoes de compatibilidade de memoria, animacao e parsers foram mantidas. Nao foram removidos Arena, lojas, Ninja School ou outros sistemas.

## Testes e limites

- test_initial_tutorial.py: percurso inteiro por protocolo versus Skip; repeticao, exclusividade, isolamento de perfil legado, persistencia e rollback forcado.
- test_initial_tutorial_client.py: Lua real para estados, troca de conta, confirmacao do servidor e repeticao apos falha; compilacao Lua 5.1.
- test_initial_tutorial_native.py: parsers reais Release para login inicial/final, tres personagens e construcao da janela de escolha, com captura PNG.
- Regressoes de melhorias, lojas, campanha, Recruit, Friends, Ninja School, data da Quest, Arena, restauracao de login, poder e recarga passaram. Logs em jogo/build/initial-tutorial-regression.
- Duas suites antigas de autenticacao falham em premissas anteriores a este trabalho: formato fixo antigo de login e fluxo legado de token/logout. Nao foram usadas para certificar o protocolo atual.

A captura nativa de diagnostico possui o inspetor sobre a janela. Ela nao certifica um percurso manual completo nem a apresentacao integral. Aceite visual PC/Android ainda necessario; APK nao reconstruido.

As pastas vazias jogo/01_conteudo_apk/assets/src e res foram vinculadas a jogo/src e jogo/res existentes, restaurando os caminhos usados pelo runtime, publicador e testes, sem sobrescrever o acervo.

Logs principais: jogo/build/initial-tutorial-test.log, initial-tutorial-outcome.json, initial-tutorial-native e initial-tutorial-regression.
