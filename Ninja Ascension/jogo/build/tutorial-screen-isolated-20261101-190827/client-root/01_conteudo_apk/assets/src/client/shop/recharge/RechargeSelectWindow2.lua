-----------------------------
--DSC原生充值、第三方充值选择界面
-----------------------------
RechargeSelectWindow2 = class("RechargeSelectWindow2Class", Window)

local recharge_select_window2_open_terminal = {
    _name = "recharge_select_window2_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("RechargeSelectWindow2Class") == nil then
            fwin:open(RechargeSelectWindow2:new():init(params), fwin._dialog)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local recharge_select_window2_close_terminal = {
    _name = "recharge_select_window2_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.unlock("recharge_list_button")
        fwin:close(fwin:find("RechargeSelectWindow2Class"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(recharge_select_window2_open_terminal)
state_machine.add(recharge_select_window2_close_terminal)
state_machine.init()

function RechargeSelectWindow2:ctor()
    self.super:ctor()
    self.roots = {}

    self.btnType = 0

    self.paySelectButtonList = {}
    self.payButtonList = {}

    local function init_recharge_select_window2_cell_terminal()
        local recharge_select_window2_click_terminal = {
            _name = "recharge_select_window2_click",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and params ~= nil then
                    local mType = params._datas.m_type
                    local rechargeType = RechargeTypeEnum.Google
                    if mType == 1 then
                        rechargeType = RechargeTypeEnum.Google
                    elseif mType == 2 then
                        rechargeType = RechargeTypeEnum.Paypal
                    elseif mType == 3 then
                        rechargeType = RechargeTypeEnum.Stripe
                    end

                    params._datas.m_rechargeCallBack(rechargeType)
                    state_machine.excute("recharge_select_window2_close", 0, "")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local recharge_select_window2_image_click_terminal = {
            _name = "recharge_select_window2_image_click",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then 
                    local btnType = params._datas.btn_type
                    instance:onRefushBtn(btnType)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(recharge_select_window2_click_terminal)
        state_machine.add(recharge_select_window2_image_click_terminal)
        state_machine.init()
    end
    init_recharge_select_window2_cell_terminal()
end

function RechargeSelectWindow2:init(params)
    self:onInit(params)
    return self
end


function RechargeSelectWindow2:onUpdateDarw()
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

    self.Text_38 = ccui.Helper:seekWidgetByName(root, "Text_38")

    self:onRefushBtn(1)
end

function RechargeSelectWindow2:onRefushBtn(btnType)
    if self.btnType == btnType then
        return
    end
    self.btnType = btnType

    for i = 1, 3 do
        local paySelectButton = self.paySelectButtonList[i]
        local payButton = self.payButtonList[i]

        paySelectButton:setTouchEnabled(i ~= btnType)
        paySelectButton:setHighlighted(i == btnType)

        payButton:setVisible(i == btnType)
    end

    self.Text_38:setVisible(btnType ~= 1)
end

function RechargeSelectWindow2:onInit(params)
    local csbItem = csb.createNode("activity/wonderful/recharge_web_1.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    -- 选择按钮
    self.paySelectButtonList = {}
    for i = 1, 3 do
        local index = i - 1
        local paySelectButton = ccui.Helper:seekWidgetByName(root, "Button_pay_"..index)
        fwin:addTouchEventListener(
            paySelectButton,
            nil,
            {
                terminal_name = "recharge_select_window2_image_click",
                btn_type = i,
                terminal_state = 0,
                isPressedActionEnabled = false
            }
        )
        self.paySelectButtonList[i] = paySelectButton
    end

    -- 拉起支付按钮
    self.payButtonList = {}
    for i = 1, 3 do
        local index = i - 1
        local payButton = ccui.Helper:seekWidgetByName(root, "Button_jz_"..index)
        fwin:addTouchEventListener(
            payButton,
            nil,
            {
                terminal_name = "recharge_select_window2_click",
                m_type = i,
                m_rechargeCallBack = params,
                terminal_state = 0,
                isPressedActionEnabled = true
            }
        )
        self.payButtonList[i] = payButton
    end

    local Button_close = ccui.Helper:seekWidgetByName(root, "Button_closed")
    fwin:addTouchEventListener(
        Button_close,
        nil,
        {
            terminal_name = "recharge_select_window2_close",
            terminal_state = 0,
            isPressedActionEnabled = false
        }
    )

    self:onUpdateDarw()
end



function RechargeSelectWindow2:onEnterTransitionFinish()
end

function RechargeSelectWindow2:onExit()
    state_machine.remove("recharge_select_window2_click")
    state_machine.remove("recharge_select_window2_image_click")
end
