--------------------------------------------------------------------------------------------------------------
--  说明：守卫战排行榜
--------------------------------------------------------------------------------------------------------------
GuardBattleRank = class("GuardBattleRankClass", Window)

--打开界面
local guard_battle_rank_window_open_terminal = {
    _name = "guard_battle_rank_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)        
        local function responseCallback2(response)
            if fwin:find("GuardBattleRankClass") == nil then
                fwin:open(GuardBattleRank:new():init(), fwin._ui)
            end
        end
        local function responseCallback1(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                protocol_command.guard_order_list.param_list = "1"
                NetworkManager:register(protocol_command.guard_order_list.code, nil, nil, nil, nil, responseCallback2, false, nil)
            end
        end
        protocol_command.guard_order_list.param_list = "0"
        NetworkManager:register(protocol_command.guard_order_list.code, nil, nil, nil, nil, responseCallback1, false, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local guard_battle_rank_window_close_terminal = {
    _name = "guard_battle_rank_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("GuardBattleRankClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(guard_battle_rank_window_open_terminal)
state_machine.add(guard_battle_rank_window_close_terminal)
state_machine.init()

function GuardBattleRank:ctor()
    self.super:ctor()
    self.roots = {}

    self._current_page = 0
    self._person_panel = nil
    self._legion_panel = nil
    self._reward_panel = nil

    local function init_guard_battle_rank_terminal()
        local guard_battle_rank_change_page_terminal = {
            _name = "guard_battle_rank_change_page",
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

        state_machine.add(guard_battle_rank_change_page_terminal)   
        state_machine.init()
    end
    init_guard_battle_rank_terminal()
end

function GuardBattleRank:changeSelectPage( page )
    local root = self.roots[1]
    local Panel_guard_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_guard_tab_box")
    local Button_guard_personal_contribution = ccui.Helper:seekWidgetByName(root, "Button_guard_personal_contribution")
    local Button_guard_legion_contribution = ccui.Helper:seekWidgetByName(root, "Button_guard_legion_contribution")
    local Button_guard_reward = ccui.Helper:seekWidgetByName(root, "Button_guard_reward")
    if page == self._current_page then
        if page == 1 then
            Button_guard_personal_contribution:setHighlighted(true)
        elseif page == 2 then
            Button_guard_legion_contribution:setHighlighted(true)
        elseif page == 3 then
            Button_guard_reward:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_guard_personal_contribution:setHighlighted(false)
    Button_guard_legion_contribution:setHighlighted(false)
    Button_guard_reward:setHighlighted(false)
    state_machine.excute("guard_battle_rank_listview_window_hide", 0, self._person_panel)
    state_machine.excute("guard_battle_rank_listview_window_hide", 0, self._legion_panel)
    state_machine.excute("guard_battle_rank_reward_window_hide", 0, nil)
    if page == 1 then
        Button_guard_personal_contribution:setHighlighted(true)
        if self._person_panel == nil then
            self._person_panel = state_machine.excute("guard_battle_rank_listview_window_open", 0, {Panel_guard_tab_box, 1})
        else
            state_machine.excute("guard_battle_rank_listview_window_show", 0, self._person_panel)
        end
    elseif page == 2 then
        Button_guard_legion_contribution:setHighlighted(true)
        if self._legion_panel == nil then
            self._legion_panel = state_machine.excute("guard_battle_rank_listview_window_open", 0, {Panel_guard_tab_box, 2})
        else
            state_machine.excute("guard_battle_rank_listview_window_show", 0, self._legion_panel)
        end
    elseif page == 3 then
        Button_guard_reward:setHighlighted(true)
        if self._reward_panel == nil then
            self._reward_panel = state_machine.excute("guard_battle_rank_reward_window_open", 0, {Panel_guard_tab_box})
        else
            state_machine.excute("guard_battle_rank_reward_window_show", 0, nil)
        end
    end
end

function GuardBattleRank:onInit()
    local csbItem = csb.createNode(config_csb.campaign.guard_battle_rank)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self.__check_covers = true
    root.__cwindow = self
    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_guard_rank_close"), nil, 
    {
        terminal_name = "guard_battle_rank_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_guard_personal_contribution"), nil, 
    {
        terminal_name = "guard_battle_rank_change_page", 
        terminal_state = 0, 
        touch_black = true,
        _page = 1,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_guard_legion_contribution"), nil, 
    {
        terminal_name = "guard_battle_rank_change_page", 
        terminal_state = 0, 
        touch_black = true,
        _page = 2,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_guard_reward"), nil, 
    {
        terminal_name = "guard_battle_rank_change_page", 
        terminal_state = 0, 
        touch_black = true,
        _page = 3,
    }, nil, 1)

    self:changeSelectPage(1)
end

function GuardBattleRank:onEnterTransitionFinish()

end

function GuardBattleRank:init()
    self:setTouchEnabled(true)
    self:onInit()
    return self
end

function GuardBattleRank:onExit()
    state_machine.remove("guard_battle_rank_change_page")
end