--[[ ----------------------------------------------------------------------------
-- 获取途径cell
--]] ----------------------------------------------------------------------------
MythicalAnimalsDestinyPropertyCell = class("MythicalAnimalsDestinyPropertyCellClass", Window)
MythicalAnimalsDestinyPropertyCell.__size = nil

-- 创建Cell实例
local mythical_animals_destiny_property_cell_create_terminal = {
	_name = "mythical_animals_destiny_property_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if MythicalAnimalsDestinyPropertyCell then
			local cell = MythicalAnimalsDestinyPropertyCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(mythical_animals_destiny_property_cell_create_terminal)
state_machine.init()

-- 构造器
function MythicalAnimalsDestinyPropertyCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize ninja biographies0 cell page state machine.
	local function init_mythical_animals_destiny_property_cell_terminal()
		
	end
	-- call func init ninja biographies0 cell state machine.
	init_mythical_animals_destiny_property_cell_terminal()
end

-- 对象初始化
function MythicalAnimalsDestinyPropertyCell:init(params)
	self._data = params

	self:onInit(params)
	
	self:setContentSize(MythicalAnimalsDestinyPropertyCell.__size)
	return self
end

function MythicalAnimalsDestinyPropertyCell:onUpdateDraw()
	local root = self.roots[1]

	-- 属性名字
	self.Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
	-- 属性值
	self.Text_1_0 = ccui.Helper:seekWidgetByName(root, "Text_1_0")

	-- 属性名字
	self.Text_2 = ccui.Helper:seekWidgetByName(root, "Text_2")
	-- 属性值
	self.Text_2_0 = ccui.Helper:seekWidgetByName(root, "Text_2_0")

	self:updateUI()
end

function MythicalAnimalsDestinyPropertyCell:updateUI()
	self.Text_1:setVisible(false)
	self.Text_1_0:setVisible(false)
	self.Text_2:setVisible(false)
	self.Text_2_0:setVisible(false)

	local propertyData1 = self._data[1]
	if propertyData1 then
		local data1 = zstring.split(propertyData1, ",")

		local name1, value1 = nil, nil
		-- 如果不是数值
		if tonumber(data1[1]) ~= nil and tonumber(data1[2]) ~= nil then
			local propertyType1 = tonumber(data1[1])
			local propertyValue1 = tonumber(data1[2])
			name1, value1 = getHardenPropertyNameAndValue(propertyType1, propertyValue1, true, tipStringInfo_magical_animals_property_name_and_value)
		else
			name1, value1 = data1[1], data1[2]
		end
		
		self.Text_1:setString(name1)
		self.Text_1_0:setString(value1)

		self.Text_1:setVisible(true)
		self.Text_1_0:setVisible(true)
	end

	local propertyData2 = self._data[2]
	if propertyData2 then
		local data2 = zstring.split(propertyData2, ",")

		local name2, value2 = nil, nil
		-- 如果不是数值
		if tonumber(data2[1]) ~= nil and tonumber(data2[2]) ~= nil then
			local propertyType2 = tonumber(data2[1])
			local propertyValue2 = tonumber(data2[2])
			name2, value2 = getHardenPropertyNameAndValue(propertyType2, propertyValue2, true, tipStringInfo_magical_animals_property_name_and_value)
		else
			name2, value2 = data2[1], data2[2]
		end

		self.Text_2:setString(name2)
		self.Text_2_0:setString(value2)

		self.Text_2:setVisible(true)
		self.Text_2_0:setVisible(true)
	end
end

function MythicalAnimalsDestinyPropertyCell:onInit(params)
	-- 加载MythicalAnimalsDestinyPropertyCellWindow界面资源.
	-- res.cultivate.Mythical_animals.mythical_animals_properties_cell = res/cultivate/Mythical_animals/mythical_animals_properties_cell.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("cultivate/Mythical_animals/mythical_animals_properties_cell.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("cultivate/Mythical_animals/mythical_animals_properties_cell.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if MythicalAnimalsDestinyPropertyCell.__size == nil then
		MythicalAnimalsDestinyPropertyCell.__size = root:getContentSize()
	end
	self:clearUIInfo()
	self:onUpdateDraw()
end

function MythicalAnimalsDestinyPropertyCell:clearUIInfo( ... )
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

function MythicalAnimalsDestinyPropertyCell:onExit()
	-- 释放MythicalAnimalsDestinyPropertyCellWindow界面资源.
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("cultivate/Mythical_animals/mythical_animals_properties_cell.csb", root)
	-- ]]
end

function MythicalAnimalsDestinyPropertyCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function MythicalAnimalsDestinyPropertyCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("cultivate/Mythical_animals/mythical_animals_properties_cell.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
