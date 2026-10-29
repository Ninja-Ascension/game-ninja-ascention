-----------------------------
-- 王者之战规则界面
-----------------------------
SmCrossServerBattleofKingsRule = class("SmCrossServerBattleofKingsRuleClass", Window)

--打开界面
local sm_cross_server_battleof_kings_rule_open_terminal = {
	_name = "sm_cross_server_battleof_kings_rule_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("SmCrossServerBattleofKingsRuleClass") == nil then
			fwin:open(SmCrossServerBattleofKingsRule:new():init(params), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local sm_cross_server_battleof_kings_rule_close_terminal = {
	_name = "sm_cross_server_battleof_kings_rule_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmCrossServerBattleofKingsRuleClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_cross_server_battleof_kings_rule_open_terminal)
state_machine.add(sm_cross_server_battleof_kings_rule_close_terminal)
state_machine.init()

function SmCrossServerBattleofKingsRule:ctor()
	self.super:ctor()
	self.roots = {}
	app.load("client.l_digital.cells.campaign.crossServerBattleofKings.sm_cross_server_battle_of_kings_rule_one_cell")
	app.load("client.l_digital.cells.campaign.crossServerBattleofKings.sm_cross_server_battle_of_kings_rule_two_cell")

    local function init_sm_cross_server_battleof_kings_rule_terminal()
        --
        -- local sm_cross_server_ranking_union_view_the_first_place_terminal = {
            -- _name = "sm_cross_server_ranking_union_view_the_first_place",
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

        -- state_machine.add(sm_cross_server_ranking_union_view_the_first_place_terminal)

        state_machine.init()
    end
    init_sm_cross_server_battleof_kings_rule_terminal()
end

function SmCrossServerBattleofKingsRule:updateDraw()
	local root = self.roots[1]
	local ListView_jhsm_cross_servers_rule = ccui.Helper:seekWidgetByName(root,"ListView_jhsms_rule")
    ListView_jhsm_cross_servers_rule:removeAllItems()
    local cellOne = SmCrossServerBattleOfKingsRuleOneCell:createCell()
    cellOne:init()
    ListView_jhsm_cross_servers_rule:addChild(cellOne)

    -- local cellTwo = SmCrossServerBattleofKingsRuleTwoCell:createCell()
    -- cellTwo:init()
    -- ListView_jhsm_cross_servers_rule:addChild(cellTwo)

    for i=1, #dms["cross_the_kings_battle_score_rank_reward"] do
        local cellAll = SmCrossServerBattleOfKingsRuleTwoCell:createCell()
        cellAll:init(i)
        ListView_jhsm_cross_servers_rule:addChild(cellAll)
    end

    ListView_jhsm_cross_servers_rule:requestRefreshView()

end

function SmCrossServerBattleofKingsRule:init(params)
	self:onInit()
    return self
end

function SmCrossServerBattleofKingsRule:onInit()
    local csbItem = csb.createNode("campaign/BattleofKingsX/battle_of_kings_x_rule.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

	--关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "sm_cross_server_battleof_kings_rule_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
	self:updateDraw()
end

function SmCrossServerBattleofKingsRule:onEnterTransitionFinish()
    
end


function SmCrossServerBattleofKingsRule:onExit()
    state_machine.remove("sm_cross_server_battleof_kings_rule_change_page")
	state_machine.remove("sm_cross_server_battleof_kings_rule_open_rank")
end

