-- ----------------------------------------------------------------------------------------------------
-- 说明：头像界面
-------------------------------------------------------------------------------------------------------
PlayerHeadChange = class("PlayerHeadChangeClass", Window)
local player_head_change_open_terminal = {
    _name = "player_head_change_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("PlayerHeadChangeClass")
        if nil == _homeWindow then
    		fwin:open(PlayerHeadChange:new():init(params), fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local player_head_change_close_terminal = {
    _name = "player_head_change_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("PlayerHeadChangeClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("PlayerHeadChangeClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(player_head_change_open_terminal)
state_machine.add(player_head_change_close_terminal)
state_machine.init()
    
function PlayerHeadChange:ctor()
    self.super:ctor()
    self.roots = {}
	self._params = nil
	self._current_page = 0
	
	self._collection_friend = nil
    self._collection_enrge = nil
    self._collection_shield = nil
	
	app.load("client.red_alert_time.player.PlayerStampSettings")
	app.load("client.red_alert_time.player.PlayerAvatarSettings")
	app.load("client.red_alert_time.player.PlayerTitleSet")
	
	
	local function init_player_head_change_terminal()
		-- 翻页
        local player_head_change_page_terminal = {
            _name = "player_head_change_page",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if funOpenDrawTip(233 + params._datas._page) == true then
                    return
                end
				instance:changeSelectPage(zstring.tonumber(params._datas._page))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(player_head_change_page_terminal)
	
		state_machine.init()
	end
	
	init_player_head_change_terminal()
	
end

function PlayerHeadChange:changeSelectPage( page )
    local root = self.roots[1]
    local Panel_player_head_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_player_head_tab_box")
    local Button_player_head = ccui.Helper:seekWidgetByName(root, "Button_player_head")
    local Button_head_ornaments = ccui.Helper:seekWidgetByName(root, "Button_head_ornaments")
    local Button_player_title = ccui.Helper:seekWidgetByName(root, "Button_player_title")
    if page == self._current_page then
        if page == 1 then
            Button_player_head:setHighlighted(true)
        elseif page == 2 then
            Button_head_ornaments:setHighlighted(true)
		elseif page == 3 then
			Button_player_title:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_player_head:setHighlighted(false)
    Button_head_ornaments:setHighlighted(false)
    Button_player_title:setHighlighted(false)
	if self._collection_friend ~= nil then
		state_machine.excute("player_stamp_settings_hide", 0, nil)
	end
	if self._collection_enrge ~= nil then
		state_machine.excute("player_avatar_settings_hide", 0, nil)
	end
	if self._collection_shield ~= nil then
		state_machine.excute("player_title_set_hide", 0, nil)
	end
	
    if page == 1 then
        Button_player_head:setHighlighted(true)
        if self._collection_friend == nil then
            self._collection_friend = state_machine.excute("player_stamp_settings_open", 0, {Panel_player_head_tab_box})
        else
            state_machine.excute("player_stamp_settings_show", 0, nil)
        end
    elseif page == 2 then
        Button_head_ornaments:setHighlighted(true)
        if self._collection_enrge == nil then
            self._collection_enrge = state_machine.excute("player_avatar_settings_open", 0, {Panel_player_head_tab_box})
        else
            state_machine.excute("player_avatar_settings_show", 0, nil)
        end
	elseif page == 3 then
        Button_player_title:setHighlighted(true)
        if self._collection_shield == nil then
            self._collection_shield = state_machine.excute("player_title_set_open", 0, {Panel_player_head_tab_box})
        else
            state_machine.excute("player_title_set_show", 0, nil)
        end
    end
end

function PlayerHeadChange:init(params)
	self._params = params
    self:setTouchEnabled(true)
    self:onInit()
    return self
end

function PlayerHeadChange:onInit()
    local csbPlayerHeadChange = csb.createNode(config_csb.player.player_head_change)
    local root = csbPlayerHeadChange:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbPlayerHeadChange)
	
	Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)
	
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_player_head_change_close"), nil, 
    {
        terminal_name = "player_head_change_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)
	
	--头像
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_player_head"), nil, 
    {
        terminal_name = "player_head_change_page", 
        terminal_state = 0, 
        _page = 1,
    }, nil, 1)
	
	--挂饰
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_head_ornaments"), nil, 
    {
        terminal_name = "player_head_change_page", 
        terminal_state = 0, 
        _page = 2,
    }, nil, 1)
	
	--称号
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_player_title"), nil, 
    {
        terminal_name = "player_head_change_page", 
        terminal_state = 0, 
        _page = 3,
    }, nil, 1)
	
	if self._params ~= nil and self._params._datas ~= nil and self._params._datas.page ~= nil then
        self:changeSelectPage(tonumber(self._params._datas.page))
    else
        self:changeSelectPage(1)
    end
end

function PlayerHeadChange:onExit()
	
end