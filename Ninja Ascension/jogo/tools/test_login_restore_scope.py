"""Login snapshot analytics are scoped; normal events and failures survive."""
import json
import test_mobile_bootstrap as vm
lua=vm.lua
path=json.dumps((vm.root/'port/lua/profile_parser_dependencies.lua').as_posix())
script=r'''
getUserFight=function() end
local events,restored=0,0
local event=function() events=events+1 end
jttd={NewAPPeventSlogger=event}
package.preload.tutorial_resume=function() return {install=function() end,restore=function() restored=restored+1 end} end
NetworkProtocol={parser_func=function(data)
 for i=1,1000 do jttd.NewAPPeventSlogger('historical') end
 if data.fail then error('REAL_PARSE_FAILURE') end
 return 'parsed',42
end}
assert(loadfile(PATH))().install()
local a,b=NetworkProtocol.parser_func({resouce='1 login_init 0 1'})
assert(a=='parsed' and b==42 and events==0 and restored==1)
assert(not NetworkProtocol.__nr_restoring_login and jttd.NewAPPeventSlogger==event)
NetworkProtocol.parser_func({resouce='2 normal_update 0 1'})
assert(events==1000)
local ok,err=pcall(NetworkProtocol.parser_func,{resouce='3 login_init_again 0 1',fail=true})
assert(not ok and err:find('REAL_PARSE_FAILURE'))
assert(jttd.NewAPPeventSlogger==event and not NetworkProtocol.__nr_restoring_login)
print('LOGIN_RESTORE_SCOPE_PASSED historical analytics suppressed; normal events, return values and original failure preserved')
'''.replace('PATH',path)
state=lua.luaL_newstate()
try:
 lua.luaL_openlibs(state);status=lua.luaL_loadstring(state,script.encode())
 if not status:status=lua.lua_pcall(state,0,0,0)
 if status:raise AssertionError(lua.lua_tolstring(state,-1,None).decode())
finally:lua.lua_close(state)
