--[[ ----------------------------------------------------------------------------
-- @class
--]] ----------------------------------------------------------------------------
FightSpiritSkillList2 = class("FightSpiritSkillList2Class", Window)
FightSpiritSkillList2.__size = nil

-- 创建Cell实例
local fight_spirit_skill_list2_create_terminal = {
	_name = "fight_spirit_skill_list2_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if FightSpiritSkillList2 then
			local cell = FightSpiritSkillList2:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fight_spirit_skill_list2_create_terminal)
state_machine.init()

-- 构造器
function FightSpiritSkillList2:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize fight spirit skill list2 page state machine.
	local function init_fight_spirit_skill_list2_terminal()
		
	end
	-- call func init fight spirit skill list2 state machine.
	init_fight_spirit_skill_list2_terminal()
end

-- 对象初始化
function FightSpiritSkillList2:init(params)
	self:onInit(params)
	self:setContentSize(FightSpiritSkillList2.__size)
	return self
end

function FightSpiritSkillList2:onUpdateDraw()
	local root = self.roots[1]

end

function FightSpiritSkillList2:onEnterTransitionFinish()
	
end

function FightSpiritSkillList2:onInit(params)
	-- 加载FightSpiritSkillList2Window界面资源.
	-- res.cocostudio.packs.FightSpirit_skill_list_2 = res/packs/FightSpirit/FightSpirit_skill_list_2.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("packs/FightSpirit/FightSpirit_skill_list_2.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("packs/FightSpirit/FightSpirit_skill_list_2.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if FightSpiritSkillList2.__size == nil then
		FightSpiritSkillList2.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function FightSpiritSkillList2:onExit()
	-- 释放FightSpiritSkillList2Window界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("packs/FightSpirit/FightSpirit_skill_list_2.csb", root)
	-- ]]
end

function FightSpiritSkillList2:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function FightSpiritSkillList2:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("packs/FightSpirit/FightSpirit_skill_list_2.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
