-- ----------------------------------------------------------------------------------------------------
-- 说明：一次探索一个任务
-------------------------------------------------------------------------------------------------------
ExplorationOpenBox = class("ExplorationOpenBoxClass", Window)

local exploration_open_box_window_open_terminal = {
    _name = "exploration_open_box_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("ExplorationOpenBoxClass") == nil then
            fwin:open(ExplorationOpenBox:new():init(params), fwin._view)
        end

        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local exploration_open_box_window_close_terminal = {
    _name = "exploration_open_box_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if  fwin:find("ExplorationOpenBoxClass") then
            fwin:close(fwin:find("ExplorationOpenBoxClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(exploration_open_box_window_open_terminal)
state_machine.add(exploration_open_box_window_close_terminal)
state_machine.init()

function ExplorationOpenBox:ctor()
    self.super:ctor()
    self.roots = {}
    
    local function init_exploration_open_box_terminal()
        local exploration_open_box_sure_terminal = {
            _name = "exploration_open_box_sure",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local max_num = dms.int(dms["play_config"], 104, play_config.param)
                local buyTimes = _ED.pokemonExplore.resultInfo.resultArray[self.eventInfo.index].buyTimes
                if buyTimes >= max_num then
                    TipDlg.drawTextDailog(tipStringInfo_file_island_tips[1])
                    return
                end
                state_machine.lock("exploration_open_box_sure", 0, "")
                local function callback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        local rewardInfo = getSceneReward(7) 
                        if rewardInfo ~= nil then
                            local function changeActionCallbackTwo( armatureBack )
                                if armatureBack then
                                    if armatureBack ~= nil then
                                        armatureBack:removeFromParent(true)
                                    end
                                    app.load("client.reward.DrawRareReward")
                                    local getRewardWnd = DrawRareReward:new()
                                    getRewardWnd:init(nil, rewardInfo)
                                    fwin:open(getRewardWnd, fwin._ui)
                                    instance:onUpdateDraw()
                                    state_machine.unlock("exploration_open_box_sure", 0, "")
                                else
                                    state_machine.unlock("exploration_open_box_sure", 0, "")
                                end
                            end

                            local Panel_dh = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_dh")
                            local jsonFile = "sprite/sprite_baoxiang.json"
                            local atlasFile = "sprite/sprite_baoxiang.atlas"
                            local animation2 = sp.spine(jsonFile, atlasFile, 1, 0, "box_open", true, nil)
                            animation2.animationNameList = {"box_open"}
                            sp.initArmature(animation2, false)
                            animation2._invoke = changeActionCallbackTwo
                            Panel_dh:addChild(animation2)
                            animation2:setPosition(-Panel_dh:getContentSize().width/2, -Panel_dh:getContentSize().height/2)
                            animation2:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
                            csb.animationChangeToAction(animation2, 0, 0, false)
                        else
                            state_machine.unlock("exploration_open_box_sure", 0, "")
                        end
                    else
                        state_machine.unlock("exploration_open_box_sure", 0, "")
                    end
                end
                local mapId = cc.UserDefault:getInstance():getStringForKey(getKey("exploration_map_id"), "1")
                local data = {}
                data[1] = {}
                data[1].resultIndex = instance.eventInfo.index
                data[1].openTimes = 1
                data[1].mapId = mapId
                local req = json.encode(data)
                protocol_command.pokemon_explore_reward_box_buy.param_list = req
                NetworkManager:register(protocol_command.pokemon_explore_reward_box_buy.code, nil, nil, nil, nil, callback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local exploration_open_box_cancel_terminal = {
            _name = "exploration_open_box_cancel",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function callback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("exploration_open_box_window_close", 0, "")
                    end
                end
                protocol_command.pokemon_explore_single_event_finish.param_list = json.encode({resultIndex = instance.eventInfo.index})
                NetworkManager:register(protocol_command.pokemon_explore_single_event_finish.code, nil, nil, nil, nil, callback, false, nil)
                -- state_machine.excute("exploration_open_box_window_close", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(exploration_open_box_cancel_terminal)
        state_machine.add(exploration_open_box_sure_terminal)
        state_machine.init()
    end
    
    init_exploration_open_box_terminal()
end

function ExplorationOpenBox:init(params)
    self.eventInfo = params
    return self
end

function ExplorationOpenBox:onUpdate(dt)

end

function ExplorationOpenBox:onUpdateDraw()
    local root = self.roots[1]
    -- self.initData()
    local Text_zuanshi_t = ccui.Helper:seekWidgetByName(root, "Text_zuanshi_t")
    local Text_zuanshi_n = ccui.Helper:seekWidgetByName(root, "Text_zuanshi_n")
    local Image_zs_icon = ccui.Helper:seekWidgetByName(root, "Image_zs_icon")
    local Text_zuanshi_time_n = ccui.Helper:seekWidgetByName(root, "Text_zuanshi_time_n")
    local max_num = dms.int(dms["play_config"], 119, play_config.param)
    local buyTimes = _ED.pokemonExplore.resultInfo.resultArray[self.eventInfo.index].buyTimes
    if buyTimes < max_num then
        local cost = zstring.split(dms.string(dms["play_config"], 120, play_config.param), ",")[buyTimes + 1]
        Text_zuanshi_n:setString(cost)
    end
    Text_zuanshi_t:setVisible(buyTimes < max_num)
    Text_zuanshi_n:setVisible(buyTimes < max_num)
    Image_zs_icon:setVisible(buyTimes < max_num)
    Text_zuanshi_time_n:setString((max_num - buyTimes) .. "/" .. max_num)
end

function ExplorationOpenBox:onEnterTransitionFinish()
    local csbNode = csb.createNode("campaign/exploration/exploration_box_open.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbNode)
    -- 开启
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_open"), nil, 
    {
        terminal_name = "exploration_open_box_sure", 
        isPressedActionEnabled = true
    },
    nil, 0)

     -- 关闭
     fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cancel"), nil, 
     {
         terminal_name = "exploration_open_box_cancel", 
         isPressedActionEnabled = true
     },
     nil, 0)

    self:onUpdateDraw()

    local rewardInfo = getSceneReward(74)
    if rewardInfo ~= nil then
        local function changeActionCallbackTwo( armatureBack )
            if armatureBack then
                if armatureBack ~= nil then
                    armatureBack:removeFromParent(true)
                end
                app.load("client.reward.DrawRareReward")
                local getRewardWnd = DrawRareReward:new()
                getRewardWnd:init(nil, rewardInfo)
                fwin:open(getRewardWnd, fwin._ui)
                state_machine.unlock("exploration_open_box_sure", 0, "")
            else
                state_machine.unlock("exploration_open_box_sure", 0, "")
            end
        end

        state_machine.lock("exploration_open_box_sure", 0, "")
        local Panel_dh = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_dh")
        local jsonFile = "sprite/sprite_baoxiang.json"
        local atlasFile = "sprite/sprite_baoxiang.atlas"
        local animation2 = sp.spine(jsonFile, atlasFile, 1, 0, "box_open", true, nil)
        animation2.animationNameList = {"box_open"}
        sp.initArmature(animation2, false)
        animation2._invoke = changeActionCallbackTwo
        Panel_dh:addChild(animation2)
        animation2:setPosition(-Panel_dh:getContentSize().width/2, -Panel_dh:getContentSize().height/2)
        animation2:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
        csb.animationChangeToAction(animation2, 0, 0, false)
    end
end

function ExplorationOpenBox:onExit()

end
