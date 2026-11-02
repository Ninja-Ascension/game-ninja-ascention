-----------------------------
-- 王者之战规则界面
-----------------------------
SmBattleofKingsRule = class("SmBattleofKingsRuleClass", Window)

--打开界面
local sm_battleof_kings_rule_open_terminal = {
	_name = "sm_battleof_kings_rule_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("SmBattleofKingsRuleClass") == nil then
			fwin:open(SmBattleofKingsRule:new():init(params), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local sm_battleof_kings_rule_close_terminal = {
	_name = "sm_battleof_kings_rule_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmBattleofKingsRuleClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_battleof_kings_rule_open_terminal)
state_machine.add(sm_battleof_kings_rule_close_terminal)
state_machine.init()

function SmBattleofKingsRule:ctor()
	self.super:ctor()
	self.roots = {}
	app.load("client.l_digital.cells.campaign.battleofKings.sm_battle_of_kings_rule_one_cell")
	app.load("client.l_digital.cells.campaign.battleofKings.sm_battle_of_kings_rule_two_cell")

    local function init_sm_battleof_kings_rule_terminal()
        --
        -- local sm_ranking_union_view_the_first_place_terminal = {
            -- _name = "sm_ranking_union_view_the_first_place",
            -- _init = function (terminal)
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params)
                
                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }

        -- state_machine.add(sm_ranking_union_view_the_first_place_terminal)

        state_machine.init()
    end
    init_sm_battleof_kings_rule_terminal()
end

function SmBattleofKingsRule:updateDraw()
	local root = self.roots[1]
	local ListView_jhsms_rule = ccui.Helper:seekWidgetByName(root,"ListView_jhsms_rule")
    ListView_jhsms_rule:removeAllItems()
    local cellOne = SmBattleOfKingsRuleOneCell:createCell()
    cellOne:init()
    ListView_jhsms_rule:addChild(cellOne)

    -- local cellTwo = SmBattleofKingsRuleTwoCell:createCell()
    -- cellTwo:init()
    -- ListView_jhsms_rule:addChild(cellTwo)

    for i=1, #dms["the_kings_battle_score_rank_reward"] do
        local cellAll = SmBattleOfKingsRuleTwoCell:createCell()
        cellAll:init(i)
        ListView_jhsms_rule:addChild(cellAll)
    end

    ListView_jhsms_rule:requestRefreshView()

end

function SmBattleofKingsRule:init(params)
	self:onInit()
    return self
end

function SmBattleofKingsRule:onInit()
    local csbItem = csb.createNode("campaign/BattleofKings/battle_of_kings_rule.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

	--关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "sm_battleof_kings_rule_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
	self:updateDraw()
end

function SmBattleofKingsRule:onEnterTransitionFinish()
    
end


function SmBattleofKingsRule:onExit()
    state_machine.remove("sm_battleof_kings_rule_change_page")
	state_machine.remove("sm_battleof_kings_rule_open_rank")
end

