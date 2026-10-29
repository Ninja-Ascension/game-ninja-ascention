"""Daily Quest creation-date regression and scoped home upgrade indicator."""
import json
import test_mobile_bootstrap as vm
root=vm.root;lua=vm.lua
base=root/'01_conteudo_apk/assets/src'
s=(base/'client/protocol/ProtocolParserCopyEx.lua').read_text(encoding='utf8');a=s.index('function parse_user_create_time(');parser=s[a:].split('\nfunction ',1)[0]
s=(base/'client/activity/dailytask/DailyTask.lua').read_text(encoding='utf8');a=s.index('            local createUserData =');b=s.index('            if createUserData.year',a);date=s[a:b]
s=(base/'client/notification/push_notification_sm_hero_develop.lua').read_text(encoding='utf8');a=s.index('local push_notification_center_hero_develop_home_hero_icon_terminal');a=s.index('_invoke = function',a);b=s.index('        _terminal =',a);callback=s[a:b].split('=',1)[1].strip().rstrip(',')
script=r'''
_ED={user_info={},GTM_Time=0};zstring={tonumber=tonumber}
function getBaseGTM8Time(time) return tonumber(time)-_ED.GTM_Time end
function npos(list) local v=list[list.pos];list.pos=list.pos+1;return v end
PARSER
local function createDate()
DATE
return createUserData,createUserTimes
end
local now=os.time()
_ED.user_info.create_time=now*1000
assert(not pcall(createDate),'original Windows millisecond date failure not reproduced')
for _,timestamp in ipairs({now,now*1000}) do
 parse_user_create_time(nil,nil,nil,nil,{tostring(timestamp),pos=1})
 local calendar,seconds=createDate()
 assert(calendar.year==os.date('*t',now).year and seconds>=0 and seconds<86400)
end
local invoke=CALLBACK
local removed=0
local widget={_nodeChild={},_istips=true,removeChild=function() removed=removed+1 end}
invoke(nil,nil,{_widget=widget});invoke(nil,nil,{_widget=widget})
assert(removed==1 and not widget._nodeChild and widget._istips==false)
COMPILE
print('DAILY_QUEST_DATE_PASSED original failure reproduced; seconds and legacy milliseconds render; home upgrade dot removed without rebuilding it; changed Lua compiles')
'''.replace('PARSER',parser,1).replace('DATE',date,1).replace('CALLBACK',callback,1)
files=[base/'client/home/HomeHero.lua',base/'client/notification/push_notification_sm_hero_develop.lua',root/'port/lua/home_hero_base_effect.lua']
script=script.replace('COMPILE','\n'.join('assert(loadfile('+json.dumps(f.as_posix())+'))' for f in files),1)
state=lua.luaL_newstate()
try:
 lua.luaL_openlibs(state);status=lua.luaL_loadstring(state,script.encode())
 if not status:status=lua.lua_pcall(state,0,0,0)
 if status:raise AssertionError(lua.lua_tolstring(state,-1,None).decode())
finally:lua.lua_close(state)
