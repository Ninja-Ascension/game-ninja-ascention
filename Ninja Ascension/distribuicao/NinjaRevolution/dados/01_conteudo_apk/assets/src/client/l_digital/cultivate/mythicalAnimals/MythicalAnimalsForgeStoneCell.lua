--[[ ----------------------------------------------------------------------------
-- 神锻石选中
--]] ----------------------------------------------------------------------------
MythicalAnimalsForgeStoneCell = class("MythicalAnimalsForgeStoneCellClass", Window)
MythicalAnimalsForgeStoneCell.__size = nil

-- 创建Cell实例
local mythical_animals_forge_stone_cell_create_terminal = {
	_name = "mythical_animals_forge_stone_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if MythicalAnimalsForgeStoneCell then
			local cell = MythicalAnimalsForgeStoneCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(mythical_animals_forge_stone_cell_create_terminal)
state_machine.init()

-- 构造器
function MythicalAnimalsForgeStoneCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize ninja biographies0 cell page state machine.
	local function init_mythical_animals_forge_stone_cell_terminal()
		local mythical_animals_forge_stone_cell_select_terminal = {
			_name = "mythical_animals_forge_stone_cell_select",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local cell = params._datas._self
				if cell then
					local selectIndex = cell._index
					state_machine.excute("mythical_animals_forge_select_cell", 0, selectIndex)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(mythical_animals_forge_stone_cell_select_terminal)
	end
	-- call func init ninja biographies0 cell state machine.
	init_mythical_animals_forge_stone_cell_terminal()
end

-- 对象初始化
function MythicalAnimalsForgeStoneCell:init(params)
	self._index = params.index

	self._prop = params.prop

	self._useCount = params.useCount

	self:onInit(params)
	
	self:setContentSize(MythicalAnimalsForgeStoneCell.__size)
	return self
end

function MythicalAnimalsForgeStoneCell:onUpdateDraw()
	local root = self.roots[1]

	-- 选中
	self.Panel_animals_prop_box = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_animals_prop_box"), nil,
	{
		terminal_name = "mythical_animals_forge_stone_cell_select",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_self = self
	}, nil, 0)	

	-- 容器
	self.Panel_stone = ccui.Helper:seekWidgetByName(root, "Panel_stone")
	-- 动画
	self.Text_num = ccui.Helper:seekWidgetByName(root, "Text_num")
	-- 名字
	self.Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
	-- 选中光效
	self.Image_select = ccui.Helper:seekWidgetByName(root, "Image_select")

	self:updateUI()
end

function MythicalAnimalsForgeStoneCell:updateUI()
	local Panel_stone = self.Panel_stone
	Panel_stone:removeAllChildren(true)

	local propId = tonumber(self._prop[2])

	local picIndex = setThePropsIcon(propId)[1]
	local sp = cc.Sprite:create(string.format("images/ui/props/props_%d.png", picIndex))
	sp:setPosition(cc.p(Panel_stone:getContentSize().width/2, Panel_stone:getContentSize().height/2))
	Panel_stone:addChild(sp)

	self.Text_name:setString(setThePropsIcon(propId)[2])

	local nowProgress = self._useCount
	local needProgress = tonumber(self._prop[3])
	self.Text_name:setString(nowProgress .. "/" .. needProgress)

	self:setSelectState(self._index == 1)
end

function MythicalAnimalsForgeStoneCell:setSelectState(isShow)
	self.Image_select:setVisible(isShow)
end

function MythicalAnimalsForgeStoneCell:onInit(params)
	-- 加载MythicalAnimalsForgeStoneCellWindow界面资源.
	-- res.cultivate.Mythical_animals.mythical_animals_stone_item_2 = res/cultivate/Mythical_animals/mythical_animals_stone_item_2.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("cultivate/Mythical_animals/mythical_animals_stone_item_2.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("cultivate/Mythical_animals/mythical_animals_stone_item_2.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if MythicalAnimalsForgeStoneCell.__size == nil then
		MythicalAnimalsForgeStoneCell.__size = root:getContentSize()
	end
	self:clearUIInfo()
	self:onUpdateDraw()
end

function MythicalAnimalsForgeStoneCell:clearUIInfo( ... )
	local root = self.roots[1]
	if root == nil then
		return
	end

	self.Panel_stone = ccui.Helper:seekWidgetByName(root, "Panel_stone")
	self.Panel_stone:removeAllChildren(true)

	self.Text_num = ccui.Helper:seekWidgetByName(root, "Text_num")
	self.Text_num:setString("")

	self.Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
	self.Text_name:setString("")

	self.Image_select = ccui.Helper:seekWidgetByName(root, "Image_select")
	self.Image_select:setVisible(false)
end

function MythicalAnimalsForgeStoneCell:onExit()
	-- 释放MythicalAnimalsForgeStoneCellWindow界面资源.
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("cultivate/Mythical_animals/mythical_animals_stone_item_2.csb", root)
	-- ]]
end

function MythicalAnimalsForgeStoneCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function MythicalAnimalsForgeStoneCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("cultivate/Mythical_animals/mythical_animals_stone_item_2.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
