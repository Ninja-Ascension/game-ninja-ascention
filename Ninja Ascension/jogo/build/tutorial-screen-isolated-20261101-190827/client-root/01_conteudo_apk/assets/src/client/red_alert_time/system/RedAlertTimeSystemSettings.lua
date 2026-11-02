-- ----------------------------------------------------------------------------------------------------
-- 说明：系统主界面
-------------------------------------------------------------------------------------------------------
RedAlertTimeSystemSettings = class("RedAlertTimeSystemSettingsClass", Window)

local red_alert_time_system_settings_open_terminal = {
    _name = "red_alert_time_system_settings_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("RedAlertTimeSystemSettingsClass")
        if nil == _homeWindow then
    		fwin:open(RedAlertTimeSystemSettings:new():init(), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_system_settings_close_terminal = {
    _name = "red_alert_time_system_settings_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("RedAlertTimeSystemSettingsClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("RedAlertTimeSystemSettingsClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_system_settings_open_terminal)
state_machine.add(red_alert_time_system_settings_close_terminal)
state_machine.init()
    
function RedAlertTimeSystemSettings:ctor()
    self.super:ctor()
    self.roots = {}

    app.load("client.red_alert_time.big_map.WorldMapPlayInfor")
	app.load("client.red_alert_time.system.RedAlertTimeSystemExchangePacks")
	app.load("client.red_alert_time.system.RedAlertTimeSystemGameSet")
    app.load("client.red_alert_time.system.RedAlertTimeSystemDontDisturb")
    app.load("client.red_alert_time.system.RedAlertTimeGameAnnouncement")
    app.load("client.red_alert_time.big_map.WorldMapPlayInfor")
    app.load("client.red_alert_time.cells.system.set_up_cell")
	local function init_red_alert_time_system_settings_terminal()
		
		
		-- -- 
        -- local red_alert_time_mine_detect_result_attack_terminal = {
            -- _name = "red_alert_time_mine_detect_result_attack",
            -- _init = function (terminal)
				-- app.load("client.red_alert_time.formation.Formation")
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params)
				-- state_machine.excute("formation_window_open", 0, {_datas = {form_type = 2, attack_cell = self.m_object.info ,playersOrmine = 0}})
                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }
		
		-- 登出
        local red_alert_time_set_logout_terminal = {
            _name = "red_alert_time_set_logout",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_WINDOWS 
					and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_LINUX 
					and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_MAC then
					handlePlatformRequest(0, LOGOUT, "")
				else
					local platformloginInfo = {
						platform_id="",
						register_type="",
						platform_account="",
						nickname="",		
						password="",
						is_registered = false
					}
					_ED.user_platform = {}
					_ED.user_platform[platformloginInfo.platform_account] = platformloginInfo
					_ED.default_user = platformloginInfo.platform_account
                    fwin:addService({
                            callback = function ( params )
                                fwin:removeAll()
                                app.unload("client.loader.EnvironmentDatas")
                                app.load("client.loader.EnvironmentDatas")
                                -- fwin:reset(nil)
                                fwin:open(Login:new(), fwin._view)
                                fwin:close(fwin:find("ConnectingViewClass"))
                                _ED.m_is_games = false
                            end,
                            delay = 0.1,
                            params = self
                        })
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }
        -- 选择语言
        local more_talk_xuanze_yuyan_terminal = {
            _name = "more_talk_xuanze_yuyan",
            _init = function (terminal)
                app.load("client.red_alert_time.home.MoreSystemChooseLanguage")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(MoreSystemChooseLanguage:new():init(2), fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(red_alert_time_set_logout_terminal)
	    state_machine.add(more_talk_xuanze_yuyan_terminal)
		state_machine.init()
	end
	
	init_red_alert_time_system_settings_terminal()
end

function RedAlertTimeSystemSettings:init()
    self:setTouchEnabled(true)
    self:onInit()
    return self
end

function RedAlertTimeSystemSettings:onUpdateDraw()
	local root = self.roots[1]
	--服务器信息
	local Text_server_now_n = ccui.Helper:seekWidgetByName(root,"Text_server_now_n")
	Text_server_now_n:setString(_ED.all_servers[_ED.selected_server].server_name)
	--角色id
	local Text_player_id_n = ccui.Helper:seekWidgetByName(root,"Text_player_id_n")
	Text_player_id_n:setString(_ED.user_platform[_ED.default_user].platform_account)
	--当前游戏版本
	local Text_now_edition_n = ccui.Helper:seekWidgetByName(root,"Text_now_edition_n")
	Text_now_edition_n:setString(m_sVersion)
end

function RedAlertTimeSystemSettings:onInit()
    local csbRedAlertTimeSystemSettings = csb.createNode(config_csb.system.red_alert_time_set_up)
    local root = csbRedAlertTimeSystemSettings:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbRedAlertTimeSystemSettings)

    self.__check_covers = true
    root.__cwindow = self
    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)
	
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_set_up_close"), nil, 
    {
        terminal_name = "red_alert_time_system_settings_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)
	
	-- 游戏设置
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_game_set_up"), nil, 
    {
        terminal_name = "red_alert_time_system_game_set_open",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)
	
	-- 服务器列表
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_sever_list"), nil, 
    {
        terminal_name = "server_managers_window_open",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)
	
	-- 联系客服
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_contact_customer_service"), nil, 
    {
        terminal_name = "",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)
	
	-- 礼包兑换
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_gift_exchage"), nil, 
    {
        terminal_name = "red_alert_time_system_exchange_packs_open",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)
	
	-- 公告
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_new_notice"), nil, 
    {
        terminal_name = "game_announcement_window_open",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_game_announcement",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_new_notice"),
    _invoke = nil,
    _interval = 0.2,})
    if zstring.tonumber(_ED.server_review) ~= 1 then
        ccui.Helper:seekWidgetByName(root,"Button_gift_exchage"):setVisible(true)
        ccui.Helper:seekWidgetByName(root,"Button_new_notice"):setVisible(true)
    else
        ccui.Helper:seekWidgetByName(root,"Button_gift_exchage"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Button_new_notice"):setVisible(false)
    end
	
	-- 世界玩法
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_world_play"), nil, 
    {
        terminal_name = "world_map_play_infor_window_open",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)
	
	-- 账号切换
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_switch_account"), nil, 
    {
        terminal_name = "red_alert_time_set_logout",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)
	
	-- 实名认证
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_real_name_auth"), nil, 
    {
        terminal_name = "",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)
	--添加语言选择
    local languageButton = ccui.Helper:seekWidgetByName(root, "Button_switch_account_0")
    if languageButton ~= nil then
        fwin:addTouchEventListener(languageButton,       nil, 
        {
            terminal_name = "more_talk_xuanze_yuyan",        
            terminal_state = 0, 
            isPressedActionEnabled = true
        }, 
        nil, 0)
    end
	self:onUpdateDraw()
end

function RedAlertTimeSystemSettings:onExit()
	
end