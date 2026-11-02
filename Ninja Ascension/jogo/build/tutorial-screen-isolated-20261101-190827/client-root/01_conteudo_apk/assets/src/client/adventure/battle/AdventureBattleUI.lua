-- ----------------------------------------------------------------------------------------------------
-- 说明：战斗UI
-------------------------------------------------------------------------------------------------------
AdventureBattleUI = class("AdventureBattleUIClass", Window)
 

function AdventureBattleUI:ctor()
    self.super:ctor()
    self.roots = {}

    self.heros_current_hp = 0
    self.heros_total_hp = 0
    self.masters_current_hp = 0
    self.masters_total_hp = 0

    -- Initialize adventure battle ui state machine.
    local function init_adventure_battle_ui_terminal()
        -- 更新战斗中的HP
        local adventure_battle_ui_update_hp_progress_terminal = {
            _name = "adventure_battle_ui_update_hp_progress",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDrawHpProgress(params)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 更新战斗回合数
        local adventure_battle_ui_update_round_terminal = {
            _name = "adventure_battle_ui_update_round",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDrawFightRound(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

         -- 跳过战斗
        local adventure_Battle_ui_tiaoguo_terminal = {
            _name = "adventure_Battle_ui_tiaoguo",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local root = self.roots[1]
                ccui.Helper:seekWidgetByName(root, "Button_tiaoguo"):setVisible(false)
                state_machine.excute("adventure_battle_jump_fight", 0, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
          -- 更新跳过按钮
        local adventure_Battle_ui_update_junp_fight_terminal = {
            _name = "adventure_Battle_ui_update_junp_fight",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local root = self.roots[1]
                ccui.Helper:seekWidgetByName(root, "Button_tiaoguo"):setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 更新战斗中战斗属性
        local adventure_battle_ui_update_fight_info_terminal = {
            _name = "adventure_battle_ui_update_fight_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDrawFightInfo(params)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 更新四维属性变化
        local adventure_battle_ui_update_change_fight_info_terminal = {
            _name = "adventure_battle_ui_update_change_fight_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDrawFightChangeInfo(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(adventure_battle_ui_update_hp_progress_terminal)
        state_machine.add(adventure_battle_ui_update_round_terminal)
        state_machine.add(adventure_battle_ui_update_fight_info_terminal)
        state_machine.add(adventure_Battle_ui_tiaoguo_terminal)
        state_machine.add(adventure_Battle_ui_update_junp_fight_terminal)
        state_machine.add(adventure_battle_ui_update_change_fight_info_terminal)
        
        state_machine.init()
    end
    
    -- call func init adventure battle ui state machine.
    init_adventure_battle_ui_terminal()
end

function AdventureBattleUI:init()
    self.heros_total_hp = zstring.tonumber(_ED.battleCompInfo._hero_info._capacity)
    self.heros_current_hp = self.heros_total_hp

    self.masters_total_hp = zstring.tonumber(_ED.battleCompInfo._master_info._capacity)
    self.masters_current_hp = self.masters_total_hp

	return self
end

function AdventureBattleUI:updateDrawFightRound(params)
    local root = self.roots[1]
    local roundCount = "" .. (params or 0)
    local BitmapFontLabel_1 = ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_1")
    BitmapFontLabel_1:setString(roundCount)
end

function AdventureBattleUI:updateDrawHpProgress(params, isInit)
    local root = self.roots[1]

    local camp = tonumber(params[1])
    local subValue = tonumber(params[2])
    local skillInfluenceElementData = params[3]
    if camp == 0 then
        self.heros_current_hp = self.heros_current_hp + subValue
        if self.heros_current_hp < 0 then
            self.heros_current_hp = 0
        end
        local ownerHP = ccui.Helper:seekWidgetByName(root, "Text_zhanli_own")
        ownerHP:setString(self.heros_current_hp)

        local LoadingBar_hp_own = ccui.Helper:seekWidgetByName(root, "LoadingBar_own")
        local parent = math.max(0, math.min(100, self.heros_current_hp / self.heros_total_hp * 100))
        -->__crint("parent camp0", parent)
        LoadingBar_hp_own:setPercent(parent)
    else
        self.masters_current_hp = self.masters_current_hp + subValue
        if self.masters_current_hp < 0 then
            self.masters_current_hp = 0
        end
        local enemyHP = ccui.Helper:seekWidgetByName(root, "Text_zhanli_enemy")
        enemyHP:setString(self.masters_current_hp)

        local LoadingBar_hp_enemy = ccui.Helper:seekWidgetByName(root, "LoadingBar_enemy")
        local parent = math.max(0, math.min(100, self.masters_current_hp / self.masters_total_hp * 100))
        -->__crint("parent camp1", parent)
        LoadingBar_hp_enemy:setPercent(parent)
    end
    if isInit ~= true then
        state_machine.excute("adventure_battle_map_draw_damage_and_buff", 0, {camp, subValue, skillInfluenceElementData})
    end
end

function AdventureBattleUI:updateDrawFightInfo(params)
    local root = self.roots[1]

    local camp = params[1]
    if camp == 0 then
        local moveLevelText = ccui.Helper:seekWidgetByName(root, "Text_xiangong")
        moveLevelText:setString(_ED.battleCompInfo._hero_info._move_level)

        local defLevelText = ccui.Helper:seekWidgetByName(root, "Text_fangyu")
        defLevelText:setString(_ED.battleCompInfo._hero_info._def_level)

        local missLevelText = ccui.Helper:seekWidgetByName(root, "Text_shanbi")
        missLevelText:setString(_ED.battleCompInfo._hero_info._miss_level)

        local kingLevelText = ccui.Helper:seekWidgetByName(root, "Text_wangzhe")
        kingLevelText:setString(_ED.battleCompInfo._hero_info._king_level)
    else
        local moveLevelText = ccui.Helper:seekWidgetByName(root, "Text_xiangong_1")
        moveLevelText:setString(_ED.battleCompInfo._master_info._move_level)

        local defLevelText = ccui.Helper:seekWidgetByName(root, "Text_fangyu_1")
        defLevelText:setString(_ED.battleCompInfo._master_info._def_level)

        local missLevelText = ccui.Helper:seekWidgetByName(root, "Text_shanbi_1")
        missLevelText:setString(_ED.battleCompInfo._master_info._miss_level)

        local kingLevelText = ccui.Helper:seekWidgetByName(root, "Text_wangzhe_1")
        kingLevelText:setString(_ED.battleCompInfo._master_info._king_level)
    end
end

function AdventureBattleUI:updateDrawFightChangeInfo(params)
    local root = self.roots[1]

    local camp = params[3]
    local defenderST = params[1]
    local subValue = tonumber(params[2])
    if tonumber(camp) == 0 then  --我方
        if tonumber(defenderST) == 2 then 
            _ED.battleCompInfo._hero_info._move_level = tonumber(_ED.battleCompInfo._hero_info._move_level) + subValue 
        elseif tonumber(defenderST) == 3 then 
            _ED.battleCompInfo._hero_info._def_level = tonumber(_ED.battleCompInfo._hero_info._def_level) + subValue 
        elseif tonumber(defenderST) == 4 then 
            _ED.battleCompInfo._hero_info._miss_level = tonumber(_ED.battleCompInfo._hero_info._miss_level) + subValue 
        elseif tonumber(defenderST) == 5 then 
            _ED.battleCompInfo._hero_info._king_level = tonumber(_ED.battleCompInfo._hero_info._king_level) + subValue 
        end
    else
        if tonumber(defenderST) == 2 then 
            _ED.battleCompInfo._master_info._move_level = tonumber(_ED.battleCompInfo._master_info._move_level) + subValue 
        elseif tonumber(defenderST) == 3 then 
            _ED.battleCompInfo._master_info._def_level = tonumber(_ED.battleCompInfo._master_info._def_level) + subValue 
        elseif tonumber(defenderST) == 4 then 
            _ED.battleCompInfo._master_info._miss_level = tonumber(_ED.battleCompInfo._master_info._miss_level) + subValue 
        elseif tonumber(defenderST) == 5 then 
            _ED.battleCompInfo._master_info._king_level = tonumber(_ED.battleCompInfo._master_info._king_level) + subValue 
        end
    end
    self:updateDrawFightInfo({camp})
end


function AdventureBattleUI:onEnterTransitionFinish()
	local csbAdventureBattleUI = csb.createNode("battle/battle_ui.csb")
    local root = csbAdventureBattleUI:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureBattleUI)

    local ownerName = ccui.Helper:seekWidgetByName(root, "Text_own_name")
    ownerName:setString(_ED.user_info.user_name)
    local enemyName = ccui.Helper:seekWidgetByName(root, "Text_enemy_name")
    
    
    if zstring.tonumber(_game_platform_version_type) == 3 and (zstring.tonumber(_ED.battleData.battle_init_type) >= 0 
        and zstring.tonumber(_ED.battleData.battle_init_type) <= 9 )
        or zstring.tonumber(_ED.battleData.battle_init_type) == 14 then 
        --pve
        local battleNpcName = dms.string(dms["npc"], zstring.tonumber(_ED._scene_npc_id), npc.npc_name)
        enemyName:setString(battleNpcName)   
    else
        --pvp
        enemyName:setString(_ED.battleData._armys[1]._battleName)    
    end

     
    -- 跳过战斗
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tiaoguo"),       nil, 
    {
        terminal_name = "adventure_Battle_ui_tiaoguo",
        current_button_name = "Button_tiaoguo",        
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)          

    self:updateDrawHpProgress({0, 0, nil}, true)
    self:updateDrawHpProgress({1, 0, nil}, true)

    self:updateDrawFightInfo({0})
    self:updateDrawFightInfo({1})

    self:updateDrawFightRound("0")
end

function AdventureBattleUI:onExit()
    state_machine.remove("adventure_battle_ui_update_hp_progress")
    state_machine.remove("adventure_battle_ui_update_round")
    state_machine.remove("adventure_battle_ui_update_fight_info")
    state_machine.remove("adventure_Battle_ui_tiaoguo")
    state_machine.remove("adventure_Battle_ui_update_junp_fight")
    state_machine.remove("adventure_battle_ui_update_change_fight_info")
end