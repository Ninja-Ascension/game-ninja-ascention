-- ----------------------------------------------------------------------------------------------------
-- 说明：老虎机规则1
-------------------------------------------------------------------------------------------------------

UnionSlotMachineRuleOneCell = class("UnionSlotMachineRuleOneCellClass", Window)
UnionSlotMachineRuleOneCell.__size = nil
function UnionSlotMachineRuleOneCell:ctor()
    self.super:ctor()
    self.roots = {}
	
    -- Initialize UnionSlotMachineRuleOneCell page state machine.
    local function init_union_slot_machine_rule_one_cell_terminal()
	
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_union_slot_machine_rule_one_cell_terminal()
end

function UnionSlotMachineRuleOneCell:initDraw()
	local root = self.roots[1]

end

function UnionSlotMachineRuleOneCell:onEnterTransitionFinish()
	
end

function UnionSlotMachineRuleOneCell:onInit()
	local root = cacher.createUIRef("legion/sm_legion_luck_draw_rule_list_1.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

 	if UnionSlotMachineRuleOneCell.__size == nil then
	 	local Panel_list_1 = ccui.Helper:seekWidgetByName(root, "Panel_list_1")
		local MySize = Panel_list_1:getContentSize()

	 	UnionSlotMachineRuleOneCell.__size = MySize
	end
	self:initDraw()
end


function UnionSlotMachineRuleOneCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function UnionSlotMachineRuleOneCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("legion/sm_legion_luck_draw_rule_list_1.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function UnionSlotMachineRuleOneCell:init()
	self:onInit()
	self:setContentSize(UnionSlotMachineRuleOneCell.__size)
	return self
end

function UnionSlotMachineRuleOneCell:createCell()
	local cell = UnionSlotMachineRuleOneCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


function UnionSlotMachineRuleOneCell:onExit()
	cacher.freeRef("legion/sm_legion_luck_draw_rule_list_1.csb", self.roots[1])
end
