--------------------------------------------------------------------------------------------------------------
--  仓库兑换
--------------------------------------------------------------------------------------------------------------
EquipmentPacksTabExchange = class("EquipmentPacksTabExchangeClass", Window)

local equipment_packs_tab_exchange_window_open_terminal = {
    _name = "equipment_packs_tab_exchange_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local list_view = EquipmentPacksTabExchange:new():init(params)
        fwin:open(list_view)
        return list_view
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(equipment_packs_tab_exchange_window_open_terminal)
state_machine.init()

function EquipmentPacksTabExchange:ctor()
    self.super:ctor()
    self.roots = {}

    self._last_page_index = 1

    -- 低级结晶
    self._low_crystal_panel = nil
    -- 中级结晶
    self._middle_crystal_panel = nil
    -- 高级结晶
    self._high_crystal_panel = nil

    app.load("client.red_alert_time.cells.props.props_shop_packs_shop_cell")

    -- Initialize equipment_packs_tab_exchange state machine.
    local function init_equipment_packs_tab_exchange_terminal()
        local equipment_packs_tab_exchange_show_terminal = {
            _name = "equipment_packs_tab_exchange_show",
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

        local equipment_packs_tab_exchange_hide_terminal = {
            _name = "equipment_packs_tab_exchange_hide",
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

        local equipment_packs_tab_exchange_change_page_terminal = {
            _name = "equipment_packs_tab_exchange_change_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance._last_page_index = params._datas.page_index
                instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新
        local equipment_packs_tab_exchange_update_draw_terminal = {
            _name = "equipment_packs_tab_exchange_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(equipment_packs_tab_exchange_show_terminal)
        state_machine.add(equipment_packs_tab_exchange_hide_terminal)
        state_machine.add(equipment_packs_tab_exchange_change_page_terminal)
        state_machine.add(equipment_packs_tab_exchange_update_draw_terminal)
        state_machine.init()
    end
    -- call func equipment_packs_tab_exchange create state machine.
    init_equipment_packs_tab_exchange_terminal()
end

function EquipmentPacksTabExchange:updateInfo( ... )
    local root = self.roots[1]
    local prop_ids = zstring.split(dms.string(dms["prop_config"], 18, prop_config.param), ",")
    for i = 1, 3 do
        local Text_change_crystal_n = ccui.Helper:seekWidgetByName(root, "Text_change_crystal_n_"..i)
        local prop_count = 0 
        if fundPropWidthId(tonumber(prop_ids[i])) ~= nil then 
            local token = fundPropWidthId(tonumber(prop_ids[i]))
            prop_count = zstring.tonumber(token.prop_number)
        end
        Text_change_crystal_n:setString(exChangeNumToString(prop_count))
    end
    state_machine.excute("equipment_packs_tab_listview_low_update", 0, nil)
    state_machine.excute("equipment_packs_tab_listview_middle_update", 0, nil)
    state_machine.excute("equipment_packs_tab_listview_high_update", 0, nil)
end

function EquipmentPacksTabExchange:updateDraw()
    local root = self.roots[1]

    local prop_ids = zstring.split(dms.string(dms["prop_config"], 18, prop_config.param), ",")

    for i = 1, 3 do
        local Button_change_tab = ccui.Helper:seekWidgetByName(root, "Button_change_tab_"..i)
        local Text_change_crystal_n = ccui.Helper:seekWidgetByName(root, "Text_change_crystal_n_"..i)
        local prop_count = 0 
        if fundPropWidthId(tonumber(prop_ids[i])) ~= nil then 
            local token = fundPropWidthId(tonumber(prop_ids[i]))
            prop_count = zstring.tonumber(token.prop_number)
        end
        Text_change_crystal_n:setString(exChangeNumToString(prop_count))
        if i == self._last_page_index then
            Button_change_tab:setHighlighted(true)
            Button_change_tab:setTouchEnabled(false)
        else
            Button_change_tab:setHighlighted(false)
            Button_change_tab:setTouchEnabled(true)
        end
    end
    
    local Panel_packs_change_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_packs_change_tab_box")
    state_machine.excute("equipment_packs_tab_listview_low_hide", 0, nil)
    state_machine.excute("equipment_packs_tab_listview_middle_hide", 0, nil)
    state_machine.excute("equipment_packs_tab_listview_high_hide", 0, nil)

    if self._last_page_index == 1 then
        if self._low_crystal_panel == nil then
            self._low_crystal_panel = state_machine.excute("equipment_packs_tab_listview_low_window_open", 0, {Panel_packs_change_tab_box, tonumber(prop_ids[1])})
        else
            state_machine.excute("equipment_packs_tab_listview_low_show", 0, nil)
        end
    elseif self._last_page_index == 2 then
        if self._middle_crystal_panel == nil then
            self._middle_crystal_panel = state_machine.excute("equipment_packs_tab_listview_middle_window_open", 0, {Panel_packs_change_tab_box, tonumber(prop_ids[2])})
        else
            state_machine.excute("equipment_packs_tab_listview_middle_show", 0, nil)
        end
    else
        if self._high_crystal_panel == nil then
            self._high_crystal_panel = state_machine.excute("equipment_packs_tab_listview_high_window_open", 0, {Panel_packs_change_tab_box, tonumber(prop_ids[3])})
        else
            state_machine.excute("equipment_packs_tab_listview_high_show", 0, nil)
        end
    end
    
end

function EquipmentPacksTabExchange:onInit()
    local csbItem = csb.createNode(string.format(config_csb.equipment.equipment_packs_tab_info, 4))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    for i = 1, 3 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_change_tab_"..i), nil, 
        {
            terminal_name = "equipment_packs_tab_exchange_change_page", 
            terminal_state = 0, 
            page_index = i,
        }, nil, 1) 
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_change_infor"), nil, 
    {
        terminal_name = "equipment_change_infor_window_open", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1) 

    self:updateDraw()
end

function EquipmentPacksTabExchange:onEnterTransitionFinish()
    
end

function EquipmentPacksTabExchange:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow

    self:onInit()
    return self
end

function EquipmentPacksTabExchange:onExit()
    state_machine.remove("equipment_packs_tab_exchange_show")    
    state_machine.remove("equipment_packs_tab_exchange_hide")
    state_machine.remove("equipment_packs_tab_exchange_change_page")
    state_machine.remove("equipment_packs_tab_exchange_update_draw")
end