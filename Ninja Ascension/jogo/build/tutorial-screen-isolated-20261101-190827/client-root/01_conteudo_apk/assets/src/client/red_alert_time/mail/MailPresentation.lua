-----------------------------
--邮件报告窗口
-----------------------------
MailPresentation = class("MailPresentationClass", Window)

local mail_presentation_window_open_terminal = {
    _name = "mail_presentation_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = MailPresentation:new():init(params)
        fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(mail_presentation_window_open_terminal)
state_machine.init()

function MailPresentation:ctor()
    self.super:ctor()
    self.roots = {}
    
    self._current_page = 0
	self._attack = nil
    self._defensive = nil
    self._investigation = nil
	
	app.load("client.red_alert_time.mail.MailPresentationAttack")
	app.load("client.red_alert_time.mail.MailPresentationDefensive")
	app.load("client.red_alert_time.mail.MailPresentationInvestigation")
	app.load("client.red_alert_time.mail.MailInvestigationInfo")

    local function init_mail_presentation_terminal()
		--显示界面
		local mail_presentation_show_terminal = {
            _name = "mail_presentation_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--隐藏界面
		local mail_presentation_hide_terminal = {
            _name = "mail_presentation_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	

        local mail_presentation_change_page_terminal = {
            _name = "mail_presentation_change_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:changeSelectPage(params._datas._page)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        local mail_presentation_update_draw_terminal = {
            _name = "mail_presentation_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

		state_machine.add(mail_presentation_show_terminal)	
		state_machine.add(mail_presentation_hide_terminal)
        state_machine.add(mail_presentation_change_page_terminal)
        state_machine.add(mail_presentation_update_draw_terminal)
        state_machine.init()
    end
    init_mail_presentation_terminal()
end

function MailPresentation:onHide()
    self:setVisible(false)
end

function MailPresentation:onShow()
    self:setVisible(true)
end

function MailPresentation:changeSelectPage( page )
    local root = self.roots[1]
	local Panel_presentation_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_presentation_tab_box")
    local Button_presentation_attack = ccui.Helper:seekWidgetByName(root, "Button_presentation_attack")
    local Button_presentation_defense = ccui.Helper:seekWidgetByName(root, "Button_presentation_defense")
    local Button_presentation_spy = ccui.Helper:seekWidgetByName(root, "Button_presentation_spy")
    Button_presentation_attack:setHighlighted(false)
    Button_presentation_defense:setHighlighted(false)
    Button_presentation_spy:setHighlighted(false)
    if page == 1 then
        Button_presentation_attack:setHighlighted(true)
    elseif page == 2 then
        Button_presentation_defense:setHighlighted(true)
    else
        Button_presentation_spy:setHighlighted(true)
    end
    if page == self._current_page then
        return
    end
    self._current_page = page
    state_machine.excute("mail_presentation_attack_hide", 0, nil)
    state_machine.excute("mail_presentation_defensive_hide", 0, nil)
    state_machine.excute("mail_presentation_investigation_hide", 0, nil)
	if page == 1 then
        Button_presentation_attack:setHighlighted(true)
        if self._attack == nil then
            self._attack = state_machine.excute("mail_presentation_attack_window_open", 0, {Panel_presentation_tab_box})
        else
            state_machine.excute("mail_presentation_attack_show", 0, nil)
        end
		state_machine.excute("mail_type_assignment", 0, 200)
	elseif page == 2 then 
		Button_presentation_defense:setHighlighted(true)
        if self._defensive == nil then
            self._defensive = state_machine.excute("mail_presentation_defensive_window_open", 0, {Panel_presentation_tab_box})
		else
			 state_machine.excute("mail_presentation_defensive_show", 0, nil)	
        end
		state_machine.excute("mail_type_assignment", 0, 1200)
    else
		Button_presentation_spy:setHighlighted(true)
        if self._investigation == nil then
            self._investigation = state_machine.excute("mail_presentation_investigation_window_open", 0, {Panel_presentation_tab_box})
		else
			state_machine.excute("mail_presentation_investigation_show", 0, nil)
        end
		state_machine.excute("mail_type_assignment", 0, 10002)
	end

end

function MailPresentation:onEnterTransitionFinish()

end

function MailPresentation:onInit( )
    local csbItem = csb.createNode(config_csb.mail.mail_presentation_tab)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_presentation_attack"), nil, 
    {
        terminal_name = "mail_presentation_change_page", 
        terminal_state = 0, 
        _page = 1,
    }, nil, 1)
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_mine_report_attack",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_presentation_attack"),
	_m_type = 1,
    _invoke = nil,
    _interval = 0.1,})

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_presentation_defense"), nil, 
    {
        terminal_name = "mail_presentation_change_page", 
        terminal_state = 0, 
        _page = 2,
    }, nil, 1)
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_mine_report_defense",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_presentation_defense"),
	_m_type = 2,
    _invoke = nil,
    _interval = 0.1,})

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_presentation_spy"), nil, 
    {
        terminal_name = "mail_presentation_change_page", 
        terminal_state = 0, 
        _page = 3,
    }, nil, 1)
	-- state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_mine_report_scout",
 --    _widget = ccui.Helper:seekWidgetByName(root, "Button_presentation_spy"),
	-- _m_type = 3,
 --    _invoke = nil,
 --    _interval = 0.1,})

	self:changeSelectPage(1)
end

function MailPresentation:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow      
	self:onInit()
    return self
end

function MailPresentation:onExit()
    state_machine.remove("mail_presentation_show")
    state_machine.remove("mail_presentation_hide")
    state_machine.remove("mail_presentation_change_page")
    state_machine.remove("mail_presentation_update_draw")
end
