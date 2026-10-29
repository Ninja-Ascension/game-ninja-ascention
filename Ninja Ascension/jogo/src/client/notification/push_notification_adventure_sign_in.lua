-- Initialize push notification center state machine.
local function init_push_notification_adventure_sign_in_terminal()
	-- 签到
    local push_notification_center_adventure_sign_in_terminal = {
        _name = "push_notification_adventure_sign_in",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getIsSign_in() == true then
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

    state_machine.add(push_notification_center_adventure_sign_in_terminal)	
    state_machine.init()
end
init_push_notification_adventure_sign_in_terminal()

function getIsSign_in()

 local hour = tonumber(os.date("%H"))

    local activity_Info = _ED.active_activity[38].activity_Info[1]            -- 取当天数据
    local signStatus = zstring.split(activity_Info.activityInfo_isReward, ",")

    if hour >= 0 and hour < 12 then
        if tonumber(signStatus[1]) == 0 then
            return true
        else
            return false
        end
    elseif hour >= 12 and hour < 18 then
        if tonumber(signStatus[2]) == 0 then
            return true
        else
            return false
        end
    elseif hour >= 18 and hour < 24 then
        if tonumber(signStatus[3]) == 0 then
            return true
        else
            return false
        end
    end
	return false
end
