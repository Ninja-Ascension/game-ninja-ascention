-- ----------------------------------------------------------------------------------------------------
-- 说明：战地争霸战报
-------------------------------------------------------------------------------------------------------
ArenaRecord = class("ArenaRecordClass", Window)

local arena_record_open_terminal = {
    _name = "arena_record_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("ArenaRecordClass")
        if nil == _homeWindow then
    		fwin:open(ArenaRecord:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local arena_record_close_terminal = {
    _name = "arena_record_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("ArenaRecordClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("ArenaRecordClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(arena_record_open_terminal)
state_machine.add(arena_record_close_terminal)
state_machine.init()
    
function ArenaRecord:ctor()
    self.super:ctor()
    self.roots = {}
	self._params = nil
	self._current_page = 0
	self._arena_dearon = nil
	self._arena_troops = nil

	app.load("client.red_alert_time.arena.arena_my_record_tab")
	app.load("client.red_alert_time.arena.arena_service_record_tab")
	
	local function init_arena_record_terminal()
		-- 翻页
        local arena_record_page_terminal = {
            _name = "arena_record_page",
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

        -- 全部已读
        local arena_record_read_terminal = {
            _name = "arena_record_read",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local report_type = 0
                if instance._current_page == 1 then
                    report_type = 11
                else
                    report_type = 10000
                end

                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if _ED.city_resource_battle_report[report_type] ~= nil then
                            for i, v in pairs(_ED.city_resource_battle_report[report_type]) do
                                _ED.city_resource_battle_report[report_type][i].read_type = 1
                            end
                        end
                        if report_type == 11 then
                            state_machine.excute("arena_my_record_tab_update_draw", 0, nil)
                        else
                            state_machine.excute("arena_service_record_tab_update_draw", 0, nil)
                        end
                        state_machine.excute("notification_center_update", 0, "push_notification_arena_record")
                    end
                end
                protocol_command.one_key_read_message.param_list = report_type
                NetworkManager:register(protocol_command.one_key_read_message.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(arena_record_page_terminal)
        state_machine.add(arena_record_read_terminal)
	
		state_machine.init()
	end
	
	init_arena_record_terminal()
	
end

function ArenaRecord:changeSelectPage( page )
    local root = self.roots[1]
    local Panel_arena_record = ccui.Helper:seekWidgetByName(root, "Panel_arena_record")
    local Button_arena_record_me = ccui.Helper:seekWidgetByName(root, "Button_arena_record_me")--我的战报
    local Button_arena_record_me_all = ccui.Helper:seekWidgetByName(root, "Button_arena_record_me_all")--部队

    if page == self._current_page then
        if page == 1 then
            Button_arena_record_me:setHighlighted(true)
        else
            Button_arena_record_me_all:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_arena_record_me:setHighlighted(false)
    Button_arena_record_me_all:setHighlighted(false)

	
	if self._arena_dearon ~= nil then
		state_machine.excute("arena_my_record_tab_hide", 0, nil)
	end
	if self._arena_troops ~= nil then
		state_machine.excute("arena_service_record_tab_hide", 0, nil)
	end

    if page == 1 then
        Button_arena_record_me:setHighlighted(true)
        if self._arena_dearon == nil then
            self._arena_dearon = state_machine.excute("arena_my_record_tab_open", 0, {Panel_arena_record})
        else
            state_machine.excute("arena_my_record_tab_show", 0, nil)
        end
    else
        Button_arena_record_me_all:setHighlighted(true)
        if self._arena_troops == nil then
            self._arena_troops = state_machine.excute("arena_service_record_tab_open", 0, {Panel_arena_record})
        else
            state_machine.excute("arena_service_record_tab_show", 0, nil)
        end
    end
end

function ArenaRecord:init(params)
	self._params = params
    self:setTouchEnabled(true)
    self:onInit()
    return self
end

function ArenaRecord:onInit()
    local csbArenaRecord = csb.createNode(config_csb.arena.arena_record)
    local root = csbArenaRecord:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbArenaRecord)
	
	Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)
	
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_arena_record_close"), nil, 
    {
        terminal_name = "arena_record_close",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,3)
	
	--我的战报
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_arena_record_me"), nil, 
    {
        terminal_name = "arena_record_page",
        terminal_state = 0,
		_page = 1,
    },
    nil,1)
	--全服战报
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_arena_record_me_all"), nil, 
    {
        terminal_name = "arena_record_page",
        terminal_state = 0,
		_page = 2,
    },
    nil,1)
	
	--全部读取
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_arena_record_read"), nil, 
    {
        terminal_name = "arena_record_read",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    },
    nil,1)
	if self._params ~= nil and self._params._datas ~= nil and self._params._datas.page ~= nil then
        self:changeSelectPage(tonumber(self._params._datas.page))
    else
        self:changeSelectPage(1)
    end
end

function ArenaRecord:onExit()
	state_machine.remove("arena_record_page")
    state_machine.remove("arena_record_read")
end