-- ----------------------------------------------------------------------------------------------------
-- 说明：战斗资源加载界面
-- ----------------------------------------------------------------------------------------------------
BattleLoading = class("BattleLoadingClass", Window)

-- load lua file
app.load("client.red_alert_time.battle.battle_scene")
app.load("client.red_alert_time.utils.LoadingWindow")

local __battle_load_clean_windows           = 4
local __battle_load_fight_module            = 8
local __battle_load_battle_res              = 12
local __battle_load_scene                   = 16
local __battle_load_role                    = 20
local __battle_load_master                  = 24
local __battle_load_buff                    = 28
local __battle_load_cache                   = 32
local __battle_load_effect                  = 36
local __battle_load_40                      = 40
local __battle_load_44                      = 44
local __battle_load_48                      = 48
local __battle_load_52                      = 52
local __battle_load_56                      = 56
local __battle_load_60                      = 60
local __battle_load_64                      = 64
local __battle_load_68                      = 68
local __battle_load_72                      = 72
local __battle_load_76                      = 76
local __battle_load_80                      = 80
local __battle_load_84                      = 84
local __battle_load_88                      = 88
local __battle_load_92                      = 92
local __battle_load_96                      = 96
local __battle_load_100                     = 100

local battle_loading_window_open_terminal = {
    _name = "battle_loading_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:cleanView(fwin._view)
        local _battleLoading = BattleLoading:new():init(params)
        fwin:open(_battleLoading, fwin._windows)
        state_machine.excute("loading_window_open", 0, {_battleLoading, "battle_loading_update", "battle_loading_window_close", 25})
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local battle_loading_window_close_terminal = {
    _name = "battle_loading_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("BattleLoadingClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(battle_loading_window_open_terminal)
state_machine.add(battle_loading_window_close_terminal)
state_machine.init()

function BattleLoading:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
    self._elapsed = 0
    self._duration = 1

    self._fight_type = 0

    self._battleScene = nil

    self._loadCount = 0

    -- Initialize battle loading state machine.
    local function init_battle_loading_terminal()
        -- 创建攻方队伍信息
        local battle_loading_update_terminal = {
            _name = "battle_loading_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return instance:onProgress(params)
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(battle_loading_update_terminal)
        state_machine.init()
    end

    -- call func init battle loading state machine.
    init_battle_loading_terminal()
end

function BattleLoading:init(params)
    _ED.show_reward_list_group = {}
    self._fight_type = params
    if config_res._sync_draw_open ~= nil and config_res._sync_draw_open ~= "" and config_res._sync_draw_open == true then
    else
        cacher.destoryRefPools()
    end
    fwin:reset(nil)
    cacher.cleanSystemCacher()
    cacher.cleanActionTimeline()
    cacher.removeAllTextures()
    cacher.remvoeUnusedArmatureFileInfoes()
    return self
end

function BattleLoading:onEnterTransitionFinish()
    
end

function BattleLoading:onExit()
    
end

function BattleLoading:onProgress(progress)
    progress = zstring.tonumber(progress)
    -- if __battle_load_clean_windows == progress then
    --     -- clean frame windows
    --     fwin:cleanView(fwin._frameview)
    --     fwin:cleanView(fwin._background)
    --     -- fwin:cleanView(fwin._view)
    --     fwin:cleanView(fwin._dview)
    --     fwin:cleanView(fwin._viewdialog)
    --     fwin:cleanView(fwin._taskbar)
    --     fwin:cleanView(fwin._ui)
    --     fwin:cleanView(fwin._dialog)
    --     fwin:cleanView(fwin._notification)
    --     fwin:cleanView(fwin._screen)
    --     fwin:cleanView(fwin._system)
    -- elseif __battle_load_fight_module == progress then
    --     ccs.ObjectFactory:destroyInstance()
    --     ccs.SceneReader:destroyInstance()
    --     ccs.GUIReader:destroyInstance()
    --     cc.AnimationCache:destroyInstance()
    --     ccs.ActionManagerEx:destroyInstance()
    --     -- ccs.DectionaryHelper:destroyInstance()
    --     -- cc.SpriteFrameCache:destroyInstance()
    --     cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()
    --     ccs.ArmatureDataManager:destroyInstance()
    --     ccs.TriggerMng:getInstance():removeAll()
    --     cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    --     cc.Director:getInstance():getActionManager():removeAllActions()

    --     -- clear cacher
    --     cacher.cleanActionTimeline()
    --     cacher.clearWindowCacher()
        
    --     -- if ____S1 == nil then
    --     --     ____S1 = cc.snapshot()
    --     -- end

    --     _ED._fightModule:initNewBattleField(_ED._scene_npc_id, self._fight_type)
    --     if _ED.tower_partner_shipmould_id ~= nil and tonumber(_ED.tower_partner_shipmould_id) > 0 then
    --         _ED._fightModule:initWithPartner(_ED.tower_partner_shipmould_id)
    --         _ED.tower_partner_shipmould_id = 0
    --     end
    --     _ED._fightModule:initNewBattleInfo()
    -- elseif __battle_load_battle_res == progress then
    --     cc.Director:getInstance():getTextureCache():addImage("images/ui/battle/battle_he.png")
    --     cc.SpriteFrameCache:getInstance():addSpriteFrames("images/ui/battle/battle_he.plist")
    -- elseif __battle_load_scene == progress then
    --     state_machine.excute("battle_scene_window_open", 0, self._fight_type)
    -- elseif __battle_load_role == progress then
    --     state_machine.excute("battle_scene_load_battle_role", 0, 0)
    -- elseif __battle_load_master == progress then
    --     if self._fight_type ~= battle_enum._fight_type._fight_type_20 then
    --         state_machine.excute("battle_scene_load_battle_master", 0, 0)
    --     else
    --         MissionClass._fristFightEnd = true
    --     end
    -- elseif __battle_load_buff == progress then
    --     state_machine.excute("battle_scene_load_buff", 0, 0)
    -- elseif __battle_load_cache == progress then
    --     state_machine.excute("battle_scene_load_cache", 0, 0)
    -- elseif __battle_load_effect <= progress then
    --     return state_machine.excute("battle_scene_load_effect", 0, 0)
    -- else
    --     return true
    -- end
    
    if self._loadCount == 1 then
        -- clean frame windows
        fwin:cleanView(fwin._frameview)
        fwin:cleanView(fwin._background)
        -- fwin:cleanView(fwin._view)
        fwin:cleanView(fwin._dview)
        fwin:cleanView(fwin._viewdialog)
        fwin:cleanView(fwin._taskbar)
        fwin:cleanView(fwin._ui)
        fwin:cleanView(fwin._dialog)
        fwin:cleanView(fwin._notification)
        fwin:cleanView(fwin._screen)
        fwin:cleanView(fwin._system)
    elseif self._loadCount == 2 then
        ccs.ObjectFactory:destroyInstance()
        ccs.SceneReader:destroyInstance()
        ccs.GUIReader:destroyInstance()
        cc.AnimationCache:destroyInstance()
        ccs.ActionManagerEx:destroyInstance()
        -- ccs.DectionaryHelper:destroyInstance()
        -- cc.SpriteFrameCache:destroyInstance()
    elseif self._loadCount == 3 then
        cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()
        ccs.ArmatureDataManager:destroyInstance()
        ccs.TriggerMng:getInstance():removeAll()
        cc.Director:getInstance():getTextureCache():removeUnusedTextures()
        cc.Director:getInstance():getActionManager():removeAllActions()
    elseif self._loadCount == 4 then   
        -- clear cacher
        cacher.cleanActionTimeline()
        cacher.clearWindowCacher()
        
        -- if ____S1 == nil then
        --     ____S1 = cc.snapshot()
        -- end
    elseif self._loadCount == 5 then
        if _ED.god_weaponry_info == nil or table.nums(_ED.god_weaponry_info) == 0 then
            initAllGodWeaponryData()
        end
        _ED._fightModule:initNewBattleField(_ED._scene_npc_id, self._fight_type)
        if _ED.tower_partner_shipmould_id ~= nil and tonumber(_ED.tower_partner_shipmould_id) > 0 then
            _ED._fightModule:initWithPartner(_ED.tower_partner_shipmould_id)
            _ED.tower_partner_shipmould_id = 0
        end
    elseif self._loadCount == 6 then
        _ED._fightModule:initNewBattleInfo()
    elseif self._loadCount == 7 then
        cc.Director:getInstance():getTextureCache():addImage("images/ui/battle/battle_he.png")
    elseif self._loadCount == 8 then
        cc.SpriteFrameCache:getInstance():addSpriteFrames("images/ui/battle/battle_he.plist")
    elseif self._loadCount == 9 then
        self._battleScene = state_machine.excute("battle_scene_window_open", 0, self._fight_type)
    elseif self._loadCount == 10 then
        state_machine.excute("battle_map_window_open", 0, {self._battleScene})
    elseif self._loadCount == 11 then
        state_machine.excute("battle_skill_ui_window_open",0,{self._battleScene})
    elseif self._loadCount == 12 then
        state_machine.excute("battle_ui_window_open",0,{self._battleScene})
    elseif self._loadCount == 13 then
        state_machine.excute("battle_ui_on_update_draw",0,{self._battleScene})
    elseif self._loadCount == 14 then
        state_machine.excute("battle_drop_pos_create",0,{self._battleScene})
    elseif self._loadCount == 15 then
        if checkPvpBattleType(self._fight_type) == true then
            state_machine.excute("battle_pvp_skill_control_open", 0, 0)
        end
    elseif self._loadCount == 16 then
        state_machine.excute("battle_scene_create_attacker_team", 0, self._battleScene)
    elseif self._loadCount == 17 then
        state_machine.excute("battle_scene_create_defender_team", 0, self._battleScene)
    elseif self._loadCount == 18 then
        if self._fight_type ~= battle_enum._fight_type._fight_type_20 then
            state_machine.excute("battle_scene_load_battle_master", 0, 0)
        else
            MissionClass._fristFightEnd = true
        end
    elseif self._loadCount == 19 then
        state_machine.excute("battle_scene_load_buff", 0, 0)
    elseif self._loadCount == 20 then
        state_machine.excute("battle_scene_load_cache", 0, 0)
    elseif self._loadCount == 25 then
        state_machine.excute("battle_scene_load_other_effect", 0, 1)
    elseif self._loadCount == 30 then
        state_machine.excute("battle_scene_load_other_effect", 0, 2)
    elseif self._loadCount > 35 then
        self._loadCount = self._loadCount + 1
        return state_machine.excute("battle_scene_load_effect", 0, 0)
    end

    self._loadCount = self._loadCount + 1

    return false
end

function BattleLoading:close()

end

function BattleLoading:destroy()
    -- clean frame windows
    fwin:cleanView(fwin._windows)
    -- 启动战斗
    state_machine.excute("battle_scene_running", 0, 0)

    --跑马灯
    -- if funOpenDrawTip(55,false) == false then  
    --     app.load("client.home.WarshipGirlPushInfo")
    --     state_machine.excute("warship_girl_push_info_open",0,{_datas={_openType=1}})
    -- end
end
-- ----------------------------------------------------------------------------------------------------