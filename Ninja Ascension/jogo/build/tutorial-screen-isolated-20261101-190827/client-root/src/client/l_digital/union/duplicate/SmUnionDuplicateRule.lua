-- ----------------------------------------------------------------------------------------------------
-- 说明：公会副本规则
-------------------------------------------------------------------------------------------------------
SmUnionDuplicateRule = class("SmUnionDuplicateRuleClass", Window)

local sm_union_duplicate_rule_open_terminal = {
    _name = "sm_union_duplicate_rule_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionDuplicateRuleClass")
        if nil == _homeWindow then
            local panel = SmUnionDuplicateRule:new():init()
            fwin:open(panel,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_union_duplicate_rule_close_terminal = {
    _name = "sm_union_duplicate_rule_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionDuplicateRuleClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmUnionDuplicateRuleClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_union_duplicate_rule_open_terminal)
state_machine.add(sm_union_duplicate_rule_close_terminal)
state_machine.init()
    
function SmUnionDuplicateRule:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.start_up_page = 1
    app.load("client.l_digital.cells.union.union_duplicate_rule_one_cell")
    app.load("client.l_digital.cells.union.union_duplicate_rule_two_cell")
    local function init_sm_union_duplicate_rule_terminal()
        -- 显示界面
        local sm_union_duplicate_rule_display_terminal = {
            _name = "sm_union_duplicate_rule_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionDuplicateRuleWindow = fwin:find("SmUnionDuplicateRuleClass")
                if SmUnionDuplicateRuleWindow ~= nil then
                    SmUnionDuplicateRuleWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_union_duplicate_rule_hide_terminal = {
            _name = "sm_union_duplicate_rule_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionDuplicateRuleWindow = fwin:find("SmUnionDuplicateRuleClass")
                if SmUnionDuplicateRuleWindow ~= nil then
                    SmUnionDuplicateRuleWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_union_duplicate_rule_display_terminal)
        state_machine.add(sm_union_duplicate_rule_hide_terminal)

        state_machine.init()
    end
    init_sm_union_duplicate_rule_terminal()
end


function SmUnionDuplicateRule:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local ListView_lb_rule = ccui.Helper:seekWidgetByName(root,"ListView_ghfb_rule")
    ListView_lb_rule:removeAllItems()

    local cellOne = UnionDuplicateRuleOneCell:createCell()
    cellOne:init()
    ListView_lb_rule:addChild(cellOne)

    for i=1, 23 do
        local cellAll = UnionDuplicateRuleTwoCell:createCell()
        cellAll:init(i)
        ListView_lb_rule:addChild(cellAll)
    end

    ListView_lb_rule:requestRefreshView()
end

function SmUnionDuplicateRule:init()
    self:onInit()
    return self
end

function SmUnionDuplicateRule:onInit()
    local csbSmUnionDuplicateRule = csb.createNode("legion/sm_legion_pve_window_rule.csb")
    local root = csbSmUnionDuplicateRule:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmUnionDuplicateRule)
	
	-- self:onUpdateDraw()
    -- self:showImageAnimation()
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "sm_union_duplicate_rule_close",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil,3)
    
    self:onUpdateDraw()
end

function SmUnionDuplicateRule:onExit()
    state_machine.remove("sm_union_duplicate_rule_display")
    state_machine.remove("sm_union_duplicate_rule_hide")
end