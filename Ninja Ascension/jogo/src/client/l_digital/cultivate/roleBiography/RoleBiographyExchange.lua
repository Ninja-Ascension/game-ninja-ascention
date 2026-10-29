--[[ ----------------------------------------------------------------------------
-- 兑换界面
--]] ----------------------------------------------------------------------------
RoleBiographyExchange = class("RoleBiographyExchangeClass", Window)

-- 打开窗口
local role_biography_exchange_window_open_terminal = {
	_name = "role_biography_exchange_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("RoleBiographyExchangeClass") then
			fwin:open(RoleBiographyExchange:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local role_biography_exchange_window_close_terminal = {
	_name = "role_biography_exchange_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("RoleBiographyExchangeClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(role_biography_exchange_window_open_terminal)
state_machine.add(role_biography_exchange_window_close_terminal)
state_machine.init()

-- 构造器
function RoleBiographyExchange:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize lim pool rule page state machine.
	local function init_role_biography_exchange_terminal()
		-- 打开角色创建窗口
		local role_biography_exchange_open_terminal = {
			_name = "role_biography_exchange_open",
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
		local role_biography_exchange_close_terminal = {
			_name = "role_biography_exchange_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("role_biography_exchange_window_close", 0, 0)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local role_biography_exchange_show_terminal = {
			_name = "role_biography_exchange_show",
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
		local role_biography_exchange_hide_terminal = {
			_name = "role_biography_exchange_hide",
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

		-- 
		local role_biography_exchange_open_buy_prop_terminal = {
			_name = "role_biography_exchange_open_buy_prop",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local buyType_params_1 = instance._buyType
				local buyType_params_2 = params._datas._buyType

				local rewards = buyType_params_2 == 0 and instance._rewards1 or instance._rewards2

				-- debug.print_r(rewards, "rewards")

				local haveCount = 0
				local costPropType = tonumber(rewards[1][1])
				if costPropType == 1 then
					haveCount = tonumber(_ED.user_info.user_silver)
				elseif costPropType == 2 then
					haveCount = tonumber(_ED.user_info.user_gold)
				end
				local unit_price = tonumber(rewards[1][3])

				if haveCount < unit_price then
					if costPropType == 1 then
						TipDlg.drawTextDailog(tipStringInfo_role_biography[13])
					elseif costPropType == 2 then
						TipDlg.drawTextDailog(tipStringInfo_role_biography[14])
					end
					return true
				end

				state_machine.excute("role_biography_buy_window_open", 0, {buyType_params_1, buyType_params_2, rewards})
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(role_biography_exchange_open_terminal)
		state_machine.add(role_biography_exchange_close_terminal)
		state_machine.add(role_biography_exchange_show_terminal)
		state_machine.add(role_biography_exchange_hide_terminal)
		state_machine.add(role_biography_exchange_open_buy_prop_terminal)
		state_machine.init()
	end
	-- call func init lim pool rule state machine.
	init_role_biography_exchange_terminal()
end

-- 对象初始化
function RoleBiographyExchange:init(params)
	--[[
	199	【火影忍者】忍列传普通购买印记1次消耗的铜钱	199	1,-1,10000|6,2082,1
	200	【火影忍者】忍列传普通购买印记10次消耗的铜钱	200	1,-1,100000|6,2082,10
	201	【火影忍者】忍列传高级购买印记1次消耗的金币/钻石数	201	2,-1,240
	202	【火影忍者】忍列传高级购买印记1次消耗的金币/钻石数	202	2,-1,2280
	]]
	self._buyType = params

	return self
end

function RoleBiographyExchange:onUpdateDraw()
	local root = self.roots[1]

	local Panel_icon = {}

	local Panel_player_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_1")
	table.insert(Panel_icon, Panel_player_icon_1)

	local Panel_player_icon_1_0 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_1_0")
	table.insert(Panel_icon, Panel_player_icon_1_0)

	local Panel_player_icon_2 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_2")
	table.insert(Panel_icon, Panel_player_icon_2)

	local Panel_player_icon_2_0 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_2_0")
	table.insert(Panel_icon, Panel_player_icon_2_0)

	local rewards1str, rewards2str = nil, nil

	if self._buyType == 0 then
		rewards1str = dms.string(dms["play_config"], 199, play_config.param)
		rewards2str = dms.string(dms["play_config"], 200, play_config.param)
	elseif self._buyType == 1 then
		rewards1str = dms.string(dms["play_config"], 201, play_config.param)
		rewards2str = dms.string(dms["play_config"], 202, play_config.param)
	end

	local rewards1 = zstring.splits(rewards1str, "|", ",")
	local rewards2 = zstring.splits(rewards2str, "|", ",")

	self._rewards1 = rewards1
	self._rewards2 = rewards2

	local props = {rewards1[1], rewards1[2], rewards2[1], rewards2[2]}

	for i, v in ipairs(Panel_icon) do
		v:removeAllChildren(true)
		local cell = self:addResourcesIconCell(props[i])
		v:addChild(cell)
	end
end

function RoleBiographyExchange:addResourcesIconCell(propData)
	local cell = ResourcesIconCell:createCell()
	local rewardType = tonumber(propData[1])
	if 13 == rewardType then
		local extraTable = {}
		if propData[4] ~= nil and tonumber(propData[4]) ~= -1 then
			extraTable.shipStar = tonumber(propData[4])
		else
			extraTable.shipStar = 0
		end
		cell:init(rewardType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true, true, 1, extraTable)
	else
		cell:init(rewardType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true ,true, 1)
	end
	return cell
end

function RoleBiographyExchange:onEnterTransitionFinish()
	-- 加载RoleBiographyExchangeWindow界面资源.
	-- res.cultivate.ninja_biographies.ninja_biographies_exchange = res/cultivate/ninja_biographies/ninja_biographies_exchange.csb
	local csbNode = csb.createNode("cultivate/ninja_biographies/ninja_biographies_exchange.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "role_biography_exchange_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	self.Button_exchange_1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_exchange_1"), nil,
	{
		terminal_name = "role_biography_exchange_open_buy_prop",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_buyType = 0
	}, nil, 0)	

	self.Button_exchange_2 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_exchange_2"), nil,
	{
		terminal_name = "role_biography_exchange_open_buy_prop",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_buyType = 1
	}, nil, 0)	

	self:onUpdateDraw()
end

function RoleBiographyExchange:onExit()
	-- 释放RoleBiographyExchangeWindow界面资源.
	state_machine.remove("role_biography_exchange_open")
	state_machine.remove("role_biography_exchange_close")
	state_machine.remove("role_biography_exchange_show")
	state_machine.remove("role_biography_exchange_hide")
	state_machine.remove("role_biography_exchange_open_buy_prop")
end

function RoleBiographyExchange:close()
	-- window event : close.
	
end

function RoleBiographyExchange:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
