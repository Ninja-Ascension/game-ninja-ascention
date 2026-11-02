-- ----------------------------------------------------------------------------------------------------
-- 说明：竞技场规则
-------------------------------------------------------------------------------------------------------

ArenaRulePanel = class("ArenaRulePanelClass", Window)

--打开界面
local sm_arena_rule_panel_open_terminal = {
	_name = "sm_arena_rule_panel_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("ArenaRulePanelClass") == nil then
			fwin:open(ArenaRulePanel:new(),_view)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_arena_rule_panel_open_terminal)
state_machine.init()
    
function ArenaRulePanel:ctor()
    self.super:ctor()
    self.roots = {}

    app.load("client.l_digital.cells.arena.arena_rule_one_cell")
    app.load("client.l_digital.cells.arena.arena_rule_two_cell")
    app.load("client.l_digital.cells.arena.arena_rule_three_cell")
	
    -- Initialize ArenaRulePanel page state machine.
    local function init_arena_rule_panel_terminal()
	
		--关闭面板
		local arena_rule_panel_close_terminal = {
            _name = "arena_rule_panel_close",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				-- fwin:open(Campaign:new(), fwin._view)
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(arena_rule_panel_close_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_arena_rule_panel_terminal()
end

function ArenaRulePanel:initDraw()
	local root = self.roots[1]
	local ListView_rule = ccui.Helper:seekWidgetByName(root, "ListView_rule")

	local rulePanelOne = ArenaRuleOneCell:createCell()
	rulePanelOne:init()
	ListView_rule:addChild(rulePanelOne)

	local rulePanelTwo = ArenaRuleTwoCell:createCell()
	rulePanelTwo:init()
	ListView_rule:addChild(rulePanelTwo)

	for i=1,10 do
		local rulePanelThree = ArenaRuleThreeCell:createCell()
		rulePanelThree:init(i)
		ListView_rule:addChild(rulePanelThree)
	end
end

function ArenaRulePanel:onUpdate(dt)

end

function ArenaRulePanel:onEnterTransitionFinish()
	
    local csbArenaRankPanel = csb.createNode("campaign/ArenaStorage/ArenaStorage_rule.csb")
	-- local action = csb.createTimeline("campaign/ArenaStorage/ArenaStorage_rule.csb")
	local root = csbArenaRankPanel:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbArenaRankPanel)
	
	-- csbArenaRankPanel:runAction(action)
	-- action:gotoFrameAndPlay(0, action:getDuration(), false)
	
	self:initDraw()
	--添加返回点击事件
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"), 	nil, 
	{
		terminal_name = "arena_rule_panel_close", 	
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 2)

	app.load("client.player.UserInformationHeroStorage")
    local userInformationHeroStorage = UserInformationHeroStorage:new()
    userInformationHeroStorage._rootWindows = self
    fwin:open(userInformationHeroStorage,fwin._view)
end

--关闭所有按钮的高亮显示
function ArenaRulePanel:closeHighlighted()
end

function ArenaRulePanel:onExit()
	state_machine.remove("arena_rule_panel_close")
end
