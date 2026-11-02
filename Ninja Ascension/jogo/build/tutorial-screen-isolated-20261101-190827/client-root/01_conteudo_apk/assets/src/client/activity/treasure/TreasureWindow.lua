-- ----------------------------------------------------------------------------------------------------
-- 说明：秘宝活动
-------------------------------------------------------------------------------------------------------
TreasureWindow = class("TreasureWindowClass", Window)

local treasure_window_open_terminal = {
    _name = "treasure_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local function callback( response )
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if fwin:find("TreasureWindowClass") == nil then
                    fwin:open(TreasureWindow:new():init(params), fwin._view)
                end
            end
        end
        
        local req = {}
        req.actId = _ED.active_activity[148].activity_id
        req.actType = 148

        local reqStr = json.encode(req)
        protocol_command.activity_refresh.param_list = reqStr
        NetworkManager:register(protocol_command.activity_refresh.code, nil, nil, nil, cells, callback, false, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local treasure_window_close_terminal = {
    _name = "treasure_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if  fwin:find("TreasureWindowClass") then
            fwin:close(fwin:find("TreasureWindowClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(treasure_window_open_terminal)
state_machine.add(treasure_window_close_terminal)
state_machine.init()

function TreasureWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.lightList = {}

    self.isPlayOne = true
    self.isPlayTen = true
    self.allScore = 0

    self.lastBeginRound = 1

    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.activity.treasure.TreasureChatInfo")
    app.load("client.activity.treasure.TreasureRuleWindow")
    app.load("client.activity.treasure.TreasureShopWindow")

    local function treasure_window_terminal()
        --抽奖
        local treasure_get_reward_reward_terminal = {
            _name = "treasure_get_reward",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("treasure_get_reward", 0, "")
                local _type = params._datas._type
                local function callBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        instance.Image_treasure_xy:setVisible(true)
                        if _type == 0 then
                            instance:playOneRound()
                        else
                            instance:playTenRound()
                        end
                        instance:onUpdateDraw()
                        instance:drawRareRewards()
                    else
                        state_machine.unlock("treasure_get_reward", 0, "")
                    end

                end
                local req = json.encode({ type = _type})
                
                protocol_command.treasures_draw.param_list = req
                NetworkManager:register(protocol_command.treasures_draw.code, nil, nil, nil, instance, callBack, false, nil)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --奖励刷新
        local treasure_reward_refresh_terminal = {
            _name = "treasure_reward_refresh",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local _type = params._datas._type
                local function callBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        instance:onUpdateDraw()
                        instance:drawAllReward(true)
                    end
                end
                protocol_command.treasures_refresh.param_list = ""
                NetworkManager:register(protocol_command.treasures_refresh.code, nil, nil, nil, instance, callBack, false, nil)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --停止动作
        local treasure_reward_anim_stop_terminal = {
            _name = "treasure_reward_anim_stop",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:clearRound()
                app.load("client.reward.DrawRareReward")
                local getRewardWnd = DrawRareReward:new()
                getRewardWnd:init(7)
                fwin:open(getRewardWnd, fwin._ui)
                instance.isPlayOne = false
                instance.isPlayTen = false
                instance.Image_treasure_xy:setVisible(false)
                state_machine.unlock("treasure_get_reward", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(treasure_get_reward_reward_terminal)
        state_machine.add(treasure_reward_refresh_terminal)
        state_machine.add(treasure_reward_anim_stop_terminal)
        state_machine.init()
    end

    treasure_window_terminal()
end

function TreasureWindow:init()
    return self
end

function TreasureWindow:drawTime(_time)
    local timeString = ""
    local _dayTime = math.floor((_time / 1000) / 86400)
    local _hourTime = math.floor((_time / 1000) % 86400 / 3600)
    local _minutesTime = math.floor((_time / 1000) % 86400 % 3600 / 60)
    local _secondsTime = math.ceil((_time / 1000) % 60)
    if _dayTime > 0 then
        timeString = timeString .. _dayTime .._string_piece_info[231]
    end
    if _hourTime > 0 then
        if _hourTime < 10 then
            timeString = timeString .. "0".._hourTime ..":"
        else
            timeString = timeString .. _hourTime ..":"
        end
    end
    if _minutesTime > 0 then
        if _minutesTime < 10 then
            timeString = timeString .. "0".._minutesTime ..":"
        else
            timeString = timeString .. _minutesTime ..":"
        end
    end
    if _secondsTime > 0 then
        if _secondsTime < 10 then
            timeString = timeString .. "0".._secondsTime 
        else
            timeString = timeString .. _secondsTime 
        end
    end
    return timeString
end

function TreasureWindow:onUpdate(dt)
    local params = json.decode(_ED.active_activity[148].activity_params)
    local score = tonumber(params.score)
    if self.allScore ~= score then
        -- 当前积分
        self.allScore = score
        self.Text_integral_n:setString(self.allScore)
    end

    if self.Text_rare_time == nil then
        return
    end
    local activity = _ED.active_activity[148]
    local drawOverTime = dms.int(dms["activity_config"], 32, activity_config.param)
    local surplus_time = (activity.end_time - ((os.time() + _ED.time_add_or_sub))*1000 - drawOverTime*1000)
    self.Text_rare_time:setString(surplus_time < 0 and _string_piece_info[305] or self:drawTime(surplus_time))
    self:refrushRedTip(surplus_time)
end

function TreasureWindow:refrushRedTip(surplusTime)
    if surplusTime <= 0 and self.Image_red_1 and self.Image_red_1:isVisible() == true then 
        self.Image_red_1:setVisible(false)
    end
end

function TreasureWindow:onUpdateDraw()
    local root = self.roots[1]
    local params = json.decode(_ED.active_activity[148].activity_params)
    local maxRefreshFreeTimes = dms.int(dms["activity_config"], 30, activity_config.param)
    local needCost = zstring.split(dms.string(dms["activity_config"], 29, activity_config.param), ",")

    local Text_darw_one_gem_n = ccui.Helper:seekWidgetByName(root, "Text_darw_one_gem_n")
    local Text_darw_ten_gem_n = ccui.Helper:seekWidgetByName(root, "Text_darw_ten_gem_n")
    local Text_darw_one_integral = ccui.Helper:seekWidgetByName(root, "Text_darw_one_integral")
    local Text_darw_ten_integral = ccui.Helper:seekWidgetByName(root, "Text_darw_ten_integral")
    local Text_refresh_gem = ccui.Helper:seekWidgetByName(root, "Text_refresh_gem")
    local Image_gem = ccui.Helper:seekWidgetByName(root, "Image_gem")
    local Text_refresh_time_n = ccui.Helper:seekWidgetByName(root, "Text_refresh_time_n")
    local Text_refresh_free = ccui.Helper:seekWidgetByName(root, "Text_refresh_free")
    self.Text_integral_n = ccui.Helper:seekWidgetByName(root, "Text_integral_n")
    local Text_gem_n = ccui.Helper:seekWidgetByName(root, "Text_gem_n")
    local Text_darw_free_time_n = ccui.Helper:seekWidgetByName(root, "Text_darw_free_time_n")
    local Image_red = ccui.Helper:seekWidgetByName(root, "Image_red")
    self.Image_red_1 = ccui.Helper:seekWidgetByName(root, "Image_red_1")

    local Image_10 = ccui.Helper:seekWidgetByName(root, "Image_10")

    local Image_free_one = ccui.Helper:seekWidgetByName(root, "Image_free_one")
    local Image_darw_one_gem = ccui.Helper:seekWidgetByName(root, "Image_darw_one_gem")
    local Image_darw_ten_gem = ccui.Helper:seekWidgetByName(root, "Image_darw_ten_gem")
    local Image_darw_one_props = ccui.Helper:seekWidgetByName(root, "Image_darw_one_props")
    local Image_darw_ten_props = ccui.Helper:seekWidgetByName(root, "Image_darw_ten_props")

    local oneIntegral = dms.int(dms["activity_config"], 26, activity_config.param)
    local tenIntegral = dms.int(dms["activity_config"], 27, activity_config.param)

    --获得积分
    Text_darw_one_integral:setString(string.format(tipStringInfo_pokemon_treasure_tips[1], oneIntegral))
    Text_darw_ten_integral:setString(string.format(tipStringInfo_pokemon_treasure_tips[2], tenIntegral))

    -- 刷新
    if tonumber(params.freeRefreshTimes) > 0 then
        Image_gem:setVisible(false)
        Text_refresh_gem:setVisible(false)
        Text_refresh_time_n:setVisible(true)
        Text_refresh_free:setVisible(true)
        Text_refresh_time_n:setString(params.freeRefreshTimes .. "/" ..maxRefreshFreeTimes)
    else
        Image_gem:setVisible(true)
        Text_refresh_gem:setVisible(true)
        if tonumber(params.payRefreshTimes) < #needCost then
            Text_refresh_gem:setString(needCost[tonumber(params.payRefreshTimes) + 1])
        else
            Text_refresh_gem:setString(needCost[#needCost])
        end
        Text_refresh_time_n:setVisible(false)
        Text_refresh_free:setVisible(false)
    end

    --刷新红点
    Image_red:setVisible(false)
    self.Image_red_1:setVisible(tonumber(params.freeDrawTimes) > 0)

    -- 当前拥有的钻石
    if tonumber( _ED.user_info.user_gold)> 1000000 then
        Text_gem_n:setString(math.floor(tonumber( _ED.user_info.user_gold) / 1000) .. string_equiprety_name[40])
    else
        Text_gem_n:setString(_ED.user_info.user_gold)
    end

    -- 道具数量
    local id = dms.int(dms["activity_config"], 25, activity_config.param)
    local num = getPropAllCountByMouldId(id)

    -- 单次
    local maxFreeDraw = dms.int(dms["activity_config"], 24, activity_config.param)
    Text_darw_free_time_n:setString(params.freeDrawTimes .. "/" .. maxFreeDraw)
    if tonumber(params.freeDrawTimes) > 0 then
        Image_free_one:setVisible(true)
        Image_10:setVisible(false)
        Image_darw_one_gem:setVisible(false)
        Text_darw_one_gem_n:setVisible(false)
        Image_darw_one_props:setVisible(false)
        
    else
        Image_free_one:setVisible(false)
        Image_10:setVisible(true)
        Text_darw_one_gem_n:setVisible(true)
        
        if tonumber(num) > 0 then
            Image_darw_one_gem:setVisible(false)
            Image_darw_one_props:setVisible(true)
            Text_darw_one_gem_n:setString(num .. "/" .. 1)
        else
            Image_darw_one_gem:setVisible(true)
            Image_darw_one_props:setVisible(false)
            Text_darw_one_gem_n:setString(dms.int(dms["activity_config"], 28, activity_config.param))
        end
    end

    -- 十次
    if tonumber(num) >= 10 then
        Image_darw_ten_gem:setVisible(false)
        Image_darw_ten_props:setVisible(true)
        Text_darw_ten_gem_n:setString(num .. "/" .. 10)
    else
        Image_darw_ten_gem:setVisible(true)
        Image_darw_ten_props:setVisible(false)
        Text_darw_ten_gem_n:setString(dms.int(dms["activity_config"], 28, activity_config.param)*10)
    end

    -- Naruto: el refresco vuelve a verse (C2S 9090; coste activity_config 29, gratis 30)
    -- self:hideRefreshButton()
end

--绘制奖励
function TreasureWindow:drawAllReward(isRefresh)
    local params = json.decode(_ED.active_activity[148].activity_params)
    local rewards = {}
    table.merge(rewards, params.normalItemList)
    for i,v in ipairs(params.diamondItemList) do
        local indexs = {1, 6, 9, 14}
        local index = indexs[i]
        table.insert(rewards, index, v)
    end
    local root = self.roots[1]
    self.rewardsToIndex = {}
    if not isRefresh then
        self.lightList = {}
    end
    for i, id in ipairs(rewards) do
        local rewordId = params.actConfig.allReward[tonumber(id)]
        local isXiyou = table.containValue(params.diamondItemList, id)
        local reward = zstring.split(params.actConfig.detailRewards[rewordId .. ""], ",")
        local Panel_light_effect = ccui.Helper:seekWidgetByName(root, "Panel_light_effect_" .. i)
        local Panel_treasure_icon = ccui.Helper:seekWidgetByName(root, "Panel_treasure_icon_" .. i)
        Panel_treasure_icon:removeAllChildren(true)
        local rewardType = zstring.tonumber(reward[1])
        local cell = ResourcesIconCell:createCell()
        if 13 == rewardType then
            local table = {}
            if reward[4] ~= nil and tonumber(reward[4]) ~= -1 then
                table.shipStar = tonumber(reward[4])
            end
            cell:init(rewardType, tonumber(reward[3]), tonumber(reward[2]),nil,nil,true,true,1,table)
        else
            cell:init(rewardType, tonumber(reward[3]), tonumber(reward[2]),nil,nil,true,true,1)
        end
        Panel_treasure_icon:addChild(cell)
        if isXiyou then
            local jsonFile = "images/ui/effice/effect_xiyou/effect_xiyou.json"
            local atlasFile = "images/ui/effice/effect_xiyou/effect_xiyou.atlas"
            local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", false, nil)
            animation.animationNameList = {"animation"}
            sp.initArmature(animation, false)
            animation._invoke = changeActionCallbackOne
            animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
            animation:setPosition(cc.p(cell:getContentSize().width/2, cell:getContentSize().height/2))
            cell:addChild(animation)
        end

        if not isRefresh then
            local jsonFile = "images/ui/effice/effect_jlmba/effect_jlmba.json"
            local atlasFile = "images/ui/effice/effect_jlmba/effect_jlmba.atlas"
            local animation2 = sp.spine(jsonFile, atlasFile, 1, 0, "animation1", false, nil)
            animation2.animationNameList = {"animation1","animation2","animation3"}
            sp.initArmature(animation2, false)
            animation2._invoke = changeActionCallbackOne
            animation2:setPosition(cc.p(Panel_light_effect:getContentSize().width/2, Panel_light_effect:getContentSize().height/2))
            Panel_light_effect:addChild(animation2)
            animation2:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
            animation2:setVisible(false)
            Panel_light_effect.animation = animation2
            Panel_light_effect:setVisible(true)
        end
        Panel_light_effect.index = i
        self.rewardsToIndex[rewards[i]] = i
        table.insert(self.lightList, Panel_light_effect)
    end
end

--稀有物品
function TreasureWindow:drawRareRewards()
    local root = self.roots[1]
    local activity_Info = _ED.active_activity[148].activity_Info
    for i, info in ipairs(activity_Info) do
        local Panel_rare_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_rare_props_icon_" .. i)
        local Text_rare_num = ccui.Helper:seekWidgetByName(root, "Text_rare_num_" .. i)
        local Text_rare_name = ccui.Helper:seekWidgetByName(root, "Text_rare_name_" .. i)
        local reward = zstring.split(info.activityInfo_reward_select, ",") 
        local rewardType = zstring.tonumber(reward[1])
        local cell = ResourcesIconCell:createCell()
        local name = nil
        local quality = nil
        Panel_rare_props_icon:removeAllChildren(true)
        if 13 == rewardType then
            local table = {}
            if reward[4] ~= nil and tonumber(reward[4]) ~= -1 then
                table.shipStar = tonumber(reward[4])
            end
            cell:init(rewardType, tonumber(reward[3]), tonumber(reward[2]),nil,nil,true,true,1,table)
        else
            cell:init(rewardType, tonumber(reward[3]), tonumber(reward[2]),nil,nil,true,true,1)
        end
        Panel_rare_props_icon:addChild(cell)

        if tonumber(rewardType) == 6 then
            quality = dms.int(dms["prop_mould"], reward[2], prop_mould.prop_quality)+1
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
        elseif tonumber(rewardType) == 71 then
            local silkbag_name_id = dms.int(dms["ship_silk_bag_mould"], reward[2], ship_silk_bag_mould.silkbag_name)
            local silkbag_name_word = dms.element(dms["word_mould"], silkbag_name_id)
            name = silkbag_name_word[3]

            quality = dms.int(dms["ship_silk_bag_mould"], reward[2], ship_silk_bag_mould.quality_level) + 1
        end
        -- Text_rare_name:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
        Text_rare_name:setString(name)

        Text_rare_num:setString(info.activityInfo_need_day)
    end
end

function TreasureWindow:playOneRound()
    local activity_params = json.decode(_ED.active_activity[148].activity_params)
    self:clearRound()
    local round = 2
    local rewardIndex = self.rewardsToIndex[activity_params.ex.hitItemList[1]]
    local num = table.nums(self.lightList)*round + rewardIndex
    local allTime = 0
    local function changeActionCallbackZore( anim0 )
        for i=self.lastBeginRound,num do
            local index = i%table.nums(self.lightList) == 0 and table.nums(self.lightList) or i%table.nums(self.lightList)
            local curNode = self.lightList[index]
            local time = 0
            if (i > self.lastBeginRound and i <= self.lastBeginRound + 4) or i >= num - 4 then
                time = 0.2
            else
                time = 0.05
            end
            allTime = allTime + time
            curNode:runAction(cc.Sequence:create(cc.DelayTime:create(allTime), 
            cc.CallFunc:create(function ()
                    curNode.animation:setVisible(true)
                    if i == num then
                        --播放中奖动画
                        self.lastBeginRound = rewardIndex

                        local function tempActionCallback( anim_temp )
                            if anim_temp then
                                anim_temp._invoke = nil
                                anim_temp:removeFromParent(true)
                            end
                        end
                        local jsonFile = "images/ui/effice/effect_jlmbb/effect_jlmbb.json"
                        local atlasFile = "images/ui/effice/effect_jlmbb/effect_jlmbb.atlas"
                        local animation3 = sp.spine(jsonFile, atlasFile, 1, 0, "animation", false, nil)
                        animation3.animationNameList = {"animation"}
                        sp.initArmature(animation3, false)
                        animation3._invoke = tempActionCallback
                        animation3:setPosition(cc.p(curNode:getContentSize().width/2, curNode:getContentSize().height/2))
                        curNode:addChild(animation3)
                        animation3:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
                        csb.animationChangeToAction(curNode.animation, 0, 0, false)

                        local function changeActionCallbackTwo( anim1 )
                            if self.isPlayOne then
                                app.load("client.reward.DrawRareReward")
                                local getRewardWnd = DrawRareReward:new()
                                getRewardWnd:init(7)
                                fwin:open(getRewardWnd, fwin._ui)
                                self.isPlayOne = false
                                self:clearRound()
                                self.Image_treasure_xy:setVisible(false)
                                state_machine.unlock("treasure_get_reward", 0, "")
                            end
                            anim1._invoke = nil
                        end
                        self.isPlayOne = true
                        curNode.animation._invoke = changeActionCallbackTwo
                        curNode.animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
                        csb.animationChangeToAction(curNode.animation, 2, 2, false)
                    else
                        local function changeActionCallbackOne( anima )
                            if anima then
                                -- local index = curNode.index - 1 == 0 and 16 or curNode.index - 1
                                -- local lastNode = self.lightList[index]
                                -- if lastNode then
                                    
                                -- end
                                anima:setVisible(false) 
                                anima._invoke = nil
                            end
                        end
                        curNode.animation._invoke = changeActionCallbackOne
                        curNode.animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
                        csb.animationChangeToAction(curNode.animation, 1, 1, false)
                    end
                end
            )))
        end 
        anim0._invoke = nil
    end
    
    self.lightList[self.lastBeginRound].animation:setVisible(true)
    self.lightList[self.lastBeginRound].animation._invoke = changeActionCallbackZore
    self.lightList[self.lastBeginRound].animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    csb.animationChangeToAction(self.lightList[self.lastBeginRound].animation, 0, 0, false)
end

function TreasureWindow:playTenRound()
    local activity_params = json.decode(_ED.active_activity[148].activity_params)
    self:clearRound()
    local ids = {}
    for i,v in ipairs(activity_params.ex.hitItemList) do
        table.insert(ids, self.rewardsToIndex[v])
    end
    local playIds = {}
    local allRoundIds = {}
    local count = 1
    allRoundIds[count] = {}
    for i,v in ipairs(ids) do
        if table.containValue(allRoundIds[count], v) then
            table.sort(allRoundIds[count], function ( a, b )
                return a < b
            end)
            count = count +1
            allRoundIds[count] = {}
        end      
        table.insert(allRoundIds[count], v)
    end
    table.insert(allRoundIds, 1, {})
    self.allRoundIds = allRoundIds

    local function changeActionCallbackZore( anim0 )
        self:playRound(1, self.lastBeginRound)
        self.lastBeginRound = ids[#ids]
        anim0._invoke = nil
        anim0:setVisible(false)
    end
    self.lightList[self.lastBeginRound].animation:setVisible(true)
    self.lightList[self.lastBeginRound].animation._invoke = changeActionCallbackZore
    self.lightList[self.lastBeginRound].animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    csb.animationChangeToAction(self.lightList[self.lastBeginRound].animation, 0, 0, false)
    
end

function TreasureWindow:playRound( round, index)
    local curNode = self.lightList[index]
    local time = 0.01

    local curRound = self.allRoundIds[round]
    if table.containValue(curRound, index) then
        time = 1
        -- csb.animationChangeToAction(curNode.animation, 2, 2, false)
    end
    self.isPlayTen = true
    curNode.animation:setVisible(true)
    
    if table.containValue(curRound, index) then
        local function tempActionCallback1( anima_temp )
            if anima_temp then
                anima_temp._invoke = nil
                anima_temp:removeFromParent(true)
            end
        end
        
        local jsonFile = "images/ui/effice/effect_jlmbb/effect_jlmbb.json"
        local atlasFile = "images/ui/effice/effect_jlmbb/effect_jlmbb.atlas"
        local animation4 = sp.spine(jsonFile, atlasFile, 1, 0, "animation", false, nil)
        animation4.animationNameList = {"animation"}
        sp.initArmature(animation4, false)
        animation4._invoke = tempActionCallback1
        animation4:setPosition(cc.p(curNode:getContentSize().width/2, curNode:getContentSize().height/2))
        curNode:addChild(animation4)
        animation4:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
        csb.animationChangeToAction(curNode.animation, 0, 0, false)

        local function changeActionCallbackTwo( anim1 )
            if round == #self.allRoundIds and index == curRound[#curRound] then
                app.load("client.reward.DrawRareReward")
                local getRewardWnd = DrawRareReward:new()
                getRewardWnd:init(7)
                fwin:open(getRewardWnd, fwin._ui)
                self:clearRound()
                self.Image_treasure_xy:setVisible(false)
                state_machine.unlock("treasure_get_reward", 0, "")
            end
            anim1._invoke = nil
            anim1:setVisible(false)
        end

        curNode.animation._invoke = changeActionCallbackTwo
        curNode.animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
        csb.animationChangeToAction(curNode.animation, 2, 2, false)
    else
        local function changeActionCallbackOne( anima )
            anima._invoke = nil
            anima:setVisible(false)
        end
        curNode.animation._invoke = changeActionCallbackOne
        curNode.animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
        csb.animationChangeToAction(curNode.animation, 1, 1, false)
    end

    if round == #self.allRoundIds and index == curRound[#curRound] then
    else
        curNode:runAction(cc.Sequence:create(cc.DelayTime:create(time), 
            cc.CallFunc:create(function ()
                    
                    index = index + 1
                    local curIndex = index%16
                    curIndex = curIndex == 0 and 16 or curIndex

                    if index <= 16 then
                        self:playRound(round, curIndex)
                    else
                        round = round + 1
                        if round <= #self.allRoundIds then
                            self:playRound(round, 1)
                        else

                        end
                    end
                end
            )))
    end
end

function TreasureWindow:clearRound()
    for i, item in ipairs(self.lightList) do
        item.animation:setVisible(false)
        item.animation._invoke = nil
        item:stopAllActions()
    end
end

function TreasureWindow:stateUpdate()
    local Button_receive = ccui.Helper:seekWidgetByName(self.roots[1], "Button_receive")
     if self.state == 1 then
        Button_receive:setTouchEnabled(true)
        Button_receive:setBright(true)
    else
        Button_receive:setTouchEnabled(false)
        Button_receive:setBright(false)
    end
end

function TreasureWindow:drawTips()
    local root = self.roots[1]
    local Text_chat_infor = ccui.Helper:seekWidgetByName(root, "Text_tip_p")
    local params = dms.searchs(dms["activity_participation_restrictions"], 2, 148)
    local day = (tonumber(_ED.system_time) - tonumber(_ED.open_server_time)/1000 + (os.time()-tonumber(_ED.native_time)))/86400
    
    local vip = 0
    local fight = 0
    for i,v in ipairs(params) do
        if tonumber(v[3]) <= day and tonumber(v[4]) >= day then
            vip = tonumber(v[5])
            fight = tonumber(v[6])
            break
        end
    end

    local max_width = 0
    Text_chat_infor:setString("")
    Text_chat_infor:removeAllChildren(true)
    local char_str = tipStringInfo_pokemon_treasure_tips[8]
    char_str = string.gsub(char_str, "!x@", vip)
    char_str = string.gsub(char_str, "!y@", fight)
    local _richText2 = ccui.RichText:create()
    _richText2:ignoreContentAdaptWithSize(false)

    local richTextWidth = Text_chat_infor:getContentSize().width
    if richTextWidth and richTextWidth == 0 then
        richTextWidth = Text_chat_infor:getFontSize() * 50
    end

    _richText2:setContentSize(cc.size(richTextWidth, 0))
    _richText2:setAnchorPoint(cc.p(0, 0))
    local fontsName = Text_chat_infor:getFontName()

    if __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 then
        color_Type_1 = cc.c3b(255, 255, 255)
        color_Type_2 = cc.c3b(255, 255, 255)
    else
        color_Type_1 = cc.c3b(71, 71, 71)
        color_Type_2 = cc.c3b(71, 71, 71)
    end
    local rt, count, text = draw.richTextCollectionMethod(_richText2, 
    char_str, 
    color_Type_1,
    color_Type_2,
    0, 
    0, 
    fontsName, 
    Text_chat_infor:getFontSize(),
    chat_rich_text_color)

    _richText2:formatTextExt()
    local rsize = _richText2:getContentSize()
    _richText2:setPositionX(_richText2:getContentSize().width/2 )
    _richText2:setPositionY(Text_chat_infor:getContentSize().height / 2 + Text_chat_infor:getFontSize() - 10)
    Text_chat_infor:addChild(_richText2)

    Text_chat_infor:setVisible((vip ~= 0 or fight ~= 0))
end

function TreasureWindow:onEnterTransitionFinish()
    local csbNode = csb.createNode("activity/wonderful/rare_treasure.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

     -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_adventure_back"), nil, 
    {
        terminal_name = "treasure_window_close", 
        isPressedActionEnabled = true
    },
    nil, 0)

    -- 抽一次
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_darw_one"), nil, 
    {
        terminal_name = "treasure_get_reward",
        _type = 0, 
        isPressedActionEnabled = true
    },
    nil, 0)

    -- 抽十次
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_darw_ten"), nil, 
    {
        terminal_name = "treasure_get_reward", 
        _type = 1,
        isPressedActionEnabled = true
    },
    nil, 0)

    -- 刷新奖品
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_refresh_reward"), nil, 
    {
        terminal_name = "treasure_refresh_reward", 
        isPressedActionEnabled = true
    },
    nil, 0)

    -- 规则
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rare_treasure_shop_0"), nil, 
    {
        terminal_name = "treasure_rule_window_open",
        isPressedActionEnabled = true
    },
    nil, 0)

    -- 商店
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rare_treasure_shop"), nil, 
    {
        terminal_name = "treasure_shop_window_open",
        isPressedActionEnabled = true
    },
    nil, 0)

    -- 刷新
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_refresh_reward"), nil, 
    {
        terminal_name = "treasure_reward_refresh",
        isPressedActionEnabled = true
    },
    nil, 0)

    -- 停止动画
    self.Image_treasure_xy = ccui.Helper:seekWidgetByName(root, "Image_treasure_xy")
    self.Image_treasure_xy:setVisible(false)
    self.Image_treasure_xy:setTouchEnabled(true)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_treasure_xy"), nil, 
    {
        terminal_name = "treasure_reward_anim_stop",
        isPressedActionEnabled = true
    },
    nil, 0)

    self.Text_rare_time = ccui.Helper:seekWidgetByName(root, "Text_rare_time")

    local Panel_get_infor_show = ccui.Helper:seekWidgetByName(root, "Panel_get_infor_show")
    local TreasureChatInfo = TreasureChatInfo:new():init()
    Panel_get_infor_show:addChild(TreasureChatInfo)
    Panel_get_infor_show:setVisible(true)



    self:onUpdateDraw()
    self:drawAllReward(false)
    self:drawRareRewards()
    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 then
        self:drawTips()
    end
end

-- DSC屏蔽刷新按钮和次数显示
function TreasureWindow:hideRefreshButton()
    local root = self.roots[1]
    ccui.Helper:seekWidgetByName(root, "Button_refresh_reward"):setVisible(false)
    ccui.Helper:seekWidgetByName(root, "Text_refresh_free"):setVisible(false)
    ccui.Helper:seekWidgetByName(root, "Text_refresh_time_n"):setVisible(false)        
end

function TreasureWindow:onExit()

end
