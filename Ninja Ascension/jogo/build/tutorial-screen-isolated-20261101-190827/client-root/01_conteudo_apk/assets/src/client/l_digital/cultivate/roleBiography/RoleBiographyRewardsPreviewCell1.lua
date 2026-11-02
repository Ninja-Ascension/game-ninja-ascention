--[[ ----------------------------------------------------------------------------
-- @class
--]] ----------------------------------------------------------------------------
RoleBiographyRewardsPreviewCell1 = class("RoleBiographyRewardsPreviewCell1Class", Window)
RoleBiographyRewardsPreviewCell1.__size = nil

-- 创建Cell实例
local role_biography_rewards_preview_cell_1_create_terminal = {
	_name = "role_biography_rewards_preview_cell_1_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if RoleBiographyRewardsPreviewCell1 then
			local cell = RoleBiographyRewardsPreviewCell1:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(role_biography_rewards_preview_cell_1_create_terminal)
state_machine.init()

-- 构造器
function RoleBiographyRewardsPreviewCell1:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize ninja biographies rewards list1 page state machine.
	local function init_role_biography_rewards_preview_cell_1_terminal()
		
	end
	-- call func init ninja biographies rewards list1 state machine.
	init_role_biography_rewards_preview_cell_1_terminal()
end

-- 对象初始化
function RoleBiographyRewardsPreviewCell1:init(params)
	-- self._index = params.index
	self._quality = params.quality

	self:onInit(params)
	
	self:setContentSize(RoleBiographyRewardsPreviewCell1.__size)
	return self
end

function RoleBiographyRewardsPreviewCell1:onUpdateDraw()
	local root = self.roots[1]

	local Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
	local colorName = _ship_types_by_color[self._quality]
	Text_1:setString(string.format(tipStringInfo_role_biography[5], colorName))
end

function RoleBiographyRewardsPreviewCell1:onEnterTransitionFinish()
	
end

function RoleBiographyRewardsPreviewCell1:onInit(params)
	-- 加载RoleBiographyRewardsPreviewCell1Window界面资源.
	-- res.cultivate.ninja_biographies.ninja_biographies_rewards_list_1 = res/cultivate/ninja_biographies/ninja_biographies_rewards_list_1.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("cultivate/ninja_biographies/ninja_biographies_rewards_list_1.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("cultivate/ninja_biographies/ninja_biographies_rewards_list_1.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if RoleBiographyRewardsPreviewCell1.__size == nil then
		RoleBiographyRewardsPreviewCell1.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function RoleBiographyRewardsPreviewCell1:onExit()
	-- 释放RoleBiographyRewardsPreviewCell1Window界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("cultivate/ninja_biographies/ninja_biographies_rewards_list_1.csb", root)
	-- ]]
end

function RoleBiographyRewardsPreviewCell1:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function RoleBiographyRewardsPreviewCell1:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("cultivate/ninja_biographies/ninja_biographies_rewards_list_1.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
