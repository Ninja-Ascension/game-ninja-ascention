-- ----------------------------------------------------------------------------------------------------
-- 说明：探索积分
-------------------------------------------------------------------------------------------------------
ExplorationAllFinishCatchWindow = class("ExplorationAllFinishCatchWindowClass", Window)

local exploration_all_finish_catch_window_open_terminal = {
    _name = "exploration_all_finish_catch_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("ExplorationAllFinishCatchWindowClass") == nil then
            fwin:open(ExplorationAllFinishCatchWindow:new():init(params), fwin._view)
        end

        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local exploration_all_finish_catch_window_close_terminal = {
    _name = "exploration_all_finish_catch_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if  fwin:find("ExplorationAllFinishCatchWindowClass") then
            fwin:close(fwin:find("ExplorationAllFinishCatchWindowClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(exploration_all_finish_catch_window_open_terminal)
state_machine.add(exploration_all_finish_catch_window_close_terminal)
state_machine.init()

function ExplorationAllFinishCatchWindow:ctor()
    self.super:ctor()
    self.roots = {}
    app.load("client.l_digital.campaign.exploration.ExplorationAllFinishCatchReward")
    app.load("client.l_digital.campaign.exploration.ExplorationAllFinishCatchBegin")

    self.is_over = false
    self.isPlay = false
    local width = dms.int(dms["role_high"], 1, 6)
    self.distance = 100 + width - 60 --每个数码兽之间的距离
    
    local function init_exploration_all_finish_catch_window_terminal()
        local exploration_all_finish_catch_window_update_close_terminal = {
            _name = "exploration_all_finish_catch_window_update_close",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                function showConfirmTip(instance,n)
                    if n == 0 then
                        instance:exitCatch()
                    end
                end

                app.load("client.utils.ConfirmTip")
                local tip = ConfirmTip:new()
                tip:init(instance, showConfirmTip, tipStringInfo_exploration_tips[7])
                fwin:open(tip, fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local exploration_all_finish_catch_time_end_terminal = {
            _name = "exploration_all_finish_catch_time_end",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:exitCatch()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local exploration_all_finish_catch_player_click_terminal = {
            _name = "exploration_all_finish_catch_player_click",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params._datas.index
                local id = params._datas.id
                if tonumber(instance.infos.ballCount) <= 0 or instance.surplus_time <= 0 or self.isPlay then
                    return
                end

                local function callback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        local Panel_catch = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_catch")
                        local parent = Panel_catch:getChildByName("player" .. index)
                        local pos = cc.p(parent:getContentSize().width/2, parent:getContentSize().height/2)
                        local shipSpine = parent:getChildByName("shipSpine")

                        local infos =  _ED.pokemonExplore.resultInfo.resultArray[instance.infos.index]
                        instance.infos = infos
                        local success = (instance.infos.curReward and instance.infos.curReward ~= "") and 0 or 1
                        if success == 0 then
                            csb.animationChangeToAction(shipSpine, _enum_animation_frame_index.animation_standby, _enum_animation_frame_index.animation_stand, false)
                            parent:stopAllActions()
                        else

                        end
                        instance:playCatchAnimation(parent, pos, success, success == 0)
                        instance:updateTextDraw()
                    end
                end
                local req = json.encode({resultIndex = instance.infos.index, hitId = id, type = 1})
                protocol_command.pokemon_explore_map_catch_hit.param_list = req
                NetworkManager:register(protocol_command.pokemon_explore_map_catch_hit.code, nil, nil, nil, nil, callback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(exploration_all_finish_catch_window_update_close_terminal)
        state_machine.add(exploration_all_finish_catch_player_click_terminal)
        state_machine.add(exploration_all_finish_catch_time_end_terminal)
        state_machine.init()
    end
    
    init_exploration_all_finish_catch_window_terminal()
end

function ExplorationAllFinishCatchWindow:init(params)
    self.index = params
    return self
end

function ExplorationAllFinishCatchWindow:onUpdate(dt)
    if not self.Text_catch_time or not self.infos then
        return
    end

    self.surplus_time = (self.infos.endTime - (os.time() + _ED.time_add_or_sub))
    if self.surplus_time > 0 then
        self.Text_catch_time:setString(math.floor(self.surplus_time) .. "s")
    else
        if not self.is_over then
            self.Panel_catch_end:setVisible(true)
            self.is_over = true
        end
    end
end

function ExplorationAllFinishCatchWindow:exitCatch()
    local function callback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            local infos =  _ED.pokemonExplore.resultInfo.resultArray[self.infos.index]
            self.infos = infos
            
            if self.infos.showRewards and self.infos.showRewards ~= "" then
                state_machine.excute("exploration_all_finish_catch_reward_window_open", 0, "")
            end
            state_machine.excute("exploration_all_finish_catch_begin_update", 0, "")
            state_machine.excute("exploration_all_finish_catch_window_close", 0, "")
        end
    end

    local req = json.encode({resultIndex = self.infos.index})
    protocol_command.pokemon_explore_map_catch_over.param_list = req
    NetworkManager:register(protocol_command.pokemon_explore_map_catch_over.code, nil, nil, nil, nil, callback, false, nil)
end

function ExplorationAllFinishCatchWindow:updateTextDraw()
    local root = self.roots[1]
    local Text_explore_catch_n = ccui.Helper:seekWidgetByName(root, "Text_explore_catch_n")
    local Image_catch_get_tip = ccui.Helper:seekWidgetByName(root, "Image_catch_get_tip")
    local Text_catch_get_tip = ccui.Helper:seekWidgetByName(root, "Text_catch_get_tip")
    local Image_catch_card_tip = ccui.Helper:seekWidgetByName(root, "Image_catch_card_tip")
    local Text_catch_card_tip = ccui.Helper:seekWidgetByName(root, "Text_catch_card_tip")
    Image_catch_get_tip:stopAllActions()
    Image_catch_card_tip:stopAllActions()

    if tonumber(self.infos.ballCount) <= 0 then
        self.Panel_catch_end:setVisible(true)
    end

    Image_catch_get_tip:setVisible(false)
    Image_catch_card_tip:setVisible(false)
    if self.infos.curReward and self.infos.curReward ~= "" then
        local name = ""
        local quality = 0
        local reward = zstring.split(self.infos.curReward, ",")
        local rewardType = zstring.tonumber(reward[1])
        if tonumber(rewardType) == 6 then
            quality = dms.int(dms["prop_mould"], reward[2], prop_mould.prop_quality)
            name = setThePropsIcon(tonumber(reward[2]))[2]
        elseif tonumber(rewardType) == 7 then
            quality = dms.int(dms["equipment_mould"], reward[2], equipment_mould.grow_level)+1
            local nameindex = dms.int(dms["equipment_mould"], reward[2], equipment_mould.equipment_name)
            --通过索引找到word_mould
            local word_info = dms.element(dms["word_mould"], nameindex)
            name = word_info[3]
        elseif tonumber(rewardType) == 13 then
            quality = dms.int(dms["ship_mould"], reward[2], ship_mould.ship_type)+1
            local evo_image = dms.string(dms["ship_mould"], reward[2], ship_mould.fitSkillTwo)
            local evo_info = zstring.split(evo_image, ",")
            --进化模板id
            -- local ship_evo = zstring.split(hero.evolution_status, "|")
            local evo_mould_id = evo_info[dms.int(dms["ship_mould"], reward[2], ship_mould.captain_name)]
            local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
            local word_info = dms.element(dms["word_mould"], name_mould_id)
            name = word_info[3]
        end

        
        local img = Image_catch_get_tip
        if tonumber(rewardType) == 13 then
            Text_catch_card_tip:setString(string.format(tipStringInfo_exploration_tips[8], tonumber(reward[4]), name))
            Image_catch_card_tip:setVisible(true)
            img = Image_catch_card_tip

        else
            Text_catch_get_tip:setString(string.format(tipStringInfo_exploration_tips[4], name, tonumber(reward[3])))
            Image_catch_get_tip:setVisible(true)
            img = Image_catch_get_tip
        end

        img:runAction(cc.Sequence:create(cc.DelayTime:create(2), 
            cc.CallFunc:create(function ()
                    Image_catch_get_tip:setVisible(false)
                end
            )))


        local rewards = zstring.splits(self.infos.totalRewards, "|", ",")
        self.ListView_catch_card:removeAllItems()
        for i, reward in ipairs(rewards) do
            local rewardType = zstring.tonumber(reward[1])
            local cell = ResourcesIconCell:createCell()
            if 13 == rewardType then
                local table = {}
                if reward[4] ~= nil and tonumber(reward[4]) ~= -1 then
                    table.shipStar = tonumber(reward[4])
                end
                cell:init(rewardType, tonumber(reward[3]), tonumber(reward[2]),nil,nil,true,true,1,table)
                self.ListView_catch_card:addChild(cell)
            end
        end

        self.ListView_catch_card:requestRefreshView()
    end

    Text_explore_catch_n:setString("×" .. self.infos.ballCount)
end

function ExplorationAllFinishCatchWindow:onUpdateDraw()
    local root = self.roots[1]
    local Panel_catch_position_in = ccui.Helper:seekWidgetByName(root, "Panel_catch_position_in")
    local Panel_catch_position_out = ccui.Helper:seekWidgetByName(root, "Panel_catch_position_out")
    local beginPos = cc.p(Panel_catch_position_in:getPosition())
    local endPos = cc.p(Panel_catch_position_out:getPosition())
    local allTime = dms.int(dms["play_config"], 139, play_config.param)
    local width = dms.int(dms["role_high"], 1, 6)
    local nums = table.nums(self.infos.shipArr)

    self.ListView_catch_card = ccui.Helper:seekWidgetByName(root, "ListView_catch_card")
    self.ListView_catch_card:removeAllItems()

    local len = self.distance*(nums-1)+ (beginPos.x - endPos.x)
    self.speed = len/allTime

    self.Text_catch_time = ccui.Helper:seekWidgetByName(root, "Text_catch_time")

    local Panel_catch_click_x = ccui.Helper:seekWidgetByName(root, "Panel_catch_click_x")
    Panel_catch_click_x:removeAllChildren(true)

    local function clickLayerTouchEvent(sender, evenType)
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()

        if ccui.TouchEventType.ended == evenType or
            ccui.TouchEventType.canceled == evenType then
            local parent = sender
            local pos = sender:convertToNodeSpace(cc.p(__epoint.x, __epoint.y))
            if tonumber(self.infos.ballCount) <= 0 or self.surplus_time <= 0 or self.isPlay then
                return
            end

            local function callback( response )
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    local infos =  _ED.pokemonExplore.resultInfo.resultArray[self.infos.index]
                    self.infos = infos
                    local success = 2
                    self:playCatchAnimation(parent, pos, success)
                    self:updateTextDraw()
                end
            end

            local req = json.encode({resultIndex = self.infos.index, hitId = -1, type = 0})
            protocol_command.pokemon_explore_map_catch_hit.param_list = req
            NetworkManager:register(protocol_command.pokemon_explore_map_catch_hit.code, nil, nil, nil, nil, callback, false, nil)
        end
    end

    Panel_catch_click_x:addTouchEventListener(clickLayerTouchEvent)

    local index = 0
    for i, shipId in ipairs(self.infos.shipArr) do
        root:runAction(cc.Sequence:create(cc.DelayTime:create(self.distance/self.speed *(i - 1)), 
        cc.CallFunc:create(function ()
                index = index + 1
                self:playersMove(shipId, index)
            end
        )))
    end
end

function ExplorationAllFinishCatchWindow:playersMove(id, index)
    local root = self.roots[1]
    local Panel_catch_position_in = ccui.Helper:seekWidgetByName(root, "Panel_catch_position_in")
    local Panel_catch_position_out = ccui.Helper:seekWidgetByName(root, "Panel_catch_position_out")
    local Panel_catch = ccui.Helper:seekWidgetByName(root, "Panel_catch")
    local beginPos = cc.p(Panel_catch_position_in:getPosition())
    local endPos = cc.p(Panel_catch_position_out:getPosition())

    local width = dms.int(dms["role_high"], id, 6)
    local height = dms.int(dms["role_high"], id, 5)
    local playerPanel = ccui.Layout:create()
    playerPanel:setTouchEnabled(true)
    playerPanel:setSwallowTouches(true)
    playerPanel:setAnchorPoint(cc.p(0.5, 0))
    playerPanel:setContentSize(cc.size(width, height))
    playerPanel:setPosition(cc.p(beginPos.x + width/2, beginPos.y))
    playerPanel.id = id
    playerPanel:setName("player" .. index)
    Panel_catch:addChild(playerPanel)

    --进化形象
    local mould_id = dms.int(dms["role_explore_catch"], id, 3)
    local evo_image = dms.string(dms["ship_mould"], mould_id, ship_mould.fitSkillTwo)
    local initial_ship = dms.string(dms["ship_mould"], mould_id, ship_mould.captain_name)
    local evo_info = zstring.split(evo_image, ",")
    -- --进化模板id
    local evo_mould_id = evo_info[zstring.tonumber(initial_ship)]
    if getShipByTemplateId(mould_id) then
        evo_mould_id = smGetSkinEvoIdChange(getShipByTemplateId(mould_id))
    end
    --新的形象编号
    temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
    app.load("client.battle.fight.FightEnum")
    local shipSpine = sp.spine_sprite(playerPanel, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_move + 1], true, nil, nil, cc.p(0.5, 0))
    shipSpine:setName("shipSpine")

    shipSpine.animationNameList = {spineAnimations[_enum_animation_frame_index.animation_standby + 1],spineAnimations[_enum_animation_frame_index.animation_move + 1]}
    sp.initArmature(shipSpine, false)
    playerPanel:runAction(cc.Sequence:create(cc.MoveTo:create((beginPos.x - endPos.x)/self.speed, cc.p(endPos.x - width/2, endPos.y)), 
        cc.CallFunc:create(function () 
            playerPanel:removeFromParent(true)
        end
    )))

    fwin:addTouchEventListener(playerPanel, nil, 
    {
        terminal_name = "exploration_all_finish_catch_player_click", 
        isPressedActionEnabled = true,
        index = index,
        id = id
    },
    nil, 0)
end

--success 0:砸中 抓捕成功 1:砸中 抓捕失败 2:未砸中 抓捕失败
function ExplorationAllFinishCatchWindow:playCatchAnimation(parent, pos, success, isRemove)
    self.isPlay = true
    local function changeActionCallbackOne( armature )
        if armature then
            armature:removeFromParent(true)
            if isRemove then
                parent:removeFromParent(true)
            end

            self.isPlay = false
        end
    end

    local jsonFile = "images/ui/effice/effect_catch/effect_catch.json"
    local atlasFile = "images/ui/effice/effect_catch/effect_catch.atlas"
    local animation2 = sp.spine(jsonFile, atlasFile, 1, 0, "animation1", true, nil)
    animation2.animationNameList = {"animation1","animation2","animation3"}
    sp.initArmature(animation2, false)
    animation2._invoke = changeActionCallbackOne
    animation2:setPosition(pos)
    parent:addChild(animation2)
    animation2:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    if success == 0 then
        csb.animationChangeToAction(animation2, 0, 0, false)
    elseif success == 1 then
        csb.animationChangeToAction(animation2, 1, 1, false)
    elseif success == 2 then
        csb.animationChangeToAction(animation2, 2, 2, false)
    end

    animation2:setFrameEventCallFunc(function (bone,evt,originFrameIndex,currentFrameIndex)
        if nil == evt then
            return
        end

        if evt == "key" then
            print("1111111111111111111")
        end
        
    end)
end

function ExplorationAllFinishCatchWindow:onEnterTransitionFinish()
    local csbNode = csb.createNode("campaign/exploration/exploration_catch.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbNode)

    local Panel_catch_time = ccui.Helper:seekWidgetByName(root, "Panel_catch_time")
    self.Panel_catch_end = ccui.Helper:seekWidgetByName(root, "Panel_catch_end")
    Panel_catch_time:setVisible(true)
    self.Panel_catch_end:setVisible(false)

    local action = csb.createTimeline("campaign/exploration/exploration_catch.csb")
    csbNode:runAction(action)
    
    action:play("catch_time", false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "open" then
        elseif str == "catch_time_over" then
            local function callback( response )
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    local infos = _ED.pokemonExplore.resultInfo.resultArray[self.index]
                    self.infos = infos
                    Panel_catch_time:setVisible(false)
                    self:onUpdateDraw()
                    self:updateTextDraw()
                end
            end
            local curMapId = cc.UserDefault:getInstance():getStringForKey(getKey("exploration_map_id"), "1")
            local req = json.encode({mapId = curMapId, resultIndex = self.index})
            protocol_command.pokemon_explore_map_catch_enter.param_list = req
            NetworkManager:register(protocol_command.pokemon_explore_map_catch_enter.code, nil, nil, nil, nil, callback, false, nil)
        end
    end)

    self.endTime = dms.int(dms["play_config"], 139, play_config.param)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_phb_back"), nil, 
    {
        terminal_name = "exploration_all_finish_catch_window_update_close", 
        isPressedActionEnabled = true
    },
    nil, 0)

    -- 时间到退出
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_catch_end"), nil, 
    {
        terminal_name = "exploration_all_finish_catch_time_end", 
        isPressedActionEnabled = true
    },
    nil, 0)
end

function ExplorationAllFinishCatchWindow:onExit()

end
