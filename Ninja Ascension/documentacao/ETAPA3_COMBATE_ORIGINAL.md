# Etapa 3 — integração do combate original (fatias 1 e 2 concluídas)

23 October 2026. Scope of this document: the first tested slices of the
ORIGINAL battle simulator running offline inside `port/lua/local_battle.lua`'s
sandbox, executed by the native smoke (`NR_PROBE_TEST_MODE=battle` +
`NR_PROBE_BATTLE_REPORT=1`).

## Fatia 2 — repasse do estado original do simulador na cena (playback)

Concluded after slice 1 (`commit 4d3371e`). Findings that shaped it:

- The captured protocol frames are ROUND BOOKKEEPING, not action rows
  (`battle_animal_anger_value #474=100`, `environment_fight_battle_camp_change
  #14712=20`, `environment_fight_battle_round #14711=18`,
  `environment_fight_round_start #14710=2` in run
  `build/layout-tests-3d6ec3649b394526b8eb49c0c374f1b8/`).
- The per-seat ACTION rows (damage/seat/skill) exist only in the SERVER frame
  `environment_fight` #39. The ORIGINAL decoder for it is IN the recovered
  tree (`client/protocol/ProtocolParserCopy.lua:2747`, registered by
  `ProtocolParser.lua` code 39 — builds `_ED.attackData.roundData` with
  attacker/pos/skill/influences/damage/hit-state/death/hp), but in this
  recovered client no offline writer composes #39 (the candidate writers
  `initFight`/`doFight` exist; `FightModule:fight(...)` is COMMENTED OUT in
  the recovered FightModule, so `doFight` cannot run unchanged).
- The recovered LIVE client did not need #39 for animation:
  `FightRoleController` drives `rountdFight` STEP BY STEP and animates from
  the SIMULATOR OBJECT STATE (that is the faithful offline contract).

Therefore slice 2 implements the state-step playback:

- `NRBattle.roundSamples()` re-runs the ORIGINAL fight deterministically and
  samples, after every `rountdFight` step, per-seat health/dead of BOTH camps
  (`runOnce`-equivalent; initial state row included; CSV rows verified 21 for
  the mirror fight).
- Native playback (`LocalBattle.cpp`): `loadPlayback` parses the rows;
  `enterForCapture` starts the replay; each step animates attack/hit/death
  (`07_pugong` / `03_beiji` / `06_siwang` on the already-verified
  `spirte_102101` skeleton) exactly per the DELTA of real simulator state,
  first existing seat per camp (the npc 1 formation leaves some seats empty).
- Evidence run `build/layout-tests-697581e9d0e14a2098a885d358a2b57b/`:
  suite 6/6 exit 0; `LOCAL_BATTLE_PLAYBACK_LOADED rows=21`; the live steps
  show real sim HPs (`round=1 hero=420 enemy=418`, `round=2 hero=419
  enemy=416`…) and `battle-active-shot.png`/`battle-shot.png` were saved
  BETWEEN playback steps (mid-replay captures).

## Fatia 3 — elenco por assento + botão de repasse na UI

- `LocalBattle::startPlayback` monta um personagem por ASSENTO OCUPADO dos
  dados originais (pool até 6×2; posição por linha de assento; oculto o par
  "toy" hero/enemy durante o repasse; restaurado ao sair).
- `playbackAdvance` anima cada assento pelo SEU delta real: morte→`06_siwang`,
  dano→`03_beiji`, lado atacante inferido (único campo que o acervo offline
  não preserva por passo) anima `07_pugong`; mortos continuam no chão.
- UI: botão **“Reproduzir combate original (simulador)”** no painel da batalha
  ativa o repasse no executável (o usuário dispara e assiste; o repasse
  automatizado de captura continua idêntico).
- Evidence run `build/layout-tests-b114eb60aa244c15b9049e3404d3fa17/`: suite
  6/6 exit 0; `PLAYBACK_LOADED rows=21`; passos com `attacker=camp0/camp1`
  inferido e HPs reais do simulador.

Limites honestos: a formação 1 do npc 1 tem 1 assento ocupado (não há elite
multi-assento neste par de dados); a inferência do atacante é por campanha
(não por assento) porque o acervo offline não preserva esse ponteiro por
passo; sem efeitos visuais de skill (ainda). Próxima fatia: npc/formações
não-espelhadas (Etapa 4) e skill→animação por influência.

## Etapa 4 (corte 1) — combate NÃO-espelhado com dados originais

