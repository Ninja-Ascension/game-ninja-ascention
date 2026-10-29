--------------------------------------------------------------------------------------------------------------
--  说明：工会切磋
--------------------------------------------------------------------------------------------------------------
LegionPK = class("LegionPKClass", Window)

--打开界面
local legion_pk_open_terminal = {
	_name = "legion_pk_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        local function responseCallback2(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                fwin:open(LegionPK:new():init(params), fwin._ui)
            end
        end

        local function responseCallback1(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                protocol_command.battlefield_report_get.param_list = 10001
                NetworkManager:register(protocol_command.battlefield_report_get.code, nil, nil, nil, nil, responseCallback2, false, nil)
            end
        end
        protocol_command.battlefield_report_get.param_list = battle_enum._fight_type._fight_type_24
        NetworkManager:register(protocol_command.battlefield_report_get.code, nil, nil, nil, nil, responseCallback1, false, nil)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local legion_pk_close_terminal = {
	_name = "legion_pk_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        _ED._legion_pk_defender_id = 0
        fwin:close(fwin:find("LegionPKClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(legion_pk_open_terminal)
state_machine.add(legion_pk_close_terminal)
state_machine.init()

function LegionPK:ctor()
	self.super:ctor()
	self.roots = {}

    self._current_page = 0
    self._pkPanel = nil
    self._recordPanel = nil

    app.load("client.red_alert_time.legion.LegionPKList")
    app.load("client.red_alert_time.legion.LegionPKRecord")
    app.load("client.red_alert_time.legion.LegionPKAttack")
    app.load("client.red_alert_time.cells.legion.legion_pk_list_cell")
    app.load("client.red_alert_time.cells.legion.legion_pk_record_cell")

    local function init_legion_pk_terminal()
        local legion_pk_change_page_terminal = {
            _name = "legion_pk_change_page",
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

		state_machine.add(legion_pk_change_page_terminal)   
        state_machine.init()
    end
    init_legion_pk_terminal()
end

function LegionPK:changeSelectPage( page )
    local root = self.roots[1]
    local Panel_welfare_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_welfare_tab_box")

    local Button_legion_reward_packs = ccui.Helper:seekWidgetByName(root, "Button_legion_reward_packs")
    local Button_legion_glory = ccui.Helper:seekWidgetByName(root, "Button_legion_glory")
    if page == self._current_page then
        if page == 1 then
            Button_legion_reward_packs:setHighlighted(true)
        else
            Button_legion_glory:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_legion_reward_packs:setHighlighted(false)
    Button_legion_glory:setHighlighted(false)
    state_machine.excute("legion_pk_list_hide", 0, nil)
    state_machine.excute("legion_pk_record_hide", 0, nil)
    if page == 1 then
        Button_legion_reward_packs:setHighlighted(true)
        if self._pkPanel == nil then
            self._pkPanel = state_machine.excute("legion_pk_list_open", 0, {Panel_welfare_tab_box})
        else
            state_machine.excute("legion_pk_list_show", 0, nil)
        end
    else
        Button_legion_glory:setHighlighted(true)
        if self._recordPanel == nil then
            self._recordPanel = state_machine.excute("legion_pk_record_open", 0, {Panel_welfare_tab_box})
        else
            state_machine.excute("legion_pk_record_show", 0, nil)
        end
    end
end

function LegionPK:onInit(params)
    local csbItem = csb.createNode(config_csb.legion.legion_member_vs)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_welfare_close"), nil, 
    {
        terminal_name = "legion_pk_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)      

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_reward_packs"), nil, 
    {
        terminal_name = "legion_pk_change_page", 
        terminal_state = 0, 
        _page = 1,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_glory"), nil, 
    {
        terminal_name = "legion_pk_change_page", 
        terminal_state = 0, 
        _page = 2,
    }, nil, 1)

    if params ~= nil and params._datas ~= nil and params._datas._page ~= nil then
        self:changeSelectPage(tonumber(params._datas._page))
    else
        self:changeSelectPage(1)
    end
end

function LegionPK:onEnterTransitionFinish()

end

function LegionPK:init(params)
    self:setTouchEnabled(true)
	self:onInit(params)
    return self
end

function LegionPK:onExit()
    state_machine.remove("legion_pk_change_page")
end