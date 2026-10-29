----------------------------------------------------------------------------------------------------
-- 说明：武将精灵动画
----------------------------------------------------------------------------------------------------
AdventureHeroSpxCell = class("AdventureHeroSpxCellClass", Window)

function AdventureHeroSpxCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- Initialize adventure firend list cell state machine.
	local function init_firend_list_cell_terminal()
        state_machine.init()
	end

	-- call func init adventure firend list cell state machine.
	init_firend_list_cell_terminal()
end

function AdventureHeroSpxCell:onEnterTransitionFinish()

end

function AdventureHeroSpxCell:onInit()

end

function AdventureHeroSpxCell:onExit()

end

function AdventureHeroSpxCell:init()
	return self
end

function AdventureHeroSpxCell:createCell()
	local cell = AdventureHeroSpxCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

