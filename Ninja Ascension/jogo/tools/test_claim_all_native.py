import os, subprocess
from pathlib import Path

root = Path(__file__).resolve().parents[1]
env = {key: value for key, value in os.environ.items() if not key.startswith('NR_PROBE_')}
result = root / 'build/claim-all-native-result.txt'
log = root / 'build/claim-all-native.log'
result.unlink(missing_ok=True)
env.update(
    NR_GAME_ROOT=str(root),
    NR_ENABLE_TUTORIAL='0',
    NR_PROBE_CLAIM_ALL='1',
    NR_PROBE_NO_DIALOG='1',
    NR_PROBE_TEST_MODE='host',
    NR_PROBE_BOOT_MAP='1',
    NR_PROBE_MENU_TEST='1',
)
exe = root / 'build/windows-release/bin/NinjaResourceProbe/Release/NinjaResourceProbe.exe'
run = subprocess.run([str(exe)], cwd=root, env=env, capture_output=True, timeout=50)
output = (run.stdout + run.stderr).decode('utf8', errors='replace')
log.write_text(output, encoding='utf8')
print('native_exit', run.returncode)
assert run.returncode == 0 and result.is_file(), output[-5000:]
assert result.read_text(encoding='utf8') == 'passed;items=8;pages=5+3'
print('CLAIM_ALL_NATIVE_PASSED: eight rewards appeared in two visible original-cell pages (5+3)')
