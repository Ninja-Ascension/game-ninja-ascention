-- Initialize push notification center state machine.

pushNotificationBattleAll = false
pushNotificationZhuxian = false
pushNotificationMingjiang = false
pushNotificationDailyDupilcate = false
pushNotificationHeroDupilcate = false

local function init_push_notification_center_battle_terminal()
	--主页的副本按钮的推送
    local push_notification_center_battle_all_terminal = {
        _name = "push_notification_center_battle_all",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getBattleAllTips() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
						ball:setAnchorPoint(cc.p(0.5, 0))
					else
						ball:setAnchorPoint(cc.p(1, 1))
					end
					
					if __lua_project_id == __lua_project_koone then
						ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height))
					elseif __lua_project_id == __lua_project_yugioh 
						or __lua_project_id == __lua_project_rouge
						then
						ball:setPosition(cc.p(params._widget:getContentSize().width - 10, params._widget:getContentSize().height))
					else
						ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width, params._widget:getContentSize().height-ball:getContentSize().height))
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
	--副本界面名将副本按钮的推送
	local push_notification_center_battle_mingjiang_terminal = {
        _name = "push_notification_center_battle_mingjiang",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getBattleMingjiangAllTips() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(0.5, 0))
					ball:setPosition(cc.p(params._widget:getContentSize().width*9/10, params._widget:getContentSize().height-ball:getContentSize().height))
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
	--副本界面日常副本按钮的推送
	local push_notification_center_battle_richang_terminal = {
        _name = "push_notification_center_battle_richang",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getBattleRichangAllTips() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(0.5, 0))
					ball:setPosition(cc.p(params._widget:getContentSize().width*9/10, params._widget:getContentSize().height-ball:getContentSize().height))
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
	--副本界面普通副本焦点按钮的推送
	local push_notification_center_battle_all_the_chest_terminal = {
        _name = "push_notification_center_battle_all_the_chest",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getBattleZhuxianAllTips() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(0.5, 1))
					ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width, params._widget:getContentSize().height-ball:getContentSize().height))
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
	--副本界面主线副本按钮的推送
	local push_notification_center_battle_ordinary_the_chest_terminal = {
        _name = "push_notification_center_battle_ordinary_the_chest",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getBattleZhuxianAllTips() == true and params._widget.isPush == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(0.5, 0))
					ball:setPosition(cc.p(params._widget:getContentSize().width*9/10, params._widget:getContentSize().height-ball:getContentSize().height))
					params._widget:addChild(ball)
					params._widget._nodeChild = ball
					params._widget._istips = true
				end
				--print("=============true",params._widget:getName(),getBattleZhuxianAllTips(),params._widget.isPush,getBattleTheChestAllTips(),getBattleCheckBoxStateTips())
			else
				if params._widget._istips == true then
					params._widget:removeChild(params._widget._nodeChild, true)
					params._widget._nodeChild = nil
					params._widget._istips = false
				end
				--print("=============false",params._widget:getName(),getBattleZhuxianAllTips(),params._widget.isPush,getBattleTheChestAllTips(),getBattleCheckBoxStateTips())
			end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }
	--pve场景管理界面内的普通副本按钮推送
	local push_notification_center_battle_list_ordinary_the_chest_terminal = {
        _name = "push_notification_center_battle_list_ordinary_the_chest",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getBattleZhuxianAllTips() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(0, 0))
					ball:setPosition(cc.p(0, params._widget:getContentSize().height-ball:getContentSize().height))
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
	--副本界面宝箱按钮的推送
	local push_notification_center_battle_current_scene_the_chest_terminal = {
        _name = "push_notification_center_battle_current_scene_the_chest",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getCurrentSceneTheChestTips(tonumber(_ED._current_scene_id)) == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(0.5, 0))
					ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height-ball:getContentSize().height))
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
	--副本界面选项卡的有课领取的关卡宝箱推送
	local push_notification_center_battle_list_scene_the_chest_terminal = {
        _name = "push_notification_center_battle_list_scene_the_chest",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getCurrentlistSceneTheChestTips(params._widget._data) == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
						ball:setAnchorPoint(cc.p(0, 0))
					else
						ball:setAnchorPoint(cc.p(1, 1))
					end
					ball:setPosition(cc.p(params._widget:getContentSize().width, 0))
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
	--副本界面选项卡的关卡宝箱按钮推送
	local push_notification_center_battle_control_box_terminal = {
        _name = "push_notification_center_battle_control_box",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getCurrentBattleCheckBoxStateTips(tonumber(params._widget._data)) == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
					ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height))
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

	--英雄副本推送
	local push_notification_center_hero_duplicate_terminal = {
        _name = "push_notification_center_hero_duplicate",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getHeroDupilcateTip() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
					ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height-10))
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

	--日常副本推送
	local push_notification_center_daily_duplicate_terminal = {
        _name = "push_notification_center_daily_duplicate",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getDailyDupilcateTip() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
					ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height-10))
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
    state_machine.add(push_notification_center_battle_all_terminal)
    state_machine.add(push_notification_center_battle_all_the_chest_terminal)
    state_machine.add(push_notification_center_battle_ordinary_the_chest_terminal)
    state_machine.add(push_notification_center_battle_list_ordinary_the_chest_terminal)
    state_machine.add(push_notification_center_battle_current_scene_the_chest_terminal)
    state_machine.add(push_notification_center_battle_list_scene_the_chest_terminal)
    state_machine.add(push_notification_center_battle_control_box_terminal)
    state_machine.add(push_notification_center_battle_mingjiang_terminal)
    state_machine.add(push_notification_center_battle_richang_terminal)
    state_machine.add(push_notification_center_hero_duplicate_terminal)
    state_machine.add(push_notification_center_daily_duplicate_terminal)
    state_machine.init()
