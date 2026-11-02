-- ----------------------------------------------------------------------------------------------------
-- 说明：公会老虎机规则
-------------------------------------------------------------------------------------------------------
SmUnionSlotMachineRule = class("SmUnionSlotMachineRuleClass", Window)

local sm_union_slot_machine_rule_open_terminal = {
    _name = "sm_union_slot_machine_rule_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionSlotMachineRuleClass")
        if nil == _homeWindow then
            local panel = SmUnionSlotMachineRule:new():init()
            fwin:open(panel,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_union_slot_machine_rule_close_terminal = {
    _name = "sm_union_slot_machine_rule_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionSlotMachineRuleClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmUnionSlotMachineRuleClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_union_slot_machine_rule_open_terminal)
state_machine.add(sm_union_slot_machine_rule_close_terminal)
state_machine.init()
    
function SmUnionSlotMachineRule:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.start_up_page = 1
    app.load("client.l_digital.cells.union.union_slot_machine_rule_one_cell")
    app.load("client.l_digital.cells.union.union_slot_machine_rule_two_cell")
    local function init_sm_union_slot_machine_rule_terminal()
        -- 显示界面
        local sm_union_slot_machine_rule_display_terminal = {
            _name = "sm_union_slot_machine_rule_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionSlotMachineRuleWindow = fwin:find("SmUnionSlotMachineRuleClass")
                if SmUnionSlotMachineRuleWindow ~= nil then
                    SmUnionSlotMachineRuleWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_union_slot_machine_rule_hide_terminal = {
            _name = "sm_union_slot_machine_rule_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionSlotMachineRuleWindow = fwin:find("SmUnionSlotMachineRuleClass")
                if SmUnionSlotMachineRuleWindow ~= nil then
                    SmUnionSlotMachineRuleWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_union_slot_machine_rule_display_terminal)
        state_machine.add(sm_union_slot_machine_rule_hide_terminal)

        state_machine.init()
    end
    init_sm_union_slot_machine_rule_terminal()
end


function SmUnionSlotMachineRule:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local ListView_lb_rule = ccui.Helper:seekWidgetByName(root,"ListView_lb_rule")
    ListView_lb_rule:removeAllItems()

    local cellOne = UnionSlotMachineRuleOneCell:createCell()
    cellOne:init()
    ListView_lb_rule:addChild(cellOne)

    for i=1, 7 do
        local cellAll = UnionSlotMachineRuleTwoCell:createCell()
        cellAll:init(i)
        ListView_lb_rule:addChild(cellAll)
    end

    ListView_lb_rule:requestRefreshView()
end

function SmUnionSlotMachineRule:init()
    self:onInit()
    return self
end

function SmUnionSlotMachineRule:onInit()
    local csbSmUnionSlotMachineRule = csb.createNode("legion/sm_legion_luck_draw_rule.csb")
    local root = csbSmUnionSlotMachineRule:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmUnionSlotMachineRule)
	
	-- self:onUpdateDraw()
    -- self:showImageAnimation()
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "sm_union_slot_machine_rule_close",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil,3)
    
    self:onUpdateDraw()
end

function SmUnionSlotMachineRule:onExit()
    state_machine.remove("sm_union_slot_machine_rule_display")
    state_machine.remove("sm_union_slot_machine_rule_hide")
end