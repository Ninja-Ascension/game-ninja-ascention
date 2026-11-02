LoginLoading = class("LoginLoadingClass", Window)

local __login_loding_load_4           		  = 4
local __login_loding_load_8                   = 8
local __login_loding_load_12                  = 12
local __login_loding_load_16                  = 16
local __login_loding_load_20                  = 20
local __login_loding_load_24                  = 24
local __login_loding_load_28                  = 28
local __login_loding_load_32                  = 32
local __login_loding_load_36                  = 36
local __login_loding_load_40                  = 40
local __login_loding_load_44                  = 44
local __login_loding_load_48                  = 48
local __login_loding_load_52                  = 52
local __login_loding_load_56                  = 56
local __login_loding_load_60                  = 60
local __login_loding_load_64                  = 64
local __login_loding_load_68                  = 68
local __login_loding_load_72                  = 72
local __login_loding_load_76                  = 76
local __login_loding_load_80                  = 80
local __login_loding_load_84                  = 84
local __login_loding_load_88                  = 88
local __login_loding_load_92                  = 92
local __login_loding_load_96                  = 96
local __login_loding_load_100                 = 100

local login_loading_window_open_terminal = {
	_name = "login_loading_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("LoginLoadingClass") == nil then
			local _wind = LoginLoading:new()
	        _wind:init(params)
			fwin:open(_wind, fwin._windows)
			app.load("client.red_alert_time.utils.LoadingWindow")
			state_machine.excute("loading_window_open", 0, {_wind, "login_loading_update", "login_loading_window_close"})
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local login_loading_window_close_terminal = {
	_name = "login_loading_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("LoginLoadingClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local login_loading_window_join_game_world_terminal = {
    _name = "login_loading_window_join_game_world",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        resetMission()
        -- fwin:freeAllView()
        -- cacher.cleanActionTimeline()
        -- cacher.cleanSystemCacher()
        cacher.removeAllTextures()

        NetworkAdaptor.XMLHttpRequest.open_auto_reconnect = true
        if nil ~= NetworkAdaptor.LuaSocket.url then
            NetworkAdaptor.intSocket()
        end

        state_machine.excute("main_window_open",0,"")
        state_machine.excute("main_window_show",0,"")
        fwin:__show(fwin._frameview)
        NetworkManager:registerKeepAlive(protocol_command.keep_alive.code, 180*2)
        

        if cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_WINDOWS 
            and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_LINUX 
            and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_MAC then
            handlePlatformRequest(0, CC_INITIALIZE_RECHARGE_PARAM, "")
        end
        
        -- if missionIsOver() == false then
        --     executeNextEvent(nil, false)
        -- end

        -- 读取事件的跳过状态
        local keyName = "skip_mission_grop_ids"
        local sdata = readKey(keyName)

        if nil ~= sdata and #sdata > 0 then
            local arr = zstring.split(sdata, ",")
            _ED._mission_1 = arr[1]
            _ED._mission_2 = arr[2]
            _ED._mission_3 = arr[3]
        end

        if nil ~= mission_tip_string and nil ~= _ED.user_info and nil ~= _ED.user_info.user_grade and "" ~= _ED.user_info.user_grade then
            local msp = zstring.split(mission_tip_string[4], ",")
            if tonumber(msp[1]) <= tonumber(_ED.user_info.user_grade) 
                and tonumber(msp[2]) <= tonumber(_ED.user_info.user_experience) 
                then
                _ED._mission_3 = _ED._mission_3 or "0"
                if tonumber(msp[4]) > tonumber(_ED._mission_3) then
                    _ED._mission_3 = msp[4]
                end
            end
        end
        
        app.load("client.red_alert_time.activity.wonderful.HelpTroopsReward")

        app.load("client.mission.missionex.NewPalyerReward")
        app.load("client.mission.newfunopen.NewFunctionOpen")
        executeResetCurrentEvent()
        if missionIsOver() == true then
            if executeMissionExt(mission_mould_tuition, nil, nil, nil, true, "l".._ED.user_info.user_grade.."e".._ED.user_info.user_experience, true) == false then
            end
        end

        if missionIsOver() == true and _ED._mission_execute ~= nil and tonumber(_ED._mission_execute[1]) == 3 then
            local missions = dms.searchs(dms["mission3"], 1, _ED._mission_execute[2], 2, _ED._mission_execute[3])
            if nil ~= missions and #missions > 0 then
                local mission = missions[1]
                if executeMissionExt(mission_mould_tuition, touch_off_mission_into_home, mission[mission_off], nil, true, mission[mission_start_param], true) == false then
                end
            end
        end

        if missionIsOver() == true then
            state_machine.excute("main_window_check_mission", 0, 0)
        end

        app.load("client.utils.LoginOfOtherTip")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(login_loading_window_open_terminal)
state_machine.add(login_loading_window_close_terminal)
state_machine.add(login_loading_window_join_game_world_terminal)
state_machine.init()

function LoginLoading:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

    self._need_create_player = false

    app.load("client.red_alert_time.home.MainWindow")
    local function init_login_loading_terminal()
        local login_loading_update_terminal = {
            _name = "login_loading_update",
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
        state_machine.add(login_loading_update_terminal)
        state_machine.init()
    end
    init_login_loading_terminal()
end

function LoginLoading:init(params)
    self._need_create_player = params
    return self
end

function LoginLoading:onEnterTransitionFinish()
    
end

function LoginLoading:onProgress(progress)
	progress = zstring.tonumber(progress)
    if __login_loding_load_4 == progress then
        self:initUserInfo()
    	self:loadingBuildInfo()
        self:loadingPushUserPropInfo()
        if __lua_project_id == __lua_project_pacific_rim then
            loadWorldMapInfo()
        end
    elseif __login_loding_load_8 == progress then
        self:loadingBuildLevelInfo()
        self:loadingPropInfo()
        dms.searchs(dms["world_mine_mould"], world_mine_mould.id, "")
        dms.searchs(dms["build_boom_lose"], build_boom_lose.id, "")
    elseif __login_loding_load_12 == progress then
        cc.dms_init_world_map_dirc(600)
		app.load("client.adventure.campaign.mine.AdventureMineManager")
        state_machine.excute("adventure_mine_manager_reload_action", 0, 0)
        state_machine.excute("adventure_mine_manager_open",0,false)
        state_machine.excute("adventure_mine_manager_hide", 0, nil)
    elseif __login_loding_load_16 == progress then
        if nil ~= NetworkAdaptor.LuaSocket.url then
            NetworkAdaptor.intSocket()
        end
    elseif __login_loding_load_20 == progress then
        self:loadingBarracksInfo()
        self:loadingCSBResources01()
    elseif __login_loding_load_24 == progress then
        self:loadingBarracksLevelInfo()
        self:loadingUIEffectResources()
    elseif __login_loding_load_28 == progress then
    	self:loadingPropMakeInfo()
        app.load("client.red_alert_time.activity.wonderful.Wonderful")
        state_machine.excute("wonderful_window_loading",0,nil)
        state_machine.excute("wonderful_window_hide",0,nil)
    elseif __login_loding_load_32 == progress then
    	self:loadingSkillInfo()
        app.load("client.red_alert_time.pve.PveMap")
        -- state_machine.excute("short_cut_go_to_other_window",0,{47})
    elseif __login_loding_load_36 == progress then
    	self:loadingPrestigeLevelInfo()
    elseif __login_loding_load_40 == progress then
    	self:loadingCatalogueMouldInfo()
    elseif __login_loding_load_44 == progress then
    	self:loadingBuildShopInfo()
    elseif __login_loding_load_48 == progress then
        self:loadingMilitaryMouldInfo()
    elseif __login_loding_load_52 == progress then
        self:loadingAvatarCommandInfo()
    elseif __login_loding_load_56 == progress then
		self:loadingBattleResources()
	elseif __login_loding_load_60 == progress then
	   self:loadFightResource01()
	elseif __login_loding_load_64 == progress then
	   self:loadingBuidlBuff()
    elseif __login_loding_load_68 == progress then
       self:loadingAvatarShop()
       if nil ~= _ED.user_info.user_head_id and _ED.user_info.user_head_id ~= "" then
           state_machine.excute("main_window_open",0,"")
           state_machine.excute("wonderful_window_hide", 0, 0)
        end
    elseif __login_loding_load_72 == progress then
       self:loadingEquipmentShop()
    elseif __login_loding_load_76 == progress then
       self:loadingStrategyCombatInfo()    
    elseif __login_loding_load_80 == progress then
       self:loadingLegionScienceLevelInfo()
    elseif __login_loding_load_84 == progress then
       self:loadingFightCenterList()
    elseif __login_loding_load_88 == progress then
        self:praseSystemPushInfo()
    elseif __login_loding_load_92 == progress then
        
    else
        -- if true == self._need_create_player then
        --     state_machine.excute("create_character_window_open", 0, "create_character_window_open.")
        -- end
    end
end

function LoginLoading:loadingPropInfo( ... )
    dms.searchs(dms["prop_mould"], prop_mould.id, "")
    _ED.base_prop_info = {}
    for i= 1, dms.count(dms["prop_mould"]) do
        local prop_info = {}
        local data_temp = dms.element(dms["prop_mould"], i)
        prop_info.id = i
        prop_info.prop_name = data_temp[prop_mould.prop_name]
        prop_info.pic_index = data_temp[prop_mould.pic_index]
        prop_info.storage_page_index = data_temp[prop_mould.storage_page_index]
        prop_info.change_of_equipment = data_temp[prop_mould.change_of_equipment]
        prop_info.use_of_ship = data_temp[prop_mould.use_of_ship]
        _ED.base_prop_info[""..i] = prop_info
    end
end

-- 初始化默认用户数据
function LoginLoading:initUserInfo()
    -- if nil == _ED.user_info.user_head_id then
    --     _ED.home_build_max_count = 0
    --     _ED.vip_grade = 0
    --     _ED.user_info = {
    --         tiger_shaped = "5000",
    --         exploit = "",
    --         dispatch_token = "",
    --         tiger_shaped_max = "0",
    --         user_glory = "0",
    --         fighter_capacity = "189",
    --         capture_head = "",
    --         key_user_gold = "||76",
    --         user_id = "3105",
    --         user_name = "",
    --         recharge_all_rmb = "0",
    --         capture_grade = "",
    --         max_user_food = "25",
    --         user_force = "0",
    --         family_name = "",
    --         horse_spirits_patch = "0",
    --         oil_field_max = "0",
    --         user_silver = "5000",
    --         user_gender = "1",
    --         friend_active = "",
    --         key_user_id = "||3105",
    --         family_index = "0",
    --         resource_experience = "0",
    --         credit_buy_state = "0",
    --         all_glories = "",
    --         endurance = "20",
    --         soul = "0",
    --         booming = "60",
    --         jade = "0",
    --         user_experience = "0",
    --         forage = "60",
    --         user_food_add_cd = "1491638761617",
    --         user_honour = "0",
    --         key_vip_level = "||0",
    --         misson_id = "305036",
    --         key_user_all_gems = "||0",
    --         credit_level = "1",
    --         capture_vip_grade = "",
    --         user_train = "",
    --         user_gold = "76",
    --         capture_id = "",
    --         user_food = "25",
    --         current_war_industry = "0",
    --         fight_capacity = 0,
    --         total_war_industry = "0",
    --         war_industry_level = "1",
    --         user_silver_max = "0",
    --         oil_field = "55000",
    --         user_invite = "",
    --         exploits_max = "0",
    --         exploits = "40000",
    --         user_iron = "70000",
    --         user_iron_max = "0",
    --         soldier = "5",
    --         credit = "0",
    --         dragon_horse_patch = "0",
    --         user_ship = "",
    --         command_level = "0",
    --         user_grade_need_experience = 5,
    --         create_time = "1491638761",
    --         max_endurance = "",
    --         user_union_fight_exploit = "0",
    --         user_head_id = "1,0,0",
    --         user_train_ship = "",
    --         key_user_grade = "||1",
    --         user_head = "",
    --         new_user_teach_record = "",
    --         user_fight = "",
    --         union_contribute = "0",
    --         capture_name = "",
    --         vip_level = "0",
    --         user_grade = "1",
    --         user_all_gems = "0"
    --     }
    -- end
end

-- 建筑模板
function LoginLoading:loadingBuildInfo( ... )
	_ED.base_build_info = {}
	for i= 1, dms.count(dms["build_mould"]) do
		local build_info = {}
		local data_temp = dms.element(dms["build_mould"], i)
		build_info.id = i
		build_info.build_name = dms.atos(data_temp, build_mould.build_name)
		build_info.pic = dms.atoi(data_temp, build_mould.pic)
		build_info.fun_open_tab_id = dms.atoi(data_temp, build_mould.fun_open_tab_id)
		build_info.build_type = dms.atoi(data_temp, build_mould.build_type)
		build_info.max_level = dms.atoi(data_temp, build_mould.max_level)
		build_info.build_ids = dms.atos(data_temp, build_mould.build_ids)
		build_info.upgrade_factor = dms.atof(data_temp, build_mould.upgrade_factor)
		build_info.cost_iron_factor = dms.atof(data_temp, build_mould.cost_iron_factor)
		build_info.cost_oil_factor = dms.atof(data_temp, build_mould.cost_oil_factor)
		build_info.cost_lead_factor = dms.atof(data_temp, build_mould.cost_lead_factor)
		build_info.get_gem_factor = dms.atof(data_temp, build_mould.get_gem_factor)
		build_info.get_iron_factor = dms.atof(data_temp, build_mould.get_iron_factor)
		build_info.get_oil_factor = dms.atof(data_temp, build_mould.get_oil_factor)
		build_info.get_lead_factor = dms.atof(data_temp, build_mould.get_lead_factor)
		build_info.get_tita_factor = dms.atof(data_temp, build_mould.get_tita_factor)
		build_info.gem_pack_factor = dms.atof(data_temp, build_mould.gem_pack_factor)
		build_info.iron_pack_factor = dms.atof(data_temp, build_mould.iron_pack_factor)
		build_info.oil_pack_factor = dms.atof(data_temp, build_mould.oil_pack_factor)
		build_info.lead_pack_factor = dms.atof(data_temp, build_mould.lead_pack_factor)
		build_info.tita_pack_factor = dms.atof(data_temp, build_mould.tita_pack_factor)
		build_info.base_booming_value = dms.atoi(data_temp, build_mould.base_booming_value)
		build_info.add_booming_value = dms.atoi(data_temp, build_mould.add_booming_value)
		build_info.add_get_speed = dms.atof(data_temp, build_mould.add_get_speed)
        build_info.build_size = dms.atoi(data_temp, build_mould.build_dec)
        build_info.need_time = dms.atoi(data_temp, build_mould.need_time)
		_ED.base_build_info[""..i] = build_info
	end
end

-- 建筑升级
function LoginLoading:loadingBuildLevelInfo( ... )
	_ED.base_build_level_info = {}
	for i= 1, dms.count(dms["build_level"]) do
		local build_level_info = {}
		local build_level_mould_info = dms.element(dms["build_level"], i)
		build_level_info.cur_level = dms.atoi(build_level_mould_info, build_level.cur_level)
		build_level_info.need_time = dms.atoi(build_level_mould_info, build_level.need_time)
		build_level_info.cost = dms.atoi(build_level_mould_info, build_level.cost)
		build_level_info.base_produce = dms.atof(build_level_mould_info, build_level.base_produce)
		build_level_info.base_pack_value = dms.atoi(build_level_mould_info, build_level.base_pack_value)
		_ED.base_build_level_info[""..build_level_info.cur_level] = build_level_info
	end
end

-- 科技模板
function LoginLoading:loadingBarracksInfo()
    _ED.base_barracks_info = {}
    for i= 1, dms.count(dms["teach_escalate_param"]) do
        local barracks_info = {}
        local barracks_mould_info = dms.element(dms["teach_escalate_param"], i)
        barracks_info.id = i
        barracks_info.name = dms.atos(barracks_mould_info, teach_escalate_param.name)
        barracks_info.pic_index = dms.atoi(barracks_mould_info, teach_escalate_param.pic_index)
        barracks_info.update_group = dms.atoi(barracks_mould_info, teach_escalate_param.update_group)
        barracks_info.open_level = dms.atoi(barracks_mould_info, teach_escalate_param.open_level)
        barracks_info.max_level = dms.atoi(barracks_mould_info, teach_escalate_param.max_level)
        barracks_info.order = dms.atoi(barracks_mould_info, teach_escalate_param.order)
        barracks_info.upgrade_factor = dms.atof(barracks_mould_info, teach_escalate_param.upgrade_factor)
        barracks_info.cost_iron_factor = dms.atof(barracks_mould_info, teach_escalate_param.cost_iron_factor)
        barracks_info.cost_oil_factor = dms.atof(barracks_mould_info, teach_escalate_param.cost_oil_factor)
        barracks_info.cost_lead_factor = dms.atof(barracks_mould_info, teach_escalate_param.cost_lead_factor)
        barracks_info.cost_tita_factor = dms.atof(barracks_mould_info, teach_escalate_param.cost_tita_factor)
        barracks_info.cost_gem_factor = dms.atof(barracks_mould_info, teach_escalate_param.cost_gem_factor)
        barracks_info.dec = dms.atos(barracks_mould_info, teach_escalate_param.dec)
        barracks_info.gift = dms.atoi(barracks_mould_info, teach_escalate_param.gift)
        _ED.base_barracks_info[""..i] = barracks_info
    end
end

-- 科技升级
function LoginLoading:loadingBarracksLevelInfo( ... )
    _ED.base_barracks_level_info = {}
    for i= 1, dms.count(dms["teach_level"]) do
        local barracks_level_info = {}
        local barracks_level_mould_info = dms.element(dms["teach_level"], i)
        barracks_level_info.cur_level = dms.atoi(barracks_level_mould_info, teach_level.cur_level)
        barracks_level_info.need_time = dms.atoi(barracks_level_mould_info, teach_level.need_time)
        barracks_level_info.cost_iron = dms.atoi(barracks_level_mould_info, teach_level.cost_iron)
        barracks_level_info.cost_oil = dms.atoi(barracks_level_mould_info, teach_level.cost_oil)
        barracks_level_info.cost_lead = dms.atoi(barracks_level_mould_info, teach_level.cost_lead)
        barracks_level_info.cost_tita = dms.atoi(barracks_level_mould_info, teach_level.cost_tita)
        barracks_level_info.cost_gem = dms.atoi(barracks_level_mould_info, teach_level.cost_gem)
        _ED.base_barracks_level_info[""..barracks_level_info.cur_level] = barracks_level_info
    end
end

-- 道具制造
function LoginLoading:loadingPropMakeInfo( ... )
    _ED.base_prop_make_info = {}
    for i= 1, dms.count(dms["prop_make"]) do
        local prop_info = {}
        local prop_mould_info = dms.element(dms["prop_make"], i)
        prop_info.id = dms.atoi(prop_mould_info, prop_make.id)
        prop_info.need_level = dms.atoi(prop_mould_info, prop_make.need_level)
        prop_info.need_vip_level = dms.atoi(prop_mould_info, prop_make.need_vip_level)
        prop_info.need_time = dms.atoi(prop_mould_info, prop_make.need_time)
        prop_info.cost = dms.atos(prop_mould_info, prop_make.cost)
        prop_info.get_prop_id = dms.atoi(prop_mould_info, prop_make.get_prop_id)
        _ED.base_prop_make_info[""..prop_info.id] = prop_info
    end
end

-- 用户技能表
function LoginLoading:loadingSkillInfo( ... )
    _ED.base_skill_info = {}
    for i= 1, dms.count(dms["majesty_skill"]) do
        local skill_info = {}
        local skill_mould_info = dms.element(dms["majesty_skill"], i)
        skill_info.id = dms.atoi(skill_mould_info, majesty_skill.id)
        skill_info.index = i
        skill_info.skill_name = dms.atos(skill_mould_info, majesty_skill.skill_name)
        skill_info.skill_pic = dms.atoi(skill_mould_info, majesty_skill.skill_pic)
        skill_info.open_level = dms.atoi(skill_mould_info, majesty_skill.open_level)
        skill_info.to_skill_id = dms.atoi(skill_mould_info, majesty_skill.to_skill_id)
        skill_info.dec = dms.atos(skill_mould_info, majesty_skill.dec)
        _ED.base_skill_info[""..skill_info.id] = skill_info
    end
end

-- 用户声望等级
function LoginLoading:loadingPrestigeLevelInfo( ... )
    _ED.base_prestige_level_info = {}
    for i= 1, dms.count(dms["avatar_prestige_level"]) do
        local prestige_info = {}
        local prestige_mould_info = dms.element(dms["avatar_prestige_level"], i)
        prestige_info.id = dms.atoi(prestige_mould_info, avatar_prestige_level.id)
        prestige_info.level = dms.atos(prestige_mould_info, avatar_prestige_level.level)
        prestige_info.max_point = dms.atoi(prestige_mould_info, avatar_prestige_level.max_point)
        prestige_info.max_scientific_level = dms.atoi(prestige_mould_info, avatar_prestige_level.max_scientific_level)
        _ED.base_prestige_level_info[""..prestige_info.level] = prestige_info
    end
end

-- 坦克仓库
function LoginLoading:loadingCatalogueMouldInfo( ... )
    _ED.base_catalogue_storage_info = {}
    for i= 1, dms.count(dms["catalogue_storage_mould"]) do
        local catalogue_info = {}
        local catalogue_mould_info = dms.element(dms["catalogue_storage_mould"], i)
        catalogue_info.id = dms.atoi(catalogue_mould_info, catalogue_storage_mould.id)
        catalogue_info.types = dms.atos(catalogue_mould_info, catalogue_storage_mould.types)
        catalogue_info.ship_mould_id = dms.atoi(catalogue_mould_info, catalogue_storage_mould.ship_mould_id)
        catalogue_info.row = dms.atoi(catalogue_mould_info, catalogue_storage_mould.row)
        _ED.base_catalogue_storage_info[""..catalogue_info.ship_mould_id] = catalogue_info
    end
end

-- 建筑商店
function LoginLoading:loadingBuildShopInfo( ... )
    _ED.base_build_shop_info = {}
    for i= 1, dms.count(dms["build_shop"]) do
        local build_shop_info = {}
        local build_shop_mould_info = dms.element(dms["build_shop"], i)
        build_shop_info.id = dms.atoi(build_shop_mould_info, build_shop.id)
        build_shop_info.buy_type = dms.atos(build_shop_mould_info, build_shop.buy_type)
        build_shop_info.resource_type = dms.atoi(build_shop_mould_info, build_shop.resource_type)
        build_shop_info.prop_ids = zstring.split(dms.atos(build_shop_mould_info, build_shop.prop_ids), ",")
        if _ED.base_build_shop_info[""..build_shop_info.buy_type] == nil then
        	_ED.base_build_shop_info[""..build_shop_info.buy_type] = {}
        end
        if _ED.base_build_shop_info[""..build_shop_info.buy_type][""..build_shop_info.resource_type] == nil then
        	_ED.base_build_shop_info[""..build_shop_info.buy_type][""..build_shop_info.resource_type] = {}
        end
        _ED.base_build_shop_info[""..build_shop_info.buy_type][""..build_shop_info.resource_type] = build_shop_info
    end
end

-- 用户军衔模板
function LoginLoading:loadingMilitaryMouldInfo( ... )
    _ED.base_military_info = {}
    for i= 1, dms.count(dms["avatar_mould"]) do
        local military_info = {}
        local military_mould_info = dms.element(dms["avatar_mould"], i)
        military_info.id = dms.atoi(military_mould_info, avatar_mould.id)
        military_info.name = dms.atos(military_mould_info, avatar_mould.name)
        military_info.pic = dms.atoi(military_mould_info, avatar_mould.pic)
        military_info.need_military = dms.atoi(military_mould_info, avatar_mould.need_military)
        military_info.need_level = dms.atoi(military_mould_info, avatar_mould.need_level)
        military_info.max_user_count = dms.atoi(military_mould_info, avatar_mould.max_user_count)
        military_info.add_famtion = dms.atoi(military_mould_info, avatar_mould.add_famtion)
        military_info.add_attack = dms.atoi(military_mould_info, avatar_mould.add_attack)
        military_info.add_power = dms.atoi(military_mould_info, avatar_mould.add_power)
        military_info.add_credit = dms.atoi(military_mould_info, avatar_mould.add_credit)
        _ED.base_military_info[""..military_info.id] = military_info
    end
end

-- 用户统率
function LoginLoading:loadingAvatarCommandInfo()
    _ED.base_command_info = {}
    for i= 1, dms.count(dms["avatar_command"]) do
        local command_info = {}
        local command_mould_info = dms.element(dms["avatar_command"], i)
        command_info.id = dms.atoi(command_mould_info, avatar_command.id)
        command_info.current_level = dms.atoi(command_mould_info, avatar_command.current_level)
        command_info.need_level = dms.atoi(command_mould_info, avatar_command.need_level)
        command_info.current_famtion = dms.atoi(command_mould_info, avatar_command.current_famtion)
        command_info.update_cost = dms.atos(command_mould_info, avatar_command.update_cost)
        command_info.success_percent = dms.atoi(command_mould_info, avatar_command.success_percent)
        command_info.fail_count = dms.atoi(command_mould_info, avatar_command.fail_count)
        command_info.success_count = dms.atoi(command_mould_info, avatar_command.success_count)
        _ED.base_command_info[""..command_info.current_level] = command_info
    end
end

-- 战力提升路径
function LoginLoading:loadingStrategyCombatInfo()
    _ED.strategy_combat_info = {}
    for i= 1, dms.count(dms["strategy_combat"]) do
        local strategy_info = {}
        local strategy_mould_info = dms.element(dms["strategy_combat"], i)
        strategy_info.id = dms.atoi(strategy_mould_info, strategy_combat.id)
        strategy_info.index = i
        strategy_info.name = dms.atos(strategy_mould_info, strategy_combat.name)
        strategy_info.dec = dms.atos(strategy_mould_info, strategy_combat.dec)
        strategy_info.pic = zstring.split(dms.atos(strategy_mould_info, strategy_combat.pic),",")
        strategy_info.short_id = dms.atoi(strategy_mould_info, strategy_combat.short_id)
        strategy_info.ntype = dms.atoi(strategy_mould_info, strategy_combat.ntype)
        _ED.strategy_combat_info[""..strategy_info.id] = strategy_info
    end
end

function LoginLoading:loadingCSBResources01()
    for i = 1,5 do
        csbCacher.createUIRef(config_csb.cells.pve.pve_chapter_cell, "root")
    end
    for i = 1,5 do
        csbCacher.createUIRef(string.format(config_csb.cells.pve.pve_map_npc_cell, i), "root")
    end
    for i = 1,5 do
        csbCacher.createUIRef(config_csb.cells.formation.formation_cell_1, "root")
        csbCacher.createUIRef(config_csb.cells.formation.formation_cell_2, "root")
    end
    for i = 1,3 do
        csbCacher.createUIRef(config_csb.cells.task.task_main_cell_1, "root")
        csbCacher.createUIRef(config_csb.cells.task.task_main_cell_2, "root")
    end
    for i = 1, 9 do
        for c = 1, 4 do
            csbCacher.createUIRef(string.format(config_csb.cells.props.props_res_icon, i), "root")
        end
    end
    for i = 1,5 do
        csbCacher.createUIRef(config_csb.cells.activity.act_share_cell_1, "root")
    end
    for i = 1,10 do
        csbCacher.createUIRef(config_csb.cells.player.player_fight_cell, "root")
    end
    for i = 1,8 do
        csbCacher.createUIRef(config_csb.cells.build_up.build_up_scientific_cell, "root")
    end
end

function LoginLoading:loadingUIEffectResources()
    for i, v in pairs(config_res.armatures_cached["ui"]) do
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(v)
    end
end

function LoginLoading:loadingBattleResources()
	-- cc.Director:getInstance():getTextureCache():addImage("images/ui/battle/battle_1.png")
	-- cc.SpriteFrameCache:getInstance():addSpriteFrames("images/ui/battle/battle_1.plist")
	-- --boss形象
	-- -- local pathName = string.format(self._boss_battle_card_string,self._boss_battle_card_num)
	-- -- ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(pathName)
	--兵种的形象
    if __lua_project_id == __lua_project_pacific_rim then
        -- for i=1, 2 do
        --     local baseName = "sprite/spirte_battle_card_100"..i
        --     sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil):retain()
        --     sp.spine(baseName .. "_1.json", baseName .. "_1.atlas", 1, 0, nil, false, nil):retain()

        --     baseName = "sprite/spirte_battle_card_110"..i
        --     sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil):retain()
        --     -- sp.spine(baseName .. "_1.json", baseName .. "_1.atlas", 1, 0, nil, false, nil):retain()

        --     baseName = "sprite/spirte_battle_card_120"..i
        --     sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil):retain()
        --     sp.spine(baseName .. "_1.json", baseName .. "_1.atlas", 1, 0, nil, false, nil):retain()

        --     baseName = "sprite/spirte_battle_card_130"..i
        --     sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil):retain()
        --     sp.spine(baseName .. "_1.json", baseName .. "_1.atlas", 1, 0, nil, false, nil):retain()
        -- end

        for i=1, 4 do
            if true == cc.FileUtils:getInstance():isFileExist("effect/effice_" .. i .. ".ExportJson") then
                ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("effect/effice_" .. i .. ".ExportJson")
            end
            if true == cc.FileUtils:getInstance():isFileExist("effect/effice_" .. i .. "_1.ExportJson") then
                ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("effect/effice_" .. i .. "_1.ExportJson")
            end
            if true == cc.FileUtils:getInstance():isFileExist("effect/effice_" .. i .. "_2.ExportJson") then
                ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("effect/effice_" .. i .. "_2.ExportJson")
            end
            if true == cc.FileUtils:getInstance():isFileExist("effect/effice_10" .. i .. ".ExportJson") then
                ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("effect/effice_10" .. i .. ".ExportJson")
            end
            if true == cc.FileUtils:getInstance():isFileExist("effect/effice_100" .. i .. ".ExportJson") then
                ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("effect/effice_100" .. i .. ".ExportJson")
            end
        end
    else
    	for i=1, 5 do
    		ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_battle_card_100"..i..".ExportJson")
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_battle_card_100"..i.."_1.ExportJson")

            ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_battle_card_120"..i..".ExportJson")
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_battle_card_120"..i.."_1.ExportJson")

            ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_battle_card_130"..i..".ExportJson")
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_battle_card_130"..i.."_1.ExportJson")
    	end

        for i=1, 4 do
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("effect/effice_" .. i .. ".ExportJson")
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("effect/effice_10" .. i .. ".ExportJson")
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("effect/effice_100" .. i .. ".ExportJson")
        end
    end

    app.load("client.adventure.cells.mine.adventure_mine_tile_cell")
    local fileName = "map/base_npc/spirte_beattacked.ExportJson"
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(fileName)
    if #AdventureMineTileCell._city_armature == 0 then
        for i=1, 50 do
            local sprite = ccs.Armature:create("spirte_beattacked")
            sprite:getAnimation():playWithIndex(0)
            sprite:retain()
            table.insert(AdventureMineTileCell._city_armature, sprite)
        end
    end

    if __lua_project_id == __lua_project_pacific_rim then
        local fileName = "map/world/effect_sea.ExportJson"
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(fileName)
        if #AdventureMineTileCell._world_sea_animation == 0 then
            for i=1, 20 do
                local sprite = ccs.Armature:create("effect_sea")
                sprite:getAnimation():playWithIndex(0)
                sprite:retain()
                table.insert(AdventureMineTileCell._world_sea_animation, sprite)
            end
        end

        local fileName = "map/world/effect_edge.ExportJson"
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(fileName)
        if #AdventureMineTileCell._world_edge_animation == 0 then
            for i=1, 10 do
                local sprite = ccs.Armature:create("effect_edge")
                sprite:getAnimation():playWithIndex(0)
                sprite:retain()
                table.insert(AdventureMineTileCell._world_edge_animation, sprite)
            end
        end

        -- 资源类型图标
        if table.nums(AdventureMineTileCell._mine_icon) == 0 then
            for j = 1, 10 do
                for i = 1, 5 do
                    local mineIcon = ccui.ImageView:create(config_res.images.ui.home._ui_res_type_small_icon[i], 1)
                    mineIcon.mine_type = i
                    mineIcon:retain()
                    AdventureMineTileCell._mine_icon[i] = AdventureMineTileCell._mine_icon[i] or {}
                    table.insert(AdventureMineTileCell._mine_icon[i], mineIcon)
                end
            end
        end
    end

    --保护罩
    fileName = "images/ui/effice/effect_shield/effect_shield.ExportJson"
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(fileName)
    if #AdventureMineTileCell._shelter_armature == 0 then
        for i=1, 10 do
            local sprite = ccs.Armature:create("effect_shield")
            sprite:getAnimation():playWithIndex(0)
            sprite:retain()
            table.insert(AdventureMineTileCell._shelter_armature, sprite)
        end
    end

    --基地等级
    if #AdventureMineTileCell._mine_level_bg == 0 then
        for i=1, 25 do
            local mineLevelBg = cc.Sprite:create("images/ui/home/build_name_bg.png")
            mineLevelBg._m_width = mineLevelBg:getContentSize().width
            local mineLevel = cc.Label:createWithTTF("", config_res.font.font_name, 20 / CC_CONTENT_SCALE_FACTOR())
            mineLevelBg:retain()
            mineLevel:retain()
            table.insert(AdventureMineTileCell._mine_level_bg, mineLevelBg)
            table.insert(AdventureMineTileCell._mine_level, mineLevel)
        end
    end

    --基地名称
    if #AdventureMineTileCell._mine_name_bg == 0 then
        for i=1,25 do
            local mineNameBg = ccui.ImageView:create("images/ui/home/build_name_bg.png")
            mineNameBg._m_width = mineNameBg:getContentSize().width
            local mineName = cc.Label:createWithTTF("", config_res.font.font_name, 16 / CC_CONTENT_SCALE_FACTOR())
            mineNameBg:retain()
            mineName:retain()
            table.insert(AdventureMineTileCell._mine_name_bg, mineNameBg)
            table.insert(AdventureMineTileCell._mine_name, mineName)
        end
    end

    --基地军团icon
    if #AdventureMineTileCell._mine_legion_icon == 0 then
        for i=1,10 do
            local mineLogoImage = cc.Sprite:create("images/ui/legion/legion_icon_world.png")
            mineLogoImage:retain()
            table.insert(AdventureMineTileCell._mine_legion_icon, mineLogoImage)
        end
    end

    --基地繁荣度
    if #AdventureMineTileCell._mine_glories_bg == 0 then
        for i=1,25 do
            local mineGloriesBg = ccui.ImageView:create("images/ui/home/parrss_loading_bg.png")
            mineGloriesBg._m_width = mineGloriesBg:getContentSize().width
            local minePragress = ccui.LoadingBar:create()
            local mi_occupied = cc.Sprite:create("map/base_npc/map_503.png")
            mineGloriesBg:retain()
            minePragress:retain()
            mi_occupied:retain()
            table.insert(AdventureMineTileCell._mine_glories_bg, mineGloriesBg)
            table.insert(AdventureMineTileCell._mine_pragress, minePragress)
            table.insert(AdventureMineTileCell._mine_occupied, mi_occupied)
        end
    end

    --叛军hp
    if #AdventureMineTileCell._rebel_hp_bg == 0 then
        for i=1,10 do
            local rebelHpBg = ccui.ImageView:create("images/ui/share/pve_hp_loadingbar_bg1.png")
            rebelHpBg._m_width = rebelHpBg:getContentSize().width
            local rebelHpBar = ccui.LoadingBar:create()
            rebelHpBg:retain()
            rebelHpBar:retain()
            table.insert(AdventureMineTileCell._rebel_hp_bg, rebelHpBg)
            table.insert(AdventureMineTileCell._rebel_hp, rebelHpBar)
        end
    end

    --矿点等级
    if table.nums(AdventureMineTileCell._mine_quality_level_bg) == 0 then
        for j=1,10 do
            for i = 1, 3 do
                local levelBg = ccui.ImageView:create("images/ui/share/res_lv_bg_"..i..".png")
                local mi_quality = cc.Sprite:create("images/ui/share/res_arrow_"..i..".png")
                
                levelBg._m_width = levelBg:getContentSize().width
                levelBg:retain()
                AdventureMineTileCell._mine_quality_level_bg[i] = AdventureMineTileCell._mine_quality_level_bg[i] or {}
                table.insert(AdventureMineTileCell._mine_quality_level_bg[i], levelBg)
                mi_quality:retain()
                AdventureMineTileCell._mine_quality[i] = AdventureMineTileCell._mine_quality[i] or {}
                table.insert(AdventureMineTileCell._mine_quality[i], mi_quality)
            end
        end
    end

    if table.nums(AdventureMineTileCell._mine_quality_bg) == 0 then
        for i=1,25 do
            local mineBg = ccui.ImageView:create("images/ui/home/build_name_bg.png")
            mineBg._m_width = mineBg:getContentSize().width
            mineBg:retain()
            table.insert(AdventureMineTileCell._mine_quality_bg, mineBg)
        end
    end

    --占矿旗帜
    if #AdventureMineTileCell._mine_my_capture == 0 then
        for i=1, 10 do
            local my_capture = cc.Sprite:create("map/base_npc/map_501.png")
            my_capture:retain()
            table.insert(AdventureMineTileCell._mine_my_capture, my_capture)
            local un_capture = cc.Sprite:create("map/base_npc/map_502.png")
            un_capture:retain()
            table.insert(AdventureMineTileCell._mine_un_capture, un_capture)
        end
    end

    if table.nums(AdventureMineTileCell._rebel_haunt_armature) == 0 then
        for i=1, 3 do
            local armatureName = "spirte_battle_card_140".. i
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/".. armatureName ..".ExportJson")

            local bgtsprite = ccs.Armature:create(armatureName)
            bgtsprite:getAnimation():playWithIndex(0)
            bgtsprite:retain()
            AdventureMineTileCell._rebel_haunt_armature[1400 + i] = AdventureMineTileCell._rebel_haunt_armature[1400 + i] or {}
            table.insert(AdventureMineTileCell._rebel_haunt_armature[1400 + i], bgtsprite)
        end
    end

    if table.nums(AdventureMineTileCell._mine_armatures) == 0 then
        local pics = {}
        for i, element in pairs(dms["world_mine_mould"]) do
            local pic = dms.atos(element, world_mine_mould.pic)
            local mine_type = dms.atoi(element, world_mine_mould.mine_type)
            if mine_type <= 5 then
                pics[pic] = pic
            end
        end

        for i, pic in pairs(pics) do
            for n = 1, 3 do
                local effect_paths = string.format(config_res.images.ui.home.home_build_effect, tonumber(pic))
                ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
                local armature = ccs.Armature:create("home_build_"..pic)
                armature:getAnimation():playWithIndex(0)
                armature:retain()
                AdventureMineTileCell._mine_armatures[pic] = AdventureMineTileCell._mine_armatures[pic] or {}
                armature._pic = pic
                table.insert(AdventureMineTileCell._mine_armatures[pic], armature)
            end
        end
    end

    -- 工厂等级图标
    if table.nums(AdventureMineTileCell._city_factory_level_icon) == 0 then
        for j = 1, 5 do
            for i = 1, 5 do
                local level_icon = cc.Sprite:create(string.format(config_res.images.ui.legion.legion_city_forcaty, i))
                level_icon.factory_level = i
                level_icon:retain()
                AdventureMineTileCell._city_factory_level_icon[i] = AdventureMineTileCell._city_factory_level_icon[i] or {}
                table.insert(AdventureMineTileCell._city_factory_level_icon[i], level_icon)
            end
        end
    end
