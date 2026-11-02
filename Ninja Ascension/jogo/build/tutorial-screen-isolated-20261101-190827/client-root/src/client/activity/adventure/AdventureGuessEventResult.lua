-- ----------------------------------------------------------------------------------------------------
-- 说明：大冒险扣除事件
-------------------------------------------------------------------------------------------------------
AdventureGuessEventResult = class("AdventureGuessEventResultClass", Window)

local adventure_guess_event_result_open_terminal = {
    _name = "adventure_guess_event_result_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("AdventureGuessEventResultClass") == nil then
            fwin:open(AdventureGuessEventResult:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}



state_machine.add(adventure_guess_event_result_open_terminal)
state_machine.init()

function AdventureGuessEventResult:ctor()
    self.super:ctor()
    self.roots = {}
    local function init_AdventureGuessEventResult_terminal() 
        local adventure_guess_event_result_close_terminal = {
            _name = "adventure_guess_event_result_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if  fwin:find("AdventureGuessEventResultClass") then
                    if self.win and self.win == 0 then
                        state_machine.excute("adventure_guess_event_open", 0, "")
                    end
                    fwin:close(fwin:find("AdventureGuessEventResultClass"))
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(adventure_guess_event_result_close_terminal)
        state_machine.init()
    end
    init_AdventureGuessEventResult_terminal()
end

function AdventureGuessEventResult:init(params)
    self.index = params
    return self
end

function AdventureGuessEventResult:onUpdate(dt)
end

function AdventureGuessEventResult:onUpdateDraw()
    local root = self.roots[1]
    local Panel_finger_effect_1 = ccui.Helper:seekWidgetByName(root, "Panel_finger_effect_1")
    -- Panel_finger_effect_1:setBackGroundImage(string.format("images/ui/text/sm_hd/act_great_adventure/finger_%d.png", self.my_choose))

    local Panel_finger_effect_2 = ccui.Helper:seekWidgetByName(root, "Panel_finger_effect_2")
    -- Panel_finger_effect_2:setBackGroundImage(string.format("images/ui/text/sm_hd/act_great_adventure/finger_%d.png", self.other_choose))

    local Panel_3 = ccui.Helper:seekWidgetByName(root, "Panel_3")
    -- local win_icon = self.win and "act_great_bai" or "act_great_sheng"
    -- Panel_3:setBackGroundImage(string.format("images/ui/text/sm_hd/act_great_adventure/%s.png", win_icon))
    Panel_3:removeBackGroundImage()

    local Image_finger_effect_bg = ccui.Helper:seekWidgetByName(root, "Image_finger_effect_bg")
    

    local function callBack(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            local info = json.decode(_ED.active_activity[147].activity_params)
            self.win = tonumber(info.ex.pw)
            local function changeActionCallbackOther( armatureBack )
                if armatureBack then
                    -- local function changeActionCallbackOther1( armatureBack1 )
                    --     if armatureBack1 then
                    --         Panel_finger_effect_2:setBackGroundImage(string.format("images/ui/text/sm_hd/act_great_adventure/finger_%d.png", tonumber(info.ex.ss)))
                    --         armatureBack1:removeFromParent(true)
                    --     end
                    -- end
                    armatureBack._invoke = changeActionCallbackOther1
                    armatureBack:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
                    csb.animationChangeToAction(armatureBack, tonumber(info.ex.ss), tonumber(info.ex.ss), false)
                end
            end

            local jsonFile = "images/ui/effice/effect_dmx_cq/effect_dmx_cq.json"
            local atlasFile = "images/ui/effice/effect_dmx_cq/effect_dmx_cq.atlas"
            local animation2 = sp.spine(jsonFile, atlasFile, 1, 0, "animation", false, nil)
            animation2.animationNameList = {"animation", "animation2", "animation3", "animation4"}
            sp.initArmature(animation2, false)
            animation2._invoke = changeActionCallbackOther
            Panel_finger_effect_2:addChild(animation2)
            animation2:setPosition(Panel_finger_effect_2:getContentSize().width/2, Panel_finger_effect_2:getContentSize().height/2)
            animation2:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
            csb.animationChangeToAction(animation2, 0, 0, false)

            local is_play = true
            local function changeActionCallbackMy( armatureBack )
                if armatureBack then
                    local function callBackAnim( armatureBack1 )
                        local win_icon = "act_great_bai"
                        if self.win == -1 then
                            win_icon = "act_great_bai"
                        elseif self.win == 0 then
                            win_icon = "act_great_ping"
                        elseif self.win == 1 then
                            win_icon = "act_great_sheng1"
                        end
                        Panel_3:setBackGroundImage(string.format("images/ui/text/sm_hd/act_great_adventure/%s.png", win_icon))
                        -- Panel_finger_effect_1:setBackGroundImage(string.format("images/ui/text/sm_hd/act_great_adventure/finger_%d.png", tonumber(info.ex.ps)))
                        if self.win == 1 and is_play then
                            self:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), 
                                cc.CallFunc:create(function ()
                                        app.load("client.reward.DrawRareReward")
                                        local getRewardWnd = DrawRareReward:new()
                                        getRewardWnd:init(7)
                                        fwin:open(getRewardWnd, fwin._ui)
                                        Image_finger_effect_bg:setTouchEnabled(true)

                                    end
                                )))
                            is_play = false
                        else
                            Image_finger_effect_bg:setTouchEnabled(true)
                        end
                    end
                    armatureBack._invoke = callBackAnim
                    armatureBack:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
                    csb.animationChangeToAction(armatureBack, tonumber(info.ex.ps), tonumber(info.ex.ps), false)
                end
            end

            local jsonFile = "images/ui/effice/effect_dmx_cq/effect_dmx_cq.json"
            local atlasFile = "images/ui/effice/effect_dmx_cq/effect_dmx_cq.atlas"
            local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", false, nil)
            animation.animationNameList = {"animation", "animation2", "animation3", "animation4"}
            sp.initArmature(animation, false)
            animation._invoke = changeActionCallbackMy
            animation:setScaleX(-1)
            Panel_finger_effect_1:addChild(animation)
            animation:setPosition(Panel_finger_effect_1:getContentSize().width/2, Panel_finger_effect_1:getContentSize().height/2)
            animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
            csb.animationChangeToAction(animation, 0, 0, false)
        end
    end
    protocol_command.monopoly_finger_game.param_list = ""..self.index
    NetworkManager:register(protocol_command.monopoly_finger_game.code, nil, nil, nil, self, callBack, false, nil)

end


function AdventureGuessEventResult:onEnterTransitionFinish()
    local csbNode = csb.createNode("activity/adventure/adv_finger_vs.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbNode)

     -- 关闭
    local Image_finger_effect_bg = ccui.Helper:seekWidgetByName(root, "Image_finger_effect_bg")
    Image_finger_effect_bg:setTouchEnabled(false)
    fwin:addTouchEventListener(Image_finger_effect_bg, nil, 
    {
        terminal_name = "adventure_guess_event_result_close", 
        isPressedActionEnabled = true
    },
    nil, 0)

    self:onUpdateDraw()
end

function AdventureGuessEventResult:onExit()

end
