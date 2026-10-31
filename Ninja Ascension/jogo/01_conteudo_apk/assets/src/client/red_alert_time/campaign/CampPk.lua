-----------------------------
--阵营对决
-----------------------------
CampPk = class("CampPkClass", Window)

local camp_pk_open_terminal = {
    _name = "camp_pk_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if nil == fwin:find("CampPkClass") then
                    fwin:open(CampPk:new():init(params), fwin._ui)
                end
            end
        end
        protocol_command.camp_duel_init.param_list = ""
        NetworkManager:register(protocol_command.camp_duel_init.code, nil, nil, nil, nil, responseCallback, false, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local camp_pk_close_terminal = {
    _name = "camp_pk_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        NetworkManager:register(protocol_command.camp_duel_exit.code, nil, nil, nil, nil, nil, false, nil)
        fwin:close(fwin:find("CampPkClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(camp_pk_open_terminal)
state_machine.add(camp_pk_close_terminal)
state_machine.init()

function CampPk:ctor()
    self.super:ctor()
    self.roots = {}

    self._current_page = 0
    self._challgePanel = nil
    self._meritoriousPanel = nil
    self._winTimesPanel = nil
    self._rewardPanel = nil
    self._shopPanel = nil
    self._buttons = {}

    app.load("client.red_alert_time.campaign.CampPkChallge")
    app.load("client.red_alert_time.campaign.CampPkBattle")
    app.load("client.red_alert_time.campaign.CampPkMeritorious")
    app.load("client.red_alert_time.campaign.CampPkReward")
    app.load("client.red_alert_time.campaign.CampPkRewardList")
    app.load("client.red_alert_time.campaign.CampPkWinStreak")
    app.load("client.red_alert_time.campaign.CampPkShop")
    app.load("client.red_alert_time.campaign.CampPkBattleMyInfo")
    app.load("client.red_alert_time.campaign.CampPkBattleMyEvent")
    app.load("client.red_alert_time.campaign.CampPkBattleCampEvent")
    app.load("client.red_alert_time.campaign.CampPkBattleUpEffect")

    app.load("client.red_alert_time.legion.LegionChatsView")
    app.load("client.red_alert_time.battle.battle_enum")

    app.load("client.red_alert_time.cells.campaign.camp_pk_reward_cell")
    app.load("client.red_alert_time.cells.campaign.camp_pk_meritorious_cell")
    app.load("client.red_alert_time.cells.campaign.camp_pk_battle_act_cell")
    app.load("client.red_alert_time.cells.campaign.camp_pk_event_text_cell")
    app.load("client.red_alert_time.cells.campaign.camp_pk_shop_cell")

    local function init_camp_pk_terminal()
        local camp_pk_change_page_terminal = {
            _name = "camp_pk_change_page",
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

        state_machine.add(camp_pk_change_page_terminal)
        state_machine.init()
    end
    init_camp_pk_terminal()
end

function CampPk:changeSelectPage(page)
    local root = self.roots[1]
    local Panel_camp_pk_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_camp_pk_tab_box")
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
    state_machine.excute("camp_pk_challge_hide", 0, nil)
    state_machine.excute("camp_pk_meritorious_hide", 0, nil)
    state_machine.excute("camp_pk_win_streak_hide", 0, nil)
    state_machine.excute("camp_pk_reward_hide", 0, nil)
    state_machine.excute("camp_pk_shop_hide", 0, nil)
    if page == 1 then
        if self._challgePanel == nil then
            self._challgePanel = state_machine.excute("camp_pk_challge_open", 0, {Panel_camp_pk_tab_box})
        else
            state_machine.excute("camp_pk_challge_show", 0, nil)
        end
    elseif page == 2 then
        if self._meritoriousPanel == nil then
            self._meritoriousPanel = state_machine.excute("camp_pk_meritorious_open", 0, {Panel_camp_pk_tab_box})
        else
            state_machine.excute("camp_pk_meritorious_show", 0, nil)
        end
    elseif page == 3 then
        if self._winTimesPanel == nil then
            self._winTimesPanel = state_machine.excute("camp_pk_win_streak_open", 0, {Panel_camp_pk_tab_box})
        else
            state_machine.excute("camp_pk_win_streak_show", 0, nil)
        end
    elseif page == 4 then
        if self._rewardPanel == nil then
            self._rewardPanel = state_machine.excute("camp_pk_reward_open", 0, {Panel_camp_pk_tab_box})
        else
            state_machine.excute("camp_pk_reward_show", 0, nil)
        end
    else
        if self._shopPanel == nil then
            self._shopPanel = state_machine.excute("camp_pk_shop_window_open", 0, {Panel_camp_pk_tab_box})
        else
            state_machine.excute("camp_pk_shop_show", 0, nil)
        end
    end
end

function CampPk:perseEventInfoData( ... )
    _ED.camp_battle_event_info = {}
    for i= 1, dms.count(dms["camp_duel_event"]) do
        local info = {}
        local mould_info = dms.element(dms["camp_duel_event"], i)
        info.id = dms.atoi(mould_info, camp_duel_event.id)
        info.info = dms.atos(mould_info, camp_duel_event.info)
        _ED.camp_battle_event_info[""..info.id] = info
    end
end

function CampPk:onEnterTransitionFinish()

end

function CampPk:onInit( params )
    self:perseEventInfoData()
    local csbItem = csb.createNode(config_csb.campaign.camp_pk)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_camp_pk_close"), nil, 
    {
        terminal_name = "camp_pk_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    self._buttons = {ccui.Helper:seekWidgetByName(root, "Button_camp_pk_vs"),
                    ccui.Helper:seekWidgetByName(root, "Button_camp_pk_meritorious"),
                    ccui.Helper:seekWidgetByName(root, "Button_camp_pk_straight"),
                    ccui.Helper:seekWidgetByName(root, "Button_camp_pk_reward"),
                    ccui.Helper:seekWidgetByName(root, "Button_camp_pk_shop")}

    for k,v in pairs(self._buttons) do
        fwin:addTouchEventListener(v, nil, 
        {
            terminal_name = "camp_pk_change_page", 
            terminal_state = 0, 
            _page = k,
        }, nil, 1)
    end

    if params ~= nil and params._datas ~= nil and params._datas._page ~= nil then
        self:changeSelectPage(tonumber(params._datas._page))
    else
        self:changeSelectPage(1)
    end
end

function CampPk:init(params)
    self:setTouchEnabled(true)
	self:onInit(params)
    return self
end

function CampPk:onExit()
    state_machine.remove("camp_pk_change_page")
end
