-----------------------------
--敌军来袭
-----------------------------
EnemyStrike = class("EnemyStrikeClass", Window)

local enemy_strike_open_terminal = {
    _name = "enemy_strike_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("EnemyStrikeClass") == nil then
            fwin:open(EnemyStrike:new():init(params), fwin._ui)  
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local enemy_strike_close_terminal = {
    _name = "enemy_strike_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("EnemyStrikeClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(enemy_strike_open_terminal)
state_machine.add(enemy_strike_close_terminal)
state_machine.init()

function EnemyStrike:ctor()
    self.super:ctor()
    self.roots = {}

    self._current_page = 0
    self._challgePanel = nil
    self._chatPanel = nil
    self._teamPanel = nil
    self._hurtPanel = nil
    self._timesPanel = nil
    self._rewardPanel = nil 
    self._isAddChat = false
    self._buttons = {}
    self._button_info = {}

    self._last_state = -1

    app.load("client.red_alert_time.campaign.EnemyStrikeFight")
    app.load("client.red_alert_time.campaign.EnemyStrikeChallge")
    app.load("client.red_alert_time.campaign.EnemyStrikeHurt")
    app.load("client.red_alert_time.campaign.EnemyStrikeTimes")
    app.load("client.red_alert_time.campaign.EnemyStrikeBlood")
    app.load("client.red_alert_time.campaign.EnemyStrikeFiveHurt")
    app.load("client.red_alert_time.campaign.EnemyStrikeReward")
    app.load("client.red_alert_time.campaign.EnemyStrikeChatCell")
    app.load("client.red_alert_time.campaign.ExpeditionRuleInfor")
    app.load("client.red_alert_time.campaign.EnemyStrikeRewardList")

    app.load("client.red_alert_time.cells.campaign.enemy_strike_reward_cell")
    app.load("client.red_alert_time.cells.campaign.enemy_strike_fight_rank_cell")

    app.load("client.red_alert_time.formation.FormationDefend")
    app.load("client.red_alert_time.formation.FormationAttack")
    app.load("client.red_alert_time.formation.FormationRepair")
    app.load("client.red_alert_time.formation.FormationChooseTroop")
    app.load("client.red_alert_time.formation.FormationManage")
    app.load("client.red_alert_time.formation.FormationLeaderChoose")
    app.load("client.red_alert_time.formation.FormationFactor")
    app.load("client.red_alert_time.cells.formation.formation_tank_head_cell")
    app.load("client.red_alert_time.cells.formation.formation_leader_head_cell")
    app.load("client.red_alert_time.cells.formation.formation_manage_enabled_cell")
    app.load("client.red_alert_time.cells.formation.formation_manage_disabled_cell")
    app.load("client.red_alert_time.cells.formation.formation_implement_cell")
    app.load("client.red_alert_time.cells.formation.formation_repair_cell")
    app.load("client.red_alert_time.cells.formation.formation_choose_leader_cell")
    app.load("client.red_alert_time.leader.LeaderExchangeInfo")

    app.load("client.red_alert_time.chat.RedAlertTimeChatSentCell")
    app.load("client.red_alert_time.chat.RedAlertTimeChatSentList")

    local function init_enemy_strike_terminal()
        local enemy_strike_change_page_terminal = {
            _name = "enemy_strike_change_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:changeSelectPage(params._datas._page)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local enemy_strike_update_state_info_erminal = {
            _name = "enemy_strike_update_state_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:updateStateInfo()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local enemy_strike_request_init_erminal = {
            _name = "enemy_strike_request_init",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("enemy_strike_update_state_info", 0, "")
                    end
                end
                protocol_command.enemy_boss_init.param_list = ""
                NetworkManager:register(protocol_command.enemy_boss_init.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local enemy_strike_update_chat_infomation_erminal = {
            _name = "enemy_strike_update_chat_infomation",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._chatPanel ~= nil then
                    state_machine.excute("red_alert_time_chat_sent_list_update_chat_infomation",0,instance._chatPanel)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(enemy_strike_change_page_terminal)
        state_machine.add(enemy_strike_update_state_info_erminal)
        state_machine.add(enemy_strike_request_init_erminal)
        state_machine.add(enemy_strike_update_chat_infomation_erminal)
        state_machine.init()
    end
    init_enemy_strike_terminal()
end

function EnemyStrike:updateStateInfo( ... )
    if self._last_state == _ED.user_enemy_strike_boss_info.state then
        return
    end
    self._last_state = _ED.user_enemy_strike_boss_info.state
    if _ED.user_enemy_strike_boss_info.state == 0 then
        -- 活动结束，刷新排行榜
        local function responseCallback1(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                local function responseCallback2(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("enemy_strike_hurt_update_info", 0, nil)
                        state_machine.excute("enemy_strike_times_update_info", 0, nil)
                    end
                end
                protocol_command.enemy_boss_rank_list_get.param_list = "1"
                NetworkManager:register(protocol_command.enemy_boss_rank_list_get.code, nil, nil, nil, nil, responseCallback2, false, nil)
            end
        end
        protocol_command.enemy_boss_rank_list_get.param_list = "0"
        NetworkManager:register(protocol_command.enemy_boss_rank_list_get.code, nil, nil, nil, nil, responseCallback1, false, nil)
    end
end

function EnemyStrike:changeSelectPage(page)
    local root = self.roots[1]
    local Panel_limit_dekaron_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_limit_dekaron_tab_box")
    local Panel_chat_sent = ccui.Helper:seekWidgetByName(root, "Panel_chat_sent")
    local Panel_chat_box = ccui.Helper:seekWidgetByName(root, "Panel_chat_box")
    for k,v in pairs(self._buttons) do
        if page == k then
            v:setHighlighted(true)
        else
            v:setHighlighted(false)
        end
    end
    if page == self._current_page then
        return
    end
    self._current_page = page
    Panel_chat_sent:setVisible(false)
    Panel_chat_box:setVisible(false)
    
    state_machine.excute("formation_defend_hide", 0, nil)
    state_machine.excute("enemy_strike_hurt_hide", 0, nil)
    state_machine.excute("enemy_strike_times_hide", 0, nil)
    state_machine.excute("enemy_strike_reward_list_hide", 0, nil)
    if page == 1 then
        -- Panel_chat_sent:setVisible(true)
        -- if self._challgePanel == nil then
        --     if _ED.user_enemy_strike_boss_info.state == 0 then
        --         self._challgePanel = state_machine.excute("enemy_strike_challge_open", 0, {Panel_limit_dekaron_tab_box})
        --     else
        --         self._challgePanel = state_machine.excute("enemy_strike_fight_open", 0, {Panel_limit_dekaron_tab_box})
        --     end
        --     if self._isAddChat == false then
        --         Panel_chat_sent:addChild(state_machine.excute("enemy_strike_chat_cell_create", 0, 0))
        --     end
        --     self._isAddChat = true
        -- else
        --     state_machine.excute("enemy_strike_challge_show", 0, nil)
        --     state_machine.excute("enemy_strike_fight_show", 0, nil)
        -- end
        -- state_machine.excute("enemy_strike_chat_cell_instal_page", 0, 7)
    elseif page == 2 then
        -- Panel_chat_sent:setVisible(true)
        -- Panel_chat_box:setVisible(true)
        -- if self._chatPanel == nil then
        --     self._chatPanel = state_machine.excute("red_alert_time_chat_sent_list_window_open", 0, {Panel_chat_box, 9})
        --     if self._isAddChat == false then
        --         Panel_chat_sent:addChild(state_machine.excute("enemy_strike_chat_cell_create", 0, 0))
        --     end
        --     self._isAddChat = true
        -- end
        -- state_machine.excute("enemy_strike_chat_cell_instal_page", 0, 8)
    elseif page == 3 then
        if self._teamPanel == nil then
            self._teamPanel = state_machine.excute("formation_defend_open", 0, {Panel_limit_dekaron_tab_box, 10})
        else
            state_machine.excute("formation_defend_show", 0, nil)
        end
    elseif page == 4 then
        if self._hurtPanel == nil then
            self._hurtPanel = state_machine.excute("enemy_strike_hurt_open", 0, {Panel_limit_dekaron_tab_box})
        else
            state_machine.excute("enemy_strike_hurt_show", 0, nil)
        end
    elseif page == 5 then
        if self._timesPanel == nil then
            self._timesPanel = state_machine.excute("enemy_strike_times_open", 0, {Panel_limit_dekaron_tab_box})
        else
            state_machine.excute("enemy_strike_times_show", 0, nil)
        end
    elseif page == 6 then
        if self._rewardPanel == nil then
            self._rewardPanel = state_machine.excute("enemy_strike_reward_list_open", 0, {Panel_limit_dekaron_tab_box})
        else
            state_machine.excute("enemy_strike_reward_list_show", 0, nil)
        end
    end
end

function EnemyStrike:onEnterTransitionFinish()

end

function EnemyStrike:onInit(params)
    local csbItem = csb.createNode(config_csb.campaign.enemy_strike)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    self.__check_covers = true
    root.__cwindow = self
    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    self._last_state = _ED.user_enemy_strike_boss_info.state
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_limit_dekaron_close"), nil, 
    {
        terminal_name = "enemy_strike_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    self._buttons = {ccui.Helper:seekWidgetByName(root, "Button_limit_dekaron"),
                    ccui.Helper:seekWidgetByName(root, "Button_limit_dekaron_rank"),
                    ccui.Helper:seekWidgetByName(root, "Button_limit_dekaron_reward"),
                    ccui.Helper:seekWidgetByName(root, "Button_limit_dekaron_0"),
                    ccui.Helper:seekWidgetByName(root, "Button_limit_dekaron_rank_0"),
                    ccui.Helper:seekWidgetByName(root, "Button_limit_dekaron_rank_0_0")}

    for k,v in pairs(self._buttons) do
        fwin:addTouchEventListener(v, nil, 
        {
            terminal_name = "enemy_strike_change_page", 
            terminal_state = 0, 
            _page = k,
        }, nil, 1)
    end

    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_enemy_strike_reward",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_limit_dekaron_rank_0_0"),
        _invoke = nil,
        _interval = 0.2,})

    if params ~= nil and params._datas ~= nil and params._datas._page ~= nil then
        self:changeSelectPage(tonumber(params._datas._page))
    else
        self:changeSelectPage(1)
    end
end

function EnemyStrike:init(params)
    self:setTouchEnabled(true)
	self:onInit(params)
    return self
end

function EnemyStrike:onExit()
    state_machine.remove("enemy_strike_change_page")
    state_machine.remove("enemy_strike_update_state_info")
    state_machine.remove("enemy_strike_request_init")
    state_machine.remove("enemy_strike_update_chat_infomation")
end
