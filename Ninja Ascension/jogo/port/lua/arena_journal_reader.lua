-- Read saved output using the game's original action/round parsers.
-- No FightModule, target selection, random rolls or damage calculation.
local M={}
local function decode(value)
    assert(type(value)=='string' and #value%2==0 and not value:find('[^%da-fA-F]'),'Arena: invalid journal bytes')
    return (value:gsub('..',function(v) return string.char(tonumber(v,16)) end))
end
local function tokens(raw)
    local list=lua_string_splits(lua_string_split_line(raw,'\r\n'),' ')
    while list[#list]=='' do table.remove(list) end
    list.pos=1
    return list
end
function M.read(record)
    assert(record.version==2 and (record.win=='0' or record.win=='1'),'Arena: invalid journal')
    assert(type(parse_environment_fight_role_round_attack_data)=='function' and type(parse_environment_fight_round_attack_data)=='function','Arena: original battle parsers unavailable')
    local rounds={};local currentRound=1;local maxRound=0;local actions=0
    local function add(round,action)
        round=assert(tonumber(round),'Arena: missing round')
        assert(round>=1 and round<=1000 and round==math.floor(round),'Arena: invalid round')
        local target=rounds[round]
        if not target then target={currentRound=tostring(round),curAttackCount=0,roundAttacksData={}};rounds[round]=target end
        target.curAttackCount=target.curAttackCount+1
        target.roundAttacksData[target.curAttackCount]=action
        maxRound=math.max(maxRound,round);actions=actions+1
    end
    local init=decode(record.initHex)
    NetworkProtocol.parser_func({resouce=init})
    assert(_ED.battleData and _ED.battleData.battle_init_type==11,'Arena: journal is not an Arena battle')
    _ED.attackData={roundData={}}
    for _,event in ipairs(record.events) do
        local raw=decode(event.dataHex)
        local list=tokens(raw)
        if event.kind=='protocol' then
            -- initHex is also in the journal; parse it only once so it cannot
            -- discard influences accumulated by subsequent packets.
            if raw~=init then
                assert(list[2] and (list[2]:match('^environment_fight') or list[2]=='fight_battle_report_info'),'Arena: unrelated journal protocol')
                NetworkProtocol.parser_func({resouce=raw})
            end
            if list[4]=='14711' then currentRound=assert(tonumber(list[5])) end
        elseif event.kind=='action' then
            local action={}
            parse_environment_fight_role_round_attack_data(nil,nil,0,nil,list,nil,action)
            assert(list.pos==#list+1,'Arena: incomplete action packet')
            add(event.round or currentRound,action)
        elseif event.kind=='round' or event.kind=='skip' then
            while list.pos<=#list do
                local before=list.pos
                parse_environment_fight_round_attack_data(nil,nil,0,nil,list,nil,1)
                assert(list.pos>before and list.pos<=#list+1,'Arena: incomplete round packet')
                local block=assert(_ED.attackData.roundData[1])
                for _,action in ipairs(block.roundAttacksData) do add(block.currentRound,action) end
            end
        else error('Arena: unsupported journal event') end
    end
    assert(actions>0,'Arena: empty historical battle')
    local ordered={}
    for round=1,maxRound do
        assert(rounds[round],'Arena: missing historical round')
        ordered[#ordered+1]=rounds[round]
    end
    _ED.attackData={isWin=record.win,totalRoundCount=record.totalRound or 10,roundCount=maxRound,roundData=ordered}
    return {rounds=maxRound,actions=actions}
end
return M
