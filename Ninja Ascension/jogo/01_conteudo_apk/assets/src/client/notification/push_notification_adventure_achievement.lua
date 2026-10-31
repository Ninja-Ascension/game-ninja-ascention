-- Initialize push notification center state machine.
local function init_push_notification_adventure_achievement_terminal()
	-- 成就
    local push_notification_center_adventure_achievement_terminal = {
        _name = "push_notification_adventure_achievement_update",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if isAchievement() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/icon/bg_reward_tag.png")
					ball:setAnchorPoint(cc.p(1, 1))
					ball:setPosition(cc.p(params._widget:getContentSize().width , params._widget:getContentSize().height))
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

    state_machine.add(push_notification_center_adventure_achievement_terminal)	
    state_machine.init()
end
init_push_notification_adventure_achievement_terminal()

function isAchievement()
	local isReceive = false
	  for i, v in pairs(_ED.daily_task_achievement) do  
		if(tonumber(v.daily_task_param) == 1) then
			isReceive = true
			break
		else
		end
       end

	return isReceive
end
