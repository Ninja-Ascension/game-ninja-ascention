"""Real Release startup at three window shapes, with private settings only."""
import ctypes,os,subprocess,tempfile,time
from ctypes import wintypes
from pathlib import Path
from PIL import Image
root=Path(__file__).resolve().parents[1]
user=ctypes.windll.user32
callback=ctypes.WINFUNCTYPE(wintypes.BOOL,wintypes.HWND,wintypes.LPARAM)
user.GetWindowThreadProcessId.argtypes=[wintypes.HWND,ctypes.POINTER(wintypes.DWORD)]
user.SetWindowPos.argtypes=[wintypes.HWND,wintypes.HWND,ctypes.c_int,ctypes.c_int,ctypes.c_int,ctypes.c_int,ctypes.c_uint]
exe=root/'build/windows-release/bin/NinjaResourceProbe/Release/NinjaResourceProbe.exe'
for width,height in [(960,640),(1280,720),(800,600)]:
 with tempfile.TemporaryDirectory(prefix='original-resolution-',dir=root/'build',ignore_cleanup_errors=True) as temp:
  temp=Path(temp)
  env={k:v for k,v in os.environ.items() if not k.startswith('NR_')}
  env.update(NR_GAME_ROOT=str(root),NR_PROBE_WRITABLE=str(temp),NR_ENABLE_TUTORIAL='0',NR_PROBE_STARTUP_SHOT=str(temp/'screen.png'))
  proc=subprocess.Popen([str(exe)],cwd=root,env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
  handles=[]
  @callback
  def visit(hwnd,param):
   pid=wintypes.DWORD();user.GetWindowThreadProcessId(hwnd,ctypes.byref(pid))
   if pid.value==proc.pid and user.IsWindowVisible(hwnd): handles.append(hwnd)
   return True
  deadline=time.monotonic()+4
  while not handles and time.monotonic()<deadline:
   user.EnumWindows(visit,0);time.sleep(.05)
  assert handles,'Native test window missing'
  rect=wintypes.RECT();client=wintypes.RECT()
  user.GetWindowRect(handles[0],ctypes.byref(rect));user.GetClientRect(handles[0],ctypes.byref(client))
  extraX=rect.right-rect.left-client.right;extraY=rect.bottom-rect.top-client.bottom
  assert user.SetWindowPos(handles[0],None,0,0,width+extraX,height+extraY,0x0016)
  output=proc.communicate(timeout=25)[0]
  (root/f'build/original-resolution-{width}x{height}.log').write_bytes(output)
  assert proc.returncode==0,proc.returncode
  assert 'ok=true' in (temp/'host-logo.log').read_text(encoding='utf8')
  assert not (temp/'boot-errors.log').exists()
  image=Image.open(temp/'screen.png').convert('RGB')
  # Axmol captureScreen exports the rendered viewport, excluding letterboxes.
  factor=min(width/960,height/640)
  expected=(round(960*factor),round(640*factor))
  assert abs(image.width-expected[0])<=1 and abs(image.height-expected[1])<=1,(image.size,expected)
  assert abs(image.width/image.height-1.5)<.004,'Original proportions changed'
  image.save(root/f'build/original-resolution-{width}x{height}.png')
  print('ORIGINAL_RESOLUTION_NATIVE_PASSED',width,height,'uniform canvas 960x640')
