--[[ ----------------------------------------------------------------------------
-- 神兽连携属性cell
--]] ----------------------------------------------------------------------------
MythicalAnimalsLeaguePropertyCell = class("MythicalAnimalsLeaguePropertyCellClass", Window)
MythicalAnimalsLeaguePropertyCell.__size = nil

-- 创建Cell实例
local mythical_animals_league_property_cell_create_terminal = {
	_name = "mythical_animals_league_property_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if MythicalAnimalsLeaguePropertyCell then
			local cell = MythicalAnimalsLeaguePropertyCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(mythical_animals_league_property_cell_create_terminal)
state_machine.init()

-- 构造器
function MythicalAnimalsLeaguePropertyCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize ninja biographies0 cell page state machine.
	local function init_mythical_animals_league_property_cell_terminal()
		
	end
	-- call func init ninja biographies0 cell state machine.
	init_mythical_animals_league_property_cell_terminal()
end

-- 对象初始化
function MythicalAnimalsLeaguePropertyCell:init(params)
	self._data = params

	self:onInit(params)
	
	self:setContentSize(MythicalAnimalsLeaguePropertyCell.__size)
	return self
end

function MythicalAnimalsLeaguePropertyCell:onUpdateDraw()
	local root = self.roots[1]

	self.Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
	self.Text_1_0 = ccui.Helper:seekWidgetByName(root, "Text_1_0")

	self:updateUI()
end

function MythicalAnimalsLeaguePropertyCell:updateUI()
	local propertyType = tonumber(self._data.propertyType)
	local propertyValue = tonumber(self._data.propertyValue)
	local name, value = getHardenPropertyNameAndValue(propertyType, propertyValue, true, tipStringInfo_magical_animals_property_name_and_value)

	self.Text_1:setString(name)
	self.Text_1_0:setString(value)
end

function MythicalAnimalsLeaguePropertyCell:onInit(params)
	-- 加载MythicalAnimalsLeaguePropertyCellWindow界面资源.
	-- res.cultivate.Mythical_animals.mythical_animals_properties_cell_3 = res/cultivate/Mythical_animals/mythical_animals_properties_cell_3.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("cultivate/Mythical_animals/mythical_animals_properties_cell_3.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("cultivate/Mythical_animals/mythical_animals_properties_cell_3.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if MythicalAnimalsLeaguePropertyCell.__size == nil then
		MythicalAnimalsLeaguePropertyCell.__size = root:getContentSize()
	end
	self:clearUIInfo()
	self:onUpdateDraw()
end

function MythicalAnimalsLeaguePropertyCell:clearUIInfo( ... )
	local root = self.roots[1]
	if root == nil then
		return
	end

	self.Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
	self.Text_1:setString("")

	self.Text_1_0 = ccui.Helper:seekWidgetByName(root, "Text_1_0")
	self.Text_1_0:setString("")
end

function MythicalAnimalsLeaguePropertyCell:onExit()
	-- 释放MythicalAnimalsLeaguePropertyCellWindow界面资源.
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("cultivate/Mythical_animals/mythical_animals_properties_cell_3.csb", root)
	-- ]]
end

function MythicalAnimalsLeaguePropertyCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function MythicalAnimalsLeaguePropertyCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("cultivate/Mythical_animals/mythical_animals_properties_cell_3.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
