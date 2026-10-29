"""Read an actual archived fight using the game's unmodified battle parsers."""
import ctypes,json,zipfile
from pathlib import Path
root=Path(__file__).resolve().parents[1]
lua=ctypes.CDLL(str(root/'build/windows-release/bin/NinjaResourceProbe/Release/lua51.dll'))
lua.luaL_newstate.restype=ctypes.c_void_p
lua.luaL_openlibs.argtypes=[ctypes.c_void_p]
lua.luaL_loadstring.argtypes=[ctypes.c_void_p,ctypes.c_char_p]
lua.lua_pcall.argtypes=[ctypes.c_void_p,ctypes.c_int,ctypes.c_int,ctypes.c_int]
lua.lua_tolstring.argtypes=[ctypes.c_void_p,ctypes.c_int,ctypes.c_void_p]
lua.lua_tolstring.restype=ctypes.c_char_p
lua.lua_close.argtypes=[ctypes.c_void_p]
script=r'''
__lua_project_id=1;__lua_project_l_naruto=1
_enum_fight_type={_fight_type_11=11}
_ED={user_info={user_grade=110,user_food=10,endurance=10}}
zstring={tonumber=function(v)return tonumber(v) or 0 end,exchangeFrom=function(v)return v end}
function zstring.split(value,sep)
 local t={};local start=1
 while true do local a,b=value:find(sep,start,true);if not a then t[#t+1]=value:sub(start);break end;t[#t+1]=value:sub(start,a-1);start=b+1 end
 return t
end
app={load=function()end};state_machine={excute=function()end}
debug.log=function()end;_____g_skill_influence=0;battle_stats_reset=function()end
assert(loadfile(PARSER))();assert(loadfile(EXTRA))()
local parsers={[182]=parse_battle_field_init,[14710]=parse_environment_fight_battle_start_influence_info,[14711]=parse_environment_fight_round_start_influence_info,[14712]=parse_environment_fight_battle_camp_change_influence_info,[14713]=parse_environment_fight_battle_init_object_info,[206]=parse_return_both_fight_capacity_info}
NetworkProtocol={parser_func=function(data)
 local t=lua_string_splits(lua_string_split_line(data.resouce,'\r\n'),' ');while t[#t]=='' do table.remove(t) end;t.pos=4
 while t.pos<=#t do local code=tonumber(npos(t));assert(parsers[code],'Unknown parser '..tostring(code));parsers[code](nil,nil,0,nil,t,nil) end
end}
local file=assert(io.open(FIXTURE,'rb'));local record=json.decode(file:read('*a'));file:close()
FightModule={new=function()error('Replay attempted a new simulation')end}
local reader=assert(loadfile(READER))()
local result=reader.read(record)
assert(result.rounds==2 and result.actions==16)
assert(_ED.attackData.isWin=='1' and _ED.battleData.defender_name=='ItachiBR')
local trace={}
for _,round in ipairs(_ED.attackData.roundData) do
 for _,action in ipairs(round.roundAttacksData) do
  trace[#trace+1]=table.concat({round.currentRound,action.attacker,action.attackerPos,action.skillMouldId,action.attackerHp,action.attackerSp},':')
 end
end
local expected=table.concat(trace,'|')
package.path=LUA_PATH..'/?.lua;'..package.path
NetworkProtocol.protocol_parses={};NetworkProtocol.find_parser=function()return nil end
NetworkManager={register=function()error('Replay attempted a purchase or settlement')end}
local replay=require('arena_replay')
for attempt=1,2 do
 _ED._fightModule={new=function()error('Replay attempted a new fight')end}
 _ED.nr_arena_fight_rank=1;_ED.nr_arena_fight_match_id='must-be-cleared'
 replay.play(record)
 assert(_ED._fightModule==nil and _ED.nr_arena_fight_rank==nil and _ED.nr_arena_fight_match_id==nil)
 assert(_ED.battleData.battle_init_type==11 and _ED.attackData.roundCount==2)
 local seen={}
 for _,round in ipairs(_ED.attackData.roundData) do
  for _,action in ipairs(round.roundAttacksData) do
   seen[#seen+1]=table.concat({round.currentRound,action.attacker,action.attackerPos,action.skillMouldId,action.attackerHp,action.attackerSp},':')
  end
 end
 assert(table.concat(seen,'|')==expected,'Replay changed recorded actions')
 table.remove(_ED.attackData.roundData,1) -- original renderer consumes its queue
end
-- The Skip reader consumes the same original round bytes, without a simulator.
local skip=json.decode(json.encode(record))
for _,event in ipairs(skip.events) do if event.kind=='round' then event.kind='skip' end end
assert(reader.read(skip).actions==16)
print('REAL_JOURNAL_PARSED rounds='..result.rounds..' actions='..result.actions)
'''
for key,path in {'PARSER':'01_conteudo_apk/assets/src/client/protocol/ProtocolParserCopy.lua','EXTRA':'01_conteudo_apk/assets/src/client/protocol/ProtocolParserCopyExx.lua','READER':'port/lua/arena_journal_reader.lua','FIXTURE':'build/arena-real-record.json'}.items():
    script=script.replace(key,json.dumps((root/path).as_posix()))
script='assert(loadfile('+json.dumps((root/'01_conteudo_apk/assets/src/cocos/cocos2d/json.lua').as_posix())+'))()\n'+script
utils=(root/'01_conteudo_apk/assets/src/frameworks/external/utils/utils.lua').read_text(encoding='utf8')
script=utils[utils.index('function lua_string_split_line('):utils.index('function split(str, delim, maxNb)')]+script
script=script.replace('LUA_PATH',json.dumps((root/'port/lua').as_posix()))
original=root/'build/arena-original-ProtocolParserCopy.lua'
with zipfile.ZipFile(root.parent/'origem_apk/NinjaRevolution64-1.1.1-64bits.apk') as apk:
    original.write_bytes(apk.read('assets/src/client/protocol/ProtocolParserCopy.lua'))
scripts=[script,script.replace(json.dumps((root/'01_conteudo_apk/assets/src/client/protocol/ProtocolParserCopy.lua').as_posix()),json.dumps(original.as_posix()))]
for variant in scripts:
    state=lua.luaL_newstate()
    try:
        lua.luaL_openlibs(state)
        status=lua.luaL_loadstring(state,variant.encode())
        if not status:status=lua.lua_pcall(state,0,0,0)
        if status:raise AssertionError(lua.lua_tolstring(state,-1,None).decode('utf8','replace'))
    finally:lua.lua_close(state)
