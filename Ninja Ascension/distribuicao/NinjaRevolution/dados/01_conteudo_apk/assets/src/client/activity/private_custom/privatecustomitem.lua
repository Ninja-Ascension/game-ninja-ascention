--[[ ----------------------------------------------------------------------------
-- 主页列表项
--]] ----------------------------------------------------------------------------
PrivateCustomItem = class("PrivateCustomItemClass", Window)
PrivateCustomItem.__size = nil

-- 创建Cell实例
local private_custom_item_create_terminal = {
	_name = "private_custom_item_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if PrivateCustomItem then
			local cell = PrivateCustomItem:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(private_custom_item_create_terminal)
state_machine.init()

-- 构造器
function PrivateCustomItem:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._buttonType = nil
	self._info = nil
	self._index = nil
	self._canClickItem = false
	self._gear = nil

	-- load lua files.

	-- Initialize private custom item page state machine.
	local function init_private_custom_item_terminal()
		-- 点击panel_item
		local private_custom_item_click_panel_item_terminal = {
			_name = "private_custom_item_click_panel_item",
			_init = function (terminal)

			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local buttonType = params._datas.buttonType
					local index = params._datas.index
					local gear = params._datas.gear

					if buttonType == 1 then
						-- 打开物品选择界面
						state_machine.excute("private_custom_formation_window_open", 0, {index = index, gear = gear})
					elseif buttonType == 2 then
						-- 刷新下方道具列表
						state_machine.excute("private_custom_formation_select_top_prop", 0, {index = index})
					elseif buttonType == 3 then
						-- 选中下方道具
						state_machine.excute("private_custom_formation_select_bottom_prop", 0, {index = index})
					end
				end
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		state_machine.add(private_custom_item_click_panel_item_terminal)
	end
	-- call func init private custom item state machine.
	init_private_custom_item_terminal()
end

-- 对象初始化
function PrivateCustomItem:init(params)
	-- 主界面类型为1 物品选择界面为2
	self._buttonType = params.buttonType

	-- 道具信息
	self._info = params.info

	-- 点击的是哪个icon
	self._index = params.index

	-- 能否点击图标（即可选位置）
	self._canClickItem = params.canClickItem

	-- 充值档位
	self._gear = params.gear

	self:onInit(params)
	self:setContentSize(PrivateCustomItem.__size)
	return self
end

function PrivateCustomItem:updateUI()
	self.Image_add:setVisible(false)
	self.Panel_effect_1:setVisible(false)
	self.Panel_item:removeAllChildren()

	local reward = self._info

	if reward and tonumber(reward[1]) > 0 then
		local cell = self:addResourcesIconCell(reward)
		self.Panel_item:addChild(cell)
	else
		self.Image_add:setVisible(true)
	end
end

function PrivateCustomItem:addResourcesIconCell(propData)
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

function PrivateCustomItem:showSelectEffect(isShow)
	self.Panel_effect_1:setVisible(isShow)
end

function PrivateCustomItem:onUpdateDraw()
	local root = self.roots[1]

	-- item容器
	self.Panel_item = ccui.Helper:seekWidgetByName(root, "Panel_item")
	-- 先移除原有的触摸事件
	fwin:removeTouchEventListener(self.Panel_item)
	-- 如果该位置是可选位置
	if self._canClickItem then
		-- print("添加点击事件 buttonType = ", self._buttonType, self._index, self._gear)
		fwin:addTouchEventListener(self.Panel_item, nil, 
		{
			terminal_name = "private_custom_item_click_panel_item",
			terminal_state = 0, 
			isPressedActionEnabled = true,
			buttonType = self._buttonType,
			index = self._index,
			gear = self._gear
		},
		nil, 0)
	end
	
	-- 加号 默认隐藏
	self.Image_add = ccui.Helper:seekWidgetByName(root, "Image_add")

	-- 选中光效 默认隐藏
	self.Panel_effect_1 = ccui.Helper:seekWidgetByName(root, "Panel_effect_1")


	self:updateUI()
end

function PrivateCustomItem:onEnterTransitionFinish()
	
end

function PrivateCustomItem:onInit(params)
	-- 加载PrivateCustomItemWindow界面资源.
	-- res.activity.private_custom.private_custom_item = res/activity/private_custom/private_custom_item.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/private_custom/private_custom_item.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/private_custom/private_custom_item.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if PrivateCustomItem.__size == nil then
		PrivateCustomItem.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function PrivateCustomItem:onExit()
	-- 释放PrivateCustomItemWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/private_custom/private_custom_item.csb", root)
	-- ]]
end

function PrivateCustomItem:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function PrivateCustomItem:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/private_custom/private_custom_item.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
