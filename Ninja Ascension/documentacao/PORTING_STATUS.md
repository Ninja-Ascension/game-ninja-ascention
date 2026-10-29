# Porting status — 18-stage roadmap alignment (audit, 23 October 2026)

The numbered working plan (stages 1–18) is now the single roadmap. This audit
maps the REAL, reproduced state onto it; every claim below was re-executed
today: fresh x64 Debug build, 6/6 automated suite, `probe_compatibility.py`
and the 8 legacy static tests, all green.

## Stage-by-stage real state

- **Etapa 1 (build + batalha local): COMPLETE by automated evidence.** Build
  x64 green; suite cases store-contracts / native-write-restore-reload /
  native-restart-load / battle-smoke exit 0; `LOCAL_BATTLE_SMOKE_PASSED`
  (original damage range via `FightUtil.computeCommonDamage`, victory,
  defeat, restart, return to editor). Turn rules verified by the Lua
  self-test: out-of-turn, duplicate and post-result actions rejected;
  restart reproducible with the seeded generator; offline module allowlist
  rejects unrelated modules. Remaining for full acceptance: HUMAN visual
  review of `battle-active-shot.png` / `battle-shot.png` (screens and logs do
  not certify composition by themselves) and audible audio — both documented
  as pending since the automation round.
- **Etapa 2 (validação visual da cena): PARTIAL.** Maps to the pending human
  review above. Machine-checked size/brightness only. Window resize,
  editor/battle overlap corners and input-capture conflicts not yet verified
  (computer-use helper still unavailable on the bracketed path).
- **Etapa 3 (combate original): SLICE 1 DONE (automated evidence).** The
  ORIGINAL offline simulator now runs end-to-end inside the allowlisted
  sandbox: `BattleReport.lua` loads its full module closure (31 report
  modules + FightModule, 6,585 lines), `BattleReport.initEnvironmentFight`'s
  public sequence executes, and the ORIGINAL `FIGHT_TYPE_PVE_ELIT` branch
  (both sides from original environment_formation/environment_ship data) ran
  **10 real rounds** with determinism asserted across two full runs:
  `LOCAL_BATTLE_REPORT_PASSED OK rounds=10 events=5842 result=0 frames=140
  missing_data_files=13`. Simulation→presentation bridge established: the
  original round frames (historical protocol format) are captured verbatim
  offline (no server) for the animation layer. Full dependency map,
  adapting points and evidence: `port/docs/ETAPA3_COMBATE_ORIGINAL.md`.
  Still pending in this stage: typed event list for the captured frames,
  attack→animation pipeline, non-mirror formation pairings.
- **Etapa 7 (compatibilidade de personagens): STARTED.** Official Spine
  2.1.25 runtime pinned + native polygon adapter runs `spirte_102101`
  through all animations (`SPINE21_ANIMATIONS_VERIFIED`). The full
  compatibility matrix over other skeletons remains to be produced.
- **Etapas 8/13 (telas/menu — progresso dentro da ordem, antecipado):** the
  ORIGINAL boot chain runs end-to-end on Axmol (boot-map), and the original
  `fwin` window system now hosts a live scene with `client.login.logo`
  actually open (`NR_PROBE_TEST_MODE=host`, commit `3b0cbe6`). Both stay
  exploratory (never fold into the suite verdict) until the battle/UI stages
  land. No menu, no login, no servers — by design.
- **Etapa 14 (editor visual): WORKING for the registered tree** (34+ nodes;
  Save/Reload/Restore across restarts, deleted-node and invalid-data
  transactions covered by the suite). New-scene registration still pending.
