"""Packet capture/playback contract; does not certify full battle rendering."""
import ctypes,json
from pathlib import Path
root=Path(__file__).resolve().parents[1]
lua=ctypes.CDLL(str(root/'build/windows-release/bin/NinjaResourceProbe/Release/lua51.dll'))
lua.luaL_newstate.restype=ctypes.c_void_p;lua.luaL_openlibs.argtypes=[ctypes.c_void_p];lua.luaL_loadstring.argtypes=[ctypes.c_void_p,ctypes.c_char_p];lua.lua_pcall.argtypes=[ctypes.c_void_p,ctypes.c_int,ctypes.c_int,ctypes.c_int];lua.lua_tolstring.argtypes=[ctypes.c_void_p,ctypes.c_int,ctypes.c_void_p];lua.lua_tolstring.restype=ctypes.c_char_p;lua.lua_close.argtypes=[ctypes.c_void_p]
script=r'''
_ED={};_enum_fight_type={_fight_type_11=11};local processed={}
FightModule={new=function() error('Replay tried to simulate a battle') end}
NetworkProtocol={protocol_parses={},find_parser=function() return false end}
function npos(t) return t[1] end
NetworkProtocol.parser_func=function(data)
 processed[#processed+1]=data.resouce
 if data.resouce:find('battle_field_init',1,true) then _ED.battleData={battle_init_type=0} end
 if data.resouce:find('environment_fight',1,true) then _ED.attackData={roundData={historical=true}} end
end
local replay=assert(loadfile(MODULE))()
local init='100\r\nbattle_field_init\r\n0\r\n182\r\nNinja With Space'
local fight='100\r\nenvironment_fight\r\n0\r\n39\r\n1 10 0'
replay.start('match-1');NetworkProtocol.parser_func({resouce=init});NetworkProtocol.parser_func({resouce=fight})
local text=assert(replay.finish('match-1'));assert(not text:find(' ',1,true),'Archive contains unsafe protocol spaces')
local record=json.decode(text);assert(record.version==1 and record.initHex and record.fightHex)
local parser=NetworkProtocol.protocol_parses[1];parser.parser_fun(nil,nil,nil,nil,{text})
assert(_ED.nr_arena_recorded_packets.initHex==record.initHex)
_ED._fightModule={};_ED.nr_arena_fight_rank=1
replay.play(_ED.nr_arena_recorded_packets)
assert(_ED._fightModule==nil and _ED.nr_arena_fight_rank==nil)
assert(_ED.attackData.roundData.historical and _ED.battleData.battle_init_type==11)
assert(processed[#processed-1]==init and processed[#processed]==fight,'Historical packets were changed')
replay.start('incomplete');NetworkProtocol.parser_func({resouce=init});assert(replay.finish('incomplete')==nil)
local engine={}
function engine:rountdFight(buffer) buffer[#buffer+1]='round-data with spaces';return 'unchanged-result' end
function engine:fightObjectAttack(attacker,buffer) buffer[#buffer+1]='action-data';return attacker end
function engine:jumpCurrentFight(user,buffer) self:rountdFight(buffer);buffer[#buffer+1]='skip-tail' end
local original=engine.rountdFight
local id=string.rep('a',32)
replay.start(id,engine);NetworkProtocol.parser_func({resouce=init})
assert(engine:rountdFight({})=='unchanged-result')
assert(engine:fightObjectAttack('attacker',{})=='attacker')
engine:jumpCurrentFight({}, {})
local journal=json.decode(assert(replay.finish(id,1)))
assert(journal.version==2 and journal.matchId==id and journal.win=='1')
assert(#journal.events==4,'Nested calls duplicated events')
assert(journal.events[1].kind=='protocol' and journal.events[2].kind=='round' and journal.events[3].kind=='action' and journal.events[4].kind=='skip')
assert(engine.rountdFight==original,'Engine wrapper was not detached')
assert(not json.encode(journal):find(' ',1,true),'Unsafe spaces in transport')
replay.start(id,engine);NetworkProtocol.parser_func({resouce=init})
engine:rountdFight({});replay.capture.overflow=true
assert(replay.finish(id,1)==nil,'Truncated journal was stored')

'''
script='assert(loadfile('+json.dumps((root/'01_conteudo_apk/assets/src/cocos/cocos2d/json.lua').as_posix())+'))()\n'+script.replace('MODULE',json.dumps((root/'port/lua/arena_replay.lua').as_posix()))
state=lua.luaL_newstate()
try:
 lua.luaL_openlibs(state);status=lua.luaL_loadstring(state,script.encode())
 if not status:status=lua.lua_pcall(state,0,0,0)
 if status:raise AssertionError(lua.lua_tolstring(state,-1,None).decode('utf8','replace'))
finally:lua.lua_close(state)
source=(root/'01_conteudo_apk/assets/src/client/l_digital/cells/arena/arena_war_report_seat_cell.lua').read_text(encoding='utf8')
assert 'nrArenaPrepareFight' not in source and 'bse:init(_enum_fight_type._fight_type_11)' in source
assert source.index('response.node.roots[1] ~= nil')<source.index("require('arena_replay').play")
print('ARENA_REPLAY_CLIENT_PASSED byte-identical capture/playback, no resimulation, original roots guard and fight type 11')
