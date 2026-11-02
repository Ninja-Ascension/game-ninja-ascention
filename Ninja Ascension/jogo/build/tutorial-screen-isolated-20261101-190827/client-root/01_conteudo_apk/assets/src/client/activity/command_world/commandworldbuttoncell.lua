--[[ ----------------------------------------------------------------------------
-- 排名展示
--]] ----------------------------------------------------------------------------
CommandWorldButtonCell = class("CommandWorldButtonCellClass", Window)
CommandWorldButtonCell.__size = nil

-- 创建Cell实例
local command_world_button_cell_create_terminal = {
	_name = "command_world_button_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if CommandWorldButtonCell then
			local cell = CommandWorldButtonCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(command_world_button_cell_create_terminal)
state_machine.init()

-- 构造器
function CommandWorldButtonCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize command world cell2 page state machine.
	local function init_command_world_button_cell_terminal()
		
	end
	-- call func init command world cell2 state machine.
	init_command_world_button_cell_terminal()
end

-- 对象初始化
function CommandWorldButtonCell:init(params)
	self._tabType = params.tabType

	self:onInit(params)
	self:setContentSize(CommandWorldButtonCell.__size)
	return self
end

function CommandWorldButtonCell:updateUI()
	for i, v in ipairs(self.Buttons) do
		v:setVisible(i == self._tabType)
	end

	local isShowDot = CommandWorldHandle.getCommandWorldShowRedDotByType(self._tabType)
	self.Image_1:setVisible(isShowDot)
end

function CommandWorldButtonCell:onUpdateDraw()
	local root = self.roots[1]

	-- 商店按钮
	self.Button_shop = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_shop"), nil,
	{
		terminal_name = "command_world_open_shop",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 排行按钮
	self.Button_rank = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rank"), nil,
	{
		terminal_name = "command_world_open_rank",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 任务按钮
	self.Button_task = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_task"), nil,
	{
		terminal_name = "command_world_open_task",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 跳转特惠礼包
	self.Button_rechange = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rechange"), nil,
	{
		terminal_name = "command_world_jump_single_recharge",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 荣誉榜按钮
	self.Button_list = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_list"), nil,
	{
		terminal_name = "command_world_open_glory",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	-- 排行，活跃任务，充值有礼，商店，荣耀榜
	self.Buttons = {self.Button_rank, self.Button_task, self.Button_rechange, self.Button_shop, self.Button_list}

	self.Image_1 = ccui.Helper:seekWidgetByName(root, "Image_1")

	self:updateUI()
end

function CommandWorldButtonCell:onEnterTransitionFinish()
	
end

function CommandWorldButtonCell:onInit(params)
	-- 加载CommandWorldButtonCellWindow界面资源.
	-- res.activity.command_world.command_world_button = res/activity/command_world/command_world_button.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/command_world/command_world_button.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/command_world/command_world_button.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if CommandWorldButtonCell.__size == nil then
		CommandWorldButtonCell.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function CommandWorldButtonCell:onExit()
	-- 释放CommandWorldButtonCellWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/command_world/command_world_button.csb", root)
	-- ]]
end

function CommandWorldButtonCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function CommandWorldButtonCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/command_world/command_world_button.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
