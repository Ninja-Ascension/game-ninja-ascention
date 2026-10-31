# Tutorial inicial do NinjaRevolution64-1.1.1-64bits.apk

Fonte inspecionada diretamente: APK em `C:/Users/Administrator/Desktop/Ninja Ascension/[APKS]/`. Arquivos de evidência extraídos nesta pasta; hashes em manifesto.json. Nenhum banco ou arquivo do jogo ativo foi alterado.

## Até onde vai

O bloco inicial é mission3, grupos 1 a 7: introdução especial NPC1196; fase 1-1 (NPC1); recrutamento e formação da Sakura (molde50); fase 1-2 (NPC2); qualidade do Naruto (molde13); fase 1-3 (NPC3); baú do capítulo1 e síntese do Konohamaru; fase 2-1 (NPC4); fase 2-2 (NPC5); aumento do Naruto para 2 estrelas na condição l6e0. As últimas ações do grupo7 abrem banners, sete dias e primeira recarga. Abrir a oferta não concede prêmio de compra.

O bloco termina depois de 2-2, após a lição das estrelas, com gatilho no nível6. Isto não significa que todas as orientações do jogo terminem: os grupos8–13 continuam por batalhas/progresso e 14–19 por níveis15,18,20,24,26,30. Este APK não contém TutorialSkip.lua nem a escolha recuperada do NinjaKingReborn.

## Aquisições e evolução previstas pelo roteiro

- Introdução: mission2 evento2010133, tipo18, solicita recurso `8-0,1` (1 EXP).
- Grupo3: recrutamento seguido de equipar Sakura molde50 na posição6. O roteiro exige a personagem; a lógica oficial de concessão do recrutamento reside no servidor.
- Grupo4: melhoria de qualidade do Naruto, pelo comando ship_grow_up. É uma operação com custo, não uma recompensa extra demonstrada por esse evento.
- Grupo5: resgate do primeiro baú; diálogo e síntese de Konohamaru. Item57 é Fragmento de Konohamaru e sua receita exige10 fragmentos, levando ao molde56.
- Grupo7: Naruto para2 estrelas por ship_awaken. É uma operação com custo; o roteiro não prova uma concessão gratuita de materiais para ela.

## Primeiro baú

pve_scene linha1 referencia scene_reward1 e limiar6 estrelas. scene_reward linha1 lista 6000 Ryo,50 gold,5 Poções de Aprimoramento (item68),10 Fragmentos de Konohamaru (item57). As probabilidades dos dois itens são1/1.

scene_reward_drop grupo1 também lista esses quatro recursos e adiciona1 Recruit Book (item239, livro de recrutamento). Portanto há diferença entre a tabela antiga/visual e a biblioteca de entrega; não omitir essa diferença ao falar em equivalência ao servidor. O APK permite apontar o livro na biblioteca, mas sozinho não demonstra que o servidor efetivamente usava essa biblioteca no resgate.

## Recompensas das fases: não assumir total final

Os NPCs1–5 possuem difficulty_reward `99,99`, drop_library642,643,644,645,646 e first_reward2000,2001,2002,0,2003, respectivamente. Uma tela genérica interpreta os dois valores de dificuldade como prata/EXP. Porém LPVENpc.lua:1053 usa grade_silver_reward e o custo de energia para a prévia de moedas, e há bibliotecas de primeira vitória adicionais. Logo495 Ryo descreve a política atual do port baseada no primeiro campo, não comprova o total recebido no servidor original deste APK.

scene_reward_drop possui grupos2001,2002,2003 com100000 Ryo +1 baú de fragmentos de ninjaR15 (item347) +10 caixas de Tomoe de clã (item318) cada. Não encontrei grupo2000 nem grupos642–646 nessa mesma tabela; IDs de linha642–646 existem, mas pertencem a grupos1527–1531. Não confundir chave da linha com library_group nem somar automaticamente esses candidatos a um total garantido. Falta comprovar como o servidor resolvia essas referências e se aplicava esses grupos nessa versão.

## O que não pode entrar na conta do tutorial inicial

- Os5000 Ryo e itens68–71 do kit de qualidade são uma política do nosso servidor local; não foram encontrados como concessão explícita nos grupos iniciais deste APK.
-20 mil Ryo do grupo10 e10 mil do grupo13 são orientações posteriores, fora dos grupos1–7.
- Prêmios de login, sete dias, primeira recarga, missões principais e correio são sistemas separados. Abrir suas telas não equivale a receber tudo.
- O saldo líquido após completar o tutorial depende de custos, drops, estado inicial e entregas de servidor. Não há base para certificar um inventário final integral apenas somando as prévias do cliente.

## Resultado

Fase final do bloco inicial: **2-2, seguida da lição de Naruto2 estrelas (nível6)**. Aquisições guiadas: Sakura e Konohamaru, além do Naruto inicial; primeiro baú e EXP de introdução documentados acima. Recompensas totais de combate e saldo final oficial continuam sem comprovação integral.
