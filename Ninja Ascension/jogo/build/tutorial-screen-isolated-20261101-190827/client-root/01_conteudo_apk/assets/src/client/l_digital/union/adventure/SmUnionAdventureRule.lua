-- ----------------------------------------------------------------------------------------------------
-- 说明：公会大冒险规则
-------------------------------------------------------------------------------------------------------
SmUnionAdventureRule = class("SmUnionAdventureRuleClass", Window)

local sm_union_adventure_rule_open_terminal = {
    _name = "sm_union_adventure_rule_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionAdventureRuleClass")
        if nil == _homeWindow then
            local panel = SmUnionAdventureRule:new():init(params)
            fwin:open(panel,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_union_adventure_rule_close_terminal = {
    _name = "sm_union_adventure_rule_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionAdventureRuleClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmUnionAdventureRuleClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_union_adventure_rule_open_terminal)
state_machine.add(sm_union_adventure_rule_close_terminal)
state_machine.init()
    
function SmUnionAdventureRule:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    local function init_sm_union_adventure_rule_terminal()
        -- 显示界面
        local sm_union_adventure_rule_display_terminal = {
            _name = "sm_union_adventure_rule_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionAdventureRuleWindow = fwin:find("SmUnionAdventureRuleClass")
                if SmUnionAdventureRuleWindow ~= nil then
                    SmUnionAdventureRuleWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_union_adventure_rule_hide_terminal = {
            _name = "sm_union_adventure_rule_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionAdventureRuleWindow = fwin:find("SmUnionAdventureRuleClass")
                if SmUnionAdventureRuleWindow ~= nil then
                    SmUnionAdventureRuleWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_union_adventure_rule_display_terminal)
        state_machine.add(sm_union_adventure_rule_hide_terminal)
        state_machine.init()
    end
    init_sm_union_adventure_rule_terminal()
end


function SmUnionAdventureRule:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end

end

function SmUnionAdventureRule:init()
    self:onInit()
    return self
end


function SmUnionAdventureRule:onInit()
    local csbSmUnionAdventureRule = csb.createNode("legion/sm_legion_adventure_rule.csb")
    local root = csbSmUnionAdventureRule:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmUnionAdventureRule)
	
    self:onUpdateDraw()
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "sm_union_adventure_rule_close",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil,3)
	-- 
end

function SmUnionAdventureRule:onExit()
    state_machine.remove("sm_union_adventure_rule_display")
    state_machine.remove("sm_union_adventure_rule_hide")
end