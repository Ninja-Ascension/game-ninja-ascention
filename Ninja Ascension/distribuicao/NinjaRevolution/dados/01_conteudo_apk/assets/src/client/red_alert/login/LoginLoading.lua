LoginLoading = class("LoginLoadingClass", Window)
--打开界面
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
	        _wind:init()
			fwin:open(_wind,fwin._windows)
			app.load("client.red_alert.utils.LoadingWindow")
			state_machine.excute("loading_window_open", 0, {_wind, "login_loading_update", "login_loading_window_close"})			
		end

		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
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
state_machine.add(login_loading_window_open_terminal)
state_machine.add(login_loading_window_close_terminal)
state_machine.init()

function LoginLoading:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

    -- var
    self._elapsed = 0
    self._duration = 1
    -- lua load file
    app.load("client.red_alert.home.MainWindow")
    -- Initialize battle loading state machine.
    local function init_login_loading_terminal()
        -- update
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

    -- call func init battle loading state machine.
    init_login_loading_terminal()
end

function LoginLoading:init(params)
    return self
end

function LoginLoading:onEnterTransitionFinish()
    
end

function LoginLoading:onProgress(progress)
	progress = zstring.tonumber(progress)
    if __login_loding_load_4 == progress then
      	self:getAllBuildEscapeData()
    elseif __login_loding_load_8 == progress then
        
    elseif __login_loding_load_12 == progress then
    	self:getWeaponryData()
    elseif __login_loding_load_16 == progress then
        self:loadingHeroImage()
    elseif __login_loding_load_20 == progress then
    	self:loadingCells1()
    elseif __login_loding_load_24 == progress then
    	self:loadingCells2()
    elseif __login_loding_load_28 == progress then
    	self:loadingTargetDatas()
    elseif __login_loding_load_32 == progress then
    	-- Init socket link
    	NetworkAdaptor.LuaSocket.socket_event = false
		NetworkAdaptor.intSocket()
	elseif __login_loding_load_36 == progress then

	elseif __login_loding_load_40 == progress then
		self:addArmaturesData()
	elseif __login_loding_load_44 == progress then
		self:getPushNotificationData()
	elseif __login_loding_load_48 == progress then
		
    end 
end

function LoginLoading:addArmaturesData()
	-- cacher.addArmatureFileInfo("images/ui/effice/effice_recruit_one_left/effice_recruit_one_left.ExportJson")
	-- cacher.addArmatureFileInfo("images/ui/effice/effice_recruit_one_right/effice_recruit_one_right.ExportJson")
	-- cacher.addArmatureFileInfo("images/ui/effice/effice_recruit_main/effice_recruit_main.ExportJson")
	-- cacher.addArmatureFileInfo("images/ui/effice/effice_recruit_main2/effice_recruit_main2.ExportJson")

	cacher.addTextures(config_res.images_cached["recruit"])
end

function LoginLoading:loadingTargetDatas( ... )
	_ED.target_datas = {}
	for i = 1,dms.count(dms["target_param"]) do
		local target_type = dms.int(dms["target_param"], i, target_param.target_type)
		if target_type == 2 then
			local targetData = {}
			local target_info = dms.element(dms["target_param"], i)
			targetData.id = dms.atoi(target_info, target_param.id)
			targetData.target_param_type = dms.atoi(target_info, target_param.target_param_type)
			targetData.target_param_value = dms.atoi(target_info, target_param.target_param_value)
			targetData.distribute = dms.atos(target_info, target_param.distribute)
			targetData.last_task_id = dms.atoi(target_info, target_param.last_task_id)
			targetData.next_task_id = dms.atoi(target_info, target_param.next_task_id)
			targetData.icon = dms.atos(target_info, target_param.icon)
			targetData.bg = dms.atos(target_info, target_param.bg)
			targetData.pop_info = dms.atos(target_info, target_param.pop_info)
			targetData.pop_music = dms.atos(target_info, target_param.pop_music)
			table.insert(_ED.target_datas, targetData)
		end
	end
end

