"""Android asset config path with the original Lua JSON decoder and no PC globals."""
import ctypes,json
from montar_apk import gameplay_lua
from pathlib import Path
root=Path(__file__).resolve().parents[1]
module=json.dumps((root/'port/lua/tutorial_disabled.lua').as_posix())
decoder=json.dumps((root/'01_conteudo_apk/assets/src/cocos/cocos2d/json.lua').as_posix())
hero=json.dumps((root/'port/lua/hero_ui_compat.lua').as_posix())
packed=gameplay_lua().decode()
script=fr'''
assert(loadfile({decoder}))()
assert(type(json.decode)=='function')
local originalGetenv=os.getenv
os.getenv=function() return nil end
cc={{FileUtils={{getInstance=function() return {{getStringFromFile=function(_,path)
 assert(path=='src/port/gameplay.json');return '{{"tutorial_enabled":false,"account_reset_version":1}}'
end}} end}},PLATFORM_OS_ANDROID=3,Application={{getInstance=function() return {{getTargetPlatform=function() return 3 end}} end}}}}
local chunk=assert(loadfile({module}))
-- Android's APK loader exposes a short chunk name, not a filesystem path.
local file=assert(io.open({module},'r'));local text=file:read('*a');file:close()
local adapter=assert(loadstring(text,'@tutorial_disabled.lua'))()
assert(adapter.enabled==false)
-- Reproduce the failure reported on BlueStacks: FileUtils returns no JSON.
cc.FileUtils.getInstance=function() return {{getStringFromFile=function() return '' end}} end
package.preload.nr_gameplay_config=assert(loadstring([====[{packed}]====]))
local decoded=json.decode(require('nr_gameplay_config'))
adapter=assert(loadstring(text,'@tutorial_disabled.lua'))()
assert(adapter.enabled==false and decoded.account_reset_version==1)
assert(decoded.tutorial_enabled==false and decoded.starter_moulds[1]==13)
-- Installation must also complete, with account settings preserved.
cc.UserDefault={{getInstance=function() return {{
 getIntegerForKey=function() return 1 end,
 setStringForKey=function() error('existing login was changed') end,
 setIntegerForKey=function() error('existing version was changed') end,
 flush=function() error('existing settings were written') end
}} end}}
adapter.install()
package.preload.nr_gameplay_config=nil;package.loaded.nr_gameplay_config=nil
local missing,reason=pcall(assert(loadstring(text,'@tutorial_disabled.lua')))
assert(not missing and tostring(reason):find('gameplay.json ausente'))
local renderer=assert(loadfile({hero}))()
renderer.install();assert(cc.setGray==nil,'Android replaced with Axmol renderer')
os.getenv=originalGetenv
print('MOBILE_BOOTSTRAP_PASSED original JSON parser, APK-only config, tutorial disabled, native Android renderer preserved')
'''
lua=ctypes.CDLL(str(root/'build/windows-release/bin/NinjaResourceProbe/Release/lua51.dll'))
lua.luaL_newstate.restype=ctypes.c_void_p
lua.luaL_openlibs.argtypes=[ctypes.c_void_p]
lua.luaL_loadstring.argtypes=[ctypes.c_void_p,ctypes.c_char_p]
lua.lua_pcall.argtypes=[ctypes.c_void_p,ctypes.c_int,ctypes.c_int,ctypes.c_int]
lua.lua_tolstring.argtypes=[ctypes.c_void_p,ctypes.c_int,ctypes.c_void_p];lua.lua_tolstring.restype=ctypes.c_char_p
lua.lua_close.argtypes=[ctypes.c_void_p]
state=lua.luaL_newstate()
try:
    lua.luaL_openlibs(state);status=lua.luaL_loadstring(state,script.encode())
    if not status:status=lua.lua_pcall(state,0,0,0)
    if status:raise AssertionError(lua.lua_tolstring(state,-1,None).decode('utf8','replace'))
finally:lua.lua_close(state)
