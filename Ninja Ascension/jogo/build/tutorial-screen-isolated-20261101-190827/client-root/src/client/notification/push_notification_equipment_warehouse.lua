-- Initialize push notification center state machine.

pushNotificationEquipmentWarehouse = false

local function init_push_notification_center_equipment_warehouse_terminal()
	--首页装备仓库按钮的推送
    local push_notification_center_equipment_warehouse_all_terminal = {
        _name = "push_notification_center_equipment_warehouse_all",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
        	pushNotificationEquipmentWarehouse = getEquipMentSynthesisTips()
			if getEquipMentSynthesisTips() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then 
						ball:setAnchorPoint(cc.p(1, 1))
						ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height))
						if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
							ball:setPosition(cc.p(params._widget:getContentSize().width-15, params._widget:getContentSize().height))
						end
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
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }
	--装备仓库界面内的装备碎片按钮的推送
	local push_notification_center_equipment_warehouse_fragment_terminal = {
        _name = "push_notification_center_equipment_warehouse_fragment",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if pushNotificationEquipmentWarehouse == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(0.7, 0.7))
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
	
    state_machine.add(push_notification_center_equipment_warehouse_all_terminal)
    state_machine.add(push_notification_center_equipment_warehouse_fragment_terminal)
    state_machine.init()
end
init_push_notification_center_equipment_warehouse_terminal()

function getEquipMentSynthesisTips()
	for i, prop in pairs(_ED.user_prop) do
		local prop_mould_data = dms.element(dms["prop_mould"], prop.user_prop_template)
		if dms.atoi(prop_mould_data, prop_mould.storage_page_index) == 3 then
			if tonumber(prop.prop_number) >= dms.atoi(prop_mould_data, prop_mould.split_or_merge_count) then
				return true
			end
		end
	end
	return false
end
