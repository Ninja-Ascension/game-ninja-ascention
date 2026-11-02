"""Execute real Lua choice/gate code; syntax-check every changed Lua module."""
import ctypes
import json
import os
from pathlib import Path

root=Path(__file__).resolve().parents[1]
build=Path(os.environ.get('NR_PROBE_BUILD',root/'build/windows-release'))
lua=ctypes.CDLL(str(build/'bin/NinjaResourceProbe/Release/lua51.dll'))
lua.luaL_newstate.restype=ctypes.c_void_p
lua.luaL_openlibs.argtypes=[ctypes.c_void_p]
lua.luaL_loadstring.argtypes=[ctypes.c_void_p,ctypes.c_char_p]
lua.lua_pcall.argtypes=[ctypes.c_void_p,ctypes.c_int,ctypes.c_int,ctypes.c_int]
lua.lua_tolstring.argtypes=[ctypes.c_void_p,ctypes.c_int,ctypes.c_void_p]
lua.lua_tolstring.restype=ctypes.c_char_p
lua.lua_close.argtypes=[ctypes.c_void_p]
files=['port/lua/initial_tutorial.lua','port/lua/tutorial_disabled.lua','port/lua/shop_local.lua',
       'port/lua/esconder_dialogos.lua','port/lua/tutorial_battle_skip.lua','port/lua/tutorial_guide_visual.lua',
       'port/lua/local_sdk_guest.lua','port/lua/intro_menu_transition.lua',
       'port/lua/tutorial_tap_wait.lua',
       'src/client/mission/TutorialSkip.lua','port/lua/menu_boot_probe.lua',
       'src/client/mission/Mission.lua','src/client/protocol/ProtocolCommander.lua',
       'src/client/protocol/ProtocolCommanderCopyExxx.lua',
       '01_conteudo_apk/assets/src/client/red_alert/battle/battle_loading.lua',
       '01_conteudo_apk/assets/src/client/login/LoginLoading.lua']
