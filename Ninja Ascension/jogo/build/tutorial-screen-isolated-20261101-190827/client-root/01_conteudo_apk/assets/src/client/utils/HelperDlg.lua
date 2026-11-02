-- ----------------------------------------------------------------------------------------------------
-- 说明：帮助界面
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
HelperDlg = class("HelperDlgClass", Window)
    
function HelperDlg:ctor()
    self.super:ctor()
 
    -- Initialize HelperDlg state machine.
    local function init_HelperDlg_terminal()
		-- 界面关闭按钮
        local helper_dlg_return_terminal = {
            _name = "helper_dlg_close",
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
		
        state_machine.add(helper_dlg_return_terminal)
        state_machine.init()
    end
    
    -- call func init HelperDlg state machine.
    init_HelperDlg_terminal()
end

function HelperDlg:onEnterTransitionFinish()
    local csbHelperDlg = csb.createNode("utils/HelperDlg.csb")
    self:addChild(csbHelperDlg)
	
	local root = csbHelperDlg:getChildByName("root")
	local close_button = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, {terminal_name = "helper_dlg_close", terminal_state = 1,isPressedActionEnabled = true}, nil, 2)
end

function HelperDlg:onExit()
	state_machine.remove("helper_dlg_close")
end