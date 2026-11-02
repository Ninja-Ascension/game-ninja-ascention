local is2006 = false
local is2005 = false
if __lua_project_id == __lua_project_warship_girl_a 
or __lua_project_id == __lua_project_warship_girl_b
or __lua_project_id == __lua_project_digimon_adventure 
or __lua_project_id == __lua_project_red_alert_time 
or __lua_project_id == __lua_project_pacific_rim  
or __lua_project_id == __lua_project_naruto 
or __lua_project_id == __lua_project_pokemon 
or __lua_project_id == __lua_project_rouge 
or __lua_project_id == __lua_project_yugioh 
or __lua_project_id == __lua_project_koone then
    if dev_version >= 2006 then
        is2006 = true
    elseif dev_version >= 2005 then
        is2005 = true
    end
end

FightMap = class("FightMapClass", Window)

local fight_map_create_map_terminal = {
    _name = "fight_map_create_map",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local mapIndex = params[1]
        local npcType = params[2]
        local function createMap(_mapIndex, _npcType)
            local fightMapLayer = FightMap:new()
            fightMapLayer:init(_mapIndex, _npcType)
            fightMapLayer:retain()
            terminal._map = fightMapLayer
        end
        if terminal._map == nil then
            createMap(mapIndex, npcType)
        else
            terminal._map:reload(mapIndex, npcType)
        end
        return terminal._map
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(fight_map_create_map_terminal)
state_machine.init()

function FightMap:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self.csbMap = nil
    self.animation = nil
    self._map_background_image_index = 0

    self._teamIndex = 0
    self._actionEndCount = 0

    self._fightIndex = 0
    
    self._npc_type = "0"

    -- Initialize fight map page state machine.
    local function init_fight_map_terminal()
        -- 英雄入场
        local fight_map_hero_into_terminal = {
            _name = "fight_map_hero_into",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:playAnimationByHeroIntoFightMap(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 英雄进入下一场战斗
        local fight_map_hero_into_next_fight_terminal = {
            _name = "fight_map_hero_into_next_fight",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:playAnimationByHeroIntoNextFightMap(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 敌方入场
        local fight_map_master_into_terminal = {
            _name = "fight_map_master_into",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:playAnimationByMasterIntoFightMap(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 敌方入场需要播放宠物加层
        local fight_map_master_into_play_pet_terminal = {
            _name = "fight_map_master_into_play_pet",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.isMasterPet = true
                instance:playAnimationByMasterIntoFightMap(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 切换战斗地图的背景
        local fight_map_change_background_image_terminal = {
            _name = "fight_map_change_background_image",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:changeBackgroundImageOfMap(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        -- 启动角色进入下一场战斗的动画
        local fight_map_hero_next_go_terminal = {
            _name = "fight_map_hero_next_go",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:playFightMapHeroNextGo(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        -- 动画加速控制
        local fight_map_action_time_speed_terminal = {
            _name = "fight_map_action_time_speed",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setTimeSpeed()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_map_init_card_info_terminal = {
            _name = "fight_map_init_card_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    instance:initCardInfo()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_map_play_card_animation_terminal = {
            _name = "fight_map_play_card_animation",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    instance:playCardAnimation(params)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 位置标识淡出
        local fight_map_fade_out_position_flag_terminal = {
            _name = "fight_map_fade_out_position_flag",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    instance:playFadeOutPositionFlagAnimation(params)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 抖动
        local fight_map_attack_shake_action_terminal = {
            _name = "fight_map_attack_shake_action",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    instance:playAttackShakeAction(params)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 抖动-发射子弹
        local fight_map_attack_bullet_shake_action_terminal = {
            _name = "fight_map_attack_bullet_shake_action",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    instance:playAttackBulletShakeAction(params)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 抖动-入场
        local fight_map_join_battle_shake_action_terminal = {
            _name = "fight_map_join_battle_shake_action",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    instance:playJoinBattleShakeAction(params)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 抖动-出场
        local fight_map_out_battle_shake_action_terminal = {
            _name = "fight_map_out_battle_shake_action",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    instance:playOutBattleShakeAction(params)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(fight_map_hero_into_terminal)
        state_machine.add(fight_map_hero_into_next_fight_terminal)
        state_machine.add(fight_map_master_into_terminal)
        state_machine.add(fight_map_change_background_image_terminal)
        state_machine.add(fight_map_hero_next_go_terminal)
        state_machine.add(fight_map_action_time_speed_terminal)
        if __lua_project_id == __lua_project_yugioh then
            state_machine.add(fight_map_init_card_info_terminal)
            state_machine.add(fight_map_play_card_animation_terminal)
        end
        state_machine.add(fight_map_master_into_play_pet_terminal)
        state_machine.add(fight_map_fade_out_position_flag_terminal)
        state_machine.add(fight_map_attack_shake_action_terminal)
        state_machine.add(fight_map_attack_bullet_shake_action_terminal)
        state_machine.add(fight_map_join_battle_shake_action_terminal)
        state_machine.add(fight_map_out_battle_shake_action_terminal)
        state_machine.init()
    end

    -- call func init fight map state machine.
    init_fight_map_terminal()
end

function FightMap:initCardInfo( ... )
    local root = self.roots[1]
    if root ~= nil then
        for i=1,3 do
            local panel_card = ccui.Helper:seekWidgetByName(root, "Panel_card_"..i)
            panel_card:removeBackGroundImage()
            if zstring.tonumber(_ED.battleData.card_count) >= i then
                local card_mould_id = _ED.battleData.card_infos[i]
                if zstring.tonumber(card_mould_id) ~= nil and zstring.tonumber(card_mould_id) > 0 then
                    panel_card:setBackGroundImage(string.format("images/ui/battle/battle_trap_%d.png", i))
                end
            end
        end
    end
end

function FightMap:playCardAnimation( params )
    local root = self.roots[1]
    if root ~= nil then
        local index = 1
        for i=1,3 do
            local card_mould_id = _ED.battleData.card_infos[i]
            if tonumber(card_mould_id) == tonumber(params) then
                index = i
            end
        end
        local panel_card = ccui.Helper:seekWidgetByName(root, "Panel_card_"..index)
        panel_card:removeBackGroundImage()
        local Panel_29717 = ccui.Helper:seekWidgetByName(root, "Panel_29717")
        local ArmatureNode_card = Panel_29717:getChildByName("ArmatureNode_card_"..index)
        ArmatureNode_card:setVisible(true)
        local function changeActionCallback(armatureBack)
            armatureBack:setVisible(false)
        end
        draw.initArmature(ArmatureNode_card, nil, -1, 0, 1)
        ArmatureNode_card._invoke = changeActionCallback
        csb.animationChangeToAction(ArmatureNode_card, 0, 0, false)
    end
end

function FightMap:init(mapIndex, _npc_type)
    self._map_background_image_index = mapIndex
    self._npc_type = _npc_type

    local csbMap = csb.createNode("battle/battle_map.csb")
    local root = csbMap:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline("battle/battle_map.csb")
    -- action:setTimeSpeed(1.0 / __fight_recorder_action_time_speed)
    table.insert(self.actions, action)
    csbMap:runAction(action)

    self.csbMap = csbMap
    self:addChild(csbMap)

    self:changeBackgroundImageOfMap(self._map_background_image_index)

    if __lua_project_id == __lua_project_warship_girl_b
        or __lua_project_id == __lua_project_digimon_adventure 
        or __lua_project_id == __lua_project_red_alert_time 
	or __lua_project_id == __lua_project_pacific_rim  
        or __lua_project_id == __lua_project_naruto 
        or __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge 
        or __lua_project_id == __lua_project_yugioh 
    	or __lua_project_id == __lua_project_koone
    	then
        fwin:addTouchEventListener(root, nil, 
        {
            terminal_name = "fight_hero_info_ui_show", 
            terminal_state = 0, 
            _type = 1,
        },
        nil,-1)
    end

    if  __lua_project_id == __lua_project_yugioh then
        self:initCardInfo()
    end
    
    return self
end

function FightMap:reload(mapIndex, _npc_type)
    self._map_background_image_index = mapIndex
    self._npc_type = _npc_type
    
    self.csbMap:stopAllActions()
    self.actions = {}
    local action = csb.createTimeline("battle/battle_map.csb")
    -- action:setTimeSpeed(1.0 / __fight_recorder_action_time_speed)
    table.insert(self.actions, action)
    self.csbMap:runAction(action)
end

function FightMap:rootAtIndex(_index)
    return self.roots[1]
end

function FightMap:setTimeSpeed()
    -- local action = self.actions[1]
    -- action:setTimeSpeed(1.0 / __fight_recorder_action_time_speed)

    -- self.cacheFightArmature:getAnimation():setSpeedScale(1.0/__fight_recorder_action_time_speed)
    -- self._animation_ArmatureNode_4:setSpeedScale(1.0/__fight_recorder_action_time_speed)
end

function FightMap:playAnimationByHeroIntoNextFightMap(fightIndex)
    self._fightIndex = fightIndex
    self.cacheFightArmature._show = true
    self.cacheFightArmature:getAnimation():playWithIndex(2)
    self.cacheFightArmature:getAnimation()._nextAction = 1
    -- self.cacheFightArmature:getAnimation():setSpeedScale(1.0/__fight_recorder_action_time_speed)

    -- local root = self.roots[1]
    -- local Panel_battle_map_1 = ccui.Helper:seekWidgetByName(root, "Panel_battle_map_1")
    -- local ArmatureNode_1 = Panel_battle_map_1:getChildByName("ArmatureNode_1")
    -- local animation = ArmatureNode_1:getAnimation()
    -- animation:playWithIndex(0, 0, 0)

    -- if self.animation  == nil then    
    --     local function changeActionCallback1(armatureBack)
    --> print("+_+_+_+_")
    --         local armature = armatureBack
    --         if armature ~= nil then
    --             local actionIndex = armature._actionIndex
    --             if actionIndex == 0 then
    --                 armature._nextAction = 1
    --             elseif actionIndex == 1 then
    --             end
    --         end
    --     end
    --     self.animation = ArmatureNode_1
    --     draw.initArmature(animation, nil, 1, 0, 1)
    --> print("+_2+_+_+_")
    --     self.animation._invoke = changeActionCallback1
    --     self.animation._actionIndex = 0
    --     self.animation._nextAction = 1
    --     self.animation:getAnimation():playWithIndex(0)
    -- else
    --> print("+_1+_+_+_")
    --     self.animation._nextAction = 0
    -- end
    

end

function FightMap:playFightMapHeroNextGo()
    local action = self.actions[1]
    -- action:setTimeSpeed(1.0 / __fight_recorder_action_time_speed)
    local Panel_armaturenode_15_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_armaturenode_15_1")
    Panel_armaturenode_15_1:setVisible(false)

    action:play("hero_next_go", false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "hero_next_go" then
            --> print("武将移动结束，准备让敌方入场。")
            state_machine.excute("fight_hero_reset_over", 0, "all")
            -- version 1.1
            self._actionEndCount = self._actionEndCount + 1
            if self._actionEndCount == 1 then
                state_machine.excute("fight_draw_formation_ui", 0, 0)
            end
        end
    end)
end

function FightMap:playAnimationByHeroIntoFightMap(teamIndex)
    self._teamIndex = teamIndex

    if __lua_project_id == __lua_project_red_alert_time 
    	or __lua_project_id == __lua_project_pacific_rim 
	then
        return
    end

    local root = self.roots[1]
    -- local Panel_battle_map_1 = ccui.Helper:seekWidgetByName(root, "Panel_battle_map_1")
    -- local ArmatureNode_1 = Panel_battle_map_1:getChildByName("ArmatureNode_1")
    -- local animation = ArmatureNode_1:getAnimation()
    -- animation:playWithIndex(0, 0, 0)

    local Panel_armaturenode_15_2 = ccui.Helper:seekWidgetByName(root, "Panel_armaturenode_15_2")
    local ArmatureNode_4 = Panel_armaturenode_15_2:getChildByName("ArmatureNode_4")
    local animation_ArmatureNode_4 = ArmatureNode_4:getAnimation()
    --Panel_armaturenode_15_2:setVisible(true)
    animation_ArmatureNode_4:playWithIndex(0, 0, 1)
    animation_ArmatureNode_4:setSpeedScale(1.0/__fight_recorder_action_time_speed)
    self._animation_ArmatureNode_4 = animation_ArmatureNode_4

    local Panel_29717 = ccui.Helper:seekWidgetByName(root, "Panel_29717")
    local ArmatureNode_1 = Panel_29717:getChildByName("ArmatureNode_1")
    self.cacheFightArmature = ArmatureNode_1
    self.cacheFightArmature.Panel_armaturenode_15_2 = Panel_armaturenode_15_2
    
    local function changeActionCallback(armatureBack)
        local armature = armatureBack
        if armature ~= nil then
            local actionIndex = armature._actionIndex
            if actionIndex == 0 then
            elseif actionIndex == 1 then
                if self.cacheFightArmature._show == true then
                    -- armature._nextAction = 2
                    -- self.cacheFightArmature._show = false
                end
                self.cacheFightArmature.Panel_armaturenode_15_2:setVisible(true)
            elseif actionIndex == 2 then
                self.cacheFightArmature.Panel_armaturenode_15_2:setVisible(false)
                armature._nextAction = 1
            end
        end
    end

    if true == is2005 
        or __lua_project_id == __lua_project_digimon_adventure 
	or __lua_project_id == __lua_project_red_alert_time 
	or __lua_project_id == __lua_project_pacific_rim  
        or __lua_project_id == __lua_project_naruto 
        or __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge 
        or __lua_project_id == __lua_project_yugioh 
        then
        draw.initArmature(self.cacheFightArmature, nil, -1, 0, 1)
        self.cacheFightArmature._show = false
        self.cacheFightArmature._invoke = nil
        self.cacheFightArmature:getAnimation():playWithIndex(1, 1, 1)
        for i = 1 , self._teamIndex do
            if i == 1 then
                state_machine.excute("fight_draw_formation_ui", 0, 0)
            end
            state_machine.excute("fight_hero_into_over", 0, i)
        end
        Panel_armaturenode_15_2:setVisible(true)
        state_machine.excute("battle_create_into_fight_end", 0, "")
    else
        if self.cacheFightArmature._invoke == nil then
            draw.initArmature(self.cacheFightArmature, nil, -1, 0, 1)
        end
        self.cacheFightArmature._show = false
        self.cacheFightArmature._invoke = nil
        self.cacheFightArmature._actionIndex = 0
        self.cacheFightArmature:getAnimation():playWithIndex(0, 0, 1)
        -- self.cacheFightArmature:getAnimation():setSpeedScale(1.0/__fight_recorder_action_time_speed)
        self.cacheFightArmature._invoke = changeActionCallback
        self.cacheFightArmature._nextAction = 1


        local action = self.actions[1]
        -- action:setTimeSpeed(1.0 / __fight_recorder_action_time_speed)
        action:play(string.format("hero_ruchang_%s", self._teamIndex), false)
        action:setFrameEventCallFunc(function (frame)
            if nil == frame then
                return
            end

            local str = frame:getEvent()
            local pos = string.find(str, string.format("battle_move_end_%d", self._teamIndex))
            if pos ~= nil then
                local datas = zstring.split(str, "_")
                
                self._actionEndCount = self._actionEndCount + 1
                -- version 1.1
                if self._actionEndCount == 1 then
                    state_machine.excute("fight_draw_formation_ui", 0, 0)
                end
                state_machine.excute("fight_hero_into_over", 0, tonumber(datas[table.getn(datas)]))

                -- if self._actionEndCount == self._teamIndex then
                --     state_machine.excute("fight_master_into_start", 0, 0)
                -- end
            end
        end)
        
        if true == is2006 then
            state_machine.excute("battle_create_into_fight_end", 0, "")
        end
    end

end

function FightMap:playAnimationByMasterIntoFightMap(fightIndex)
    self._fightIndex = fightIndex

    self._actionEndCount = 0

    if __lua_project_id == __lua_project_red_alert_time 
    	or __lua_project_id == __lua_project_pacific_rim 
	then
        self:runAction(cc.Sequence:create(cc.DelayTime:create(2), cc.CallFunc:create(function (sender)
                state_machine.excute("fight_request_battle", 0, self._currentFightIndex)
                state_machine.excute("fight_map_fade_out_position_flag", 0, 0)
                state_machine.excute("fight_ui_show_keep_battle", 0, true)
            end)))
    else
        local root = self.roots[1]

        local action = self.actions[1]
        -- action:setTimeSpeed(1.0 / __fight_recorder_action_time_speed)
        action:play(string.format("difang_ruchang_%s", self._fightIndex), false)
        action:setFrameEventCallFunc(function (frame)
            if nil == frame then
                return
            end

            local str = frame:getEvent()
            local pos = string.find(str, string.format("difang_ruchang_over_%d", self._fightIndex))
            if pos ~= nil then
                -->print("怪物都已经出场完毕了。", self._fightIndex)
                -- version 1.0
                -- state_machine.excute("fight_draw_formation_ui", 0, 0)

                -- version 1.1
                if self.isMasterPet == true then
                    state_machine.excute("fight_master_play_pet_ready", 0, self._currentFightIndex)
                else
                    state_machine.excute("fight_request_battle", 0, self._currentFightIndex)
                end
            end
        end)
    end
end

function FightMap:playFadeOutPositionFlagAnimation()
    local root = self.roots[1]
    local Node_postion_bg = root:getChildByName("Node_postion_bg")
    Node_postion_bg:runAction(cc.FadeOut:create(4))
end

function FightMap:playAttackShakeAction()
    if nil ~= self._shake_action then
        return
    end
    self._shake_action = cc.Sequence:create(cc.MoveTo:create(0.08, cc.p(0, -3)), 
        cc.MoveTo:create(0.08, cc.p(0, 0)), 
        cc.CallFunc:create(function ( sender )
            sender._shake_action = nil
        end))
    self:runAction(self._shake_action)
end

function FightMap:playAttackBulletShakeAction( ... )
    if nil ~= self._shake_action then
        return
    end
    self._shake_action = cc.Sequence:create(cc.MoveTo:create(0.02, cc.p(0, -10)), 
        cc.MoveTo:create(0.08, cc.p(0, 0)), 
        cc.CallFunc:create(function ( sender )
            sender._shake_action = nil
        end))
    self:runAction(self._shake_action)
end

function FightMap:playJoinBattleShakeAction( nCount )
    if nil ~= self._join_shake_action then
        return
    end

    if nCount <= 0 then
        nCount = 9
    end

    local actions = {}
    for i=1, nCount do
        table.insert(actions, cc.DelayTime:create(0.1))
        table.insert(actions, cc.MoveTo:create(0.08, cc.p(0, -10)))
        table.insert(actions, cc.MoveTo:create(0.08, cc.p(0, 0)))
    end
    table.insert(actions, cc.CallFunc:create(function ( sender )
            sender._join_shake_action = nil
        end))
    self._join_shake_action = cc.Sequence:create(actions)
    self:runAction(self._join_shake_action)
end

function FightMap:playOutBattleShakeAction( nCount )
    if nil ~= self._join_shake_action then
        return
    end

    if nCount <= 0 then
        nCount = 10
    end

    local actions = {}
    for i=1, nCount do
        table.insert(actions, cc.DelayTime:create(0.2))
        table.insert(actions, cc.MoveTo:create(0.08, cc.p(0, -3)))
        table.insert(actions, cc.MoveTo:create(0.08, cc.p(0, 0)))
    end
    table.insert(actions, cc.CallFunc:create(function ( sender )
            sender._join_shake_action = nil
        end))
    self._join_shake_action = cc.Sequence:create(actions)
    self:runAction(self._join_shake_action)
end

function FightMap:getBackgroundPanel()
    local root = self.roots[1]
    local bg1 = ccui.Helper:seekWidgetByName(root, "Panel_battle_map_1")
    return bg1;
end

function FightMap:changeBackgroundImageOfMap(mapIndex)
    local root = self.roots[1]
    if __lua_project_id == __lua_project_red_alert_time
        then
        for i = 1, 6 do
            local childNode = root:getChildByName("Node_postion_enemy_" .. i)
            childNode:setPositionY(childNode:getPositionY() - app.baseOffsetY)
        end
        return
    elseif __lua_project_id == __lua_project_pacific_rim then
        for i = 1, 6 do
            local childNode = root:getChildByName("Node_postion_enemy_" .. i)
            childNode:setPositionY(childNode:getPositionY() - app.baseOffsetY / 2)
        end
        for i = 1, 6 do
            local childNode = root:getChildByName("Node_postion_" .. i)
            childNode:setPositionY(childNode:getPositionY() - app.baseOffsetY / 2)
        end
        return
    end
    local bg1 = ccui.Helper:seekWidgetByName(root, "Panel_29798")
    if nil ~= bg1 then
        bg1:removeBackGroundImage()
        bg1:setBackGroundImage("map/battle/battle_"..mapIndex.."_0.png")    
    end
    _ED.battle_map_imagePath = "map/battle/battle_"..mapIndex.."_0.png"
    -- bg1:removeAllChildren(true)
    -- local csbBg = csb.createNode("battle/map_"..mapIndex..".csb")
    -- bg1:addChild(csbBg)
end

function FightMap:onEnterTransitionFinish()

end

function FightMap:onExit()
    state_machine.remove("fight_map_attack_bullet_shake_action")
    state_machine.remove("fight_map_join_battle_shake_action")
    state_machine.remove("fight_map_out_battle_shake_action")
end
