--------------------------------------------------------------------------------------------------------------
--  说明：学霸之战
--------------------------------------------------------------------------------------------------------------
SuperScholar = class("SuperScholarClass", Window)

--打开界面
local super_scholar_window_open_terminal = {
    _name = "super_scholar_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.lock("super_scholar_window_open", 0, 0)
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                state_machine.unlock("super_scholar_window_open", 0, 0)
                if fwin:find("SuperScholarClass") == nil then
                    local _win = SuperScholar:new()
                    _win:init()
                    fwin:open(_win,fwin._ui)
                end
            end
        end
        protocol_command.answer_init.param_list = ""
        NetworkManager:register(protocol_command.answer_init.code, nil, nil, nil, nil, responseCallback, false, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local super_scholar_window_close_terminal = {
    _name = "super_scholar_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("SuperScholarClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(super_scholar_window_open_terminal)
state_machine.add(super_scholar_window_close_terminal)
state_machine.init()

function SuperScholar:ctor()
    self.super:ctor()
    self.roots = {}

    self._current_page = 0
    self._answerPanel = nil
    self._rankPanel = nil
    self._rewardPanel = nil
    self._rulePanel = nil

    app.load("client.red_alert_time.campaign.SuperScholarAnswer")
    app.load("client.red_alert_time.campaign.SuperScholarRank")
    app.load("client.red_alert_time.campaign.SuperScholarReward")
    app.load("client.red_alert_time.campaign.SuperScholarRule")

    app.load("client.red_alert_time.cells.campaign.super_scholar_rank_cell")
    app.load("client.red_alert_time.cells.campaign.super_scholar_reward_cell")

    local function init_super_scholar_terminal()
        local super_scholar_change_page_terminal = {
            _name = "super_scholar_change_page",
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

        state_machine.add(super_scholar_change_page_terminal)   
        state_machine.init()
    end
    init_super_scholar_terminal()
end

function SuperScholar:changeSelectPage( page )
    local root = self.roots[1]
    local Panel_super_scholar_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_super_scholar_tab_box")
    local Button_super_scholar_answer = ccui.Helper:seekWidgetByName(root, "Button_super_scholar_answer")
    local Button_super_scholar_rank = ccui.Helper:seekWidgetByName(root, "Button_super_scholar_rank")
    local Button_super_scholar_reward = ccui.Helper:seekWidgetByName(root, "Button_super_scholar_reward")
    local Button_super_scholar_rule = ccui.Helper:seekWidgetByName(root, "Button_super_scholar_rule")
    if page == self._current_page then
        if page == 1 then
            Button_super_scholar_answer:setHighlighted(true)
        elseif page == 2 then
            Button_super_scholar_rank:setHighlighted(true)
        elseif page == 3 then
            Button_super_scholar_reward:setHighlighted(true)
        else
            Button_super_scholar_rule:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_super_scholar_answer:setHighlighted(false)
    Button_super_scholar_rank:setHighlighted(false)
    Button_super_scholar_reward:setHighlighted(false)
    Button_super_scholar_rule:setHighlighted(false)
    state_machine.excute("super_scholar_answer_hide", 0, nil)
    state_machine.excute("super_scholar_rank_hide", 0, nil)
    state_machine.excute("super_scholar_reward_hide", 0, nil)
    state_machine.excute("super_scholar_rule_hide", 0, nil)
    if page == 1 then
        Button_super_scholar_answer:setHighlighted(true)
        if self._answerPanel == nil then
            self._answerPanel = state_machine.excute("super_scholar_answer_open", 0, {Panel_super_scholar_tab_box})
        else
            state_machine.excute("super_scholar_answer_show", 0, nil)
        end
    elseif page == 2 then
        Button_super_scholar_rank:setHighlighted(true)
        if self._rankPanel == nil then
            self._rankPanel = state_machine.excute("super_scholar_rank_open", 0, {Panel_super_scholar_tab_box})
        else
            state_machine.excute("super_scholar_rank_show", 0, nil)
        end
    elseif page == 3 then
        Button_super_scholar_reward:setHighlighted(true)
        if self._rewardPanel == nil then
            self._rewardPanel = state_machine.excute("super_scholar_reward_open", 0, {Panel_super_scholar_tab_box})
        else
            state_machine.excute("super_scholar_reward_show", 0, nil)
        end
    else
        Button_super_scholar_rule:setHighlighted(true)
        if self._rulePanel == nil then
            self._rulePanel = state_machine.excute("super_scholar_rule_open", 0, {Panel_super_scholar_tab_box})
        else
            state_machine.excute("super_scholar_rule_show", 0, nil)
        end
    end
end

function SuperScholar:onInit(params)
    local csbItem = csb.createNode(config_csb.campaign.super_scholar)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

    self.__check_covers = true
    root.__cwindow = self
    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_super_scholar_close"), nil, 
    {
        terminal_name = "super_scholar_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)      

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_super_scholar_answer"), nil, 
    {
        terminal_name = "super_scholar_change_page", 
        terminal_state = 0, 
        _page = 1,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_super_scholar_rank"), nil, 
    {
        terminal_name = "super_scholar_change_page", 
        terminal_state = 0, 
        _page = 2,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_super_scholar_reward"), nil, 
    {
        terminal_name = "super_scholar_change_page", 
        terminal_state = 0, 
        _page = 3,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_super_scholar_rule"), nil, 
    {
        terminal_name = "super_scholar_change_page", 
        terminal_state = 0, 
        _page = 4,
    }, nil, 1)

    self:changeSelectPage(1)
end

function SuperScholar:onEnterTransitionFinish()

end

function SuperScholar:init(params)
    self:setTouchEnabled(true)
    self:onInit(params)
    return self
end

function SuperScholar:onExit()
    state_machine.remove("super_scholar_change_page")
end