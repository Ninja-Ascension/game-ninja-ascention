--------------------------------------------------------------------------------------------------------------
--  说明：军团争霸
--------------------------------------------------------------------------------------------------------------
LegionHegemony = class("LegionHegemonyClass", Window)

--打开界面
local legion_hegemony_window_open_terminal = {
	_name = "legion_hegemony_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if _ED.union.union_info == nil 
            or _ED.union.union_info == {} 
            or _ED.union.union_info.union_id == nil 
            or _ED.union.union_info.union_id == "" 
            or tonumber(_ED.union.union_info.union_id) == 0 then
            TipDlg.drawTextDailog(red_alert_time_str[158])
            return
        end

        state_machine.lock("legion_hegemony_window_open", 0, 0)
        local function responseCallback(response)
            state_machine.unlock("legion_hegemony_window_open", 0, 0)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if fwin:find("LegionHegemonyClass") == nil then
                    fwin:open(LegionHegemony:new():init(params), fwin._ui)
                end
            end
        end
        NetworkManager:register(protocol_command.union_craft_init.code, nil, nil, nil, nil, responseCallback, false, nil)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local legion_hegemony_window_close_terminal = {
	_name = "legion_hegemony_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LegionHegemonyClass"))
        _ED.union.union_union_hegemony_rank_list = nil
        NetworkManager:register(protocol_command.union_craft_exit.code, nil, nil, nil, nil, nil, false, nil)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(legion_hegemony_window_open_terminal)
state_machine.add(legion_hegemony_window_close_terminal)
state_machine.init()

