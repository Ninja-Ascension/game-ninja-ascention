--------------------------------------------------------------------------------------------------------------
--  配件仓库
--------------------------------------------------------------------------------------------------------------
EquipmentPacksTab = class("EquipmentPacksTabClass", Window)

local equipment_packs_tab_window_open_terminal = {
    _name = "equipment_packs_tab_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local list_view = EquipmentPacksTab:new():init(params)
        fwin:open(list_view)
        return list_view
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(equipment_packs_tab_window_open_terminal)
state_machine.init()

function EquipmentPacksTab:ctor()
    self.super:ctor()
    self.roots = {}

    self._last_page_index = 1
    -- 配件
    self._fitting_panel = nil
    -- 碎片
    self._chip_panel = nil
    -- 材料
    self._data_panel = nil
    -- 兑换
    self._exchange_panel = nil

    app.load("client.red_alert_time.cells.equipment.equipment_parts_change_cell")
    app.load("client.red_alert_time.cells.equipment.equipment_packs_tab_cell")
    -- Initialize equipment_packs_tab state machine.
    local function init_equipment_packs_tab_terminal()
        -- 切换页面
        local equipment_packs_tab_change_page_terminal = {
            _name = "equipment_packs_tab_change_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance._last_page_index = params._datas.page_index
                instance:updateDraw()
                if instance._last_page_index == 1 then
                    _ED.push_user_have_equipment_count = 0
                elseif instance._last_page_index == 2 then
                    _ED.push_user_equipment_chip_count = 0
                elseif instance._last_page_index == 3 then
                    _ED.push_user_equipment_data_count = 0
                end
                state_machine.excute("notification_center_update", 0, "push_notification_equipment_packs")
                state_machine.excute("notification_center_update", 0, "push_notification_equipment_pack_fit")
                state_machine.excute("notification_center_update", 0, "push_notification_equipment_pack_chip")
                state_machine.excute("notification_center_update", 0, "push_notification_equipment_pack_data")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local equipment_packs_tab_update_equipment_number_terminal = {
            _name = "equipment_packs_tab_update_equipment_number",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local number = params
                instance:updateEquipmentNumber(number)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(equipment_packs_tab_change_page_terminal)
        state_machine.add(equipment_packs_tab_update_equipment_number_terminal)
        state_machine.init()
    end
    
    -- call func equipment_packs_tab create state machine.
    init_equipment_packs_tab_terminal()

end

function EquipmentPacksTab:updateEquipmentNumber(number)
    local root = self.roots[1]
    local Button_equip_packs_1 = ccui.Helper:seekWidgetByName(root, "Button_equip_packs_1")
    Button_equip_packs_1:setTitleText(string.format(red_alert_time_str[243], number))
end

function EquipmentPacksTab:updateDraw()
    local root = self.roots[1]
    -- if page_index == self._last_page_index then
    --     return
    -- end
    for i = 1, 4 do
        local Button_equip_packs = ccui.Helper:seekWidgetByName(root, "Button_equip_packs_"..i)
        if i == self._last_page_index then
            Button_equip_packs:setHighlighted(true)
            Button_equip_packs:setTouchEnabled(false)
        else
            Button_equip_packs:setHighlighted(false)
            Button_equip_packs:setTouchEnabled(true)
        end
    end
    local Panel_equip_packs_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_equip_packs_tab_box")
    state_machine.excute("equipment_packs_tab_fitting_hide", 0, nil)
    state_machine.excute("equipment_packs_tab_chip_hide", 0, nil)
    state_machine.excute("equipment_packs_tab_data_hide", 0, nil)
    state_machine.excute("equipment_packs_tab_exchange_hide", 0, nil)

    if self._last_page_index == 1 then
        if self._fitting_panel == nil then
            self._fitting_panel = state_machine.excute("equipment_packs_tab_fitting_window_open", 0, {Panel_equip_packs_tab_box})
        else
            state_machine.excute("equipment_packs_tab_fitting_show", 0, nil)
        end
    elseif self._last_page_index == 2 then
        if self._chip_panel == nil then
            self._chip_panel = state_machine.excute("equipment_packs_tab_chip_window_open", 0, {Panel_equip_packs_tab_box})
        else
            state_machine.excute("equipment_packs_tab_chip_show", 0, nil)
        end
    elseif self._last_page_index == 3 then
        if self._data_panel == nil then
            self._data_panel = state_machine.excute("equipment_packs_tab_data_window_open", 0, {Panel_equip_packs_tab_box})
        else
            state_machine.excute("equipment_packs_tab_data_show", 0, nil)
        end
    else
        if self._exchange_panel == nil then
            self._exchange_panel = state_machine.excute("equipment_packs_tab_exchange_window_open", 0, {Panel_equip_packs_tab_box})
        else
            state_machine.excute("equipment_packs_tab_exchange_show", 0, nil)
        end
    end
end

function EquipmentPacksTab:onInit()
    local csbItem = csb.createNode(config_csb.equipment.equipment_packs_tab)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    for i = 1, 4 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_equip_packs_"..i), nil, 
        {
            terminal_name = "equipment_packs_tab_change_page", 
            terminal_state = 0, 
            page_index = i,
        }, nil, 1) 
    end

    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_equipment_pack_fit",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_equip_packs_1"),
    _invoke = nil,
    _interval = 0.2,})

    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_equipment_pack_chip",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_equip_packs_2"),
    _invoke = nil,
    _interval = 0.2,})

    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_equipment_pack_data",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_equip_packs_3"),
    _invoke = nil,
    _interval = 0.2,})

    self:updateDraw()
    _ED.push_user_have_equipment_count = 0
end

function EquipmentPacksTab:onEnterTransitionFinish()
    
end

function EquipmentPacksTab:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow

    self:onInit()
    return self
end

function EquipmentPacksTab:onExit()
    state_machine.remove("equipment_packs_tab_change_page")
    state_machine.remove("equipment_packs_tab_update_equipment_number")
end