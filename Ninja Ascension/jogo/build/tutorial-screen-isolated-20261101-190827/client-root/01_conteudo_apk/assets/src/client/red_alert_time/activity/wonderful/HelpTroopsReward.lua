-- ----------------------------------------------------------------------------------------------------
-- 说明：新手教学总部缓军奖励
-- ----------------------------------------------------------------------------------------------------
HelpTroopsReward = class("HelpTroopsRewardClass", Window)

local help_troops_reward_window_open_terminal = {
	_name = "help_troops_reward_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:open(HelpTroopsReward:new():init(params), fwin._dialog)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local help_troops_reward_window_close_terminal = {
	_name = "help_troops_reward_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("HelpTroopsRewardClass"))
		saveExecuteEventByOfScriptAfter()
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(help_troops_reward_window_open_terminal)
state_machine.add(help_troops_reward_window_close_terminal)
state_machine.init()

function HelpTroopsReward:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
	
	local function init_help_troops_reward_terminal()
		state_machine.init()
	end
	
	init_help_troops_reward_terminal()
end

function HelpTroopsReward:onUpdateDraw(params)
	-- -- local mission = currentExecuteMission()
	-- local rewardString = dms.string(dms["user_config"],34,user_config.param)
	-- local rewardArr = zstring.split(rewardString, "|")
	-- print(rewardString)
end

function HelpTroopsReward:onInit(params)
	local csbHelpTroopsReward = csb.createNode("utils/help_troops_reward.csb")
	self:addChild(csbHelpTroopsReward)
	local root = csbHelpTroopsReward:getChildByName("root")
	table.insert(self.roots, root)

	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_troops_reward_rec"), nil, 
    {
        terminal_name = "help_troops_reward_window_close", 
        terminal_state = 0, 
        touch_black = true,
        isPressedActionEnabled = true,
    }, nil, 3)

    self:onUpdateDraw(params)
end

function HelpTroopsReward:init(params)
	self:onInit(params)
	return self
end

function HelpTroopsReward:onEnterTransitionFinish()
	
end

function HelpTroopsReward:onExit()

end
