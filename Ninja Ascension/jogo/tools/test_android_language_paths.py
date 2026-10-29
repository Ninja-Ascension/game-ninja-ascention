"""Android language selection must keep late port modules resolvable."""
import json
import test_mobile_bootstrap as vm
lua=vm.lua
app=json.dumps((vm.root/'01_conteudo_apk/assets/src/frameworks/app.lua').as_posix())
resume=json.dumps((vm.root/'port/lua/tutorial_resume.lua').as_posix())
script=r'''
local paths={'src/port/lua','src','res'}
local files={getWritablePath=function() return '/private/' end,setSearchPaths=function(_,value) paths=value end}
cc={PLATFORM_OS_ANDROID=3,PLATFORM_OS_WINDOWS=0,Application={getInstance=function() return {getTargetPlatform=function() return 3 end} end},FileUtils={getInstance=function() return files end}}
assert(loadfile(APP))()
app.searchPaths={'src','res'} -- snapshot taken before port_mobile loaded
app.configJson={version='1.66012',MultiLanguage={pt_BR={searchPaths={'res/language/pt_BR'}},en_US={searchPaths={'res/language/en_US'}}}}
package.loaders[#package.loaders+1]=function(name)
 if name=='tutorial_resume' then
  for _,path in ipairs(paths) do if path=='src/port/lua' then return assert(loadfile(RESUME)) end end
 end
 return '\nport path absent'
end
for _,language in ipairs({'pt_BR','en_US','pt_BR'}) do
 package.loaded.tutorial_resume=nil
 assert(app.setSearchPaths(language)==true)
 local module=require('tutorial_resume')
 assert(type(module.restore)=='function')
 _ED={user_info={user_id='2',new_user_teach_record={}}}
 module.restore();assert(module.checkpoint==nil)
end
local old=paths
assert(app.setSearchPaths('missing')==false and paths==old)
print('ANDROID_LANGUAGE_PATHS_PASSED late tutorial_resume loads after repeated language changes; missing language preserves paths')
'''.replace('APP',app).replace('RESUME',resume)
state=lua.luaL_newstate()
try:
 lua.luaL_openlibs(state);status=lua.luaL_loadstring(state,script.encode())
 if not status:status=lua.lua_pcall(state,0,0,0)
 if status:raise AssertionError(lua.lua_tolstring(state,-1,None).decode())
finally:lua.lua_close(state)
