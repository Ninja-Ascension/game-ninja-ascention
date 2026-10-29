# Números de dano acumulados e habilidade especial do Sasuke travada

Estado: **parcial**. Uma causa real foi provada e corrigida; o restante está
delimitado abaixo com o que foi medido e o que **não** foi.

Commit: `3ea2bc9`.

---

## 1. Método

Duas regras guiaram o trabalho:

* **Cada sintoma investigado na própria evidência.** A imagem do jogo não prova
  que os números de dano bloqueiam o clique, então não foi usada como prova de
  nada.
* **Nenhum log antigo usado como evidência da execução atual.** `server.log`
  tem 2,3 MB de tráfego de teste (incluindo um laço `education_change ... ACK
  neutro`); as medições abaixo são todas desta sessão, feitas no binário.

Sondas em `port/lua/diag_*.lua`, chamadas por variável de ambiente dentro do
bloco `NR_PROBE_RENDER_TEST=1` do `boot_map.lua`, com o binário real
(`NinjaResourceProbe.exe`) e o CSB real de cada tela.

---

## 2. Primeira exceção da execução atual — PROVADA E CORRIGIDA

O `server.log` registrava, no caminho de batalha:

```
FightUI.lua:2593: attempt to index a nil value
  in function 'updateAnimalUIShowState'
```

Cadeia completa, medida:

| Passo | Evidência |
|---|---|
| `FightUI:onEnterTransitionFinish` chama `refreshAnimalSkillInfoUI` | `FightUI.lua:2513` |
| O ramo roda porque o recurso está aberto | `MythicalAnimals = 1`; tabela `project_function_synchronization_open_condition` linha 1 = `1<TAB>1`; `dms.int(t,1,2)=1` → `MythicalAnimals_aberto=true` |
| O corpo exige `Panel_shenshou_effect` e `Panel_shenshou` | `FightUI.lua:2531` e `:2593` |
| `Panel_shenshou_effect` existe | `widget Panel_shenshou_effect = true` |
| **`Panel_shenshou` não existe** | `widget Panel_shenshou = false` |
| A chamada original estoura | `sem_guarda_estoura=true erro=FightUI.lua:2593: attempt to index a nil value` |

O `battle_UI.csb` do APK contém **apenas** quatro painéis
(`Panel_team_head_hb_right_1_pr1`, `_right_2_pr1`, `_left_2`, `_left_1`). O
painel do 神兽 era **baixado como patch** pelo cliente Android e não está nos
recursos recuperados — ou seja, aquele ramo nunca teve o que procurar.

**Por que isso importa para os dois sintomas:** a exceção estourava dentro de
`onEnterTransitionFinish`, ou seja **no meio da montagem da UI de batalha**.
Tudo depois da linha 2513 não rodava, deixando o estado inconsistente.

### Correção

`port/lua/fight_ui_animal.lua` embrulha `FightUI:refreshAnimalSkillInfoUI` —
o acervo não foi editado. O corpo original roda apenas quando os widgets que
ele exige existem no CSB carregado; caso contrário, registra uma linha e
retorna.

Deliberadamente **não** se fez: substituir o método por função vazia, forçar
`GetProjectFunctionIsOpen` a `false` (mentiria sobre a configuração do
projeto), ou engolir exceções de outros pontos.

`port/lua/animal_contract.lua` prova as três afirmações:

```
ANIMAL_CONTRATO MythicalAnimals_aberto=true
ANIMAL_CONTRATO alcancou_updateAnimalUIShowState=1
ANIMAL_CONTRATO sem_guarda_estoura=true erro=FightUI.lua:2593: attempt to index a nil value
ANIMAL_CONTRATO com_guarda_ok=true erro=nil
ANIMAL_CONTRATO com_widgets_ok=true erro=nil
ANIMAL_CONTRATO_PASSED guarda evita a exceção e não vira no-op
```

---

## 3. Números de dano — o que foi medido e descartado

Investiguei `DrawHitDamage.lua` e a sua cadeia até o fechamento da janela.
Medições desta sessão, no binário:

* Uma janela **fecha corretamente isolada**: `exitCalls=1 fechadas=1
  golpes=0 danos=0` — os arrays são limpos e a saída chega ao callback.
* O relógio de fim de janela **funciona**: `metodo_na_classe=function`,
  `chamada ok=true`.
* `_battle_controller` **existe** e tem `_draw_hit_damage_duration=2`, então
  `_duration` **não** é zero (hipótese refutada por medição).
* A timeline de saída avança e entrega o evento de fim:
  `evento_de_fim_chegou=true no_passo=11`, `duracao=75`.

**Não** encontrei, por medição, um laço que deixe janelas vivas quando as
timelines avançam. Ou seja: **a causa do acúmulo na tela não está provada
ainda.** O que a primeira exceção acima explica com segurança é a montagem da
UI de batalha quebrada no meio — que é justamente onde a janela de dano e a
liberação de toque dependem de estado consistente. Se isso é suficiente para
produzir o acúmulo observado, **só a sua validação no jogo mostra** — não vou
declarar resolvido com base em raciocínio.

