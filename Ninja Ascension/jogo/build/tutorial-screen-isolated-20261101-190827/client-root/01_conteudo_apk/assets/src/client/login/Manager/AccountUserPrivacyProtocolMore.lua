
AccountUserPrivacyProtocolMore = class("AccountUserPrivacyProtocolMoreClass", Window)

local account_user_privacy_protocol_more_open_terminal = {
    _name = "account_user_privacy_protocol_more_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        fwin:close(fwin:find("AccountUserPrivacyProtocolMoreClass"))
        fwin:open(AccountUserPrivacyProtocolMore:new():init(params), fwin._display_log)
    	return true
    end,
    _terminal = nil,
    _terminals = nil
}

local account_user_privacy_protocol_more_close_terminal = {
    _name = "account_user_privacy_protocol_more_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        fwin:close(fwin:find("AccountUserPrivacyProtocolMoreClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(account_user_privacy_protocol_more_open_terminal)
state_machine.add(account_user_privacy_protocol_more_close_terminal)
state_machine.init()
    
function AccountUserPrivacyProtocolMore:ctor()
    self.super:ctor()
   	self.actions = {}
	self.roots = {}

    self.page_index = 0
    self.max_page = 0

    app.load("client.login.Manager.AccountUserPrivacyProtocolCell")
    local function init_account_user_privacy_protocol_more_terminal()
        local account_user_privacy_protocol_more_left_terminal = {
            _name = "account_user_privacy_protocol_more_left",
            _init = function (terminal) 
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.page_index = instance.page_index - 1
                instance.PageView:scrollToPage(instance.page_index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
    
        local account_user_privacy_protocol_more_right_terminal = {
            _name = "account_user_privacy_protocol_more_right",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.page_index = instance.page_index + 1
                instance.PageView:scrollToPage(instance.page_index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(account_user_privacy_protocol_more_left_terminal)
        state_machine.add(account_user_privacy_protocol_more_right_terminal)
        state_machine.init()
    end
    init_account_user_privacy_protocol_more_terminal()	
end

function AccountUserPrivacyProtocolMore:onUpdataDraw(index)
	local root = self.roots[1]
    local Text_tip = ccui.Helper:seekWidgetByName(root, "Text_tip")
    Text_tip:setString(user_privacy_protocol[index][1])
    local PageView_1 = ccui.Helper:seekWidgetByName(root, "PageView_1")
    PageView_1:removeAllChildren(true)
    for k,v in pairs(user_privacy_protocol[index]) do
        if k >= 2 then
            local cell = state_machine.excute("account_user_privacy_protocol_cell_create", 0, {user_privacy_protocol[index][k]})
            PageView_1:addPage(cell)
        end
        self.max_page = k - 1
    end
    self.page_index = PageView_1:getCurPageIndex()
    self:updateButton()
end

function AccountUserPrivacyProtocolMore:updateButton( ... )
    local root = self.roots[1]
    local Button_left = ccui.Helper:seekWidgetByName(root, "Button_left")
    local Button_right = ccui.Helper:seekWidgetByName(root, "Button_right")
    local Text_page = ccui.Helper:seekWidgetByName(root, "Text_page")
    Button_left:setVisible(true)
    Button_right:setVisible(true)
    if self.page_index == 0 then 
        Button_left:setVisible(false)
    end
    if self.page_index == self.max_page - 1 then
        Button_right:setVisible(false)
    end
    Text_page:setString((self.page_index + 1).."/"..self.max_page)
end

function AccountUserPrivacyProtocolMore:onEnterTransitionFinish()
	
end

function AccountUserPrivacyProtocolMore:init( index )
    local csbUserInfo = csb.createNode("login/register/register_prompt_7.csb")
    self:addChild(csbUserInfo)
    local root = csbUserInfo:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ok"),nil, 
    {
        terminal_name = "account_user_privacy_protocol_more_close",
        terminal_state = 0,
        isPressedActionEnabled = true
    },
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_left"), nil, 
    {
        terminal_name = "account_user_privacy_protocol_more_left", 
        terminal_state = 0, 
        isPressedActionEnabled = true
    },
    nil,0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_right"), nil, 
    {
        terminal_name = "account_user_privacy_protocol_more_right", 
        terminal_state = 0, 
        isPressedActionEnabled = true
    },
    nil,0)

    local PageView_1 = ccui.Helper:seekWidgetByName(root, "PageView_1")
    local function pageViewEventCallBack(sender, eventType)
        if eventType == ccui.PageViewEventType.turning then
            local currentPageIndex = sender:getCurPageIndex()
            currentPageIndex = tonumber(sender:getCurPageIndex() + 1)
            sender._self.page_index = currentPageIndex - 1
            sender._self:updateButton()
        end
    end
    PageView_1._self = self
    PageView_1:addEventListener(pageViewEventCallBack)
    PageView_1.callback = pageViewEventCallBack
    self.PageView = PageView_1

    self:onUpdataDraw(index)
    return self
end

function AccountUserPrivacyProtocolMore:onExit()
end
