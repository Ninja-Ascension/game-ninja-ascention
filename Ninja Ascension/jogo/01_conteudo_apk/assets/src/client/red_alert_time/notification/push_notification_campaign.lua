cc.Director:getInstance():getTextureCache():addImage("images/ui/bar/tuishong.png")
push_notification_arena_record_count = nil                -- 战地争霸战报
push_arena_integral_reward_count = nil                    -- 战地争霸积分奖励
push_have_integral_reward_count = 0                       -- 战地争霸积分奖励数量
push_arena_all_reward_count = 0                           -- 战地争霸奖励
-- Initialize push notification center state machine.
local function init_push_notification_campaign_terminal()

    local push_notification_campaign_cell_terminal = {
        _name = "push_notification_campaign_cell",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            local id = params._datas._id
            local campaign_type = params._datas._type
            if getCampaignCellAllTip(id,campaign_type) == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = state_machine.excute("util_tips_cretae", 0, {""})
                    ball:setAnchorPoint(cc.p(0.5, 0.5))
                    if __lua_project_id == __lua_project_pacific_rim then
                        ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.3-16, params._widget:getContentSize().height-ball:getContentSize().height*0.3-5))
                    else
                        ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.3, params._widget:getContentSize().height-ball:getContentSize().height*0.3))
                    end
                    params._widget:addChild(ball)
                    params._widget._nodeChild = ball
                    params._widget._istips = true
                end
            else
                if params._widget._istips == true then
                    params._widget:removeChild(params._widget._nodeChild, true)
                    params._widget._nodeChild = nil
                    params._widget._istips = false
                end
            end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    -- 日常
    local push_notification_all_daily_campaign_terminal = {
        _name = "push_notification_all_daily_campaign",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            local is_have_push = false
            for i=1,6 do
                if getCampaignDailyTip(i) == true then
                    is_have_push = true
                    break
                end
            end
            if is_have_push == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = state_machine.excute("util_tips_cretae", 0, {""})
                    ball:setAnchorPoint(cc.p(0.5, 0.5))
                    ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.3, params._widget:getContentSize().height-ball:getContentSize().height*0.3))
                    params._widget:addChild(ball)
                    params._widget._nodeChild = ball
                    params._widget._istips = true
                end
            else
                if params._widget._istips == true then
                    params._widget:removeChild(params._widget._nodeChild, true)
                    params._widget._nodeChild = nil
                    params._widget._istips = false
                end
            end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }
	
	-- 限时
    local push_notification_all_linited_campaign_terminal = {
        _name = "push_notification_all_linited_campaign",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            local is_have_push = false
            for i=1,5 do
                if getCampaignLinitedTip(i) == true then
                    is_have_push = true
                    break
                end
            end
            if is_have_push == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = state_machine.excute("util_tips_cretae", 0, {""})
                    ball:setAnchorPoint(cc.p(0.5, 0.5))
                    ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.3, params._widget:getContentSize().height-ball:getContentSize().height*0.3))
                    params._widget:addChild(ball)
                    params._widget._nodeChild = ball
                    params._widget._istips = true
                end
            else
                if params._widget._istips == true then
                    params._widget:removeChild(params._widget._nodeChild, true)
                    params._widget._nodeChild = nil
                    params._widget._istips = false
                end
            end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

	-- 跨服
    local push_notification_all_inter_service_campaign_terminal = {
        _name = "push_notification_all_inter_service_campaign",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            local is_have_push = false
            for i=1,2 do
                if getCampaignInterServiceTip(i) == true then
                    is_have_push = true
                    break
                end
            end
            if is_have_push == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = state_machine.excute("util_tips_cretae", 0, {""})
                    ball:setAnchorPoint(cc.p(0.5, 0.5))
                    ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.3, params._widget:getContentSize().height-ball:getContentSize().height*0.3))
                    params._widget:addChild(ball)
                    params._widget._nodeChild = ball
                    params._widget._istips = true
                end
            else
                if params._widget._istips == true then
                    params._widget:removeChild(params._widget._nodeChild, true)
                    params._widget._nodeChild = nil
                    params._widget._istips = false
                end
            end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    -- 远征界面重置次数
    local push_notification_campaign_expedition_terminal = {
        _name = "push_notification_campaign_expedition",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            local id = params._datas._id
            if getCampaignDailyTip(id) == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = state_machine.excute("util_tips_cretae", 0, {""})
                    ball:setAnchorPoint(cc.p(0.5, 0.5))
                    ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.3, params._widget:getContentSize().height-ball:getContentSize().height*0.3))
                    params._widget:addChild(ball)
                    params._widget._nodeChild = ball
                    params._widget._istips = true
                end
            else
                if params._widget._istips == true then
                    params._widget:removeChild(params._widget._nodeChild, true)
                    params._widget._nodeChild = nil
                    params._widget._istips = false
                end
            end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    -- 战地争霸未阅读战报
    local push_notification_arena_record_terminal = {
        _name = "push_notification_arena_record",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if getArenaDearonTip() == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = state_machine.excute("util_tips_cretae", 0, {""})
                    ball:setAnchorPoint(cc.p(0.5, 0.5))
                    ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.3, params._widget:getContentSize().height-ball:getContentSize().height*0.3))
                    params._widget:addChild(ball)
                    params._widget._nodeChild = ball
                    params._widget._istips = true
                end
            else
                if params._widget._istips == true then
                    params._widget:removeChild(params._widget._nodeChild, true)
                    params._widget._nodeChild = nil
                    params._widget._istips = false
                end
            end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    -- 战地争霸奖励
    local push_notification_arena_all_reward_terminal = {
        _name = "push_notification_arena_all_reward",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            local count = getArenaAllRewardTip()
            local isChange = false
            if count ~= push_arena_all_reward_count then
                isChange = true
            end
            push_arena_all_reward_count = count
            if count > 0 then
                if isChange == true then
                    if params._widget._istips == true then
                        params._widget:removeChild(params._widget._nodeChild, true)
                        params._widget._nodeChild = nil
                        params._widget._istips = false
                    end
                else
                    -- if params._widget._istips == nil or params._widget._istips == false then
                    --     local ball = state_machine.excute("util_tips_cretae", 0, {count})
                    --     ball:setAnchorPoint(cc.p(0.5, 0.5))
                    --     ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
                    --     params._widget:addChild(ball)
                    --     params._widget._nodeChild = ball
                    --     params._widget._istips = true
                    -- end
                end
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = state_machine.excute("util_tips_cretae", 0, {count})
                    ball:setAnchorPoint(cc.p(0.5, 0.5))
                    ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
                    params._widget:addChild(ball)
                    params._widget._nodeChild = ball
                    params._widget._istips = true
                end
            else
                if params._widget._istips == true then
                    params._widget:removeChild(params._widget._nodeChild, true)
                    params._widget._nodeChild = nil
                    params._widget._istips = false
                end
            end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    -- 战地争霸积分奖励
    local push_notification_arena_integral_reward_terminal = {
        _name = "push_notification_arena_integral_reward",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            local count = getArenaIntegralRewardTip()
            local isChange = false
            if count ~= push_have_integral_reward_count then
                isChange = true
            end
            push_have_integral_reward_count = count
            if count > 0 then
                if isChange == true then
                    if params._widget._istips == true then
                        params._widget:removeChild(params._widget._nodeChild, true)
                        params._widget._nodeChild = nil
                        params._widget._istips = false
                    end
                else
                    -- if params._widget._istips == nil or params._widget._istips == false then
                    --     local ball = state_machine.excute("util_tips_cretae", 0, {""})
                    --     ball:setAnchorPoint(cc.p(0.5, 0.5))
                    --     ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
                    --     params._widget:addChild(ball)
                    --     params._widget._nodeChild = ball
                    --     params._widget._istips = true
                    -- end
                end
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = state_machine.excute("util_tips_cretae", 0, {""})
                    ball:setAnchorPoint(cc.p(0.5, 0.5))
                    ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
                    params._widget:addChild(ball)
                    params._widget._nodeChild = ball
                    params._widget._istips = true
                end
            else
                if params._widget._istips == true then
                    params._widget:removeChild(params._widget._nodeChild, true)
                    params._widget._nodeChild = nil
                    params._widget._istips = false
                end
            end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }
    
    -- 战地争霸排名奖励
    local push_notification_arena_rank_reward_terminal = {
        _name = "push_notification_arena_rank_reward",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if getArenaRankRewardTip() > 0 then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = state_machine.excute("util_tips_cretae", 0, {""})
                    ball:setAnchorPoint(cc.p(0.5, 0.5))
                    ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.3, params._widget:getContentSize().height-ball:getContentSize().height*0.3))
                    params._widget:addChild(ball)
                    params._widget._nodeChild = ball
                    params._widget._istips = true
                end
            else
                if params._widget._istips == true then
                    params._widget:removeChild(params._widget._nodeChild, true)
                    params._widget._nodeChild = nil
                    params._widget._istips = false
                end
            end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }
    
    -- 战地争霸幸运奖励
    local push_notification_arena_lucky_reward_terminal = {
        _name = "push_notification_arena_lucky_reward",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if getArenaLuckyRewardTip() > 0 then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = state_machine.excute("util_tips_cretae", 0, {""})
                    ball:setAnchorPoint(cc.p(0.5, 0.5))
                    ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.3, params._widget:getContentSize().height-ball:getContentSize().height*0.3))
                    params._widget:addChild(ball)
                    params._widget._nodeChild = ball
                    params._widget._istips = true
                end
            else
                if params._widget._istips == true then
                    params._widget:removeChild(params._widget._nodeChild, true)
                    params._widget._nodeChild = nil
                    params._widget._istips = false
                end
            end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    -- 敌军来袭奖励
    local push_notification_enemy_strike_reward_terminal = {
        _name = "push_notification_enemy_strike_reward",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if getEnemyStrikeRewardTip() == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = state_machine.excute("util_tips_cretae", 0, {""})
                    ball:setAnchorPoint(cc.p(0.5, 0.5))
                    ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.3, params._widget:getContentSize().height-ball:getContentSize().height*0.3))
                    params._widget:addChild(ball)
                    params._widget._nodeChild = ball
                    params._widget._istips = true
                end
            else
                if params._widget._istips == true then
                    params._widget:removeChild(params._widget._nodeChild, true)
                    params._widget._nodeChild = nil
                    params._widget._istips = false
                end
            end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    -- 城市战领取分红
    local push_notification_legion_city_reward_terminal = {
        _name = "push_notification_legion_city_reward",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if getLegionCityRewardTip() == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = state_machine.excute("util_tips_cretae", 0, {""})
                    ball:setAnchorPoint(cc.p(0.5, 0.5))
                    ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.3, params._widget:getContentSize().height-ball:getContentSize().height*0.3))
                    params._widget:addChild(ball)
                    params._widget._nodeChild = ball
                    params._widget._istips = true
                end
            else
                if params._widget._istips == true then
                    params._widget:removeChild(params._widget._nodeChild, true)
                    params._widget._nodeChild = nil
                    params._widget._istips = false
                end
            end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    state_machine.add(push_notification_campaign_cell_terminal)
    state_machine.add(push_notification_all_daily_campaign_terminal)
    state_machine.add(push_notification_all_linited_campaign_terminal)
    state_machine.add(push_notification_all_inter_service_campaign_terminal)
    state_machine.add(push_notification_campaign_expedition_terminal)
    state_machine.add(push_notification_arena_record_terminal)
    state_machine.add(push_notification_arena_all_reward_terminal)
    state_machine.add(push_notification_arena_integral_reward_terminal)
    state_machine.add(push_notification_arena_rank_reward_terminal)
    state_machine.add(push_notification_arena_lucky_reward_terminal)
    state_machine.add(push_notification_enemy_strike_reward_terminal)
    state_machine.add(push_notification_legion_city_reward_terminal)
    state_machine.init()
