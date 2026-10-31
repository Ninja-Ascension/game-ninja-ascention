-----------------------------
-- 战报
-----------------------------
MapRattlingBattleField = class("MapRattlingBattleFieldClass", Window)

local map_rattle_battle_field_window_open_terminal = {
    _name = "map_rattle_battle_field_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("MapRattlingBattleFieldClass")
        app.load("client.red_alert_time.battle.battle_enum")
        if nil == _Window then
            local function responseCallback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    local result = _ED.city_resource_battle_report
                    _ED.city_resource_battle_report = {}
                    fwin:open(MapRattlingBattleField:new():init(result), fwin._ui)
                end
            end

            --先请求防守的数据
            protocol_command.battlefield_report_get.param_list = battle_enum._fight_type._fight_type_23 + 1000
            NetworkManager:register(protocol_command.battlefield_report_get.code, nil, nil, nil, self, responseCallback, false, nil)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local map_rattle_battle_field_window_close_terminal = {
    _name = "map_rattle_battle_field_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("MapRattlingBattleFieldClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(map_rattle_battle_field_window_open_terminal)
state_machine.add(map_rattle_battle_field_window_close_terminal)
state_machine.init()

function MapRattlingBattleField:ctor()
    self.super:ctor()
    self.roots = {}

    self._chooseIndex = -1
    self._info_data = {}

    self.listview = nil
    self.listview_poy = nil

    -- load lua file
    app.load("client.red_alert_time.cells.big_map.map_rattling_battle_field_cell")

    local function init_map_rattle_battle_field_terminal()
        local map_rattle_battle_field_change_state_terminal = {
            _name = "map_rattle_battle_field_change_state",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- local function responseCallback(response)
                --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                --         if response.node ~= nil and response.node.roots ~= nil then
                --             response.node._info_data[""..params._datas.state] = _ED.city_resource_battle_report
                --             response.node:onUpdateDraw(params._datas.state)
                --         end
                --     end
                -- end
                -- if instance._chooseIndex == params._datas.state then
                --     local Button_right1 = ccui.Helper:seekWidgetByName(instance.roots[1], "Button_right1")
                --     local Button_right2 = ccui.Helper:seekWidgetByName(instance.roots[1], "Button_right2")
                --     if changeState == 1 then
                --         Button_right1:setHighlighted(true)
                --         Button_right2:setHighlighted(false)
                --     else
                --         Button_right1:setHighlighted(false)
                --         Button_right2:setHighlighted(true)
                --     end
                --     return
                -- end
                -- _ED.city_resource_battle_report = {}
                -- if instance._chooseIndex == 1 then
                --     protocol_command.battlefield_report_get.param_list = battle_enum._fight_type._fight_type_23
                -- else
                --     protocol_command.battlefield_report_get.param_list = battle_enum._fight_type._fight_type_23 + 1000
                -- end
                -- if instance._info_data[""..instance._chooseIndex] ~= nil then
                    instance:onUpdateDraw(params._datas.state)
                    if instance ~= nil and instance.roots ~= nil and instance.listview ~= nil then
                        instance.listview:jumpToTop()
                        instance.listview:getInnerContainer():setPositionY(instance.listview:getInnerContainer():getPositionY() - 1)
                        instance.listview:requestRefreshView()
                    end
                -- else
                --     NetworkManager:register(protocol_command.battlefield_report_get.code, nil, nil, nil, instance, responseCallback, false, nil)
                -- end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(map_rattle_battle_field_change_state_terminal)
        state_machine.init()
    end
    init_map_rattle_battle_field_terminal()
end

function MapRattlingBattleField:onUpdateDraw(changeState)
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
    self.listview = ccui.Helper:seekWidgetByName(root,"ListView_26")
    self.listview:removeAllItems()

    local finish_cells = {}
    finish_cells = self._info_data[""..self._chooseState] 
    local function sortfunction( a,b )
        return tonumber(a.time) > tonumber(b.time)
    end
    table.sort( finish_cells, sortfunction )
    for k,v in pairs(finish_cells) do
        local cell = state_machine.excute("map_rattling_battle_field_create_cell", 0, {k, self._chooseState, v})
        self.listview:addChild(cell)
    end
    self.listview:requestRefreshView()
    self.listview:jumpToTop()

    self.listview_poy = self.listview:getInnerContainer():getPositionY()
    self.listview_poy = -1
end

function MapRattlingBattleField:onUpdate(dt)
    if self.listview ~= nil then
        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
        if self.listview_poy == posY then
            return
        end
        self.listview_poy = posY
        local items = self.listview:getItems()
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

function MapRattlingBattleField:onEnterTransitionFinish()

end

function MapRattlingBattleField:onInit( )
    local csbItem = csb.createNode(config_csb.big_map.map_rattling_battle_field)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "map_rattle_battle_field_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_right1"), nil, 
    {
        terminal_name = "map_rattle_battle_field_change_state", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        state = 1,
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_right2"), nil, 
    {
        terminal_name = "map_rattle_battle_field_change_state", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        state = 2,
    }, nil, 0)

    --请求进攻的数据
    local function responseCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil then
                response.node._info_data["1"] = _ED.city_resource_battle_report
            end
        end
    end
    protocol_command.battlefield_report_get.param_list = battle_enum._fight_type._fight_type_23
    NetworkManager:register(protocol_command.battlefield_report_get.code, nil, nil, nil, self, responseCallback, false, nil)

    --默认显示防守
	state_machine.excute("map_rattle_battle_field_change_state", 0, {_datas = {state = 2}})
end

function MapRattlingBattleField:init(params)
    self._info_data["2"] = params
    self:onInit()
    return self
end

function MapRattlingBattleField:onExit()
    state_machine.remove("map_rattle_battle_field_change_state")
end
