"""Execute real Lua choice/gate code; syntax-check every changed Lua module."""
import ctypes
import json
from pathlib import Path

root=Path(__file__).resolve().parents[1]
lua=ctypes.CDLL(str(root/'build/windows-release/bin/NinjaResourceProbe/Release/lua51.dll'))
lua.luaL_newstate.restype=ctypes.c_void_p
lua.luaL_openlibs.argtypes=[ctypes.c_void_p]
lua.luaL_loadstring.argtypes=[ctypes.c_void_p,ctypes.c_char_p]
lua.lua_pcall.argtypes=[ctypes.c_void_p,ctypes.c_int,ctypes.c_int,ctypes.c_int]
lua.lua_tolstring.argtypes=[ctypes.c_void_p,ctypes.c_int,ctypes.c_void_p]
lua.lua_tolstring.restype=ctypes.c_char_p
lua.lua_close.argtypes=[ctypes.c_void_p]
files=['port/lua/initial_tutorial.lua','port/lua/tutorial_disabled.lua','port/lua/shop_local.lua',
       'port/lua/esconder_dialogos.lua','port/lua/tutorial_battle_skip.lua','port/lua/tutorial_guide_visual.lua',
       'src/client/mission/TutorialSkip.lua','port/lua/menu_boot_probe.lua',
       'src/client/mission/Mission.lua','src/client/protocol/ProtocolCommander.lua',
       'src/client/protocol/ProtocolCommanderCopyExxx.lua']
script='package.path='+json.dumps((root/'port/lua/?.lua').as_posix())+'..";"..package.path\n'
script+='assert(loadfile('+json.dumps((root/'src/cocos/cocos2d/json.lua').as_posix())+'))()\n'
script+=r'''
cc={c4b=function(...) return {...} end,UserDefault={getInstance=function() return {getIntegerForKey=function() return 1 end} end}}
_ED={user_info={user_id='77',user_grade='1',user_experience='0'}}
local invokes,exits=0,0
state_machine={_terminals={tuition_test={_invoke=function() invokes=invokes+1;return 'invoked' end}},
 find=function() return true end,excute=function() exits=exits+1 end}
executeMissionExt=function(...) return 'original' end
missionIsOver=function() return true end
mission_mould_tuition='tuition';mission_mould_battle='battle'
NetworkProtocol={protocol_parses={},find_parser=function(code)
 for _,v in ipairs(NetworkProtocol.protocol_parses) do if v.code==code then return v end end
end}
protocol_command={tutorial_skip={code=9993}}
function npos(list) local v=list[list.pos];list.pos=list.pos+1;return v end
local gate=require('tutorial_disabled');gate.install()
assert(executeMissionExt('tuition')==false)
assert(state_machine._terminals.tuition_test._invoke()==false)
local initial=require('initial_tutorial');initial.install();initial.install()
assert(#NetworkProtocol.protocol_parses==1)
local parser=NetworkProtocol.find_parser(15989).parser_fun
parser(nil,nil,nil,nil,{'choice',pos=1})
assert(gate.enabled and executeMissionExt('tuition')=='original')
assert(state_machine._terminals.tuition_test._invoke()=='invoked' and invokes==1)
parser(nil,nil,nil,nil,{'legacy',pos=1})
assert(not gate.enabled and executeMissionExt('tuition')==false)
parser(nil,nil,nil,nil,{'playing',pos=1})
assert(gate.enabled and executeMissionExt('tuition')=='original')
parser(nil,nil,nil,nil,{'completed',pos=1})
assert(not gate.enabled and exits==1)
assert(protocol_command.tutorial_start.command_fun('19')=='19\r\ntutorial_start\r\n77')
Window={};class=function() return {} end
local closed=0
fwin={find=function() return {} end,close=function() closed=closed+1 end}
local callback,requested
NetworkManager={register=function(_,code,_,_,_,_,cb) requested=code;callback=cb end}
'''
script+='assert(loadfile('+json.dumps((root/'src/client/mission/TutorialSkip.lua').as_posix())+'))()\n'
script+=r'''
local replayed=0
TutorialSkip.pending={'pending',nil,nil,nil,nil,'l1e0',true}
TutorialSkip.original=function(...) replayed=replayed+1;assert(select('#',...)==7) end
TutorialSkip.newbie()
assert(requested==9992 and TutorialSkip.busy and replayed==0 and closed==0)
callback({RESPONSE_SUCCESS=false,PROTOCOL_STATUS=-1})
assert(not TutorialSkip.busy and TutorialSkip.pending and closed==0)
TutorialSkip.newbie()
initial.apply('playing')
callback({RESPONSE_SUCCESS=true,PROTOCOL_STATUS=0})
assert(replayed==1 and closed==1 and TutorialSkip.pending==nil and not TutorialSkip.busy)
_ED.user_info.user_id='88';initial.apply('legacy')
assert(not gate.enabled and initial.state=='legacy' and TutorialSkip.profile=='88')
assert(not pcall(initial.apply,'untrusted_state'))
'''
script+='\n'.join('assert(loadfile('+json.dumps((root/f).as_posix())+'))' for f in files)
state=lua.luaL_newstate()
try:
    lua.luaL_openlibs(state)
    status=lua.luaL_loadstring(state,script.encode())
    if not status:status=lua.lua_pcall(state,0,0,0)
    if status:raise AssertionError(lua.lua_tolstring(state,-1,None).decode('utf8','replace'))
finally:lua.lua_close(state)
print('INITIAL_TUTORIAL_CLIENT_PASSED server states, account switch, retry, deferred choice, Lua 5.1 compilation')
