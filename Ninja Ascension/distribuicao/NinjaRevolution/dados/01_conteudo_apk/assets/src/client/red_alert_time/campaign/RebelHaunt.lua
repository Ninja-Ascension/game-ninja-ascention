-----------------------------
--叛军出没
-----------------------------
RebelHaunt = class("RebelHauntClass", Window)

local rebel_haunt_open_terminal = {
    _name = "rebel_haunt_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if tonumber(_ED.user_info.user_grade) < 5 then
            TipDlg.drawTextDailog(red_alert_time_str[265])
            return
        end
        state_machine.lock("rebel_haunt_open", 0, 0)
        local function responseCallback(response)
            state_machine.unlock("rebel_haunt_open", 0, 0)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                local _Window = fwin:find("RebelHauntClass")
                if nil == _Window then
                    fwin:open(RebelHaunt:new():init(params), fwin._ui)
                end
            end
        end
        protocol_command.rebel_haunt_list_init.param_list = ""
        NetworkManager:register(protocol_command.rebel_haunt_list_init.code, nil, nil, nil, nil, responseCallback, false, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local rebel_haunt_close_terminal = {
    _name = "rebel_haunt_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        NetworkManager:register(protocol_command.rebel_haunt_exit.code, nil, nil, nil, nil, nil, false, nil)
        fwin:close(fwin:find("RebelHauntClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(rebel_haunt_open_terminal)
state_machine.add(rebel_haunt_close_terminal)
state_machine.init()

function RebelHaunt:ctor()
    self.super:ctor()
    self.roots = {}

    self._current_page = 0
    self._rebelPanel = nil
    self._weakPanel = nil
    self._totalPanel = nil
    self._rewardPanel = nil
    self._buttons = {}

    app.load("client.red_alert_time.campaign.RebelHauntList")
    app.load("client.red_alert_time.campaign.RebelHauntListInfo")
    app.load("client.red_alert_time.campaign.RebelHauntWeak")
    app.load("client.red_alert_time.campaign.RebelHauntTotal")
    app.load("client.red_alert_time.campaign.RebelHauntReward")
    app.load("client.red_alert_time.campaign.RebelHauntAttack")
    app.load("client.red_alert_time.campaign.ExpeditionRuleInfor")

    app.load("client.red_alert_time.cells.campaign.rebel_week_rank_cell")
    app.load("client.red_alert_time.cells.campaign.rebel_reward_cell")
    app.load("client.red_alert_time.cells.campaign.rebel_soldier_cell")
    app.load("client.red_alert_time.cells.campaign.rebel_soldier_attack_cell")

    local function init_rebel_haunt_terminal()
        local rebel_haunt_change_page_terminal = {
            _name = "rebel_haunt_change_page",
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
        state_machine.add(rebel_haunt_change_page_terminal)
        state_machine.init()
    end
    init_rebel_haunt_terminal()
end

function RebelHaunt:getRebelRankList()
    -- local function responseCallback2(response)
    --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
    --         state_machine.excute("rebel_haunt_weak_update_draw", 0, "")
    --         state_machine.excute("rebel_haunt_total_update_draw", 0, "")
    --         state_machine.excute("rebel_haunt_reward_update_draw", 0, "")
    --     end
    -- end
    -- local function responseCallback1(response)
    --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
    --         protocol_command.rebel_haunt_rank_list_get.param_list = "1".. "\r\n" .."1".. "\r\n" .."20"
    --         NetworkManager:register(protocol_command.rebel_haunt_rank_list_get.code, nil, nil, nil, nil, responseCallback2, false, nil)
    --     end
    -- end
    -- protocol_command.rebel_haunt_rank_list_get.param_list = "0".. "\r\n" .."1".. "\r\n" .."20"
    -- NetworkManager:register(protocol_command.rebel_haunt_rank_list_get.code, nil, nil, nil, nil, responseCallback1, false, nil)
end

function RebelHaunt:changeSelectPage(page)
    local root = self.roots[1]
    local Panel_collection_tab = ccui.Helper:seekWidgetByName(root, "Panel_collection_tab")
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
    state_machine.excute("rebel_haunt_list_hide", 0, nil)
    state_machine.excute("rebel_haunt_weak_hide", 0, nil)
    state_machine.excute("rebel_haunt_total_hide", 0, nil)
    state_machine.excute("rebel_haunt_reward_hide", 0, nil)
    if page == 1 then
        if self._rebelPanel == nil then
            self._rebelPanel = state_machine.excute("rebel_haunt_list_open", 0, {Panel_collection_tab})
        else
            state_machine.excute("rebel_haunt_list_show", 0, nil)
        end
    elseif page == 2 then
        if self._weakPanel == nil then
            self._weakPanel = state_machine.excute("rebel_haunt_weak_open", 0, {Panel_collection_tab})
        else
            state_machine.excute("rebel_haunt_weak_show", 0, nil)
        end
    elseif page == 3 then
        if self._totalPanel == nil then
            self._totalPanel = state_machine.excute("rebel_haunt_total_open", 0, {Panel_collection_tab})
        else
            state_machine.excute("rebel_haunt_total_show", 0, nil)
        end
    else
        if self._rewardPanel == nil then
            self._rewardPanel = state_machine.excute("rebel_haunt_reward_open", 0, {Panel_collection_tab})
        else
            state_machine.excute("rebel_haunt_reward_show", 0, nil)
        end
    end
end

function RebelHaunt:onEnterTransitionFinish()

end

function RebelHaunt:onInit(params)
    local csbItem = csb.createNode(config_csb.campaign.rebel_haunt)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    self.__check_covers = true
    root.__cwindow = self
    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_rebel_haunt_close"), nil, 
    {
        terminal_name = "rebel_haunt_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    self._buttons = {ccui.Helper:seekWidgetByName(root, "Button_rebel"),
                    ccui.Helper:seekWidgetByName(root, "Button_rebel_week_rank"),
                    ccui.Helper:seekWidgetByName(root, "Button_rebel_all_rank"),
                    ccui.Helper:seekWidgetByName(root, "Button_rebel_week_reward")}

    for k,v in pairs(self._buttons) do
        fwin:addTouchEventListener(v, nil, 
        {
            terminal_name = "rebel_haunt_change_page", 
            terminal_state = 0, 
            _page = k,
        }, nil, 1)
    end

    if params ~= nil and params._datas ~= nil and params._datas._page ~= nil then
        self:changeSelectPage(tonumber(params._datas._page))
    else
        self:changeSelectPage(1)
    end
    
    self:getRebelRankList()
end

function RebelHaunt:init(params)
    self:setTouchEnabled(true)
	self:onInit(params)
    return self
end

function RebelHaunt:onExit()
    state_machine.remove("rebel_haunt_change_page")
end
