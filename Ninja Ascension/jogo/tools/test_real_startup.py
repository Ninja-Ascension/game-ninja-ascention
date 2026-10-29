"""Normal PC startup, private settings, no test-mode boot shortcuts."""
import os,subprocess,tempfile
from pathlib import Path
from PIL import Image
root=Path(__file__).resolve().parents[1]
with tempfile.TemporaryDirectory(prefix='real-startup-',dir=root/'build',ignore_cleanup_errors=True) as folder:
    folder=Path(folder)
    env={k:v for k,v in os.environ.items() if not k.startswith('NR_')}
    env.update(NR_GAME_ROOT=str(root),NR_PROBE_WRITABLE=str(folder),NR_ENABLE_TUTORIAL='0',NR_PROBE_STARTUP_SHOT=str(folder/'startup.png'))
    run=subprocess.run([str(root/'build/windows-release/bin/NinjaResourceProbe/Release/NinjaResourceProbe.exe')],cwd=root,env=env,capture_output=True,timeout=25)
    (root/'build/real-startup-process.log').write_bytes(run.stdout+run.stderr)
    assert run.returncode==0,run.returncode
    assert 'ok=true' in (folder/'host-logo.log').read_text(encoding='utf8')
    assert 'LoginClass visible=true children=1' in (folder/'startup-state.txt').read_text(encoding='utf8')
    assert not (folder/'boot-errors.log').exists()
    image=Image.open(folder/'startup.png').convert('RGB')
    colors=image.resize((96,64)).getdata()
    assert sum(max(pixel)>40 for pixel in colors)>2000,'Startup stayed black'
    image.save(root/'build/real-startup-login.png')
print('REAL_STARTUP_PASSED normal boot, visible login, no startup error, screenshot is not black; private settings only')
