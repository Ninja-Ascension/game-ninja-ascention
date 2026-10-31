-- ----------------------------------------------------------------------------------------------------
-- 说明：战地争霸排行界面
-------------------------------------------------------------------------------------------------------
ArenaRankTab = class("ArenaRankTabClass", Window)

local arena_rank_tab_open_terminal = {
    _name = "arena_rank_tab_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("ArenaRankTabClass")
        if nil == _homeWindow then
    		fwin:open(ArenaRankTab:new():init(params[1]), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local arena_rank_tab_close_terminal = {
    _name = "arena_rank_tab_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("ArenaRankTabClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("ArenaRankTabClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(arena_rank_tab_open_terminal)
state_machine.add(arena_rank_tab_close_terminal)
state_machine.init()
    
function ArenaRankTab:ctor()
    self.super:ctor()
    self.roots = {}
	self._current_page = 0
	self._arena_rank_all = nil
	self._arena_rank_lucky = nil
	
	app.load("client.red_alert_time.arena.arena_rank_all_tab")
	app.load("client.red_alert_time.arena.arena_rank_lucky_tab")
	
	local function init_arena_rank_tab_terminal()
		local arena_rank_tab_show_terminal = {
            _name = "arena_rank_tab_show",
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

        local arena_rank_tab_hide_terminal = {
            _name = "arena_rank_tab_hide",
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
        local arena_rank_tab_page_terminal = {
            _name = "arena_rank_tab_page",
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

        state_machine.add(arena_rank_tab_page_terminal)
        state_machine.add(arena_rank_tab_show_terminal)
        state_machine.add(arena_rank_tab_hide_terminal) 
		state_machine.init()
	end
	
	init_arena_rank_tab_terminal()
	
end

function ArenaRankTab:onUpdateDraw()
	local root = self.roots[1]

end

function ArenaRankTab:changeSelectPage( page )
    local root = self.roots[1]
    local Panel_arena_rank_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_arena_rank_tab_box")
    local Button_arena_rank = ccui.Helper:seekWidgetByName(root, "Button_arena_rank")--排行
    local Button_arena_lucky_rank = ccui.Helper:seekWidgetByName(root, "Button_arena_lucky_rank")--幸运排行
	
    if page == self._current_page then
        if page == 1 then
            Button_arena_rank:setHighlighted(true)
        else
            Button_arena_lucky_rank:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_arena_rank:setHighlighted(false)
    Button_arena_lucky_rank:setHighlighted(false)
	
	if self._arena_rank_all ~= nil then
		state_machine.excute("arena_rank_all_tab_hide", 0, nil)
	end
	if self._arena_rank_lucky ~= nil then
		state_machine.excute("arena_rank_lucky_tab_hide", 0, nil)
	end
	
    if page == 1 then
        Button_arena_rank:setHighlighted(true)
        if self._arena_rank_all == nil then
            self._arena_rank_all = state_machine.excute("arena_rank_all_tab_open", 0, {Panel_arena_rank_tab_box})
        else
            state_machine.excute("arena_rank_all_tab_show", 0, nil)
        end
    else
        Button_arena_lucky_rank:setHighlighted(true)
        if self._arena_rank_lucky == nil then
            self._arena_rank_lucky = state_machine.excute("arena_rank_lucky_tab_open", 0, {Panel_arena_rank_tab_box})
        else
            state_machine.excute("arena_rank_lucky_tab_show", 0, nil)
        end
    end
end

function ArenaRankTab:init(params1)
	self._rootWindows = params1
    self:onInit()
    return self
end

function ArenaRankTab:onInit()
    local csbArenaRankTab = csb.createNode(config_csb.arena.arena_rank_tab)
    local root = csbArenaRankTab:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbArenaRankTab)
	
	--排行榜
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_arena_rank"), nil, 
    {
        terminal_name = "arena_rank_tab_page",
        terminal_state = 0,
		_page = 1,
    },
    nil,1)
	
	--幸运排行
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_arena_lucky_rank"), nil, 
    {
        terminal_name = "arena_rank_tab_page",
        terminal_state = 0,
		_page = 2,
    },
    nil,1)
	
	self:changeSelectPage(1)
	-- self:onUpdateDraw()
end

function ArenaRankTab:onExit()
    state_machine.remove("arena_rank_tab_show")
    state_machine.remove("arena_rank_tab_hide")
    state_machine.remove("arena_rank_tab_page")
end