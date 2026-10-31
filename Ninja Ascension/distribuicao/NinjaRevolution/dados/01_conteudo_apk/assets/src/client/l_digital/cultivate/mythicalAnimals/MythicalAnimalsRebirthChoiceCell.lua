--[[ ----------------------------------------------------------------------------
-- 重生选择cell
--]] ----------------------------------------------------------------------------
MythicalAnimalsRebirthChoiceCell = class("MythicalAnimalsRebirthChoiceCellClass", Window)
MythicalAnimalsRebirthChoiceCell.__size = nil

-- 创建Cell实例
local mythical_animals_rebirth_choice_cell_create_terminal = {
	_name = "mythical_animals_rebirth_choice_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if MythicalAnimalsRebirthChoiceCell then
			local cell = MythicalAnimalsRebirthChoiceCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(mythical_animals_rebirth_choice_cell_create_terminal)
state_machine.init()

-- 构造器
function MythicalAnimalsRebirthChoiceCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize ninja biographies0 cell page state machine.
	local function init_mythical_animals_rebirth_choice_cell_terminal()
		local mythical_animals_rebirth_choice_cell_select_terminal = {
			_name = "mythical_animals_rebirth_choice_cell_select",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local _self = params._datas._self
				-- 刷新重生界面
				state_machine.excute("mythical_animals_rebirth_refresh_ui", 0, _self._animalsMouldId)
				-- 关闭重生选择界面
				state_machine.excute("mythical_animals_rebirth_choice_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(mythical_animals_rebirth_choice_cell_select_terminal)
	end
	-- call func init ninja biographies0 cell state machine.
	init_mythical_animals_rebirth_choice_cell_terminal()
end

-- 对象初始化
function MythicalAnimalsRebirthChoiceCell:init(params)
	self._animalsMouldId = params

	self:onInit(params)
	
	self:setContentSize(MythicalAnimalsRebirthChoiceCell.__size)
	return self
end

function MythicalAnimalsRebirthChoiceCell:onUpdateDraw()
	local root = self.roots[1]

	-- 选中
	self.Button_1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil,
	{
		terminal_name = "mythical_animals_rebirth_choice_cell_select",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_self = self
	}, nil, 0)	

	self.Panel_animal_icon = ccui.Helper:seekWidgetByName(root, "Panel_animal_icon")
	self.Text_animal = ccui.Helper:seekWidgetByName(root, "Text_animal")
	self.Text_stage_num = ccui.Helper:seekWidgetByName(root, "Text_stage_num")

	self:updateUI()
end

function MythicalAnimalsRebirthChoiceCell:updateUI()
	local Panel_animal_icon = self.Panel_animal_icon
	Panel_animal_icon:removeAllChildren(true)

	local curStar = MythicalAnimalsHandle.getMythicalAnimalsStarById(self._animalsMouldId)

	local cell = DrawHandle.drawIcon({72, tonumber(self._animalsMouldId), 1, curStar})
	Panel_animal_icon:addChild(cell)

	local name = MythicalAnimalsHandle.getAnimalsNameById(self._animalsMouldId)
	self.Text_animal:setString(name)

	local curStage = MythicalAnimalsHandle.getMythicalAnimalsStageById(self._animalsMouldId)
	self.Text_stage_num:setString(string.format(tipStringInfo_magical_animals_word[2], curStage))
end

function MythicalAnimalsRebirthChoiceCell:onInit(params)
	-- 加载MythicalAnimalsRebirthChoiceCellWindow界面资源.
	-- res.cultivate.Mythical_animals.mythical_animals_rebirth_choice_cell = res/cultivate/Mythical_animals/mythical_animals_rebirth_choice_cell.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("cultivate/Mythical_animals/mythical_animals_rebirth_choice_cell.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("cultivate/Mythical_animals/mythical_animals_rebirth_choice_cell.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if MythicalAnimalsRebirthChoiceCell.__size == nil then
		MythicalAnimalsRebirthChoiceCell.__size = root:getContentSize()
	end
	self:clearUIInfo()
	self:onUpdateDraw()
end

function MythicalAnimalsRebirthChoiceCell:clearUIInfo( ... )
	local root = self.roots[1]
	if root == nil then
		return
	end

	self.Panel_animal_icon = ccui.Helper:seekWidgetByName(root, "Panel_animal_icon")
	self.Panel_animal_icon:removeAllChildren(true)

	self.Text_animal = ccui.Helper:seekWidgetByName(root, "Text_animal")
	self.Text_animal:setString("")

	self.Text_stage_num = ccui.Helper:seekWidgetByName(root, "Text_stage_num")
	self.Text_stage_num:setString("")
end

function MythicalAnimalsRebirthChoiceCell:onExit()
	-- 释放MythicalAnimalsRebirthChoiceCellWindow界面资源.
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("cultivate/Mythical_animals/mythical_animals_rebirth_choice_cell.csb", root)
	-- ]]
end

function MythicalAnimalsRebirthChoiceCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function MythicalAnimalsRebirthChoiceCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("cultivate/Mythical_animals/mythical_animals_rebirth_choice_cell.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
