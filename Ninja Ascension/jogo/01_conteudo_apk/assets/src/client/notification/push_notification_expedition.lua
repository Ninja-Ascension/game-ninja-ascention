-- Initialize push notification center state machine.
local function init_push_notification_center_expedition_terminal()
	--首页的征战按钮的推送
    local push_notification_center_expedition_all_terminal = {
        _name = "push_notification_center_expedition_all",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getExpeditionAllTips(params) == true then
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
	--征战界面的夺宝按钮的推送
	local push_notification_center_expedition_indiana_terminal = {
        _name = "push_notification_center_expedition_indiana",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getExpeditionIndianaTips() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))	
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then		
						ball:setPosition(cc.p(params._widget:getContentSize().width-10, params._widget:getContentSize().height-10))
					elseif __lua_project_id == __lua_project_warship_girl_b 
						or __lua_project_id == __lua_project_digimon_adventure 
						or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge 
						then
						ball:setPosition(cc.p(params._widget:getContentSize().width, 50))	
					elseif __lua_project_id == __lua_project_yugioh 
						then
						ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height - 20))						
					else
						ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height*3/2))
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
	--夺宝界面内的可合成的宝物图标的推送 --残卷
	local push_notification_center_expedition_indiana_cell_terminal = {
        _name = "push_notification_center_expedition_indiana_cell",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if checkIsOver(params._widget._data) == true then
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
	--征战界面内的竞技场按钮的推送 --武神台
	local push_notification_center_expedition_arena_reward_terminal = {
        _name = "push_notification_center_expedition_arena_reward",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getArenaRewardTips() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
					
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then		
						ball:setPosition(cc.p(params._widget:getContentSize().width-10, params._widget:getContentSize().height-10))
					elseif __lua_project_id == __lua_project_warship_girl_b 
						or __lua_project_id == __lua_project_digimon_adventure 
						or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge then 
						ball:setPosition(cc.p(params._widget:getContentSize().width, 50))
					elseif __lua_project_id == __lua_project_yugioh then
						ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height - 20))					
					else
						ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height*3/2))
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
	--竞技场界面荣誉商店界面的按钮推送和荣誉商店界面内的奖励按钮的推送
	local push_notification_center_expedition_arena_reward_cell_terminal = {
        _name = "push_notification_center_expedition_arena_reward_cell",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getArenaRewardTips() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
						ball:setPosition(cc.p(params._widget:getContentSize().width+10, params._widget:getContentSize().height+10))
					else
						ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height))
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
	--征战界面内的世界海战按钮的推送 -罗刹道场
	local push_notification_center_expedition_trialtower_terminal = {
        _name = "push_notification_center_expedition_trialtower",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
        	if __lua_project_id == __lua_project_gragon_tiger_gate
				or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				or __lua_project_id == __lua_project_red_alert 
				then
        		if params == nil or params._widget == nil then
        			return
        		end
        	end
			if checkTrialTowerReset() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
					
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then		
						ball:setPosition(cc.p(params._widget:getContentSize().width-10, params._widget:getContentSize().height-10))
					elseif __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge then 
						ball:setPosition(cc.p(params._widget:getContentSize().width, 50))
					elseif __lua_project_id == __lua_project_yugioh 
						then
						ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height - 20))							
					else
						ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height*3/2))
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
	--征战界面内的世界海战重置按钮的推送
	local push_notification_center_expedition_trialtower_reset_terminal = {
        _name = "push_notification_center_expedition_trialtower_reset",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if checkTrialTowerReset() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
						ball:setAnchorPoint(cc.p(0.5, 1))
						ball:setPosition(cc.p(params._widget:getContentSize().width - ball:getContentSize().width + 17, params._widget:getContentSize().height+ 7))
					else
						ball:setAnchorPoint(cc.p(0.5, 1))
						ball:setPosition(cc.p(params._widget:getContentSize().width - ball:getContentSize().width, params._widget:getContentSize().height))
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
	--世界海战神装商店界面的按钮推送的推送
	local push_notification_center_expedition_trialtower_equip_shop_terminal = {
        _name = "push_notification_center_expedition_trialtower_equip_shop",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getTrialTowerRewardTips(params) == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
						ball:setAnchorPoint(cc.p(1, 1))
					else
						ball:setAnchorPoint(cc.p(1.2, 1.2))
					end
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
	
	--世界海战神装商店界面内的奖励按钮的推送
	local push_notification_center_expedition_trialtower_equip_shop_reward_terminal = {
        _name = "push_notification_center_expedition_trialtower_equip_shop_reward",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getTrialTowerRewardTips(params) == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
						ball:setPosition(cc.p(params._widget:getContentSize().width+15, params._widget:getContentSize().height+15))
					else
						ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height))
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
	
	--惩奸除恶奖励按钮的推送
	local push_notification_center_worldboss_reward_terminal = {
        _name = "push_notification_center_worldboss_reward",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getWorldBossRewardTips(params) == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
						ball:setPosition(cc.p(params._widget:getContentSize().width+15, params._widget:getContentSize().height+15))
					else
						ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height))
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
	local push_notification_center_expedition_worldboss_terminal = {
        _name = "push_notification_center_expedition_worldboss",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getWorldBossRewardTips() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
					
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then		
						ball:setPosition(cc.p(params._widget:getContentSize().width-10, params._widget:getContentSize().height-10))
					elseif __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
						if params._datas._direction == 1 then 
							ball:setPosition(cc.p(params._widget:getContentSize().width, 70))						
						else
							ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height-10))						
						end
						
					else
						ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height*3/2))
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

    state_machine.add(push_notification_center_expedition_all_terminal)
    state_machine.add(push_notification_center_expedition_indiana_terminal)
    state_machine.add(push_notification_center_expedition_indiana_cell_terminal)
    state_machine.add(push_notification_center_expedition_arena_reward_terminal)
    state_machine.add(push_notification_center_expedition_arena_reward_cell_terminal)
    state_machine.add(push_notification_center_expedition_trialtower_terminal)
    state_machine.add(push_notification_center_expedition_trialtower_reset_terminal)
    state_machine.add(push_notification_center_expedition_trialtower_equip_shop_terminal)
    state_machine.add(push_notification_center_expedition_trialtower_equip_shop_reward_terminal)
    state_machine.add(push_notification_center_worldboss_reward_terminal)
    state_machine.add(push_notification_center_expedition_worldboss_terminal)
    state_machine.init()
