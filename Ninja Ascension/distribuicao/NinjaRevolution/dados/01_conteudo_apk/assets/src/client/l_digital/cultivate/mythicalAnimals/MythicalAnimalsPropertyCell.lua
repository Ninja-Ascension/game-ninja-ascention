--[[ ----------------------------------------------------------------------------
-- 神兽属性cell
--]] ----------------------------------------------------------------------------
MythicalAnimalsPropertyCell = class("MythicalAnimalsPropertyCellClass", Window)
MythicalAnimalsPropertyCell.__size = nil

-- 创建Cell实例
local mythical_animals_property_cell_create_terminal = {
	_name = "mythical_animals_property_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if MythicalAnimalsPropertyCell then
			local cell = MythicalAnimalsPropertyCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(mythical_animals_property_cell_create_terminal)
state_machine.init()

-- 构造器
function MythicalAnimalsPropertyCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize ninja biographies0 cell page state machine.
	local function init_mythical_animals_property_cell_terminal()
		
	end
	-- call func init ninja biographies0 cell state machine.
	init_mythical_animals_property_cell_terminal()
end

-- 对象初始化
function MythicalAnimalsPropertyCell:init(params)
	self._data = params.data
	self._forgeAddProperty = params.forgeAddProperty

	self:onInit(params)
	
	self:setContentSize(MythicalAnimalsPropertyCell.__size)
	return self
end

function MythicalAnimalsPropertyCell:onUpdateDraw()
	local root = self.roots[1]

	self.Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
	self.Text_1_0 = ccui.Helper:seekWidgetByName(root, "Text_1_0")

	self.Text_2 = ccui.Helper:seekWidgetByName(root, "Text_2")
	self.Text_2_0 = ccui.Helper:seekWidgetByName(root, "Text_2_0")

	self:updateUI()
end

function MythicalAnimalsPropertyCell:updateUI()
	local propertyType = tonumber(self._data.propertyType)
	local propertyValue = tonumber(self._data.propertyValue)
	local name, value = getHardenPropertyNameAndValue(propertyType, propertyValue, true, tipStringInfo_magical_animals_property_name_and_value)

	self.Text_1:setString(name)
	self.Text_1_0:setString(value)

	self.Text_2:setString(tipStringInfo_magical_animals_word[3])

	-- 神锻加成
	local forgePropertyType = propertyType
	local forgePropertyValue = self._forgeAddProperty[forgePropertyType]
	local _, forgeAddValue = getHardenPropertyNameAndValue(forgePropertyType, forgePropertyValue, true, tipStringInfo_magical_animals_property_name_and_value)
	self.Text_2_0:setString(forgeAddValue)
end

function MythicalAnimalsPropertyCell:onInit(params)
	-- 加载MythicalAnimalsPropertyCellWindow界面资源.
	-- res.cultivate.Mythical_animals.mythical_animals_prop = res/cultivate/Mythical_animals/mythical_animals_prop.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("cultivate/Mythical_animals/mythical_animals_prop.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("cultivate/Mythical_animals/mythical_animals_prop.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if MythicalAnimalsPropertyCell.__size == nil then
		MythicalAnimalsPropertyCell.__size = root:getContentSize()
	end
	self:clearUIInfo()
	self:onUpdateDraw()
end

function MythicalAnimalsPropertyCell:clearUIInfo( ... )
	local root = self.roots[1]
	if root == nil then
		return
	end

	self.Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
	self.Text_1:setString("")

	self.Text_1_0 = ccui.Helper:seekWidgetByName(root, "Text_1_0")
	self.Text_1_0:setString("")

	self.Text_2 = ccui.Helper:seekWidgetByName(root, "Text_2")
	self.Text_2:setString("")

	self.Text_2_0 = ccui.Helper:seekWidgetByName(root, "Text_2_0")
	self.Text_2_0:setString("")
end

function MythicalAnimalsPropertyCell:onExit()
	-- 释放MythicalAnimalsPropertyCellWindow界面资源.
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("cultivate/Mythical_animals/mythical_animals_prop.csb", root)
	-- ]]
end

function MythicalAnimalsPropertyCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function MythicalAnimalsPropertyCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("cultivate/Mythical_animals/mythical_animals_prop.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