function LoginLoading:loadingHeroImage()
   	if cacher.getObject("man") == nil then
   		local jsonPath = "sprite/spirte_nanzhu.json"
	    local atlasPath = "sprite/spirte_nanzhu.atlas"
	    local animation_nv = sp.spine(jsonPath, atlasPath, 1, 0, "animation", true, nil)
	    animation_nv.__cname = "man"
    	cacher.addObject(animation_nv)
    end

    if cacher.getObject("women") == nil then
	    local jsonPath = "sprite/spirte_nvzhu.json"
	    local atlasPath = "sprite/spirte_nvzhu.atlas"
	    local animation_nan = sp.spine(jsonPath, atlasPath, 1, 0, "animation", true, nil)
	    animation_nan.__cname = "women"
	    cacher.addObject(animation_nan)
	end

	for i = 2, 7 do
		local ship_id = zstring.tonumber(_ED.formetion[i])
		if ship_id ~= 0 then
			local user_ship = _ED.user_ship[""..ship_id]
			local base_ship_mould_id = user_ship.ship_base_template_id
			if cacher.getObject("formation_"..base_ship_mould_id) == nil then
			    local temp_bust_index = dms.int(dms["ship_mould"], base_ship_mould_id, ship_mould.bust_index)
			    temp_bust_index = 10000 + temp_bust_index 
			    
			    local jsonFile = string.format("sprite/spirte_%s.json", temp_bust_index)
				local atlasFile = string.format("sprite/spirte_%s.atlas", temp_bust_index)

			    local animation = sp.spine(jsonFile, atlasFile, 1, 0, _spine_sprite_animation_names[_enum_spine_animation_frame_index.animation_standby_dir_4+1], true, nil)
			    animation.__cname = "formation_"..base_ship_mould_id
			    cacher.addObject(animation)
			end
		end
	end
end

function LoginLoading:loadingCells1()
	-- for i = 1,8 do
	-- 	for j = 1 ,20 do
	-- 		csbCacher.createUIRef("cells/packs/resource_"..i..".csb", "root")
	-- 	end
	-- end

	-- for i = 1,25 do
	-- 	csbCacher.createUIRef(config_csb.cells.packs.packs_icon_bg_cell, "root")
	-- end

	-- for i = 1,6 do
	-- 	csbCacher.createUIRef(config_csb.cells.hero.hero_icon_cell,"root")
	-- end

	-- for i = 1,10 do
	-- 	csbCacher.createUIRef(config_csb.cells.rank.ranking_right_cell, "root")
	-- end

	-- for i = 1,4 do
	-- 	csbCacher.createUIRef(config_csb.cells.activity.dailytasks.task_cell, "root")
	-- end

end

function LoginLoading:loadingCells2()
	-- for i = 1,12 do
	-- 	csbCacher.createUIRef(config_csb.activity.sign_in.sign_in_cell_right, "root")
	-- end

	-- for i = 1,8 do
	-- 	csbCacher.createUIRef(config_csb.cells.duplicate.duplicate_list_cell,"root")
	-- end

	-- for i = 1,6 do
	-- 	csbCacher.createUIRef(config_csb.cells.hero.hero_main_skills_up_cell,"root")
	-- end
	
	-- for i = 1,6 do
	-- 	csbCacher.createUIRef(config_csb.cells.activity.wonderful.famous_general_cell, "root")
	-- end
	
	-- for i = 1,6 do
	-- 	csbCacher.createUIRef(config_csb.cells.campaign.weaponry.weaponry_cell, "root")
	-- end

	-- for i = 1,6 do
	-- 	csbCacher.createUIRef(config_csb.cells.packs.equipstorage.equipment_gem_input_cell,"root")
	-- end

	-- for i = 1,10 do
	-- 	csbCacher.createUIRef(config_csb.cells.activity.wonderful.active_left_cell, "root")
	-- end

end

