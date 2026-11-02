-- Initialize push notification center state machine.
push_notification_on_card = nil
cc.Director:getInstance():getTextureCache():addImage("images/ui/bar/tuishong.png")
local function init_push_notification_home_button_terminal()
	--首页活动按钮的推送(邮件)
    local push_notification_home_button_mail_terminal = {
        _name = "push_notification_home_button_mail",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if _ED.mail_system_have_new == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tuishong.png")
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

	--首页活动按钮的推送(活动)
    local push_notification_home_button_activity_terminal = {
        _name = "push_notification_home_button_activity",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getActivityAllTip() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tuishong.png")
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
			if getNewActivityTip() == true then
				if params._widget._istipsUP == nil or params._widget._istipsUP == false then
					local ball = cc.Sprite:create("images/ui/wonderful/wonderful_xin.png")
					ball:setAnchorPoint(cc.p(0.5, 0.5))
					ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width/0.8, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
					params._widget:addChild(ball)
					params._widget._nodeChildUP = ball
					params._widget._istipsUP = true
				end
			else
				if params._widget._istipsUP == true then
					params._widget:removeChild(params._widget._nodeChildUP, true)
					params._widget._nodeChildUP = nil
					params._widget._istipsUP = false
				end
			end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    -- 开服狂欢
    local push_notification_home_button_open_activity_terminal = {
        _name = "push_notification_home_button_open_activity",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getOpenActivityTip() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tuishong.png")
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

    --首页活动按钮的推送(签到)
    local push_notification_home_button_sign_in_terminal = {
        _name = "push_notification_home_button_sign_in",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getSignInTip() == true and pushNotificationSignIn() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tuishong.png")
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

    --登录送
    local push_notification_home_button_activity_seven_day_terminal = {
        _name = "push_notification_home_button_activity_seven_day",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getActivitySevenDayTips() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tuishong.png")
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

    --首冲
    local push_notification_home_button_activity_frsit_recharge_terminal = {
        _name = "push_notification_home_button_activity_frsit_recharge",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getActivityFrsitRechargeTips() == true or _ED._push_top_up == 1 then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tuishong.png")
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

    --大转盘
    local push_notification_home_button_activity_cost_rotary_terminal = {
        _name = "push_notification_home_button_activity_cost_rotary",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getActivityCostRaotaryTips() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tuishong.png")
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

    --充值
    local push_notification_home_button_activity_top_up_terminal = {
        _name = "push_notification_home_button_activity_top_up",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			-- if pushNotificationVIP() == true or getActivityVipPrivilegeTips() == true then
			if getActivityVipPrivilegeTips() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tuishong.png")
					ball:setAnchorPoint(cc.p(0.5, 0.5))
					ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.3, params._widget:getContentSize().height-ball:getContentSize().height*0.3))
					params._widget:addChild(ball,1000)
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

    --VIP
    local push_notification_home_button_activity_VIP_terminal = {
        _name = "push_notification_home_button_activity_VIP",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			-- if pushNotificationVIP() == true or getActivityVipPrivilegeTips() == true then
			if getActivityVipPrivilegeTips() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tuishong.png")
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
    
    -- 开服冲Top
    local push_notification_home_button_server_top_rank_terminal = {
        _name = "push_notification_home_button_server_top_rank",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if pushNotificationServerTopRank() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tuishong.png")
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

    -- 月卡(金卡)
    local push_notification_activity_on_card_gold_terminal = {
        _name = "push_notification_activity_on_card_gold",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getOnCardGoldTip() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tuishong.png")
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

    -- 月卡(钻卡)
    local push_notification_activity_on_card_jewel_terminal = {
        _name = "push_notification_activity_on_card_jewel",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getOnCardJewelTip() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tuishong.png")
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

    -- 攻略推送
    local push_notification_home_button_strategy_terminal = {
        _name = "push_notification_home_button_strategy",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getStrategyTips() == true  then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tuishong.png")
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

    -- 元宝大转盘
    local push_notification_home_button_activity_cost_rotary_all_terminal = {
        _name = "push_notification_home_button_activity_cost_rotary_all",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getActivityCostRaotaryAllTips() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tuishong.png")
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

    -- 冲级奖励(特殊渠道)
    local push_notification_home_button_activity_up_level_two_terminal = {
        _name = "push_notification_home_button_activity_up_level_two",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getUpLevelTwoTips() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tuishong.png")
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

    state_machine.add(push_notification_home_button_mail_terminal)
    state_machine.add(push_notification_home_button_activity_terminal)
    state_machine.add(push_notification_home_button_sign_in_terminal)
    state_machine.add(push_notification_home_button_activity_seven_day_terminal)
    state_machine.add(push_notification_home_button_activity_frsit_recharge_terminal)
    state_machine.add(push_notification_home_button_activity_cost_rotary_terminal)
    state_machine.add(push_notification_home_button_activity_top_up_terminal)
    state_machine.add(push_notification_home_button_activity_VIP_terminal)
    state_machine.add(push_notification_home_button_server_top_rank_terminal)
    state_machine.add(push_notification_activity_on_card_gold_terminal)
    state_machine.add(push_notification_activity_on_card_jewel_terminal)
    state_machine.add(push_notification_home_button_open_activity_terminal)
    state_machine.add(push_notification_home_button_activity_fourteen_days_terminal)
    state_machine.add(push_notification_home_button_strategy_terminal)
    state_machine.add(push_notification_home_button_activity_cost_rotary_all_terminal)
    state_machine.add(push_notification_home_button_activity_up_level_two_terminal)
    state_machine.init()
end
init_push_notification_home_button_terminal()

--活动
function getActivityAllTip()
	if _ED.activity_info == nil then 
		return false
	end
	if funOpenDrawTip(56,false) == true then  
		return false
	end
	-- 月卡推送
	if push_notification_on_card == nil then 
		push_notification_on_card = dms.searchs(dms["top_up_goods"], top_up_goods.goods_type, 1)
	end
	if _ED.month_card ~= nil and _ED.month_card ~= "" and _ED.month_card[push_notification_on_card[1][1]] ~= nil and _ED.month_card[push_notification_on_card[1][1]] ~= "" then
		if zstring.tonumber(_ED.month_card[push_notification_on_card[1][1]].surplus_month_card_time) > 0 then 
			if zstring.tonumber(_ED.month_card[push_notification_on_card[1][1]].draw_month_card_state) == 0 then 
				return true
			end
		end
	end
	if _ED.month_card ~= nil and _ED.month_card ~= "" and _ED.month_card[push_notification_on_card[2][1]] ~= nil and _ED.month_card[push_notification_on_card[2][1]] ~= "" then
		if zstring.tonumber(_ED.month_card[push_notification_on_card[2][1]].surplus_month_card_time) > 0 then 
			if zstring.tonumber(_ED.month_card[push_notification_on_card[2][1]].draw_month_card_state) == 0 then 
				return true
			end
		end
	end

	for i,activity_info in pairs(_ED.activity_info) do
		local index = tonumber(i)
		if index == 5 then -- 元宝大放送
			local now_day = tonumber(_ED.activity_info["5"].activity_add_state) + 1
			for i, activity_data in pairs(_ED.activity_info["5"].activity_data[now_day]) do
			 	if tonumber(activity_data.achieve_state) == 1 then
					return true
				end
			end
		elseif index == 9 or index == 24 or index == 25 then --VIP2,3,4基金
	        local activity_type = _ED.activity_info[""..i].activity_data
	        for j,k in pairs(activity_type[1]) do
	            if tonumber(k.achieve_state) == 2 then
	                for i,v in pairs(activity_type) do
	                    for m,activity_data in pairs(v) do
	                        if tonumber(activity_data.achieve_state) == 1 then
	                            return true
	                        end
	                    end
	                end 
	            end
	        end
	        
        elseif index == 15 then 	--签到
        	local activity_add_state = zstring.split(_ED.activity_info["15"].activity_add_state,",")
			if nil ~= activity_add_state 
				and #activity_add_state > 1 
				and tonumber(activity_add_state[1]) < tonumber(activity_add_state[2]) 
				then
				return true
			end
		elseif index == 17 then 	-- 超值兑换
			local activity_type = _ED.activity_info["17"].activity_data[1]
			local counts = 0
			for i,v in pairs(activity_type) do
				local complete_count = zstring.split(v.achieve_complete_count, "/")
				if tonumber(complete_count[1]) == 0 then
					counts = counts + 1
				end
			end
			if counts ~= #activity_type then
				return true
			end
        elseif index == 21 then          -- 三签
        	local infos = zstring.split(_ED.activity_info["21"].activity_add_state, "|")
			local server_time = _ED.system_time + (os.time() - _ED.native_time)

			if tonumber(infos[5]) == 2 then
				return false
			end

			if tonumber(infos[5]) < 0 
				or (tonumber(infos[5]) ~= 1 and server_time >= tonumber(infos[6]))
				or (tonumber(infos[5]) ~= 2 and server_time >= tonumber(infos[6])) then 
				return true
			end
		elseif index == 41 then   -- 单笔充值2
        local activity_add_state = zstring.split(_ED.activity_info[""..index].activity_add_state,",")
        for i,v in pairs(_ED.activity_info[""..index].activity_data) do
            for m,activity_data in pairs(v) do
                local achieve_complete_count = zstring.split(activity_data.achieve_complete_count,"/")
                if tonumber(achieve_complete_count[1]) > tonumber(activity_add_state[activity_data.achieve_index]) then
                    return true
                end
            end
        end
		elseif index == 2 then          -- 首冲
		elseif index == 3 then          -- 战力达成
        elseif index == 4 then          -- 闯关奖励
        elseif index == 6 then          -- 冲级奖励
        elseif index == 7 then          -- 七天乐
        elseif index == 12 then         -- 累积充值
        elseif index == 18 then         -- VIP礼包
        elseif index == 19 then         -- 98五倍返
        elseif index == 22 then         -- 积分转盘
        elseif index == 23 then         -- 开服冲Top
        elseif index == 26 then         -- 侠客行
        elseif index == 27 then         -- 十四天活动
        elseif index == 28 then         -- 华山论剑
        elseif index == 29 then         -- 装备强化
        elseif index == 30 then         -- 侠客培养
        elseif index == 32 then         -- 今日充值福利
        elseif index == 37 then         -- 元宝大转盘
    	elseif index == 40 then         -- 开服冲Top(2号)
    	elseif index == 42 then         -- 全服积分大转盘
        elseif index == 38 then         -- 十连抽送碎片
		    local propRecruitCount_ten = 0 
		    if fundPropWidthId(258) ~= nil then 
		        local token = fundPropWidthId(258)	-- 十连书
		        propRecruitCount_ten = token.prop_number
		    end
			if tonumber(propRecruitCount_ten) > 0 or _ED.send_pieces_activity_tip == 1 then
				return true
			end
		elseif index == 39 then         -- 冲级奖励(特殊渠道)
			local page = tonumber(zstring.split(activity_info.activity_add_state, ",")[1]) + 1
			for i,activity_data in pairs(activity_info.activity_data[page]) do
		        if tonumber(activity_data.achieve_state) == 1 then
		            return true
		        end
		    end
		else
			for j,k in pairs(activity_info.activity_data) do
				for m,activity_data in pairs(k) do
					if tonumber(activity_data.achieve_state) == 1 then
						return true
					end
				end
			end
		end
	end
	return false
end

-- 开服活动
function getOpenActivityTip()
	if _ED.activity_info == nil then 
		return false
	end
	if funOpenDrawTip(137,false) == true then  
		return false
	end
	for i,activity_info in pairs(_ED.activity_info) do
		local index = zstring.tonumber(i)
        if index == 2 then
        elseif index == 5 then          -- 元宝大放送
        elseif index == 8 then          -- 名将招募
        elseif index == 9 then          -- 成长计划VIP2
        elseif index == 11 then         -- 活跃奖励
        elseif index == 13 then         -- 单笔充值
        elseif index == 14 then         -- 邀请好友
        elseif index == 15 then         -- 签到
        elseif index == 16 then         -- cdkey
        elseif index == 17 then         -- 杂货铺
        elseif index == 20 then         -- 累积消费
        elseif index == 24 then         --成长计划VIP3
        elseif index == 25 then         --成长计划VIP4
        elseif index == 18 then         -- VIP礼包
        elseif index == 21 then         -- 每日三签
        elseif index == 22 then         -- 积分转盘
        elseif index == 23 then         -- 开服冲Top
        elseif index == 31 then         -- 累积充值(常驻活动)
        elseif index == 33 then         -- 豪华签到
        elseif index == 34 then         -- 特惠礼包
        elseif index == 35 then         -- 特惠礼包
        elseif index == 36 then         -- 每月充值福利
        elseif index == 37 then         -- 元宝大转盘
        elseif index == 38 then         -- 十连抽送碎片
        elseif index == 39 then			-- 渠道定制活动
        elseif index == 40 then         -- 开服冲Top(2号)
        elseif index == 41 then         -- 单笔充值	
        elseif index == 42 then         -- 全服积分大转盘
        elseif index == 43 then         -- 登陆送
        elseif index == 19 then         -- 98五倍
        	return true
		else
			for j,k in pairs(activity_info.activity_data) do
				for m,activity_data in pairs(k) do
					if zstring.tonumber(activity_data.achieve_state) == 1 then
						return true
					end
				end
			end
		end
	end
	return false
end

-- 签到
function getSignInTip()
	if _ED.activity_info == nil then
		return false
	end
	local sign_activity = _ED.activity_info["15"]
	if sign_activity == nil then 
		return false
	end
	local activity_add_state = zstring.split(sign_activity.activity_add_state,",")
	if nil ~= activity_add_state 
		and #activity_add_state > 1 
		and zstring.tonumber(activity_add_state[1]) < zstring.tonumber(activity_add_state[2]) 
		then
		return true
	end

	return false
end

--登录送
function getActivitySevenDayTips()
	if _ED.activity_info == nil then
		return false
	end
	local activity = _ED.activity_info["7"]
	if activity == nil then 
		return false
	end
	local now_day_index = zstring.tonumber(zstring.split(activity.activity_add_state, ",")[1])
	now_day_index = math.max(1,now_day_index)
	now_day_index = math.min(7,now_day_index)
    local state = activity.activity_data[now_day_index][1].achieve_state

    if now_day_index == 1 then
    elseif now_day_index == 2 then
        if zstring.tonumber(state) ~= 2 then
            return true
        end
    elseif now_day_index == 3 then
        if zstring.tonumber(state) ~= 2 
        	or zstring.tonumber(activity.activity_data[2][1].achieve_state) ~= 2 then
            return true
        end
    elseif now_day_index == 4 then
        if zstring.tonumber(activity.activity_data[2][1].achieve_state) ~= 2 
        	or zstring.tonumber(activity.activity_data[3][1].achieve_state) ~= 2
        	then
            return true
        end
    elseif now_day_index == 5 then
        if zstring.tonumber(state) ~= 2 
        	or zstring.tonumber(activity.activity_data[2][1].achieve_state) ~= 2 
        	or zstring.tonumber(activity.activity_data[3][1].achieve_state) ~= 2
        	then
            return true
        end
    elseif now_day_index == 6 then
        if zstring.tonumber(activity.activity_data[2][1].achieve_state) ~= 2
        	or zstring.tonumber(activity.activity_data[3][1].achieve_state) ~= 2 
        	or zstring.tonumber(activity.activity_data[5][1].achieve_state) ~= 2
        	then
            return true
        end
    elseif now_day_index == 7 then
        if zstring.tonumber(state) ~= 2
        	or zstring.tonumber(activity.activity_data[2][1].achieve_state) ~= 2
        	or zstring.tonumber(activity.activity_data[3][1].achieve_state) ~= 2 
        	or zstring.tonumber(activity.activity_data[5][1].achieve_state) ~= 2
        	then
            return true
        end
    end
	return false
end

--首冲
function getActivityFrsitRechargeTips()
	if _ED.activity_info == nil then
		return false
	end
	local activity = _ED.activity_info["2"]
	if activity == nil then 
		return false
	end
	if zstring.tonumber(activity.activity_data[1][1].achieve_state) == 1 
		or zstring.tonumber(activity.activity_data[1][2].achieve_state) == 1 
		or zstring.tonumber(activity.activity_data[1][3].achieve_state) == 1 then
		return true
	end

	return false
end

--大转盘
function getActivityCostRaotaryTips()
	if _ED.activity_info == nil then
		return false
	end
	local activity = _ED.activity_info["22"]
	if activity == nil then
		return false
	end
	local infos = zstring.split(activity.activity_add_state, ",")
    if zstring.tonumber(infos[1]) >= zstring.tonumber(infos[3]) then
    	return true
    end
    for k,v in pairs(activity.activity_data[2]) do
    	if zstring.tonumber(v.achieve_state) == 1 then
    		return true
    	end
    end
	return false
end

--VIP
function getActivityVipPrivilegeTips()
	for index = 1,12 do
		if tonumber(index) <= tonumber(_ED.vip_grade) then
	        for i=1,index do
	            local items = _ED.all_shop_info["2"]
	            local item = items[i]
	            if item ~= nil then 
		            local openInfos = zstring.split(item.open_info, ",")
		            if tonumber(_ED.vip_grade) >= tonumber(openInfos[2]) then
		                if tonumber(item.remain_times) ~= 0 then
		                    return true
		                end
		            end
		        end
	        end
	    end
	end
	return false
end

-- 新活动
function getNewActivityTip()
	if _ED.activity_info == nil then 
		return false
	end
	if funOpenDrawTip(56,false) == true then  
		return false
	end
	for i, activity in pairs(_ED.activity_info) do
		if activity._new_activity == true then
			return true
		end
	end
	return false
end

-- 月卡(金卡)
function getOnCardGoldTip()
	if funOpenDrawTip(56,false) == true then  
		return false
	end
	if _ED.month_card ~= nil and _ED.month_card ~= "" and _ED.month_card[push_notification_on_card[1][1]] ~= nil and _ED.month_card[push_notification_on_card[1][1]] ~= "" then
		if zstring.tonumber(_ED.month_card[push_notification_on_card[1][1]].surplus_month_card_time) > 0 then 
			if zstring.tonumber(_ED.month_card[push_notification_on_card[1][1]].draw_month_card_state) == 0 then 
				return true
			end
		end
	end
	return false
end

-- 月卡(钻卡)
function getOnCardJewelTip()
	if funOpenDrawTip(56,false) == true then  
		return false
	end
	if _ED.month_card ~= nil and _ED.month_card ~= "" and _ED.month_card[push_notification_on_card[2][1]] ~= nil and _ED.month_card[push_notification_on_card[2][1]] ~= "" then
		if zstring.tonumber(_ED.month_card[push_notification_on_card[2][1]].surplus_month_card_time) > 0 then 
			if zstring.tonumber(_ED.month_card[push_notification_on_card[2][1]].draw_month_card_state) == 0 then 
				return true
			end
		end
	end
	return false
end

--元宝大转盘
function getActivityCostRaotaryAllTips()
	if _ED.activity_info == nil then
		return false
	end
	local activity = _ED.activity_info["37"]
	if activity == nil then
		return false
	end
	if _ED.gold_rotary_tip == 1 then
    	return true
    end
    for k,v in pairs(activity.activity_data[2]) do
    	if tonumber(v.achieve_state) == 1 then
    		return true
    	end
    end
	return false
end

--冲级奖励(特殊渠道)
function getUpLevelTwoTips()
	if _ED.activity_info == nil then
		return false
	end
	local activity = _ED.activity_info["39"]
	if activity == nil then
		return false
	end
	local page = tonumber(zstring.split(activity.activity_add_state, ",")[1]) + 1
	for i,activity_data in pairs(activity.activity_data[page]) do
        if tonumber(activity_data.achieve_state) == 1 then
            return true
        end
    end
	return false
end

-- 攻略推送
function getStrategyTips()
	if tonumber(_ED.user_info.user_grade) >= 6 and tonumber(_ED.user_info.user_grade) <= 40 then
		if pushNotificationStrategy() == true then
			return true
		end
	end
	return false
end