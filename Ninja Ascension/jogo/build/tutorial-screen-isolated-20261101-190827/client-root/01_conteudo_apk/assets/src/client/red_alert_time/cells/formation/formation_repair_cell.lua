-- --------------------------------------------------------------------------------------------------
-- 说明：部队维修cell
-- -----------------------------------------------------------------------------------------------------
FormationRepairCell = class("FormationRepairCellClass", Window)
FormationRepairCell.__size = nil

local formation_repair_cell_create_terminal = {
    _name = "formation_repair_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        local cell = FormationRepairCell:new()
        local index = params[1]
        local ship = params[2]
        cell:init(index, ship)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(formation_repair_cell_create_terminal)
state_machine.init()

function FormationRepairCell:ctor()
    self.super:ctor()
    self.roots = {}  

    self._index = 1   

    self._need_gem = 0      -- 所需宝石
    self._need_gold = 0     -- 所需金币
    local function init_formation_repair_cell_terminal()
        -- 金币维修
        local formation_repair_cell_repair_gold_terminal = {
            _name = "formation_repair_cell_repair_gold",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				--刷新
				local function requesrRepairCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        TipDlg.drawTextDailog(red_alert_time_str[109])
						state_machine.excute("formation_repair_update_info",0,0)
                        state_machine.excute("home_map_update_build", 0, nil)
                        state_machine.excute("notification_center_update", 0, "push_notification_formation_repair")
					end
				end
				local cells = params._datas.cell
                if math.ceil(cells._need_gold) > zstring.tonumber(_ED.user_info.user_gold) then
                    TipDlg.drawTextDailog(tipStringInfo_campaign_info[16])
                    return
                end
				protocol_command.ship_repair_ship_count.param_list = params._datas._tepair_type .. "\r\n" ..cells._ship.ship_id
				NetworkManager:register(protocol_command.ship_repair_ship_count.code, nil, nil, nil, nil, requesrRepairCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 宝石维修
        local formation_repair_cell_repair_gem_terminal = {
            _name = "formation_repair_cell_repair_gem",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				--刷新
				local function requesrRepairCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        TipDlg.drawTextDailog(red_alert_time_str[109])
						state_machine.excute("formation_repair_update_info",0,0)
                        state_machine.excute("home_map_update_build", 0, nil)
                        state_machine.excute("main_window_update_resource", 0, nil)
                        state_machine.excute("notification_center_update", 0, "push_notification_formation_repair")
					end
				end
				local cells = params._datas.cell
                if math.ceil(cells._need_gem) > zstring.tonumber(_ED.user_info.user_silver) then
                    TipDlg.drawTextDailog(red_alert_time_str[52])
                    return
                end
				protocol_command.ship_repair_ship_count.param_list = params._datas._tepair_type .. "\r\n" ..cells._ship.ship_id
				NetworkManager:register(protocol_command.ship_repair_ship_count.code, nil, nil, nil, nil, requesrRepairCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
    
        state_machine.add(formation_repair_cell_repair_gold_terminal)    
        state_machine.add(formation_repair_cell_repair_gem_terminal)      
        state_machine.init()
    end
    init_formation_repair_cell_terminal()           
end

function FormationRepairCell:onUpdateDraw()
    local root = self.roots[1]
    local Panel_implement_icon = ccui.Helper:seekWidgetByName(root,"Panel_implement_icon")
    local Text_repair_tank_name = ccui.Helper:seekWidgetByName(root,"Text_repair_tank_name")
    local Text_repair_tank_n = ccui.Helper:seekWidgetByName(root,"Text_repair_tank_n")
    local Text_consume_gold = ccui.Helper:seekWidgetByName(root,"Text_consume_gold")
    local Text_consume_gem = ccui.Helper:seekWidgetByName(root,"Text_consume_gem")

    local lose_ship_count = self._ship.lose_ship_count
    -- lose_ship_count = 7
    local mould_id = self._ship.ship_template_id

    local ship_data = dms.element(dms["ship_mould"], mould_id)
    local name = dms.atos(ship_data, ship_mould.captain_name)        -- 名称
    local pic = dms.atoi(ship_data, ship_mould.All_icon)            -- 图标
    local cost_gem = dms.atoi(ship_data, ship_mould.price)           -- 维修消耗宝石矿
    local cost_gold = dms.atof(ship_data, ship_mould.need_honor)     -- 维修消耗金币

    Text_repair_tank_name:setString(name)

    Panel_implement_icon:removeBackGroundImage()
    Panel_implement_icon:setBackGroundImage(string.format(config_res.images.ui.props.tank, pic))
    Text_repair_tank_n:setString(lose_ship_count)

    Text_consume_gold:setString(exChangeNumToString(math.ceil((cost_gold * lose_ship_count) * (1 - zstring.tonumber(_ED.repair_cost_factor) / 100))))
    self._need_gold = math.ceil(cost_gold * (1 - zstring.tonumber(_ED.repair_cost_factor) / 100))
    if math.ceil(self._need_gold) > zstring.tonumber(_ED.user_info.user_gold) then
        Text_consume_gold:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
    else
        Text_consume_gold:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
    end

    Text_consume_gem:setString(exChangeNumToString( math.ceil((cost_gem * lose_ship_count) * (1 - zstring.tonumber(_ED.repair_cost_factor) / 100))))
    self._need_gem = math.ceil(cost_gem * (1 - zstring.tonumber(_ED.repair_cost_factor) / 100))
    if math.ceil(self._need_gem) > zstring.tonumber(_ED.user_info.user_silver) then
        Text_consume_gem:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
    else
        Text_consume_gem:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
    end
end

function FormationRepairCell:setSelected()

end

function FormationRepairCell:onEnterTransitionFinish()

end

function FormationRepairCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.formation.formation_repair_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 

    local size = root:getContentSize()
    
    if FormationRepairCell.__size == nil then
        FormationRepairCell.__size = size
    end

    -- 金币维修
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_repair_gold"), nil, 
    {
        terminal_name = "formation_repair_cell_repair_gold", 
        terminal_state = 0,
        touch_scale = true,
        cell = self,
		_tepair_type = 0,
    },
    nil,1)

    -- 宝石维修
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_repair_gem"), nil, 
    {
        terminal_name = "formation_repair_cell_repair_gem", 
        terminal_state = 0,
        touch_scale = true,
        cell = self,
		_tepair_type = 1,
    },
    nil,1)
    
    self:onUpdateDraw()
end

function FormationRepairCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.formation.formation_repair_cell, self.roots[1])
end

function FormationRepairCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function FormationRepairCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.formation.formation_repair_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function FormationRepairCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_implement_icon = ccui.Helper:seekWidgetByName(root,"Panel_implement_icon")
    local Text_repair_tank_name = ccui.Helper:seekWidgetByName(root,"Text_repair_tank_name")
    local Text_repair_tank_n = ccui.Helper:seekWidgetByName(root,"Text_repair_tank_n")
    local Text_consume_gold = ccui.Helper:seekWidgetByName(root,"Text_consume_gold")
    local Text_consume_gem = ccui.Helper:seekWidgetByName(root,"Text_consume_gem")

    if Panel_implement_icon ~= nil then
        Panel_implement_icon:removeBackGroundImage()
        Text_repair_tank_name:setString("")
        Text_repair_tank_n:setString("")
        Text_consume_gold:setString("")
        Text_consume_gold:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
        Text_consume_gem:setString("")
        Text_consume_gem:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
    end
end

function FormationRepairCell:init(index, ship) 
    self._index = index
    self._ship = ship

    if index ~= nil and index <= 8 then
        self:onInit()
    end
    self:setContentSize(FormationRepairCell.__size)
end

