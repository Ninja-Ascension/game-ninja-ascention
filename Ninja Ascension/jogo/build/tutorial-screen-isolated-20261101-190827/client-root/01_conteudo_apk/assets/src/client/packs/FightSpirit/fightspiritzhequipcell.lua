--[[ ----------------------------------------------------------------------------
-- @class
--]] ----------------------------------------------------------------------------
FightSpiritZhEquipCell = class("FightSpiritZhEquipCellClass", Window)
FightSpiritZhEquipCell.__size = nil

-- 创建Cell实例
local fight_spirit_zh_equip_cell_create_terminal = {
	_name = "fight_spirit_zh_equip_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if FightSpiritZhEquipCell then
			local cell = FightSpiritZhEquipCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fight_spirit_zh_equip_cell_create_terminal)
state_machine.init()

-- 构造器
function FightSpiritZhEquipCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize fight spirit zh equip cell page state machine.
	local function init_fight_spirit_zh_equip_cell_terminal()
		-- 装备
		local fight_spirit_zh_equip_cell_equip_terminal = {
			_name = "fight_spirit_zh_equip_cell_equip",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				FightSpiritHandle.setShipFightSpirit(instance._shipId, params._datas.fightSpirit.id)
				state_machine.excute("fight_spirit_zh_equip_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 查看
		local fight_spirit_zh_equip_cell_check_terminal = {
			_name = "fight_spirit_zh_equip_cell_check",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("fight_spirit_skill_window_open", 0, {_datas = {fightSpirit1 = params._datas.fightSpirit}})
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(fight_spirit_zh_equip_cell_equip_terminal)
		state_machine.add(fight_spirit_zh_equip_cell_check_terminal)
		state_machine.init()
	end
	-- call func init fight spirit zh equip cell state machine.
	init_fight_spirit_zh_equip_cell_terminal()
end

-- 对象初始化
function FightSpiritZhEquipCell:init(params)
	self:onInit(params)
	self:setContentSize(FightSpiritZhEquipCell.__size)
	return self
end

function FightSpiritZhEquipCell:onUpdateDraw()
	local root = self.roots[1]

	ccui.Helper:seekWidgetByName(root, "Button_zb"):setVisible(not self._hasEquip)
	ccui.Helper:seekWidgetByName(root, "Button_gh"):setVisible(self._hasEquip)

	local cell = ResourcesIconCell:createCell()
	local fightSpirit = self._fightSpirit
	cell:init(73,nil,nil,nil,nil,nil,false,nil,{fightSpirit=fightSpirit})
	ccui.Helper:seekWidgetByName(root, "Panel_zh"):addChild(cell)

	local pos = dms.int(dms["fight_spirit_mould"], fightSpirit.mouldId, fight_spirit_mould.pos)
	local suitId = dms.int(dms["fight_spirit_mould"], fightSpirit.mouldId, fight_spirit_mould.suit_id)
	ccui.Helper:seekWidgetByName(root, "Text_name"):setString(dms.element(dms["word_mould"], 
		dms.int(dms["fight_spirit_suit_mould"], suitId, fight_spirit_suit_mould.suit_name))[3].."."..chinese_num[pos])
	ccui.Helper:seekWidgetByName(root, "Panel_2"):getChildByName("Text_1"):setString(chinese_num[pos]..tipStringInfo_fight_spirit[1])
end

function FightSpiritZhEquipCell:onEnterTransitionFinish()
	
end

function FightSpiritZhEquipCell:onInit(params)
	-- 加载FightSpiritZhEquipCellWindow界面资源.
	local csbNode = csb.createNode("packs/FightSpirit/FightSpirit_zh_equip_cell.csb")
	local root = csbNode:getChildByName("root")
	-- ]]
	-- root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(csbNode)
	if FightSpiritZhEquipCell.__size == nil then
		FightSpiritZhEquipCell.__size = root:getContentSize()
	end

	self._fightSpirit = params.fightSpirit
	self._hasEquip = params.hasEquip
	self._shipId = params.shipId

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zb"), nil, 
	{
		terminal_name = "fight_spirit_zh_equip_cell_equip", 
		terminal_state = 0, 
		isPressedActionEnabled = true,
		fightSpirit = self._fightSpirit,
	}, nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_gh"), nil, 
	{
		terminal_name = "fight_spirit_zh_equip_cell_equip", 
		terminal_state = 0, 
		isPressedActionEnabled = true,
		fightSpirit = self._fightSpirit,
	}, nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ck"), nil, 
	{
		terminal_name = "fight_spirit_zh_equip_cell_check", 
		terminal_state = 0, 
		isPressedActionEnabled = true,
		fightSpirit = self._fightSpirit,
	}, nil, 0)

	self:onUpdateDraw()
end

function FightSpiritZhEquipCell:onExit()
	-- 释放FightSpiritZhEquipCellWindow界面资源.
	state_machine.remove("fight_spirit_zh_equip_cell_equip")
	state_machine.remove("fight_spirit_zh_equip_cell_check")
end

function FightSpiritZhEquipCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function FightSpiritZhEquipCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
