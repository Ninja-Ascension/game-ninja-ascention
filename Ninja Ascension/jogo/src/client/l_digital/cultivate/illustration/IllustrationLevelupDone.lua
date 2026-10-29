--[[ ----------------------------------------------------------------------------
-- 卡冊等级提升界面
--]] ----------------------------------------------------------------------------
IllustrationLevelupDone = class("IllustrationLevelupDoneClass", Window)

-- 打开窗口
local illustration_levelup_done_window_open_terminal = {
	_name = "illustration_levelup_done_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("IllustrationLevelupDoneClass") then
			fwin:open(IllustrationLevelupDone:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local illustration_levelup_done_window_close_terminal = {
	_name = "illustration_levelup_done_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("IllustrationLevelupDoneClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(illustration_levelup_done_window_open_terminal)
state_machine.add(illustration_levelup_done_window_close_terminal)
state_machine.init()

-- 构造器
function IllustrationLevelupDone:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._per_card_data = nil
	self._is_combine_card = false
	-- load lua files.

	-- Initialize illustration levelup done page state machine.
	local function init_illustration_levelup_done_terminal()
		-- 打开角色创建窗口
		local illustration_levelup_done_open_terminal = {
			_name = "illustration_levelup_done_open",
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
		local illustration_levelup_done_close_terminal = {
			_name = "illustration_levelup_done_close",
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
		local illustration_levelup_done_show_terminal = {
			_name = "illustration_levelup_done_show",
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
		local illustration_levelup_done_hide_terminal = {
			_name = "illustration_levelup_done_hide",
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

		state_machine.add(illustration_levelup_done_open_terminal)
		state_machine.add(illustration_levelup_done_close_terminal)
		state_machine.add(illustration_levelup_done_show_terminal)
		state_machine.add(illustration_levelup_done_hide_terminal)
		state_machine.init()
	end
	-- call func init illustration levelup done state machine.
	init_illustration_levelup_done_terminal()
end

-- 对象初始化
function IllustrationLevelupDone:init(params)
	self._per_card_data = params[1]
	self._is_combine_card = params[2]
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function IllustrationLevelupDone:onUpdateDraw()
	local root = self.roots[1]
	local curMark = tonumber(self._per_card_data.cardScore)
	local curShipMouldId = tonumber(self._per_card_data.shipMouldId)
	local curCardStar = tonumber(self._per_card_data.cardStar)
	local curCardMouldId = tonumber(self._per_card_data.cardMouldId)
	
	local mouldId = self._is_combine_card and curCardMouldId or curShipMouldId
	local consume,curAdd,nextAdd,markAdd = IllustrationHandle.getUpLevelConsume(mouldId, curCardStar, self._is_combine_card)
	
	-- 升级前卡册评分
	self.Text_point_1 = ccui.Helper:seekWidgetByName(root, "Text_point_1")
	self.Text_point_1:setString(""..curMark)
	-- 升级后卡册评分
	self.Text_point_2 = ccui.Helper:seekWidgetByName(root, "Text_point_2")
	self.Text_point_2:setString(""..(curMark + markAdd))

	for i=1,4 do
		local Text_attributes_n = ccui.Helper:seekWidgetByName(root, "Text_attributes_n_"..i)
		local Text_attributes_t = ccui.Helper:seekWidgetByName(root, "Text_attributes_t_"..i)
		Text_attributes_n:setVisible(false)
		Text_attributes_t:setVisible(false)
	end

	local addDatas = zstring.split(nextAdd,"|")
	for i=1,#addDatas do
		local datas = zstring.split(addDatas[i],",")
		local addType = tonumber(datas[1])
		local addVal = tonumber(datas[2])

		local propertyName, propertyValue = getPropertyNameAndValue(addType, addVal)

		local Text_attributes_n = ccui.Helper:seekWidgetByName(root, "Text_attributes_n_"..i)
		local Text_attributes_t = ccui.Helper:seekWidgetByName(root, "Text_attributes_t_"..i)

		Text_attributes_n:setString(propertyName)
		Text_attributes_t:setString(propertyValue)
		
		Text_attributes_n:setVisible(true)
		Text_attributes_t:setVisible(true)
	end
end

function IllustrationLevelupDone:onEnterTransitionFinish()
	-- 加载IllustrationLevelupDoneWindow界面资源.
	-- res.cultivate.illustration.illustration_levelup_done = res/cultivate/illustration/illustration_levelup_done.csb
	local csbNode = csb.createNode("cultivate/illustration/illustration_levelup_done.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)

	local action = csb.createTimeline("cultivate/illustration/illustration_levelup_done.csb") 
	
	action:play("window_open", false)
	csbNode:runAction(action)
	self:addChild(csbNode)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_2"), nil,
	{
		terminal_name = "illustration_levelup_done_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)
	self:onUpdateDraw()
end

function IllustrationLevelupDone:onExit()
	-- 释放IllustrationLevelupDoneWindow界面资源.
	state_machine.remove("illustration_levelup_done_open")
	state_machine.remove("illustration_levelup_done_close")
	state_machine.remove("illustration_levelup_done_show")
	state_machine.remove("illustration_levelup_done_hide")
end

function IllustrationLevelupDone:close()
	-- window event : close.
	
end

function IllustrationLevelupDone:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
