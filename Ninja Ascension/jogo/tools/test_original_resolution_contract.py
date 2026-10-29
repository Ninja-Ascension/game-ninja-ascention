"""Original geometry and Android viewport ownership regression."""
import ctypes,json
from pathlib import Path
root=Path(__file__).resolve().parents[1]
dll=ctypes.CDLL(str(root/'build/windows-release/bin/NinjaResourceProbe/Release/lua51.dll'))
dll.luaL_newstate.restype=ctypes.c_void_p
dll.luaL_openlibs.argtypes=[ctypes.c_void_p]
dll.luaL_loadstring.argtypes=[ctypes.c_void_p,ctypes.c_char_p]
dll.lua_pcall.argtypes=[ctypes.c_void_p,ctypes.c_int,ctypes.c_int,ctypes.c_int]
dll.lua_tolstring.argtypes=[ctypes.c_void_p,ctypes.c_int,ctypes.c_void_p];dll.lua_tolstring.restype=ctypes.c_char_p
dll.lua_close.argtypes=[ctypes.c_void_p]
module=json.dumps((root/'port/lua/desktop_layout.lua').as_posix())
saga=json.dumps((root/'port/lua/saga_layout.lua').as_posix())
script=r'''
local platform=1
local calls=0
local view={setDesignResolutionSize=function(_,w,h,policy)
 assert(w==960 and h==640 and policy==2);calls=calls+1
end}
cc={PLATFORM_OS_ANDROID=3,PLATFORM_OS_IPHONE=4,PLATFORM_OS_IPAD=5,
 Application={getInstance=function() return {getTargetPlatform=function() return platform end} end},
 Director={getInstance=function() return {getOpenGLView=function() return view end,getVisibleSize=function() return {width=960,height=640} end} end},
 ResolutionPolicy={SHOW_ALL=2},Label={}}
ccui={Text={},Button={}};tolua={isnull=function() return false end};csb={createNode=function() end}
-- Deliberately no scheduler: resizing must not run per-screen transformations.
app={}
for _,value in ipairs({1,3}) do
 platform=value
 local layout=assert(loadfile(MODULE))();layout.install();layout.install()
 assert(calls==1,'Android changed the native viewport or install repeated')
 local node=setmetatable({},{__index=function(_,key) error('Unexpected geometry mutation/read '..key) end})
 layout.preserve(node)
 layout.apply(node,{ninjaList=true},1280)
 layout.apply(node,{saga=true},1280)
 assert(layout.aspectCorrection()==1)
end
local saga=assert(loadfile(SAGA))();saga.fit({})
'''.replace('MODULE',module).replace('SAGA',saga)
state=dll.luaL_newstate()
try:
 dll.luaL_openlibs(state)
 status=dll.luaL_loadstring(state,script.encode())
 if not status:status=dll.lua_pcall(state,0,0,0)
 if status:raise AssertionError(dll.lua_tolstring(state,-1,None).decode('utf8','replace'))
finally:dll.lua_close(state)
for path in [root/'port/lua/desktop_layout.lua',root/'port/lua/saga_layout.lua']:
 state=dll.luaL_newstate()
 try:
  status=dll.luaL_loadstring(state,path.read_bytes())
  if status:raise AssertionError(dll.lua_tolstring(state,-1,None).decode('utf8','replace'))
 finally:dll.lua_close(state)
print('ORIGINAL_RESOLUTION_CONTRACT_PASSED PC uniform canvas, Android native scale, no card/Saga distortion; Lua 5.1 syntax valid')
