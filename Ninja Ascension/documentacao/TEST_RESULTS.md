# Actual results — 22 October 2026

## Original battle simulator runs end-to-end offline (Etapa 3 slice 1) — 23 October 2026

The sandbox in `port/lua/local_battle.lua` now runs the ORIGINAL
`BattleReport.initEnvironmentFight` pipeline headlessly (gated by
`NR_PROBE_BATTLE_REPORT=1`, set by the suite before the battle case). Iterative
loud-failure closure — every dependency joined the explicit allowlist by its
real name, the JSON codec is the ORIGINAL `cocos/cocos2d/json.lua` (loaded in
the engine scope, Lua-5.1 `module()` semantics, bridged as a global), and the
simulator's protocol frames are captured VERBATIM offline through the
`NetworkProtocol.parser_func` adaptation point (no server, nothing invented).
The original `FIGHT_TYPE_PVE_ELIT` data-driven branch (both sides from
ORIGINAL environment_formation/environment_ship rows, npc 1 mirror) executes
`initBattleField → initFightOrder → rountdFight` loop. Validated run
`build/layout-tests-a82222007e93412eb0f09f6c56e33ac6/`:
**all 6 suite cases exit 0** and

```
LOCAL_BATTLE_REPORT_PASSED OK rounds=10 events=5842 result=0 frames=140 missing_data_files=13
LOCAL_BATTLE_SMOKE_PASSED: original damage, victory, defeat, restart, editor return
```

- Determinism asserted: two fresh full runs keep equal roundCount, buffer
  size and fightResult (seeded LCG still replaces only `math.random`).
- 13/336 data files from the original `data_path_config` are absent in the
  recovered APK; each is logged by name (`BATTLE_REPORT_DATA_MISS`) and
  registered as an empty dms entry, so any real access fails loudly.
- The player-formation branch (`_ED.formetion`) is the account-data boundary
  and stays out of scope; documentation: `port/docs/ETAPA3_COMBATE_ORIGINAL.md`.

Not claimed: visual validation of the battle (Etapa 2 human-eyes item), no
menu/login, RNG parity with the APK not asserted.

## All probe writes moved off C: into the workspace — 23 October 2026