end

function LoginLoading:loadFightResource01()
    app.load("client.battle.fight.Fight")
    for i, v in pairs(config_res.armatures_cached["battle"]) do
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(v)
    end

    -- ui
    cc.Director:getInstance():getTextureCache():addImage("images/ui/battle/battle_1.png")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("images/ui/battle/battle_1.plist")
end

-- 建筑增益光环
function LoginLoading:loadingBuidlBuff()
    _ED.base_build_buff = {}
    for i= 1, dms.count(dms["build_buff"]) do
        local build_buff_info = {}
        local build_buff_mould_info = dms.element(dms["build_buff"], i)
        build_buff_info.id = dms.atoi(build_buff_mould_info, build_buff.id)
        build_buff_info.pic = zstring.split(dms.atos(build_buff_mould_info, build_buff.pic), ",")
        build_buff_info.info = dms.atos(build_buff_mould_info, build_buff.info)
        build_buff_info.is_show = dms.atoi(build_buff_mould_info, build_buff.is_show)
        build_buff_info.shop_id = dms.atoi(build_buff_mould_info, build_buff.shop_id)
        _ED.base_build_buff[""..build_buff_info.id] = build_buff_info
    end
end

function LoginLoading:loadingAvatarShop()
    _ED.base_avatar_shop_info = {}
    for i = 1, dms.count(dms["avatar_shop"]) do
        local avatar_shop_info = {}
        local avatar_shop_mould_info = dms.element(dms["avatar_shop"], i)
        avatar_shop_info.id = dms.atoi(avatar_shop_mould_info, avatar_shop.id)
        avatar_shop_info.shop_type = dms.atoi(avatar_shop_mould_info, avatar_shop.shop_type)
        avatar_shop_info.prop = zstring.split(dms.atos(avatar_shop_mould_info, avatar_shop.prop), ",")
        avatar_shop_info.cost_gold = dms.atoi(avatar_shop_mould_info, avatar_shop.cost_gold)
        _ED.base_avatar_shop_info[""..avatar_shop_info.id] = avatar_shop_info
    end
