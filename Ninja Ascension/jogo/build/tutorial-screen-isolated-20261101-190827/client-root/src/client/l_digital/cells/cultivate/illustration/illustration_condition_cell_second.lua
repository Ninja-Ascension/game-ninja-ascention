--[[ ----------------------------------------------------------------------------
-- 条件列表项
--]] ----------------------------------------------------------------------------
IllustrationConditionCellSecond = class("IllustrationConditionCellSecondClass", Window)
IllustrationConditionCellSecond.__size = nil

-- 创建Cell实例
local illustration_condition_cell_second_create_terminal = {
	_name = "illustration_condition_cell_second_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if IllustrationConditionCellSecond then
			local cell = IllustrationConditionCellSecond:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(illustration_condition_cell_second_create_terminal)
state_machine.init()

-- 构造器
function IllustrationConditionCellSecond:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._combine_card_data = nil

	-- load lua files.

	-- Initialize lim pool record list page state machine.
	local function init_illustration_condition_cell_second_terminal()
		
	end
	-- call func init lim pool record list state machine.
	init_illustration_condition_cell_second_terminal()
end

-- 对象初始化
function IllustrationConditionCellSecond:init(params)
	self._combine_card_data = params[1]

	self:onInit(params)
	self:setContentSize(IllustrationConditionCellSecond.__size)
	return self
end

function IllustrationConditionCellSecond:updateUI()
	local special_condition_str = self._combine_card_data[ship_illustration_card_mould.special_condition]
	local special_condition = zstring.split(special_condition_str, ",")

	local maxProgress = table.nums(special_condition)

	self.Text_t_2:setString(maxProgress)

	local nowProgress = IllustrationHandle.getSpecialTaskFinishedCount(self._combine_card_data)
	self.Text_t_1:setString(nowProgress)

	if nowProgress >= maxProgress then
		self.Text_t_0:setColor(cc.c3b(0, 203, 11))
		self.Text_t_1:setColor(cc.c3b(0, 203, 11))
		self.Text_t_2:setColor(cc.c3b(0, 203, 11))
	else
		self.Text_t_0:setColor(cc.c3b(125, 58, 0))
		self.Text_t_1:setColor(cc.c3b(125, 58, 0))
		self.Text_t_2:setColor(cc.c3b(125, 58, 0))
	end
end

function IllustrationConditionCellSecond:onUpdateDraw()
	local root = self.roots[1]

	-- 斜杠
	self.Text_t_0 = ccui.Helper:seekWidgetByName(root, "Text_t_0")

	-- 当前进度
	self.Text_t_1 = ccui.Helper:seekWidgetByName(root, "Text_t_1")

	-- 总进度
	self.Text_t_2 = ccui.Helper:seekWidgetByName(root, "Text_t_2")

	self:updateUI()
end

function IllustrationConditionCellSecond:onEnterTransitionFinish()
	
end

function IllustrationConditionCellSecond:onInit(params)
	-- 加载IllustrationConditionCellSecondWindow界面资源.
	-- res.cultivate.illustration.illustration_levelup_list_2 = res/cultivate/illustration/illustration_levelup_list_2.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("cultivate/illustration/illustration_levelup_list_2.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("cultivate/illustration/illustration_levelup_list_2.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if IllustrationConditionCellSecond.__size == nil then
		IllustrationConditionCellSecond.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function IllustrationConditionCellSecond:onExit()
	-- 释放IllustrationConditionCellSecondWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("cultivate/illustration/illustration_levelup_list_2.csb", root)
	-- ]]
end

function IllustrationConditionCellSecond:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function IllustrationConditionCellSecond:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("cultivate/illustration/illustration_levelup_list_2.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
