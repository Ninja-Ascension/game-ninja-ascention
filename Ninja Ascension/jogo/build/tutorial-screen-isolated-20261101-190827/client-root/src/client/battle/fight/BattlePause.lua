BattlePause = class("BattlePauseClass", Window)

local battle_pause_window_open_terminal = {
    _name = "battle_pause_window_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if funOpenDrawTip(90) then
            return false
        end
        -- state_machine.excute("explore_window_close")
        if nil == fwin:find("BattlePauseClass") then
            fwin:open(BattlePause:new():init(params), fwin._dialog)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local battle_pause_window_close_terminal = {
    _name = "battle_pause_window_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("BattlePauseClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local battle_pause_terminal = {
    _name = "battle_pause",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local function doPause( _layer )
            _layer:pause()
            for i, v in pairs(_layer:getChildren()) do
                doPause(v)
            end
        end
        doPause(fwin._background._layer)
        doPause(fwin._view._layer)
        doPause(fwin._windows._layer)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local battle_resume_terminal = {
    _name = "battle_resume",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local function doResume( _layer )
            _layer:resume()
            for i, v in pairs(_layer:getChildren()) do
                doResume(v)
            end
        end
        doResume(fwin._background._layer)
        doResume(fwin._view._layer)
        doResume(fwin._windows._layer)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(battle_pause_window_open_terminal)
state_machine.add(battle_pause_window_close_terminal)
state_machine.add(battle_pause_terminal)
state_machine.add(battle_resume_terminal)
state_machine.init()

function BattlePause:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
    self._fight_type = -1

    -- Initialize battle pause page state machine.
    local function init_battle_pause_terminal()
        -- 返回战斗
        local battle_pause_back_battle_terminal = {
            _name = "battle_pause_back_battle",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:doBackBattle()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 退出战斗
        local battle_pause_exit_battle_terminal = {
            _name = "battle_pause_exit_battle",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:doExitBattle()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(battle_pause_back_battle_terminal)
        state_machine.add(battle_pause_exit_battle_terminal)
        state_machine.init()
    end

    -- call func init battle pause state machine.
    init_battle_pause_terminal()
end

function BattlePause:doPause( _layer )
    _layer:pause()
    for i, v in pairs(_layer:getChildren()) do
        self:doPause(v)
    end
end

function BattlePause:doResume( _layer )
    _layer:resume()
    for i, v in pairs(_layer:getChildren()) do
        self:doResume(v)
    end
end

function BattlePause:init(params)
    self._fight_type = params
    -- fwin._background._layer:pause()
    -- fwin._view._layer:pause()
    -- fwin._windows._layer:pause()
    -- cc.Director:getInstance():pause()
    -- self:doPause(cc.Director:getInstance():getRunningScene())

    self:doPause(fwin._background._layer)
    self:doPause(fwin._view._layer)
    self:doPause(fwin._windows._layer)
    return self
end

function BattlePause:doBackBattle()
    -- cc.Director:getInstance():resume()
    state_machine.excute("battle_pause_window_close", 0, 0)
end

function BattlePause:doExitBattle()
    -- cc.Director:getInstance():resume()
    cc.Director:getInstance():getScheduler():setTimeScale(1)
    local _fight_type = self._fight_type
    state_machine.excute("battle_pause_window_close", 0, 0)

    fwin._last_music = nil
    fwin._current_music = nil

    _ED.battle_playback_arena = {}
    -- fwin:removeAll()
    -- cacher.removeAllObject(_object)
    cacher.removeAllTextures()
    fwin:reset(nil)
    -- fwin:removeAll()
    app.load("client.home.Menu")
    fwin:open(Menu:new(), fwin._taskbar)

    --教学战斗中途退出，清除其数据
    _ED._battle_eve_unlock_npc = 0

    if _fight_type == _enum_fight_type._fight_type_11 then ----jjc
        app.load("client.l_digital.campaign.Campaign")
        state_machine.excute("campaign_window_open", 0, nil)
        app.load("client.l_digital.campaign.arena.Arena")
        state_machine.excute("arena_window_open", 0, nil)
    elseif _fight_type == _enum_fight_type._fight_type_53 then
        app.load("client.l_digital.campaign.digitalpurify.DigitalPurifyWindow")
        state_machine.excute("digital_purify_window_open", 0, 0)
    else
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            -- print("_fight_type==".._fight_type)
            if _fight_type == _enum_fight_type._fight_type_2 then --金钱副本
                app.load("client.l_digital.explore.activity_copy.ActivityCopyWindow")
                state_machine.excute("activity_copy_window_open", 0, 0)
            elseif _fight_type == _enum_fight_type._fight_type_3 then --经验副本
                app.load("client.l_digital.explore.activity_copy.ActivityCopyWindow")
                state_machine.excute("activity_copy_window_open", 0, 0)
            elseif _fight_type == _enum_fight_type._fight_type_51 then --幻象挑战
                app.load("client.l_digital.explore.activity_copy.ActivityCopyWindow")
                state_machine.excute("activity_copy_window_open", 0, 0)
            elseif _fight_type == _enum_fight_type._fight_type_52 then --技之作战
                app.load("client.l_digital.explore.activity_copy.ActivityCopyWindow")
                state_machine.excute("activity_copy_window_open", 0, 0)
            elseif _fight_type == _enum_fight_type._fight_type_54 and _ED.fury_tower_battle ~= nil
                and FuryTowers_battleQuit ~= nil then -- Fury: torres diaria/semanal
                FuryTowers_battleQuit()
            elseif _fight_type == _enum_fight_type._fight_type_54 then --数码试炼
                app.load("client.l_digital.campaign.trialtower.TrialTower")
                fwin:open(TrialTower:new(), fwin._ui) 
            elseif _fight_type == _enum_fight_type._fight_type_7 then --公会副本
                app.load("client.l_digital.union.duplicate.SmUnionDuplicate")
                state_machine.excute("sm_union_duplicate_open", 0, nil)
                app.load("client.l_digital.union.duplicate.SmUnionPveBattleWindow")
                state_machine.excute("sm_union_pve_battle_window_open", 0, {_ED.union_attack_npc_id,_ED.union_attack_data_id})
            elseif _fight_type == _enum_fight_type._fight_type_211 then -- 王者之战
                -- print("王者之战中断退出战斗")
            elseif _fight_type == _enum_fight_type._fight_type_212 then
                if _ED.previous_ship_evo_window == "FormationTigerGateClass" then
                    state_machine.excute("formation_open_instance_window",0,{_datas = {_shipInstance = _ED.battle_evo_ship_info}})
                    -- state_machine.excute("formation_open_instance_window", 0, {_datas = {_shipInstance = }})
                    -- state_machine.excute("formation_set_ship",0,_ED.battle_evo_ship_info)
                elseif _ED.previous_ship_evo_window == "SmRoleStrengthenTabClass" then
                    app.load("client.packs.hero.HeroDevelop")
                    local heroDevelopWindow = HeroDevelop:new()
                    local ship_info = _ED.battle_evo_ship_info
                    ship_info.shengming = zstring.tonumber(ship_info.ship_health)
                    ship_info.gongji = zstring.tonumber(ship_info.ship_courage)
                    ship_info.waigong = zstring.tonumber(ship_info.ship_intellect)
                    ship_info.neigong = zstring.tonumber(ship_info.ship_quick)
                    heroDevelopWindow:init(ship_info.ship_id, "learn")
                    fwin:open(heroDevelopWindow, fwin._viewdialog)
                end
            elseif _fight_type == _enum_fight_type._fight_type_213 then
                state_machine.excute("union_fighting_main_open", 0, {notReqeust = true})

            -- 跨服矿战
            elseif _fight_type == _enum_fight_type._fight_type_214 then
                app.load("client.l_digital.campaign.Campaign")
                state_machine.excute("campaign_window_open", 0, nil)
                app.load("client.l_digital.campaign.CrossServerBattel.CrossServerBattelMap")
                state_machine.excute("cross_server_battel_map_window_open", 0, nil)
            --世界boss
            elseif _fight_type == _enum_fight_type._fight_type_218 then
                if fwin:find("WorldBossWindowClass") == nil then
                    app.load("client.l_digital.campaign.exploration.ExplorationLoading")
                    fwin:open(ExplorationLoading:new():init(218), fwin._taskbar)
                end
            -- 跨服忍界
            elseif _fight_type == _enum_fight_type._fight_type_219 then
                app.load("client.l_digital.campaign.Campaign")
                state_machine.excute("campaign_window_open", 0, nil)
                app.load("client.l_digital.campaign.cross_total_war.CrossTotalWar")
                state_machine.excute("cross_total_war_window_open", 0, "cross_total_war_window_open.")
            -- 跨服竞技小队
            elseif _fight_type == _enum_fight_type._fight_type_220 then
                app.load("client.l_digital.campaign.Campaign")
                state_machine.excute("campaign_window_open", 0, nil)
                app.load("client.l_digital.campaign.team_arena.TeamArena")
                state_machine.excute("team_arena_window_open", 0, "")

            elseif _ED.battleData.battle_init_type == _enum_fight_type._fight_type_215 
                or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_216
                or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_217
                or _ED.fileIsland.fileIslandFriendCellInfo_goBattle == true
                then
                if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                    -- if fwin:find("HomeClass") == nil then
                    --     state_machine.excute("menu_manager", 0, 
                    --         {
                    --             _datas = {
                    --                 terminal_name = "menu_manager",     
                    --                 next_terminal_name = "menu_show_home_page", 
                    --                 current_button_name = "Button_home",
                    --                 but_image = "Image_home",       
                    --                 terminal_state = 0, 
                    --                 _needOpenHomeHero = true,
                    --                 isPressedActionEnabled = true
                    --             }
                    --         }
                    --     )
                    -- end
                    -- state_machine.excute("menu_back_home_page", 0, "")
                    -- state_machine.excute("home_change_open_atrribute", 0, false)
                    app.load("client.l_digital.campaign.exploration.ExplorationLoading")
                    fwin:open(ExplorationLoading:new():init(), fwin._taskbar)
                else
                    app.load("client.l_digital.campaign.fileIsland.FileIslandWindow")
                    state_machine.excute("fileIsland_window_open", 0, 1)
                end
            elseif _fight_type == _enum_fight_type._fight_type_13 then
                if fwin:find("HomeClass") == nil then
                    state_machine.excute("menu_manager", 0, 
                        {
                            _datas = {
                                terminal_name = "menu_manager",     
                                next_terminal_name = "menu_show_home_page", 
                                current_button_name = "Button_home",
                                but_image = "Image_home",       
                                terminal_state = 0, 
                                _needOpenHomeHero = true,
                                isPressedActionEnabled = true
                            }
                        }
                    )
                end
                state_machine.excute("menu_back_home_page", 0, "")
                state_machine.excute("home_change_open_atrribute", 0, false)
            else
                state_machine.excute("lduplicate_window_pve_quick_entrance", 0, 
                {
                    _type    = LDuplicateWindow._infoDatas._type, 
                    _sceneId = LDuplicateWindow._infoDatas._chapter
                })
            end
        else
            state_machine.excute("lduplicate_window_pve_quick_entrance", 0, 
            {
                _type    = LDuplicateWindow._infoDatas._type, 
                _sceneId = LDuplicateWindow._infoDatas._chapter
            })
        end
    end
end

function BattlePause:onEnterTransitionFinish()
    local csbNode = csb.createNode("battle/battle_pause.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    -- 战斗暂停界面-返回战斗按钮
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back_to_battle"), nil, 
    {
        terminal_name = "battle_pause_back_battle",
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, nil, 0)

    -- 战斗暂停界面-退出战斗按钮
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_out_to_battle"), nil, 
    {
        terminal_name = "battle_pause_exit_battle",
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, nil, 0)
end

function BattlePause:onExit()
    self:doResume(fwin._background._layer)
    self:doResume(fwin._view._layer)
    self:doResume(fwin._windows._layer)

    state_machine.remove("fight_ui_back_battle")
    state_machine.remove("fight_ui_exit_battle")
end
