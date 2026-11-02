-----------------------------
-- 公会战规则界面
-----------------------------
UnionFightingRule = class("UnionFightingRuleClass", Window)

--打开界面
local union_fighting_rule_open_terminal = {
	_name = "union_fighting_rule_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("UnionFightingRuleClass") == nil then
			fwin:open(UnionFightingRule:new():init(params), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local union_fighting_rule_close_terminal = {
	_name = "union_fighting_rule_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("UnionFightingRuleClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(union_fighting_rule_open_terminal)
state_machine.add(union_fighting_rule_close_terminal)
state_machine.init()

function UnionFightingRule:ctor()
	self.super:ctor()
	self.roots = {}
	app.load("client.l_digital.cells.union.unionFighting.union_fighting_rule_one_cell")
	app.load("client.l_digital.cells.union.unionFighting.union_fighting_rule_two_cell")

    local function init_union_fighting_rule_terminal()
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
    init_union_fighting_rule_terminal()
end

function UnionFightingRule:updateDraw()
	local root = self.roots[1]
	local ListView_jhsms_rule = ccui.Helper:seekWidgetByName(root,"ListView_jhsms_rule")
    ListView_jhsms_rule:removeAllItems()
    local cellOne = state_machine.excute("union_fighting_rule_one_cell_create", 0, {1})
    ListView_jhsms_rule:addChild(cellOne)

    -- 预选赛和复赛奖励
    fwin:addService({
        callback = function ( params )
            if params ~= nil and params.roots ~= nil and params.roots[1] ~= nil then
                local reward_list = dms.searchs(dms["union_warfare_score_rank_reward"], union_warfare_score_rank_reward.rank_type, "1")
                for k, v in pairs(reward_list) do
                    local cellAll = state_machine.excute("union_fighting_rule_two_cell_create", 0, {k, v})
                    ListView_jhsms_rule:addChild(cellAll)
                end
                ListView_jhsms_rule:requestRefreshView()
            end
        end,
        delay = 0.15,
        params = self
    })

    fwin:addService({
        callback = function ( params )
            if params ~= nil and params.roots ~= nil and params.roots[1] ~= nil then
                local cellTwo = state_machine.excute("union_fighting_rule_one_cell_create", 0, {3})
                ListView_jhsms_rule:addChild(cellTwo)

                -- 决赛奖励
                reward_list = dms.searchs(dms["union_warfare_score_rank_reward"], union_warfare_score_rank_reward.rank_type, "2")
                for k, v in pairs(reward_list) do
                    local cellAll = state_machine.excute("union_fighting_rule_two_cell_create", 0, {k, v})
                    ListView_jhsms_rule:addChild(cellAll)
                end
                ListView_jhsms_rule:requestRefreshView()
            end
        end,
        delay = 0.25,
        params = self
    })
end

function UnionFightingRule:init(params)
	self:onInit()
    return self
end

function UnionFightingRule:onInit()
    local csbItem = csb.createNode(config_csb.union_fight.sm_legion_ghz_rule)
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

	--关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "union_fighting_rule_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
	self:updateDraw()
end

function UnionFightingRule:onEnterTransitionFinish()
    
end


function UnionFightingRule:onExit()

end

