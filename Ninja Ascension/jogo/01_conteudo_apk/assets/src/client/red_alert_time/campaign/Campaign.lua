-----------------------------
--日常 历练
-----------------------------
Campaign = class("CampaignClass", Window)

local campaign_window_open_terminal = {
    _name = "campaign_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        -- if funOpenDrawTip(64) == true then
        --     return
        -- end
        local _Window = fwin:find("CampaignClass")
        if nil == _Window then
            fwin:open(Campaign:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local campaign_window_close_terminal = {
    _name = "campaign_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("CampaignClass"))
        -- 校验开启教学事件
        state_machine.excute("main_window_check_mission", 0, 0)

        cacher.removeAllTextures()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(campaign_window_open_terminal)
state_machine.add(campaign_window_close_terminal)
state_machine.init()

function Campaign:ctor()
    self.super:ctor()
    self.roots = {}

    self._current_page = 0
    self._pages = {}
    self._buttons = {}

    app.load("client.red_alert_time.campaign.CampaignList")
    app.load("client.red_alert_time.campaign.EnemyStrike")
    app.load("client.red_alert_time.campaign.RebelHaunt")
    app.load("client.red_alert_time.campaign.ExpeditionManager")
    app.load("client.red_alert_time.campaign.ExpeditionRuleInfor")
    app.load("client.red_alert_time.campaign.SuperScholar")
    app.load("client.red_alert_time.campaign.LimitDekaron")
    app.load("client.red_alert_time.campaign.CampPk")
    app.load("client.red_alert_time.campaign.GuardBattle")
    app.load("client.red_alert_time.legion.LegionHegemony")
    app.load("client.red_alert_time.campaign.EnemyStrikeWorldBox")
    app.load("client.red_alert_time.legion.LegionCity")
    app.load("client.red_alert_time.legion.LegionCityRuleInfor")

    app.load("client.red_alert_time.cells.campaign.campaign_cell")
    app.load("client.red_alert_time.utils.ShortCut")

    local function init_campaign_terminal()
        local campaign_change_page_terminal = {
            _name = "campaign_change_page",
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

        local campaign_change_update_state_terminal = {
            _name = "campaign_change_update_state",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:updateDrawState()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(campaign_change_page_terminal)
        state_machine.add(campaign_change_update_state_terminal)
        state_machine.init()
    end
    init_campaign_terminal()
end

function Campaign:updateDrawState( ... )
    for k,v in pairs(self._pages) do
        state_machine.excute("campaign_list_update", 0, v)
    end
end

function Campaign:changeSelectPage(page)
    local root = self.roots[1]
    local Panel_campaign_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_campaign_tab_box")
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
    for k,v in pairs(self._pages) do
        v:setVisible(false)
    end
    if self._pages[""..page] == nil then
        self._pages[""..page] = state_machine.excute("campaign_list_open", 0, {Panel_campaign_tab_box, page})
    else
        self._pages[""..page]:setVisible(true)
    end
end

function Campaign:onEnterTransitionFinish()

end

function Campaign:onInit(params)
    local csbItem = csb.createNode(config_csb.campaign.campaign)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    self.__check_covers = true
    root.__cwindow = self
    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_campaign_close"), nil, 
    {
        terminal_name = "campaign_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    self._buttons = {ccui.Helper:seekWidgetByName(root, "Button_daily_activity"),
                    ccui.Helper:seekWidgetByName(root, "Button_linited_activity"),
                    ccui.Helper:seekWidgetByName(root, "Button_inter_service_activity")}

    for k,v in pairs(self._buttons) do
        fwin:addTouchEventListener(v, nil, 
        {
            terminal_name = "campaign_change_page", 
            terminal_state = 0, 
            _page = k,
        }, nil, 1)
    end

    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_all_daily_campaign",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_daily_activity"),
    _invoke = nil,
    _interval = 0.2,})

    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_all_linited_campaign",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_linited_activity"),
    _invoke = nil,
    _interval = 0.2,})

    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_all_inter_service_campaign",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_inter_service_activity"),
    _invoke = nil,
    _interval = 0.2,})

    if params ~= nil and params._datas ~= nil and params._datas._page ~= nil then
        self:changeSelectPage(tonumber(params._datas._page))
    else
        self:changeSelectPage(1)
    end

end

function Campaign:init(params)
    self:setTouchEnabled(true)
	self:onInit(params)
    return self
end

function Campaign:onExit()
    state_machine.remove("campaign_change_page")
    state_machine.remove("campaign_change_update_state")
end
