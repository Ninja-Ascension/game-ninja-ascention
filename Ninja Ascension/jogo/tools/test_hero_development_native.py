import os,subprocess
from pathlib import Path
root=Path(__file__).resolve().parents[1]
env={k:v for k,v in os.environ.items() if not k.startswith('NR_PROBE_')}
env.update(NR_ENABLE_TUTORIAL='0',NR_PROBE_HERO_DEVELOPMENT='1',NR_PROBE_NO_DIALOG='1',NR_PROBE_TEST_MODE='host',NR_PROBE_BOOT_MAP='1',NR_PROBE_MENU_TEST='1')
exe=root/'build/windows-probe-native/bin/NinjaResourceProbe/Debug/NinjaResourceProbe.exe'
run=subprocess.run([str(exe)],cwd=exe.parent,env=env,capture_output=True,timeout=50)
output=run.stdout.decode('utf8',errors='replace');(root/'build/hero-development-native.log').write_text(output,encoding='utf8')
assert run.returncode==0 and 'HERO_DEVELOPMENT_NATIVE_PASSED' in output,output[-3500:]
assert 'LUA ERROR:' not in output and 'MENU_BOOT_PROBE_RESULT false' not in output,output[-3500:]
print('HERO_DEVELOPMENT_NATIVE_PASSED')
