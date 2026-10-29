FightUIForDailyActivityCopy = class("FightUIForDailyActivityCopyClass", Window)

function FightUIForDailyActivityCopy:ctor()
    self.super:ctor()
    self.roots = {}

    self._fightType = _fightType
    self.copyId = _ED._daily_copy_npc_id

    self.maxRoundCount = 0

    self.extra_type = 0
    self.rewardParams = {}

    self.fightRoundCount = 0
    self.totalDamage = 0
    self.baseReward = 0
    self.extraDamage = 0
    self.extraRate = 0
    self.extraReward = 0
    self.damagePercent = 1

    self.totalFightHurt = 0

    self.lastHurt = 0

    self.totalHurts = 0

    self.lastTotalHurt = 0

    -- Initialize fight ui for daily activity copy page state machine.
    local function init_fight_ui_for_daily_activity_copy_terminal()
        -- 更新战斗回合
        local fight_ui_for_daily_activity_copy_update_fight_round_count_terminal = {
            _name = "fight_ui_for_daily_activity_copy_update_fight_round_count",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.updateFightRoundCount ~= nil then
                    instance:updateFightRoundCount(params)
                end 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 更新战斗中的总伤害值
        local fight_ui_for_daily_activity_copy_update_fight_damage_terminal = {
            _name = "fight_ui_for_daily_activity_copy_update_fight_damage",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.updateFightDamage ~= nil then
                    instance:updateFightDamage(params)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 更新战斗奖励结算
        local fight_ui_for_daily_activity_copy_update_draw_res_count_terminal = {
            _name = "fight_ui_for_daily_activity_copy_update_draw_res_count",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.updateDropResounces ~= nil then
                    instance:updateDropResounces(params)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 计算战斗总伤害
        local fight_ui_for_daily_activity_copy_begin_calc_fight_hurt_terminal = {
            _name = "fight_ui_for_daily_activity_copy_begin_calc_fight_hurt",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.calcTotalHurt ~= nil then
                    instance:calcTotalHurt()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(fight_ui_for_daily_activity_copy_update_fight_round_count_terminal)
        state_machine.add(fight_ui_for_daily_activity_copy_update_fight_damage_terminal)
        state_machine.add(fight_ui_for_daily_activity_copy_update_draw_res_count_terminal)
        state_machine.add(fight_ui_for_daily_activity_copy_begin_calc_fight_hurt_terminal)
        state_machine.init()
    end

    -- call func init fight ui for daily activitystate machine.
    init_fight_ui_for_daily_activity_copy_terminal()
end

function FightUIForDailyActivityCopy:calcTotalHurt( ... )
    self.totalHurts = 0
    if _ED.attackData ~= nil and _ED.attackData.roundData ~= nil then
        for k,roundData in pairs(_ED.attackData.roundData) do
            for m = 1, roundData.curAttackCount do
                local isHurtMaster = false
                local attData = roundData.roundAttacksData[m]
                for j = 1, attData.skillInfluenceCount do
                    local _skf = attData.skillInfluences[j]
                    if _skf ~= nil then
                        for w = 1, _skf.defenderCount do
                            local _def = _skf._defenders[w]
                            if _def ~= nil and (_def.defenderST == "0" or _def.defenderST == "6") then
                                if tonumber(_def.defender) == 1 then
                                    isHurtMaster = true
                                    self.totalFightHurt = self.totalFightHurt + tonumber(_def.stValue)
                                end
                            end
                        end
                    end
                end

                if tonumber(attData.linkAttackerPos) > 0 and attData.fitHeros ~= nil then --如果有合体技能
                    for k, fitAttData in pairs(attData.fitHeros) do
                        if fitAttData ~= nil then
                            for j = 1, fitAttData.skillInfluenceCount do
                                local _fitSkf = fitAttData.skillInfluences[j]
                                if _fitSkf ~= nil then
                                    for w = 1, _fitSkf.defenderCount do
                                        local _def = _fitSkf._defenders[w]
                                        if _def ~= nil and (_def.defenderST == "0" or _def.defenderST == "6") then
                                            if tonumber(_def.defender) == 1 then
                                                isHurtMaster = true
                                                self.totalFightHurt = self.totalFightHurt + tonumber(_def.stValue)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                if isHurtMaster == true then
                    self.totalHurts = self.totalHurts + 1
                end
            end
        end
    end
    self.lastTotalHurt = self.baseReward
end

function FightUIForDailyActivityCopy:updateFightRoundCount(params)
    local root = self.roots[1]
    self.fightRoundCount = params[1]
    ccui.Helper:seekWidgetByName(root,"Text_14"):setString("" .. self.fightRoundCount .. "/"..self.maxRoundCount)
    if self.extra_type == 0 then
    else
        self:updateDropResounces()
    end
end

function FightUIForDailyActivityCopy:updateFightDamage(params)
    local root = self.roots[1]
    self.lastHurt = self.totalDamage
    self.totalDamage = math.abs(zstring.tonumber(params[1]))
    if self.extra_type == 0 then
        ccui.Helper:seekWidgetByName(root,"Text_14_0"):setString("" .. self.totalDamage)
    end
    if self.extra_type == 0 then
        if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  or __lua_project_id == __lua_project_naruto 
            or __lua_project_id == __lua_project_yugioh 
            or __lua_project_id == __lua_project_warship_girl_b 
            or __lua_project_id == __lua_project_pokemon 
            or __lua_project_id == __lua_project_rouge 
            or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
            then 
            local extraReward = 0
            for i, v in pairs(self.rewardParams) do
                if zstring.tonumber(v[1]) <= self.totalDamage then
                    extraReward = zstring.tonumber(v[2])
                end
            end
            ccui.Helper:seekWidgetByName(root,"Text_14_0_0"):setString("" .. extraReward + self.baseReward)
        else
            self:updateDropResounces()
        end
    end
end

function FightUIForDailyActivityCopy:updateDropResounces(params)
    local root = self.roots[1]
    local res_count = "1"
    local drawValue = 0
    local controlValue = 0

    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
        controlValue = math.abs(zstring.tonumber((self.extra_type == 0 and self.totalDamage or self.fightRoundCount)))
        local currentIndex = 0
        local totalAward = 0
        local lastAward = 0
        for i, v in pairs(self.rewardParams) do
            if zstring.tonumber(v[1]) <= controlValue then
                self.extraDamage = zstring.tonumber(v[1])
               
                self.extraReward = zstring.tonumber(v[2])
                currentIndex = i
            end
        end

        if self.extra_type == 1 then
            drawValue = self.extraReward
        else
            drawValue = self.baseReward + self.extraReward * zstring.tonumber(self.extraRate[currentIndex]) / 100.0 + (self.totalDamage - self.extraDamage) * zstring.tonumber(self.damagePercent[currentIndex]) / 100.0
            drawValue = math.floor(drawValue)
        end
    else
        controlValue = math.abs(zstring.tonumber((self.extra_type == 0 and self.totalFightHurt or self.fightRoundCount)))
        local currentIndex = 0
        local totalAward = 0
        local lastAward = 0
        for i, v in pairs(self.rewardParams) do
            if zstring.tonumber(v[1]) <= controlValue then
                self.extraDamage = zstring.tonumber(v[1])
               
                self.extraReward = zstring.tonumber(v[2])
                currentIndex = i
            end

            if zstring.tonumber(v[1]) <= self.lastHurt then
                lastAward = zstring.tonumber(v[2])
            end

            if zstring.tonumber(v[1]) <= self.totalDamage then
                totalAward = zstring.tonumber(v[2])
            end
        end

        if self.extra_type == 1 then
            drawValue = self.extraReward
        else
            drawValue = self.lastTotalHurt + (totalAward - lastAward)*zstring.tonumber(self.extraRate[currentIndex]) / 100.0 + (self.totalFightHurt - self.extraDamage)/self.totalHurts * zstring.tonumber(self.damagePercent[currentIndex]) / 100.0
            self.lastTotalHurt = drawValue
            drawValue = math.floor(drawValue)
        end
    end

    ccui.Helper:seekWidgetByName(root,"Text_14_0"..(self.extra_type == 0 and "_0" or "")):setString(""..drawValue)
end

function FightUIForDailyActivityCopy:init(_fightType)
    self._fightType = _fightType
    return self
end

function FightUIForDailyActivityCopy:onEnterTransitionFinish()
    local csbBattleUI = csb.createNode("duplicate/GameActivity/GameActivity_battle.csb")
    local root = csbBattleUI:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbBattleUI)

    local elementData = dms.element(dms["daily_instance_mould"], tonumber(self.copyId))
    local needParams = zstring.split(dms.atos(elementData, daily_instance_mould.extra_reward), "|")
    local nCount = #needParams
    for i = 1, nCount do
        local params = zstring.split(needParams[i], ",")
        local needValue = params[1]
        local rewardValue = params[2]
        table.insert(self.rewardParams, {needValue, rewardValue})
    end

    self.maxRoundCount = dms.atoi(elementData, daily_instance_mould.round_count)
    self.extra_type = dms.atoi(elementData, daily_instance_mould.extra_type)
    self.baseReward = dms.atoi(elementData, daily_instance_mould.init_reward)
    self.extraRate = zstring.split(dms.atos(elementData, daily_instance_mould.double_cont), ",")
    self.damagePercent = zstring.split(dms.atos(elementData, daily_instance_mould.division_cont), ",")

    -- 回合数限制
    ccui.Helper:seekWidgetByName(root,"Text_14"):setString("0/"..self.maxRoundCount)

    local rewardUIElement = {}
    if self.extra_type == 0 then
        -- 伤害信息显示
        local damageContentLebel = ccui.Helper:seekWidgetByName(root, "Text_13_0")
        damageContentLebel:setString(dms.atos(elementData, daily_instance_mould.extra_reward_condition) .. ":")
        local damageValueLebel = ccui.Helper:seekWidgetByName(root, "Text_14_0")
        damageValueLebel:setString("0")
        damageValueLebel:setPositionX(damageContentLebel:getPositionX() + damageContentLebel:getContentSize().width + 3)

        ccui.Helper:seekWidgetByName(root,"Panel_7"):setVisible(true)
        rewardUIElement = {"Text_13_0_0", "Text_14_0_0"}
    else
        rewardUIElement = {"Text_13_0", "Text_14_0"}
    end

    local rewardType = dms.int(dms["daily_instance_mould"], self.copyId, daily_instance_mould.reward_type)
    local rewardId = dms.int(dms["daily_instance_mould"], self.copyId, daily_instance_mould.reward_id)
    local res_name = ""
    
    -- 根据 类型 道具/ 装备  去取 对应的模板id 的名称
    if rewardType == 6 then
        res_name = dms.string(dms["prop_mould"], rewardId, prop_mould.prop_name)..":"
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            res_name = setThePropsIcon(rewardId)[2]..":"
        end
    elseif rewardType == 7 then
        res_name = dms.string(dms["equipment_mould"], rewardId, equipment_mould.equipment_name)..":"
    else
        res_name = reward_prop_list[rewardType]..":"
    end
    
    
    
    local rewardContentLebel = ccui.Helper:seekWidgetByName(root,rewardUIElement[1])
    rewardContentLebel:setString(res_name)
    local rewardValueLebel = ccui.Helper:seekWidgetByName(root,rewardUIElement[2])
    rewardValueLebel:setString(self.baseReward)
    rewardValueLebel:setPositionX(rewardContentLebel:getPositionX() + rewardContentLebel:getContentSize().width + 3)
end

function FightUIForDailyActivityCopy:onExit()
    state_machine.remove("fight_ui_for_daily_activity_copy_update_fight_round_count")
    state_machine.remove("fight_ui_for_daily_activity_copy_update_fight_damage")
    state_machine.remove("fight_ui_for_daily_activity_copy_update_draw_res_count")
    state_machine.remove("fight_ui_for_daily_activity_copy_begin_calc_fight_hurt")
end