end
init_push_notification_center_expedition_terminal()


local searchRankLink1 = nil 
local searchRankLink2 = nil  
-------------------------------------------------------------------------------
-- 征战总体推送
-------------------------------------------------------------------------------
function getExpeditionAllTips(notificationer)
	--竞技场奖励推送
	local arena_grade=dms.int(dms["fun_open_condition"], 16, fun_open_condition.level)
    if arena_grade <= zstring.tonumber(_ED.user_info.user_grade) then
		if _ED._is_recharge_push_expedition == false then
			if notificationer ~= nil then
				notificationer.startTime = notificationer.startTime or os.time()
				if (notificationer.startTime  + 4) > os.time() then
					return
				end
			end
			if _ED.arena_user_rank == nil or _ED.arena_user_rank == "" then
				local function responseArenaInitCallTipsback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if _ED.arena_good_reward_number == "" or _ED.arena_good_reward_number == nil then
							protocol_command.arena_shop_init.param_list = "1\r\n"
							NetworkManager:register(protocol_command.arena_shop_init.code, nil, nil, nil, nil, nil, false, nil)
						end
					end
				end
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
					if missionIsOver() == false and fwin:find("CampaignClass") ~= nil then
						return
					end
				end
				protocol_command.arena_init.param_list = "0"
				NetworkManager:register(protocol_command.arena_init.code, nil, nil, nil, nil, responseArenaInitCallTipsback, false, nil)
			end
			_ED._is_recharge_push_expedition = true
		end
		
		if getArenaRewardTips() == true then
			return true
		end
	end
	
	--获取夺宝推送
	local indiana_grade=dms.int(dms["fun_open_condition"], 15, fun_open_condition.level)
	if indiana_grade <= zstring.tonumber(_ED.user_info.user_grade) then
		if getExpeditionIndianaTips() == true then
			return true
		end
	end
	
	--世界海战重置
	if checkTrialTowerReset() == true then
		return true
	end

	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		if getWorldBossRewardTips() == true then
			return true
		end
	end
	return false
end

-------------------------------------------------------------------------------
-- 竞技场部分
-------------------------------------------------------------------------------
function getArenaRewardTips()
	for i, arena in pairs(_ED.arena_good_reward) do
		local arena_shop_info_data = dms.element(dms["arena_shop_info"], arena.good_id)
		if dms.atoi(arena_shop_info_data, arena_shop_info.shop_type) == 1 then
			if dms.atoi(arena_shop_info_data, arena_shop_info.item_mould) ~= -1 then
				local purchaseTimes = tonumber(arena.exchange_times)
				local limit = dms.atoi(arena_shop_info_data, arena_shop_info.exchange_count_limit)
				local minLimit = limit - purchaseTimes
				if minLimit > 0 then
					if tonumber(_ED.user_info.user_honour) >= dms.atoi(arena_shop_info_data, arena_shop_info.need_honor) then
						if tonumber(_ED.max_arena_user_rank) <= dms.atoi(arena_shop_info_data, arena_shop_info.ranking) then
							return true
						end
					end
				end
			end
		end
	end
	return false
end

