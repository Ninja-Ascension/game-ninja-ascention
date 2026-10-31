-- Initialize push notification center state machine.
local function init_push_notification_center_home_expand_terminal()
	--首页更多按钮的推送
    local push_notification_center_home_expand_terminal = {
        _name = "push_notification_center_home_expand",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getHomeExpandCenterAllTips(params) == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")

					
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then 
						ball:setAnchorPoint(cc.p(1, 1))
						ball:setPosition(cc.p(params._widget:getContentSize().width+10, params._widget:getContentSize().height))
					else
						ball:setAnchorPoint(cc.p(1, 1))
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
	
    state_machine.add(push_notification_center_home_expand_terminal)
    state_machine.init()
end
init_push_notification_center_home_expand_terminal()

function getHomeExpandCenterAllTips(notificationer)
	if getNoReadMallCount(notificationer) > 0 then
		return true
	end
	
	if getFriendCenterAllTips(notificationer) == true then
		return true
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		--龙虎门更多里面不推送世界或者私聊消息
	else
		if getNoReadAllChatCount() == true then
			return true
		end
	end
	return false
end