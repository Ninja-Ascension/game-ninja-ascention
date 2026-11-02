-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏开启里面的系统设置
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
InStall = class("InStallClass", Window)
	
function InStall:ctor()
    self.super:ctor()
	self.roots = {}
    self.action = nil
	self.actions = {}
	self.status = false
	self.timeRoot = nil
    -- Initialize AnnouncePage page state machine.
    local function init_inStall_terminal()
		--设置里面的关闭按钮
        local inStall_close_terminal = {
            _name = "inStall_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				fwin:close(instance)
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--设置里面的公告按钮
        local inStall_announce_open_terminal = {
            _name = "inStall_announce_open",
            _init = function (terminal)
                app.load("client.system.AnnouncePage")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	fwin:close(fwin:find("AnnouncePageClass"))
				fwin:open(AnnouncePage:new(), fwin._ui)
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local inStall_change_account_terminal = {
            _name = "inStall_change_account",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local isClearPlatForm = true
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
					if app.configJson.OperatorName == "gamedreamer" then
						isClearPlatForm = false
					end
				end
            	if cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_WINDOWS 
					and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_LINUX 
					and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_MAC then
					if isClearPlatForm == true then
						handlePlatformRequest(0, LOGOUT, "")
					else
						fwin:removeAll()
						fwin:reset(nil)
						fwin:open(Login:new(), fwin._view)
						fwin:close(fwin:find("ConnectingViewClass"))
					end
				else
					if isClearPlatForm == true then
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
					end
					fwin:removeAll()
					fwin:reset(nil)
					fwin:open(Login:new(), fwin._view)
					fwin:close(fwin:find("ConnectingViewClass"))
					if isClearPlatForm == true then
						_ED.m_is_games = false
					end
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local inStall_bind_account_terminal = {
            _name = "inStall_bind_account",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	handlePlatformRequest(0, BINDACCOUNT, "")
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(inStall_close_terminal)
		state_machine.add(inStall_announce_open_terminal)
		state_machine.add(inStall_change_account_terminal)
		state_machine.add(inStall_bind_account_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_inStall_terminal()
end
function InStall:formatTimeString(m_time)	--系统时间转换
	local temp = os.date("*t",m_time)

	local m_month 	= string.format("%02d", temp.month)
	local m_day 	= string.format("%02d", temp.day)
	local m_hour 	= string.format("%02d", temp.hour)
	local m_min 	= string.format("%02d", temp.min)
	local m_sec 	= string.format("%02d", temp.sec)
	local timeString = m_hour ..":".. m_min  ..",".. m_month .."/".. m_day
	-- local timeString = m_hour ..":".. m_min ..",".. m_month .."/".. m_day:temp
	-- print("timeString---------------",timeString)
    return timeString
end
function InStall:onUpdate(dt)
	if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh) then
		if self.timeRoot ~= nil then
			local timetext = ccui.Helper:seekWidgetByName(self.timeRoot, "Text_34_0")
			local times = tonumber(os.time())- tonumber(_ED.native_time)
			local tttt = self:formatTimeString(_ED.system_time+times)
			timetext:setString(tttt)
		end
	end
end

function InStall:onEnterTransitionFinish()
	local csbInStall = csb.createNode("system/set_up.csb")
	self:addChild(csbInStall)
	local root = csbInStall:getChildByName("root")
	table.insert(self.roots, root)
	
	
	if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh) then
		if ccui.Helper:seekWidgetByName(root, "Panel_system_notice_0") ~= nil then
			-- app.load("client.utils.TimeUtil")
			self.timeRoot = ccui.Helper:seekWidgetByName(root, "Panel_system_notice_0"):getChildByName("ProjectNode_system_notice"):getChildByName("Panel_19")
		end
	end
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_103"), nil, {terminal_name = "inStall_close",  terminal_state = 0, isPressedActionEnabled = true}, nil, 0)
	
	local root1 = ccui.Helper:seekWidgetByName(root, "Panel_background_sound"):getChildByName("ProjectNode_background_sound"):getChildByName("root")
	local root2 = ccui.Helper:seekWidgetByName(root, "Panel_sound_effect"):getChildByName("ProjectNode_sound_effect"):getChildByName("root")
	-- local root3 = ccui.Helper:seekWidgetByName(root, "Panel_interface_effects"):getChildByName("ProjectNode_3"):getChildByName("root")
	local root4 = ccui.Helper:seekWidgetByName(root, "Panel_hover_chat"):getChildByName("ProjectNode_hover_chat"):getChildByName("root")
	-- local root5 = ccui.Helper:seekWidgetByName(root, "Panel_invite_friends"):getChildByName("ProjectNode_invite_friends"):getChildByName("root")
	-- local root6 = ccui.Helper:seekWidgetByName(root, "Panel_system_notice"):getChildByName("ProjectNode_system_notice"):getChildByName("Panel_19")
	-- local root7 = ccui.Helper:seekWidgetByName(root, "Panel_call_center"):getChildByName("ProjectNode_call_center"):getChildByName("root")
	local Panel_change_login = ccui.Helper:seekWidgetByName(root, "Panel_change_login")
	local root8 = nil
	if Panel_change_login ~= nil then
		root8 = Panel_change_login:getChildByName("ProjectNode_change_login"):getChildByName("root")
	end

	local music_btn = nil
	local sound_btn = nil
	local chat_btn = nil
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
		then
		local _sound = iscurrentBgm()
		local _music = isBgmOpen()

		local currentAccount = _ED.user_platform[_ED.default_user].platform_account
		local currentServerNumber = _ED.all_servers[_ED.selected_server].server_number
		local newPropTag = currentAccount..currentServerNumber.."chatViewDialog" .. "end"
		local data = cc.UserDefault:getInstance():getStringForKey(newPropTag)
		local temp = zstring.split(data, ",")
		music_btn = ccui.Helper:seekWidgetByName(root1, "Button_22")
		sound_btn = ccui.Helper:seekWidgetByName(root2, "Button_22")
		chat_btn = ccui.Helper:seekWidgetByName(root4, "Button_22")

		if temp[3] == "1" then
			chat_btn:setHighlighted(false)
		elseif temp[3] == "2" then
			chat_btn:setHighlighted(true)
		end
		if _music == true then
			music_btn:setHighlighted(false)
		else
			music_btn:setHighlighted(true)
		end
		if _sound == true then
			sound_btn:setHighlighted(false)
		else
			sound_btn:setHighlighted(true)
		end
	end

	local function notOpenCallBack(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			TipDlg.drawTextDailog(_function_unopened_tip_string)
		elseif eventType == ccui.TouchEventType.began then
			
		end
	end
	-- ccui.Helper:seekWidgetByName(root3, "Button_22"):addTouchEventListener(notOpenCallBack)
	-- ccui.Helper:seekWidgetByName(root5, "Button_22"):addTouchEventListener(notOpenCallBack)
	-- ccui.Helper:seekWidgetByName(root6, "Button_22"):addTouchEventListener(notOpenCallBack)
	-- ccui.Helper:seekWidgetByName(root7, "Button_22"):addTouchEventListener(notOpenCallBack)
	
	local action1 = csb.createTimeline("system/background_sound_effect.csb")
    root1:runAction(action1)
	
	local action2 = csb.createTimeline("system/sound_effect.csb")
    root2:runAction(action2)
	
	local action4 = csb.createTimeline("system/hover_chat.csb")
    root4:runAction(action4)

	local status = isBgmOpen()
	if status == false then
		action1:play("Button_22_touch_2",false)
		status = true
	else
		action1:play("Button_22_touch_1",false)
		status = false
	end
	local function musicCallBack(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			if status == false then
				action1:play("Button_22_touch_2",false)
				status = true
				muteBgm()
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
					or __lua_project_id == __lua_project_red_alert 
					or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
					then
					music_btn:setHighlighted(true)
				end
			elseif status == true then
				action1:play("Button_22_touch_1",false)
				status = false
				openBgm()
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
					or __lua_project_id == __lua_project_red_alert 
					or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
					then
					music_btn:setHighlighted(false)
				end
			end
			
		elseif eventType == ccui.TouchEventType.began then
			
		end
	end
	ccui.Helper:seekWidgetByName(root1, "Button_22"):addTouchEventListener(musicCallBack)
	
	
	local status2 = iscurrentBgm()
	if status2 == false then
		action2:play("Button_23_touch_2",false)
		status2 = true
	else
		action2:play("Button_23_touch_1",false)
		status2 = false
	end
	local function musicSoundCallBack(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			if status2 == false then
				action2:play("Button_23_touch_2",false)
				status2 = true
				muteSoundEffect()
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
					or __lua_project_id == __lua_project_red_alert 
					or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
					then
					sound_btn:setHighlighted(true)
				end
			elseif status2 == true then
				action2:play("Button_23_touch_1",false)
				status2 = false
				openSoundEffect()
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
					or __lua_project_id == __lua_project_red_alert 
					or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
					then
					sound_btn:setHighlighted(false)
				end
			end
		elseif eventType == ccui.TouchEventType.began then
			
		end
	end
	ccui.Helper:seekWidgetByName(root2, "Button_22"):addTouchEventListener(musicSoundCallBack)
	
	local chatView = fwin:find("ChatHomeViewClass")
	if chatView ~= nil then
		local status4 = chatView:isVisible()
		if status4 == false then
			action4:play("Button_25_touch_2",false)
			status4 = true
		else
			action4:play("Button_25_touch_1",false)
			status4 = false
		end
	end
	local function chatCallBack(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			local _level = dms.string(dms["fun_open_condition"], 71, fun_open_condition.level)
			if tonumber(_ED.user_info.user_grade) <  tonumber(_level) then
				TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 71, fun_open_condition.tip_info))
				return
			end	
			if status4 == false then
				action4:play("Button_25_touch_2",false)
				status4 = true
				state_machine.excute("chat_hide_self", 0, "click chat_hide_self.'")
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
					or __lua_project_id == __lua_project_red_alert 
					or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
					then
					chat_btn:setHighlighted(true)
				end
			elseif status4 == true then
				action4:play("Button_25_touch_1",false)
				status4 = false
				openSoundEffect()
				state_machine.excute("chat_show_self", 0, "click chat_show_self.'")
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
					or __lua_project_id == __lua_project_red_alert 
					or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
					then
					chat_btn:setHighlighted(false)
				end
			end
		elseif eventType == ccui.TouchEventType.began then
			
		end
	end
	ccui.Helper:seekWidgetByName(root4, "Button_22"):addTouchEventListener(chatCallBack)
	
	local announce_root = ccui.Helper:seekWidgetByName(root, "Panel_system_notice"):getChildByName("ProjectNode_system_notice"):getChildByName("Panel_19")
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(announce_root, "Button_22"), nil, 
	{
		terminal_name = "inStall_announce_open",  
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, nil, 0)
	local server_review = cc.UserDefault:getInstance():getStringForKey("server_review", "1")
	if server_review == "1" or _ED.system_notice_ex == nil or _ED.system_notice_ex == "" then
		ccui.Helper:seekWidgetByName(root, "Panel_system_notice"):setVisible(false)
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
		then
		local Panel_invite_friends = ccui.Helper:seekWidgetByName(root,"Panel_invite_friends")
		if open_share_fun == 1 then -- tipstring里的开关，1 是打开，0是关闭
			app.load("client.system.share.ShareCenter")
			local ProjectNode_invite_friends = Panel_invite_friends:getChildByName("ProjectNode_invite_friends")
			local Panel_19 = ProjectNode_invite_friends:getChildByName("Panel_19")
			local Panel_13 = Panel_19:getChildByName("Panel_13")
			local button_invite = Panel_13:getChildByName("Button_22")
			
			

			local invite_id = 0
			for i=1,#dms["share_reward_mould"] do
				local share_type = dms.int(dms["share_reward_mould"],i,share_reward_mould.share_type)
				if share_type == 5 then
					invite_id = dms.int(dms["share_reward_mould"],i,share_reward_mould.id)
					break
				end
			end
			fwin:addTouchEventListener(button_invite, nil, 
			{
				terminal_name = "shareCenter_to_getdata_and_open_share_dlg",  
				terminal_state = 0, 
				isPressedActionEnabled = true,
				share_id = invite_id --shareid = 1 为邀请
			}, nil, 0)
		else
			Panel_invite_friends:setVisible(false)
		end
	end

	if root8 ~= nil then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root8, "Button_22"), nil, 
		{
			terminal_name = "inStall_change_account",  
			terminal_state = 0, 
			isPressedActionEnabled = true
		}, nil, 0)
	end

	local Panel_youkebangding = ccui.Helper:seekWidgetByName(root, "Panel_youkebangding")
	if Panel_youkebangding ~= nil then
		local youkebangding_root = Panel_youkebangding:getChildByName("ProjectNode_youkebangding"):getChildByName("Panel_19")
		if youkebangding_root ~= nil then
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(youkebangding_root, "Button_22"), nil, 
			{
				terminal_name = "inStall_bind_account",  
				terminal_state = 0, 
				isPressedActionEnabled = true
			}, nil, 0)
		end
	end
end


function InStall:onExit()
	self.timeRoot = nil
	state_machine.remove("inStall_close")
	state_machine.remove("inStall_announce_open")
	state_machine.remove("inStall_change_account")
	state_machine.remove("inStall_bind_account")
end