-- Initialize push notification center state machine.
local function init_push_notification_center_military_rank_terminal()
	--首页三国志按钮的推送--九死邪功
    local push_notification_center_military_rank_all_terminal = {
        _name = "push_notification_center_military_rank_all",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			local military_grade=dms.int(dms["fun_open_condition"], 9, fun_open_condition.level)
			if military_grade <= zstring.tonumber(_ED.user_info.user_grade) then
				if _ED.cur_destiny_id == nil or _ED.cur_destiny_id == "" then
					if nil == NetworkManager:find(protocol_command.destiny_init.code) then
						NetworkManager:register(protocol_command.destiny_init.code, nil, nil, nil, nil, nil, false, nil)
					end
				end
				if getdestinyUpTips() == true then
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
							ball:setAnchorPoint(cc.p(0.5, 0.5))
							ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width, params._widget:getContentSize().height-ball:getContentSize().height))
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
			end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }
	
    state_machine.add(push_notification_center_military_rank_all_terminal)
    state_machine.init()
end
init_push_notification_center_military_rank_terminal()

function getdestinyUpTips()
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
			if _ED.cur_destiny_id == ""  then
				--如果请求还没回来
				return false
			end
			local next_destiny_id = tonumber(_ED.cur_destiny_id) + 1
			local destiny_mould_data = dms.element(dms["destiny_mould"], next_destiny_id)

			if dms.atoi(destiny_mould_data, destiny_mould.previous_id) == -1 then
				if dms.atoi(destiny_mould_data, destiny_mould.next_id) == -1 then
					--表示下一个还没开启，不推送
					return false
				end
			end
	end
	if tonumber(_ED.cur_destiny_id) == #dms["destiny_mould"] then
		return false
	end
	local destiny_mould_data = dms.element(dms["destiny_mould"], zstring.tonumber(_ED.cur_destiny_id)+1)
	local propItem = dms.atoi(destiny_mould_data, destiny_mould.need_of_prop)
	local propNumber = 0
	local findProp = fundPropWidthId(propItem)
	if findProp ~= nil then
		propNumber = zstring.tonumber(findProp.prop_number)
	end
	if propNumber >= dms.atoi(destiny_mould_data, destiny_mould.need_of_prop_count) then
		return true
	end
	return false
end

