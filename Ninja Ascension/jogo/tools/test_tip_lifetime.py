"""Exercise real toast timeline creation and expiry in a private client."""
import os,subprocess,tempfile
from pathlib import Path
root=Path(__file__).resolve().parents[1]
with tempfile.TemporaryDirectory(prefix='tip-lifetime-',dir=root/'build',ignore_cleanup_errors=True) as folder:
 folder=Path(folder)
 env={k:v for k,v in os.environ.items() if not k.startswith('NR_')}
 env.update(NR_GAME_ROOT=str(root),NR_PROBE_WRITABLE=str(folder),NR_ENABLE_TUTORIAL='0',NR_PROBE_TIP_LIFETIME='1',NR_PROBE_STARTUP_SHOT=str(folder/'tip.png'))
 exe=root/'build/windows-release/bin/NinjaResourceProbe/Release/NinjaResourceProbe.exe'
 run=subprocess.run([str(exe)],cwd=root,env=env,capture_output=True,timeout=25)
 (root/'build/tip-lifetime-process.log').write_bytes(run.stdout+run.stderr)
 assert run.returncode==0,hex(run.returncode & 0xffffffff)
 assert 'TIP_LIFETIME_OPEN 3' in (folder/'tip-lifetime.log').read_text()
 assert 'GameTipDialogClass' not in (folder/'startup-state.txt').read_text(),'notification did not expire'
 assert not (folder/'boot-errors.log').exists()
 print('TIP_LIFETIME_PASSED three native notifications, animation expiry, process alive')
