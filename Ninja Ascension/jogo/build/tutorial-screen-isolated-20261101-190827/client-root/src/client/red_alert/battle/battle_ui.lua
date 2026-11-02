-- ----------------------------------------------------------------------------------------------------
-- 说明：战斗UI
-- ----------------------------------------------------------------------------------------------------
BattleUI = class("BattleUIClass", Window)
BattleUI.__is_auto_fight = false

app.load("client.red_alert.cells.battle.battle_ui_icon_cell")
app.load("client.utils.DrawHelper")

local battle_ui_window_open_terminal = {
    _name = "battle_ui_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _battleUI = BattleUI:new():init(params)
        fwin:open(_battleUI)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local battle_ui_window_close_terminal = {
    _name = "battle_ui_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("BattleUIClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(battle_ui_window_open_terminal)
state_machine.add(battle_ui_window_close_terminal)
state_machine.init()

function BattleUI:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

    -- var
    -- 战斗掉落的银币
    self._silver = 0
    self._drop_silver = nil

    -- 战斗掉落的道具
    self._prop = 0
    self._drop_prop = nil

    -- 战斗剩余时间
    self._time_ui = nil

    -- 角色控制UI
    self._role_ui = {nil}

    -- 玩家聚气值
    self._player_sp = encryptInfo(0)

    -- 玩家聚气最大值
    self._player_max_sp = encryptInfo(dms.int(dms["fight_config"], battle_enum._fight_config_num.juqi_full_player, fight_config.attribute))

    -- 主公技列表
    self._listview_protagonist = nil

    -- 主公技能释放状态 
    self._majesty_info = {}

    -- 是否可以施放主公技能
    self._open_player_skill = false

    -- 战斗类型 false: pve,  true pvp
    self._battle_pvp_type = false

    -- 是否为自动战斗
    self._is_auto_fight = false

    -- load lua file 
    app.load("client.red_alert.cells.battle.battle_skills_cell")
    local function init_battle_ui_terminal()
        -- 打开主公技
        local battle_ui_window_open_player_skill_terminal = {
            _name = "battle_ui_window_open_player_skill",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:showMajestyInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

         -- 隐藏主公技
        local battle_ui_window_hide_player_skill_terminal = {
            _name = "battle_ui_window_hide_player_skill",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:hideMajestyInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 禁用所有主公技
        local battle_ui_set_all_majesty_skill_cannot_use_terminal = {
            _name = "battle_ui_set_all_majesty_skill_cannot_use",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setMajestyAllNotUse()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 解除禁用主公技
        local battle_ui_un_set_all_majesty_skill_cannot_use_terminal = {
            _name = "battle_ui_un_set_all_majesty_skill_cannot_use",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:unSetMajestyAllNotUse()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 释放主公技
        local battle_ui_use_majesty_skill_terminal = {
            _name = "battle_ui_use_majesty_skill",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local majesty_id = params[1]
                if majesty_id == nil or majesty_id <= 0 then
                    for i,v in pairs(self._majesty_info) do
                        if v.majesty_use_times == 0 then
                            majesty_id = v.majesty_id
                            break
                        end
                    end
                end
                if majesty_id == 0 then
                    return
                end
                -- state_machine.excute("battle_role_execute_buff_skill", 0, {majesty_id})
                state_machine.excute("battle_scene_execute_master_skill", 0, {0, majesty_id})
                instance._player_sp = encryptInfo(0)
                state_machine.excute("battle_ui_update_player_sp", 0, 0)
                state_machine.excute("battle_ui_window_hide_player_skill", 0, 0)
                instance:updateDrawMajestyInfoByUse(majesty_id)
                if instance._is_auto_fight == false then
                    if config_res.battle ~= nil and config_res.battle.music ~= nil and config_res.battle.music.skill_effect ~= nil then
                        playEffectMusic(config_res.battle.music.skill_effect[1])
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --暂停游戏
        local battle_ui_window_open_time_out_terminal = {
            _name = "battle_ui_window_open_time_out",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("battle_ui_pause_game",0,"")
                state_machine.excute("battle_time_out_window_open",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 暂停战斗接口
        local battle_ui_pause_game_terminal = {
            _name = "battle_ui_pause_game",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:pauseFight()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

       -- 继续战斗接口
        local battle_ui_resume_game_terminal = {
            _name = "battle_ui_resume_game",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:resumeFight()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        -- 更新战斗掉落的银币
        local battle_ui_drop_silver_terminal = {
            _name = "battle_ui_drop_silver",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params[1]
                instance:updateDrawDropSilver(index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 更新战斗掉落的道具
        local battle_ui_drop_prop_terminal = {
            _name = "battle_ui_drop_prop",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params[1]
                instance:updateDrawDropProp(index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 更新战斗剩余时间
        local battle_ui_update_time_terminal = {
            _name = "battle_ui_update_time",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDrawTime(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 更新玩家的SP
        local battle_ui_update_player_sp_terminal = {
            _name = "battle_ui_update_player_sp",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDrawPlayerSP(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 重置玩家的战斗信息显示
        local battle_ui_update_player_reset_terminal = {
            _name = "battle_ui_update_player_reset",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDrawPlayerReset(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 更新角色的HP
        local battle_ui_update_role_hp_terminal = {
            _name = "battle_ui_update_role_hp",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDrawRoleHP(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 更新角色的SP
        local battle_ui_update_role_sp_terminal = {
            _name = "battle_ui_update_role_sp",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDrawRoleSP(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 重置角色的显示
        local battle_ui_update_role_reset_terminal = {
            _name = "battle_ui_update_role_reset",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDrawRoleReset(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 自动战斗
        local battle_ui_automatic_combat_terminal = {
            _name = "battle_ui_automatic_combat",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:automaticCombat()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 获得掉落道具宝箱抖动
        local battle_ui_box_shake_terminal = {
            _name = "battle_ui_box_shake",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onBoxShake()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新战斗场次
        local battle_ui_update_fight_count_terminal = {
            _name = "battle_ui_update_fight_count",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateBattleCount()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local battle_ui_add_partner_effect_terminal = {
            _name = "battle_ui_add_partner_effect",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:addPartnerEffect(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local battle_ui_change_show_state_terminal = {
            _name = "battle_ui_change_show_state",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:changeShowState(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local battle_ui_add_partner_icon_terminal = {
            _name = "battle_ui_add_partner_icon",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:addPartnerIcon(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local battle_ui_on_update_draw_terminal = {
            _name = "battle_ui_on_update_draw",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDraw(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(battle_ui_window_open_player_skill_terminal)
        state_machine.add(battle_ui_window_hide_player_skill_terminal)
        state_machine.add(battle_ui_set_all_majesty_skill_cannot_use_terminal)
        state_machine.add(battle_ui_un_set_all_majesty_skill_cannot_use_terminal)
        state_machine.add(battle_ui_use_majesty_skill_terminal)
        state_machine.add(battle_ui_window_open_time_out_terminal)
        state_machine.add(battle_ui_pause_game_terminal)
        state_machine.add(battle_ui_resume_game_terminal)
        state_machine.add(battle_ui_drop_silver_terminal)
        state_machine.add(battle_ui_drop_prop_terminal)
        state_machine.add(battle_ui_update_time_terminal)
        state_machine.add(battle_ui_update_player_sp_terminal)
        state_machine.add(battle_ui_update_player_reset_terminal)
        state_machine.add(battle_ui_update_role_hp_terminal)
        state_machine.add(battle_ui_update_role_sp_terminal)
        state_machine.add(battle_ui_update_role_reset_terminal)
        state_machine.add(battle_ui_automatic_combat_terminal)
        state_machine.add(battle_ui_box_shake_terminal)
        state_machine.add(battle_ui_update_fight_count_terminal)
        state_machine.add(battle_ui_add_partner_effect_terminal)
        state_machine.add(battle_ui_change_show_state_terminal)
        state_machine.add(battle_ui_add_partner_icon_terminal)
        state_machine.add(battle_ui_on_update_draw_terminal)
        state_machine.init()
    end
    
    -- call func alert_home create state machine.
    init_battle_ui_terminal()    
end

function BattleUI:addPartnerIcon( params )
    local root = self.roots[1]
    local ListView_battle_ui = ccui.Helper:seekWidgetByName(root, "ListView_battle_ui")
    ListView_battle_ui:removeAllItems()
    
    local width = 0
    if nil ~= params then
        local shipMould = dms.element(dms["ship_mould"], params.shipMould)
        local shipMouldId = dms.atoi(shipMould, ship_mould.id)

        local ship = {}
        -- ship.lessHp = 0
        -- ship.maxHp = 0
        ship.ship_template_id = params.shipMould
        ship.ship_type = dms.atoi(shipMould, ship_mould.ship_type)

        local cell = state_machine.excute("battle_ui_icon_cell",0,{ship})
        ListView_battle_ui:addChild(cell)
        self._role_ui[shipMouldId] = cell
        width = cell:getContentSize().width
    end

    local formation = _ED.formetion
    local user_ships = _ED.user_ship
    if self._rootWindows._fight_type == battle_enum._fight_type._fight_type_21 then
        formation = _ED.union.union_team_fight_info.formation
        user_ships = _ED.union.union_team_fight_info.ships
    end
    for idx = 2, 7 do
        local shipId = formation[7 - idx +  2]
        local ship = user_ships[shipId]
        if nil ~= ship then
            local cell = state_machine.excute("battle_ui_icon_cell",0,{ship})
            ListView_battle_ui:addChild(cell)
            self._role_ui[ship.ship_base_template_id] = cell
            -- width = width + cell:getContentSize().width
        end
    end

    ListView_battle_ui:setPositionX(ListView_battle_ui:getPositionX() - width / 2)
end

function BattleUI:changeShowState( params )
    local root = self.roots[1]
    local Image_battle_ui = ccui.Helper:seekWidgetByName(root, "Image_battle_ui")
    local ListView_battle_ui = ccui.Helper:seekWidgetByName(root, "ListView_battle_ui")
    Image_battle_ui:setVisible(params)
    ListView_battle_ui:setVisible(params)
end

function BattleUI:addPartnerEffect( params )
    local root = self.roots[1]
    local Panel_reinforcements = ccui.Helper:seekWidgetByName(root, "Panel_reinforcements")
    if Panel_reinforcements ~= nil then
        Panel_reinforcements:addChild(params)
    end
end

function BattleUI:pauseFight()
    -- state_machine.excute("battle_scene_pause", 0, {})
    state_machine.excute("battle_scene_all_pause", 0, nil)
end

function BattleUI:resumeFight()
    state_machine.excute("battle_scene_resume", 0, 0)
end

function BattleUI:updateDrawDropSilver(index)
    self._silver = self._silver + index
    self._drop_silver:setString(self._silver)
end

function BattleUI:updateDrawDropProp(index)
    self._prop = self._prop + index
    self._drop_prop:setString(self._prop)
end

function BattleUI:updateDrawTime(params)
    local time = math.modf(params)
    local minute = math.floor(time / 60)
    local second = time % 60
    local millisecond = (params - time) * 1000
    -- self._time_ui:setString(string.format("%02d:%02d %03d", minute, second, millisecond))
    self._time_ui:setString(string.format("%02d:%02d", minute, second))
end

function BattleUI:updateDrawPlayerSP(sp)
    self._player_sp = encryptInfo(math.min(decryptInfo(self._player_max_sp), decryptInfo(self._player_sp) + sp))
    local root = self.roots[1]
    local persentSp = (decryptInfo(self._player_sp) / decryptInfo(self._player_max_sp) / 2)  * 100
    persentSp = math.max(0, math.min(50, persentSp))
    self.ProgressTimerBar:setPercentage(persentSp)

    if persentSp >= 50 then
        --怒气满
        if self._open_player_skill == false then
            self._open_player_skill = true
            -- self._Image_battle_ui_loading_bg:setVisible(false)
            state_machine.excute("battle_ui_window_open_player_skill", 0, 0)
            if self._is_auto_fight == true then
                state_machine.excute("battle_ui_use_majesty_skill", 0, {0})
            end
        end
    else
        self._open_player_skill = false
        -- self._Image_battle_ui_loading_bg:setVisible(true)
    end
end

function BattleUI:updateDrawPlayerReset(params)
    
end

function BattleUI:updateDrawRoleHP(params)
    local shipId = zstring.tonumber(params.shipId)
    params.cell = self._role_ui[shipId]
    if nil ~= params.cell then
        state_machine.excute("battle_ui_icon_cell_update_hp", 0, params)
    end
end

function BattleUI:updateDrawRoleSP(params)
    local shipId = zstring.tonumber(params.shipId)
    params.cell = self._role_ui[shipId]
    if nil ~= params.cell then
        state_machine.excute("battle_ui_icon_cell_update_sp", 0, params)
    end
end

function BattleUI:updateDrawRoleReset(params)
    local shipId = zstring.tonumber(params.shipId)
    params.cell = self._role_ui[shipId]
    if nil ~= params.cell then
        state_machine.excute("battle_ui_icon_cell_update_reset", 0, params)
    end
end

function BattleUI:initDrawMajestyInfo()
    local root = self.roots[1]
    local majesty_info = _ED.majesty_info
    if self._rootWindows._fight_type == battle_enum._fight_type._fight_type_20 then
        majesty_info = {"13", "0", "0", "0"}
    end
    for i,v in pairs(majesty_info) do
        if zstring.tonumber(v) ~= 0 then
            local data = {
                majesty_id = tonumber(v),
                majesty_use_times = 0,
            }
            table.insert(self._majesty_info,data)
        end
    end
    self._listview_protagonist:setVisible(false)
    for i,v in pairs(self._majesty_info) do
        local cell = state_machine.excute("battle_skills_create_cell",0,{v})
        self._listview_protagonist:addChild(cell)
    end
    self._listview_protagonist:requestRefreshView()
end

function BattleUI:updateDrawMajestyInfoByUse(majesty_id)
    local root = self.roots[1]
    for i,v in pairs(self._majesty_info) do
        if v.majesty_id == majesty_id then
            v.majesty_use_times = v.majesty_use_times + 1
        end
    end
    for i,cell in pairs(self._listview_protagonist:getItems()) do
        if cell._majesty_id == majesty_id then
            cell._majesty_use_times = cell._majesty_use_times + 1
            cell:setCannotUse()
        end
    end
end

function BattleUI:setMajestyAllNotUse()
    for i,cell in pairs(self._listview_protagonist:getItems()) do
        cell:stopUse()
    end
end

function BattleUI:unSetMajestyAllNotUse()
    for i,cell in pairs(self._listview_protagonist:getItems()) do
        cell:startUse()
    end    
end

function BattleUI:hideMajestyInfo()
    self._listview_protagonist:setVisible(false)
end

function BattleUI:showMajestyInfo()
    local root = self.roots[1]
    local action = self.actions[1]
    local can_user_majesty_skill = false
    for i,v in pairs(self._majesty_info) do
        if v.majesty_use_times == 0 then
            can_user_majesty_skill = true
            break
        end
    end
    if can_user_majesty_skill == false then
        return
    end
    action:stop()
    self._listview_protagonist:setVisible(true)
    action:play("protagonist_skills_open",false)
end

function BattleUI:hideMajestyInfo()
    self._listview_protagonist:setVisible(false)
end

function BattleUI:automaticCombat()
    local Image_Automatic_combat_open = ccui.Helper:seekWidgetByName(self.roots[1], "Image_Automatic_combat_open")
    local Image_Automatic_combat_close = ccui.Helper:seekWidgetByName(self.roots[1], "Image_Automatic_combat_close")
    Image_Automatic_combat_open:setVisible(false)
    Image_Automatic_combat_close:setVisible(false)
    if BattleUI.__is_auto_fight == false then
        self._is_auto_fight = true
        self._listview_protagonist:setVisible(false)
        self._open_player_skill = false
        Image_Automatic_combat_open:setVisible(true)
        -- if self._open_player_skill == true then
        --     state_machine.excute("battle_ui_use_majesty_skill", 0, {0})
        -- end
    else
        self._is_auto_fight = false
        if decryptInfo(self._player_sp) >= decryptInfo(self._player_max_sp) then
            self._listview_protagonist:setVisible(true)
        end
        Image_Automatic_combat_close:setVisible(true)
    end

    BattleUI.__is_auto_fight = self._is_auto_fight
    
    state_machine.excute("battle_scene_auto_fight", 0, self._is_auto_fight)

    for i, v in pairs(self._role_ui) do
        state_machine.excute("battle_ui_icon_cell_auto_fight", 0, {v, self._is_auto_fight})
    end
end

function BattleUI:init(params)
	local rootWindow = params[1]

	self._rootWindows = rootWindow
    self._battle_pvp_type = checkPvpBattleType(self._rootWindows._fight_type)
    return self
end

--获得掉落道具宝箱抖动
function BattleUI:onBoxShake()
    local root = self.roots[1]
    local action = self.actions[1]
    action:play("box_anmi", false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "box_anmi_over" then
        end
    end)
end

function BattleUI:updateBattleCount( ... )
    local root = self.roots[1]
    local Text_round = ccui.Helper:seekWidgetByName(root, "Text_round")
    if Text_round ~= nil then
        Text_round:setString(self._rootWindows._battle_index.."/"..decryptInfo(_ED._fightModule.maxBattleCount))
    end
end

function BattleUI:onUpdateDraw()
    local root = self.roots[1]
    
    local ListView_battle_ui = ccui.Helper:seekWidgetByName(root, "ListView_battle_ui")
    local nCount = 0
    local width = 0
    if self._rootWindows._fight_type == battle_enum._fight_type._fight_type_20 then
        for k,v in pairs(pve_formation_ship_info) do
            if v ~= nil then
                local cell = state_machine.excute("battle_ui_icon_cell",0,{v})
                ListView_battle_ui:addChild(cell)
                self._role_ui[v.shipid] = cell
                nCount = nCount + 1
                width = width + cell:getContentSize().width
            end
        end
    else
        local formation = _ED.formetion
        local user_ships = _ED.user_ship
        if self._rootWindows._fight_type == battle_enum._fight_type._fight_type_21 then
            formation = _ED.union.union_team_fight_info.formation
            user_ships = _ED.union.union_team_fight_info.ships
        end
        for idx = 2, 7 do
            local shipId = formation[7 - idx +  2]
            local ship = user_ships[shipId]
            if nil ~= ship then
                local cell = state_machine.excute("battle_ui_icon_cell",0,{ship})
                ListView_battle_ui:addChild(cell)
                self._role_ui[ship.ship_base_template_id] = cell
                nCount = nCount + 1
                width = width + cell:getContentSize().width
            end
        end
    end
    local listViewSize = ListView_battle_ui:getContentSize()
    -- ListView_battle_ui:setContentSize(cc.size(width, listViewSize.height))
    -- ListView_battle_ui:requestRefreshView()
    -- print(width)

    ListView_battle_ui:setPositionX(ListView_battle_ui:getPositionX() + (listViewSize.width - width) / 2)
    self:initDrawMajestyInfo()
    -- for i,v in pairs(_ED.user_info.battleCache) do
    --     if index == 6 then
    --         return
    --     end
    --     index = index + 1
    --     local cell = state_machine.excute("national_war_hero_icon_create_cell",0,{v})
    --     ListView_battle_ui:addChild(cell)
    -- end

    -- 自动战斗控制
    local Panel_Automatic_combat = ccui.Helper:seekWidgetByName(root, "Panel_Automatic_combat")
    local Panel_Automatic_combat = ccui.Helper:seekWidgetByName(root,"Panel_Automatic_combat")
    Panel_Automatic_combat:setVisible(false)
    if funOpenDrawTip(136,false) == false then 
        Panel_Automatic_combat:setVisible(true)
    end
    local Image_Automatic_combat_open = ccui.Helper:seekWidgetByName(root, "Image_Automatic_combat_open")
    local Image_Automatic_combat_close = ccui.Helper:seekWidgetByName(root, "Image_Automatic_combat_close")
    local Image_Automatic_combat_lock = ccui.Helper:seekWidgetByName(root, "Image_Automatic_combat_lock")
    Panel_Automatic_combat:setTouchEnabled(true)
    if self._battle_pvp_type == true then
        Image_Automatic_combat_lock:setVisible(true)
        Panel_Automatic_combat:setTouchEnabled(false)
        local current_fight = BattleUI.__is_auto_fight
        -- if BattleUI.__is_auto_fight == true then
            BattleUI.__is_auto_fight = false
            self:automaticCombat()
            BattleUI.__is_auto_fight = current_fight
        -- end
    else
        if self._rootWindows._fight_type ~= battle_enum._fight_type._fight_type_20 
            -- or zstring.tonumber(_ED.npc_state[tonumber("".._ED._scene_npc_id)]) > 0 
            then
            Image_Automatic_combat_close:setVisible(true)
            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_Automatic_combat"), nil, 
            {
                terminal_name = "battle_ui_automatic_combat", 
                terminal_state = 0, 
                touch_scale = true,
                touch_scale_xy = 0.95,
            }, nil, 0)

            if BattleUI.__is_auto_fight == true then
                BattleUI.__is_auto_fight = false
                self:automaticCombat()
            end
        end
    end
    
    self:updateBattleCount()
end

function BattleUI:onEnterTransitionFinish()
    local csbItem = csb.createNode(config_csb.battle.battle_ui)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.battle.battle_ui)
    table.insert(self.actions,action)
    csbItem:runAction(action)

    -- 绘制角色头像
    local Panel_battle_ui_player_icon = ccui.Helper:seekWidgetByName(root, "Panel_battle_ui_player_icon")
    if tonumber(_ED.user_info.user_gender) == 1 then
        Panel_battle_ui_player_icon:setBackGroundImage("images/ui/battle/battle_head_men.png", 1)
    else
        Panel_battle_ui_player_icon:setBackGroundImage("images/ui/battle/battle_head_women.png", 1)
    end
    self._drop_silver = ccui.Helper:seekWidgetByName(root, "Text_battle_ui_money")

    self._drop_prop = ccui.Helper:seekWidgetByName(root, "Text_battle_ui_box")

    self._time_ui = ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_time")

    self._Image_battle_ui_loading_bg = ccui.Helper:seekWidgetByName(root, "Image_battle_ui_loading_bg")

    self.Panel_anger_loading = ccui.Helper:seekWidgetByName(root, "Panel_anger_loading")
    self.Sprite_anger_loading = self.Panel_anger_loading:getChildByName("Sprite_anger_loading")
    self._listview_protagonist = ccui.Helper:seekWidgetByName(root, "ListView_protagonist_skills") 
    local pos = cc.p(self.Sprite_anger_loading:getPosition())
    local size = self.Sprite_anger_loading:getContentSize()
    local anchor = self.Sprite_anger_loading:getAnchorPoint()
    self.Sprite_anger_loading:removeFromParent(false)
    self.ProgressTimerBar = cc.ProgressTimer:create(self.Sprite_anger_loading)
    self.ProgressTimerBar:setPosition(pos)
    self.Panel_anger_loading:addChild(self.ProgressTimerBar)
    self.ProgressTimerBar:setReverseDirection(true)
    self.ProgressTimerBar:setPercentage(0)

    local Button_battle_ui_time_out = ccui.Helper:seekWidgetByName(root,"Button_battle_ui_time_out")
    fwin:addTouchEventListener(Button_battle_ui_time_out, nil, 
    {
        terminal_name = "battle_ui_window_open_time_out", 
        -- terminal_name = "battle_ui_window_open_player_skill", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    if zstring.tonumber(_ED.user_info.user_grade) == 1 
        or self._rootWindows._fight_type == battle_enum._fight_type._fight_type_105
        then
        Button_battle_ui_time_out:setVisible(false)
    end
    -- -- 打开主公技
    -- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_collision_1"), nil, 
    -- {
    --     terminal_name = "battle_ui_window_open_player_skill", 
    --     terminal_state = 0, 
    --     touch_scale = true,
    --     touch_scale_xy = 0.95, 
    -- }, nil, 0)

    -- self:onUpdateDraw()
end

function BattleUI:close()

end

function BattleUI:destroy()

end

function BattleUI:onExit()
    state_machine.remove("battle_ui_window_open_player_skill")
    state_machine.remove("battle_ui_window_hide_player_skill")
    state_machine.remove("battle_ui_set_all_majesty_skill_cannot_use")
    state_machine.remove("battle_ui_un_set_all_majesty_skill_cannot_use")
    state_machine.remove("battle_ui_use_majesty_skill")
    state_machine.remove("battle_ui_window_open_time_out")
    state_machine.remove("battle_ui_pause_game") 
    state_machine.remove("battle_ui_resume_game")
    state_machine.remove("battle_ui_drop_silver")
    state_machine.remove("battle_ui_drop_prop")
    state_machine.remove("battle_ui_update_time")
    state_machine.remove("battle_ui_update_player_sp")
    state_machine.remove("battle_ui_update_player_reset")
    state_machine.remove("battle_ui_update_role_hp")
    state_machine.remove("battle_ui_update_role_sp")
    state_machine.remove("battle_ui_update_role_reset")
    state_machine.remove("battle_ui_automatic_combat")
    state_machine.remove("battle_ui_box_shake")
    state_machine.remove("battle_ui_update_fight_count")
    state_machine.remove("battle_ui_add_partner_effect")
    state_machine.remove("battle_ui_change_show_state")
    state_machine.remove("battle_ui_add_partner_icon")
    state_machine.remove("battle_ui_on_update_draw")
end
-- ----------------------------------------------------------------------------------------------------