--[[ ----------------------------------------------------------------------------
-- 排重福袋主界面
--]] ----------------------------------------------------------------------------
FortuneBag = class("FortuneBagClass", Window)

-- 打开窗口
local fortune_bag_window_open_terminal = {
	_name = "fortune_bag_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("FortuneBagClass") then
			fwin:open(FortuneBag:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local fortune_bag_window_close_terminal = {
	_name = "fortune_bag_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("FortuneBagClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fortune_bag_window_open_terminal)
state_machine.add(fortune_bag_window_close_terminal)
state_machine.init()

-- 构造器
function FortuneBag:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.deltaTime = 1
	self.totalTime = 0
	self._activityEndTime = nil
	self._current_page = 0			-- 当前页面
	-- load lua files.
	app.load("client.cells.activity.april_fools_day_prop_exchange_cell")
	app.load("client.activity.fortune_bag.FortuneBagRule")
	app.load("client.activity.fortune_bag.fortunebaglist1")
	app.load("client.activity.fortune_bag.FortuneBagOpen")
	app.load("client.activity.fortune_bag.FortuneExchangeCell")
	app.load("client.activity.fortune_bag.FortunePushNotice")
	
	-- Initialize fortune bag page state machine.
	local function init_fortune_bag_terminal()

		-- 显示窗口
		local fortune_bag_show_terminal = {
			_name = "fortune_bag_show",
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
		local fortune_bag_hide_terminal = {
			_name = "fortune_bag_hide",
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

		-- 切换页签
		local fortune_bag_change_page_terminal = {
			_name = "fortune_bag_change_page",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local pageIndex = params._datas.page_index
				if instance then
					instance:changeToPage(pageIndex)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 刷新主界面
		local fortune_bag_refesh_windows_terminal = {
			_name = "fortune_bag_refesh_windows",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					instance:onInit()
					if params and params.m_page then
						local mPage = tonumber(params.m_page)
						instance._current_page = -1
						instance:changeToPage(mPage)
					end
					if state_machine.find("fortune_bag_open_refesh") ~= nil then
						state_machine.excute("fortune_bag_open_refesh",0,"")				
					end
					-- 刷新活动按钮红点
					state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 169)
					fwin:addService({
						callback = function ( params )
							state_machine.excute("notification_center_update", 0, "push_notification_fortune_bag_page_push")
							state_machine.excute("notification_center_update", 0, "push_notification_fortune_bag_page_push")
						end,
						delay = 0,
					})
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(fortune_bag_show_terminal)
		state_machine.add(fortune_bag_hide_terminal)
		state_machine.add(fortune_bag_change_page_terminal)
		state_machine.add(fortune_bag_refesh_windows_terminal)
		state_machine.init()
	end
	-- call func init fortune bag state machine.
	init_fortune_bag_terminal()
end

-- 对象初始化
function FortuneBag:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function FortuneBag:onInit(params)
	self._activity_info = _ED.active_activity[169]
	self._activityEndTime = self._activity_info.end_time
end

function FortuneBag:onUpdateDraw()
	local root = self.roots[1]

	-- 跑马灯容器
	self.Panel_paomadeng = ccui.Helper:seekWidgetByName(root, "Panel_paomadeng")
	self.Panel_paomadeng:setVisible(true)
	-- 配对奖励容器
	self.ListView_fortune_bag_peidui = ccui.Helper:seekWidgetByName(root, "ListView_fortune_bag_peidui")
	self.ListView_fortune_bag_peidui:setVisible(false)
	-- 福袋开启容器
	self.Panel_fortune_bag_tongyong = ccui.Helper:seekWidgetByName(root, "Panel_fortune_bag_tongyong")
	self.Panel_fortune_bag_tongyong:removeAllChildren(true)
	self.Panel_fortune_bag_tongyong:setSwallowTouches(false)
	-- 活动倒计时
	self.Text_time = ccui.Helper:seekWidgetByName(root, "Text_time")
	self:updateActivityRemainTime()
	self:changeToPage(1)
	self:pushRedTip()
	_ED.active_activity[169].notice_update = true
end


function FortuneBag:changeToPage(page)
	if page == self._current_page then
        if page == 1 then
            self.Button_fortune_bag_kaiqi:setHighlighted(true)
        elseif page == 2 then
            self.Button_fortune_bag_jiangli:setHighlighted(true)
        elseif page == 3 then
            self.Button_fortune_bag_duihuan:setHighlighted(true)
        end
        return
    end
	self._current_page = page
	self.Button_fortune_bag_kaiqi:setHighlighted(false)
	self.Button_fortune_bag_jiangli:setHighlighted(false)
	self.Button_fortune_bag_duihuan:setHighlighted(false)
	self.ListView_fortune_bag_peidui:setVisible(false)
	state_machine.excute("fortune_bag_open_hide",0,"")

	if 1 == page then
		self.Button_fortune_bag_kaiqi:setHighlighted(true)
		if self._open then
			state_machine.excute("fortune_bag_open_show",0,"")
		else
			self._open = state_machine.excute("fortune_bag_open_window_open", 0, {self.Panel_fortune_bag_tongyong})
		end
	elseif 2 == page then
		self:showPairReward()
		self.Button_fortune_bag_jiangli:setHighlighted(true)
		
	else
		self:showDayExchange()
		self.Button_fortune_bag_duihuan:setHighlighted(true)
	end
	self.Button_fortune_bag_duihuan:setVisible(false)
end

-- 展示节日兑换
function FortuneBag:showDayExchange()
	self.ListView_fortune_bag_peidui:setVisible(true)
	self.ListView_fortune_bag_peidui:removeAllChildren(true)
	local activity =self._activity_info.exchange_reward.exchangePropInfo

	for i, v in pairs(activity) do
		local cell = FortuneExchangeCell:createCell()
		cell:init(v)
		self.ListView_fortune_bag_peidui:addChild(cell)
	end
	self.ListView_fortune_bag_peidui:jumpToTop()
	self.ListView_fortune_bag_peidui:requestRefreshView()
end

-- 配对奖励显示
function FortuneBag:showPairReward()
	
	self.ListView_fortune_bag_peidui:removeAllChildren(true)
	
	local rewardInfo = self._activity_info.activity_data.matchRewardStatusJSON
	
	rewardInfo = self:sortListItems(rewardInfo)
	
	for i, v in pairs(rewardInfo) do
		local cell = state_machine.excute("fortune_bag_list1_create",0,{v})
		self.ListView_fortune_bag_peidui:addChild(cell)
	end
	
	self.ListView_fortune_bag_peidui:jumpToTop()
	self.ListView_fortune_bag_peidui:requestRefreshView()
	self.ListView_fortune_bag_peidui:setVisible(true)
end

-- 配对奖励排序
function FortuneBag:sortListItems(items)
	local result = {}
	local closeItems = {}		-- 已领取
	local drawItems = {}		-- 可领取
	local unGetItems = {}			-- 未达到

	for i=0,table.nums(items) - 1 do
		local index = "matchReward"..i
		local val = items[index]
		if 1 == tonumber(val.matchRewardStatus)  then			-- 可领取
			table.insert(drawItems, val)
		elseif 2 == tonumber(val.matchRewardStatus) then		-- 已领取
			table.insert(closeItems, val)
		else
			table.insert(unGetItems, val)
		end
	end
	for k,v in pairs(drawItems) do
		table.insert(result,v)
	end
	for k,v in pairs(unGetItems) do
		table.insert(result,v)
	end
	for k,v in pairs(closeItems) do
		table.insert(result,v)
	end
	
	return result
end

-- 按钮红点的显示
function FortuneBag:pushRedTip()
	for i=1,3 do
		state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_fortune_bag_page_push",
            _widget = self._ButtonList[i],
            _invoke = nil,
            _pageIndex = i,
			_interval = 0.5,})
	end
end

function FortuneBag:onUpdate(dt)
	self.totalTime = self.totalTime + dt
	if self.totalTime >= self.deltaTime then
		self:updateActivityRemainTime()
		self:updateRunHouse()
		self.totalTime = 0
	end
end

-- 刷新跑马灯信息
function FortuneBag:updateRunHouse()
	if not self.Panel_paomadeng then
		return
	end
	local houseDatas = _ED.active_activity[169].notice

--
	if nil == houseDatas or 0 == #houseDatas then
		self.Panel_paomadeng:setVisible(false)
		return
	end
	if houseDatas and _ED.active_activity[169].notice_update then
		_ED.active_activity[169].notice_update = false
		if #houseDatas >= 2 then
			local function sortFunction(a, b)
				if tonumber(a.updateTime) > tonumber(b.updateTime) then
					return true
				end
				return false
			end
	
			table.sort(houseDatas, sortFunction)
		end
		
		self.Panel_paomadeng:removeAllChildren(true)
		local cell = state_machine.excute("activity_fortune_push_notice_list_create",0,{houseDatas})
		cell:setAnchorPoint(cc.p(0, 0))
		self.Panel_paomadeng:addChild(cell)
		self.Panel_paomadeng:setVisible(true)
	end
end

function FortuneBag:updateActivityRemainTime()
	if self.Text_time == nil or self._activityEndTime == nil then
		return
	end
	local surplus_time = (self._activityEndTime - ((os.time() + _ED.time_add_or_sub))*1000)
	self.Text_time:setString(surplus_time < 0 and _string_piece_info[305] or self:drawTime(surplus_time))
end

function FortuneBag:drawTime(_time)
	local timeString = ""
	local _dayTime = math.floor((_time / 1000) / 86400)
	local _hourTime = math.floor((_time / 1000) % 86400 / 3600)
	local _minutesTime = math.floor((_time / 1000) % 86400 % 3600 / 60)
	local _secondsTime = math.floor((_time / 1000) % 60)
	if _dayTime > 0 then
		timeString = timeString .. _dayTime .._string_piece_info[231]
	end
	if _hourTime < 10 then
		timeString = timeString .. "0".._hourTime ..":"
	else
		timeString = timeString .. _hourTime ..":"
	end

	if _minutesTime < 10 then
		timeString = timeString .. "0".._minutesTime ..":"
	else
		timeString = timeString .. _minutesTime ..":"
	end

	if _secondsTime < 10 then
		timeString = timeString .. "0".._secondsTime 
	else
		timeString = timeString .. _secondsTime 
	end
	return timeString
end

function FortuneBag:onEnterTransitionFinish()
	-- 加载FortuneBagWindow界面资源.
	-- res.activity.fortune_bag.fortune_bag = res/activity/fortune_bag/fortune_bag.csb
	local csbNode = csb.createNode("activity/fortune_bag/fortune_bag.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 福袋开启按钮
	self.Button_fortune_bag_kaiqi = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_fortune_bag_kaiqi"), nil,
	{
		terminal_name = "fortune_bag_change_page",
		terminal_state = 0,
		page_index = 1,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 配对奖励按钮
	self.Button_fortune_bag_jiangli = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_fortune_bag_jiangli"), nil,
	{
		terminal_name = "fortune_bag_change_page",
		terminal_state = 0,
		page_index = 2,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 节日兑换按钮
	self.Button_fortune_bag_duihuan = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_fortune_bag_duihuan"), nil,
	{
		terminal_name = "fortune_bag_change_page",
		terminal_state = 0,
		page_index = 3,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 帮助按钮
	self.Button_bangzhu = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_bangzhu"), nil,
	{
		terminal_name = "fortune_bag_rule_window_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "fortune_bag_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	self._ButtonList = {self.Button_fortune_bag_kaiqi,self.Button_fortune_bag_jiangli,self.Button_fortune_bag_duihuan}
	self:onUpdateDraw()
end

function FortuneBag:onExit()
	-- 释放FortuneBagWindow界面资源.
	state_machine.remove("fortune_bag_show")
	state_machine.remove("fortune_bag_hide")
	state_machine.remove("fortune_bag_change_page")
	state_machine.remove("fortune_bag_refesh_windows")
	
end

function FortuneBag:close()
	-- window event : close.
	
end

function FortuneBag:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
