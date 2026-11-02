-- Logout/switch account (former AccountSysFloatingWindow switch terminal).
function nrSwitchAccount()
    local info = {platform_id="", register_type="", platform_account="", nickname="", password="", is_registered=false}
    _ED.user_platform = {}
    _ED.user_platform[info.platform_account] = info
    _ED.default_user = info.platform_account
    m_sUin = ""
    pcall(handlePlatformRequest, 0, LOGOUT, "")
    m_account_sys_floating_switch = true
    if account_sys_forget_token then account_sys_forget_token() end   -- after leaving, the password is asked again
    fwin:removeAll()
    fwin:reset(nil)
    initialize_ed()
    _ED.m_is_games = false
    protocol_command.search_user_platform.user_info_switch = true
    app.load("client.login.login")
    fwin:open(Login:new(), fwin._view)
    fwin:close(fwin:find("ConnectingViewClass"))
end

-- ----------------------------------------------------------------------------------------------------
-- 说明：数码系统设置页
-------------------------------------------------------------------------------------------------------
SmPlayerSystemSetPage = class("SmPlayerSystemSetPageClass", Window)
require("client.utils.FuryGameSpeed")   -- Fury (V3): casilla 4 = velocidad del juego VIP
local sm_player_system_set_page_open_terminal = {
    _name = "sm_player_system_set_page_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        local page = SmPlayerSystemSetPage:createCell():init()
    	return page
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_player_system_set_page_open_terminal)
state_machine.init()
    
