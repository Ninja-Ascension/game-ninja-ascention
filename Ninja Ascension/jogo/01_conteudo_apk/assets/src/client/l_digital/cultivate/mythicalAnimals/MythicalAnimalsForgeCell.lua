--[[ ----------------------------------------------------------------------------
-- 神锻右侧cell
--]] ----------------------------------------------------------------------------
MythicalAnimalsForgeCell = class("MythicalAnimalsForgeCellClass", Window)
MythicalAnimalsForgeCell.__size = nil

-- 创建Cell实例
local mythical_animals_forge_cell_create_terminal = {
	_name = "mythical_animals_forge_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if MythicalAnimalsForgeCell then
			local cell = MythicalAnimalsForgeCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(mythical_animals_forge_cell_create_terminal)
state_machine.init()

-- 构造器
function MythicalAnimalsForgeCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize ninja biographies0 cell page state machine.
	local function init_mythical_animals_forge_cell_terminal()
		local mythical_animals_forge_cell_open_obtain_terminal = {
			_name = "mythical_animals_forge_cell_open_obtain",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local prop = params._datas.prop
				state_machine.excute("mythical_animals_obtain_window_open", 0, {prop = prop})
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		local mythical_animals_forge_cell_select_terminal = {
			_name = "mythical_animals_forge_cell_select",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if params._datas._self ~= nil then
					local index = params._datas._self._index
					state_machine.excute("mythical_animals_forge_select_cell", 0, index)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(mythical_animals_forge_cell_open_obtain_terminal)
		state_machine.add(mythical_animals_forge_cell_select_terminal)
	end
	-- call func init ninja biographies0 cell state machine.
	init_mythical_animals_forge_cell_terminal()
end

-- 对象初始化
function MythicalAnimalsForgeCell:init(params)
	self._index = params.index

	self._prop = params.prop

	self._useCount = params.useCount

	self._animalsMouldId = params.animalsMouldId

	self:onInit(params)
	
	self:setContentSize(MythicalAnimalsForgeCell.__size)
	return self
end

function MythicalAnimalsForgeCell:onUpdateDraw()
	local root = self.roots[1]

	-- 去获取
	self.Button_obtain_0 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_obtain_0"), nil,
	{
		terminal_name = "mythical_animals_forge_cell_open_obtain",
		terminal_state = 0,
		isPressedActionEnabled = true,
		prop = self._prop
	}, nil, 0)	

	-- 选中
	self.Image_4 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_4"), nil,
	{
		terminal_name = "mythical_animals_forge_cell_select",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_self = self
	}, nil, 0)	


	-- 选择背景亮
	self.Image_light = ccui.Helper:seekWidgetByName(root, "Image_light")
	-- 道具
	self.Panel_material_icon = ccui.Helper:seekWidgetByName(root, "Panel_material_icon")
	-- 道具名字
	self.Text_stone = ccui.Helper:seekWidgetByName(root, "Text_stone")
	-- 产生属性
	self.Text_use = ccui.Helper:seekWidgetByName(root, "Text_use")
	-- 当前数量
	self.Text_material = ccui.Helper:seekWidgetByName(root, "Text_material")
	-- 需要数量
	self.Text_material_need = ccui.Helper:seekWidgetByName(root, "Text_material_need")
	-- 已激活
	self.Image_activited = ccui.Helper:seekWidgetByName(root, "Image_activited")
	-- 选中
	self.CheckBox_choice = ccui.Helper:seekWidgetByName(root, "CheckBox_choice")
	self.CheckBox_choice:setTouchEnabled(false)

	self.CheckBox_choice:setVisible(false)
	self.Button_obtain_0:setVisible(false)
	self.Image_activited:setVisible(false)

	self:updateUI()
end

function MythicalAnimalsForgeCell:updateUI()
	-- self:setSelectState(self._index == 1)

	local propId = tonumber(self._prop[2])
	self.Text_stone:setString(setThePropsIcon(propId)[2])

	local quality = dms.int(dms["prop_mould"], propId, prop_mould.prop_quality) + 1
	self.Text_stone:setColor(cc.c3b(color_Type[quality][1], color_Type[quality][2], color_Type[quality][3]))

	local havePropCount = tonumber(getPropAllCountByMouldId(propId))

	self.Panel_material_icon:removeAllChildren(true)
	local cell = DrawHandle.drawIcon({6, propId, havePropCount})
	self.Panel_material_icon:addChild(cell)

	local addProperty = MythicalAnimalsHandle.getForgePropAddProperty()
	local name, value = getHardenPropertyNameAndValue(addProperty[self._index][1], addProperty[self._index][2], true, tipStringInfo_magical_animals_property_name_and_value)
	self.Text_use:setString(name .. value)

	local nowProgress = self._useCount
	local needProgress = nowProgress

	local curStage = MythicalAnimalsHandle.getMythicalAnimalsStageById(self._animalsMouldId)

	local maxStage = MythicalAnimalsHandle.getMaxStageLvlById(self._animalsMouldId)

	local isStageMax = false

	if curStage == maxStage then
		isStageMax = true
		curStage = curStage - 1
	end

	local costProp = MythicalAnimalsHandle.getAnimalsUpStagCostPropInfoById(self._animalsMouldId, curStage)
	if costProp ~= nil then
		needProgress = tonumber(costProp[self._index][3])
	end

	-- 满阶级
	if isStageMax == true then
		nowProgress = needProgress
	end

	self.Text_material:setString(nowProgress)
	self.Text_material_need:setString("/" .. needProgress)

	if costProp ~= nil then
		if havePropCount <= 0 then
			self.Button_obtain_0:setVisible(true)
		else
			self.CheckBox_choice:setVisible(true)
		end
	else
		self.Image_activited:setVisible(true)
	end
end

function MythicalAnimalsForgeCell:setSelectState(isShow)
	self.Image_light:setVisible(isShow)

	local propId = tonumber(self._prop[2])
	local havePropCount = tonumber(getPropAllCountByMouldId(propId))
	if havePropCount > 0 and isShow == true then
		self.CheckBox_choice:setSelected(true)
	else
		self.CheckBox_choice:setSelected(false)
	end
end

function MythicalAnimalsForgeCell:onInit(params)
	-- 加载MythicalAnimalsForgeCellWindow界面资源.
	-- res.cultivate.Mythical_animals.mythical_animals_forging_cell = res/cultivate/Mythical_animals/mythical_animals_forging_cell.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("cultivate/Mythical_animals/mythical_animals_forging_cell.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("cultivate/Mythical_animals/mythical_animals_forging_cell.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if MythicalAnimalsForgeCell.__size == nil then
		MythicalAnimalsForgeCell.__size = root:getContentSize()
	end
	self:clearUIInfo()
	self:onUpdateDraw()
end

function MythicalAnimalsForgeCell:clearUIInfo( ... )
	local root = self.roots[1]
	if root == nil then
		return
	end

	self.Image_light = ccui.Helper:seekWidgetByName(root, "Image_light")
	self.Image_light:setVisible(false)

	self.Panel_material_icon = ccui.Helper:seekWidgetByName(root, "Panel_material_icon")
	self.Panel_material_icon:removeAllChildren(true)

	self.Text_use = ccui.Helper:seekWidgetByName(root, "Text_use")
	self.Text_use:setString("")

	self.Text_material = ccui.Helper:seekWidgetByName(root, "Text_material")
	self.Text_material:setString("")

	self.Text_material_need = ccui.Helper:seekWidgetByName(root, "Text_material_need")
	self.Text_material_need:setString("")

	self.Image_activited = ccui.Helper:seekWidgetByName(root, "Image_activited")
	self.Image_activited:setVisible(false)
end

function MythicalAnimalsForgeCell:onExit()
	-- 释放MythicalAnimalsForgeCellWindow界面资源.
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("cultivate/Mythical_animals/mythical_animals_forging_cell.csb", root)
	-- ]]
end

function MythicalAnimalsForgeCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function MythicalAnimalsForgeCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("cultivate/Mythical_animals/mythical_animals_forging_cell.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
