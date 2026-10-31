-- ----------------------------------------------------------------------------------------------------
-- 说明：叛军帮助
-- 创建时间	2015-03-06
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

BetrayArmyHelp = class("BetrayArmyHelpClass", Window)
    
function BetrayArmyHelp:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
	self.BetrayArmyHelp = nil
	self.action = nil
    -- Initialize BetrayArmyHelp page state machine.
    local function init_world_boss_terminal()
	
		local betray_army_help_back_terminal = {
            _name = "betray_army_help_back",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance.actions[1]:play("window_close", false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
	
		state_machine.add(betray_army_help_back_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_world_boss_terminal()
end

-- function BetrayArmyHelp:drawAction()
	-- local myAction = csb.createTimeline("campaign/WorldBoss/wordBoss_help.csb") 
	-- myAction:play("window_close", false)
	-- self.BetrayArmyHelp:runAction(myAction)
	-- myAction:setFrameEventCallFunc(function (frame)
		-- if nil == frame then
			-- return
		-- end

		-- local str = frame:getEvent()
		-- if str == "open" then
		-- elseif str == "window_close_over" then
			-- fwin:close(self)
		-- end
	-- end)
-- end
function BetrayArmyHelp:onUpdateDraw()
	local root = self.roots[1]
	
	local textBetrayArmyReward = ccui.Helper:seekWidgetByName(root, "Text_456")
	local textBetrayArmyExploit = ccui.Helper:seekWidgetByName(root, "Text_456_0")
	local textBetrayArmyCredit = ccui.Helper:seekWidgetByName(root, "Text_456_0_0")
	
	textBetrayArmyReward:setString(_betray_army_reward_tip_info)
	textBetrayArmyExploit:setString(_betray_army_exploit_tip_info)
	textBetrayArmyCredit:setString(_betray_army_credit_tip_info)
end

function BetrayArmyHelp:onEnterTransitionFinish()
	local csbBetrayArmyHelp = csb.createNode("campaign/WorldBoss/wordBoss_help.csb")
	-- local action = csb.createTimeline("campaign/WorldBoss/wordBoss_help.csb") 
	local root = csbBetrayArmyHelp:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbBetrayArmyHelp)
	-- self.BetrayArmyHelp = csbBetrayArmyHelp
	-- self.action = action
	-- self.action:play("window_open", false)
	-- self.BetrayArmyHelp:runAction(self.action)
	local action = csb.createTimeline("campaign/WorldBoss/wordBoss_help.csb")
	table.insert(self.actions, action)
	csbBetrayArmyHelp:runAction(action)
	action:setFrameEventCallFunc(function (frame)
		if nil == frame then
			return
		end
		
		local str = frame:getEvent()
		if str == "window_close_over" then
			fwin:close(self)
		end
	end)
	action:play("window_open", false)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_274"), nil, 
		{
		terminal_name = "betray_army_help_back",
		terminal_state = 0,
		}, nil, 2)
	
	self:onUpdateDraw()
end


function BetrayArmyHelp:onExit()
	state_machine.remove("exploit_second_back")
end