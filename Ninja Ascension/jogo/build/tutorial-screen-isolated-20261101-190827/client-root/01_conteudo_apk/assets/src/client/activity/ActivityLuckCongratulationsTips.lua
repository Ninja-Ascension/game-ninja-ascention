--[[ ----------------------------------------------------------------------------
-- 幸运占卜一次窗口界面
--]] ----------------------------------------------------------------------------
ActivityLuckCongratulationsTips = class("ActivityLuckCongratulationsTipsClass", Window)

-- 打开窗口
local activity_luck_congratulations_tips_window_open_terminal = {
	_name = "activity_luck_congratulations_tips_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("ActivityLuckCongratulationsTipsClass") then
			fwin:open(ActivityLuckCongratulationsTips:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local activity_luck_congratulations_tips_window_close_terminal = {
	_name = "activity_luck_congratulations_tips_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("ActivityLuckCongratulationsTipsClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(activity_luck_congratulations_tips_window_open_terminal)
state_machine.add(activity_luck_congratulations_tips_window_close_terminal)
state_machine.init()

-- 构造器
function ActivityLuckCongratulationsTips:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.awardPos = {}

	-- load lua files.
	app.load("client.cells.activity.activity_daily_icon_cell")

	-- Initialize activity luck congratulations tips page state machine.
	local function init_activity_luck_congratulations_tips_terminal()
		-- 打开角色创建窗口
		local activity_luck_congratulations_tips_open_terminal = {
			_name = "activity_luck_congratulations_tips_open",
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
		local activity_luck_congratulations_tips_close_terminal = {
			_name = "activity_luck_congratulations_tips_close",
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
		local activity_luck_congratulations_tips_show_terminal = {
			_name = "activity_luck_congratulations_tips_show",
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
		local activity_luck_congratulations_tips_hide_terminal = {
			_name = "activity_luck_congratulations_tips_hide",
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


		local activity_luck_congratulations_tips_bagani_terminal = {
			_name = "activity_luck_congratulations_tips_bagani",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
					local textdata=decideWhichPropIsFullFunc(instance.reworlds)
					if table.nums(instance.awardPos)>0 and textdata == "" then
						playAnimationToBag(instance.awardPos)
					end
				state_machine.excute("props_bag_refresh_bag_data", 0,{1})
				state_machine.excute("activity_luck_congratulations_tips_window_close",0,0)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 前往邮件
		local activity_luck_congratulations_gomail_terminal = {
			_name = "activity_luck_congratulations_gomail",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
					state_machine.excute("mail_home_window_open", 0, "")
					state_machine.excute("activity_luck_congratulations_tips_window_close", 0, "")
					state_machine.excute("activity_luck_frame_window_close", 0, "")
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(activity_luck_congratulations_gomail_terminal)
		state_machine.add(activity_luck_congratulations_tips_bagani_terminal)
		state_machine.add(activity_luck_congratulations_tips_open_terminal)
		state_machine.add(activity_luck_congratulations_tips_close_terminal)
		state_machine.add(activity_luck_congratulations_tips_show_terminal)
		state_machine.add(activity_luck_congratulations_tips_hide_terminal)
		state_machine.init()
	end
	-- call func init activity luck congratulations tips state machine.
	init_activity_luck_congratulations_tips_terminal()
end

-- 对象初始化
function ActivityLuckCongratulationsTips:init(params)
	if params ~= nil and params.isCat ~= nil then 
		self.isCat = params.isCat or nil 
		self.rewardStr = params.rewardStr or nil
	end
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function ActivityLuckCongratulationsTips:onUpdateDraw()
	local root = self.roots[1]
	-- 获得奖励滚动容器
	self.ScrollView_luck_award_content = ccui.Helper:seekWidgetByName(root, "ScrollView_luck_award_content")

	if self.rewardStr == nil then
		self.reworlds = zstring.splits(_ED.divinationInfo.DrawReward, "|",",")
	else
		self.reworlds = zstring.splits(self.rewardStr, "|",",")
	end
	-- self.reworlds = zstring.splits("1,1001,100|2,94,1", "|",",")
	
	local size = self.ScrollView_luck_award_content:getContentSize()
	local line = math.floor(table.nums(self.reworlds)/6)
	if line < 2 then
		line = 2
	end
	self.ScrollView_luck_award_content:setInnerContainerSize(cc.size(size.width, 85*line))
	local dis = 5
	local wid = 80
	for i = 1, table.nums(self.reworlds) do 
		local x = 0
		local y = 0
		if (i % 6) == 0 then
			x = 5*(dis+wid)+dis
		else
			x = (i % 6-1)*(dis+wid)+dis
		end			
		local curLine = line - math.floor((i-1)/6)
		if curLine == 1 then
			y = dis
		else
			y = (curLine-1)*(dis+wid)+dis
		end		
		cell = state_machine.excute("activity_daily_icon_cell_create", 0, {self.reworlds[i]})
		cell:setPosition(cc.p(x,y))
		if tonumber(self.reworlds[i][1]) == 4 then
			table.insert(self.awardPos,cell)
		end
		self.ScrollView_luck_award_content:addChild(cell)
	end

	local textdata=decideWhichPropIsFullFunc(self.reworlds)
	if textdata~="" then
		self.Button_luck_get:setVisible(true)
	else
		self.Button_luck_get:setVisible(false)
		self.Button_luck_confirm:setPositionX(self.roots[1]:getContentSize().width/2)
	end
end

function ActivityLuckCongratulationsTips:onEnterTransitionFinish()
	-- 加载ActivityLuckCongratulationsTipsWindow界面资源.
	-- res.activity.activity_luck_congratulations_tips = res/activity/activity_luck_congratulations_tips.csb
	local csbNode = csb.createNode("Lucky/activity_luck_congratulations_tips.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 确定按键
	self.Button_luck_confirm = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_luck_confirm"), nil,
	{
		terminal_name = "activity_luck_congratulations_tips_bagani",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)
	if self.Button_luck_confirm_x == nil then
		self.Button_luck_confirm_x = self.Button_luck_confirm:getPositionX()
	end

	-- 前往邮件
	self.Button_luck_get = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_luck_get"), nil,
	{
		terminal_name = "activity_luck_congratulations_gomail",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	if self.isCat ~= nil and self.isCat == true then
		self.Button_luck_get:setVisible(false)
		self.Button_luck_confirm:setPositionX(320)
	else
		self.Button_luck_get:setVisible(true)
		self.Button_luck_confirm:setPositionX(self.Button_luck_confirm_x)
	end

	self:onUpdateDraw()
end

function ActivityLuckCongratulationsTips:onExit()
	-- 释放ActivityLuckCongratulationsTipsWindow界面资源.
	state_machine.remove("activity_luck_congratulations_tips_open")
	state_machine.remove("activity_luck_congratulations_tips_close")
	state_machine.remove("activity_luck_congratulations_tips_show")
	state_machine.remove("activity_luck_congratulations_tips_hide")
	state_machine.remove("activity_luck_congratulations_tips_bagani")
	state_machine.remove("activity_luck_congratulations_gomail")
end

function ActivityLuckCongratulationsTips:close()
	-- window event : close.
	
end

function ActivityLuckCongratulationsTips:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
