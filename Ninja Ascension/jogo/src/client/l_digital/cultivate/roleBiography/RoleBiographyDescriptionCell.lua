--[[ ----------------------------------------------------------------------------
-- 列传详情
--]] ----------------------------------------------------------------------------
RoleBiographyDescriptionCell = class("RoleBiographyDescriptionCellClass", Window)
RoleBiographyDescriptionCell.__size = nil

-- 创建Cell实例
local role_biography_description_cell_create_terminal = {
	_name = "role_biography_description_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if RoleBiographyDescriptionCell then
			local cell = RoleBiographyDescriptionCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(role_biography_description_cell_create_terminal)
state_machine.init()

-- 构造器
function RoleBiographyDescriptionCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize ninja biographies imprint list page state machine.
	local function init_role_biography_description_cell_terminal()
		
	end
	-- call func init ninja biographies imprint list state machine.
	init_role_biography_description_cell_terminal()
end

-- 对象初始化
function RoleBiographyDescriptionCell:init(params)
	self._index = params.index
	self._data = params.data

	if self._index < 9 then
		self:onInit(params)
	end
	self:setContentSize(RoleBiographyDescriptionCell.__size)
	return self
end

function RoleBiographyDescriptionCell:onUpdateDraw()
	local root = self.roots[1]

	-- 忍列传名字
	self.Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")

	-- 加的印记值
	self.Text_1_0 = ccui.Helper:seekWidgetByName(root, "Text_1_0")

	self.ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")

	
	local data = self._data

	local name_mould_id = dms.atof(data, biographies_mould.name)
	local word_info = dms.element(dms["word_mould"], name_mould_id)
    local name = word_info[3]

	local achievementAdd = dms.atof(data, biographies_mould.achievementAdd)

	self.Text_1:setString(name)
	self.Text_1_0:setString(string.format(tipStringInfo_role_biography[2], achievementAdd))

	local biographyId = dms.atof(data, biographies_mould.id)
	local isActivate = RoleBiographyHandle.getBiographyIsActivate(biographyId)
	if isActivate then
		self.Text_1:setColor(cc.c3b(0, 128, 0))
		self.Text_1_0:setColor(cc.c3b(0, 128, 0))
	end


	local signetCostStr = dms.atos(data, biographies_mould.signet_cost)
    local signetCost = zstring.splits(signetCostStr, "|", ",")

	local ListView_1 = self.ListView_1
	ListView_1:removeAllItems()
	for _, v in ipairs(signetCost) do
		local cell = RoleBiographyHandle.addSpecialIconCell(v, false, false)
		ListView_1:addChild(cell)
	end

	ListView_1:jumpToLeft()
	ListView_1:requestRefreshView()
end

function RoleBiographyDescriptionCell:clearUIInfo( ... )
	local root = self.roots[1]
	if root == nil then
		return
	end

	self.Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
	self.Text_1:setString("")
	self.Text_1:setColor(cc.c3b(113, 34, 0))

	self.Text_1_0 = ccui.Helper:seekWidgetByName(root, "Text_1_0")
	self.Text_1_0:setString("")
	self.Text_1_0:setColor(cc.c3b(113, 34, 0))


	self.ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")
	self.ListView_1:removeAllItems()
end

function RoleBiographyDescriptionCell:onEnterTransitionFinish()
	
end

function RoleBiographyDescriptionCell:onInit(params)
	-- 加载NinjaBiographiesImprintListWindow界面资源.
	-- res.cultivate.ninja_biographies.ninja_biographies_imprint_list = res/cultivate/ninja_biographies/ninja_biographies_imprint_list.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("cultivate/ninja_biographies/ninja_biographies_imprint_list.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("cultivate/ninja_biographies/ninja_biographies_imprint_list.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if RoleBiographyDescriptionCell.__size == nil then
		RoleBiographyDescriptionCell.__size = root:getContentSize()
	end
	self:clearUIInfo()
	self:onUpdateDraw()
end

function RoleBiographyDescriptionCell:onExit()
	-- 释放NinjaBiographiesImprintListWindow界面资源.
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("cultivate/ninja_biographies/ninja_biographies_imprint_list.csb", root)
	-- ]]
end

function RoleBiographyDescriptionCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function RoleBiographyDescriptionCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("cultivate/ninja_biographies/ninja_biographies_imprint_list.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
