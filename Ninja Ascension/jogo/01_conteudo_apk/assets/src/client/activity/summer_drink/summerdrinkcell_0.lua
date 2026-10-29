--[[ ----------------------------------------------------------------------------
-- 宝箱开启页面
--]] ----------------------------------------------------------------------------
SummerDrinkCell0 = class("SummerDrinkCell0Class", Window)
SummerDrinkCell0.__size = nil

-- 创建Cell实例
local summer_drink_cell0_create_terminal = {
	_name = "summer_drink_cell0_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if SummerDrinkCell0 then
			local cell = SummerDrinkCell0:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(summer_drink_cell0_create_terminal)
state_machine.init()

-- 构造器
function SummerDrinkCell0:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize summer drink cell0 page state machine.
	local function init_summer_drink_cell0_terminal()
		-- 打开任务界面
		local summer_drink_cell0_open_task_ui_terminal = {
			_name = "summer_drink_cell0_open_task_ui",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 16 - 23
				local index = params._datas.index
				local root = params._datas._self

				local state = SummerDrinkHandle.getTaskRewardState(index)
				if state == 1 then
					state_machine.lock("summer_drink_cell_open_task_ui", 0, nil)
					state_machine.lock("summer_drink_cell0_open_task_ui", 0, nil)

					local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node ~= nil and response.node.roots ~= nil then
								if root then
									response.node:createEffect(root)
								end

								response.node:runAction(cc.Sequence:create(cc.DelayTime:create(1.5), cc.CallFunc:create(function (sender)
									local getRewardWnd = DrawRareReward:new()
									getRewardWnd:init(7)
									fwin:open(getRewardWnd, fwin._ui)

									state_machine.unlock("summer_drink_cell_open_task_ui", 0, nil)
									state_machine.unlock("summer_drink_cell0_open_task_ui", 0, nil)

									-- 刷新界面以及外部icon红点
									state_machine.excute("summer_drink_refresh_ui", 0, nil)
									state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 172)
								end
								)))
							end
						else
							state_machine.unlock("summer_drink_cell_open_task_ui", 0, nil)
							state_machine.unlock("summer_drink_cell0_open_task_ui", 0, nil)
						end
					end
					protocol_command.summer_cool_weal_get_reward.param_list = "" .. (index - 1)
					NetworkManager:register(protocol_command.summer_cool_weal_get_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
				else
					state_machine.excute("summer_drink_task_window_open", 0, {type = 2, index = index})
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(summer_drink_cell0_open_task_ui_terminal)
	end
	-- call func init summer drink cell0 state machine.
	init_summer_drink_cell0_terminal()
end

-- 对象初始化
function SummerDrinkCell0:init(params)
	-- 行列宝箱顺序在冰块任务的基础上 +15
	self._index = params + 15

	self:onInit(params)
	self:setContentSize(SummerDrinkCell0.__size)
	return self
end

function SummerDrinkCell0:showOpenBoxImage()
	local Image_box_1 = self.Image_box_1
	local Image_box_2 = self.Image_box_2

	local state = SummerDrinkHandle.getTaskRewardState(self._index)
	Image_box_1:setVisible(state == 0)
	Image_box_2:setVisible(state == 2)

	if state == 2 then
		self.Panel_1:setTouchEnabled(false)
	end

	if state == 1 then
		self:createIceHighlightEffect()
	end
end

-- 添加饮料杯任务可领取高光动画
function SummerDrinkCell0:createIceHighlightEffect()
	local Panel_effect = self.Panel_effect
	Panel_effect:removeAllChildren(true)

	local jsonFile = "images/ui/effice/effect_summer_drink/effect_summer_drink.json"
	local atlasFile = "images/ui/effice/effect_summer_drink/effect_summer_drink.atlas"

	local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation3", true, nil)
	sp.initArmature(animation, true)
	animation:setAnimation(0, "animation3", true)
	animation:setPosition(cc.p(Panel_effect:getContentSize().width/2, Panel_effect:getContentSize().height/2))
	Panel_effect:addChild(animation)

	-- 保存动画
	self._animation = animation
end

-- 行列奖励领取动画
function SummerDrinkCell0:createEffect(root)
	root.Image_box_1:setVisible(false)
	root.Image_box_2:setVisible(false)

	root._animation:setAnimation(0, "animation4", false)
end

function SummerDrinkCell0:onUpdateDraw()
	local root = self.roots[1]

	self.Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
	self.Panel_effect:removeAllChildren(true)

	self.Panel_1 = ccui.Helper:seekWidgetByName(root, "Panel_1")
	fwin:removeTouchEventListener(self.Panel_1)
	fwin:addTouchEventListener(self.Panel_1, nil,
	{
		terminal_name = "summer_drink_cell0_open_task_ui",
		terminal_state = 0,
		isPressedActionEnabled = true,
		index = self._index,
		_self = self
	}, nil, 0)

	-- 初始静态图
	self.Image_box_1 = ccui.Helper:seekWidgetByName(root, "Image_box_1")

	-- 领取完成静态图
	self.Image_box_2 = ccui.Helper:seekWidgetByName(root, "Image_box_2")

	-- 可领取静态图
	self.Image_box_0 = ccui.Helper:seekWidgetByName(root, "Image_box_0")
	self.Image_box_0:setVisible(false)
	
	self:showOpenBoxImage()
end

function SummerDrinkCell0:onEnterTransitionFinish()
	
end

function SummerDrinkCell0:onInit(params)
	-- 加载SummerDrinkCell0Window界面资源.
	-- res.activity.summer_drink.summer_drink_cell_0 = res/activity/summer_drink/summer_drink_cell_0.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/summer_drink/summer_drink_cell_0.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/summer_drink/summer_drink_cell_0.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if SummerDrinkCell0.__size == nil then
		SummerDrinkCell0.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function SummerDrinkCell0:onExit()
	-- 释放SummerDrinkCell0Window界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/summer_drink/summer_drink_cell_0.csb", root)
	-- ]]
end

function SummerDrinkCell0:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function SummerDrinkCell0:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/summer_drink/summer_drink_cell_0.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
