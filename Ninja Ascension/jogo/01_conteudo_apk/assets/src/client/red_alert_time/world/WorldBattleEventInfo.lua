-- ----------------------------------------------------------------------------------------------------
-- 说明：世界的事件队列
-------------------------------------------------------------------------------------------------------
WorldBattleEventInfo = class("WorldBattleEventInfoClass", Window)

local world_battle_event_info_open_terminal = {
    _name = "world_battle_event_info_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("WorldBattleEventInfoClass") then
    		fwin:open(WorldBattleEventInfo:new():init(), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local world_battle_event_info_close_terminal = {
	_name = "world_battle_event_info_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("WorldBattleEventInfoClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(world_battle_event_info_open_terminal)
state_machine.add(world_battle_event_info_close_terminal)
state_machine.init()

function WorldBattleEventInfo:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._current_page = 0

    self._march_panel = nil
    self._struck_panel = nil
    self._defence_panel = nil

    self._is_open = false
    self._queue_count = {0, 0, 0}       -- 行军，来袭，协防队列数量

    self._button_pos_x = {}    
    self._panel_pos_x = {}
    self._text_pos_x = {}
    self._image_pos_x = {}   

    app.load("client.red_alert_time.utils.ShortCut")
    app.load("client.red_alert_time.world.WorldBattleEventInfoMarch")
    app.load("client.red_alert_time.world.WorldBattleEventInfoDefence")
    app.load("client.red_alert_time.world.WorldBattleEventInfoStruck")
    app.load("client.red_alert_time.world.WorldBattlePathManager")
    app.load("client.red_alert_time.world.WorldBattleTroopsInfor")
    app.load("client.red_alert_time.worldMap.redAlertTimeMineBattleTroopsInfor")

    app.load("client.red_alert_time.cells.world.world_battle_event_info_march_cell")
    app.load("client.red_alert_time.cells.world.world_battle_event_info_defence_cell")
    app.load("client.red_alert_time.cells.world.world_battle_event_info_struck_cell")

    local function init_world_battle_event_info_terminal()
        local world_battle_event_info_show_terminal = {
            _name = "world_battle_event_info_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance._is_open == false then
                    state_machine.excute("world_input_window_close", 0, 0)
                    instance:showAnimation(true)
                end
                if params ~= nil and params._datas ~= nil and params._datas._page ~= nil then
                    instance:changeSelectPage(tonumber(params._datas._page))
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local world_battle_event_info_hide_terminal = {
            _name = "world_battle_event_info_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance._is_open == true then
                    instance:showAnimation(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local world_battle_event_info_change_page_terminal = {
            _name = "world_battle_event_info_change_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:changeSelectPage(tonumber(params._datas.page))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local world_battle_event_info_update_draw_terminal = {
            _name = "world_battle_event_info_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDraw()
                state_machine.excute("adventure_mine_update_map_draw", 0, 0)
                state_machine.excute("notification_center_update", 0, "push_notification_queue_event")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local world_battle_event_info_update_show_info_terminal = {
            _name = "world_battle_event_info_update_show_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local show_type = params[1]
                local info = params[2] 
                instance:onUpdateShowInfo(show_type, info)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(world_battle_event_info_change_page_terminal)   
        state_machine.add(world_battle_event_info_show_terminal)  
        state_machine.add(world_battle_event_info_hide_terminal)   
        state_machine.add(world_battle_event_info_update_draw_terminal)  
        state_machine.add(world_battle_event_info_update_show_info_terminal)  
        state_machine.init()
    end
    init_world_battle_event_info_terminal()
end

function WorldBattleEventInfo:onUpdateShowInfo( show_type, info )
    local root = self.roots[1]
    local Text_distance_n = ccui.Helper:seekWidgetByName(root,"Text_distance_n_"..show_type)
    Text_distance_n:setString(info)
end

-- 刷新事件队列
function WorldBattleEventInfo:onUpdateDraw()
    local root = self.roots[1]
    local Button_world_attack = ccui.Helper:seekWidgetByName(root, "Button_world_attack")
    local Button_world_attack_incoming = ccui.Helper:seekWidgetByName(root, "Button_world_attack_incoming")
    local Button_world_attack_help = ccui.Helper:seekWidgetByName(root, "Button_world_attack_help")

    self._queue_count = {0, 0, 0}           -- 行军，来袭，协防队列数量

    if _ED.world_map~= nil and _ED.world_map.target_event_info ~= nil then
        for i, v in pairs(_ED.world_map.target_event_info) do
            if tonumber(v._event_type) < 10 or tonumber(v._event_type) >= 18 then
                self._queue_count[1] = self._queue_count[1] + 1
            elseif tonumber(v._event_type) > 10 and tonumber(v._event_type) < 13 then
                self._queue_count[2] = self._queue_count[2] + 1
            elseif tonumber(v._event_type) >= 13 and tonumber(v._event_type) < 18 then
                self._queue_count[3] = self._queue_count[3] + 1
            end
        end
    end

    local max_march_count = dms.int(dms["base_consume"], 81, base_consume.vip_0_value + zstring.tonumber(_ED.vip_grade))
    local max_defence_count = zstring.split(dms.string(dms["world_config"], 22 , world_config.param), ",")[1]
    Button_world_attack:setTitleText(string.format(tipStringInfo_consumption_info[14], self._queue_count[1], max_march_count))
    Button_world_attack_incoming:setTitleText(string.format(tipStringInfo_consumption_info[15], self._queue_count[2]))
    Button_world_attack_help:setTitleText(string.format(tipStringInfo_consumption_info[16], self._queue_count[3], max_defence_count))

    local current_index = 1
    for i = 3, 1, -1 do
        local Button_world_attack_state = ccui.Helper:seekWidgetByName(root,"Button_world_attack_state_"..i)
        local Panel_world_attack_icon = ccui.Helper:seekWidgetByName(root,"Panel_world_attack_icon_"..i)
        local Image_distance_bg = ccui.Helper:seekWidgetByName(root,"Image_distance_bg_"..i)
        local Text_distance_n = ccui.Helper:seekWidgetByName(root,"Text_distance_n_"..i)
        if self._queue_count[i] > 0 
            -- or i == 1               -- 测试代码，默认显示行军按钮
            then
            Button_world_attack_state:setPositionX(self._button_pos_x[current_index])
            Panel_world_attack_icon:setPositionX(self._panel_pos_x[current_index])
            Image_distance_bg:setPositionX(self._image_pos_x[current_index])
            Text_distance_n:setPositionX(self._text_pos_x[current_index])

            current_index = current_index + 1
        end
    end
    self:onUpdateButtonState()

    state_machine.excute("world_battle_event_info_march_update", 0, nil)
    state_machine.excute("world_battle_event_info_struck_update", 0, nil)
    state_machine.excute("world_battle_event_info_defence_update", 0, nil)
    state_machine.excute("formation_attack_update_info", 0, nil)
    state_machine.excute("world_battle_troops_infor_update_draw", 0, "")
end

function WorldBattleEventInfo:onUpdateButtonState()
    local root = self.roots[1]
    local Button_world_attack_window = ccui.Helper:seekWidgetByName(root, "Button_world_attack_window")

    if self._is_open == true then
        Button_world_attack_window:setVisible(true)
    else
        Button_world_attack_window:setVisible(false)
    end

    for i = 1, 3 do
        local Button_world_attack_state = ccui.Helper:seekWidgetByName(root,"Button_world_attack_state_"..i)
        local Panel_world_attack_icon = ccui.Helper:seekWidgetByName(root,"Panel_world_attack_icon_"..i)
        local Image_distance_bg = ccui.Helper:seekWidgetByName(root,"Image_distance_bg_"..i)
        local Text_distance_n = ccui.Helper:seekWidgetByName(root,"Text_distance_n_"..i)
        local is_visible = false
        if self._is_open == false and self._queue_count[i] > 0 
            -- or i == 1               -- 测试代码，默认显示行军按钮
            then
            is_visible = true
        end
        Button_world_attack_state:setVisible(is_visible)
        Panel_world_attack_icon:setVisible(is_visible)
        Image_distance_bg:setVisible(is_visible)
        Text_distance_n:setVisible(is_visible)
    end
end

function WorldBattleEventInfo:changeSelectPage( page )
    local root = self.roots[1]
    local Panel_world_attack_box = ccui.Helper:seekWidgetByName(root, "Panel_world_attack_box")
    local Button_world_attack = ccui.Helper:seekWidgetByName(root, "Button_world_attack")
    local Button_world_attack_incoming = ccui.Helper:seekWidgetByName(root, "Button_world_attack_incoming")
    local Button_world_attack_help = ccui.Helper:seekWidgetByName(root, "Button_world_attack_help")
    local ListView_world_attack = ccui.Helper:seekWidgetByName(root, "ListView_world_attack")
    Panel_world_attack_box:setVisible(true)
    ListView_world_attack:setVisible(false)
    if page == self._current_page then
        if page == 1 then
            Button_world_attack:setHighlighted(true)
        elseif page == 2 then
            Button_world_attack_incoming:setHighlighted(true)
        else
            Button_world_attack_help:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_world_attack:setHighlighted(false)
    Button_world_attack_incoming:setHighlighted(false)
    Button_world_attack_help:setHighlighted(false)
    state_machine.excute("world_battle_event_info_march_hide", 0, nil)
    state_machine.excute("world_battle_event_info_struck_hide", 0, nil)
    state_machine.excute("world_battle_event_info_defence_hide", 0, nil)
    if page == 1 then
        Button_world_attack:setHighlighted(true)
        if self._march_panel == nil then
            self._march_panel = state_machine.excute("world_battle_event_info_march_window_open", 0, {Panel_world_attack_box})
        else
            state_machine.excute("world_battle_event_info_march_show", 0, nil)
        end
    elseif page == 2 then
        Button_world_attack_incoming:setHighlighted(true)
        if self._struck_panel == nil then
            self._struck_panel = state_machine.excute("world_battle_event_info_struck_window_open", 0, {Panel_world_attack_box})
        else
            state_machine.excute("world_battle_event_info_struck_show", 0, nil)
        end
    else
        Button_world_attack_help:setHighlighted(true)
        if self._defence_panel == nil then
            self._defence_panel = state_machine.excute("world_battle_event_info_defence_window_open", 0, {Panel_world_attack_box})
        else
            state_machine.excute("world_battle_event_info_defence_show", 0, nil)
        end
    end
end

function WorldBattleEventInfo:showAnimation(is_open)
    local action_name = ""
    local action_over_name = ""
    if is_open == true then
        action_name = "world_attack_window_open"
        action_over_name = "world_attack_window_open_over"
    else
        action_name = "world_attack_window_close"
        action_over_name = "world_attack_window_close_over"
    end

    self._is_open = is_open
    self:onUpdateButtonState()

    self.actions[1]:play(action_name, false)
    self.actions[1]:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "open" then
        elseif str == action_over_name then
            --打开结束
        end
        
    end)
end

function WorldBattleEventInfo:initButtonInfo()
    local root = self.roots[1]

    self._button_pos_x = {}    
    self._panel_pos_x = {}
    self._text_pos_x = {}
    self._image_pos_x = {}  

    for i = 1, 3 do
        local Button_world_attack_state = ccui.Helper:seekWidgetByName(root,"Button_world_attack_state_"..i)
        local Panel_world_attack_icon = ccui.Helper:seekWidgetByName(root,"Panel_world_attack_icon_"..i)
        local Image_distance_bg = ccui.Helper:seekWidgetByName(root,"Image_distance_bg_"..i)
        local Text_distance_n = ccui.Helper:seekWidgetByName(root,"Text_distance_n_"..i)
        table.insert(self._button_pos_x, Button_world_attack_state:getPositionX())
        table.insert(self._panel_pos_x, Panel_world_attack_icon:getPositionX())
        table.insert(self._image_pos_x, Image_distance_bg:getPositionX())
        table.insert(self._text_pos_x, Text_distance_n:getPositionX())

        Panel_world_attack_icon:removeBackGroundImage()
        if i == 1 then
            Panel_world_attack_icon:setBackGroundImage("images/ui/share/world_implement_icon_1.png")
        elseif i == 2 then
            Panel_world_attack_icon:setBackGroundImage("images/ui/share/world_implement_icon_4.png")
        else
            Panel_world_attack_icon:setBackGroundImage("images/ui/share/world_implement_icon_6.png")
        end

        Text_distance_n:setString("")
    end
end

function WorldBattleEventInfo:initCreateWindow()
    local root = self.roots[1]
    -- 创建队列页面
    local Panel_world_attack_box = ccui.Helper:seekWidgetByName(root, "Panel_world_attack_box")
    if self._march_panel == nil then
        self._march_panel = state_machine.excute("world_battle_event_info_march_window_open", 0, {Panel_world_attack_box})
    end
    if self._struck_panel == nil then
        self._struck_panel = state_machine.excute("world_battle_event_info_struck_window_open", 0, {Panel_world_attack_box})
    end
    if self._defence_panel == nil then
        self._defence_panel = state_machine.excute("world_battle_event_info_defence_window_open", 0, {Panel_world_attack_box})
    end
end

function WorldBattleEventInfo:onInit(params)
    local csbItem = csb.createNode(config_csb.world_map.battle_infor)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)   

    local action = csb.createTimeline(config_csb.world_map.battle_infor)
    table.insert(self.actions, action)
    csbItem:runAction(action) 

    self:initButtonInfo()
    self:initCreateWindow()

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_world_attack"), nil, 
    {
        terminal_name = "world_battle_event_info_change_page", 
        terminal_state = 0, 
        page = 1,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_world_attack_incoming"), nil, 
    {
        terminal_name = "world_battle_event_info_change_page", 
        terminal_state = 0, 
        page = 2,
    }, nil, 1)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_world_attack_help"), nil, 
    {
        terminal_name = "world_battle_event_info_change_page", 
        terminal_state = 0, 
        page = 3,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_world_attack_window"), nil, 
    {
        terminal_name = "world_battle_event_info_hide", 
        terminal_state = 0, 
        page = 3,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panell_window_bg"), nil, 
    {
        terminal_name = "world_battle_event_info_hide", 
        terminal_state = 0, 
        page = 3,
    }, nil, 1)

    for i = 1, 3 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_world_attack_state_"..i), nil, 
        {
            terminal_name = "world_battle_event_info_show", 
            terminal_state = 0, 
            _page = i,
        }, nil, 1)
        state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_queue_event",
            _widget = ccui.Helper:seekWidgetByName(root, "Button_world_attack_state_"..i),
            _m_type = i,
            _invoke = nil,
            _interval = 0.2,})
    end
    
    if params ~= nil and params._datas ~= nil and params._datas._page ~= nil then
        self:changeSelectPage(tonumber(params._datas._page))
    else
        self:changeSelectPage(1)
    end
    self:onUpdateDraw()
    state_machine.excute("world_battle_path_manager_open", 0, nil)
end

function WorldBattleEventInfo:onEnterTransitionFinish()

end

function WorldBattleEventInfo:init(params)
    self:onInit(params)
    return self
end

function WorldBattleEventInfo:onExit()
    state_machine.remove("world_battle_event_info_change_page")
    state_machine.remove("world_battle_event_info_show")
    state_machine.remove("world_battle_event_info_hide")
    state_machine.remove("world_battle_event_info_update_draw")
    state_machine.remove("world_battle_event_info_update_show_info")
end