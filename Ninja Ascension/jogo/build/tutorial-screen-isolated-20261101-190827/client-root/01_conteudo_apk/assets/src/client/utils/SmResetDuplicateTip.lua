SmResetDuplicateTip = class("SmResetDuplicateTipClass", Window)

--打开界面
local sm_reset_duplicate_tip_open_terminal = {
    _name = "sm_reset_duplicate_tip_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("SmResetDuplicateTipClass") == nil then
            fwin:open(SmResetDuplicateTip:new():init(), fwin._dialog)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_reset_duplicate_tip_close_terminal = {
    _name = "sm_reset_duplicate_tip_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("SmResetDuplicateTipClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_reset_duplicate_tip_open_terminal)
state_machine.add(sm_reset_duplicate_tip_close_terminal)
state_machine.init()

function SmResetDuplicateTip:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    local function init_sm_reset_duplicate_tip_terminal()
        local sm_reset_duplicate_tip_goto_recharge_terminal = {
            _name = "sm_reset_duplicate_tip_goto_recharge",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("recharge_dialog_window_open", 0, nil)
                state_machine.excute("show_vip_privilege", 0, nil)
                state_machine.excute("sm_reset_duplicate_tip_close", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(sm_reset_duplicate_tip_goto_recharge_terminal)
        state_machine.init()
    end
    init_sm_reset_duplicate_tip_terminal()
end

function SmResetDuplicateTip:onInit()
	local csbTip = csb.createNode("utils/prompt_4.csb")
    self:addChild(csbTip)
	local root = csbTip:getChildByName("root")

    local action = csb.createTimeline("utils/prompt_4.csb") 
    table.insert(self.actions, action)
    csbTip:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
    end)
    action:play("window_open", false)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3_6_2"), nil, 
	{
		terminal_name = "sm_reset_duplicate_tip_goto_recharge", 
		terminal_state = 0, 
        isPressedActionEnabled = true
	},
	nil,0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4_8"), nil, 
    {
        terminal_name = "sm_reset_duplicate_tip_close", 
        terminal_state = 0, 
        isPressedActionEnabled = true
    },
    nil,0)
end

function SmResetDuplicateTip:onEnterTransitionFinish()
    
end

function SmResetDuplicateTip:init()
	self:onInit()
    return self
end

function SmResetDuplicateTip:onExit()
	state_machine.remove("sm_reset_duplicate_tip_goto_recharge")
end
