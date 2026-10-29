# Original boot analysis (M2 preparation) — 23 October 2026

Purpose: map how the ORIGINAL game boots so the probe can eventually run it on
Axmol instead of loading isolated pieces. Findings come from reading the files
listed at the end; nothing in this document modifies original content, and no
new game art/data was created (per project scope: only what the reference list
requires). A prepared experiment (not yet executed — needs an approved build/
test batch) will confirm the static conclusions empirically.

## Entry chain (static reading)

```
main.lua                         (130 lines — see note below)
  1) FileUtils:addSearchPath("src"), addSearchPath("res")   (relative paths)
  2) require "cocos.init"
       src/cocos/init.lua (65 lines) requires 38 framework files shipped IN the
       APK under src/cocos/** (Cocos2d, constants, extern, bitExtend,
       DrawPrimitives, Opengl(+Constants), cocosbuilder, AudioEngine, CocoStudio,
       ui GuiConstants/experimentalUIConstants, ExtensionConstants,
       NetworkConstants, SpineConstants; + Deprecated* only if
       CC_USE_DEPRECATED_API). The json codec is src/cocos/cocos2d/json.lua.
  3) require("frameworks.app") -> table `app`; _app.create() -> app.create()
       xpcall(app.init) — fatal on failure (original behavior).
  4) app.init() (apps/app.lua lines 49-370):
       - cc.dms_load("configs/app.config")  (JSON v1.417, 640x960, fps 25,
         MultiLanguage, patch/update URLs) — file exists under assets/res.
       - setSearchPaths rebuilt from patch_path + config searchPaths
         (res, src, src/frameworks/external, aeslua, src/config) — RELATIVE.
       - loads external libs: aeslua, blowfish (key "K(7a!ykjTD&DAp0!"), utils,
         utf8, AudioUtil.
       - optional cc.JtsThreadHelper (nil-guarded — safe if missing on Axmol).
       - Director/GUI setup; GLView NOT recreated when one exists (the probe
         already created one before scripts run — good).
       - support libs: support/init, support/debug, support/cocostudio,
         external/utils (local_datas, module_datas, utils, string),
       - NETWORK stack loaded UNCONDITIONALLY: NetworkAdaptor, NetworkManager,
         NetworkProtocol, NetworkView, NetworkAdaptor:init() — modules load,
         but no connection is made here (server contact happens later, at
         login flows; M2 must keep it inert).
       - lua_bridge, state_machine, notification_center, fwin + window
         (custom window manager), optional display_log (debug only), and a
         UserDefault "version" stamp (1.417).
  5) main() -> app.load("client.launch")
       client/launch.lua (16 lines): registers terminal "launch_logo" in
       app.state_machine and executes it -> fwin:open(app.load("client.login.logo"),
       fwin._screen) — the first real window, client/login/logo.lua, loads
       WITHOUT any network dependency.
  6) Windows-only debug branch (ShadowUtil pvr dumps — guarded by config).
```

Important reference note: the recovered APK is ALREADY a custom 32-bit Windows-
capable rebuild ("NinjaRevolution-1.0.9-32bits"): main.lua carries
`PLATFORM_OS_WINDOWS` branches and PT/ES comments about an Android 11+ wrapper
("carcasa", CierreInforme.java). This port treats that main.lua as the
reference boot, not a pristine 1.0.9 upstream.

## Engine contracts the boot depends on

