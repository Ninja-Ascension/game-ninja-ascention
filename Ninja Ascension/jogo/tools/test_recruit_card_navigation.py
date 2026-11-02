"""Verify the first-account Recruit tutorial block is skipped cleanly."""
import ctypes
import json
from pathlib import Path

root = Path(__file__).resolve().parents[1]
lua = ctypes.CDLL(str(root / 'build/windows-release/bin/NinjaResourceProbe/Release/lua51.dll'))
lua.luaL_newstate.restype = ctypes.c_void_p
lua.luaL_openlibs.argtypes = [ctypes.c_void_p]
lua.luaL_loadstring.argtypes = [ctypes.c_void_p, ctypes.c_char_p]
lua.lua_pcall.argtypes = [ctypes.c_void_p, ctypes.c_int, ctypes.c_int, ctypes.c_int]
lua.lua_tolstring.argtypes = [ctypes.c_void_p, ctypes.c_int, ctypes.c_void_p]
lua.lua_tolstring.restype = ctypes.c_char_p
lua.lua_close.argtypes = [ctypes.c_void_p]

script = 'package.path=' + json.dumps((root / 'port/lua/?.lua').as_posix()) + '..";"..package.path\n'
script += r'''
local lobby=require('recruit_lobby')
local mission={[1]=3,[2]=4}
_ED={nr_initial_tutorial='playing'}
mission_id=1;mission_event_id=2
dms={atoi=function(row,index) return row[index] end}
local skipped,closed=0,0
local controller={_mission=mission,skipInitialRecruitSection=function(self) skipped=skipped+1;return true end}
local windows={NewRecruitMainClass={},HeroRecruitListViewClass={},HeroRecruitSuccessClass={}}
fwin={
    find=function(_,name) if name=='TuitionControllerClass' then return controller end;return windows[name] end,
    close=function(_,window) closed=closed+1;for name,value in pairs(windows) do if value==window then windows[name]=nil end end end
}
for event=4,17 do
    mission[2]=event
    assert(lobby.isInitialTutorialRecruitBlock(mission),'Recruit segment event '..event..' was not recognized')
end
assert(not lobby.isInitialTutorialRecruitBlock({[1]=3,[2]=3}))
assert(lobby.openInitialTutorialRecruit(),'Tutorial Recruit entry was not intercepted')
assert(skipped==1 and closed==3,'Recruit windows were not closed and tutorial skip was not requested')
mission[2]=18
assert(not lobby.isInitialTutorialRecruitBlock(mission))
assert(not lobby.openInitialTutorialRecruit(),'Ordinary Recruit entry was suppressed after the skipped block')
_ED.nr_initial_tutorial='completed'
mission[2]=4
assert(not lobby.isInitialTutorialRecruitBlock(mission),'Completed account was still treated as onboarding')
assert(loadfile(''' + json.dumps((root / '01_conteudo_apk/assets/src/client/home/Home.lua').as_posix()) + r'''))
assert(loadfile(''' + json.dumps((root / '01_conteudo_apk/assets/src/client/mission/tuition/TuitionController.lua').as_posix()) + r'''))
local home=assert(io.open(''' + json.dumps((root / '01_conteudo_apk/assets/src/client/home/Home.lua').as_posix()) + r''','rb')):read('*a')
assert(home:find('if require("recruit_lobby").openInitialTutorialRecruit() then return true end',1,true))
assert(home:find('app.load("client.shop.recruit.HeroRecruitListView")',1,true),'Normal Recruit route was removed')
local tuition=assert(io.open(''' + json.dumps((root / '01_conteudo_apk/assets/src/client/mission/tuition/TuitionController.lua').as_posix()) + r''','rb')):read('*a')
assert(tuition:find('self:skipInitialRecruitSection()',1,true),'Tutorial controller does not fast-forward the Recruit block')
assert(not tuition:find('initialTutorialRecruitTarget',1,true),'Broken required-recruit target route remains')
assert(not tuition:find('home_new_recruit_main',1,true),'Tutorial still opens Recruit as a required target')
assert(tuition:find('saveExecuteEvent(mission, true, true)',1,true),'Skip does not advance using the normal tutorial event pipeline')
print('RECRUIT_TUTORIAL_SKIP_PASSED events 3:4-17 skipped, event 3:18 and normal Recruit retained')
'''

state = lua.luaL_newstate()
try:
    lua.luaL_openlibs(state)
    status = lua.luaL_loadstring(state, script.encode())
    if not status:
        status = lua.lua_pcall(state, 0, 0, 0)
    if status:
        raise AssertionError(lua.lua_tolstring(state, -1, None).decode('utf8', 'replace'))
finally:
    lua.lua_close(state)
