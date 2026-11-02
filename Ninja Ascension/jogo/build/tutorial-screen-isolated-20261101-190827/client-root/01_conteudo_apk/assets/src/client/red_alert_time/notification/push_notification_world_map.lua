cc.Director:getInstance():getTextureCache():addImage("images/ui/bar/tuishong.png")
push_notification_queue_march_count = 0	  -- 行军
push_notification_queue_struck_count = 0	  -- 来袭
push_notification_privilege_packs_count = 0	  -- 特权
push_notification_privilege_packs_internal_count = 0	  -- 特权2
push_notification_queue_defense_count = 0	  -- 协防

local function init_push_notification_world_map_terminal()
	--行军
    local push_notification_queue_march_terminal = {
        _name = "push_notification_queue_march",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			local count = 0
			if redAlertTimeMineEventQueue._defense_index > 0 then
				count = gerQueueDefense()
			elseif redAlertTimeMineEventQueue._struck_index > 0 then
				count = gerQueueStruck()
			elseif redAlertTimeMineEventQueue._march_index > 0 then	
				count = gerQueueMarch()
			end
			local isChange = false
	        if count ~= push_notification_queue_march_count then
	        	isChange = true
	        end
	        push_notification_queue_march_count = count
			if count > 0 then
				if isChange == true then
					if params._widget._istips == true then
						params._widget:removeChild(params._widget._nodeChild, true)
						params._widget._nodeChild = nil
						params._widget._istips = false
					end
				else
					-- if params._widget._istips == nil or params._widget._istips == false then
					-- 	local ball = state_machine.excute("util_tips_cretae", 0, {count})
					-- 	ball:setAnchorPoint(cc.p(0.5, 0.5))
					-- 	ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
					-- 	params._widget:addChild(ball)
					-- 	params._widget._nodeChild = ball
					-- 	params._widget._istips = true
					-- end
				end
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = state_machine.excute("util_tips_cretae", 0, {count})
					ball:setAnchorPoint(cc.p(0.5, 0.5))
					ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
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

    --来袭
    local push_notification_queue_struck_terminal = {
        _name = "push_notification_queue_struck",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			local count = 0
			if redAlertTimeMineEventQueue._defense_index >0 and redAlertTimeMineEventQueue._struck_index > 0 then
				count = gerQueueStruck()
			elseif redAlertTimeMineEventQueue._defense_index >0 and redAlertTimeMineEventQueue._march_index > 0 then
				count = gerQueueMarch()	
			elseif redAlertTimeMineEventQueue._struck_index > 0 and redAlertTimeMineEventQueue._march_index > 0 then
				count = gerQueueMarch()		
			end
			-- if redAlertTimeMineEventQueue._march_index >0 and redAlertTimeMineEventQueue._struck_index > 0 then
			-- 	count = gerQueueMarch()
			-- elseif redAlertTimeMineEventQueue._struck_index > 0 and redAlertTimeMineEventQueue._march_index<=0 then
			-- 	count = gerQueueMarch()
			-- else
				-- count = gerQueueMarch()
			-- end
			local isChange = false
	        if count ~= push_notification_queue_struck_count then
	        	isChange = true
	        end
	        push_notification_queue_struck_count = count
			if count > 0 then
				if isChange == true then
					if params._widget._istips == true then
						params._widget:removeChild(params._widget._nodeChild, true)
						params._widget._nodeChild = nil
						params._widget._istips = false
					end
				else
					-- if params._widget._istips == nil or params._widget._istips == false then
					-- 	local ball = state_machine.excute("util_tips_cretae", 0, {count})
					-- 	ball:setAnchorPoint(cc.p(0.5, 0.5))
					-- 	ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
					-- 	params._widget:addChild(ball)
					-- 	params._widget._nodeChild = ball
					-- 	params._widget._istips = true
					-- end
				end
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = state_machine.excute("util_tips_cretae", 0, {count})
					ball:setAnchorPoint(cc.p(0.5, 0.5))
					ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
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

    --协防
    local push_notification_queue_defense_terminal = {
        _name = "push_notification_queue_defense",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			local count = 0
			-- if redAlertTimeMineEventQueue._march_index >0 and redAlertTimeMineEventQueue._struck_index > 0 then
			-- 	count = gerQueueMarch()
			-- elseif redAlertTimeMineEventQueue._struck_index > 0 and redAlertTimeMineEventQueue._march_index<=0 then
			-- 	count = gerQueueMarch()
			-- else
				count = gerQueueMarch()
			-- end
			local isChange = false
	        if count ~= push_notification_queue_defense_count then
	        	isChange = true
	        end
	        push_notification_queue_defense_count = count
			if count > 0 then
				if isChange == true then
					if params._widget._istips == true then
						params._widget:removeChild(params._widget._nodeChild, true)
						params._widget._nodeChild = nil
						params._widget._istips = false
					end
				else
					-- if params._widget._istips == nil or params._widget._istips == false then
					-- 	local ball = state_machine.excute("util_tips_cretae", 0, {count})
					-- 	ball:setAnchorPoint(cc.p(0.5, 0.5))
					-- 	ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
					-- 	params._widget:addChild(ball)
					-- 	params._widget._nodeChild = ball
					-- 	params._widget._istips = true
					-- end
				end
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = state_machine.excute("util_tips_cretae", 0, {count})
					ball:setAnchorPoint(cc.p(0.5, 0.5))
					ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
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

    --行军事件
    local push_notification_queue_event_terminal = {
        _name = "push_notification_queue_event",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            local count = 0
            local isChange = flase
            local m_type = params._datas._m_type
            if m_type == 1 then
                count = gerQueueMarch()
                if count ~= push_notification_queue_march_count then
                    isChange = true
                end
                push_notification_queue_march_count = count
            elseif m_type == 2 then
                count = gerQueueStruck()
                if count ~= push_notification_queue_struck_count then
                    isChange = true
                end
                push_notification_queue_struck_count = count
            elseif m_type == 3 then
                count = gerQueueDefense()
                if count ~= push_notification_queue_defense_count then
                    isChange = true
                end
                push_notification_queue_defense_count = count
            end

            if count > 0 then
                if isChange == true then
                    if params._widget._istips == true then
                        params._widget:removeChild(params._widget._nodeChild, true)
                        params._widget._nodeChild = nil
                        params._widget._istips = false
                    end
                else
                end
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = state_machine.excute("util_tips_cretae", 0, {count})
                    ball:setAnchorPoint(cc.p(0.5, 0.5))
                    ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
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

    --特权礼包
    local push_notification_privilege_packs_terminal = {
        _name = "push_notification_privilege_packs",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			local count = 0
			count = getAllPrivilegePacks()
			local isChange = false
	        if count ~= push_notification_privilege_packs_count then
	        	isChange = true
	        end
	        push_notification_privilege_packs_count = count
			if count > 0 then
				if isChange == true then
					if params._widget._istips == true then
						params._widget:removeChild(params._widget._nodeChild, true)
						params._widget._nodeChild = nil
						params._widget._istips = false
					end
				else
				end
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = state_machine.excute("util_tips_cretae", 0, {})
					ball:setAnchorPoint(cc.p(0.5, 0.5))
                    if ball:getContentSize().height > params._widget:getContentSize().height / 2 then
                        ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5+8, params._widget:getContentSize().height-ball:getContentSize().height*0.5+10))
                    else
    					ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
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

    --特权礼包2
    local push_notification_privilege_packs_internal_terminal = {
        _name = "push_notification_privilege_packs_internal",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			local count = 0
			count = gerPrivilegePacks()
			local isChange = false
	        if count ~= push_notification_privilege_packs_internal_count then
	        	isChange = true
	        end
	        push_notification_privilege_packs_internal_count = count
			if count > 0 then
				if isChange == true then
					if params._widget._istips == true then
						params._widget:removeChild(params._widget._nodeChild, true)
						params._widget._nodeChild = nil
						params._widget._istips = false
					end
				else
				end
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = state_machine.excute("util_tips_cretae", 0, {count})
					ball:setAnchorPoint(cc.p(0.5, 0.5))
					ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
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

    --特权福利
    local push_notification_vip_privilege_gift_terminal = {
        _name = "push_notification_vip_privilege_gift",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getPrivilegeGifts() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = state_machine.excute("util_tips_cretae", 0, {""})
					ball:setAnchorPoint(cc.p(0.5, 0.5))
					ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
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

    state_machine.add(push_notification_queue_march_terminal)
    state_machine.add(push_notification_queue_struck_terminal)
    state_machine.add(push_notification_queue_defense_terminal)
    state_machine.add(push_notification_privilege_packs_terminal)
    state_machine.add(push_notification_privilege_packs_internal_terminal)
    state_machine.add(push_notification_queue_event_terminal)
    state_machine.add(push_notification_vip_privilege_gift_terminal)
    state_machine.init()
end
init_push_notification_world_map_terminal()

-- 
function gerQueueMarch()
	local index = 0 
	if _ED.world_map~= nil and _ED.world_map.target_event_info ~= nil then
		for i, v in pairs(_ED.world_map.target_event_info) do
			if tonumber(v._event_type) < 10 
                or tonumber(v._event_type) == 18 
                or tonumber(v._event_type) == 19
                or tonumber(v._event_type) == 20
                or tonumber(v._event_type) == 23
                then
				index = index + 1
			end
		end
	end
	return index
end


function gerQueueStruck()
	local index = 0 
	if _ED.world_map~= nil and _ED.world_map.target_event_info ~= nil then
		for i, v in pairs(_ED.world_map.target_event_info) do
			if tonumber(v._event_type) > 10 and tonumber(v._event_type) < 13 then	
				index = index + 1
			end
		end
	end
	return index
end

function gerQueueDefense()
	local index = 0 
	if _ED.world_map~= nil and _ED.world_map.target_event_info ~= nil then
		for i, v in pairs(_ED.world_map.target_event_info) do
			if tonumber(v._event_type) >= 13 and tonumber(v._event_type) < 18 then	
				index = index + 1
			end
		end
	end
	return index
end

function gerPrivilegePacks()
	local index = 0
	if _ED.activity_info["49"] ~= nil then
		local activity_data = _ED.activity_info["49"].activity_data[1]
	    for i=1, #activity_data do
	        if tonumber(activity_data[i].achieve_state) ~= 2 then
	        	local moneyData = zstring.split(activity_data[i].achieve_other_info, ",")
	        	if tonumber(_ED.vip_grade) >= tonumber(moneyData[3]) then
	        		index = index + 1
	        	end
	        end
	    end  
	end
    return index  
end

function getPrivilegeGifts()
	if _ED.activity_info["131"] ~= nil then
		local activity_data = _ED.activity_info["131"].activity_data[1]
		for j, w in pairs(activity_data) do
            if tonumber(w.achieve_state) == 1 then
                return true
            end
        end
	end
    return false  
end

function getAllPrivilegePacks()
	local index = 0
	if pushNotificationRedAlertTimeVipReward() == true then
		index = index + gerPrivilegePacks()
	end
	if getPrivilegeGifts() == true then
		index = index + 1
	end
	return index
end