end

-- 装备商店
function LoginLoading:loadingEquipmentShop()
    _ED.base_equipment_shop_info = {}
    for i = 1, dms.count(dms["equipment_shop"]) do
        local equipment_shop_info = {}
        local equipment_shop_mould_info = dms.element(dms["equipment_shop"], i)
        equipment_shop_info.id = dms.atoi(equipment_shop_mould_info, equipment_shop.id)
        equipment_shop_info.shop_type = dms.atoi(equipment_shop_mould_info, equipment_shop.shop_type)
        equipment_shop_info.need_prop = dms.atos(equipment_shop_mould_info, equipment_shop.need_prop)
        equipment_shop_info.receive_prop = zstring.split(dms.atos(equipment_shop_mould_info, equipment_shop.receive_prop), ",")
        _ED.base_equipment_shop_info[""..equipment_shop_info.id] = equipment_shop_info
    end
end

-- 军团科技捐献升级
function LoginLoading:loadingLegionScienceLevelInfo()
    _ED.base_legion_science_level_info = {}
    for i = 1, dms.count(dms["union_science_level"]) do
        local legion_science_level_info = {}
        local legion_science_level_mould_info = dms.element(dms["union_science_level"], i)
        legion_science_level_info.id = dms.atoi(legion_science_level_mould_info, union_science_level.id)
        legion_science_level_info.group = dms.atoi(legion_science_level_mould_info, union_science_level.group)
        legion_science_level_info.current_count = dms.atoi(legion_science_level_mould_info, union_science_level.current_count)
        legion_science_level_info.cost_res = zstring.split(dms.atos(legion_science_level_mould_info, union_science_level.cost_res), "|")
        legion_science_level_info.cost_gold = zstring.split(dms.atos(legion_science_level_mould_info, union_science_level.cost_gold), "|")
        legion_science_level_info.reward_res = zstring.split(dms.atos(legion_science_level_mould_info, union_science_level.reward_res), "|")
        legion_science_level_info.reward_gold = zstring.split(dms.atos(legion_science_level_mould_info, union_science_level.reward_gold), "|")
        _ED.base_legion_science_level_info[""..legion_science_level_info.group] = _ED.base_legion_science_level_info[""..legion_science_level_info.group] or {}
        _ED.base_legion_science_level_info[""..legion_science_level_info.group][""..legion_science_level_info.current_count] = legion_science_level_info
    end
