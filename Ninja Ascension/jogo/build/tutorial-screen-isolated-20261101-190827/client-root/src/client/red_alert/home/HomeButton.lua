--------------------------------------------------------------------------------------------------------------
--  说明：主页面静态功能按钮
--------------------------------------------------------------------------------------------------------------
HomeButton = class("HomeButtonClass", Window)

--打开界面
local home_button_window_open_terminal = {
	_name = "home_button_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        local _homeButtonWindow = fwin:find("HomeButtonClass")
        if nil == _homeButtonWindow then
    		fwin:open(HomeButton:new():init(), fwin._frameview)
        end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local home_button_window_close_terminal = {
	_name = "home_button_window_close",
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
state_machine.add(home_button_window_open_terminal)
state_machine.add(home_button_window_close_terminal)
state_machine.init()

function HomeButton:ctor()
	self.super:ctor()
	self.roots = {}

    -- load lua file
	app.load("client.red_alert.duplicate.DuplicateManager")
    app.load("client.red_alert.mail.Mail")
    app.load("client.red_alert.activity.sign_in.SignIn")
    app.load("client.red_alert.activity.wonderful.Wonderful")
    app.load("client.red_alert.strategy.Strategy")
	app.load("client.red_alert.campaign.nationalwar.NationalTruce")
	app.load("client.red_alert.campaign.nationalwar.NationalTruceLoading")
	app.load("client.utils.DrawHelper")
	
    
	 -- Initialize alert_home state machine.
    local function init_home_button_terminal()
		 -- 防沉迷 按钮显示
        local home_button_show_anti_terminal = {
            _name = "home_button_show_anti",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)

                local function checkAnti( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        local root = instance.roots[1]
                        local Button_fangchenmi = ccui.Helper:seekWidgetByName(root,"Button_fangchenmi")
                        if tonumber(_ED.parse_user_register_anti) == 1  then
                            Button_fangchenmi:setVisible(false)
                        elseif tonumber(_ED.parse_user_register_anti) == 0 then
                            Button_fangchenmi:setVisible(true)
                        end
                    end
                end
                -- 检测是否验证
                protocol_command.vali_id.param_list = m_sUin
                NetworkManager:register(protocol_command.vali_id.code, app.configJson.url, nil, nil, instance, checkAnti, false, nil) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--显示所有
		local home_button_window_show_terminal = {
            _name = "home_button_window_show",
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
		-- 隐藏所有
        local home_button_window_hide_terminal = {
            _name = "home_button_window_hide",
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

        local home_button_choose_activity_terminal = {
            _name = "home_button_choose_activity",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("wonderful_window_open", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

	    state_machine.add(home_button_show_anti_terminal)
		state_machine.add(home_button_window_show_terminal)
		state_machine.add(home_button_window_hide_terminal)
        state_machine.add(home_button_choose_activity_terminal)	
        state_machine.init()
    end
    
    -- call func alert_home create state machine.
    init_home_button_terminal()

end

function HomeButton:onUpdate()
    if self.roots == nil or self.roots[1] == nil then
        return
    end
    if self._sign_activity == nil and self._panel_qiandao == nil then
        return
    end
    self._panel_qiandao:setVisible(false)
    if getSignInTip() == true then
        self._panel_qiandao:setVisible(true)
    end
end

function HomeButton:updateDraw()
    local root = self.roots[1]
    local Button_fangchenmi = ccui.Helper:seekWidgetByName(root,"Button_fangchenmi")
    
    if Button_fangchenmi == nil then
        return
    end 
    if _ED.user_birthday ~= nil then
        local function responseCallback( response )
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                _ED.user_birthday = nil
            end
        end
        protocol_command.birthday_record.param_list = _ED.user_birthday
        NetworkManager:register(protocol_command.birthday_record.code, nil, nil, nil, nil, responseCallback, false, nil)
    end

    if zstring.tonumber(_ED.parse_user_register_anti) == 1  then
        Button_fangchenmi:setVisible(false)
    elseif zstring.tonumber(_ED.parse_user_register_anti) == 0 then
        Button_fangchenmi:setVisible(true)
    end

    app.load("client.utils.AntiAddctionLoginIn")
    fwin:addTouchEventListener(Button_fangchenmi,nil, 
    {
        terminal_name = "anti_addction_loginin_open",   
        terminal_state = 0,
        from_type = "home",
        isPressedActionEnabled = true
    }, 
    nil, 0)

    if _ED.first_login_game == true and zstring.tonumber(_ED.parse_user_register_anti) == 0 then
        state_machine.excute("anti_addction_loginin_open",0,{_datas = {
            terminal_name = "anti_addction_loginin_open",       
            terminal_state = 0, 
            from_type = "home" , 
            isPressedActionEnabled = true
            }})
        _ED.first_login_game = false
    end
end

function HomeButton:onInit()
    local csbItem = csb.createNode(config_csb.home.home_button)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    --副本
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pve"), nil, 
    {
        terminal_name = "duplicate_manager_window_open",
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 2)
    --活动
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_activity"), nil, 
    {
        terminal_name = "home_button_choose_activity", 
        -- func_string = [[funOpenDrawTip(56)]], 
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 2)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_home_button_activity",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_activity"),
    _invoke = nil,
    _interval = 0.5,})


    -- 登录送
    -- local Button_login = ccui.Helper:seekWidgetByName(root, "Button_login")
    -- Button_login:setVisible(false)
    
    --邮件
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_mail"), nil, 
    {
        terminal_name = "mail_window_open", 
        -- func_string = [[funOpenDrawTip(58)]], 
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 2)      
    
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_home_button_mail",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_mail"),
    _invoke = nil,
    _interval = 0.5,})

    -- local Button_raiders = ccui.Helper:seekWidgetByName(root,"Button_raiders")
    -- Button_raiders:setVisible(false)
    -- if funOpenDrawTip(59,false) == false then 
    --     Button_raiders:setVisible(true)
    -- end
    --助手
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_raiders"), nil, 
    {
        terminal_name = "strategy_main_open",
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 2)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_home_button_strategy",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_raiders"),
    _invoke = nil,
    _interval = 0.5,})

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_third"), nil, 
    {
        -- terminal_name = "strategy_main_open",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 2)

 --    if _ED.activity_info["15"] ~= nil then
 --        self._sign_activity = _ED.activity_info["15"]
 --    end
 --    self._panel_qiandao = ccui.Helper:seekWidgetByName(root, "Panel_qiandao")
 --    if self._panel_qiandao ~= nil then 
 --        self._panel_qiandao:setVisible(false)
 --    end

	-- self:updateDraw()
 --    self:checkMission()
end

function HomeButton:checkMission()
    if missionIsOver() == false then
        -- print("==11111111111===========")
        executeNextEvent(nil, false)
    else
        -- print("=======","l".._ED.user_info.user_grade.."e".._ED.user_info.user_experience)
        if executeMissionExt(mission_mould_tuition, nil, nil, nil, true, "l".._ED.user_info.user_grade.."e".._ED.user_info.user_experience, true) == false then
            -- print("==333333333333===========")
			if _ED.easy_now_scene_id > 0 then
				local sceneParam = "sc".._ED.scene_current_state[zstring.tonumber("".._ED.easy_now_scene_id)]..
					"m".._ED.scene_max_state[zstring.tonumber("".._ED.easy_now_scene_id)]
				if executeMissionExt(mission_mould_tuition, touch_off_mission_battle_over, "".._ED.easy_now_scene_id, nil, true, sceneParam, true) == false then
				end
			end
        end
    end
end

function HomeButton:onEnterTransitionFinish()

end

function HomeButton:init()
	self:onInit()
    return self
end

function HomeButton:onExit()
    state_machine.remove("home_button_window_show")
    state_machine.remove("home_button_window_hide")
    state_machine.remove("home_button_show_anti")
    state_machine.remove("home_button_choose_activity")
end