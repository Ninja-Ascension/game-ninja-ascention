-- Initialize push notification center state machine.
local function init_push_notification_center_friend_terminal()
	--首页好友按钮的推送
    local push_notification_center_friend_all_terminal = {
        _name = "push_notification_center_friend_all",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getFriendCenterAllTips(params) == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
					if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
						ball:setPosition(cc.p(params._widget:getContentSize().width-10, params._widget:getContentSize().height-15))
						if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
							ball:setPosition(cc.p(params._widget:getContentSize().width-15, params._widget:getContentSize().height))
						end
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
	
	--领取耐力子界面的推送
    local push_notification_center_friend_endurance_terminal = {
        _name = "push_notification_center_friend_endurance",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getFriendEnduranceTips(params) == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(0.7, 0.7))
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
						ball:setAnchorPoint(cc.p(1, 1))
					end
					ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height))
					if params._datas and params._datas._shifting then 
						ball:setPosition(cc.p(ball:getPositionX() - params._datas._shifting[1],ball:getPositionY() + params._datas._shifting[2]))
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
	
	--好友申请子界面的推送
    local push_notification_center_friend_apply_terminal = {
        _name = "push_notification_center_friend_apply",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getFriendApplyTips(params) == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(0.7, 0.7))
					ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height))
					if params._datas and params._datas._shifting then 
						ball:setAnchorPoint(cc.p(1, 1))
						ball:setPosition(cc.p(ball:getPositionX() - params._datas._shifting[1],ball:getPositionY() + params._datas._shifting[2]))
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
	
    state_machine.add(push_notification_center_friend_all_terminal)
    state_machine.add(push_notification_center_friend_endurance_terminal)
    state_machine.add(push_notification_center_friend_apply_terminal)
    state_machine.init()
end
init_push_notification_center_friend_terminal()

function getFriendCenterAllTips(notificationer)
	if getFriendEnduranceTips(notificationer) == true then
		return true
	end
	if getFriendApplyTips(notificationer) == true then
		return true
	end
	return false
end

function getFriendEnduranceTips(notificationer)
	if (_ED.endurance_init_info.get_count == nil or _ED.endurance_init_info.get_count == "") and notificationer._need_request_friend_endurance ~= true then
		notificationer._need_request_friend_endurance = true

		local function recruitInitCallBack(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				
			end
		end
		NetworkManager:register(protocol_command.draw_endurance_init.code, nil, nil, nil, nil, recruitInitCallBack, false, nil)
        return false
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		local count = 0
		local isHaveRecivew = false
		local max_draw_strength = zstring.split(dms.string(dms["friend_config"], 4, friend_config.param),",")
		max_draw_strength = tonumber(max_draw_strength[1])
		for i, v in pairs(_ED.endurance_init_info.get_info) do
			if tonumber(v.draw_state) == 1 then
				count = count + 1
				if count >= max_draw_strength then
					return false
				end
			elseif tonumber(v.draw_state) == 0 then
				isHaveRecivew = true
			end
		end
		return isHaveRecivew
	else
		if zstring.tonumber(_ED.endurance_init_info.get_count) > 0 then
			return true
		end
	end
	return false
end

function getFriendApplyTips(notificationer)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		if _ED.request_user ~= nil and #_ED.request_user > 0 then
			return true
		end
		return false
	end
	if (zstring.tonumber(_ED.request_user_num) <= 0 or _ED.request_user_num == "") and notificationer._need_request_friend_apply ~= true then
		notificationer.startTime = notificationer.startTime or os.time()
		if (notificationer.startTime  + 6) > os.time() then
			return
		end
		notificationer._need_request_friend_apply = true
		
		local function recruitInitCallBack(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				if zstring.tonumber(_ED.request_user_num) > 0 then
					state_machine.excute("friend_manager_four_update", 0, "")
				end
			end
		end
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		else
			NetworkManager:register(protocol_command.search_friend_apply.code, nil, nil, nil, nil, recruitInitCallBack, false, nil)
		end
        return false
	end
	
	if zstring.tonumber(_ED.request_user_num) > 0 then
		return true
	end
	return false
end