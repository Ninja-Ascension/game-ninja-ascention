--[[ ----------------------------------------------------------------------------
-- 黄色属性
--]] ----------------------------------------------------------------------------
RoleBiographyPropertyCell4 = class("RoleBiographyPropertyCell4Class", Window)
RoleBiographyPropertyCell4.__size = nil

-- 创建Cell实例
local role_biography_property_cell_4_create_terminal = {
	_name = "role_biography_property_cell_4_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if RoleBiographyPropertyCell4 then
			local cell = RoleBiographyPropertyCell4:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(role_biography_property_cell_4_create_terminal)
state_machine.init()

-- 构造器
function RoleBiographyPropertyCell4:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize ninja biographies0 cell page state machine.
	local function init_role_biography_property_cell_4_terminal()
		
	end
	-- call func init ninja biographies0 cell state machine.
	init_role_biography_property_cell_4_terminal()
end

-- 对象初始化
function RoleBiographyPropertyCell4:init(params)
	self._data = params

		
	self:onInit(params)
	self:setContentSize(RoleBiographyPropertyCell4.__size)
	return self
end

function RoleBiographyPropertyCell4:updateUI()
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
			name1, value1 = getHardenPropertyNameAndValue(propertyType1, propertyValue1, true)
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
			name2, value2 = getHardenPropertyNameAndValue(propertyType2, propertyValue2, true)
		else
			name2, value2 = data2[1], data2[2]
		end

		self.Text_2:setString(name2)
		self.Text_2_0:setString(value2)

		self.Text_2:setVisible(true)
		self.Text_2_0:setVisible(true)
	end

	-- print(name, value)
end

function RoleBiographyPropertyCell4:onUpdateDraw()
	local root = self.roots[1]

	self.Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")

	self.Text_1_0 = ccui.Helper:seekWidgetByName(root, "Text_1_0")

	self.Text_2 = ccui.Helper:seekWidgetByName(root, "Text_2")

	self.Text_2_0 = ccui.Helper:seekWidgetByName(root, "Text_2_0")
	
	self:updateUI()
end

function RoleBiographyPropertyCell4:onEnterTransitionFinish()
	
end

function RoleBiographyPropertyCell4:onInit(params)
	-- 加载RoleBiographyPropertyCell4Window界面资源.
	-- res.cultivate.ninja_biographies.ninja_biographies_levelup_cell = res/cultivate/ninja_biographies/ninja_biographies_levelup_cell.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("cultivate/ninja_biographies/ninja_biographies_levelup_cell.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("cultivate/ninja_biographies/ninja_biographies_levelup_cell.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if RoleBiographyPropertyCell4.__size == nil then
		RoleBiographyPropertyCell4.__size = root:getContentSize()
	end
	self:clearUIInfo()
	self:onUpdateDraw()
end

function RoleBiographyPropertyCell4:clearUIInfo( ... )
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

function RoleBiographyPropertyCell4:onExit()
	-- 释放RoleBiographyPropertyCell4Window界面资源.
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("cultivate/ninja_biographies/ninja_biographies_levelup_cell.csb", root)
	-- ]]
end

function RoleBiographyPropertyCell4:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function RoleBiographyPropertyCell4:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("cultivate/ninja_biographies/ninja_biographies_levelup_cell.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
