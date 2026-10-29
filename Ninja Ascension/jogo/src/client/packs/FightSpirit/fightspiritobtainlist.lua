--[[ ----------------------------------------------------------------------------
-- @class
--]] ----------------------------------------------------------------------------
FightSpiritObtainList = class("FightSpiritObtainListClass", Window)
FightSpiritObtainList.__size = nil

-- 创建Cell实例
local fight_spirit_obtain_list_create_terminal = {
	_name = "fight_spirit_obtain_list_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if FightSpiritObtainList then
			local cell = FightSpiritObtainList:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fight_spirit_obtain_list_create_terminal)
state_machine.init()

-- 构造器
function FightSpiritObtainList:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize fight spirit obtain list page state machine.
	local function init_fight_spirit_obtain_list_terminal()
		
	end
	-- call func init fight spirit obtain list state machine.
	init_fight_spirit_obtain_list_terminal()
end

-- 对象初始化
function FightSpiritObtainList:init(params)
	self:onInit(params)
	self:setContentSize(FightSpiritObtainList.__size)
	return self
end

function FightSpiritObtainList:onUpdateDraw()
	local root = self.roots[1]

end

function FightSpiritObtainList:onEnterTransitionFinish()
	
end

function FightSpiritObtainList:onInit(params)
	-- 加载FightSpiritObtainListWindow界面资源.
	-- res.cocostudio.packs.FightSpirit_obtain_list = res/packs/FightSpirit/FightSpirit_obtain_list.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("packs/FightSpirit/FightSpirit_obtain_list.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("packs/FightSpirit/FightSpirit_obtain_list.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if FightSpiritObtainList.__size == nil then
		FightSpiritObtainList.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function FightSpiritObtainList:onExit()
	-- 释放FightSpiritObtainListWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("packs/FightSpirit/FightSpirit_obtain_list.csb", root)
	-- ]]
end

function FightSpiritObtainList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function FightSpiritObtainList:unload()
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
