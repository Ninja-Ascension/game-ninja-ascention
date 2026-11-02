
AssetsUpdateError = class("AssetsUpdateErrorClass", Window)

function AssetsUpdateError:ctor()
	self.super:ctor()
    self.roots = {}
	
	local function init_assets_update_error_terminal()
        local assets_update_error_exit_game_terminal = {
            _name = "assets_update_error_exit_game",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	os.exit()
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local assets_update_error_restart_terminal = {
            _name = "assets_update_error_restart",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:close(instance)
                state_machine.excute("assets_manager_manager", 0, "assets_manager_manager_assets_verify")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


		state_machine.add(assets_update_error_exit_game_terminal)
        state_machine.add(assets_update_error_restart_terminal)
        state_machine.init()
    end
    init_assets_update_error_terminal()
end

function AssetsUpdateError:addLink()
	
end

function AssetsUpdateError:onEnterTransitionFinish()
	local csbAssetsUpdateError = csb.createNode("utils/update_timeout.csb")
    self:addChild(csbAssetsUpdateError)

    local root = csbAssetsUpdateError:getChildByName("root")
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
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_t_1"),          nil, 
    {
        terminal_name = "assets_update_error_exit_game",
        isPressedActionEnabled = true
    }, nil, 0)

    -- 更新资源
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_t_2"),          nil, 
    {
        terminal_name = "assets_update_error_restart",
        isPressedActionEnabled = true
    }, nil, 0)

end

function AssetsUpdateError:onExit()
	state_machine.remove("assets_update_error_exit_game")
    state_machine.remove("assets_update_error_restart")
end