--------------------------------------------------------------------------------------------------------------
--  说明：阵容修理
--------------------------------------------------------------------------------------------------------------
FormationRepair = class("FormationRepairClass", Window)

--打开界面
local formation_repair_open_terminal = {
	_name = "formation_repair_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        local panel = FormationRepair:new():init(params)
        fwin:open(panel)
        return panel
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local formation_repair_close_terminal = {
	_name = "formation_repair_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("FormationRepairClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(formation_repair_open_terminal)
state_machine.add(formation_repair_close_terminal)
state_machine.init()

function FormationRepair:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}

    self._from_type = 0

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_production_arrow_down = nil
    self._Image_production_arrow_up = nil
	
	self.need_repars_ships = {}
    self._need_gem = 0      -- 所需宝石
    self._need_gold = 0     -- 所需金币
    local function init_formation_repair_terminal()
        local formation_repair_show_terminal = {
            _name = "formation_repair_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local formation_repair_hide_terminal = {
            _name = "formation_repair_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local formation_repair_update_info_terminal = {
            _name = "formation_repair_update_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.roots ~= nil and instance.roots[1] ~= nil then
                    local posY = instance._list_view_poy
                    instance:updateDraw()
                    if math.abs(posY) > math.abs(instance._list_view_height) then
                        posY = instance._list_view_height
                    end
                    instance._list_view:getInnerContainer():setPositionY(posY)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--金币全部维修
		local formation_repair_all_repair_gold_terminal = {
            _name = "formation_repair_all_repair_gold",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._need_gold > zstring.tonumber(_ED.user_info.user_gold) then
                    TipDlg.drawTextDailog(tipStringInfo_campaign_info[16])
                    return
                end                
				local function requesrRepairCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        TipDlg.drawTextDailog(red_alert_time_str[110])
                        checkPlayEffect(74)
						state_machine.excute("formation_repair_update_info",0,0)
                        state_machine.excute("home_map_update_build", 0, nil)
                        state_machine.excute("notification_center_update", 0, "push_notification_formation_repair")
					end
				end
				local ship_id_set = ""
				for k, v in pairs(self.need_repars_ships) do
					if k == #self.need_repars_ships then
						ship_id_set = ship_id_set..v.ship_id
					else
						ship_id_set = ship_id_set..v.ship_id..","
					end
				end
				protocol_command.ship_repair_ship_count.param_list = params._datas._tepair_type .. "\r\n" ..ship_id_set
				NetworkManager:register(protocol_command.ship_repair_ship_count.code, nil, nil, nil, nil, requesrRepairCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--宝石全部维修
		local formation_repair_all_repair_gem_terminal = {
            _name = "formation_repair_all_repair_gem",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._need_gem > zstring.tonumber(_ED.user_info.user_silver) then
                    TipDlg.drawTextDailog(red_alert_time_str[52])
                    return
                end
                local function requesrRepairCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        TipDlg.drawTextDailog(red_alert_time_str[110])
                        checkPlayEffect(74)
						state_machine.excute("formation_repair_update_info",0,0)
                        state_machine.excute("home_map_update_build", 0, nil)
                        state_machine.excute("main_window_update_resource", 0, nil)
                        state_machine.excute("notification_center_update", 0, "push_notification_formation_repair")
					end
				end
				local ship_id_set = ""
				for k, v in pairs(self.need_repars_ships) do
					if k == #self.need_repars_ships then
						ship_id_set = ship_id_set..v.ship_id
					else
						ship_id_set = ship_id_set..v.ship_id..","
					end
				end
				protocol_command.ship_repair_ship_count.param_list = params._datas._tepair_type .. "\r\n" ..ship_id_set
				NetworkManager:register(protocol_command.ship_repair_ship_count.code, nil, nil, nil, nil, requesrRepairCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(formation_repair_show_terminal)
        state_machine.add(formation_repair_hide_terminal)
        state_machine.add(formation_repair_update_info_terminal)
        state_machine.add(formation_repair_all_repair_gold_terminal)
        state_machine.add(formation_repair_all_repair_gem_terminal)
        state_machine.init()
    end
    
    init_formation_repair_terminal()
end

function FormationRepair:updateDraw()
    local root = self.roots[1]
    local ListView_implement = ccui.Helper:seekWidgetByName(root, "ListView_implement")
    ListView_implement:jumpToTop()
    ListView_implement:removeAllItems()

    self.need_repars_ships = {}
	local need_repars_gold = 0
	local need_repars_gem = 0
    for k, v in pairs(_ED.user_ship) do
        if v.captain_type ~= 3 then
            if tonumber(v.lose_ship_count) > 0 then
                table.insert(self.need_repars_ships, v)
    			local ship_data = dms.element(dms["ship_mould"], v.ship_template_id)
    			local cost_gem = dms.atoi(ship_data, ship_mould.price)           -- 维修消耗宝石矿
    			local cost_gold = dms.atof(ship_data, ship_mould.need_honor)     -- 维修消耗金币
    			need_repars_gold = need_repars_gold + math.ceil(tonumber(v.lose_ship_count)*cost_gold)
    			need_repars_gem = need_repars_gem + math.ceil(tonumber(v.lose_ship_count)*cost_gem)
            end
        end
    end
    need_repars_gold = math.ceil(need_repars_gold * (1 - zstring.tonumber(_ED.repair_cost_factor) / 100))
    need_repars_gem = math.ceil(need_repars_gem * (1 - zstring.tonumber(_ED.repair_cost_factor) / 100))

    for k, v in pairs(self.need_repars_ships) do
        local cell = state_machine.excute("formation_repair_cell_create", 0, {k, v})
        ListView_implement:addChild(cell)
    end

    ListView_implement:requestRefreshView()
    self._list_view = ListView_implement
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
	
	--金币消耗数
	local Text_repair_all_gold_n = ccui.Helper:seekWidgetByName(root, "Text_repair_all_gold_n")
    self._need_gold = need_repars_gold
	Text_repair_all_gold_n:setString(exChangeNumToString(math.ceil(need_repars_gold)))
	if need_repars_gold > zstring.tonumber(_ED.user_info.user_gold) then
		Text_repair_all_gold_n:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
	else
		Text_repair_all_gold_n:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
	end
	--宝石消耗数
	local Text_repair_all_gem_n = ccui.Helper:seekWidgetByName(root, "Text_repair_all_gem_n")
	Text_repair_all_gem_n:setString(exChangeNumToString(math.ceil(need_repars_gem)))
    self._need_gem = need_repars_gem
	if need_repars_gem > zstring.tonumber(_ED.user_info.user_silver) then
		Text_repair_all_gem_n:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
	else
		Text_repair_all_gem_n:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
	end

    local Button_repair_all_gold = ccui.Helper:seekWidgetByName(root, "Button_repair_all_gold")
    local Button_repair_all_gem = ccui.Helper:seekWidgetByName(root, "Button_repair_all_gem")
    if #self.need_repars_ships == 0 then
        Button_repair_all_gold:setTouchEnabled(false)
        Button_repair_all_gold:setBright(false)
        Button_repair_all_gem:setTouchEnabled(false)
        Button_repair_all_gem:setBright(false)
    else
        Button_repair_all_gold:setTouchEnabled(true)
        Button_repair_all_gold:setBright(true)
        Button_repair_all_gem:setTouchEnabled(true)
        Button_repair_all_gem:setBright(true)
    end

    local Text_info = ccui.Helper:seekWidgetByName(root, "Text_info")
    if Text_info ~= nil then
        if self._from_type == 8 then
            ccui.Helper:seekWidgetByName(root, "Text_info"):setVisible(true)
        else
            ccui.Helper:seekWidgetByName(root, "Text_info"):setVisible(false)
        end
    end

    local Text_troops_repair_all_not = ccui.Helper:seekWidgetByName(root, "Text_troops_repair_all_not")
    if #self._list_view:getItems() > 0 then
        Text_troops_repair_all_not:setVisible(false)
    else
        Text_troops_repair_all_not:setVisible(true)
    end

    local Text_troops_repair_all_p = ccui.Helper:seekWidgetByName(root, "Text_troops_repair_all_p")
    local num = dms.float(dms["fight_config"], 34, fight_config.attribute)
    num = num * 100
    Text_troops_repair_all_p:setString(num.."%")
	
	state_machine.excute("home_map_update_build", 0, 0)
end

function FormationRepair:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_production_arrow_down:setVisible(true)
        else
            self._Image_production_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_production_arrow_up:setVisible(true)
        else
            self._Image_production_arrow_up:setVisible(false)
        end
        if self._list_view_poy == posY then
            return
        end
        self._list_view_poy = posY
        local items = self._list_view:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

--初始化
function FormationRepair:onInit()
    local csbItem = csb.createNode(string.format(config_csb.formation.formation_tab, "3"))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
	
	
	-- 金币维修
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_repair_all_gold"), nil, 
    {
        terminal_name = "formation_repair_all_repair_gold", 
        terminal_state = 0,
        touch_scale = true,
		_tepair_type = 0,
    },
    nil,1)

    -- 宝石维修
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_repair_all_gem"), nil, 
    {
        terminal_name = "formation_repair_all_repair_gem", 
        terminal_state = 0,
        touch_scale = true,
		_tepair_type = 1,
    },
    nil,1)

    self._Image_production_arrow_up = ccui.Helper:seekWidgetByName(root,"Image_production_arrow_up")
    self._Image_production_arrow_down = ccui.Helper:seekWidgetByName(root,"Image_production_arrow_down")

    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_production_arrow_down:stopAllActions()
    self._Image_production_arrow_up:stopAllActions()
    playActions(self._Image_production_arrow_down)
    playActions(self._Image_production_arrow_up)
    self._Image_production_arrow_down:setVisible(false)
    self._Image_production_arrow_up:setVisible(false)

    self:updateDraw()
end

function FormationRepair:onEnterTransitionFinish()

end

function FormationRepair:init(param)
    self._rootWindows = param[1]
    self._from_type = param[2]
	self:onInit()
    return self
end

function FormationRepair:onExit()
    state_machine.remove("formation_repair_show")
    state_machine.remove("formation_repair_hide")
    state_machine.remove("formation_repair_update_info")
    state_machine.remove("formation_repair_all_repair_gold")
    state_machine.remove("formation_repair_all_repair_gem")
end