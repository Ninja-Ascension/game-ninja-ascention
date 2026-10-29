-- ----------------------------------------------------------------------------------------------------
-- 说明：竞技场规则2
-------------------------------------------------------------------------------------------------------

ArenaRuleTwoCell = class("ArenaRuleTwoCellClass", Window)
ArenaRuleTwoCell.__size = nil
function ArenaRuleTwoCell:ctor()
    self.super:ctor()
    self.roots = {}
	
    -- Initialize ArenaRuleTwoCell page state machine.
    local function init_arena_rule_two_cell_terminal()
	
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_arena_rule_two_cell_terminal()
end

function ArenaRuleTwoCell:initDraw()
	local root = self.roots[1]

end

function ArenaRuleTwoCell:onEnterTransitionFinish()
	
end

function ArenaRuleTwoCell:onInit()
	local root = cacher.createUIRef("campaign/ArenaStorage/ArenaStorage_rule_list_2.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

 	if ArenaRuleTwoCell.__size == nil then
	 	ArenaRuleTwoCell.__size = root:getContentSize()
	end
	self:initDraw()
end

function ArenaRuleTwoCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function ArenaRuleTwoCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("campaign/ArenaStorage/ArenaStorage_rule_list_2.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function ArenaRuleTwoCell:init(role, index)
	self:onInit()
	self:setContentSize(ArenaRuleTwoCell.__size)
	return self
end

function ArenaRuleTwoCell:createCell()
	local cell = ArenaRuleTwoCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


function ArenaRuleTwoCell:onExit()
	cacher.freeRef("campaign/ArenaStorage/ArenaStorage_rule_list_2.csb", self.roots[1])
end
