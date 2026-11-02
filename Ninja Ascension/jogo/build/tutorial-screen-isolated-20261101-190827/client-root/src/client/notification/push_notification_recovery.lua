-- Initialize push notification center state machine.
local function init_push_notification_center_recovery_terminal()
	--首页回收按钮的推送
    local push_notification_center_recovery_all_terminal = {
        _name = "push_notification_center_recovery_all",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getRecoveryAllTips() == true then
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
						if __lua_project_id == __lua_project_yugioh then
							ball:setPosition(cc.p(params._widget:getContentSize().width-20, params._widget:getContentSize().height - 20))
						else
							ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width, params._widget:getContentSize().height-ball:getContentSize().height))
						end
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
	--回收界面的武将分解按钮推送
	local push_notification_center_recovery_ship_terminal = {
        _name = "push_notification_center_recovery_ship",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getRecoveryShipTips() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
						ball:setAnchorPoint(cc.p(1.2, 1.2))
					else
						ball:setAnchorPoint(cc.p(0.7, 0.7))
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
	--回收界面的装备分解按钮的推送
	local push_notification_center_recovery_equip_terminal = {
        _name = "push_notification_center_recovery_equip",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getRecoveryEquipTips() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
						ball:setAnchorPoint(cc.p(1.2, 1.2))
					else
						ball:setAnchorPoint(cc.p(0.7, 0.7))
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
	
    state_machine.add(push_notification_center_recovery_all_terminal)
    state_machine.add(push_notification_center_recovery_ship_terminal)
    state_machine.add(push_notification_center_recovery_equip_terminal)
    state_machine.init()
end
init_push_notification_center_recovery_terminal()

function getRecoveryAllTips()
	if getRecoveryShipTips() == true then
		return true
	elseif getRecoveryEquipTips() == true then
		return true
	end
	return false
end

function getRecoveryShipTips()
	local recoveryNumber = 0
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		for i, ship in pairs(_ED.user_ship) do
			if zstring.tonumber(ship.formation_index) == 0 and zstring.tonumber(ship.little_partner_formation_index) == 0 then
				if ship.inResourceFromation ~= true then
					-- local ship_mould_data = dms.element(dms["ship_mould"], ship.ship_template_id)
					-- local ship_type = dms.atoi(ship_mould_data, ship_mould.ship_type)
					if zstring.tonumber(ship.ship_type) > 0 and zstring.tonumber(ship.ship_type) < 4 then
						if zstring.tonumber(ship.captain_type) ~= 2 then
							return true
						end
					end
				end
			end
		end
	else
		for i, ship in pairs(_ED.user_ship) do
			if zstring.tonumber(ship.formation_index) == 0 and zstring.tonumber(ship.little_partner_formation_index) == 0 then
				-- local ship_type = dms.int(dms["ship_mould"], ship.ship_template_id, ship_mould.ship_type)
				if zstring.tonumber(ship.ship_type) > 0 and zstring.tonumber(ship.ship_type) < 3 then
					recoveryNumber = recoveryNumber+1
					if recoveryNumber >= 5 then
						return true
					end
				end
			end
		end
	end
	return false
end

function getRecoveryEquipTips()
	local recoveryNumber = 0
	for i, equip in pairs(_ED.user_equiment) do
		if zstring.tonumber(equip.ship_id) == 0 then
			local equipment_mould_data = dms.element(dms["equipment_mould"], equip.user_equiment_template)
			local grab_rank_link = dms.atoi(equipment_mould_data, equipment_mould.grab_rank_link)
			if grab_rank_link == -1 then
				-- local grow_level = dms.atoi(equipment_mould_data, equipment_mould.grow_level)
				if zstring.tonumber(equip.grow_level) > 0 and zstring.tonumber(equip.grow_level) < 3 then
					recoveryNumber = recoveryNumber + 1
					if recoveryNumber >= 5 then
						return true
					end
				end
			end
		end
	end
end
