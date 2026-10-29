-- ----------------------------------------------------------------------------------
-- QuickTimeEvent
-- ----------------------------------------------------------------------------------
FightQTEController= class("FightQTEControllerClass", Window)

local fight_qte_controller_open_window_terminal = {
    _name = "fight_qte_controller_open_window",
    _init = function (terminal)
        app.load("client.cells.battle.battle_qte_head_cell")
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local window = fwin:find("FightQTEControllerClass")
        if window == nil then
            window = FightQTEController:new():init(params)
            fwin:open(window, fwin._view)
        end
        return window
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(fight_qte_controller_open_window_terminal)
state_machine.init()

function FightQTEController:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.csbFightQTEController = nil

    self.domains = {}
    self.listView = nil
    self.lianjiRoot = nil
    self.qteing = false
    self.score = 0
    self.scroeCount = 0
    self.totalHurt = 0
    self.auto_intervel = 2
    self.isShake = false

    self.missionState = 0

    self.currentPos = {}
    self:onLoad()

    -- Initialize fight qte controller state machine.
    local function init_fight_qte_controller_terminal()
        local fight_qte_controller_manager_terminal = {
            _name = "fight_qte_controller_manager",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_qte_controller_add_role_terminal = {
            _name = "fight_qte_controller_add_role",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:addRole(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_qte_controller_role_by_active_terminal = {
            _name = "fight_qte_controller_role_by_active",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:roleByActive(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_qte_controller_init_role_qte_state_terminal = {
            _name = "fight_qte_controller_init_role_qte_state",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:initRoundRoleQteState(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_qte_controller_start_qte_active_terminal = {
            _name = "fight_qte_controller_start_qte_active",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:startQTEActive(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_qte_controller_start_qte_isVisible_terminal = {
            _name = "fight_qte_controller_start_qte_isVisible",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.roots and instance.roots[2] then
                    local qteLayer = ccui.Helper:seekWidgetByName(instance.roots[2], "Panel_head_dh")
                    return qteLayer:isVisible()
                end

            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_qte_controller_qte_to_next_attack_role_terminal = {
            _name = "fight_qte_controller_qte_to_next_attack_role",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("fight_role_controller_begin_mission", 0, {0, false})
                instance:qteToNextAttackRole(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_qte_controller_qte_to_next_attack_role_lock_terminal = {
            _name = "fight_qte_controller_qte_to_next_attack_role_lock",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local items = instance.listView:getItems()
                for i, v in pairs(items) do
                    local root = v.roots[1]
                    local status = v.status
                    v._e_lock = true
                    local Panel_hand_head = ccui.Helper:seekWidgetByName(root, "Panel_hand_head")
                    Panel_hand_head:setOpacity(130)
                end
                state_machine.lock("fight_qte_controller_qte_to_next_attack_role")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_qte_controller_qte_to_next_attack_role_unlock_terminal = {
            _name = "fight_qte_controller_qte_to_next_attack_role_unlock",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if true ~= params and instance._is_begin_power_skill_lock ~= true then
                    return false
                end
                local items = instance.listView:getItems()
                for i, v in pairs(items) do
                    local root = v.roots[1]
                    local status = v.status
                    v._e_lock = false
                    local Panel_hand_head = ccui.Helper:seekWidgetByName(root, "Panel_hand_head")
                    Panel_hand_head:setOpacity(255)
                end
                state_machine.unlock("fight_qte_controller_qte_to_next_attack_role")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_qte_controller_qte_to_auto_next_attack_role_terminal = {
            _name = "fight_qte_controller_qte_to_auto_next_attack_role",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
                    or __lua_project_id == __lua_project_l_naruto 
                    then
                    if true == FightRoleController.__lock_battle then
                        return false
                    end
                    if nil ~= params 
                        and type(params) == "userdata"
                        and nil ~= params._datas  
                        and true == params._datas.check_auto_select 
                        then
                        local auto_select = state_machine.excute("fight_role_controller_auto_select", 0, 0)
                        if true == auto_select then
                            return false
                        end
                    end
                    if instance.missionState == 14 then
                        instance.missionState = 15
                        __________b = true
                        fwin:addService({
                            callback = function ( params )
                                instance.missionState = 0
                                state_machine.excute("battle_resume", 0, 0)
                                state_machine.excute("fight_qte_controller_qte_to_auto_next_attack_role", 0, 0)
                            end,
                            delay = 0,
                            params = nil
                        })
                        return true
                    else
                        if instance.missionState > 0 then
                            params._one_called = false
                            return false
                        end
                    end
                end
                
                state_machine.excute("fight_role_controller_begin_mission", 0, {0, false})

                instance:qteToAutoNextAttackRole(params)

                state_machine.lock("fight_qte_controller_qte_to_auto_next_attack_role_but")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_qte_controller_qte_to_auto_next_attack_role_but_terminal = {
            _name = "fight_qte_controller_qte_to_auto_next_attack_role_but",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if true == terminal._nc then
                    terminal._nc = false
                    return false
                end
                if true == instance._FightRoleController.auto_select then
                    return false
                end
                state_machine.unlock("fight_qte_controller_qte_to_auto_next_attack_role")
                state_machine.excute("fight_qte_controller_qte_to_auto_next_attack_role", instance, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_qte_controller_qte_hide_progress_terminal = {
            _name = "fight_qte_controller_qte_hide_progress",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:changeQteProgressToHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_qte_controller_update_fight_comkill_info_terminal = {
            _name = "fight_qte_controller_update_fight_comkill_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateFightComKillInfo(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_qte_controller_update_fight_score_info_terminal = {
            _name = "fight_qte_controller_update_fight_score_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- instance.totalHurt = params[1]
                -- local comKillCount = params[2]
                -- if comKillCount == 1 then
                --     instance:updateFightScoreInfo(params)
                -- end

                -- if nil ~= params[1] and params[1] > 0 then
                --     instance:updateFightScoreInfo(params[1])
                -- end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_qte_controller_enter_auto_fight_terminal = {
            _name = "fight_qte_controller_enter_auto_fight",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:enterAutoFight(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_qte_controller_enter_next_auto_fight_terminal = {
            _name = "fight_qte_controller_enter_next_auto_fight",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:checkOneHeadFightSuccess(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_qte_controller_play_pinjia_ani_terminal = {
            _name = "fight_qte_controller_play_pinjia_ani",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:playPinJiaAni(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_qte_controller_reset_fight_head_terminal = {
            _name = "fight_qte_controller_reset_fight_head",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:resetHeadView(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_qte_controller_get_qte_state_terminal = {
            _name = "fight_qte_controller_get_qte_state",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return instance:getCurrentQteState(params)
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_qte_controller_shake_ui_terminal = {
            _name = "fight_qte_controller_shake_ui",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:startShakeUI(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_qte_controller_progress_continue_play_terminal = {
            _name = "fight_qte_controller_progress_continue_play",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                cc.Director:getInstance():getActionManager():resumeTarget(self.csbFightQTEController)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_qte_controller_change_mission_state_terminal = {
            _name = "fight_qte_controller_change_mission_state",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.missionState = params
                instance._fury_perfect_hecho = false -- Fury 4-oct: nueva espera de enter_perfect
                if zstring.tonumber(params) > 0 then
                    FightRoleController.__lock_battle = true
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_qte_controller_change_visible_terminal = {
            _name = "fight_qte_controller_change_visible",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_qte_controller_update_role_cell_state_terminal = {
            _name = "fight_qte_controller_update_role_cell_state",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateRoleCellState(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 绘制绝对的总伤害信息
        local fight_qte_controller_update_draw_power_skill_total_damage_terminal = {
            _name = "fight_qte_controller_update_draw_power_skill_total_damage",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDrawPowerSkillTotalDamage(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 取消UI信息的加速
        local fight_qte_controller_change_time_speed_terminal = {
            _name = "fight_qte_controller_change_time_speed",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:changeTimeSpeed(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 初始化连击动画
        local fight_qte_controller_on_init_with_role_layer_terminal = {
            _name = "fight_qte_controller_on_init_with_role_layer",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onInitWithRoleLayer(params[1], params[2], params[3])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_qte_controller_qte_to_auto_chram_attack_role_terminal = {
            _name = "fight_qte_controller_qte_to_auto_chram_attack_role",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:qteToAutoChramAttackRole()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_qte_controller_qte_to_auto_animal_start_attack_terminal = {
            _name = "fight_qte_controller_qte_to_auto_animal_start_attack",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local canAttack, canAttackAnimal, dIndex = false, nil, -1

                local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.MythicalAnimals)
                if fun_is_open == true then
                    canAttack, canAttackAnimal, dIndex = instance:qteToAutoAnimalAttackRole()
                end
                return canAttack, canAttackAnimal, dIndex
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 设置指引位置
        local fight_qte_controller_save_guide_perfect_pos_terminal = {
            _name = "fight_qte_controller_save_guide_perfect_pos",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.roots[2] then
                    local Image_10 = ccui.Helper:seekWidgetByName(instance.roots[2], "Image_10")
                    _ED._PerfectPos = fwin:convertToWorldSpaceAR(Image_10, cc.p(0, 0))
                end
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 清空指引位置
        local fight_qte_controller_unsave_guide_perfect_pos_terminal = {
            _name = "fight_qte_controller_unsave_guide_perfect_pos",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                _ED._PerfectPos = nil
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(fight_qte_controller_manager_terminal)
        state_machine.add(fight_qte_controller_add_role_terminal)
        state_machine.add(fight_qte_controller_role_by_active_terminal)
        state_machine.add(fight_qte_controller_init_role_qte_state_terminal)
        state_machine.add(fight_qte_controller_start_qte_active_terminal)
        state_machine.add(fight_qte_controller_qte_to_next_attack_role_terminal)
        state_machine.add(fight_qte_controller_qte_to_next_attack_role_lock_terminal)
        state_machine.add(fight_qte_controller_qte_to_next_attack_role_unlock_terminal)
        state_machine.add(fight_qte_controller_qte_to_auto_next_attack_role_terminal)
        state_machine.add(fight_qte_controller_qte_to_auto_next_attack_role_but_terminal)
        state_machine.add(fight_qte_controller_qte_hide_progress_terminal)
        state_machine.add(fight_qte_controller_update_fight_comkill_info_terminal)
        state_machine.add(fight_qte_controller_enter_auto_fight_terminal)
        state_machine.add(fight_qte_controller_enter_next_auto_fight_terminal)
        state_machine.add(fight_qte_controller_update_fight_score_info_terminal)
        state_machine.add(fight_qte_controller_play_pinjia_ani_terminal)
        state_machine.add(fight_qte_controller_reset_fight_head_terminal)
        state_machine.add(fight_qte_controller_get_qte_state_terminal)
        state_machine.add(fight_qte_controller_shake_ui_terminal)
        state_machine.add(fight_qte_controller_progress_continue_play_terminal)
        state_machine.add(fight_qte_controller_change_mission_state_terminal)
        state_machine.add(fight_qte_controller_change_visible_terminal)
        state_machine.add(fight_qte_controller_update_role_cell_state_terminal)
        state_machine.add(fight_qte_controller_update_draw_power_skill_total_damage_terminal)
        state_machine.add(fight_qte_controller_change_time_speed_terminal)
        state_machine.add(fight_qte_controller_on_init_with_role_layer_terminal)
        state_machine.add(fight_qte_controller_start_qte_isVisible_terminal)
        state_machine.add(fight_qte_controller_qte_to_auto_chram_attack_role_terminal)
        state_machine.add(fight_qte_controller_qte_to_auto_animal_start_attack_terminal)
        state_machine.add(fight_qte_controller_save_guide_perfect_pos_terminal)
        state_machine.add(fight_qte_controller_unsave_guide_perfect_pos_terminal)

        
        state_machine.init()
    end

    -- call func init fight qte controller state machine.
    init_fight_qte_controller_terminal()
end

function FightQTEController:init(isPvEFight)
    self.isPvEType = isPvEFight
    return self
end

-- 添加角色头像控件
function FightQTEController:addRole(params)
    local tempCell = BattleQTEHeadCell:createCell()
    tempCell:init(params)

    if params and params._isAnimal == true then
        tempCell:setVisible(false)
        if params.roleCamp == 0 then
            self.animalListView:addChild(tempCell)
        end
        return
    end

    self.listView:addChild(tempCell)
    if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_211 then
        tempCell:setVisible(false)
    end

    -- 更新ListView的宽度
    local items = self.listView:getItems()
    local lsize = self.listView:getContentSize()
    local size = tempCell:getContentSize()
    local margin = self.listView:getItemsMargin()
    local twidth = 0
    local totalCount = #items
    for i, v in pairs(items) do
        local w = v:getContentSize().width
        twidth = twidth + w
        if i == totalCount then
            v:setLastCell(true)
        else
            v:setLastCell(false)
        end
    end
    twidth = twidth + (totalCount - 1) * margin
    self.listView:setContentSize(cc.size(twidth, lsize.height))
    
    local root = self.roots[1]
    local image_6 = ccui.Helper:seekWidgetByName(root, "Image_6")
    image_6:setContentSize(cc.size(twidth + 30, image_6:getContentSize().height))
    self.listView:refreshView()
    -- state_machine.excute("battle_qte_head_update_draw", 0, {cell = tempCell, status = "dizziness"})
end

function FightQTEController:getCurrentQteState( params )
    return self.qteing
end

function FightQTEController:resetHeadView( ... )
    self.listView:removeAllChildren(true)
end

function FightQTEController:roleByActive(params)
    local activeState = params
    local items = self.listView:getItems()
    for i, v in pairs(items) do
        state_machine.excute("fight_ui_update_heti_skill_state", 0, {cell = v.armature, status = 1})
        state_machine.excute("battle_qte_head_update_draw", 0, {cell = v, status = activeState})
    end
    if activeState == "active" then
        local root = self.roots[1]

        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then

        else
            local Panel_shouchaojihuo = ccui.Helper:seekWidgetByName(root, "Panel_shouchaojihuo")
            Panel_shouchaojihuo:setVisible(true)
            local ArmatureNode_12 = Panel_shouchaojihuo:getChildByName("ArmatureNode_12")
            local animation = ArmatureNode_12:getAnimation()
            animation:playWithIndex(0, 0, 0)
        end
    end
end

-- 播放怒气满的特效
function FightQTEController:playPowerFullEffect( powerFullObjects )
    if nil ~= powerFullObjects and #powerFullObjects > 0 and nil ~= self.ArmatureNode_2 then
        self.ArmatureNode_2.powerFullObjects = powerFullObjects
        self.ArmatureNode_2:setVisible(true)
        csb.animationChangeToAction(self.ArmatureNode_2, 0, 0, false)
    end
end

function FightQTEController:initRoundRoleQteState( params )
    self._is_begin_power_skill = false
    local items = self.listView:getItems()
    local slot = params.slot
    local state = params.state
    local powerFullObjects = nil
    if nil ~= self.ArmatureNode_2 then
        powerFullObjects = self.ArmatureNode_2.powerFullObjects or {}
    end
    for i, v in pairs(items) do
        if v.armature._info ~= nil then
            if tonumber(v.armature._info._pos) == tonumber(slot) then
                -- print("初始化回合角色攻击状态，", v.armature.roleCamp, v.armature._info._pos, slot, state)
                v.armature.is_dizziness = false
                local stateInfo = nil
                if tonumber(state) == 1 then
                    
                elseif tonumber(state) == 2 then
                    stateInfo = "deathed"
                elseif tonumber(state) == 3 
                    or tonumber(state) == 8 
                    or tonumber(state) == 9 
                    or tonumber(state) == 12 
                    then
                    stateInfo = "dizziness"
                    v.armature.is_dizziness = true

                elseif tonumber(state) == 10 then
                    stateInfo = "dizziness"
                    v.armature.is_dizziness = true

                elseif tonumber(state) == 11 
                    or tonumber(state) == 13 then
                    stateInfo = "dizziness"
                    
                elseif tonumber(state) == 4 then
                    self._is_begin_power_skill = true
                    if v.armature._info._sp < FightModule.MAX_SP then
                        v.armature._info._sp = FightModule.MAX_SP
                    end
                    if nil ~= self.ArmatureNode_2 then
                        state_machine.excute("battle_qte_head_touch_head_role_skill_state", 0, {cell = v, status = state})

                        local Panel_jueji_effect = ccui.Helper:seekWidgetByName(v.roots[1], "Panel_jueji_effect")
                        Panel_jueji_effect:setVisible(false)

                        v._itemIndex = i
                        v._item_params = {cell = v, status = state, uiTarget = Panel_jueji_effect}
                        table.insert(powerFullObjects, 1, v)
                    else
                        state_machine.excute("battle_qte_head_touch_head_role_skill_state", 0, {cell = v, status = state})
                    end
                elseif tonumber(state) == 5 then
                    state_machine.excute("fight_ui_update_heti_skill_state", 0, {cell = v.armature, status = state})
                elseif tonumber(state) == 6 then
                    state_machine.excute("battle_qte_head_touch_head_role_skill_state", 0, {cell = v, status = state})
                    state_machine.excute("fight_ui_update_heti_skill_state", 0, {cell = v.armature, status = state})
                elseif tonumber(state) == 7 then
                    state_machine.excute("battle_qte_head_touch_head_role_skill_state", 0, {cell = v, status = state})
                end
                if stateInfo ~= nil then
                    state_machine.excute("battle_qte_head_update_draw", 0, {cell = v, status = stateInfo})
                end
            end
        end
    end

    if 0 < #powerFullObjects then
        self:playPowerFullEffect(powerFullObjects)
    end
end

function FightQTEController:startQTEActive(params)
    if self._is_begin_power_skill_lock == true then
        return
    end
    state_machine.unlock("fight_qte_controller_qte_to_auto_next_attack_role")
    self.currentPos = {}
    local qteLayer = ccui.Helper:seekWidgetByName(self.roots[2], "Panel_head_dh")
    local qteProgressPos = tonumber(params[1])
    if nil == params[2] or nil == params[2].parent or qteProgressPos < 0 then
        local posInfo = ""
        if qteProgressPos == 0 then
            posInfo = qtePosition[7]
        elseif qteProgressPos < 0 then
            posInfo = "0, 10000"
        else
            posInfo = qtePosition[tonumber(params[1])]
        end
        self.currentPos = zstring.split(posInfo, ",")
        qteLayer:setPosition(tonumber(self.currentPos[1]), tonumber(self.currentPos[2]))
    else
        -- local xx, yy = params[2].parent:getPosition()
        local xx = params[2].parent._base_pos.x
        local yy = params[2].parent._base_pos.y
        qteLayer:setPosition(xx, yy)
        self.currentPos = {xx, yy}
        local Panel_175 = ccui.Helper:seekWidgetByName(self.roots[2], "Panel_175")
        if true == params[3] then
            Panel_175:setVisible(false)
        else
            Panel_175:setVisible(true)
        end
    end
    if qteLayer ~= nil then
        local action = self.actions[1]
        if __fight_recorder_action_time_speed < 0.8 then
            action:setTimeSpeed(1.0 / __fight_recorder_action_time_speed)
        end
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
            or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
            then
            -- action:stop()
            self._FightRoleController._open_hit_count = true
            state_machine.unlock("fight_qte_controller_qte_to_auto_next_attack_role_but")
            if self.missionState == 4 then
                action:play("head_dh_jx", false)
            else
                action:play("head_dh", false)
                action.auto_select_index = math.random(1, 4)
                -- print("action.auto_select_index", action.auto_select_index)
                -- if action.auto_select_index == 4 then
                --     local animationInfo = action:getAnimationInfo("head_dh")
                --     local frameCount = math.random(animationInfo.endIndex + 30, animationInfo.startIndex - 30)
                --     self:runAction(cc.Sequence:create(cc.DelayTime:create(frameCount / 60.0), cc.CallFunc:create(function ( sender )
                --         local auto_select = state_machine.excute("fight_role_controller_auto_select", 0, 0)
                --         if auto_select then
                --             -- print("enter_perfect")
                --             FightRoleController.__lock_battle = false
                --             state_machine.unlock("fight_qte_controller_qte_to_auto_next_attack_role")
                --             state_machine.excute("fight_qte_controller_qte_to_auto_next_attack_role", 0, 0)
                --         end
                --     end)))
                -- end
            end
        else
            action:play("head_dh", false)
        end
        -- cc.Director:getInstance():getActionManager():resumeTarget(self.csbFightQTEController)
        cc.Director:getInstance():getActionManager():resumeTarget(self.csdActionNode)
        self.qteing = true
        qteLayer:setVisible(true)
        state_machine.unlock("fight_qte_controller_qte_to_auto_next_attack_role")
    end
    local Panel_caozuopingfen = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_caozuopingfen")
    Panel_caozuopingfen:setVisible(false)
end

function FightQTEController:changeQteProgressToHide( ... )
    local root = self.roots[2]
    local qteLayer = ccui.Helper:seekWidgetByName(root, "Panel_head_dh")
    if qteLayer ~= nil then
        qteLayer:setVisible(false)
        self.qteing = false
    end
end

function FightQTEController:qteToNextAttackRole(params)
    if _ED._fightModule.greadCount > 0 then
        -- self._FightRoleController._open_hit_count = true
    end

    local isHaveProgress = self.qteing
    self:changeQteProgressToHide()
    local root = self.roots[2]
    local uicell = params
    local armature = uicell.armature
    local focus = ccui.Helper:seekWidgetByName(root, "Image_move")
    local offsetX = focus:getPositionX()
    local dIndex = 5

    for i, v in pairs(self.domains) do
        if offsetX >= v.point.x and offsetX <= (v.point.x + v.size.width) then
            dIndex = i
            break
        end
    end
    if not isHaveProgress then
        dIndex = 5
    end
    self.qteing = false

    self._is_begin_power_skill = false
    local items = self.listView:getItems()

    for i, v in pairs(items) do
        if v.armature ~= nil and v.armature._info ~= nil and _ED._fightModule ~= nil then
            local attackObject = _ED._fightModule:getAppointFightObject(v.armature.roleCamp, v.armature._info._pos)
            if attackObject and attackObject.isCharm then
                if self.isPvEType == true then
                    -- 魅惑角色技能状态改为普攻
                    v._powerSkillState = -1
                    v._normalSkillState = -1
                end
            end
        end
    end

    for i, v in pairs(items) do
        if v._powerSkillState > -1 and v.isCanTouch and v.armature ~= nil then
            -- self.qteing = false
            -- self:changeQteProgressToHide()
            -- v.armature.isBeginHeti = false
            -- state_machine.excute("fight_role_controller_reset_comkill_progress", 0, 0)
            -- state_machine.excute("fight_role_controller_qte_to_next_attack_role", 0, {v.armature, dIndex})
            -- self._is_begin_power_skill = true
            -- return
            self._is_begin_power_skill = true
            break
        end
    end

    self._is_begin_power_skill_lock = self._is_begin_power_skill
    if true == uicell._unlock_power then
        self._is_begin_power_skill_lock = true
        uicell._unlock_power = false
    end

    if true == self._is_begin_power_skill then
        self._is_begin_power_skill = false
        for i, v in pairs(items) do
            if (v._powerSkillState > -1) and v.armature ~= nil and v ~= uicell then
                self._is_begin_power_skill = true
            end
        end
    end

    local skipSkill = false
    if uicell._powerSkillState > -1 then
        -- self._is_begin_power_skill = true
        state_machine.excute("fight_role_controller_reset_comkill_progress", 0, 0)
    else
        self._is_begin_power_skill = false
        -- self._is_begin_power_skill_lock = false
        skipSkill = true

        if true == self._is_begin_power_skill_lock then
            self._is_begin_power_skill = false
            if true == skipSkill then
                self._is_begin_power_skill_lock = false
            end
            local items = self.listView:getItems()
            -- _ED._fightModule:resetActionStatus()
            _ED._fightModule:clearPowerSkillState(0)
            for i, v in pairs(items) do
                if (v._powerSkillState > -1) 
                    and v.armature ~= nil 
                    then
                    v.isCanTouch = true
                    v.armature.qteOver = false
                    v.armature.comKill = 0
                    v.armature.isBeginHeti = true
                    v._powerSkillState = -1
                    state_machine.excute("battle_qte_head_touch_head_role_skill_state", 0, {cell = v, status = v._normalSkillState})
                end
            end

            -- self:changeQteProgressToHide()
            state_machine.excute("fight_role_controller_reset_comkill_progress", 0, 0)
        end
    end

    state_machine.excute("fight_role_controller_qte_to_next_attack_role", 0, {armature, dIndex})

    if true == self._is_begin_power_skill_lock and false == self._is_begin_power_skill then
        self._is_begin_power_skill = false
        if true == skipSkill then
            self._is_begin_power_skill_lock = false
        end
        local items = self.listView:getItems()
        -- _ED._fightModule:resetActionStatus()
        _ED._fightModule:clearPowerSkillState(0)
        for i, v in pairs(items) do
            if (v._powerSkillState > -1) and 
                v.armature ~= nil 
                then
                v.isCanTouch = true
                v.armature.qteOver = false
                v.armature.comKill = 0
                v.armature.isBeginHeti = true
                v._powerSkillState = -1
                state_machine.excute("battle_qte_head_touch_head_role_skill_state", 0, {cell = v, status = v._normalSkillState})
            end
        end

        -- self:changeQteProgressToHide()
        state_machine.excute("fight_role_controller_reset_comkill_progress", 0, 0)
    end

    if true == self._is_begin_power_skill_lock 
        -- and self._is_begin_power_skill == true 
        then
        -- state_machine.lock("fight_qte_controller_qte_to_next_attack_role")
        state_machine.excute("fight_qte_controller_qte_to_next_attack_role_lock", 0, 0)
        if uicell._normalSkillState > -1 then
            uicell.isCanTouch = true
            uicell.armature.qteOver = false
            uicell.armature.comKill = 0
            uicell.armature.isBeginHeti = true
            -- _ED._fightModule:resetActionStatus()
        end

        -- self._is_begin_power_skill = false
        -- for i, v in pairs(items) do
        --     if (v._powerSkillState > -1) and 
        --         v.armature ~= nil then
        --         self._is_begin_power_skill = true
        --     end
        -- end
        state_machine.excute("fight_role_controller_add_wake_up_beAttack_effect", 0, 0)
    end
end

-- 找到下一个要动手的fightRole，准备进行攻击
function FightQTEController:qteToAutoNextAttackRole(params)
    if nil ~= _ED._fightModule and _ED._fightModule.greadCount > 0 then
        -- self._FightRoleController._open_hit_count = true
    end
    -- if self.qteing == false then
    --     return
    -- end
    local root = self.roots[2]
    local focus = ccui.Helper:seekWidgetByName(root, "Image_move")
    local offsetX = focus:getPositionX()
    local dIndex = 5

    -- 神兽自动攻击
    local canAttack, canAttackAnimal, animaldIndex = state_machine.excute("fight_qte_controller_qte_to_auto_animal_start_attack", 0, 0)

    -- print("找到下一个要动手的fightRole，准备进行攻击 canAttack = ", canAttack, " canAttackAnimal = ", canAttackAnimal)

    if canAttack == true then
        -- print("======== canAttackAnimal = ", canAttackAnimal.roleCamp, canAttackAnimal._info._pos)

        state_machine.excute("fight_role_controller_qte_to_next_attack_role", 0, {canAttackAnimal, animaldIndex})
        return
    end

    for i, v in pairs(self.domains) do
        if offsetX >= v.point.x and offsetX <= (v.point.x + v.size.width) then
            dIndex = i
            break
        end
    end

    local items = self.listView:getItems()
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        local ditems = {}
        for i, v in pairs(items) do
            if v.armature ~= nil and v.armature._info ~= nil then
                if nil == _ED._fightModule then
                    table.insert(ditems, 1, v)
                else
                    local attackObject = _ED._fightModule:getAppointFightObject(v.armature.roleCamp, v.armature._info._pos)
                    if attackObject ~= nil and attackObject.isAction ~= true and attackObject.isDead ~= true then
                        table.insert(ditems, 1, v)
                    end
                end
            end
        end
        items = ditems
    end

    local auto_select = state_machine.excute("fight_role_controller_auto_select", 0, 0)

    self._is_begin_power_skill = false
    for i, v in pairs(items) do
        if v._powerSkillState > -1 and v.isCanTouch and v.armature ~= nil then
            if auto_select then
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                    -- print("-------:::>>>", v._touch_object._datas.terminal_name, v.deathed, v.armature._info._pos, v.armature.roleCamp)
                    if nil ~= v._touch_object then
                        state_machine.excute("fight_qte_controller_qte_to_next_attack_role_unlock", 0, 0)
                        state_machine.excute(v._touch_object._datas.terminal_name, v._touch_object._datas.terminal_state or 0, v._touch_object)
                        return
                    end
                end
            end
            -- self.qteing = false
            -- self:changeQteProgressToHide()
            -- v.armature.isBeginHeti = false
            -- state_machine.excute("fight_role_controller_reset_comkill_progress", 0, 0)
            -- state_machine.excute("fight_role_controller_qte_to_next_attack_role", 0, {v.armature, dIndex})
            -- self._is_begin_power_skill = true
            -- return
            self._is_begin_power_skill = true
            break
        end
    end

    -- if true == self._is_begin_power_skill then
    --     self._is_begin_power_skill = false
    --     for i, v in pairs(items) do
    --         if v._normalSkillState > -1 and v.armature ~= nil then
    --             v.isCanTouch = true
    --             v.armature.qteOver = false
    --             v.armature.comKill = 0
    --             v.armature.isBeginHeti = true
    --         end
    --     end

    --     self:changeQteProgressToHide()
    --     state_machine.excute("fight_role_controller_reset_comkill_progress", 0, 0)
    -- end

    if true == self._is_begin_power_skill then
        self._is_begin_power_skill = false
        local items = self.listView:getItems()
        -- _ED._fightModule:resetActionStatus()
        _ED._fightModule:clearPowerSkillState(0)
        for i, v in pairs(items) do
            if (v._powerSkillState > -1) and v.armature ~= nil 
                then
                v.isCanTouch = true
                v.armature.qteOver = false
                v.armature.comKill = 0
                v.armature.isBeginHeti = true
                v._powerSkillState = -1
                state_machine.excute("battle_qte_head_touch_head_role_skill_state", 0, {cell = v, status = v._normalSkillState})
            end
        end

        -- self:changeQteProgressToHide()
        state_machine.excute("fight_role_controller_reset_comkill_progress", 0, 0)
    end

    self._is_begin_power_skill_lock = self._is_begin_power_skill
    
    -- 武将自动攻击
    for i, v in pairs(items) do
        if v.isCanTouch and v.armature ~= nil then
            self.qteing = false
            self:changeQteProgressToHide()
            v.armature.isBeginHeti = false

            -- v.armature就是一下次动手的fightRole

            -- PVE的自动战斗，连击概率
            local auto_select = state_machine.excute("fight_role_controller_auto_select", 0, 0)
            if self.isPvEType == true and auto_select == true then

                local fightRole = v.armature
                local attackObject = _ED._fightModule:getAppointFightObject(0, fightRole._info._pos)
                local add = attackObject.ptvf85
                if add == 0 then
                    dIndex = math.random(1, 4)
                else
                    local base = 25
                    if math.random(1, 100) <= base + add then
                        dIndex = 1
                    elseif math.random(1, 100) <= (100 - base - add) / 3 then
                        dIndex = 2
                    elseif math.random(1, 100) <= (100 - base - add) / 3 then
                        dIndex = 3
                    else
                        dIndex = 4
                    end
                end
                local isCharm = attackObject.isCharm
                if isCharm then
                    v._powerSkillState = -1
                    v._normalSkillState = -1
                end
            end
            -- 这里自动模式开始的地方
            state_machine.excute("fight_role_controller_qte_to_next_attack_role", 0, {v.armature, dIndex})
            return
        end
    end
end

-- 被魅惑的角色先攻击
function FightQTEController:qteToAutoChramAttackRole()
    local items = self.listView:getItems()
    for i, v in pairs(items) do
        if v.armature ~= nil and v.armature._info ~= nil and _ED._fightModule ~= nil then
            local attackObject = _ED._fightModule:getAppointFightObject(v.armature.roleCamp, v.armature._info._pos)
            if attackObject and attackObject.isCharm then
                self.qteing = false
                self:changeQteProgressToHide()
                v.armature.isBeginHeti = false

                local dIndex = 5
                if self.isPvEType == true then
                    dIndex = math.random(1, 4)

                    -- 魅惑角色技能状态改为普攻
                    v._powerSkillState = -1
                    v._normalSkillState = -1
                    state_machine.excute("fight_role_controller_qte_to_next_attack_role", 0, {v.armature, dIndex})
                    -- state_machine.excute("battle_qte_head_update_draw", 0, {cell = v, status = "charm"})
                end
            end
        end
    end
end

-- 插入神兽攻击
function FightQTEController:qteToAutoAnimalAttackRole()
    local canAttack = false
    local canAttackAnimal = nil
    local dIndex = 5

    local items = self.animalListView:getItems()

    if _ED._fightModule ~= nil then
        canAttackAnimal = _ED._fightModule:getCanAttackAnimal()
    end
        
    for i, v in pairs(items) do
        if v.armature ~= nil and v.armature._info ~= nil and _ED._fightModule ~= nil then
            if canAttackAnimal then
                local coordinate = canAttackAnimal.coordinate

                -- print("插入神兽攻击 coordinate = ", coordinate, " v.armature._info._pos = ", v.armature._info._pos)
                if tonumber(coordinate) == tonumber(v.armature._info._pos) then
                    self.qteing = false
                    self:changeQteProgressToHide()
                    v.armature.isBeginHeti = false

                    if self.isPvEType == true then
                        dIndex = math.random(1, 4)

                        v._powerSkillState = 4
                        v._normalSkillState = -1

                        canAttack = true
                        canAttackAnimal = v.armature
                        dIndex = dIndex
                        break
                    end
                end
            end
        end
    end
    
    return canAttack, canAttackAnimal, dIndex
end

function FightQTEController:enterAutoFight( params )
    local items = self.listView:getItems()
    for i, v in pairs(items) do
        state_machine.excute("battle_qte_head_update_draw", 0, {cell = v, status = "lock"})
        state_machine.excute("fight_ui_update_heti_skill_state", 0, {cell = v.armature, status = 1})
    end
end

function FightQTEController:updateRoleCellState( params )
    local items = self.listView:getItems()
    for i, v in pairs(params[2]) do
        state_machine.excute("battle_qte_head_update_draw", 0, {cell = items[v], status = params[1]})
    end

    if #params > 2 then
        for i, v in pairs(params[4]) do
            state_machine.excute("battle_qte_head_update_draw", 0, {cell = items[v], status = params[3]})
        end
    end
end

function FightQTEController:checkOneHeadFightSuccess(params)
    local fightRole = params
    local items = self.listView:getItems()
    local isUseHeti = fightRole.isBeginHeti
    for i, v in pairs(items) do
        if isUseHeti == false then
            state_machine.excute("fight_ui_update_heti_skill_state", 0, {cell = v.armature, status = 1})
        end
        if fightRole == v.armature then
            if isUseHeti == true then
                state_machine.excute("fight_ui_update_heti_skill_state", 0, {cell = v.armature, status = 1})
            else
                state_machine.excute("battle_qte_head_update_draw", 0, {cell = v, status = "finish"})
            end
        end
    end
end

function FightQTEController:updateFightComKillInfo( params )
    local scoreList = params.hitList
    local isPlayScoreAni = params.playScoreAni
    local totalHurt = params.totalHurt
    self.scroeCount = table.getn(scoreList)
    local score = scoreList[self.scroeCount][1]
    local root = self.roots[1]
    local Panel_caozuopingfen = ccui.Helper:seekWidgetByName(root, "Panel_caozuopingfen")
    local Panel_lianji = ccui.Helper:seekWidgetByName(root, "Panel_lianji")
    local lianji_add = 0
    local scroeCountIndex = 0

    local dataNums = dms.count(dms["operate_addition"])

    for i,v in ipairs(scoreList) do
        local row = i >= dataNums and dataNums or i
        local add = dms.string(dms["operate_addition"], row,  (5 - v[1]) * 2 + 1)
        lianji_add = lianji_add + add

        -- if i > 2 then
        --     if v[1] >= 4 then
        --         scroeCountIndex = 0
        --     else
        --         scroeCountIndex = scroeCountIndex + 1
        --     end
        -- end
        if v[2] == false then
            scroeCountIndex = 0
        else
            if i > 2 then
                if v[2] == true then
                    scroeCountIndex = scroeCountIndex + 1
                end
            end
        end
    end
    if tonumber(self.scroeCount) > 1 then
        local row = self.scroeCount >= dataNums and dataNums or self.scroeCount
        self.score = self.score + dms.string(dms["operate_addition"], row, (5 - score) * 2 + 2)
        Panel_lianji:removeAllChildren(true)
        Panel_lianji:setVisible(true)

        local armature = ccs.Armature:create("effect_lianjijiacheng")
        draw.initArmature(armature, nil, -1, 0, 1)
        local function changeActionCallback( armatureBack )
            local isPlayScoreAni = armatureBack.isPlayScoreAni
            local _self = armatureBack._self
            local _totalHurt = armatureBack._totalHurt
            armatureBack:removeFromParent(true)
            Panel_lianji:setVisible(false)
            if isPlayScoreAni then
                _self:updateFightScoreInfo(_totalHurt)
            end
        end

        -- if isPlayScoreAni then
        --     armature._invoke = changeActionCallback
        -- else
        --     armature._invoke = nil
        -- end
        armature._invoke = changeActionCallback
        armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
        -- local shuziIconName = string.format("images/ui/battle/lianjishuzi_%s.png", self.scroeCount)
        -- local shuziIcon = ccs.Skin:create(shuziIconName)
        local jiachengIconName = string.format("images/ui/battle/shanghaijiacheng_%s.png", lianji_add)
        local jiachengIcon = ccs.Skin:create(jiachengIconName)
        -- armature:getBone("shuzi"):addDisplay(shuziIcon, 0)
        armature:getBone("jiacheng"):addDisplay(jiachengIcon, 0)
        csb.animationChangeToAction(armature, 0, 0, false)

        -- local actionIndex = self.scroeCount - 2
        -- csb.animationChangeToAction(armature, actionIndex, actionIndex + 5, false)
        local actionIndex = scroeCountIndex
        csb.animationChangeToAction(armature, actionIndex, actionIndex, false)
        armature.isPlayScoreAni = isPlayScoreAni
        armature._self = self
        armature._totalHurt = totalHurt
        Panel_lianji:addChild(armature)

        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        else   
            local row = self.scroeCount >= dataNums and dataNums or self.scroeCount
            local musicId = dms.string(dms["operate_addition"], row, (15 - score))
            playEffect(formatMusicFile("effect", musicId))
        end
    end
end

function FightQTEController:updateFightScoreInfo( params )
    local root = self.roots[1]
    local Panel_lianji = ccui.Helper:seekWidgetByName(root, "Panel_lianji")
    Panel_lianji:setVisible(false)
    local Panel_caozuopingfen = ccui.Helper:seekWidgetByName(root, "Panel_caozuopingfen")
    local Panel_zongshanghai = ccui.Helper:seekWidgetByName(root, "Panel_zongshanghai")
    Panel_caozuopingfen:setVisible(true)
    Panel_zongshanghai:setVisible(true)
    local scoreLevel = 1
    for i=1,6 do
        for j=1,4 do
            local min = 0
            local max = 0
            if j == operate_grade.min then
                min = dms.string(dms["operate_grade"], i, j)
            elseif j == operate_grade.max then
                max = dms.string(dms["operate_grade"], i, j)
            end
            local lastScore = math.floor(self.score/(self.scroeCount - 1))
            if lastScore >= tonumber(min) and lastScore <= tonumber(max) then
                scoreLevel = i
                break
            end
        end
    end
    self.score = 0
    self.scroeCount = 0

    local qteLayer = ccui.Helper:seekWidgetByName(root, "Panel_head_dh")
    if qteLayer ~= nil then
        qteLayer:setVisible(false)
        self.qteing = false
    end

    local scoreDis = dms.string(dms["operate_grade"], scoreLevel, operate_grade.dis)

    local armature = ccs.Armature:create("effect_caozuopinfen")
    draw.initArmature(armature, nil, -1, 0, 1)
    local function changeActionCallback( armatureBack )
        local isPlayScoreAni = armatureBack.isPlayScoreAni
        local _self = armatureBack._self
        armatureBack:removeFromParent(true)
        Panel_caozuopingfen:setVisible(false)
    end
    armature._invoke = changeActionCallback
    armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    csb.animationChangeToAction(armature, scoreLevel - 1, scoreLevel - 1, false)
    armature._self = self
    Panel_caozuopingfen:addChild(armature)


    local AtlasLabel_xue = ccui.Helper:seekWidgetByName(self.hurtRoot, "AtlasLabel_xue")
    AtlasLabel_xue:setString(""..math.floor(params))--self.totalHurt
    local action = self.actions[2]
    if action then
        action:play("zhongshanghai_ing", false)
    end

    local armature = self.hurtRoot:getChildByName("Panel_zongshanghai_0"):getChildByName("ArmatureNode_1")
    local function changeActionCallback(armatureBack)
        Panel_zongshanghai:setVisible(false)
    end
    draw.initArmature(armature, nil, -1, 0, 1)
    armature._invoke = changeActionCallback
    csb.animationChangeToAction(armature, 0, 0, false)
    self.totalHurt = 0

    -- local armature = ccs.Armature:create("effect_zongshanghai")
    -- draw.initArmature(armature, nil, -1, 0, 1)
    -- local function changeActionCallback( armatureBack )
    --     local isPlayScoreAni = armatureBack.isPlayScoreAni
    --     local _self = armatureBack._self
    --     armatureBack:removeFromParent(true)
    --     Panel_zongshanghai:setVisible(false)
    -- end
    -- armature._invoke = changeActionCallback
    -- armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    -- csb.animationChangeToAction(armature, 0, 0, false)
    -- armature._self = self
    -- Panel_zongshanghai:addChild(armature)
end

function FightQTEController:playPinJiaAni( params )
    local score = tonumber(params)
    if nil == score or score < 0 or score > 4 then
        score = 4
    end
    local root = self.roots[2]
    local Panel_lianjiepingjia = ccui.Helper:seekWidgetByName(root, "Panel_lianjiepingjia")
    local armature = Panel_lianjiepingjia:getChildByName("ArmatureNode_panduan")

    if nil ~= FightRole.firstTargetPos then
        Panel_lianjiepingjia:setPosition(FightRole.firstTargetPos)
        FightRole.firstTargetPos = nil
    else
        if #self.currentPos == 2 then
            Panel_lianjiepingjia:setPosition(tonumber(self.currentPos[1]), tonumber(self.currentPos[2]))
        end
    end
    local function changeActionCallback(armatureBack)
        local armature = armatureBack
        if armature ~= nil then
            local actionIndex = armature._actionIndex
            if actionIndex == 0 or actionIndex == 1 or actionIndex == 2 or actionIndex == 3 then
                Panel_lianjiepingjia:setVisible(false)
            end
        end
    end
    if score <= 3 then
        state_machine.excute("fight_scene_shake", 0, nil)
    end
    draw.initArmature(armature, nil, -1, 0, 1)
    Panel_lianjiepingjia:setVisible(true)
    armature._invoke = changeActionCallback
    csb.animationChangeToAction(armature, 4 - score, 4 - score, false)
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then

        self.actions[1]:gotoFrameAndPause(0)

        if nil ~= self._FightRoleController and true == self._FightRoleController.auto_select then

        else
            if armature._actionIndex == 0 then
                playEffect(formatMusicFile("effect", 9984))
            elseif armature._actionIndex == 1 then
                playEffect(formatMusicFile("effect", 9985))
            elseif armature._actionIndex == 2 then
                playEffect(formatMusicFile("effect", 9986))
            elseif armature._actionIndex == 3 then
                playEffect(formatMusicFile("effect", 9987))
            end
        end
    end
end

function FightQTEController:startShakeUI(params)
    if self.isShake == true then
        return
    end
    local function shakeEnd( sender )
        self.isShake = false
    end
    local arrayForScale = {
        cc.MoveTo:create(0.1, cc.p(6, -8)),
        cc.MoveTo:create(0.1, cc.p(-4, 6)),
        cc.MoveTo:create(0.1, cc.p(0, 0)),
        cc.CallFunc:create(shakeEnd)
    }
    self.isShake = true
    local scaleSeq = cc.Sequence:create(arrayForScale)
    self:runAction(scaleSeq)
end

function FightQTEController:updateDrawPowerSkillTotalDamage( params )
    -- print("绘制绝对的总伤害信息：", params)
    local damage = math.floor(zstring.tonumber(params))
    if damage < 0 then
        damage = -1 * damage
    end

    local AtlasLabel_xue = self.totalHurtRoot._AtlasLabel_xue

    local action = self.actions[3]

    if damage <= 0 then
        AtlasLabel_xue._total_damage_value = 0
        if action then
            action:stop()
        end
        self.totalHurtRoot:setVisible(false)
        return
    end
    AtlasLabel_xue._total_damage_value = AtlasLabel_xue._total_damage_value + damage
    AtlasLabel_xue:setString(""..AtlasLabel_xue._total_damage_value)

    self.totalHurtRoot:setVisible(true)

    -- local AtlasLabel_xue = ccui.Helper:seekWidgetByName(self.totalHurtRoot, "AtlasLabel_xue")
    -- AtlasLabel_xue._total_damage_value = AtlasLabel_xue._total_damage_value or 0

    -- if AtlasLabel_xue._total_damage_value == 0 then
    --     csb.animationChangeToAction(self.totalHurtRoot._armature, 0, 0, false)
    -- end

    -- AtlasLabel_xue._total_damage_value = AtlasLabel_xue._total_damage_value + damage
    -- AtlasLabel_xue:setString(""..damage)
    -- if damage <= 0 then
    --     AtlasLabel_xue._total_damage_value = 0
    --     return
    -- end

    if action then
        action:play("zhongshanghai_ing", false)
    end
end

function FightQTEController:changeTimeSpeed( ... )
    local timeScale = cc.Director:getInstance():getScheduler():getTimeScale()
    local items = self.listView:getItems()
    local ditems = {}
    for i, v in pairs(items) do
        if v then
            for m, n in pairs(v.actions) do
                n:setTimeSpeed(1 / timeScale)
            end
        end
    end
end

function FightQTEController:onInitWithRoleLayer( _window, csdActionNode, fileName )
    -- local action = csb.createTimeline(fileName)
    -- table.insert(self.actions, 1, action)

    -- local root = _window.roots[1]
    -- table.insert(self.roots, root)

    self._FightRoleController = _window

    local action = csb.createTimeline("battle/battle_hand_control.csb")
    table.insert(self.actions, 1, action)

    local root = ccui.Helper:seekWidgetByName(self.roots[1], "panel_yuanquan")
    table.insert(self.roots, root)

    root:setPositionX(root:getPositionX()-1 * app.baseOffsetX / 2)

    local qteLayer = ccui.Helper:seekWidgetByName(root, "Panel_head_dh")

    local focus = ccui.Helper:seekWidgetByName(root, "Image_move")
    local offsetX = focus:getPositionX()

    local Panel_bad = ccui.Helper:seekWidgetByName(root, "Panel_bad")
    local Panel_good = ccui.Helper:seekWidgetByName(root, "Panel_good")
    local Panel_great = ccui.Helper:seekWidgetByName(root, "Panel_great")
    local Panel_perfect = ccui.Helper:seekWidgetByName(root, "Panel_perfect")
    table.insert(self.domains, {point = cc.p(Panel_perfect:getPosition()), size = Panel_perfect:getContentSize()})
    table.insert(self.domains, {point = cc.p(Panel_great:getPosition()), size = Panel_great:getContentSize()})
    table.insert(self.domains, {point = cc.p(Panel_good:getPosition()), size = Panel_good:getContentSize()})
    table.insert(self.domains, {point = cc.p(Panel_bad:getPosition()), size = Panel_bad:getContentSize()})

    -- self.csdActionNode = csdActionNode
    self.csdActionNode = self.csbFightQTEController

    -- action:setTimeSpeed(app.getTimeSpeed())
    self.csbFightQTEController:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        local action = frame:getTimeline():getActionTimeline()
        
        if str == "head_dh_over" then
            -- Fury 4-oct: el tutorial espera el "enter_perfect" (missionState 4) y el circulo
            -- termino sin darlo (fotograma saltado en un movil lento, circulo ya pasado...):
            -- se da aqui, igual que en enter_perfect. Si tampoco llega, el vigilante de Mission.lua.
            if tonumber(self.missionState) == 4 and self._fury_perfect_hecho ~= true
                and (__lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto)
                then
                self._fury_perfect_hecho = true
                cc.Director:getInstance():getActionManager():pauseTarget(self.csdActionNode)
                executeNextEvent(nil, nil)
                fwin:addService({
                        callback = function ( params )
                            self.missionState = 14
                            FightRoleController.__lock_battle = false
                        end,
                        delay = 0.5,
                        params = nil
                    })
                return
            end
            if action.auto_select_index == 4 then
                action.auto_select_index = 0
                local auto_select = state_machine.excute("fight_role_controller_auto_select", 0, 0)
                if auto_select then
                    -- print("head_dh_over")
                    state_machine.excute("fight_qte_controller_qte_to_auto_next_attack_role", 0, 0)
                end
            end
            if qteLayer ~= nil then
                qteLayer:setVisible(false)
            end
            if self.qteing == true then
                self.qteing = false
                state_machine.excute("fight_role_controller_restart_qte_timer", 0, 0)
                state_machine.excute("fight_role_controller_wake_up_beAttack_effect", 0, nil)
            end
        elseif str == "enter_good" then
            if action.auto_select_index == 1 then
                action.auto_select_index = 0
                local auto_select = state_machine.excute("fight_role_controller_auto_select", 0, 0)
                if auto_select then
                    -- print("enter_good")
                    state_machine.excute("fight_qte_controller_qte_to_auto_next_attack_role", 0, 0)
                end
            end
            if tonumber(self.missionState) == 1 then
                cc.Director:getInstance():getActionManager():pauseTarget(self.csdActionNode)
                state_machine.excute("fight_role_controller_begin_mission", 0, {self.missionState, true})
            end
        elseif str == "enter_great" then
            if action.auto_select_index == 2 then
                action.auto_select_index = 0
                local auto_select = state_machine.excute("fight_role_controller_auto_select", 0, 0)
                if auto_select then
                    -- print("enter_great")
                    state_machine.excute("fight_qte_controller_qte_to_auto_next_attack_role", 0, 0)
                end
            end
        elseif str == "enter_perfect" then
            if action.auto_select_index == 3 then
                action.auto_select_index = 0
                local auto_select = state_machine.excute("fight_role_controller_auto_select", 0, 0)
                if auto_select then
                    -- print("enter_perfect")
                    state_machine.excute("fight_qte_controller_qte_to_auto_next_attack_role", 0, 0)
                end
            end
            if tonumber(self.missionState) == 4 then
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    then
                    -- app.load("client.battle.fight.BattlePause")
                    -- state_machine.excute("battle_pause", 0, 0)
                    -- local function doResume( _layer )
                    --     _layer:resume()
                    --     for i, v in pairs(_layer:getChildren()) do
                    --         doResume(v)
                    --     end
                    -- end
                    -- doResume(self)
                    self._fury_perfect_hecho = true -- Fury 4-oct
                    cc.Director:getInstance():getActionManager():pauseTarget(self.csdActionNode)
                    executeNextEvent(nil, nil)
                    fwin:addService({
                            callback = function ( params )
                                self.missionState = 14
                                FightRoleController.__lock_battle = false
                            end,
                            delay = 0.5,
                            params = nil
                        })
                else
                    cc.Director:getInstance():getActionManager():pauseTarget(self.csdActionNode)
                    state_machine.excute("fight_role_controller_begin_mission", 0, {self.missionState, true})
                    state_machine.excute("battle_pause", 0, 0)
                end
            end
        elseif str == "stop" then
            app.load("client.battle.fight.BattlePause")
            state_machine.excute("battle_pause", 0, 0)
            local function doResume( _layer )
                _layer:resume()
                for i, v in pairs(_layer:getChildren()) do
                    doResume(v)
                end
            end
            doResume(self)
        elseif str == "close" then
            -- 结束在一次连击动画中的连击计数
            self._FightRoleController._open_hit_count = false
            state_machine.lock("fight_qte_controller_qte_to_auto_next_attack_role_but")
        end
    end)
end

function FightQTEController:onEnterTransitionFinish()
    local csbFightQTEController = csb.createNode("battle/battle_hand_control.csb")
    local root = csbFightQTEController:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbFightQTEController)
    self.csbFightQTEController = csbFightQTEController
    if MissionClass._isFirstGame == true then
        self:setVisible(false)
    end

    self.listView = ccui.Helper:seekWidgetByName(root, "ListView_battle_head")
    
    self.animalListView = ccui.Helper:seekWidgetByName(root, "ListView_animal_battle_head")

    -- local qteLayer = ccui.Helper:seekWidgetByName(root, "Panel_head_dh")

    -- local Panel_bad = ccui.Helper:seekWidgetByName(root, "Panel_bad")
    -- local Panel_good = ccui.Helper:seekWidgetByName(root, "Panel_good")
    -- local Panel_great = ccui.Helper:seekWidgetByName(root, "Panel_great")
    -- local Panel_perfect = ccui.Helper:seekWidgetByName(root, "Panel_perfect")
    -- table.insert(self.domains, {point = cc.p(Panel_perfect:getPosition()), size = Panel_perfect:getContentSize()})
    -- table.insert(self.domains, {point = cc.p(Panel_great:getPosition()), size = Panel_great:getContentSize()})
    -- table.insert(self.domains, {point = cc.p(Panel_good:getPosition()), size = Panel_good:getContentSize()})
    -- table.insert(self.domains, {point = cc.p(Panel_bad:getPosition()), size = Panel_bad:getContentSize()})

    -- local action = csb.createTimeline("battle/battle_hand_control.csb")
    -- table.insert(self.actions, action)

    local Panel_zongshanghai = ccui.Helper:seekWidgetByName(root, "Panel_zongshanghai")
    local csbFightQTEControllerHurt = csb.createNode("battle/battle_hand_zongshanghai.csb")
    Panel_zongshanghai:addChild(csbFightQTEControllerHurt)
    self.hurtRoot = csbFightQTEControllerHurt:getChildByName("root")
    local hurtAction = csb.createTimeline("battle/battle_hand_zongshanghai.csb")
    table.insert(self.actions, hurtAction)
    csbFightQTEControllerHurt:runAction(hurtAction)

    -- 怒气提示特效
    local Panel_battle_hand = ccui.Helper:seekWidgetByName(root, "Panel_battle_hand")
    local ArmatureNode_2 = Panel_battle_hand:getChildByName("ArmatureNode_2")
    if nil ~= ArmatureNode_2 then
        local function changeActionCallback(armatureBack)
            armatureBack:setVisible(false)
        end
        draw.initArmature(ArmatureNode_2, nil, -1, 0, 1)
        ArmatureNode_2:getAnimation():setFrameEventCallFunc(function ( bone,evt,originFrameIndex,currentFrameIndex )
            local armature = bone:getArmature()
            if nil ~= armature.powerFullObjects then
                local len = table.nums(armature.powerFullObjects)
                if len > 0 then
                    local item = armature.powerFullObjects[1]
                    local frameEvents = zstring.split(evt, "_")
                    local index = item._itemIndex
                    if checkFrameEvent(frameEvents, "full" .. index) == true then
                        local item = table.remove(armature.powerFullObjects, 1)
                        if item._normalSkillState > -1 then
                            item._item_params.uiTarget:setVisible(true)
                        end
                        -- state_machine.excute("battle_qte_head_touch_head_role_skill_state", 0, item._item_params)
                    end
                end
                if table.nums(armature.powerFullObjects) == 0 then
                    armature.powerFullObjects = nil
                end
            end
        end)
        ArmatureNode_2._invoke = changeActionCallback
        csb.animationChangeToAction(ArmatureNode_2, 0, 0, false)
        self.ArmatureNode_2 = ArmatureNode_2
    end

    -- 添加加绝技的总伤害绘制
    local Panel_bishashanghai = ccui.Helper:seekWidgetByName(root, "Panel_bishashanghai")
    if nil ~= Panel_bishashanghai then
        local csbFightQTEControllerTotalHurt = csb.createNode("battle/battle_hand_zongshanghai_0.csb")
        Panel_bishashanghai:addChild(csbFightQTEControllerTotalHurt)
        self.totalHurtRoot = csbFightQTEControllerTotalHurt:getChildByName("root")
        self.totalHurtRoot:setVisible(false)
        local totalHurtAction = csb.createTimeline("battle/battle_hand_zongshanghai_0.csb")
        table.insert(self.actions, totalHurtAction)
        csbFightQTEControllerTotalHurt:runAction(totalHurtAction)

        -- local armature = self.totalHurtRoot:getChildByName("Panel_zongshanghai_0"):getChildByName("ArmatureNode_1")
        -- local function changeActionCallback(armatureBack)
        --     armatureBack:setVisible(false)
        -- end
        -- draw.initArmature(armature, nil, -1, 0, 1)
        -- armature._invoke = changeActionCallback
        -- self.totalHurtRoot._armature = armature

        local AtlasLabel_xue = ccui.Helper:seekWidgetByName(self.totalHurtRoot, "AtlasLabel_xue")
        AtlasLabel_xue._total_damage_value = 0
        self.totalHurtRoot._AtlasLabel_xue = AtlasLabel_xue
    end
    
    local Panel_xiangyin = ccui.Helper:seekWidgetByName(root, "Panel_xiangyin")
    if nil ~= Panel_xiangyin then
        FightRoleController.__lock_battle = true
        fwin:addTouchEventListener(Panel_xiangyin,  nil, 
        {
            terminal_name = "fight_qte_controller_qte_to_auto_next_attack_role_but",
            cell = self,
            terminal_state = 0,
            check_auto_select = true
        }, 
        nil, 0)
        Panel_xiangyin:setSwallowTouches(false)
    end
    state_machine.lock("fight_qte_controller_qte_to_auto_next_attack_role_but")

    -- -- action:setTimeSpeed(app.getTimeSpeed())
    -- csbFightQTEController:runAction(action)
    -- action:setFrameEventCallFunc(function (frame)
    --     if nil == frame then
    --         return
    --     end

    --     local str = frame:getEvent()
    --     local action = frame:getTimeline():getActionTimeline()
    --     if str == "head_dh_over" then
    --         if action.auto_select_index == 4 then
    --             action.auto_select_index = 0
    --             local auto_select = state_machine.excute("fight_role_controller_auto_select", 0, 0)
    --             if auto_select then
    --                 -- print("head_dh_over")
    --                 state_machine.excute("fight_qte_controller_qte_to_auto_next_attack_role", 0, 0)
    --             end
    --         end
    --         if qteLayer ~= nil then
    --             qteLayer:setVisible(false)
    --         end
    --         if self.qteing == true then
    --             self.qteing = false
    --             state_machine.excute("fight_role_controller_restart_qte_timer", 0, 0)
    --             state_machine.excute("fight_role_controller_wake_up_beAttack_effect", 0, nil)
    --         end
    --     elseif str == "enter_good" then
    --         if action.auto_select_index == 1 then
    --             action.auto_select_index = 0
    --             local auto_select = state_machine.excute("fight_role_controller_auto_select", 0, 0)
    --             if auto_select then
    --                 -- print("enter_good")
    --                 state_machine.excute("fight_qte_controller_qte_to_auto_next_attack_role", 0, 0)
    --             end
    --         end
    --         if tonumber(self.missionState) == 1 then
    --             cc.Director:getInstance():getActionManager():pauseTarget(self.csbFightQTEController)
    --             state_machine.excute("fight_role_controller_begin_mission", 0, {self.missionState, true})
    --         end
    --     elseif str == "enter_great" then
    --         if action.auto_select_index == 2 then
    --             action.auto_select_index = 0
    --             local auto_select = state_machine.excute("fight_role_controller_auto_select", 0, 0)
    --             if auto_select then
    --                 -- print("enter_great")
    --                 state_machine.excute("fight_qte_controller_qte_to_auto_next_attack_role", 0, 0)
    --             end
    --         end
    --     elseif str == "enter_perfect" then
    --         if action.auto_select_index == 3 then
    --             action.auto_select_index = 0
    --             local auto_select = state_machine.excute("fight_role_controller_auto_select", 0, 0)
    --             if auto_select then
    --                 -- print("enter_perfect")
    --                 state_machine.excute("fight_qte_controller_qte_to_auto_next_attack_role", 0, 0)
    --             end
    --         end
    --         if tonumber(self.missionState) == 4 then
    --             if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
    --                 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
    --                 then
    --                 -- app.load("client.battle.fight.BattlePause")
    --                 -- state_machine.excute("battle_pause", 0, 0)
    --                 -- local function doResume( _layer )
    --                 --     _layer:resume()
    --                 --     for i, v in pairs(_layer:getChildren()) do
    --                 --         doResume(v)
    --                 --     end
    --                 -- end
    --                 -- doResume(self)
    --                 cc.Director:getInstance():getActionManager():pauseTarget(self.csbFightQTEController)
    --                 executeNextEvent(nil, nil)
    --                 fwin:addService({
    --                         callback = function ( params )
    --                             self.missionState = 14
    --                             FightRoleController.__lock_battle = false
    --                         end,
    --                         delay = 0.5,
    --                         params = nil
    --                     })
    --             else
    --                 cc.Director:getInstance():getActionManager():pauseTarget(self.csbFightQTEController)
    --                 state_machine.excute("fight_role_controller_begin_mission", 0, {self.missionState, true})
    --                 state_machine.excute("battle_pause", 0, 0)
    --             end
    --         end
    --     elseif str == "stop" then
    --         app.load("client.battle.fight.BattlePause")
    --         state_machine.excute("battle_pause", 0, 0)
    --         local function doResume( _layer )
    --             _layer:resume()
    --             for i, v in pairs(_layer:getChildren()) do
    --                 doResume(v)
    --             end
    --         end
    --         doResume(self)
    --     end
    -- end)
end

function FightQTEController:onLoad()
    local effect_paths = "images/ui/effice/effect_lianjijiacheng/effect_lianjijiacheng.ExportJson"
    -- ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync(effect_paths, self.onArmatureDataLoad, self.onArmatureDataLoadEx, self)
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
    effect_paths = "images/ui/effice/effect_caozuopinfen/effect_caozuopinfen.ExportJson"
    -- ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync(effect_paths, self.onArmatureDataLoad, self.onArmatureDataLoadEx, self)
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
end

function FightQTEController:onArmatureDataLoad( ... )
    -- body
end

function FightQTEController:onArmatureDataLoadEx( ... )
    -- body
end

function FightQTEController:onExit()
    local effect_paths = "images/ui/effice/effect_lianjijiacheng/effect_lianjijiacheng.ExportJson"
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(effect_paths)
    effect_paths = "images/ui/effice/effect_caozuopinfen/effect_caozuopinfen.ExportJson"
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(effect_paths)
    state_machine.remove("fight_qte_controller_manager")
    state_machine.remove("fight_qte_controller_add_role")
    state_machine.remove("fight_qte_controller_start_qte_active")
    state_machine.remove("fight_qte_controller_init_role_qte_state")
    state_machine.remove("fight_qte_controller_qte_to_next_attack_role")
    state_machine.remove("fight_qte_controller_qte_to_next_attack_role_lock")
    state_machine.remove("fight_qte_controller_qte_to_next_attack_role_unlock")
    state_machine.remove("fight_qte_controller_qte_to_auto_next_attack_role")
    state_machine.remove("fight_qte_controller_qte_to_auto_next_attack_role_but")
    state_machine.remove("fight_qte_controller_update_fight_comkill_info")
    state_machine.remove("fight_qte_controller_qte_hide_progress")
    state_machine.remove("fight_qte_controller_enter_auto_fight")
    state_machine.remove("fight_qte_controller_enter_next_auto_fight")
    state_machine.remove("fight_qte_controller_update_fight_score_info")
    state_machine.remove("fight_qte_controller_play_pinjia_ani")
    state_machine.remove("fight_qte_controller_reset_fight_head")
    state_machine.remove("fight_qte_controller_get_qte_state")
    state_machine.remove("fight_qte_controller_shake_ui")
    state_machine.remove("fight_qte_controller_progress_continue_play")
    state_machine.remove("fight_qte_controller_change_mission_state")
    state_machine.remove("fight_qte_controller_change_visible")
    state_machine.remove("fight_qte_controller_update_role_cell_state")
    state_machine.remove("fight_qte_controller_update_draw_power_skill_total_damage")
    state_machine.remove("fight_qte_controller_change_time_speed")
    state_machine.remove("fight_qte_controller_on_init_with_role_layer")
    state_machine.remove("fight_qte_controller_qte_to_auto_chram_attack_role") 
    state_machine.remove("fight_qte_controller_qte_to_auto_animal_start_attack")
    state_machine.remove("fight_qte_controller_save_guide_perfect_pos")
    state_machine.remove("fight_qte_controller_unsave_guide_perfect_pos")
end