script='package.path='+json.dumps((root/'port/lua/?.lua').as_posix())+'..";"..package.path\n'
script+='assert(loadfile('+json.dumps((root/'src/cocos/cocos2d/json.lua').as_posix())+'))()\n'
script+=r'''
cc={c4b=function(...) return {...} end,UserDefault={getInstance=function() return {getIntegerForKey=function() return 1 end} end}}
_ED={user_info={user_id='77',user_grade='1',user_experience='0'}}
local invokes,exits,menuCalls=0,0,0
state_machine={_terminals={tuition_test={_invoke=function() invokes=invokes+1;return 'invoked' end}},
 find=function() return true end,excute=function(name) exits=exits+1;if name=='menu_window_open_mission' then menuCalls=menuCalls+1 end end}
local routedCalls={}
executeMissionExt=function(...) routedCalls[#routedCalls+1]={...};return 'original' end
local missionResets=0
resetMission=function(force) assert(force==true);missionResets=missionResets+1 end
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
local beforeRoute=#routedCalls
assert(executeMissionExt('tuition',nil,nil,nil,true,'l1e0',true)=='original')
assert(#routedCalls==beforeRoute+1 and routedCalls[#routedCalls][1]=='battle'
    and routedCalls[#routedCalls][6]=='1196v1','playing profile did not resume the original Itachi/Pain intro')
assert(missionResets==1,'stale Chakra lesson was not cleared before resuming the intro')
beforeRoute=#routedCalls
assert(executeMissionExt('tuition',nil,nil,nil,true,'l1e0',true)==true)
assert(#routedCalls==beforeRoute and missionResets==1,'intro route restarted after its first dispatch')
parser(nil,nil,nil,nil,{'completed',pos=1})
assert(not gate.enabled and exits==1 and not gate.introRouteStarted)
assert(protocol_command.tutorial_start.command_fun('19')=='19\r\ntutorial_start\r\n77')
Window={};class=function() return {} end
state_machine.add=function() end
state_machine.init=function() end
'''
login_loading=(root/'01_conteudo_apk/assets/src/client/login/LoginLoading.lua').read_text(encoding='utf8')
entry_start=login_loading.index('function LoginLoading:shouldEnterInitialBattle')
entry_end=login_loading.index('\nfunction LoginLoading:onInit',entry_start)
script+='LoginLoading={}\n'
script+='assert(loadstring('+json.dumps(login_loading[entry_start:entry_end])+'))()\n'
update_start=login_loading.index('function LoginLoading:onUpdate')
update_end=login_loading.index('\nfunction LoginLoading:checkLoginLoading',update_start)
script+='assert(loadstring('+json.dumps(login_loading[update_start:update_end])+'))()\n'
script+=r'''
assert(LoginLoading:shouldEnterInitialBattle()==false,
    'choice/completed/legacy profiles must enter normal login instead of the legacy battle loader')
initial.apply('playing')
assert(LoginLoading:shouldEnterInitialBattle()==true,
    'the active first tutorial battle must still use its tutorial loader')
initial.apply('skipped')
assert(LoginLoading:shouldEnterInitialBattle()==false,
    'skipped profiles must not reopen the legacy first battle')
_ED.user_info.user_id=''
assert(LoginLoading:shouldEnterInitialBattle()==true,
    'the original character-creation path must remain available without a user id')
_ED.user_info.user_id='77'
'''
gate_start=login_loading.index('function LoginLoading:checkLoginLoading')
gate_end=login_loading.index('\nfunction LoginLoading:loadingShipData',gate_start)
script+='loginLoadingTutorialTrace=function() end\nassert(loadstring('+json.dumps(login_loading[gate_start:gate_end])+'))()\n'
script+=r'''
local originalMissionExecute=executeMissionExt
local rejectedLoader={totalNum=8}
local rejectedFight={_unload=false}
assert(originalMissionExecute(mission_mould_tuition)==false,
    'The configured legacy tutorial gate should refuse this lesson before loading continues')
LoginLoading.checkLoginLoading(rejectedLoader,rejectedFight,false)
assert(rejectedLoader.totalNum==9 and rejectedFight._unload==false,
    'Rejected/disabled tutorial must not strand the battle loader at 9%')
local startedLoader={totalNum=8}
local startedFight={_unload=false}
executeMissionExt=function() return true end
LoginLoading.checkLoginLoading(startedLoader,startedFight,false)
assert(startedLoader.totalNum==9 and startedFight._unload==true,
    'A started tutorial must pause the battle loader until its mission callback resumes it')
local failedLoader={totalNum=8}
local failedFight={_unload=false}
executeMissionExt=function() error('simulated tutorial dispatch error') end
LoginLoading.checkLoginLoading(failedLoader,failedFight,false)
assert(failedLoader.totalNum==9 and failedFight._unload==false,
    'A tutorial dispatch error must leave the battle loader recoverable')
local choiceLoader={totalNum=8,isBeginLoad=true,_unload=false,basePosX=0,
    loadingBar={getContentSize=function() return {width=100} end,setPercent=function() end},
    Panel_loading_ing={setPositionX=function() end},Text_loading_02={setString=function() end}}
setmetatable(choiceLoader,{__index=LoginLoading})
local choiceShown=false
app={load=function(module) assert(module=='client.mission.TutorialSkip') end}
TutorialSkip={install=function() end,openWhenLoaded=function()
    choiceShown=true
    assert(TutorialSkip.pending[1]==mission_mould_tuition and TutorialSkip.pending[6]=='l1e0')
end}
fwin={find=function(_,name) return name=='TutorialSkipWindowClass' and choiceShown and {} or nil end}
initial.apply('choice')
LoginLoading.onUpdate(choiceLoader,0)
assert(choiceLoader._unload==true and choiceLoader.totalNum==9 and choiceShown,
    'normal login must directly show the tutorial choice at 8%, independent of mission-over state')
executeMissionExt=originalMissionExecute
local closed=0
fwin={find=function() return {} end,close=function() closed=closed+1 end}
local callback,requested
NetworkManager={register=function(_,code,_,_,_,_,cb) requested=code;callback=cb end}
'''
script+='assert(loadfile('+json.dumps((root/'src/client/mission/TutorialSkip.lua').as_posix())+'))()\n'
script+=r'''
local replayed,route=0,nil
TutorialSkip.pending={'pending',nil,nil,nil,nil,'l1e0',true}
TutorialSkip.original=function(...) replayed=replayed+1;route={...};assert(select('#',...)==7) end
TutorialSkip.newbie()
assert(requested==9992 and TutorialSkip.busy and replayed==0 and closed==0)
callback({RESPONSE_SUCCESS=false,PROTOCOL_STATUS=-1})
assert(not TutorialSkip.busy and TutorialSkip.pending and closed==0)
TutorialSkip.newbie()
initial.apply('playing')
callback({RESPONSE_SUCCESS=true,PROTOCOL_STATUS=0})
assert(replayed==1 and closed==1 and TutorialSkip.pending==nil and not TutorialSkip.busy)
assert(route[1]=='battle' and route[5]==true and route[6]=='1196v1' and route[7]==true)
local realOpen=io.open
io.open=function() return {write=function() end,close=function() end} end
app={load=function() end}
cc.FileUtils={getInstance=function() return {getWritablePath=function() return '' end} end}
_ED._scene_npc_id=1196
_ED.user_info.user_grade='2';_ED.user_info.user_experience='1';_ED.nr_initial_tutorial='playing'
assert(require('tutorial_tap_wait').isIntroBattle(),
    'Pain terminal stopped matching after its XP reward advanced the profile')
_ED._nr_current_mission_progress=2010135
initial.apply('playing')
require('intro_menu_transition').install()
state_machine.excute('menu_window_open_mission',0,0)
assert(initial.state=='playing','tutorial finished before the final Pain cutscene marker')
_ED._nr_current_mission_progress=2010136
menuCalls=0
local completedAfterPain=0
local completionResponse
local resumedAfterPain=0
protocol_command.education_change={code=88,param_list=''}
TutorialSkip.resumeAfterIntro=function()
    resumedAfterPain=resumedAfterPain+1
    completedAfterPain=completedAfterPain+1
    initial.apply('completed') -- login_init/education parser returns the authoritative state
end
state_machine.excute('menu_window_open_mission',0,0)
assert(initial.state=='playing','client locally completed before server confirmed the post-Pain terminal')
assert(requested==88 and protocol_command.education_change.param_list=='2010136' and menuCalls==0,
    'post-Pain terminal did not confirm completion before opening legacy missions')
completionResponse=callback
completionResponse({RESPONSE_SUCCESS=true,PROTOCOL_STATUS=0})
assert(initial.state=='completed' and completedAfterPain==1,
    'server-confirmed post-Pain completion did not refresh the profile')
state_machine.excute('menu_window_open_mission',0,0)
assert(resumedAfterPain==2 and menuCalls==0,
    'already-completed post-Pain session did not resume through login refresh')
io.open=realOpen
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
loader=(root/'01_conteudo_apk/assets/src/client/red_alert/battle/battle_loading.lua').read_text(encoding='utf8')
first_load=loader.split('if self._loadCount == 1 then',1)[1].split('elseif self._loadCount == 2 then',1)[0]
assert 'fwin:cleanView(fwin._view)' in first_load
print('INITIAL_TUTORIAL_CLIENT_PASSED server states, account switch, retry, deferred choice, Lua 5.1 compilation')
