-- ----------------------------------------------------------------------------------------------------
-- 说明：天降好礼
-------------------------------------------------------------------------------------------------------
SmEveryDayOnlineReward = class("SmEveryDayOnlineRewardClass", Window)
local sm_every_day_online_reward_open_terminal = {
    _name = "sm_every_day_online_reward_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _window = fwin:find("SmEveryDayOnlineRewardClass")
        if _window == nil then
            fwin:open(SmEveryDayOnlineReward:new(),fwin._ui)
            fwin:find("SmEveryDayOnlineRewardClass"):setVisible(false)
        end
    	return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_every_day_online_reward_open_terminal)
state_machine.init()
    
function SmEveryDayOnlineReward:ctor()
    self.super:ctor()
   	self.actions = {}
	self.roots = {}
	self.ArmatureNode_1 = nil
    app.load("client.reward.DrawRareReward")
    local function init_sm_every_day_online_reward_terminal()
        --确定
        local sm_every_day_online_reward_define_terminal = {
            _name = "sm_every_day_online_reward_define",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- params:setTouchEnabled(false)
                state_machine.lock("sm_every_day_online_reward_define")
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 and _ED.every_day_online_reward_double ~= 0 then
                        local getRewardWnd = DrawRareReward:new()
                        if zstring.tonumber(_ED.every_day_online_reward_double) == 2 then
                            getRewardWnd:showDoubleState()
                        end
                        getRewardWnd:init(1)
                        fwin:open(getRewardWnd, fwin._ui)
                        -- fwin:close(instance)
                        -- csb.animationChangeToAction(response.node.ArmatureNode_1, 1, 2, nil)
                    -- else
                        -- params:setTouchEnabled(true)
                    end
                    state_machine.unlock("sm_every_day_online_reward_define")
                    state_machine.excute("sm_every_day_online_reward_close" , 0,"")
                end
                protocol_command.trigger_scene_surprise.param_list = "1"
                NetworkManager:register(protocol_command.trigger_scene_surprise.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --关闭
        local sm_every_day_online_reward_close_terminal = {
            _name = "sm_every_day_online_reward_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(sm_every_day_online_reward_define_terminal)
        state_machine.add(sm_every_day_online_reward_close_terminal)
        state_machine.init()
    end
    
    init_sm_every_day_online_reward_terminal()
end

function SmEveryDayOnlineReward:onEnterTransitionFinish()
	local csbUserInfo = csb.createNode("activity/wonderful/sm_gift_of_heaven.csb")
	self:addChild(csbUserInfo)
	local root = csbUserInfo:getChildByName("root")
	table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"),nil, 
    {
        terminal_name = "sm_every_day_online_reward_close",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
    local Panel_box = ccui.Helper:seekWidgetByName(root, "Panel_box")
    -- fwin:addTouchEventListener(Panel_box ,nil, 
    -- {
    --     terminal_name = "sm_every_day_online_reward_define",     
    --     terminal_state = 0, 
    --     isPressedActionEnabled = true
    -- },
    -- nil, 0)
    -- self.ArmatureNode_1 = Panel_box:getChildByName("ArmatureNode_1")
    -- draw.initArmature(self.ArmatureNode_1, nil, -1, 0, 1)
    -- csb.animationChangeToAction(self.ArmatureNode_1, 0, 0, false)

    -- changeActionCallback = function ( armatureBack )
    --     local armature = armatureBack
    --     local actionIndex = armature._actionIndex
    --     if actionIndex == 2 then
    --         state_machine.excute("sm_every_day_online_reward_close" , 0,"")
    --     end
    -- end
    -- self.ArmatureNode_1._invoke = changeActionCallback

    -- self.ArmatureNode_1:getAnimation():setFrameEventCallFunc(function (bone,evt,originFrameIndex,currentFrameIndex)
    --     if evt == "reward" then
    --         local getRewardWnd = DrawRareReward:new()
    --         if zstring.tonumber(_ED.every_day_online_reward_double) == 2 then
    --             getRewardWnd:showDoubleState()
    --         end
    --         getRewardWnd:init(1)
    --         fwin:open(getRewardWnd, fwin._ui)
    --     end
    -- end)

end

function SmEveryDayOnlineReward:onExit()
    state_machine.remove("sm_every_day_online_reward_define")
    state_machine.remove("sm_every_day_online_reward_close")
end
