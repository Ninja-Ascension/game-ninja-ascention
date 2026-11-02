-- ----------------------------------------------------------------------------------------------------
-- 说明：更新提示确认框
-- 创建时间
-- 作者：肖雄
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
UpdatePrompt = class("UpdatePromptClass", Window)

function UpdatePrompt:ctor()
    self.super:ctor()
    
	self.roots = {}
	
	self.tipText = ""
	self.confirmTerminalName = ""
	self.cancelTerminalName = ""
	self.richText = nil
	
    local function init_update_prompt_terminal()
        local update_prompt_click_confirm_terminal = {
            _name = "update_prompt_click_confirm",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if self.confirmTerminalName ~= "" then
					state_machine.excute(self.confirmTerminalName, 0, "update_prompt_click_confirm.")
				else
					--> debug.log(true, "nil ConfirmTerminalName In update_prompt_click_confirm_terminal.")
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local update_prompt_click_cancel_terminal = {
            _name = "update_prompt_click_cancel",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if self.cancelTerminalName ~= "" then
					state_machine.excute(self.cancelTerminalName, 0, "update_prompt_click_cancel.")
				else
					--> debug.log(true, "nil CancelTerminalName In update_prompt_click_cancel_terminal.")
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(update_prompt_click_confirm_terminal)
		state_machine.add(update_prompt_click_cancel_terminal)
        state_machine.init()
    end
    init_update_prompt_terminal()
end

function UpdatePrompt:init(_tipText, _confirmTerminalName, _cancelTerminalName, _richText)
	self.tipText = _tipText
	self.confirmTerminalName = _confirmTerminalName
	self.cancelTerminalName = _cancelTerminalName
	self.richText = _richText
end

function UpdatePrompt:onEnterTransitionFinish()
    local csbUpdatePrompt = csb.createNode("utils/update.csb")
	local root = csbUpdatePrompt:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbUpdatePrompt)
	
	local content_text = ccui.Helper:seekWidgetByName(root, "Text_3")
	content_text:removeAllChildren(true)
	content_text:setString(self.tipText)
	if self.richText ~= nil then
		content_text:addChild(self.richText)
	end
	
	-- 确定
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, 
	{
		terminal_name = "update_prompt_click_confirm", 	
		terminal_state = 0, 
		isPressedActionEnabled = true
	},	
	nil, 0)	
	
	-- 取消
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil, 
	{
		terminal_name = "update_prompt_click_cancel", 	
		terminal_state = 0, 
		isPressedActionEnabled = true
	},	
	nil, 1)	
end

function UpdatePrompt:onExit()
	state_machine.remove("update_prompt_click_confirm")
	state_machine.remove("update_prompt_click_cancel")
end