end
init_push_notification_campaign_terminal()

function getCampaignCellAllTip(id,campaign_type)
    if campaign_type == 1 then
        if getCampaignDailyTip(id) == true then
            return true
        end
    elseif campaign_type == 2 then
        if getCampaignLinitedTip(id) == true then
            return true
        end
    elseif campaign_type == 3 then
        if getCampaignInterServiceTip(id) == true then
            return true
        end
    end
    return false 
end

-- 日常
function getCampaignDailyTip(id)
    if id == 1 then
        -- 战地争霸
        if funOpenDrawTip(154,false) == false then
            local have_attack_times = 0
            local leave_time = 0
            if _ED.arena_info.arena_id == nil or _ED.arena_info.arena_id == "" then
                if  _ED.mould_function_push_info["1"] ~= nil then
                    local params = zstring.split(_ED.mould_function_push_info["1"].params, ",") 
                    have_attack_times = zstring.tonumber(params[2])
                    leave_time = math.floor(zstring.tonumber(params[3]) / 1000) - (os.time() + _ED.time_add_or_sub)
                end
            else
                leave_time = zstring.tonumber(_ED.arena_info.fight_cooling_time) - (os.time() + _ED.time_add_or_sub)
                have_attack_times = zstring.tonumber(_ED.arena_info.leave_attack_count)
            end
            if have_attack_times > 0 
                and leave_time <= 0 then
                return true
            end
        end
    elseif id == 2 then
        -- 远征
        if funOpenDrawTip(218,false) == false then
            local have_reset_times = 0
            local reset_times = dms.int(dms["base_consume"], 94, base_consume.vip_0_value + tonumber(_ED.vip_grade))
            if _ED.expedition_shop_info == nil then
                if _ED.mould_function_push_info["2"] ~= nil then
                    local params = _ED.mould_function_push_info["2"].params
                    have_reset_times = reset_times - tonumber(params)
                end
            else
                have_reset_times = reset_times - zstring.tonumber(_ED.user_expedition_info.reset_enemy_count)
            end
            if have_reset_times > 0 then
                return true
            end
        end
    elseif id == 3 then
        if funOpenDrawTip(219,false) == false then
            if _ED.mould_function_push_info["3"] ~= nil then
                if tonumber(_ED.mould_function_push_info["3"].state) > 0 then
                    return true
                end
            end
        end
    elseif id == 4 then
        if funOpenDrawTip(220,false) == false then
            if _ED.mould_function_push_info["4"] ~= nil then
                if tonumber(_ED.mould_function_push_info["4"].state) == 1 then
                    return true
                end
            end
        end
    elseif id == 5 then
        if funOpenDrawTip(221,false) == false then
            if _ED.mould_function_push_info["5"] ~= nil then
                if tonumber(_ED.mould_function_push_info["5"].state) == 1 then
                    return true
                end
            end
        end
    elseif id == 6 then
        -- 极限挑战
        if funOpenDrawTip(222,false) == false then
            local attack_times = dms.int(dms["limit_challenge_config"],2,limit_challenge_config.param)
            local have_attack_times = attack_times
            if _ED.user_extreme_info.reset_times ~= nil then
                have_attack_times = attack_times - zstring.tonumber(_ED.user_extreme_info.reset_times)
            else
                if _ED.mould_function_push_info["6"] ~= nil then
                    local params = zstring.split(_ED.mould_function_push_info["6"].params, ",") 
                    have_attack_times = attack_times - zstring.tonumber(params[1])
                end
            end
            if have_attack_times > 0 then
                return true
            end
        end
    end
    return false 
