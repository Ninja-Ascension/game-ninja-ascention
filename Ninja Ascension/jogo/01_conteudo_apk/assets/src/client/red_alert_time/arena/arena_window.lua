-- ----------------------------------------------------------------------------------------------------
-- 说明：战地争霸主页
-------------------------------------------------------------------------------------------------------
ArenaWindow = class("ArenaWindowClass", Window)

local arena_window_open_terminal = {
    _name = "arena_window_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if fwin:find("ArenaWindowClass") == nil then
                    fwin:open(ArenaWindow:new():init(params), fwin._ui)
                end
            end
        end
        protocol_command.arena_init.param_list = "0"
        NetworkManager:register(protocol_command.arena_init.code, nil, nil, nil, nil, responseCallback, false, nil)

        -- 进入战地争霸时 触发教学
        state_machine.excute("main_window_check_mission", 0, 0)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local arena_window_close_terminal = {
    _name = "arena_window_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("ArenaWindowClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("ArenaWindowClass"))
        end
        -- 校验开启教学事件
        state_machine.excute("main_window_check_mission", 0, 0)
        if _ED.city_rank ~= nil then
            if _ED.city_rank.other_user ~= nil then
                _ED.city_rank.other_user[1] = {}
            end
        end
        state_machine.excute("home_map_update_prodcution_state", 0, {4})
        cacher.removeAllTextures()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(arena_window_open_terminal)
state_machine.add(arena_window_close_terminal)
state_machine.init()
    
function ArenaWindow:ctor()
    self.super:ctor()
    self.roots = {}
	self._params = nil
	self._current_page = 0
	self._arena_dearon = nil
	self._arena_troops = nil
	self._arena_shop = nil
	self._arena_rank = nil
	self._arena_reward = nil
	
	app.load("client.red_alert_time.arena.arena_dearon_tab")
	app.load("client.red_alert_time.arena.arena_troops_tab")
	app.load("client.red_alert_time.arena.arena_shop_tab")
	app.load("client.red_alert_time.arena.arena_rank_tab")
	app.load("client.red_alert_time.arena.arena_reward_tab")
    app.load("client.red_alert_time.formation.FormationDefend")
    app.load("client.red_alert_time.formation.FormationChooseTroop")
    app.load("client.red_alert_time.formation.FormationManage")
    app.load("client.red_alert_time.formation.FormationLeaderChoose")
    app.load("client.red_alert_time.formation.FormationFactor")
    app.load("client.red_alert_time.cells.formation.formation_tank_head_cell")
    app.load("client.red_alert_time.cells.formation.formation_leader_head_cell")
    app.load("client.red_alert_time.cells.formation.formation_manage_enabled_cell")
    app.load("client.red_alert_time.cells.formation.formation_manage_disabled_cell")
    app.load("client.red_alert_time.cells.formation.formation_implement_cell")
    app.load("client.red_alert_time.cells.formation.formation_choose_leader_cell")

    app.load("client.red_alert_time.leader.LeaderExchangeInfo")
	
	local function init_arena_window_terminal()
		-- 翻页
        local arena_window_page_terminal = {
            _name = "arena_window_page",
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

        state_machine.add(arena_window_page_terminal)
	
		state_machine.init()
	end
	
	init_arena_window_terminal()
	
end

function ArenaWindow:changeSelectPage( page )
    local root = self.roots[1]
    local Panel_arena_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_arena_tab_box")
    local Button_arena_dearon = ccui.Helper:seekWidgetByName(root, "Button_arena_dearon")--挑战
    local Button_arena_troops = ccui.Helper:seekWidgetByName(root, "Button_arena_troops")--部队
    local Button_arena_shop = ccui.Helper:seekWidgetByName(root, "Button_arena_shop")--商店
    local Button_arena_rank = ccui.Helper:seekWidgetByName(root, "Button_arena_rank")--排行
    local Button_arena_reward = ccui.Helper:seekWidgetByName(root, "Button_arena_reward")--奖励
	
    if page == self._current_page then
        if page == 1 then
            Button_arena_dearon:setHighlighted(true)
        elseif page == 2 then
            Button_arena_troops:setHighlighted(true)
		elseif page == 3 then
			Button_arena_shop:setHighlighted(true)
		elseif page == 4 then
			Button_arena_rank:setHighlighted(true)
        else
            Button_arena_reward:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_arena_dearon:setHighlighted(false)
    Button_arena_troops:setHighlighted(false)
    Button_arena_shop:setHighlighted(false)
    Button_arena_rank:setHighlighted(false)
    Button_arena_reward:setHighlighted(false)
	
	if self._arena_dearon ~= nil then
		state_machine.excute("arena_dearon_tab_hide", 0, nil)
	end
	if self._arena_troops ~= nil then
		state_machine.excute("formation_defend_hide", 0, nil)
	end
	if self._arena_shop ~= nil then
		state_machine.excute("arena_shop_tab_hide", 0, nil)
	end
	
	if self._arena_rank ~= nil then
		state_machine.excute("arena_rank_tab_hide", 0, nil)
	end
	
	if self._arena_reward ~= nil then
		state_machine.excute("arena_reward_tab_hide", 0, nil)
	end
	
    if page == 1 then
        Button_arena_dearon:setHighlighted(true)
        if self._arena_dearon == nil then
            self._arena_dearon = state_machine.excute("arena_dearon_tab_open", 0, {Panel_arena_tab_box})
        else
            state_machine.excute("arena_dearon_tab_show", 0, nil)
        end
    elseif page == 2 then
        Button_arena_troops:setHighlighted(true)
        if self._arena_troops == nil then
            self._arena_troops = state_machine.excute("formation_defend_open", 0, {Panel_arena_tab_box, 11})
        else
            state_machine.excute("formation_defend_show", 0, nil)
        end
	elseif page == 3 then
        Button_arena_shop:setHighlighted(true)
        if self._arena_shop == nil then
            self._arena_shop = state_machine.excute("arena_shop_tab_open", 0, {Panel_arena_tab_box})
        else
            state_machine.excute("arena_shop_tab_show", 0, nil)
        end
	elseif page == 4 then
        Button_arena_rank:setHighlighted(true)
        if self._arena_rank == nil then
            self._arena_rank = state_machine.excute("arena_rank_tab_open", 0, {Panel_arena_tab_box})
        else
            state_machine.excute("arena_rank_tab_show", 0, nil)
        end	
    else
        Button_arena_reward:setHighlighted(true)
        if self._arena_reward == nil then
            self._arena_reward = state_machine.excute("arena_reward_tab_open", 0, {Panel_arena_tab_box,1})
        else
            state_machine.excute("arena_reward_tab_show", 0, nil)
        end
    end
end

function ArenaWindow:init(params)
	self._params = params
    self:setTouchEnabled(true)
    self:onInit()
    return self
end

function ArenaWindow:onInit()
    local csbArenaWindow = csb.createNode(config_csb.arena.window )
    local root = csbArenaWindow:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbArenaWindow)
	
    self.__check_covers = true
    root.__cwindow = self
	Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)
	
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_arena_close"), nil, 
    {
        terminal_name = "arena_window_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)
	
	--翻页挑战
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_arena_dearon"), nil, 
    {
        terminal_name = "arena_window_page",
        terminal_state = 0,
		_page = 1,
    },
    nil,1)
	--翻页部队
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_arena_troops"), nil, 
    {
        terminal_name = "arena_window_page",
        terminal_state = 0,
		_page = 2,
    },
    nil,1)
	--翻页商店
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_arena_shop"), nil, 
    {
        terminal_name = "arena_window_page",
        terminal_state = 0,
		_page = 3,
    },
    nil,1)
	--翻页排行
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_arena_rank"), nil, 
    {
        terminal_name = "arena_window_page",
        terminal_state = 0,
		_page = 4,
    },
    nil,1)
	--翻页奖励
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_arena_reward"), nil, 
    {
        terminal_name = "arena_window_page",
        terminal_state = 0,
		_page = 5,
    },
    nil,1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_arena_all_reward",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_arena_reward"),
    _invoke = nil,
    _interval = 0.2,})
	
	if self._params ~= nil and self._params._datas ~= nil and self._params._datas.page ~= nil then
        self:changeSelectPage(tonumber(self._params._datas.page))
    else
        self:changeSelectPage(1)
    end
end

function ArenaWindow:onExit()
	state_machine.remove("arena_window_page")
end