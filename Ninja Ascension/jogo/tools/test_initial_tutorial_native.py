"""Construct choice UI and parse isolated outcomes in the actual Release client."""
import os
from pathlib import Path
import subprocess
import sys

root=Path(__file__).resolve().parents[1]
subprocess.run([sys.executable,str(root/'tools/test_initial_tutorial.py')],check=True,capture_output=True)
output=root/'build/initial-tutorial-native'
output.mkdir(exist_ok=True)
result=root/'build/initial-tutorial-native-result.txt'
if result.exists():result.unlink()
env={k:v for k,v in os.environ.items() if not k.startswith('NR_')}
env.update(NR_GAME_ROOT=str(root),NR_PROBE_WRITABLE=str(output),
           NR_PROBE_INITIAL_TUTORIAL='1',NR_PROBE_NO_DIALOG='1',
           NR_PROBE_TEST_MODE='host',NR_PROBE_BOOT_MAP='1',NR_PROBE_MENU_TEST='1',
           NR_PROBE_SHOT=str(output),NR_PROBE_LAYOUT_FILE=str(output/'layout.json'))
run=subprocess.run([str(root/'build/windows-release/bin/NinjaResourceProbe/Release/NinjaResourceProbe.exe')],
                   cwd=root,env=env,capture_output=True,timeout=35)
(output/'native.log').write_bytes(run.stdout+run.stderr)
assert run.returncode==0,run.returncode
assert result.exists(),'Native callback did not finish'
assert result.read_text(encoding='utf8')=='passed',result.read_text(encoding='utf8')
assert (output/'logo-host-shot.png').is_file()
print('INITIAL_TUTORIAL_NATIVE_PASSED parsers and choice constructed; full manual playthrough pending')
