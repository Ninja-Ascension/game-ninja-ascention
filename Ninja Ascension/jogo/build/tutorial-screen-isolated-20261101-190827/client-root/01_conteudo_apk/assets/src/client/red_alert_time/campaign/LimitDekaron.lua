-- ------------------------------------------------------------------------------------------------------------
--  说明：极限挑战
-- ------------------------------------------------------------------------------------------------------------
LimitDekaron = class("LimitDekaronClass", Window)

--打开界面
local limit_dekaron_window_open_terminal = {
    _name = "limit_dekaron_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.lock("limit_dekaron_window_open", 0, 0)
        local function responseCallback(response)
            state_machine.unlock("limit_dekaron_window_open", 0, 0)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if fwin:find("LimitDekaronClass") == nil then
                    fwin:open(LimitDekaron:new():init(), fwin._ui)
                end
            end
        end
        protocol_command.extreme_init.param_list = ""
        NetworkManager:register(protocol_command.extreme_init.code, nil, nil, nil, nil, responseCallback, false, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local limit_dekaron_window_close_terminal = {
    _name = "limit_dekaron_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LimitDekaronClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(limit_dekaron_window_open_terminal)
state_machine.add(limit_dekaron_window_close_terminal)
state_machine.init()

function LimitDekaron:ctor()
    self.super:ctor()
    self.roots = {}

    self._current_page = 0
    self._challenge_panel = nil
    self._rank_panel = nil
    self._reward_panel = nil
    self._battlefield_panel = nil

    app.load("client.red_alert_time.campaign.LimitDekaronChallenge")
    app.load("client.red_alert_time.campaign.LimitDekaronRank")
    app.load("client.red_alert_time.campaign.LimitDekaronReward")
    app.load("client.red_alert_time.campaign.LimitDekaronGrand")
    app.load("client.red_alert_time.campaign.LimitDekaronSettlementReward")
        
    app.load("client.red_alert_time.cells.campaign.limit_dekarona_rank_cell")
    app.load("client.red_alert_time.cells.campaign.limit_dekarona_reward_cell")
    app.load("client.red_alert_time.cells.campaign.limit_dekarona_cell")
    app.load("client.red_alert_time.cells.campaign.limit_dekarona_boss_cell")
    app.load("client.red_alert_time.cells.campaign.limit_dekarona_buff_cell")
    app.load("client.red_alert_time.cells.campaign.limit_dekaron_grand_cell")
    app.load("client.red_alert_time.cells.props.props_icon_cell")
    local function init_limit_dekaron_terminal()
        local limit_dekaron_change_page_terminal = {
            _name = "limit_dekaron_change_page",
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

        local limit_dekaron_enter_fight_terminal = {
            _name = "limit_dekaron_enter_fight",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                _ED._battle_init_type = battle_enum._fight_type._fight_type_202
                _ED._current_scene_id = 0
                _ED._scene_npc_id = 0
                _ED._npc_difficulty_index = 1
                state_machine.excute("fight_window_open", 0, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(limit_dekaron_change_page_terminal)
        state_machine.add(limit_dekaron_enter_fight_terminal)
        state_machine.init()
    end
    init_limit_dekaron_terminal()
end

function LimitDekaron:changeSelectPage( page )
    local root = self.roots[1]
    local Panel_limit_dekaron_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_limit_dekaron_tab_box")
    local Button_limit_dekaron = ccui.Helper:seekWidgetByName(root, "Button_limit_dekaron")
    local Button_limit_dekaron_rank = ccui.Helper:seekWidgetByName(root, "Button_limit_dekaron_rank")
    local Button_limit_dekaron_reward = ccui.Helper:seekWidgetByName(root, "Button_limit_dekaron_reward")
    local Button_limit_dekaron_battlefield = ccui.Helper:seekWidgetByName(root, "Button_limit_dekaron_battlefield")
    if page == self._current_page then
        if page == 1 then
            Button_limit_dekaron:setHighlighted(true)
        elseif page == 2 then
            Button_limit_dekaron_rank:setHighlighted(true)
        elseif page == 3 then
            Button_limit_dekaron_reward:setHighlighted(true)
        else
            Button_limit_dekaron_battlefield:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_limit_dekaron:setHighlighted(false)
    Button_limit_dekaron_rank:setHighlighted(false)
    Button_limit_dekaron_reward:setHighlighted(false)
    Button_limit_dekaron_battlefield:setHighlighted(false)
    state_machine.excute("limit_dekaron_challenge_hide", 0, nil)
    state_machine.excute("limit_dekaron_rank_hide", 0, nil)
    state_machine.excute("limit_dekaron_reward_hide", 0, nil)
    state_machine.excute("limit_dekaron_grand_hide", 0, nil)
    if page == 1 then
        Button_limit_dekaron:setHighlighted(true)
        if self._challenge_panel == nil then
            self._challenge_panel = state_machine.excute("limit_dekaron_challenge_open", 0, {Panel_limit_dekaron_tab_box})
        else
            state_machine.excute("limit_dekaron_challenge_show", 0, nil)
        end
    elseif page == 2 then
        Button_limit_dekaron_rank:setHighlighted(true)
        if self._rank_panel == nil then
            self._rank_panel = state_machine.excute("limit_dekaron_rank_open", 0, {Panel_limit_dekaron_tab_box})
        else
            state_machine.excute("limit_dekaron_rank_show", 0, nil)
        end
    elseif page == 3 then
        Button_limit_dekaron_reward:setHighlighted(true)
        if self._reward_panel == nil then
            self._reward_panel = state_machine.excute("limit_dekaron_reward_open", 0, {Panel_limit_dekaron_tab_box})
        else
            state_machine.excute("limit_dekaron_reward_show", 0, nil)
        end
    else
        Button_limit_dekaron_battlefield:setHighlighted(true)
        if self._battlefield_panel == nil then
            self._battlefield_panel = state_machine.excute("limit_dekaron_grand_window_open", 0, {Panel_limit_dekaron_tab_box})
        else
            state_machine.excute("limit_dekaron_grand_show", 0, nil) 
        end
    end

    local Panel_limit_attack_bg = ccui.Helper:seekWidgetByName(root, "Panel_limit_attack_bg")
    if Panel_limit_attack_bg ~= nil then
        if page == 1 then
            Panel_limit_attack_bg:setVisible(true)
        else
            Panel_limit_attack_bg:setVisible(false)
        end
    end

    local Image_limit_attack_bar = ccui.Helper:seekWidgetByName(root, "Image_limit_attack_bar")
    if Image_limit_attack_bar ~= nil then
        if page == 1 then
            Image_limit_attack_bar:setVisible(true)
        else
            Image_limit_attack_bar:setVisible(false)
        end
    end
end

function LimitDekaron:onInit(params)
    local csbItem = csb.createNode(config_csb.campaign.limit_dekaron)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

    self.__check_covers = true
    root.__cwindow = self
    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_limit_dekaron_close"), nil, 
    {
        terminal_name = "limit_dekaron_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)      

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_limit_dekaron"), nil, 
    {
        terminal_name = "limit_dekaron_change_page", 
        terminal_state = 0, 
        _page = 1,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_limit_dekaron_rank"), nil, 
    {
        terminal_name = "limit_dekaron_change_page", 
        terminal_state = 0, 
        _page = 2,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_limit_dekaron_reward"), nil, 
    {
        terminal_name = "limit_dekaron_change_page", 
        terminal_state = 0, 
        _page = 3,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_limit_dekaron_battlefield"), nil, 
    {
        terminal_name = "limit_dekaron_change_page", 
        terminal_state = 0, 
        _page = 4,
    }, nil, 1)

    self:changeSelectPage(1)
end

function LimitDekaron:onEnterTransitionFinish()

end

function LimitDekaron:init(params)
    self:setTouchEnabled(true)
    self:onInit(params)
    return self
end

function LimitDekaron:onExit()
    state_machine.remove("limit_dekaron_change_page")
    state_machine.remove("limit_dekaron_enter_fight")
end