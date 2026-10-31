-- Initialize push notification center state machine.
local function init_push_notification_center_chat_terminal()
	--首页聊天按钮的推送
    local push_notification_center_chat_all_terminal = {
        _name = "push_notification_center_chat_all",
        _init = function (terminal)
			
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getNoReadAllChatCount() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then 
						ball:setAnchorPoint(cc.p(1, 1))
						ball:setPosition(cc.p(params._widget:getContentSize().width+10, params._widget:getContentSize().height+5))
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
	
	--聊天界面世界聊天按钮的推送
    local push_notification_center_world_chat_terminal = {
        _name = "push_notification_center_world_chat",
        _init = function (terminal)
			
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getNoReadWorldChatCount() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = nil				
					if __lua_project_id == __lua_project_adventure  then 
						ball = cc.Sprite:create("images/ui/icon/bg_reward_tag.png")
						ball:setName("ball")
						ball:setAnchorPoint(cc.p(1, 1))
					else
						ball = cc.Sprite:create("images/ui/bar/tips.png")					
						if __lua_project_id == __lua_project_gragon_tiger_gate
							or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
							or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
							or __lua_project_id == __lua_project_red_alert 
							then 
							ball:setAnchorPoint(cc.p(0.4, 0.7))
						else
							ball:setAnchorPoint(cc.p(1, 1))
						end	
					end	
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
	
	--聊天界面私聊按钮的推送
    local push_notification_center_whisper_chat_terminal = {
        _name = "push_notification_center_whisper_chat",
        _init = function (terminal)
			
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getNoReadWhisperChatCount() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = nil 
					if __lua_project_id == __lua_project_adventure then 
						if params._widget.__isWhisper == false then 
							ball = cc.Sprite:create("images/ui/icon/bg_reward_tag.png")
							ball:setName("ball")
							ball:setAnchorPoint(cc.p(1, 1))
							ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height))
							params._widget:addChild(ball)
							params._widget._nodeChild = ball
							params._widget._istips = true	
						else
							params._widget._istips = true	
						end
						
					else
						ball = cc.Sprite:create("images/ui/bar/tips.png")
						if __lua_project_id == __lua_project_gragon_tiger_gate
							-- or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
							-- or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
							or __lua_project_id == __lua_project_red_alert 
							then 
							ball:setAnchorPoint(cc.p(0.4, 0.7))
						else
							ball:setAnchorPoint(cc.p(1, 1))
						end	
						ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height))
						params._widget:addChild(ball)
						params._widget._nodeChild = ball
						params._widget._istips = true
					end 
				end
			else
				if params._widget._istips == true then
					params._widget:removeChild(params._widget._nodeChild, true)
					params._widget._nodeChild = nil
					params._widget._istips = false

					-- 将已读的数据本地缓存
					local str = json.encode(_ED.privateChatSaveToXml)
					cc.UserDefault:getInstance():setStringForKey("privateChatSaveToXml", str)

					--延迟通知，不然通知不到，fwin.updateLua只会在app.notification_center.running == true时才才发通知
					local sharedScheduler = cc.Director:getInstance():getScheduler()
					local handle
				    handle = sharedScheduler:scheduleScriptFunc(function()
				        sharedScheduler:unscheduleScriptEntry(handle)
				        state_machine.excute("notification_center_update", 0, "push_notification_center_chat_all")
				    end, 0, false)
					

				end
			end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }
    --聊天界面军团聊天按钮的推送
    local push_notification_center_union_chat_terminal = {
        _name = "push_notification_center_union_chat",
        _init = function (terminal)
			
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getNoReadUnionChatCount() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")					
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then 
						ball:setAnchorPoint(cc.p(0.4, 0.7))
					else
						ball:setAnchorPoint(cc.p(1, 1))
					end		
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
	
    state_machine.add(push_notification_center_chat_all_terminal)
    state_machine.add(push_notification_center_world_chat_terminal)
    state_machine.add(push_notification_center_whisper_chat_terminal)
    if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh)
    	and ___is_open_union == true 
    	 then
   		state_machine.add(push_notification_center_union_chat_terminal)
   	end
    state_machine.init()
end
init_push_notification_center_chat_terminal()

function getNoReadAllChatCount()
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	else
		if getNoReadWorldChatCount() == true then 
			return true
		end
	end
	
	if getNoReadWhisperChatCount() == true then 
		return true
	end
	if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh)
		and ___is_open_union == true 
		 then
		if getNoReadUnionChatCount() == true then 
			return true
		end
	end
	return false
end

function getNoReadWorldChatCount()
	if __lua_project_id == __lua_project_adventure  then 
		chatWnd = fwin:find("AdventureChatHomeViewClass")	
	else
		chatWnd = fwin:find("ChatHomeViewClass")	
	end
	if chatWnd ~= nil then
		local information_count = zstring.tonumber(_ED.world_information_count)
			
		if zstring.tonumber(chatWnd.num) ~= information_count and information_count > 0 then
			return true
		end
	end
	
	return false
end

function getNoReadWhisperChatCount()
	local chatWnd = nil 
	if __lua_project_id == __lua_project_adventure  then 
		chatWnd = fwin:find("AdventureChatHomeViewClass")
	elseif __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		chatWnd = true
	else
		chatWnd = fwin:find("ChatHomeViewClass")	
	end

	if chatWnd ~= nil then
		-- local function responseInitCallback(response)
			-- if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			
			-- end
		-- end
		-- NetworkManager:register(protocol_command.refush_msg.code, nil, nil, nil, nil, responseInitCallback, false, nil)
		if _ED.findNewWhisper == 1 then
			return true
		end
	end
	
	return false
end

function getNoReadUnionChatCount()
	local chatWnd = fwin:find("ChatHomeViewClass")
	if chatWnd ~= nil then
		local information_count = zstring.tonumber(_ED.union_information_count)
			
		if zstring.tonumber(chatWnd.num) ~= information_count and information_count > 0 then
			return true
		end
	end
	
	return false
end