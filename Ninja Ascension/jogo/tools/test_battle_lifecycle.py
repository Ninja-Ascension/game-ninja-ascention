"""LuaJIT tests of battle-scoped preload and actor identity contracts."""
from pathlib import Path
import ctypes,json
root=Path(__file__).resolve().parents[1]
module=json.dumps((root/'port/lua/battle_lifecycle.lua').as_posix())
writable=json.dumps((root/'build').as_posix()+'/')
script=f'''
local tutorial={{enabled=true}}
package.preload.tutorial_disabled=function() return tutorial end
cc={{FileUtils={{getInstance=function() return {{getWritablePath=function() return {writable} end}} end}}}}
local modules={{}};app={{load=function(name) modules[name]=true end}}
local adapter=assert(loadfile({module}))()
local opened=0
local loader={{loadingActivity=function(self) opened=opened+1;self.isLoadActivity=true end,
 loadingFormation=function(self) opened=opened+1;self.isLoadFormation=true end}}
function loader:checkLoginLoading(base,loginIn)
 self:loadingActivity();self:loadingFormation()
 if self.fail then error('original failure') end
 return 'preserved'
end
adapter.installLoading(loader)
assert(loader:checkLoginLoading({{__cname='FightLoadingCellClass'}},false)=='preserved')
assert(opened==0 and modules['client.activity.ActivityWindow'] and modules['client.formation.FormationTigerGate'])
assert(loader.isLoadActivity and loader.isLoadFormation and not loader.__nr_preloading_battle)
loader:checkLoginLoading(nil,true);assert(opened==2,'normal menu preload changed')
tutorial.enabled=false
loader:checkLoginLoading(nil,true);assert(opened==2,'disabled tutorial opened menu preload windows')
tutorial.enabled=true
loader.fail=true
assert(not pcall(loader.checkLoginLoading,loader,{{__cname='FightLoadingCellClass'}},false))
assert(not loader.__nr_preloading_battle,'scope leaked after exception')
loader.fail=false
local peer={{loadingActivity=function() error('stale copied method') end}}
LoginLoading=loader
local battleLoader={{onAddLoginLoading=function(self) self.LoginLoading=peer end}}
adapter.installBattleLoader(battleLoader)
battleLoader:onAddLoginLoading()
peer:checkLoginLoading({{}},false)
assert(peer.isLoadActivity and peer.isLoadFormation,'native peer kept stale preload methods')
local actor={{}}
local called=0
local controller={{_hero_formation={{['1']=actor}},_master_formation={{['2']=actor}},
 initHero=function() error('original construction failure') end,
 executeCurrentSelectRoleFightDataAddAttacker=function(self,data)
  called=called+1
  assert(type(data.attacker)=='string' and type(data.attackerPos)=='string')
  return 'action preserved'
 end}}
adapter.installRoles(controller)
local constructed,constructionError=pcall(controller.initHero,controller)
assert(not constructed and constructionError:find('original construction failure',1,true))
assert(controller:executeCurrentSelectRoleFightDataAddAttacker({{attacker=0,attackerPos=1}})=='action preserved')
controller:executeCurrentSelectRoleFightDataAddAttacker({{attacker='1',attackerPos='2'}})
_ED={{battleData={{_heros={{['1']={{}}}},_armys={{}}}}}}
local ok,err=pcall(controller.executeCurrentSelectRoleFightDataAddAttacker,controller,{{attacker='1',attackerPos='3'}})
assert(not ok and err:find('Missing actor camp=1 seat=3',1,true))
assert(called==2,'missing actor action was silently executed')
print('BATTLE_LIFECYCLE_PASSED preload scope, normal menu, exception cleanup, actor identities, missing-actor evidence')
'''
lua=ctypes.CDLL(str(root/'build/windows-probe-native/bin/NinjaResourceProbe/Debug/lua51.dll'))
lua.luaL_newstate.restype=ctypes.c_void_p
lua.luaL_openlibs.argtypes=[ctypes.c_void_p]
lua.luaL_loadstring.argtypes=[ctypes.c_void_p,ctypes.c_char_p]
lua.lua_pcall.argtypes=[ctypes.c_void_p,ctypes.c_int,ctypes.c_int,ctypes.c_int]
lua.lua_tolstring.argtypes=[ctypes.c_void_p,ctypes.c_int,ctypes.c_void_p]
lua.lua_tolstring.restype=ctypes.c_char_p
lua.lua_close.argtypes=[ctypes.c_void_p]
state=lua.luaL_newstate()
try:
    lua.luaL_openlibs(state)
    code=lua.luaL_loadstring(state,script.encode())
    if not code:code=lua.lua_pcall(state,0,0,0)
    if code:raise AssertionError(lua.lua_tolstring(state,-1,None).decode('utf-8','replace'))
finally:lua.lua_close(state)
