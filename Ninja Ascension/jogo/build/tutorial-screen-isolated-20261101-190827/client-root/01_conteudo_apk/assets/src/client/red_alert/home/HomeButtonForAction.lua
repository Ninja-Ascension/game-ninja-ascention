--------------------------------------------------------------------------------------------------------------
--  说明：主页面动态功能按钮
--------------------------------------------------------------------------------------------------------------
HomeButtonForAction = class("HomeButtonForActionClass", Window)
HomeButtonForAction.__is_show = true

--打开界面
local home_button_for_action_window_open_terminal = {
	_name = "home_button_for_action_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        local _homeButtonForActionWindow = fwin:find("HomeButtonForActionClass")
        if nil == _homeButtonForActionWindow then
            fwin:open(HomeButtonForAction:new():init(), fwin._ui)
        end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local home_button_for_action_window_close_terminal = {
	_name = "home_button_for_action_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)

		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(home_button_for_action_window_open_terminal)
state_machine.add(home_button_for_action_window_close_terminal)
state_machine.init()

function HomeButtonForAction:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}
	self.is_show = true

    app.load("client.red_alert.cells.home.home_button_task_cell")
    app.load("client.red_alert.cells.home.home_button_target_cell")

    app.load("client.red_alert.formation.FormationSetting")
    app.load("client.red_alert.hero.HeroMain")
    app.load("client.red_alert.packs.equipstorage.Equipment")
    app.load("client.red_alert.campaign.Campaign")
    app.load("client.red_alert.activity.dailytasks.Task")
    app.load("client.red_alert.packs.Packs")    
    app.load("client.red_alert.rank.Ranking")    
    app.load("client.red_alert.union.create.UnionJoin")
    app.load("client.red_alert.union.Union")
    app.load("client.red_alert.battle.battle_enum")
    
	 -- Initialize alert_home state machine.
    local function init_home_button_for_action_terminal()
	
		--显示所有
		local home_button_for_action_window_show_terminal = {
            _name = "home_button_for_action_window_show",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onShow()
                state_machine.excute("chat_view_window_show", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 隐藏所有
        local home_button_for_action_window_hide_terminal = {
            _name = "home_button_for_action_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

			--播放出现动画
		local home_button_for_action_play_terminal = {
            _name = "home_button_for_action_play",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.is_show == false then
                    instance:playShowAction()
                    instance.is_show = true
                    HomeButtonForAction.__is_show = true
                else
                    instance:playHideAction()
                    instance.is_show = false
                    HomeButtonForAction.__is_show = false
                    -- clear cacher
                    cacher.clearWindowCacher()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --播放出现动画
        local home_button_for_action_play_show_terminal = {
            _name = "home_button_for_action_play_show",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:playShowAction()
                instance.is_show = true
                HomeButtonForAction.__is_show = true
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --播放隐藏动画
        local home_button_for_action_play_hide_terminal = {
            _name = "home_button_for_action_play_hide",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:playHideAction()
                instance.is_show = false
                HomeButtonForAction.__is_show = false
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local home_button_for_action_open_union_terminal = {
            _name = "home_button_for_action_open_union",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if funOpenDrawTip(70) == true then
                    return
                end
                local function responseCallbackUnion(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if _ED.union.union_info == nil 
                            or _ED.union.union_info == {} 
                            or _ED.union.union_info.union_id == nil 
                            or _ED.union.union_info.union_id == "" 
                            or tonumber(_ED.union.union_info.union_id) == 0 
                            then
                            state_machine.excute("union_join_open", 0, "")
                        else
                            if tonumber(_ED.union.user_union_info.union_post) == 1 or tonumber(_ED.union.user_union_info.union_post) == 2 then
                                protocol_command.union_examine_list.param_list = _ED.union.union_info.union_id
                                NetworkManager:register(protocol_command.union_examine_list.code, nil, nil, nil, nil, nil, false, nil)
                            end
                            state_machine.excute("union_open", 0, "")
                        end
                    end
                end 
                _ED.union.union_list_info = nil
                NetworkManager:register(protocol_command.union_init.code, nil, nil, nil, nil, responseCallbackUnion, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --请求进入大地图
        local home_button_for_action_open_city_request_terminal = {
            _name = "home_button_for_action_open_city_request",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if funOpenDrawTip(123) == true then
                    return
                end
                local _Window = fwin:find("NationalWarMapClass")
                if nil == _Window then
                    local function responseholdInit(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if nil ~= fwin:find("DuplicateManagerClass") then
                                state_machine.excute("duplicate_manager_window_close", 0, 0)
                            end
                            state_machine.excute("national_truce_loading_window_open", 0, {_datas = {open_type = 1}})
                        end
                    end
                    local function responseCallback2(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            _ED.personal_defender_battle_report_list = {}
                            for i, data in pairs(_ED.city_resource_battle_report) do
                                if tonumber(data.result) == 0 then
                                    table.insert(_ED.personal_defender_battle_report_list, data)
                                end
                            end
                            -- responseholdInit({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 1})
                            NetworkManager:register(protocol_command.city_resource_hold_init.code, nil, nil, nil, nil, responseholdInit, false, nil)   
                        end
                    end
                    local function responseCallback1(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            protocol_command.battlefield_report_get.param_list = battle_enum._fight_type._fight_type_105 + 1000
                            NetworkManager:register(protocol_command.battlefield_report_get.code, nil, nil, nil, nil, responseCallback2, false, nil)
                        end
                    end
                    protocol_command.user_stronghold_plunder_refresh.param_list = ""
                    NetworkManager:register(protocol_command.user_stronghold_plunder_refresh.code, nil, nil, nil, nil, responseCallback1, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        local home_button_for_action_update_task_info_terminal = {
            _name = "home_button_for_action_update_task_info",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local home_button_for_action_hide_task_target_terminal = {
            _name = "home_button_for_action_hide_task_target",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:chnageTaskTargetShowState(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(home_button_for_action_window_show_terminal)
		state_machine.add(home_button_for_action_window_hide_terminal)
		state_machine.add(home_button_for_action_play_terminal)
        state_machine.add(home_button_for_action_play_show_terminal)
        state_machine.add(home_button_for_action_play_hide_terminal)
        state_machine.add(home_button_for_action_open_union_terminal)
        state_machine.add(home_button_for_action_open_city_request_terminal) 
        state_machine.add(home_button_for_action_update_task_info_terminal)
        state_machine.add(home_button_for_action_hide_task_target_terminal)
        state_machine.init()
    end
    
    -- call func alert_home create state machine.
    init_home_button_for_action_terminal()

end

function HomeButtonForAction:chnageTaskTargetShowState( isShow )
    local root = self.roots[1]
    local Panel_task = ccui.Helper:seekWidgetByName(root, "Panel_task")
    local Panel_target = ccui.Helper:seekWidgetByName(root, "Panel_target")
    Panel_task:setVisible(isShow)
    Panel_target:setVisible(isShow)
end

function HomeButtonForAction:onShow( ... )
    self:setVisible(true)
end

function HomeButtonForAction:onHide( ... )
    self:setVisible(false)
end

function HomeButtonForAction:playShowAction( )
    self.actions[1]:stop()
	self.actions[1]:play("Button_stretch_2", false)
end

function HomeButtonForAction:playHideAction( )
    self.actions[1]:stop()
	self.actions[1]:play("Button_stretch_1", false)
end

function HomeButtonForAction:updateDraw()
    local root = self.roots[1]
    local Panel_task = ccui.Helper:seekWidgetByName(root, "Panel_task")
    local Panel_target = ccui.Helper:seekWidgetByName(root, "Panel_target")
    Panel_task:removeAllChildren(true)
    Panel_target:removeAllChildren(true)
    local cell = state_machine.excute("home_button_task_cell_create", 0, nil)
    if cell ~= nil then
        Panel_task:addChild(cell)
    end
	local taskButtonCell = state_machine.excute("home_button_target_cell_create", 0, nil)
    Panel_target:addChild(taskButtonCell)
	Panel_target._roots = taskButtonCell._roots
end

function HomeButtonForAction:onInit()
    -- 推送箭头动画资源加载
    for i, v in pairs(config_res.sprites_cached["push_arrows"]) do
        cc.SpriteFrameCache:getInstance():addSpriteFrames(v)
    end

    local csbItem = csb.createNode(config_csb.home.home_button_foraction)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)   

    local action = csb.createTimeline(config_csb.home.home_button_foraction)
    action:setTimeSpeed(app.getTimeSpeed())
    table.insert(self.actions, action)

    csbItem:runAction(action)
    
    --布阵   
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_features_line"), nil, 
    {
        terminal_name = "formation_setting_window_open", 
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 2) 

    --出现或隐藏 面板
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_stretch"), nil, 
    {
        terminal_name = "home_button_for_action_play", 
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        isPressedActionEnabled = false
    }, nil, 0) 

    -- 武将
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_features_role"), nil, 
    {
        terminal_name = "hero_main_window_open", 
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 2) 
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_home_button_foraction_role",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_features_role"),
    _invoke = nil,
    _interval = 0.5,})

    -- 日常
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_daily"), nil, 
    {
        terminal_name = "campaign_window_open", 
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 2) 
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_home_button_foraction_campaign",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_daily"),
    _invoke = nil,
    _interval = 0.5,})
    
    --任务
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_task"), nil, 
    {
        terminal_name = "task_window_open", 
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 2)   
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_home_button_foraction_task",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_task"),
    _invoke = nil,
    _interval = 0.5,})  
    
    --包裹
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_features_package"), nil, 
    {
        terminal_name = "packs_window_open", 
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 2)   
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_home_button_foraction_packs",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_features_package"),
    _invoke = nil,
    _interval = 0.5,})      

    --装备
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_features_equipment"), nil, 
    {
        terminal_name = "equipment_window_open", 
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true, 
    }, nil, 2)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_home_button_foraction_equipment",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_features_equipment"),
    _invoke = nil,
    _interval = 0.5,})


    --排行榜
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ranking"), nil, 
    {
        terminal_name = "ranking_window_open",
        -- func_string = [[funOpenDrawTip(65)]],
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        touch_black = true,
    }, nil, 2)

    --联盟
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_features_legion"), nil, 
    {
        terminal_name = "home_button_for_action_open_union",
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 2)    
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_home_button_foraction_union",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_features_legion"),
    _invoke = nil,
    _interval = 0.5,})
    
    --世界地图
    local Button_map = ccui.Helper:seekWidgetByName(root,"Button_map")
    if Button_map ~= nil then
        fwin:addTouchEventListener(Button_map, nil, 
        {
            terminal_name = "home_button_for_action_open_city_request",
            terminal_state = 0, 
            cell = self, 
            touch_scale = true,
            touch_scale_xy = 0.95, 
            open_type = 1,
        }, nil, 2)
        -- state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_home_button_foraction_rivers",
        -- _widget = ccui.Helper:seekWidgetByName(root, "Button_map"),
        -- _invoke = nil,
        -- _interval = 0.5,})
    end

    --出现或隐藏 面板
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_stretch_0"), nil, 
    {
        terminal_name = "home_button_for_action_play", 
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        isPressedActionEnabled = false
    }, nil, 0) 

    self:updateDraw()

    if HomeButtonForAction.__is_show == false then
        self.is_show = false
        self.actions[1]:play("Button_stretch_3", false)
    end
end

function HomeButtonForAction:onEnterTransitionFinish()

end

function HomeButtonForAction:init()
	self:onInit()
    return self
end

function HomeButtonForAction:onExit()
	state_machine.remove("home_button_for_action_window_show")
	state_machine.remove("home_button_for_action_window_hide")
	state_machine.remove("home_button_for_action_play")	
    state_machine.remove("home_button_for_action_play_show")
    state_machine.remove("home_button_for_action_play_hide")
    state_machine.remove("home_button_for_action_open_union")
    state_machine.remove("home_button_for_action_open_city_request")
    state_machine.remove("home_button_for_action_update_task_info")
    state_machine.remove("home_button_for_action_hide_task_target")
end