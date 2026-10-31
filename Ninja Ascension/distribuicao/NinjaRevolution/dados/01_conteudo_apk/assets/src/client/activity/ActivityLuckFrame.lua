--[[ ----------------------------------------------------------------------------
-- 幸运占卜框界面
--]] ----------------------------------------------------------------------------
ActivityLuckFrame = class("ActivityLuckFrameClass", Window)

-- 打开窗口
local activity_luck_frame_window_open_terminal = {
	_name = "activity_luck_frame_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("ActivityLuckFrameClass") then
			fwin:open(ActivityLuckFrame:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local activity_luck_frame_window_close_terminal = {
	_name = "activity_luck_frame_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("ActivityLuckFrameClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(activity_luck_frame_window_open_terminal)
state_machine.add(activity_luck_frame_window_close_terminal)
state_machine.init()

-- 构造器
function ActivityLuckFrame:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.titles = {}
	self.buttons = {}
	self.prePage = 1
	self.curPage = 1
	-- var

	-- load lua files.
	app.load("client.activity.ActivityLuckDivination")
	app.load("client.activity.ActivityLuckAward")
	app.load("client.activity.ActivityLuckRank")
	app.load("client.activity.ActivityLuckTimeTips")
	app.load("client.activity.ActivityLuckRule")
	
	
	-- Initialize activity luck frame page state machine.
	local function init_activity_luck_frame_terminal()
		-- 打开角色创建窗口
		local activity_luck_frame_open_terminal = {
			_name = "activity_luck_frame_open",
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
		local activity_luck_frame_close_terminal = {
			_name = "activity_luck_frame_close",
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
		local activity_luck_frame_show_terminal = {
			_name = "activity_luck_frame_show",
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
		local activity_luck_frame_hide_terminal = {
			_name = "activity_luck_frame_hide",
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

		-- 切换tab
		local activity_luck_change_page_terminal = {
			_name = "activity_luck_change_page",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				self.prePage = self.curPage
				self.curPage = tonumber(params._datas.page)
				instance:changePage()
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		

		state_machine.add(activity_luck_frame_open_terminal)
		state_machine.add(activity_luck_frame_close_terminal)
		state_machine.add(activity_luck_frame_show_terminal)
		state_machine.add(activity_luck_frame_hide_terminal)
		state_machine.add(activity_luck_change_page_terminal)
		state_machine.init()
	end
	-- call func init activity luck frame state machine.
	init_activity_luck_frame_terminal()
end

-- 对象初始化
function ActivityLuckFrame:init(params)
	-- debug.log(_ED.activityLuckInfo)
	-- debug.log(_ED.divine_reward_info)
	-- debug.log(_ED.divinationInfo)
	
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function ActivityLuckFrame:onUpdateDraw()
	local root = self.roots[1]

	-- 幸运占卜标题做显示隐藏
	self.Text_luck_divination_title = ccui.Helper:seekWidgetByName(root, "Text_luck_divination_title")
	table.insert(self.titles,self.Text_luck_divination_title)
	
	-- 排行榜标题做显示隐藏
	self.Text_luck_rank_title = ccui.Helper:seekWidgetByName(root, "Text_luck_rank_title")
	table.insert(self.titles,self.Text_luck_rank_title)

	-- 幸运大奖标题做显示隐藏
	self.Text_luck_prize_title = ccui.Helper:seekWidgetByName(root, "Text_luck_prize_title")
	table.insert(self.titles,self.Text_luck_prize_title)

	-- 排名奖励标题做显示隐藏
	self.Text_luck_rank_award_title = ccui.Helper:seekWidgetByName(root, "Text_luck_rank_award_title")
	table.insert(self.titles,self.Text_luck_rank_award_title)

	-- 幸运占卜内容容器
	self.Panel_luck_content = ccui.Helper:seekWidgetByName(root, "Panel_luck_content")

end

function ActivityLuckFrame:onEnterTransitionFinish()
	-- 加载ActivityLuckFrameWindow界面资源.
	-- res.activity.activity_luck_frame = res/activity/activity_luck_frame.csb
	local csbNode = csb.createNode("Lucky/activity_luck_frame.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)
	-- 关闭按键
	self.Button_luck_close = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_luck_close"), nil,
	{
		terminal_name = "activity_luck_frame_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 幸运占卜按键
	self.Button_luck_divination = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_luck_divination"), nil,
	{
		terminal_name = "activity_luck_change_page",
		terminal_state = 0,
		isPressedActionEnabled = true,
		page = 1
	}, nil, 0)
	table.insert(self.buttons,self.Button_luck_divination)
	-- 排行榜按键
	self.Button_luck_rank = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_luck_rank"), nil,
	{
		terminal_name = "activity_luck_change_page",
		terminal_state = 0,
		isPressedActionEnabled = true,
		page = 2
	}, nil, 0)	
	table.insert(self.buttons,self.Button_luck_rank)

	-- 幸运大奖按键
	self.Button_luck_prize = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_luck_prize"), nil,
	{
		terminal_name = "activity_luck_change_page",
		terminal_state = 0,
		isPressedActionEnabled = true,
		page = 3
	}, nil, 0)	
	table.insert(self.buttons,self.Button_luck_prize)

	-- 排行奖励按键
	self.Button_luck_award = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_luck_award"), nil,
	{
		terminal_name = "activity_luck_change_page",
		terminal_state = 0,
		isPressedActionEnabled = true,
		page = 4
	}, nil, 0)	
	table.insert(self.buttons,self.Button_luck_award)


	self:onUpdateDraw()
	self:changePage()
end
-- 切页
function ActivityLuckFrame:changePage()
	self.titles[self.prePage]:setVisible(false)
	self.titles[self.curPage]:setVisible(true)
	self.buttons[self.prePage]:setHighlighted(false)
	self.buttons[self.prePage]:setTouchEnabled(true)

	self.buttons[self.curPage]:setHighlighted(true)
	self.buttons[self.curPage]:setTouchEnabled(false)
	if self.prePage == 1 then
		state_machine.excute("activity_luck_divination_hide", 0, 0)
	elseif self.prePage == 2 then
		state_machine.excute("activity_luck_rank_hide", 0, 0)
	elseif self.prePage == 3 then
		state_machine.excute("activity_luck_award_hide", 0,0)
	elseif self.prePage == 4 then
		state_machine.excute("activity_luck_award_hide", 0,0)
	end
	if self.curPage == 1 then
		state_machine.excute("activity_luck_divination_window_open", 0, {self.Panel_luck_content})
	elseif self.curPage == 2 then
		state_machine.excute("activity_luck_rank_window_open", 0, {self.Panel_luck_content})
	elseif self.curPage == 3 then--幸运奖励
		state_machine.excute("activity_luck_award_window_open", 0, {self.Panel_luck_content,1})
	elseif self.curPage == 4 then--排名奖励
		state_machine.excute("activity_luck_award_window_open", 0, {self.Panel_luck_content,2})
	end
end

function ActivityLuckFrame:onExit()
	-- 释放ActivityLuckFrameWindow界面资源.
	state_machine.remove("activity_luck_frame_open")
	state_machine.remove("activity_luck_frame_close")
	state_machine.remove("activity_luck_frame_show")
	state_machine.remove("activity_luck_frame_hide")
	state_machine.remove("activity_luck_change_page")
	
end

function ActivityLuckFrame:close()
	-- window event : close.
	
end

function ActivityLuckFrame:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