Ponto ainda suspeito, registrado para a próxima etapa: em
`DrawHitDamage.lua:377-385` o fechamento de fato (`fwin:close(self)` e
`setVisible(false)`) está **comentado no acervo**; o que sobra limpa os arrays e
chama o terminal com parâmetro negativo. E `_elapsed` é zerado a cada acerto
(`:142` e `:175`), então uma sequência contínua de golpes mantém a janela
aberta por desenho.

---

## 4. Habilidade especial do Sasuke — o que foi delimitado

O caminho que libera a especial é a missão de `execute_type` 45
("角色释放绝技"), `Mission.lua:2866-2871`:

```lua
_ED._fightModule:setPowerSkillState(attackerCamp, attackerFormationIndex, true)
```

`FightModule:setPowerSkillState(battleTag, coordinate)` (`:2163`) percorre
`fightOrderList` e, **só quando acha um item com `battleTag` e `coordinate`
iguais**, faz:

```lua
battleObject.skipSuperSkillMould = true
battleObject:setSkillPoint(math.max(battleObject.skillPoint, FightModule.MAX_SP))
```

Se nada casar, retorna `nil` em silêncio — a especial nunca fica disponível,
sem erro no log. É exatamente o tipo de falha que produz "o indicador aponta,
mas não ativa".

Varri todas as tabelas de dados do acervo (`tools/achar_super_skill.py`) e há
**10 linhas** com `execute_type=45`, todas em `environment_ship.txt` e
`program_reward.txt`, com `param1/param2` = `0/0` ou `-9999/9999`. **Nenhuma
delas é a do tutorial.** Então o tutorial do Sasuke chega a esse estado por
outro gancho (`execute_type_touchUI = 3`, "点击UI"), e **não localizei ainda
qual** — é o ponto onde parei.

Pelos limites da tarefa: **não** forcei energia e **não** removi bloqueios. A
condição que barra a especial ainda **não foi identificada**, e sem ela
qualquer mudança seria chute.

---

## 5. Limites honestos desta etapa

* **Não houve validação visual.** Não tenho acesso a clicar no jogo nesta
  sessão; você é quem valida.
* **Não declarei o tutorial resolvido.** A montagem da UI de batalha agora
  completa; se isso basta para a especial do Sasuke destravar, a sua execução
  dirá.
* Até onde a execução foi **realmente** validada: contratos automatizados no
  binário real (abaixo). Nenhuma etapa do tutorial foi percorrida de ponta a
  ponta com toques reais.

---

## 6. Arquivos alterados

* `port/lua/fight_ui_animal.lua` (novo) — guarda do painel do 神兽.
* `port/lua/animal_contract.lua` (novo) — prova as três afirmações.
* `port/lua/diag_animal.lua` (novo) — medição que localizou o widget ausente.
* `port/lua/boot_map.lua` — uma linha: `require('fight_ui_animal').armar()`
  (mais o gancho do contrato).
* `port/server/local_server.py` — dump `[CORPO]` atrás de `NR_LOG_CORPO=1`.
* `tools/test_local_server.py` — **parou de escrever no banco de produção.**
  Ele criava `suite_local_1` toda vez que rodava; encontrei 3 contas de teste
  no banco real e removi. Agora os passos de escrita exigem
  `NR_LOCAL_TEST_ALLOW_WRITE=1` com banco descartável.
* `tools/achar_super_skill.py` (novo) — varredura das linhas `execute_type=45`.

Preservado: `port/lua/native_spine.lua` e `port/native/LegacyCharacter.cpp`
(correções de animação) têm **diff zero**. Os ajustes não commitados que já
estavam na árvore (`battle_lifecycle.lua`, `test_battle_lifecycle.py`, dois
`.md`) continuam como estavam.

---

## 7. Testes

Todos com exit 0, no estado commitado:

| Suíte | Resultado |
|---|---|
| `test_layout_editor.py` (7 etapas) | 7/7 exit 0 |
| `test_local_server.py` | exit 0, **sem escrever** (`contas antes=24 depois=24`) |
| `test_sessao_perfil.py` | exit 0 |
| `test_battle_lifecycle.py` | exit 0 |
| `test_freio_de_laco.py` | exit 0 |
| `test_contas_e2e.py` | exit 0 |
| `test_tutorial_state.py` | exit 0 |
| `test_window_open_contract.py` | exit 0 |
| `NATIVE_TUTORIAL_WAVE2_PASSED` | passou |
| `NATIVE_RENDER_CONTRACT_PASSED` | passou |
| `ANIMAL_CONTRATO_PASSED` | passou |

Contas e perfis preservados; banco só no disco E.

---

## 8. Próximo passo (o que falta, concretamente)

1. Rodar o tutorial até o ponto da especial do Sasuke e capturar, na execução
   atual, o `execute_type` e os `param1/param2` do evento que deveria liberar
   a especial — com isso descobrir **qual** gancho chama
   `setPowerSkillState` no tutorial e por que o `fightOrderList` não casa.
2. Com a causa da especial identificada, verificar se o acúmulo de números
   persiste com a UI de batalha montada por inteiro (a primeira exceção já não
   interrompe mais a montagem).
3. Só então escrever os testes de regressão dos itens 7 da tarefa.
