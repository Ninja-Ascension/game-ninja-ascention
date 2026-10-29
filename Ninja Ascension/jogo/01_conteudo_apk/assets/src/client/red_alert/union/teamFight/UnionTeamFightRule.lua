-----------------------------
--规则
-----------------------------
UnionTeamFightRule = class("UnionTeamFightRuleClass", Window)
--打开
local union_team_fight_rule_window_open_terminal = {
    _name = "union_team_fight_rule_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local index = params[1]
        fwin:open(UnionTeamFightRule:new():init(index), fwin._view)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
--关闭
local union_team_fight_rule_window_close_terminal = {
    _name = "union_team_fight_rule_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("UnionTeamFightRuleClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(union_team_fight_rule_window_open_terminal)
state_machine.add(union_team_fight_rule_window_close_terminal)
state_machine.init()

function UnionTeamFightRule:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    local function init_union_team_fight_rule_terminal()
        --显示界面
        local union_team_fight_rule_window_show_terminal = {
            _name = "union_team_fight_rule_window_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
        
        --隐藏界面
        local union_team_fight_rule_window_hide_terminal = {
            _name = "union_team_fight_rule_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(union_team_fight_rule_window_show_terminal)
        state_machine.add(union_team_fight_rule_window_hide_terminal)
        state_machine.init()
    end

    init_union_team_fight_rule_terminal()
end 

function UnionTeamFightRule:onUpdateDraw()
    local root = self.roots[1]
    local Text_rule = ccui.Helper:seekWidgetByName(root, "Text_rule_"..self._index)
    local Text_rule_inner = ccui.Helper:seekWidgetByName(root, "Text_rule_inner_"..self._index) 
    Text_rule:setVisible(true)
    Text_rule_inner:setVisible(true)
end

function UnionTeamFightRule:onHide( )
    self:setVisible(false)
end

function UnionTeamFightRule:onShow( )
    self:setVisible(true)
end

function UnionTeamFightRule:onInit( )
    local csbItem = csb.createNode(config_csb.legion.legion_rule)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.legion.legion_rule)
    table.insert(self.actions, action)
    csbItem:runAction(action)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "union_team_fight_rule_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    self:onUpdateDraw()
end

function UnionTeamFightRule:init(index)
    self._index = index
	self:onInit()
    return self
end

function UnionTeamFightRule:onExit()  
    
    state_machine.remove("union_team_fight_rule_window_show")
    state_machine.remove("union_team_fight_rule_window_hide")
end