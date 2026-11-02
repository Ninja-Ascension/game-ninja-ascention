-------------------------------------------------------------------------------------
--  居所战报界面
-------------------------------------------------------------------------------------
PersonalFightBattleFiled = class("PersonalFightBattleFiledClass", Window)

local personal_fight_battle_field_window_open_terminal = {
    _name = "personal_fight_battle_field_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("PersonalFightBattleFiledClass")
        app.load("client.red_alert_time.battle.battle_enum")
        if nil == _Window then
            local function responseCallback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    local result = _ED.city_resource_battle_report
                    _ED.personal_defender_battle_report_list = {}
                    for i, data in pairs(_ED.city_resource_battle_report) do
                        if tonumber(data.result) == 0 then
                            table.insert(_ED.personal_defender_battle_report_list, data)
                        end
                    end
                    fwin:open(PersonalFightBattleFiled:new():init(result), fwin._ui)
                end
            end
            protocol_command.battlefield_report_get.param_list = battle_enum._fight_type._fight_type_105 + 1000
            NetworkManager:register(protocol_command.battlefield_report_get.code, nil, nil, nil, nil, responseCallback, false, nil)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local personal_fight_battle_field_window_close_terminal = {
    _name = "personal_fight_battle_field_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PersonalFightBattleFiledClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(personal_fight_battle_field_window_open_terminal)
state_machine.add(personal_fight_battle_field_window_close_terminal)
state_machine.init()

function PersonalFightBattleFiled:ctor()
    self.super:ctor()
    self.roots = {}

    self._chooseState = -1              --选择查看的战报，1：攻击，2：防守
    self._info_data = {}                --战报数据

    self._listPanel = {}

    -- load lua file
    app.load("client.red_alert_time.personal_fight.PersonalFightResult")
    app.load("client.red_alert_time.personal_fight.PersonalFightBattleFieldListView")
    app.load("client.red_alert_time.cells.personal_fight.personal_fight_battle_field_cell")

    local function init_personal_fight_battle_field_terminal()
        local personal_fight_battle_field_change_state_terminal = {
            _name = "personal_fight_battle_field_change_state",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDraw(params._datas.state)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(personal_fight_battle_field_change_state_terminal)
        state_machine.init()
    end
    init_personal_fight_battle_field_terminal()
end

function PersonalFightBattleFiled:onUpdateDraw(changeState)
    local root = self.roots[1]
    local Button_right1 = ccui.Helper:seekWidgetByName(root, "Button_right1")
    local Button_right2 = ccui.Helper:seekWidgetByName(root, "Button_right2")
    local Panel_listview = ccui.Helper:seekWidgetByName(root, "Panel_listview")
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

    for i,listview in pairs(self._listPanel) do
        listview:setVisible(false)
    end
    if self._listPanel[""..self._chooseState] == nil then
        local finish_cells = {}
        finish_cells = self._info_data[""..self._chooseState] 
        local function sortfunction( a,b )
            return tonumber(a.time) > tonumber(b.time)
        end
        table.sort(finish_cells, sortfunction)
        local listview = state_machine.excute("personal_fighting_battle_field_listview_window_open",0,{Panel_listview, finish_cells, self._chooseState})
        self._listPanel[""..self._chooseState] = listview
        self._listPanel[""..self._chooseState]:setVisible(true)   
    else
        self._listPanel[""..self._chooseState]:setVisible(true)     
    end
end

function PersonalFightBattleFiled:onEnterTransitionFinish()

end

function PersonalFightBattleFiled:onInit( )
    local csbItem = csb.createNode(config_csb.big_map.map_rattling_battle_field)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "personal_fight_battle_field_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_right1"), nil, 
    {
        terminal_name = "personal_fight_battle_field_change_state", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        state = 1,
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_right2"), nil, 
    {
        terminal_name = "personal_fight_battle_field_change_state", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        state = 2,
    }, nil, 0)

    local function responseCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                response.node._info_data["1"] = _ED.city_resource_battle_report
            end
        end
    end
    protocol_command.battlefield_report_get.param_list = battle_enum._fight_type._fight_type_105
    NetworkManager:register(protocol_command.battlefield_report_get.code, nil, nil, nil, self, responseCallback, false, nil)
    
    state_machine.excute("personal_fight_battle_field_change_state", 0, {_datas = {state = 2}})
end

function PersonalFightBattleFiled:init(params)
    self._info_data["2"] = params
    self:onInit()
    return self
end

function PersonalFightBattleFiled:onExit()
    state_machine.remove("personal_fight_battle_field_change_state")
end
