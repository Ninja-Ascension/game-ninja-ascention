
AssetsManager = class("AssetsManagerClass", Window)

function AssetsManager:ctor()
	self.super:ctor()
    self.roots = {}
	self.updateLayer = nil
	self.downloadIndex = -1
	
	app.load("client.login.UpdatePrompt")
	
	local function init_assets_manager_terminal()
        local assets_manager_click_request_confirm_terminal = {
            _name = "assets_manager_click_request_confirm",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local root = instance.roots[1]
				ccui.Helper:seekWidgetByName(root,"LoadingBar_1"):setPercent(0)
				ccui.Helper:seekWidgetByName(root,"Text_10"):setString("0")
				-- updateDialog:setVisible(false)
				fwin:close(fwin:find("UpdatePromptClass"))
				ccui.Helper:seekWidgetByName(root, "Panel_21"):setVisible(true)
				self.updateLayer:onCheckVersion()
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local assets_manager_click_request_cancel_terminal = {
            _name = "assets_manager_click_request_cancel",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				handlePlatformRequest(0, CC_EXIT_APPLICATION, "")
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local assets_manager_click_over_confirm_terminal = {
            _name = "assets_manager_click_over_confirm",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:loginGame()
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local assets_manager_click_over_cancel_terminal = {
            _name = "assets_manager_click_over_cancel",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:loginGame()
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local assets_manager_click_update_lose_confirm_terminal = {
            _name = "assets_manager_click_update_lose_confirm",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:showUpdateDialog()
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local assets_manager_click_update_lose_cancel_terminal = {
            _name = "assets_manager_click_update_lose_cancel",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				handlePlatformRequest(0, CC_EXIT_APPLICATION, "")
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local assets_manager_click_network_error_confirm_terminal = {
            _name = "assets_manager_click_network_error_confirm",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:requestGetServerListCallback()
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(assets_manager_click_request_confirm_terminal)
		state_machine.add(assets_manager_click_request_cancel_terminal)
		state_machine.add(assets_manager_click_over_confirm_terminal)
		state_machine.add(assets_manager_click_over_cancel_terminal)
		state_machine.add(assets_manager_click_update_lose_confirm_terminal)
		state_machine.add(assets_manager_click_update_lose_cancel_terminal)
		state_machine.add(assets_manager_click_network_error_confirm_terminal)
        state_machine.init()
    end
    init_assets_manager_terminal()
	--> print("========  init_assets_manager_terminal  ==========")
end

function AssetsManager:loginGame()
	--> print("========  loginGame  ==========")
	-- 重新载入lua文件的定时器
	local function reloadGame()
		AssetsManager:unscheduler("schedulerEntry")
		
		local function releasepackage (...) 
			AudioUtil = nil
			package.loaded["AudioUtil"] = nil
			for k, v in pairs(package.loaded) do
				local s, e = string.find(k, "script/")
				if s~= nil and s > 0 then
					s, e = string.find(k, "ThirdpartySupporter")
					if s~= nil and s > 0 then
						
					else
						package.loaded[k] = nil
					end
				end
			end
		end
		package.loaded["data.TipStringInfo"] = nil
		local uin = m_sUin
		local sessionId = m_sSessionId
		local reloadLua = table.getn(_ED.resource_package) > 0 and true or false
		if reloadLua == true then
			releasepackage()
		end
		releasepackage()
		
		-- require "script/transformers/Controller"
		-- require "script/transformers/operation/jttd"
		
		-- initThirdpartySupporter()
		-- initializeNetwork()
		
		m_sUin = uin
		m_sSessionId = sessionId
		
		
		
		app.load("client.login.login")
        fwin:open(Login:new(), fwin._view) 
		self:requestResourceUpdateAfterCallback()
	end
		
	local function loginGameTimer(dt)
		reloadGame()
	end

	self:scheduler("schedulerEntry", loginGameTimer, 1)
end

function AssetsManager:showUpdateDialog()
	--> print("========  showUpdateDialog  ==========")
	local function addLink()
		if dev_version >= 2001 then
			self.updateLayer:resetDownload()
		end

		local totalSize = 0
		local dIdx = 0
		for i, v in pairs(_ED.resource_package) do
			if dIdx >= self.downloadIndex then
				v.package_url = zstring.exchangeFrom(v.package_url)
				local tempData = ""..v.package_url
				tempData = zstring.replace(tempData, " ", "")
				tempData = zstring.split(tempData, "\r\n")
				if #tempData > 1 then
					local tempUrl = tempData[1]
					local downloadCount = 0
					for i = 2, table.getn(tempData) do
						local downloadData = zstring.split(tempData[i], ",")
						if table.getn(downloadData) == 3 then
							if zstring.tonumber(package_version) < zstring.tonumber(downloadData[2]) then
								local downloadUrl = ""..tempUrl..""..downloadData[1]
								self.updateLayer:parser(
									v.current_version_code,
									downloadData[2],
									v.client_version_code_min,
									v.client_version_code_max,
									v.package_version_url,
									downloadUrl,
									tonumber(downloadData[3])
									)
								downloadCount = downloadCount + 1
								totalSize = totalSize + tonumber(downloadData[3])
							end
						end
					end
				else
					self.updateLayer:parser(
						v.current_version_code,
						v.downloaded_version_code,
						v.client_version_code_min,
						v.client_version_code_max,
						v.package_version_url,
						v.package_url,
						tonumber(v.package_size)
					)
					totalSize = totalSize + tonumber(v.package_size)
				end
			end
			dIdx = dIdx + 1
		end
		return totalSize
	end

	local totalSize = addLink()
	
	local dataString = ""
	if (totalSize < 1024) then
		dataString = string.format("%02dB", totalSize)
	elseif (totalSize < 1024 * 1024) then
		dataString = string.format("%.2fKB", totalSize/1024.0)
	else
		dataString = string.format("%.2fMB", totalSize/1024.0/1024.0)
	end
	
	local _richText = ccui.RichText:create();
	_richText:ignoreContentAdaptWithSize(false);
	-- local cellSize = self._uiLayer:getWidgetByName("Label_Prompt_0")
	-- cellSize:removeAllChildren(true)
	-- _richText:setContentSize(cellSize:getSize());
	local fontName = ccui.Helper:seekWidgetByName(self.roots[1],"Text_10"):getFontName()
	app.load("data.TipStringInfo")
	local re1 = ccui.RichElementText:create(1, cc.c3b(_hero_color_info[9][1],_hero_color_info[9][2],_hero_color_info[9][3]), 255, _string_piece_info[101], fontName, 10)
	local re2 = ccui.RichElementText:create(2, cc.c3b(0, 255, 0), 255, dataString, fontName, 10)
	local re3 = ccui.RichElementText:create(3, cc.c3b(_hero_color_info[9][1],_hero_color_info[9][2],_hero_color_info[9][3]), 255, _string_piece_info[102], fontName, 10)
	
	_richText:pushBackElement(re1)
	_richText:pushBackElement(re2)
	_richText:pushBackElement(re3)
	-- cellSize:addWidget(_richText)
	_richText:setAnchorPoint(cc.p(0, 1))
	_richText:setPosition(cc.p(0, 0))
	
	-- updateDialog:setVisible(true);
	local updateDialog = UpdatePrompt:new()
	updateDialog:init("", "assets_manager_click_request_confirm", "assets_manager_click_request_cancel", _richText)
	fwin:open(updateDialog, fwin._view)
end

function AssetsManager:requestGetServerListCallback()
	--> print("========  requestGetServerListCallback  ==========")
	local function getServerUpdate(dt)
		AssetsManager:unscheduler("getServerUpdate")
		self:requestGetServerListCallback()
	end
	if m_sOperatorName == nil or m_sOperatorName == "" then
		AssetsManager:scheduler("getServerUpdate", getServerUpdate, 1)
		return
	end
	
	if dev_version >= 2001 then
		NetworkManager:register(protocol_command.new_get_server_list.code, app.configJson.url, nil, nil, nil, responseNewGetServerListCallback, false, nil)
	else
		NetworkManager:register(protocol_command.new_get_server_list.code, app.configJson.url, nil, nil, nil, responseGetServerListCallback, false, nil)
	end
end

function AssetsManager:requestResourceUpdateAfterCallback()
	if dev_version >= 2001 then
		package_version = cc.UserDefault:getInstance():getStringForKey("package")
		protocol_command.resource_update_after.param_list = package_version
		--> debug.log(true, "package_version ==== ======= ====== ===  ======",package_version)
		NetworkManager:register(protocol_command.resource_update_after.code, nil, nil, nil, nil, responseResourceUpdateAfterCallback, false, nil)
	end
end

function AssetsManager:onEnterTransitionFinish()
	--> print("========  onEnterTransitionFinish aaa  ==========")
	local csbAssetsManager = csb.createNode("utils/update_loading.csb")
	self:addChild(csbAssetsManager)
	
	local root = csbAssetsManager:getChildByName("root")
	table.insert(self.roots, root)
	
	local package_version = cc.UserDefault:getInstance():getStringForKey("package")
	if package_version == nil or package_version == "" then
		package_version = "0"
		cc.UserDefault:getInstance():setStringForKey("package", package_version)
	end
	
	-- local requestResourceUpdateAfterCallback = nil
	
	self.updateLayer = cc.UpdateLayer:new()
	self:addChild(self.updateLayer)
	self.updateLayer:release()
		
	-- 资源更新完毕话框
	-- local updateSuccessDialog = ccui.Helper:seekWidgetByName(root,"Panel_been_updated")
	
	-- local updateSucessConfirmButton = ccui.Helper:seekWidgetByName(root,"Button_cancel_0_0_0")
	-- updateSucessConfirmButton:addTouchEventListener(loginGameCallback)
	-- local updateSucessCloseButton = ccui.Helper:seekWidgetByName(root,"Button_1158")
	-- updateSucessCloseButton:addTouchEventListener(loginGameCallback)
	
	-- local updateDialog = ccui.Helper:seekWidgetByName(root,"Panel_update_0")
	local updatePragressLayer = ccui.Helper:seekWidgetByName(root,"Panel_21")
	updatePragressLayer:setVisible(false)
	local schedule = ccui.Helper:seekWidgetByName(root,"LoadingBar_1")
	local scheduleInfo = ccui.Helper:seekWidgetByName(root,"Text_10")
	
	local updateState = nil
	
	-- local cancelUpdateResouecesCallback
	-- local function showUpdateLoseDialog()
		-- local function showUpdateDialogAgain(sender, eventType)
			-- if eventType == ccui.TouchEventType.ended then
				-- showUpdateDialog()
			-- end
		-- end
		-- TipDlg.drawTipDialog(_string_piece_info[99],showUpdateDialogAgain,cancelUpdateResouecesCallback)
	-- end
	
	-- local function confirmUpdateResouecesCallback(sender, eventType)
		-- if eventType == ccui.TouchEventType.ended then
			-- schedule:setPercent(0)
			-- scheduleInfo:setStringValue("0")
			-- updateDialog:setVisible(false)
			-- updatePragressLayer:setVisible(true)
			-- self.updateLayer:onCheckVersion()
		-- end
	-- end
	
	-- cancelUpdateResouecesCallback = function(sender, eventType)
		-- if eventType == ccui.TouchEventType.ended then
			-- handlePlatformRequest(0, CC_EXIT_APPLICATION, "")
		-- end
	-- end
	
	local _lastPercentPragress = 0
	local _lastPercentNumber = 0
	updateState = function(args)
		-- local params = tolua.cast(args, "CCArray")
		local params = args
		-- local updateType = tolua.cast(params:objectAtIndex(0), "CCInteger"):getValue()
		local updateType = tonumber(params:objectAtIndex(0))
		if updateType == 0 then	-- kStateUpdate
			-- self.downloadIndex = self.downloadIndex + 1
			package_version = cc.UserDefault:getInstance():getStringForKey("package")
		elseif updateType == 1 then	-- kStateReset
		
		elseif updateType == 2 then	-- kStateExit
			--self.updateLayer:removeFromParentAndCleanup(true)
		
		elseif updateType == 3 then	-- kStateInit
		
		elseif updateType == 4 -- kStateError
			or updateType == 5 -- kStateNoNewVersion
			or updateType == 8 --kStateOnUncompress
			then	
			-- 弹出重新更新的对话框
			-- if self.downloadIndex > -1 then
				-- self.downloadIndex = self.downloadIndex - 1
			-- end
			
			cc.UserDefault:getInstance():setStringForKey("package", package_version)
			cc.UserDefault:getInstance():flush()
				
			if dev_version >= 2001 then
				showUpdateLoseDialog()
			else
				schedule:setPercent(0)
				scheduleInfo:setString("0")
				local function checkUpdate(dt)
					self.updateLayer:onCheckVersion()
					AssetsManager:unscheduler("checkUpdate")
				end
				AssetsManager:scheduler("checkUpdate", checkUpdate,0.3)
			end
		elseif updateType == 6 then	-- kStateOnProgress
			local percentValue = tolua.cast(params:objectAtIndex(4), "cc.String"):getCString()
			local percentPragress = tolua.cast(params:objectAtIndex(4), "cc.String"):floatValue()
			if percentPragress < 0 then
				percentPragress = 0
			end
			if percentPragress > 100 then
				percentPragress = 100
			end
			schedule:setPercent(percentPragress)
			local percentNumber = tonumber(percentValue)
			if percentNumber > 100 then
				percentNumber = 100
			end
			_lastPercentPragress = percentPragress
			_lastPercentNumber = percentNumber
			scheduleInfo:setString(math.ceil(percentNumber))
		elseif updateType == 7 then	-- kStateOnSuccess	
			updatePragressLayer:setVisible(false)
			-- updateSuccessDialog:setVisible(true)
			
			
			local updateSuccessDialog = UpdatePrompt:new()
			updateSuccessDialog:init(_string_piece_info[107], "assets_manager_click_over_confirm", "assets_manager_click_over_cancel")
            fwin:open(updateSuccessDialog, fwin._view)
		end
	end
	
	self.updateLayer:registerScriptHandler(updateState)
		
	-- --确定更新
	-- local confirmButton= ccui.Helper:seekWidgetByName(root,"Button_cancel_0_0")
	-- confirmButton:addTouchEventListener(confirmUpdateResouecesCallback)
	-- --取消更新
	-- local closeButton= ccui.Helper:seekWidgetByName(root,"Button_979")
	-- closeButton:addTouchEventListener(cancelUpdateResouecesCallback)
	
	
	-- local updatePragress = ccui.Helper:seekWidgetByName(root,"Panel_update_loading_0")
	-- END~资源更新对话框
	-- ------------------------------------------------------------------------------------------------- --
	
	-- local requestGetServerListCallback

	local function networkError()
		-- local function showUpdateDialogAgain(sender, eventType)
			-- if eventType == ccui.TouchEventType.ended then
				-- requestGetServerListCallback()
			-- end
		-- end
		if _string_piece_info == nil then
			app.load("data.TipStringInfo")
		end
		-- TipDlg.drawTipDialog(_string_piece_info[100],showUpdateDialogAgain,cancelUpdateResouecesCallback)
		local networkErrorDialog = UpdatePrompt:new()
		networkErrorDialog:init(_string_piece_info[100], "assets_manager_click_network_error_confirm", "assets_manager_click_update_lose_cancel")
		fwin:open(networkErrorDialog, fwin._view)
	end
	
	local function responseGetServerListCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if m_tOperateSystem == 1 then
				if m_sUserAccountPlatformName == "pps" then
					handlePlatformRequest(0, CC_INIT_PLATFORM_PARAM,"656".."|".."1001")
				end
			end
			if _ED.resource_package == nil or table.getn(_ED.resource_package) <= 0 then
				self:loginGame()
			else
				self:showUpdateDialog()
			end
		else
			CCNetwork:sharedNetwork():registerUrl(m_sURL_IP)
			networkError()
		end		
	end
	
	local function responseNewGetServerListCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if m_tOperateSystem == 1 then
				if m_sUserAccountPlatformName == "pps" then
					handlePlatformRequest(0, CC_INIT_PLATFORM_PARAM,"656".."|".."1001")
				end
			end
			if _ED.resource_package == nil or table.getn(_ED.resource_package) <= 0 then
				self:loginGame()
			else
				self:showUpdateDialog()
			end
		else
			networkError()
		end		
	end
	
	-- requestGetServerListCallback = function ()
		-- local function getServerUpdate(dt)
			-- AssetsManager:unscheduler("getServerUpdate")
			-- requestGetServerListCallback()
		-- end
		-- if m_sOperatorName == nil or m_sOperatorName == "" then
			-- AssetsManager:scheduler("getServerUpdate", getServerUpdate, 1)
			-- return
		-- end
		
		-- if dev_version >= 2001 then
			-- NetworkManager:register(protocol_command.new_get_server_list.code, nil, nil, nil, nil, responseNewGetServerListCallback, true, nil)
		-- else
			-- NetworkManager:register(protocol_command.get_server_list.code, nil, nil, nil, nil, responseGetServerListCallback, true, nil)
		-- end
	-- end
	self:requestGetServerListCallback()
	
	local _checkResourceUpdateAfterCount = 0
	local function responseResourceUpdateAfterCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			
		else
			CCNetwork:sharedNetwork():registerUrl(m_sURL_IP)
			_checkResourceUpdateAfterCount = _checkResourceUpdateAfterCount + 1
			if _checkResourceUpdateAfterCount < 10 then
				local function resourceUpdateAfterUpdate(dt)
					AssetsManager:unscheduler("resourceUpdateAfterUpdate")
					self:requestResourceUpdateAfterCallback()
				end
				AssetsManager:scheduler("resourceUpdateAfterUpdate", resourceUpdateAfterUpdate, 10)
			end
		end		
	end
	
	-- requestResourceUpdateAfterCallback = function()
		-- if dev_version >= 2001 then
			-- package_version = cc.UserDefault:getInstance():getStringForKey("package")
			-- protocol_command.resource_update_after.param_list = package_version
			--> debug.log(true, "package_version ==== ======= ====== ===  ======",package_version)
			-- NetworkManager:register(protocol_command.resource_update_after.code, nil, nil, nil, nil, responseResourceUpdateAfterCallback, true, nil)
		-- end
	-- end

	platformLogin()
	--> print("========  onEnterTransitionFinish bbb  ==========")
end

function AssetsManager:onExit()
	state_machine.remove("assets_manager_click_request_confirm")
	state_machine.remove("assets_manager_click_request_cancel")
	state_machine.remove("assets_manager_click_over_confirm")
	state_machine.remove("assets_manager_click_over_cancel")
	state_machine.remove("assets_manager_click_update_lose_confirm")
	state_machine.remove("assets_manager_click_update_lose_cancel")
	state_machine.remove("assets_manager_click_network_error_confirm")
end