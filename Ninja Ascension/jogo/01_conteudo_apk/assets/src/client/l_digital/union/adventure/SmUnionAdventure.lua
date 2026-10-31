-- ----------------------------------------------------------------------------------------------------
-- 说明：公会大冒险
-------------------------------------------------------------------------------------------------------
SmUnionAdventure = class("SmUnionAdventureClass", Window)

local sm_union_adventure_open_terminal = {
    _name = "sm_union_adventure_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionAdventureClass")
        if nil == _homeWindow then
            local panel = SmUnionAdventure:new():init(params)
            fwin:open(panel,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_union_adventure_close_terminal = {
    _name = "sm_union_adventure_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        _ED.adventure_draw_union = nil
		local _homeWindow = fwin:find("SmUnionAdventureClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmUnionAdventureClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_union_adventure_open_terminal)
state_machine.add(sm_union_adventure_close_terminal)
state_machine.init()
    
function SmUnionAdventure:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self.base_point = 200
    self.current_layer = 0

    self.set_level = 0

    self.silver_number = 0
    self.gem_number = 0
    self.prop_number = 0
    self.double = false

    self.MAX_LEVEL = dms.count(dms["union_adventure_reward"])

    app.load("client.l_digital.union.adventure.SmUnionAdventureBackAward")
    app.load("client.l_digital.union.adventure.SmUnionAdventureUi")
    app.load("client.l_digital.union.adventure.SmUnionAdventureBackTip")
    app.load("client.l_digital.union.adventure.SmUnionAdventureSettlement")
    app.load("client.l_digital.cells.union.adventure.union_adventure_road_cell")
    app.load("client.l_digital.cells.union.adventure.union_adventure_stick_cell")
    local function init_sm_union_adventure_terminal()
        -- 显示界面
        local sm_union_adventure_display_terminal = {
            _name = "sm_union_adventure_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionAdventureWindow = fwin:find("SmUnionAdventureClass")
                if SmUnionAdventureWindow ~= nil then
                    SmUnionAdventureWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_union_adventure_hide_terminal = {
            _name = "sm_union_adventure_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionAdventureWindow = fwin:find("SmUnionAdventureClass")
                if SmUnionAdventureWindow ~= nil then
                    SmUnionAdventureWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --游戏结束
        local sm_union_adventure_game_over_receive_terminal = {
            _name = "sm_union_adventure_game_over_receive",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                --奖励上限
                local silver_ceiling = 0
                local gem_ceiling = 0
                local prop_ceiling = 0

                local science_info = zstring.split(_ED.union_science_info,"|")
                local hall_technology = zstring.split(science_info[5],",")
                --通过科技类型找到科技模板的库组
                local parameter_group = dms.int(dms["union_science_mould"], 5, union_science_mould.parameter_group)
                --通过参数库组找到对应de经验参数表数据
                local expMould = dms.searchs(dms["union_science_exp"], union_science_exp.group_id, parameter_group)
                local expData = nil
                for i, v in pairs(expMould) do
                    if tonumber(hall_technology[1]) == tonumber(v[3]) then
                        expData = v
                        break
                    end
                end

                local expData_info = zstring.split(expData[5],",")
                silver_ceiling = tonumber(expData_info[1])
                gem_ceiling = tonumber(expData_info[2])
                prop_ceiling = tonumber(expData_info[3])

                local datas = zstring.split(_ED.union_adventure_state_info,"!")
                if datas[2] == "-1" then
                else
                    local reworldData = zstring.split(datas[2],"|")
                    for i, v in pairs(reworldData) do
                        local datasReworld = zstring.split(v,",")
                        if tonumber(datasReworld[1]) == 1 then
                            silver_ceiling = silver_ceiling - tonumber(datasReworld[3])
                        elseif tonumber(datasReworld[1]) == 2 then
                            gem_ceiling = gem_ceiling - tonumber(datasReworld[3])
                        elseif tonumber(datasReworld[1]) == 6 then 
                            prop_ceiling = prop_ceiling - tonumber(datasReworld[3])
                        end
                    end
                end

                local rewardInfo = ""
                local reward_silver = math.min(tonumber(instance.silver_number), silver_ceiling)
                if reward_silver > 0 then
                    if rewardInfo == "" then
                        rewardInfo = "1,-1,"..reward_silver
                    else
                        rewardInfo = rewardInfo.."|".."1,-1,"..reward_silver
                    end
                end
                local gem_ceiling = math.min(tonumber(instance.gem_number), gem_ceiling)
                if gem_ceiling > 0 then
                    if rewardInfo == "" then
                        rewardInfo = "2,-1,"..gem_ceiling
                    else
                        rewardInfo = rewardInfo.."|".."2,-1,"..gem_ceiling
                    end
                end
                local prop_ceiling = math.min(tonumber(instance.prop_number), prop_ceiling)
                if prop_ceiling > 0 then

                    local propData = zstring.split(dms.string(dms["union_config"], 73, union_config.param), ",")
                    local propType = propData[1]
                    local propId = propData[2]

                    if rewardInfo == "" then
                        rewardInfo = propType .. "," .. propId .. "," .. prop_ceiling
                    else
                        rewardInfo = rewardInfo .. "|".. propType .. "," .. propId .. ",".. prop_ceiling
                    end
                end
                local science_info = zstring.split(_ED.union_science_info,"|")
                local adventure = zstring.split(science_info[4],",")

                local function recruitCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        _ED.adventure_draw_union = nil
                        state_machine.excute("sm_union_adventure_back_tip_open", 0, {reward_silver, gem_ceiling, prop_ceiling,instance.old_current_layer})
                    end
                end

                protocol_command.union_stick_crazy_adventure_draw_reward.param_list = (tonumber(adventure[4])+1).."\r\n"..rewardInfo.."\r\n"..instance.old_current_layer
                NetworkManager:register(protocol_command.union_stick_crazy_adventure_draw_reward.code, nil, nil, nil, instance, recruitCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --棍子倒下来
        local sm_union_adventure_rotate_sticks_terminal = {
            _name = "sm_union_adventure_rotate_sticks",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local Panel_road = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_road")
                local cell = ccui.Helper:seekWidgetByName(instance.standing_point.roots[1],"Panel_21"):getChildByTag(100)
                local stickLength = ccui.Helper:seekWidgetByName(cell.roots[1], "Image_stick"):getContentSize().height
                local function playOvers()
                    if instance == nil and instance.roots == nil and instance.roots[1] == nil then
                        return
                    end

                    if math.abs(instance.new_platform:getPositionX() - (stickLength + instance.base_point)) <= 5 then
                        instance.double = true
                        playEffect(formatMusicFile("effect", 9976))
                        local function changeActionCallback(armatureBack)
                            -- DSC重塑
                            if __lua_project_id == __lua_project_l_digital then
                                armatureBack._invoke = nil
                                armatureBack:removeFromParent(true)
                            end
                        end
                        local Panel_wanmei = ccui.Helper:seekWidgetByName(instance.new_platform.roots[1], "Panel_wanmei")
                        Panel_wanmei:setVisible(true)

                        -- DSC重塑
                        if __lua_project_id == __lua_project_l_digital then
                            Panel_wanmei:removeAllChildren(true)

                            local jsonFile = "images/ui/effice/effect_adv_wanmei/effect_adv_wanmei.json"
                            local atlasFile = "images/ui/effice/effect_adv_wanmei/effect_adv_wanmei.atlas"
                            local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation1", false, nil)
                            sp.initArmature(animation, false)
                            animation._invoke = changeActionCallback
                            animation.animationNameList = {"animation1", "animation2"}
                            Panel_wanmei:addChild(animation)
                            animation:setPosition(cc.p(Panel_wanmei:getContentSize().width / 2, Panel_wanmei:getContentSize().height / 2))
                            animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
                            csb.animationChangeToAction(animation, 0, 0, false)
                        else
                            local boy_touch = Panel_wanmei:getChildByName("ArmatureNode_1")
                            draw.initArmature(boy_touch, nil, -1, 0, 1)
                            boy_touch:getAnimation():playWithIndex(0, 0, 0)
                            boy_touch._invoke = changeActionCallback
                        end
                    end
                end
                ccui.Helper:seekWidgetByName(cell.roots[1], "Image_stick"):runAction(cc.Sequence:create(cc.RotateBy:create(0.25, 90),cc.CallFunc:create(playOvers)))
                local scheduler = cc.Director:getInstance():getScheduler()  
                local schedulerID = nil  
                schedulerID = scheduler:scheduleScriptFunc(function ()
                        if instance == nil and instance.roots == nil and instance.roots[1] == nil then
                            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(schedulerID)
                            return
                        end
                        state_machine.excute("sm_union_adventure_play_hero_animation",0,1)
                        local moving_distance = -ccui.Helper:seekWidgetByName(instance.new_platform.roots[1], "Image_road"):getContentSize().width/2+self.base_point - instance.new_platform:getPositionX()
                        --判断是否过关
                        
                        -- instance.hero_animation:runAction(cc.MoveTo:create(0.25, cc.p(instance.standing_point:getPositionX()+ stickLength + instance.base_point, 0)))
                        local max = instance.new_platform:getPositionX()+ccui.Helper:seekWidgetByName(instance.new_platform.roots[1], "Image_road"):getContentSize().width/2
                        local min = instance.new_platform:getPositionX()-ccui.Helper:seekWidgetByName(instance.new_platform.roots[1], "Image_road"):getContentSize().width/2
                        if stickLength + instance.base_point >  max or stickLength + instance.base_point < min then
                            -- print("失败了")
                            instance.isover = true
                            playEffect(formatMusicFile("effect", 9977))
                            local function playOver()
                                ccui.Helper:seekWidgetByName(cell.roots[1], "Image_stick"):runAction(cc.RotateBy:create(0.25, 90))
                                local function changeActionCallback(armatureBack)
                                    ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_over"):setVisible(false)

                                end
                                local Panel_over = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_over")
                                Panel_over:setVisible(true)
                                local boy_touch = Panel_over:getChildByName("ArmatureNode_1")
                                draw.initArmature(boy_touch, nil, -1, 0, 1)
                                boy_touch:getAnimation():playWithIndex(1, 0, 0)
                                boy_touch._invoke = changeActionCallback
                            end

                            instance.hero_animation:runAction(cc.Sequence:create(cc.MoveTo:create(0.25, cc.p(instance.standing_point:getPositionX()+ stickLength + instance.base_point, 0)),cc.CallFunc:create(playOver)))
                        else
                            -- print("成功了")
                            instance.isover = false
                            local function playOver()
                                for i=1, 3 do
                                    ccui.Helper:seekWidgetByName(instance.new_platform.roots[1],"Panel_reward_type_"..i):setVisible(false)
                                end
                                ccui.Helper:seekWidgetByName(instance.new_platform.roots[1],"Text_number"):setString("")
                                local function changeActionCallback(armatureBack)
                                    ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_root"):setTouchEnabled(true)
                                end
                                playEffect(formatMusicFile("effect", 9976))
                                ccui.Helper:seekWidgetByName(instance.new_platform.roots[1],"Panel_huode"):setVisible(true)
                                local boy_touch = ccui.Helper:seekWidgetByName(instance.new_platform.roots[1],"Panel_huode"):getChildByName("ArmatureNode_2")
                                
                                if __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 then
                                    local jsonFile = "images/ui/effice/effect_ghdamaoxian/effect_ghdamaoxian.json"
                                    local atlasFile = "images/ui/effice/effect_ghdamaoxian/effect_ghdamaoxian.atlas"
                                    local animationNameList = {"jinbi", "zuanshi", "baoxiang"}
                                    local reward = zstring.split(dms.string(dms["union_adventure_reward"], self.current_layer+1, union_adventure_reward.reward),",")
                                    local animation_node = nil
                                    if tonumber(reward[1]) == 1 then
                                        animation_node = sp.spine(jsonFile, atlasFile, 1, 0, animationNameList[1], false, nil)
                                    elseif tonumber(reward[1]) == 2 then
                                        animation_node = sp.spine(jsonFile, atlasFile, 1, 0, animationNameList[2], false, nil)
                                    else
                                        animation_node = sp.spine(jsonFile, atlasFile, 1, 0, animationNameList[3], false, nil)
                                    end

                                    boy_touch:addChild(animation_node)
                                    animation_node:registerSpineEventHandler(function (event)
                                        animation_node:removeFromParent(true)
                                        changeActionCallback()
                                    end, sp.EventType.ANIMATION_COMPLETE)
                                else
                                    draw.initArmature(boy_touch, nil, -1, 0, 1)
                                    local reward = zstring.split(dms.string(dms["union_adventure_reward"], self.current_layer+1, union_adventure_reward.reward),",")
                                    if tonumber(reward[1]) == 1 then
                                        boy_touch:getAnimation():playWithIndex(0, 0, 0)
                                    elseif tonumber(reward[1]) == 2 then
                                        boy_touch:getAnimation():playWithIndex(1, 0, 0)
                                    else
                                        -- boy_touch:getAnimation():playWithIndex(2, 0, 0)
                                        -- 暂时屏蔽获得道具碎片的动画
                                        ccui.Helper:seekWidgetByName(instance.new_platform.roots[1],"Panel_huode"):setVisible(false)
                                        ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_root"):setTouchEnabled(true)
                                    end
                                    boy_touch._invoke = changeActionCallback
                                end
                            end
                            instance.hero_animation:runAction(cc.Sequence:create(cc.MoveTo:create(0.25, cc.p(instance.standing_point:getPositionX()+ stickLength + instance.base_point, 0)),cc.CallFunc:create(playOver)))
                        end
                        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(schedulerID)
                end,0.5,false)

                --角色移动
                local scheduler3 = cc.Director:getInstance():getScheduler()  
                local schedulerID3 = nil  
                schedulerID3 = scheduler3:scheduleScriptFunc(function ()
                        if instance == nil and instance.roots == nil and instance.roots[1] == nil then
                            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(schedulerID3)
                            return
                        end
                        state_machine.excute("sm_union_adventure_play_hero_animation",0,0)
                        if instance.isover == true then
                            local old_current_layer = instance.current_layer
                            local function playOver()
                                instance.current_layer = 0
                                -- local Panel_21 = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_21")
                                -- state_machine.excute("sm_union_adventure_ui_open", 0, {Panel_21})
                                instance.old_current_layer = old_current_layer
                                state_machine.excute("sm_union_adventure_game_over_receive", 0, "")
                                -- state_machine.excute("sm_union_adventure_back_tip_open", 0, {instance.silver_number,instance.gem_number,instance.prop_number,old_current_layer})
                                state_machine.unlock("sm_union_adventure_direct_settlement", 0, "")
                                ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_root"):setTouchEnabled(true)
                                instance:showShipAnimation()
                            end
                            instance.hero_animation:runAction(cc.Sequence:create(cc.MoveBy:create(0.5, cc.p(0, -200)),cc.CallFunc:create(playOver)))
                        end
                        local function playOver()
                            state_machine.unlock("sm_union_adventure_direct_settlement", 0, "")
                            state_machine.excute("union_adventure_road_cell_show_stick", 0, {instance.standing_point, false})
                            state_machine.excute("union_adventure_road_cell_show_stick", 0, {instance.new_platform, true})
                            local Panel_21 = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_21")
                            -- Panel_road:removeChildByTag(100-instance.current_layer)
                            instance.standing_point = instance.new_platform 
                            
                            ccui.Helper:seekWidgetByName(instance.standing_point.roots[1],"Panel_wanmei"):setVisible(false)
                            ccui.Helper:seekWidgetByName(instance.standing_point.roots[1],"Panel_huode"):setVisible(false)
                            
                            instance.new_platform = nil
                            instance.current_layer = instance.current_layer + 1
                            if instance.isover == false and instance.current_layer >= instance.MAX_LEVEL then
                                local function changeActionCallback(armatureBack)
                                    old_current_layer = instance.current_layer
                                    instance.current_layer = 0
                                    ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_over"):setVisible(false)
                                    instance.old_current_layer = old_current_layer
                                    state_machine.excute("sm_union_adventure_game_over_receive", 0, "")
                                    -- state_machine.excute("sm_union_adventure_back_tip_open", 0, {instance.silver_number,instance.gem_number,instance.prop_number,old_current_layer})
                                    state_machine.unlock("sm_union_adventure_direct_settlement", 0, "")
                                    ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_root"):setTouchEnabled(true)
                                    instance:showShipAnimation()
                                end
                                local Panel_over = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_over")
                                Panel_over:setVisible(true)
                                local boy_touch = Panel_over:getChildByName("ArmatureNode_1")
                                draw.initArmature(boy_touch, nil, -1, 0, 1)
                                boy_touch:getAnimation():playWithIndex(0, 0, 0)
                                boy_touch._invoke = changeActionCallback
                            else
                                if instance.isover == true then
                                    for i=1, 3 do
                                        ccui.Helper:seekWidgetByName(instance.standing_point.roots[1],"Panel_reward_type_"..i):setVisible(false)
                                    end
                                    ccui.Helper:seekWidgetByName(instance.standing_point.roots[1],"Text_number"):setString("")
                                    ccui.Helper:seekWidgetByName(instance.standing_point.roots[1],"Panel_wanmei"):setVisible(false)
                                    ccui.Helper:seekWidgetByName(instance.standing_point.roots[1],"Panel_huode"):setVisible(false)
                                end
                            end

                            if instance.isover == false then
                                local step_range = zstring.split(dms.string(dms["union_adventure_reward"], instance.current_layer, union_adventure_reward.reward),",")
                                if instance.double == true then
                                    instance:drawUpdateRewald(tonumber(step_range[1]),tonumber(step_range[3])*2)
                                else
                                    instance:drawUpdateRewald(tonumber(step_range[1]),tonumber(step_range[3]))
                                end
                                instance.double = false
                            end

                            if instance.current_layer < instance.MAX_LEVEL then
                                local Panel_21 = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_21")
                                    --新出现的
                                instance.new_platform = state_machine.excute("union_adventure_road_cell_creat", 0, {"2",nil,instance.current_layer+1})
                                instance.new_platform:setTag(100-instance.current_layer-1)
                                Panel_road:addChild(instance.new_platform,100-instance.set_level)
                                instance.set_level = instance.set_level + 1
                                instance.new_platform:setPositionX(Panel_21:getContentSize().width+ccui.Helper:seekWidgetByName(instance.new_platform.roots[1],"Image_road"):getContentSize().width/2)
                                local spacing = ccui.Helper:seekWidgetByName(instance.new_platform.roots[1],"Image_road")._w
                                local step_distance_range = zstring.split(dms.string(dms["union_adventure_reward"], instance.current_layer+1, union_adventure_reward.step_distance_range),",")
                                instance.new_platform:runAction(cc.MoveTo:create(0.25, cc.p(instance.base_point + math.random(tonumber(step_distance_range[1]),tonumber(step_distance_range[2]))*spacing, instance.new_platform:getPositionY())))
                            end
                        end

                        instance.hero_animation:runAction(cc.MoveTo:create(0.25, cc.p(instance.hero_p, 0)))
                        local moving_distance = -ccui.Helper:seekWidgetByName(instance.new_platform.roots[1], "Image_road"):getContentSize().width/2+instance.base_point - instance.new_platform:getPositionX()
                        instance.new_platform:runAction(cc.MoveBy:create(0.25, cc.p(moving_distance, 0)))
                        instance.standing_point:runAction(cc.Sequence:create(cc.MoveBy:create(0.25, cc.p(moving_distance, 0)),cc.CallFunc:create(playOver)))
                        state_machine.excute("union_adventure_road_cell_show_stick", 0, {instance.new_platform, true})
                        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(schedulerID3)
                end,1,false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --播放攻击动画
        local sm_union_adventure_play_hero_animation_terminal = {
            _name = "sm_union_adventure_play_hero_animation",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
                    instance:changeHeroAnimation(params)
                end
            end,
            _terminal = nil,
            _terminals = nil
        }

        --播放攻击动画
        local sm_union_adventure_start_the_game_terminal = {
            _name = "sm_union_adventure_start_the_game",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.current_layer = tonumber(params)
                state_machine.excute("sm_union_adventure_ui_hide", 0, "")
                ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_root"):setTouchEnabled(true)
                instance:drawUpdateRewald(0,"")
                local Panel_jindu = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_jindu")
                Panel_jindu:setVisible(true)
            end,
            _terminal = nil,
            _terminals = nil
        }

        --重新开始
        local sm_union_adventure_start_new_start_terminal = {
            _name = "sm_union_adventure_start_new_start",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.current_layer = 0
                state_machine.excute("sm_union_adventure_ui_show", 0, "")
                state_machine.excute("sm_union_adventure_ui_update_draw", 0, "")
                local Panel_jindu = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_jindu")
                Panel_jindu:setVisible(false)

                instance:onUpdateDraw()
            end,
            _terminal = nil,
            _terminals = nil
        }

        --直接结算
        local sm_union_adventure_direct_settlement_terminal = {
            _name = "sm_union_adventure_direct_settlement",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("union_unlock_state_machine", 0, nil)

                if instance.current_layer  > 0 then
                    state_machine.excute("sm_union_adventure_settlement_open", 0, {instance.silver_number,instance.gem_number,instance.prop_number,instance.current_layer})
                else
                    state_machine.excute("sm_union_adventure_close", 0, "")
                end
                
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 跳转
        local sm_union_adventure_skip_to_best_terminal = {
            _name = "sm_union_adventure_skip_to_best",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:skipToBest()                
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_union_adventure_display_terminal)
        state_machine.add(sm_union_adventure_hide_terminal)
        state_machine.add(sm_union_adventure_rotate_sticks_terminal)
        state_machine.add(sm_union_adventure_play_hero_animation_terminal)
        state_machine.add(sm_union_adventure_start_the_game_terminal)
        state_machine.add(sm_union_adventure_start_new_start_terminal)
        state_machine.add(sm_union_adventure_direct_settlement_terminal)
        state_machine.add(sm_union_adventure_game_over_receive_terminal)
        state_machine.add(sm_union_adventure_skip_to_best_terminal)
        state_machine.init()
    end
    init_sm_union_adventure_terminal()
end

function SmUnionAdventure:drawUpdateRewald(index,number)
    local root = self.roots[1]
    if root == nil then 
        return
    end

    local silver_ceiling = 0
    local gem_ceiling = 0
    local prop_ceiling = 0

    local science_info = zstring.split(_ED.union_science_info,"|")
    local hall_technology = zstring.split(science_info[5],",")
    --通过科技类型找到科技模板的库组
    local parameter_group = dms.int(dms["union_science_mould"], 5, union_science_mould.parameter_group)
    --通过参数库组找到对应de经验参数表数据
    local expMould = dms.searchs(dms["union_science_exp"], union_science_exp.group_id, parameter_group)
    local expData = nil
    for i, v in pairs(expMould) do
        if tonumber(hall_technology[1]) == tonumber(v[3]) then
            expData = v
            break
        end
    end

    local expData_info = zstring.split(expData[5],",")
    silver_ceiling = tonumber(expData_info[1])
    gem_ceiling = tonumber(expData_info[2])
    prop_ceiling = tonumber(expData_info[3])

    local datas = zstring.split(_ED.union_adventure_state_info,"!")
    if datas[2] == "-1" then
    else
        local reworldData = zstring.split(datas[2],"|")
        for i, v in pairs(reworldData) do
            local datasReworld = zstring.split(v,",")
            if tonumber(datasReworld[1]) == 1 then
                silver_ceiling = silver_ceiling - tonumber(datasReworld[3])
            elseif tonumber(datasReworld[1]) == 2 then
                gem_ceiling = gem_ceiling - tonumber(datasReworld[3])
            elseif tonumber(datasReworld[1]) == 6 then 
                prop_ceiling = prop_ceiling - tonumber(datasReworld[3])
            end
        end
    end
    
    local isVerity = true
    if isVerity == true and _ED.adventure_draw_union ~= nil then
        local adventure_draw_union = aeslua.decrypt("jar-world", _ED.adventure_draw_union, aeslua.AES128, aeslua.ECBMODE)
        if self.silver_number..self.gem_number..self.prop_number ~= adventure_draw_union then
            isVerity = false
        end
    end

    if index == 1 then
        self.silver_number = zstring.tonumber(self.silver_number) + zstring.tonumber(number)
        if self.silver_number >= silver_ceiling then
            self.silver_number = silver_ceiling
        end
    elseif index == 2 then
        self.gem_number = zstring.tonumber(self.gem_number) + zstring.tonumber(number)
        if self.gem_number >= gem_ceiling then
            self.gem_number = gem_ceiling
        end
    elseif index == 6 then
        self.prop_number = zstring.tonumber(self.prop_number) + zstring.tonumber(number)
        if self.prop_number >= prop_ceiling then
            self.prop_number = prop_ceiling
        end 
    else
        if self.silver_number >= silver_ceiling then
            self.silver_number = silver_ceiling
        end

        if self.gem_number >= gem_ceiling then
            self.gem_number = gem_ceiling
        end

        if self.prop_number >= prop_ceiling then
            self.prop_number = prop_ceiling
        end 
    end

    if isVerity == false then
        if fwin:find("ReconnectViewClass") == nil then
            fwin:open(ReconnectView:new():init(_string_piece_info[420]), fwin._system)
        end
        return false
    else
        _ED.adventure_draw_union = aeslua.encrypt("jar-world", self.silver_number..self.gem_number..self.prop_number, aeslua.AES128, aeslua.ECBMODE)
    end

    --宝石
    local Text_zs_n = ccui.Helper:seekWidgetByName(root,"Text_zs_n")
    --钱
    local Text_jb_n = ccui.Helper:seekWidgetByName(root,"Text_jb_n")
    --道具
    local Text_sp_n = ccui.Helper:seekWidgetByName(root,"Text_sp_n")
    Text_zs_n:setString(self.gem_number)
    Text_jb_n:setString(self.silver_number)
    Text_sp_n:setString(self.prop_number)

    if index == 1 then
        Text_jb_n:setScale(1.2)
        Text_jb_n:setColor(cc.c3b(0, 255, 0))
        Text_jb_n:runAction(cc.Sequence:create({cc.DelayTime:create(0.5), cc.CallFunc:create(function ( sender )
            Text_jb_n:setColor(cc.c3b(255, 255, 255))
            Text_jb_n:setScale(1)
        end)}))
    elseif index == 2 then
        Text_zs_n:setScale(1.2)
        Text_zs_n:setColor(cc.c3b(0, 255, 0))
        Text_zs_n:runAction(cc.Sequence:create({cc.DelayTime:create(0.5), cc.CallFunc:create(function ( sender )
            Text_zs_n:setColor(cc.c3b(255, 255, 255))
            Text_zs_n:setScale(1)
        end)}))
    elseif index == 6 then
        Text_sp_n:setScale(1.2)
        Text_sp_n:setColor(cc.c3b(0, 255, 0))
        Text_sp_n:runAction(cc.Sequence:create({cc.DelayTime:create(0.5), cc.CallFunc:create(function ( sender )
            Text_sp_n:setColor(cc.c3b(255, 255, 255))
            Text_sp_n:setScale(1)
        end)}))
    end
    ccui.Helper:seekWidgetByName(root,"Text_floor"):setString(self.current_layer)

    local Image_jindu = ccui.Helper:seekWidgetByName(root,"Image_jindu")

    local increase_distance = Image_jindu:getContentSize().width/60

    local Image_arrow = ccui.Helper:seekWidgetByName(root,"Image_arrow")
    if Image_arrow._x == nil then
        Image_arrow._x = Image_arrow:getPositionX()
    end
    Image_arrow:setPositionX(Image_arrow._x+zstring.tonumber(self.current_layer)*increase_distance)
    if number == "" then
        Image_arrow:setPositionX(Image_arrow._x)
    end
end

function SmUnionAdventure:changeHeroAnimation(play_types)
    self.play_types = play_types
    csb.animationChangeToAction(self.hero_animation, play_types, play_types, false)
end

function SmUnionAdventure:showShipAnimation()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local Panel_juese = ccui.Helper:seekWidgetByName(root,"Panel_juese")
    Panel_juese:removeAllChildren(true)
    local hero_animation = sp.spine_sprite(Panel_juese, tonumber(union_small_games_deploy[1]), spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
    hero_animation:setScaleX(-1)
    self.hero_animation = hero_animation
    self.play_types = 0
    hero_animation.animationNameList = spineAnimations
    sp.initArmature(hero_animation, true)
    hero_animation._self = self
    self.hero_p = hero_animation:getPositionX()

    local function changeActionCallback( armatureBack ) 
        state_machine.excute("sm_union_adventure_play_hero_animation",0,0)
    end
    hero_animation._invoke = changeActionCallback
    hero_animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    csb.animationChangeToAction(hero_animation, 0, 0, false)
end

function SmUnionAdventure:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    self.silver_number = 0
    self.gem_number = 0
    self.prop_number = 0

    ccui.Helper:seekWidgetByName(root,"Text_floor"):setString(self.current_layer)

    local Image_jindu = ccui.Helper:seekWidgetByName(root,"Image_jindu")

    local increase_distance = Image_jindu:getContentSize().width/100

    local Image_arrow = ccui.Helper:seekWidgetByName(root,"Image_arrow")
    Image_arrow:setPositionX(Image_arrow:getPositionX()+increase_distance*self.current_layer)
    local Panel_road = ccui.Helper:seekWidgetByName(root,"Panel_road")
    Panel_road:removeAllChildren(true)
    if self.current_layer == 0 then
        --角色待的地方
        self.standing_point = state_machine.excute("union_adventure_road_cell_creat", 0, {"1",self.base_point})
        self.standing_point:setTag(100-self.current_layer)
        Panel_road:addChild(self.standing_point,100-self.set_level)
        self.set_level = self.set_level + 1
        self.standing_point:setPositionX(self.base_point/2)
        for i=1, 3 do
            ccui.Helper:seekWidgetByName(self.standing_point.roots[1],"Panel_reward_type_"..i):setVisible(false)
        end
        ccui.Helper:seekWidgetByName(self.standing_point.roots[1],"Text_number"):setString("")
        ccui.Helper:seekWidgetByName(self.standing_point.roots[1],"Panel_wanmei"):setVisible(false)
        ccui.Helper:seekWidgetByName(self.standing_point.roots[1],"Panel_huode"):setVisible(false)

        local Panel_21 = ccui.Helper:seekWidgetByName(root,"Panel_21")
            --新出现的
        self.new_platform = state_machine.excute("union_adventure_road_cell_creat", 0, {"2",nil,self.current_layer+1})
        self.new_platform:setTag(100-self.current_layer-1)
        Panel_road:addChild(self.new_platform,100-self.set_level)
        self.set_level = self.set_level + 1
        self.new_platform:setPositionX(Panel_21:getContentSize().width+ccui.Helper:seekWidgetByName(self.new_platform.roots[1],"Image_road"):getContentSize().width/2)
        local spacing = ccui.Helper:seekWidgetByName(self.new_platform.roots[1],"Image_road")._w
        local step_distance_range = zstring.split(dms.string(dms["union_adventure_reward"], self.current_layer+1, union_adventure_reward.step_distance_range),",")
        self.new_platform:runAction(cc.MoveTo:create(0.25, cc.p(self.base_point + math.random(tonumber(step_distance_range[1]),tonumber(step_distance_range[2]))*spacing, self.new_platform:getPositionY())))
    end

    self:showShipAnimation()
end

function SmUnionAdventure:init()
    self:onInit()
    return self
end

function SmUnionAdventure:onUpdate(dt)
    if self.one == true then
        state_machine.excute("union_adventure_stick_cell_updata", 0, {ccui.Helper:seekWidgetByName(self.standing_point.roots[1],"Panel_21"):getChildByTag(100),self.current_layer+1})
    end
end

-- 创建icon
function SmUnionAdventure:addResourcesIconCell(propData)
    local cell = ResourcesIconCell:createCell()
    local rewardType = tonumber(propData[1])
    if 13 == rewardType then
        local extraTable = {}
        if propData[4] ~= nil and tonumber(propData[4]) ~= -1 then
            extraTable.shipStar = tonumber(propData[4])
        else
            extraTable.shipStar = 0
        end
        cell:init(rewardType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true, true, 1, extraTable)
    else
        cell:init(rewardType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true ,true, 1)
    end
    return cell
end

function SmUnionAdventure:addRewardPropIcon()
    local propData = zstring.split(dms.string(dms["union_config"], 73, union_config.param), ",")
    local cell = self:addResourcesIconCell(propData)

    local Panel_sp_icon = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_sp_icon")
    Panel_sp_icon:removeAllChildren(true)
    Panel_sp_icon:addChild(cell)
end

function SmUnionAdventure:onInit()
    local csbSmUnionAdventure = csb.createNode("legion/sm_legion_adventure.csb")
    local root = csbSmUnionAdventure:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmUnionAdventure)
    self:onUpdateDraw()
    state_machine.excute("sm_union_user_topinfo_open",0,self)

    local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.UnionAdventureReward)
    if fun_is_open == true then
        self:addRewardPropIcon()
    end

	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_03"), nil, 
    {
        terminal_name = "sm_union_adventure_direct_settlement",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil,3)
    local Panel_root = ccui.Helper:seekWidgetByName(root,"Panel_root")
    -- 升长棍子
    local function consumptionOnTouchEvent(sender, evenType)
            local __spoint = sender:getTouchBeganPosition()
            local __mpoint = sender:getTouchMovePosition()
            local __epoint = sender:getTouchEndPosition()

            if ccui.TouchEventType.began == evenType then
                self.one = true
                state_machine.lock("sm_union_adventure_direct_settlement", 0, "")
            elseif ccui.TouchEventType.moved == evenType then
                if __lua_project_id == __lua_project_gragon_tiger_gate
                    or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    or __lua_project_id == __lua_project_red_alert 
                    or __lua_project_id == __lua_project_digimon_adventure 
                    or __lua_project_id == __lua_project_yugioh
                    or __lua_project_id == __lua_project_warship_girl_b 
                    then
                    if __mpoint.x - __spoint.x > 80 
                        or __mpoint.x - __spoint.x < -80 
                        or __mpoint.y - __spoint.y > 50 
                        or __mpoint.y - __spoint.y < -50 
                        then
                        self.one = false
                        state_machine.excute("sm_union_adventure_rotate_sticks", 0, "")
                        Panel_root:setTouchEnabled(false)
                    end
                end
            elseif ccui.TouchEventType.ended == evenType then
                self.one = false
                state_machine.excute("sm_union_adventure_rotate_sticks", 0, "")
                Panel_root:setTouchEnabled(false)
            end
        end
        
        if Panel_root ~= nil then
            Panel_root:addTouchEventListener(consumptionOnTouchEvent)
        end
        
    local science_info = zstring.split(_ED.union_science_info,"|")
    local adventure = zstring.split(science_info[4],",")
    local adventure_group = dms.int(dms["union_science_mould"], 4, union_science_mould.parameter_group)
    local adventureMould = dms.searchs(dms["union_science_exp"], union_science_exp.group_id, adventure_group)
    local adventureData = nil
    for i, v in pairs(adventureMould) do
        if tonumber(adventure[1]) == tonumber(v[3]) then
            adventureData = v
            break
        end
    end

    local countPlay = tonumber(adventure[4])
    
    local datas = zstring.split(_ED.union_adventure_state_info,"!")
    local infos = zstring.split(datas[1],",")
    local best_level = tonumber(infos[2])
    local topHistoryData = datas[3]
    local isRightHistory = true
    if topHistoryData == nil or topHistoryData == "-1" or topHistoryData == "" then
        isRightHistory = false
    end

    local Panel_21 = ccui.Helper:seekWidgetByName(root,"Panel_21")

    --没开始
    state_machine.excute("sm_union_adventure_ui_open", 0, {Panel_21})

    if countPlay == 0 and best_level > 0 and isRightHistory then
        state_machine.excute("sm_union_adventure_back_award_window_open", 0, {Panel_21})
        state_machine.excute("sm_union_adventure_ui_hide", 0, "")
    end

    local Panel_jindu = ccui.Helper:seekWidgetByName(root,"Panel_jindu")
    Panel_jindu:setVisible(false)
end

function SmUnionAdventure:onExit()
    state_machine.remove("sm_union_adventure_display")
    state_machine.remove("sm_union_adventure_hide")
    state_machine.remove("sm_union_adventure_rotate_sticks")
    state_machine.remove("sm_union_adventure_play_hero_animation")
    state_machine.remove("sm_union_adventure_start_the_game")
    state_machine.remove("sm_union_adventure_skip_to_best")
end

function SmUnionAdventure:skipToBest(nLevel)
    if nLevel == nil then
        local datas = zstring.split(_ED.union_adventure_state_info,"!")
        local infos = zstring.split(datas[1],",")
        local best_level = tonumber(infos[2])
        nLevel = best_level
    end

    if nLevel >= self.MAX_LEVEL then
        nLevel = self.MAX_LEVEL - 1
    end

    -- 设置层级
    self.current_layer = nLevel
    self.set_level = nLevel

    -- 设置触摸
    ccui.Helper:seekWidgetByName(self.roots[1],"Panel_root"):setTouchEnabled(true)

    -- 重新绘制新平台
    local spacing = ccui.Helper:seekWidgetByName(self.new_platform.roots[1],"Image_road")._w
    local step_distance_range = zstring.split(dms.string(dms["union_adventure_reward"], nLevel + 1, union_adventure_reward.step_distance_range),",")
    self.new_platform:setPosition(cc.p(self.base_point + math.random(tonumber(step_distance_range[1]),tonumber(step_distance_range[2]))*spacing, self.new_platform:getPositionY()))
    self.new_platform:resetData(nLevel + 1)

    -- 叠加之前的奖励
    self.silver_number = 0
    self.gem_number = 0
    self.prop_number = 0

    local dataAdventure = dms["union_adventure_reward"]
    for i=1, self.current_layer do
        local reward = zstring.split(dms.string(dataAdventure, i, union_adventure_reward.reward), ",", zstring.tonumber)
        local rewardType = reward[1]
        local rewardNum = reward[3]
        if rewardType == 1 then
            self.silver_number = self.silver_number + rewardNum
        elseif rewardType == 2 then
            self.gem_number = self.gem_number + rewardNum
        elseif rewardType == 6 then
            self.prop_number = self.prop_number + rewardNum
        end
    end

    _ED.adventure_draw_union = nil

    -- 重新绘制奖励
    self:drawUpdateRewald(0, 0)

    local Panel_jindu = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_jindu")
    Panel_jindu:setVisible(true)
end