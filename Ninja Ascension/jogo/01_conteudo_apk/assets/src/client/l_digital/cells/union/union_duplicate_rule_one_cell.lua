-- ----------------------------------------------------------------------------------------------------
-- 说明：公会副本规则1
-------------------------------------------------------------------------------------------------------

UnionDuplicateRuleOneCell = class("UnionDuplicateRuleOneCellClass", Window)
UnionDuplicateRuleOneCell.__size = nil
function UnionDuplicateRuleOneCell:ctor()
    self.super:ctor()
    self.roots = {}
	
    -- Initialize UnionDuplicateRuleOneCell page state machine.
    local function init_union_duplicate_rule_one_cell_terminal()
	
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_union_duplicate_rule_one_cell_terminal()
end

function UnionDuplicateRuleOneCell:initDraw()
	local root = self.roots[1]

end

function UnionDuplicateRuleOneCell:onEnterTransitionFinish()
	
end

function UnionDuplicateRuleOneCell:onInit()
	local root = cacher.createUIRef("legion/sm_legion_pve_window_rule_list_1.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

 	if UnionDuplicateRuleOneCell.__size == nil then
	 	local Panel_list_1 = ccui.Helper:seekWidgetByName(root, "Panel_list_1")
		local MySize = Panel_list_1:getContentSize()

	 	UnionDuplicateRuleOneCell.__size = MySize
	end
	self:initDraw()
end


function UnionDuplicateRuleOneCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function UnionDuplicateRuleOneCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("legion/sm_legion_pve_window_rule_list_1.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function UnionDuplicateRuleOneCell:init()
	self:onInit()
	self:setContentSize(UnionDuplicateRuleOneCell.__size)
	return self
end

function UnionDuplicateRuleOneCell:createCell()
	local cell = UnionDuplicateRuleOneCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


function UnionDuplicateRuleOneCell:onExit()
	cacher.freeRef("legion/sm_legion_pve_window_rule_list_1.csb", self.roots[1])
end
