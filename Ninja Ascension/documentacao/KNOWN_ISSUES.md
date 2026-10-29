# Known issues

Automation round (23 October 2026): battle smoke is now an automated test case
(`NR_PROBE_TEST_MODE=battle`) and passes; native per-run screenshots
(`NR_PROBE_SHOT`) provide rendered frames for review — machine-checked for
size/brightness only, composition still needs human eyes (this harness model
cannot view images). `port/resources` override search path is active and its
precedence is proven at runtime with a byte-identical fb_icon.png copy
(OVERRIDE_RESOLVE -> port/resources in all three probe processes). Dirs
created before workspace provisioning (`port/`, `.git`) lack the sandbox grant
for the confined token: commands that write there run outside the sandbox (git,
binary copies), while harness file-backend edits work; user full-control
repairs were applied and verified, with rollback helpers under
`E:\[code]\dsh-acl-reports\`. Git checkpoint `1f496be` exists on `master`; `.git` has
protected/foreign-denied ACLs, so git commands run outside the sandbox until
that is resolved. Host alert: C: had under 10 MB free during this round
(ENOSPC on harness temp writes) — freeing C: is a pending user action; the
project on E: is unaffected. Follow-up (later 23 October): the battle case now
also captures the live scene while the battle is active (`battle-active-shot.png`,
turn 1, before the post-smoke shot); the LNK4098 Debug CRT warning was closed by
linking the probe with `/NODEFAULTLIB:MSVCRT` (`port/CMakeLists.txt`) — clean
link and a green 4-case suite.

Battle boot fix (23 October 2026): the local-battle integration had never been
compiled or tested; its first real run died at boot because `local_battle.lua`
never loaded `client.battle.report.RestrainObject` (required by BattleObject's
ctor; the original loads it via `BattleReport.lua`), and
`LuaStack::executeScriptFile()` returns 0 for both success and errors, hiding
the `[LUA ERROR]` from the probe's boot checks. Both fixed under `port/` and
validated: the automated suite (`store-contracts` plus `NR_PROBE_TEST_MODE=
write/read/battle`) exits 0 on every case, the battle smoke passes
(`LOCAL_BATTLE_SMOKE_PASSED`) and the fixes are checkpointed on `master`.
Still unverified: audible audio, visual parity, computer-use helper.

Newest animation update (23 October): `spirte_102101` parses and evaluates with the pinned official Spine 2.1.25 C runtime and a native Axmol polygon adapter. Historical `flipX` failure below applies to the Cocos 3.5 comparison runtime. This does not certify every character or visual parity. Animation events do not yet trigger gameplay/audio; animation selection and speed are session-only. Modern Spine Lua bindings remain disabled. Computer-use visual verification remains unresolved (the Debug CRT warning was closed on 23 October via /NODEFAULTLIB:MSVCRT). See PREVIA_PERSONAGEM.md.

Latest layout-editor update: global mouse/audio binding removed; audio has a dedicated button/A shortcut. Save/Reload/Restore and automatic reload now work for registered nodes, verified in native tests. Inspector Delete is deliberately not persisted: saving is blocked until restore/reload, while nodes are retained safely. Use Visible=false to persist hiding. The current logo starts paused; resume with its button/Space, and note that animated/layout-controlled properties may be overwritten by those controllers while playing. Nodes outside the stable registry are not saved. Debug CRT warning, Spine compatibility and external computer-use helper issues remain open.

Current native status: the resource probe now builds, opens and remains responsive. CSB node/timeline startup is logged. Outstanding issues are animation compatibility (including flipX in the legacy comparison), visual/input/audio acceptance and a Debug LNK4098 CRT-link warning. No longer blocked by toolchain installation. The Computer Use helper itself fails on the bracketed workspace path, preventing screenshot verification; application logs and process checks were used instead.

Latest follow-up supersedes missing-toolchain entries below: VS2026/MSVC, Windows SDK and CMake are installed and recognized. Axmol configuration passes. The source directory brackets break CMake globbing; `N:` is a temporary SUBST alias of `E:\[code]\nk`, not a copied checkout. Builds use N:/build/windows-probe-native. axslcc 1.14.0 was downloaded into build/deps only, with archive SHA-256 `5EA1AE25517A14A81B578836563837FDDCB3FECA005581761446F3E75986E828`. Original historical entries follow.

New native finding: the unchanged legacy Spine parser rejects original `flipX` bone timelines. An initial cleanup crashed in `spAnimation_dispose`; checking the parser's error field before using the returned skeleton now reports the actual failure and exits 4. This is an unresolved animation incompatibility, not a passing test or an asset modification.

1. **Native build blocked:** `tools/build_windows.ps1 -ConfigureOnly` fails immediately with missing CMake. `cmake`, `cl`, `ninja`, `lua`, `luajit` were absent from PATH; standard Program Files paths had no VS installation or Windows Kits. A compiler installed elsewhere is not ruled out. No executable or native crash log exists.
2. **Spine hard incompatibility:** run `tools/probe_compatibility.py`; original spirte_102101 is 2.1.27, runtime header says 4.2 and parser rejects version mismatch. Adapter not implemented. Legacy parser source is present, not compiled. Original sample has weighted skinnedmesh attachments and three PNG pages.
3. **Original login CSB references unresolved by direct resource lookup:** Default/DemoPlayer.ExportJson, images/ui/login/button_gongguang.png, images/ui/login/fangchenmi.png. See compatibility_results.json. They may be legacy placeholders, frame names or localized/update resources; do not assume harmless. Native load/appearance has not been tested, and loader may fail before showing the scene.
4. **Lua contracts unexecuted:** aliases do not restore changed renderer/shader APIs or all custom methods. `cc.dms_load` probe uses the original Windows string-return convention; Android optional length/decryption semantics remain unknown.
5. **Font encoding:** selected .fnt has non-UTF-8 face metadata. Initial validator failed with UnicodeDecodeError. Fixed to parse ASCII page filename bytes without altering original encoding. Rendering still requires validation.
6. **Backend excluded:** resource probe does not run main.lua/login/network, download patches, contact historical endpoints, fabricate server responses or load accounts. No gameplay/save support claimed.
7. **Headless validation limits:** passing CSB structural decode does not certify native loader support, anchors, glyphs, timeline events, audio or GPU rendering.
8. **Diagnostic source uncompiled:** compiler integration, DLL staging, shaders and runtime errors may remain. All need real build/run before this can be called a validated native foundation.
