"""Run native Axmol UI using isolated Event protocol fixtures, no real account."""
import os,subprocess,sys
from pathlib import Path
root=Path(__file__).resolve().parents[1]
fixture=subprocess.run([sys.executable,str(root/'tools/test_events_local.py')],capture_output=True)
assert fixture.returncode==0,(fixture.stdout+fixture.stderr).decode(errors='replace')[-3000:]
env={k:v for k,v in os.environ.items() if not k.startswith('NR_PROBE_')}
shots=root/'build/events-screenshots';shots.mkdir(exist_ok=True)
env.update(NR_GAME_ROOT=str(root),NR_ENABLE_TUTORIAL='0',NR_PROBE_EVENTS='1',NR_PROBE_NO_DIALOG='1',NR_PROBE_BOOT_MAP='1',NR_PROBE_MENU_TEST='1',NR_PROBE_WRITABLE=str(root/'build/events-probe-writable'),NR_PROBE_STARTUP_SHOT=str(shots/'events.png'))
exe=root/'build/windows-release/bin/NinjaResourceProbe/Release/NinjaResourceProbe.exe'
proof=root/'build/events-native-result.txt'
proof.unlink(missing_ok=True)
startup=subprocess.STARTUPINFO();startup.dwFlags|=subprocess.STARTF_USESHOWWINDOW;startup.wShowWindow=0
result=subprocess.run([str(exe)],cwd=root,env=env,capture_output=True,timeout=50,startupinfo=startup)
output=(result.stdout+result.stderr).decode('utf8',errors='replace')
(root/'build/events-native.log').write_text(output,encoding='utf8')
details=proof.read_text(encoding='utf8') if proof.exists() else 'Native Event result was not written'
assert result.returncode==0 and details.startswith('true '),details+'\n'+output[-2000:]
assert not any(t in output for t in ('LUA ERROR:','MENU_BOOT_PROBE_RESULT false')),output[-5000:]
print('EVENT_NATIVE_UI_PASSED')
