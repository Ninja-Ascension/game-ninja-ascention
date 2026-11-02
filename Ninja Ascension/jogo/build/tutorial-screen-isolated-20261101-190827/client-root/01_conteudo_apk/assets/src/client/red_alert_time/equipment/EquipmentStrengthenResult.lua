--------------------------------------------------------------------------------------------------------------
--  装备强化十次结果
--------------------------------------------------------------------------------------------------------------
EquipmentStrengthenResult = class("EquipmentStrengthenResultClass", Window)

--打开界面
local equipment_strengthen_result_window_open_terminal = {
    _name = "equipment_strengthen_result_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("EquipmentStrengthenResultClass") == nil then
            fwin:open(EquipmentStrengthenResult:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local equipment_strengthen_result_window_close_terminal = {
    _name = "equipment_strengthen_result_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("EquipmentStrengthenResultClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(equipment_strengthen_result_window_open_terminal)
state_machine.add(equipment_strengthen_result_window_close_terminal)
state_machine.init()

function EquipmentStrengthenResult:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    app.load("client.red_alert_time.cells.equipment.equipment_strengthen_result_cell")
    
end

--初始化界面
function EquipmentStrengthenResult:onInit()
    local csbItem = csb.createNode(config_csb.equipment.equipment_strengthen_ten_infor)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_strengthen_ten_close"), nil, 
    {
        terminal_name = "equipment_strengthen_result_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "equipment_strengthen_result_window_close", 
        terminal_state = 0, 
    }, nil, 3)  

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_strengthen_ten_sure "), nil, 
    {
        terminal_name = "equipment_strengthen_result_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    self:onUpdateDraw()
end

function EquipmentStrengthenResult:onUpdateDraw()
    local root = self.roots[1]
    local ListView_strengthen_ten = ccui.Helper:seekWidgetByName(root, "ListView_strengthen_ten")
    ListView_strengthen_ten:jumpToTop()
    ListView_strengthen_ten:removeAllItems()

    local last_equipment = self._current_equipment

    for k,v in pairs(_ED.equip_strength_result) do
        local cell = state_machine.excute("equipment_strengthen_result_cell_create", 0, {k, v, last_equipment})
        ListView_strengthen_ten:addChild(cell)

        if tonumber(v.result) == 0 then
            last_equipment = v
        end
    end
end

--初始化
function EquipmentStrengthenResult:init(params)
    self._current_equipment = params
    self:onInit()
    return self
end

--移除状态机
function EquipmentStrengthenResult:onExit()
end