function SmPlayerSystemSetPage:ctor()
    self.super:ctor()
   	self.actions = {}
	self.roots = {}
    self.image_on_group = {}
    self.image_off_group = {}
    self.image_button_group = {}
	
    local function init_sm_player_system_set_page_terminal()
        --显示
        local sm_player_system_set_page_show_terminal = {
            _name = "sm_player_system_set_page_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                	instance:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --隐藏
        local sm_player_system_set_page_hide_terminal = {
            _name = "sm_player_system_set_page_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --推送
        local sm_player_system_set_tuisong_terminal = {
            _name = "sm_player_system_set_tuisong",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                TipDlg.drawTextDailog(_new_interface_text[113])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --黑名单
        local sm_player_system_set_back_list_open_terminal = {
            _name = "sm_player_system_set_back_list_open",
            _init = function (terminal)
                app.load("client.l_digital.player.SmPlayerSystemSetBackList")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("sm_playersystem_set_backList_open",0,"sm_playersystem_set_backList_open.")
                    end
                end
                NetworkManager:register(protocol_command.friend_update.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --兑换码
        local sm_player_system_set_cdKey_open_terminal = {
            _name = "sm_player_system_set_cdKey_open",
            _init = function (terminal)
                app.load("client.l_digital.player.SmPlayerSystemSetCDKey")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("sm_player_system_set_cdkey_page_open",0,"sm_player_system_set_cdkey_page_open.")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --客服
        local sm_player_system_set_service_open_terminal = {
            _name = "sm_player_system_set_service_open",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                app.load("client.l_digital.player.SmPlayerSystemQAWindow")
                state_machine.excute("sm_player_system_qa_window_open",0,"")

                -- if config_operation.gmMessageAndReply == true then
                --     app.load("client.l_digital.player.SmPlayerSystemQAWindow")
                --     state_machine.excute("sm_player_system_qa_window_open",0,"")
                --     -- local function responseGMCallback(response)
                --     --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                --     --         app.load("client.l_digital.player.SmPlayerSystemGMMessage")
                --     --         state_machine.excute("sm_player_system_GM_message_page_open",0,"sm_player_system_GM_message_page_open.")
                --     --     end
                --     -- end
                --     -- NetworkManager:register(protocol_command.gm_message_init.code, nil, nil, nil, instance, responseGMCallback, false, nil)
                -- else
                --     app.load("client.l_digital.player.SmPlayerSystemSetService")
                --     state_machine.excute("sm_player_system_set_service_page_open",0,"sm_player_system_set_service_page_open.")
                -- end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --公告
        local sm_player_system_set_announce_open_terminal = {
            _name = "sm_player_system_set_announce_open",
            _init = function (terminal)
                app.load("client.red_alert_time.game_announcement.GameAnnouncement")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("game_announcement_window_open", 0, nil)
                    end
                end
                NetworkManager:register(protocol_command.get_system_notice.code, app.configJson.urlForAnnounce, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 头衔
        local sm_player_system_set_designation_open_terminal = {
            _name = "sm_player_system_set_designation_open",
            _init = function (terminal)
                -- app.load("client.l_digital.player.SmPlayerSystemSetDesignation")
                app.load("client.l_digital.player.SmTitleInfoWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- TipDlg.drawTextDailog(_new_interface_text[113])
                -- state_machine.excute("sm_player_system_set_designation_page_open",0,"sm_player_system_set_designation_page_open.")
                state_machine.excute("sm_title_info_window_open", 0, "sm_title_info_window_open")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_player_system_set_logout_terminal = {
            _name = "sm_player_system_set_logout",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- NinjaAscension "Sair": same path as the old floating button.
                if nrSwitchAccount then nrSwitchAccount() return true end
                fwin:open(ConnectingView:new(), fwin._windows)
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
                m_sUin = nil
                fwin:addService({
                    callback = function ( params )
                        fwin:reset(nil)
                        initialize_ed()
                        fwin:open(Login:new(), fwin._view)
                        fwin:close(fwin:find("ConnectingViewClass"))
                        _ED.m_is_games = false
                    end,
                    delay = 0.1,
                    params = self
                })
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }

        local sm_player_system_url_jump_terminal = {
            _name = "sm_player_system_url_jump",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local m_type = tonumber(params._datas._type)
                handlePlatformRequest(0, CC_OPEN_URL, _web_page_jump[m_type])
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }

        local sm_player_system_user_center_terminal = {
            _name = "sm_player_system_user_center",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- NinjaAscension "Conta": back to the account window to switch account.
                nrSwitchAccount()
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }

        local sm_player_system_user_record_terminal = {
            _name = "sm_player_system_user_record",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- El historial de recargas nativo era
                -- del operador antiguo; con el operador actual (app.config: "t4")
                -- la condicion nunca se cumplia. Rama muerta retirada.
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }

        -- 打开帐号注销
        local sm_player_system_accout_deletion_open_terminal = {
            _name = "sm_player_system_accout_deletion_open",
            _init = function (terminal)
                app.load("client.l_digital.player.AccountDeletionWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local status = readKey("accout_deletion_status")    
                if status == nil or status == "" then
                    status = 1
                end
                if tonumber(status) == 4 then
                    -- 申请撤销成功
                    local cancelTime = readKey("accout_deletion_cancel_time")
                    if cancelTime ~= nil and cancelTime ~= "" then
                        local currentTime = _ED.system_time + (os.time() - _ED.native_time)
                        local cutTime = math.abs(currentTime - tonumber(cancelTime))
                        -- 小于24小时不可重复申请
                        if cutTime <= 60 * 60 * 24 then
                            TipDlg.drawTextDailog(tipStringInfo_account_deletion[1])
                            return true
                        else
                            status = 1
                            writeKey("accout_deletion_cancel_time", "")
                        end
                    end
                    writeKey("accout_deletion_status", "1")
                elseif tonumber(status) == 2 or tonumber(status) == 3 then
                    -- 申请注销成功/申请撤销
                    local deletTime = readKey("accout_deletion_times")
                    if deletTime ~= nil and deletTime ~= "" then
                        -- 3天后注销帐号
                        local currentTime = _ED.system_time + (os.time() - _ED.native_time)
                        local cutHour = math.ceil((24 * 60 * 60 * 3 - math.abs(currentTime - deletTime)) / (60 * 60))
                        if cutHour <= 0 then 
                            -- 注销倒计时结束后恢复到申请状态
                            status = 1
                            writeKey("accout_deletion_status", status)
                        else
                            if tonumber(status) == 2 then
                                status = 3
                                writeKey("accout_deletion_status", status)
                            end
                        end
                    end
                end
                state_machine.excute("account_deletion_window_open", 0, {status})
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }


        state_machine.add(sm_player_system_set_page_show_terminal)
		state_machine.add(sm_player_system_set_page_hide_terminal)
        state_machine.add(sm_player_system_set_tuisong_terminal)
        state_machine.add(sm_player_system_set_back_list_open_terminal)
        state_machine.add(sm_player_system_set_cdKey_open_terminal)
        state_machine.add(sm_player_system_set_service_open_terminal)
        state_machine.add(sm_player_system_set_announce_open_terminal)
        state_machine.add(sm_player_system_set_designation_open_terminal)
        state_machine.add(sm_player_system_set_logout_terminal)
        state_machine.add(sm_player_system_url_jump_terminal)
        state_machine.add(sm_player_system_user_center_terminal)
        state_machine.add(sm_player_system_user_record_terminal)
        state_machine.add(sm_player_system_accout_deletion_open_terminal)
        state_machine.init()
    end
    
    init_sm_player_system_set_page_terminal()
end
function SmPlayerSystemSetPage:onUpdataDraw()
	local root = self.roots[1]
    if isBgmOpen() == true then
        self.image_button_group[1]:setPosition(cc.p(self.image_off_group[1]:getPosition()))
    else
        self.image_button_group[1]:setPosition(cc.p(self.image_on_group[1]:getPosition()))
    end
    if iscurrentBgm() == true then
        self.image_button_group[2]:setPosition(cc.p(self.image_off_group[2]:getPosition()))
    else
        self.image_button_group[2]:setPosition(cc.p(self.image_on_group[2]:getPosition()))
    end
    local showMasterHp = cc.UserDefault:getInstance():getStringForKey("m_isShowMasterHp")
    if tonumber(showMasterHp) == 1 then
        self.image_button_group[3]:setPosition(cc.p(self.image_off_group[3]:getPosition()))
    else
        self.image_button_group[3]:setPosition(cc.p(self.image_on_group[3]:getPosition()))
    end
    if fury_game_speed.game_enabled() then
        self.image_button_group[4]:setPosition(cc.p(self.image_off_group[4]:getPosition()))
    else
        self.image_button_group[4]:setPosition(cc.p(self.image_on_group[4]:getPosition()))
    end  
end

function SmPlayerSystemSetPage:onInit()
	local csbUserInfo = csb.createNode("player/role_information_tab_2.csb")
	self:addChild(csbUserInfo)
	local root = csbUserInfo:getChildByName("root")
	table.insert(self.roots, root)
    --推送
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tuisong"),nil, 
    {
        terminal_name = "sm_player_system_set_tuisong",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
    --黑名单
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tuisong_2"),nil, 
    {
        terminal_name = "sm_player_system_set_back_list_open",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
    --兑换码
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tuisong_3"),nil, 
    {
        terminal_name = "sm_player_system_set_cdKey_open",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
    --官方客服
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tuisong_4"),nil, 
    {
        terminal_name = "sm_player_system_set_service_open",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    --游戏公告
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tuisong_5"),nil, 
    {
        terminal_name = "sm_player_system_set_announce_open",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 头衔
    -- dsc称号从系统设置移到玩家信息面板
    -- Button_tuisong_6由美术隐藏
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tuisong_6"),nil, 
    {
        terminal_name = "sm_player_system_set_designation_open",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    --退出
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tuisong_7"),nil, 
    {
        terminal_name = "sm_player_system_set_logout",
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    --facebook粉丝页
    local Button_tuisong_8 = ccui.Helper:seekWidgetByName(root, "Button_tuisong_8")
    if Button_tuisong_8 ~= nil then
        fwin:addTouchEventListener(Button_tuisong_8,nil, 
        {
            terminal_name = "sm_player_system_url_jump",
            terminal_state = 0,
            _type = 1,
            isPressedActionEnabled = true
        }, 
        nil, 0)
    end

    --官方网页
    local Button_tuisong_9 = ccui.Helper:seekWidgetByName(root, "Button_tuisong_9")
    if Button_tuisong_9 ~= nil then
        fwin:addTouchEventListener(Button_tuisong_9,nil, 
        {
            terminal_name = "sm_player_system_url_jump",
            terminal_state = 0,
            _type = 2,
            isPressedActionEnabled = true
        }, 
        nil, 0)
    end

    --客服中心
    local Button_tuisong_10 = ccui.Helper:seekWidgetByName(root, "Button_tuisong_10")
    if Button_tuisong_10 ~= nil then
        fwin:addTouchEventListener(Button_tuisong_10,nil, 
        {
            terminal_name = "sm_player_system_url_jump",
            terminal_state = 0,
            _type = 3,
            isPressedActionEnabled = true
        }, 
        nil, 0)
    end

    --用户中心
    local Button_tuisong_11 = ccui.Helper:seekWidgetByName(root, "Button_tuisong_11")
    if Button_tuisong_11 ~= nil then
        fwin:addTouchEventListener(Button_tuisong_11,nil, 
        {
            terminal_name = "sm_player_system_user_center",
            terminal_state = 0,
            isPressedActionEnabled = true
        }, 
        nil, 0)
    end

    --充值记录
    local Button_tuisong_12 = ccui.Helper:seekWidgetByName(root, "Button_tuisong_12")
    if Button_tuisong_12 ~= nil then
        fwin:addTouchEventListener(Button_tuisong_12,nil, 
        {
            terminal_name = "sm_player_system_user_record",
            terminal_state = 0,
            isPressedActionEnabled = true
        }, 
        nil, 0)
    end

    -- 帐号注销
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_accout_cancel"),nil, 
    {
        terminal_name = "sm_player_system_accout_deletion_open",
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- Fury (V3): la casilla 4 («Lens Stretch», m_isSceneExtrude) venia OCULTA en
    -- la maqueta y nadie leia su clave. Pasa a ser la velocidad del juego VIP y
    -- solo se ensena a quien la tiene. Se clona la casilla 3 porque el arte de
    -- la 4 tiene otras medidas.
    local gameSpeed = fury_game_speed.game_tier()
    if gameSpeed ~= nil then
        local switch3 = ccui.Helper:seekWidgetByName(root, "Image_switch_3")
        local switch4 = ccui.Helper:seekWidgetByName(root, "Image_switch_4")
        local textSpeed = ccui.Helper:seekWidgetByName(root, "Text_camera")
        if switch3 ~= nil and switch4 ~= nil and textSpeed ~= nil then
            local clone = switch3:clone()
            clone:setName("Image_switch_4")
            clone:setPosition(cc.p(switch4:getPosition()))
            clone:setVisible(true)
            for _, part in ipairs({"Image_on_", "Image_off_", "Image_button_"}) do
                clone:getChildByName(part .. "3"):setName(part .. "4")
            end
            switch4:getParent():addChild(clone)
            switch4:removeFromParent(true)
            textSpeed:setString(string.format(_fury_speed_text[2], tostring(gameSpeed)))
            local width = textSpeed:getAutoRenderSize().width
            if width > 100 then
                textSpeed:setScale(100 / width)
            end
            textSpeed:setVisible(true)
        end
    end

    for i = 1 , 4 do 
        self.image_on_group[i] = ccui.Helper:seekWidgetByName(root, "Image_on_"..i)
        self.image_off_group[i] = ccui.Helper:seekWidgetByName(root, "Image_off_"..i)
        self.image_button_group[i] = ccui.Helper:seekWidgetByName(root, "Image_button_"..i)
    end
    
    for i = 1 , 4 do   
        local status = true
        if i == 1 then
            status = isBgmOpen()
        elseif i == 2 then
            status = iscurrentBgm()
        elseif i == 3 then
            local showMasterHp = cc.UserDefault:getInstance():getStringForKey("m_isShowMasterHp")
            status = (tonumber(showMasterHp) == 1)
        else
            status = fury_game_speed.game_enabled()
        end
        self.image_on_group[i]:setVisible(status == true)
        self.image_off_group[i]:setVisible(status == false)
        local function musicCallBack(sender, eventType)
            if eventType == ccui.TouchEventType.ended then
                if status == false then
                    status = true
                    if sender.index == 1 then
                        openBgm()
                    elseif sender.index == 2 then
                        openSoundEffect()
                    elseif sender.index == 3 then
                        cc.UserDefault:getInstance():setStringForKey("m_isShowMasterHp","1")
                        cc.UserDefault:getInstance():flush()
                    else
                        fury_game_speed.set_game_enabled(true)
                    end
                    self.image_on_group[sender.index]:setVisible(true)
                    self.image_off_group[sender.index]:setVisible(false)
                    sender:setPosition(cc.p(self.image_off_group[sender.index]:getPosition()))
                elseif status == true then
                    status = false
                    if sender.index == 1 then
                        muteBgm()
                    elseif sender.index == 2 then
                        muteSoundEffect()
                    elseif sender.index == 3 then
                        cc.UserDefault:getInstance():setStringForKey("m_isShowMasterHp","0")
                        cc.UserDefault:getInstance():flush()
                    else
                        fury_game_speed.set_game_enabled(false)
                    end
                    self.image_on_group[sender.index]:setVisible(false)
                    self.image_off_group[sender.index]:setVisible(true)
                    sender:setPosition(cc.p(self.image_on_group[sender.index]:getPosition()))
                end
            end
        end
        self.image_button_group[i].index = i
        self.image_button_group[i]:addTouchEventListener(musicCallBack)
    end

	self:onUpdataDraw()
end

function SmPlayerSystemSetPage:init(params)
    -- local _windows = params
    -- self._rootWindows = _windows
    self:onInit()
    return self
end

function SmPlayerSystemSetPage:onExit()
	state_machine.remove("sm_player_system_set_page_show")
    state_machine.remove("sm_player_system_set_page_hide")
    state_machine.remove("sm_player_system_set_tuisong")
    state_machine.remove("sm_player_system_set_back_list_open")
    state_machine.remove("sm_player_system_set_cdKey_open")
    state_machine.remove("sm_player_system_set_service_open")
    state_machine.remove("sm_player_system_set_announce_open")
    state_machine.remove("sm_player_system_set_designation_open")
    state_machine.remove("sm_player_system_set_logout")
    state_machine.remove("sm_player_system_accout_deletion_open")
end

function SmPlayerSystemSetPage:createCell()
    local cell = SmPlayerSystemSetPage:new()
    cell:registerOnNodeEvent(cell)
    return cell
end