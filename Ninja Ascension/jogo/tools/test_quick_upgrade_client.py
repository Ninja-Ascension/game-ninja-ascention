"""Execute original Lua selector and request wrappers in the shipped Lua VM."""
import ctypes,json
from pathlib import Path
root=Path(__file__).resolve().parents[1]
source=json.dumps((root/'01_conteudo_apk/assets/src/client/packs/hero/SmAutoUpgrade.lua').as_posix())
shop=json.dumps((root/'port/lua/shop_local.lua').as_posix())
script=fr'''
local terminals={{}}
state_machine={{add=function(t) terminals[t._name]=t end,init=function() end}}
Window={{}};function class() return {{super={{ctor=function() end}}}} end
assert(loadfile({source}))()
local widget={{setTouchEnabled=function() end,setHighlighted=function() end,setPercent=function(_,p) assert(p==p and p>=0 and p<=100) end,setString=function() end,setColor=function() end}}
ccui={{Helper={{seekWidgetByName=function() return widget end}}}}
cc={{c3b=function() end}}
_quality_color={{{{0,0,0}},{{0,0,0}}}}
zstring={{tonumber=function(v) return tonumber(v) or 0 end}}
ship_mould={{ability=9}};dms={{ship_mould={{}},ship_experience_param={{}}}}
dms.int=function(t) if t==dms.ship_mould then return 14 else return 100 end end
_ED={{user_info={{user_grade='20'}}}}
local object=setmetatable({{}},{{__index=SmAutoUpgrade}});object:ctor()
object.roots={{{{}}}};object._choose_ship={{ship_id='100013',ship_grade='1',ship_template_id='13',exprience='0'}}
object._max_level=100;object._chooseProps={{'243'}};object._totalPropsInfo={{['243']={{count=3,exp=100,index=1}}}}
object:updateCurrentMaxLevel();assert(object._current_max_level==4,'reachable level overwritten')
object:setSelectNum(15);assert(object._current_level==4 and object._choosePropsCount['243']==3)
object._totalPropsInfo['243'].count=100;object:updateCurrentMaxLevel()
assert(object._current_max_level==20,'account cap ignored')
object:setSelectNum(10);assert(object._choosePropsCount['243']==9)
fundPropWidthId=function(id) assert(id=='243');return {{user_prop_id='1000243'}} end
protocol_command={{ship_escalate={{code=33}},equipment_escalate={{code=25}},treasure_escalate={{code=34}},treasure_onekey_escalate={{code=6366}},equipment_up_star={{code=100}},equipment_harden={{code=101}},equipment_harden_replace={{code=102}},equipment_harden_locking={{code=103}}}}
NetworkManager={{register=function(_,code) assert(code==33) end}}
terminals.sm_auto_upgrade_sure._invoke(nil,object)
assert(protocol_command.ship_escalate.param_list=='0\r\n100013\r\n1000243:9\r\n10','fast request has wrong fields')
object._choose_ship.ship_grade='20';object._max_level=20;object:updateCurrentMaxLevel();object:setSelectNum(20)
assert(object._current_level==20,'at-cap selector invalid')
NetworkProtocol={{protocol_parses={{}},find_parser=function() return true end,__nr_power=true}}
for name,command in pairs(protocol_command) do
 command.command_fun=function(seq) return seq..'\r\n'..name..'\r\n1\r\n'..(command.param_list or '100013\r\n0\r\n1\r\n1\r\n10') end
end
local adapter=assert(loadfile({shop}))();adapter.install()
for _,name in ipairs({{'ship_escalate','equipment_escalate','treasure_escalate','treasure_onekey_escalate','equipment_up_star','equipment_harden','equipment_harden_replace','equipment_harden_locking'}}) do
 local request=protocol_command[name].command_fun('2')
 assert(request:match('\r\n%d+:%d+:%d+$'),'missing durable request id: '..name)
 assert(request~=protocol_command[name].command_fun('2'),'new clicks reused request id')
end
print('QUICK_UPGRADE_CLIENT_PASSED reachable levels, player cap, material selection, real request fields, durable request IDs')
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