end

-- 作战中心列表
function LoginLoading:loadingFightCenterList()
    _ED.fight_center_list_info = {}
    for i = 1, dms.count(dms["fight_center_list"]) do
        local fight_center_info = {}
        local fight_center_list_mould_info = dms.element(dms["fight_center_list"], i)
        fight_center_info.id = dms.atoi(fight_center_list_mould_info, fight_center_list.id)
        fight_center_info.list_type = dms.atoi(fight_center_list_mould_info, fight_center_list.list_type)
        fight_center_info.list_type_name = dms.atos(fight_center_list_mould_info, fight_center_list.list_type_name)
        fight_center_info.pic_index = zstring.split(dms.atos(fight_center_list_mould_info, fight_center_list.pic_index), ",")
        fight_center_info.fun_open_condition = dms.atoi(fight_center_list_mould_info, fight_center_list.fun_open_condition)
        fight_center_info.order = dms.atoi(fight_center_list_mould_info, fight_center_list.order)
        _ED.fight_center_list_info[""..fight_center_info.id] = fight_center_info
    end
end

-- 读取本地储存道具推送数据
function LoginLoading:loadingPushUserPropInfo()
    if _ED.push_user_prop == nil then
        _ED.push_user_prop = {}
    end
    local push_user_prop = cc.UserDefault:getInstance():getStringForKey(getKey("push_user_prop"))
    if push_user_prop == nil or push_user_prop == "" then
        _ED.push_user_prop = {}
    else
        local push_user_prop = zstring.split(push_user_prop, "|")
        for i,v in pairs(push_user_prop) do
            if v ~= nil and v ~= "" then
                local last_prop = zstring.split(v, ",")
                if _ED.push_user_prop[""..last_prop[1]] == nil then
                    _ED.push_user_prop[""..last_prop[1]] = {}
                end
                _ED.push_user_prop[""..last_prop[1]][""..last_prop[2]] = zstring.tonumber(last_prop[3])
            end
        end
    end
    if _ED.push_equipment_packs == nil then
        _ED.push_equipment_packs = {}
    end
    local push_equipment_packs = cc.UserDefault:getInstance():getStringForKey(getKey("push_equipment_packs"))
    if push_equipment_packs == nil or push_equipment_packs == "" then
        _ED.push_equipment_packs = {}
    else
        local push_equipment_packs = zstring.split(push_equipment_packs, "|")
        for i,v in pairs(push_equipment_packs) do
            if v ~= nil and v ~= "" then
                local last_prop = zstring.split(v, ",")
                if _ED.push_equipment_packs[""..last_prop[1]] == nil then
                    _ED.push_equipment_packs[""..last_prop[1]] = {}
                end
                _ED.push_equipment_packs[""..last_prop[1]][""..last_prop[2]] = zstring.tonumber(last_prop[3])
            end
        end
    end

    if _ED.push_equipment_parts == nil then
        _ED.push_equipment_parts = {}
    end
    local push_equipment_parts = cc.UserDefault:getInstance():getStringForKey(getKey("push_equipment_parts"))
    if push_equipment_parts == nil or push_equipment_parts == "" then
        _ED.push_equipment_parts = {}
    else
        local push_equipment_parts = zstring.split(push_equipment_parts, "|")
        for i,v in pairs(push_equipment_parts) do
            if v ~= nil and v ~= "" then
                local last_prop = zstring.split(v, ",")
                _ED.push_equipment_parts[""..last_prop[1]] = zstring.tonumber(last_prop[2])
            end
        end
    end

    if _ED.push_armor_parts == nil then
        _ED.push_armor_parts = {}
    end
    local push_armor_parts = cc.UserDefault:getInstance():getStringForKey(getKey("push_armor_parts"))
    if push_armor_parts == nil or push_armor_parts == "" then
        _ED.push_armor_parts = {}
    else
        local push_armor_parts = zstring.split(push_armor_parts, "|")
        for i,v in pairs(push_armor_parts) do
            if v ~= nil and v ~= "" then
                local last_prop = zstring.split(v, ",")
                _ED.push_armor_parts[""..last_prop[1]] = zstring.tonumber(last_prop[2])
            end
        end
    end

    if _ED.push_armor_packs == nil then
        _ED.push_armor_packs = {}
    end
    local push_armor_packs = cc.UserDefault:getInstance():getStringForKey(getKey("push_user_prop"))
    if push_armor_packs == nil or push_armor_packs == "" then
        _ED.push_armor_packs = {}
    else
        local push_armor_packs = zstring.split(push_armor_packs, "|")
        for i,v in pairs(push_armor_packs) do
            if v ~= nil and v ~= "" then
                local last_prop = zstring.split(v, ",")
                _ED.push_armor_packs[""..last_prop[2]] = zstring.tonumber(last_prop[3])
            end
        end
    end
