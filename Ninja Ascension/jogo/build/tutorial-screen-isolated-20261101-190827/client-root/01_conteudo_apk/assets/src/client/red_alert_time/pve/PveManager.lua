--------------------------------------------------------------------------------------------------------------
--  说明：副本
--------------------------------------------------------------------------------------------------------------
PveManager = class("PveManagerClass", Window)

--打开界面
local pve_manager_window_open_terminal = {
	_name = "pve_manager_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        -- state_machine.excute("pve_manager_window_close", 0, 0)
        if fwin:find("PveManagerClass") == nil then
    		local _wind = PveManager:new()
    		_wind:init(params)
    		fwin:open(_wind, fwin._ui)
        end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local pve_manager_window_close_terminal = {
	_name = "pve_manager_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PveManagerClass"))
        state_machine.excute("main_window_update_userinfo", 0, nil)
        -- state_machine.excute("main_window_check_mission", 0, 0)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(pve_manager_window_open_terminal)
state_machine.add(pve_manager_window_close_terminal)
state_machine.init()

function PveManager:ctor()
	self.super:ctor()
	self.roots = {}

    self._current_page = 0
    self._chapterPanel = nil
    self._supplyPanel = nil
    self._armorPanel = nil

    app.load("client.red_alert_time.pve.PveChapter")
    app.load("client.red_alert_time.pve.PveMap")
    app.load("client.red_alert_time.pve.PveStarReward")
    app.load("client.red_alert_time.pve.PveTroopsAttribute")
    app.load("client.red_alert_time.pve.PvePartsSupplyTab")
    app.load("client.red_alert_time.pve.PveArmorTab")
    app.load("client.red_alert_time.pve.PveAttack")
    app.load("client.red_alert_time.pve.PveRaid")
    app.load("client.red_alert_time.pve.PveTroopsAttributeEx")

    -- app.load("client.red_alert_time.cells.pve.pve_chapter_cell")
    -- app.load("client.red_alert_time.cells.pve.pve_gain_cell")
    -- app.load("client.red_alert_time.cells.pve.pve_npc_cell")
    -- app.load("client.red_alert_time.cells.pve.pve_star_box_cell")
    -- app.load("client.red_alert_time.cells.pve.pve_troops_attribute_cell")
    -- app.load("client.red_alert_time.cells.pve.pve_parts_supply_lock_cell")
    -- app.load("client.red_alert_time.cells.pve.pve_parts_supply_unlock_cell")

    app.load("client.red_alert_time.battle.battle_enum")

    local function init_pve_manager_terminal()
        local pve_manager_change_page_terminal = {
            _name = "pve_manager_change_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local page = tonumber(params._datas._page)
                if page == 3 and funOpenDrawTip(204) == true then
                    return
                end
                instance:changeSelectPage(page)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 显示
        local pve_manager_show_terminal = {
            _name = "pve_manager_show",
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
        local pve_manager_hide_terminal = {
            _name = "pve_manager_hide",
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

		state_machine.add(pve_manager_change_page_terminal)	
        state_machine.add(pve_manager_show_terminal)	
        state_machine.add(pve_manager_hide_terminal)    
        state_machine.init()
    end
    init_pve_manager_terminal()
end

function PveManager:changeSelectPage( page )
    local root = self.roots[1]
    local Panel_pve_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_pve_tab_box")
    local Text_pve_title = ccui.Helper:seekWidgetByName(root, "Text_pve_title")
    local Button_pve_chapter = ccui.Helper:seekWidgetByName(root, "Button_pve_chapter")
    local Button_parts_supply = ccui.Helper:seekWidgetByName(root, "Button_parts_supply")
    local Button_armor_supply = ccui.Helper:seekWidgetByName(root, "Button_armor_supply")
    if page == self._current_page then
        if page == 1 then
            Button_pve_chapter:setHighlighted(true)
        elseif page == 2 then
            Button_parts_supply:setHighlighted(true)
        elseif page == 3 then
            if nil ~= Button_armor_supply then
                Button_armor_supply:setHighlighted(true)
            end
        end
        return
    end
    self._current_page = page
    Button_pve_chapter:setHighlighted(false)
    Button_parts_supply:setHighlighted(false)
    if nil ~= Button_armor_supply then
        Button_armor_supply:setHighlighted(false)
    end
    state_machine.excute("pve_chapter_hide", 0, nil)
    state_machine.excute("pve_parts_supply_tab_hide", 0, nil)
    state_machine.excute("pve_armor_tab_hide", 0, nil)
    if page == 1 then
        Button_pve_chapter:setHighlighted(true)
        if self._chapterPanel == nil then
            self._chapterPanel = state_machine.excute("pve_chapter_open", 0, {Panel_pve_tab_box})
        else
            state_machine.excute("pve_chapter_show", 0, nil)
        end
    elseif page == 2 then
        Button_parts_supply:setHighlighted(true)
        if self._supplyPanel == nil then
            self._supplyPanel = state_machine.excute("pve_parts_supply_tab_open", 0, {Panel_pve_tab_box})
        else
            state_machine.excute("pve_parts_supply_tab_show", 0, nil)
        end
    elseif page == 3 then
        if nil ~= Button_armor_supply then
            Button_armor_supply:setHighlighted(true)
        end
        if self._armorPanel == nil then
            self._armorPanel = state_machine.excute("pve_armor_tab_open", 0, {Panel_pve_tab_box})
        else
            state_machine.excute("pve_armor_tab_show", 0, nil)
        end
    end
end

function PveManager:onInit(params)
    local csbItem = csb.createNode(config_csb.pve.pve)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    
    

    self.__check_covers = true
    root.__cwindow = self
    local time = nil
    if false == missionIsOver() then
        time = 0
        self._view = fwin._ui
        self:onCheckCovers(self)
    else
        Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN, time)
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pve_close"), nil, 
    {
        terminal_name = "pve_manager_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)      

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pve_chapter"), nil, 
    {
        terminal_name = "pve_manager_change_page", 
        terminal_state = 0, 
        _page = 1,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_parts_supply"), nil, 
    {
        terminal_name = "pve_manager_change_page", 
        terminal_state = 0, 
        _page = 2,
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_pve_parts_supply",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_parts_supply"),
    _invoke = nil,
    _interval = 0.2,})

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_armor_supply"), nil, 
    {
        terminal_name = "pve_manager_change_page", 
        terminal_state = 0, 
        _page = 3,
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_pve_armor",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_armor_supply"),
    _invoke = nil,
    _interval = 0.2,})

    if params ~= nil and params._datas ~= nil and params._datas._page ~= nil then
        self:changeSelectPage(tonumber(params._datas._page))
    else
        self:changeSelectPage(1)
    end
end

function PveManager:onEnterTransitionFinish()

end

function PveManager:init(params)
    self:setTouchEnabled(true)
	self:onInit(params)
end

function PveManager:onExit()
    state_machine.remove("pve_manager_change_page")
    state_machine.remove("pve_manager_show")
    state_machine.remove("pve_manager_hide")
end