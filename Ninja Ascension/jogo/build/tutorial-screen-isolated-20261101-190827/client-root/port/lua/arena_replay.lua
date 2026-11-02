-- Archive the actual init/report packets emitted by the existing live engine.
-- Playback feeds those same packets to the original parsers; no fight is run.
-- Version 1 can feed complete protocol-39 reports to the existing reader.
-- Version 2 archives incremental PC output for the original action/round parsers;
-- it must never be mistaken for the original server's complete report format.
local M={}
local function append(capture,kind,raw,round)
    if not capture or capture.overflow or type(raw)~='string' or raw=='' then return end
    capture.bytes=capture.bytes+#raw
    if capture.bytes>1024*1024 or #capture.events>=4096 then capture.overflow=true;return end
    capture.events[#capture.events+1]={kind=kind,round=round,dataHex=(raw:gsub('.',function(c) return ('%02x'):format(c:byte()) end))}
    if kind~='protocol' then capture.hasActions=true end
end
local function detach()
    if M.capture and M.capture.engine then
        for name,original in pairs(M.capture.originals) do M.capture.engine[name]=original end
    end
end
local function hex(value) return (value:gsub('.',function(c) return ('%02x'):format(c:byte()) end)) end
local function unhex(value)
    assert(type(value)=='string' and #value%2==0 and not value:find('[^%da-fA-F]'),'Arena: invalid packet encoding')
    return (value:gsub('..',function(v) return string.char(tonumber(v,16)) end))
end
local function command(packet)
    return packet:match('^[^\r\n]+[\r\n]+([^\r\n]+)')
end
function M.install()
    if M.installed then return end
    M.installed=true
    local parse=NetworkProtocol.parser_func
    NetworkProtocol.parser_func=function(data,...)
        local capture=M.capture
        local raw=data and data.resouce
        local result={parse(data,...)}
        if capture and capture==M.capture and type(raw)=='string' and #raw<=4*1024*1024 then
            local cmd=command(raw)
            if cmd=='battle_field_init' then capture.init=raw
            elseif cmd=='environment_fight' then capture.fight=raw end
            if cmd=='battle_field_init' or cmd=='fight_battle_report_info' or (cmd and cmd:match('^environment_fight')) then append(capture,'protocol',raw) end
        end
        return unpack(result)
    end
    if not NetworkProtocol.find_parser(15981) then
        table.insert(NetworkProtocol.protocol_parses,{code=15981,parser='nr_arena_recorded_report',parser_fun=function(_,_,_,_,list)
            _ED.nr_arena_recorded_packets=json.decode(npos(list))
        end})
    end
end
function M.play(record)
    assert(record and (record.version==1 or record.version==2),'Arena: recorded packets missing')
    detach()
    M.capture=nil
    _ED._fightModule=nil
    _ED.nr_arena_fight_active=nil
    _ED.nr_arena_fight_rank=nil
    _ED.nr_arena_fight_match_id=nil
    _ED.nr_arena_fight_replay=nil
    _ED.nr_arena_recorded_packets=nil
    _ED.battle_report_info=nil
    if record.version==2 then
        require('arena_journal_reader').read(record)
        _ED.user_info.last_user_grade=_ED.user_info.user_grade
        _ED.user_info.last_user_food=_ED.user_info.user_food
        _ED.user_info.last_endurance=_ED.user_info.endurance
    else
        local init=unhex(record.initHex);local fight=unhex(record.fightHex)
        assert(command(init)=='battle_field_init' and command(fight)=='environment_fight','Arena: invalid recorded packet')
        NetworkProtocol.parser_func({resouce=init})
        NetworkProtocol.parser_func({resouce=fight})
    end
    if record.uiBattleData then _ED.arena_battle_data=record.uiBattleData end
    assert(_ED.battleData and _ED.attackData and _ED.attackData.roundData,'Arena: report parser did not restore battle data')
    _ED.battleData.battle_init_type=_enum_fight_type._fight_type_11
end
function M.start(matchId,engine)
    M.install()
    detach()
    M.capture=matchId and {matchId=matchId,events={},bytes=0,depth=0,engine=engine,originals={}} or nil
    local capture=M.capture
    if capture and engine then
        local function wrap(name,bufferIndex,kind)
            local original=engine[name]
            if type(original)~='function' then return end
            capture.originals[name]=original
            engine[name]=function(self,...)
                local args={...};local buffer=args[bufferIndex];local first=type(buffer)=='table' and #buffer+1
                local outer=capture.depth==0
                local round=tonumber(self.roundCount)
                capture.depth=capture.depth+1
                local result={original(self,...)}
                capture.depth=capture.depth-1
                if outer and first and M.capture==capture then
                    local emitted={};for i=first,#buffer do emitted[#emitted+1]=tostring(buffer[i]) end
                    append(capture,kind,table.concat(emitted,''),kind=='action' and round or nil)
                end
                return unpack(result)
            end
        end
        wrap('rountdFight',1,'round')
        wrap('fightObjectAttack',2,'action')
        wrap('jumpFight',2,'skip')
        wrap('jumpCurrentFight',2,'skip')
    end
end
function M.finish(matchId,win)
    local capture=M.capture
    detach()
    M.capture=nil
    if not capture or capture.matchId~=matchId or not capture.init or capture.overflow then
        print('NR_ARENA_REPLAY complete historical packets unavailable; replay not stored')
        return nil
    end
    if not capture.fight then
        if not capture.hasActions or #capture.events<2 or (tostring(win)~='0' and tostring(win)~='1') then return nil end
        return json.encode({version=2,matchId=matchId,win=tostring(win),initHex=hex(capture.init),events=capture.events})
    end
    if win~=nil then
        local fields={};for value in capture.fight:gmatch('%S+') do fields[#fields+1]=value;if #fields==5 then break end end
        if fields[4]~='39' or fields[5]~=tostring(win) then
            print('NR_ARENA_REPLAY final report unavailable; settlement retained without replay')
            return nil
        end
    end
    return json.encode({version=1,initHex=hex(capture.init),fightHex=hex(capture.fight)})
end
return M
