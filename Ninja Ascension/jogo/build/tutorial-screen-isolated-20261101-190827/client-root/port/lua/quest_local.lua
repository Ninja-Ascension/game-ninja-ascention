local M={}
function M.install()
    -- install() also runs before the protocol table exists (battle_lifecycle
    -- reinstalls after every app.load); wait for it like shop_local does.
    if not NetworkProtocol or not NetworkProtocol.protocol_parses or NetworkProtocol.find_parser(15992) then return end
    table.insert(NetworkProtocol.protocol_parses,{code=15992,parser='local_quest',parser_fun=function(_,_,_,_,list)
        local info=json.decode(npos(list))
        _ED.local_quest_enabled=true
        _ED.daily_task_info={};_ED.user_reset_is=true
        _ED.daily_task_achievement=_ED.daily_task_achievement or {}
        _ED.local_quest_wallet=info.wallet
        if info.wallet['34'] then _ED.user_info.talent_point=tonumber(info.wallet['34']) end
        if info.wallet['67'] then _ED.maxtrix_essence_num=tonumber(info.wallet['67']) end
        local fields={tostring(info.points),table.concat(info.boxes,','),tostring(#info.tasks)}
        for _,task in ipairs(info.tasks) do
            for _,name in ipairs({'daily_task_id','daily_task_mould_id','daily_task_complete_count','daily_task_param'}) do table.insert(fields,task[name]) end
        end
        fields.pos=1
        NetworkProtocol.find_parser(361).parser_fun(nil,nil,nil,nil,fields,nil)
    end})
end
return M
