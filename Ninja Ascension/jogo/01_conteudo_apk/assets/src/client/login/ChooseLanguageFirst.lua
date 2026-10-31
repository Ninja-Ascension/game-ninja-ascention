-- ----------------------------------------------------------------------------------------------------
-- 说明：首次登陆弹出切换语言弹窗
-- ----------------------------------------------------------------------------------------------------
ChooseLanguageFirst = class("ChooseLanguageFirstClass", Window)

function ChooseLanguageFirst:ctor()
	self.super:ctor()
    self.roots = {}
    self._multiLanguage = {}
	local function init_assets_notice_terminal()
        local choose_language_first_sure_terminal = {
            _name = "choose_language_first_sure",
            _init = function (terminal)
                app.load("client.login.ChooseLanguagePopup")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	fwin:close(instance)
                fwin:open(ChooseLanguagePopup:new():init(), fwin._view)
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local choose_language_first_cancel_terminal = {
            _name = "choose_language_first_cancel",
            _init = function (terminal)
                app.load("client.login.login")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:close(instance)
                state_machine.excute("login_vali_register", 0, "login_vali_register")
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(choose_language_first_cancel_terminal)
		state_machine.add(choose_language_first_sure_terminal)
        state_machine.init()
    end
    init_assets_notice_terminal()
end

function ChooseLanguageFirst:onEnterTransitionFinish()
	local csbChooseLanguageFirst = csb.createNode("login/change_language_Switch.csb")
    self:addChild(csbChooseLanguageFirst)

    local root = csbChooseLanguageFirst:getChildByName("root")
	table.insert(self.roots, root)
    --提示文字内容 检查到版本更新，点击开始下载即可进行下载更新。
    local languageText = self._multiLanguage.languageText
    local oldLanguage = cc.UserDefault:getInstance():getStringForKey("current_language")
    if config_res.multiLanguage then
        local oldMultiLanguage = config_res.multiLanguage[oldLanguage]
        -- 显示当前游戏语言文本
        local oldLanguageText = oldMultiLanguage.languageText
        if oldLanguageText then
            local Text_change_n_1 = ccui.Helper:seekWidgetByName(root, "Text_change_n_1")
            Text_change_n_1:setString(oldLanguageText)--游戏语言
        end
    end

    if config_res.multiLanguage then
        local sysLanguage = m_system_default_language
        local sysLanguageConfig = config_res.multiLanguage[sysLanguage]
        -- 显示手机系统语言文本
        if sysLanguageConfig then
            local Text_change = ccui.Helper:seekWidgetByName(root, "Text_change")
            Text_change:setString(sysLanguageConfig.firstCheckLanguageHint)
            local Text_change_n = ccui.Helper:seekWidgetByName(root, "Text_change_n")
            Text_change_n:setString(sysLanguageConfig.languageText)
            local Button_language_n = ccui.Helper:seekWidgetByName(root, "Button_language_n")
            if Button_language_n then
                local Text_language_n = ccui.Helper:seekWidgetByName(Button_language_n, "Text_language_n")
                Text_language_n:setString(sysLanguageConfig.firstChangeLanguage)
            end
            local Button_language_n_0 = ccui.Helper:seekWidgetByName(root, "Button_language_n_0")
            if Button_language_n_0 then
                local Text_language_n = ccui.Helper:seekWidgetByName(Button_language_n, "Text_language_n")
                Text_language_n:setString(sysLanguageConfig.firstNoChangeLanguage)
            end
        end
    end

    -- 取消下载
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_language_n_0"),nil,
	{
		terminal_name = "choose_language_first_cancel",
		isPressedActionEnabled = true
	}, nil, 0)

	-- 确认更新语言
   	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_language_n"),nil,
	{
		terminal_name = "choose_language_first_sure",
		isPressedActionEnabled = true,
	}, nil, 0)
end

function ChooseLanguageFirst:init()

    return self
end

function ChooseLanguageFirst:onExit()
	state_machine.remove("choose_language_first_sure")
	state_machine.remove("choose_language_first_cancel")
end