end

function LoginLoading:praseSystemPushInfo( ... )
    _ED.base_system_push_info = {}
    if system_push_time_info ~= nil then
        for k,v in pairs(system_push_time_info) do
            local mould_id = v[1]
            local timeInfo = v[2]
            local pushIds = v[3]
            local paramsInfo = v[4]
            _ED.base_system_push_info[""..mould_id] = {}
            for index, time in pairs(timeInfo) do
                table.insert(_ED.base_system_push_info[""..mould_id], {time = time, havePush = false, pushId = pushIds[index], params = paramsInfo[index]})
            end
        end
    end
end

function LoginLoading:close()

end

function LoginLoading:onExit( ... )
	state_machine.remove("login_loading_ex_update")
    self:unregisterOnNoteUpdate(self)
end

function LoginLoading:destroy()
    if _ED.user_info.user_id == nil 
        or zstring.tonumber(_ED.user_info.user_id) < 1 then
        -- fwin:freeAllView()
        -- executeNextEvent(nil, false)
        if executeMissionExt(mission_mould_plot, touch_off_mission_into_home, "0", nil, true, "0") == false then
            if executeMissionExt(mission_mould_plot, touch_off_mission_into_home, "0", nil, true, "l1e0") == false then
                state_machine.excute("create_character_window_open", 0, "create_character_window_open.")
            end
        end
    else
        state_machine.excute("login_loading_window_join_game_world", 0, 0)
    end
end
----------------------------------------------------------------------------------------------------