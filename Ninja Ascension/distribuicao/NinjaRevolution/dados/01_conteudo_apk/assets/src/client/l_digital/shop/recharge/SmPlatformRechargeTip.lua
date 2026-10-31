-- ----------------------------------------------------------------------------------------------------
-- 说明：火影充值提示界面
-------------------------------------------------------------------------------------------------------
SmPlatformRechargeTip = class("SmPlatformRechargeTipClass", Window)

local sm_platform_recharge_tip_open_terminal = {
    _name = "sm_platform_recharge_tip_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	local SmPlatformRechargeTipWindow = fwin:find("SmPlatformRechargeTipClass")
    	if SmPlatformRechargeTipWindow ~= nil then
    		SmPlatformRechargeTipWindow:setVisible(true)
    		return
    	end
    	local page = SmPlatformRechargeTip:new():init(params)
    	fwin:open(page , fwin._windows)
		return page
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_platform_recharge_tip_open_terminal)
state_machine.init()

function SmPlatformRechargeTip:ctor()
    self.super:ctor()
    self.roots = {}
	
    local function init_sm_platform_recharge_tip_terminal()
	
		--返回充值界面
		local sm_platform_recharge_tip_show_recharge_terminal = {
            _name = "sm_platform_recharge_tip_show_recharge",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local m_index = zstring.tonumber(params._datas.number)
				state_machine.excute("platform_request_for_payment", 0, m_index)
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--
		local sm_platform_recharge_tip_close_terminal = {
            _name = "sm_platform_recharge_tip_close",
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

		state_machine.add(sm_platform_recharge_tip_show_recharge_terminal)
		state_machine.add(sm_platform_recharge_tip_close_terminal)
        state_machine.init()
    end
    init_sm_platform_recharge_tip_terminal()
end

function SmPlatformRechargeTip:onUpdateDraw()
	local root = self.roots[1]
	--金币
	local Text_payment_gold_n = ccui.Helper:seekWidgetByName(root, "Text_payment_gold_n")
	Text_payment_gold_n:setString(self.gods)
	--美元
	local Text_payment_money = ccui.Helper:seekWidgetByName(root, "Text_payment_money")
	Text_payment_money:setString("$ "..self.money)
end

function SmPlatformRechargeTip:onInit()
	local csbVipPrilige = csb.createNode("utils/payment_prompt.csb")
    local root = csbVipPrilige:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbVipPrilige)
	
	--WEB充值
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_more_gold"), nil, 
	{
		terminal_name = "sm_platform_recharge_tip_show_recharge", 
		terminal_state = 0, 
		number = 1,
		isPressedActionEnabled = true
	},
	nil,0)
	--谷歌充值
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_google_pay"), nil, 
	{
		terminal_name = "sm_platform_recharge_tip_show_recharge", 
		terminal_state = 0, 
		number = 0,
		isPressedActionEnabled = true
	},
	nil,0)
	
	--关闭
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_payment_close"), nil, 
	{
		terminal_name = "sm_platform_recharge_tip_close", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil,0)

	self:onUpdateDraw()
end

function SmPlatformRechargeTip:init(params)
	self.money = params[1]
	self.gods = params[2]
	self:onInit()
	return self
end

function SmPlatformRechargeTip:onExit()
	state_machine.remove("sm_platform_recharge_tip_show_recharge")
end
