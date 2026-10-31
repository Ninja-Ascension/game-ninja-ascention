--[[ ----------------------------------------------------------------------------
-- 战魂属性文本
--]] ----------------------------------------------------------------------------
FightSpiritObtainCell = class("FightSpiritObtainCellClass", Window)
FightSpiritObtainCell.__size = nil

-- 创建Cell实例
local fight_spirit_obtain_cell_create_terminal = {
	_name = "fight_spirit_obtain_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if FightSpiritObtainCell then
			local cell = FightSpiritObtainCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fight_spirit_obtain_cell_create_terminal)
state_machine.init()

-- 构造器
function FightSpiritObtainCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize fight spirit zh att cell page state machine.
	local function init_fight_spirit_obtain_cell_terminal()
		
	end
	-- call func init fight spirit zh att cell state machine.
	init_fight_spirit_obtain_cell_terminal()
end

-- 对象初始化
function FightSpiritObtainCell:init(params)
	self:onInit(params)
	self:setContentSize(FightSpiritObtainCell.__size)
	return self
end

function FightSpiritObtainCell:onUpdateDraw()
	local root = self.roots[1]

	ccui.Helper:seekWidgetByName(root, "Button_qw"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Text_1"):setVisible(false)
end

function FightSpiritObtainCell:onEnterTransitionFinish()
	
end

function FightSpiritObtainCell:onInit(params)
	-- 加载FightSpiritObtainCellWindow界面资源.
	-- res.cocostudio.packs.FightSpirit_obtain_list = res/packs/FightSpirit/FightSpirit_obtain_list.csb
	 -- 不使用缓存创建
	local csbNode = csb.createNode("packs/FightSpirit/FightSpirit_obtain_list.csb")
	local root = csbNode:getChildByName("root")
	
	-- [[ 使用缓存创建
	-- local root = cacher.createUIRef("packs/FightSpirit/FightSpirit_obtain_list.csb", "root")
	-- ]]
	-- root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(csbNode)
	if FightSpiritObtainCell.__size == nil then
		FightSpiritObtainCell.__size = root:getContentSize()
	end

	self.attrs = params.attrs

	self:onUpdateDraw()
end

function FightSpiritObtainCell:onExit()
	-- 释放FightSpiritObtainCellWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("packs/FightSpirit/FightSpirit_obtain_list.csb", root)
	-- ]]
end

function FightSpiritObtainCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function FightSpiritObtainCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("packs/FightSpirit/FightSpirit_obtain_list.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
