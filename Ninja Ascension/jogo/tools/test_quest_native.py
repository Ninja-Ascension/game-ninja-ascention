import os,sys,subprocess
from pathlib import Path
root=Path(__file__).resolve().parents[1]
fixtures=subprocess.run([sys.executable,str(root/'tools/test_quest_local.py')],capture_output=True)
assert fixtures.returncode==0,(fixtures.stdout+fixtures.stderr).decode('utf8',errors='replace')
env={k:v for k,v in os.environ.items() if not k.startswith('NR_PROBE_')}
env.update(NR_ENABLE_TUTORIAL='0',NR_PROBE_QUEST='1',NR_PROBE_NO_DIALOG='1',NR_PROBE_TEST_MODE='host',NR_PROBE_BOOT_MAP='1',NR_PROBE_MENU_TEST='1')
exe=root/'build/windows-probe-native/bin/NinjaResourceProbe/Debug/NinjaResourceProbe.exe'
run=subprocess.run([str(exe)],cwd=exe.parent,env=env,capture_output=True,timeout=50)
output=run.stdout.decode('utf8',errors='replace');(root/'build/quest-native.log').write_text(output,encoding='utf8')
assert run.returncode==0 and 'QUEST_NATIVE_PASSED' in output,output[-4000:]
assert not any(x in output for x in ('LUA ERROR:','Legacy Spine callback:','MENU_BOOT_PROBE_RESULT false')),output[-4000:]
print('QUEST_NATIVE_UI_PASSED')
