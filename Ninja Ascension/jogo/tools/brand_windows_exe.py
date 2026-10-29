"""Apply the exact game icon to an existing PE; keep a recoverable original."""
import ctypes,struct,shutil
from pathlib import Path
import game_branding
root=game_branding.ROOT
exe=root/'build/windows-release/bin/NinjaResourceProbe/Release/NinjaResourceProbe.exe'
backup=root/'build/branding-before/NinjaResourceProbe.exe'
backup.parent.mkdir(parents=True,exist_ok=True)
if not backup.exists():shutil.copy2(exe,backup)
raw=exe.read_bytes();old=b'Ninja Revolution - M1 resource probe\0';new=b'NinjaAscension\0'
if old in raw:
    assert raw.count(old)==1
    exe.write_bytes(raw.replace(old,new+b'\0'*(len(old)-len(new))))
elif new not in raw:raise RuntimeError('Game window title string not found')
icon=game_branding.prepare().read_bytes();reserved,kind,count=struct.unpack_from('<HHH',icon)
assert kind==1
kernel=ctypes.WinDLL('kernel32',use_last_error=True)
kernel.BeginUpdateResourceW.argtypes=[ctypes.c_wchar_p,ctypes.c_int];kernel.BeginUpdateResourceW.restype=ctypes.c_void_p
kernel.UpdateResourceW.argtypes=[ctypes.c_void_p,ctypes.c_void_p,ctypes.c_void_p,ctypes.c_ushort,ctypes.c_void_p,ctypes.c_uint];kernel.UpdateResourceW.restype=ctypes.c_int
kernel.EndUpdateResourceW.argtypes=[ctypes.c_void_p,ctypes.c_int];kernel.EndUpdateResourceW.restype=ctypes.c_int
handle=kernel.BeginUpdateResourceW(str(exe),False)
if not handle:raise ctypes.WinError(ctypes.get_last_error())
def update(kind,name,data):
    value=ctypes.create_string_buffer(data)
    text=ctypes.c_wchar_p(name) if isinstance(name,str) else None
    pointer=ctypes.cast(text,ctypes.c_void_p) if text else ctypes.c_void_p(name)
    if not kernel.UpdateResourceW(handle,ctypes.c_void_p(kind),pointer,0,value,len(data)):raise ctypes.WinError(ctypes.get_last_error())
try:
    group=bytearray(struct.pack('<HHH',0,1,count))
    for index in range(count):
        offset=6+16*index
        width,height,colors,reserved,planes,bits,size,position=struct.unpack_from('<BBBBHHII',icon,offset)
        update(3,index+1,icon[position:position+size])
        group.extend(struct.pack('<BBBBHHIH',width,height,colors,reserved,planes,bits,size,index+1))
    update(14,1,bytes(group));update(14,'GLFW_ICON',bytes(group))
except BaseException:
    kernel.EndUpdateResourceW(handle,True);raise
if not kernel.EndUpdateResourceW(handle,False):raise ctypes.WinError(ctypes.get_last_error())
print('WINDOWS_GAME_BRANDED NinjaAscension; shell and GLFW icons updated')