- **Etapas 4–6, 9–12, 15–18: Etapa 4 STARTED (cut 1–2).** Non-mirror ORIGINAL
  data battles run and playback: attack formation row vs an npc's own wave
  list via the shared `NRBattle.battleNpcId/battleEveNpc` pair (measured:
  formation 3 [2 ships] vs npc 2 [formation 4, 4 ships] → attack side wins in
  4 rounds, `result=1`, deterministic, playback rows match the simulated
  fight). Remaining: npc/formation selection UI, skill VFX mapping, deeper
  per-seat influence effects. **5–6, 9–12, 15–18: PENDING — nothing claimed.**

## Corrections applied by this audit

- The "extern \"C\" awaiting compile/validation" item is CLOSED: the guards
  live in `LocalBattle.cpp` / `LegacyCharacter.cpp`, and every build today
  (including this fresh one) compiles them and the battle/character runs
  exercise them.
- `tools/probe_compatibility.py` no longer prints a frozen production-gate
  string from the pre-toolchain era; it detects the probe executable and
  states the real, evidence-backed gate. `port/data/compatibility_results.json`
  regenerated.
- Alias verified: `subst N:` → `E:\[code]\nk`; working tree was clean at
  `3b0cbe6` before this audit's changes.
- The prompt's "latest build was interrupted / Lua binding errors" state is
  superseded: those binding fixes are in-tree, built and validated repeatedly
  (see KNOWN_ISSUES.md battle-boot entry and TEST_RESULTS.md).

## Next concrete steps (in roadmap order now)

