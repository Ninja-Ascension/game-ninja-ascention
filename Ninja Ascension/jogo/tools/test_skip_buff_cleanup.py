"""Exercise the real delayed cleanup with live, removed and replaced effects."""
import ctypes
from pathlib import Path

root = Path(__file__).resolve().parents[1]
source = root / '01_conteudo_apk/assets/src/client/battle/landscape/FightRole.lua'
text = source.read_text(encoding='utf8')
helper = text[text.index('local function scheduleBuffCleanup('):text.index('local function deleteEffectFile(')]
script = helper + r'''
local services={}
fwin={addService=function(_,s) services[#services+1]=s end}
local role={parent={},buffEffectList={},calls=0}
function role:cleanBuffStateWithType(t)
 self.calls=self.calls+1;self.cleaned=t;self.buffEffectList[t]=nil
end
local function schedule(effect)
 role.buffEffectList['137']=effect
 scheduleBuffCleanup(role,effect,'137',1.5)
 return services[#services]
end
local live=schedule({});live.callback(live.params)
assert(role.calls==1 and role.cleaned=='137','Live cleanup did not run')
local removed=schedule({});removed.params.cancelled=true
removed.callback(removed.params);assert(role.calls==1,'Cancelled cleanup ran')
local exited=schedule({});role.parent=nil
exited.callback(exited.params);assert(role.calls==1,'Closed battle cleanup ran')
role.parent={}
local replaced=schedule({});role.buffEffectList['137']={}
replaced.callback(replaced.params);assert(role.calls==1,'Old timer removed a replacement buff')
local destroyed={};local delayed=schedule(destroyed)
role.buffEffectList['137']=nil
setmetatable(destroyed,{__index=function() error('Released effect was accessed') end})
delayed.callback(delayed.params);assert(role.calls==1)
'''
lua = ctypes.CDLL(str(root/'build/windows-release/bin/NinjaResourceProbe/Release/lua51.dll'))
lua.luaL_newstate.restype=ctypes.c_void_p
lua.luaL_openlibs.argtypes=[ctypes.c_void_p]
lua.luaL_loadstring.argtypes=[ctypes.c_void_p,ctypes.c_char_p]
lua.luaL_loadfile.argtypes=[ctypes.c_void_p,ctypes.c_char_p]
lua.lua_pcall.argtypes=[ctypes.c_void_p,ctypes.c_int,ctypes.c_int,ctypes.c_int]
lua.lua_tolstring.argtypes=[ctypes.c_void_p,ctypes.c_int,ctypes.c_void_p]
lua.lua_tolstring.restype=ctypes.c_char_p
lua.lua_settop.argtypes=[ctypes.c_void_p,ctypes.c_int]
lua.lua_close.argtypes=[ctypes.c_void_p]
state=lua.luaL_newstate()
try:
    lua.luaL_openlibs(state)
    status=lua.luaL_loadfile(state,str(source).encode())
    if status:raise AssertionError(lua.lua_tolstring(state,-1,None).decode('utf8','replace'))
    lua.lua_settop(state,0)
    status=lua.luaL_loadstring(state,script.encode())
    if not status:status=lua.lua_pcall(state,0,0,0)
    if status:raise AssertionError(lua.lua_tolstring(state,-1,None).decode('utf8','replace'))
finally:
    lua.lua_close(state)
assert text.count('scheduleBuffCleanup(v, armatureEffect,')==7
assert 'if cleanup then cleanup.cancelled = true end' in text
print('SKIP_BUFF_CLEANUP_PASSED live, cancelled, exited, replaced, released; Lua 5.1 compiled')
