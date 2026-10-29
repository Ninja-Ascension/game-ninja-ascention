"""Exercise real toast timeline creation and expiry in a private client."""
import os,subprocess,tempfile
from pathlib import Path
root=Path(__file__).resolve().parents[1]
with tempfile.TemporaryDirectory(prefix='home-base-',dir=root/'build',ignore_cleanup_errors=True) as folder:
 folder=Path(folder)
 env={k:v for k,v in os.environ.items() if not k.startswith('NR_')}
 env.update(NR_GAME_ROOT=str(root),NR_PROBE_WRITABLE=str(folder),NR_ENABLE_TUTORIAL='0',NR_PROBE_HOME_BASE='1',NR_PROBE_STARTUP_SHOT=str(folder/'tip.png'))
 exe=root/'build/windows-release/bin/NinjaResourceProbe/Release/NinjaResourceProbe.exe'
 run=subprocess.run([str(exe)],cwd=root,env=env,capture_output=True,timeout=25)
 (root/'build/home-base-process.log').write_bytes(run.stdout+run.stderr)
 assert run.returncode==0,hex(run.returncode & 0xffffffff)
 assert 'HOME_BASE_NATIVE_PASSED' in (folder/'home-base-test.txt').read_text()
 (root/'build/home-base-native.png').write_bytes((folder/'tip.png').read_bytes())
 assert not (folder/'boot-errors.log').exists()
 print('HOME_BASE_NATIVE_PASSED original Spine effect, one instance, screenshot saved')
