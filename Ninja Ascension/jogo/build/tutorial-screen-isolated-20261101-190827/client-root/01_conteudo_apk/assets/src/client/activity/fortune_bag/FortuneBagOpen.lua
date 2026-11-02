--[[ ----------------------------------------------------------------------------
-- 福袋开启页面
--]] ----------------------------------------------------------------------------
FortuneBagOpen = class("FortuneBagOpenClass", Window)
FortuneBagOpen.__size = nil
-- 打开窗口
local fortune_bag_open_window_open_terminal = {
	_name = "fortune_bag_open_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("FortuneBagOpenClass") then
			fwin:open(FortuneBagOpen:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local fortune_bag_open_window_close_terminal = {
	_name = "fortune_bag_open_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil ~= fwin:find("FortuneBagOpenClass") then
			fwin:close(fwin:find("FortuneBagOpenClass"))
		end
		
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fortune_bag_open_window_open_terminal)
state_machine.add(fortune_bag_open_window_close_terminal)
state_machine.init()

-- 构造器
function FortuneBagOpen:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.
	app.load("client.activity.fortune_bag.FortuneRecruitOne")
	app.load("client.activity.fortune_bag.FortuneRecruitTen")
	app.load("client.activity.fortune_bag.FortuneBagTips")
	app.load("client.activity.fortune_bag.FortuneBagReward")
	-- Initialize fortune bag open page state machine.
	local function init_fortune_bag_open_terminal()
		-- 显示窗口
		local fortune_bag_open_show_terminal = {
			_name = "fortune_bag_open_show",
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
		local fortune_bag_open_hide_terminal = {
			_name = "fortune_bag_open_hide",
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

		-- 抽取奖励（1次 10次）
		local fortune_bag_get_reward_terminal = {
			_name = "fortune_bag_get_reward",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				
				local group = params._datas.group
				local times = params._datas.times
				local m_type = params._datas.m_type
				

				if not instance:haveEnoughProp(times) then
					state_machine.excute("fortune_bag_tips_window_open", 0, 0)
					return true
				end

				state_machine.lock("fortune_bag_get_reward")
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
							if fwin:find("FortuneRecruitOneClass") ~= nil then
								fwin:close(fwin:find("FortuneRecruitOneClass"))
							end

							if fwin:find("FortuneRecruitTenClass") ~= nil then
								fwin:close(fwin:find("FortuneRecruitTenClass"))
							end

							getSceneReward(64)
							_ED.show_reward_list_group_ex = {}

							if times == 1 then
								local obj = FortuneRecruitOne:new()
								obj:setRanking(herorIndex, m_type, true, group)
								fwin:open(obj, fwin._ui)
							elseif times == 10 then
								local obj = FortuneRecruitTen:new()
								obj:setRanking(herorIndex, m_type, true, group)
								fwin:open(obj, fwin._ui)
							end
							
							state_machine.excute("menu_hide_event", 0, "menu_hide_event.")
							state_machine.excute("fortune_bag_refesh_windows", 0, {m_page = 1})
							
						else
							state_machine.unlock("fortune_bag_get_reward")
						end
					else
						state_machine.unlock("fortune_bag_get_reward")
					end
					_ED.prop_chest_store_recruiting = false
				end

				_ED.new_prop_object = {}
				_ED.recruit_success_ship_id = nil
				_ED.new_reward_object = {}
				_ED.prop_chest_store_recruiting = true

				protocol_command.lucky_match_draw.param_list = ""..(group - 1).."\r\n".. times
				NetworkManager:register(protocol_command.lucky_match_draw.code, nil, nil, nil, instance, responseCallback, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 刷新主界面
		local fortune_bag_open_refesh_terminal = {
			_name = "fortune_bag_open_refesh",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					instance:onRefreshDraw()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(fortune_bag_open_show_terminal)
		state_machine.add(fortune_bag_open_hide_terminal)
		state_machine.add(fortune_bag_get_reward_terminal)
		state_machine.add(fortune_bag_open_refesh_terminal)
		state_machine.init()
	end
	-- call func init fortune bag open state machine.
	init_fortune_bag_open_terminal()
end

-- 对象初始化
function FortuneBagOpen:init(params)
	if nil ~= self.onInit then
		self._rootWindows = params[1]
		self:onInit(params)
	end
	return self
end

function FortuneBagOpen:onInit(params)
	
end

function FortuneBagOpen:onUpdateDraw()
	local root = self.roots[1]
	self:onRefreshDraw()
end

-- 界面刷新
function FortuneBagOpen:onRefreshDraw()
	local root = self.roots[1]
	local propID = self:getNeedCostPropID()
	local havePropNum = getPropAllCountByMouldId(propID)
	local Text_item_num = ccui.Helper:seekWidgetByName(root, "Text_item_num")
	Text_item_num:setString(havePropNum)
	self:updateButtonRedDot()
end

-- 获取消耗道具的id
function FortuneBagOpen:getNeedCostPropID()
	local propID = dms.int(dms["activity_config"], 67, activity_config.param)
	return propID
end

-- 道具是否足够
function FortuneBagOpen:haveEnoughProp(needCount)
	local propID = self:getNeedCostPropID()
	local havePropNum = tonumber(getPropAllCountByMouldId(propID))

	return havePropNum >= needCount
end

-- 按钮红点的显示
function FortuneBagOpen:updateButtonRedDot()
	for i, v in ipairs(self._ButtonList) do
		local isShow = false
		if i == 1 or i== 3 then
			isShow = self:haveEnoughProp(1)
		elseif i == 2 or i == 4 then
			isShow = self:haveEnoughProp(10)
		end
		self:changeRedDotShowState( v, isShow)
	end
end

function FortuneBagOpen:changeRedDotShowState( widget, isShow)
	if widget._istips == true then
		widget:removeChild(widget._nodeChild, true)
		widget._nodeChild = nil
		widget._istips = false
	end

	if isShow then
		if widget._istips == nil or widget._istips == false then
			local ball = cc.Sprite:create("images/ui/bar/tips.png")
			ball:setAnchorPoint(cc.p(0.5, 0.5))
			ball:setPosition(cc.p(widget:getContentSize().width-ball:getContentSize().width*0.5, widget:getContentSize().height-ball:getContentSize().height*0.5))
			widget:addChild(ball)
			widget._nodeChild = ball
			widget._istips = true
		end
	end
end


function FortuneBagOpen:onEnterTransitionFinish()
	-- 加载FortuneBagOpenWindow界面资源.
	-- client.activity.fortune_bag.fortune_bag_list_2 = activity/fortune_bag/fortune_bag_list_2.csb
	local csbNode = csb.createNode("activity/fortune_bag/fortune_bag_xingyunpeidui.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	if FortuneBagOpen.__size == nil then
        FortuneBagOpen.__size = root:getContentSize()
    end
	self:setContentSize(FortuneBagOpen.__size)
	
	-- A库组抽奖
	self.Button_chouqu1_1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chouqu1_1"), nil,
	{
		terminal_name = "fortune_bag_get_reward",
		terminal_state = 0,
		m_type = 9,
		group = 1,
		times = 1,
		isPressedActionEnabled = true,
	}, nil, 0)

	self.Button_chouqu1_10 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chouqu1_10"), nil,
	{
		terminal_name = "fortune_bag_get_reward",
		terminal_state = 0,
		m_type = 9,
		group = 1,
		times = 10,
		isPressedActionEnabled = true,
	}, nil, 0)

	-- B库组抽奖
	self.Button_chouqu2_1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chouqu2_1"), nil,
	{
		terminal_name = "fortune_bag_get_reward",
		terminal_state = 0,
		m_type = 9,
		group = 2,
		times = 1,
		isPressedActionEnabled = true,
	}, nil, 0)

	self.Button_chouqu2_10 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chouqu2_10"), nil,
	{
		terminal_name = "fortune_bag_get_reward",
		terminal_state = 0,
		m_type = 9,
		group = 2,
		times = 10,
		isPressedActionEnabled = true,
	}, nil, 0)

	-- 奖励预览
	self.Button_fortune_bag_yulan = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_fortune_bag_yulan"), nil,
	{
		terminal_name = "fortune_bag_reward_window_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	self._ButtonList = {self.Button_chouqu1_1, self.Button_chouqu1_10, self.Button_chouqu2_1, self.Button_chouqu2_10}
	self:onUpdateDraw()
end

function FortuneBagOpen:onExit()
	-- 释放FortuneBagOpenWindow界面资源.
	state_machine.remove("fortune_bag_open_show")
	state_machine.remove("fortune_bag_open_hide")
	state_machine.remove("fortune_bag_get_reward")
	state_machine.remove("fortune_bag_open_refesh")

end

function FortuneBagOpen:close()
	-- window event : close.
	
end

function FortuneBagOpen:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
