--------------------------------------------------------------------------------------------------------------
--  说明：军团城市战报
--------------------------------------------------------------------------------------------------------------
LegionCityRecord = class("LegionCityRecordClass", Window)

--打开界面
local legion_city_record_open_terminal = {
    _name = "legion_city_record_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if _ED.city_resource_battle_report ~= nil then
            _ED.city_resource_battle_report[210] = nil
            _ED.city_resource_battle_report[10007] = nil
        end
        local function responseReportCallback2(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if fwin:find("LegionCityRecordClass") == nil then
                    fwin:open(LegionCityRecord:new():init(params), fwin._ui)
                end
            end
        end

        local function responseReportCallback1(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                protocol_command.battlefield_report_get.param_list = 10007
                NetworkManager:register(protocol_command.battlefield_report_get.code, nil, nil, nil, nil, responseReportCallback2, false, nil)
            end
        end
        protocol_command.battlefield_report_get.param_list = 210
        NetworkManager:register(protocol_command.battlefield_report_get.code, nil, nil, nil, nil, responseReportCallback1, false, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local legion_city_record_close_terminal = {
    _name = "legion_city_record_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LegionCityRecordClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(legion_city_record_open_terminal)
state_machine.add(legion_city_record_close_terminal)
state_machine.init()

function LegionCityRecord:ctor()
    self.super:ctor()
    self.roots = {}

    self._current_page = 0
    self._list_tables = {}

    app.load("client.red_alert_time.legion.LegionCityRecordListView")
    app.load("client.red_alert_time.cells.legion.legion_city_record_cell")

    local function init_legion_city_record_terminal()
        local legion_city_record_change_page_terminal = {
            _name = "legion_city_record_change_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:changeSelectPage(tonumber(params._datas._page))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_city_record_change_page_terminal)   
        state_machine.init()
    end
    init_legion_city_record_terminal()
end

function LegionCityRecord:changeSelectPage( page )
    local root = self.roots[1]
    local Panel_legion_city_record_tab = ccui.Helper:seekWidgetByName(root, "Panel_legion_city_record_tab")

    local Button_legion_city_legion_record = ccui.Helper:seekWidgetByName(root, "Button_legion_city_legion_record")
    local Button_legion_city_legion_me_record = ccui.Helper:seekWidgetByName(root, "Button_legion_city_legion_me_record")
    Button_legion_city_legion_record:setHighlighted(false)
    Button_legion_city_legion_me_record:setHighlighted(false)
    if page == 1 then
        Button_legion_city_legion_record:setHighlighted(true)
    else
        Button_legion_city_legion_me_record:setHighlighted(true)
    end
    if page == self._current_page then
        return
    end
    self._current_page = page

    for k, v in pairs(self._list_tables) do
        state_machine.excute("legion_city_record_liseview_hide", 0, {v})
    end

    if self._list_tables[""..self._current_page] == nil then
        self._list_tables[""..self._current_page] = state_machine.excute("legion_city_record_liseview_open", 0, {Panel_legion_city_record_tab, self._current_page})
    else
        state_machine.excute("legion_city_record_liseview_show", 0, {self._list_tables[""..self._current_page]})
    end
end

function LegionCityRecord:onInit(params)
    local csbItem = csb.createNode(config_csb.legion.legion_city_record)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_city_record_close"), nil, 
    {
        terminal_name = "legion_city_record_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)      

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_city_legion_record"), nil, 
    {
        terminal_name = "legion_city_record_change_page", 
        terminal_state = 0, 
        _page = 1,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_city_legion_me_record"), nil, 
    {
        terminal_name = "legion_city_record_change_page", 
        terminal_state = 0, 
        _page = 2,
    }, nil, 1)

    self:changeSelectPage(1)
end

function LegionCityRecord:onEnterTransitionFinish()

end

function LegionCityRecord:init(params)
    self:setTouchEnabled(true)
    self:onInit(params)
    return self
end

function LegionCityRecord:onExit()
    state_machine.remove("legion_city_record_change_page")
end