-- ----------------------------------------------------------------------------------------------------
-- 说明：本周的奖励
-------------------------------------------------------------------------------------------------------
AdventureWeekSignInReward = class("AdventureWeekSignInRewardClass", Window)
    
function AdventureWeekSignInReward:ctor()
    self.super:ctor()
	self.roots = {}
	
	app.load("client.adventure.activity.sign.AdventureWeekSignInRewardList")
    -- Initialize adventure daily sign in state machine.
    local function init_adventure_daily_sign_in_terminal()

        state_machine.init()
    end
    
    -- call func init adventure daily sign in state machine.
    init_adventure_daily_sign_in_terminal()
end

function AdventureWeekSignInReward:init()
    return self
end

function AdventureWeekSignInReward:onEnterTransitionFinish()
    local csbAdventureWeekSignInReward = csb.createNode("system/sign_week_1.csb")
    local root = csbAdventureWeekSignInReward:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureWeekSignInReward)
	local ListView_reward = ccui.Helper:seekWidgetByName(root, "ListView_reward")
	ListView_reward:removeAllItems()
	for i ,w in pairs(_ED.active_activity[38].activity_Info) do 
		local cell = AdventureWeekSignInRewardList:createCell()
		cell:init(w)
		ListView_reward:addChild(cell)
	end
	ListView_reward:requestRefreshView()
	
    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureWeekSignInRewardClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
end

function AdventureWeekSignInReward:onExit()
	state_machine.remove("everyday_sign_in_button")
end