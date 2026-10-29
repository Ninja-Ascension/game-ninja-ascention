"""Check the real SDK wrapper against recovered fwin:open/cleanView contracts."""
from pathlib import Path
import ctypes
import json
import sys

root=Path(__file__).resolve().parents[1]
source=(root/'01_conteudo_apk/assets/src/frameworks/windows/fwin.lua').read_text(encoding='utf-8-sig')
def function(name,following):
    return source[source.index('function '+name):source.index('function '+following,source.index('function '+name))]
original_open=function('fwin:open(', 'fwin:update(')
original_clean=function('fwin:cleanView(', 'fwin:cleanViews(')
sdk=json.dumps((root/'port/lua/local_sdk_guest.lua').as_posix())
load_sdk=f'assert(loadfile({sdk}))()'
if '--verify-old-fails' in sys.argv:
    old=(root/'port/lua/local_sdk_guest.lua').read_text(encoding='utf-8-sig')
    old=old.replace('fwin.open = function(self, janela, layer, ...)',
                    'fwin.open = function(janela, layer)')
    old=old.replace('original(self, janela, layer, ...)', 'original(janela, layer)')
    load_sdk='assert(loadstring('+json.dumps(old,ensure_ascii=False)+'))()'
script=f'''
fwin={{_list={{}}}}
local function container() return {{_layer={{removeAllChildren=function() end}}}} end
fwin._view=container();fwin._windows=container();fwin._dialog=container()
function fwin:push(window,layer)
 assert(self==fwin,'lost fwin self')
 window._view=layer or self._view
 table.insert(self._list,window)
end
function fwin:close(window)
 for i,v in ipairs(self._list) do if v==window then table.remove(self._list,i);break end end
 window.totalNum=nil
end
{original_open}
{original_clean}
local sdk={load_sdk}
sdk.instalarSondaDeJanelas()
local loading={{__cname='FightLoadingCellClass',totalNum=5}}
assert(fwin:open(loading,fwin._windows)==loading,'lost return value')
assert(loading._view==fwin._windows,'loader sent to wrong container')
local overlay={{__cname='OverlayClass'}}
fwin:open(overlay,fwin._view)
fwin:cleanView(fwin._view)
assert(loading.totalNum==5,'createFight cleanup destroyed loader')
assert(#fwin._list==1 and fwin._list[1]==loading)
local dialog={{__cname='DialogClass'}}
assert(fwin.open(fwin,dialog,fwin._dialog)==dialog)
assert(dialog._view==fwin._dialog,'explicit-self call lost container')
print('WINDOW_OPEN_CONTRACT_PASSED: original open/cleanView, colon calls, loader lifetime')
'''
lua=ctypes.CDLL(str(root/'build/windows-probe-native/bin/NinjaResourceProbe/Debug/lua51.dll'))
lua.luaL_newstate.restype=ctypes.c_void_p
lua.luaL_openlibs.argtypes=[ctypes.c_void_p]
lua.luaL_loadstring.argtypes=[ctypes.c_void_p,ctypes.c_char_p]
lua.lua_pcall.argtypes=[ctypes.c_void_p,ctypes.c_int,ctypes.c_int,ctypes.c_int]
lua.lua_tolstring.argtypes=[ctypes.c_void_p,ctypes.c_int,ctypes.c_void_p]
lua.lua_tolstring.restype=ctypes.c_char_p
lua.lua_close.argtypes=[ctypes.c_void_p]
state=lua.luaL_newstate()
try:
    lua.luaL_openlibs(state)
    code=lua.luaL_loadstring(state,script.encode('utf-8'))
    if not code: code=lua.lua_pcall(state,0,0,0)
    if '--verify-old-fails' in sys.argv:
        assert code, 'Old wrapper unexpectedly passed'
        message=lua.lua_tolstring(state,-1,None).decode('utf-8','replace')
        assert 'loader sent to wrong container' in message, message
        print('OLD_WRAPPER_REGRESSION_REPRODUCED: requested windows container was lost')
    elif code:
        raise AssertionError(lua.lua_tolstring(state,-1,None).decode('utf-8','replace'))
finally:
    lua.lua_close(state)
