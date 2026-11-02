
AssetsManager = class("AssetsManagerClass", Window)

function AssetsManager:ctor()
	self.super:ctor()
    self.roots = {}

    self._enum_state = {
    	_assets_verify	= 1	-- 校验资源更新
	}

    self._assetsManager = nil
    self._openDownload = false

	local function init_assets_manager_terminal()
        local assets_manager_manager_terminal = {
            _name = "assets_manager_manager",
            _init = function (terminal)
            	app.load("client.assets.AssetsVerify")
            	app.load("client.assets.AssetsNotice")
            	app.load("client.assets.AssetsUpdate")
            	app.load("client.assets.AssetsUpdateError")
            	app.load("client.assets.AssetsUpdateSucceed")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute(params, 0, "")
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local assets_manager_manager_assets_verify_terminal = {
            _name = "assets_manager_manager_assets_verify",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(AssetsVerify:new(), fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local assets_manager_manager_assets_notice_terminal = {
            _name = "assets_manager_manager_assets_notice",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_red_alert_time 
                    or __lua_project_id == __lua_project_pacific_rim 
                    or __lua_project_id == __lua_project_l_naruto
                    or __lua_project_id == __lua_project_l_dragonball
                    then
                    state_machine.excute("assets_manager_manager", 0, "assets_manager_manager_assets_update")
                else
                    fwin:open(AssetsNotice:new(), fwin._view)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local assets_manager_manager_assets_update_terminal = {
            _name = "assets_manager_manager_assets_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:close(fwin:find("AssetsUpdateClass"))
                fwin:open(AssetsUpdate:new(), fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local assets_manager_manager_assets_update_succeed_terminal = {
            _name = "assets_manager_manager_assets_update_succeed",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if __lua_project_id == __lua_project_warship_girl_a 
                    or __lua_project_id == __lua_project_warship_girl_b 
                    or __lua_project_id == __lua_project_digimon_adventure 
                    or __lua_project_id == __lua_project_naruto 
                    or __lua_project_id == __lua_project_pokemon 
                    or __lua_project_id == __lua_project_rouge 
                    or __lua_project_id == __lua_project_yugioh 
                    or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
                    then -- 直接打开主界面
					state_machine.excute("assets_manager_manager_assets_into_login_page", 0, "")
				else
					fwin:open(AssetsUpdateSucceed:new(), fwin._view)
				end				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local assets_manager_manager_assets_update_error_terminal = {
            _name = "assets_manager_manager_assets_update_error",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(AssetsUpdateError:new(), fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local assets_manager_manager_assets_into_login_page_terminal = {
            _name = "assets_manager_manager_assets_into_login_page",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                app.load("client.operation.Config")          
                -- fwin:removeAll()
                fwin:clean(fwin._view)
		app.load("client.utils.shortcut")
                app.load("configs.data.data_path_config")
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                    dms.load("data/mould/word_mould.txt")
                    dms.format("word_mould", 2)
                end
				app.load("client.loader.LocalDatas")
				localData_attack_logic()
                app.load("client.battle.BattleScene")
                app.load("client.mission.Mission")
                app.load("client.mission.tuition.TuitionController")
                app.load("client.login.login")

                app.load("client.network.ReconnectView")
                NetworkView:register(nil, ReconnectView:new(), nil, nil)

                fwin:open(Login:new(), fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(assets_manager_manager_terminal)
        state_machine.add(assets_manager_manager_assets_verify_terminal)
        state_machine.add(assets_manager_manager_assets_notice_terminal)
        state_machine.add(assets_manager_manager_assets_update_terminal)
        state_machine.add(assets_manager_manager_assets_update_succeed_terminal)
        state_machine.add(assets_manager_manager_assets_update_error_terminal)
        state_machine.add(assets_manager_manager_assets_into_login_page_terminal)
        state_machine.init()
    end
    init_assets_manager_terminal()
end

function AssetsManager:checkVersionDownload()
    if nil == app.lmd5 or nil == app.vmd5 then
        self:initMd5Info()
    end
    if app.lmd5.version ~= app.vmd5.version then
        print("format download files.")
        _ED.resource_package = {}
        for i, v in pairs(app.vmd5) do
            local l = app.lmd5[i]
            -- print(i, l.md5, v.md5)
            if nil ~= v.root and (nil == l or l.md5 ~= v.md5) then
                local resource = {
                    current_version_code = "0",
                    downloaded_version_code = app.vmd5.version,
                    client_version_code_min = app.version,
                    client_version_code_max = app.version,
                    package_version_url =  app.assets_version_url,
                    package_url = app.assets_update_url .. v.root .. "/" .. i,
                    package_size = v.size
                }
                -- debug.print_r(resource)
                table.insert(_ED.resource_package, resource)
            end
        end
        _ED.assets_update = true
        if #_ED.resource_package > 0 then
            state_machine.excute("assets_manager_manager", 0, "assets_manager_manager_assets_notice")
        else
            state_machine.excute("assets_manager_manager", 0, "assets_manager_manager_assets_verify")
        end
    else
        state_machine.excute("assets_manager_manager", 0, "assets_manager_manager_assets_verify")
    end
end

function AssetsManager:checkDownloadVersion( ... )
    if nil == app.vmd5 or zstring.tonumber(app.vmd5.version) < zstring.tonumber(_ED.version_resource_info.resource_version_code) then
        app.lmd5 = nil
        app.vmd5 = nil
        cc.UserDefault:getInstance():setStringForKey("current-version-code", "0")
        cc.UserDefault:getInstance():setStringForKey("downloaded-version-code", "0")
        self._assetsManager:deleteVersion()
        
        print("download version_md5.plist.")
        self._assetsManager:checkUpdate()
        self._openDownload = true
    else
        print("check version download.")
        self:checkVersionDownload()
    end
end

function AssetsManager:getDownloadVersion( ... )
    print("start get download version.")
    local package_md5 = "0.0"
    if nil ~= getPackageMd5Param then
        package_md5 = getPackageMd5Param()
    end

    local xhr = cc.XMLHttpRequest:new()
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
    xhr:open("GET", app.assets_version_url .. "&" 
        .. "current_resource_version=" .. package_md5 .. "&" 
        .. "client_version=" .. app.version .. "&" 
        .. "operator_name=" .. app.configJson.OperatorName .. "&"
        .. "operate_platform_name=" .. app.configJson.OperationPlatformName .. "&"
        .. "account_platform_name=" .. app.configJson.UserAccountPlatformName
        )

    local function onReadyStateChanged()
        local result = false
        if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
            local arr = zstring.split(xhr.response, "\r\n")
            _ED.version_resource_info = _ED.version_resource_info or {}
            _ED.version_resource_info.resource_id = arr[1]
            _ED.version_resource_info.resource_version_code = arr[2]
            _ED.version_resource_info.get_resource_version_url = arr[3]
            _ED.version_resource_info.resource_donwload_url = arr[4]
            -- -- debug.print_r(_ED.version_resource_info)
            -- -- print(xhr.response, tonumber(self._assetsManager:getVersion()), tonumber(xhr.response), app.lmd5.version, app.vmd5.version)
            -- -- if tonumber(self._assetsManager:getVersion()) ~= tonumber(xhr.response) then
            -- --     cc.UserDefault:getInstance():setStringForKey("current-version-code", "0")
            -- --     cc.UserDefault:getInstance():setStringForKey("downloaded-version-code", "0")
            -- --     self._assetsManager:deleteVersion()
            -- --     self._assetsManager:checkUpdate()
            -- --     self._openDownload = true
            -- --     print("download version_md5.plist.")
            -- -- else
            -- --     print("check version download.")
            -- --     self:checkVersionDownload()
            -- -- end
            -- self:checkDownloadVersion()
            self:initDownloadInfo()
            result = true
        else
            print("xhr.readyState is:", xhr.readyState, "xhr.status is: ", xhr.status)
        end
        xhr:unregisterScriptHandler()
        if result == false then
            self:getDownloadVersion()
        end
    end

    xhr:registerScriptHandler(onReadyStateChanged)
    xhr:send()
end

function AssetsManager:onUpdate(dt)
    if self._openDownload == true then
        local isDownloading = self._assetsManager:isDownloading()
        if false == isDownloading then
            self._openDownload = false
            local currentVersionCode = self._assetsManager:getVersion()
            print(isDownloading, currentVersionCode)
            if zstring.tonumber(currentVersionCode) > 0.01 then
                print("verify resources.")
                self:checkVersionDownload()
            else
                print("restart download.")
                self:checkDownloadVersion()
            end
        end
    end
end

function AssetsManager:initMd5Info( ... )
    print("init md5 info.")
    local lmd5 = cc.FileUtils:getInstance():loadLocalFilenameMSDictionaryFromFile(app.dir_cache_md5 .. app.assets_local_md5)
    if nil == lmd5 or nil == lmd5.version then
        lmd5 = cc.FileUtils:getInstance():getValueMapFromFile("configs/assets.plist")
        if nil == lmd5 or nil == lmd5.version then
            return
        end
        cc.FileUtils:getInstance():setLocalFilenameMSDictionary(lmd5)
        cc.FileUtils:getInstance():dumpLocalFilenameMSDictionaryFromFile(app.dir_cache_md5 .. app.assets_local_md5)
    end
    local vmd5 = cc.FileUtils:getInstance():loadVersionFilenameMSDictionaryFromFile(app.dir_cache_md5 .. app.assets_version_md5)

    app.lmd5 = lmd5
    app.vmd5 = vmd5
end

function AssetsManager:initDownloadInfo()
    print("init download info.")
    local needDownloadVMD5 = true
    if nil ~= _ED.version_resource_info
        then
        needDownloadVMD5 = false
        if nil ~= _ED.version_resource_info.get_resource_version_url then
            app.assets_version_url = _ED.version_resource_info.get_resource_version_url
        end
        if nil ~= _ED.version_resource_info.resource_donwload_url then
            app.assets_update_url = _ED.version_resource_info.resource_donwload_url .. "cdn/version/"
            app.assets_version_md5_url = _ED.version_resource_info.resource_donwload_url .. "cdn/zip/" .. app.assets_version_md5 .. ".zip"
        end

        if nil == app.vmd5 or zstring.tonumber(app.vmd5.version) < zstring.tonumber(_ED.version_resource_info.resource_version_code) then
            needDownloadVMD5 = true
        end
    end

    print(needDownloadVMD5, app.assets_version_md5_url, "\r\n", app.assets_version_url)
    if true == needDownloadVMD5 then
        if nil == self._assetsManager then
            self._assetsManager = cc.AssetsManager:new("" .. app.assets_version_md5_url, app.assets_version_url)
            self._assetsManager:setStoragePath(app.dir_cache_md5)
            self._assetsManager:deleteVersion()
            self:addChild(self._assetsManager)
        end

        if nil == _ED.version_resource_info or zstring.tonumber(_ED.version_resource_info.resource_version_code) <= 0 then
            print("init get download version.")
            self:getDownloadVersion()
        else
            print("init check 0 download version.")
            self:checkDownloadVersion()
        end
    else
        -- state_machine.excute("assets_manager_manager", 0, "assets_manager_manager_assets_verify")
        print("init check 1 download version.")
        self:checkVersionDownload()
    end
end

function AssetsManager:onEnterTransitionFinish()
	local csbAssetsManager = csb.createNode("utils/update_bg.csb")
    self:addChild(csbAssetsManager)

    if nil == app.assets_version_url or #app.assets_version_url <= 0 then
        state_machine.excute("assets_manager_manager", 0, "assets_manager_manager_assets_verify")
    else
        self:initMd5Info()

        _ED.version_resource_info = nil
        if nil ~= _ED.version_resource_info
            then
            self:initDownloadInfo()
        else
            self:getDownloadVersion()
        end
    end
end

function AssetsManager:onExit()
	state_machine.remove("assets_manager_manager")
    state_machine.remove("assets_manager_manager_assets_verify")
    state_machine.remove("assets_manager_manager_assets_notice")
    state_machine.remove("assets_manager_manager_assets_update")
    state_machine.remove("assets_manager_manager_assets_update_succeed")
    state_machine.remove("assets_manager_manager_assets_update_error")
    state_machine.remove("assets_manager_manager_assets_into_login_page")
end