
AssetsUpdate = class("AssetsUpdateClass", Window)

function AssetsUpdate:ctor()
	self.super:ctor()
    self.roots = {}
	
	self.pragress = 0
	self.pragressInfo = "0"
	self.pragressSize = cc.size(0, 0)

	self.totalSize = 0

	self.package_version = ""
	self.downloadIndex = -1
	self.updateLayer = nil
	self.next_terminal_name = ""
	
	self._download_error_count = 0

	local function init_assets_update_terminal()
        local assets_update_manager_terminal = {
            _name = "assets_update_manager",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- fwin:close(instance)
				-- state_machine.excute(params, 0, "")
				self.next_terminal_name = params
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local assets_update_update_draw_download_pragress_terminal = {
            _name = "assets_update_update_draw_download_pragress",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:updateDrawDownloadPragress(params[1], params[2])
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local assets_update_succeed_terminal = {
            _name = "assets_update_succeed",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if true == _ED.assets_update then
	            	cc.FileUtils:getInstance():swapDownloadFilename("version")
	            	cc.FileUtils:getInstance():dumpLocalFilenameMSDictionaryFromFile(app.dir_cache_md5 .. app.assets_local_md5)
	            	_ED.assets_update = false
	            end
                app.reload(false)

                app.load("data.TipStringInfo")
				app.load("client.utils.TipDraw")
				app.load("client.protocol.ProtocolParser")
                app.load("client.protocol.ProtocolCommander")
				app.load("client.loader.EnvironmentDatas")
				
                NetworkProtocol.protocol_commands = protocol_command
                NetworkProtocol.protocol_parses = protocol_parse
				
				NetworkManager:registerUrl(app.configJson.url, app.configJson.wsurl)
				app.load("client.network.ConnectingView")
				app.load("client.network.ReconnectView")
				app.load("client.network.NetworkErrorDialog")
				app.load("client.network.ProtocolErrorDialog")
                NetworkView:register(ConnectingView:new(), nil, NetworkErrorDialog:new(), ProtocolErrorDialog:new())
                NetworkManager:registerKeepAlive(protocol_command.keep_alive.code, 180*2)

                -- app.load("client.loader.LocalDatas")
                -- if localData ~= nil then
                    -- localData()
                    -- localData = nil
                -- end

                -- 重置加载数据
                dms.unload("data/mould/sound_effect_param.txt")
                dms.load("data/mould/sound_effect_param.txt")

				state_machine.excute("assets_manager_manager", 0, "assets_manager_manager_assets_update_succeed")
				local package_version = cc.UserDefault:getInstance():getStringForKey("package")
				protocol_command.resource_update_after.param_list = package_version
				NetworkManager:register(protocol_command.resource_update_after.code, nil, nil, nil, nil, nil, false, nil)
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local assets_update_error_terminal = {
            _name = "assets_update_error",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	state_machine.excute("assets_manager_manager", 0, "assets_manager_manager_assets_update_error")
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(assets_update_manager_terminal)
		state_machine.add(assets_update_update_draw_download_pragress_terminal)
		state_machine.add(assets_update_succeed_terminal)
		state_machine.add(assets_update_error_terminal)
        state_machine.init()
    end
    init_assets_update_terminal()
end

function AssetsUpdate:updateDrawDownloadPragress(percentPragress, percentNumber)
	local root = self.roots[1]
	local offsetX = percentPragress * self.pragressSize.width / 100
	self.loadEffectPad:setPosition(cc.p(self.loadEffectPad._original_point.x + offsetX, self.loadEffectPad._original_point.y))
end

function AssetsUpdate:addLink()
	self.updateLayer:resetDownload()

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
						if zstring.tonumber(self.package_version) < zstring.tonumber(downloadData[2]) then
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
	self.totalSize = totalSize
end

function AssetsUpdate:onUpdate(dt)
	if self.next_terminal_name ~= nil and self.next_terminal_name ~= "" then
		state_machine.excute(self.next_terminal_name, 0, "")
		self.next_terminal_name = ""
		fwin:close(self)
	end
end

function AssetsUpdate:onEnterTransitionFinish()
	local csbAssetsUpdate = csb.createNode("utils/update_loading.csb")
    self:addChild(csbAssetsUpdate)

    local root = csbAssetsUpdate:getChildByName("root")
	table.insert(self.roots, root)

	self.pragress = ccui.Helper:seekWidgetByName(root, "LoadingBar_1")
	self.pragress:setPercent(0)
	self.pragressInfo = ccui.Helper:seekWidgetByName(root, "Text_10")

	self.pragressSize = self.pragress:getContentSize()
	self.loadEffectPad = ccui.Helper:seekWidgetByName(root, "Panel_20")
	self.loadEffectPad._original_point = cc.p(self.loadEffectPad:getPosition())

	local package_version = cc.UserDefault:getInstance():getStringForKey("package")
	if package_version == nil or package_version == "" then
		package_version = "0"
	end
	self.package_version = package_version
	self.downloadIndex = -1


	local _lastPercentPragress = 0
	local _lastPercentNumber = 0
	local downloadIndex = -1
	local downloadFileCount = 0;
	updateState = function(event, args)
		local params = tolua.cast(args, "CCArray")
		local updateType = tolua.cast(params:objectAtIndex(0), "CCString"):intValue()
		--> print("updateType:", updateType)
		if updateType == 0 then	-- kStateUpdate
			-- downloadIndex = downloadIndex + 1
			package_version = cc.UserDefault:getInstance():getStringForKey("package")
			self.pragress_Percent = self.pragress:getPercent()
			self.pragress_String = self.pragressInfo:getString()
		elseif updateType == 1 then	-- kStateReset
		
		elseif updateType == 2 then	-- kStateExit
			--updateLayer:removeFromParentAndCleanup(true)
			state_machine.excute("assets_update_manager", 0, "assets_update_succeed")
		elseif updateType == 3 then	-- kStateInit
		
		elseif updateType == 4 -- kStateError
			or updateType == 5 -- kStateNoNewVersion
			or updateType == 8 --kStateOnUncompress
			then	
			-- 弹出重新更新的对话框
			-- if downloadIndex > -1 then
			-- 	downloadIndex = downloadIndex - 1
			-- end
			
			cc.UserDefault:getInstance():setStringForKey("package", package_version)
			cc.UserDefault:getInstance():flush()
				
			-- if dev_version >= 2001 then
			-- 	showUpdateLoseDialog()
			-- else
			
			-- if __lua_project_id == __lua_project_warship_girl_a 
				-- or __lua_project_id == __lua_project_warship_girl_b 
				-- or __lua_project_id == __lua_project_digimon_adventure 
				-- or __lua_project_id == __lua_project_naruto 
				-- or __lua_project_id == __lua_project_pokemon 
				-- or __lua_project_id == __lua_project_yugioh 
				-- then
				-- local tmpscheduler = cc.Director:getInstance():getScheduler()
				-- local tmpschedulerEntry = nil
				-- local function checkUpdate(dt)
					-- self.updateLayer:onCheckVersion()
					-- tmpscheduler:unscheduleScriptEntry(tmpschedulerEntry)
					-- tmpschedulerEntry = nil
				-- end
				-- tmpschedulerEntry = tmpscheduler:scheduleScriptFunc(checkUpdate, 0.3, false)
			-- else
				-- state_machine.excute("assets_update_manager", 0, "assets_update_error")
			-- end
			
			self._download_error_count = self._download_error_count + 1
			if self._download_error_count > 200 then
				state_machine.excute("assets_update_manager", 0, "assets_update_error")
			else
				local tmpscheduler = cc.Director:getInstance():getScheduler()
				local tmpschedulerEntry = nil
				local function checkUpdate(dt)
					self.updateLayer:onCheckVersion()
					tmpscheduler:unscheduleScriptEntry(tmpschedulerEntry)
					tmpschedulerEntry = nil
				end
				tmpschedulerEntry = tmpscheduler:scheduleScriptFunc(checkUpdate, 0.3, false)
			end
		elseif updateType == 6 then	-- kStateOnProgress
			local percentValue = tolua.cast(params:objectAtIndex(4), "CCString"):getCString()
			local percentPragress = tolua.cast(params:objectAtIndex(4), "CCString"):floatValue()
			if percentPragress < 0 then
				percentPragress = 0
			end
			if percentPragress > 100 then
				percentPragress = 100
			end
			self.pragress:setPercent(percentPragress)
			local percentNumber = tonumber(percentValue)
			if percentNumber > 100 then
				percentNumber = 100
			end
			_lastPercentPragress = percentPragress
			_lastPercentNumber = percentNumber
			self.pragressInfo:setString(""..math.ceil(percentNumber) .. "%")
			state_machine.excute("assets_update_update_draw_download_pragress", 0, {percentPragress, percentNumber})
		elseif updateType == 7 then	-- kStateOnSuccess	
			if true == _ED.assets_update then
				-- updatePragressLayer:setVisible(false)
				-- updateSuccessDialog:setVisible(true)
				downloadFileCount = downloadFileCount + 1
				-- print("-------->>>>", self.updateLayer:getDownloadFileName(), self.updateLayer:getDownloadFileName(true))
				-- cc.FileUtils:getInstance():swapDownloadFilename(self.updateLayer:getDownloadFileName(true))
				local lCount = tolua.cast(params:objectAtIndex(1), "CCString"):intValue()
				-- print("---->>>>", lCount, downloadFileCount)
				local extensionName = getExtension(self.updateLayer:getDownloadFileName())
				if downloadFileCount >= 10 or extensionName == "zip" then
					downloadFileCount = 0
					-- local t = os.clock()
					cc.FileUtils:getInstance():dumpLocalFilenameMSDictionaryFromFile(app.dir_cache_md5 .. app.assets_local_md5)
					-- print(os.clock() - t)
				end
			end
		end
	end
	
	self.updateLayer = cc.UpdateLayer:new()
	self.updateLayer:registerScriptHandler(updateState)
	self:addChild(self.updateLayer)
	self.updateLayer:release()

	self:addLink()
	self.updateLayer:onCheckVersion()

    local totalSize = self.totalSize
    local dataString = ""
    if (totalSize < 1024) then
        dataString = string.format("%02dB", totalSize)
    elseif (totalSize < 1024 * 1024) then
        dataString = string.format("%.2fKB", totalSize/1024.0)
    else
        dataString = string.format("%.2fMB", totalSize/1024.0/1024.0)
    end
    local Text_2 = ccui.Helper:seekWidgetByName(root, "Text_2")
	-- Textos en el idioma ELEGIDO en el juego (current_language); el del movil
	-- solo si aun no hay uno o no tiene ficha en config_res.multiLanguage.
	local sysLanguage = cc.UserDefault:getInstance():getStringForKey("current_language", "")
	if config_res == nil or config_res.multiLanguage == nil or config_res.multiLanguage[sysLanguage] == nil then
		sysLanguage = m_system_default_language
	end
	if config_res.multiLanguage then
		local sysLanguageConfig = config_res.multiLanguage[sysLanguage]
		if sysLanguageConfig then
			update_download_info = sysLanguageConfig.updateText
		end
	end
    if update_download_info == nil then
    	update_download_info = "%s"
    end
    Text_2:setString(string.format(update_download_info, dataString))
end

function AssetsUpdate:onExit()
	state_machine.remove("assets_update_manager")
	state_machine.remove("assets_update_update_draw_download_pragress")
	state_machine.remove("assets_update_succeed")
	state_machine.remove("assets_update_error")
end