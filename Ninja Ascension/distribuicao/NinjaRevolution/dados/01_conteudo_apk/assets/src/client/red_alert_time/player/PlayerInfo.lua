--------------------------------------------------------------------------------------------------------------
--  说明：主页面角色信息
--------------------------------------------------------------------------------------------------------------
PlayerInfo = class("PlayerInfoClass", Window)

--打开界面
local player_info_window_open_terminal = {
	_name = "player_info_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if nil == fwin:find("PlayerInfoClass") then
    		local _wind = PlayerInfo:new()
    		_wind:init(params)
    		fwin:open(_wind, fwin._ui)
        end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local player_info_window_close_terminal = {
	_name = "player_info_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PlayerInfoClass"))
        state_machine.excute("player_fight_update_draw", 0, "")
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(player_info_window_open_terminal)
state_machine.add(player_info_window_close_terminal)
state_machine.init()

function PlayerInfo:ctor()
	self.super:ctor()
	self.roots = {}

    self._current_page = 0
    self._infoPanel = nil
    self._skillPanel = nil
    self._buildPanel = nil

    app.load("client.red_alert_time.player.PlayerInfomation")
    app.load("client.red_alert_time.player.PlayerInfoSkill")
    app.load("client.red_alert_time.player.PlayerInfoBuildUpgrade")
    local function init_play_info_terminal()
		-- 刷新角色头像信息等级
        local player_info_change_page_terminal = {
            _name = "player_info_change_page",
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

        -- 显示
        local player_info_show_terminal = {
            _name = "player_info_show",
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

        -- 隐藏
        local player_info_hide_terminal = {
            _name = "player_info_hide",
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

        -- 隐藏
        local player_info_window_close_check_terminal = {
            _name = "player_info_window_close_check",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("player_info_window_close", 0, 0)
                -- 校验开启教学事件
                state_machine.excute("main_window_check_mission", 0, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(player_info_change_page_terminal)	
        state_machine.add(player_info_show_terminal)	
        state_machine.add(player_info_hide_terminal)
        state_machine.add(player_info_window_close_check_terminal)   
        state_machine.init()
    end
    init_play_info_terminal()
end

function PlayerInfo:changeSelectPage( page )
    local root = self.roots[1]
    local Panel_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_tab_box")
    local Button_information = ccui.Helper:seekWidgetByName(root, "Button_information")
    local Button_skill = ccui.Helper:seekWidgetByName(root, "Button_skill")
    local Button_build = ccui.Helper:seekWidgetByName(root, "Button_build")
    if page == self._current_page then
        if page == 1 then
            Button_information:setHighlighted(true)
        elseif page == 2 then
            Button_skill:setHighlighted(true)
        else
            Button_build:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_information:setHighlighted(false)
    Button_skill:setHighlighted(false)
    Button_build:setHighlighted(false)
    state_machine.excute("player_infomation_hide", 0, nil)
    state_machine.excute("player_info_skill_hide", 0, nil)
    state_machine.excute("player_info_build_upgrade_hide", 0, nil)
    if page == 1 then
        Button_information:setHighlighted(true)
        if self._infoPanel == nil then
            self._infoPanel = state_machine.excute("player_infomation_open", 0, {Panel_tab_box})
        else
            state_machine.excute("player_infomation_show", 0, nil)
        end
    elseif page == 2 then
        Button_skill:setHighlighted(true)
        if self._skillPanel == nil then
            self._skillPanel = state_machine.excute("player_info_skill_open", 0, {Panel_tab_box})
        else
            state_machine.excute("player_info_skill_show", 0, nil)
        end
    else
        Button_build:setHighlighted(true)
        if self._buildPanel == nil then
            self._buildPanel = state_machine.excute("player_info_build_upgrade_open", 0, {Panel_tab_box})
        else
            state_machine.excute("player_info_build_upgrade_show", 0, nil)
        end
    end
end

function PlayerInfo:onInit(params)
    local csbItem = csb.createNode(config_csb.player.player_info)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

    self.__check_covers = true
    root.__cwindow = self
    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "player_info_window_close_check", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)      

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_information"), nil, 
    {
        terminal_name = "player_info_change_page", 
        terminal_state = 0, 
        _page = 1,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_skill"), nil, 
    {
        terminal_name = "player_info_change_page", 
        terminal_state = 0, 
        _page = 2,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_build"), nil, 
    {
        terminal_name = "player_info_change_page", 
        terminal_state = 0, 
        _page = 3,
    }, nil, 1)

    if params ~= nil and params._datas ~= nil and params._datas._page ~= nil then
        self:changeSelectPage(tonumber(params._datas._page))
    else
        self:changeSelectPage(1)
    end
end

function PlayerInfo:onEnterTransitionFinish()

end

function PlayerInfo:init(params)
    self:setTouchEnabled(true)
	self:onInit(params)
end

function PlayerInfo:onExit()
    state_machine.remove("player_info_change_page")
    state_machine.remove("player_info_show")
    state_machine.remove("player_info_hide")
    state_machine.remove("player_info_window_close_check")
end