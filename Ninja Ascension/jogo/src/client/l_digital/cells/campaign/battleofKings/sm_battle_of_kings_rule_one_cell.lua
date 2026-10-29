-- ----------------------------------------------------------------------------------------------------
-- 说明：王者之战规则1
-------------------------------------------------------------------------------------------------------

SmBattleOfKingsRuleOneCell = class("SmBattleOfKingsRuleOneCellClass", Window)
SmBattleOfKingsRuleOneCell.__size = nil
function SmBattleOfKingsRuleOneCell:ctor()
    self.super:ctor()
    self.roots = {}
	self.m_index = 0
	app.load("client.cells.utils.resources_icon_cell")
    -- Initialize SmBattleOfKingsRuleOneCell page state machine.
    local function init_sm_battle_of_kings_rule_one_cell_terminal()
	
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_sm_battle_of_kings_rule_one_cell_terminal()
end

function SmBattleOfKingsRuleOneCell:initDraw()
	local root = self.roots[1]

	
end

function SmBattleOfKingsRuleOneCell:onEnterTransitionFinish()
	
end

function SmBattleOfKingsRuleOneCell:onInit()
	local root = cacher.createUIRef("campaign/BattleofKings/battle_of_kings_rule_list_1.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

 	if SmBattleOfKingsRuleOneCell.__size == nil then
	 	local Panel_list_2 = ccui.Helper:seekWidgetByName(root, "Panel_list_2")
		local MySize = Panel_list_2:getContentSize()

	 	SmBattleOfKingsRuleOneCell.__size = MySize
	end
	self:initDraw()
end


function SmBattleOfKingsRuleOneCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function SmBattleOfKingsRuleOneCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("campaign/BattleofKings/battle_of_kings_rule_list_1.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function SmBattleOfKingsRuleOneCell:init(index)
	self.m_index = index
	self:onInit()
	self:setContentSize(SmBattleOfKingsRuleOneCell.__size)
	return self
end

function SmBattleOfKingsRuleOneCell:createCell()
	local cell = SmBattleOfKingsRuleOneCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


function SmBattleOfKingsRuleOneCell:onExit()
	cacher.freeRef("campaign/BattleofKings/battle_of_kings_rule_list_1.csb", self.roots[1])
end
