--[[ ----------------------------------------------------------------------------
-- 奖励预览
--]] ----------------------------------------------------------------------------
RescueStationRewardPreview = class("RescueStationRewardPreviewClass", Window)

-- 打开窗口
local rescue_station_reward_preview_window_open_terminal = {
	_name = "rescue_station_reward_preview_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("RescueStationRewardPreviewClass") then
			fwin:open(RescueStationRewardPreview:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local rescue_station_reward_preview_window_close_terminal = {
	_name = "rescue_station_reward_preview_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("RescueStationRewardPreviewClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(rescue_station_reward_preview_window_open_terminal)
state_machine.add(rescue_station_reward_preview_window_close_terminal)
state_machine.init()

-- 构造器
function RescueStationRewardPreview:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
    app.load("client.cells.activity.rescue_station_reward_preview_list")
	local function init_rescue_station_reward_preview_terminal()
		-- 打开角色创建窗口
		local rescue_station_reward_preview_open_terminal = {
			_name = "rescue_station_reward_preview_open",
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
		local rescue_station_reward_preview_close_terminal = {
			_name = "rescue_station_reward_preview_close",
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
		local rescue_station_reward_preview_show_terminal = {
			_name = "rescue_station_reward_preview_show",
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
		local rescue_station_reward_preview_hide_terminal = {
			_name = "rescue_station_reward_preview_hide",
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

		state_machine.add(rescue_station_reward_preview_open_terminal)
		state_machine.add(rescue_station_reward_preview_close_terminal)
		state_machine.add(rescue_station_reward_preview_show_terminal)
		state_machine.add(rescue_station_reward_preview_hide_terminal)
		state_machine.init()
	end
	-- call func init rescue station reward preview state machine.
	init_rescue_station_reward_preview_terminal()
end

-- 对象初始化
function RescueStationRewardPreview:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function RescueStationRewardPreview:onUpdateDraw()
	local root = self.roots[1]
	local activityParams = json.decode(_ED.active_activity[tonumber(159)].activity_params)
	local rankInfo = activityParams.rankReward
	-- 列表
	self.ListView_jhsms_reward = ccui.Helper:seekWidgetByName(root, "ListView_jhsms_reward")
	self.ListView_jhsms_reward:removeAllItems()

    local num = #rankInfo
	for i=1,num do
		local info = rankInfo[i]
        local cell = state_machine.excute("rescue_station_reward_preview_list_create",0,{info})
        self.ListView_jhsms_reward:addChild(cell)
    end

end

function RescueStationRewardPreview:onEnterTransitionFinish()
	-- 加载RescueStationRewardPreviewWindow界面资源.
	-- res.activity.rescue_station_reward_preview = res/activity/rescue_station_reward_preview.csb
	local csbNode = csb.createNode("activity/rescue_station/rescue_station_reward_preview.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "rescue_station_reward_preview_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function RescueStationRewardPreview:onExit()
	-- 释放RescueStationRewardPreviewWindow界面资源.
	state_machine.remove("rescue_station_reward_preview_open")
	state_machine.remove("rescue_station_reward_preview_close")
	state_machine.remove("rescue_station_reward_preview_show")
	state_machine.remove("rescue_station_reward_preview_hide")
end

function RescueStationRewardPreview:close()
	-- window event : close.
	
end

function RescueStationRewardPreview:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
