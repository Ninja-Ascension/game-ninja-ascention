-- Initialize push notification center state machine.
pushNotificationShipWarehouseTip = false

local function init_push_notification_center_ship_warehouse_terminal()
	--主页的武将仓库按钮的推送--英雄按钮
    local push_notification_center_ship_warehouse_all_terminal = {
        _name = "push_notification_center_ship_warehouse_all",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
        	if __lua_project_id == __lua_project_gragon_tiger_gate
				or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				or __lua_project_id == __lua_project_red_alert 
				then
        		if params == nil or params._widget == nil then
        			return
        		end
        	end
        	pushNotificationShipWarehouseTip = getShipSynthesisTips()
			if pushNotificationShipWarehouseTip == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")

					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then 
						ball:setAnchorPoint(cc.p(1, 1))
						ball:setPosition(cc.p(params._widget:getContentSize().width+3, params._widget:getContentSize().height))
						if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
							ball:setPosition(cc.p(params._widget:getContentSize().width-15, params._widget:getContentSize().height))
						end
					else
						ball:setAnchorPoint(cc.p(0.7, 0.7))
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
	--武将仓库界面内的武将碎片按钮的推送 --英雄碎片
	local push_notification_center_ship_warehouse_fragment_terminal = {
        _name = "push_notification_center_ship_warehouse_fragment",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if pushNotificationShipWarehouseTip == true then
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
	
	--武将仓库界面内的武将列表装备按钮
	local push_notification_center_ship_warehouse_ship_equip_tip_terminal = {
        _name = "push_notification_center_ship_warehouse_ship_equip_tip",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
        	--这个有问题，暂时不用,红点直接画在界面上做刷新
        	if true then
        		return false
        	end
        	local cell = params._datas._cell
        	local ship = cell.heroInstance
			if getShipWarehouseShipEquipTip(ship) == true then
				if cell.roots ~= nil then
		        	local button = ccui.Helper:seekWidgetByName(cell.roots[1], "Button_zhuangbei")
		        	if button ~= nil then
						if button._istips == nil or button._istips == false then
							local ball = cc.Sprite:create("images/ui/bar/tips.png")
							ball:setAnchorPoint(cc.p(0.7, 0.7))
							ball:setPosition(cc.p(button:getContentSize().width, button:getContentSize().height))
							button:addChild(ball)
							button._nodeChild = ball
							button._istips = true
						end
					end
				end
			else
				if cell.roots ~= nil then
		        	local button = ccui.Helper:seekWidgetByName(cell.roots[1], "Button_zhuangbei")
		        	if button ~= nil then
						if button._istips == true then
							button:removeChild(params._widget._nodeChild, true)
							button._nodeChild = nil
							button._istips = false
						end
					end
				end
			end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    --武将仓库界面内的武将列表强化按钮
	local push_notification_center_ship_warehouse_ship_strength_tip_terminal = {
        _name = "push_notification_center_ship_warehouse_ship_strength_tip",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
        	--这个有问题，暂时不用,红点直接画在界面上做刷新
        	if true then
        		return false
        	end
        	local cell = params._datas._cell
        	local ship = cell.heroInstance
			if getShipWarehouseShipStrengthTip(ship) == true then
	        	if cell.roots ~= nil then
		        	local button = ccui.Helper:seekWidgetByName(cell.roots[1], "Button_qianghua")
		        	if button ~= nil then
						if button._istips == nil or button._istips == false then
							local ball = cc.Sprite:create("images/ui/bar/tips.png")
							ball:setAnchorPoint(cc.p(0.7, 0.7))
							ball:setPosition(cc.p(button:getContentSize().width, button:getContentSize().height))
							button:addChild(ball)
							button._nodeChild = ball
							button._istips = true
						end
					end
				end
			else
				if cell.roots ~= nil then
		        	local button = ccui.Helper:seekWidgetByName(cell.roots[1], "Button_qianghua")
					if button ~= nil then
						if button._istips == true then
							button:removeChild(params._widget._nodeChild, true)
							button._nodeChild = nil
							button._istips = false
						end
					end
				end
			end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }
    state_machine.add(push_notification_center_ship_warehouse_all_terminal)
    state_machine.add(push_notification_center_ship_warehouse_fragment_terminal)
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
    	state_machine.add(push_notification_center_ship_warehouse_ship_equip_tip_terminal)
    	state_machine.add(push_notification_center_ship_warehouse_ship_strength_tip_terminal)
    end
    state_machine.init()
end
init_push_notification_center_ship_warehouse_terminal()

function getShipSynthesisTips()
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		--碎片合成
        for k, v in pairs(_ED.user_prop) do
            local ship_mould_id = dms.int(dms["prop_mould"], v.user_prop_template, prop_mould.use_of_ship)
            local storage_page_index = dms.int(dms["prop_mould"], v.user_prop_template, prop_mould.storage_page_index)
            if storage_page_index == 18 and ship_mould_id > 0 and fundShipWidthTemplateId(ship_mould_id) == nil then
                local need_count = dms.int(dms["prop_mould"], v.user_prop_template, prop_mould.split_or_merge_count)
                if tonumber(v.prop_number) >= need_count then
                    return true
                end
            end
        end

		--武将提升
		for i , v in pairs(_ED.user_ship) do
			if shipIsCanEvolution(v) == true then
				return true
			end
			if shipIsCanUpGradeStar(v) == true then
				return true
			end
			if shipEquipmentIsCanEvolution(v) == true then
				return true
			end
			if shipEquipmentIsCanAwake(v) == true then
				return true
			end
			-- for j = 1 , 6 do
			-- 	if equipmentIsCanEvolution(v , j) == true then
			-- 		return true
			-- 	end
			-- 	if equipmentIsCanAwake(v , j) == true then
			-- 		return true
			-- 	end
			-- end
		end
	else
		for i, prop in pairs(_ED.user_prop) do
			if dms.int(dms["prop_mould"], prop.user_prop_template, prop_mould.storage_page_index) == 5 then
				if tonumber(prop.prop_number) >= dms.int(dms["prop_mould"], prop.user_prop_template, prop_mould.split_or_merge_count) then
					return true
				end
			end
		end
	end
	return false
end

--装备按钮
function getShipWarehouseShipEquipTip(ship)
	if ship == nil then
		return false
	end
	if shipEquipmentIsCanEvolution(ship) == true then
        return true
    end
    if shipEquipmentIsCanAwake(ship) == true then
        return true
    end
	-- for j = 1 , 6 do
	-- 	if equipmentIsCanEvolution(ship , j) == true then
	-- 		return true
	-- 	end
	-- 	if equipmentIsCanAwake(ship , j) == true then
	-- 		return true
	-- 	end
	-- end
	return false
end

--武将强化按钮
function getShipWarehouseShipStrengthTip(ship)
	if ship == nil then
		return false
	end
	if shipIsCanEvolution(ship) == true then
		return true
	end
	if shipIsCanUpGradeStar(ship) == true then
		return true
	end
	return false
end
