import os,subprocess,tempfile
from pathlib import Path
r=Path(__file__).resolve().parents[1]
with tempfile.TemporaryDirectory(prefix='shop-scroll-',dir=r/'build',ignore_cleanup_errors=True) as t:
 env={k:v for k,v in os.environ.items() if not k.startswith('NR_')};env.update(NR_GAME_ROOT=str(r),NR_PROBE_WRITABLE=t,NR_ENABLE_TUTORIAL='0',NR_PROBE_SHOP_SCROLL='1',NR_PROBE_STARTUP_SHOT=str(Path(t)/'s.png'))
 p=subprocess.run([str(r/'build/windows-release/bin/NinjaResourceProbe/Release/NinjaResourceProbe.exe')],cwd=r,env=env,capture_output=True,timeout=25)
 state=Path(t)/'scroll-state.txt';print(state.read_text(encoding='utf8') if state.exists() else 'NO STATE')
 (r/'build/shop-scroll-native.png').write_bytes((Path(t)/'s.png').read_bytes())
 (r/'build/shop-scroll-native.log').write_bytes(p.stdout+p.stderr)
