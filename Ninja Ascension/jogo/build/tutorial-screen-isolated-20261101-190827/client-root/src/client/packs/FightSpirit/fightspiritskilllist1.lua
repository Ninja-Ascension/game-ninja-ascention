--[[ ----------------------------------------------------------------------------
-- @class
--]] ----------------------------------------------------------------------------
FightSpiritSkillList1 = class("FightSpiritSkillList1Class", Window)
FightSpiritSkillList1.__size = nil

-- 创建Cell实例
local fight_spirit_skill_list1_create_terminal = {
	_name = "fight_spirit_skill_list1_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if FightSpiritSkillList1 then
			local cell = FightSpiritSkillList1:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fight_spirit_skill_list1_create_terminal)
state_machine.init()

-- 构造器
function FightSpiritSkillList1:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize fight spirit skill list1 page state machine.
	local function init_fight_spirit_skill_list1_terminal()
		
	end
	-- call func init fight spirit skill list1 state machine.
	init_fight_spirit_skill_list1_terminal()
end

-- 对象初始化
function FightSpiritSkillList1:init(params)
	self:onInit(params)
	self:setContentSize(FightSpiritSkillList1.__size)
	return self
end

function FightSpiritSkillList1:onUpdateDraw()
	local root = self.roots[1]

end

function FightSpiritSkillList1:onEnterTransitionFinish()
	
end

function FightSpiritSkillList1:onInit(params)
	-- 加载FightSpiritSkillList1Window界面资源.
	-- res.cocostudio.packs.FightSpirit_skill_list_1 = res/packs/FightSpirit/FightSpirit_skill_list_1.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("packs/FightSpirit/FightSpirit_skill_list_1.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("packs/FightSpirit/FightSpirit_skill_list_1.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if FightSpiritSkillList1.__size == nil then
		FightSpiritSkillList1.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function FightSpiritSkillList1:onExit()
	-- 释放FightSpiritSkillList1Window界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("packs/FightSpirit/FightSpirit_skill_list_1.csb", root)
	-- ]]
end

function FightSpiritSkillList1:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function FightSpiritSkillList1:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("packs/FightSpirit/FightSpirit_skill_list_1.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
