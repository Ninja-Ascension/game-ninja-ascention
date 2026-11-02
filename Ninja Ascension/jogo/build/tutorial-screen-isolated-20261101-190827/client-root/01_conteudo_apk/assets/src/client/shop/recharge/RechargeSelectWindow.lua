-----------------------------
--充值返钻
-----------------------------
RechargeSelectWindow = class("RechargeSelectWindowClass", Window)

-- 充值类型
MRECHARGETYPE = "13"
MRECHARGESTRP = "14"

local recharge_select_window_open_terminal = {
    _name = "recharge_select_window_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("RechargeSelectWindowClass") == nil then
            fwin:open(RechargeSelectWindow:new():init(params), fwin._dialog)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local recharge_select_window_close_terminal = {
    _name = "recharge_select_window_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.unlock("recharge_list_button")
        fwin:close(fwin:find("RechargeSelectWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(recharge_select_window_open_terminal)
state_machine.add(recharge_select_window_close_terminal)
state_machine.init()

function RechargeSelectWindow:ctor()
    self.super:ctor()
    self.roots = {}

    self.m_type = 0

    local function init_recharge_select_window_cell_terminal()
        local recharge_select_window_click_terminal = {
            _name = "recharge_select_window_click",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params then
                    local mType = params._datas.m_type
                    if mType == 1 then
                        -- Paypal
                        params._datas.m_rechargeCallBack(MRECHARGETYPE)
                    else
                        -- Stripe
                        params._datas.m_rechargeCallBack(MRECHARGESTRP)
                    end
                   

                    state_machine.excute("recharge_select_window_close", 0, "")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local recharge_select_image_click_terminal = {
            _name = "recharge_select_image_click",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance then 
                    local btnType = params._datas.btn_type
                    instance:onRefushBtn(btnType)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(recharge_select_window_click_terminal)
        state_machine.add(recharge_select_image_click_terminal)
        state_machine.init()
    end
    init_recharge_select_window_cell_terminal()
end

function RechargeSelectWindow:init(params)
    self:onInit(params)
    return self
end


function RechargeSelectWindow:onUpdateDarw()
    local root = self.roots[1]

    local money = dms.string(dms["top_up_goods"], tonumber(m_reqcharge_info.rechargeIndex), top_up_goods.money)
    local game_money = dms.string(dms["top_up_goods"], tonumber(m_reqcharge_info.rechargeIndex), top_up_goods.game_money)

    local Text_server_0 = ccui.Helper:seekWidgetByName(root, "Text_server_0")
    Text_server_0:setString(_ED.all_servers[_ED.selected_server].server_name.."")

    local Text_role_name_0 = ccui.Helper:seekWidgetByName(root, "Text_role_name_0")
    Text_role_name_0:setString(_ED.user_info.user_name.."")

    local Text_amount_0 = ccui.Helper:seekWidgetByName(root, "Text_amount_0")
    Text_amount_0:setString(_string_piece_info[217]..money)

    local Text_amount_content_0 = ccui.Helper:seekWidgetByName(root, "Text_amount_content_0")
    Text_amount_content_0:setString(game_money.."")

    -- google pay
    local Text_3 = ccui.Helper:seekWidgetByName(root, "Text_3")
    -- appale pay
    local Text_3_1 = ccui.Helper:seekWidgetByName(root, "Text_3_1")
    Text_3:setVisible(false)
    Text_3_1:setVisible(false)

    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) or (cc.PLATFORM_OS_MAC == targetPlatform) then
        Text_3_1:setVisible(true)
    else
        Text_3:setVisible(true)
    end

    self:onRefushBtn(1)
end

function RechargeSelectWindow:onRefushBtn(btnType)
    if self.m_type == btnType then 
        return
    end
    self.m_type = btnType
    if btnType == 1 then 
        self.Button_pay_1:setTouchEnabled(false)
        self.Button_pay_1:setHighlighted(true)
        self.Button_pay_2:setTouchEnabled(true)
        self.Button_pay_2:setHighlighted(false)
        self.Button_jz:setVisible(true)
        self.Button_jz_0:setVisible(false)
    else
        self.Button_pay_1:setTouchEnabled(true)
        self.Button_pay_1:setHighlighted(false)
        self.Button_pay_2:setTouchEnabled(false)
        self.Button_pay_2:setHighlighted(true)
        self.Button_jz:setVisible(false)
        self.Button_jz_0:setVisible(true)
    end
end

function RechargeSelectWindow:onInit(params)
    local csbItem = csb.createNode("activity/wonderful/recharge_web.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)
    self.Button_pay_1 = ccui.Helper:seekWidgetByName(root, "Button_pay_1")
    if self.Button_pay_1 then
        fwin:addTouchEventListener(
            self.Button_pay_1,
            nil,
            {
                terminal_name = "recharge_select_image_click",
                btn_type = 1,
                m_rechargeCallBack = params,
                terminal_state = 0,
                isPressedActionEnabled = false
            }
        )
    end

    self.Button_pay_2 = ccui.Helper:seekWidgetByName(root, "Button_pay_2")
    if self.Button_pay_2 then
        fwin:addTouchEventListener(
            self.Button_pay_2,
            nil,
            {
                terminal_name = "recharge_select_image_click",
                btn_type = 2,
                terminal_state = 0,
                m_rechargeCallBack = params,
                isPressedActionEnabled = false
            }
        )
    end

    self.Button_jz = ccui.Helper:seekWidgetByName(root, "Button_jz")
    if self.Button_jz then
        fwin:addTouchEventListener(
            self.Button_jz,
            nil,
            {
                terminal_name = "recharge_select_window_click",
                m_type = 1,
                m_rechargeCallBack = params,
                terminal_state = 0,
                isPressedActionEnabled = true
            }
        )
    end

    self.Button_jz_0 = ccui.Helper:seekWidgetByName(root, "Button_jz_0")
    if self.Button_jz_0 then
        fwin:addTouchEventListener(
            self.Button_jz_0,
            nil,
            {
                terminal_name = "recharge_select_window_click",
                m_type = 2,
                terminal_state = 0,
                m_rechargeCallBack = params,
                isPressedActionEnabled = true
            }
        )
    end

    local Button_close = ccui.Helper:seekWidgetByName(root, "Button_closed")
    fwin:addTouchEventListener(
            Button_close,
            nil,
            {
                terminal_name = "recharge_select_window_close",
                terminal_state = 0,
                m_rechargeCallBack = params,
                isPressedActionEnabled = false
            }
        )

    self:onUpdateDarw()
end



function RechargeSelectWindow:onEnterTransitionFinish()
end

function RechargeSelectWindow:onExit()
    state_machine.remove("recharge_select_window_click")
    state_machine.remove("recharge_select_image_click")
end
