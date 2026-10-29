-- Initialize push notification center state machine.
local function init_push_notification_center_friend_terminal()
	--首页好友按钮的推送
    local push_notification_center_adventure_home_friend_terminal = {
        _name = "push_notification_center_adventure_home_friend",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getFriendCenterAllTips(params) == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/icon/bg_reward_tag_1.png")
					local countLabel = cc.Label:createWithTTF("1" ,"fonts/chinese.ttf", 30)
					countLabel:setContentSize(ball:getContentSize())
					countLabel:setColor(cc.c3b(0,0,0))
					--countLabel:setFontColor(cc.c3b(255,0,0))
				   	countLabel:setAnchorPoint(cc.p(0.5, 0.5))-->设置锚点
				   	countLabel:setPosition(cc.p(ball:getContentSize().width/2,ball:getContentSize().height/2))
				   	ball:addChild(countLabel,2)
					ball:setAnchorPoint(cc.p(1, 1))
					ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height + 10))
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
	
	--好友请求个数
    local push_notification_center_friend_apply_count_terminal = {
        _name = "push_notification_center_friend_apply_count",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)

			-- if 1 == true then
			-- 	if params._widget._istips == nil or params._widget._istips == false then
			-- 		local ball = cc.Sprite:create("images/ui/icon/bg_reward_tag.png")
			-- 		ball:setAnchorPoint(cc.p(0.7, 0.7))
			-- 		ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height))
			-- 		params._widget:addChild(ball)
			-- 		params._widget._nodeChild = ball
			-- 		params._widget._istips = true
			-- 	end
			-- else
			-- 	if params._widget._istips == true then
			-- 		params._widget:removeChild(params._widget._nodeChild, true)
			-- 		params._widget._nodeChild = nil
			-- 		params._widget._istips = false
			-- 	end
			-- end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }
	
    state_machine.add(push_notification_center_adventure_home_friend_terminal)
	-- state_machine.add(push_notification_center_friend_apply_count_terminal)
    --state_machine.add(push_notification_center_friend_endurance_terminal)
    --state_machine.add(push_notification_center_friend_apply_terminal)
    state_machine.init()
end
init_push_notification_center_friend_terminal()

function getFriendCenterAllTips(notificationer)
	
	-- if getFriendEnduranceTips(notificationer) == true then
	-- 	return true
	-- end
	if getFriendApplyTips(notificationer) == true then
		return true
	end
	-- return false
end

function getFriendEnduranceTips(notificationer)
	-- if (_ED.endurance_init_info.get_count == nil or _ED.endurance_init_info.get_count == "") and notificationer._need_request_friend_endurance ~= true then
	-- 	notificationer._need_request_friend_endurance = true

	-- 	local function recruitInitCallBack(response)
	-- 		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				
	-- 		end
	-- 	end
		
	-- 	NetworkManager:register(protocol_command.draw_endurance_init.code, nil, nil, nil, nil, recruitInitCallBack, false, nil)
 --        return false
	-- end
	
	-- if zstring.tonumber(_ED.endurance_init_info.get_count) > 0 then
	-- 	return true
	-- end
	return false
end

-- function getFriendApplyTips(notificationer)
-- 	if (zstring.tonumber(_ED.request_user_num) <= 0 or _ED.request_user_num == "") and notificationer._need_request_friend_apply ~= true then
-- 		notificationer.startTime = notificationer.startTime or os.time()
-- 		if (notificationer.startTime  + 6) > os.time() then
-- 			return
-- 		end
-- 		notificationer._need_request_friend_apply = true
		
-- 		local function recruitInitCallBack(response)
-- 			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then

-- 			end
-- 		end
-- 		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
-- 		else
-- 			NetworkManager:register(protocol_command.search_friend_apply.code, nil, nil, nil, nil, recruitInitCallBack, false, nil)
-- 		end
--         return false
-- 	end
	
-- 	if zstring.tonumber(_ED.request_user_num) > 0 then
-- 		return true
-- 	end
-- 	return false
-- end