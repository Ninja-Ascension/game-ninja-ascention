"""Ask the native client Lua runtime to compile and load MoppingResults.lua."""
import os
import subprocess
from pathlib import Path

root = Path(__file__).resolve().parents[1]
env = {key: value for key, value in os.environ.items() if not key.startswith('NR_PROBE_')}
env.update(
    NR_GAME_ROOT=str(root),
    NR_ENABLE_TUTORIAL='0',
    NR_PROBE_SWEEP_LUA='1',
    NR_PROBE_NO_DIALOG='1',
    NR_PROBE_TEST_MODE='host',
    NR_PROBE_BOOT_MAP='1',
    NR_PROBE_MENU_TEST='1',
    NR_PROBE_WRITABLE=str(root / 'build' / 'sweep-lua-probe-writable'),
)
exe = root / 'build' / 'windows-release' / 'bin' / 'NinjaResourceProbe' / 'Release' / 'NinjaResourceProbe.exe'
proof = root / 'build' / 'sweep-lua-native-result.txt'
proof.unlink(missing_ok=True)
startup = subprocess.STARTUPINFO()
startup.dwFlags |= subprocess.STARTF_USESHOWWINDOW
startup.wShowWindow = 0
run = subprocess.run([str(exe)], cwd=root, env=env, capture_output=True,
                     timeout=50, startupinfo=startup)
output = (run.stdout + run.stderr).decode('utf-8', errors='replace')
(root / 'build' / 'sweep-lua-native.log').write_text(output, encoding='utf-8')
result = proof.read_text(encoding='utf-8') if proof.exists() else 'MoppingResults proof was not written'
assert run.returncode == 0 and result == 'passed;MoppingResults loaded', result + '\n' + output[-2500:]
assert 'LUA ERROR:' not in output and 'MENU_BOOT_PROBE_RESULT false' not in output, output[-3500:]
print('SWEEP_LUA_NATIVE_PASSED', result)
