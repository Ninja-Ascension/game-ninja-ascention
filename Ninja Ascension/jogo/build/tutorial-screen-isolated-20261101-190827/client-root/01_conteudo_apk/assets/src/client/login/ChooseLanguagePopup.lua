-- ----------------------------------------------------------------------------------------------------
-- 说明： 选择语言弹窗
-- ----------------------------------------------------------------------------------------------------
ChooseLanguagePopup = class("ChooseLanguagePopupClass", Window)

-- Primera sesion tras descargar una version (instalacion nueva, o al volver
-- de muchas versiones atras): client.operation.Config se cargo ANTES de la
-- descarga, desde el APK, y app.reload(false) no recarga nada que lleve
-- "operation". La copia del APK no trae languageIsReady y
-- elegir un idioma daba LUA ERROR «attempt to call global 'languageIsReady'»
-- y no pasaba nada hasta cerrar el juego. Se vuelve a cargar la de disco.
function chooseLanguageEnsureConfig()
    if languageIsReady == nil then
        app.preload["client.operation.Config"] = nil
        package.loaded["client.operation.Config"] = nil
        app.load("client.operation.Config")
    end
end
local choose_language_popup_open_terminal = {
    _name = "choose_language_popup_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("ChooseLanguagePopupClass") == nil then
            fwin:open(ChooseLanguagePopup:new():init(), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local choose_language_popup_close_terminal = {
    _name = "choose_language_popup_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
--        if params._datas.is_popup then
--            fwin:open(Logo:new(), fwin._screen)     --切换到logo界面
--        end
        fwin:close(fwin:find("ChooseLanguagePopupClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(choose_language_popup_open_terminal)
state_machine.add(choose_language_popup_close_terminal)
state_machine.init()

function ChooseLanguagePopup:ctor()
    self.super:ctor()
    self.roots = {}
    self.button_list_down = nil
    self.button_list_up = nil
    self.server_list = nil
    self.server_list_ContainerPosY = nil
--    self.is_popup = false
    local function init_choose_language_popup_terminal()
       --确认选择下载语言包
        local choose_language_popup_ok_terminal = {
            _name = "choose_language_popup_ok",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
--                local languageConfig = config_res.chooseLanguage[m_curr_choose_language]
--                local indexStr = params._datas.index..""
--                local curSelLanguage = languageConfig[indexStr].name
                local curSelLanguage =  params._datas._sel.name
                local is_popup = instance.is_popup
              --  debug.print_r(curSelLanguage,"curSelLanguage==")
             --   debug.print_r("assets_download_url_"..curSelLanguage,"assets_download_url_==")
                m_curr_choose_language = ""
                -- LO QUE YA ESTA EN DISCO NO SE DESCARGA. languageIsReady
                -- (Config.lua) mira tambien si res/language/<idioma> esta
                -- puesto: los once paquetes viajan dentro del juego, y sin
                -- esa comprobacion el cliente se iba al descargador nativo
                -- contra un CDN muerto y se colgaba para siempre.
                chooseLanguageEnsureConfig()
                if languageIsReady(curSelLanguage) then  --校验是否需要下载基础语言版本包
                    --登入的时候
                    app.unload("data.TipStringInfo")
                    app.unload("configs.data.data_path_config")
                    cacher.destoryRefPools() --清理对象池
                    cacher.cleanSystemCacher()  --清理系统缓存
                    cacher.removeAllTextures()  --清理所有图片
                    cacher.cleanActionTimeline() --清理动画
                    if localData_list_new_unload_next() then
                        localData_list_new_unload_next() --清理dms
                    end
                    cc.CSLoader:destroyInstance() --清理csb
                    fwin:reset(nil)     --重置
                    initialize_ed()     --释放数据
                    _ED.m_is_games = false
                    local old_language = cc.UserDefault:getInstance():getStringForKey("current_language") --之前的語言
                    local old_package = cc.UserDefault:getInstance():getStringForKey("package", "0")  --之前的版本号
                   -- debug.print_r(old_package,"之前的版本号 package==")
                    local package_target = cc.UserDefault:getInstance():getStringForKey("package_" .. curSelLanguage, "0.0") --目标语言
                  --  debug.print_r(package_target,"目标语言的版本号package_target==")

                    local old_package_rc = cc.UserDefault:getInstance():getStringForKey("package_rc", "0")
                    local package_rc_target = cc.UserDefault:getInstance():getStringForKey("package_rc_" .. curSelLanguage, "0")

                    local old_package_md5 = cc.UserDefault:getInstance():getStringForKey("package_md5", "0")
                    local package_md5_target = cc.UserDefault:getInstance():getStringForKey("package_md5_" .. curSelLanguage, "0")

                    -- PRIMERO se aplica la ruta del idioma y SOLO SI se
                    -- aplico se guarda nada. Dejar current_language puesto
                    -- a un idioma que el juego no sabe cargar es lo que
                    -- deja la cuenta a medias.
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
                        -- No se toca ni una clave: se vuelve al idioma de antes.
                        m_curr_choose_language = old_language
                        app.setSearchPaths(old_language)
                    end
                    fwin:open(Logo:new(), fwin._screen)     --切换到logo界面
                else
                    --下载基础语言版本包
                    if config_res.multiLanguage then
                        local multiLanguage= config_res.multiLanguage[curSelLanguage]
                        -- Sin ficha de idioma no hay tamano ni URL: la
                        -- ventana de descarga reventaria al pintarse.
                        if multiLanguage ~= nil then
                            instance:noticePopup(multiLanguage)
                        end
                    end
                end

                fwin:close(fwin:find("ChooseLanguagePopupClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(choose_language_popup_ok_terminal)
        state_machine.init()
    end
    init_choose_language_popup_terminal()
end

--清理所有表
--function ChooseLanguagePopup:unloadAlldms( )
--    for i, v in pairs(dms) do
--        if nil ~= dms[i] then
--            for m, n in pairs(dms[i]) do
--                n[m] = nil
--            end
--            dms[i] = nil
--        end
--    end
--end
--确认更新语言弹窗
function ChooseLanguagePopup:noticePopup(multiLanguage)
    app.load("client.login.ChooseLanguageNotice")
    if fwin:find("ChooseLanguageNoticeClass") == nil then
        fwin:open(ChooseLanguageNotice:new():init(multiLanguage), fwin._ui)
    end
end

function ChooseLanguagePopup:init()
--    self.choose_language = showtype
	return self
end
function ChooseLanguagePopup:onUpdate(dt)
    if (__lua_project_id == __lua_project_gragon_tiger_gate
            or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball
            or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
            or __lua_project_id == __lua_project_red_alert
            or __lua_project_id == __lua_project_warship_girl_a
            or __lua_project_id == __lua_project_warship_girl_b
            or __lua_project_id == __lua_project_digimon_adventure
            or __lua_project_id == __lua_project_naruto
            or __lua_project_id == __lua_project_pokemon
            or __lua_project_id == __lua_project_rouge
            or __lua_project_id == __lua_project_yugioh
            or __lua_project_id == __lua_project_adventure)
    then
        self:refreshListView()
    end
end
function ChooseLanguagePopup:refreshListView( )
    if self.server_list ~= nil then
        local size = self.server_list:getContentSize()
        local posY = self.server_list:getInnerContainer():getPositionY()
        if self.server_list_ContainerPosY == posY then
            return
        end
        self.server_list_ContainerPosY = posY
        local items = self.server_list:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function ChooseLanguagePopup:onEnterTransitionFinish()
    local csbMoreSystem = csb.createNode("login/change_language.csb")
    local root = csbMoreSystem:getChildByName("root")
    if root == nil then
        return
    end
    table.insert(self.roots, root)
    self:addChild(csbMoreSystem)
    local closeButton = ccui.Helper:seekWidgetByName(root, "Button_closed")
    -- 返回
    fwin:addTouchEventListener(closeButton, nil,
    {
        terminal_name = "choose_language_popup_close",
        terminal_state = 0,
        isPressedActionEnabled = true
    },
    nil, 0)

    local curLanguage = cc.UserDefault:getInstance():getStringForKey("current_language")
    --debug.print_r(curLanguage,"curLanguage======")
    -- Textos en el idioma ELEGIDO en el juego (current_language); el del movil
    -- solo si aun no hay uno o no tiene ficha en config_res.multiLanguage.
    local sysLanguage = cc.UserDefault:getInstance():getStringForKey("current_language", "")
    if config_res == nil or config_res.multiLanguage == nil or config_res.multiLanguage[sysLanguage] == nil then
        sysLanguage = m_system_default_language
    end
    --debug.print_r(sysLanguage,"sysLanguage==========")
    if config_res.multiLanguage then
        local languageConfig = config_res.multiLanguage[curLanguage]
        if languageConfig then
            local  languageTextStr = languageConfig.languageText --简体中文
            local txtDef = ccui.Helper:seekWidgetByName(root, "Text_language_default")
            txtDef:setString(languageTextStr)
        end

        local sysLanguageConfig = config_res.multiLanguage[sysLanguage]
        if sysLanguageConfig then
            local curLanguageText = ccui.Helper:seekWidgetByName(root, "Text_13")
            curLanguageText:setString(sysLanguageConfig.currentLanguage)
            local downLanguageText = ccui.Helper:seekWidgetByName(root, "Text_13_0")
            downLanguageText:setString(sysLanguageConfig.downLanguageWord)
        end
    end
    self.server_list = ccui.Helper:seekWidgetByName(root,"ListView_language") --语言选择列表
    self.server_list:requestRefreshView()

    app.load("client.cells.login.choose_language_cell")

    -- local sysLanguageConfig = {}
    -- for k, v in pairs(config_res.chooseLanguage) do
    --     if v.name == sysLanguage then
    --         sysLanguageConfig = v
    --         table.remove(config_res.chooseLanguage, k)
    --         break
    --     end
    -- end
--    debug.print_r(sysLanguageConfig,"sysLanguageConfig==")
    -- if #sysLanguageConfig >0 then
    --     table.insert(config_res.chooseLanguage, sysLanguageConfig)
    -- end
    -- Antes habia aqui un reverseTable() que vaciaba config_res.chooseLanguage
    -- con table.remove y le asignaba la lista del reves: al ser la MISMA tabla
    -- global, el orden se daba la vuelta cada vez que se abria el popup.
    -- Se usa el orden del config tal cual, que es estable.
--    debug.print_r(config_res.chooseLanguage,"config_res.chooseLanguage==")
    if config_res.chooseLanguage then
        local languageConfigLength =table.nums(config_res.chooseLanguage)
        self.button_list_down = ccui.Helper:seekWidgetByName(root, "Button_list_down")
        self.button_list_up = ccui.Helper:seekWidgetByName(root, "Button_list_up")
        self.button_list_down:setVisible(languageConfigLength >5)
        self.button_list_up:setVisible(languageConfigLength >5)
        for i = 1, languageConfigLength do
            local languageData = config_res.chooseLanguage[i]
            if curLanguage ~= languageData.name then
                local cell = ChooseLanguageCell:createCell()
                cell:init(languageData,true)
                self.server_list:addChild(cell)
            end
        end
        self.server_list_ContainerPosY = self.server_list:getInnerContainer():getPositionY()
    end
end

function ChooseLanguagePopup:onExit()
    state_machine.remove("choose_language_popup_ok")
end