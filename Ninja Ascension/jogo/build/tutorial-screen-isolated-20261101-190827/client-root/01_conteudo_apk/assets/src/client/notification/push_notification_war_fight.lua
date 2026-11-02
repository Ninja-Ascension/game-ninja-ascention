-- Initialize push notification center state machine.
local function init_push_notification_war_fight_terminal()

	local push_notification_war_fight_of_task_terminal = {
		_name = "push_notification_war_fight_of_task",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
		_invoke = function(terminal, instance, params)
			if getWarTaskState() == true then
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

	local push_notification_war_fight_of_decree_terminal = {
		_name = "push_notification_war_fight_of_decree",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
		_invoke = function(terminal, instance, params)
			if getWarDecreeState() == true then
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

	local push_notification_war_fight_of_reward_terminal = {
		_name = "push_notification_war_fight_of_reward",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
		_invoke = function(terminal, instance, params)
			if getWarRewardState() == true then
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
	state_machine.add(push_notification_war_fight_of_task_terminal)	
	state_machine.add(push_notification_war_fight_of_decree_terminal)
	state_machine.add(push_notification_war_fight_of_reward_terminal)	
    state_machine.init()
end
init_push_notification_war_fight_terminal()

function getWarTaskState()
	if (_ED.war_task_info == nil or _ED.war_task_info == {}) then
		return false
	else
		-- 检查国战任务（领取）
		if (_ED.war_task_info.country ~= nil and _ED.war_task_info.country ~= {})then
			for i,v in pairs(_ED.war_task_info.country) do
				if tonumber(v.task_state) == 1 then
					return true
				end
			end
		end
		-- 检查个人任务（领取）
		if (_ED.war_task_info.user ~= nil and _ED.war_task_info.user ~= {}) then
			for i,v in pairs(_ED.war_task_info.user) do
				if tonumber(v.task_state) == 1 then
					return true
				end
			end
		end
		return false
	end
end

function getWarDecreeState()
	if (_ED.war_decree_time == nil or _ED.war_decree_time == {}) then
		return false
	else
		for i,v in pairs(_ED.war_decree_time) do
			if tonumber(v.country_leave_time) > 0 then
				return true
			end
		end
		return false
	end
end

function getWarRewardState()
	if (_ED.user_war_get_reward_state == nil or _ED.user_war_get_reward_state == {}) then
		return false
	else
		if tonumber(_ED.user_war_get_reward_state) == 0 then
			return true
		else
			return false
		end
	end
end