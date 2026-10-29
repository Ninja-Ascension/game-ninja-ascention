-- ----------------------------------------------------------------------------------------------------
-- 说明：大冒险猜拳事件
-------------------------------------------------------------------------------------------------------
AdventureGuessEvent = class("AdventureGuessEventClass", Window)

local adventure_guess_event_open_terminal = {
    _name = "adventure_guess_event_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("AdventureGuessEventClass") == nil then
            fwin:open(AdventureGuessEvent:new():init(params), fwin._dview)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local adventure_guess_event_close_terminal = {
    _name = "adventure_guess_event_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if  fwin:find("AdventureGuessEventClass") then
            fwin:close(fwin:find("AdventureGuessEventClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(adventure_guess_event_open_terminal)
state_machine.add(adventure_guess_event_close_terminal)
state_machine.init()

function AdventureGuessEvent:ctor()
    self.super:ctor()
    self.roots = {}
    app.load("client.activity.adventure.AdventureGuessEventResult")
    local function init_adventure_guess_event_terminal()
        --选择结果
        local adventure_guess_result_terminal = {
            _name = "adventure_guess_result",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local index = params._datas.index
                state_machine.excute("adventure_guess_event_result_open", 0, index)
                state_machine.excute("adventure_guess_event_close", 0, "")
                -- local function callBack(response)
                --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                --         local info = json.decode(_ED.active_activity[147].activity_params)


                --         state_machine.excute("adventure_guess_event_result_open", 0, info.ex)
                --         state_machine.excute("adventure_guess_event_close", 0, "")
                --         if info.ex.pw then
                --             app.load("client.reward.DrawRareReward")
                --             local getRewardWnd = DrawRareReward:new()
                --             getRewardWnd:init(7)
                --             fwin:open(getRewardWnd, fwin._ui)
                --         end
                --     end
                -- end
                -- protocol_command.monopoly_finger_game.param_list = ""..index
                -- NetworkManager:register(protocol_command.monopoly_finger_game.code, nil, nil, nil, _self, callBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(adventure_guess_result_terminal)
        state_machine.init()
    end
    init_adventure_guess_event_terminal()
end

function AdventureGuessEvent:init(params)
    return self
end

function AdventureGuessEvent:onUpdate(dt)
end

function AdventureGuessEvent:onUpdateDraw()
    local root = self.roots[1]
end


function AdventureGuessEvent:onEnterTransitionFinish()
    local csbNode = csb.createNode("activity/adventure/adv_finger_game_tips.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbNode)

     -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy_power_close"), nil, 
    {
        terminal_name = "adventure_guess_event_close", 
        isPressedActionEnabled = true
    },
    nil, 0)

    for i=1,3 do
       fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_finger_" .. i), nil, 
        {
            terminal_name = "adventure_guess_result", 
            isPressedActionEnabled = true,
            index = i
        },
        nil, 0)
    end

    self:onUpdateDraw()
end

function AdventureGuessEvent:onExit()

end
