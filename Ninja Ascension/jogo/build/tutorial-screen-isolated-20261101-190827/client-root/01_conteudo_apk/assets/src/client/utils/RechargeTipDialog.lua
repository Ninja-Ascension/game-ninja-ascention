-- ----------------------------------------------------------------------------------------------------
-- 说明：VIP等级不足的充值跳转提示界面
-------------------------------------------------------------------------------------------------------
RechargeTipDialog = class("RechargeTipDialogClass", Window)
    
function RechargeTipDialog:ctor()
    self.super:ctor()
	self.roots = {}

    self.current_type = 0
    self.needVipLevel = 0
    self.useCount = 0
    self.tipMessage = ""

    self._enum_type = {
        RECHARGE_TIP_NEED_VIP_LEVEL = 10,    -- vip等级不足的充值提示
        RECHARGE_TIP_NEED_GOOLD = 11,    -- 用户宝石不足的充值提示
    }

    -- Initialize recharge tip dialog state machine.
    local function init_recharge_tip_dialog_terminal()
        local recharge_tip_dialog_close_terminal = {
            _name = "recharge_tip_dialog_close",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:close(fwin:find("RechargeTipDialogClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local recharge_tip_dialog_cancel_terminal = {
            _name = "recharge_tip_dialog_cancel",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("recharge_tip_dialog_close", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local recharge_tip_dialog_confirm_terminal = {
            _name = "recharge_tip_dialog_confirm",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("recharge_tip_dialog_close", 0, "")
                state_machine.excute("shortcut_open_recharge_window", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(recharge_tip_dialog_close_terminal)
        state_machine.add(recharge_tip_dialog_cancel_terminal)
        state_machine.add(recharge_tip_dialog_confirm_terminal)
        state_machine.init()
    end
    
    -- call func init recharge tip dialog state machine.
    init_recharge_tip_dialog_terminal()
end

function RechargeTipDialog:onUpdateDraw()
    local root = self.roots[1]
    if self.current_type == self._enum_type.RECHARGE_TIP_NEED_VIP_LEVEL then
        if self.tipMessage ~= nil then
            ccui.Helper:seekWidgetByName(root, "Text_1_2_2"):setString(self.tipMessage)
        end
    else
        ccui.Helper:seekWidgetByName(root, "Text_1_2_2_0"):setString("" .. self.needVipLevel)
        ccui.Helper:seekWidgetByName(root, "Text_1_2_2_0_0"):setString("" .. self.useCount)
    end
end

function RechargeTipDialog:onEnterTransitionFinish()
    local csbRechargeTipDialog = csb.createNode("utils/prompt_2.csb")
    local root = csbRechargeTipDialog:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbRechargeTipDialog)

    local action = csb.createTimeline("utils/prompt_2.csb")
    if action:IsAnimationInfoExists("window_open") == true then
        csbRechargeTipDialog:runAction(action)
        action:play("window_open", false)
    end

    self:onUpdateDraw()

    -- 添加UI的响应事件
    -- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_13_3_4"),       nil, 
    -- {
    --     terminal_name = "recharge_tip_dialog_close",       
    --     terminal_state = 0, 
    --     isPressedActionEnabled = false
    -- }, 
    -- nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_2"),       nil, 
    {
        terminal_name = "recharge_tip_dialog_close",       
        terminal_state = 0, 
        isPressedActionEnabled = false
    }, 
    nil, 2)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4_8_4"),       nil, 
    {
        terminal_name = "recharge_tip_dialog_cancel",       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3_6_2"),       nil, 
    {
        terminal_name = "recharge_tip_dialog_confirm",       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
end

function RechargeTipDialog:init(_types, vipLevel, hasCount, _tipMessage)
	self.current_type = _types
    self.needVipLevel = vipLevel
    self.useCount = hasCount
    self.tipMessage = _tipMessage
    return self
end

function RechargeTipDialog:onExit()
    state_machine.remove("recharge_tip_dialog_close")
	state_machine.remove("recharge_tip_dialog_cancel")
	state_machine.remove("recharge_tip_dialog_confirm")
end