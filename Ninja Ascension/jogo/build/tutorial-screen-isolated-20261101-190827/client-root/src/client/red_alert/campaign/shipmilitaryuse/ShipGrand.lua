-----------------------------
-- 押镖劫镖战报
-----------------------------
ShipGrand = class("ShipGrandClass", Window)

local ship_grand_window_open_terminal = {
    _name = "ship_grand_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("ShipGrandClass")
        if nil == _Window then
            fwin:open(ShipGrand:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local ship_grand_window_close_terminal = {
    _name = "ship_grand_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ShipGrandClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(ship_grand_window_open_terminal)
state_machine.add(ship_grand_window_close_terminal)
state_machine.init()

function ShipGrand:ctor()
    self.super:ctor()
    self.roots = {}

    self._chooseState = -1
    self._info_data = {}

    app.load("client.red_alert.cells.campaign.shipmilitaryuse.ship_grand_cell")

    local function init_ship_grand_terminal()
        local ship_grand_change_state_terminal = {
            _name = "ship_grand_change_state",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            response.node._info_data[""..params._datas.state] = _ED.city_resource_battle_report
                            response.node:onUpdateDraw(params._datas.state)
                        end
                    end
                end
                if instance._chooseState == params._datas.state then
                    local Button_right1 = ccui.Helper:seekWidgetByName(instance.roots[1], "Button_right1")
                    local Button_right2 = ccui.Helper:seekWidgetByName(instance.roots[1], "Button_right2")
                    if instance._chooseState == 1 then
                        Button_right1:setHighlighted(true)
                        Button_right2:setHighlighted(false)
                    else
                        Button_right1:setHighlighted(false)
                        Button_right2:setHighlighted(true)
                    end
                    return
                end
                _ED.city_resource_battle_report = {}
                if params._datas.state == 1 then
                    protocol_command.battlefield_report_get.param_list = battle_enum._fight_type._fight_type_19
                else
                    protocol_command.battlefield_report_get.param_list = battle_enum._fight_type._fight_type_19 + 1000
                end
                if instance._info_data[""..params._datas.state] ~= nil then
                    instance:onUpdateDraw(params._datas.state)
                else
                    NetworkManager:register(protocol_command.battlefield_report_get.code, nil, nil, nil, instance, responseCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(ship_grand_change_state_terminal)
        state_machine.init()
    end
    init_ship_grand_terminal()
end

function ShipGrand:onUpdateDraw(changeState)
    local root = self.roots[1]
    local Button_right1 = ccui.Helper:seekWidgetByName(root, "Button_right1")
    local Button_right2 = ccui.Helper:seekWidgetByName(root, "Button_right2")
    if changeState == 1 then
        Button_right1:setHighlighted(true)
        Button_right2:setHighlighted(false)
    else
        Button_right1:setHighlighted(false)
        Button_right2:setHighlighted(true)
    end

    if changeState == self._chooseState then
        return
    end
    self._chooseState = changeState
    local ListView_26 = ccui.Helper:seekWidgetByName(root,"ListView_26")
    ListView_26:removeAllItems()

    local finish_cells = {}
    finish_cells = self._info_data[""..self._chooseState]
    local function sortfunction( a,b )
        return tonumber(a.time) > tonumber(b.time)
    end
    table.sort( finish_cells, sortfunction )
    for k,v in pairs(finish_cells) do
        local cell = state_machine.excute("ship_grand_create_cell", 0, {k, self._chooseState, v})
        ListView_26:addChild(cell)
    end
    ListView_26:requestRefreshView()
    ListView_26:jumpToTop()
end

function ShipGrand:onEnterTransitionFinish()

end

function ShipGrand:onInit( )
    local csbItem = csb.createNode(config_csb.big_map.map_rattling_battle_field)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "ship_grand_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_right1"), nil, 
    {
        terminal_name = "ship_grand_change_state", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        state = 1,
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_right2"), nil, 
    {
        terminal_name = "ship_grand_change_state", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        state = 2,
    }, nil, 0)
    
    state_machine.excute("ship_grand_change_state", 0, {_datas = {state = 2}})
end

function ShipGrand:init(params)
    self:onInit()
    return self
end

function ShipGrand:onExit()
    state_machine.remove("ship_grand_change_state")
end
