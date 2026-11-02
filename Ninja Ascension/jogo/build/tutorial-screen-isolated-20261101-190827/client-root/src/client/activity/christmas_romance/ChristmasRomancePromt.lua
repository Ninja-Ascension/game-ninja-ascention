--[[ ----------------------------------------------------------------------------
-- 消耗道具抽奖确认框
--]] ----------------------------------------------------------------------------
ChristmasRomancePromt = class("ChristmasRomancePromtClass", Window)

-- 打开窗口
local christmas_romance_promt_window_open_terminal = {
	_name = "christmas_romance_promt_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("ChristmasRomancePromtClass") then
			fwin:open(ChristmasRomancePromt:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local christmas_romance_promt_window_close_terminal = {
	_name = "christmas_romance_promt_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("ChristmasRomancePromtClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(christmas_romance_promt_window_open_terminal)
state_machine.add(christmas_romance_promt_window_close_terminal)
state_machine.init()

-- 构造器
function ChristmasRomancePromt:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._trunType = nil
	self._callBack = nil
	self._times = nil
	-- load lua files.

	-- Initialize christmas romance promt page state machine.
	local function init_christmas_romance_promt_terminal()
		-- 打开角色创建窗口
		local christmas_romance_promt_open_terminal = {
			_name = "christmas_romance_promt_open",
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
		local christmas_romance_promt_close_terminal = {
			_name = "christmas_romance_promt_close",
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

		-- 显示窗口
		local christmas_romance_promt_show_terminal = {
			_name = "christmas_romance_promt_show",
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
		local christmas_romance_promt_hide_terminal = {
			_name = "christmas_romance_promt_hide",
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

		-- 隐藏窗口
		local christmas_romance_promt_click_confirm_terminal = {
			_name = "christmas_romance_promt_click_confirm",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if params then 
					params._datas.mCallBack()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(christmas_romance_promt_open_terminal)
		state_machine.add(christmas_romance_promt_close_terminal)
		state_machine.add(christmas_romance_promt_show_terminal)
		state_machine.add(christmas_romance_promt_hide_terminal)
		state_machine.add(christmas_romance_promt_click_confirm_terminal)
		state_machine.init()
	end
	-- call func init christmas romance promt state machine.
	init_christmas_romance_promt_terminal()
end

-- 对象初始化
function ChristmasRomancePromt:init(params)
	-- 1:钻石转盘 2:幸运转盘 3.使用刷新券
	self._trunType = params.mTurnType
	self._times = params.mTimes
	self._callBack = params.mCallBack
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function ChristmasRomancePromt:onUpdateDraw()
	local root = self.roots[1]

	-- 使用抽奖卷 提示文本
	self.Text_tip = ccui.Helper:seekWidgetByName(root, "Text_tip")
	self.Text_tip:setVisible(false)
	-- 使用钻石 提示文本
	self.Text_tip_gem = ccui.Helper:seekWidgetByName(root, "Text_tip_gem")
	self.Text_tip_gem:setVisible(false)
	-- 使用刷新券 提示文本
	self.Text_tip_0 = ccui.Helper:seekWidgetByName(root, "Text_tip_0")
	self.Text_tip_0:setVisible(false)

	-- 抽奖卷icon
	self.Image_darw_choujiangquan = ccui.Helper:seekWidgetByName(root, "Image_darw_choujiangquan")
	self.Image_darw_choujiangquan:setVisible(false)

	-- 钻石icon
	self.Image_darw_gem = ccui.Helper:seekWidgetByName(root, "Image_darw_gem")
	self.Image_darw_gem:setVisible(false)
	-- 消耗钻石数量
	self.Text_gem_num = ccui.Helper:seekWidgetByName(root, "Text_gem_num")

	-- 刷新券icon
	self.Image_darw_shuaxinquan = ccui.Helper:seekWidgetByName(root, "Image_darw_shuaxinquan")
	self.Image_darw_shuaxinquan:setVisible(false)

	if self._trunType == 1 then 
		local needData = nil
        if self._times == 1 then
            needData = dms.string(dms["activity_config"], 87, activity_config.param)
        elseif self._times == 10 then
            needData = dms.string(dms["activity_config"], 88, activity_config.param)
        end
        local needNum = zstring.split(needData, ",")[3]
		self.Text_tip_gem:setString(string.format(tipStringInfo_christmas_romance_activity_tips[2],needNum))
		self.Text_gem_num:setString(needNum)
		self.Image_darw_gem:setVisible(true)
		self.Text_tip_gem:setVisible(true)
	elseif self._trunType == 2 then 
		self.Image_darw_choujiangquan:setVisible(true)
		self.Text_tip:setVisible(true)
	elseif self._trunType == 3 then
		self.Image_darw_shuaxinquan:setVisible(true)
		self.Text_tip_0:setVisible(true)
	end
end

function ChristmasRomancePromt:onEnterTransitionFinish()
	-- 加载ChristmasRomancePromtWindow界面资源.
	-- res.activity.christmas_romance.christmas_romance_promt = res/activity/christmas_romance/christmas_romance_promt.csb
	local csbNode = csb.createNode("activity/christmas_romance/christmas_romance_promt.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 取消
	self.Button_cancel = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cancel"), nil,
	{
		terminal_name = "christmas_romance_promt_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 前往
	self.Button_confirm = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_confirm"), nil,
	{
		terminal_name = "christmas_romance_promt_click_confirm",
		terminal_state = 0,
		isPressedActionEnabled = true,
		mCallBack = self._callBack,
	}, nil, 0)	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "christmas_romance_promt_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function ChristmasRomancePromt:onExit()
	-- 释放ChristmasRomancePromtWindow界面资源.
	state_machine.remove("christmas_romance_promt_open")
	state_machine.remove("christmas_romance_promt_close")
	state_machine.remove("christmas_romance_promt_show")
	state_machine.remove("christmas_romance_promt_hide")
	state_machine.remove("christmas_romance_promt_click_confirm")
end

function ChristmasRomancePromt:close()
	-- window event : close.
	
end

function ChristmasRomancePromt:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