end

-- 限时
function getCampaignLinitedTip(id)
    if id == 1 then
        -- 军团争霸
        if funOpenDrawTip(155, false) == false then
            -- if _ED.union.union_info == nil 
            --     or _ED.union.union_info == {} 
            --     or _ED.union.union_info.union_id == nil 
            --     or _ED.union.union_info.union_id == "" 
            --     or tonumber(_ED.union.union_info.union_id) == 0 then
            --     return false
            -- end
            if _ED.mould_function_push_info["9"] ~= nil then
                if tonumber(_ED.mould_function_push_info["9"].state) == 1 
                    or tonumber(_ED.mould_function_push_info["9"].state) == 2 
                    or tonumber(_ED.mould_function_push_info["9"].state) == 3
                    then
                    return true
                end 
            end
        end
    elseif id == 2 then
        -- 阵营战
        if funOpenDrawTip(224, false) == false then
            if _ED.mould_function_push_info["10"] ~= nil then
                if tonumber(_ED.mould_function_push_info["10"].state) > 0 then
                    return true
                end 
            end
        end
    elseif id == 3 then
        -- 守卫战
        if funOpenDrawTip(225, false) == false then
            if _ED.mould_function_push_info["13"] ~= nil then
                if tonumber(_ED.mould_function_push_info["13"].state) > 0 then
                    return true
                end 
            end
        end
    elseif id == 5 then
        -- -- 城市战
        -- if funOpenDrawTip(244, false) == false then
        --     if _ED.mould_function_push_info["14"] ~= nil then
        --         if tonumber(_ED.mould_function_push_info["14"].state) > 0 then
        --             return true
        --         end 
        --     end
        -- end
    end
    return false 
