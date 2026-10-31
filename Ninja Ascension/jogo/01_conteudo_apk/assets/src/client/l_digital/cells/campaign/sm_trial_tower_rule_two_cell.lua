-- ----------------------------------------------------------------------------------------------------
-- 说明：试炼规则2
-------------------------------------------------------------------------------------------------------

SmTrialTowerRuleTwoCell = class("SmTrialTowerRuleTwoCellClass", Window)
SmTrialTowerRuleTwoCell.__size = nil
function SmTrialTowerRuleTwoCell:ctor()
    self.super:ctor()
    self.roots = {}
	self.m_index = 0
	app.load("client.cells.utils.resources_icon_cell")
    -- Initialize SmTrialTowerRuleTwoCell page state machine.
    local function init_sm_trial_tower_rule_two_cell_terminal()
	
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_sm_trial_tower_rule_two_cell_terminal()
end

function SmTrialTowerRuleTwoCell:initDraw()
	local root = self.roots[1]

	
end

function SmTrialTowerRuleTwoCell:onEnterTransitionFinish()
	
end

function SmTrialTowerRuleTwoCell:onInit()
	local root = cacher.createUIRef("campaign/TrialTower/sm_trial_tower_rule_2.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

 	if SmTrialTowerRuleTwoCell.__size == nil then
	 	local Panel_list_2 = ccui.Helper:seekWidgetByName(root, "Panel_list_2")
		local MySize = Panel_list_2:getContentSize()

	 	SmTrialTowerRuleTwoCell.__size = MySize
	end
	self:initDraw()
end


function SmTrialTowerRuleTwoCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function SmTrialTowerRuleTwoCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("campaign/TrialTower/sm_trial_tower_rule_2.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function SmTrialTowerRuleTwoCell:init(index)
	self.m_index = index
	self:onInit()
	self:setContentSize(SmTrialTowerRuleTwoCell.__size)
	return self
end

function SmTrialTowerRuleTwoCell:createCell()
	local cell = SmTrialTowerRuleTwoCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


function SmTrialTowerRuleTwoCell:onExit()
	cacher.freeRef("campaign/TrialTower/sm_trial_tower_rule_2.csb", self.roots[1])
end
