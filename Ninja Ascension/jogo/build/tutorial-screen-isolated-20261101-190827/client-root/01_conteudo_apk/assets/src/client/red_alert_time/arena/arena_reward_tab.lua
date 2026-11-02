-- ----------------------------------------------------------------------------------------------------
-- 说明：战地争霸奖励界面
-------------------------------------------------------------------------------------------------------
ArenaRewardTab = class("ArenaRewardTabClass", Window)

local arena_reward_tab_open_terminal = {
    _name = "arena_reward_tab_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("ArenaRewardTabClass")
        if nil == _homeWindow then
    		fwin:open(ArenaRewardTab:new():init(params[1]), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local arena_reward_tab_close_terminal = {
    _name = "arena_reward_tab_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("ArenaRewardTabClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("ArenaRewardTabClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(arena_reward_tab_open_terminal)
state_machine.add(arena_reward_tab_close_terminal)
state_machine.init()
    
function ArenaRewardTab:ctor()
    self.super:ctor()
    self.roots = {}
	self._current_page = 0
	self._arena_integral = nil
	self._arena_ranking = nil
	self._arena_lucky = nil
	
	app.load("client.red_alert_time.arena.arena_reward_integral_tab")
	app.load("client.red_alert_time.arena.arena_reward_lucky_tab")
	app.load("client.red_alert_time.arena.arena_reward_ranking_tab")
	
	local function init_arena_reward_tab_terminal()
		local arena_reward_tab_show_terminal = {
            _name = "arena_reward_tab_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local arena_reward_tab_hide_terminal = {
            _name = "arena_reward_tab_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		
		-- 翻页
        local arena_reward_tab_page_terminal = {
            _name = "arena_reward_tab_page",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:changeSelectPage(zstring.tonumber(params._datas._page))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(arena_reward_tab_page_terminal)
		
	
        state_machine.add(arena_reward_tab_show_terminal)
        state_machine.add(arena_reward_tab_hide_terminal) 

	
		state_machine.init()
	end
	
	init_arena_reward_tab_terminal()
	
end

function ArenaRewardTab:changeSelectPage( page )
    local root = self.roots[1]
    local Panel_reward_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_reward_tab_box")
    local Button_integral_reward = ccui.Helper:seekWidgetByName(root, "Button_integral_reward")--积分
    local Button_rank_reward = ccui.Helper:seekWidgetByName(root, "Button_rank_reward")--排名
    local Button_lucky_rank = ccui.Helper:seekWidgetByName(root, "Button_lucky_rank")--幸运
	
    if page == self._current_page then
        if page == 1 then
            Button_integral_reward:setHighlighted(true)
        elseif page == 2 then
            Button_rank_reward:setHighlighted(true)
		else
            Button_lucky_rank:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_integral_reward:setHighlighted(false)
    Button_rank_reward:setHighlighted(false)
    Button_lucky_rank:setHighlighted(false)
	
	if self._arena_integral ~= nil then
		state_machine.excute("arena_reward_integral_tab_hide", 0, nil)
	end
	if self._arena_ranking ~= nil then
		state_machine.excute("arena_reward_ranking_tab_hide", 0, nil)
	end
	if self._arena_lucky ~= nil then
		state_machine.excute("arena_reward_lucky_tab_hide", 0, nil)
	end
	
    if page == 1 then
        Button_integral_reward:setHighlighted(true)
        if self._arena_integral == nil then
            self._arena_integral = state_machine.excute("arena_reward_integral_tab_open", 0, {Panel_reward_tab_box})
        else
            state_machine.excute("arena_reward_integral_tab_show", 0, nil)
        end
    elseif page == 2 then
        Button_rank_reward:setHighlighted(true)
        if self._arena_ranking == nil then
            self._arena_ranking = state_machine.excute("arena_reward_ranking_tab_open", 0, {Panel_reward_tab_box})
        else
            state_machine.excute("arena_reward_ranking_tab_show", 0, nil)
        end
    else
        Button_lucky_rank:setHighlighted(true)
        if self._arena_lucky == nil then
            self._arena_lucky = state_machine.excute("arena_reward_lucky_tab_open", 0, {Panel_reward_tab_box})
        else
            state_machine.excute("arena_reward_lucky_tab_show", 0, nil)
        end
    end
end

function ArenaRewardTab:onUpdateDraw()
	local root = self.roots[1]

end


function ArenaRewardTab:init(params1)
	self._rootWindows = params1
    self:onInit()
    return self
end

function ArenaRewardTab:onInit()
    local csbArenaRewardTab = csb.createNode(config_csb.arena.arena_reward_tab)
    local root = csbArenaRewardTab:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbArenaRewardTab)
	
	--翻页积分
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_integral_reward"), nil, 
    {
        terminal_name = "arena_reward_tab_page",
        terminal_state = 0,
		_page = 1,
    },
    nil,1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_arena_integral_reward",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_integral_reward"),
    _invoke = nil,
    _interval = 0.2,})
	--翻页排名
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_rank_reward"), nil, 
    {
        terminal_name = "arena_reward_tab_page",
        terminal_state = 0,
		_page = 2,
    },
    nil,1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_arena_rank_reward",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_rank_reward"),
    _invoke = nil,
    _interval = 0.2,})
	--翻页幸运
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_lucky_rank"), nil, 
    {
        terminal_name = "arena_reward_tab_page",
        terminal_state = 0,
		_page = 3,
    },
    nil,1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_arena_lucky_reward",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_lucky_rank"),
    _invoke = nil,
    _interval = 0.2,})
	
	-- self:onUpdateDraw()
	self:changeSelectPage(1)
end

function ArenaRewardTab:onExit()
    state_machine.remove("arena_reward_tab_show")
    state_machine.remove("arena_reward_tab_hide")
    state_machine.remove("arena_reward_tab_page")
end