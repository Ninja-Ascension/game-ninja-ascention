--[[ ----------------------------------------------------------------------------
-- 滚动条
--]] ----------------------------------------------------------------------------
RoleBiographyAchievementCell1 = class("RoleBiographyAchievementCell1Class", Window)
RoleBiographyAchievementCell1.__size = nil

-- 创建Cell实例
local role_biography_achievement_cell_1_create_terminal = {
	_name = "role_biography_achievement_cell_1_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if RoleBiographyAchievementCell1 then
			local cell = RoleBiographyAchievementCell1:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(role_biography_achievement_cell_1_create_terminal)
state_machine.init()

-- 构造器
function RoleBiographyAchievementCell1:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize ninja biographies task0 page state machine.
	local function init_role_biography_achievement_cell_1_terminal()
		-- 更新选中光效
		local role_biography_achievement_cell_1_select_terminal = {
			_name = "role_biography_achievement_cell_1_select",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					local index = params
					instance:updateSelect(index)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		state_machine.add(role_biography_achievement_cell_1_select_terminal)
	end
	-- call func init ninja biographies task0 state machine.
	init_role_biography_achievement_cell_1_terminal()
end

-- 对象初始化
function RoleBiographyAchievementCell1:init(params)
	self:onInit(params)
	self:setContentSize(RoleBiographyAchievementCell1.__size)
	return self
end

function RoleBiographyAchievementCell1:updateSelect(index)
	for i, v in ipairs(self._Panel_ban) do
		local selectImage = nil
		local cell = v:getChildren()[1]
		if cell ~= nil then
			local root = cell:getChildByName("root")
			if root ~= nil then
				selectImage = root:getChildByName("Image_1")
			end
		end
		if selectImage then
			selectImage:setVisible(i == index)
		end
	end
end

function RoleBiographyAchievementCell1:onUpdateDraw()
	local root = self.roots[1]

	self._Panel_ban = {}
	local mCount = dms.count(dms["biographies_achieve"])
	for i = 1, mCount do
		table.insert(self._Panel_ban, ccui.Helper:seekWidgetByName(root, "Panel_ban_"..i))
	end

	local Image_line = {}
	for i = 1, (mCount-1) do
		table.insert(Image_line, ccui.Helper:seekWidgetByName(root, "Image_line_"..i))
	end

	for i, v in ipairs(self._Panel_ban) do
		v:removeAllChildren(true)

		local achieveData = dms.element(dms["biographies_achieve"], i)
		-- print("achieveData = ", achieveData)
		if achieveData then
			local cell = state_machine.excute("role_biography_achievement_cell_2_create", 0, {i, achieveData})
			v:addChild(cell)
			v:setVisible(true)
		else
			v:setVisible(false)
		end
	end

	for i, v in ipairs(Image_line) do
		v:setVisible(false)

		local achieveData = dms.element(dms["biographies_achieve"], i + 1)

		if achieveData then
			local id = dms.atof(achieveData, biographies_achieve.id)
			local isUnlock = RoleBiographyHandle.getAchievementIsUnlock(id)
			if isUnlock then
				v:setVisible(true)
			end
		end
	end

	local ScrollView_1 = ccui.Helper:seekWidgetByName(root, "ScrollView_1")

	local totalIndex = dms.count(dms["biographies_achieve"])
	local jumpIndex = self:getNextUnlockAchievementId()

	if jumpIndex <= 6 then
		ScrollView_1:jumpToLeft()
	else
		ScrollView_1:jumpToPercentHorizontal(((jumpIndex - 1) / totalIndex)*100)
	end
	
	self:updateSelect(jumpIndex)
end

function RoleBiographyAchievementCell1:getNextUnlockAchievementId()
	local jumpIndex = 1
	local totalIndex = dms.count(dms["biographies_achieve"])

	for i, v in ipairs(dms["biographies_achieve"]) do
		local id = dms.atof(v, biographies_achieve.id)
		local isUnlock = RoleBiographyHandle.getAchievementIsUnlock(id)
		if isUnlock then
			jumpIndex = jumpIndex + 1
		end
	end

	return jumpIndex > totalIndex and totalIndex or jumpIndex
end

function RoleBiographyAchievementCell1:onEnterTransitionFinish()
	
end

function RoleBiographyAchievementCell1:onInit(params)
	-- 加载RoleBiographyAchievementCell1Window界面资源.
	-- res.cultivate.ninja_biographies.ninja_biographies_task_0 = res/cultivate/ninja_biographies/ninja_biographies_task_0.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("cultivate/ninja_biographies/ninja_biographies_task_0.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("cultivate/ninja_biographies/ninja_biographies_task_0.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if RoleBiographyAchievementCell1.__size == nil then
		RoleBiographyAchievementCell1.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function RoleBiographyAchievementCell1:onExit()
	-- 释放RoleBiographyAchievementCell1Window界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("cultivate/ninja_biographies/ninja_biographies_task_0.csb", root)
	-- ]]
end

function RoleBiographyAchievementCell1:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function RoleBiographyAchievementCell1:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("cultivate/ninja_biographies/ninja_biographies_task_0.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
