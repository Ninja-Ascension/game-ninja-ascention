--[[ ----------------------------------------------------------------------------
-- 天赋弹窗cell
--]] ----------------------------------------------------------------------------
MythicalAnimalsTalentTipCell = class("MythicalAnimalsTalentTipCellClass", Window)
MythicalAnimalsTalentTipCell.__size = nil

-- 创建Cell实例
local mythical_animals_talent_tip_cell_create_terminal = {
	_name = "mythical_animals_talent_tip_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if MythicalAnimalsTalentTipCell then
			local cell = MythicalAnimalsTalentTipCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(mythical_animals_talent_tip_cell_create_terminal)
state_machine.init()

-- 构造器
function MythicalAnimalsTalentTipCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize ninja biographies0 cell page state machine.
	local function init_mythical_animals_talent_tip_cell_terminal()
		
	end
	-- call func init ninja biographies0 cell state machine.
	init_mythical_animals_talent_tip_cell_terminal()
end

-- 对象初始化
function MythicalAnimalsTalentTipCell:init(params)
	self._index = params.index
	self._talentMouldId = params.talentMouldId
	-- 当前神兽的天赋阶级
	self._curStage = params.curStage

	self:onInit(params)
	
	self:setContentSize(MythicalAnimalsTalentTipCell.__size)
	return self
end

function MythicalAnimalsTalentTipCell:onUpdateDraw()
	local root = self.roots[1]

	self.Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
	self.Text_2_0 = ccui.Helper:seekWidgetByName(root, "Text_2_0")

	self:updateUI()
end

function MythicalAnimalsTalentTipCell:updateUI()
	self.Text_1:setString(string.format(tipStringInfo_magical_animals_word[4], self._index))

	local nameId = dms.int(dms["talent_mould"], self._talentMouldId, talent_mould.talent_describe)
	local word_info = dms.element(dms["word_mould"], nameId)
	self.Text_2_0:setString(word_info[3])

	if self._curStage >= self._index then
		self.Text_2_0:setColor((cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3])))
	else
		self.Text_2_0:setColor((cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3])))
	end
end

function MythicalAnimalsTalentTipCell:onInit(params)
	-- 加载MythicalAnimalsTalentTipCellWindow界面资源.
	-- res.cultivate.Mythical_animals.mythical_animals_prop_0 = res/cultivate/Mythical_animals/mythical_animals_prop_0.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("cultivate/Mythical_animals/mythical_animals_prop_0.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("cultivate/Mythical_animals/mythical_animals_prop_0.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if MythicalAnimalsTalentTipCell.__size == nil then
		MythicalAnimalsTalentTipCell.__size = root:getContentSize()
	end
	self:clearUIInfo()
	self:onUpdateDraw()
end

function MythicalAnimalsTalentTipCell:clearUIInfo( ... )
	local root = self.roots[1]
	if root == nil then
		return
	end

	self.Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
	self.Text_1:setString("")

	self.Text_2_0 = ccui.Helper:seekWidgetByName(root, "Text_2_0")
	self.Text_2_0:setString("")
end

function MythicalAnimalsTalentTipCell:onExit()
	-- 释放MythicalAnimalsTalentTipCellWindow界面资源.
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("cultivate/Mythical_animals/mythical_animals_prop_0.csb", root)
	-- ]]
end

function MythicalAnimalsTalentTipCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function MythicalAnimalsTalentTipCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("cultivate/Mythical_animals/mythical_animals_prop_0.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
