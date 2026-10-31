-- Initialize push notification center state machine.
local function init_push_notification_home_select_terminal()
	--任务的推送(主线)
    local push_notification_task_to_main_terminal = {
        _name = "push_notification_task_to_main",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getTaskToMainTip() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tuishong.png")
					ball:setAnchorPoint(cc.p(0.5, 0.5))
					ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.2, params._widget:getContentSize().height-ball:getContentSize().height*0.2))
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

	--任务的推送(日常)
        local push_notification_task_to_dialy_terminal = {
        _name = "push_notification_task_to_dialy",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getTaskToDialyTip() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tuishong.png")
					ball:setAnchorPoint(cc.p(0.5, 0.5))
					ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.2, params._widget:getContentSize().height-ball:getContentSize().height*0.2))
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

	--任务的推送(成就)
    local push_notification_task_to_achievement_terminal = {
        _name = "push_notification_task_to_achievement",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getTaskToAchievementTip() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tuishong.png")
					ball:setAnchorPoint(cc.p(0.5, 0.5))
					ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.2, params._widget:getContentSize().height-ball:getContentSize().height*0.2))
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

    state_machine.add(push_notification_task_to_main_terminal)
    state_machine.add(push_notification_task_to_dialy_terminal)
    state_machine.add(push_notification_task_to_achievement_terminal)
    state_machine.init()
end
init_push_notification_home_select_terminal()

--主线
function getTaskToMainTip()
    if _ED.user_task_infos == nil or _ED.user_task_infos["0"] == nil then
        return false
    end
    for i,v in pairs(_ED.user_task_infos["0"]) do
        if zstring.tonumber(v.task_complete_count) >= zstring.tonumber(v.need_complete_count) then
            return true
        end
    end
    return false
end

--日常
function getTaskToDialyTip()
    if _ED.user_task_infos == nil or _ED.user_task_infos["1"] == nil then
        return false
    end
	for i,v in pairs(_ED.user_task_infos["1"]) do
        if zstring.tonumber(v.task_complete_count) >= zstring.tonumber(v.need_complete_count) then
            return true
        end
    end
    return false
end
    
--成就
function getTaskToAchievementTip()
    if _ED.user_task_infos == nil or _ED.user_task_infos["2"] == nil then
        return false
    end
    for i,v in pairs(_ED.user_task_infos["2"]) do
        if tonumber(v.achievement_finish_type) == 28 then
            if zstring.tonumber(v.task_complete_count) <= zstring.tonumber(v.need_complete_count) then
                return true
            end
        else
            if zstring.tonumber(v.task_complete_count) >= zstring.tonumber(v.need_complete_count) then
                return true
            end
        end
    end
    return false
end


