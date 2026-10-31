--[[ ----------------------------------------------------------------------------
-- @class
--]] ----------------------------------------------------------------------------
RoleBiographyRewardsPreviewCell2 = class("RoleBiographyRewardsPreviewCell2Class", Window)
RoleBiographyRewardsPreviewCell2.__size = nil

-- 创建Cell实例
local role_biography_rewards_preview_cell_2_create_terminal = {
	_name = "role_biography_rewards_preview_cell_2_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if RoleBiographyRewardsPreviewCell2 then
			local cell = RoleBiographyRewardsPreviewCell2:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(role_biography_rewards_preview_cell_2_create_terminal)
state_machine.init()

-- 构造器
function RoleBiographyRewardsPreviewCell2:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize ninja biographies rewards list2 page state machine.
	local function init_role_biography_rewards_preview_cell_2_terminal()
		
	end
	-- call func init ninja biographies rewards list2 state machine.
	init_role_biography_rewards_preview_cell_2_terminal()
end

-- 对象初始化
function RoleBiographyRewardsPreviewCell2:init(params)
	self._index = params.index
	self._data = params.data

	-- if self._index <= 4 then
		self:onInit(params)
	-- end
	self:setContentSize(RoleBiographyRewardsPreviewCell2.__size)
	return self
end

function RoleBiographyRewardsPreviewCell2:onUpdateDraw()
	local root = self.roots[1]

	local ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")
	ListView_1:removeAllItems()

	local data = self._data
	for _, v in ipairs(data) do
		local cell = self:addResourcesIconCell(v)
		ListView_1:addChild(cell)
	end

	ListView_1:jumpToLeft()
	ListView_1:requestRefreshView()
end

function RoleBiographyRewardsPreviewCell2:addResourcesIconCell(propData)
	local cell = ResourcesIconCell:createCell()
	local rewardType = tonumber(propData[1])
	if 13 == rewardType then
		local extraTable = {}
		if propData[4] ~= nil and tonumber(propData[4]) ~= -1 then
			extraTable.shipStar = tonumber(propData[4])
		else
			extraTable.shipStar = 0
		end
		cell:init(rewardType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true, true, 1, extraTable)
	else
		cell:init(rewardType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true ,true, 1)
	end
	return cell
end

function RoleBiographyRewardsPreviewCell2:onEnterTransitionFinish()
	
end

function RoleBiographyRewardsPreviewCell2:onInit(params)
	-- 加载RoleBiographyRewardsPreviewCell2Window界面资源.
	-- res.cultivate.ninja_biographies.ninja_biographies_rewards_list_2 = res/cultivate/ninja_biographies/ninja_biographies_rewards_list_2.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("cultivate/ninja_biographies/ninja_biographies_rewards_list_2.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("cultivate/ninja_biographies/ninja_biographies_rewards_list_2.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if RoleBiographyRewardsPreviewCell2.__size == nil then
		RoleBiographyRewardsPreviewCell2.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function RoleBiographyRewardsPreviewCell2:onExit()
	-- 释放RoleBiographyRewardsPreviewCell2Window界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("cultivate/ninja_biographies/ninja_biographies_rewards_list_2.csb", root)
	-- ]]
end

function RoleBiographyRewardsPreviewCell2:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function RoleBiographyRewardsPreviewCell2:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("cultivate/ninja_biographies/ninja_biographies_rewards_list_2.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