1. Etapa 2: human-eyes acceptance of the two battle shots + resize/overlap
   checks (needs the user's eyes; automation fallback documented).
2. Etapa 3 (next slices): turn the captured original frames into a typed
   event list → attack/hit/death → LegacyCharacter animations; non-mirror
   formation pairing with the original npc table.
3. Etapa 7: expand the character matrix from the sprite inventory.

Older historical entries are preserved below, newest-first.

--- Historical (superseded entries kept for provenance) ---

Newest update (23 October): original `spirte_102101` now has a native animation preview using the unchanged official Spine 2.1.25 runtime, pinned at `142e770e5b4b42395a3a0a68ff3c8a21ba2774eb`. The earlier Cocos 3.5 parser failure is superseded by a separate compatible adapter, not an asset conversion. Character controls select animation, pause, restart and speed. `probe.character` transforms join the persistent layout registry (34 nodes). Gameplay and visual fidelity acceptance remain pending. See PREVIA_PERSONAGEM.md; older entries below describe historical stages.

Current update (23 October): Inspector now has a companion **Ajustes do layout** panel with Save/Reload/Restore and persistent local JSON. Audio no longer triggers on every mouse click; use its explicit button or A. Preview is paused initially for editing without pausing Inspector. Native tests confirmed profile roundtrip across process restart, text/flip properties, logo recreation, deleted-node recovery, invalid-data transactions and no mouse-audio request. Original static tests still pass. Current executable is built, open and responsive. See USAR_EDITOR_DE_LAYOUT.md and newest TEST_RESULTS.md section. Spine/combat remain pending; full game parity is not claimed.

Latest Inspector update (23 October): ImGui/Inspector now enabled, built and running. Corrected invalid shutdown-call placement in user edits, added editor-input capture guards and native frame diagnostics. Native log confirms Inspector attachment and nonzero ImGui frame output. Overrides/Save functionality and Spine animation remain pending. See TEST_RESULTS.md. No original game files modified.

## Latest follow-up

### Phase 1a CLOSED: the network protocol is fully reconstructed from recovered code

- payload at the APPLICATION layer is PLAIN TEXT: tokens separated by CRLF
  and spaces (`data.resouce_serializer`, NetworkAdaptor.lua:573-576); the
  request text comes from `NetworkProtocol.command_func(command, data)`
- transport: `cc.DBytes:new(text)` → `cc.deflateMemory` (zlib) →
  `blowfish:encrypt` (round trip on receive: blowfish:decrypt →
  `cc.inflateMemory`, NetworkAdaptor.lua:544-572)
- Blowfish key literal in the recovered code: app.lua:174 —
  `app.blowfish:setKey("K(7a!ykjTD&DAp0!")` (16 bytes) — wrapper at
  frameworks/external/blowfish/blowfish.lua registers `cc.CBlowFish`
- `cc.DBytes` disassembly proof: it is ONLY a byte-transport wrapper over
  `cocos2d::Data` (getBytes → pointer+size; `Data::encrypt` is a 2-byte
  stub) — not a cipher
- community history matters: build-era patches marked "Fury" (per-device
  header `X-Fury-Device`, token from S2C 327) prove the recovered build ran
  on a COMMUNITY server after the official shutdown; four protocol copies
  exist in the archive: `client/protocol/ProtocolCommanderCopy{,Ex,Exx,Exxx}.lua`
- native layer not stripped: 26.849 defined dynamic symbols; CBlowFish
  implementation + S-boxes in-binary; inflateMemoryWithHint (ZipUtils),
  cocos2d::network HttpClient family present — phase 1b will locate the
  custom Lua bindings (`cc.XMLHttpRequest`, `cc.inflateMemory`,
  register_dbytes-style small registrars) and reimplement the natives for
  Axmol on Windows (deflate via bundled zlib, Blowfish standard algorithm
  with binary-faithful S-boxes, DBytes wrapper, XHR via axmol HttpClient)

### Corte 6b CLOSED: the offline START wall is characterized end-to-end (commits 30d6fff..ba25df6)

START on the original login now runs the ORIGINAL chain and every link is
proven with recovered code:

- click → `login_get_server_list` (login.lua:342-343): registers
  `new_get_server_list` and sends; schedule 11/12 markers show the original
  retry choreography (`DEL script schedule 11`, `ADD script schedule 12`);
- the offline fence (boot stage 3b) marks the send the original way
  (`error_code=-5`, `dataState=ERROR`) — identical state to a live server
  answering HTTP 404/500 (NetworkAdaptor.lua:533);
- network views registered verbatim (stage 3c = logo.lua:28-41 incl.
  `NetworkView:register(ConnectingView,nil,NetworkErrorDialog,ProtocolErrorDialog)`),
  so the pump's error path actually runs (NetworkManager.lua:287-291);
- diagnostics (stage 3d, `HOST_NETVIEW` wrappers; census v4 scanning
  `fwin._list` + all 13 containers) proved the pump calls
  `networkErrorViewDisplay` repeatedly and `poll()` DRAINS the queue each
  time (NetworkManager.lua:66-79), the original handler no-ops on the
  RESPONSE_SUCCESS guard (login.lua:257), and the dialog IS alive
  (`HOST_WINDOW_CENSUS live LoginClass,NetworkErrorDialogClass,...`);
- **the dialog is invisible because the recovered SOURCE of
  `client/network/NetworkErrorDialog.lua` is a 14-line skeleton** — no CSB,
  no nodes: the original developer never implemented its body. Nothing to
  render short of fabricating content.

Stable offline state (faithful): login window stays up, ghost open/close of
the empty dialog while the login retries the server-list request. The only
honest ways past this wall: a real server responding (out of scope: no
protocol responses in the recovered assets; faking is forbidden) or the
`libjts.so` native-protocol reverse-engineering + localhost server project
(user decision pending).

### Pure game mode (commit 14011f7)

Double-click boots ONLY the game: empty host scene + presenter-tick chain
(boot@1 logo@3 check@4). The lab bench (layout editor, character preview,
battle shell, inspector, panels, keys, audio test) exists solely behind
`NR_PROBE_PROBE_UI=1` / `NR_PROBE_TEST_MODE` (suite still 6/6 there). GL
warm-up lesson recorded: without pre-loop primitives the original app.init
fails `3.app_create` with "Shader compile failed" (app.lua:402, cold
ANGLE/D3D11 context inside the first ImGui tick). Census v3/v4 lessons
recorded: fwin containers are tables `{_layer,_z}` (fwin.lua:14);
`fwin:open` respects the window's own `_view` (fwin.lua:409).

### GAME MODE reaches the ORIGINAL login window automatically (commit 94926b2)

`powershell -ExecutionPolicy Bypass -File tools\run_game.ps1` now produces, in
one window and without any click:

- the full original boot (stages 0→6 all OK; the fence active; new stage 5b
  loads the ORIGINAL `client.loader.LocalDatas` — the login ctor needs its
  global `addErrorInfor`, login.lua:178);
- the Logo window (fwin scene, `logo_children=1`);
- at +4s the ORIGINAL Login window open (`HOST_LOGIN_OPENED login=true`),
  with its recovered art (`jinruyouxi.png`, `dljm_16.png`, `btn-middle-red.png`)
  resident;
- zero ImGui assertions (the chain rides the presenter tick: boot@tick1,
  logo@tick3; the scene-scheduler variant asserts mid-frame and is abandoned);
- schedule stacking fixed (`nrgate` guards, one-shot recheck, `ipairs` census).

Next wall (documented, still loud): the login screen's own server/connect step
lands on the offline fence — the game's dialogs handle it; per-screen reach
from here is the cut 6/7 work (server list → menu load-only → original-scene
battles).

### GAME MODE: single command boots the ORIGINAL chain directly (Etapa 6 cut 5)

Run it from the repo root (`E:\[code]\nk`, alias N:):

```
powershell -ExecutionPolicy Bypass -File tools\run_game.ps1
```

(builds the exe, recreates res/src junctions if a reboot removed them, then
launches the game host with `NR_PROBE_AUTO_REAL_CHAIN=1` — the probe boots the
ORIGINAL chain automatically: boot_map (0..6) -> fwin scene swap -> Logo window
-> (4s) Login window; no test panel exists in this mode. `-NoBuild` skips the
compile step; plain double-click keeps the optional "Telas reais" panel.)

The offline behavior inside this mode: every network request lands on the send
fence and surfaces through the game's own error dialogs; missing recovered
art/scripts fail loudly with documented names; native-crypto bindings fail
loud. Nothing online is faked.

### Where the real-screen testing goes next (aligned with the 18-stage plan)

- cut 6: offline login continuation — server list / login response paths from
  recovered data only (no synthesized servers); connecting dialogs part of the
  game's own UX.
- cut 7: menu/mission screens load-only via the original window system; census
  markers name the next missing pieces.
- cut 8: battles THROUGH the original scenes (landscape controllers
  FightRoleController et al.) — presentation fidelity gate; the battle sandbox
  (simulator + full-cast replay + skill stamps) remains the automated harness
  (suite: `python tools\test_layout_editor.py` via N:).
- Standing boundaries: visual/audio validation is human-only (rule 12);
  recovered-asset gaps stay loud; no original file is edited — every adapter
  lives in port/.

### Earlier follow-up (now superseded in part by GAME MODE)

### Etapa 6 STARTED (out of order, user choice): the REAL boot chain under a live host

Status as of `0fd711f`+ (runs `layout-tests-f6d46c9f/ea544902…`):

- Full ORIGINAL boot chain passes in the probe: cocos.init, frameworks/app.lua,
  `app.create()` (original app.init: config, aes/blowfish utils, network
  modules, NetworkAdaptor.init, lua_bridge, state_machine, notification
  center, fwin window system), `client.launch`, and load of
  `client.login.logo` — all via the NR_PROBE_BOOT_MAP chain (boot_map.lua).
- M2 host milestone reached: `fwin:create()`+`fwin:graphics(nil)` REPLACES the
  probe scene with the original fwin scene; `HOST_LOGO_RECHECK
  running_is_fwin=true` (director-level recheck 1s later; the in-frame check
  was a false negative by construction).
- Original Logo window opens and attaches; a lifecycle adapter fires the
  window's OWN `onEnterTransitionFinish` once (axmol never emits it for a
  plain replaceScene) and the logo's original content builder ran without
  error: `logo_children=1`.
