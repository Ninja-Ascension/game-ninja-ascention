-- Initialize push notification center state machine.
local function init_push_notification_center_every_day_sign_terminal()
	--首页签到按钮的推送
    local push_notification_center_every_day_sign_all_terminal = {
        _name = "push_notification_center_every_day_sign_all",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getEveryDaySignCenterAllTips(params) == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 0.7))
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
	
    state_machine.add(push_notification_center_every_day_sign_all_terminal)
    state_machine.init()
end
init_push_notification_center_every_day_sign_terminal()

function getEveryDaySignCenterAllTips(notificationer)
	if _ED.active_activity ~= nil and _ED.active_activity[38] ~= nil then
		local currday = tonumber(_ED.active_activity[38].activity_login_day)
		for i ,v in pairs(_ED.active_activity[38].activity_Info) do 
			if tonumber(v.activityInfo_need_day) == currday then
				if tonumber(v.activityInfo_isReward) then
					if tonumber(v.activityInfo_isReward) == 0 
						or (tonumber(v.activityInfo_isReward) == 2 and tonumber(_ED.vip_grade) >= tonumber(v.activityInfo_need_vip))
						then
						return true
					end
				end
			end
		end
	end
	local activity = _ED.active_activity[38]
    local days_info = zstring.split(activity.activity_day_infos, ",")
    local receiveNumber = tonumber(days_info[1])
    local needNumber = tonumber(days_info[2])
	if receiveNumber >= needNumber then
    	return true
    end
	return false
end
