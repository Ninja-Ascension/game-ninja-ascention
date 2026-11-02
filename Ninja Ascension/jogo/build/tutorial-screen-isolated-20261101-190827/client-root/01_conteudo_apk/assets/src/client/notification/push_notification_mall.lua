-- Initialize push notification center state machine.

pushNotificationResouceCount = false
pushNotificationCenterMallHaveDate = false
pushNotificationUnreadEmailCount = 0
local function init_push_notification_center_mall_terminal()
	--首页邮件按钮的推送
    local push_notification_center_mall_all_terminal = {
        _name = "push_notification_center_mall_all",
        _init = function (terminal)
			
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			local unreadEMailCount = getNoReadMallCount(params)
            local isChange = true
            -- if unreadEMailCount ~= pushNotificationUnreadEmailCount then
            --     isChange = true
            -- end
            if unreadEMailCount > 0 then
                if isChange == true then
                    if params._widget._istips == true then
                        params._widget:removeChild(params._widget._nodeChild, true)
                        params._widget._nodeChild = nil
                        params._widget._istips = false
                    end
                end

                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = NotificationTipCell:createCell()
                    ball:init(unreadEMailCount)
                    params._widget:addChild(ball)
                    local ball_width = ccui.Helper:seekWidgetByName(ball.roots[1], "Image_1"):getContentSize().width
                    local ball_height = ccui.Helper:seekWidgetByName(ball.roots[1], "Image_1"):getContentSize().height
                    ball:setPosition(cc.p(params._widget:getContentSize().width - ball_width/2, params._widget:getContentSize().height - ball_height/2))
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
		--首页被占领的闪亮推送
    local push_notification_center_capture_shine_terminal = {
        _name = "push_notification_center_capture_shine",
        _init = function (terminal)
			
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
        	local panel = params._datas._widget
            pushNotificationResouceCount = getnewCountIsHaveResouce()
        	if pushNotificationResouceCount == true then
        		panel:setVisible(true)
        	else
        		panel:setVisible(false)
        	end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }
		--可占领的动画推送
    local push_notification_center_capture_can_attack_shine_terminal = {
        _name = "push_notification_center_capture_can_attack_shine",
        _init = function (terminal)
			
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
        	local panel = params._datas._widget
        	if getCaptureCanAttack() == true and pushNotificationResouceCount == false then
        		panel:setVisible(true)
        	else
        		panel:setVisible(false)
        	end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }
    state_machine.add(push_notification_center_mall_all_terminal)
    state_machine.add(push_notification_center_capture_shine_terminal)
    state_machine.add(push_notification_center_capture_can_attack_shine_terminal)
    state_machine.init()
end
init_push_notification_center_mall_terminal()

function getNoReadMallCount(notificationer)
	local unreadEMailCount = 0 
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
        or __lua_project_id == __lua_project_l_naruto 
        then
        if pushNotificationCenterMallHaveDate == true then
            for i , v in pairs(_ED._reward_centre) do 
                if tonumber(v.read_type) == 0 then
                    unreadEMailCount = unreadEMailCount + 1
                end
            end
        else
            -- TODO 减少进入游戏前端向后端请求的次数
            -- local function responsePropCompoundCallback(response)
            --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    pushNotificationCenterMallHaveDate = true
            --     end
            -- end
            -- NetworkManager:register(protocol_command.reward_center_init.code, nil, nil, nil, nil, responsePropCompoundCallback, false, nil)
        end
    else
    	if _ED.no_read_mail_cont ~= nil and zstring.tonumber(_ED.no_read_mail_cont) > 0  then
    		unreadEMailCount = zstring.tonumber(_ED.no_read_mail_cont)
    	elseif _ED.no_read_mail_cont ~= nil and zstring.tonumber(_ED.no_read_mail_cont) == -1  then
    		unreadEMailCount = 0 
    	end
    end 
	
	return unreadEMailCount
end
--被占领
function getnewCountIsHaveResouce( ... )
	if zstring.tonumber(_ED.no_read_mail_cont) == 0 then
		return false
	end 
	local table_len = #_ED.mail_item
    local result = _ED.mail_item--sortEmailForTime()
	for i,v in pairs(result) do
		if i <= tonumber(_ED.no_read_mail_cont) then
			if tonumber(result[i].mailChannelChildType) == 19 then
                local map_table = zstring.split(result[i].mailInfo,",")
                local _map_index = map_table[1]
                local _pos_x = map_table[2]
                local _pos_y = map_table[3]
                if checkIsMyBuild(_map_index,_pos_x,_pos_y) == true then
				    return true
                end
			end
		end
	end
    return false
end

