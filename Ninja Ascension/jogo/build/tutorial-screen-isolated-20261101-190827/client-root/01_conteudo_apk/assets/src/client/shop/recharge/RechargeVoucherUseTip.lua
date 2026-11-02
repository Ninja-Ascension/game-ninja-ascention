-- ----------------------------------------------------------------------------------------------------
-- 代金券跳转确认界面
-------------------------------------------------------------------------------------------------------
RechargeVoucherUseTip = class("RechargeVoucherUseTipClass", Window)

function RechargeVoucherUseTip:ctor()
    self.super:ctor()
    self.roots = {}
    self._instance = nil
    self._callback = nil
    self._txt = ""
    self.params = nil -- {terminal_name = "", terminal_state = 0, _msg = "", _datas= {}}

    -- Initialize RechargeVoucherUseTip state machine.
    local function init_RechargeVoucherUseTip_terminal()
        -- 界面确定按钮
        local confirm_tip_ok_terminal = {
            _name = "confirm_tip_ok",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance then
                    instance._callback(instance._instance, 0)
                end

                fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 界面取消按钮
        local confirm_tip_cancel_terminal = {
            _name = "confirm_tip_cancel",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance then
                    instance._callback(instance._instance, 2)
                end

                fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 界面关闭
        local confirm_tip_close_terminal = {
            _name = "confirm_tip_close",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance then
                    instance._callback(instance._instance, 3)
                end
                fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(confirm_tip_close_terminal)
        state_machine.add(confirm_tip_ok_terminal)
        state_machine.add(confirm_tip_cancel_terminal)
        state_machine.init()
    end

    -- call func init RechargeVoucherUseTip state machine.
    init_RechargeVoucherUseTip_terminal()
end

function RechargeVoucherUseTip:onEnterTransitionFinish()
    local csbRechargeVoucherUseTip = csb.createNode("utils/prompt_6.csb")
    self:addChild(csbRechargeVoucherUseTip)

    local root = csbRechargeVoucherUseTip:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline("utils/prompt_6.csb")
    root:runAction(action)
    action:play("window_open", false)

    --提示文本
    local drawText = ""
    if self.params ~= nil then
        drawText = self.params._msg
    elseif self._txt ~= nil and self._txt ~= "" then
        drawText = self._txt
    end
    local titleName = ccui.Helper:seekWidgetByName(root, "Text_141")
    if titleName ~= nil then
        titleName:setString(drawText or " ")
    end

    local ok_button =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_3_6_2"),
        nil,
        {
            terminal_name = "confirm_tip_ok",
            terminal_state = 1,
            taget = self,
            isPressedActionEnabled = true
        },
        nil,
        0
    )
    local cancel_button =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_4_8_0"),
        nil,
        {
            terminal_name = "confirm_tip_cancel",
            terminal_state = 1,
            taget = self,
            isPressedActionEnabled = true
        },
        nil,
        0
    )
    local Button_4_8 =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_4_8"),
        nil,
        {
            terminal_name = "confirm_tip_close",
            terminal_state = 1,
            taget = self
        },
        nil,
        0
    )

    local Panel_6_13 = ccui.Helper:seekWidgetByName(root, "Panel_6_13")
    if self.isShowAni ~= nil and self.isShowAni == false then
        Panel_6_13:setVisible(false)
    end
end

function RechargeVoucherUseTip:init(instance, callback, txt, params, cell, isShowAni, isExecuteCloseCallback)
    self._instance = instance
    self._callback = callback
    self._txt = txt
    self.params = params
    self._self = cell
    if isShowAni ~= nil then
        self.isShowAni = isShowAni
    end

    self._isExecuteCloseCallback = (isExecuteCloseCallback == nil) and true or isExecuteCloseCallback

    return self
end

function RechargeVoucherUseTip:onExit()
    state_machine.remove("confirm_tip_ok")
    state_machine.remove("confirm_tip_cancel")
    state_machine.remove("confirm_tip_close")
end
