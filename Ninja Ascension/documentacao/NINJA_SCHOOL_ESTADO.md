# Ninja School — estado desta atualização

Última atualização: 27/10/2026 (VPS Windows, pacote em `C:\Users\Administrator\Desktop\Ninja Ascension`).

## Implementado

### Base (26/10/2026)
- Estado inicial para as 12 telas originais, entregue no login e nas consultas de inicialização.
- Correção do formato de espírito nos personagens e dos objetos de matriz de ligas.
- Correção de comparação com conquista ausente na tela de artefatos.
- Política local de teste: 10.000 pontos de talento na primeira inicialização, sem recriar a conta ou alterar sua formação.

### Talentos (`ship_talent_*`)
- `ship_talent_init` e `ship_talent_level_up`: custos originais (`ship_talent_param`), pré-requisitos de página e de talento, limite, persistência e proteção contra repetição.
- **Novo — `ship_talent_reset`:** custa 500 diamantes (`local_resources.gold`); o valor é o impresso no CSB original `cultivate_talent_reset.csb` ao lado do ícone de diamante, porque o cliente não envia nem valida o custo. Devolve todos os pontos de talento e toda a prata gasta, como diz o texto original da janela. A resposta usa os parsers originais 25 (diamantes), 22 (prata), 171 tipo 7 (janela de recompensa que o cliente abre), 6043 (pontos) e 12559 (estado). Sem talentos comprados, recusa (`nenhum_talento_para_redefinir`) em vez de cobrar.
- **Novo — efeito em combate:** os bônus entram nos atributos autoritativos enviados ao cliente (parser 15995), que o `FightObject` usa no combate e no cálculo de poder.
  - Condição 0 = todos; 1 = fileira da frente (posições 1–3); 2 = fileira de trás (4–6). A divisão segue `move_logic.lua` ("前排1号位", "后排4号位").
  - Condições 3/4/5 = Ninja ATQ/Técnica/DEF, mapeadas para `ship_mould.camp_preference` 1/3/2. Evidência: os ícones originais `sm_type_bar_1/2/3` são espada, escudo e pergaminho, e as descrições do talento citam "Ninja(ATK)/(Skill)/(DEF)".
  - Tipos 0–3 (PV/ATQ/DEF/DEF mágica fixos) e 4/5 (PV%/ATQ%) são aplicados no painel. Os tipos percentuais vão para o painel porque a fórmula de combate usa o percentual de ataque como fração, enquanto a tabela grava "+2%" como 2. Os demais (33/34 dano final, 8 crítico, 10 bloqueio, 40 roubo de vida, 42 reflexão, 43 dano crítico, 55/56/57, 70/71) vão por `property_values`, nas unidades que o `FightObject`/`BattleObject` já esperam.
  - Os bônus dependem da posição e são recalculados quando a formação muda (`formation_change` já reenviava os atributos).

### Espírito digital (`ship_spirit_*`) — novo
- `ship_spirit_init` (consulta por ninja), `ship_spirit_level_up` (um item escolhido, ou `-1` = presentear tudo) e `ship_spirit_batch_level_up` (quantidades `a,b,c`).
- Valida posse, se o ninja pertence ao grupo de `ship_spirit_group`, itens em `local_inventory`, nível máximo e repetição. Consumo e atualização ocorrem na mesma transação SQLite.
- Experiência por item, níveis e faixas conforme `ship_spirit_group`/`ship_spirit_param`. Ao completar o último nível de uma faixa, passa ao nível 1 da faixa seguinte (mesma regra do cliente em `sm_cultivate_spirit_cell.lua`). Limite `ship_config` 48 = 600.
- Efeitos: atributos de `ship_spirit_mould` (ATQ, DEF, PV fixos e os dois atributos percentuais do grupo, como crítico/resistência, dano/redução final, bloqueio/quebra de bloqueio) e `speed_add`, cumulativo por nível na tabela. A velocidade vem da configuração original do espírito, não do nível comum do personagem.
- Persistência por personagem em `local_ninja_school.state.spirits`. O bloco do personagem no login (`shipSpirit`) agora usa esse estado em vez do valor fixo `:1,0,1`. O parser 15997 local aplica `local_ship_spirit` a `user_ship`. Cada ninja vai num bloco 12560 próprio, porque o parser original só lê corretamente uma entrada por bloco.

### Index (`user_card_info_*`) — novo (27/10/2026)
- Mapa das abas (imagens `TF_res/c*.png`): Talent=talento, Team Spirit=espírito, Shamanism=artefato, Achievements=conquistas, Sculpture Mountain=constelação, Mudra=Alloy Matrix, Aid Team=soulward, Ninja Tool=silkbag, Combo Card, Index=illustration, Ninja Saga=roleBiography, Tailed Beasts=mythicalAnimals.
- `jogo/port/server/index_local.py`: ativar carta (ninja possuído, nível 0, grátis), subir nível (nível da carta + 1 ≤ estrelas do ninja; custo do `card_unblock`), pontuação, bônus por nível e faixas de `card_achieve`; ranking (12665) com os jogadores deste servidor.
- Respostas nos parsers originais 12663/12664 + inventário + atributos. Os bônus do Index entram em `combat_bonus` para todos os ninjas.
- Cliente: número de pedido nos dois comandos (`shop_local.lua`) e `illustration_info_init` sempre aplicado a partir do servidor.
- Limitação: cartas combinadas são recusadas (`condicoes_especiais_da_carta_combinada_nao_implementadas`), porque o progresso das condições especiais ainda não é rastreado.
- Teste: `jogo/tools/test_index_local.py`.