end
init_push_notification_center_battle_terminal()

function getBattleAllTips()
	if getBattleZhuxianAllTips() == true then
		return true
	end
	if getBattleMingjiangAllTips() == true then
		return true
	end

	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		if getDailyDupilcateTip() == true then
			return true
		end
		if getHeroDupilcateTip() == true then
			return true
		end
	end
	return false
end

function getBattleZhuxianAllTips()
	if getBattleTheChestAllTips() == true then
		return true
	end
	if getBattleCheckBoxStateTips() == true then
		return true
	end
	return false
end

function getBattleMingjiangAllTips()
	-- 剩余挑战次数
	if getBattleMingjiangTimesTips() == true then
		return true
	end
	
	-- 可领取宝箱
	if getBattleMingjiangBoxTips() == true then
		return true
	end
	
	return false
end

function getBattleMingjiangOpenState()
	local user_grade=dms.int(dms["fun_open_condition"], 18, fun_open_condition.level)
	local lastSceneId, firstScene = getOpenMaxSceneId(9)
	if user_grade <= zstring.tonumber(_ED.user_info.user_grade)  and lastSceneId < 0 then
		return true
	end
	return false
end

function getBattleMingjiangTimesTips()
	if getBattleMingjiangOpenState() and zstring.tonumber(_ED.activity_pve_times[347]) > 0 then
		return true
	end
	return false
end

function getBattleMingjiangBoxTips()
	if _ED.scene_current_state == nil or _ED.scene_current_state == "" then
		return false
	end
	for i, v in ipairs(_ED.scene_current_state) do
		if dms.int(dms["pve_scene"], i, pve_scene.scene_type) == 9 then
			local npcIdListStr = dms.string(dms["pve_scene"], i, pve_scene.design_npc)
			local npcIDTable = zstring.split(npcIdListStr, ",")
			for j, v in pairs(npcIDTable) do
				local drawState = _ED.scene_draw_chest_npcs[v]
				--已经领取
				if drawState == 1 then
				else--没有领取
					if tonumber(_ED.npc_state[tonumber(v)]) > 0 then
						return true
					end
				end
			end
		end	
	end
	return false
end

function getBattleRichangAllTips()
	-- 今日挑战次数
	local vipLevel = zstring.tonumber(_ED.vip_grade)
	local attackCountElement = dms.element(dms["base_consume"], 53)
	local fightCount = dms.atoi(attackCountElement, base_consume.vip_0_value + vipLevel) - zstring.tonumber(_ED.game_activity_times)

	if fightCount > 0 then
		return true
	end
	
	return false
end

function getBattleTheChestAllTips()
	local numbers = nil
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		numbers = zstring.tonumber(_ED._now_scene_max_open_number)
	else
		numbers = zstring.tonumber(_ED._now_scene_index)
	end	
	for i=1 ,numbers do
		local rewardNeedStar = zstring.split(dms.string(dms["pve_scene"], tonumber(i), pve_scene.reward_need_star), ",")
		-- print("======当前关获得星星数=======",_ED.get_star_count[i],"第"..(i-1).."关")
		for j=1, table.getn(rewardNeedStar) do
			if zstring.tonumber(rewardNeedStar[j]) <= tonumber(_ED.get_star_count[i]) then
				if zstring.tonumber(_ED.star_reward_state[i]) < 7 then
					if zstring.tonumber(_ED.star_reward_state[i]) == 0 then
						return true
					elseif zstring.tonumber(_ED.star_reward_state[i]) == 1 then
						if j == 1 then
						else
							return true
						end
					elseif zstring.tonumber(_ED.star_reward_state[i]) == 2 then
						if j == 2 then
						else
							return true
						end
					elseif zstring.tonumber(_ED.star_reward_state[i]) == 4 then
						if j == 3 then
						else
							return true
						end
					elseif zstring.tonumber(_ED.star_reward_state[i]) == 3 then
						if j == 1 or j == 2 then
						else
							return true
						end
					elseif zstring.tonumber(_ED.star_reward_state[i]) == 5 then
						if j == 1 or j == 3 then
						else
							return true
						end
					elseif zstring.tonumber(_ED.star_reward_state[i]) == 6 then
						if j == 2 or j == 3 then
						else
							return true
						end
					end
				end
			end
		end
	end
	return false
end

