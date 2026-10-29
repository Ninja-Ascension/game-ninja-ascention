# M0/M1 compatibility matrix

Native follow-up: Lua compatibility.lua assertions, original CSB node creation and logo timeline startup now execute successfully in the Axmol x64 probe. Font/atlas creation did not trigger boot failure. This validates the exercised API calls, not visual fidelity or arbitrary recovered Lua modules. Audio backend initialization did not log failure; audible playback and input remain manual checks. Legacy reference parser now compiles/runs but rejects `flipX` bone timelines. Detailed prior static classifications below should be read with these newer execution results.

Paths below are relative to `01_conteudo_apk/assets/src` unless specified. Status distinguishes source inspection from execution.

| Original API / call location | Contract evidenced by caller | Axmol replacement / work | Priority and verification | Status |
|---|---|---|---|---|
| `cc`, `ccui`; main.lua/frameworks | Engine classes and UI types | Probe aliases `ax`, `axui` only | M1; Lua runtime assertions | Implemented, unexecuted |
| `cc.dms_load(path)`; frameworks/app.lua:8,63,119 | String contents, optionally length; Windows branch already uses FileUtils | Probe FileUtils getStringFromFile with existence check, one return | M1; read app.config and negative missing-file assertion | Implemented, unexecuted; native Android second return not reconstructed |
| `FileUtils`/search paths; main.lua:3–4, app.lua | src/res plus versioned/localized overlays | Explicit reference paths; writable data under LOCALAPPDATA/NinjaRevolutionProbe | M1; load selected assets, log path | Implemented, unexecuted; update overlays excluded from probe |
| `CSLoader` / csb.createNode; frameworks/support/cocostudio.lua | Node tree, resources, anchors, timeline/action tags | Existing cocostudio extension | M1; original login CSB and logo timeline | Binary decode comparison passed; rendering untested |
| `sp.SkeletonAnimation`; frameworks/support/display.lua:294–315 | JSON/atlas/scale, track/name/loop, skins | 4.2 is incompatible; isolated legacy adapter needed | M1 blocker; weighted mesh, animation event and frame comparisons | Blocked, no critical stub |
| atlas/bitmap font | Page paths and glyph/frame coordinates | Original textures and BMFont loader | M1; selected atlas pages and font page exist; render glyphs | File validation passed; GPU untested |
| `AudioUtil` / frameworks/external/utils/AudioUtil.lua | BGM/effect playback, volume, stop | AudioEngine lazyInit/play2d | M1; original background_1.mp3 by A/click | Implemented request path, playback untested |
| `socketevent`; frameworks/network/NetworkAdaptor.lua:7–13 | tcp(key), on(event,callback), sendmessage, close/connect plus heartbeat | Custom transport contract; yasio not automatically equivalent | Later startup/combat; loopback framing/crypto/timeout tests | Deferred; native registrar found, not stubbed |
| `socket.core`; script/socket.lua; NetworkAdaptor.lua:10 | TCP primitives, gettime high-resolution clock | Portable LuaSocket build or measured clock adapter | Later network/timing; API contract tests | Native symbol found; no replacement claimed |
| `mime.core`; script/mime.lua | Binary filters/encoding | Portable LuaSocket MIME component | Later if selected path needs it | Deferred; native symbol found |
| LuaJIT FFI | ELF luaopen_ffi; direct active caller not established | Opt-in LuaJIT 2.1; native ABI contracts | Later if active caller exists; audit direct/indirect require | Runtime selected, FFI execution untested |
| `jttd`, custom rendering/cachers | e.g. logo.lua calls facebookAPPeventSlogger; cacher.lua uses addImageAsync extension | Explicit platform services/custom method adapters | Later full startup; inventory active call chain | Not invoked by resource probe; no empty success implementation |
| `luaj` bridge; frameworks/support/lua_bridge.lua | JNI request/callback registration | Desktop service interfaces, fail unsupported calls | Later account/store; contract callbacks | Excluded from probe |
| `UserDefault`; frameworks/app.lua:360+ | Preferences and update version | Desktop UserDefault, separate future progress store | Later full startup/save | Not claimed as complete player save |
| callbacks/pause | Director scheduler and audio lifecycle | Window focus suspend/resume, keyboard pause | M1; manual focus/Space test | Implemented, unexecuted |

Active build identification: `res/configs/app.config` ReleaseProject=27; `client/operation/Config.lua:23` assigns __lua_project_id from that value and `:50` defines __lua_project_l_naruto=27. `client/login/logo.lua` loads Config and initializes protocol/network/asset-update paths even on desktop (one Windows branch is `and false`). Running original main.lua is therefore not an offline resource test. The probe deliberately starts its own diagnostic scene without executing game startup. Runtime SDK overrides in ThirdpartySupporter and downloaded updates could still change selection in the installed app.

Combat follow-up evidence only: Fight.lua:420–520 branches for l_naruto into local FightModule setup in relevant modes; BattleReport loads FormulaUtil and other simulation modules. Some modes still request/init server data. M2 will trace individual fight types and state fixtures; no combat tests or mocked authority were added in M0/M1.
