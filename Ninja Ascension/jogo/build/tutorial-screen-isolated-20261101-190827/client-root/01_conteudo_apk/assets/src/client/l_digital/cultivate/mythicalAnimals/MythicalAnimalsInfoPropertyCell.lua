--[[ ----------------------------------------------------------------------------
-- 神兽信息页签属性cell
--]] ----------------------------------------------------------------------------
MythicalAnimalsInfoPropertyCell = class("MythicalAnimalsInfoPropertyCellClass", Window)
MythicalAnimalsInfoPropertyCell.__size = nil

-- 创建Cell实例
local mythical_animals_info_property_cell_create_terminal = {
	_name = "mythical_animals_info_property_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if MythicalAnimalsInfoPropertyCell then
			local cell = MythicalAnimalsInfoPropertyCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(mythical_animals_info_property_cell_create_terminal)
state_machine.init()

-- 构造器
function MythicalAnimalsInfoPropertyCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize ninja biographies0 cell page state machine.
	local function init_mythical_animals_info_property_cell_terminal()
		
	end
	-- call func init ninja biographies0 cell state machine.
	init_mythical_animals_info_property_cell_terminal()
end

-- 对象初始化
function MythicalAnimalsInfoPropertyCell:init(params)
	self._data = params

	self:onInit(params)
	
	self:setContentSize(MythicalAnimalsInfoPropertyCell.__size)
	return self
end

function MythicalAnimalsInfoPropertyCell:onUpdateDraw()
	local root = self.roots[1]

	self.Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
	self.Text_1_0 = ccui.Helper:seekWidgetByName(root, "Text_1_0")

	self:updateUI()
end

function MythicalAnimalsInfoPropertyCell:updateUI()
	local propertyType = tonumber(self._data.propertyType)
	local propertyValue = tonumber(self._data.propertyValue)
	local name, value = getHardenPropertyNameAndValue(propertyType, propertyValue, true, tipStringInfo_magical_animals_property_name_and_value)

	self.Text_1:setString(name)
	self.Text_1_0:setString(value)
end

function MythicalAnimalsInfoPropertyCell:onInit(params)
	-- 加载MythicalAnimalsInfoPropertyCellWindow界面资源.
	-- res.cultivate.Mythical_animals.mythical_animals_properties_cell_2 = res/cultivate/Mythical_animals/mythical_animals_properties_cell_2.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("cultivate/Mythical_animals/mythical_animals_properties_cell_2.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("cultivate/Mythical_animals/mythical_animals_properties_cell_2.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if MythicalAnimalsInfoPropertyCell.__size == nil then
		MythicalAnimalsInfoPropertyCell.__size = root:getContentSize()
	end
	self:clearUIInfo()
	self:onUpdateDraw()
end

function MythicalAnimalsInfoPropertyCell:clearUIInfo( ... )
	local root = self.roots[1]
	if root == nil then
		return
	end

	self.Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
	self.Text_1:setString("")

	self.Text_1_0 = ccui.Helper:seekWidgetByName(root, "Text_1_0")
	self.Text_1_0:setString("")
end

function MythicalAnimalsInfoPropertyCell:onExit()
	-- 释放MythicalAnimalsInfoPropertyCellWindow界面资源.
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("cultivate/Mythical_animals/mythical_animals_properties_cell_2.csb", root)
	-- ]]
end

function MythicalAnimalsInfoPropertyCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function MythicalAnimalsInfoPropertyCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("cultivate/Mythical_animals/mythical_animals_properties_cell_2.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
