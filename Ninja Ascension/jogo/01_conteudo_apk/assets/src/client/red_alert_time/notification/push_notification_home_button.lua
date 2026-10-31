cc.Director:getInstance():getTextureCache():addImage("images/ui/bar/tuishong.png")
push_notification_bag_count = 0 			      -- 背包
push_notification_home_packs_count = 0 		      -- 主界面背包
push_notification_bag_resources_count = 0 		  -- 背包资源页
push_notification_bag_fight_count = 0 		      -- 背包战斗页
push_notification_bag_treasure_box_count = 0 	  -- 背包宝箱页
push_notification_bag_other_count = 0 		      -- 背包其他页
push_notification_equipment = 0 			      -- 主界面配件
push_notification_parts_count = 0 			      -- 配件
push_notification_home_task_count = 0 		      -- 主界面任务
push_notification_daily_task_count = 0 		      -- 日常任务
push_notification_fight_task_count = 0 		      -- 战斗任务
push_notification_legion_task_count = 0 		  -- 军团任务
push_notification_grow_task_count = 0 		      -- 发展任务
push_notification_privilege_task_count = 0 		  -- 特权任务
push_notification_privilege_main_count = 0 		  -- 主线任务
push_notification_pve_parts_supply_count = 0 	  -- 配件副本
push_notification_pve_armor_count = 0             -- 装甲副本
push_notification_pve_count = 0 	  			  -- 主界面征战
push_notification_mine_count = 0				  -- 邮件全部
push_notification_mine_inbox_count = 0			  -- 邮件收件
push_notification_mine_report_count = 0			  -- 邮件报告
push_notification_formation_count = 0 			  -- 主界面部队
push_notification_formation_repair_count = 0 	  -- 部队界面维修
push_notification_mine_report_attack_count = 0	  -- 攻击报告
push_notification_mine_report_defense_count = 0	  -- 防御报告
push_notification_mine_report_scout_count = 0	  -- 侦察报告
push_notification_mine_activity_count = 0	  -- 活动报告
push_notification_mine_treasure_count = 0	  -- 宝藏报告
push_notification_mine_lottery_count = 0	  -- 抽奖推送
push_notification_mine_ordinary_lottery_count = 0	  -- 普通抽奖推送
push_notification_mine_advanced_lottery_count = 0	  -- 高级抽奖推送
push_notification_parts_supply_info = {}
push_notification_equipment_page_parts_info = { 0,0,0,0 }
local function init_push_notification_home_button_terminal()
	--首页征战按钮的推送
    local push_notification_home_button_pve_terminal = {
        _name = "push_notification_home_button_pve",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			local count = getPveTip()
			local isChange = false
	        if count ~= push_notification_pve_count then
	        	isChange = true
	        end
	        push_notification_pve_count = count
			if count > 0 then
				if isChange == true then
					if params._widget._istips == true then
						params._widget:removeChild(params._widget._nodeChild, true)
						params._widget._nodeChild = nil
						params._widget._istips = false
					end
				else
					-- if params._widget._istips == nil or params._widget._istips == false then
					-- 	local ball = state_machine.excute("util_tips_cretae", 0, {count})
					-- 	ball:setAnchorPoint(cc.p(0.5, 0.5))
					-- 	ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
					-- 	params._widget:addChild(ball)
					-- 	params._widget._nodeChild = ball
					-- 	params._widget._istips = true
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

    --首页阵容按钮的推送
    local push_notification_home_button_formation_terminal = {
        _name = "push_notification_home_button_formation",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
        	local count = getFormationTip()
			local isChange = false
	        if count ~= push_notification_formation_count then
	        	isChange = true
	        end
	        push_notification_formation_count = count
			if count > 0 then
				if isChange == true then
					if params._widget._istips == true then
						params._widget:removeChild(params._widget._nodeChild, true)
						params._widget._nodeChild = nil
						params._widget._istips = false
					end
				else
					-- if params._widget._istips == nil or params._widget._istips == false then
					-- 	local ball = state_machine.excute("util_tips_cretae", 0, {count})
					-- 	ball:setAnchorPoint(cc.p(0.5, 0.5))
					-- 	ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
					-- 	params._widget:addChild(ball)
					-- 	params._widget._nodeChild = ball
					-- 	params._widget._istips = true
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

    -- 部队界面推送
    local push_notification_formation_repair_terminal = {
        _name = "push_notification_formation_repair",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
        	local count = getFormationTip()
			local isChange = false
	        if count ~= push_notification_formation_repair_count then
	        	isChange = true
	        end
	        push_notification_formation_repair_count = count
			if count > 0 then
				if isChange == true then
					if params._widget._istips == true then
						params._widget:removeChild(params._widget._nodeChild, true)
						params._widget._nodeChild = nil
						params._widget._istips = false
					end
				else
					-- if params._widget._istips == nil or params._widget._istips == false then
					-- 	local ball = state_machine.excute("util_tips_cretae", 0, {count})
					-- 	ball:setAnchorPoint(cc.p(0.5, 0.5))
					-- 	ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
					-- 	params._widget:addChild(ball)
					-- 	params._widget._nodeChild = ball
					-- 	params._widget._istips = true
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

    -- 战斗胜利维修推送
    local push_notification_battle_reward_repair_terminal = {
        _name = "push_notification_battle_reward_repair",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
        	local number = getFormationTip()
			if number > 0 then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = state_machine.excute("util_tips_cretae", 0, {number})
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

    --战斗失败推送
    local push_notification_battle_lose_repair_terminal = {
        _name = "push_notification_battle_lose_repair",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
        	local number = getFormationTip()
			if number > 0 then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = state_machine.excute("util_tips_cretae", 0, {number})
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

    --首页背包按钮的推送
    local push_notification_home_button_packs_terminal = {
        _name = "push_notification_home_button_packs",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
        	local count = _ED.push_user_resources_count + _ED.push_user_fight_count + _ED.push_user_treasure_box_count + _ED.push_user_other_count
	        local isChange = false
	        if count ~= push_notification_home_packs_count then
	        	isChange = true
	        end
	        push_notification_home_packs_count = count
			if count > 0 then
				if isChange == true then
					if params._widget._istips == true then
						params._widget:removeChild(params._widget._nodeChild, true)
						params._widget._nodeChild = nil
						params._widget._istips = false
					end
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

    --背包按钮的推送
    local push_notification_packs_terminal = {
        _name = "push_notification_packs",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
        	local count = _ED.push_user_resources_count + _ED.push_user_fight_count + _ED.push_user_treasure_box_count + _ED.push_user_other_count
	        local isChange = false
	        if count ~= push_notification_bag_count then
	        	isChange = true
	        end
	        push_notification_bag_count = count
			if count > 0 then
				if isChange == true then
					if params._widget._istips == true then
						params._widget:removeChild(params._widget._nodeChild, true)
						params._widget._nodeChild = nil
						params._widget._istips = false
					end
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

    -- 背包界面资源页推送
    local push_notification_pack_resources_terminal = {
        _name = "push_notification_pack_resources",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
        	local count = _ED.push_user_resources_count
			local isChange = false
	        if count ~= push_notification_bag_resources_count then
	        	isChange = true
	        end
	        push_notification_bag_resources_count = count
			if count > 0 then
				if isChange == true then
					if params._widget._istips == true then
						params._widget:removeChild(params._widget._nodeChild, true)
						params._widget._nodeChild = nil
						params._widget._istips = false
					end
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

    -- 背包界面战斗页推送
    local push_notification_pack_fight_terminal = {
        _name = "push_notification_pack_fight",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
        	local count = _ED.push_user_fight_count
			local isChange = false
	        if count ~= push_notification_bag_fight_count then
	        	isChange = true
	        end
	        push_notification_bag_fight_count = count
			if count > 0 then
				if isChange == true then
					if params._widget._istips == true then
						params._widget:removeChild(params._widget._nodeChild, true)
						params._widget._nodeChild = nil
						params._widget._istips = false
					end
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

    -- 背包界面宝箱页推送
    local push_notification_pack_treasure_box_terminal = {
        _name = "push_notification_pack_treasure_box",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
        	local count = _ED.push_user_treasure_box_count
			local isChange = false
	        if count ~= push_notification_bag_treasure_box_count then
	        	isChange = true
	        end
	        push_notification_bag_treasure_box_count = count
			if count > 0 then
				if isChange == true then
					if params._widget._istips == true then
						params._widget:removeChild(params._widget._nodeChild, true)
						params._widget._nodeChild = nil
						params._widget._istips = false
					end
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
    
    -- 背包界面其他页推送
    local push_notification_pack_other_terminal = {
        _name = "push_notification_pack_treasure_other",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
        	local count = _ED.push_user_other_count
			local isChange = false
	        if count ~= push_notification_bag_other_count then
	        	isChange = true
	        end
	        push_notification_bag_other_count = count
			if count > 0 then
				if isChange == true then
					if params._widget._istips == true then
						params._widget:removeChild(params._widget._nodeChild, true)
						params._widget._nodeChild = nil
						params._widget._istips = false
					end
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

    -- 配件界面单个配件可装备推送
    local push_notification_equipment_parts_icon_terminal = {
        _name = "push_notification_equipment_parts_icon",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
        	local equip_type = params._datas._type
        	local index = params._datas._index
			if getEquipmentPartsIconTip(equip_type,index) == true then
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

    -- 可装备配件总推送
    local push_notification_equipment_parts_terminal = {
        _name = "push_notification_equipment_parts",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
        	local count = push_notification_equipment
	        local isChange = false
	        if count ~= push_notification_parts_count then
	        	isChange = true
	        end
	        push_notification_parts_count = count
			if count > 0 then
				if isChange == true then
					if params._widget._istips == true then
						params._widget:removeChild(params._widget._nodeChild, true)
						params._widget._nodeChild = nil
						params._widget._istips = false
					end
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

    -- 可装备配件总推送
    local push_notification_equipment_terminal = {
        _name = "push_notification_equipment",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
        	local index = params._datas._index
        	local count, pagePushTable = getEquipmentPartsTip()
	        local isChange = false
	        local currCount = count
	        if index ~= nil then
	        	if pagePushTable[index] ~= push_notification_equipment_page_parts_info[index] then
	        		isChange = true
		        end
		        push_notification_equipment_page_parts_info[index] = pagePushTable[index]
		        currCount = pagePushTable[index]
	        else
		        if count ~= push_notification_equipment then
		        	isChange = true
		        end
	            if isChange == true then
	                state_machine.excute("home_map_update_prodcution_state", 0, {6})
	            end
		        push_notification_equipment = count
	        end
			if currCount > 0 then
				if isChange == true then
					if params._widget._istips == true then
						params._widget:removeChild(params._widget._nodeChild, true)
						params._widget._nodeChild = nil
						params._widget._istips = false
					end
				end
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = state_machine.excute("util_tips_cretae", 0, {currCount})
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

    -- 仓库总推送
    local push_notification_equipment_packs_terminal = {
        _name = "push_notification_equipment_packs",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if _ED.push_user_have_equipment_count > 0
				or _ED.push_user_equipment_chip_count > 0
				or _ED.push_user_equipment_data_count > 0
                or _ED.push_user_equipment_chip_compose_count > 0
				then
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

    -- 仓库配件推送
    local push_notification_equipment_pack_fit_terminal = {
        _name = "push_notification_equipment_pack_fit",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if _ED.push_user_have_equipment_count > 0 then
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

    -- 仓库碎片推送
    local push_notification_equipment_pack_chip_terminal = {
        _name = "push_notification_equipment_pack_chip",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if _ED.push_user_equipment_chip_count > 0 
                or _ED.push_user_equipment_chip_compose_count > 0
                then
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

    -- 仓库碎片可合成推送
    local push_notification_equipment_pack_chip_compose_terminal = {
        _name = "push_notification_equipment_pack_chip_compose",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if _ED.push_user_equipment_chip_compose_count > 0 then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = state_machine.excute("util_tips_cretae", 0, {""})
                    ball:setAnchorPoint(cc.p(0.5, 0.5))
                    ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5+6, params._widget:getContentSize().height-ball:getContentSize().height*0.5+6))
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

    -- 仓库材料推送
    local push_notification_equipment_pack_data_terminal = {
        _name = "push_notification_equipment_pack_data",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if _ED.push_user_equipment_data_count > 0 then
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

    -- 首页任务按钮的推送
    local push_notification_home_button_task_terminal = {
        _name = "push_notification_home_button_task",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
        	local count = getTotalTaskTip()
	        local isChange = false
	        if count ~= push_notification_home_task_count then
	        	isChange = true
	        end
	        push_notification_home_task_count = count
			if count > 0 then
				if isChange == true then
					if params._widget._istips == true then
						params._widget:removeChild(params._widget._nodeChild, true)
						params._widget._nodeChild = nil
						params._widget._istips = false
					end
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

    -- 任务界面主线任务的推送
    local push_notification_task_button_main_terminal = {
        _name = "push_notification_task_button_main",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
        	local count = _ED.push_user_main_task_count
			local isChange = false
	        if count ~= push_notification_privilege_main_count then
	        	isChange = true
	        end
	        push_notification_privilege_main_count = count
			if count > 0 then
				if isChange == true then
					if params._widget._istips == true then
						params._widget:removeChild(params._widget._nodeChild, true)
						params._widget._nodeChild = nil
						params._widget._istips = false
					end
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

    -- 任务界面日常任务的推送
    local push_notification_task_button_daily_terminal = {
        _name = "push_notification_task_button_daily",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
        	local count = getDailyTaskTip()
	        local isChange = false
	        if count ~= push_notification_daily_task_count then
	        	isChange = true
	        end
	        push_notification_daily_task_count = count
			if count > 0 then
				if isChange == true then
					if params._widget._istips == true then
						params._widget:removeChild(params._widget._nodeChild, true)
						params._widget._nodeChild = nil
						params._widget._istips = false
					end
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

    -- 任务界面战斗任务的推送
    local push_notification_task_button_fight_terminal = {
        _name = "push_notification_task_button_fight",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
        	local count = _ED.push_user_fight_task_count
			local isChange = false
	        if count ~= push_notification_fight_task_count then
	        	isChange = true
	        end
	        push_notification_fight_task_count = count
			if count > 0 then
				if isChange == true then
					if params._widget._istips == true then
						params._widget:removeChild(params._widget._nodeChild, true)
						params._widget._nodeChild = nil
						params._widget._istips = false
					end
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

    -- 任务界面军团任务的推送
    local push_notification_task_button_legion_terminal = {
        _name = "push_notification_task_button_legion",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
        	local count = _ED.push_user_legion_task_count
			local isChange = false
	        if count ~= push_notification_legion_task_count then
	        	isChange = true
	        end
	        push_notification_legion_task_count = count
			if count > 0 then
				if isChange == true then
					if params._widget._istips == true then
						params._widget:removeChild(params._widget._nodeChild, true)
						params._widget._nodeChild = nil
						params._widget._istips = false
					end
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

    -- 任务界面发展任务的推送
    local push_notification_task_button_grow_terminal = {
        _name = "push_notification_task_button_grow",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
        	local count = _ED.push_user_grow_task_count
			local isChange = false
	        if count ~= push_notification_grow_task_count then
	        	isChange = true
	        end
	        push_notification_grow_task_count = count
			if count > 0 then
				if isChange == true then
					if params._widget._istips == true then
						params._widget:removeChild(params._widget._nodeChild, true)
						params._widget._nodeChild = nil
						params._widget._istips = false
					end
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

    -- 任务界面特权任务的推送
    local push_notification_task_button_privilege_terminal = {
        _name = "push_notification_task_button_privilege",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
        	local count = _ED.push_user_privilege_task_count
			local isChange = false
	        if count ~= push_notification_privilege_task_count then
	        	isChange = true
	        end
	        push_notification_privilege_task_count = count
			if count > 0 then
				if isChange == true then
					if params._widget._istips == true then
						params._widget:removeChild(params._widget._nodeChild, true)
						params._widget._nodeChild = nil
						params._widget._istips = false
					end
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

    -- 配件补给的推送
    local push_notification_pve_parts_supply_terminal = {
        _name = "push_notification_pve_parts_supply",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
        	local count = getPvePartsSupplyTip()
			local isChange = false
	        if count ~= push_notification_pve_parts_supply_count then
	        	isChange = true
	        end
	        push_notification_pve_parts_supply_count = count
			if count > 0 then
				if isChange == true then
					if params._widget._istips == true then
						params._widget:removeChild(params._widget._nodeChild, true)
						params._widget._nodeChild = nil
						params._widget._istips = false
					end
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

    -- 装甲副本的推送
    local push_notification_pve_armor_terminal = {
        _name = "push_notification_pve_armor",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            local count = getPveArmorTip()
            local isChange = false
            if count ~= push_notification_pve_armor_count then
                isChange = true
            end
            push_notification_pve_armor_count = count
            if count > 0 then
                if isChange == true then
                    if params._widget._istips == true then
                        params._widget:removeChild(params._widget._nodeChild, true)
                        params._widget._nodeChild = nil
                        params._widget._istips = false
                    end
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
	
	-- 邮件的全部推送
    local push_notification_mine_push_terminal = {
        _name = "push_notification_mine_push",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			local m_type = params._datas._m_type
        	local count = getMineTip(m_type)
			local isChange = false
	        if count ~= push_notification_mine_count then
	        	isChange = true
	        end
	        push_notification_mine_count = count
			if count > 0 then
				if isChange == true then
					if params._widget._istips == true then
						params._widget:removeChild(params._widget._nodeChild, true)
						params._widget._nodeChild = nil
						params._widget._istips = false
					end
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
	
	-- 邮件的单个推送
    local push_notification_mine_in_box_push_terminal = {
        _name = "push_notification_mine_in_box_push",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			local m_type = params._datas._m_type
        	local count = getMineTip(m_type)
			local isChange = false
	        if count ~= push_notification_mine_inbox_count then
	        	isChange = true
	        end
	        push_notification_mine_inbox_count = count
			if count > 0 then
				if isChange == true then
					if params._widget._istips == true then
						params._widget:removeChild(params._widget._nodeChild, true)
						params._widget._nodeChild = nil
						params._widget._istips = false
					end
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
	
	-- 邮件的报告推送
    local push_notification_mine_report_push_terminal = {
        _name = "push_notification_mine_report_push",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			local m_type = params._datas._m_type
        	local count = getMineTip(m_type)
			local isChange = false
	        if count ~= push_notification_mine_report_count then
	        	isChange = true
	        end
	        push_notification_mine_report_count = count
			if count > 0 then
				if isChange == true then
					if params._widget._istips == true then
						params._widget:removeChild(params._widget._nodeChild, true)
						params._widget._nodeChild = nil
						params._widget._istips = false
					end
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
	
	-- 战斗报告推送
    local push_notification_mine_report_attack_terminal = {
        _name = "push_notification_mine_report_attack",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			local m_type = params._datas._m_type
        	local count = getMineReportTip(m_type)
			local isChange = false
	        if count ~= push_notification_mine_report_attack_count then
	        	isChange = true
	        end
	        push_notification_mine_report_attack_count = count
			if count > 0 then
				if isChange == true then
					if params._widget._istips == true then
						params._widget:removeChild(params._widget._nodeChild, true)
						params._widget._nodeChild = nil
						params._widget._istips = false
					end
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
	
	-- 防御报告推送
    local push_notification_mine_report_defense_terminal = {
        _name = "push_notification_mine_report_defense",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			local m_type = params._datas._m_type
        	local count = getMineReportTip(m_type)
			local isChange = false
	        if count ~= push_notification_mine_report_defense_count then
	        	isChange = true
	        end
	        push_notification_mine_report_defense_count = count
			if count > 0 then
				if isChange == true then
					if params._widget._istips == true then
						params._widget:removeChild(params._widget._nodeChild, true)
						params._widget._nodeChild = nil
						params._widget._istips = false
					end
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
	
	-- 侦察报告推送
    local push_notification_mine_report_scout_terminal = {
        _name = "push_notification_mine_report_scout",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			local m_type = params._datas._m_type
        	local count = getMineReportTip(m_type)
			local isChange = false
	        if count ~= push_notification_mine_report_scout_count then
	        	isChange = true
	        end
	        push_notification_mine_report_scout_count = count
			if count > 0 then
				if isChange == true then
					if params._widget._istips == true then
						params._widget:removeChild(params._widget._nodeChild, true)
						params._widget._nodeChild = nil
						params._widget._istips = false
					end
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
	
	-- 活动推送
    local push_notification_mine_activity_push_terminal = {
        _name = "push_notification_mine_activity_push",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
        	if true == params._isCountPush or terminal._current_count == nil then
        		terminal._last_count = terminal._last_count or 0
        		terminal._current_count = getActivityPush()
			end
			params._widget:removeChild(params._widget._nodeChild, true)
			params._widget._nodeChild = nil
			params._widget._istips = false
    		if terminal._current_count > 0 then
    			terminal._last_count = terminal._current_count
				local ball = state_machine.excute("util_tips_cretae", 0, {terminal._last_count})
				ball:setAnchorPoint(cc.p(0.5, 0.5))
				ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
				params._widget:addChild(ball)
				params._widget._nodeChild = ball
				params._widget._istips = true
			end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

	-- 宝藏推送
    local push_notification_mine_treasure_push_terminal = {
        _name = "push_notification_mine_treasure_push",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if true == params._isCountPush or terminal._current_count == nil then
        		terminal._last_count = terminal._last_count or 0
        		terminal._current_count = getTreasurePush()
			end
			params._widget:removeChild(params._widget._nodeChild, true)
			params._widget._nodeChild = nil
			params._widget._istips = false
    		if terminal._current_count > 0 then
    			terminal._last_count = terminal._current_count
				local ball = state_machine.excute("util_tips_cretae", 0, "")
				ball:setAnchorPoint(cc.p(0.5, 0.5))
				ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
				params._widget:addChild(ball)
				params._widget._nodeChild = ball
				params._widget._istips = true
			end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    -- 抽奖推送
    local push_notification_mine_lottery_push_terminal = {
        _name = "push_notification_mine_lottery_push",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
        	local count = getLotteryPush(0)
			local isChange = false
	        if count ~= push_notification_mine_lottery_count then
	        	isChange = true
	        end
	        push_notification_mine_lottery_count = count
			if count > 0 then
				if isChange == true then
					if params._widget._istips == true then
						params._widget:removeChild(params._widget._nodeChild, true)
						params._widget._nodeChild = nil
						params._widget._istips = false
					end
				end
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = state_machine.excute("util_tips_cretae", 0, "")
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

    -- 普通抽奖推送
    local push_notification_mine_ordinary_lottery_push_terminal = {
        _name = "push_notification_mine_ordinary_lottery_push",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
        	local count = getLotteryPush(1)
			local isChange = false
	        if count ~= push_notification_mine_ordinary_lottery_count then
	        	isChange = true
	        end
	        push_notification_mine_ordinary_lottery_count = count
			if count > 0 then
				if isChange == true then
					if params._widget._istips == true then
						params._widget:removeChild(params._widget._nodeChild, true)
						params._widget._nodeChild = nil
						params._widget._istips = false
					end
				end
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = state_machine.excute("util_tips_cretae", 0, "")
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


	-- 高级抽奖推送
    local push_notification_mine_advanced_lottery_push_terminal = {
        _name = "push_notification_mine_advanced_lottery_push",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
        	local count = getLotteryPush(2)
			local isChange = false
	        if count ~= push_notification_mine_advanced_lottery_count then
	        	isChange = true
	        end
	        push_notification_mine_advanced_lottery_count = count
			if count > 0 then
				if isChange == true then
					if params._widget._istips == true then
						params._widget:removeChild(params._widget._nodeChild, true)
						params._widget._nodeChild = nil
						params._widget._istips = false
					end
				end
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = state_machine.excute("util_tips_cretae", 0, "")
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

    -- 赠送能量好友按钮的推送
    local push_notification_friend_give_energy_terminal = {
        _name = "push_notification_friend_give_energy",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			local m_type = params._datas._m_type
        	local count = getGiveEnergy()
			local isChange = false
	        if count ~= m_type then
	        	isChange = true
	        end
	        m_type = count
			if count > 0 then
				if isChange == true then
					if params._widget._istips == true then
						params._widget:removeChild(params._widget._nodeChild, true)
						params._widget._nodeChild = nil
						params._widget._istips = false
					end
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
    
    -- 公告
    local push_notification_game_announcement_terminal = {
        _name = "push_notification_game_announcement",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if _ED.push_game_announcement_state ~= false then
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

    -- 资源位购买
    local push_notification_have_buy_build_pos_count_terminal = {
        _name = "push_notification_have_buy_build_pos_count",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if _ED.have_buy_build_pos_count == true then
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

    -- 配件进化活动推送
    local push_notification_parts_activity_state_terminal = {
        _name = "push_notification_parts_activity_state",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if _ED.push_parts_activity_state == true then
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

    -- 聊天推送
    local push_notification_chat_count_terminal = {
        _name = "push_notification_chat_count",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            local m_type = params._datas._m_type
            if _ED.push_chat_count ~= nil and _ED.push_chat_count[""..m_type] ~= nil and tonumber(_ED.push_chat_count[""..m_type]) > 0 then
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

    -- 单个可装备装甲推送
    local push_notification_armor_icon_terminal = {
        _name = "push_notification_armor_icon",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            local formation_type = params._datas._formation_type
            local armor_type = params._datas._armor_type
            if getArmorIconTip(formation_type, armor_type, false) == true then
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

    -- 单个装甲阵型位推送
    local push_notification_armor_formation_terminal = {
        _name = "push_notification_armor_formation",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            local formation_type = params._datas._formation_type
            if getArmorFormationTip(formation_type) == true then
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

    -- 装甲装备总推送
    local push_notification_armor_equipment_terminal = {
        _name = "push_notification_armor_equipment",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if getArmorEquipmentTip() == true then
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

    -- 装甲仓库推送
    local push_notification_armor_pack_terminal = {
        _name = "push_notification_armor_pack",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if getArmorPackTip() == true then
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

    -- 装甲生产推送
    local push_notification_armor_production_terminal = {
        _name = "push_notification_armor_production",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            local production_type = params._datas._production_type
            if getArmorProductionTip(production_type) == true then
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

    -- facebok推送
    local push_notification_facebook_terminal = {
        _name = "push_notification_facebook",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if notificationFacebookTip() == true then
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

    -- 加速道具推送
    local push_notification_quick_prop_push_terminal = {
        _name = "push_notification_quick_prop_push",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            local ntype = params._datas.ntype
            if getQuickPropTip(ntype) == true then
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

    -- 碎片可招募将领推送推送
    local push_notification_leader_exhange_terminal = {
        _name = "push_notification_leader_exhange",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if getLeaderExchangeTip() == true then
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

    state_machine.add(push_notification_home_button_pve_terminal)
    state_machine.add(push_notification_home_button_formation_terminal)
    state_machine.add(push_notification_home_button_packs_terminal)
    state_machine.add(push_notification_pack_resources_terminal)
    state_machine.add(push_notification_pack_fight_terminal)
    state_machine.add(push_notification_pack_treasure_box_terminal)
    state_machine.add(push_notification_pack_other_terminal)
    state_machine.add(push_notification_equipment_parts_icon_terminal)
    state_machine.add(push_notification_equipment_parts_terminal)
    state_machine.add(push_notification_equipment_packs_terminal)
    state_machine.add(push_notification_equipment_pack_fit_terminal)
    state_machine.add(push_notification_equipment_pack_chip_terminal)
    state_machine.add(push_notification_equipment_pack_data_terminal)
    state_machine.add(push_notification_equipment_terminal)
    state_machine.add(push_notification_packs_terminal)
    state_machine.add(push_notification_home_button_task_terminal)
    state_machine.add(push_notification_task_button_main_terminal)
    state_machine.add(push_notification_task_button_daily_terminal)
    state_machine.add(push_notification_task_button_fight_terminal)
    state_machine.add(push_notification_task_button_legion_terminal)
    state_machine.add(push_notification_task_button_grow_terminal)
    state_machine.add(push_notification_task_button_privilege_terminal)
    state_machine.add(push_notification_pve_parts_supply_terminal)
    state_machine.add(push_notification_pve_armor_terminal)
    state_machine.add(push_notification_mine_push_terminal)
    state_machine.add(push_notification_mine_in_box_push_terminal)
    state_machine.add(push_notification_mine_report_push_terminal)
    state_machine.add(push_notification_mine_report_attack_terminal)
    state_machine.add(push_notification_mine_report_defense_terminal)
    state_machine.add(push_notification_mine_report_scout_terminal)
    state_machine.add(push_notification_mine_activity_push_terminal)
    state_machine.add(push_notification_battle_reward_repair_terminal)
    state_machine.add(push_notification_battle_lose_repair_terminal)
    state_machine.add(push_notification_formation_repair_terminal)
    state_machine.add(push_notification_mine_treasure_push_terminal)
    state_machine.add(push_notification_mine_lottery_push_terminal)
    state_machine.add(push_notification_mine_ordinary_lottery_push_terminal)
    state_machine.add(push_notification_mine_advanced_lottery_push_terminal)
    state_machine.add(push_notification_friend_give_energy_terminal)
    state_machine.add(push_notification_game_announcement_terminal)
    state_machine.add(push_notification_have_buy_build_pos_count_terminal)
    state_machine.add(push_notification_parts_activity_state_terminal)
    state_machine.add(push_notification_chat_count_terminal)
    state_machine.add(push_notification_armor_icon_terminal)
    state_machine.add(push_notification_armor_formation_terminal)
    state_machine.add(push_notification_armor_equipment_terminal)
    state_machine.add(push_notification_armor_pack_terminal)
    state_machine.add(push_notification_armor_production_terminal)
    state_machine.add(push_notification_facebook_terminal)
    state_machine.add(push_notification_quick_prop_push_terminal)
    state_machine.add(push_notification_leader_exhange_terminal)
    state_machine.add(push_notification_equipment_pack_chip_compose_terminal)
    state_machine.init()
end
init_push_notification_home_button_terminal()


function getPveTip()
	local count = getPvePartsSupplyTip() + getPveArmorTip()
	return count
end

-- 部队推送
function getFormationTip()
	local index = 0 
	 for k, v in pairs(_ED.user_ship) do
        if v.captain_type ~= 3 then
            if tonumber(v.lose_ship_count) > 0 then
               index = index + 1
            end
        end
    end
	return index
end

-- 单个配件可装备推送
function getEquipmentPartsIconTip(equip_type, index)
	local equip_index = (equip_type - 1) * 8 + index
	local info = _ED.push_user_equipment_table[""..equip_index]
	if info ~= nil then
	    if info.is_have_war == false and info.is_have_equip == true then
	    	return true
	    end
	end
	return false
end

-- 配件可装备总推送
function getEquipmentPartsTip()
	local equipmentPageTable = {0,0,0,0}
	local count = 0
	if funOpenDrawTip(156, false) == true then
		return count
	end
	local need_level_info = zstring.split(dms.string(dms["equipment_config"], 7, equipment_config.param), "|")
	for i=1,4 do
		local number = 0
    	local need_levels = zstring.split(need_level_info[i], ",")
		for j=1,8 do
			if tonumber(_ED.user_info.user_grade) >= tonumber(need_levels[j]) then
				local is_have_war = false
				local is_have_equip = false
				local index = (i - 1) * 8 + j
				local info = _ED.push_user_equipment_table[""..index]
				if info ~= nil then
					is_have_war = info.is_have_war
					is_have_equip = info.is_have_equip
				end
			    if is_have_war == false and is_have_equip == true then
			    	count = count + 1
			    	number = number + 1
			    end
			end
		end
		equipmentPageTable[i] = number
	end
	return count,equipmentPageTable
end

-- 任务总推送
function getTotalTaskTip()
	local count = 0
	if _ED.mould_function_push_info["12"] ~= nil then
		count = tonumber(_ED.mould_function_push_info["12"].params)
	else
		count = _ED.push_user_main_task_count + getDailyTaskTip()
	end
	return count
end

-- 日常任务推送
function getDailyTaskTip()
	local count = _ED.push_user_fight_task_count + _ED.push_user_legion_task_count + _ED.push_user_grow_task_count + _ED.push_user_privilege_task_count
	return count
end

-- 配件补给推送
function getPvePartsSupplyTip()
	if push_notification_parts_supply_info == nil 
		or #push_notification_parts_supply_info <= 0 
		or _ED._is_update_parts_supply == true
		then
		push_notification_parts_supply_info = {}
		_ED._is_update_parts_supply = false
        for k,v in pairs(_ED.scene_current_state) do
	        local _scene_type = dms.int(dms["pve_scene"], k, pve_scene.scene_type) 
	        if _scene_type == 1 then
	        	local open_level = dms.int(dms["pve_scene"], k, pve_scene.open_level) 
	        	local info = {state = v , 
	        				open_level = open_level,
	        				scene_id = k ,
	        				}
	           table.insert(push_notification_parts_supply_info, info) 
	        end
	    end
    end
	local count = 0
    for k,v in pairs(push_notification_parts_supply_info) do
    	if tonumber(v.state) >= 0 then
    		if tonumber(_ED.user_info.user_grade) >= v.open_level then
    			local npc_id = dms.int(dms["pve_scene"],v.scene_id,pve_scene.npcs)
    			local attack_times = _ED.npc_current_attack_count[tonumber(""..npc_id)]
    			if tonumber(attack_times) == 0 then
    				count = count + 1
    			end
    		end
    	end
    end
	return count
end

-- 装甲副本推送
function getPveArmorTip()
    local count = 0
    if funOpenDrawTip(204, false) == true then
        return count
    end
    local times = dms.int(dms["copy_config"],1,copy_config.param)
    local buy_times = 0
    local attack_times = 0
    local is_open = false
    for k,v in pairs(_ED.scene_current_state) do
        local _scene_type = dms.int(dms["pve_scene"], k, pve_scene.scene_type) 
        if _scene_type == battle_enum._fight_type._fight_type_15 then
            if tonumber(v) >= 0 then
                is_open = true
                break
            end
        end
    end
    if is_open == true then
        count = getArmorPveAttackTimes()
    end
    return count
end

-- 邮件推送
function getMineTip(m_type)
	local count = 0
	if m_type == 0 then
		if _ED.mould_function_push_info["7"] ~= nil then
			local datas = zstring.split(_ED.mould_function_push_info["7"].params, ",")
			count = count + zstring.tonumber(datas[1]) + zstring.tonumber(datas[2])
		end
		if _ED.mould_function_push_info["8"] ~= nil then
			count = count + zstring.tonumber(_ED.mould_function_push_info["8"].params)
		end
	else
		if m_type == 7 then
			if _ED.mould_function_push_info[""..m_type] ~= nil then
				local datas = zstring.split(_ED.mould_function_push_info[""..m_type].params, ",")
				if datas[1] ~= nil then
					count = count + zstring.tonumber(datas[1])
				end
				if datas[2] ~= nil then
					count = count + zstring.tonumber(datas[2])
				end
				-- if datas[3] ~= nil then
				-- 	count = count + zstring.tonumber(datas[3])
				-- end
			end
		elseif  m_type == 8 then
			if _ED.mould_function_push_info[""..m_type] ~= nil then
				count = count + zstring.tonumber(_ED.mould_function_push_info[""..m_type].params)
			end
		end
	end
	return count
end

-- 报告推送
function getMineReportTip(m_type)
	local count = 0
	if _ED.mould_function_push_info["7"] ~= nil then
		local datas = zstring.split(_ED.mould_function_push_info["7"].params, ",")
		if datas[tonumber(m_type)] ~= nil then
			count = count + zstring.tonumber(datas[tonumber(m_type)])
		end
	end
	return count
end

function getActivityPush()
	local count = 0
	if _ED.activity_info== nil then 
        return 0
    end
    local push_activity_tables = {} 
    for i, v in pairs(_ED.activity_info) do
        if v ~= nil then
            if tonumber(v.activity_type) == 2           --- 首冲
                or tonumber(v.activity_type) == 45          --- 充值红包
                or tonumber(v.activity_type) == 50          --- 基地冲级
                or tonumber(v.activity_type) == 73          --- 军团副本
                or tonumber(v.activity_type) == 74          --- 战火纷飞
                or tonumber(v.activity_type) == 86          --- 军备竞赛
                or tonumber(v.activity_type) == 90          --- 将领进阶
                or tonumber(v.activity_type) == 92          --- 首次充值
                or tonumber(v.activity_type) == 95          --- 消费返利
                or tonumber(v.activity_type) == 125          --- 累计消费
                or tonumber(v.activity_type) == 52          --- 战力冲榜
                or tonumber(v.activity_type) == 53          --- 关卡排行
                or tonumber(v.activity_type) == 51          --- 军团冲级
                or tonumber(v.activity_type) == 66          --- 军团战力
                or tonumber(v.activity_type) == 93          --- 同心协力
                or tonumber(v.activity_type) == 9 
                or tonumber(v.activity_type) == 4       -- 扫荡关卡
                or tonumber(v.activity_type) == 8       -- 英雄招募
                or tonumber(v.activity_type) == 17      -- 天天限购
                or tonumber(v.activity_type) == 54      -- 部队结集
                or tonumber(v.activity_type) == 55      -- 开服限购
                or tonumber(v.activity_type) == 108     -- 军事培训
                or tonumber(v.activity_type) == 109     -- 有趣道具
                or tonumber(v.activity_type) == 56      -- 百战百胜
                or tonumber(v.activity_type) == 60      -- 寻找宝藏
                or tonumber(v.activity_type) == 61      -- 豪华礼包
                or tonumber(v.activity_type) == 62      -- 竞技胜利
                or tonumber(v.activity_type) == 63      -- 全服冲V
                or tonumber(v.activity_type) == 64      -- 特权宝箱
                or tonumber(v.activity_type) == 65      -- 配件补给
                or tonumber(v.activity_type) == 68      -- 配件进化
                or tonumber(v.activity_type) == 69      -- 军团发展
                or tonumber(v.activity_type) == 70      -- 改造风暴
                or tonumber(v.activity_type) == 72      -- 采集福利
                or tonumber(v.activity_type) == 76      -- 军团捐献
                or tonumber(v.activity_type) == 77      -- 硝烟弥漫
                or tonumber(v.activity_type) == 106     -- 全面发展
                or tonumber(v.activity_type) == 107     -- 完美伪装
                or tonumber(v.activity_type) == 79      -- 7天充值
                or tonumber(v.activity_type) == 41      -- 首冲返利
                or tonumber(v.activity_type) == 80      -- 充值福利
                or tonumber(v.activity_type) == 32      -- 每日单笔
                or tonumber(v.activity_type) == 12      -- 累计充值
                or tonumber(v.activity_type) == 84      -- 配件进化
                or tonumber(v.activity_type) == 85      -- 军团发展
                or tonumber(v.activity_type) == 87      -- 改造风暴
                or tonumber(v.activity_type) == 88      -- 活动达人
                or tonumber(v.activity_type) == 89      -- 军团捐献
                or tonumber(v.activity_type) == 91      -- 硝烟弥漫
                or tonumber(v.activity_type) == 94      -- 7天充值
                or tonumber(v.activity_type) == 110     -- 加速礼包
                or tonumber(v.activity_type) == 111       -- 坦克兑换
                or tonumber(v.activity_type) == 112       -- 开服礼包
                or tonumber(v.activity_type) == 113
                or tonumber(v.activity_type) == 114
                or tonumber(v.activity_type) == 115
                or tonumber(v.activity_type) == 116
                or tonumber(v.activity_type) == 121          --- 英雄招募
                or tonumber(v.activity_type) == 122          --- 幸运抽奖
                or tonumber(v.activity_type) == 124
                or tonumber(v.activity_type) == 47          -- 在线奖励
                or tonumber(v.activity_type) == 120         -- 充值排行
                or tonumber(v.activity_type) == 123     -- 消费排行
                then
                table.insert(push_activity_tables, tonumber(v.activity_type))
            end
        end
    end

    table.insert(push_activity_tables, 59)      -- 领取能量
    table.insert(push_activity_tables, 1)      -- 月卡
    table.insert(push_activity_tables, 16)      -- 礼包兑换

    for k, v in pairs(push_activity_tables) do
        if getPushActivityType(v) == true then
            count = count + 1
        end
    end

	return count
end

function getTreasurePush()
	local count = 0
	if _ED.activity_info== nil then 
        return 0
    end 

    local push_activity_tables = {} 
    for i,v in pairs(_ED.activity_info) do
        if v ~= nil then
            if tonumber(v.activity_type) == 78 
                or tonumber(v.activity_type) == 83
                or tonumber(v.activity_type) == 7
                or tonumber(v.activity_type) == 82
                or tonumber(v.activity_type) == 97
                or tonumber(v.activity_type) == 98
                or tonumber(v.activity_type) == 57 
                or tonumber(v.activity_type) == 58 
                or tonumber(v.activity_type) == 75
                or tonumber(v.activity_type) == 102 
                or tonumber(v.activity_type) == 67
                or tonumber(v.activity_type) == 71
                or tonumber(v.activity_type) == 104
                or tonumber(v.activity_type) == 105
                or tonumber(v.activity_type) == 98
                or tonumber(v.activity_type) == 99 
                or tonumber(v.activity_type) == 81 
                or tonumber(v.activity_type) == 57 
                or tonumber(v.activity_type) == 96 
                or tonumber(v.activity_type) == 101 
                or tonumber(v.activity_type) == 97 
                or tonumber(v.activity_type) == 99
                or tonumber(v.activity_type) == 101
                or tonumber(v.activity_type) == 118
                or tonumber(v.activity_type) == 127
                or tonumber(v.activity_type) == 103
                or tonumber(v.activity_type) == 119
                or tonumber(v.activity_type) == 129
                then
                table.insert(push_activity_tables, tonumber(v.activity_type))
            end
        end
    end

    if __lua_project_id == __lua_project_pacific_rim then
        table.insert(push_activity_tables, 46)      -- 幸运抽奖
    end

    for k, v in pairs(push_activity_tables) do
        if getPushActivityType(v) == true then
            count = count + 1
        end
    end

	return count
end

-- 活动推送状态
function getPushActivityType(activity_type)
    if _ED.activity_info== nil then 
        return false
    end 

    local activity_info = _ED.activity_info[""..activity_type]
    local server_time_month = os.date("%m", zstring.exchangeFrom(_ED.system_time + (os.time() - _ED.native_time)))
    local server_time_day = os.date("%d", zstring.exchangeFrom(_ED.system_time + (os.time() - _ED.native_time)))
    -- 活动
    if tonumber(activity_type) == 2           --- 首冲
        or tonumber(activity_type) == 4           --- 疯狂关卡
        or tonumber(activity_type) == 45          --- 充值红包
        or tonumber(activity_type) == 50          --- 基地冲级
        or tonumber(activity_type) == 62          --- 战地风云
        or tonumber(activity_type) == 63          --- 全服冲v
        or tonumber(activity_type) == 69          --- 军团募集
        or tonumber(activity_type) == 72          --- 采集福利
        or tonumber(activity_type) == 73          --- 军团副本
        or tonumber(activity_type) == 74          --- 战火纷飞
        or tonumber(activity_type) == 41          --- 首冲返利
        or tonumber(activity_type) == 80          --- 充值福利
        or tonumber(activity_type) == 32          --- 每日单笔
        or tonumber(activity_type) == 12          --- 累计充值
        or tonumber(activity_type) == 86          --- 军备竞赛
        or tonumber(activity_type) == 90          --- 将领进阶
        or tonumber(activity_type) == 92          --- 首次充值
        or tonumber(activity_type) == 95          --- 消费返利
        or tonumber(activity_type) == 121          --- 英雄招募
        or tonumber(activity_type) == 122          --- 幸运抽奖
        or tonumber(activity_type) == 124          
        or tonumber(activity_type) == 125
        then
        if activity_info.activity_data[1]~= nil then
            for j, w in pairs(activity_info.activity_data[1]) do
                local complete_count = zstring.split(w.achieve_complete_count, "/")
                if tonumber(complete_count[1]) >= tonumber(complete_count[2]) and tonumber(w.achieve_state) ~= 2 then
                    return true
                end
            end
        end
    end

    if tonumber(activity_type) >= 112 
        and tonumber(activity_type) <= 116 
        then
        local infoData = zstring.split(activity_info.activity_add_state, ",")
        for j, w in pairs(activity_info.activity_data[1]) do
            local current_count = zstring.split(w.achieve_complete_count, "/")
            local current_recive_count = zstring.tonumber(infoData[j + 1])
            if zstring.tonumber(current_count[1]) > current_recive_count then
                return true
            end
        end
    end 

    if tonumber(activity_type) == 52          --- 战力冲榜
        or tonumber(activity_type) == 53          --- 关卡排行
        or tonumber(activity_type) == 51          --- 军团冲级
        or tonumber(activity_type) == 66          --- 军团战力
        or tonumber(activity_type) == 93          --- 同心协力
        then
        local timesData = zstring.split(activity_info.activity_add_state, ",")
        if (tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))) < tonumber(timesData[3])/1000 then
        else
            if activity_info.activity_data[1] ~= nil then
                for j, w in pairs(activity_info.activity_data[1]) do
                    local push_activity = false
                    if tonumber(activity_type) == 51 then
                        local achievement = zstring.split(w.achieve_other_info, ",")
                        if tonumber(w.achieve_state) ~= 2 then
                            if tonumber(achievement[1]) == tonumber(achievement[2]) then
                                if tonumber(timesData[5]) == tonumber(achievement[1]) and tonumber(timesData[4]) >= tonumber(achievement[3]) and tonumber(timesData[4]) <= tonumber(achievement[4]) then
                                    push_activity = true
                                else
                                    push_activity = false
                                end
                            else
                                if tonumber(timesData[5]) >= tonumber(achievement[1]) and tonumber(timesData[5]) <= tonumber(achievement[2])
                                    and tonumber(timesData[4]) >= tonumber(achievement[3]) and tonumber(timesData[4]) <= tonumber(achievement[4]) then
                                    push_activity = true
                                else
                                    push_activity = false
                                end
                            end
                        else
                            push_activity = false
                        end
                    elseif tonumber(activity_type) == 52 or tonumber(activity_type) == 53 then
                        local achievement = zstring.split(w.achieve_other_info, ",")
                        if tonumber(w.achieve_state) ~= 2 then
                            if tonumber(achievement[1]) <= tonumber(timesData[4]) 
                                and tonumber(achievement[2]) >= tonumber(timesData[4]) 
                                then
                                push_activity = true
                            else
                                push_activity = false
                            end
                        else
                            push_activity = false
                        end
                    else
                        if zstring.tonumber(timesData[4]) ~= 0 
                            and zstring.tonumber(timesData[4]) == j
                            and tonumber(w.achieve_state) ~= 2
                            then
                            push_activity = true
                            if zstring.tonumber(timesData[7]) > zstring.tonumber(timesData[8]) then
                                push_activity = false
                            end
                        else
                            push_activity = false
                        end
                    end
                    if push_activity == true then
                        return true
                    end
                end
            end
        end
    end
    
    if tonumber(activity_type) == 79 
        or tonumber(activity_type) == 89
        then
        if activity_info.activity_data[2]~= nil then
            for j, w in pairs(activity_info.activity_data[2]) do
                local complete_count = zstring.split(w.achieve_complete_count, "/")
                if tonumber(complete_count[1]) >= tonumber(complete_count[2]) 
                    and tonumber(w.achieve_state) ~= 2 
                    and w.achieve_reward ~= "-1" 
                    then
                    return true
                end
            end
        end
    end

    if tonumber(activity_type) == 9 then
        if activity_info.activity_data[1]~= nil then
            local complete_count = zstring.split(activity_info.activity_data[1][1].achieve_complete_count, "/")
            if tonumber(_ED.vip_grade) >= tonumber(complete_count[2]) then
                if tonumber(activity_info.activity_data[1][1].achieve_state) ~= 2 then
                    return true
                else
                    if activity_info.activity_data[2]~= nil then
                        for j, w in pairs(activity_info.activity_data[2]) do
                            local complete_count = zstring.split(w.achieve_complete_count, "/")
                            if tonumber(complete_count[1]) >= tonumber(complete_count[2]) and tonumber(w.achieve_state) ~= 2 then
                                return true
                            end
                        end
                    end
                end
            end 
        end 
    end 
        
    if tonumber(activity_type) == 4       -- 扫荡关卡
        or tonumber(activity_type) == 8       
        or tonumber(activity_type) == 17      
        or tonumber(activity_type) == 54 
        or tonumber(activity_type) == 55
        or tonumber(activity_type) == 108
        or tonumber(activity_type) == 109
        or tonumber(activity_type) == 56 
        or tonumber(activity_type) == 60
        or tonumber(activity_type) == 61 
        or tonumber(activity_type) == 62      -- 竞技胜利
        or tonumber(activity_type) == 63      -- 全服冲V
        or tonumber(activity_type) == 64 
        or tonumber(activity_type) == 65 
        or tonumber(activity_type) == 68  
        or tonumber(activity_type) == 69      -- 军团发展
        or tonumber(activity_type) == 70 
        or tonumber(activity_type) == 72      -- 采集福利
        or tonumber(activity_type) == 76 
        or tonumber(activity_type) == 77
        or tonumber(activity_type) == 106
        or tonumber(activity_type) == 107 
        or tonumber(activity_type) == 79      -- 7天充值
        or tonumber(activity_type) == 41      -- 首冲返利
        or tonumber(activity_type) == 80      -- 充值福利
        or tonumber(activity_type) == 32          --- 每日单笔
        or tonumber(activity_type) == 12          --- 累计充值
        or tonumber(activity_type) == 84      -- 全民狂欢
        or tonumber(activity_type) == 85      -- 科技飙升
        or tonumber(activity_type) == 87      -- 疯狂矿工
        or tonumber(activity_type) == 88      -- 活动达人
        or tonumber(activity_type) == 89      -- 连续小充
        or tonumber(activity_type) == 91      -- 火线支援
        or tonumber(activity_type) == 94      -- 将领进化
        or tonumber(activity_type) == 110     -- 加速礼包
        or tonumber(activity_type) == 111       -- 坦克兑换
        or tonumber(activity_type) == 112       -- 开服礼包
        or tonumber(activity_type) == 113
        or tonumber(activity_type) == 114
        or tonumber(activity_type) == 115
        or tonumber(activity_type) == 116
        or tonumber(activity_type) == 121
        or tonumber(activity_type) == 122
        or tonumber(activity_type) == 124
        then
        local saveActiveTime_month = os.date("%m", zstring.exchangeFrom(zstring.tonumber(cc.UserDefault:getInstance():getStringForKey(getKey("activity_id_"..activity_type)))))
        local saveActiveTime_day = os.date("%d", zstring.exchangeFrom(zstring.tonumber(cc.UserDefault:getInstance():getStringForKey(getKey("activity_id_"..activity_type)))))
        if tonumber(server_time_month) > tonumber(saveActiveTime_month) or tonumber(server_time_day) > tonumber(saveActiveTime_day) then
            return true
        end
        if tonumber(activity_type) == 56 then
            if activity_info.activity_data[1]~= nil then
                for j, w in pairs(activity_info.activity_data[1]) do
                    local complete_count = zstring.split(w.achieve_complete_count, "/")
                    if tonumber(complete_count[1]) >= tonumber(complete_count[2]) and tonumber(w.achieve_state) ~= 2 then
                        return true
                    end
                end
            end
        end
    end 
    if tonumber(activity_type) == 59 then
        local current = _ED.system_time + (os.time() - _ED.native_time)
        --判断中午12点的差距时间
        local noon = 12*3600
        local noonEnd = 14*3600
        local temp = getCurrentGTM8Time()
        local m_hour    = tonumber(string.format("%02d", temp.hour))
        local m_min     = tonumber(string.format("%02d", temp.min))
        local m_sec     = tonumber(string.format("%02d", temp.sec))
        if m_hour*3600+m_min*60+m_sec >= noon  and m_hour*3600+m_min*60+m_sec <= noonEnd then
            if _ED.user_task_infos["3"] ~= nil then
                for i,v in pairs(_ED.user_task_infos["3"]) do
                    if tonumber(v.task_state) == 1 then
                        return true
                    end
                end 
            end
        end
    end
    if tonumber(activity_type) == 47 then
        local datas = zstring.split(activity_info.activity_add_state,",")
        local m_time = (tonumber(datas[3])/1000)+(os.time()-activity_info.start_time)
        if activity_info.activity_data[1]~= nil then
            for j, w in pairs(activity_info.activity_data[1]) do
                local m_datas = zstring.split(w.achieve_complete_count, "/")
                if math.floor(m_time/60) >= tonumber(m_datas[2]) and tonumber(w.achieve_state) <= 1 then
                    return true
                end
            end
        end     
    end
    if tonumber(activity_type) == 60 then 
        local rewarld = zstring.split(activity_info.activity_data[1][1].achieve_other_info, ",")
        local number = {}
        for i=1,#rewarld do
            local datas = {}
            local index = 0
            if i == 1 then
                index = 0
            elseif i==2 then
                index = 4
            elseif i==3 then
                index = 8
            elseif i==4 then
                index = 12
            end
            for j=1,4 do
                datas[j] = rewarld[index+j]
            end
            if tonumber(datas[1]) == -1 then
                datas[1] = resource_prop_id[tonumber(datas[2])]
            end
            number[i] = 0
            for w, v in pairs(_ED.user_prop) do
                if tonumber(v.user_prop_template) == tonumber(datas[1]) then
                    number[i] = tonumber(v.prop_number) 
                end
            end
        end
        if number[1] >0 and number[2] > 0 and number[3] >0 and number[4] >0 then
            return true
        end
    end
    if tonumber(activity_type) == 1 then
        local _drawMonth = dms.searchs(dms["top_up_goods"], top_up_goods.goods_type, 1)
        for i = 1 , 2 do
            if _ED.month_card ~= nil and _ED.month_card ~= "" and _ED.month_card[_drawMonth[i][1]] ~= nil and _ED.month_card[_drawMonth[i][1]] ~= "" 
                and tonumber(_ED.month_card[_drawMonth[i][1]].surplus_month_card_time) ~= 0 then
                if tonumber(_ED.month_card[_drawMonth[i][1]].draw_month_card_state) == 0 then
                    return true
                end
            end
        end
    end
    if tonumber(activity_type) == 88 then
        for i , v in pairs(activity_info.activity_data) do
            for j , w in pairs(v) do
                if tonumber(w.achieve_state) == 1 then
                    return true
                end
            end
        end
    end
    if tonumber(activity_type) == 120             -- 充值排行
        or tonumber(activity_type) == 123         -- 消费排行
        then
        local activity_add_state = zstring.split(activity_info.activity_add_state, ",")
        if tonumber(activity_add_state[3]) / 1000 < (os.time() + _ED.time_add_or_sub) then
            local activity_data = activity_info.activity_data[1]
            for k1, v1 in pairs(activity_data) do
                if tonumber(v1.achieve_state) == 1 then
                    return true
                end
            end
        end
    end

    -- 宝藏
    if tonumber(activity_type) == 78 then
        if activity_info.activity_data[1]~= nil then
            for j, w in pairs(activity_info.activity_data[1]) do
                local complete_count = zstring.split(w.achieve_complete_count, "/")
                if _ED.activity_to_full_service >= zstring.tonumber(complete_count[2]) and tonumber(w.achieve_state) ~= 2 then
                    return true
                end 
            end
        end
        if activity_info.activity_data[2]~= nil then
            for j, w in pairs(activity_info.activity_data[2]) do
                local complete_count = zstring.split(w.achieve_complete_count, "/")
                if tonumber(complete_count[1]) >= tonumber(complete_count[2]) and tonumber(w.achieve_state) ~= 2 then
                    return true
                end
            end
        end
    end    
    if tonumber(activity_type) == 83 and _ED.activity_info["7"] == nil then
        if activity_info.activity_data[1]~= nil then
            for j, w in pairs(activity_info.activity_data[1]) do
                local complete_count = zstring.split(w.achieve_complete_count, "/")
                if tonumber(complete_count[1]) >= tonumber(complete_count[2]) and tonumber(w.achieve_state) ~= 2 then
                    return true
                end
            end
        end
        if activity_info.activity_data[2]~= nil then
            for j, w in pairs(activity_info.activity_data[2]) do
                local complete_count = zstring.split(w.achieve_complete_count, "/")
                if tonumber(complete_count[1]) >= tonumber(complete_count[2]) and tonumber(w.achieve_state) ~= 2 then
                    return true
                end
            end
        end
    end
    if tonumber(activity_type) == 7 or tonumber(activity_type) == 82 
        or tonumber(activity_type) == 97
        or tonumber(activity_type) == 98
        then
        local activity_data = nil 
        if tonumber(activity_type) == 98 then
            activity_data = activity_info.activity_data[2]
        else
            activity_data = activity_info.activity_data[1]
        end
        if activity_data ~= nil then
            for j, w in pairs(activity_data) do
                local complete_count = zstring.split(w.achieve_complete_count, "/")
                if tonumber(complete_count[1]) >= tonumber(complete_count[2]) and tonumber(w.achieve_state) ~= 2 then
                    return true
                end
            end
        end
    end

    if tonumber(activity_type) == 57
        --or tonumber(activity_type) == 96
        --or tonumber(activity_type) == 97
        then
        local saveActiveTime_month = os.date("%m", zstring.exchangeFrom(zstring.tonumber(cc.UserDefault:getInstance():getStringForKey(getKey("activity_id_"..activity_type)))))
        local saveActiveTime_day = os.date("%d", zstring.exchangeFrom(zstring.tonumber(cc.UserDefault:getInstance():getStringForKey(getKey("activity_id_"..activity_type)))))
        if tonumber(server_time_month) > tonumber(saveActiveTime_month) or tonumber(server_time_day) > tonumber(saveActiveTime_day) then
            return true
        end
    elseif tonumber(activity_type) == 58 
        or tonumber(activity_type) == 75
        or tonumber(activity_type) == 102  
        then
        local activity_add_state_info = zstring.split(activity_info.activity_add_state,"|")
        local activity_add_state = zstring.split(activity_add_state_info[1],",")
        if tonumber(activity_add_state[7]) < tonumber(activity_add_state[8]) then
            return true
        end
    end 
    if tonumber(activity_type) == 67 then
        local activity_add_state = zstring.split(activity_info.activity_add_state,",")
        local isHaveRank = false
        for i,v in pairs(_ED.accessories_points_ranking) do
            if v.name == _ED.user_info.user_name then
                isHaveRank = true
            end
        end
        if tonumber(activity_add_state[10])/1000 > (tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))) then
            if tonumber(activity_add_state[5]) < tonumber(activity_add_state[6]) then
                return true
            end 
        else
            if isHaveRank == true then
                local already_receive = false
                for k,v in pairs(activity_info.activity_data[1]) do
                    if tonumber(v.achieve_state) == 2 then
                        already_receive = true
                        break
                    end
                end
                if already_receive == false then
                    return true
                end 
            end
        end
    end
    --免费次数类型推送
    if tonumber(activity_type) == 71
        or tonumber(activity_type) == 104
        or tonumber(activity_type) == 105
        or tonumber(activity_type) == 98
        or tonumber(activity_type) == 99 
        then
        local activity_add_state = zstring.split(activity_info.activity_add_state,",")
        local currNumber = 0
        local maxNumber = 0
        if tonumber(activity_type) == 71 
            or tonumber(activity_type) == 104
            or tonumber(activity_type) == 105
            then
            currNumber = tonumber(activity_add_state[4])
            maxNumber = tonumber(activity_add_state[5])
        elseif tonumber(activity_type) == 98 then
            currNumber = tonumber(activity_add_state[7])
            maxNumber = tonumber(activity_add_state[8])
        elseif tonumber(activity_type) == 99 then
            currNumber = tonumber(activity_add_state[5])
            maxNumber = tonumber(activity_add_state[6])
        else

        end
        if currNumber < maxNumber then
            if tonumber(activity_type) == 99 then
                if tonumber(activity_add_state[3])/1000 > (tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))) then
                    return true
                end
            else
                return true
            end
        else
            if tonumber(activity_type) == 71 
                or tonumber(activity_type) == 104
                or tonumber(activity_type) == 105
                then
                for k1, v1 in pairs(activity_info.activity_data) do
                    local other_info = zstring.split(v1[1].achieve_other_info,",")
                    local mould_id = tonumber(other_info[1])
                    local numbers = 0
                    for i,v in pairs(_ED.user_prop) do
                        if tonumber(v.user_prop_template) == mould_id then
                            numbers = tonumber(v.prop_number)
                            break
                        end
                    end
                    if tonumber(numbers) >= tonumber(other_info[3]) then
                        return true
                    end
                end
            end
        end
    end
    if tonumber(activity_type) == 81 then
        local activity_add_state = zstring.split(activity_info.activity_add_state,",")
        local isHaveRank = false
        if zstring.tonumber(activity_add_state[13]) > 0 then
            isHaveRank = true
        end
        if tonumber(activity_add_state[11])/1000 > (tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))) then
            if math.floor(tonumber(activity_add_state[4])/tonumber(activity_add_state[7]))-tonumber(activity_add_state[5]) > 0 then
                return true
            end
            if tonumber(activity_add_state[10]) - tonumber(activity_add_state[9]) > 0 then
                return true
            end
        else
            if isHaveRank == true then
                local already_receive = false
                for k,v in pairs(activity_info.activity_data[2]) do
                    if tonumber(v.achieve_state) == 2 then
                        already_receive = true
                        break
                    end
                end
                if already_receive == false then
                    return true
                end 
            end
        end
    end
    if tonumber(activity_type) == 57  then
        if _ED.union.union_info == nil 
            or _ED.union.union_info == {} 
            or _ED.union.union_info.union_id == nil 
            or _ED.union.union_info.union_id == "" 
            or tonumber(_ED.union.union_info.union_id) == 0 
            then
            
        else
            if _ED.mould_function_push_info~= nil and _ED.mould_function_push_info["11"]~= nil then
                if tonumber(_ED.mould_function_push_info["11"].params) > 0 then
                    return true
                end
            end
        end
    end
    if tonumber(activity_type) == 96 then
        local activity_add_state = zstring.split(activity_info.activity_add_state,",")
        local currNumber = math.min(math.floor(tonumber(activity_add_state[6]) / tonumber(activity_add_state[4])) , tonumber(activity_add_state[5])) 
        currNumber =  currNumber - tonumber(activity_add_state[7])
        if currNumber > 0 then
            return true
        end
    end
    if tonumber(activity_type) == 101 then
        local activity_add_state_array = zstring.split(activity_info.activity_add_state,"|")
        local timesData = zstring.split(activity_add_state_array[1] , ",")
        if tonumber(timesData[3])/1000 > (tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))) then
            for i = 1 , 3 do
                local activity_add_state = zstring.split(activity_add_state_array[1 + i] , ",")
                if tonumber(activity_add_state[1]) < tonumber(activity_add_state[2]) then
                    return true
                end
            end
        end
    end
    --排行榜类型的推送处理
    if tonumber(activity_type) == 97
        or tonumber(activity_type) == 99
        or tonumber(activity_type) == 101 
        or tonumber(activity_type) == 118
        or tonumber(activity_type) == 127
        then
        local activity_add_state = zstring.split(activity_info.activity_add_state,",")
        local isHaveRank = false
        local points_ranking = {}
        local activity_data = {}
        if tonumber(activity_type) == 97 then
            points_ranking = _ED.military_exploit_points_ranking
            activity_data = activity_info.activity_data[2]
        elseif tonumber(activity_type) == 99 then
            points_ranking = _ED.leader_senior_points_ranking
            activity_data = activity_info.activity_data[1]
        elseif tonumber(activity_type) == 101 then
            points_ranking = _ED.military_pulpit_points_ranking
            activity_data = activity_info.activity_data[1]
        elseif tonumber(activity_type) == 118 then
            points_ranking = _ED.largesse_give_points_ranking
            activity_data = activity_info.activity_data[1]
        elseif tonumber(activity_type) == 127 then
            points_ranking = _ED.full_vitality_activity_rank
            activity_data = activity_info.activity_data[2]
        else

        end
        if points_ranking ~= nil then
            for i,v in pairs(points_ranking) do
                if v.name == _ED.user_info.user_name then
                    isHaveRank = true
                end
            end
        end
        local have_push = false
        if tonumber(activity_add_state[3])/1000 > (tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))) then
        else
            if isHaveRank == true then
                local already_receive = false
                for k,v in pairs(activity_data) do
                    if tonumber(v.achieve_state) == 2 then
                        already_receive = true
                        break
                    end
                end
                if already_receive == false then
                    have_push = true
                    return true
                end 
            end
        end
        if have_push == false then
            if tonumber(activity_type) == 118
                or tonumber(activity_type) == 127
                then
                local activity_data = nil
                if tonumber(activity_type) == 118 then
                    activity_data = activity_info.activity_data[2]
                elseif tonumber(activity_type) == 127 then
                    activity_data = activity_info.activity_data[1]
                end
                if activity_data ~= nil then
                    for j, w in pairs(activity_data) do
                        local complete_count = zstring.split(w.achieve_complete_count, "/")
                        if zstring.tonumber(complete_count[1]) >= zstring.tonumber(complete_count[2]) and tonumber(w.achieve_state) ~= 2 then
                            return true
                        end 
                    end
                end
            end
        end
    end
    -- 传奇名将
    if tonumber(activity_type) == 119 then
        local activity_add_state_arry = zstring.split(activity_info.activity_add_state,"!")
        local other_info = zstring.split(activity_add_state_arry[2],"|")
        other_info = zstring.split(other_info[1], ",")
        if tonumber(other_info[1]) < tonumber(other_info[2]) then
            return true
        end
    end

    -- 幸运抽奖
    if tonumber(activity_type) == 46 then
        if getLotteryPush(0) > 0 then
            return true
        end
    end
    --折扣卖场推送
    if tonumber(activity_type) == 103 then
        if discountStorePagePush(1) == true or discountStorePagePush(2) == true 
            or discountStorePagePush(3) == true then
            return true
        end
    end

    --欢乐团购推送
    if tonumber(activity_type) == 129 then
        if _ED.happy_buy_activity_info ~= nil and _ED.happy_buy_activity_info.record_list ~= nil and _ED.happy_buy_activity_info.all_count ~= nil then
            for k, v in pairs(_ED.happy_buy_activity_info.record_list) do
                local discount = tonumber(_ED.happy_buy_activity_info.all_count[v.data_index].discount)
                local activity_data = activity_info.activity_data[1][v.data_index]
                local cost_info = zstring.split(activity_data.achieve_other_info, ",")
                local cost = math.ceil(tonumber(cost_info[3]) * discount / 10)
                local can_rebate_gold = v.cost_gold - cost - v.rebate_gold
                if can_rebate_gold > 0 then
                    return true
                end
            end
        end
    end

    -- 狂欢时刻推送
    if tonumber(activity_type) == 130 then
        if getCanivalHourPush(1) == true or getCanivalHourPush(2) == true or getCanivalHourPush(3) == true then
            return true
        end
    end

    return false
end

function getLotteryPush(m_index) 
	local count = 0
	if _ED.activity_info== nil then 
        return 0
    end  
	if _ED.activity_info["46"]~= nil then
		local _params = zstring.split(_ED.activity_info["46"].activity_add_state, "|")
		local datasInfoOne = zstring.split(_params[1], ",")
		local datasInfoTwo = zstring.split(_params[2], ",")
		if tonumber(datasInfoOne[4]) > tonumber(_ED.vip_grade) then
			datasInfoOne[1] = "1"
		end
		if tonumber(datasInfoTwo[4]) > tonumber(_ED.vip_grade) then
			datasInfoTwo[1] = "1"
		end
		if m_index == 0 then

			--免费
			if tonumber(datasInfoOne[1]) == 0 then
				count = count + 1
			end
			if tonumber(_ED.user_info.user_grade) > 10 then
				if tonumber(datasInfoTwo[1]) == 0 then
					count = count + 1
				end
			end
			--道具
			for i, v in pairs(_ED.user_prop) do
				if tonumber(v.user_prop_template) == dms.int(dms["prop_config"], 20, prop_config.param) then
					if tonumber(v.prop_number) >= 1 and tonumber(v.prop_number) < 3 then
						count = count + 1
					else
						if tonumber(_ED.user_info.user_grade) > 10 then
							count = count + 2
						end
					end
				end
			end
		elseif m_index == 1 then
			if tonumber(datasInfoOne[1]) == 0 then
				count = count + 1
			end
		elseif m_index == 2 then
			if tonumber(datasInfoTwo[1]) == 0 then
				count = count + 1
			end
		end
	end
	return count
end
-- --赠送能量推送
function getGiveEnergy()
	local count = 0
	if _ED.friend_info== nil then 
        return 0
    end
    for i,v in pairs(_ED.friend_info) do
    	if tonumber(v.is_receive) == 1 then
    		count = count + 1
    	end 
    end
    -- 剩余领取次数
    local can_receive_count = 10 - zstring.tonumber(_ED.friendRecipientsNumber)
    count = math.min(count, can_receive_count)
    return count
end

--单个装甲是否装备推送
function getArmorIconTip(formation_type, armor_type, check_best)
    getRedAlertTimeArmorPartsTip()
    local armor_info = nil
    if _ED.push_user_armor_equip_table[""..formation_type] ~= nil then
        armor_info = _ED.push_user_armor_equip_table[""..formation_type][""..armor_type]
    end
    local best_armor_info = _ED.push_user_armor_best_table[""..armor_type]
    if best_armor_info ~= nil then
        if armor_info == nil then
            return true
        end
        if check_best == true then
            if best_armor_info.grow_level > armor_info.grow_level
                or (best_armor_info.grow_level == armor_info.grow_level and tonumber(best_armor_info.upgrade_level) > tonumber(armor_info.upgrade_level))
                or (best_armor_info.grow_level == armor_info.grow_level and tonumber(best_armor_info.upgrade_level) == tonumber(armor_info.upgrade_level) and tonumber(best_armor_info.experience) > tonumber(armor_info.experience))
                then
                return true
            end
        end
    end
    return false
end

-- 单个装甲阵型推送
function getArmorFormationTip(formation_type)
    for i = 1, 6 do
        if getArmorIconTip(formation_type, i, true) == true then
            return true
        end
    end
    return false
end

-- 装甲装备总推送
function getArmorEquipmentTip()
    for i = 1, 6 do
        if getArmorFormationTip(i) == true then
            return true
        end
    end
    return false
end

-- 装甲仓库推送
function getArmorPackTip()
    if funOpenDrawTip(204, false) == true then
        return false
    end
    -- 装甲
    getRedAlertTimeArmorPartsTip()
    if zstring.tonumber(_ED.push_user_have_armor_count) > 0 then
        return true
    end

    -- 经验
    if zstring.tonumber(_ED.push_user_armor_packs_count) > 0 then
        return true
    end
    return false
end

-- 装甲生产推送
function getArmorProductionTip(production_type)
    if funOpenDrawTip(204, false) == true then
        return false
    end
    if _ED.user_armor_info ~= nil and _ED.user_armor_info.free_times_info ~= nil then
        if production_type == 0 then        -- 全部生产推送
            for k, v in pairs(_ED.user_armor_info.free_times_info) do
                if tonumber(v.free_times) > 0 then
                    return true
                end
            end
        else
            if tonumber(_ED.user_armor_info.free_times_info[""..production_type].free_times) > 0 then
                return true
            end
        end
    end
    return false
end
--facebook推送
function notificationFacebookTip()
	if _ED.redAlertTime_fb_info ~= nil then 
		for i , v in pairs(_ED.redAlertTime_fb_info) do 
			if tonumber(v.reward_state) == 1 then
				return true
			end 
		end
	else
		return false
	end
	return false
end

-- 有可加速道具推送
function getQuickPropTip(ntype)
    local prop_ids = nil
    if ntype == 1 then      -- 建造加速
        prop_ids = _ED.base_build_shop_info["2"]["0"].prop_ids
    elseif ntype == 2 then      -- 科技加速
        prop_ids = _ED.base_build_shop_info["3"]["0"].prop_ids
    elseif ntype == 3 then      -- 生产加速
        prop_ids = _ED.base_build_shop_info["4"]["0"].prop_ids
    end
    for k, v in pairs(prop_ids) do
        local prop_count = 0 
        local prop = fundPropWidthId(v) 
        if prop ~= nil then 
            prop_count = tonumber(prop.prop_number)
        end
        if prop_count > 0 then
            return true
        end
    end
    return false
end

function getLeaderExchangeTip()
    for k, v in pairs(_ED.user_prop) do
        if tonumber(v.storage_page_index) == 23 then
            local is_owned = false
            local ship_template_id = dms.int(dms["prop_mould"], tonumber(v.user_prop_template), prop_mould.use_of_ship)     -- 兑换后将领模板id
            local base_template_id = dms.int(dms["ship_mould"], ship_template_id, ship_mould.base_mould)
            for k, v in pairs(_ED.user_ship) do
                if tonumber(v.ship_base_template_id) == base_template_id then
                    is_owned = true
                    break
                end
            end
            if is_owned == false and tonumber(v.prop_number) >= tonumber(v.coming_need_number) then
                return true
            end
        end
    end
    return false
end

function getCanivalHourPush(nType)
    if _ED.activity_info == nil or _ED.activity_info["130"] == nil then
        return false
    end

    local activity_info = _ED.activity_info["130"]
    if nType == 1 then
        -- 在线奖励
        local activity_data = activity_info.activity_data[1]
        local activity_add_state_arr = zstring.split(activity_info.activity_add_state,"|")
        local activity_add_state = zstring.split(activity_add_state_arr[1], ",")
        local have_time = tonumber(activity_add_state[6]) / 1000 + (os.time() + _ED.time_add_or_sub - tonumber(activity_add_state[5]) / 1000)
        if activity_data ~= nil then
            for k, v in pairs(activity_data) do
                if v.achieve_other_info == "-1" then
                    local complete_count = zstring.split(v.achieve_complete_count, "/")
                    if math.floor(have_time / 60) >= tonumber(complete_count[2]) and tonumber(v.achieve_state) <= 1 then
                        return true
                    end
                end
            end
        end  
    elseif nType == 2 then
        -- 充值好礼
        local activity_data = activity_info.activity_data[2]
        for k, v in pairs(activity_data) do
            local complete_count = zstring.split(v.achieve_complete_count, "/")
            if tonumber(complete_count[1]) >= tonumber(complete_count[2]) and tonumber(v.achieve_state) ~= 2 then
                return true
            end
        end
    elseif nType == 3 then
        -- 折扣卖场
        local next_push_time = zstring.tonumber(cc.UserDefault:getInstance():getStringForKey(getKey("activity_id_"..activity_info.activity_type)))
        if next_push_time <= os.time() then
            return true
        end
    end
    return false
end

