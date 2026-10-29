from pathlib import Path
import json
import test_mobile_bootstrap as vm
import montar_apk
lua=vm.lua
main=montar_apk.main_lua().decode()
script=r'''
local shown=false
local label={setDimensions=function() end,setAnchorPoint=function() end,setPosition=function() end}
local scene={addChild=function() shown=true end}
local director={getWinSize=function() return {width=960,height=640} end,getRunningScene=function() return nil end,runWithScene=function() end}
cc={FileUtils={getInstance=function() return {addSearchPath=function() end,getWritablePath=function() return 'invalid/' end} end},Director={getInstance=function() return director end},Scene={create=function() return scene end},Label={createWithSystemFont=function(_,text) assert(text:find('TEST_BOOT_FAILURE'));return label end}}
package.preload['cocos.init']=function() return true end
package.preload['frameworks.app']=function() return {create=function() error('TEST_BOOT_FAILURE') end} end
local main=assert(loadstring(MAIN,'@main.lua'))
local ok,err=pcall(main)
assert(not ok and tostring(err):find('TEST_BOOT_FAILURE'))
assert(shown,'startup error was not displayed')
assert(__nr_android_boot.stage=='app.create')
print('ANDROID_DIAGNOSTIC_TEST_PASSED startup failure displayed with stage')
'''.replace('MAIN',' [====['+main+']====] ')
state=lua.luaL_newstate()
try:
 lua.luaL_openlibs(state)
 status=lua.luaL_loadstring(state,script.encode())
 if not status:status=lua.lua_pcall(state,0,0,0)
 if status:raise AssertionError(lua.lua_tolstring(state,-1,None).decode())
finally:lua.lua_close(state)

