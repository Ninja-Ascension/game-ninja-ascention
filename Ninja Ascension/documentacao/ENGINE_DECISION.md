# M0/M1 engine decision — 22 October 2026

Latest execution: Axmol x64 diagnostic now builds and launches with original CSB/timeline startup after Lua contract assertions. This supports retaining the primary engine candidate. Full animation compatibility is still blocked; no full-game/production gate pass is claimed. See TEST_RESULTS.md for the executable, environment and remaining warning.

Native follow-up: VS2026 18.11, MSVC x64 19.51 and Windows SDK 10.0.26100.0 are now available. CMake 4.5.0-rc1 configured the Axmol probe successfully after scoped shader dependency setup. The legacy C parser built and executed, but explicitly failed on `Invalid timeline type for a bone: flipX`. Therefore the reference 3.5 runtime is not directly compatible with this character either. Its parser can return non-NULL after an animation error, leaving dangling animation entries; the diagnostic now checks `reader->error` before inspecting/disposal and returns failure. The reference engine files remain unchanged.

Read the complete `06_auditoria/RELATORIO.md` before implementation. No original files changed.

Primary candidate pinned: **Axmol v2.11.5**, Git commit `6c0dce6db4660feafe29dabb1ab3506ee76b0931`. Reference: **Cocos2d-x cocos2d-x-3.5**, commit `f7e11a2467e4508738ad9cf4b3992da05f9d1e7c`. Both were downloaded and inspected locally. The engine selection has not changed; production integration is blocked pending the animation gate.

Evidence at the pinned Axmol revision:

- `docs/DevSetup.md`: VS2022 or newer with Desktop C++ workload. Template requires CMake >=3.22; engine-managed build profile currently requests 4.2.x. Use VS2022/v143, Windows 10/11 SDK and CMake 4.2.x for the setup below.
- `3rdparty/lua/plainlua/CMakeLists.txt`: default Lua 5.4.8. `3rdparty/CMakeLists.txt` defaults AX_USE_LUAJIT to false. Explicit `AX_USE_LUAJIT=ON` selects LuaJIT; dependency overview identifies 2.1-7152e15. This preserves 5.1 semantics, but does not prove identical RNG/FFI/ABI to original 2.0.3.
- `extensions/spine/runtime/include/spine/Version.h`: Spine 4.2. `SkeletonJson.cpp:155–158` rejects a skeleton version not beginning with 4.2. Original character `spirte_102101` is 2.1.27 with region and skinnedmesh attachments, including three atlas pages. Merely changing its version string would be invalid.
- `extensions/cocostudio` still has CSLoader, CSB reader, timeline and legacy armature readers. Generated table fields are close to the adapted 2.1 schema (TextOptions localization at end of legacy fields). This is source evidence, not an executed CSB compatibility result.
- Native Lua core registers `ax`, UI registers `axui`, studio registers `ccs`: probe provides narrow `cc=ax`, `ccui=axui` aliases. Methods beyond this surface remain unverified.

Legacy comparison: Cocos2d-x 3.5 includes the C Spine runtime with old `skins` object, FFD and skinnedmesh parsing, unlike Axmol's 4.2 parser. It is a closer diagnostic reference. Its root CMake explicitly disables Lua builds/tests by default for MSVC and has a TODO about MSVC tests; its historical prebuilt dependencies must not be assumed x64 or compatible with VS2022. No legacy native build was completed because no C++ compiler/SDK/CMake was found. Thus it is not yet a demonstrated alternative Windows x64 runtime.

Preferred next experiment: isolate the legacy Spine 2.1 parser/runtime behind an Axmol rendering adapter, preserving weighted meshes, FFD, events and atlas pages. Compare parser outputs against the pinned legacy reference first. Keep Spine 4.2 disabled in the diagnostic target to prevent accidental ingestion. Do not replace every character with frame exports or perform mass JSON conversions. A runtime migration or re-export needs version-aware handling and visual parity tests; original Spine editor projects were not supplied.

License: Axmol is MIT, but its Spine extension uses Spine Runtimes License; the pinned legacy runtime carries Spine Runtimes Software License Version 2.1, including restrictions on developing new applications/modifying runtime without appropriate permission. Ownership/permission evidence is not supplied. No legacy Spine source was copied into the port or relicensed. Resolve terms for the selected integration before distribution and before adopting runtime changes that require permission. Sources: [Axmol pinned tree](https://github.com/axmolengine/axmol/tree/v2.11.5), [legacy reference](https://github.com/cocos2d/cocos2d-x/tree/cocos2d-x-3.5), and license headers in those checkouts.

Decision: **production gate remains blocked**. `port/CMakeLists.txt` is only a resource diagnostic harness; no production startup or combat migration is enabled. Engine source remains unchanged.