### Mudra / Alloy Matrix (`ship_metal_*`, `draw_matrix_reward`) — novo (27/10/2026)
- `jogo/port/server/mudra_local.py`. Compra pelos 5 botões originais (`ship_bounty` 4/5 e `ship_batch_bounty` 5/6/7 → `partner_bounty_param` 13–17): custo em Ryo ou gold, 1 grátis por dia nos dois botões de 1x, limite diário de `ship_config` 41, prêmios de `bounty_hero_param` (66 = peça, 67 = essência, 1 = Ryo). O baú de equipamentos (tipo 3) continua no `shop_local`.
- Equipar/trocar/retirar (`ship_metal_set` tipos 0/1/2): casas 4/6/8 por grupo, liberadas pelo nível do ninja (`ship_config` 39); uma peça só fica em um lugar.
- Fortalecer: nível com essência (`next_need_exp` × fator 35 da qualidade); nos degraus de rank, Ryo (`next_level_gold` × fator 36). Tipo 0 = um passo, tipo 1 = tudo que a essência permitir; fortalecimento total do grupo até o nível escolhido.
- Derreter: só peças fora do ninja; devolve 100% da essência e 80% do Ryo gastos (`ship_config` 37).
- Formações: a de cada grupo vem da lista do ninja (`ship_mould` coluna 68) e de `ship_matrix_mould`. A primeira ativação libera a recompensa de `ship_config` 40 (50 essência + 10.000 Ryo), que só pode ser recebida uma vez.
- Bônus no combate: atributos das peças (`ship_metal_param` × fator de qualidade) e da formação ativa (`ship_matrix_param`) somam em `combat_bonus` do ninja.
- Login/abertura: 14111 (peças), 12047 (essência), 14113 (contadores) e `alloyMatrix` real no bloco 14104 de cada ninja.
- Reconstrução (não está no cliente): quando várias formações cabem no mesmo grupo, vale a que usa mais peças, depois a de maior qualidade; a qualidade da formação é a menor qualidade entre as peças usadas.
- Teste: `jogo/tools/test_mudra_local.py`.

### Shamanism / artefatos (`artifact_*`) — novo (27/10/2026)
- `jogo/port/server/artifact_local.py`. Prática básica/intermediária/avançada (custos de `artifact_mould`, 1x ou 10x), resultado pendente até confirmar (escolher quais práticas aplicar) ou cancelar; limites por nível da equipe (`artifact_param`); bônus para todos os ninjas.
- Liberação dos artefatos 2–9 pelas conquistas gerais (`achieve`), via `achievements_local.completed`.
- Reconstrução: a prática de nível m sorteia m+1 vezes e fica com o melhor valor (o texto de ajuda só diz que a avançada é a melhor).

### Sculpture Mountain / constelação (`constellation_buy/exchange`) — novo
- `jogo/port/server/constellation_local.py`. Comprar bênção (Ryo ou gold), passar a usar, trocar entre compradas; nível da equipe por qualidade (`play_config` 80) e ninja exigido quando `lock` = 1.
- Reconstrução: os atributos da bênção em uso vão para o ninja da própria casa; `ctv` = soma dos valores de guarda em uso.

### Ninja Saga (`biographies_*`) — novo
- `jogo/port/server/saga_local.py`. Painel de compra (`play_config` 199–202), sorteio normal/avançado 1x/10x (grátis por dia, bilhetes 2105/2106, limites, biblioteca garantida a cada 10, prêmio extra por sorteios avançados), síntese de marks (`mark_synthesis`), ativar saga com marks, estrelas, redefinir estrelas (800 gold, devolve marks), conquistas da saga liberando capítulos e estrelas, ranking.

### Tailed Beasts (`magical_animals_*`) — novo
- `jogo/port/server/mythical_local.py`. Ativar com fragmentos, subir estrelas, forja (pedras 2325/2326/2327, estágios), redefinir forja (100 gold, devolve pedras), conexões entre bestas, habilidade equipada e modo de uso. Destino (天命) ainda é recusado (não implementado).
- Conta RenegadoBR: Kurama (besta 4) e Gyuki (besta 3) ativados na estrela 1, com 700 fragmentos de cada (o necessário para chegar à estrela 5). Backup antes: `contas-antes-bestas-20261027-113125.sqlite3`.

### Achievements (`draw_achievement_reward`) — novo
- `jogo/port/server/achievements_local.py`. Aba da Ninja School (12565) e progresso geral (3501). Progresso calculado do que o servidor registra: nível, missões diárias, estrelas de fase, ninjas por estrela/qualidade/aptidão, selos no máximo, esculturas, capítulo 12. Tipos sem registro neste port ficam em 0 (não são inventados).
- Os pontos das conquistas aparecem na aba; não somam à velocidade da equipe (o cliente confere a velocidade com o servidor).

