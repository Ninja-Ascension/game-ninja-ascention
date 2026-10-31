UnionFightingDuleReport = class("UnionFightingDuleReportClass", Window)

local union_fighting_dule_report_open_terminal = {
	_name = "union_fighting_dule_report_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("UnionFightingDuleReportClass") == nil then
            fwin:open(UnionFightingDuleReport:new():init(params), fwin._ui)
        end
        return true
	end,
	_terminal = nil,
	_terminals = nil
}

local union_fighting_dule_report_close_terminal = {
	_name = "union_fighting_dule_report_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("UnionFightingDuleReportClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(union_fighting_dule_report_open_terminal)
state_machine.add(union_fighting_dule_report_close_terminal)
state_machine.init()

function UnionFightingDuleReport:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

    local function init_union_fighting_dule_report_terminal()
    end
    init_union_fighting_dule_report_terminal()
end

function UnionFightingDuleReport:updateDraw()
	local root = self.roots[1]
	if root == nil then
		return
	end
    local Panel_ghz_js_zk = ccui.Helper:seekWidgetByName(root, "Panel_ghz_js_zk")
    Panel_ghz_js_zk:removeAllChildren(true)
    state_machine.excute("union_fighting_dule_window_open", 0, {Panel_ghz_js_zk})
end

function UnionFightingDuleReport:onInit()
	local csbUnion = csb.createNode(config_csb.union_fight.sm_legion_ghz_js_fighting)
    local root = csbUnion:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbUnion)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_wzzz_back"), nil, 
    {
        terminal_name = "union_fighting_dule_report_close", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    state_machine.excute("sm_union_user_topinfo_open",0,self)
    self:updateDraw()
end

function UnionFightingDuleReport:onEnterTransitionFinish()
end

function UnionFightingDuleReport:init(params)
    self:onInit()
	return self
end

function UnionFightingDuleReport:onExit()
end
