--------------------------------------------------------------------------------------------------------------
--  说明：军团城市
--------------------------------------------------------------------------------------------------------------
LegionCity = class("LegionCityClass", Window)

--打开界面
local legion_city_open_terminal = {
    _name = "legion_city_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if _ED.union.union_info == nil 
            or _ED.union.union_info == {} 
            or _ED.union.union_info.union_id == nil 
            or _ED.union.union_info.union_id == "" 
            or tonumber(_ED.union.union_info.union_id) == 0 then
            TipDlg.drawTextDailog(red_alert_time_str[158])
            return
        end
        
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if fwin:find("LegionCityClass") == nil then
                    fwin:open(LegionCity:new():init(params), fwin._ui)
                end
                if params ~= nil and params._datas ~= nil and params._datas.show_help == true then
                    local is_show = false
                    local server_time = getCurrentGTM8Time()
                    local record_day = cc.UserDefault:getInstance():getStringForKey(getKey("world_city_help_show_info"))
                    if record_day == nil then
                        is_show = true
                    else
                        local record_day_info = zstring.split(record_day, ",")
                        if zstring.tonumber(server_time.year) > zstring.tonumber(record_day_info[1])
                            or zstring.tonumber(server_time.month) > zstring.tonumber(record_day_info[2])
                            or zstring.tonumber(server_time.day) > zstring.tonumber(record_day_info[3]) then 
                            is_show = true
                        end
                    end
                    if is_show == true then
                        state_machine.excute("legion_city_image_infor_window_open", 0, "")
                        cc.UserDefault:getInstance():setStringForKey(getKey("world_city_help_show_info"), ""..server_time.year..","..server_time.month..","..server_time.day)
                    end
                end
            end
        end

        protocol_command.world_city_list_get.param_list = ""
        NetworkManager:register(protocol_command.world_city_list_get.code, nil, nil, nil, nil, responseCallback, false, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local legion_city_close_terminal = {
    _name = "legion_city_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LegionCityClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(legion_city_open_terminal)
state_machine.add(legion_city_close_terminal)
state_machine.init()

function LegionCity:ctor()
    self.super:ctor()
    self.roots = {}

    self._current_page = 0
    self._occupyPanel = nil
    self._listPanel = nil
    self._factoryPanel = nil

    app.load("client.red_alert_time.legion.LegionCityList")
    app.load("client.red_alert_time.legion.LegionCityOccupy")
    app.load("client.red_alert_time.legion.LegionCityInfor")
    app.load("client.red_alert_time.legion.LegionCityInforAttack")
    app.load("client.red_alert_time.legion.LegionCityOccupyInfor")
    app.load("client.red_alert_time.legion.LegionCityActiveInfo")
    app.load("client.red_alert_time.legion.LegionCityRuleInfor")
    app.load("client.red_alert_time.legion.LegionCityImageInfor")
    app.load("client.red_alert_time.legion.LegionCityRecord")
    app.load("client.red_alert_time.legion.LegionCityFactoryInfor")

    app.load("client.red_alert_time.cells.legion.legion_city_list_cell")
    app.load("client.red_alert_time.cells.legion.legion_city_occupy_cell")

    local function init_legion_city_terminal()
        local legion_city_change_page_terminal = {
            _name = "legion_city_change_page",
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

        local legion_city_request_init_terminal = {
            _name = "legion_city_request_init",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            state_machine.excute("legion_city_list_update_list_info", 0, response.node._listPanel)
                            state_machine.excute("legion_city_list_update_list_info", 0, response.node._factoryPanel)
                            state_machine.excute("legion_city_occupy_update_list_info", 0, "")
                        end
                    end
                end

                protocol_command.world_city_list_get.param_list = ""
                NetworkManager:register(protocol_command.world_city_list_get.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_city_change_page_terminal)   
        state_machine.add(legion_city_request_init_terminal)   
        state_machine.init()
    end
    init_legion_city_terminal()
end

function LegionCity:changeSelectPage( page )
    local root = self.roots[1]
    local Panel_shop_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_shop_tab_box")

    local Button_legion_city_occupy = ccui.Helper:seekWidgetByName(root, "Button_legion_city_occupy")
    local Button_legion_city_list = ccui.Helper:seekWidgetByName(root, "Button_legion_city_list")
    local Button_legion_city_factory = ccui.Helper:seekWidgetByName(root, "Button_legion_city_factory")
    if page == self._current_page then
        if page == 1 then
            Button_legion_city_occupy:setHighlighted(true)
        elseif page == 2 then
            Button_legion_city_list:setHighlighted(true)
        else
            Button_legion_city_factory:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_legion_city_occupy:setHighlighted(false)
    Button_legion_city_list:setHighlighted(false)
    Button_legion_city_factory:setHighlighted(false)
    state_machine.excute("legion_city_occupy_hide", 0, nil)
    state_machine.excute("legion_city_list_hide", 0, self._listPanel)
    state_machine.excute("legion_city_list_hide", 0, self._factoryPanel)
    if page == 1 then
        Button_legion_city_occupy:setHighlighted(true)
        if self._occupyPanel == nil then
            self._occupyPanel = state_machine.excute("legion_city_occupy_open", 0, {Panel_shop_tab_box})
        else
            state_machine.excute("legion_city_occupy_show", 0, nil)
        end
    elseif page == 2 then
        Button_legion_city_list:setHighlighted(true)
        if self._listPanel == nil then
            self._listPanel = state_machine.excute("legion_city_list_open", 0, {Panel_shop_tab_box, 1})
        else
            state_machine.excute("legion_city_list_show", 0, self._listPanel)
        end
    else
        Button_legion_city_factory:setHighlighted(true)
        if self._factoryPanel == nil then
            self._factoryPanel = state_machine.excute("legion_city_list_open", 0, {Panel_shop_tab_box, 2})
        else
            state_machine.excute("legion_city_list_show", 0, self._factoryPanel)
        end
    end
end

function LegionCity:onInit(params)
    local csbItem = csb.createNode(config_csb.legion.legion_city)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_shop_close"), nil, 
    {
        terminal_name = "legion_city_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)      

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_city_occupy"), nil, 
    {
        terminal_name = "legion_city_change_page", 
        terminal_state = 0, 
        _page = 1,
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_legion_city_reward",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_legion_city_occupy"),
        _invoke = nil,
        _interval = 0.2,})

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_city_list"), nil, 
    {
        terminal_name = "legion_city_change_page", 
        terminal_state = 0, 
        _page = 2,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_city_factory"), nil, 
    {
        terminal_name = "legion_city_change_page", 
        terminal_state = 0, 
        _page = 3,
    }, nil, 1)

    if params ~= nil and params._datas ~= nil and params._datas._page ~= nil then
        self:changeSelectPage(tonumber(params._datas._page))
    else
        self:changeSelectPage(1)
    end
end

function LegionCity:onEnterTransitionFinish()

end

function LegionCity:init(params)
    self:setTouchEnabled(true)
    self:onInit(params)
    return self
end

function LegionCity:onExit()
    state_machine.remove("legion_city_change_page")
    state_machine.remove("legion_city_request_init")
end