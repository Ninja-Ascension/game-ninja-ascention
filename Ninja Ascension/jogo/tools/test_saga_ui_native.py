import os,subprocess
from pathlib import Path
root=Path(__file__).resolve().parents[1]
env={k:v for k,v in os.environ.items() if not k.startswith('NR_PROBE_')}
env.update(NR_GAME_ROOT=str(root),NR_ENABLE_TUTORIAL='0',NR_PROBE_SAGA_UI='1',NR_PROBE_NO_DIALOG='1',NR_PROBE_TEST_MODE='host',NR_PROBE_BOOT_MAP='1',NR_PROBE_MENU_TEST='1')
exe=root/'build/windows-release/bin/NinjaResourceProbe/Release/NinjaResourceProbe.exe'
result=root/'build/saga-ui-native-result.txt'
if result.exists():result.unlink()
run=subprocess.run([str(exe)],cwd=root,env=env,capture_output=True,timeout=50)
output=(run.stdout+run.stderr).decode('utf8',errors='replace');print('native_exit',run.returncode);(root/'build/saga-ui-native.log').write_text(output,encoding='utf8')
assert run.returncode==0 and result.is_file(),output[-3500:]
assert result.read_text(encoding='utf8')=='true nil',result.read_text(encoding='utf8')
assert 'LUA ERROR:' not in output and 'MENU_BOOT_PROBE_RESULT false' not in output,output[-3500:]
print('SAGA_UI_NATIVE_PASSED')
