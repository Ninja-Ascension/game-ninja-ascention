-- ----------------------------------------------------------------------------------------------------
-- 说明：二级确认界面
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
ConfirmDlg = class("ConfirmDlgClass", Window)
    
function ConfirmDlg:ctor()
    self.super:ctor()
 
    -- Initialize ConfirmDlg state machine.
    local function init_ConfirmDlg_terminal()
		-- 界面确定按钮
        local confirm_dlg_ok_terminal = {
            _name = "confirm_dlg_ok",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 界面取消按钮
        local confirm_dlg_cancel_terminal = {
            _name = "confirm_dlg_cancel",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(confirm_dlg_ok_terminal)
        state_machine.add(confirm_dlg_cancel_terminal)
        state_machine.init()
    end
    
    -- call func init ConfirmDlg state machine.
    init_ConfirmDlg_terminal()
end

function ConfirmDlg:onEnterTransitionFinish()
    local csbConfirmDlg = csb.createNode("utils/ConfirmDlg.csb")
    self:addChild(csbConfirmDlg)
	
	local root = csbConfirmDlg:getChildByName("root")
	
	local ok_button = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil, {terminal_name = "confirm_dlg_ok", terminal_state = 1,isPressedActionEnabled = true}, nil, 0)
	local cancel_button = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, {terminal_name = "confirm_dlg_cancel", terminal_state = 1,isPressedActionEnabled = true}, nil, 2)
end

function ConfirmDlg:onExit()
	state_machine.remove("confirm_dlg_ok")
	state_machine.remove("confirm_dlg_cancel")
end