--[[ ----------------------------------------------------------------------------
-- 祈福活动
-- 稀有物品框及普通物品框
--]] ----------------------------------------------------------------------------
PrayActivitywSelectCell = class("PrayActivitywSelectCellClass", Window)
PrayActivitywSelectCell.__size = nil

-- 创建Cell实例
local pray_activityw_select_cell_create_terminal = {
	_name = "pray_activityw_select_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if PrayActivitywSelectCell then
			local cell = PrayActivitywSelectCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(pray_activityw_select_cell_create_terminal)
state_machine.init()

-- 构造器
function PrayActivitywSelectCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize pray activityw select cell page state machine.
	local function init_pray_activityw_select_cell_terminal()
		
	end
	-- call func init pray activityw select cell state machine.
	init_pray_activityw_select_cell_terminal()
end

-- 对象初始化
function PrayActivitywSelectCell:init(params)
	self:onInit(params)
	self:setContentSize(PrayActivitywSelectCell.__size)
	return self
end

function PrayActivitywSelectCell:onUpdateDraw()
	local root = self.roots[1]

	-- 道具显示容器
	self.Panel_1 = ccui.Helper:seekWidgetByName(root, "Panel_1")

	-- 稀有道具框可选择状态
	self.Image_choice_red = ccui.Helper:seekWidgetByName(root, "Image_choice_red")

	-- 稀有道具框正常状态
	self.Image_normal_red = ccui.Helper:seekWidgetByName(root, "Image_normal_red")

	-- 普通道具框可选择状态
	self.Image_choice_bule = ccui.Helper:seekWidgetByName(root, "Image_choice_bule")

	-- 普通道具框正常状态
	self.Image_normal_bule = ccui.Helper:seekWidgetByName(root, "Image_normal_bule")

	-- 物品选择完毕状态
	self.Image_Selected = ccui.Helper:seekWidgetByName(root, "Image_Selected")

	-- 道具名称
	self.Text_Prop_name = ccui.Helper:seekWidgetByName(root, "Text_Prop_name")


	
end

function PrayActivitywSelectCell:onEnterTransitionFinish()
	
end

function PrayActivitywSelectCell:onInit(params)
	-- 加载PrayActivitywSelectCellWindow界面资源.
	-- res.activity.Pray.Pray_item = res/activity/Pray/Pray_item.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/Pray/Pray_item.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/Pray/Pray_item.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if PrayActivitywSelectCell.__size == nil then
		PrayActivitywSelectCell.__size = root:getContentSize()
	end

	-- 道具选择按钮
	self.Button_choice = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_choice"), nil,
	{
		terminal_name = "",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 道具更换按钮
	self.Button_exchange = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_exchange"), nil,
	{
		terminal_name = "",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function PrayActivitywSelectCell:onExit()
	-- 释放PrayActivitywSelectCellWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/Pray/Pray_item.csb", root)
	-- ]]
end

function PrayActivitywSelectCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function PrayActivitywSelectCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/Pray/Pray_item.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
