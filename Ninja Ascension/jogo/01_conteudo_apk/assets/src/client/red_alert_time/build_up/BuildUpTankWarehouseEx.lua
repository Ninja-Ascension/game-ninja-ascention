--------------------------------------------------------------------------------------------------------------
--  说明：坦克仓库
--------------------------------------------------------------------------------------------------------------
BuildUpTankWarehouseEx = class("BuildUpTankWarehouseExClass", Window)

--打开界面
local build_up_tank_warehouse_ex_window_open_terminal = {
    _name = "build_up_tank_warehouse_ex_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("BuildUpTankWarehouseExClass") then
            fwin:open(BuildUpTankWarehouseEx:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local build_up_tank_warehouse_ex_window_close_terminal = {
    _name = "build_up_tank_warehouse_ex_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("BuildUpTankWarehouseExClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(build_up_tank_warehouse_ex_window_open_terminal)
state_machine.add(build_up_tank_warehouse_ex_window_close_terminal)
state_machine.init()

function BuildUpTankWarehouseEx:ctor()
    self.super:ctor()
    self.roots = {}

    self._current_page = 0

    self._panel_tables = {}

    app.load("client.red_alert_time.build_up.BuildUpTankWarehouseListview")
    app.load("client.red_alert_time.cells.build_up.build_up_tank_warehouse_list_cell")
    app.load("client.red_alert_time.cells.build_up.build_up_tank_warehouse_cell")

    local function init_build_up_tank_warehouse_ex_terminal()
        local build_up_tank_warehouse_ex_change_page_terminal = {
            _name = "build_up_tank_warehouse_ex_change_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:changeSelectPage(tonumber(params._datas.page))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local build_up_tank_warehouse_ex_update_draw_terminal = {
            _name = "build_up_tank_warehouse_ex_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                for k, v in pairs(instance._panel_tables) do
                    state_machine.excute("build_up_tank_warehouse_listview_update", 0, v)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(build_up_tank_warehouse_ex_change_page_terminal)    
        state_machine.add(build_up_tank_warehouse_ex_update_draw_terminal)    
        state_machine.init()
    end
    init_build_up_tank_warehouse_ex_terminal()
end

function BuildUpTankWarehouseEx:changeSelectPage( page )
    local root = self.roots[1]
    local Panel_list = ccui.Helper:seekWidgetByName(root, "Panel_list")
    local Button_conventional_forces = ccui.Helper:seekWidgetByName(root, "Button_conventional_forces")
    local Button_legendary_troops = ccui.Helper:seekWidgetByName(root, "Button_legendary_troops")
    Button_conventional_forces:setHighlighted(false)
    Button_legendary_troops:setHighlighted(false)
    if page == 1 then
        Button_conventional_forces:setHighlighted(true)
    else
        Button_legendary_troops:setHighlighted(true)
    end
    if page == self._current_page then
        return
    end
    self._current_page = page
    for k, v in pairs(self._panel_tables) do
        state_machine.excute("build_up_tank_warehouse_listview_hide", 0, v)
    end

    if self._panel_tables[""..self._current_page] == nil then
        self._panel_tables[""..self._current_page] = state_machine.excute("build_up_tank_warehouse_listview_window_open", 0, {Panel_list, self._current_page})
    else
        state_machine.excute("build_up_tank_warehouse_listview_show", 0, self._panel_tables[""..self._current_page])
    end
end

function BuildUpTankWarehouseEx:onInit(params)
    local csbItem = csb.createNode(config_csb.build_up.build_up_tank_warehouse)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

    self.__check_covers = true
    root.__cwindow = self
    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "build_up_tank_warehouse_ex_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_conventional_forces"), nil, 
    {
        terminal_name = "build_up_tank_warehouse_ex_change_page", 
        terminal_state = 0, 
        page = 1,
    }, nil, 1)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legendary_troops"), nil, 
    {
        terminal_name = "build_up_tank_warehouse_ex_change_page", 
        terminal_state = 0, 
        page = 2,
    }, nil, 1)

    
    if params ~= nil and params._datas ~= nil and params._datas._page ~= nil then
        self:changeSelectPage(tonumber(params._datas._page))
    else
        self:changeSelectPage(1)
    end
end

function BuildUpTankWarehouseEx:onEnterTransitionFinish()

end

function BuildUpTankWarehouseEx:init(params)
    self:setTouchEnabled(true)
    self:onInit(params)
    return self
end

function BuildUpTankWarehouseEx:onExit()
    state_machine.remove("build_up_tank_warehouse_ex_change_page")
    state_machine.remove("build_up_tank_warehouse_ex_update_draw")
end