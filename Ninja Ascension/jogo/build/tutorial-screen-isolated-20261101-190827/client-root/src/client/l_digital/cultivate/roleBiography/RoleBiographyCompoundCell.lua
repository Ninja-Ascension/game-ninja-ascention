--[[ ----------------------------------------------------------------------------
-- 
--]] ----------------------------------------------------------------------------
RoleBiographyCompoundCell = class("RoleBiographyCompoundCellClass", Window)
RoleBiographyCompoundCell.__size = nil

-- 创建Cell实例
local role_biography_compound_cell_create_terminal = {
	_name = "role_biography_compound_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if RoleBiographyCompoundCell then
			local cell = RoleBiographyCompoundCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(role_biography_compound_cell_create_terminal)
state_machine.init()

-- 构造器
function RoleBiographyCompoundCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize ninja biographies obtain list page state machine.
	local function init_role_biography_compound_cell_terminal()
		
	end
	-- call func init ninja biographies obtain list state machine.
	init_role_biography_compound_cell_terminal()
end

-- 对象初始化
function RoleBiographyCompoundCell:init(params)
	self._propInfo = params

	self:onInit(params)
	self:setContentSize(RoleBiographyCompoundCell.__size)
	return self
end

function RoleBiographyCompoundCell:onUpdateDraw()
	local root = self.roots[1]

	self.Panel_player_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_1")
	self.Text_quantity = ccui.Helper:seekWidgetByName(root, "Text_quantity")

	local propId = self._propInfo[2]
	local propData = {6, propId, 0}

	local cell = DrawHandle.drawIcon(propData)
	self.Panel_player_icon_1:addChild(cell)

	local needCount = zstring.tonumber(self._propInfo[3])
	local haveCount = zstring.tonumber(getPropAllCountByMouldId(propId))
	self.Text_quantity:setString(haveCount .. "/" .. needCount)
end

function RoleBiographyCompoundCell:updateHaveCount()
	local needCount = zstring.tonumber(self._propInfo[3])
	local propId = self._propInfo[2]
	local haveCount = zstring.tonumber(getPropAllCountByMouldId(propId))
	self.Text_quantity:setString(haveCount .. "/" .. needCount)
end

function RoleBiographyCompoundCell:onEnterTransitionFinish()
	
end

function RoleBiographyCompoundCell:onInit(params)
	-- 加载RoleBiographyCompoundCellWindow界面资源.
	-- res.cultivate.ninja_biographies.ninja_biographies_synthesis_cell = res/cultivate/ninja_biographies/ninja_biographies_synthesis_cell.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("cultivate/ninja_biographies/ninja_biographies_synthesis_cell.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("cultivate/ninja_biographies/ninja_biographies_synthesis_cell.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if RoleBiographyCompoundCell.__size == nil then
		RoleBiographyCompoundCell.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function RoleBiographyCompoundCell:onExit()
	-- 释放RoleBiographyCompoundCellWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("cultivate/ninja_biographies/ninja_biographies_synthesis_cell.csb", root)
	-- ]]
end

function RoleBiographyCompoundCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function RoleBiographyCompoundCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("cultivate/ninja_biographies/ninja_biographies_synthesis_cell.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
