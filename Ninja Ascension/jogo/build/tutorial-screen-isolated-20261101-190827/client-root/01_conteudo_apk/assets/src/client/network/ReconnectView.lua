ReconnectView = class("ReconnectViewClass", Window)
ReconnectView._logout = false

--打开界面
local reconnect_view_window_open_terminal = {
    _name = "reconnect_view_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	if nil == fwin:find("LoginOfOtherTipClass") then
	        if nil == fwin:find("ReconnectViewClass") then
	        	local info = nil
	        	local socketSendData = nil
	        	if nil ~= params and type(params) == "table" then
	        		info = params[1]
	        		socketSendData = params[2]
	        	end
	            fwin:open(ReconnectView:new():init(info, socketSendData), fwin._system)
	        end
	    end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local reconnect_view_window_close_terminal = {
    _name = "reconnect_view_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ReconnectViewClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--连接超时
local reconnect_view_connect_time_out_terminal = {
    _name = "reconnect_view_connect_time_out",
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
--重新连接成功
local reconnect_view_connect_success_terminal = {
    _name = "reconnect_view_connect_success",
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

state_machine.add(reconnect_view_window_open_terminal)
state_machine.add(reconnect_view_window_close_terminal)
state_machine.add(reconnect_view_connect_time_out_terminal)
state_machine.add(reconnect_view_connect_success_terminal)
state_machine.init()

function ReconnectView:ctor()
    self.super:ctor()
	self.roots = {}
	self.info = ""
	self.request = nil
	self.socketSendData = nil
	
	local function init_reconnect_view_terminal()
		local reconnect_view_back_login_terminal = {
			_name = "reconnect_view_back_login",
			_init = function (terminal) 
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				NetworkAdaptor.socketClose()
				app.load("client.login.login")
				ReconnectView._logout = false
				fwin:reset(nil)
				cacher.destoryRefPools()
				cacher.cleanSystemCacher()
				cacher.cleanActionTimeline()
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
					or __lua_project_id == __lua_project_red_alert 
					or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
					then
					checkTipBeLeave()
				end
				cacher.remvoeUnusedArmatureFileInfoes()
				fwin:open(Login:new(), fwin._view)
				if cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_WINDOWS 
				and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_LINUX 
				and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_MAC then
					handlePlatformRequest(0, LOGOUT, "")
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		local reconnect_view_continue_chaining_terminal = {
			_name = "reconnect_view_continue_chaining",
			_init = function (terminal) 
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("reconnect_view_window_close", 0, 0)
				state_machine.excute("logout_tip_window_close", 0, 0)
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball 
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    then
                    _ED.new_prop_object = {}
                    _ED.recruit_success_ship_id = nil
                    _ED.new_reward_object = {}
                    _ED.prop_chest_store_recruiting = true
                end
				local nDatas = params._datas._window.request
				if nil ~= missionIsOver and missionIsOver() == false then
					if nil == nDatas then
						nDatas = NetworkManager:peek()
					end
				end
				if nDatas ~= nil then
					NetworkAdaptor.LuaSocket.reconnect = false
					NetworkManager:register(nDatas.command, 
											nDatas.url, 
											nDatas.mode, 
											nDatas.nType, 
											nDatas.node, 
											nDatas.handler, 
											nDatas.showWaitView, 
											nDatas.timeOut,
											nDatas.unreconnect,
											nDatas.str,
											1)
					NetworkView:reconnectErase(nDatas)
					-- if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
					-- 	NetworkAdaptor.restartSocket()
					-- end
				else
				end
				if nil ~= params._datas._window.socketSendData and type(params._datas._window.socketSendData) == "string" then
					NetworkAdaptor.socketSend(self.socketSendData)
				else
					-- NetworkAdaptor.reconnectSocket()
					
					-- if NetworkAdaptor.retry_count < NetworkAdaptor.retry_max_count 
					-- 	and false == NetworkAdaptor.LuaSocket.reconnect
					-- 	then
						if NetworkAdaptor.LuaSocket.status == -1 
							and NetworkAdaptor.LuaSocket.url ~= nil 
							then
							NetworkAdaptor.reconnectSocket()
						end
					-- end
				end
			    return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		state_machine.add(reconnect_view_back_login_terminal)
		state_machine.add(reconnect_view_continue_chaining_terminal)
		state_machine.init()
	end
	
	init_reconnect_view_terminal()
	
	
	local csbReconnectView = csb.createNode("utils/timeout_connection.csb")
    self:addChild(csbReconnectView)
	local root = csbReconnectView:getChildByName("Panel_5320")
	table.insert(self.roots, root)
	if fwin:find("FightLoadingCellClass") then 
		fwin._close_touch_end_event = false
	end
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_5327"), nil, 
	{
		terminal_name = "reconnect_view_back_login",
		_window = self,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_5328"), nil, 
	{
		terminal_name = "reconnect_view_continue_chaining",
		_window = self,
		isPressedActionEnabled = true
	},
	nil, 0)
	local Button_5327_en = ccui.Helper:seekWidgetByName(root, "Button_5327_en")
	if Button_5327_en ~= nil then
		local Button_5328_en = ccui.Helper:seekWidgetByName(root, "Button_5328_en")
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_5327_en"), nil, 
		{
			terminal_name = "reconnect_view_back_login",
			_window = self,
			isPressedActionEnabled = true
		}, 
		nil, 0)
		
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_5328_en"), nil, 
		{
			terminal_name = "reconnect_view_continue_chaining",
			_window = self,
			isPressedActionEnabled = true
		},
		nil, 0)
	end
end

function ReconnectView:onEnterTransitionFinish()
	-- body
	local root = self.roots[1]
	if root ~= nil then
		local backButton = ccui.Helper:seekWidgetByName(root, "Button_5327")
		if backButton ~= nil then
			backButton:setVisible(true)
			if _ED == nil or _ED.m_is_games ~= true then
				backButton:setVisible(false)
			end
		end
		local Button_5327_en = ccui.Helper:seekWidgetByName(root, "Button_5327_en")
		if Button_5327_en ~= nil then
			Button_5327_en:setVisible(true)
			if _ED == nil or _ED.m_is_games ~= true then
				Button_5327_en:setVisible(false)
			end
		end
	end

	local Button_5328 = ccui.Helper:seekWidgetByName(root, "Button_5328")
	if nil ~= Button_5328 then
		if nil == Button_5328._pos then
			Button_5328._pos = cc.p(Button_5328:getPosition())
		else
			Button_5328:setPosition(Button_5328._pos)
		end
	end
	local Button_5327_en = ccui.Helper:seekWidgetByName(root, "Button_5327_en")
	local Button_5328_en = ccui.Helper:seekWidgetByName(root, "Button_5328_en")
	if nil ~= Button_5328_en then
		if nil == Button_5328_en._pos then
			Button_5328_en._pos = cc.p(Button_5328_en:getPosition())
		else
			Button_5328_en:setPosition(Button_5328_en._pos)
		end
	end

	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
		then
		local re_login_btn = ccui.Helper:seekWidgetByName(root, "Button_back_x")
		local Button_back_x_en = ccui.Helper:seekWidgetByName(root, "Button_back_x_en")
		if fwin:find("FightUIClass") ~= nil 
			and (__lua_project_id ~= __lua_project_red_alert_time and __lua_project_id ~= __lua_project_pacific_rim) 
			then -- 如果是战斗中，必须返回登录
			re_login_btn:setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Button_5327"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Button_5328"):setVisible(false)
			fwin:addTouchEventListener(re_login_btn, nil, 
			{
				terminal_name = "reconnect_view_back_login",
				_window = self,
				isPressedActionEnabled = true
			}, 
			nil, 0)

			if Button_back_x_en ~= nil then
				Button_back_x_en:setVisible(true)
				Button_5327_en:setVisible(false)
				Button_5328_en:setVisible(false)
				fwin:addTouchEventListener(Button_back_x_en, nil, 
				{
					terminal_name = "reconnect_view_back_login",
					_window = self,
					isPressedActionEnabled = true
				}, 
				nil, 0)
			end
		else
			re_login_btn:setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Button_5327"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Button_5328"):setVisible(true)
			if Button_back_x_en ~= nil then
				Button_back_x_en:setVisible(false)
				Button_5327_en:setVisible(true)
				Button_5328_en:setVisible(true)
			end
		end

		if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
			if re_login_btn ~= nil then
				re_login_btn:setVisible(false)
			end
			if Button_back_x_en ~= nil then
				Button_back_x_en:setVisible(false)
			end
		end
	end

	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		-- if ReconnectView._logout == true then
		-- 	self:setVisible(false)
		-- 	fwin:addService({
	 --            callback = function ( params )
	 --            	ReconnectView._logout = false
		-- 			NetworkView:reconnectErase(nDatas)
  --   				fwin:close("ReconnectViewClass")
		-- 			state_machine.excute("logout_tip_window_open", 0, 0)
	 --            end,
	 --            delay = 0,
	 --            params = self
	 --        })
		-- end
		-- ReconnectView._logout = true
		if fwin:find("LoginClass") ~= nil or fwin:find("LogoClass") ~= nil then
			ccui.Helper:seekWidgetByName(root, "Button_5327"):setVisible(false)
			local Button_5328Size = Button_5328:getContentSize()
			local parentSzie = Button_5328:getParent():getContentSize()
			Button_5328:setPositionX((parentSzie.width - Button_5328Size.width) / 2 + Button_5328Size.width / 2)
			if Button_5327_en ~= nil then
				Button_5327_en:setVisible(false)
				local Button_5328_enSize = Button_5327_en:getContentSize()
				local parent_enSzie = Button_5328_en:getParent():getContentSize()
				Button_5328_en:setPositionX((parent_enSzie.width - Button_5328_enSize.width) / 2 + Button_5328_enSize.width / 2)
			end
		end
	end
	local Panel_5322 = ccui.Helper:seekWidgetByName(root, "Panel_5322")
	local Panel_5322_en = ccui.Helper:seekWidgetByName(root, "Panel_5322_en")
	if Panel_5322_en ~= nil then
		Panel_5322:setVisible(false)
		Panel_5322_en:setVisible(false)
	end
	if #_lua_release_language_param > 1 then
		if m_curr_choose_language == nil 
			or m_curr_choose_language == ""
			then
			local curr_language = cc.UserDefault:getInstance():getStringForKey("current_language","")
			if curr_language == "zh_TW" then
				Panel_5322:setVisible(true)
			else
				if Panel_5322_en ~= nil then
					Panel_5322_en:setVisible(true)
				end
			end
		else
			Panel_5322:setVisible(true)
			local Button_5327 = ccui.Helper:seekWidgetByName(root, "Button_5327")
			-- local Button_5328 = ccui.Helper:seekWidgetByName(root, "Button_5328")
			local Button_back_x = ccui.Helper:seekWidgetByName(root, "Button_back_x")
			local Label_5324_0 = ccui.Helper:seekWidgetByName(root, "Label_5324*_0")
			local Label_5324 = ccui.Helper:seekWidgetByName(root, "Label_5324")
			if Button_5327 ~= nil then
				Button_5327:setTitleText(reconnect_view_string[4])
			end
			if Button_5328 ~= nil then
				Button_5328:setTitleText(reconnect_view_string[3])
			end
			if Button_back_x ~= nil then
				Button_back_x:setTitleText(reconnect_view_string[4])
			end
			if Label_5324_0 ~= nil then
				Label_5324_0:setString(reconnect_view_string[1])
			end
			if Label_5324 ~= nil and self.info == "" then
				Label_5324:setString(reconnect_view_string[2])
			end
		end
	end
end

function ReconnectView:onExit()
	-- state_machine.remove("reconnect_view_back_login")
	-- state_machine.remove("reconnect_view_continue_chaining")
end

function ReconnectView:init( info, socketSendData)
	local root = self.roots[1]
	if nil ~= info then
		self.info = info
		ccui.Helper:seekWidgetByName(root, "Label_5324"):setString(info)
	end
	self._socketSendData = socketSendData
	return self
end

function ReconnectView:reset(request)
	self.request = request
end