-------------------------------------------------------------------------------
-- 夺宝部分
-------------------------------------------------------------------------------
function getExpeditionIndianaTips()
	if searchRankLink1 == nil then 
		searchRankLink1 = dms2.searchs(dms["grab_rank_link"], grab_rank_link.is_resident, 1)
	end
	if searchRankLink2 == nil then 
		searchRankLink2 = dms2.searchs(dms["grab_rank_link"], grab_rank_link.is_resident, 0)
	end
	for i = 1,#searchRankLink1 do
		if checkIsOver(tonumber(searchRankLink1[i][grab_rank_link.equipment_mould])) == true then
			return true
		end
	end
	
	for i = 1,#searchRankLink2 do
		if checkIsOver(tonumber(searchRankLink2[i][grab_rank_link.equipment_mould])) == true then
			return true
		end
	end
	return false
end

function getInstance(mould)
	local propInstace = nil
	for i,prop in pairs(_ED.user_prop) do
		if tonumber(prop.user_prop_template) == tonumber(mould) then
			propInstace = prop
			break
		end
	end
	return propInstace
end
-- 检查碎片是否凑齐
function checkIsOver(mould)
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		if mould == nil then
			return
		end
	end
	local result = true
	local datas = dms2.searchs(dms["grab_rank_link"], grab_rank_link.equipment_mould, mould)
	local grabRankLink = datas[1][grab_rank_link.id]
	local grab_rank_link_data = dms.element(dms["grab_rank_link"], grabRankLink)
	local need_prop = 
	{
		tonumber(dms.atoi(grab_rank_link_data, grab_rank_link.need_prop1)),
		tonumber(dms.atoi(grab_rank_link_data, grab_rank_link.need_prop2)),
		tonumber(dms.atoi(grab_rank_link_data, grab_rank_link.need_prop3)),
		tonumber(dms.atoi(grab_rank_link_data, grab_rank_link.need_prop4)),
		tonumber(dms.atoi(grab_rank_link_data, grab_rank_link.need_prop5)),
		tonumber(dms.atoi(grab_rank_link_data, grab_rank_link.need_prop6))
	}
	
	for i = 1,6 do
		if	need_prop[i] ~= -1 then
			local prop = getInstance(need_prop[i])
			if prop == nil then
				result = false
				break
			elseif prop.prop_number == 0 then
				result = false
				break
			end
		end
	end
	return result
end

-------------------------------------------------------------------------------
-- 世界海战部分
-------------------------------------------------------------------------------
-- 检查世界海战重置状态 （用于海战征战中图标推送）
function checkTrialTowerReset()
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		return false
	end
	app.load("client.campaign.trialtower.TrialTower")
	if TrialTower.getFreeReset() == true and checkupTrialTowerShopIsOpened() == true then
		return true 
	end
	return false
end

-- 检查神装商店的奖励领取状态 （用于海战神装商店入口图标和商店中奖励图标推送） 
function getTrialTowerRewardTips(notificationer)
	if (_ED.dignified_shop_init == nil or _ED.dignified_shop_init == "") and notificationer._need_request_reward ~= true then
		notificationer._need_request_reward = true

		local function responseDignifiedShopInitCallback(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				
			end
		end
		
		NetworkManager:register(protocol_command.dignified_shop_init.code, nil, nil, nil, nil, responseDignifiedShopInitCallback, false, nil)
        return false
	end
	
	local shop = dms["dignified_shop_model"]
	for i = 1, table.getn(shop) do
		local dignified_shop_model_data = dms.element(dms["dignified_shop_model"], i)

		local sindex = dms.atoi(dignified_shop_model_data, dignified_shop_model.prop_index)
		local star = dms.atoi(dignified_shop_model_data, dignified_shop_model.need_star)
		local limit = dms.atoi(dignified_shop_model_data, dignified_shop_model.purchase_count_limit)
		
		if sindex == 3 and limit > 0 and tonumber(_ED.three_kingdoms_view.history_max_stars) >= star then
			local yetCount = getTrialtowerShopLimitCount(i) --获取当前限定购买中 已经购买过的
			if yetCount ~= nil then
				limit = math.max(limit - yetCount, 0)
				
				if limit > 0 then
					return true
				end
			end
		end
	end	
	return false
end
function getWorldBossRewardTips( ... )
	if _ED.return_rebel_army_awardInfo.award_info == nil or _ED.exploit_second_information.dayAccumulate == nil then
		local function recruitCallBack(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				
			end
		end		
		NetworkManager:register(protocol_command.rebel_army_init.code, nil, nil, nil, nil, recruitCallBack, false, nil)		
		return
	end
	-- debug.print_r(_ED.return_rebel_army_awardInfo.award_info)
	for i,v in ipairs(_ED.return_rebel_army_awardInfo.award_info) do
		local textReward = dms.string(dms["rebel_army_reward_mould"],tonumber(v.award_id),rebel_army_reward_mould.need_value)	
		if tonumber(_ED.exploit_second_information.dayAccumulate) >= tonumber(textReward) and tonumber(v.award_state) == 0 then
			return true
		end
	end
end
-------------------------------------------------------------------------------