--兵器冢数据
function LoginLoading:getWeaponryData()
	_ED.weapon_duplicate_info = {}
    local index = 1
    local gem_index = 1
    for i = 1, dms.count( dms["pve_scene"] ) do
    	local pve_scene_mould = dms.element(dms["pve_scene"], i)
        local scene_type = dms.atoi(pve_scene_mould, pve_scene.scene_type)
        local npcs = dms.atos(pve_scene_mould, pve_scene.npcs)
        if scene_type == 17 then
            _ED.weapon_duplicate_info[index] = _ED.weapon_duplicate_info[index] or {}
            npcs = zstring.split(npcs,",")
            for j,npc_id in pairs(npcs) do
            	local npc_mould = dms.element(dms["npc"], npc_id)
                local reward_id = dms.atoi(npc_mould, npc.drop_library)
                local reward_items_show = dms.string(dms["scene_reward"],reward_id,scene_reward.reward_items)
                reward_items_show = zstring.split(reward_items_show,"|")
                local _reward_table = {}
                for k,m in pairs(reward_items_show) do
                    local data_temp = zstring.split(m,",")
                        _reward_table[k] = {
                            prop_item = data_temp[1],
                            prop_type = data_temp[2],
                            item_value = data_temp[3],
                        } 
                end
                _ED.weapon_duplicate_info[index][j] = _ED.weapon_duplicate_info[index][j] or {}
                _ED.weapon_duplicate_info[index][j].scene_id = i
                _ED.weapon_duplicate_info[index][j].difficulty = index
                _ED.weapon_duplicate_info[index][j].npc_id = tonumber(npc_id)
                _ED.weapon_duplicate_info[index][j].dec = dms.atos(npc_mould, npc.sign_msg)
                _ED.weapon_duplicate_info[index][j].reward_data = _reward_table
                _ED.weapon_duplicate_info[index][j].ship_mould_id = dms.atoi(npc_mould, npc.base_pic)  --兵器副本这里 是shipmould id 
            end
            index = index + 1
        elseif scene_type == 16 then
        	_ED.push_notification_info = _ED.push_notification_info or {}
        	_ED.push_notification_info.campaign = _ED.push_notification_info.campaign or {}
        	_ED.push_notification_info.campaign.gem_copy_scene_id = _ED.push_notification_info.campaign.gem_copy_scene_id or {}
        	_ED.push_notification_info.campaign.gem_copy_scene_id[gem_index] = dms.atoi(pve_scene_mould, pve_scene.scene_id)
        	gem_index = gem_index + 1
        elseif scene_type == 21 then
        	_ED.push_notification_info = _ED.push_notification_info or {}
        	_ED.push_notification_info.union = _ED.push_notification_info.union or {}
            npcs = zstring.split(npcs,",")
        	_ED.push_notification_info.union.team_fight_npcs = npcs
        elseif scene_type == 104 then
        	_ED.push_notification_info = _ED.push_notification_info or {}
        	_ED.push_notification_info.seven_star = _ED.push_notification_info.seven_star or {}
            npcs = zstring.split(npcs,",")
            local open_level = dms.atoi(pve_scene_mould, pve_scene.open_level) 
        	if tonumber(_ED.user_info.user_grade) >= open_level then 
        		_ED.push_notification_info.seven_star[i] = npcs
        	end
        end
    end
end

function LoginLoading:getPushNotificationData()
	_ED.push_notification_info = _ED.push_notification_info or {}
	_ED.push_notification_info.campaign = _ED.push_notification_info.campaign or {}
	_ED.push_notification_info.campaign.gem_copy_max_times = dms.string(dms["gem_duplicate_config"],2,gem_duplicate_config.param)
	_ED.push_notification_info.campaign.raiders_max_times = dms.int(dms["raiders_cut_config"], 4, raiders_cut_config.param)
	_ED.push_notification_info.union = _ED.push_notification_info.union or {}
	_ED.push_notification_info.union.axila_npc_level = zstring.split(dms.string(dms["union_config"], 26, union_config.param), "|") 
end

