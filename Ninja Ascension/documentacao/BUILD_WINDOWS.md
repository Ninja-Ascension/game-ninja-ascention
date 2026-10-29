# Reproduce M0/M1 on Windows x64

Persistence regression suite added: first finish building `NinjaResourceProbe` and `LayoutOverridesTests`, then run `python tools/test_layout_editor.py`. Do not launch tests while the post-build DLL copy is still running. Test profiles are isolated under build/. Use USAR_EDITOR_DE_LAYOUT.md for the normal editor controls and local JSON location.

Latest installed environment: Visual Studio Community 2026 18.11.12315.225, MSVC 19.51.36260 x64, Windows SDK 10.0.26100.0, CMake 4.5.0-rc1, Git 2.56.0.windows.2. The script now detects VS2022 or VS2026. Ninja is not needed for the Visual Studio generator. System Lua is not needed: the project explicitly links the pinned Axmol LuaJIT dependency. Prior missing-toolchain results below are historical.

Use a bracket-free alias because CMake globbing treats `[code]` as a pattern. No files are moved:

```powershell
subst N: "E:\[code]\nk"
./tools/prepare_probe_dependencies.ps1
./tools/build_windows.ps1 -SourceRoot N:/
```

Only use N: if free, or choose another unused letter and pass it as SourceRoot. Keep the alias while building/debugging; it is session-local and can later be removed with `subst N: /D`. Existing native build directory: `build/windows-probe-native`, legacy: `build/legacy-parser-native`. The axslcc setup verifies a pinned archive SHA-256 and makes no PATH, registry, security-policy or developer-mode changes. Third-party engine packages are fetched by CMake into the ignored build tree. WebView2 is disabled because the offline resource probe does not use an embedded browser; NuGet is consequently unnecessary for this target.

Run commands from the repository root in PowerShell. Reference APK/assets are not copied or converted. Network downloads below target official engine repositories only.

Prerequisites: Git, Python 3.10+, Visual Studio 2022 with Desktop development with C++ (MSVC v143 x64/x86, Windows 10/11 SDK, CMake tools). Pinned Axmol setup documents VS2022/2026 and its managed profile requests CMake 4.2.x; the project minimum is 3.22. Use CMake 4.2.x for this procedure. No compiler/SDK was installed automatically during this milestone.

```powershell
./tools/fetch_engines.ps1
python tools/probe_compatibility.py
python port/tests/test_compatibility.py
```

Engine revision verification is mandatory; scripts reject mismatches. `build/deps` is ignored by version control. Axmol source is unmodified. The legacy checkout is an analysis reference, not a built library.

After installing the toolchain, follow the pinned Axmol `docs/DevSetup.md` for third-party dependency/shader compiler setup. Its `setup.ps1` may download tools and configure environment variables; review before running:

```powershell
& ./build/deps/axmol/setup.ps1
# Open a fresh VS2022 developer PowerShell with CMake on PATH.
./tools/build_windows.ps1 -ConfigureOnly
./tools/build_windows.ps1
Get-ChildItem ./build/windows-probe -Filter NinjaResourceProbe.exe -Recurse
```

Expected target: NinjaResourceProbe.exe, diagnostic only. No executable exists from the current session. Do not report the above commands as tested successfully: configure was blocked before CMake ran. Run the discovered executable after DLL staging completes. Shader/dependency downloads are handled by pinned engine helpers, which may need network access. An offline build needs those dependencies cached separately.

The probe enforces x64 and pinned engine revision, enables LuaJIT explicitly, disables Spine 4.2, reads original res/src paths and writes diagnostics to `E:\[code]\nk\build\probe-writable\resource-probe.log` (workspace-only; project policy stores nothing on C:; redirect with `NR_PROBE_WRITABLE`). It never requires original main.lua. A/click requests original background audio; Space toggles pause; R restarts original logo timeline. CSB login UI may expose missing references listed in KNOWN_ISSUES. The atlas texture is not an animated character.

Manual acceptance after a successful build: verify login layout and glyph appearance, original logo timeline/frame events, audible MP3 on real device, focus/pause/resume, mouse/keyboard, and missing-file traceback. Capture logs/screenshots and exact machine/build configuration. Character animation remains a failing gate until a version-compatible adapter is implemented and compared with legacy reference. Do not start M2 just because the probe window opens.

The isolated legacy C parser comparison avoids old graphics/engine prebuilt libraries. It compiles unchanged reference runtime C files and reads actual PNG dimensions without allocating GPU textures:

```powershell
cmake -S port/tests/legacy_parser -B build/legacy-parser -G 'Visual Studio 17 2022' -A x64
cmake --build build/legacy-parser --config Debug
ctest --test-dir build/legacy-parser -C Debug --output-on-failure
```

These commands are prepared, NOT executed successfully. This checks parsing, not animation or rendering parity. Full legacy engine comparison: Cocos2d-x 3.5 uses historical external prebuilt libraries and MSVC defaults disable Lua. Check library machine types before attempting x64 linking; recompile compatible dependencies as needed. The current environment cannot run this comparison because compiler/SDK/CMake are missing. No claim of a working minimal legacy Windows build is made.
