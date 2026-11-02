-- ----------------------------------------------------------------------------------------------------
-- 说明： 切换多语言更新错误弹窗
-- ----------------------------------------------------------------------------------------------------
ChooseLanguageError = class("ChooseLanguageErrorClass", Window)

function ChooseLanguageError:ctor()
	self.super:ctor()
    self.roots = {}
    self._multiLanguage = {}
	local function init_choose_language_error_terminal()
        local choose_language_error_exit_game_terminal = {
            _name = "choose_language_error_exit_game",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
--            	os.exit()
                fwin:close(instance)
                -- Y la pantalla de carga que hay DEBAJO. Sin esto,
                -- «Salir» devolvia al jugador a la barra parada y no
                -- habia forma de volver al login.
                local updateWindow = fwin:find("ChooseLanguageUpdateClass")
                if updateWindow ~= nil then
                    fwin:close(updateWindow)
                end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local choose_language_error_restart_terminal = {
            _name = "choose_language_error_restart",
            _init = function (terminal)
                app.load("client.login.ChooseLanguageUpdate")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:close(instance)
                local multiLanguage = params._datas._multiLanguage
                fwin:open(ChooseLanguageUpdate:new():init(multiLanguage), fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(choose_language_error_exit_game_terminal)
        state_machine.add(choose_language_error_restart_terminal)
        state_machine.init()
    end
    init_choose_language_error_terminal()
end

function ChooseLanguageError:onEnterTransitionFinish()
	local csbChooseLanguageError = csb.createNode("utils/update_timeout.csb")
    self:addChild(csbChooseLanguageError)

    local root = csbChooseLanguageError:getChildByName("root")
	table.insert(self.roots, root)

    -- Textos en el idioma ELEGIDO en el juego (current_language); el del movil
    -- solo si aun no hay uno o no tiene ficha en config_res.multiLanguage.
    local sysLanguage = cc.UserDefault:getInstance():getStringForKey("current_language", "")
    if config_res == nil or config_res.multiLanguage == nil or config_res.multiLanguage[sysLanguage] == nil then
        sysLanguage = m_system_default_language
    end
    if config_res.multiLanguage then
        local sysLanguageConfig = config_res.multiLanguage[sysLanguage]
        if sysLanguageConfig then
            local Text_2= ccui.Helper:seekWidgetByName(root, "Text_2")
            if Text_2 then
                Text_2:setString(sysLanguageConfig.updateErrorExit)
            end
            local Text_3= ccui.Helper:seekWidgetByName(root, "Text_3")
            if Text_3 then
                Text_3:setString(sysLanguageConfig.updateErrorRenew)
            end
            local Text_1= ccui.Helper:seekWidgetByName(root, "Text_1")
            if Text_1 then
                Text_1:setString(sysLanguageConfig.updateErrorHint)
            end
        end
    end
    -- 退出游戏
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_t_1"),nil,
    {
        terminal_name = "choose_language_error_exit_game",
        isPressedActionEnabled = true
    }, nil, 0)

    -- 更新资源
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_t_2"),nil,
    {
        terminal_name = "choose_language_error_restart",
        isPressedActionEnabled = true,
        _multiLanguage = self._multiLanguage
    }, nil, 0)

end
function ChooseLanguageError:init(params)
    self._multiLanguage = params
    return self
end
function ChooseLanguageError:onExit()
	state_machine.remove("choose_language_error_exit_game")
    state_machine.remove("choose_language_error_restart")
end