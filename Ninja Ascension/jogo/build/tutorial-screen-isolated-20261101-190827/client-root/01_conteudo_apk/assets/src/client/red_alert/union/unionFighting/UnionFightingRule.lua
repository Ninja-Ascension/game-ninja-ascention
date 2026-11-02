UnionFightingRule = class("UnionFightingRuleClass", Window)

local union_fighting_rule_open_terminal = {
	_name = "union_fighting_rule_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:open(UnionFightingRule:new():init(params), fwin._ui)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local union_fighting_rule_close_terminal = {
	_name = "union_fighting_rule_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("UnionFightingRuleClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(union_fighting_rule_open_terminal)
state_machine.add(union_fighting_rule_close_terminal)
state_machine.init()

function UnionFightingRule:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
end

function UnionFightingRule:onInit(params)
	local csbNode = csb.createNode(config_csb.legion.legion_rule)
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "union_fighting_rule_close", 
        terminal_state = 0,
        isPressedActionEnabled = true,
    }, 
    nil, 0)

    ccui.Helper:seekWidgetByName(root, "Text_rule_inner_2"):setVisible(true)
end

function UnionFightingRule:onEnterTransitionFinish()
end

function UnionFightingRule:init()
    self:onInit()
	return self
end

function UnionFightingRule:onExit()

end