- Honest limits: engine gap shims remain (CBlowFish fails loudly, socketevent
  inert, GLProgramCache nil) — see boot_map.lua 0c stage; login art partially
  absent from the recovered APK (`images/ui/login/button_gongguang.png`,
  `fangchenmi.png` missing — documented, not fabricated); NO visual validation
  claimed (rule 12): pixel metrics (tools/frame_metrics.py) are technical
  diagnostics only. `socket/core.lua` absent — network stays inert offline.
- Next: fire the logo timeline to its `open`/`exit` frame events
  (logo.lua:211-213) to reach `logo_activate_app` state machine transitions,
  then the login window — each original handler expected to surface the next
  offline boundary (login server URL etc.) as a loud, documented failure.

Toolchain blockers resolved earlier: VS2026/MSVC, Windows SDK and CMake installed. Official axslcc and pinned engine dependencies prepared in build/. Script now chooses VS2022/2026 automatically. A temporary N: mapping avoids bracket globbing without renaming/moving files. Native parser comparison now runs and fails on original flipX timelines, narrowing the animation adapter requirement. See TEST_RESULTS.md for real outputs and the Debug CRT warning.

## Previous checkpoint (historical)

New/updated work in this follow-up: port/CMakeLists.txt, native/ResourceProbe.cpp, legacy parser test source/CMake, tools/build_windows.ps1, tools/prepare_probe_dependencies.ps1, tools/probe_compatibility.py, generated compatibility_results.json, and port/docs. No original game files changed.