function LoginLoading:getAllBuildEscapeData()
	for i= 1 ,dms.count(dms["build_mould"]) do
		local update_id = dms.int(dms["build_mould"],i,build_mould.update_id)
		if update_id ~= -1 then
			_ED.build_escalate_info[""..update_id] = {}
			local data = dms.searchs(dms["build_escalate_param"],build_escalate_param.escalate_group,update_id)
			for j,data_temp in pairs(data) do
				local level = dms.atos(data_temp,build_escalate_param.now_level)
				_ED.build_escalate_info[""..update_id][""..level] = {}	
				local rank_consume = dms.atos(data_temp,build_escalate_param.rank_consume)
				rank_consume = zstring.split(rank_consume,",")
				_ED.build_escalate_info[""..update_id][""..level].update_need_resouce_type = rank_consume[1]
				_ED.build_escalate_info[""..update_id][""..level].update_need_resouce = rank_consume[2]
				_ED.build_escalate_info[""..update_id][""..level].consume_time = dms.atos(data_temp,build_escalate_param.consume_time)
				_ED.build_escalate_info[""..update_id][""..level].output_type = dms.atos(data_temp,build_escalate_param.output_type)
				_ED.build_escalate_info[""..update_id][""..level].output_count = dms.atos(data_temp,build_escalate_param.output_count)
				_ED.build_escalate_info[""..update_id][""..level].output_time = dms.atos(data_temp,build_escalate_param.output_time)
				_ED.build_escalate_info[""..update_id][""..level].max_volumn = dms.atos(data_temp,build_escalate_param.max_volumn)
				_ED.build_escalate_info[""..update_id][""..level].open_skill = dms.atos(data_temp,build_escalate_param.open_skill)
				_ED.build_escalate_info[""..update_id][""..level].open_build = dms.atos(data_temp,build_escalate_param.open_build)
				_ED.build_escalate_info[""..update_id][""..level].open_teach = dms.atos(data_temp,build_escalate_param.open_teach)
				_ED.build_escalate_info[""..update_id][""..level].by_open_home_level = dms.atos(data_temp,build_escalate_param.by_open_home_level)
				_ED.build_escalate_info[""..update_id][""..level].by_open_user_level = dms.atos(data_temp,build_escalate_param.by_open_user_level)
				_ED.build_escalate_info[""..update_id][""..level].max_volumn_teams = dms.atos(data_temp,build_escalate_param.max_volumn_teams)
				_ED.build_escalate_info[""..update_id][""..level].level = level
				_ED.build_escalate_info[""..update_id][""..level].update_id = i
				-- local rank_consume = 3 ,    			--升级消耗
				-- local consume_time = 4 ,    			--升级时间
				-- local output_type = 5 ,    			--产出类型
				-- local output_count = 6 ,    			--产出值
				-- local output_time = 7 ,    			--产出时间
				-- local max_volumn = 8 ,    			--最大容量
				-- local open_skill = 9 ,    			--解锁技能ID
				-- local open_build = 10 ,    			--解锁建筑
				-- local open_teach = 11 ,    			--解锁科技
				-- local by_open_home_level = 12 ,		--需求主城等级
				-- local by_open_user_level = 13 ,		--需求玩家等级
				-- debug.print_r(_ED.build_escalate_info[""..update_id][""..level])
			end
		end
	end
end

function LoginLoading:close()

end

function LoginLoading:destroy()
    -- clean frame windows
    fwin:removeAll()
	self:unregisterOnNoteUpdate(self)

	pushNotificationNewActivity()
	pushNotificationChat()
	pushNotificationTopUp()
	
	_ED.send_information_system = {}

	if zstring.tonumber(_ED.user_info.user_force) ~= 0 then
		state_machine.excute("main_window_open",0,"")
		fwin:__show(fwin._frameview)
	else
		executeResetCurrentEvent()
	    if executeMissionExt(mission_mould_tuition, nil, nil, nil, true, "l".._ED.user_info.user_grade.."e".._ED.user_info.user_experience, true) == false then
	    	app.load("client.red_alert.login.CampChose")
	    	state_machine.excute("camp_chose_window_open",0,"")
	    end
	end
	if cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_WINDOWS 
	and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_LINUX 
	and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_MAC then
		handlePlatformRequest(0, CC_INITIALIZE_RECHARGE_PARAM, "")
	end
end
----------------------------------------------------------------------------------------------------