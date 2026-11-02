LimSummonViewRule = class("LimSummonViewRuleClass", Window)

-- 打开窗口
local lim_summon_view_rule_window_open_terminal = {
    _name = "lim_summon_view_rule_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("LimSummonViewRuleClass") then
            fwin:open(LimSummonViewRule:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local lim_summon_view_rule_window_close_terminal = {
    _name = "lim_summon_view_rule_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LimSummonViewRuleClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(lim_summon_view_rule_window_open_terminal)
state_machine.add(lim_summon_view_rule_window_close_terminal)
state_machine.init()

function LimSummonViewRule:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    local function init_lim_summon_view_rule_terminal()
        
        local lim_summon_view_rule_close_terminal = 
        {
            _name = "lim_summon_view_rule_close",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:close(fwin:find("LimSummonViewRuleClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(lim_summon_view_rule_close_terminal)
        state_machine.init()
    end

    init_lim_summon_view_rule_terminal()
end

function LimSummonViewRule:init(params)
    self.params = params
    
    self:initData()
    
    if nil ~= self.onInit then
        self:onInit(params)
    end

    return self
end

function LimSummonViewRule:onEnterTransitionFinish()
    local csbNode = csb.createNode("activity/lim_summon/lim_summon_rule.csb")
    self:addChild(csbNode)

    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)

    -- 定义按钮控件
    self.btnClose = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil,
    {
        terminal_name = "lim_summon_view_rule_close",
        terminal_state = 0,
        isPressedActionEnabled = true,
    }, nil, 0)

    self:onUpdateDraw()
    self:showData()
end

function LimSummonViewRule:onUpdateDraw()
    local root = self.roots[1]

    -- 定义除按钮外的其他UI控件

end

function LimSummonViewRule:initData()
    -- 更新数据
end

function LimSummonViewRule:showData()
    -- 更新显示
end

function LimSummonViewRule:onExit()
    state_machine.remove("lim_summon_view_rule_close")
end

function LimSummonViewRule:close()

end

function LimSummonViewRule:destroy(window)
 
end