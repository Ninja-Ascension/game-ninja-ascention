


BattleStoryTwo = class("BattleStoryTwoClass", Window)


local battle_story_two_window_open_terminal = {
	_name = "battle_story_two_window_open",
	_init = function (terminal)

	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("BattleStoryTwoClass") == nil then

		   fwin:open(BattleStoryTwo:new():init(),fwin._windows)
        end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}


local battle_story_two_window_close_terminal = {
	_name = "battle_story_two_window_close",
	_init = function (terminal)

	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("BattleStoryTwoClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(battle_story_two_window_open_terminal)
state_machine.add(battle_story_two_window_close_terminal)
state_machine.init()

function BattleStoryTwo:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}



    self._action_num = 1


    local function init_battle_story_two_terminal()

        local battle_story_two_stop_actions_terminal = {
            _name = "battle_story_two_stop_actions",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:stopChatActions()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(battle_story_two_stop_actions_terminal)
        state_machine.init()
    end

    init_battle_story_two_terminal()

end


function BattleStoryTwo:playNextAction()
    local root = self.roots[1]
    local action = self.actions[1]
    action:stop()
    self._action_num = self._action_num + 1
    local actionName = "chat_" .. self._action_num
    if action:IsAnimationInfoExists(actionName) == true then
        action:play(actionName, false)
    else
        state_machine.excute("battle_story_two_window_close", 0, "")
    end
end

function BattleStoryTwo:onUpdateDraw()
    local root = self.roots[1]
    local action = self.actions[1]
    action:play("chat_" .. self._action_num, false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "chat_" .. self._action_num .. "_over" then
            self:playNextAction()
        end
    end)
end


function BattleStoryTwo:stopChatActions()
    self:playNextAction()
end


function BattleStoryTwo:onInit()
    local csbItem = csb.createNode(config_csb.mission.missionex.battle_story_2)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.mission.missionex.battle_story_2)
    table.insert(self.actions, action)
    csbItem:runAction(action)


    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_story_x"), nil,
    {
        terminal_name = "battle_story_two_stop_actions",
        terminal_state = 0,
    }, nil, 0)
	self:onUpdateDraw()
end

function BattleStoryTwo:onEnterTransitionFinish()

end

function BattleStoryTwo:init()
	self:onInit()
    return self
end


function BattleStoryTwo:onExit()
    state_machine.remove("battle_story_two_stop_actions")
    executeNextEvent(nil, nil)
end