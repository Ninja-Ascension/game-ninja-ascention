-- Initialize push notification center state machine.
local function init_push_notification_center_sm_special_duplicate_terminal()
	--数码首页特殊副本推送
    local push_notification_center_sm_special_duplicate_all_terminal = {
        _name = "push_notification_center_sm_special_duplicate_all",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getSmSpecialDuplicateAllTips(params) == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
					ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
					if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                        ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5+12, params._widget:getContentSize().height-ball:getContentSize().height*0.5+10))
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
    --数码净化推送
    local push_notification_center_sm_purify_duplicate_terminal = {
        _name = "push_notification_center_sm_purify_duplicate",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getSmPurifyDuplicateTips(params) == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(0.5, 0.5))
					ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
					if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                        ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5-15, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
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

    --数码试炼奖励
    local push_notification_center_sm_trial_tower_reward_terminal = {
        _name = "push_notification_center_sm_trial_tower_reward",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getSmTrialTowerRewardTips(params) == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(0.5, 0.5))
					ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
					if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                        ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5-15, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
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

    -- 探索入口红点
    local push_notification_center_sm_exploration_terminal = {
        _name = "push_notification_center_sm_exploration",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if getSmExploration(params) == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = cc.Sprite:create("images/ui/bar/tips.png")
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

    -- 文件岛入口红点
    local push_notification_center_sm_fileIsland_terminal = {
        _name = "push_notification_center_sm_fileIsland",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if getSmFileIsland(params) == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = cc.Sprite:create("images/ui/bar/tips.png")
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

    -- 文件岛好友列表红点
    local push_notification_fileIsland_friend_cell_push_terminal = {
        _name = "push_notification_fileIsland_friend_cell_push",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if params._widget._istips == true then
                params._widget:removeChild(params._widget._nodeChild, true)
                params._widget._nodeChild = nil
                params._widget._istips = false
            end
                
            if get_fileIsland_friend_cell_push(params) == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = cc.Sprite:create("images/ui/bar/tips.png")
                    ball:setPosition(cc.p(ball:getContentSize().width / 2, params._widget:getContentSize().height - ball:getContentSize().height))
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

    -- boss icon红点
    local push_notification_fileIsland_boss_icon_push_terminal = {
        _name = "push_notification_fileIsland_boss_icon_push",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if get_fileIsland_boss_icon_push(params) == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = cc.Sprite:create("images/ui/bar/tips.png")
                    ball:setAnchorPoint(cc.p(1, 1))
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

    -- 探索boss icon红点
    local push_notification_exploration_boss_icon_push_terminal = {
        _name = "push_notification_exploration_boss_icon_push",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if get_exploration_boss_icon_push(params) == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = cc.Sprite:create("images/ui/bar/tips.png")
                    ball:setAnchorPoint(cc.p(1, 1))
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

    -- 好友任务icon红点
    local push_notification_fileIsland_friend_icon_push_terminal = {
        _name = "push_notification_fileIsland_friend_icon_push",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if get_fileIsland_friend_icon_push(params) == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = cc.Sprite:create("images/ui/bar/tips.png")
                    ball:setAnchorPoint(cc.p(1, 1))
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

    -- 单次探索按钮红点
    local push_notification_fileIsland_update_search_1_btn_push_terminal = {
        _name = "push_notification_fileIsland_update_search_1_btn_push",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if get_fileIsland_update_search_1_btn_push(params) == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = cc.Sprite:create("images/ui/bar/tips.png")
                    ball:setPosition(cc.p(params._widget:getContentSize().width - 35, params._widget:getContentSize().height - 10))
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

    -- 一键探索按钮红点
    local push_notification_fileIsland_update_search_all_btn_push_terminal = {
        _name = "push_notification_fileIsland_update_search_all_btn_push",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if get_fileIsland_update_search_all_btn_push(params) == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = cc.Sprite:create("images/ui/bar/tips.png")
                    ball:setPosition(cc.p(params._widget:getContentSize().width - 35, params._widget:getContentSize().height - 10))
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

    state_machine.add(push_notification_center_sm_special_duplicate_all_terminal)
    state_machine.add(push_notification_center_sm_purify_duplicate_terminal)
    state_machine.add(push_notification_center_sm_trial_tower_reward_terminal)

    state_machine.add(push_notification_center_sm_exploration_terminal)

    state_machine.add(push_notification_center_sm_fileIsland_terminal)
    state_machine.add(push_notification_fileIsland_friend_cell_push_terminal)
    state_machine.add(push_notification_fileIsland_boss_icon_push_terminal)
    state_machine.add(push_notification_exploration_boss_icon_push_terminal)
    state_machine.add(push_notification_fileIsland_friend_icon_push_terminal)
    state_machine.add(push_notification_fileIsland_update_search_1_btn_push_terminal)
    state_machine.add(push_notification_fileIsland_update_search_all_btn_push_terminal)
    state_machine.init()
end
init_push_notification_center_sm_special_duplicate_terminal()

function getSmSpecialDuplicateAllTips(notificationer)
	if getSmPurifyDuplicateTips() == true then
		return true
	end
	if getSmTrialTowerRewardTips() == true then
		return true
	end
    if getSmFileIsland() == true then
        return true
    end
    if getSmExploration() == true then
        return true
    end
	return false
end

function getSmPurifyDuplicateTips(notificationer)
    if funOpenDrawTip(93, false) == true then
    	return false
    end

    if _ED.digital_purify_info == nil then
        -- TODO 减少进入游戏前端向后端请求的次数
    	-- protocol_command.ship_purify_init.param_list = ""
     --    NetworkManager:register(protocol_command.ship_purify_init.code, nil, nil, nil, nil, nil, false, nil)
    	return false
    end	
    if _ED.digital_purify_info ~= nil 
        and _ED.digital_purify_info._team_info ~= nil 
        and next(_ED.digital_purify_info._team_info) == nil
        then
        return true
    end
    if _ED.digital_purify_info ~= nil 
    	and _ED.digital_purify_info._team_info ~= nil 
    	and _ED.digital_purify_info._team_info.team_type ~= nil
    	and _ED.digital_purify_info._team_info.team_type >= 0 
    	then
    	local user_info = nil
    	for k, v in pairs(_ED.digital_purify_info._team_info.members) do
    		if tonumber(v.user_id) == tonumber(_ED.user_info.user_id) then
    			user_info = v
    			break
    		end
    	end
    	if user_info ~= nil then
    		local complete_count = tonumber(user_info.complete_count)
    		local max_count = tonumber(zstring.split(dms.string(dms["play_config"], 20, play_config.param), ",")[2])
    		if complete_count < max_count then
    			return true
    		end
    	end
    end
    return false
end

function getSmTrialTowerRewardTips(notificationer)
	if funOpenDrawTip(92, false) == true then
    	return false
    end
    if _ED.user_try_highest_score_reward_state == nil then
        -- TODO 减少进入游戏前端向后端请求的次数
    	-- protocol_command.three_kingdoms_init.param_list = ""
     --    NetworkManager:register(protocol_command.three_kingdoms_init.code, nil, nil, nil, nil, nil, false, nil)
    	return false
    end	

	if _ED.user_try_highest_score_reward_state ~= nil then
		for i = 1, dms.count(dms["three_kingdoms_score_reward_param"]) do
			if _ED.user_try_highest_score_reward_state[""..i] == nil then
				local integral = dms.int(dms["three_kingdoms_score_reward_param"], i, three_kingdoms_score_reward_param.need_integral)
				if integral <= zstring.tonumber(_ED.user_try_highest_integral) then
					return true
				else
					return false
				end
			end
		end
	end
    return false
end

function get_fileIsland_friend_cell_push(params)
    local index = params._datas._index
    local all = params._datas._data

    local data = all[index]
    if data.cellType == 1 then
        if data.curProgress == 0 then
            return true
        else
            return false
        end

    -- 协作
    elseif data.cellType == 2 then
        if data.curProgress == 0 then
            return true
        else
            return false
        end

    -- 加入
    elseif data.cellType == 3 then
        local complete = false
        for i = 1, #data.rewardFriends do
            if data.rewardFriends[i] == tonumber(_ED.user_info.user_id) then
                complete = true
                break
            end
        end

        if complete == false then
            return true
        else
            return false
        end
    end

    return false
end

function get_fileIsland_boss_icon_push(params)
    if _ED.fileIsland == nil or _ED.fileIsland.bossInfo == nil then
        return false
    end

    local bossInfo = _ED.fileIsland.bossInfo.bossInfo

    local ret = false
    for i = 1, #bossInfo do
        local info = bossInfo[i]
        -- 我发现的boss，并且没有挑战
        if info.uid == tonumber(_ED.user_info.user_id) and info.curProgress == 0 then
            ret = true
            break
        end
    end
    return ret
end

function get_exploration_boss_icon_push(params)
    if _ED.pokemonExplore == nil or _ED.pokemonExplore.bossInfo == nil then
        return false
    end

    local bossInfo = _ED.pokemonExplore.bossInfo.bossInfo

    local ret = false
    for i = 1, #bossInfo do
        local info = bossInfo[i]
        -- 我发现的boss，并且没有挑战
        if info.uid == tonumber(_ED.user_info.user_id) and info.curProgress == 0 then
            ret = true
            break
        end
    end
    return ret
end

function get_fileIsland_friend_icon_push(params)
    -- print("日志get_fileIsland_friend_icon_push 1")
    if _ED.fileIsland == nil or _ED.fileIsland.taskInfo == nil then
        return false
    end

    -- print("日志get_fileIsland_friend_icon_push 2")

    local taskInfo = _ED.fileIsland.taskInfo

    -- 我的任务
    local taskInfo1 = {}

    for i = 1, #taskInfo.mySingleTaskInfo do
        local data = taskInfo.mySingleTaskInfo[i]
        data.cellType = 1
        data.listType = 1
        table.insert(taskInfo1, data)
    end

    for i = 1, #taskInfo.myJoinTaskInfo do
        local data = taskInfo.myJoinTaskInfo[i]
        data.cellType = 3
        data.listType = 1
        table.insert(taskInfo1, data)
    end

    for i = 1, #taskInfo.myMultiTaskInfo do
        local data = taskInfo.myMultiTaskInfo[i]
        data.cellType = 2
        data.listType = 1
        table.insert(taskInfo1, data)
    end

    for i = 1, #taskInfo1 do
        
        local data = taskInfo1[i]
        if data.cellType == 1 then
            if data.curProgress == 0 then
                return true
            end

        elseif data.cellType == 2 then
            if data.curProgress == 0 then
                return true
            end

        elseif data.cellType == 3 then
            local complete = false
            for i = 1, #data.rewardFriends do
                if data.rewardFriends[i] == tonumber(_ED.user_info.user_id) then
                    complete = true
                    break
                end
            end

            if complete == false then
                return true
            end
        end

    end

    return false

end

function get_fileIsland_update_search_1_btn_push()
    if _ED.fileIsland and _ED.fileIsland.searchPoint then
        if tonumber(_ED.fileIsland.searchPoint) > 0 then
            return true
        end
    end
    return false
end

function get_fileIsland_update_search_all_btn_push()
    if _ED.fileIsland and _ED.fileIsland.searchPoint then
        if tonumber(_ED.fileIsland.searchPoint) >= 2 then
            return true
        end
    end
    return false
end


function getSmFileIsland(notificationer)
    if funOpenDrawTip(94, false) == true then
        return false
    end

    if _ED.fileIsland == nil then
        return false
    end

    if zstring.tonumber(_ED.fileIsland.taskRedPoint) == 1 or get_fileIsland_update_search_1_btn_push() or get_fileIsland_friend_icon_push() or get_fileIsland_boss_icon_push() then
        return true
    end

    return false
end

-- 积分红点
function getExplorationScorRedot()
    for i = 1, #dms["role_explore_daily_score"] do
        local needScore = dms.int(dms["role_explore_daily_score"], i, 2)
        local scoreCompelet = _ED.pokemonExplore.scoreInfo.todayScoreR
        local curScore = _ED.pokemonExplore.scoreInfo.todayScore
        if (table.containValue(scoreCompelet, "" .. i) or table.containValue(scoreCompelet, i)) then -- 已经领取
        else
            if tonumber(curScore) >= needScore then --已完成
                return true
            end
        end
    end

    for i = 1, #dms["role_explore_gather_score"] do
        local needScore = dms.int(dms["role_explore_gather_score"], i, 2)
        local scoreCompelet = _ED.pokemonExplore.scoreInfo.totalScoreR
        local curScore = _ED.pokemonExplore.scoreInfo.totalScore
        if (table.containValue(scoreCompelet, "" .. i) or table.containValue(scoreCompelet, i)) then -- 已经领取
        else
            if tonumber(curScore) >= needScore then
                return true
            end
        end
    end

    return false
end

--
function getSmExploration()
    if funOpenDrawTip(94, false) == true then
        return false
    end

    if _ED.pokemonExplore == nil then
        return false
    end

    if _ED.pokemonExplore and _ED.pokemonExplore.searchPoint then
        local minPoint = dms.int(dms["play_config"], 124, play_config.param)
        if tonumber(_ED.pokemonExplore.searchPoint) >= minPoint then
            return true
        end
    end

    if getExplorationScorRedot() then
        return true
    end

    if get_exploration_boss_icon_push() then
        return true
    end

    return false
end

