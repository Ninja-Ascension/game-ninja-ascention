-----------------------------
-- 合金矩阵主界面
-----------------------------
AlloyMatrixRule = class("AlloyMatrixRuleClass", Window)

local alloy_matrix_rule_open_terminal = {
	_name = "alloy_matrix_rule_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("AlloyMatrixRuleClass") == nil then
            fwin:open(AlloyMatrixRule:new():init(), fwin._ui)     
        end
	end,
	_terminal = nil,
	_terminals = nil
}

local alloy_matrix_rule_close_terminal = {
	_name = "alloy_matrix_rule_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("AlloyMatrixRuleClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(alloy_matrix_rule_open_terminal)
state_machine.add(alloy_matrix_rule_close_terminal)
state_machine.init()

function AlloyMatrixRule:ctor()
	self.super:ctor()
	self.roots = {}
end


function AlloyMatrixRule:onUpdateDraw()
    local root = self.roots[1]
end

function AlloyMatrixRule:onUpdate( dt )
    
end

function AlloyMatrixRule:init(params)
	self:onInit()
    return self
end

function AlloyMatrixRule:onInit()
    local csbItem = csb.createNode("cultivate/alloy_matrix_rule.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    --中级矩阵
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_matrix_rule_text__close"), nil, 
    {
        terminal_name = "alloy_matrix_rule_close", 
        terminal_state = 0,
        touch_black = true,
    }, nil, 3)
end

function AlloyMatrixRule:onEnterTransitionFinish()
end

function AlloyMatrixRule:onExit()
    state_machine.remove("tab_btn_change")
end
