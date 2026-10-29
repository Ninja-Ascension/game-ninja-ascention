"""Decode a 1 MB shop snapshot with the Android JSON decoder and real parser."""
import ctypes,json,sys,time,tempfile
from pathlib import Path
root=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(root/'port/server'))
import shop_local
# Synthetic IDs: no live account or persistent data used by the test.
mould=next(int(k) for k in shop_local.data.tabela('equipment_mould.txt') if k.isdigit())
items=[shop_local.equipment(i+1,mould) for i in range(1002)]
payload=json.dumps({'equipment':items,'free':1,'draws':123},separators=(',',':'))
with tempfile.TemporaryDirectory(prefix='large-json-',dir=root/'build') as folder:
 path=Path(folder)/'payload.json';path.write_text(payload)
 module=json.dumps((root/'01_conteudo_apk/assets/src/cocos/cocos2d/json.lua').as_posix())
 shop=json.dumps((root/'port/lua/shop_local.lua').as_posix())
 fast=json.dumps((root/'port/lua/fast_json.lua').as_posix())
 script=r'''
assert(loadfile(MODULE))()
local fast=assert(loadfile(FAST))()
package.preload.fast_json=function() return fast end
local file=assert(io.open(PAYLOAD,'r'));local text=file:read('*a');file:close()
local assertOriginal=assert
local messageBytes=0
_G.assert=function(value,message,...) messageBytes=messageBytes+#tostring(message or '');return assertOriginal(value,message,...) end
local start=os.clock()
local decoded=fast.decode(text)
assert(#decoded.equipment==1002 and decoded.equipment[1002].user_equiment_id=='2000001002')
local elapsed=os.clock()-start
assert(messageBytes<#text*200,'successful decode still builds full document errors: '..messageBytes)
_G.assert=assertOriginal
local reference=json.decode(text)
for i,item in ipairs(reference.equipment) do
 for key,value in pairs(item) do assert(decoded.equipment[i][key]==value,'equipment field changed: '..key) end
 for key,value in pairs(decoded.equipment[i]) do assert(item[key]==value,'unexpected equipment field: '..key) end
end
local saved={user_equiment_id='existing'}
_ED={user_equiment={existing=saved}}
protocol_command={}
NetworkProtocol={protocol_parses={},parser_func=function() end}
NetworkProtocol.find_parser=function(code) for _,p in ipairs(NetworkProtocol.protocol_parses) do if p.code==code then return p end end end
function npos(list) local value=list[list.pos];list.pos=list.pos+1;return value end
assert(loadfile(SHOP))().install()
local list={text,pos=1}
NetworkProtocol.find_parser(15990).parser_fun(nil,nil,nil,nil,list)
assert(list.pos==2 and _ED.user_equiment_number==1003 and _ED.user_equiment.existing==saved)
assert(_ED.free_info[3].surplus_free_number==1 and _ED.user_accumulate_camp_god==123)
assert(_ED.user_equiment['2000001002'].user_equiment_id=='2000001002')
for _,bad in ipairs({'{','[1,','{"equipment":[','[01]','[1e]','{"x":true,}','"\\uD800"'}) do assert(not pcall(fast.decode,bad),'invalid JSON accepted') end
local unicode=fast.decode([=[{"x":"\u00e7\uD83D\uDE00","n":-1.25e2,"b":false,"a":[1,2,3]}]=])
assert(unicode.x==string.char(195,167,240,159,152,128) and unicode.n==-125 and unicode.b==false and #unicode.a==3)
print(string.format('LARGE_ANDROID_JSON_PASSED bytes=%d items=1002 decode_seconds=%.3f error_message_bytes=%d; actual shop parser restores all items',#text,elapsed,messageBytes))
'''.replace('FAST',fast).replace('MODULE',module).replace('PAYLOAD',json.dumps(path.as_posix())).replace('SHOP',shop)
 lua=ctypes.CDLL(str(root/'build/windows-release/bin/NinjaResourceProbe/Release/lua51.dll'))
 lua.luaL_newstate.restype=ctypes.c_void_p
 lua.luaL_openlibs.argtypes=[ctypes.c_void_p]
 lua.luaL_loadstring.argtypes=[ctypes.c_void_p,ctypes.c_char_p]
 lua.lua_pcall.argtypes=[ctypes.c_void_p,ctypes.c_int,ctypes.c_int,ctypes.c_int]
 lua.lua_tolstring.argtypes=[ctypes.c_void_p,ctypes.c_int,ctypes.c_void_p];lua.lua_tolstring.restype=ctypes.c_char_p
 lua.lua_close.argtypes=[ctypes.c_void_p]
 state=lua.luaL_newstate()
 try:
  lua.luaL_openlibs(state);status=lua.luaL_loadstring(state,script.encode())
  if not status:status=lua.lua_pcall(state,0,0,0)
  if status:raise AssertionError(lua.lua_tolstring(state,-1,None).decode())
 finally:lua.lua_close(state)