Testes: `test_artifact_local.py`, `test_constellation_local.py`, `test_saga_local.py`, `test_mythical_local.py`, `test_achievements_local.py`.

## Testes realizados (27/10/2026, nesta VPS)
- `tools/test_ninja_school_local.py` (banco temporário): **PASSOU**. Cobre custos, recusa sem recursos, repetição com o mesmo identificador, reutilização com outro conteúdo, pré-requisitos, limite, reset/reembolso, bônus de frente/trás no atributo efetivo, remoção do bônus após o reset, espírito (item único, lote, tudo, troca de faixa, nível máximo, velocidade, recusas de grupo/posse/itens) e relogin com o estado persistido.
- Regressão (banco temporário): `test_hero_stats_local`, `test_hero_quality_local`, `test_hero_development_local`, `test_hero_gates_local`, `test_hero_level_local`, `test_shop_local` e `test_quest_local` **passaram**.
  - `test_recruitment_local` falha porque o replay difere no timestamp do bloco 12040, gerado por `ship_tokens`.
  - `test_hero_training_local` falha porque espera a prata concedida pelo tutorial, que está desativado.
  - Essas duas falhas já existiam e não têm relação com a Ninja School.
- Simulação sobre uma **cópia** do perfil ItachiBR (id 61): login e atributos sem erro. Os bônus de talento aparecem apenas nos ninjas da formação, conforme a fileira. O banco real não foi alterado (`integrity_check` = ok).
- **Executável: NÃO validado nesta VPS.** O cliente Debug encerra com `0xC0000005` logo após abrir `resource-probe.log`, antes de qualquer mensagem. O mesmo acontece no boot normal, sem variáveis de probe, então a causa não está nas mudanças da Ninja School.
  - Testado e descartado: runtime Debug ausente (as DLLs estão presentes), espaço no caminho e backends `ANGLE_DEFAULT_PLATFORM` (d3d9/gl/swiftshader/vulkan).
  - O dxdiag informa D3D 11/12 disponível (VMware SVGA 3D e adaptador RDP). A máquina de origem usava uma AMD RX 5500 XT.
  - Próximo passo sugerido: compilar Release com símbolos, ou executar com depurador para obter a pilha.

## Pendente
- Validação no executável: abrir telas, cliques, animação de presente, janela de recompensa do reset, relogin sem travar nos 9% e efeito visível no combate.
- Artefatos: desbloqueio, treinamento e confirmação.
- Conquistas calculadas a partir do progresso real.
- Guardiões/constelações, ligas/matrizes, apoio, ferramentas ninja, cartas combo, coleção, biografias, criaturas e suas habilidades.

## Limitações conhecidas e decisões locais
- Talentos com condições 9–13 (Arena, Ninja King, Clan Battle e modos entre servidores) ficam gravados, mas não são somados aos atributos da campanha/menu, porque esses modos não existem neste port.
- A ordem exata de aplicação no servidor oficial não foi recuperada. Localmente, os bônus fixos de talento/espírito entram antes dos percentuais, e PV%/ATQ% de talento somam com os percentuais de vínculo. Isso é uma reconstrução, não uma fórmula oficial comprovada.
- O custo de 500 diamantes do reset vem do layout original, não de uma tabela de servidor.

Nenhum sucesso de compra ou recompensa foi inventado para as operações pendentes. Os estados vazios significam que não há aquisições locais registradas.

## Arquivos alterados nesta etapa
- `jogo/port/server/ninja_school_local.py`: reset, espírito, `combat_bonus`, respostas com atributos.
- `jogo/port/server/hero_stats_local.py`: aplica `combat_bonus`; nova `attribute_tokens`.
- `jogo/port/server/recruitment_local.py`: `shipSpirit` persistido no bloco do personagem.
- `jogo/port/server/recarga.py`: novos comandos para recarga a quente.
- `jogo/port/lua/shop_local.lua`: identificador de pedido para os novos comandos; aplica `local_ship_spirit`.
- `jogo/port/lua/menu_boot_probe.lua`: caminhos `N:/` trocados por `NR_GAME_ROOT` (fallback `N:`).
- `jogo/tools/test_ninja_school_local.py` e `jogo/tools/test_ninja_school_native.py`: teste ampliado; o teste nativo passa `NR_GAME_ROOT`.
- Backup antes das mudanças: `jogo/port/dados/backups/contas_antes_ninja_school_20261026_235616.sqlite3`, feito com a API de backup do SQLite.
- Criadas as junções `jogo/res` e `jogo/src`, as mesmas que o `iniciar.ps1` cria.

Reinício: o servidor não estava em execução. Ao iniciar `INICIAR_JOGO.cmd`/`INICIAR_SERVIDOR.cmd`, o código novo é carregado; com um servidor já aberto, é preciso reiniciá-lo ou usar a recarga de `recarga.py`. O cliente lê `port/lua` na inicialização, portanto precisa ser reiniciado.