`runOnce`/`roundSamples` agora usam **linhas reais diferentes** para os dois
lados: ataque = `environment_formation` linha 2 (dois navios reais, ids 8 e
11 de `environment_ship.txt`), defesa = as ondas do npc 1 (formação 1). Mesma
chamada ORIGINAL (`initBattleField` branch PVE_ELIT); só os dados de entrada
mudaram. Resultado medido (run
`build/layout-tests-f44b0adf9bf74d2e90bf2e0fe2ddc395/`): **`result=1`
(VITÓRIA do lado com 2 navios) em 4 rodadas**, events=3355, frames=58,
determinismo asssertado nas duas corridas, suíte 6/6 exit 0. O playback
(full cast por assento) passou a exercitar o caminho multi-assento.

## Etapa 4 (corte 3) — seleção de lutas originais na UI

- `NRBattle.battlePairs(24)`: inventário REAL (npc × environment_formation com
  assentos ocupados; leitura pura de `dms`/`ConfigDB`, sem fabricar dados) —
  evidence: `LOCAL_BATTLE_PAIRS count=24` (run
  `build/layout-tests-66a6df4aa0af4c298f8b95bc68460397/`, suíte 6/6).
- `NRBattle.setPair(npc,eve)`: validação alto-e-sonora (formação existe, npc
  tem ondas, onda-1 existe) antes de trocar `battleNpcId/battleEveNpc`; limpa
  frames em cache do par anterior.
- UI: combo “Luta original — Ataque=formação X (N navio(s)) vs NPC Y” no painel
  da batalha; ao escolher, `applyPair` revalida, re-simula (`roundSamples`) e
  inicia o repasse na hora. Erros aparecem no painel (nada silencioso).

## Etapa 4 (corte 4) — números flutuantes de dano/cura por delta real

