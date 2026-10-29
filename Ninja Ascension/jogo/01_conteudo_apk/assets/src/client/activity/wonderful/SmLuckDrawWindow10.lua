--[[ ----------------------------------------------------------------------------
-- 转动一次弹窗
--]] ----------------------------------------------------------------------------
SmLuckDrawWindow10 = class("SmLuckDrawWindow10Class", Window)

-- 打开窗口
local sm_luck_draw_window10_window_open_terminal = {
	_name = "sm_luck_draw_window10_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("SmLuckDrawWindow10Class") then
			fwin:open(SmLuckDrawWindow10:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local sm_luck_draw_window10_window_close_terminal = {
	_name = "sm_luck_draw_window10_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmLuckDrawWindow10Class"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_luck_draw_window10_window_open_terminal)
state_machine.add(sm_luck_draw_window10_window_close_terminal)
state_machine.init()

-- 构造器
function SmLuckDrawWindow10:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize sm luck draw window10 page state machine.
	local function init_sm_luck_draw_window10_terminal()
		-- 打开角色创建窗口
		local sm_luck_draw_window10_open_terminal = {
			_name = "sm_luck_draw_window10_open",
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
		local sm_luck_draw_window10_close_terminal = {
			_name = "sm_luck_draw_window10_close",
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
		local sm_luck_draw_window10_show_terminal = {
			_name = "sm_luck_draw_window10_show",
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
		local sm_luck_draw_window10_hide_terminal = {
			_name = "sm_luck_draw_window10_hide",
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

		state_machine.add(sm_luck_draw_window10_open_terminal)
		state_machine.add(sm_luck_draw_window10_close_terminal)
		state_machine.add(sm_luck_draw_window10_show_terminal)
		state_machine.add(sm_luck_draw_window10_hide_terminal)
		state_machine.init()
	end
	-- call func init sm luck draw window10 state machine.
	init_sm_luck_draw_window10_terminal()
end

-- 对象初始化
function SmLuckDrawWindow10:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function SmLuckDrawWindow10:onUpdateDraw()
	local root = self.roots[1]

	-- 十连拉把结果列表
	self.ListView_136 = ccui.Helper:seekWidgetByName(root, "ListView_136")

	-- 十连拉把结果列表内容控件
	self.Panel_luck_icon_content = ccui.Helper:seekWidgetByName(root, "Panel_luck_icon_content")

	-- -- 转到道具图标1
	-- self.Panel_reward_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_reward_icon_1")

	-- -- 转到道具图标2
	-- self.Panel_reward_icon_2 = ccui.Helper:seekWidgetByName(root, "Panel_reward_icon_2")

	-- -- 转到道具图标3
	-- self.Panel_reward_icon_3 = ccui.Helper:seekWidgetByName(root, "Panel_reward_icon_3")

	-- -- 转到道具图标4
	-- self.Panel_reward_icon_4 = ccui.Helper:seekWidgetByName(root, "Panel_reward_icon_4")

	-- -- 转到道具图标5
	-- self.Panel_reward_icon_5 = ccui.Helper:seekWidgetByName(root, "Panel_reward_icon_5")

	-- -- 转到道具图标6
	-- self.Panel_reward_icon_6 = ccui.Helper:seekWidgetByName(root, "Panel_reward_icon_6")

	-- 获得的全部道具列表
	-- self.ListView_137 = ccui.Helper:seekWidgetByName(root, "ListView_137")

	self.cellItem = ccui.Helper:seekWidgetByName(root, "Panel_luck_icon_content")
	self.cellItem:setPosition(-1000,-1000)
	-- 连抽记录
	self.ListView_136:setVisible(true)
	local cellSize = self.cellItem:getContentSize()
	for i,v in pairs(_ED.active_activity[162].pullResult) do
		local default_item = ccui.Layout:create()
		default_item:setContentSize(cellSize.width*2,cellSize.height)
	
		local cell1 = self.cellItem:clone()
		cell1:setPosition(0,0)
		default_item:addChild(cell1)

		local returnIconId = v.returnIconId
		for k,v in pairs(returnIconId) do
			panel = ccui.Helper:seekWidgetByName(cell1, "Panel_reward_icon_"..k)
			local cell = ResourcesIconCell:createCell()
			local rewardType = v[1]
			if 13 == tonumber(rewardType) then
				local table = {}
				if v[4] ~= nil and tonumber(v[4]) ~= -1 then
					table.shipStar = tonumber(v[4])
				else
					table.shipStar = 0
				end
				cell:init(rewardType, 0, tonumber(v[2]),nil,nil,true,true,1,table)
			else
				cell:init(rewardType, 0, tonumber(v[2]),nil,nil,true,true,1)
			end
			panel:addChild(cell)
		end

		local time = ccui.Helper:seekWidgetByName(cell1, "Text_luck_icon_title")
		time:setString(string.format(time:getString(),tostring(i)))

		local Image_reward = ccui.Helper:seekWidgetByName(cell1, "Image_reward")
		local returnReward = v.returnReward[1]
		if	returnReward.sourceNumber == -1 and returnReward.sourceStarNumber == -1 and returnReward.sourceType == -1 and returnReward.sourceMouldID == -1 then
			Image_reward:setVisible(false)
		else
			Image_reward:setVisible(true)
		end


		self.ListView_136:addChild(default_item)
	end
	self.ListView_136:refreshView()

	-- 奖励显示
	self.ListView_137 = ccui.Helper:seekWidgetByName(root, "ListView_137")
	self.ListView_137:setVisible(true)
	if _ED.active_activity[162].tenpullReward ~= nil then
		local myReworld =  zstring.splits(_ED.active_activity[162].tenpullReward, "|",",")
		--debug.print_r(myReworld,'myReworld')
		for i,v in pairs(myReworld) do
			local prop_data = v
			local cell = ResourcesIconCell:createCell()
			local rewardType = v[1]
			if 13 == tonumber(rewardType) then
				local table = {}
				if v[4] ~= nil and tonumber(v[4]) ~= -1 then
					table.shipStar = tonumber(v[4])
				else
					table.shipStar = 0
				end
				cell:init(rewardType, tonumber(v[3]), tonumber(v[2]),nil,nil,true,true,1,table)
			else
				cell:init(rewardType, tonumber(v[3]), tonumber(v[2]),nil,nil,true,true,1)
			end
			self.ListView_137:addChild(cell)
		end
		self.ListView_137:refreshView()
	end
end

function SmLuckDrawWindow10:onEnterTransitionFinish()
	-- 加载SmLuckDrawWindow10Window界面资源.
	-- res.activity.wonderful.sm_luck_draw_window_10 = res/activity/wonderful/sm_luck_draw_window_10.csb
	local csbNode = csb.createNode("activity/wonderful/sm_luck_draw_window_10.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_luck_confirm = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_luck_confirm"), nil,
	{
		terminal_name = "sm_luck_draw_window10_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function SmLuckDrawWindow10:onExit()
	-- 释放SmLuckDrawWindow10Window界面资源.
	state_machine.remove("sm_luck_draw_window10_open")
	state_machine.remove("sm_luck_draw_window10_close")
	state_machine.remove("sm_luck_draw_window10_show")
	state_machine.remove("sm_luck_draw_window10_hide")
end

function SmLuckDrawWindow10:close()
	-- window event : close.
	
end

function SmLuckDrawWindow10:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
