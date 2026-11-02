-- Initialize push notification center state machine.
local function init_push_notification_center_capture_terminal()
	--首页占领按钮的推送
    local push_notification_center_capture_terminal = {
        _name = "push_notification_center_capture",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
        	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        	else
				if getCaptureTips() == true then
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
			end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    local push_notification_center_learing_terminal = {
        _name = "push_notification_center_learing",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getLearingTip() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
					ball:setPosition(cc.p(params._widget:getContentSize().width+10, params._widget:getContentSize().height+5))
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

    local push_notification_center_capture_get_reward_terminal = {
        _name = "push_notification_center_capture_get_reward",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getCaptureReward() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
					ball:setPosition(cc.p(params._widget:getContentSize().width+10, params._widget:getContentSize().height+5))
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
    state_machine.add(push_notification_center_capture_terminal)
    state_machine.add(push_notification_center_learing_terminal)
    state_machine.add(push_notification_center_capture_get_reward_terminal)
    state_machine.init()
end
init_push_notification_center_capture_terminal()

function getCaptureTips()
	if _ED.capture_push_info == true then
		return true
	end

	if getCaptureCanAttack() == true then
		return true
	end

	if getCaptureReward() == true then
		return true
	end

	return false

end

function getCaptureCanAttack( ... )
	local currentCount = nil
	if _ED.captureResourceInfo ~= nil then
        currentCount = table.nums(_ED.captureResourceInfo)
    end
    -- print("=================",currentCount,_ED.open_resource_bulid_max_count)
    if currentCount < tonumber(_ED.open_resource_bulid_max_count) then
		return true
	end

	return false
end

function getCaptureReward( ... )
	if _ED.capture.rank_reward_state == "" or _ED.capture.rank_reward_state == nil then
        local function responseCallbackScore(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then

            end
        end
        NetworkManager:register(protocol_command.hold_integral_init.code, nil, nil, nil, nil, responseCallbackScore, false, nil)
        return false
	end

	if  tonumber(_ED.capture.rank_reward_state) == 0 and zstring.tonumber(_ED.capture.last_my_score) ~= 0 then
		return true
	end

	return false

end
--学艺有免费次数给推送
function getLearingTip( ... )
	if _ED.free_learn_skill_count == nil then
		return false
	end

	if tonumber(_ED.free_learn_skill_count) > 0 then
		return true
	end
end