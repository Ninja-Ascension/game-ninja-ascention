-- Initialize push notification center state machine.
smPushNotificationCenterUnionHaveDuplicateData = false
smPushNotificationCenterUnionHaveRedEnvelopesData = false
smPushNotificationCenterUnionHavePowerHourseData = false
smPushNotificationCenterUnionSystemHaveRedEnvelopesData = false
local function init_push_notification_center_union_terminal()
	--首页活动按钮的推送
    -- local push_notification_center_activity_all_terminal = {
        -- _name = "push_notification_center_activity_all",
        -- _init = function (terminal)
        -- end,
        -- _inited = false,
        -- _instance = self,
        -- _state = 0,
        -- _invoke = function(terminal, instance, params)
			-- if getactivityAllTip() == true then
				-- if params._widget._istips == nil or params._widget._istips == false then
					-- local ball = cc.Sprite:create("images/ui/bar/tips.png")
					-- ball:setAnchorPoint(cc.p(0.5, 0.5))
					-- ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
					-- params._widget:addChild(ball)
					-- params._widget._nodeChild = ball
					-- params._widget._istips = true
				-- end
			-- else
				-- if params._widget._istips == true then
					-- params._widget:removeChild(params._widget._nodeChild, true)
					-- params._widget._nodeChild = nil
					-- params._widget._istips = false
				-- end
			-- end
			
            -- return true
        -- end,
        -- _terminal = nil,
        -- _terminals = nil
    -- }
     -- 主界面
	local push_notification_center_union_all_terminal = {
		_name = "push_notification_center_union_all",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
		_invoke = function(terminal, instance, params)
			if getUnionAllTip() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_naruto then
						ball:setAnchorPoint(cc.p(1, 1))
						ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height))
					elseif __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_red_alert 
						then
						ball:setAnchorPoint(cc.p(1, 1))
						ball:setPosition(cc.p(params._widget:getContentSize().width-5, params._widget:getContentSize().height-30))
					elseif __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
						ball:setAnchorPoint(cc.p(1, 1))
						ball:setPosition(cc.p(params._widget:getContentSize().width-15, params._widget:getContentSize().height))
					else
						ball:setAnchorPoint(cc.p(0.5, 0.5))
						ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.8, params._widget:getContentSize().height-ball:getContentSize().height*1))
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
	--商店
	local push_notification_center_union_shop_reward_terminal = {
		_name = "push_notification_center_union_shop_reward",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
		_invoke = function(terminal, instance, params)
			if getUnionShopRewardTip() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
						ball:setAnchorPoint(cc.p(0.5, 0.5))
						ball:setPosition(cc.p(params._widget:getContentSize().width - 5, params._widget:getContentSize().height - 5))
					else
						ball:setAnchorPoint(cc.p(0.5, 0.5))
						ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
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
	local push_notification_center_union_shop_time_terminal = {
		_name = "push_notification_center_union_shop_time",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
		_invoke = function(terminal, instance, params)
			if getUnionShopTimeTip() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
						ball:setAnchorPoint(cc.p(0.5, 0.5))
						ball:setPosition(cc.p(params._widget:getContentSize().width - 5, params._widget:getContentSize().height - 5))
					else
						ball:setAnchorPoint(cc.p(0.5, 0.5))
						ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
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

	local push_notification_center_union_check_terminal = {
		_name = "push_notification_center_union_check",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
		_invoke = function(terminal, instance, params)
			if getUnionCheck() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
						ball:setAnchorPoint(cc.p(0, 0))
						ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width+5, params._widget:getContentSize().height-ball:getContentSize().height*0.5-5))						
					else
						ball:setAnchorPoint(cc.p(0.5, 0.5))
						ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
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
	local push_notification_center_union_shop_fashion_terminal = {
		_name = "push_notification_center_union_shop_fashion",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
		_invoke = function(terminal, instance, params)
			if getUnionShopFashion() == true then
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

	local push_notification_center_union_fighting_terminal = {
		_name = "push_notification_center_union_fighting",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
		_invoke = function(terminal, instance, params)
			if getUnionFighting() == true then
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

	local push_notification_center_union_build_terminal = {
		_name = "push_notification_center_union_build",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
		_invoke = function(terminal, instance, params)
			if getUnionBuildTip() == true then
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
	--工会主界面副本按钮推送
	local sm_push_notification_center_union_main_window_duplicate_terminal = {
		_name = "sm_push_notification_center_union_main_window_duplicate",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
		_invoke = function(terminal, instance, params)
			if smUnionPushDuplicate() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
					local scale = params._widget:getScale()
					ball:setScale( 0.8 / scale )
					ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height))
					if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
						ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height+50))
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

	--工会主大厅按钮推送
	local sm_push_notification_center_union_main_window_union_hall_terminal = {
		_name = "sm_push_notification_center_union_main_window_union_hall",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
		_invoke = function(terminal, instance, params)
			if smUnionPushHall() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
					local scale = params._widget:getScale()
					ball:setScale( 0.8 / scale )
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

	--工会主大厅审核按钮推送
	local sm_push_notification_center_union_main_window_union_examine_apply_terminal = {
		_name = "sm_push_notification_center_union_main_window_union_examine_apply",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
		_invoke = function(terminal, instance, params)
			if getUnionCheck() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(0.7, 0.7))
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

	--工会主界面老虎机推送
	local sm_push_notification_center_union_main_window_slot_machine_terminal = {
		_name = "sm_push_notification_center_union_main_window_slot_machine",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
		_invoke = function(terminal, instance, params)
			if smUnionPushSlotMachine() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
					local scale = params._widget:getScale()
					ball:setScale( 0.8 / scale )
					ball:setPosition(cc.p(params._widget:getContentSize().width  - ball:getContentSize().width , params._widget:getContentSize().height - ball:getContentSize().height / 2))
					if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
						ball:setPosition(cc.p(params._widget:getContentSize().width  - ball:getContentSize().width , params._widget:getContentSize().height - ball:getContentSize().height / 2-20))
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

	--工会主界面公会战推送
	local sm_push_notification_center_union_main_window_union_battle_terminal = {
		_name = "sm_push_notification_center_union_main_window_union_battle",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
		_invoke = function(terminal, instance, params)
			if smUnionPushUnionBattle() == true or smUnionPushUnionBattleStake() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
					local scale = params._widget:getScale()
					ball:setScale( 0.8 / scale )
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

	--工会主界面大冒险推送
	local sm_push_notification_center_union_main_window_adventure_terminal = {
		_name = "sm_push_notification_center_union_main_window_adventure",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
		_invoke = function(terminal, instance, params)
			if smUnionPushAdventure() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
					local scale = params._widget:getScale()
					ball:setScale( 0.8 / scale )
					ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height - ball:getContentSize().height / 2))
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

	--工会主界面红包推送
	local sm_push_notification_center_union_main_window_red_envelopes_terminal = {
		_name = "sm_push_notification_center_union_main_window_red_envelopes",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
		_invoke = function(terminal, instance, params)
			if smUnionPushRedEnvelopesAll() == true then
				_ED.union_red_envelopes_open = true
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(0, 0))
					local scale = params._widget:getScale()
					ball:setScale( 0.8 / scale )
					ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height - ball:getContentSize().height))
					params._widget:addChild(ball)
					params._widget._nodeChild = ball
					params._widget._istips = true
				end
			else
				_ED.union_red_envelopes_open = false
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

	--工会系统红包界面推送
	local sm_push_notification_center_union_sys_red_envelopes_snatched_terminal = {
		_name = "sm_push_notification_center_union_sys_red_envelopes_snatched",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
		_invoke = function(terminal, instance, params)
			if smUnionPushRedEnvelopesSystem() == true then
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

	--工会抢红包界面抢红包推送
	local sm_push_notification_center_union_red_envelopes_snatched_terminal = {
		_name = "sm_push_notification_center_union_red_envelopes_snatched",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
		_invoke = function(terminal, instance, params)
			if smUnionPushRedEnvelopes() == true then
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

	--工会主界面研究院推送
	local sm_push_notification_center_union_main_window_research_institute_terminal = {
		_name = "sm_push_notification_center_union_main_window_research_institute",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
		_invoke = function(terminal, instance, params)
			if smUnionPushResearchInstitute() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
					local scale = params._widget:getScale()
					ball:setScale( 0.8 / scale )
					ball:setPosition(cc.p(params._widget:getContentSize().width - ball:getContentSize().width * 1.2, params._widget:getContentSize().height))
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

	--工会主界面能量屋推送
	local sm_push_notification_center_union_main_window_power_house_terminal = {
		_name = "sm_push_notification_center_union_main_window_power_house",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
		_invoke = function(terminal, instance, params)
			if smUnionPushPowerHouse() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
					local scale = params._widget:getScale()
					ball:setScale( 0.8 / scale )
					if __lua_project_id == __lua_project_l_naruto then
						ball:setPosition(cc.p(params._widget:getContentSize().width-50, params._widget:getContentSize().height-120))
					elseif __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
						ball:setPosition(cc.p(params._widget:getContentSize().width-10, params._widget:getContentSize().height-25))
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

	--工会营地按钮推送
	local sm_push_notification_center_union_camping_ground_terminal = {
		_name = "sm_push_notification_center_union_camping_ground",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
		_invoke = function(terminal, instance, params)
			if smUnionPushPowerHouse() == true then
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
	--工会副本挑战按钮推送
	local sm_push_notification_center_union_duplicate_challenge_terminal = {
		_name = "sm_push_notification_center_union_duplicate_challenge",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
		_invoke = function(terminal, instance, params)
			local npc_index = params._datas.npc_index
			if smUnionPushDuplicateChallengeTimes(npc_index) == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(0.7, 0.7))
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

	--工会副本领取按钮推送
	local sm_push_notification_center_union_duplicate_reward_terminal = {
		_name = "sm_push_notification_center_union_duplicate_reward",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
		_invoke = function(terminal, instance, params)
			local npc_index = params._datas.npc_index
			local npc_id = params._datas.npc_id
			if smUnionPushDuplicateReward(npc_index) == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(0.7, 0.7))
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

	--工会副本NPC推送
	local sm_push_notification_center_union_duplicate_npc_status_terminal = {
		_name = "sm_push_notification_center_union_duplicate_npc_status",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
		_invoke = function(terminal, instance, params)
			local npc_index = params._datas.npc_index
			if smUnionPushDuplicateNpcStatus(npc_index) == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(0.7, 0.7))
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

	--工会战下注
	local sm_push_notification_center_union_battle_stake_terminal = {
		_name = "sm_push_notification_center_union_battle_stake",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
		_invoke = function(terminal, instance, params)
			if smUnionPushUnionBattleStake() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(0.7, 0.7))
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

	state_machine.add(push_notification_center_union_all_terminal)
	state_machine.add(push_notification_center_union_shop_reward_terminal)
	state_machine.add(push_notification_center_union_shop_time_terminal)
	state_machine.add(push_notification_center_union_check_terminal)
	state_machine.add(push_notification_center_union_shop_fashion_terminal)
	state_machine.add(push_notification_center_union_fighting_terminal)
	state_machine.add(push_notification_center_union_build_terminal)
	state_machine.add(sm_push_notification_center_union_main_window_duplicate_terminal)
	state_machine.add(sm_push_notification_center_union_main_window_union_examine_apply_terminal)
	state_machine.add(sm_push_notification_center_union_main_window_union_hall_terminal)
	state_machine.add(sm_push_notification_center_union_main_window_slot_machine_terminal)
	state_machine.add(sm_push_notification_center_union_main_window_union_battle_terminal)
	state_machine.add(sm_push_notification_center_union_main_window_adventure_terminal)
	state_machine.add(sm_push_notification_center_union_main_window_red_envelopes_terminal)
	state_machine.add(sm_push_notification_center_union_main_window_research_institute_terminal)
	state_machine.add(sm_push_notification_center_union_main_window_power_house_terminal)
	state_machine.add(sm_push_notification_center_union_duplicate_challenge_terminal)
	state_machine.add(sm_push_notification_center_union_camping_ground_terminal)
	state_machine.add(sm_push_notification_center_union_red_envelopes_snatched_terminal)
	state_machine.add(sm_push_notification_center_union_duplicate_reward_terminal)
	state_machine.add(sm_push_notification_center_union_duplicate_npc_status_terminal)
	state_machine.add(sm_push_notification_center_union_sys_red_envelopes_snatched_terminal)
	state_machine.add(sm_push_notification_center_union_battle_stake_terminal)
    state_machine.init()
end
init_push_notification_center_union_terminal()

function getUnionAllTip()
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		if _ED.union.union_info == nil or _ED.union.union_info == {}  or  _ED.union.union_info.union_id == nil or _ED.union.union_info.union_id == "" then
			return false
		end
		--研究院
		if smUnionPushResearchInstitute() == true then
			return true
		end
		--老虎机
		if smUnionPushSlotMachine() == true then
			return true
		end
		--冰熊大冒险
		if smUnionPushAdventure() == true then
			return true
		end
		--工会红包
		if smUnionPushRedEnvelopesAll() == true then
			return true
		end
		--能量屋
		if smUnionPushPowerHouse() == true then
			return true
		end
		--工会副本推送
		if smUnionPushDuplicate() == true then
			return true
		end
		--工会战推送
		if smUnionPushUnionBattle() == true then
			return true
		end
		--工会战下注推送
		if smUnionPushUnionBattleStake() == true then
			return true
		end
	else
		if getUnionFighting() == true then
			return true
		end
		if _ED.union_push_notification_info ~= nil and _ED.union_push_notification_info ~= "" and _ED.union_push_notification_time ~= nil  then 
			for k,v in pairs(_ED.union_push_notification_info) do
				if v ~= nil then
					
					if k == 1 then
						if zstring.tonumber(v) == 1 then
							return true
						end    
					elseif k == 2 and _ED.union_push_notification_info_limit_refresh ~= nil and _ED.union_push_notification_info_limit_refresh ~= false then
						if zstring.tonumber(v) == 1  then
							return true
						end 
					elseif k == 3 then
						if zstring.tonumber(v) == 1  then
							return true
						end 
					elseif k == 4 then
						if zstring.tonumber(v) == 1  then
							return true
						end 
					elseif k == 5 then
						if _ED.union.user_union_info ~= nil and _ED.union.user_union_info ~= "" then
							if _ED.union.user_union_info.union_post ~= nil and (zstring.tonumber(_ED.union.user_union_info.union_post) == 1 or zstring.tonumber(_ED.union.user_union_info.union_post) == 2) then

								if zstring.tonumber(v) == 1  then
									return true
								end
								if _ED.union.union_examine_list_sum ~= nil and _ED.union.union_examine_list_sum ~= "" then
									if zstring.tonumber(_ED.union.union_examine_list_sum) > 0 then
										return true
									end
								end
							end
						end
					end
				end 
			end
			
		end
	end
	return false
end

function getUnionShopRewardTip()
	if _ED.union_push_notification_info ~= nil and _ED.union_push_notification_info ~= "" and _ED.union_push_notification_time ~= nil  then 
		for k,v in pairs(_ED.union_push_notification_info) do
			if v ~= nil then
				if k == 1 then
					if zstring.tonumber(v) == 1 then
						return true
					end    
				end
			end 
		end
		
	end
	return false
end

function getUnionBuildTip()
	if _ED.union_push_notification_info ~= nil and _ED.union_push_notification_info ~= "" and _ED.union_push_notification_time ~= nil  then 
		for k,v in pairs(_ED.union_push_notification_info) do
			if v ~= nil then
				if k == 1 then
					if zstring.tonumber(v) == 3 then
						return true
					end    
				end
			end 
		end
		
	end
	return false
end

function getUnionShopTimeTip()

	if _ED.union_push_notification_info ~= nil and _ED.union_push_notification_info ~= "" and _ED.union_push_notification_time ~= nil 
		and _ED.union_push_notification_info_limit_refresh ~= nil and _ED.union_push_notification_info_limit_refresh ~= false then 
		for k,v in pairs(_ED.union_push_notification_info) do
			if v ~= nil then
				if k == 2 then
					if zstring.tonumber(v) == 1 then
						return true
					end    
				end
			end 
		end
		
	end
	return false
end

function getUnionCheck( ... )
	if _ED.union_push_notification_info ~= nil and _ED.union_push_notification_info ~= "" and _ED.union_push_notification_time ~= nil  then
		if _ED.union.union_examine_list_sum ~= nil and _ED.union.union_examine_list_sum ~= "" then
			if zstring.tonumber(_ED.union.union_examine_list_sum) > 0 then
				return true
			end
		end
		for k,v in pairs(_ED.union_push_notification_info) do
			if v ~= nil then
				if k == 5 then
					if zstring.tonumber(v) == 1 then
						return true
					end    
				end
			end 
		end
	end
end

function getUnionShopFashion()
	local data = dms2.searchs(dms["union_shop_mould"], union_shop_mould.shop_page, 1)
    local dataCount = table.getn(data)
    if dataCount ~= 0 and data ~= nil and data[1] ~= nil and data[1][1] ~= nil then
        for i,v in pairs(data) do
        	local needlv = dms.atoi(v, union_shop_mould.need_lv)          --所需军团等级 
			local sumdata = zstring.split(_ED.union.union_shop_info.prop.goods_count, ",")  -- 已兑换次数
			local sum = zstring.tonumber(sumdata[dms.atoi(v, union_shop_mould.id)])
			local sellcantimes = dms.atoi(v, union_shop_mould.sell_can_times)          --购买限制次数
			if _ED.union.union_info.union_grade < needlv then
				 -- 等级不足
			else
				if sum >= sellcantimes then
					 -- 次数不足
				else
					return true  -- 可购买
				end
			end

        end
    end
    return false
end

function getUnionFighting( ... )
	if tonumber(_ED.union_fight_state) == 2 and _ED.union_fight_is_join == true then
		return true
	end
	return false
end


--工会副本推送
function smUnionPushDuplicate()
	if funOpenDrawTip(148, false) == true then
		return false
	end
	if _ED.union_pve_info == nil then
		NetworkManager:register(protocol_command.union_copy_init.code, nil, nil, nil, instance, responseCallback, false, nil)
		return false
	end

	for k, v in pairs(_ED.union_pve_info) do
		if smUnionPushDuplicateNpcStatus(v.index) == true then
			return true
		end
	end
	return false
end

--工会副本NPC推送
function smUnionPushDuplicateNpcStatus(index)
	if smUnionPushDuplicateChallengeTimes(index) == true then
		return true
	end
	if smUnionPushDuplicateReward(index) == true then
		return true
	end
	return false
end

function smUnionPushHall( ... )
	if getUnionCheck() then
		return true
	end
	return false
end

--研究院
function smUnionPushResearchInstitute()
	if _ED.union == nil or _ED.union.union_info == nil or _ED.union.union_info.union_grade == nil or dms.int(dms["fun_open_condition"], 142, fun_open_condition.union_level) > tonumber(_ED.union.union_info.union_grade) then
		return false
	end
	local science_info = zstring.split(_ED.union_science_info,"|")
	local hall_technology = zstring.split(science_info[1],",")
	local maxNumber = dms.int(dms["union_config"], 18, union_config.param)
	if maxNumber - tonumber(hall_technology[4]) > 0 then
		return true
	end
	return false
end
--老虎机
function smUnionPushSlotMachine()
	if _ED.union == nil or _ED.union.union_info == nil or _ED.union.union_info.union_grade == nil or dms.int(dms["fun_open_condition"], 143, fun_open_condition.union_level) > tonumber(_ED.union.union_info.union_grade) then
		return false
	end
	local science_info = zstring.split(_ED.union_science_info,"|")
	local hall_technology = zstring.split(science_info[2],",")
	local parameter_group = dms.int(dms["union_science_mould"], 2, union_science_mould.parameter_group)
	local expMould = dms.searchs(dms["union_science_exp"], union_science_exp.group_id, parameter_group)
	local expData = nil
    for i, v in pairs(expMould) do
        if tonumber(hall_technology[1]) == tonumber(v[3]) then
            expData = v
            break
        end
    end
    if tonumber(expData[5])- tonumber(hall_technology[4]) > 0 then
    	return true
    end
	return false
end
--冰熊大冒险
function smUnionPushAdventure()
	if nil == _ED.union or nil == _ED.union.union_info then
		return false
	end
	if _ED.union == nil or _ED.union.union_info == nil or _ED.union.union_info.union_grade == nil or dms.int(dms["fun_open_condition"], 144, fun_open_condition.union_level) > tonumber(_ED.union.union_info.union_grade) then
		return false
	end
	local science_info = zstring.split(_ED.union_science_info,"|")
	local adventure = zstring.split(science_info[4],",")
    local adventure_group = dms.int(dms["union_science_mould"], 4, union_science_mould.parameter_group)
    local adventureMould = dms.searchs(dms["union_science_exp"], union_science_exp.group_id, adventure_group)
    local adventureData = nil
    for i, v in pairs(adventureMould) do
        if tonumber(adventure[1]) == tonumber(v[3]) then
            adventureData = v
            break
        end
    end
    if tonumber(adventureData[5])-tonumber(adventure[4]) > 0 then
    	return true
    end
	return false
end

--工会所有红包推送
function smUnionPushRedEnvelopesAll()
	if smUnionPushRedEnvelopesSystem() == true then
		return true
	end
	if smUnionPushRedEnvelopes() == true then
		return true
	end
	return false
end

--工会系统红包
function smUnionPushRedEnvelopesSystem()
	if _ED.union == nil or _ED.union.union_info == nil or _ED.union.union_info.union_grade == nil or dms.int(dms["fun_open_condition"], 145, fun_open_condition.union_level) > zstring.tonumber(_ED.union.union_info.union_grade) then
		return false
	end
	if _ED.union_red_envelopes_info ~= nil then
		local red_envelopes_info = zstring.split(_ED.union_red_envelopes_info ,"|") 
	    local science_info = zstring.split(_ED.union_science_info,"|")
	    local m_number = 0
	    for i=1, 3 do
	        local red_envelopes_data = zstring.split(red_envelopes_info[i] ,",") 

	        local open_level = dms.int(dms["union_science_mould"], tonumber(5 + i), union_science_mould.open_level)

	        local science_data = zstring.split(science_info[5+i],",")

	        if zstring.tonumber(red_envelopes_data[4]) ~= 0 then

	        	-- 已领取
	        	if tonumber(science_data[4]) > 0 then

	        	-- 未领取
	        	else
	        		-- 如果已经解锁，但未领取则返回true
	        		if open_level <= tonumber(_ED.union.union_info.union_grade) then
	        			return true
	        		end
	        		
	        	end
	        else
	        end
	    end
	    
	else
		-- TODO 减少进入游戏前端向后端请求的次数
		-- local function responseUnionInitCallback(response)
	 --        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
	 --            smPushNotificationCenterUnionSystemHaveRedEnvelopesData = true
	 --        end
	 --    end
	 --    NetworkManager:register(protocol_command.union_init.code, nil, nil, nil, nil, responseUnionInitCallback, false, nil)
	end
    return false 
end
--工会抢红包
function smUnionPushRedEnvelopes()
	if _ED.union == nil or _ED.union.union_info == nil or _ED.union.union_info.union_grade == nil or dms.int(dms["fun_open_condition"], 145, fun_open_condition.union_level) > zstring.tonumber(_ED.union.union_info.union_grade) then
		return false
	end
	if smPushNotificationCenterUnionHaveRedEnvelopesData == true and _ED.union_red_envelopes_can_be_snatched ~= nil then
		-- 剩余次数
	    local count = dms.int(dms["base_consume"], 61, base_consume.vip_0_value + zstring.tonumber(_ED.vip_grade))
	    local science_info = zstring.split(_ED.union_science_info,"|")
	    local datas = zstring.split(science_info[6],",")
	    local leave_count = count-tonumber(datas[6])
	    if leave_count > 0 then
			for i, v in pairs(_ED.union_red_envelopes_can_be_snatched) do
				local haveSnatched = false
				if tonumber(v.remain_number) > 0 then
					for j, k in pairs(_ED.union_red_envelopes_my_info) do
						local datas = zstring.split(k ,",")
						if tonumber(datas[4]) == tonumber(v.times) then
							haveSnatched = true
						end
					end
					if haveSnatched == false then
						return true
					end
				end
			end
		end
	else
		local function responseCallback( response )
	        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
	            smPushNotificationCenterUnionHaveRedEnvelopesData = true
	        end
	    end
		protocol_command.union_red_packet_rap_manager.param_list = "-1"
	    NetworkManager:register(protocol_command.union_red_packet_rap_manager.code, nil, nil, nil, instance, responseCallback, false, nil)
	end
	return false
end
--能量屋
function smUnionPushPowerHouse()
	if _ED.union == nil or _ED.union.union_info == nil or _ED.union.union_info.union_grade == nil or dms.int(dms["fun_open_condition"], 147, fun_open_condition.union_level) > tonumber(_ED.union.union_info.union_grade) then
		return false
	end
	if smPushNotificationCenterUnionHavePowerHourseData == true and _ED.union_personal_energy_info ~= nil then
		if smChechUnionMemberAccelerate() == true then
			local my_data = zstring.split(_ED.union_personal_energy_info,"|")
		    local accelerate = zstring.split(my_data[1],",")
		    local param = zstring.split(dms.string(dms["union_config"], 25, union_config.param) ,",")
		    if tonumber(param[1])-tonumber(accelerate[1]) > 0 then
		    	return true
		    end
		end
	else
	    local function responseCallback(response)
	        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
	           smPushNotificationCenterUnionHavePowerHourseData = true 
	        end
	    end
	    NetworkManager:register(protocol_command.union_ship_train_init.code, nil, nil, nil, instance, responseCallback, false, nil)
	end
	return false
end

-- 是否有公会成员可以加速
function smChechUnionMemberAccelerate()
	if _ED.union_member_energy_info == nil then
		return false
	end

	local param = zstring.split(dms.string(dms["union_config"], 25, union_config.param) ,",")
    for i, v in pairs(_ED.union_member_energy_info) do
        if tonumber(v.member_id) ~= tonumber(_ED.user_info.user_id) then
            local my_data = zstring.split(v.member_data,"|")
            local count_info = zstring.split(my_data[1], ",")
            if tonumber(param[2]) - tonumber(count_info[2]) > 0 then
                local max_level = 0 
                for j, w in pairs(_ED.union.union_member_list_info) do
                    if tonumber(v.member_id) == tonumber(w.id) then
                        max_level = tonumber(w.level)
                        break
                    end
                end
                for j=1, 8 do
                    local shipData = zstring.split(my_data[2+j],",")
                    if tonumber(shipData[3]) ~= 0 then
                    	local ability = dms.int(dms["ship_mould"], shipData[4], ship_mould.ability)
                        local needExp = dms.int(dms["ship_experience_param"], tonumber(shipData[5]) + 1, ability-13+3)
                        if tonumber(shipData[5]) >= max_level and tonumber(shipData[6]) >= tonumber(needExp) then
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

--工会副本挑战次数推送
function smUnionPushDuplicateChallengeTimes(index)
	local npcInfo = _ED.union_pve_info[tonumber(index)]
	if tonumber(npcInfo.status) == 0 then
		local maxBattleNumber = dms.int(dms["union_config"], 21, union_config.param)
		if maxBattleNumber-tonumber(_ED.union.user_union_info.duplicate_battle_count) > 0 then
			return true
		end
	end
	return false
end

--工会副本可领奖推送
function smUnionPushDuplicateReward(index)
	local stateInfo = zstring.split(_ED.union.user_union_info.npc_frist_reward_state, "|")
	local npcInfo = _ED.union_pve_info[tonumber(index)]
    local my_state = -1
    for k,v in pairs(stateInfo) do
        v = zstring.split(v, ":")
        if tonumber(v[1]) == zstring.tonumber(npcInfo.id) then
            my_state = tonumber(v[2])
            break
        end
    end

	if my_state == 0 or my_state == 2 then
        if tonumber(npcInfo.status) == 0 then
            return false
        else
            return true
        end
    elseif my_state == 1 or my_state == 3 then
        return false
    end
	return false
end

--工会战推送
function smUnionPushUnionBattle()
	if _ED.union.union_info == nil 
        or _ED.union.union_info == {} 
        or _ED.union.union_info.union_id == nil 
        or _ED.union.union_info.union_id == "" 
        or tonumber(_ED.union.union_info.union_id) == 0 
        then
        return false
    end
    if funOpenDrawTip(82, false) == true then
        return false
    end
    local server_time = _ED.system_time + (os.time() - _ED.native_time) - _ED.GTM_Time
    if _ED.union ~= nil 
        and _ED.union.user_union_info ~= nil 
        and _ED.union.user_union_info.union_last_enter_time ~= nil 
        and _ED.union.user_union_info.union_last_enter_time - server_time > 0 then
        return false
    end
    if _ED.union.union_fight_battle_info == nil then
    	return false
    end
    if (tonumber(_ED.union.union_fight_battle_info.state) == 0 
        or tonumber(_ED.union.union_fight_battle_info.state) == 5) 
    	then
    	return false
    end
    if _ED.union.union_fight_user_info == nil or tonumber(_ED.union.union_fight_user_info.join_state) ~= 0 then
    	return false
    end
	return true
end

function smUnionPushUnionBattleStake()
	if smUnionPushUnionBattle() == false then
		return false
	end
	if _ED.union ~= nil 
		and _ED.union.union_fight_battle_info ~= nil 
		and _ED.union.union_fight_user_info ~= nil 
		then
		if tonumber(_ED.union.union_fight_battle_info.battle_times) == 5 
	        and (tonumber(_ED.union.union_fight_battle_info.state) == 1 
	        or tonumber(_ED.union.union_fight_battle_info.state) == 2) 
	        then
	        if _ED.union.union_fight_user_info.bet_info == "0,0" then
	        	return true
	        end
	    end
	end
	return false
end