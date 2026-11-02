-- ---------------------------
-- 军团争霸-战报
-- ---------------------------
LegionHegemonyReport = class("LegionHegemonyReportClass", Window)

local legion_hegemony_report_window_open_terminal = {
    _name = "legion_hegemony_report_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = LegionHegemonyReport:new():init(params)
        fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(legion_hegemony_report_window_open_terminal)
state_machine.init()

function LegionHegemonyReport:ctor()
    self.super:ctor()
    self.roots = {}

    self._current_page = 0

    self._listview_tab = {}
    self._panel_listview = nil

    local function init_legion_hegemony_report_terminal()
        -- 显示界面
        local legion_hegemony_report_show_terminal = {
            _name = "legion_hegemony_report_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local legion_hegemony_report_hide_terminal = {
            _name = "legion_hegemony_report_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        -- 刷新界面
        local legion_hegemony_report_update_draw_terminal = {
            _name = "legion_hegemony_report_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:updateReport()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        -- 切换页面
        local legion_hegemony_report_change_page_terminal = {
            _name = "legion_hegemony_report_change_page",
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

        local legion_hegemony_report_update_all_terminal = {
            _name = "legion_hegemony_report_update_all",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:updateReportAll()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_hegemony_report_show_terminal)  
        state_machine.add(legion_hegemony_report_hide_terminal)
        state_machine.add(legion_hegemony_report_update_draw_terminal)
        state_machine.add(legion_hegemony_report_change_page_terminal)
        state_machine.add(legion_hegemony_report_update_all_terminal)
        state_machine.init()
    end
    init_legion_hegemony_report_terminal()
end

function LegionHegemonyReport:onHide()
    self:setVisible(false)
end

function LegionHegemonyReport:onShow()
    self:setVisible(true)
end

function LegionHegemonyReport:updateReport( ... )
    for k,v in pairs(self._listview_tab) do
        state_machine.excute("legion_hegemony_report_listview_add_report_cell", 0, v)
    end
end

function LegionHegemonyReport:updateReportAll( ... )
    for k,v in pairs(self._listview_tab) do
        state_machine.excute("legion_hegemony_report_listview_update_draw", 0, v)
    end
end

function LegionHegemonyReport:changeSelectPage( page )
    local root = self.roots[1]
    local Panel_hegemony_fighting_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_hegemony_fighting_tab_box")
    local Button_hegemony_all_fighting = ccui.Helper:seekWidgetByName(root, "Button_hegemony_all_fighting")
    local Button_hegemony_legion_fighting = ccui.Helper:seekWidgetByName(root, "Button_hegemony_legion_fighting")
    local Button_hegemony_personal_fighting = ccui.Helper:seekWidgetByName(root, "Button_hegemony_personal_fighting")
    Button_hegemony_all_fighting:setHighlighted(false)
    Button_hegemony_legion_fighting:setHighlighted(false)
    Button_hegemony_personal_fighting:setHighlighted(false)
    if page == 1 then
        Button_hegemony_all_fighting:setHighlighted(true)
    elseif page == 2 then
        Button_hegemony_legion_fighting:setHighlighted(true)
    elseif page == 3 then
        Button_hegemony_personal_fighting:setHighlighted(true)
    end
    if page == self._current_page then
        return
    end
    self._current_page = page

    for k, v in pairs(self._listview_tab) do
        state_machine.excute("legion_hegemony_report_listview_window_hide", 0, v)
    end
    self._panel_listview = Panel_hegemony_fighting_tab_box
    if self._listview_tab[""..page] == nil then
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                    for k, v in pairs(response.node._listview_tab) do
                        state_machine.excute("legion_hegemony_report_listview_window_hide", 0, v)
                    end
                    local listview = state_machine.excute("legion_hegemony_report_listview_window_open",0,{response.node._panel_listview, page})
                    response.node._listview_tab[""..page] = listview
                end
            end
        end
        if page == 1                     -- 全服战况
            -- and (_ED.city_resource_battle_report == nil or _ED.city_resource_battle_report[10003] == nil) 
            then
            protocol_command.battlefield_report_get.param_list = 10003
            NetworkManager:register(protocol_command.battlefield_report_get.code, nil, nil, nil, self, responseCallback, false, nil)
        elseif page == 2                 -- 军团战况
            -- and (_ED.city_resource_battle_report == nil or _ED.city_resource_battle_report[10004] == nil) 
            then
            protocol_command.battlefield_report_get.param_list = 10004
            NetworkManager:register(protocol_command.battlefield_report_get.code, nil, nil, nil, self, responseCallback, false, nil)
        elseif page == 3                 -- 个人战况
            -- and (_ED.city_resource_battle_report == nil or _ED.city_resource_battle_report[207] == nil) 
            then
            protocol_command.battlefield_report_get.param_list = 207
            NetworkManager:register(protocol_command.battlefield_report_get.code, nil, nil, nil, self, responseCallback, false, nil)
        else
            local listview = state_machine.excute("legion_hegemony_report_listview_window_open",0,{self._panel_listview, page})
            self._listview_tab[""..page] = listview
        end
    else
        state_machine.excute("legion_hegemony_report_listview_window_show", 0, self._listview_tab[""..page])  
    end 
end

function LegionHegemonyReport:onEnterTransitionFinish()

end

function LegionHegemonyReport:onInit( )
    local csbItem = csb.createNode(string.format(config_csb.legion.legion_hegemony_tab, 2))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hegemony_all_fighting"), nil, 
    {
        terminal_name = "legion_hegemony_report_change_page", 
        terminal_state = 0, 
        _page = 1,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hegemony_legion_fighting"), nil, 
    {
        terminal_name = "legion_hegemony_report_change_page", 
        terminal_state = 0, 
        _page = 2,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hegemony_personal_fighting"), nil, 
    {
        terminal_name = "legion_hegemony_report_change_page", 
        terminal_state = 0, 
        _page = 3,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hegemony_fighting_infor"), nil, 
    {
        terminal_name = "legion_hegemony_help_window_open", 
        terminal_state = 0, 
        touch_black = true,
        infor_type = 2,
    }, nil, 1)

    self:changeSelectPage(1)
end

function LegionHegemonyReport:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow      
    self:onInit()
    return self
end

function LegionHegemonyReport:onExit()
    state_machine.remove("legion_hegemony_report_show")
    state_machine.remove("legion_hegemony_report_hide")
    state_machine.remove("legion_hegemony_report_update_draw")
    state_machine.remove("legion_hegemony_report_change_page")
    state_machine.remove("legion_hegemony_report_update_all")
end
