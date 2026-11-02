--[[ ----------------------------------------------------------------------------
-- 获得终极奖励弹框
--]] ----------------------------------------------------------------------------
SecretTreasureDone = class("SecretTreasureDoneClass", Window)

-- 打开窗口
local secret_treasure_done_window_open_terminal = {
	_name = "secret_treasure_done_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("SecretTreasureDoneClass") then
			fwin:open(SecretTreasureDone:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local secret_treasure_done_window_close_terminal = {
	_name = "secret_treasure_done_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SecretTreasureDoneClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(secret_treasure_done_window_open_terminal)
state_machine.add(secret_treasure_done_window_close_terminal)
state_machine.init()

-- 构造器
function SecretTreasureDone:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._rewardInfo = nil

	-- load lua files.

	-- Initialize secret treasure done page state machine.
	local function init_secret_treasure_done_terminal()
		-- 打开角色创建窗口
		local secret_treasure_done_open_terminal = {
			_name = "secret_treasure_done_open",
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
		local secret_treasure_done_close_terminal = {
			_name = "secret_treasure_done_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("secret_treasure_done_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local secret_treasure_done_show_terminal = {
			_name = "secret_treasure_done_show",
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
		local secret_treasure_done_hide_terminal = {
			_name = "secret_treasure_done_hide",
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

		state_machine.add(secret_treasure_done_open_terminal)
		state_machine.add(secret_treasure_done_close_terminal)
		state_machine.add(secret_treasure_done_show_terminal)
		state_machine.add(secret_treasure_done_hide_terminal)
		state_machine.init()
	end
	-- call func init secret treasure done state machine.
	init_secret_treasure_done_terminal()
end

-- 对象初始化
function SecretTreasureDone:init(params)
	self._rewardInfo = params
	return self
end

function SecretTreasureDone:updateUI()
	local Panel_item = self.Panel_item

	local reward = self._rewardInfo
	if reward then
		local cell = self:addResourcesIconCell(reward)
		self.Panel_item:addChild(cell)
	end
end

function SecretTreasureDone:addResourcesIconCell(propData)
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

function SecretTreasureDone:onUpdateDraw()
	local root = self.roots[1]

	-- 道具容器
	self.Panel_item = ccui.Helper:seekWidgetByName(root, "Panel_item")

	self:updateUI()
end

function SecretTreasureDone:onEnterTransitionFinish()
	-- 加载SecretTreasureDoneWindow界面资源.
	-- res.activity.secret_treasure.secret_treasure_done = res/activity/secret_treasure/secret_treasure_done.csb
	local csbNode = csb.createNode("activity/secret_treasure/secret_treasure_done.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 弹出后消失动画
	local action = csb.createTimeline("activity/secret_treasure/secret_treasure_done.csb")
	table.insert(self.actions, action)
	csbNode:runAction(action)

	action:play("window_open", false)

	action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "open" then

        elseif str == "over" then
           state_machine.excute("secret_treasure_done_window_close", 0, nil)
        end
    end)

	-- -- 关闭
	-- self.Panel_20 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_20"), nil,
	-- {
	-- 	terminal_name = "secret_treasure_done_close",
	-- 	terminal_state = 0,
	-- 	isPressedActionEnabled = true,
	-- }, nil, 0)

	-- 作为屏蔽层
	local Panel_20 = ccui.Helper:seekWidgetByName(root, "Panel_20")
	Panel_20:setTouchEnabled(true)


	self:onUpdateDraw()
end

function SecretTreasureDone:onExit()
	-- 释放SecretTreasureDoneWindow界面资源.
	state_machine.remove("secret_treasure_done_open")
	state_machine.remove("secret_treasure_done_close")
	state_machine.remove("secret_treasure_done_show")
	state_machine.remove("secret_treasure_done_hide")
end

function SecretTreasureDone:close()
	-- window event : close.
	
end

function SecretTreasureDone:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
