--------------------------------------------------------------------------------------------------------------
--  说明：坦克仓库
--------------------------------------------------------------------------------------------------------------
BuildUpTankWarehouse = class("BuildUpTankWarehouseClass", Window)

--打开界面
local build_up_tank_warehouse_window_open_terminal = {
    _name = "build_up_tank_warehouse_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("BuildUpTankWarehouseClass") == nil then
            local _win = BuildUpTankWarehouse:new()
            _win:init()
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local build_up_tank_warehouse_window_close_terminal = {
    _name = "build_up_tank_warehouse_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("BuildUpTankWarehouseClass"))
        -- 校验开启教学事件
        state_machine.excute("main_window_check_mission", 0, 0)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(build_up_tank_warehouse_window_open_terminal)
state_machine.add(build_up_tank_warehouse_window_close_terminal)
state_machine.init()

function BuildUpTankWarehouse:ctor()
    self.super:ctor()
    self.roots = {}

    local function init_build_up_tank_warehouse_terminal()

    end
    init_build_up_tank_warehouse_terminal()
end

function BuildUpTankWarehouse:onUpdateDraw()
    local root = self.roots[1]

end

function BuildUpTankWarehouse:onInit()
    local csbItem = csb.createNode(config_csb.build_up.build_up_tank_warehouse)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)   

    self.__check_covers = true
    root.__cwindow = self
    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "build_up_tank_warehouse_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    self:onUpdateDraw()
end

function BuildUpTankWarehouse:onEnterTransitionFinish()

end

function BuildUpTankWarehouse:init()
    self:setTouchEnabled(true)
    self:onInit()
    return self
end

function BuildUpTankWarehouse:onExit()

end