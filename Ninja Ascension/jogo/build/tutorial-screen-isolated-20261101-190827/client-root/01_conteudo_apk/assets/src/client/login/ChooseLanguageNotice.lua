-- ----------------------------------------------------------------------------------------------------
-- 说明： 确认切换语言弹窗
-- ----------------------------------------------------------------------------------------------------
ChooseLanguageNotice = class("ChooseLanguageNoticeClass", Window)

function ChooseLanguageNotice:ctor()
	self.super:ctor()
    self.roots = {}
    self._multiLanguage = {}
	local function init_assets_notice_terminal()
        local choose_language_notice_sure_terminal = {
            _name = "choose_language_notice_sure",
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

        local choose_language_notice_cancel_terminal = {
            _name = "choose_language_notice_cancel",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:close(instance)
              --  os.exit() --退出游戏
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(choose_language_notice_cancel_terminal)
		state_machine.add(choose_language_notice_sure_terminal)
        state_machine.init()
    end
    init_assets_notice_terminal()
end

function ChooseLanguageNotice:onEnterTransitionFinish()
	local csbChooseLanguageNotice = csb.createNode("utils/update_get_prompt.csb")
    self:addChild(csbChooseLanguageNotice)

    local root = csbChooseLanguageNotice:getChildByName("root")
	table.insert(self.roots, root)
    --提示文字内容 检查到版本更新，点击开始下载即可进行下载更新。
    local languageText = self._multiLanguage.languageText
    local oldLanguage = cc.UserDefault:getInstance():getStringForKey("current_language")
    local oldMultiLanguage= config_res.multiLanguage[oldLanguage]

    -- Textos en el idioma ELEGIDO en el juego (current_language); el del movil
    -- solo si aun no hay uno o no tiene ficha en config_res.multiLanguage.
    local sysLanguage = cc.UserDefault:getInstance():getStringForKey("current_language", "")
    if config_res == nil or config_res.multiLanguage == nil or config_res.multiLanguage[sysLanguage] == nil then
        sysLanguage = m_system_default_language
    end
    local sysLanguageConfig = nil
    if config_res.multiLanguage then
        sysLanguageConfig = config_res.multiLanguage[sysLanguage]
    end
    -- 绘制资源更新大小的提示信息
    local totalSize = self._multiLanguage.packageSize
    local dataString = ""
    if (totalSize < 1024) then
        dataString = string.format("%02dB", totalSize)
    elseif (totalSize < 1024 * 1024) then
        dataString = string.format("%.2fKB", totalSize/1024.0)
    else
        dataString = string.format("%.2fMB", totalSize/1024.0/1024.0)
    end
    local downloadDataSizeString = ccui.Helper:seekWidgetByName(root, "Text_gp_2")
    downloadDataSizeString:setString(dataString)

    -- 绘制更新的公告信息
    if sysLanguageConfig then
        local sureUpdateWord = sysLanguageConfig.sureUpdateWord
        if sureUpdateWord then
            local hintStr = string.format(sureUpdateWord,languageText)
            local textNotice = ccui.Helper:seekWidgetByName(root, string.format("Text_05"))
            textNotice:setString(hintStr)
        end
    end

--    local list = {}
--    for i, v in pairs(_ED.resource_package_notices) do
--        ccui.Helper:seekWidgetByName(root, string.format("Text_0%s", i + 4)):setString(zstring.exchangeFrom(v.tile .." ".. v.notice))
--        table.insert(list, ccui.Helper:seekWidgetByName(root, string.format("Text_0%s", i + 4)))
--    end
--    local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_gp_2")
--    local panel = m_ScrollView:getInnerContainer()
--    panel:setContentSize(m_ScrollView:getContentSize())
--    panel:setPosition(cc.p(0,0))
--    panel:removeAllChildren(true)
--
--    local sSize = panel:getContentSize()
--    local sHeight = sSize.height
--    local controlSize = m_ScrollView:getInnerContainerSize()
--    local nextY = sSize.height
--    local tHeight = 0
--    local thList = {}
--    for i, v in ipairs(list) do
--        v:removeFromParent(false)
--        panel:addChild(v)
--        tHeight = tHeight + v:getContentSize().height
--    end
--
--    sHeight = math.max(sHeight, tHeight)
--    panel:setContentSize(m_ScrollView:getContentSize().width, sHeight)

    --取消下载
    local Text_4 = ccui.Helper:seekWidgetByName(root, "Text_4")
    if sysLanguageConfig then
        local cancelDownWord = sysLanguageConfig.cancelDownWord
        if cancelDownWord then
            --  debug.print_r(cancelDownWord,"cancelDownWord===")
            Text_4:setString(cancelDownWord)
        end
    end
    --确认下载
    if sysLanguageConfig then
        local Text_5 = ccui.Helper:seekWidgetByName(root, "Text_5")
        local sureDownWord = sysLanguageConfig.sureDownWord
        if sureDownWord then
            -- debug.print_r(sureDownWord,"sureDownWord===")
            Text_5:setString(sureDownWord)
        end
    end

    -- 取消下载
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_gp_1"),nil,
	{
		terminal_name = "choose_language_notice_cancel",
		isPressedActionEnabled = true
	}, nil, 0)

	-- 确认更新语言
   	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_gp_2"),nil,
	{
		terminal_name = "choose_language_notice_sure",
		isPressedActionEnabled = true,
        _multiLanguage = self._multiLanguage
	}, nil, 0)
end

function ChooseLanguageNotice:init(params)
    self._multiLanguage = params
    return self
end

function ChooseLanguageNotice:onExit()
	state_machine.remove("choose_language_notice_sure")
	state_machine.remove("choose_language_notice_cancel")
end