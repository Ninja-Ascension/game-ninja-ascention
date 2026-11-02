--[[ ----------------------------------------------------------------------------
-- 充值修复窗口
--]] ----------------------------------------------------------------------------
RechargeRepairTip = class("RechargeRepairTipClass", Window)

-- 打开窗口
local recharge_repair_tip_window_open_terminal = {
	_name = "recharge_repair_tip_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("RechargeRepairTipClass") then
			fwin:open(RechargeRepairTip:new():init(params), fwin._windows)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local recharge_repair_tip_window_close_terminal = {
	_name = "recharge_repair_tip_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("RechargeRepairTipClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(recharge_repair_tip_window_open_terminal)
state_machine.add(recharge_repair_tip_window_close_terminal)
state_machine.init()

-- 构造器
function RechargeRepairTip:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize lim pool rule page state machine.
	local function init_recharge_repair_tip_terminal()
		-- 打开角色创建窗口
		local recharge_repair_tip_open_terminal = {
			_name = "recharge_repair_tip_open",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 关闭角色创建窗口
		local recharge_repair_tip_close_terminal = {
			_name = "recharge_repair_tip_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("recharge_repair_tip_window_close", 0, 0)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local recharge_repair_tip_show_terminal = {
			_name = "recharge_repair_tip_show",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 显示窗口
				if nil ~= instance then
					instance:setVisible(true)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 隐藏窗口
		local recharge_repair_tip_hide_terminal = {
			_name = "recharge_repair_tip_hide",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 隐藏窗口
				if nil ~= instance then
					instance:setVisible(false)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 下载
		local recharge_repair_tip_download_terminal = {
			_name = "recharge_repair_tip_download",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local url = dms.string(dms["user_config"], 19, user_config.param)
				handlePlatformRequest(0, CC_OPEN_URL, url)
				-- print("url = ", url)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(recharge_repair_tip_open_terminal)
		state_machine.add(recharge_repair_tip_close_terminal)
		state_machine.add(recharge_repair_tip_show_terminal)
		state_machine.add(recharge_repair_tip_hide_terminal)
		state_machine.add(recharge_repair_tip_download_terminal)
		state_machine.init()
	end
	-- call func init lim pool rule state machine.
	init_recharge_repair_tip_terminal()
end

-- 对象初始化
function RechargeRepairTip:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function RechargeRepairTip:onUpdateDraw()
	local root = self.roots[1]

	local Text_description_1 = ccui.Helper:seekWidgetByName(root, "Text_description_1")
	Text_description_1:setString(tipStringInfo_recharge_repair_tips[1])

	local Text_description_3 = ccui.Helper:seekWidgetByName(root, "Text_description_3")
	Text_description_3:setString(tipStringInfo_recharge_repair_tips[2])

	local urlStr = dms.string(dms["user_config"], 19, user_config.param)
	self.Text_description_2:setString(urlStr)
end

function RechargeRepairTip:onEnterTransitionFinish()
	-- 加载RechargeRepairTipWindow界面资源.
	-- res.shop.recharge_repair_tip = res/shop/shop_chongzhi_xiufu..csb
	local csbNode = csb.createNode("shop/shop_chongzhi_xiufu.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "recharge_repair_tip_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	-- 下载
	self.Button_download = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_download"), nil,
	{
		terminal_name = "recharge_repair_tip_download",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	self.Text_description_2 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Text_description_2"), nil, 
	{
		terminal_name = "recharge_repair_tip_download", 
		terminal_state = 0,
		isPressedActionEnabled = true
	},
	nil, 0)

	self:onUpdateDraw()
end

function RechargeRepairTip:onExit()
	-- 释放RechargeRepairTipWindow界面资源.
	state_machine.remove("recharge_repair_tip_open")
	state_machine.remove("recharge_repair_tip_close")
	state_machine.remove("recharge_repair_tip_show")
	state_machine.remove("recharge_repair_tip_hide")
	state_machine.remove("recharge_repair_tip_download")
end

function RechargeRepairTip:close()
	-- window event : close.
	
end

function RechargeRepairTip:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