end

-- 跨服
function getCampaignInterServiceTip(id)

    return false 
end

-- 战地争霸战报
function getArenaDearonTip()
    if push_notification_arena_record_count == nil then
        local max_number = dms.string(dms["arena_config"],12,arena_config.param)
        local max_numberInfo = zstring.split(max_number, ",")
        push_notification_arena_record_count = tonumber(max_numberInfo[1])
    end
    if _ED.city_resource_battle_report ~= nil and _ED.city_resource_battle_report[11] ~= nil then
        for i, v in pairs(_ED.city_resource_battle_report[11]) do
            if i <= push_notification_arena_record_count then
                if zstring.tonumber(v.read_type) == 0 then
                    return true
                end
            end
        end
    end
    return false 
end

-- 战地争霸奖励
function getArenaAllRewardTip()
    return getArenaIntegralRewardTip() + getArenaRankRewardTip() + getArenaLuckyRewardTip()
end

-- 战地争霸积分奖励
function getArenaIntegralRewardTip()
    local count = 0
    if push_arena_integral_reward_count == nil then    
        push_arena_integral_reward_count = table.nums(dms["arena_score"])
    end
    if _ED.arena_info ~= nil and _ED.arena_info.state_group ~= nil then
        local state_group = zstring.split(_ED.arena_info.state_group, ",")
        for i=1, push_arena_integral_reward_count do
            if tonumber(_ED.arena_info.integral) >= i*2 then
                if tonumber(state_group[i]) == 0 then
                    count = count + 1
                end
            end
        end
    end
    return count 
