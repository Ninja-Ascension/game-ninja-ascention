"""Exercise tutorial-screen cleanup without opening the production database."""
import ctypes
from pathlib import Path
import json

root = Path(__file__).resolve().parents[1]
out = root / "build" / "tutorial-screen-guard-test"
out.mkdir(parents=True, exist_ok=True)
log = out / "initial-tutorial-screen.log"
if log.exists():
    log.unlink()

lua = ctypes.CDLL(str(root / "build/windows-release/bin/NinjaResourceProbe/Release/lua51.dll"))
lua.luaL_newstate.restype = ctypes.c_void_p
lua.luaL_openlibs.argtypes = [ctypes.c_void_p]
lua.luaL_loadstring.argtypes = [ctypes.c_void_p, ctypes.c_char_p]
lua.luaL_loadstring.restype = ctypes.c_int
lua.lua_pcall.argtypes = [ctypes.c_void_p, ctypes.c_int, ctypes.c_int, ctypes.c_int]
lua.lua_pcall.restype = ctypes.c_int
lua.lua_tolstring.argtypes = [ctypes.c_void_p, ctypes.c_int, ctypes.c_void_p]
lua.lua_tolstring.restype = ctypes.c_char_p
lua.lua_close.argtypes = [ctypes.c_void_p]

script = "package.path=" + json.dumps((root / "port/lua/?.lua").as_posix() + ";") + " .. package.path\n"
script += "local logRoot=" + json.dumps(out.as_posix() + "/") + "\n"
script += r'''
cc={FileUtils={getInstance=function() return {getWritablePath=function() return logRoot end} end}}
require('package')
package.loaded.initial_tutorial={state='playing'}
local windows={}
fwin={_list=windows}
function fwin:find(name)
    for _,w in ipairs(self._list) do if w.__cname==name then return w end end
end
function fwin:close(target)
    for i,w in ipairs(self._list) do if w==target then table.remove(self._list,i);return end end
end
function fwin:addService(service) service.callback() end
local guard=require('tutorial_screen_guard')
local home={__cname='HomeHeroClass',visible=true,isVisible=function(self) return self.visible end}
local fight={__cname='FightClass',visible=true,isVisible=function(self) return self.visible end}
windows[1]=home;windows[2]=fight
local entered=0
local HomeHero={onEnterTransitionFinish=function() entered=entered+1 end}
guard.installHomeHero(HomeHero)
HomeHero.onEnterTransitionFinish(home)
assert(entered==1,'original character-screen callback was not preserved')
assert(fwin:find('HomeHeroClass')==nil,'character screen remained open over battle')
assert(fwin:find('FightClass')==fight,'battle window was closed with character screen')
windows[1]=home
local hiddenFight={__cname='FightClass',visible=false,isVisible=function(self) return self.visible end}
windows[2]=hiddenFight
HomeHero.onEnterTransitionFinish(home)
assert(fwin:find('HomeHeroClass')==home,'hidden preload fight was treated as an active battle')
windows[2]=nil
HomeHero.onEnterTransitionFinish(home)
assert(fwin:find('HomeHeroClass')==home,'character screen was closed outside battle')
local Tuition={showWindow=function() return 'shown' end,executeMission=function() return 'mission' end}
guard.installTuitionController(Tuition)
assert(Tuition:showWindow()=='shown')
assert(Tuition:executeMission()=='mission')
'''
state = lua.luaL_newstate()
try:
    lua.luaL_openlibs(state)
    code = lua.luaL_loadstring(state, script.encode())
    if not code:
        code = lua.lua_pcall(state, 0, 0, 0)
    if code:
        raise AssertionError(lua.lua_tolstring(state, -1, None).decode("utf-8", "replace"))
finally:
    lua.lua_close(state)

contents = log.read_text(encoding="utf-8")
assert "character-screen-entered-during-battle" in contents
assert "character-screen-entered-during-battle-closed" in contents
assert "tutorial-showWindow-begin" in contents and "tutorial-executeMission-end" in contents
print("TUTORIAL_SCREEN_GUARD_PASSED close-only-during-battle; original callback preserved; diagnostic log written")
