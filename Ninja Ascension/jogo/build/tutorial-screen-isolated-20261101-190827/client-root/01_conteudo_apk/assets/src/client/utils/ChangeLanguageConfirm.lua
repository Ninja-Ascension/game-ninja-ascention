-- ----------------------------------------------------------------------------------------------------
-- 说明：切换语言退出确认界面
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
ChangeLanguageConfirm = class("ChangeLanguageConfirmClass", Window)
    
function ChangeLanguageConfirm:ctor()
    self.super:ctor()
    self._language = nil
 
    local function init_chang_language_confirm_terminal()
		--取消切换
        local chang_language_no_terminal = {
            _name = "chang_language_no",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                --local cell = fwin:find("MoreSystemChooseLanguageClass")
                --cell:setVisible(true)
                fwin:close(fwin:find("ChangeLanguageConfirmClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --确定切换
        local chang_language_yes_terminal = {
            _name = "chang_language_yes",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local languageString = instance._language
                cc.UserDefault:getInstance():setStringForKey("current_language",languageString)
                cc.UserDefault:getInstance():flush()
                fwin:close(fwin:find("ChangeLanguageConfirmClass"))
                fwin:close(fwin:find("MoreSystemChooseLanguageClass"))
                TipDlg.drawTextDailog(chooseLanguageStr)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(chang_language_yes_terminal)
        state_machine.add(chang_language_no_terminal)
        state_machine.init()
    end
    
    -- call func init BulkBuy state machine.
    init_chang_language_confirm_terminal()
end

function ChangeLanguageConfirm:onEnterTransitionFinish()
    local csbChangeLanguageConfirm = csb.createNode(config_csb.utils.prompt_yuyanshezhi)
    self:addChild(csbChangeLanguageConfirm)
	
	local root = csbChangeLanguageConfirm:getChildByName("root")
	
    --取消
	local close_button = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil, 
        {
            terminal_name = "chang_language_no", 
            terminal_state = 1,
            isPressedActionEnabled = true
        }, nil, 2)
    --取消
    local Button_prompt_close = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_prompt_close"), nil, 
        {
            terminal_name = "chang_language_no", 
            terminal_state = 1,
            isPressedActionEnabled = true
        }, nil, 2)
    --确定
    local close_button = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, 
        {
            terminal_name = "chang_language_yes", 
            terminal_state = 1,
            isPressedActionEnabled = true
        }, nil, 2)
end

function ChangeLanguageConfirm:onExit()
	state_machine.remove("chang_language_no")
    state_machine.remove("chang_language_yes")
end

function ChangeLanguageConfirm:init(_language)
    self._language = _language
end