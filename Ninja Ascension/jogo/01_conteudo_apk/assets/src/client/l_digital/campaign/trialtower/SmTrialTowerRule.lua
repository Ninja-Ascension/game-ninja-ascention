-----------------------------
-- 试炼规则界面
-----------------------------
SmTrialTowerRule = class("SmTrialTowerRuleClass", Window)

--打开界面
local sm_trial_tower_rule_open_terminal = {
	_name = "sm_trial_tower_rule_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("SmTrialTowerRuleClass") == nil then
			fwin:open(SmTrialTowerRule:new():init(params), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local sm_trial_tower_rule_close_terminal = {
	_name = "sm_trial_tower_rule_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmTrialTowerRuleClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_trial_tower_rule_open_terminal)
state_machine.add(sm_trial_tower_rule_close_terminal)
state_machine.init()

function SmTrialTowerRule:ctor()
	self.super:ctor()
	self.roots = {}
	app.load("client.l_digital.cells.campaign.sm_trial_tower_rule_one_cell")
	app.load("client.l_digital.cells.campaign.sm_trial_tower_rule_two_cell")
	app.load("client.l_digital.cells.campaign.sm_trial_tower_rule_three_cell")

    local function init_sm_trial_tower_rule_terminal()
        --
        local sm_ranking_union_view_the_first_place_terminal = {
            _name = "sm_ranking_union_view_the_first_place",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_ranking_union_view_the_first_place_terminal)

        state_machine.init()
    end
    init_sm_trial_tower_rule_terminal()
end

function SmTrialTowerRule:updateDraw()
	local root = self.roots[1]
	local ListView_rule = ccui.Helper:seekWidgetByName(root,"ListView_rule")
    ListView_rule:removeAllItems()
    local cellOne = SmTrialTowerRuleOneCell:createCell()
    cellOne:init()
    ListView_rule:addChild(cellOne)

    local cellTwo = SmTrialTowerRuleTwoCell:createCell()
    cellTwo:init()
    ListView_rule:addChild(cellTwo)

    for i=1, 10 do
        local cellAll = SmTrialTowerRuleThreeCell:createCell()
        cellAll:init(i)
        ListView_rule:addChild(cellAll)
    end

    ListView_rule:requestRefreshView()

end

function SmTrialTowerRule:init(params)
	self:onInit()
    return self
end

function SmTrialTowerRule:onInit()
    local csbItem = csb.createNode("campaign/TrialTower/sm_trial_tower_rule.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

	--关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "sm_trial_tower_rule_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
	self:updateDraw()
end

function SmTrialTowerRule:onEnterTransitionFinish()
    
end


function SmTrialTowerRule:onExit()
    state_machine.remove("sm_trial_tower_rule_change_page")
	state_machine.remove("sm_trial_tower_rule_open_rank")
end

