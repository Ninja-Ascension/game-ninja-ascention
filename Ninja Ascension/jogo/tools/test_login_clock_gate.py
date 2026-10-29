"""Run the actual clock parser and the feature gate from the Android error."""
import json
import test_mobile_bootstrap as vm
lua=vm.lua
p=vm.root/'01_conteudo_apk/assets/src'
s=(p/'client/protocol/ProtocolParserCopyExx.lua').read_text(encoding='utf-8')
a=s.index('function parse_return_system_time(');clock=s[a:].split('\nfunction ',1)[0]
s=(p/'client/loader/EnvironmentDatas.lua').read_text(encoding='utf-8');a=s.index('function funOpenDrawTip(');gate=s[a:s.index('function funOpenDrawTipEX',a)]
script=r'''
_ED={user_info={user_grade=100},vip_grade=0,union={union_info={union_grade=1}}}
function npos(list) local v=list[list.pos];list.pos=list.pos+1;return v end
CLOCK
GATE
local now=os.time()*1000
local list={tostring(now),tostring(now-86400000*3),pos=1}
parse_return_system_time(nil,nil,nil,nil,list)
assert(list.pos==3 and _ED.system_time and _ED.open_server_time and _ED.native_time)
__lua_project_id=7;__lua_project_l_naruto=7
zstring={tonumber=tonumber}
fun_open_condition={level=1,vip_level=2,scene_id=3,npc_id=4,open_day=5,union_level=6}
local row={15,0,0,0,2,0}
dms={fun_open_condition={},element=function() return row end,atoi=function(r,k) return r[k] end}
assert(funOpenDrawTip(82,false)==false,'three-day-old server feature stayed locked')
_ED.open_server_time=tostring(now)
assert(funOpenDrawTip(82,false)==true,'day gate was bypassed')
_ED.open_server_time=tostring(now-86400000*3);_ED.user_info.user_grade=1
assert(funOpenDrawTip(82,false)==true,'level gate was bypassed')
print('LOGIN_CLOCK_GATE_PASSED real clock parser and union gate: no nil arithmetic; server-age and level limits respected')
'''.replace('CLOCK',clock,1).replace('GATE',gate,1)
state=lua.luaL_newstate()
try:
 lua.luaL_openlibs(state);status=lua.luaL_loadstring(state,script.encode())
 if not status:status=lua.lua_pcall(state,0,0,0)
 if status:raise AssertionError(lua.lua_tolstring(state,-1,None).decode())
finally:lua.lua_close(state)


