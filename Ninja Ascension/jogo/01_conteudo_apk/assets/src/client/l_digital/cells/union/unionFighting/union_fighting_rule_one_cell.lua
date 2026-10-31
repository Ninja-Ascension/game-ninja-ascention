-- ----------------------------------------------------------------------------------------------------
-- 说明：公会战规则1
-------------------------------------------------------------------------------------------------------
UnionFightingRuleOneCell = class("UnionFightingRuleOneCellClass", Window)
UnionFightingRuleOneCell.__size = nil

--创建cell
local union_fighting_rule_one_cell_create_terminal = {
    _name = "union_fighting_rule_one_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = UnionFightingRuleOneCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(union_fighting_rule_one_cell_create_terminal)
state_machine.init()

function UnionFightingRuleOneCell:ctor()
    self.super:ctor()
    self.roots = {}
	self.m_index = 0
	app.load("client.cells.utils.resources_icon_cell")
    -- Initialize UnionFightingRuleOneCell page state machine.
    local function init_sm_battle_of_kings_rule_one_cell_terminal()
	
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_sm_battle_of_kings_rule_one_cell_terminal()
end

function UnionFightingRuleOneCell:initDraw()
	local root = self.roots[1]

	
end

function UnionFightingRuleOneCell:onEnterTransitionFinish()
	
end

function UnionFightingRuleOneCell:onInit()
	local root = cacher.createUIRef(string.format(config_csb.union_fight.sm_legion_ghz_rule_cell, self.m_index), "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

 -- 	if UnionFightingRuleOneCell.__size == nil then
	--  	UnionFightingRuleOneCell.__size = root:getContentSize()
	-- end
	self:setContentSize(root:getContentSize())
	self:initDraw()
end


function UnionFightingRuleOneCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function UnionFightingRuleOneCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef(string.format(config_csb.union_fight.sm_legion_ghz_rule_cell, self.m_index), root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function UnionFightingRuleOneCell:init(params)
	self.m_index = params[1]
	self:onInit()
	-- self:setContentSize(UnionFightingRuleOneCell.__size)
	return self
end

function UnionFightingRuleOneCell:onExit()
	cacher.freeRef(string.format(config_csb.union_fight.sm_legion_ghz_rule_cell, self.m_index), self.roots[1])
end