function LegionHegemony:ctor()
	self.super:ctor()
	self.roots = {}

    self._current_page = 0
    self._joinPanel = nil
    self._reportPanel = nil
    self._rankPanel = nil
    self._rewardPanel = nil
    self._buttons = {}

    self._last_state = 0

    app.load("client.red_alert_time.legion.LegionHegemonyJoin")
    app.load("client.red_alert_time.legion.LegionHegemonyOtherJoin")
    app.load("client.red_alert_time.legion.LegionHegemonyReport")
    app.load("client.red_alert_time.legion.LegionHegemonyRank")
    app.load("client.red_alert_time.legion.LegionHegemonyReward")
    app.load("client.red_alert_time.legion.LegionHegemonyRankListview")
    app.load("client.red_alert_time.legion.LegionHegemonyReportListview")
    app.load("client.red_alert_time.legion.LegionHegemonyHelp")

    app.load("client.red_alert_time.cells.legion.legion_hegemony_sign_up_cell")
    app.load("client.red_alert_time.cells.legion.legion_hegemony_window_cell")
    app.load("client.red_alert_time.cells.legion.legion_hegemony_rank_cell")
    app.load("client.red_alert_time.cells.legion.legion_hegemony_reward_cell")
    app.load("client.red_alert_time.cells.legion.legion_hegemony_fighting_cell")
    
    local function init_legion_hegemony_terminal()
        local legion_hegemony_change_page_terminal = {
            _name = "legion_hegemony_change_page",
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

        -- 军团争霸状态刷新
        local legion_hegemony_update_state_terminal = {
            _name = "legion_hegemony_update_state",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local current_state = tonumber(params[1])
                if instance._last_state ~= current_state then
                    if instance._last_state == 3 then
                        local function responseCallback(response)
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                state_machine.excute("legion_hegemony_rank_update_list_view", 0, "")
                                state_machine.excute("legion_hegemony_reward_update_list_view", 0, "")
                            end
                        end
                        protocol_command.union_craft_rank_list_get.param_list = ""
                        NetworkManager:register(protocol_command.union_craft_rank_list_get.code, nil, nil, nil, nil, responseCallback, false, nil)
                    end
                    -- 开启新军团争霸，清除上一次数据
                    if (instance._last_state == 0 or instance._last_state == 4) and (current_state ~= 0 and current_state ~= 4) then
                        -- 清除战报信息
                        if _ED.city_resource_battle_report ~= nil then
                            _ED.city_resource_battle_report[10003] = {}
                            _ED.city_resource_battle_report[10004] = {}
                            _ED.city_resource_battle_report[207] = {}
                            state_machine.excute("legion_hegemony_report_update_all", 0, "")
                        end
                        -- 清除报名信息
                        _ED.union.union_hegemony_sign_up_list = {}
                        _ED.union.union_hegemony_sign_up_number = 0
                        -- 清除排行信息
                        _ED.union.union_union_hegemony_rank_list = nil
                        state_machine.excute("legion_hegemony_rank_update_list_view", 0, "")
                        state_machine.excute("legion_hegemony_reward_update_list_view", 0, "")
                    end
                end
                state_machine.excute("legion_hegemony_join_update_draw", 0, nil)
                instance._last_state = current_state
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(legion_hegemony_change_page_terminal)   
        state_machine.add(legion_hegemony_update_state_terminal)   
        state_machine.init()
    end
    init_legion_hegemony_terminal()
end

function LegionHegemony:changeSelectPage( page )
    local root = self.roots[1]
    local Panel_hegemony_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_hegemony_tab_box")
    for k,v in pairs(self._buttons) do
        if k == page then
            v:setHighlighted(true)
        else
            v:setHighlighted(false)
        end
    end
    if page == self._current_page then
        return
    end
    self._current_page = page
    state_machine.excute("legion_hegemony_join_hide", 0, nil)
    state_machine.excute("legion_hegemony_report_hide", 0, nil)
    state_machine.excute("legion_hegemony_rank_hide", 0, nil)
    state_machine.excute("legion_hegemony_reward_hide", 0, nil)
    if page == 1 then
        if self._joinPanel == nil then
            self._joinPanel = state_machine.excute("legion_hegemony_join_window_open", 0, {Panel_hegemony_tab_box})
        else
            state_machine.excute("legion_hegemony_join_show", 0, nil)
        end
    elseif page == 2 then
        if self._reportPanel == nil then
            self._reportPanel = state_machine.excute("legion_hegemony_report_window_open", 0, {Panel_hegemony_tab_box})
        else
            state_machine.excute("legion_hegemony_report_show", 0, nil)
        end
    elseif page == 3 then
        if self._rankPanel == nil then
            self._rankPanel = state_machine.excute("legion_hegemony_rank_window_open", 0, {Panel_hegemony_tab_box})
        else
            state_machine.excute("legion_hegemony_rank_show", 0, nil)
        end
    else
        if self._rewardPanel == nil then
            self._rewardPanel = state_machine.excute("legion_hegemony_reward_window_open", 0, {Panel_hegemony_tab_box})
        else
            state_machine.excute("legion_hegemony_reward_show", 0, nil)
        end
    end
end

function LegionHegemony:onInit(params)
    local csbItem = csb.createNode(config_csb.legion.legion_hegemony)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    local state = tonumber(_ED.union.union_hegemony_info.state)
    if _ED.mould_function_push_info["9"] ~= nil then
        if state ~= tonumber(_ED.mould_function_push_info["9"].state) then
            state = tonumber(_ED.mould_function_push_info["9"].state)
        end
    end
    self._last_state = tonumber(state)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_hegemony_close"), nil, 
    {
        terminal_name = "legion_hegemony_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    self._buttons = {
        ccui.Helper:seekWidgetByName(root, "Button_hegemony_sign_up"),
        ccui.Helper:seekWidgetByName(root, "Button_hegemony_battle_field"),
        ccui.Helper:seekWidgetByName(root, "Button_hegemony_rank"),
        ccui.Helper:seekWidgetByName(root, "Button_hegemony_reward")
    }
    for k,v in pairs(self._buttons) do
        fwin:addTouchEventListener(v, nil, 
        {
            terminal_name = "legion_hegemony_change_page", 
            terminal_state = 0, 
            _page = k,
        }, nil, 1)
    end

    if params ~= nil and params._datas ~= nil and params._datas._page ~= nil then
        self:changeSelectPage(tonumber(params._datas._page))
    else
        local state = tonumber(_ED.union.union_hegemony_info.state)
        if _ED.mould_function_push_info["9"] ~= nil then
            if state ~= tonumber(_ED.mould_function_push_info["9"].state) then
                state = tonumber(_ED.mould_function_push_info["9"].state)
            end
        end
        if state == 1 then
            self:changeSelectPage(1)
        else
            self:changeSelectPage(2)
        end
    end
end

function LegionHegemony:onEnterTransitionFinish()

end

function LegionHegemony:init(params)
    self:setTouchEnabled(true)
	self:onInit(params)
    return self
end

function LegionHegemony:onExit()
    state_machine.remove("legion_hegemony_change_page")
    state_machine.remove("legion_hegemony_update_state")
end