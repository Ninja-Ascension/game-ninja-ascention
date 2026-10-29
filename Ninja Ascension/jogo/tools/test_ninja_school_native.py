import os,subprocess
from pathlib import Path
root=Path(__file__).resolve().parents[1]
env={k:v for k,v in os.environ.items() if not k.startswith('NR_PROBE_')}
env.update(NR_GAME_ROOT=str(root),NR_ENABLE_TUTORIAL='0',NR_PROBE_NINJA_SCHOOL='1',NR_PROBE_NO_DIALOG='1',NR_PROBE_TEST_MODE='host',NR_PROBE_BOOT_MAP='1',NR_PROBE_MENU_TEST='1')
exe=root/'build/windows-probe-native/bin/NinjaResourceProbe/Debug/NinjaResourceProbe.exe'
run=subprocess.run([str(exe)],cwd=exe.parent,env=env,capture_output=True,timeout=50)
output=run.stdout.decode('utf8',errors='replace')
(root/'build/ninja-school-native.log').write_text(output,encoding='utf8')
print('\n'.join(line for line in output.splitlines() if 'SCHOOL_' in line or 'LUA ERROR:' in line))
assert run.returncode==0 and 'NINJA_SCHOOL_NATIVE_PASSED' in output,output[-1400:]
assert 'LUA ERROR:' not in output and 'MENU_BOOT_PROBE_RESULT false' not in output