User policy: nothing is stored on the C: drive. `ResourceProbe.cpp` now derives
the writable path from `NR_ROOT` (`E:\[code]\nk\build\probe-writable\",
gitignored) instead of `%LOCALAPPDATA%`, redirectable with `NR_PROBE_WRITABLE`;
the layout editor default JSON rides on the same path. The old
`%LOCALAPPDATA%\NinjaRevolutionProbe` was migrated (resource-probe.log,
UserDefault.bin, layout_overrides.json → verified present on E:) and deleted;
after full rebuild + suite it does NOT reappear (verified false-positive-free:
`OLD-AFTER-RUNS-ABSENT: true`), suite 5/5 green and boot-map markers unchanged
(run `build/layout-tests-15137421f0d64deda0f3911b8f2503b7/`). Live docs that
cited the old path were updated (BUILD_WINDOWS, GUIA_AXMOL_2,
USAR_EDITOR_DE_LAYOUT).

## Original boot chain runs end-to-end on Axmol (boot-map) — 23 October 2026

`tools/test_layout_editor.py` gained an exploratory fifth case,
`boot-map-analysis` (`NR_PROBE_BOOT_MAP=1` on the battle mode): it executes the
ORIGINAL game boot chain stage by stage (`port/lua/boot_map.lua`) and never
folds into the suite verdict. Validated run
`build/layout-tests-3a3054ab08854aa28ef6eabec0c32dce/`: all four standard
cases still exit 0 AND the boot map reached `BOOT_MAP_END` with every stage OK
— `3.app_create` (the full original `app.init()`), `4.client_launch` and
`5.logo_load_only` (client.login.logo loads; opening it needs the probe scene
to become a fwin host — next milestone). Six documented engine-gap shims were
needed (`Director.getOpenGLView`, PVR flag, display stats, `CBlowFish`,
`socketevent`, `GLProgramCache`) plus two infrastructure fixes: builtin shader
cards (`axslc`) must survive `setSearchPaths` replacements (native assert
otherwise; `ResourceProbe.cpp` + stage 6 re-add the directory) and the original
layout junctions (`res`, `src` next to the exe) make `app.init`'s relative
search paths resolve. Full analysis, gaps and repro steps:
`port/docs/BOOT_ANALYSIS.md`.

## Original logo window opens for real (fwin host) — 23 October 2026

The milestone after the boot-map: make the ORIGINAL `fwin` window system host a
live scene so `client.login.logo` actually renders. New sixth exploratory case
`logo-host` (`NR_PROBE_TEST_MODE=host`, requires `NR_PROBE_BOOT_MAP=1`): the
probe now accepts the `host` mode, executes `port/lua/host_logo.lua` and then
captures `logo-host-shot.png` on the DIRECTOR scheduler (the probe scene stops
ticking after the swap, so scene-level `scheduleOnce` chains would never fire).
Validated run `build/layout-tests-cc8291ec6f294a7e9a551f44acd7ed42/`: all five
standard cases still exit 0 and the host chain reports
`HOST_LOGO_SCRIPT_OK` / `HOST_LOGO_RESULT true` — window instance is a real
tolua userdata attached under `fwin._screen` (children 1), shot 960x640 saved.
Mechanics proven (details in `port/docs/BOOT_ANALYSIS.md`):
- `fwin:graphics(nil)` creates the original game scene and replaces the probe
  scene; `fwin:create()` is required first because the frame built inside
  `app.init` died together with the dormant boot scene (tolua objects freed).
- `app.load("client.login.logo")` returns an INSTANCE (module ends
  `return Logo:new()`); after the frame death the cached instance is dead, so
  the host rebuilds it via the same `Logo:new()` and runs the original
  `fwin:open(window, fwin._screen)` from `client/launch.lua`.
- Known offline noise from the ORIGINAL network schedule
  (`NetworkAdaptor.lua:544`): the HTTP send path needs `cc.DBytes` (native
  buffer class only in the original libjts; axmol does not export it), so the
  frame-tick request producer errors per frame — loud, honest, inert.

## Editor/battle automation round with native screenshots — 23 October 2026

Follow-up (same day): the battle case now saves two frames — the live battle
scene while the battle is active (new `LocalBattle::enterForCapture()`, turn-1
state, `battle-active-shot.png`: 960x640, 100% non-black, mean gray ~125 — a
full lit scene, unlike the dark editor shots at ~26) and the post-smoke frame
(`battle-shot.png`). Validated set:
`build/layout-tests-cb80f0edaff5456c8b50e6b6b0320cf3/` (4/4 green). The LNK4098
Debug CRT warning is resolved: the probe now links with `/NODEFAULTLIB:MSVCRT`
(`port/CMakeLists.txt`); the proof is a rebuilt binary with no LNK lines and a
green suite. One flake recorded: a leftover probe process held the old exe
(LNK1168); killing the stale PID and rebuilding was enough.

`tools/test_layout_editor.py` now runs a fourth case, `battle-smoke`
(`NR_PROBE_TEST_MODE=battle`): Lua selfTest, original damage (asserted 95-105),
victory, defeat and restart all pass — `LOCAL_BATTLE_SMOKE_PASSED: original
damage, victory, defeat, restart, editor return` in
`build/layout-tests-4f908970411a49dba28a53cd797a8862/`. The allowlist needed no
further modules beyond the already wired `client.battle.report.RestrainObject`.

Test runs now save a rendered frame per process through the new `NR_PROBE_SHOT`
env (`write/read/battle-shot.png`): `ResourceProbe.cpp` schedules
`ax::utils::captureScreen` after the smoke result, verifies the save and fails
visibly (exit 3 = shot timed out/captured/failed to save) instead of finishing
silently. First validated set:
`build/layout-tests-ebc32c37354343bdbe767aeaf37bc413/` — all four cases exit 0.
Static verification (stdlib PNG decode, no model image input in this harness):
anchors 960x640, ~37-38% non-black, mean gray ~26 — real rendered content, not
blank frames; on-screen composition still needs human eyes and the files were
delivered in-session for review.

`port/resources` override search path is active (`FileUtils::setSearchPaths`
places it before the original asset set) — `port/resources/README.md` documents
the rules (never touch the original trees; copy preserving hierarchy; delete
the copy to revert). Precedence is now proven at runtime: a byte-identical copy
of `images/ui/login/fb_icon.png` (469 B, SHA-256 equal) resolves from
`port/resources` in all three probe processes — `OVERRIDE_RESOLVE
images/ui/login/fb_icon.png -> E:/[code]/nk/port/resources/images/ui/login/fb_icon.png`
in `build/layout-tests-418fba4f1eda4fedb98f1e4d3b86d677/` (4/4 green, shots
saved). Sandbox note: the `port/` subtree and `.git` predate the workspace
provisioning, so the confined token lacks the sandbox grant there (repairs
granted the signed-in user verified full control; reports under
`E:\[code]\dsh-acl-reports\`) — commands that write there (git, binary asset
copies) run outside the sandbox; text edits through the harness file backend
are unaffected.

Git: first full checkpoint `1f496be "Test offline battle slice and repair its
Lua boot"` on `master` (previous head `a93d886` predates the battle slice).
`.gitignore` skips the regenerable reference trees (APK, jadx output, decoded
assets, decompiled Java, ~1 GB of extracted CSB JSON, jadx tooling) and tracks
`04_indices` and `06_auditoria`. Caveat: `.git` carries foreign deny entries and
an inheritance-protected DACL; the authorized ACL repair granted the signed-in
user full control (verified) but the sandboxed token still cannot create files
inside `.git`, so git commands currently run outside the sandbox in single
justified calls. Host alert recorded: drive `C:` had under 10 MB free during
this round (harness temp writes hit ENOSPC); the project on `E:` (165 GB free)
was unaffected, but freeing `C:` is the user's pending action.

## Battle Lua boot repair — 23 October 2026

The probe executable was found missing from
`build/windows-probe-native/bin/NinjaResourceProbe/Debug/` (PDB/LIB/EXP and
intermediates remained). Rebuilding with `tools/build_windows.ps1 -SourceRoot N:/`
exposed that the local-battle integration saved at 01:31–01:33 on 23 October
(`local_battle.lua`, `LegacyCharacter.*`, `LocalBattle.h`, `ResourceProbe.cpp`
at 01:33:04, `LocalBattle.cpp` at 01:33:54) had never been compiled or tested:
the last green integration run used an earlier `RESOURCE_PROBE_STARTED` text
(`Spine21 character adapter active` versus the current `offline battle available`).
First real run: `store-contracts` exit 0, but the application died during boot
after `LAYOUT Carregado` with `[LUA ERROR] client/battle/report/BattleObject.lua:363:
attempt to index global 'RestrainObject' (a nil value)`, no `BOOT_FAILED`, exit
code 0xE24C4A02.

Root causes and minimal fixes (originals untouched; changes only under `port/`):

- `local_battle.lua` never loaded `client.battle.report.RestrainObject`, although
  BattleObject's ctor (lines 5-712) uses it at line 363; the original loads it
  through `BattleReport.lua` (line 6). Added to the allowlist and loaded before
  `BattleObject`. `RestrainObject:ctor` is self-contained and the ctor has no
  other module dependencies (first `zstring`/`ConfigDB`/`FightBuff` use is at
  line 930 or later).
- `LuaStack::executeScriptFile()` returns 0 both for success-without-return and
  for errors (`[LUA ERROR]` then `return 0`), so the probe's `!= 0` boot checks
  were blind to Lua failures. `compatibility.lua` and `local_battle.lua` now end
  with an explicit `return 1` (local_battle also asserts a working
  `NRBattle.dispatch('snapshot')` before returning), and `ResourceProbe.cpp`
  requires `== 1`, so any future Lua boot failure reports `BOOT_FAILED` and
  exits cleanly instead of leaving a half-initialized scene.

Validation (Debug x64, VS2026/MSVC 19.51):
`cmake --build N:/build/windows-probe-native --config Debug --target
NinjaResourceProbe LayoutOverridesTests --parallel 4` then
`python tools/test_layout_editor.py` →
`build/layout-tests-710409c12c00417b86b4230218dfc968/results.json`: all three
runs exit 0 with `INSPECTOR_ATTACHED`, `RESOURCE_PROBE_STARTED; offline battle
available; original full gameplay parity pending`, `LAYOUT_EDITOR_PANEL_READY
nodes=34`, `MOUSE_AUDIO_REGRESSION_PASSED`, `LAYOUT_SMOKE_WRITE_PASSED`,
`LAYOUT_SMOKE_READ_PASSED` across both restarts and `PROBE_EXIT`. The user's
LOCALAPPDATA layout profile was untouched (tests use isolated
`NR_PROBE_LAYOUT_FILE` paths).

Environment notes: this session's sandbox initially could not provision write
access to the workspace root (Win32 error 5 granting `E:\[code]\nk`; build
writes always travel through the SUBST alias `N:`). Repaired once with the ACL
diagnostic script (full-control entry for the signed-in user at the workspace
root; backup and rollback command in `E:\[code]\dsh-acl-reports`). Confined
commands work again, but build/test commands still ran outside the sandbox
because of the alias and the documented piped-spawn boundary.

Still open: `NR_PROBE_TEST_MODE=battle` (Lua selfTest, victory/defeat paths,
FightUtil damage compute) has no automated run yet; the LNK4098 Debug CRT
warning remains; audible playback, visual parity and computer-use verification
remain unverified; this folder still has no Git repository, so these edits have
no versioned checkpoint.

## Original character adapter — 23 October 2026

Final native build: exit 0, existing LNK4098 warning remains. Official unchanged
Spine 2.1.25 (`142e770e5b4b42395a3a0a68ff3c8a21ba2774eb`) parser test:
`ctest --test-dir N:/build/spine21-parser -C Debug --output-on-failure`, 1/1 passed.
This is separate from the deliberately retained failing Cocos 3.5 comparison.

Final native integration results:
`build/layout-tests-b2b08d44c3174be99da61c0458ef2b34/results.json`.
Store contracts, native write/restore/reload and restart/read all exited 0.
Both native application runs load three original atlas pages, sample 121 times
across each of 15 animations, reject nonfinite geometry or invalid mesh indices,
and assert that nonempty geometry exists and its vertex signature changes.
They also run the existing mouse/audio and layout recovery regressions.
Registered editable nodes now total 34, adding `probe.character` without
renaming or removing any previous profile IDs. The final native runs used
temporary test profiles, preserving the user's LOCALAPPDATA layout.

Original compatibility/hash tests: 8/8 passed. No original asset or engine
source changed. New runtime source checkout is ignored under `build/deps` and
reproducible with the pinned `tools/fetch_engines.ps1` entry.

Limits: sampling is not exhaustive correctness proof; geometry assertions do
not verify displayed pixel fidelity. No automated screenshot or real GUI input
verification was possible with the unavailable computer-use helper. Animation
events are not connected to gameplay or audio. See PREVIA_PERSONAGEM.md.

## Layout editor and persistence — 23 October 2026

Implemented nr_layout (strict JSON + Windows atomic replacement), LayoutEditor (33 stable registered nodes for current samples), explicit Salvar ajustes/Recarregar/Restaurar iniciais controls and default versioned profile. Node properties, label text and sprite flips persist in a separate LOCALAPPDATA JSON. Original resources and engine sources remain unchanged. Removed the global click-to-audio listener; audio is now an explicit button/A action. Preview pause affects the logo ActionTimeline rather than the Director, keeping the editor live.

Final native build completed with exit 0. An intermediate post-build DLL copy failed when tests started before staging finished; build and tests were rerun sequentially and succeeded. Existing Debug LNK4098 warning remains.

Final test evidence: `build/layout-tests-ff33dbba745e4a75952bcebd4289dcfe/results.json`:

| Test | Actual result |
|---|---|
| LayoutOverridesTests native store contracts | Exit 0: roundtrip (all property types), replacement, nonfinite rejection, malformed JSON, schema/scene mismatch, duplicate key, invalid type and failed replacement against directory |
| Real application write/restore/reload | Exit 0: changed position/text/flip/logo, saved atomic JSON, restored baseline, reloaded saved values, rejected unknown IDs before mutation |
| Inspector Delete lifecycle | Save rejected removed registered node; previous file remained intact; restore/reload recovered it; strong references avoid freed pointers |
| Second application process | Exit 0: saved position, text, flip and logo state recovered; logo deletion/recreation and preview toggles preserved overrides |
| Mouse regression, both processes | `MOUSE_AUDIO_REGRESSION_PASSED`: synthetic Axmol mouse event did not request audio |
| Original static suite | 8/8 passed, 0.850 s reported |
| Normal-profile launch | Open and responsive; `LAYOUT_EDITOR_PANEL_READY nodes=33`, `INSPECTOR_FRAME_CHECK windows=4 vertices=1662` |

Tests use unique build/layout-tests-<id> directories through NR_PROBE_LAYOUT_FILE. They do not overwrite the user's local profile. Native test modes exercise the same save/reload/restore functions used by the UI; OS-level button clicking and audible playback are not independently verified by these tests. The external computer-use helper limitation remains. The normal application was left open with preview paused and no pending test modifications.

## Inspector integration — 23 October 2026

User changes enabled ImGui/Inspector and attached the Inspector, but a standalone `Inspector::destroyInstance()` line was placed between methods without a semicolon. Moved the fully qualified call into applicationWillQuit. Kept the user's CMake enablement and scene attachment. Added ImGui mouse/keyboard capture checks so editor input is not dispatched to the scene controls.

Executed `tools/build_windows.ps1 -SourceRoot N:/`: configure/build/link exit 0, ImGui.lib and Inspector.lib produced. Launched the updated executable and checked the responsive process/window. Runtime log:

```text
CSB_NODE_CREATED (visual fidelity not certified)
TIMELINE_STARTED
INSPECTOR_ATTACHED font=fonts/FZYiHei.ttf
RESOURCE_PROBE_STARTED; character animation unresolved; production gate remains blocked
INSPECTOR_FRAME_CHECK windows=3 vertices=52
```

This confirms attachment and ImGui frame output. It is not a screenshot-based acceptance test or proof of saved edits. The prior LNK4098 Debug CRT warning remains. Visual input automation has not been recovered in this bracketed workspace. Persistence is not implemented; original assets and engine sources remain untouched. Logs for this run: build/inspector-build.log and build/inspector-run.stdout.log / inspector-run.stderr.log, plus the normal LOCALAPPDATA log. The new application was left open.

## Latest native build/run follow-up

The previous missing-toolchain blocker is resolved. Detected VS Community 2026 18.11.12315.225, MSVC 19.51.36260.0 x64, Windows SDK 10.0.26100.0, CMake 4.5.0-rc1 and Git 2.56.0.windows.2. Ninja and system Lua are unnecessary for this Visual Studio/LuaJIT target.

| Verification | Actual outcome |
|---|---|
| Updated build script `-SourceRoot N:/ -ConfigureOnly` | Passed with VS2026 auto-detection |
| Axmol Debug native build/link | Passed, exit 0 |
| Executable | `build/windows-probe-native/bin/NinjaResourceProbe/Debug/NinjaResourceProbe.exe`, 42,802,688 bytes; PE machine 0x8664 (AMD64) |
| Real executable launch | Running, title `Ninja Revolution - M1 resource probe`, Responding=True at final check |
| Embedded Lua compatibility contract | Script executed without error before scene creation; version/JIT/config/missing-file assertions did not abort |
| Original login CSB | Native log: `CSB_NODE_CREATED (visual fidelity not certified)` |
| Original logo timeline | Native log: `TIMELINE_STARTED` |
| Scene startup | Native log: `RESOURCE_PROBE_STARTED; character animation unresolved; production gate remains blocked` |
| Audio backend | No lazyInit-failure entry; audible playback NOT verified; A/click remains manual |
| Original character animation | Not supported yet; displayed atlas is explicitly static |
| Legacy parser x64 build | Passed |
| Legacy parser test | FAILED: `Invalid timeline type for a bone: flipX`; original atlas's three PNG pages loaded |
| Python regression suite | 8/8 passed on rerun, 1.207 s reported |
| Visual capture/input automation | Helper failed to initialize: filesystem glob path E:\[code]\nk only supports deny access. No screenshot or input-based acceptance claimed |

Latest logs: `build/windows-probe-build.log`, `build/windows-probe-configure.log`, `build/windows-probe-run.stdout.log`, `build/windows-probe-run.stderr.log`, `%LOCALAPPDATA%/NinjaRevolutionProbe/resource-probe.log`; legacy CTest log under `build/legacy-parser-native/Testing/Temporary/LastTest.log`. The application remains open for manual testing.

Fixes validated by actual build: Visual Studio generator detection, bracket-free SUBST source alias, pinned axslcc dependency setup, consistent plain target_link_libraries signature with engine helpers, lvalue GfxContextAttrs argument, console entry-point setting, and required particle3d/assets-manager implementations referenced by the pinned Lua registrars. No engine source files or original game assets/scripts changed. Unused WebView2 is disabled, avoiding an unnecessary NuGet dependency.

Open warning: Debug link emits LNK4098 (MSVCRT runtime conflict with imported prebuilt dependencies). Launch succeeds, but runtime/allocator alignment still needs validation before considering the build stable. Missing optional Unix audio backends, NASM and PkgConfig were nonfatal on this Windows/prebuilt configuration.

## Previous checkpoint (historical)

Python used: bundled Codex primary runtime Python executable under the user's .cache/codex-runtimes. Tests run against original extracted files and pinned downloaded engine sources.

| Command/check | Actual result |
|---|---|
| git clone Axmol v2.11.5 + rev-parse | Completed, commit 6c0dce6db4660feafe29dabb1ab3506ee76b0931 |
| git clone Cocos2d-x cocos2d-x-3.5 | Completed, commit f7e11a2467e4508738ad9cf4b3992da05f9d1e7c |
| python tools/probe_compatibility.py | Exit 0 after fixing legacy font metadata decoding; manifests generated |
| python port/tests/test_compatibility.py | 8/8 passed, 0.288 seconds reported |
| tools/build_windows.ps1 -ConfigureOnly | Exit 1: missing CMake; did not reach compiler detection or compilation |
| Native build/link/window/CSB GPU render | NOT RUN |
| Embedded Lua compatibility.lua assertions | NOT RUN (no Lua runtime binary available) |
| Original animated character | NOT RUN; known incompatible with built-in Spine 4.2 |
| Audible MP3 output | NOT RUN |
| Legacy parser native comparison | Source inspected only; NOT COMPILED |
| Combat / server / save tests | Out of scope M0/M1; NOT RUN |

Eight automated cases: engine pin; original CSB binary re-decoding equals previous structural JSON; incompatible Spine remains explicitly rejected; legacy old-format parser markers; selected sample source hashes; project 27 maps to l_naruto; selected animation name exists; original resolution/policy/60 FPS configuration.

The toolchain preflight and source/version checks are real results. They are not substitutes for native runtime validation. No executable produced. No historical endpoints contacted. The first sandboxed Git attempt failed due to proxy connectivity; permitted direct download succeeded, so engine source availability is resolved.
