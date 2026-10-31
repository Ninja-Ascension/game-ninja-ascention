-- ----------------------------------------------------------------------------------------------------
-- 说明：smVIP权限查看界面
-------------------------------------------------------------------------------------------------------
SmVipPrivilegeDialog = class("SmVipPrivilegeDialogClass", Window)

local sm_vip_PrivilegeDialog_open_terminal = {
    _name = "sm_vip_PrivilegeDialog_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	local SmVipPrivilegeDialogWindow = fwin:find("SmVipPrivilegeDialogClass")
    	if SmVipPrivilegeDialogWindow ~= nil then
    		SmVipPrivilegeDialogWindow:setVisible(true)
    		return
    	end
    	local page = SmVipPrivilegeDialog:new():init(params)
    	fwin:open(page , fwin._windows)
		return page
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(sm_vip_PrivilegeDialog_open_terminal)
state_machine.init()

function SmVipPrivilegeDialog:ctor()
    self.super:ctor()
    self.roots = {}
    self.page_index = 0
    self.PageView = nil
    self._maxVIPLevel = tonumber(_vip_max_grade[1])
	app.load("client.l_digital.shop.recharge.SmVipPrivilegeDialogPage")
    local function init_sm_vipPrilige_terminal()
	
		--返回充值界面
		local sm_vip_prilige_show_recharge_terminal = {
            _name = "sm_vip_prilige_show_recharge",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local _Window = fwin:find("RechargeDialogClass")
				--local Panel_vip_tab = ccui.Helper:seekWidgetByName(_Window.roots[1], "Panel_vip_tab")
				local ScrollView_1 = ccui.Helper:seekWidgetByName(_Window.roots[1], "ScrollView_1")
				local Button_2 = ccui.Helper:seekWidgetByName(_Window.roots[1], "Button_2")
				Button_2:setVisible(true)
				ScrollView_1:setVisible(true)
				--Panel_vip_tab:setVisible(false)
				instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--左
		local sm_vip_prilige_to_left_terminal = {
            _name = "sm_vip_prilige_to_left",
            _init = function (terminal) 
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance.page_index = instance.page_index - 1
				instance.PageView:scrollToPage(instance.page_index)
				-- instance:updateButton()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--右
		local sm_vip_prilige_to_right_terminal = {
            _name = "sm_vip_prilige_to_right",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance.page_index = instance.page_index + 1
            	instance.PageView:scrollToPage(instance.page_index)
				-- instance:updateButton()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--刷新领取按钮
		local sm_vip_prilige_update_page_button_terminal = {
            _name = "sm_vip_prilige_update_page_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local page_array = instance.PageView:getPages()
            	for i , v in pairs(page_array) do 
            		v:updateDrawButton(v)
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		local sm_vip_prilige_update_change_page_terminal = {
            _name = "sm_vip_prilige_update_change_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local vip_grade = params[1]
            	instance.page_index = vip_grade - 1
            	instance.PageView:scrollToPage(instance.page_index)
				-- instance:updateButton()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(sm_vip_prilige_show_recharge_terminal)
		state_machine.add(sm_vip_prilige_to_left_terminal)
		state_machine.add(sm_vip_prilige_to_right_terminal)
		state_machine.add(sm_vip_prilige_update_page_button_terminal)
		state_machine.add(sm_vip_prilige_update_change_page_terminal)
        state_machine.init()
    end
    init_sm_vipPrilige_terminal()
end

function SmVipPrivilegeDialog:onUpdateDraw()
	local root = self.roots[1]
	local PageView_vip_n = ccui.Helper:seekWidgetByName(root, "PageView_vip_n")
	PageView_vip_n:setTouchEnabled(false)
	PageView_vip_n:removeAllChildren(true)
	local vip = {}
	vip[1] = _vip_privilege_info.privilege_one
	vip[2] = _vip_privilege_info.privilege_two
	vip[3] = _vip_privilege_info.privilege_three
	vip[4] = _vip_privilege_info.privilege_four
	vip[5] = _vip_privilege_info.privilege_five
	vip[6] = _vip_privilege_info.privilege_six
	vip[7] = _vip_privilege_info.privilege_seven
	vip[8] = _vip_privilege_info.privilege_eight
	vip[9] = _vip_privilege_info.privilege_nine
	vip[10] = _vip_privilege_info.privilege_ten
	vip[11] = _vip_privilege_info.privilege_eleven
	vip[12] = _vip_privilege_info.privilege_twelve
	vip[13] = _vip_privilege_info.privilege_thirteen
	vip[14] = _vip_privilege_info.privilege_fourteen
	vip[15] = _vip_privilege_info.privilege_fifteen
	vip[16] = _vip_privilege_info.privilege_sixteen
	vip[17] = _vip_privilege_info.privilege_seventeen
	vip[18] = _vip_privilege_info.privilege_eighteen
	if _vip_privilege_info.privilege_nineteen then 
		vip[19] = _vip_privilege_info.privilege_nineteen
	end
	if _vip_privilege_info.privilege_twenty then 
		vip[20] = _vip_privilege_info.privilege_twenty
	end
	for i = 1, self._maxVIPLevel do
		if vip[i] ~= nil then
			local page = SmVipPrivilegeDialogPage:createCell()
			page:init(i , vip[i])
			PageView_vip_n:addPage(page)
		end
	end
	self.page_index = PageView_vip_n:getCurPageIndex()
	self.PageView = PageView_vip_n
	self.page_index = tonumber(_ED.vip_grade) - 1
	self.page_index = math.max(0 , self.page_index)
	self.PageView:scrollToPage(self.page_index)
	self.PageView:getPage(self.page_index):load()
	self:updateButton()
end

function SmVipPrivilegeDialog:updateButton()
	local root = self.roots[1]
	local Button_72860 = ccui.Helper:seekWidgetByName(root, "Button_72860")
	local Button_72861 = ccui.Helper:seekWidgetByName(root, "Button_72861")
	Button_72860:setVisible(true)
	Button_72861:setVisible(true)
	if self.page_index == 0 then 
		Button_72860:setVisible(false)
	elseif self.page_index == self._maxVIPLevel - 1 then
		Button_72861:setVisible(false)
	end
end

function SmVipPrivilegeDialog:onInit()
	local csbVipPrilige = csb.createNode("player/vip_privileges.csb")
    local root = csbVipPrilige:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbVipPrilige)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, 
	{
		terminal_name = "sm_vip_prilige_show_recharge", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil,0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_72860"), nil, 
	{
		terminal_name = "sm_vip_prilige_to_left", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil,0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_72861"), nil, 
	{
		terminal_name = "sm_vip_prilige_to_right", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil,0)

	local PageView_vip_n = ccui.Helper:seekWidgetByName(root, "PageView_vip_n")
	local function pageViewEventCallBack(sender, eventType)
        if eventType == ccui.PageViewEventType.turning then
            local currentPageIndex = sender:getCurPageIndex()
            if self._maxVIPLevel == currentPageIndex then
            	return
            end
            currentPageIndex = tonumber(sender:getCurPageIndex() + 1)
			for k,v in pairs(sender:getPages()) do
				v:unLoad()
			end
			sender:getPage(currentPageIndex-1):load()
			sender._self.page_index = currentPageIndex - 1
			sender._self:updateButton()
        end
    end
    PageView_vip_n._self = self
	PageView_vip_n:addEventListener(pageViewEventCallBack)
	PageView_vip_n.callback = pageViewEventCallBack

	self:onUpdateDraw()
end

function SmVipPrivilegeDialog:init(params)
	-- local _Window = params
	-- self._rootWindows = _Window
	self:onInit()
	return self
end

function SmVipPrivilegeDialog:onExit()
	state_machine.remove("sm_vip_prilige_show_recharge")
	state_machine.remove("sm_vip_prilige_to_right")
	state_machine.remove("sm_vip_prilige_to_left")
	state_machine.remove("sm_vip_prilige_update_page_button")
	state_machine.remove("sm_vip_prilige_update_change_page")
end
