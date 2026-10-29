--[[ ----------------------------------------------------------------------------
-- 主界面角色背景
--]] ----------------------------------------------------------------------------
CrossTotalWarRole1 = class("CrossTotalWarRole1Class", Window)
CrossTotalWarRole1.__size = nil

-- 创建Cell实例
local cross_total_war_role1_create_terminal = {
	_name = "cross_total_war_role1_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if CrossTotalWarRole1 then
			local cell = CrossTotalWarRole1:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(cross_total_war_role1_create_terminal)
state_machine.init()

-- 构造器
function CrossTotalWarRole1:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize cross total war role1 page state machine.
	local function init_cross_total_war_role1_terminal()
		
	end
	-- call func init cross total war role1 state machine.
	init_cross_total_war_role1_terminal()
end

-- 对象初始化
function CrossTotalWarRole1:init(params)
	self:onInit(params)
	self:setContentSize(CrossTotalWarRole1.__size)
	return self
end

function CrossTotalWarRole1:onUpdateDraw()
	local root = self.roots[1]

end

function CrossTotalWarRole1:onEnterTransitionFinish()
	
end

function CrossTotalWarRole1:onInit(params)
	-- 加载CrossTotalWarRole1Window界面资源.
	-- client.campaign.cross_total_war.cross_total_war_role_1 = client/campaign/cross_total_war/cross_total_war_role_1.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("client/campaign/cross_total_war/cross_total_war_role_1.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("client/campaign/cross_total_war/cross_total_war_role_1.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if CrossTotalWarRole1.__size == nil then
		CrossTotalWarRole1.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function CrossTotalWarRole1:onExit()
	-- 释放CrossTotalWarRole1Window界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("client/campaign/cross_total_war/cross_total_war_role_1.csb", root)
	-- ]]
end

function CrossTotalWarRole1:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function CrossTotalWarRole1:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("client/campaign/cross_total_war/cross_total_war_role_1.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
