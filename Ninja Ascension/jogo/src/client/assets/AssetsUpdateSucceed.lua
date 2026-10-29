
AssetsUpdateSucceed = class("AssetsUpdateSucceedClass", Window)

function AssetsUpdateSucceed:ctor()
	self.super:ctor()
    self.roots = {}
	
	local function init_assets_update_succeed_terminal()
        local assets_update_succeed_manager_terminal = {
            _name = "assets_update_succeed_manager",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("assets_manager_manager_assets_into_login_page", 0, "")
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(assets_update_succeed_manager_terminal)
        state_machine.init()
    end
    init_assets_update_succeed_terminal()
end

function AssetsUpdateSucceed:addLink()
	
end

function AssetsUpdateSucceed:onEnterTransitionFinish()
	local csbAssetsUpdateSucceed = csb.createNode("utils/update.csb")
    self:addChild(csbAssetsUpdateSucceed)

    local root = csbAssetsUpdateSucceed:getChildByName("root")
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
            local Text_3= ccui.Helper:seekWidgetByName(root, "Text_3")
            if Text_3 then
                Text_3:setString(sysLanguageConfig.updateSuccessText)
            end
        end
    end

    -- 更新成功
    jttd.myDataSubmitted("3","")
    -- 确定
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"),          nil, 
    {
        terminal_name = "assets_update_succeed_manager",
        isPressedActionEnabled = true
    }, nil, 0)

    -- 取消
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"),          nil, 
    {
        terminal_name = "assets_update_succeed_manager",
        isPressedActionEnabled = true
    }, nil, 0)
end

function AssetsUpdateSucceed:onExit()
	state_machine.remove("assets_update_succeed_manager")
end