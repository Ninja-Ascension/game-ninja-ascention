--[[ ----------------------------------------------------------------------------
-- 战魂属性文本
--]] ----------------------------------------------------------------------------
FightSpiritZhAttCell = class("FightSpiritZhAttCellClass", Window)
FightSpiritZhAttCell.__size = nil

-- 创建Cell实例
local fight_spirit_zh_att_cell_create_terminal = {
	_name = "fight_spirit_zh_att_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if FightSpiritZhAttCell then
			local cell = FightSpiritZhAttCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fight_spirit_zh_att_cell_create_terminal)
state_machine.init()

-- 构造器
function FightSpiritZhAttCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize fight spirit zh att cell page state machine.
	local function init_fight_spirit_zh_att_cell_terminal()
		
	end
	-- call func init fight spirit zh att cell state machine.
	init_fight_spirit_zh_att_cell_terminal()
end

-- 对象初始化
function FightSpiritZhAttCell:init(params)
	self:onInit(params)
	self:setContentSize(FightSpiritZhAttCell.__size)
	return self
end

function FightSpiritZhAttCell:onUpdateDraw()
	local root = self.roots[1]

	local name, value = getHardenPropertyNameAndValue(self.attrs[1].k, self.attrs[1].v)
	ccui.Helper:seekWidgetByName(root, "Text_1"):setString(name)
	ccui.Helper:seekWidgetByName(root, "Text_num_1"):setString(value)

	if self.attrs[2] then
		local name, value = getHardenPropertyNameAndValue(self.attrs[2].k, self.attrs[2].v)
		ccui.Helper:seekWidgetByName(root, "Text_2"):setString(name)
		ccui.Helper:seekWidgetByName(root, "Text_num_2"):setString(value)
	else
		ccui.Helper:seekWidgetByName(root, "Text_2"):setString("")
		ccui.Helper:seekWidgetByName(root, "Text_num_2"):setString("")
	end
end

function FightSpiritZhAttCell:onEnterTransitionFinish()
	
end

function FightSpiritZhAttCell:onInit(params)
	-- 加载FightSpiritZhAttCellWindow界面资源.
	-- res.cocostudio.packs.FightSpirit_zh_att_cell = res/packs/FightSpirit/FightSpirit_zh_att_cell.csb
	 -- 不使用缓存创建
	local csbNode = csb.createNode("packs/FightSpirit/FightSpirit_zh_att_cell.csb")
	local root = csbNode:getChildByName("root")
	
	-- [[ 使用缓存创建
	-- local root = cacher.createUIRef("packs/FightSpirit/FightSpirit_zh_att_cell.csb", "root")
	-- ]]
	-- root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(csbNode)
	if FightSpiritZhAttCell.__size == nil then
		FightSpiritZhAttCell.__size = root:getContentSize()
	end

	self.attrs = params.attrs

	self:onUpdateDraw()
end

function FightSpiritZhAttCell:onExit()
	-- 释放FightSpiritZhAttCellWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("packs/FightSpirit/FightSpirit_zh_att_cell.csb", root)
	-- ]]
end

function FightSpiritZhAttCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function FightSpiritZhAttCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("packs/FightSpirit/FightSpirit_zh_att_cell.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
