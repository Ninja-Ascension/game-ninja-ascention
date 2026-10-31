-- ----------------------------------------------------------------------------------------------------
-- 说明：王者之战规则1
-------------------------------------------------------------------------------------------------------

SmCrossServerBattleOfKingsRuleOneCell = class("SmCrossServerBattleOfKingsRuleOneCellClass", Window)
SmCrossServerBattleOfKingsRuleOneCell.__size = nil
function SmCrossServerBattleOfKingsRuleOneCell:ctor()
    self.super:ctor()
    self.roots = {}
	self.m_index = 0
	app.load("client.cells.utils.resources_icon_cell")
    -- Initialize SmCrossServerBattleOfKingsRuleOneCell page state machine.
    local function init_sm_cross_server_battle_of_kings_rule_one_cell_terminal()
	
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_sm_cross_server_battle_of_kings_rule_one_cell_terminal()
end

function SmCrossServerBattleOfKingsRuleOneCell:initDraw()
	local root = self.roots[1]

	
end

function SmCrossServerBattleOfKingsRuleOneCell:onEnterTransitionFinish()
	
end

function SmCrossServerBattleOfKingsRuleOneCell:onInit()
	local root = cacher.createUIRef("campaign/BattleofKingsX/battle_of_kings_x_rule_list_1.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

 	if SmCrossServerBattleOfKingsRuleOneCell.__size == nil then
	 	local Panel_list_2 = ccui.Helper:seekWidgetByName(root, "Panel_list_2")
		local MySize = Panel_list_2:getContentSize()

	 	SmCrossServerBattleOfKingsRuleOneCell.__size = MySize
	end
	self:initDraw()
end


function SmCrossServerBattleOfKingsRuleOneCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function SmCrossServerBattleOfKingsRuleOneCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("campaign/BattleofKings/battle_of_kings_rule_list_1.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function SmCrossServerBattleOfKingsRuleOneCell:init(index)
	self.m_index = index
	self:onInit()
	self:setContentSize(SmCrossServerBattleOfKingsRuleOneCell.__size)
	return self
end

function SmCrossServerBattleOfKingsRuleOneCell:createCell()
	local cell = SmCrossServerBattleOfKingsRuleOneCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


function SmCrossServerBattleOfKingsRuleOneCell:onExit()
	cacher.freeRef("campaign/BattleofKings/battle_of_kings_rule_list_1.csb", self.roots[1])
end