- Cada passo do repasse exibe, sobre cada assento alvejado, o **delta real de
  HP do simulador** (vermelho para dano, verde para cura — a direção do valor
  é o próprio estado, nunca inventado; efeitos que não alteram HP exceto
  dano/cura não têm número sem o parser #39 — limite mantido).
- Implementação: `spawnDelta` (Label + Spawn{MoveBy,FadeOut} + RemoveSelf),
  chamado em `playbackAdvance` nos ramos morte/dano/cura de cada assento.
- Evidence run `build/layout-tests-e7bd0d1c0b4349338cfb161aeb311ca0/`: suíte
  6/6 exit 0; capturas salvas em pleno repasse (números possivelmente visíveis
  no frame — validação visual segue humana).

## Etapa 4 (corte 5) — ondas múltiplas do defensor (driver ORIGINAL jumpFight)

- `reportTest` agora roda o driver ORIGINAL completo
  `FightModule:jumpFight` (linha 5590): para cada onda, esgota
  `rountdFight` e passa por `initBattleInfo`, que carrega a próxima onda e
  avança `currentBattleCount` — mesma sequência de produção.
- `roundSamples` espelha o MESMO loop (com hooks de amostragem) e rotula cada
  linha com a **onda** (`round,wave,step,camp0,camp1`); a UI mostra
  "Rodada N (onda W)" a partir da segunda onda.
- Bug honesto corrigido no caminho: a semente do gerador agora **recomeça por
  corrida** (`runOnce`/`roundSamples`) — com ondas, a contagem de sorteios
  divergia entre as duas passadas de determinismo (as passadas são idênticas
  por construção da semente; a paridade com o RNG do APK segue NÃO afirmada).
- Padrão atual: npc 1 (defesa com 2 ondas: formações 1 e 2) × ataque
  `environment_formation` 3. Evidence run
  `build/layout-tests-eac01fd6700048399b53941cfd0c37e4/`: suíte 6/6 exit 0,
  `REPORT_PASSED OK rounds=4 events=3574 result=1 frames=74 waves=2`.

## Etapa 5 (corte 1) — identidade original por assento no repasse

- `NRBattle.seatRoster(wave)`: para cada camp, lê os assentos da formação
  REAL usada naquela onda (ataque `battleEveNpc`; defesa
  `npc:getEnvironmentFormation(wave)`) e resolve o nome pela cadeia original
  `environment_ship.ship_name` → `word_mould` col 3; vírgulas/quebras
  sanitizadas para o CSV; qualquer linha ausente falha alto.
- C++ `updateRosterLabels(wave)`: etiquetas `nome #shipId` acima de cada
  personagem (ax::Label, CJK ok), chamada no início do repasse (onda 1) e a
  cada troca de onda; falha é registrada (fail-soft na UI, o repasse segue).
- Limite mantido: a skill exata por passo não sobrevive no estado do módulo
  (`addReleaseSkill` morto no acervo; detalhes ficavam no frame #39 do
  servidor) — o nome/efeito de skill por passo segue bloqueado pelo mesmo
  parser. Skeletons: só `spirte_102101` existe no acervo; modelos
  225/25/237/137 não — reuso documentado em todos os assentos.
- Evidence run `build/layout-tests-9d191a2622834d11aebe2ab1afbd4971/`: suíte
  6/6 exit 0, `LOCAL_BATTLE_ROSTER wave=1`.

## Etapa 5 (corte 2) — habilidade real por passo (carimbo de ação do módulo)

- Primeira tentativa (contadores `normalSkillUseCount`/`skillPoint`) deu
  `events=0`: no NR, ataque comum não incrementa contador (FightModule
  2975-2988 mostra que o contador só sobe na PEQUENA habilidade) — não usar.
- Caminho correto, 100% dentro do módulo: cada ação reseta
  `headBuffer/bodyBuffer` (2741-42), guarda o atacante em
  `self.currentObject` (2728) e carimba o skillId disparado em
  `bodyBuffer[3]` (3013). `NRBattle.skillSamples()` espelha o loop de ondas
  e emite `step,camp,seat,event,skillId,name` com camp/seat por IDENTIDADE
  do ator nos arrays (mesma indexação do pool de playback) e nome direto de
  `skill_mould.skill_name` (vírgulas/quebras sanitizadas; linha ausente =
  falha alta). Evento classificado: normal / small / power / skill.
- C++: `loadStepSkills` no `loadPlayback` (cobre prepare + troca de par);
  `spawnSkillTag` mostra a etiqueta por passo sobre o ator (amarelo normal,
  laranja small, violeta power, azul não classificado).
- Ainda não coberto pelos eventos: os danos por alvo que seguem no
  bodyBuffer (base para a fatia 3 — efeitos de influência por alvo).
- Evidence run `build/layout-tests-a650620b165e446cbc8eb0404a9b5ef8`: suíte
  6/6 exit 0, `LOCAL_BATTLE_SKILLS events=9` (4 rodadas × 2+ atacantes).

Not claimed: no visual certification of these shots (human-eyes item), no
typed per-seat row stream beyond first-seat focus (deeper seat/Bookkeeping
per-influence animation mapping is queued for slice 3), no #39 synthesis —
a document boundary recorded here, never fabricated from samples.

## Resultado medido (rodada de validação)

```
LOCAL_BATTLE_REPORT_PASSED OK rounds=10 events=5842 result=0 frames=140 missing_data_files=13
LOCAL_BATTLE_SMOKE_PASSED: original damage, victory, defeat, restart, editor return
```

- The ORIGINAL 6,585-line `FightModule` simulator ran end-to-end (init battle
  field, fight order, 10 rounds) with: ORIGINAL damage formula
  (`FightUtil.computeCommonDamage`, coefficients from the ORIGINAL
  `data/configs/fight_config.txt`), ORIGINAL formations from
  `data/mould/environment_formation.txt` and ships from
  `environment_ship.txt`, ORIGINAL skills/equipment/restrain classes.
- Determinism asserted: two full fresh runs produced identical roundCount,
  event buffer size and fightResult under the seeded generator
  (`env.math.random` LCG; explicitly NOT claimed as APK RNG parity).
- `result=0` (`FIGHT_RESULT_LOST`) for the mirrored attack side — speed/action
  ordering of this specific data pairing; recorded as measured behavior.
- `events=5842` strings in the original result buffer format;
  `frames=140` protocol frames captured (see adapting points).

## Fatia offline escolhida (ambos os lados de dados originais)

The player-formation branch of `initBattleField` reads account data
(`_ED.formetion`, `_ED.user_ship`, `_ED.user_info.speed_sum` — original code
comments confirm these come from server-facing state). Out of offline scope.
The chosen slice is the ORIGINAL `FIGHT_TYPE_PVE_ELIT` (value 1) branch:
both sides are built from ORIGINAL environment data — attack side from the
environment_formation row passed as `eveNpc`, defence side from
`npc:getEnvironmentFormation(i)` for `npc.formationCount` formations. This
slice uses `npc` id 1 and both sides on its first formation (mirror match),
which is fully data-driven and needs no account.

## Sequência ORIGINAL espelhada (nenhuma lógica reimplementada)

Per `client/battle/report/BattleReport.lua` and the real battle entry
(`client/battle/fight/Fight.lua:495-509`):

1. `_ED._fightModule = FightModule:new()`
2. `initBattleField(npc, difficulty, fightType, resultBuffer, eveNpc, write)`
3. `initFightOrder(_ED.user_info, orderList)`
4. `while fightModule.hasNextRound ~= false do rountdFight(resultBuffer) end`
5. determinism check: run 1~4 twice from a reset sandbox state and require
   equal roundCount, buffer size and fightResult.

## Fechamento de dependências (tudo código original; lista explícita)

- Framework utilities: `frameworks/external/utils/utils.lua` (split/strippath/
  zstring/math.round), `frameworks/support/debug.lua`,
  `frameworks/support/state_machine.lua`,
  `frameworks/external/utils/local_datas.lua` (the `dms` database engine).
- Column dictionaries: `client/loader/LocalDatas.lua` (misson/user/play configs
  + all mould column maps), `client/loader/EnvironmentDatas.lua` (13,585-line
  global state table).
- Data index: `assets/res/configs/data/data_path_config.lua` (336 data .txt
  files; 13 are absent from the recovered APK — each miss is logged by name as
  `BATTLE_REPORT_DATA_MISS` and registered as an EMPTY dms entry so any real
  access fails loudly at the exact usage point).
- Battle report modules: the 31 modules of BattleReport's own load list
  (ConfigDB, IniUtil, FightObject, FightModule, Talent*, BattleCache, Npc,
  SkillMould, ShipMould, SkillInfluence, EnvironmentFormation/Ship(+Module),
  Restrain*, EquipmentMould, BattleObject, BattleSkill, FightUtil, ClassInit,
  FightBuff, Unit, Ship, FormulaUtil, RookieCache, RestrainMould),
  `FormationInfo`, and `client/l_digital/.../MythicalAnimalsHandle.lua`
  (required by FightModule itself).
- enums: `client/battle/fight/FightEnum.lua` (`_enum_fight_type` and friends).
- Config: ORIGINAL `configs/app.config` parsed with the ORIGINAL
  `cocos/cocos2d/json.lua` codec (loaded once in the engine scope because it
  is a Lua-5.1 `module()` file — the sandbox gets the same global bridged).

## Pontos de adaptação (documentados; nenhum comportamento de simulação alterado)

1. **NetworkProtocol.parser_func = captura offline** — `FightModule` escreve
   cada evento de round no formato histórico de protocolo e chama
   `NetworkProtocol.parser_func(data)` (caminho de servidor). Offline não há
   servidor: o `parser_func` capturado guarda cada frame VERBATIM
   (`{sequence=count, resouce=string}`) para a camada de apresentação. Estes
   140 frames são o contrato simulador→player das próximas fatias.
2. **`_fight_run_speed = {1,1,1,1,1,1}`** — acelerações de animação da
   APRESENTAÇÃO (`FightEnum._enum_action_time_speed`). Nenhum conteúdo
   recuperado atribui esses valores (nada em src/ e nada nos data files);
   usar 1x neutro marcado no código. O simulador não lê esta tabela.
3. **Dados ausentes = tabelas dms vazias** — 13/336 arquivos do
   data_path_config não vieram no APK recuperado; carregados como entradas
   vazias com registro por nome; qualquer acesso real falha com nil-index no
   ponto de uso (jamais silencioso, jamais inventado).

## Sandbox additions (mesmos valores do boot original, sem expandir poderes)

`env.cc`, `env.os`, `env.io` (como no boot original), `env.require` FROZEN
para libs padrão (json.lua usa `require('math')`), `env.package={loaded={}}` +
`env.module` para módulos Lua-5.1, `env.class` com campo `super` para as
classes simples de reporte. `debug._isOpen=true` + `cclog=print` apenas para
 Logging do framework (paths de erro).

## Próximas fatias desta etapa

1. Converter os 140 frames capturados (formato seq/enter/cmdname/result/código)
   em uma lista tipada de eventos (attack/hit/death/buff) e mapear para
   animações do LegacyCharacter — a ponte simulação→apresentação.
2. Sair do espelho: atacante = formação A, defensor = formação B (config ORIGINAL
   npc, formações diferentes),_IDS reais dos personagens (Etapa 4).
3. Nota RNG: gerador semeado nosso; equivalência com o APK não afirmada.
