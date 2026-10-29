--------------------------------------------------------------------------------------------------------------
--  说明：守卫战战斗记录
--------------------------------------------------------------------------------------------------------------
GuardBattleRecord = class("GuardBattleRecordClass", Window)

--打开界面
local guard_battle_record_window_open_terminal = {
    _name = "guard_battle_record_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)        
        if fwin:find("GuardBattleRecordClass") == nil then
            fwin:open(GuardBattleRecord:new():init(), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local guard_battle_record_window_close_terminal = {
    _name = "guard_battle_record_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("GuardBattleRecordClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(guard_battle_record_window_open_terminal)
state_machine.add(guard_battle_record_window_close_terminal)
state_machine.init()

function GuardBattleRecord:ctor()
    self.super:ctor()
    self.roots = {}

    self._current_page = 0
    self._listview_tab = {}

    app.load("client.red_alert_time.cells.legion.legion_hegemony_fighting_cell")

    local function init_guard_battle_record_terminal()
        local guard_battle_record_change_page_terminal = {
            _name = "guard_battle_record_change_page",
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

        local guard_battle_record_update_all_terminal = {
            _name = "guard_battle_record_update_all",
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

        -- 刷新界面
        local guard_battle_record_update_draw_terminal = {
            _name = "guard_battle_record_update_draw",
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

        -- 显示战斗结果
        local guard_battle_record_show_result_info_terminal = {
            _name = "guard_battle_record_show_result_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local listview = self._listview_tab["2"]
                if listview ~= nil then
                    state_machine.excute("guard_battle_record_listview_show_result_info", 0, listview)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        state_machine.add(guard_battle_record_change_page_terminal)   
        state_machine.add(guard_battle_record_update_all_terminal)   
        state_machine.add(guard_battle_record_update_draw_terminal)   
        state_machine.add(guard_battle_record_show_result_info_terminal)   
        state_machine.init()
    end
    init_guard_battle_record_terminal()
end

function GuardBattleRecord:updateReport( ... )
    for k,v in pairs(self._listview_tab) do
        state_machine.excute("guard_battle_record_listview_add_report_cell", 0, v)
    end
end

function GuardBattleRecord:updateReportAll( ... )
    for k,v in pairs(self._listview_tab) do
        state_machine.excute("guard_battle_record_listview_update_draw", 0, v)
    end
end


function GuardBattleRecord:changeSelectPage( page )
    local root = self.roots[1]
    local Panel_expedition_record = ccui.Helper:seekWidgetByName(root, "Panel_expedition_record")
    local Button_build = ccui.Helper:seekWidgetByName(root, "Button_build")
    local Button_introduce = ccui.Helper:seekWidgetByName(root, "Button_introduce")
    Button_build:setHighlighted(false)
    Button_introduce:setHighlighted(false)
    if page == 1 then
        Button_build:setHighlighted(true)
    elseif page == 2 then
        Button_introduce:setHighlighted(true)
    end
    if page == self._current_page then
        return
    end
    self._current_page = page

    for k, v in pairs(self._listview_tab) do
        state_machine.excute("guard_battle_record_listview_window_hide", 0, v)
    end
    self._panel_listview = Panel_expedition_record
    if self._listview_tab[""..page] == nil then
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                    for k, v in pairs(response.node._listview_tab) do
                        state_machine.excute("guard_battle_record_listview_window_hide", 0, v)
                    end
                    local listview = state_machine.excute("guard_battle_record_listview_window_open",0,{response.node._panel_listview, page})
                    response.node._listview_tab[""..page] = listview
                end
            end
        end
        if page == 1                     -- 个人记录战况
            -- and (_ED.city_resource_battle_report == nil or _ED.city_resource_battle_report[209] == nil) 
            then
            protocol_command.battlefield_report_get.param_list = 209
            NetworkManager:register(protocol_command.battlefield_report_get.code, nil, nil, nil, self, responseCallback, false, nil)
        elseif page == 2                 -- 全服记录战况
            -- and (_ED.city_resource_battle_report == nil or _ED.city_resource_battle_report[10006] == nil) 
            then
            protocol_command.battlefield_report_get.param_list = 10006
            NetworkManager:register(protocol_command.battlefield_report_get.code, nil, nil, nil, self, responseCallback, false, nil)
        else
            local listview = state_machine.excute("guard_battle_record_listview_window_open",0,{self._panel_listview, page})
            self._listview_tab[""..page] = listview
        end
    else
        state_machine.excute("guard_battle_record_listview_window_show", 0, self._listview_tab[""..page])  
    end 
end

function GuardBattleRecord:onInit()
    local csbItem = csb.createNode(config_csb.campaign.guard_battle_record)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_expedition_record_close"), nil, 
    {
        terminal_name = "guard_battle_record_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_build"), nil, 
    {
        terminal_name = "guard_battle_record_change_page", 
        terminal_state = 0, 
        touch_black = true,
        _page = 1,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_introduce"), nil, 
    {
        terminal_name = "guard_battle_record_change_page", 
        terminal_state = 0, 
        touch_black = true,
        _page = 2,
    }, nil, 1)

    self:changeSelectPage(2)
end

function GuardBattleRecord:onEnterTransitionFinish()

end

function GuardBattleRecord:init()
    self:onInit()
    return self
end

function GuardBattleRecord:onExit()
    state_machine.remove("guard_battle_record_change_page")
    state_machine.remove("guard_battle_record_update_all")
    state_machine.remove("guard_battle_record_update_draw")
    state_machine.remove("guard_battle_record_show_result_info")
end