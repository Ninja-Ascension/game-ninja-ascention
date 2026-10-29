"""Exercise the actual HTTP adaptor for Android and Windows in Lua 5.1."""
import json
import test_mobile_bootstrap as vm
lua=vm.lua
path=json.dumps((vm.root/'01_conteudo_apk/assets/src/frameworks/network/NetworkAdaptor.lua').as_posix())
script=r'''
local sock={on=function() end,setopt=function() end}
package.preload.socketevent=function() return {tcp=function() return sock end} end
package.preload['socket.core']=function() return {gettime=os.time} end
local platform=3
local nativeCalls=0
local function native() nativeCalls=nativeCalls+1 end
blowfish={_key='test',encrypt=native,decrypt=native}
NetworkView={};debug.log=function() end
CreateEnumTable=function(names) local out={};for i,n in ipairs(names) do out[n]=i end;return out end
lua_string_split_line=function(text) return text end
lua_string_splits=function(text) return {'1','new_get_server_list','0'} end
local response='1 new_get_server_list 0 58 1 999 Local http://test/iniServer 1 0'
local request='1\r\nnew_get_server_list\r\nclient'
local captured
local function bytes(text) return {value=text,getSize=function(self) return #self.value end,getBytes=function(self) return self.value end,release=function() end} end
cc={PLATFORM_OS_ANDROID=3,Application={getInstance=function() return {getTargetPlatform=function() return platform end} end},DBytes={new=function(_,text) return bytes(text) end},deflateMemory=native,inflateMemory=native,XMLHttpRequest={new=function()
 local xhr={readyState=5,status=200,timeout=10}
 function xhr:registerScriptHandler(fn) self.callback=fn end
 function xhr:open(method,url) self.url=url end
 function xhr:setRequestHeader() end
 function xhr:data(buffer) buffer.value=response end
 function xhr:send(body) captured={url=self.url,body=body,text=true};self.callback() end
 function xhr:send_d(body) captured={url=self.url,body=body.value,text=false};self.callback() end
 return xhr
end}}
assert(loadfile(PATH))()
NetworkAdaptor.init()
for _,case in ipairs({{platform=3,url='http://test/iniServer',text=true},{platform=3,url='http://test/iniServer?s=valid_token',text=true},{platform=0,url='http://test/iniServer?s=valid_token',text=false},{platform=3,url='http://other/external',text=false}}) do
 platform=case.platform;nativeCalls=0
 local data={mode=NetworkAdaptor.mode.HTTP,data='payload',str=request,command=8,url=case.url,nType='POST',error_code=0,timeOut=10}
 NetworkAdaptor.send(data)
 assert(captured.body==request and captured.text==case.text)
 assert(data.RESPONSE_SUCCESS and data.resouce==response)
 if case.text then
  assert(nativeCalls==0 and captured.url:find('nr_transport=text-v1',1,true))
  if case.url:find('?s=',1,true) then assert(captured.url:find('?s=valid_token&nr_transport=text-v1',1,true)) end
 else assert(nativeCalls==4 and captured.url==case.url) end
end
print('ANDROID_HTTP_CLIENT_PASSED actual Lua adaptor; Android text and Windows binary; session URL preserved; response parsing completes')
'''.replace('PATH',path)
state=lua.luaL_newstate()
try:
 lua.luaL_openlibs(state);status=lua.luaL_loadstring(state,script.encode())
 if not status:status=lua.lua_pcall(state,0,0,0)
 if status:raise AssertionError(lua.lua_tolstring(state,-1,None).decode())
finally:lua.lua_close(state)
