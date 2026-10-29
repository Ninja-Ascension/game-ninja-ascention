-- ----------------------------------------------------------------------------------------------------
-- 说明： 语言更新界面
-- ----------------------------------------------------------------------------------------------------
ChooseLanguageUpdate = class("ChooseLanguageUpdateClass", Window)

function ChooseLanguageUpdate:ctor()
	self.super:ctor()
    self.roots = {}
	self._multiLanguage = {}

	self.pragress = 0
	self.pragressInfo = "0"
	self.pragressSize = cc.size(0, 0)

	self.totalSize = 0

	self.package_version = ""
	self.downloadIndex = -1
	self.updateLayer = nil
	self.next_terminal_name = ""
	
	self._download_error_count = 0
	self._wait_time = 0
	self._error_shown = false
	self._update_done = false

    local function init_assets_update_terminal()
        local choose_language_update_download_pragress_terminal = {
            _name = "choose_language_update_download_pragress",
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
        state_machine.add(choose_language_update_download_pragress_terminal)
        state_machine.init()
    end
    init_assets_update_terminal()
end

function ChooseLanguageUpdate:updateDrawDownloadPragress(percentPragress, percentNumber)
--	local root = self.roots[1]
	if self.loadEffectPad then
        local offsetX = percentPragress * self.pragressSize.width / 100
		self.loadEffectPad:setPosition(cc.p(self.loadEffectPad._original_point.x + offsetX, self.loadEffectPad._original_point.y))
	end
end

--Segundos SIN un solo aviso de avance antes de dar la descarga por
--perdida. cc.UpdateLayer reintenta indefinidamente (se midio: un aviso de
--red cada ~6 s, mas de 2 min 30 s sin llegar nunca a kStateError), asi que
--el tope lo pone el cliente. Con una descarga viva este contador se pone a
--cero en cada kStateOnProgress, o sea que solo salta si de verdad no avanza.
ChooseLanguageUpdate.WAIT_LIMIT = 45

function ChooseLanguageUpdate:onUpdate(dt)
	if self._update_done == true or self._error_shown == true then
		return
	end
	self._wait_time = (self._wait_time or 0) + dt
	if self._wait_time >= ChooseLanguageUpdate.WAIT_LIMIT then
		self:showUpdateError()
	end
end

--El aviso de error que el propio cliente ya tiene preparado
--(updateErrorHint / ChooseLanguageError). Una sola vez.
function ChooseLanguageUpdate:showUpdateError()
	if self._error_shown == true then
		return
	end
	self._error_shown = true
	self._download_error_count = (self._download_error_count or 0) + 1
	app.load("client.login.ChooseLanguageError")
	fwin:open(ChooseLanguageError:new():init(self._multiLanguage), fwin._view)
end

function ChooseLanguageUpdate:onEnterTransitionFinish()
	local csbAssetsManager = csb.createNode("utils/update_bg.csb")
	self:addChild(csbAssetsManager)

	local csbChooseLanguageUpdate = csb.createNode("utils/update_loading.csb")
    self:addChild(csbChooseLanguageUpdate)

    local root = csbChooseLanguageUpdate:getChildByName("root")
	table.insert(self.roots, root)

	self.pragress = ccui.Helper:seekWidgetByName(root, "LoadingBar_1")
	self.pragress:setPercent(0)
	self.pragressInfo = ccui.Helper:seekWidgetByName(root, "Text_10")

	self.pragressSize = self.pragress:getContentSize()
	self.loadEffectPad = ccui.Helper:seekWidgetByName(root, "Panel_20")
	self.loadEffectPad._original_point = cc.p(self.loadEffectPad:getPosition())

	local package_version = cc.UserDefault:getInstance():getStringForKey("package","0")
	self.package_version = package_version
	self.downloadIndex = -1

	local multiLanguage = self._multiLanguage

	local checkVersionUrl = multiLanguage.checkVersionUrl
	local packageSize = multiLanguage.packageSize
	local curSelLanguage = multiLanguage.name
	local assetsDownloadUrl = multiLanguage.assetsDownloadUrl or ""
	if assetsDownloadUrl ~= "" then
		assetsDownloadUrl = string.gsub(assetsDownloadUrl,"%%s",curSelLanguage)
	end

	local _lastPercentPragress = 0
	local _lastPercentNumber = 0
	local downloadIndex = -1
	local downloadFileCount = 0
	local updateState = function(event, args)
		local params = tolua.cast(args, "CCArray")
		local updateType = tolua.cast(params:objectAtIndex(0), "CCString"):intValue()
		--> print("updateType:", updateType)
		if updateType == 0 then	-- kStateUpdate

		elseif updateType == 1 then	-- kStateReset

		elseif updateType == 2 then	-- kStateExit  更新完成退出提示
--			app.load("client.login.ChooseLanguageError")
--			fwin:open(ChooseLanguageError:new():init(self._multiLanguage), fwin._view)
		elseif updateType == 3 then	-- kStateInit

		elseif updateType == 4 -- kStateError
				or updateType == 5 -- kStateNoNewVersion
				or updateType == 8 --kStateOnUncompress
		then
			self:showUpdateError()
		elseif updateType == 6 then	-- kStateOnProgress
			--Hay avance: se reinicia el reloj de espera.
			self._wait_time = 0
			local percentValue = tolua.cast(params:objectAtIndex(4), "CCString"):getCString()
			--debug.print_r(percentValue,"percentValue==")
			local percentPragress = tolua.cast(params:objectAtIndex(4), "CCString"):floatValue()
			--debug.print_r(percentPragress,"percentPragress==")
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
            state_machine.excute("choose_language_update_download_pragress", 0, {percentPragress, percentNumber})
		elseif updateType == 7 then	-- kStateOnSuccess 下载成功后的处理
			self._update_done = true
			fwin:addService({
			   callback = function ( params )
				   --登入的时候
				   app.unload("data.TipStringInfo")
				   app.unload("configs.data.data_path_config")
				   cacher.destoryRefPools() --清理对象池
				   cacher.cleanSystemCacher()  --清理系统缓存
				   cacher.removeAllTextures()  --清理所有图片
				   cacher.cleanActionTimeline() --清理动画
				   localData_list_new_unload_next() --清理dms
				   cc.CSLoader:destroyInstance() --清理csb
				   fwin:reset(nil)     --重置
				   initialize_ed()     --释放数据
				   _ED.m_is_games = false
				   --debug.print_r(curSelLanguage,"写入当前的语言==")
				   local old_language = cc.UserDefault:getInstance():getStringForKey("current_language") --之前的語言
				   cc.UserDefault:getInstance():setStringForKey("assets_download_url_"..old_language, "1") --存储之前的语言包
				   cc.UserDefault:getInstance():setStringForKey("assets_download_url_"..curSelLanguage, "1")--存储现在的语言包

				   local old_package = cc.UserDefault:getInstance():getStringForKey("package", "0")  --之前的版本号
				   --debug.print_r(old_package,"之前的版本号 package==")
				   local package_target = cc.UserDefault:getInstance():getStringForKey("package_" .. curSelLanguage, "0.0") --目标语言
				   --debug.print_r(package_target,"目标语言的版本号package_target==")
				   local old_package_rc = cc.UserDefault:getInstance():getStringForKey("package_rc", "0")
				   local package_rc_target = cc.UserDefault:getInstance():getStringForKey("package_rc_" .. curSelLanguage, "0")

				   local old_package_md5 = cc.UserDefault:getInstance():getStringForKey("package_md5", "0")
				   local package_md5_target = cc.UserDefault:getInstance():getStringForKey("package_md5_" .. curSelLanguage, "0")

				   --PRIMERO se aplica la ruta del idioma; solo si se aplico se
				   --guarda nada, para no dejar current_language apuntando a un
				   --idioma que el juego no sabe cargar.
				   if app.setSearchPaths(curSelLanguage) == true then
				      cc.UserDefault:getInstance():setStringForKey("package", package_target)			--存储目标语言的版本号到package
				      cc.UserDefault:getInstance():setStringForKey("package_" .. old_language, old_package) --存储之前的语言版本号
				      cc.UserDefault:getInstance():setStringForKey("package_rc", package_rc_target)
				      cc.UserDefault:getInstance():setStringForKey("package_rc_" .. old_language, old_package_rc)

				      cc.UserDefault:getInstance():setStringForKey("package_md5", package_md5_target)
				      cc.UserDefault:getInstance():setStringForKey("package_md5_" .. old_language, old_package_md5)

				      cc.UserDefault:getInstance():setStringForKey("current_language", curSelLanguage)
				      cc.UserDefault:getInstance():flush()
				      m_curr_choose_language = curSelLanguage --设置全局当前选择的语言
				   else
				      m_curr_choose_language = old_language
				      app.setSearchPaths(old_language)
				   end

				   fwin:open(Logo:new(), fwin._screen)     --切换到logo界面
			   end,
			   delay = 0.1,
			   params = self
		   	})
		end
	end
	--debug.print_r(assetsDownloadUrl,"assetsDownloadUrl==")
	self.updateLayer = cc.UpdateLayer:new()
	self.updateLayer:registerScriptHandler(updateState)
	self:addChild(self.updateLayer)
	self.updateLayer:release()

	local current_version_code = "0"
	local downloaded_version_code = "0"
	local client_version_code_min = ""
	local client_version_code_max = ""

	self.updateLayer:parser(
		current_version_code,
		downloaded_version_code,
		client_version_code_min,
		client_version_code_max,
		checkVersionUrl,
		assetsDownloadUrl,
		packageSize
	)
	--Sin URL no hay nada que intentar: el aviso de error antes que una
	--barra parada para siempre.
	if assetsDownloadUrl == "" or checkVersionUrl == nil or checkVersionUrl == "" then
		self:showUpdateError()
	else
		self.updateLayer:onCheckVersion()
	end

    local totalSize = packageSize
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

function ChooseLanguageUpdate:init(params)
	self._multiLanguage = params
	return self
end
function ChooseLanguageUpdate:onExit()
    state_machine.remove("choose_language_update_download_pragress")
end