-- ------------------------------------------------------------------------------------------------------------
--  说明：配件兑换帮助信息
-- ------------------------------------------------------------------------------------------------------------
EquipmentChangeInfor = class("EquipmentChangeInforClass", Window)

--打开界面
local equipment_change_infor_window_open_terminal = {
    _name = "equipment_change_infor_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("EquipmentChangeInforClass") == nil then
            local _win = EquipmentChangeInfor:new()
            _win:init()
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local equipment_change_infor_window_close_terminal = {
    _name = "equipment_change_infor_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("EquipmentChangeInforClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(equipment_change_infor_window_open_terminal)
state_machine.add(equipment_change_infor_window_close_terminal)
state_machine.init()

function EquipmentChangeInfor:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    
     -- Initialize alert_home state machine.
    local function init_equipment_change_infor_terminal()

    end
    -- call func alert_home create state machine.
    init_equipment_change_infor_terminal()
end

-- 显示信息
function EquipmentChangeInfor:onUpdateDraw()
    local root = self.roots[1]

end

--初始化界面
function EquipmentChangeInfor:onInit()
    local csbItem = csb.createNode(config_csb.equipment.equipment_change_infor)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_res_infor_close"), nil, 
    {
        terminal_name = "equipment_change_infor_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "equipment_change_infor_window_close", 
        terminal_state = 0, 
    }, nil, 3)

    self:onUpdateDraw()
end

--初始化
function EquipmentChangeInfor:init()
    self:onInit()
end

--移除状态机
function EquipmentChangeInfor:onExit()

end