Next: manually inspect the open probe (A/click audio, Space pause, R timeline), align Debug/prebuilt CRT settings, and implement a compatible legacy animation adapter preserving flipX/weighted mesh/events. Combat remains outside this iteration.

## Previous checkpoint (historical)

**Production compatibility gate: blocked. No playable executable produced.**

Completed:

- Read prior audit in full. Originals untouched; no gameplay scripts migrated.
- Downloaded and pinned Axmol 2.11.5 and Cocos2d-x 3.5 reference; inspected Lua, CSB, Spine, build and license sources.
- Resolved project 27 to l_naruto default configuration; avoided original network-enabled startup.
- Implemented read-only sample selection, provenance hashes, original CSB re-decoding/comparison, atlas/font-page checks and eight automated regressions.
- Added native diagnostic source/CMake, narrow Lua aliases and dms_load contract, reference search paths, desktop persistent log, original CSB/timeline/font/atlas texture paths, input and audio request path.
- Build script attempted configuration and reported missing CMake explicitly.

In progress / blocked:

- Original Spine 2.1.27 animation cannot run on built-in Axmol Spine 4.2. Weighted meshes/FFD preclude changing version strings as a fix.
- CMake, MSVC and Windows SDK are unavailable in inspected environment. C++/Lua diagnostic source has not compiled or executed. Python tests do not validate C++.
- Selected original login layout has three unresolved references; preserve and investigate atlas/localization/path resolution rather than delete widgets.
- Desktop LuaJIT ABI and RNG behavior need executable tests.

New files: port/CMakeLists.txt; port/native/ResourceProbe.cpp; port/lua/compatibility.lua; port/tests/test_compatibility.py; port/data/samples.json and compatibility_results.json; six port/docs documents; tools/probe_compatibility.py, build_windows.ps1 and fetch_engines.ps1; root .gitignore. Original audit outputs unchanged.

No full production port initialized. The native code is an isolated resource probe that visibly labels character animation as blocked and displays only an atlas texture; this must never be counted as a working animated character. All runtime status remains unverified until actual execution.

Next milestone remains M1: install toolchain, compile/run resource probe and minimal legacy parser comparison, resolve selected layout dependencies, then implement/validate a licensed Spine 2.1 adapter. Only after original UI + animated character + audible audio pass should M2 combat integration begin.
