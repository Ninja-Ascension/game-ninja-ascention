--[[ ----------------------------------------------------------------------------
-- 冰块任务界面
--]] ----------------------------------------------------------------------------
SummerDrinkCell = class("SummerDrinkCellClass", Window)
SummerDrinkCell.__size = nil

-- 创建Cell实例
local summer_drink_cell_create_terminal = {
	_name = "summer_drink_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if SummerDrinkCell then
			local cell = SummerDrinkCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(summer_drink_cell_create_terminal)
state_machine.init()

-- 构造器
function SummerDrinkCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize summer drink cell page state machine.
	local function init_summer_drink_cell_terminal()
		-- 打开任务界面
		local summer_drink_cell_open_task_ui_terminal = {
			_name = "summer_drink_cell_open_task_ui",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 1 - 15
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

								 response.node:runAction(cc.Sequence:create(cc.DelayTime:create(2.0), cc.CallFunc:create(function (sender)
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
					state_machine.excute("summer_drink_task_window_open", 0, {type = 1, index = index})
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(summer_drink_cell_open_task_ui_terminal)
	end
	-- call func init summer drink cell state machine.
	init_summer_drink_cell_terminal()
end

-- 对象初始化
function SummerDrinkCell:init(params)
	self._index = params

	self:onInit(params)
	self:setContentSize(SummerDrinkCell.__size)
	return self
end

function SummerDrinkCell:showIceImage()
	local state = SummerDrinkHandle.getTaskRewardState(self._index)

	if state == 1 then
		self:createIceHighlightEffect()
	end
end

-- 添加冰块任务可领取高光动画
function SummerDrinkCell:createIceHighlightEffect()
	local Panel_effect = self.Panel_effect
	Panel_effect:removeAllChildren(true)

	local jsonFile = "images/ui/effice/effect_summer_drink/effect_summer_drink.json"
	local atlasFile = "images/ui/effice/effect_summer_drink/effect_summer_drink.atlas"

	local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
	sp.initArmature(animation, true)
	animation:setAnimation(0, "animation", true)
	animation:setPosition(cc.p(Panel_effect:getContentSize().width/2, Panel_effect:getContentSize().height/2))
	Panel_effect:addChild(animation)

	-- 保存动画
	self._animation = animation
end

-- 领取奖励时的冰块破碎动画
function SummerDrinkCell:createEffect(root)
	-- 摇晃冰块时隐藏底图
	root.Image_ice_1:setVisible(false)

	root._animation:setAnimation(0, "animation2", false)
end

function SummerDrinkCell:onUpdateDraw()
	local root = self.roots[1]

	self.Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
	self.Panel_effect:removeAllChildren(true)

	self.Panel_1 = ccui.Helper:seekWidgetByName(root, "Panel_1")
	fwin:removeTouchEventListener(self.Panel_1)
	fwin:addTouchEventListener(self.Panel_1, nil,
	{
		terminal_name = "summer_drink_cell_open_task_ui",
		terminal_state = 0,
		isPressedActionEnabled = true,
		index = self._index,
		_self = self
	}, nil, 0)

	-- 初始静态图
	self.Image_ice_1 = ccui.Helper:seekWidgetByName(root, "Image_ice_1")
	self.Image_ice_1:setVisible(true)

	-- 可领取静态图
	self.Image_ice_0 = ccui.Helper:seekWidgetByName(root, "Image_ice_0")
	self.Image_ice_0:setVisible(false)

	self:showIceImage()
end

function SummerDrinkCell:onEnterTransitionFinish()
	
end

function SummerDrinkCell:onInit(params)
	-- 加载SummerDrinkCellWindow界面资源.
	-- res.activity.summer_drink.summer_drink_cell = res/activity/summer_drink/summer_drink_cell.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/summer_drink/summer_drink_cell.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/summer_drink/summer_drink_cell.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if SummerDrinkCell.__size == nil then
		SummerDrinkCell.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function SummerDrinkCell:onExit()
	-- 释放SummerDrinkCellWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/summer_drink/summer_drink_cell.csb", root)
	-- ]]
end

function SummerDrinkCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function SummerDrinkCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/summer_drink/summer_drink_cell.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
