-- ----------------------------------------------------------------------------------------------------
-- 领旨
-- ----------------------------------------------------------------------------------------------------
NationalWarMilitaryOrder = class("NationalWarMilitaryOrderClass", Window)

-- 打开窗口
local nationalwar_military_order_window_open_terminal = {
    _name = "nationalwar_military_order_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.excute("national_task_window_close",0,"")
        if fwin:find("NationalWarMilitaryOrderClass") == nil then
            fwin:open(NationalWarMilitaryOrder:new():init(), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local nationalwar_military_order_window_close_terminal = {
    _name = "nationalwar_military_order_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("NationalWarMilitaryOrderClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(nationalwar_military_order_window_open_terminal)
state_machine.add(nationalwar_military_order_window_close_terminal)
state_machine.init()

function NationalWarMilitaryOrder:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.task_level = nil --任务阶段

    app.load("client.red_alert.campaign.nationalwar.NationalWarMilitaryOrderCell")

end

function NationalWarMilitaryOrder:onUpdateDraw()
    local root = self.roots[1]
    local ListView_military = ccui.Helper:seekWidgetByName(root,"ListView_military")
    ListView_military:removeAllItems()
    for i,v in pairs(_ED.warfar_get_order_task) do
        local cell = state_machine.excute("national_war_military_order_create_cell",0,{v})
        ListView_military:addChild(cell)
    end

    local Image_military_title_1 = ccui.Helper:seekWidgetByName(root,"Image_military_title_1")
    local Image_military_title_2 = ccui.Helper:seekWidgetByName(root,"Image_military_title_2")
    local Image_military_title_3 = ccui.Helper:seekWidgetByName(root,"Image_military_title_3")
    Image_military_title_1:setVisible(false)
    Image_military_title_2:setVisible(false)
    Image_military_title_3:setVisible(false)
    -- print("========打开阶段",self.task_level)
    local Image_military_title = ccui.Helper:seekWidgetByName(root,"Image_military_title_"..self.task_level)
    Image_military_title:setVisible(true)
    _ED.warfar_get_order_task  = {}

end

function NationalWarMilitaryOrder:onInit()
    local csbItem = csb.createNode(config_csb.campaign.nationalwar.nationalwar_military_order)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_military_ok"), nil, 
    {
        terminal_name = "nationalwar_military_order_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    self:onUpdateDraw()
end

function NationalWarMilitaryOrder:init()
    self.task_level = _ED.warfar_get_order_task_level
    self:onInit()
    return self
end


function NationalWarMilitaryOrder:onExit()

end


