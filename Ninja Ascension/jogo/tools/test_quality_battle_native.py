import os,sys,subprocess,tempfile
from pathlib import Path
root=Path(__file__).resolve().parents[1]
build=Path(os.environ.get('NR_PROBE_BUILD',root/'build/windows-probe-native'))
config=os.environ.get('NR_PROBE_CONFIG','Debug')
fixtures=subprocess.run([sys.executable,str(root/'tools/test_hero_quality_local.py')],capture_output=True)
assert fixtures.returncode==0,(fixtures.stdout+fixtures.stderr).decode('utf8',errors='replace')
exe=build/'bin/NinjaResourceProbe'/config/'NinjaResourceProbe.exe'
with tempfile.TemporaryDirectory(prefix='quality-battle-',dir=root/'build') as writable:
    env={k:v for k,v in os.environ.items() if not k.startswith('NR_PROBE_')}
    env.update(NR_GAME_ROOT=str(root),NR_PROBE_WRITABLE=writable,NR_ENABLE_TUTORIAL='0',
               NR_PROBE_QUALITY_BATTLE='1',NR_PROBE_NO_DIALOG='1',NR_PROBE_TEST_MODE='host',
               NR_PROBE_BOOT_MAP='1',NR_PROBE_MENU_TEST='1')
    run=subprocess.run([str(exe)],cwd=exe.parent,env=env,capture_output=True,timeout=50)
output=run.stdout.decode('utf8',errors='replace')+run.stderr.decode('utf8',errors='replace')
(root/'build/quality-adventure-native.log').write_text(output,encoding='utf8')
assert run.returncode==0 and 'QUALITY_ADVENTURE_NATIVE_PASSED' in output,f'returncode={run.returncode}\n{output[-4500:]}'
assert not any(x in output for x in ('LUA ERROR:','Legacy Spine callback:','MENU_BOOT_PROBE_RESULT false')),output[-4500:]
print('QUALITY_ADVENTURE_NATIVE_UI_PASSED')
