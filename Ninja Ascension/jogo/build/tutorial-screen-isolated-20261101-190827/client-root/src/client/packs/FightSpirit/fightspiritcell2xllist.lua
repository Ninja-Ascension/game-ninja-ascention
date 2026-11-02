--[[ ----------------------------------------------------------------------------
-- 战魂显示框
--]] ----------------------------------------------------------------------------
FightSpiritCell2XlList = class("FightSpiritCell2XlListClass", Window)
FightSpiritCell2XlList.__size = nil

-- 创建Cell实例
local fight_spirit_cell2_xl_list_create_terminal = {
	_name = "fight_spirit_cell2_xl_list_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if FightSpiritCell2XlList then
			local cell = FightSpiritCell2XlList:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fight_spirit_cell2_xl_list_create_terminal)
state_machine.init()

-- 构造器
function FightSpiritCell2XlList:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize fight spirit cell2 xl list page state machine.
	local function init_fight_spirit_cell2_xl_list_terminal()
		
	end
	-- call func init fight spirit cell2 xl list state machine.
	init_fight_spirit_cell2_xl_list_terminal()
end

-- 对象初始化
function FightSpiritCell2XlList:init(params)
	self._mouldId = params.mouldId
	local pos = dms.int(dms["fight_spirit_mould"], self._mouldId, fight_spirit_mould.pos)
	self._pos = pos
	self._isStrength = params.isStrength
	if self._isStrength then
		self.fightSpirit = params.fightSpirit
	end

	if not params.isLazy then
		self:onInit()
		self.loadTag = false
	end
	-- DSC重塑
	if __lua_project_id == __lua_project_l_digital then
		self:setContentSize(FightSpiritCell2XlList.__size)
	else
		self:setContentSize(296,103)
	end
	return self
end

function FightSpiritCell2XlList:onUpdateDraw()
	local root = self.roots[1]

	local fightSpirit = {}
	fightSpirit.mouldId = self._mouldId

	local quality = dms.int(dms["fight_spirit_mould"], fightSpirit.mouldId, fight_spirit_mould.quality)
	fightSpirit.quality = quality

	local cell = ResourcesIconCell:createCell()
	ccui.Helper:seekWidgetByName(root, "Panel_zh"):addChild(cell)

	local suitId = dms.int(dms["fight_spirit_mould"], self._mouldId, fight_spirit_mould.suit_id)
	local name_mould_id = dms.int(dms["fight_spirit_suit_mould"], suitId, fight_spirit_suit_mould.suit_name)
	local pos = dms.int(dms["fight_spirit_mould"], self._mouldId, fight_spirit_mould.pos)
	ccui.Helper:seekWidgetByName(root, "Text_name"):setString(dms.element(dms["word_mould"], name_mould_id)[3].."."..chinese_num[pos])

	ccui.Helper:seekWidgetByName(root, "Text_qh"):setVisible(self._isStrength)
	ccui.Helper:seekWidgetByName(root, "Text_1_0"):setVisible(not self._isStrength)

	if self._isStrength then
		cell:init(73,nil,nil,nil,nil,nil,false,nil,{fightSpirit=self.fightSpirit})

		ccui.Helper:seekWidgetByName(root, "Text_level"):setString(self.fightSpirit.level)
	else
		cell:init(73,nil,nil,nil,nil,nil,false,nil,{fightSpirit=fightSpirit})
		
		local count = 0
		local allFightSpirits = FightSpiritHandle.getAllFightSpiritsList()
		for i,fightSpirit in ipairs(allFightSpirits) do
			if fightSpirit.shipId <= 0 then
				local pos = dms.int(dms["fight_spirit_mould"], fightSpirit.mouldId, fight_spirit_mould.pos)
				local suitId = dms.int(dms["fight_spirit_mould"], fightSpirit.mouldId, fight_spirit_mould.suit_id)
				if fightSpirit.mouldId == self._mouldId then
					count = count + 1
				end
			end
		end
		ccui.Helper:seekWidgetByName(root, "Text_level"):setString(count)
	end
end

function FightSpiritCell2XlList:onEnterTransitionFinish()
	
end

function FightSpiritCell2XlList:onInit()
	 if not self.roots[1] then
		local csbNode = csb.createNode("packs/FightSpirit/FightSpirit_cell_2_xl_list.csb")
		local root = csbNode:getChildByName("root")
		table.insert(self.roots, root)
		self:addChild(csbNode)
	end

	local root = self.roots[1]
	if FightSpiritCell2XlList.__size == nil then
		FightSpiritCell2XlList.__size = root:getContentSize()
	end

	ccui.Helper:seekWidgetByName(root, "Image_1"):setSwallowTouches(false)
	self:onUpdateDraw()
end

function FightSpiritCell2XlList:onExit()
	-- 释放FightSpiritCell2XlListWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("packs/FightSpirit/FightSpirit_cell_2_xl_list.csb", root)
	-- ]]
end

function FightSpiritCell2XlList:reload()
	local root = self.roots[1]
	if root ~= nil or self.loadTag then
		return
	end
	self:onInit()
	self.loadTag = true
end

function FightSpiritCell2XlList:unload()
	local root = self.roots[1]
	if root == nil or not self.loadTag then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("packs/FightSpirit/FightSpirit_cell_2_xl_list.csb", root)
	
	self.roots = {}
	self.loadTag = false
end

-- ~END
-- ----------------------------------------------------------------------------