| Contract | State on Axmol probe |
|---|---|
| `cc = ax`, `ccui = axui` aliases | done (`compatibility.lua`, 22 lines) |
| `cc.dms_load` (Mac/Windows build defined it via FileUtils) | done in compatibility.lua (fail-visible asserts) |
| `configs/app.config` present | yes (assets/res/configs) |
| `cocos/**` framework files (38) | shipped in APK; JS json codec included; API parity vs Axmol bindings UNKNOWN per file |
| `require()` resolving through engine search paths | UNPROVEN on the probe (battle slice used dms_load+loadstring instead); FileUtils-based searcher fallback prepared |
| `cc.PLATFORM_OS_WINDOWS` numeric identity | probe marker will print both values (0.arch) |
| `json` global from cocos.cocos2d.json | shipped in APK |
| frameworks/support + windows modules existence | verified on disk (38 files under frameworks/**) |
| Network stack must stay INERT offline | modules may load; establishing connections is server-dependent and out of scope for this stage |
| fwin windows need a host scene | opening `client.login.logo` for real requires the probe scene to become a fwin host — M2 execution work, load-only for now |

## Analysis experiment (prepared; execution needs user-approved build/test batch)

Files added (tooling only):
- `port/lua/boot_map.lua` — runs stage by stage, prints `BOOT_MAP_*` markers:
  - stage 0 `arch`: resolution sanity + workspace-root derivation +
    platform/enum facts;
  - stage 0b: check native `require`; if it cannot see the original tree,
    install ONE FileUtils-based searcher at `package.loaders[2]`;
  - stage 1 `cocos_init`: whole `cocos/init.lua`; on failure, decompose into
    its own require list (`1b.<module>` lines name the first broken file);
  - stage 2 `app_lua`: frameworks/app.lua;
  - stage 3 `app_create`: FULL original `app.init()` (network modules included
    — loading only; KNOWN fallout: it replaces the probe search paths with
    relative game-folder entries, absent next to this exe);
  - stage 4 `client_launch`: original launcher terminal;
  - stage 5 `logo_load_only`: `app.load("client.login.logo")` WITHOUT opening
    the window (hosting it is the next milestone);
  - stage 6 `restore_probe_paths`: re-asserts the probe search paths so the
    remainder of the run (editor CSB, battle fixtures, screenshots) behaves
    exactly as in the green suite.
- Hook: `port/lua/local_battle.lua` executes it only when `NR_PROBE_BOOT_MAP`
  is set (no rebuild needed — the probe reads Lua from disk each run).
- Suite: `tools/test_layout_editor.py` gained case `boot-map-analysis`; it is
  EXPLORATORY — its result never folds into the suite verdict until the
  markers are analyzed.

Accepted risks during the experiment: pcall cannot catch a native crash (if
the original network/`JtsThreadHelper`/cocostudio wrappers force one, the
process dies AFTER printing its markers — the log still names the stage);
`app.init``s design-size math may touch GLView state (probe recreates its
window per run, so contamination is process-local).

## EXPERIMENT EXECUTED — RESULT (23 Oct 2026, night)

`python tools\test_layout_editor.py` → **7/7 markers OK**, suite still 5/5 green
(store-contracts, native write/read, battle smoke, boot-map exploratory), and
the full ORIGINAL chain now runs to the end on Axmol:

```
0.arch OK · 0b.searcher_installed OK · 0b.require_after_searcher OK
0c.engine_gap_shims OK · 1.cocos_init OK (all 38 framework files)
2.app_lua OK · 3.app_create OK (app.init() COMPLETE · network inert)
4.client_launch OK · 5.logo_load_only OK (client.login.logo loads; window NOT
opened — hosting it is the next milestone) · 6.restore_probe_paths OK
```

Gaps found iteration by iteration, each fixed as an honest, documented shim
(inside `port/lua/boot_map.lua` stage 0c, gated to boot-map runs):

1. `Director.getOpenGLView` — renamed in Axmol; aliased to the identical
   `getRenderView`.
2. `Image.setPVRImagesHavePremultipliedAlpha` — not exported; recorded as a
   no-op (assets here are PNG/CSB; reevaluate if PVR art ever lands).
3. `Director.setDisplayStats` — not exported; no-op (cosmetic stats overlay).
4. `cc.CBlowFish` — native binding of the original engine's network crypto;
   key storage works, any real Encrypt/Decrypt FAILS LOUDLY (offline map never
   fakes protocol behavior).
5. `socketevent` — shipped inside the original libjts.so; opening the module
   itself opened a TCP socket. Stubbed INERT: callbacks registered but never
   fire, `connect` never connects (marker on use), sends are dropped with a
   `BOOT_MAP_SHIM_USED` marker, unknown API surface fails loudly. Status stays
   -1 ("- not connected"), matching the offline policy.
6. `cc.GLProgramCache` — no Axmol equivalent; `destroyInstance` inert,
   `getGLProgram` returns nil (using it fails visibly instead of faking).

Infrastructure findings (no game content touched):

- **Builtin shader cards (`axslc`)**: Axmol resolves precompiled shaders
  (`positionTextureColor_vs` etc.) under the app root. `setSearchPaths` —
  ours, app.init's, and the stage-6 restore — replaces the list wholesale and
  drops that directory; the next builtin program load compiled an EMPTY shader
  and moved to a native assert (exit 0x80000003). Fix: `ResourceProbe.cpp`
  re-asserts `<root>/build/windows-probe-native/runtime/axslc` after its own
  search-path setup, and stage 6 appends the same directory (rebuild done).
- **Relative search paths resolve from the EXE directory**, not the CWD:
  `app.init` installs `res`/`src` relative entries exactly like the original
  game layout, so junction directories `res`→`01_conteudo_apk/assets/res` and
  `src`→`01_conteudo_apk/assets/src` were created next to the exe (and at the
  project root for tooling convenience). Regenerate after a reboot with:
  `cmd /c mklink /J "…\Debug\res" "E:\[code]\nk\01_conteudo_apk\assets\res"`
  (same for `src`), plus `subst N: "E:\[code]\nk"` if the build's absolute
  `N:` paths are needed (logon-transient; the overnight reboot reset both).
- Data files consumed at boot (`data/mould/sound_effect_param.txt` etc.) all
  resolve through the exe-side `res` junction — original files, no copies.
- `cc.PLATFORM_OS_WINDOWS` is nil on the Axmol bindings (targetPlatform=1);
  comparisons against nil evaluate false, so the original's Windows-only
  branches are skipped harmlessly. Worth revisiting in M2 if a branch decides
  behavior.
- Native `require` works while the engine's initial search paths are intact
  (stage 0b proved it); the absolute-root searcher (loaders[2]) exists because
  `app.init` destroys that state mid-boot.

## M2 executed — the original fwin hosts a live scene (logo opens), 23 Oct 2026

Follow-up experiment (`port/lua/host_logo.lua`, executed by the probe's new
`NR_PROBE_TEST_MODE=host` mode, gated behind `NR_PROBE_BOOT_MAP=1`): after the
boot-map restores the probe search paths, the host adapter rebuilds the
ORIGINAL window system and lets it take over the Director. Original content
untouched — `host_logo.lua` only orchestrates original calls. Sequence and
findings:

1. **The frame built inside `app.init` dies with the boot scene.** When the
   probe later replaces the (dormant) boot scene via `runWithScene`, cocos
   releases the whole fwin frame — `fwin._framewindow`, every container layer,
   and the logo instance opened by `client/launch.lua`'s top-level
   `state_machine.excute("launch_logo")` during stage 4. Calling
   `fwin:graphics` on the dead frame fails with
   `invalid 'obj' in lua_ax_base_Node_addChild` (fwin.lua:52); a re-run of the
   launch terminal fails at `fwin.lua:938` with
   `attempt to call method 'retain' (a nil value)` — the cached instance is a
   dead tolua object.
2. **`fwin:create()` rebuilds the frame with ORIGINAL code** (fwin:init: fresh
   `_framewindow`, `_layer`, all containers, `_list` cleared). Then
   **`fwin:graphics(nil)`** creates the original game scene, REPLACES the probe
   scene and re-parents the frame into it, wiring the original schedules
   (`NetworkManager.updateRequestQueue`, `fwin.updateLua`). The director swap
   is deferred: `getRunningScene()` still reports the probe scene for one
   frame (informational print only, never asserted).
3. **`app.load("client.login.logo")` returns an INSTANCE, not a class** —
   logo.lua ends with `return Logo:new()` (line 613). Window modules are
   singletons in the module cache. After the pre-host frame died, that cached
   instance cannot be re-opened; the host therefore rebuilds the window the
   same way the module did (`Logo:new()` — global class assigned at
   logo.lua:1) and runs the ORIGINAL open call from client/launch.lua:
   `fwin:open(window, fwin._screen)` → `fwin:push` → `fwin:swap`
   (fwin.lua:926) registers the window in `fwin._list`, attaches it into
   `fwin._screen._layer` and drives the original lifecycle (`open`, node
   events). Validated: instance is a real tolua userdata; `fwin._screen`
   holds 1 child; capture saved.
4. **Offline network noise surfaced by the live schedule**
   (`NetworkAdaptor.lua:544`): `updateRequestQueue`'s HTTP path calls
   `cc.DBytes:new(...)` — a data-buffer class exported by the ORIGINAL
   native stack (libjts era), absent from Axmol bindings. Each frame the
   queued request errors (`attempt to index field 'DBytes'`). Loud and
   honest; no data leaves the process (the step fails before any socket work,
   and `socketevent` is already the inert shim). Candidates for the future
   login offline story: a documented `cc.DBytes` stub that fails one step
   later, or stopping the queue tick for offline runs. NOT done now —
   original behavior stays visible.
5. Probe adaptation (`ResourceProbe.cpp`): `host` joined the mode whitelist;
   the host branch executes `port/lua/host_logo.lua`, then arms capture +
   deadline on the **DIRECTOR scheduler** (`Director::...->getScheduler()`),
   because the probe scene stops ticking after the swap — the scene-level
   `scheduleOnce` chain used by other modes would never fire. Shot:
   `logo-host-shot.png` (960x640). Exit contract identical to other modes;
   script failure keeps the run exploratory (markers only).

The suite (`tools/test_layout_editor.py`) now has six cases: five standard
(4 folded into `ok`) + `boot-map-analysis` + `logo-host`, both exploratory.
A `NR_PROBE_LINT=<file>` hook in `port/lua/local_battle.lua` compiles any Lua
file with the engine's own LuaJIT and prints the detailed parser message
(found `host_logo.lua:11: function arguments expected near 'and'` — a real
syntax bug invisible in file content checks; axmol's
`LuaStack::luaLoadBuffer` only AXLOGE-gates the generic message under
`_AX_DEBUG`, so runtime loads report no position).

Next milestone: verify the logo window content visually (video/static path,
fonts, spine intro assets it pulls), then follow the ORIGINAL logo → login
transition (`logo_check_assets` terminal → AssetsManager flow / login window)
still under host mode. No new game content was created anywhere in this work.


## Files read for this document

- `01_conteudo_apk/assets/src/main.lua` (130 lines, full)
- `01_conteudo_apk/assets/src/frameworks/app.lua` (520 lines, full)
- `01_conteudo_apk/assets/src/cocos/init.lua` (65 lines, full)
- `01_conteudo_apk/assets/src/client/launch.lua` (16 lines, full)
- Directory listings: `src/cocos/**` (38 files), `src/frameworks/**` (38 files),
  `src/client/login/*` (login.lua, logo.lua), plus index CSV confirming file
  sizes/paths (`04_indices/todos_os_arquivos.csv`).
