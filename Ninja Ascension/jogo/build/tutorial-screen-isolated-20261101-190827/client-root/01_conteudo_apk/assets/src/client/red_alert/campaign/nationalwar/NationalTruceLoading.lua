--打开国战加载界面
NationalTruceLoading = class("NationalTruceLoadingClass", Window)

local __national_load_clean_windows           = 4
local __national_load_8                       = 8
local __national_load_12                      = 12
local __national_load_16                      = 16
local __national_load_role                    = 20
local __national_load_24                      = 24
local __national_load_28                      = 28
local __national_load_32                      = 32
local __national_load_36                      = 36
local __national_load_40                      = 40
local __national_load_44                      = 44
local __national_load_48                      = 48
local __national_load_52                      = 52
local __national_load_56                      = 56
local __national_load_60                      = 60
local __national_load_64                      = 64
local __national_load_68                      = 68
local __national_load_72                      = 72
local __national_load_76                      = 76
local __national_load_80                      = 80
local __national_load_84                      = 84
local __national_load_88                      = 88
local __national_load_92                      = 92
local __national_load_96                      = 96
local __national_load_100                     = 100

local one_camp_npc_numbers = 10
local national_truce_loading_window_open_terminal = {
    _name = "national_truce_loading_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("NationalTruceLoadingClass") == nil then
            local _wind = NationalTruceLoading:new()
            _wind:init(params)
            fwin:cleanView(fwin._windows)
            fwin:open(_wind,fwin._windows)
            app.load("client.red_alert.utils.LoadingWindow")
            state_machine.excute("loading_window_open", 0, {_wind, "national_truce_loading_update", "national_truce_loading_window_close"})          
        end

        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local national_truce_loading_window_close_terminal = {
    _name = "national_truce_loading_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("NationalTruceLoadingClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(national_truce_loading_window_open_terminal)
state_machine.add(national_truce_loading_window_close_terminal)
state_machine.init()

function NationalTruceLoading:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
	
	-- load lue file
    app.load("client.red_alert.campaign.nationalwar.NationalWarMap")
	app.load("client.red_alert.campaign.nationalwar.NationalWarCityWarMap")
    app.load("client.red_alert.campaign.nationalwar.NationalWarMilitaryOrder")
	app.load("configs.res.config")
	self.open_type = 0
    self.open_info = false

    -- Initialize national_truce_loading state machine.
    local function init_national_truce_loading_terminal()
        -- update
        local national_truce_loading_update_terminal = {
            _name = "national_truce_loading_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onProgress(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(national_truce_loading_update_terminal)
        state_machine.init()
    end

    -- call func init national_truce_loading state machine.
    init_national_truce_loading_terminal()
end

function NationalTruceLoading:init(params)
	self.open_type = params._datas.open_type
    if params._datas.open_info ~= nil then
        self.open_info = params._datas.open_info
    end
    return self
end

function NationalTruceLoading:onEnterTransitionFinish()
    
end

function NationalTruceLoading:onProgress(progress)
	progress = zstring.tonumber(progress)
    if __national_load_clean_windows == progress then
        -- clean frame windows
        fwin:cleanView(fwin._frameview)
        fwin:cleanView(fwin._background)
        fwin:cleanView(fwin._view)
        fwin:cleanView(fwin._dview)
        fwin:cleanView(fwin._viewdialog)
        fwin:cleanView(fwin._taskbar)
        fwin:cleanView(fwin._ui)
        fwin:cleanView(fwin._dialog)
        fwin:cleanView(fwin._notification)
        fwin:cleanView(fwin._screen)
        fwin:cleanView(fwin._system)
    elseif __national_load_8 == progress then
        ccs.ObjectFactory:destroyInstance()
        ccs.SceneReader:destroyInstance()
        ccs.GUIReader:destroyInstance()
        cc.AnimationCache:destroyInstance()
        ccs.ActionManagerEx:destroyInstance()
        -- ccs.DectionaryHelper:destroyInstance()
        -- cc.SpriteFrameCache:destroyInstance()
        cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()
        ccs.ArmatureDataManager:destroyInstance()
        ccs.TriggerMng:getInstance():removeAll()
        cc.Director:getInstance():getTextureCache():removeUnusedTextures()
        cc.Director:getInstance():getActionManager():removeAllActions()

        -- clear cacher
        cacher.cleanActionTimeline()
        cacher.clearWindowCacher()
        
        self:loadingMapNpcOfCampOne()
    elseif __national_load_40 == progress then
        self:loadingMapNpcOfCampTwo()
    elseif __national_load_44 == progress then
        self:loadingMapNpcOfCampThree()
    elseif __national_load_52 == progress then
        self:loadingEffect()
    elseif __national_load_56 == progress then
		app.load("client.red_alert.campaign.nationalwar.NationalWarMap")
		state_machine.excute("national_war_map_window_open", 0, {self.open_type})
    elseif __national_load_100 == progress then
        if _ED.city_resource_battle_end_info ~= nil then
            state_machine.excute("map_rattling_window_open", 0, _ED.city_resource_battle_end_info)
            _ED.city_resource_battle_end_info = nil
        end
    end 
end

function NationalTruceLoading:loadingMapNpcOfCampOne()
    for i=1,one_camp_npc_numbers do
        app.load("client.battle.fight.FightEnum")
        local temp_bust_index = 0
        if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
            temp_bust_index = "15".. math.random(0,1) .."1_2"
        else
            temp_bust_index = 1003
        end

        local armature = sp.spine_sprite(nil, temp_bust_index, _spine_sprite_animation_names[77], true, nil, nil, cc.p(0.5, 0))
        armature:retain()
        if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
            local armature_camp = sp.spine_sprite(nil, "zy_1", _spine_sprite_animation_names[77], true, nil, nil, cc.p(0.5, 0))
            armature.armature_camp = armature_camp
            armature_camp:setPositionY(20)
            if nil ~= armature.armature_camp then
                armature:addChild(armature_camp)
            end
        end
        state_machine.excute("national_war_map_draw_npc_camp_one",0,armature)
    end 
end

function NationalTruceLoading:loadingMapNpcOfCampTwo()
    for i=1,one_camp_npc_numbers do
        app.load("client.battle.fight.FightEnum")
        local temp_bust_index = 0
        if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
            temp_bust_index = "15".. math.random(0,1) .."1_2"
        else
            temp_bust_index = 1004
        end
        local armature = sp.spine_sprite(nil, temp_bust_index, _spine_sprite_animation_names[77], true, nil, nil, cc.p(0.5, 0))
        armature:retain()
        if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
            local armature_camp = sp.spine_sprite(nil, "zy_2", _spine_sprite_animation_names[77], true, nil, nil, cc.p(0.5, 0))
            armature.armature_camp = armature_camp
            armature_camp:setPositionY(20)
            if nil ~= armature.armature_camp then
                armature:addChild(armature_camp)
            end
        end       

        state_machine.excute("national_war_map_draw_npc_camp_two",0,armature)
    end 
end

function NationalTruceLoading:loadingMapNpcOfCampThree()
    for i=1,one_camp_npc_numbers do
        app.load("client.battle.fight.FightEnum")
        local temp_bust_index = 0
        if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
            temp_bust_index = "15".. math.random(0,1) .."1_2"
        else
            temp_bust_index = 1005
        end
        local armature = sp.spine_sprite(nil, temp_bust_index, _spine_sprite_animation_names[77], true, nil, nil, cc.p(0.5, 0))
        armature:retain()  
        if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
            local armature_camp = sp.spine_sprite(nil, "zy_3", _spine_sprite_animation_names[77], true, nil, nil, cc.p(0.5, 0))
            armature.armature_camp = armature_camp
            armature_camp:setPositionY(20)
            if nil ~= armature.armature_camp then
                armature:addChild(armature_camp)
            end
        end              
        state_machine.excute("national_war_map_draw_npc_camp_three",0,armature)
    end 
end

function NationalTruceLoading:loadingEffect()
    -- 资源点收获动画加载
    for i, v in pairs(config_res.sprites_cached["map_rattling"]) do
        cc.SpriteFrameCache:getInstance():addSpriteFrames(v)
    end
    local effect_paths = nil 
    for i, v in pairs(config_res.armatures_cached["map_rattling"]) do
        effect_paths = v
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
    end
end

function NationalTruceLoading:close()
	if missionIsOver() == false then
		executeNextEvent(nil, true)
	end
end

function NationalTruceLoading:destroy()
    -- clean frame windows
    self:unregisterOnNoteUpdate(self)
    if _ED.national_truce_short_type ~= nil then
        if _ED.national_truce_short_type == 1 then
            state_machine.excute("hero_main_window_open",0,"")
        elseif _ED.national_truce_short_type == 2 then
            state_machine.excute("equipment_window_open",0,"")
        elseif _ED.national_truce_short_type == 3 then
            state_machine.excute("formation_setting_window_open",0,"")
        elseif _ED.national_truce_short_type == 4 then
            state_machine.excute("racecourse_ride_window_open",0,"")
        elseif _ED.national_truce_short_type == 5 then
            app.load("client.red_alert.god_weaponry.GodWeaponry")
            local list = getGodWeaponrySortForFight()
            -- 有蓝三星以上侠客打开兵器谱,没有打开兵器谱入口
            if table.nums(list) == 0 then
                state_machine.excute("national_war_map_window_close",0,{_datas={open_type = 1}})
                state_machine.excute("main_window_open",0,"")
                state_machine.excute("home_select_action_window_open",0,{16})
            else
                state_machine.excute("god_weaponry_window_open",0,"")
            end
        end
        _ED.national_truce_short_type = nil
    end
    state_machine.excute("reward_obtain_window_open",0,{68})
end
-- ----------------------------------------------------------------------------------------------------