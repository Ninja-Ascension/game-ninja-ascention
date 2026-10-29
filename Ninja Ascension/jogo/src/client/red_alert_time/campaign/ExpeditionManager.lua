-- ------------------------------------------------------------------------------------------------------------
--  说明：远征界面
-- ------------------------------------------------------------------------------------------------------------
ExpeditionManager = class("ExpeditionManagerClass", Window)

--打开界面
local expedition_manager_window_open_terminal = {
	_name = "expedition_manager_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        state_machine.lock("expedition_manager_window_open", 0, 0)
        local function responseCallback(response)
            state_machine.unlock("expedition_manager_window_open", 0, 0)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if fwin:find("ExpeditionManagerClass") == nil then
                    fwin:open(ExpeditionManager:new():init(params), fwin._ui)  
                end
            end
        end
        protocol_command.expedition_init.param_list = ""
        NetworkManager:register(protocol_command.expedition_init.code, nil, nil, nil, nil, responseCallback, false, nil)
	    return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local expedition_manager_window_close_terminal = {
	_name = "expedition_manager_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ExpeditionManagerClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(expedition_manager_window_open_terminal)
state_machine.add(expedition_manager_window_close_terminal)
state_machine.init()

function ExpeditionManager:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}

    self._current_page = 0
    self._pages = {}
    self._buttons = {}

    app.load("client.red_alert_time.campaign.Expedition")
    app.load("client.red_alert_time.campaign.ExpeditionRecord")
    app.load("client.red_alert_time.campaign.ExpeditionShop")
    app.load("client.red_alert_time.cells.campaign.expedition_shop_cell")
    app.load("client.red_alert_time.cells.campaign.expedition_record_cell")
    app.load("client.red_alert_time.cells.campaign.expedition_pve_npc_cell")

    local function init_expedition_manager_terminal()
        local expedition_manager_change_page_terminal = {
            _name = "expedition_manager_change_page",
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

        state_machine.add(expedition_manager_change_page_terminal)
        state_machine.init()
    end
    
    init_expedition_manager_terminal()
end

function ExpeditionManager:changeSelectPage(page)
    local root = self.roots[1]
    local Panel_expedition_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_expedition_tab_box")
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

    if page == 1 then
        if self._pages[""..page] == nil then
            self._pages[""..page] = state_machine.excute("expedition_window_open", 0, {Panel_expedition_tab_box})
        else
            state_machine.excute("expedition_show", 0, nil)
        end
    elseif page == 2 then
        if self._pages[""..page] == nil then
            self._pages[""..page] = state_machine.excute("expedition_shop_window_open", 0, {Panel_expedition_tab_box})
        else
            state_machine.excute("expedition_shop_show", 0, nil)
        end
    else
        if self._pages[""..page] == nil then
            self._pages[""..page] = state_machine.excute("expedition_record_window_open", 0, {Panel_expedition_tab_box})
        else
            state_machine.excute("expedition_record_show", 0, nil)
        end
    end
end

function ExpeditionManager:onInit(param)
    local csbItem = csb.createNode(config_csb.campaign.expedition_manager)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self.__check_covers = true
    root.__cwindow = self
    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_box_get)

    -- 关闭界面
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_expedition_close"), nil, 
    {
        terminal_name = "expedition_manager_window_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)

    self._buttons = {ccui.Helper:seekWidgetByName(root, "Button_expedition"),
            ccui.Helper:seekWidgetByName(root, "Button_expedition_shop"),
            ccui.Helper:seekWidgetByName(root, "Button_expedition_record")}

    for k,v in pairs(self._buttons) do
        fwin:addTouchEventListener(v, nil, 
        {
            terminal_name = "expedition_manager_change_page", 
            terminal_state = 0, 
            _page = k,
        }, nil, 1)
    end

    protocol_command.battlefield_report_get.param_list = battle_enum._fight_type._fight_type_201
    NetworkManager:register(protocol_command.battlefield_report_get.code, nil, nil, nil, nil, nil, false, nil)
    
    if params ~= nil and params._datas ~= nil and params._datas._page ~= nil then
        self:changeSelectPage(tonumber(params._datas._page))
    else
        self:changeSelectPage(1)
    end
end

function ExpeditionManager:onEnterTransitionFinish()
    checkEffectLevelUp()
end

function ExpeditionManager:init(param)
	self:onInit(param)
    return self
end

function ExpeditionManager:onExit()
    state_machine.remove("expedition_manager_change_page")
end
