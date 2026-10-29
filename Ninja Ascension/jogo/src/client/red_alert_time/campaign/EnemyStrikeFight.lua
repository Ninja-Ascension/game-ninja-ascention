--------------------------------------------------------------------------------------------------------------
--  说明：敌军来袭-战斗中
--------------------------------------------------------------------------------------------------------------
EnemyStrikeFight = class("EnemyStrikeFightClass", Window)

--打开界面
local enemy_strike_fight_open_terminal = {
	_name = "enemy_strike_fight_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        local panel = EnemyStrikeFight:new():init(params)
		fwin:open(panel)
        return panel
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(enemy_strike_fight_open_terminal)
state_machine.init()

function EnemyStrikeFight:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}

    self._showHurtRank = false
    self._showTimesRank = false
    self._Text_revive_time = nil
    self._Panel_boss_attack = nil
    self._Button_boss_attack_free = nil
    self._Text_revive_five_time = nil
    self._Text_revive_five_time_0 = nil
    self._showHurtBloodTime = 0

    self._move_panel = {}
    self._pos_info = {{1018, 710}, {-418, -218}}

    self._is_text_show = true
    self._text_moves = {}
    self._isDeath = false

    local function init_enemy_strike_fight_terminal()
        local enemy_strike_fight_show_terminal = {
            _name = "enemy_strike_fight_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local enemy_strike_fight_hide_terminal = {
            _name = "enemy_strike_fight_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local enemy_strike_fight_update_hp_info_terminal = {
            _name = "enemy_strike_fight_update_hp_info",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.roots ~= nil and instance.roots[1] ~= nil then
                    local isCheckReward = false
                    if params ~= nil and params ~= "" then
                        isCheckReward = params[1]
                    end
                    instance:updateDraw(isCheckReward)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local enemy_strike_fight_update_fight_info_terminal = {
            _name = "enemy_strike_fight_update_fight_info",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:showHurtAction(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local enemy_strike_fight_change_hurt_rank_state_terminal = {
            _name = "enemy_strike_fight_change_hurt_rank_state",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance._showHurtRank = not instance._showHurtRank
                instance:changeHurtRankState()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local enemy_strike_fight_change_times_rank_state_terminal = {
            _name = "enemy_strike_fight_change_times_rank_state",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance._showTimesRank = not instance._showTimesRank
                instance:changeTimesRankState()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local enemy_strike_fight_start_terminal = {
            _name = "enemy_strike_fight_start",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local isHaveSetFormation = false
                local formation_tabs = zstring.split(_ED.user_enemy_strike_info.formation_info, "|")
                for k, v in pairs(formation_tabs) do
                    local info_tabs = zstring.split(v, ",")
                    if tonumber(info_tabs[1]) > 0 then
                        isHaveSetFormation = true
                        break
                    end
                end
                if isHaveSetFormation == false then
                    TipDlg.drawTextDailog(formation_type_string[14])
                    return
                end
                local ntype = params._datas.ntype
                local cost = 0
                local cost_info = zstring.split(dms.string(dms["enemy_boss_config"], 3, enemy_boss_config.param), ",")
                if ntype == 2 then
                    cost = cost_info[2]
                    local time_info = zstring.split(dms.string(dms["enemy_boss_config"], 2, enemy_boss_config.param), ",")
                    local fiveTickTime = math.ceil(_ED.user_enemy_strike_info.five_attack_cd/1000 + tonumber(time_info[2]) - (os.time() + _ED.time_add_or_sub))
                    if fiveTickTime > 0 then
                        TipDlg.drawTextDailog(tipStringInfo_campaign_info[15])
                        return
                    end
                end
                if ntype == 0 then
                    local time_info = zstring.split(dms.string(dms["enemy_boss_config"], 2, enemy_boss_config.param), ",")
                    local onceTickTime = math.ceil(_ED.user_enemy_strike_info.once_attack_cd/1000 + tonumber(time_info[1]) - (os.time() + _ED.time_add_or_sub))
                    if onceTickTime > 0 then
                        cost = cost_info[1]
                        local tip = ConfirmTip:new()
                        tip:init(instance, instance.sureFight, string.format(tipStringInfo_campaign_info[31], cost))
                        fwin:open(tip,fwin._windows)
                        return 
                    end
                end
                if tonumber(cost) > tonumber(_ED.user_info.user_gold) then
                    TipDlg.drawTextDailog(tipStringInfo_campaign_info[16])
                    return
                end
                _ED._battle_init_type = battle_enum._fight_type._fight_type_204
                _ED._current_scene_id = 0
                _ED._scene_npc_id = 0
                _ED._npc_difficulty_index = ntype
                state_machine.excute("adventure_mine_request_battle_field_init", 0, {_ED._battle_init_type, _ED._current_scene_id, _ED._scene_npc_id, ntype, 0, ""})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local enemy_strike_fight_send_message_terminal = {
            _name = "enemy_strike_fight_send_message",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local Panel_chat_view = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_chat_view")
                local posX = Panel_chat_view:getContentSize().width
                local posY = math.random(50,Panel_chat_view:getContentSize().height - 50)
                local color_index = math.floor(math.random(1, 6))
                local message = params.send_information_name..":"..params.information_content
                local fontSize = 24
                local label = cc.Label:createWithTTF(message, config_res.font.font_name, fontSize)
                label:setAnchorPoint(cc.p(0, 0.5))
                label:setPosition(cc.p(posX, posY))
                label:setColor(chat_rich_text_color[color_index])
                label:enableOutline(cc.c4b(0, 0, 0, 255), 1)
                Panel_chat_view:addChild(label)

                table.insert(instance._text_moves, label)
                label:setVisible(instance._is_text_show)

                local width = label:getContentSize().width

                local function callback(sender)
                    for i, v in pairs(instance._text_moves) do
                        if v == sender then
                            table.remove(instance._text_moves, i)
                            break
                        end
                    end
                    sender:removeFromParent(true)
                end

                local end_posX = 0 - width
                label:runAction(cc.Sequence:create(cc.MoveTo:create(5, cc.p(end_posX, posY)),
                    cc.CallFunc:create(callback)
                    ))

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 开关弹幕
        local enemy_strike_fight_switch_show_text_terminal = {
            _name = "enemy_strike_fight_switch_show_text",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance._is_text_show = params
                for k, v in pairs(self._text_moves) do
                    v:setVisible(instance._is_text_show)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local enemy_strike_fight_update_rank_list_terminal = {
            _name = "enemy_strike_fight_update_rank_list",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:changeTimesRankState()
                    instance:changeHurtRankState()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local enemy_strike_fight_update_user_fight_info_terminal = {
            _name = "enemy_strike_fight_update_user_fight_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:updateUserFightInfo()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(enemy_strike_fight_show_terminal)
        state_machine.add(enemy_strike_fight_hide_terminal)
        state_machine.add(enemy_strike_fight_update_hp_info_terminal)
        state_machine.add(enemy_strike_fight_update_fight_info_terminal)
        state_machine.add(enemy_strike_fight_change_hurt_rank_state_terminal)
        state_machine.add(enemy_strike_fight_change_times_rank_state_terminal)
        state_machine.add(enemy_strike_fight_start_terminal)
        state_machine.add(enemy_strike_fight_send_message_terminal)
        state_machine.add(enemy_strike_fight_switch_show_text_terminal)
        state_machine.add(enemy_strike_fight_update_rank_list_terminal)
        state_machine.add(enemy_strike_fight_update_user_fight_info_terminal)
        state_machine.init()
    end
    
    init_enemy_strike_fight_terminal()
end

function EnemyStrikeFight:sureFight(sure_number)
    if sure_number == 0 then
        local time_info = zstring.split(dms.string(dms["enemy_boss_config"], 2, enemy_boss_config.param), ",")
        local onceTickTime = math.ceil(_ED.user_enemy_strike_info.once_attack_cd/1000 + tonumber(time_info[1]) - (os.time() + _ED.time_add_or_sub))
        if onceTickTime <= 0 then       -- 部队已到达
            return
        end

        local ntype = 1
        _ED._battle_init_type = battle_enum._fight_type._fight_type_204
        _ED._current_scene_id = 0
        _ED._scene_npc_id = 0
        _ED._npc_difficulty_index = ntype
        state_machine.excute("adventure_mine_request_battle_field_init", 0, {_ED._battle_init_type, _ED._current_scene_id, _ED._scene_npc_id, ntype, 0, ""})
    end
end

function EnemyStrikeFight:changeHurtRankState(  )
    local root = self.roots[1]
    local Panel_enemy_hurt_rank = ccui.Helper:seekWidgetByName(root, "Panel_enemy_hurt_rank")
    local ListView_enemy_hurt_rank = ccui.Helper:seekWidgetByName(root, "ListView_enemy_hurt_rank")
    -- local Image_enemy_hurt_rank_arrow = ccui.Helper:seekWidgetByName(root, "Image_enemy_hurt_rank_arrow")
    -- local Image_enemy_hurt_rank_arrow_0 = ccui.Helper:seekWidgetByName(root, "Image_enemy_hurt_rank_arrow_0")
    ListView_enemy_hurt_rank:jumpToTop()
    ListView_enemy_hurt_rank:removeAllItems()

    if _ED.user_enemy_strike_boss_info ~= nil and _ED.user_enemy_strike_boss_info.hurt_list ~= nil then
        local result = {}
        for k, v in pairs(_ED.user_enemy_strike_boss_info.hurt_list) do
            table.insert(result, v)
        end
        local function sortFunction (a, b)
            return tonumber(a.total_hurt) > tonumber(b.total_hurt)
        end
        table.sort(result, sortFunction)
        for k, v in pairs(result) do
            if k > 10 then
                break
            end
            local cell = state_machine.excute("enemy_strike_fight_rank_create_cell", 0, {k, v, 1})
            ListView_enemy_hurt_rank:addChild(cell)
        end
        ListView_enemy_hurt_rank:requestRefreshView()
    end
end

function EnemyStrikeFight:changeTimesRankState(  )
    local root = self.roots[1]
    local Panel_enemy_join_rank = ccui.Helper:seekWidgetByName(root, "Panel_enemy_join_rank")
    local ListView_enemy_join_rank = ccui.Helper:seekWidgetByName(root, "ListView_enemy_join_rank")
    -- local Image_enemy_join_rank_arrow = ccui.Helper:seekWidgetByName(root, "Image_enemy_join_rank_arrow")
    -- local Image_enemy_join_rank_arrow_0 = ccui.Helper:seekWidgetByName(root, "Image_enemy_join_rank_arrow_0")
    ListView_enemy_join_rank:jumpToTop()
    ListView_enemy_join_rank:removeAllItems()

    if _ED.user_enemy_strike_boss_info ~= nil and _ED.user_enemy_strike_boss_info.join_list ~= nil then
        local result = {}
        for k, v in pairs(_ED.user_enemy_strike_boss_info.join_list) do
            table.insert(result, v)
        end
        local function sortFunction (a, b)
            return tonumber(a.total_times) > tonumber(b.total_times)
        end
        table.sort(result, sortFunction)
        for k, v in pairs(result) do
            if k > 10 then
                break
            end
            local cell = state_machine.excute("enemy_strike_fight_rank_create_cell", 0, {k, v, 2})
            ListView_enemy_join_rank:addChild(cell)
        end
        ListView_enemy_join_rank:requestRefreshView()
    end
end

function EnemyStrikeFight:updateUserFightInfo()
    local root = self.roots[1]
    local Text_enemy_all_hurt_n = ccui.Helper:seekWidgetByName(root, "Text_enemy_all_hurt_n")
    local Text_enemy_join_all_n = ccui.Helper:seekWidgetByName(root, "Text_enemy_join_all_n")
    Text_enemy_all_hurt_n:setString(exChangeNumToString(_ED.user_enemy_strike_info.hurt_value))
    Text_enemy_join_all_n:setString(_ED.user_enemy_strike_info.join_times)
end

function EnemyStrikeFight:updateDraw(isCheckReward)
    local root = self.roots[1]
    -- self._move_panel = {ccui.Helper:seekWidgetByName(root, "Panel_boss_map_effect"),
    --     ccui.Helper:seekWidgetByName(root, "Panel_boss_map_effect_0")}
    local LoadingBar_enemy_bar = ccui.Helper:seekWidgetByName(root, "LoadingBar_enemy_bar")
    local Text_14 = ccui.Helper:seekWidgetByName(root, "Text_14")
    self._Text_revive_time = ccui.Helper:seekWidgetByName(root, "Text_revive_time")
    self._Text_14 = Text_14
    self._Panel_boss_attack = ccui.Helper:seekWidgetByName(root, "Panel_boss_attack")
    self._Button_attack = ccui.Helper:seekWidgetByName(root, "Button_attack")
    self._Text_revive_five_time = ccui.Helper:seekWidgetByName(root, "Text_revive_five_time")
    self._Text_revive_five_time_0 = ccui.Helper:seekWidgetByName(root, "Text_revive_five_time_0")
    local LoadingBar_enemy_bar = ccui.Helper:seekWidgetByName(root, "LoadingBar_enemy_bar")

    local percent = 0
    local less_boss_index = 0
    for k,v in pairs(_ED.user_enemy_strike_boss_info.boss_info) do
        if v.current_hp >= v.total_hp then
            percent = percent + 20
        elseif v.current_hp > 0 then
            local current_percent = math.floor(v.current_hp * 20/v.total_hp)
            percent = percent + current_percent
            if current_percent <= dms.int(dms["enemy_boss_config"], 11, enemy_boss_config.param) then
                less_boss_index = k
            end
        end
    end
    LoadingBar_enemy_bar:setPercent(percent)
    local isAddPartDamage = false
    for i=1,5 do
        local Panel_part_damage_effect = ccui.Helper:seekWidgetByName(root, "Panel_part_damage_effect_"..i)
        Panel_part_damage_effect:removeAllChildren(true)
        if less_boss_index == i then
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_bosscome_light)
            local armature = ccs.Armature:create("effect_bosscome_light")
            armature:getAnimation():playWithIndex(0)
            armature:setPosition(cc.p(Panel_part_damage_effect:getContentSize().width/2, Panel_part_damage_effect:getContentSize().height/2))
            Panel_part_damage_effect:addChild(armature)
            isAddPartDamage = true
        end
    end
    self:checkCDTime()
    -- self:showDamageAction(isAddPartDamage)
    self:changeHurtRankState()
    self:changeTimesRankState()
    self:updateUserFightInfo()
    -- if _ED.user_enemy_strike_info.reward_info ~= "" and isCheckReward == true then
    --     state_machine.excute("enemy_strike_reward_window_open", 0, nil)
    -- end
end

-- function EnemyStrikeFight:showTankEffect( ... )
--     local root = self.roots[1]
--     local boss_index = 1
--     for k,v in pairs(_ED.user_enemy_strike_boss_info.boss_info) do
--         if v.total_hp > 0 and v.total_hp > v.current_hp then
--             boss_index = k
--         end
--         if v.current_hp == 0 then
--             boss_index = k + 1
--         end
--     end
--     if boss_index >= 6 then
--         boss_index = 0
--         self._isDeath = true
--     end
--     local Panel_boss_tank_effect = ccui.Helper:seekWidgetByName(root, "Panel_boss_tank_effect")
--     Panel_boss_tank_effect:removeAllChildren(true)
--     ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_boss)
--     local armature = ccs.Armature:create("effect_boss")
--     armature:getAnimation():playWithIndex(boss_index)
--     armature:setPosition(cc.p(Panel_boss_tank_effect:getContentSize().width/2, Panel_boss_tank_effect:getContentSize().height/2))
--     Panel_boss_tank_effect:addChild(armature)

--     local Panel_boss_tank_attack_effect = ccui.Helper:seekWidgetByName(root, "Panel_boss_tank_attack_effect")
--     Panel_boss_tank_attack_effect:removeAllChildren(true)
--     ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_boss_attack)
--     local armature = ccs.Armature:create("effect_boss_attack")
--     armature:getAnimation():playWithIndex(0)
--     armature:setPosition(cc.p(Panel_boss_tank_attack_effect:getContentSize().width/2, Panel_boss_tank_attack_effect:getContentSize().height/2))
--     Panel_boss_tank_attack_effect:addChild(armature)
-- end

function EnemyStrikeFight:showHurtAction( isCheckType )
    local root = self.roots[1]
    if _ED.user_enemy_strike_update_info == nil then
        return
    end
    if isCheckType == true then
        if _ED.user_enemy_strike_update_info.is_show == false
            and _ED.user_enemy_strike_update_info.hurt_type == 0 then
            _ED.user_enemy_strike_update_info.is_show = true
            state_machine.excute("enemy_strike_blood_create", 0, {_ED.user_enemy_strike_update_info.hurt_value, self})
        end
    else
        if _ED.user_enemy_strike_update_info.is_show == false
            and _ED.user_enemy_strike_update_info.hurt_type ~= 0 then
            _ED.user_enemy_strike_update_info.is_show = true
            if _ED.user_enemy_strike_update_info.hurt_type == 1 then
                state_machine.excute("enemy_strike_five_hurt_create", 0, {_ED.user_enemy_strike_update_info.hurt_value})
            else
                self:showSpecialEffect(_ED.user_enemy_strike_update_info.hurt_type, _ED.user_enemy_strike_update_info.hurt_value, _ED.user_enemy_strike_update_info.boss_index, _ED.user_enemy_strike_update_info.user_name)
            end
        end
    end
end

-- 特殊伤害类动画
function EnemyStrikeFight:showSpecialEffect( ntype, hurt, boss_index, hurt_name )
    local root = self.roots[1]
    local Panel_battle_state = ccui.Helper:seekWidgetByName(root, "Panel_battle_state")
    local Panel_battle_state_effect = ccui.Helper:seekWidgetByName(root, "Panel_battle_state_effect")
    local Text_best_hurt_player_name = ccui.Helper:seekWidgetByName(root, "Text_best_hurt_player_name")
    Panel_battle_state:setOpacity(255)
    Panel_battle_state:stopAllActions()
    if Panel_battle_state._armature ~= nil then
        Panel_battle_state._armature:removeFromParent(true)
        Panel_battle_state._armature = nil
        Text_best_hurt_player_name:setString(hurt_name)
    end
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_boss_damage)
    local armature = ccs.Armature:create("effect_boss_damage")
    local function onFrameEvent(bone,evt,originFrameIndex,currentFrameIndex)
        local armature = bone:getArmature()
        if evt == "over" and self.roots ~= nil and self.roots[1] ~= nil then
            local fadeOutEndCallBack = cc.CallFunc:create(function()
                Panel_battle_state._armature:removeFromParent(true)
                Panel_battle_state._armature = nil
                Text_best_hurt_player_name:setString(hurt_name)
                if _ED.user_enemy_strike_boss_info.state == 0 
                    or self._isDeath == true 
                    or (ntype == 3 and boss_index == 4) then
                    _ED.user_enemy_strike_boss_info.state = 0
                    state_machine.excute("enemy_strike_update_state_info", 0, nil)
                    state_machine.excute("enemy_strike_world_box_update_state_info", 0, nil)
                end
            end)
            Panel_battle_state:runAction(cc.Sequence:create(cc.FadeOut:create(0.3), fadeOutEndCallBack))
        end
    end
    draw.initArmature(armature, nil, -1, 0, 1)
    armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    armature:getAnimation():setFrameEventCallFunc(onFrameEvent)
    Panel_battle_state._armature = armature

    if ntype == 3 then
        if boss_index == 4 then
            self._isDeath = true
            armature:getAnimation():playWithIndex(1)
        else
            armature:getAnimation():playWithIndex(0)
        end
        Text_best_hurt_player_name:setString(hurt_name)
    else
        armature:getAnimation():playWithIndex(2)
        Text_best_hurt_player_name:setString(hurt_name)
    end
    checkPlayEffect(63)
    armature:setPosition(cc.p(Panel_battle_state_effect:getContentSize().width/2, Panel_battle_state_effect:getContentSize().height/2))
    Panel_battle_state_effect:addChild(armature)
end

--部位即将被破坏（红屏动画）
function EnemyStrikeFight:showDamageAction( isAdd )
    local root = self.roots[1]
    local Panel_boss_damage_time_effect = ccui.Helper:seekWidgetByName(root, "Panel_boss_damage_time_effect")
    Panel_boss_damage_time_effect:removeAllChildren(true)
    if isAdd == true then
        checkPlayEffect(71)
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_boss_damage_time)
        local armature = ccs.Armature:create("effect_boss_damage_time")
        armature:getAnimation():playWithIndex(0)
        armature:setPosition(cc.p(Panel_boss_damage_time_effect:getContentSize().width/2, Panel_boss_damage_time_effect:getContentSize().height/2))
        Panel_boss_damage_time_effect:addChild(armature)
    end
end

function EnemyStrikeFight:checkCDTime( ... )
    local time_info = zstring.split(dms.string(dms["enemy_boss_config"], 2, enemy_boss_config.param), ",")
    local onceTickTime = math.ceil(_ED.user_enemy_strike_info.once_attack_cd/1000 + tonumber(time_info[1]) - (os.time() + _ED.time_add_or_sub))
    if onceTickTime > 0 then
        self._Text_14:setVisible(true)
        self._Text_revive_time:setString(onceTickTime.."s")
        self._Button_attack:setTitleText(red_alert_time_str[300])
    else
        self._Text_14:setVisible(false)
        self._Text_revive_time:setString("")
        self._Button_attack:setTitleText(formation_type_string[13])
    end
    local fiveTickTime = math.ceil(_ED.user_enemy_strike_info.five_attack_cd/1000 + tonumber(time_info[2]) - (os.time() + _ED.time_add_or_sub))
    if fiveTickTime > 0 then
        self._Text_revive_five_time:setString(fiveTickTime.."s")
        self._Text_revive_five_time_0:setVisible(true)
    else
        self._Text_revive_five_time:setString("")
        self._Text_revive_five_time_0:setVisible(false)
    end
end

function EnemyStrikeFight:onUpdate( dt )
    self._showHurtBloodTime = self._showHurtBloodTime + dt
    if self._showHurtBloodTime >= 1 then
        self._showHurtBloodTime = 0
        self:showHurtAction(true)
    end
    -- for k,v in pairs(self._move_panel) do
    --     if v:getPositionX() >= self._pos_info[1][1] and v:getPositionY() >= self._pos_info[1][2] then
    --         v:setPosition(cc.p(self._pos_info[2][1], self._pos_info[2][2]))
    --     end
    --     v:setPosition(cc.p(v:getPositionX() + 1.436 * 4, v:getPositionY() + 0.928 * 4))
    -- end
    self:checkCDTime()
end

--初始化
function EnemyStrikeFight:onInit()
    local csbItem = csb.createNode(string.format(config_csb.campaign.enemy_strike_tab, 2))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_attack_five"), nil, 
    {
        terminal_name = "enemy_strike_fight_start", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        ntype = 2,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_attack"), nil, 
    {
        terminal_name = "enemy_strike_fight_start", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        ntype = 0,
    }, nil, 1)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_enemy_set_formation"), nil, 
    {
        terminal_name = "enemy_strike_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        _page = 3,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_enemy_hurt_rank"), nil, 
    {
        terminal_name = "enemy_strike_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        _page = 4,
    }, nil, 1)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_enemy_attack_time"), nil, 
    {
        terminal_name = "enemy_strike_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        _page = 6,
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_enemy_strike_reward",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_enemy_attack_time"),
        _invoke = nil,
        _interval = 0.2,})

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_window_bg"), nil, 
    {
        terminal_name = "enemy_strike_world_box_close", 
        terminal_state = 0, 
    }, nil, 3)

    self:updateDraw()
end

function EnemyStrikeFight:onEnterTransitionFinish()

end

function EnemyStrikeFight:init(param)
    self._rootWindows = param[1]
	self:onInit()
    return self
end

function EnemyStrikeFight:onExit()
    state_machine.remove("enemy_strike_fight_show")
    state_machine.remove("enemy_strike_fight_hide")
    state_machine.remove("enemy_strike_fight_update_hp_info")
    state_machine.remove("enemy_strike_fight_update_fight_info")
    state_machine.remove("enemy_strike_fight_change_hurt_rank_state")
    state_machine.remove("enemy_strike_fight_change_times_rank_state")
    state_machine.remove("enemy_strike_fight_start")
    state_machine.remove("enemy_strike_fight_send_message")
    state_machine.remove("enemy_strike_fight_switch_show_text")
    state_machine.remove("enemy_strike_fight_update_rank_list")
    state_machine.remove("enemy_strike_fight_update_user_fight_info")
end