end

-- 战地争霸排名奖励
function getArenaRankRewardTip()
    local count = 0
    if _ED.arena_info ~= nil then
        if tonumber(_ED.arena_info.settlement_state) == 0 then
            count = 1
        end
    end
    return count 
end

-- 战地争霸幸运奖励
function getArenaLuckyRewardTip()
    local count = 0
    local have_reward = false
    if table.nums(_ED.arena_lucky_ranking) > 0 then
        for i,v in pairs(_ED.arena_lucky_ranking) do
            if tonumber(v.previous_period_lucky_rank_id) == tonumber(_ED.user_info.user_id) then
                have_reward = true
                break
            end
        end
    end
    if _ED.arena_info.lucky_state ~= nil 
        and tonumber(_ED.arena_info.lucky_state) == 0 
        and have_reward == true then
        count = 1
    end
    return count 
end

function getEnemyStrikeRewardTip()
    if _ED.user_enemy_strike_info ~= nil and _ED.last_enemy_strke_join_times ~= nil then
        if _ED.last_enemy_strke_join_times < tonumber(_ED.user_enemy_strike_info.join_times) then
            return true
        end
    end
    return false
end

function getLegionCityRewardTip()
    if _ED.world_city_info ~= nil and _ED.world_city_info.my_info ~= nil then
        local open_state = 0
        if _ED.mould_function_push_info["14"] ~= nil then
            open_state = tonumber(_ED.mould_function_push_info["14"].state)
        end
        if open_state == 0 and tonumber(_ED.world_city_info.my_info.reward_state) == 1 then
            return true
        end
    end
    return false
end

