--------------------------------------------------------------------------------------------------------------
--  说明：首战对话气泡3
--------------------------------------------------------------------------------------------------------------
BattleStoryThree = class("BattleStoryThreeClass", Window)

--打开界面
local battle_story_three_window_open_terminal = {
	_name = "battle_story_three_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("BattleStoryThreeClass") == nil then

		   fwin:open(BattleStoryThree:new():init(),fwin._windows)
        end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local battle_story_three_window_close_terminal = {
	_name = "battle_story_three_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("BattleStoryThreeClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(battle_story_three_window_open_terminal)
state_machine.add(battle_story_three_window_close_terminal)
state_machine.init()

function BattleStoryThree:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}

	 -- Initialize alert_home state machine.
    local function init_battle_story_three_terminal()

        state_machine.init()
    end
   
    init_battle_story_three_terminal()

end

function BattleStoryThree:onUpdateDraw()
    local root = self.roots[1]

end

--初始化界面
function BattleStoryThree:onInit()
    local csbItem = csb.createNode(config_csb.mission.missionex.battle_story_3)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)  

    local action = csb.createTimeline(config_csb.mission.missionex.battle_story_3)
    table.insert(self.actions, action)
    csbItem:runAction(action)
    action:play("chat_1", false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        if frame == "chat_1_over" then
            state_machine.excute("battle_story_three_window_close",0,"")
        end
    end)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_story_x"), nil, 
    {
        terminal_name = "battle_story_three_window_close", 
        terminal_state = 0, 
    }, nil, 0)
	self:onUpdateDraw()
end

function BattleStoryThree:onEnterTransitionFinish()

end

function BattleStoryThree:init()
	self:onInit()
    return self
end

--移除状态机
function BattleStoryThree:onExit()

end