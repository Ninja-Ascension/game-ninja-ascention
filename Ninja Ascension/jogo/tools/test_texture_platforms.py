"""Preserve Android's target callback; translate only the desktop binding."""
import json
import test_mobile_bootstrap as vm
lua=vm.lua
module=json.dumps((vm.root/'port/lua/texture_async_compat.lua').as_posix())
loading=json.dumps((vm.root/'01_conteudo_apk/assets/src/client/utils/Loading.lua').as_posix())
script=r'''
local queue={}
local target,texture={},{}
cc={PLATFORM_OS_ANDROID=3,Application={getInstance=function() return {getTargetPlatform=function() return 3 end} end},TextureCache={}}
local native=function(self,path,callback,owner,flag1,flag2)
 assert(owner and flag1==false and flag2==true,'Android legacy arguments lost')
 queue[#queue+1]=function() callback(owner,texture) end
end
cc.TextureCache.addImageAsync=native
local adapter=assert(loadfile(MODULE))()
adapter.armar();assert(cc.TextureCache.addImageAsync==native)
local cache=setmetatable({},{__index=cc.TextureCache})
cc.Director={getInstance=function() return {getTextureCache=function() return cache end} end}
cc.Node={create=function() return {retain=function() end,release=function() end} end}
local plists=0
cc.SpriteFrameCache={getInstance=function() return {addSpriteFrames=function() plists=plists+1 end} end}
assert(loadfile(LOADING))()
local completed=0
Loading.loading({_pic={'portrait.png'},_plist={{_png={'home.png'},_plist={'home.plist'}}}},function() completed=completed+1 end)
assert(Loading.loadCount==2 and completed==0)
for _,fn in ipairs(queue) do fn() end
assert(Loading.loadCount==0 and completed==1 and plists==1,'Android loader did not finish')
cc.Application.getInstance=function() return {getTargetPlatform=function() return 0 end} end
cc.TextureCache={addImageAsync=function(self,path,callback,...)
 assert(select('#',...)==0,'desktop got Android arguments');callback(texture)
end}
adapter.armar()
local called=false
cc.TextureCache.addImageAsync({},'home.png',function(owner,value) assert(owner==target and value==texture);called=true end,target,false,true)
assert(called)
print('TEXTURE_PLATFORM_CONTRACTS_PASSED Android original Loading drains once; desktop legacy callback translates correctly')
'''.replace('MODULE',module).replace('LOADING',loading)
state=lua.luaL_newstate()
try:
 lua.luaL_openlibs(state);status=lua.luaL_loadstring(state,script.encode())
 if not status:status=lua.lua_pcall(state,0,0,0)
 if status:raise AssertionError(lua.lua_tolstring(state,-1,None).decode())
finally:lua.lua_close(state)