function getCurrentSceneTheChestTips(sceneId)
	if zstring.tonumber(sceneId) == 0 then
		return false
	end
	local rewardNeedStar = zstring.split(dms.string(dms["pve_scene"], tonumber(sceneId), pve_scene.reward_need_star), ",")
	for j=1, table.getn(rewardNeedStar) do
		if zstring.tonumber(rewardNeedStar[j]) <= tonumber(_ED.get_star_count[sceneId]) then
			if zstring.tonumber(_ED.star_reward_state[sceneId]) < 7 then
				if zstring.tonumber(_ED.star_reward_state[sceneId]) == 0 then
					return true
				elseif zstring.tonumber(_ED.star_reward_state[sceneId]) == 1 then
					if j == 1 then
					else
						return true
					end
				elseif zstring.tonumber(_ED.star_reward_state[sceneId]) == 2 then
					if j == 2 then
					else
						return true
					end
				elseif zstring.tonumber(_ED.star_reward_state[sceneId]) == 4 then
					if j == 3 then
					else
						return true
					end
				elseif zstring.tonumber(_ED.star_reward_state[sceneId]) == 3 then
					if j == 1 or j == 2 then
					else
						return true
					end
				elseif zstring.tonumber(_ED.star_reward_state[sceneId]) == 5 then
					if j == 1 or j == 3 then
					else
						return true
					end
				elseif zstring.tonumber(_ED.star_reward_state[sceneId]) == 6 then
					if j == 2 or j == 3 then
					else
						return true
					end
				end
			end
		end
	end
	return false
end

function getBattleCheckBoxStateTips()
	local numbers = nil
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		numbers = zstring.tonumber(_ED._now_scene_max_open_number)
	else
		numbers = zstring.tonumber(_ED._now_scene_index)
	end
	for i=1 ,numbers do
		local npcIdListStr = dms.string(dms["pve_scene"], i, pve_scene.design_npc)
		local npcIDTable = zstring.split(npcIdListStr, ",")
		for j, v in pairs(npcIDTable) do
			
			local drawState = _ED.scene_draw_chest_npcs[v]
			--print("=====当前npc宝箱状态==========",drawState,"npcID:"..v.."npc对应章节:"..(i-1),"npc星数:"..tonumber(_ED.npc_state[tonumber(v)]))
			--已经领取
			local npcIdx = tonumber(v)
			if drawState == 1 or npcIdx <= 0 then
			else--没有领取
				if tonumber(_ED.npc_state[npcIdx]) > 0 then
					return true
				end
			end
		end
	end
	return false
end

function getCurrentBattleCheckBoxStateTips(NpcId)
	-- local currentNpcId = zstring.tonumber(_ED._current_scene_id)
	-- if currentNpcId <= 0 then
		-- return false
	-- end

	local npcIdListStr = dms.string(dms["pve_scene"], tonumber(_ED._current_scene_id), pve_scene.design_npc)
	if npcIdListStr == nil or npcIdListStr == "" then
		return false
	end
	local npcIDTable = zstring.split(npcIdListStr, ",")
	if getCheckNpcTableForNpcID(npcIDTable,NpcId) == true then
		local drawState = _ED.scene_draw_chest_npcs[""..NpcId]
		--已经领取
		if drawState == 1 then
		else--没有领取
			if tonumber(_ED.npc_state[tonumber(NpcId)]) > 0 then
				return true
			end
		end
	end
	return false
end

function getCurrentlistSceneTheChestTips(params)
	if params[2] ~= 3 and getCurrentSceneTheChestTips(tonumber(params[1]))== true then
		return true
	end
	
	
	local npcIdListStr = dms.string(dms["pve_scene"], tonumber(params[1]), pve_scene.design_npc)
	local npcIDTable = zstring.split(npcIdListStr, ",")
	for j, v in pairs(npcIDTable) do
		local drawState = _ED.scene_draw_chest_npcs[v]
		--已经领取
		if drawState == 1 then
		else--没有领取
			if tonumber(_ED.npc_state[tonumber(v)]) > 0 then
				return true
			end
		end
	end
	return false
end

--检测table中是否包含传入的NPCid
function getCheckNpcTableForNpcID(npcIDTable, npcID)
	for i, v in pairs(npcIDTable) do
		if tonumber(v) == tonumber(npcID) then
			return true
		end
	end
	return false
end
--英雄副本
function getHeroDupilcateTip( ... )
	local isopen ,tip= getFunopenLevelAndTip(18)
	if _ED.activity_pve_times[347] == nil or isopen == false then
		return false
	end
	if tonumber(_ED.activity_pve_times[347]) > 0 then
		return true
	end

end
--日常副本
function getDailyDupilcateTip( ... )
	local isopen ,tip= getFunopenLevelAndTip(19)
	if _ED.vip_grade == nil or _ED.game_activity_times == nil or isopen == false then
		return false
	end
	local vipLevel = zstring.tonumber(_ED.vip_grade)
	local attackCountElement = dms.element(dms["base_consume"], 53)
	local fightCount = dms.atoi(attackCountElement, base_consume.vip_0_value + vipLevel) - zstring.tonumber(_ED.game_activity_times)
	if tonumber(fightCount) > 0 then
		return true
	end
end