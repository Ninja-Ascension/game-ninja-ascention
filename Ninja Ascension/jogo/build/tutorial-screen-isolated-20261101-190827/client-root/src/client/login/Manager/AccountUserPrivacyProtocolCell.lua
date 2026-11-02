
AccountUserPrivacyProtocolCell = class("AccountUserPrivacyProtocolCellClass", Window)
AccountUserPrivacyProtocolCell.__size = nil

local account_user_privacy_protocol_cell_create_terminal = {
    _name = "account_user_privacy_protocol_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = AccountUserPrivacyProtocolCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(account_user_privacy_protocol_cell_create_terminal)
state_machine.init()

function AccountUserPrivacyProtocolCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._info = ""   
end

function AccountUserPrivacyProtocolCell:onUpdateDraw()
    local root = self.roots[1]
    ccui.Helper:seekWidgetByName(root, "Text_content"):setString(self._info)
end

function AccountUserPrivacyProtocolCell:onEnterTransitionFinish()
end

function AccountUserPrivacyProtocolCell:onInit()
    local csbUserInfo = csb.createNode("login/register/register_prompt_8.csb")
    self:addChild(csbUserInfo)
    local root = csbUserInfo:getChildByName("root")
    table.insert(self.roots, root)
    
    if AccountUserPrivacyProtocolCell.__size == nil then
        AccountUserPrivacyProtocolCell.__size = root:getContentSize()
    end

    self:onUpdateDraw()
end

function AccountUserPrivacyProtocolCell:onExit()
end

function AccountUserPrivacyProtocolCell:init(params)
    self._info = params[1]
    self:onInit()
    self:setContentSize(AccountUserPrivacyProtocolCell.__size)
end

