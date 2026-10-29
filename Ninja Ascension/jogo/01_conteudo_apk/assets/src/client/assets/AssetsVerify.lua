
AssetsVerify = class("AssetsVerifyClass", Window)

function AssetsVerify:ctor()
	self.super:ctor()
    self.roots = {}
	
	local function init_assets_verify_terminal()
        local assets_verify_manager_terminal = {
            _name = "assets_verify_manager",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseAssetsVerifyCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        --> print("-获取资源更新完毕-")
                        if _ED.resource_package == nil or table.getn(_ED.resource_package) <= 0 then
                            -- app.load("client.loader.LocalDatas")
                            -- if localData ~= nil then
                                -- localData()
                                -- localData = nil
                            -- end
                            state_machine.excute("assets_manager_manager_assets_into_login_page", 0, "")
                        else
                            --> print("有资源更新内容，进入资源更新公告预览")
                             --开始更新
                            jttd.myDataSubmitted("2","")
                            state_machine.excute("assets_manager_manager", 0, "assets_manager_manager_assets_notice")
                        end
                        fwin:close(response.node)
                    else
                        state_machine.excute("assets_verify_manager", 0, "")
                    end
                end
                terminal.responseCount = terminal.responseCount or 0
                terminal.responseCount = terminal.responseCount + 1
                if terminal.responseCount > 100 then
                    terminal.responseCount = 0
                    return false
                end
                _ED.resource_package = _ED.resource_package or {}
                NetworkView:reconnectErase(nil)
                NetworkManager:register(protocol_command.new_get_server_list.code, app.configJson.url, nil, nil, instance, responseAssetsVerifyCallback, false, nil)
                -- if localData ~= nil then
                --     localData()
                --     localData = nil
                -- end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(assets_verify_manager_terminal)
        state_machine.init()
    end
    init_assets_verify_terminal()
end

function AssetsVerify:onEnterTransitionFinish()
	local csbAssetsVerify = csb.createNode("utils/update_get.csb")
    self:addChild(csbAssetsVerify)
    local root = csbAssetsVerify:getChildByName("root")
    -- Textos en el idioma ELEGIDO en el juego (current_language); el del movil
    -- solo si aun no hay uno o no tiene ficha en config_res.multiLanguage.
    local sysLanguage = cc.UserDefault:getInstance():getStringForKey("current_language", "")
    if config_res == nil or config_res.multiLanguage == nil or config_res.multiLanguage[sysLanguage] == nil then
        sysLanguage = m_system_default_language
    end
    if config_res.multiLanguage then
        local sysLanguageConfig = config_res.multiLanguage[sysLanguage]
        if sysLanguageConfig then
            local Text_05= ccui.Helper:seekWidgetByName(root, "Text_05")
            if Text_05 then
                Text_05:setString(sysLanguageConfig.updateDetectText)
            end
        end
    end
    state_machine.excute("assets_verify_manager", 0, "")
end

function AssetsVerify:onExit()
	state_machine.remove("assets_verify_manager")
end