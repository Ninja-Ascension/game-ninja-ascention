--------------------------------------------------------------------------------------------------------------
--  说明：工会活跃
--------------------------------------------------------------------------------------------------------------
LegionActive = class("LegionActiveClass", Window)

--打开界面
local legion_active_open_terminal = {
	_name = "legion_active_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        state_machine.lock("legion_active_open", 0, 0)
        local function responseCallback(response)
            state_machine.unlock("legion_active_open", 0, 0)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if fwin:find("LegionActiveClass") == nil then
                    local _win = LegionActive:new()
                    _win:init()
                    fwin:open(_win,fwin._ui)
                end
            end
        end
        protocol_command.union_active_init.param_list = ""
        NetworkManager:register(protocol_command.union_active_init.code, nil, nil, nil, nil, responseCallback, false, nil)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local legion_active_close_terminal = {
	_name = "legion_active_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LegionActiveClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(legion_active_open_terminal)
state_machine.add(legion_active_close_terminal)
state_machine.init()

function LegionActive:ctor()
	self.super:ctor()
	self.roots = {}

    self._current_page = 0
    self._taskPanel = nil
    self._rewardPanel = nil
    self._rankPanel = nil

    app.load("client.red_alert_time.legion.LegionActiveTask")
    app.load("client.red_alert_time.legion.LegionActiveReward")
    app.load("client.red_alert_time.legion.LegionActiveRank")

    app.load("client.red_alert_time.cells.legion.legion_active_task_cell")
    app.load("client.red_alert_time.cells.legion.legion_active_rank_cell")

    local function init_legion_active_terminal()
        local legion_active_change_page_terminal = {
            _name = "legion_active_change_page",
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

		state_machine.add(legion_active_change_page_terminal)   
        state_machine.init()
    end
    init_legion_active_terminal()
end

function LegionActive:changeSelectPage( page )
    local root = self.roots[1]
    local Panel_legion_active_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_legion_active_tab_box")

    local Button_active_task = ccui.Helper:seekWidgetByName(root, "Button_active_task")
    local Button_legion_welfare = ccui.Helper:seekWidgetByName(root, "Button_legion_welfare")
    local Button_active_rank = ccui.Helper:seekWidgetByName(root, "Button_active_rank")
    if page == self._current_page then
        if page == 1 then
            Button_active_task:setHighlighted(true)
        elseif page == 2 then
            Button_legion_welfare:setHighlighted(true)
        else
            Button_active_rank:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_active_task:setHighlighted(false)
    Button_legion_welfare:setHighlighted(false)
    Button_active_rank:setHighlighted(false)
    state_machine.excute("legion_active_task_hide", 0, nil)
    state_machine.excute("legion_active_reward_hide", 0, nil)
    state_machine.excute("legion_active_rank_hide", 0, nil)
    if page == 1 then
        Button_active_task:setHighlighted(true)
        if self._taskPanel == nil then
            self._taskPanel = state_machine.excute("legion_active_task_open", 0, {Panel_legion_active_tab_box})
        else
            state_machine.excute("legion_active_task_show", 0, nil)
        end
    elseif page == 2 then
        Button_legion_welfare:setHighlighted(true)
        if self._rewardPanel == nil then
            self._rewardPanel = state_machine.excute("legion_active_reward_open", 0, {Panel_legion_active_tab_box})
        else
            state_machine.excute("legion_active_reward_show", 0, nil)
        end
    else
        Button_active_rank:setHighlighted(true)
        if self._rankPanel == nil then
            self._rankPanel = state_machine.excute("legion_active_rank_open", 0, {Panel_legion_active_tab_box})
        else
            state_machine.excute("legion_active_rank_show", 0, nil)
            state_machine.excute("legion_active_rank_update_draw", 0, nil)
        end
    end
end

function LegionActive:onInit(params)
    local csbItem = csb.createNode(config_csb.legion.legion_active)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_shop_close"), nil, 
    {
        terminal_name = "legion_active_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)      

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_active_task"), nil, 
    {
        terminal_name = "legion_active_change_page", 
        terminal_state = 0, 
        _page = 1,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_welfare"), nil, 
    {
        terminal_name = "legion_active_change_page", 
        terminal_state = 0, 
        _page = 2,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_active_rank"), nil, 
    {
        terminal_name = "legion_active_change_page", 
        terminal_state = 0, 
        _page = 3,
    }, nil, 1)

    if params ~= nil and params._datas ~= nil and params._datas._page ~= nil then
        self:changeSelectPage(tonumber(params._datas._page))
    else
        self:changeSelectPage(1)
    end
end

function LegionActive:onEnterTransitionFinish()

end

function LegionActive:init(params)
    self:setTouchEnabled(true)
	self:onInit(params)
    return self
end

function LegionActive:onExit()
    state_machine.remove("legion_active_change_page")
end