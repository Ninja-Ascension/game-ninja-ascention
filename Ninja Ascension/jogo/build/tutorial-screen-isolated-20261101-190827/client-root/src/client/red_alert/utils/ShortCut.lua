
local short_cut_go_to_other_window_terminal = {
    _name = "short_cut_go_to_other_window",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local function_param_id = params[1]
        local target_guide = params[2]
        local params_data = params[3]
        local genre = dms.int(dms["function_param"],function_param_id,function_param.genre)
        local open_npc = dms.int(dms["function_param"],function_param_id,function_param.open_npc)

        local fun_open_id = dms.int(dms["function_param"],function_param_id,function_param.open_function)
        if funOpenDrawTip(fun_open_id) == true then
            return
        end
-- -1：无跳转
-- 1：英雄分解
-- 2：英雄合成
-- 3：英雄重生
-- 4：英魂副本(将魂副本)
-- 5：普通副本
-- 6：精英副本
-- 7：炼狱副本
-- 8：黑石山（兵器冢）
-- 9：宝石山谷(宝石矿洞)
-- 10：秘宝商店
-- 11：中立酒馆
-- 12：神兵副本
-- 13：荣誉商店（军功商店）
-- 14：家族商店
-- 15：无尽之战（无双试炼）   
-- 16：种族皇者（皇城） 
-- 17：运送物资 
-- 18：集市（马场）   
-- 19：主城   
-- 20：擂台赛  
-- 21：再战无双 
-- 22：攻城拔营 
-- 23：占卜   
-- 24：黑暗神殿（七星台）    
-- 25:   英雄    
-- 26:   装备    
-- 27：神器打造 
-- 28：兵营 
-- 29：农村
-- 30：伐木场
-- 31：阵型   
-- 32：装备分解 
-- 33：宝物分解 
-- 34：宝物装备 
-- 35：侠客录  
-- 36：掌门技能 
-- 37：开服狂欢 
-- 38：每月签到 
-- 39：每日3签 
-- 40：任务   
-- 41：月卡   
-- 42：江湖   
-- 43：帮派-药王谷   
-- 44：充值   
-- 45：祭祀   
-- 46：战功商店
-- 47：至尊转盘
        state_machine.excute("get_the_way_window_close",0,"")
        if genre == 1 then   --英雄分解
            app.load("client.red_alert.forging.Refining")
            state_machine.excute("refining_window_open",0,{_datas = {page_index = 1}})
        elseif genre == 2 then   --合成
            state_machine.excute("combining_window_open",0,"")
            state_machine.excute("combining_manager",0,{
                _datas = 
                {
                    terminal_name = "combining_manager",     
                    next_terminal_name = "combining_change_to_hero", 
                    current_button_name = "Button_hero_synthesis",   
                    but_image = "",     
                    terminal_state = 0, 
                    touch_scale = true,
                    touch_scale_xy = 0.95, 
                }
            })
        elseif genre == 3 then   --重生
            app.load("client.red_alert.forging.Rebirth")
            state_machine.excute("rebirth_window_open",0,"")
        elseif genre == 4 then   --英魂副本(将魂副本)
            app.load("client.red_alert.campaign.soul_duplicate.SoulDuplicate")
            state_machine.excute("soul_duplicate_window_open",0,"")
        elseif genre == 5 then   --普通副本
            state_machine.excute("task_window_close", 0, nil)
            if fwin:find("TaskClass") ~= nil then
                state_machine.excute("task_window_hide",0,"")  
                state_machine.excute("duplicate_map_window_show",0,"")
                state_machine.excute("home_button_for_action_window_show",0,"")  
                state_machine.excute("chat_view_window_show",0,"")  
                state_machine.excute("duplicate_title_window_show",0,"")
            end
            if fwin:find("HeroMainClass") ~= nil then
                if fwin:find("HeroStarActivationClass") ~= nil then
                    state_machine.excute("hero_star_activation_window_hide",0,"")
                end
                state_machine.excute("hero_main_window_hide",0,"")
                state_machine.excute("duplicate_map_window_show",0,"")
                state_machine.excute("home_button_for_action_window_show",0,"")  
                state_machine.excute("chat_view_window_show",0,"")  
                state_machine.excute("duplicate_title_window_show",0,"")
            end
            local scence_id = dms.int(dms["function_param"],function_param_id,function_param.open_scene)
            state_machine.excute("national_war_map_window_close",0,{_datas={open_type = 1}})
            if tonumber(scence_id) < 0 then 
                state_machine.excute("hero_recruit_window_hide",0,"")
                state_machine.excute("catalogue_storage_window_hide",0,"")
                state_machine.excute("packs_window_hide",0,"")
                state_machine.excute("hero_main_window_hide",0,"")
                state_machine.excute("main_window_open",0,"")
                state_machine.excute("player_resource_window_show",0,"")   
                state_machine.excute("home_button_for_action_window_show",0,"")  
                state_machine.excute("chat_view_window_show",0,"")
                state_machine.excute("duplicate_title_window_show",0,"")
                state_machine.excute("hero_star_activation_window_hide",0,"")
                state_machine.excute("hero_talent_activation_window_close",0,"")
                state_machine.excute("duplicate_manager_window_open",0,{1})
            else
                if fwin:find("DuplicateMapClass") ~= nil 
                    and tonumber(scence_id) == fwin:find("DuplicateMapClass").sceneID
                    then
                    local tempNpcIds = zstring.split(dms.string(dms["pve_scene"], tonumber(scence_id), pve_scene.npcs), ",")
                    local index = 1
                    for k,v in pairs(tempNpcIds) do
                        if tonumber(v) == tonumber(open_npc) then
                            index = k
                            break
                        end
                    end
                    state_machine.excute("duplicate_title_update_information", 0, {scence_id})
                    if open_npc > 0 and tonumber(_ED.npc_state[open_npc]) < 0 then
                        state_machine.excute("duplicate_map_move_to_choose_npc",0,{index})
                        if target_guide == true then
                            local tempNpcIds = zstring.split(dms.string(dms["pve_scene"], scence_id, pve_scene.npcs), ",")
                            local sceneState = tonumber(_ED.scene_current_state[tonumber(scence_id)])
                            if sceneState < #tempNpcIds then
                                open_npc = tempNpcIds[sceneState + 1]
                            else
                                open_npc = tempNpcIds[sceneState]
                            end
                            state_machine.excute("duplicate_map_short_cut_npc",0,{open_npc})
                        end
                    else
                        state_machine.excute("duplicate_map_short_cut_npc",0,{open_npc})
                    end
                else
                -- if tonumber(_ED.npc_state[open_npc]) < 0 then
                --     TipDlg.drawTextDailog(tipStringInfo_trialTower[18])
                -- else
                    state_machine.excute("hero_recruit_window_hide",0,"")
                    state_machine.excute("catalogue_storage_window_hide",0,"")
                    state_machine.excute("packs_window_hide",0,"")
                    state_machine.excute("hero_main_window_hide",0,"")
                    state_machine.excute("main_window_open",0,"")
                    state_machine.excute("player_resource_window_show",0,"")   
                    state_machine.excute("home_button_for_action_window_show",0,"")  
                    state_machine.excute("chat_view_window_show",0,"")
                    state_machine.excute("duplicate_title_window_show",0,"")
                    state_machine.excute("hero_star_activation_window_hide",0,"")
                    state_machine.excute("hero_talent_activation_window_close",0,"")
                    state_machine.excute("duplicate_title_update_information", 0, {scence_id})
                    state_machine.excute("duplicate_manager_window_open",0,{1})

                    local result = state_machine.excute("duplicate_list_cell_click",0,{
                        _datas = {
                            cell = {
                                scenceID = scence_id,
                                from_type = 1,
                                npc_id = open_npc
                            }
                        }
                    })

                    if result == false then
                        if fwin:find("TaskClass") ~= nil then
                            state_machine.excute("task_window_show",0,"")  
                            state_machine.excute("duplicate_map_window_hide",0,"")
                            state_machine.excute("home_button_for_action_window_hide",0,"")  
                            state_machine.excute("chat_view_window_hide",0,"")  
                            state_machine.excute("duplicate_title_window_hide",0,"")
                        end
                        if fwin:find("DuplicateMapClass") ~= nil then
                            state_machine.excute("duplicate_map_window_show",0,"")
                            state_machine.excute("home_button_for_action_window_show",0,"")  
                            state_machine.excute("chat_view_window_show",0,"")  
                            state_machine.excute("duplicate_title_window_show",0,"")
                        end
                    end

                    state_machine.excute("duplicate_map_window_show",0,"")
                    if open_npc > 0 and tonumber(_ED.npc_state[open_npc]) < 0 then
                        if target_guide == true then
                            local tempNpcIds = zstring.split(dms.string(dms["pve_scene"], scence_id, pve_scene.npcs), ",")
                            local sceneState = tonumber(_ED.scene_current_state[tonumber(scence_id)])
                            if sceneState < #tempNpcIds then
                                open_npc = tempNpcIds[sceneState + 1]
                            else
                                open_npc = tempNpcIds[sceneState]
                            end
                            state_machine.excute("duplicate_map_short_cut_npc",0,{open_npc})
                        end
                    else
                        state_machine.excute("duplicate_map_short_cut_npc",0,{open_npc})
                    end
                end
            end
        elseif genre == 6 then   --精英副本
            state_machine.excute("task_window_close", 0, nil)
            local scence_id = dms.int(dms["function_param"],function_param_id,function_param.open_scene)
            -- if tonumber(_ED.npc_state[open_npc]) < 0 then
            --     TipDlg.drawTextDailog(tipStringInfo_trialTower[18])
            -- else
            if fwin:find("TaskClass") ~= nil then
                state_machine.excute("task_window_hide",0,"")  
                state_machine.excute("duplicate_map_window_show",0,"")
                state_machine.excute("home_button_for_action_window_show",0,"")  
                state_machine.excute("chat_view_window_show",0,"")  
                state_machine.excute("duplicate_title_window_show",0,"")
            end
            if tonumber(scence_id) < 0 then 
                state_machine.excute("hero_recruit_window_hide",0,"")
                state_machine.excute("catalogue_storage_window_hide",0,"")
                state_machine.excute("packs_window_hide",0,"")
                state_machine.excute("hero_main_window_hide",0,"")
                state_machine.excute("main_window_open",0,"")
                state_machine.excute("player_resource_window_show",0,"")   
                state_machine.excute("home_button_for_action_window_show",0,"")  
                state_machine.excute("chat_view_window_show",0,"")
                state_machine.excute("duplicate_title_window_show",0,"")
                state_machine.excute("hero_star_activation_window_hide",0,"")
                state_machine.excute("hero_talent_activation_window_close",0,"")
                state_machine.excute("duplicate_manager_window_open",0,{2})
            else
                state_machine.excute("hero_recruit_window_hide",0,"")
                state_machine.excute("catalogue_storage_window_hide",0,"")
                state_machine.excute("packs_window_hide",0,"")
                state_machine.excute("hero_main_window_hide",0,"")
                state_machine.excute("main_window_open",0,"")
                state_machine.excute("player_resource_window_show",0,"")   
                state_machine.excute("home_button_for_action_window_show",0,"")  
                state_machine.excute("chat_view_window_show",0,"")
                state_machine.excute("duplicate_title_window_show",0,"")
                state_machine.excute("hero_star_activation_window_hide",0,"")
                state_machine.excute("hero_talent_activation_window_close",0,"")
                state_machine.excute("duplicate_title_update_information", 0, {scence_id})
                state_machine.excute("duplicate_manager_window_open",0,{2})

                local result = state_machine.excute("duplicate_list_cell_click",0,{
                    _datas = {
                            cell = {
                                scenceID = scence_id,
                                from_type = 2,
                                npc_id = open_npc
                            }
                        }
                    })

                if result == false then
                    if fwin:find("TaskClass") ~= nil then
                        state_machine.excute("task_window_show",0,"")  
                        state_machine.excute("duplicate_map_window_hide",0,"")
                        state_machine.excute("home_button_for_action_window_hide",0,"")  
                        state_machine.excute("chat_view_window_hide",0,"")  
                        state_machine.excute("duplicate_title_window_hide",0,"")
                    end
                end
                state_machine.excute("duplicate_map_window_show",0,"")
                if tonumber(_ED.npc_state[open_npc]) < 0 then
                else
                    state_machine.excute("duplicate_map_short_cut_npc",0,{open_npc})
                end
            end
        elseif genre == 7 then   --炼狱副本
            state_machine.excute("task_window_close", 0, nil)
            local scence_id = dms.int(dms["function_param"],function_param_id,function_param.open_scene)
            -- if tonumber(_ED.npc_state[open_npc]) < 0 then
            --     TipDlg.drawTextDailog(tipStringInfo_trialTower[18])
            -- else
            if fwin:find("TaskClass") ~= nil then
                state_machine.excute("task_window_hide",0,"")  
                state_machine.excute("duplicate_map_window_show",0,"")
                state_machine.excute("home_button_for_action_window_show",0,"")  
                state_machine.excute("chat_view_window_show",0,"")  
                state_machine.excute("duplicate_title_window_show",0,"")
            end
            if tonumber(scence_id) < 0 then 
                state_machine.excute("hero_recruit_window_hide",0,"")
                state_machine.excute("catalogue_storage_window_hide",0,"")
                state_machine.excute("packs_window_hide",0,"")
                state_machine.excute("hero_main_window_hide",0,"")
                state_machine.excute("main_window_open",0,"")
                state_machine.excute("player_resource_window_show",0,"")   
                state_machine.excute("home_button_for_action_window_show",0,"")  
                state_machine.excute("chat_view_window_show",0,"")
                state_machine.excute("duplicate_title_window_show",0,"")
                state_machine.excute("hero_star_activation_window_hide",0,"")
                state_machine.excute("hero_talent_activation_window_close",0,"")
                state_machine.excute("duplicate_manager_window_open",0,{3})
            else
                state_machine.excute("hero_recruit_window_hide",0,"")
                state_machine.excute("catalogue_storage_window_hide",0,"")
                state_machine.excute("packs_window_hide",0,"")
                state_machine.excute("hero_main_window_hide",0,"")
                state_machine.excute("main_window_show",0,"")
                state_machine.excute("player_resource_window_show",0,"")   
                state_machine.excute("home_button_for_action_window_show",0,"")  
                state_machine.excute("chat_view_window_show",0,"")
                state_machine.excute("duplicate_title_window_show",0,"")
                state_machine.excute("hero_star_activation_window_hide",0,"")
                state_machine.excute("hero_talent_activation_window_close",0,"")
                state_machine.excute("duplicate_title_update_information", 0, {scence_id})
                state_machine.excute("duplicate_manager_window_open",0,{3})

                local result = state_machine.excute("duplicate_list_cell_click",0,{
                    _datas = {
                        cell = {
                            scenceID = scence_id,
                            from_type = 3,
                            npc_id = open_npc
                        }
                    }
                })
                if result == false then
                    if fwin:find("TaskClass") ~= nil then
                        state_machine.excute("task_window_show",0,"")  
                        state_machine.excute("duplicate_map_window_hide",0,"")
                        state_machine.excute("home_button_for_action_window_hide",0,"")  
                        state_machine.excute("chat_view_window_hide",0,"")  
                        state_machine.excute("duplicate_title_window_hide",0,"")
                    end
                end
                state_machine.excute("duplicate_map_window_show",0,"")
                if tonumber(_ED.npc_state[open_npc]) < 0 then
                else
                    state_machine.excute("duplicate_map_short_cut_npc",0,{open_npc})
                end
            end
        elseif genre == 8 then   --黑石山（兵器冢）
            app.load("client.red_alert.campaign.weaponry.Weaponry")
            state_machine.excute("weaponry_window_open",0,"")
        elseif genre == 9 then   --宝石山谷(宝石矿洞)
            app.load("client.red_alert.campaign.gemduplicate.GemDuplicate")
            state_machine.excute("gem_duplicate_window_open",0,"")
        elseif genre == 10 then   --秘宝商店
            local function recruitCallBack(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    state_machine.excute("mystery_shop_window_open",0,"")            
                end
            end
            if _ED.secret_shop_init_info.os_time == nil or _ED.secret_shop_init_info.os_time == "" then
                NetworkManager:register(protocol_command.secret_shop_init.code, nil, nil, nil, nil, recruitCallBack, false, nil)
            else
                local times = os.time()- tonumber(_ED.secret_shop_init_info.os_time)
                local leave_time = _ED.secret_shop_init_info.refresh_time/1000-times
                if leave_time <= 0 then
                    NetworkManager:register(protocol_command.secret_shop_init.code, nil, nil, nil, self, recruitCallBack, false, nil)
                else
                    recruitCallBack({RESPONSE_SUCCESS = true,PROTOCOL_STATUS = 0})
                end
            end
        elseif genre == 11 then   --中立酒馆
            state_machine.excute("hero_recruit_window_open",0,"")

        elseif genre == 12 then   --神兵副本
            app.load("client.red_alert.god_weaponry.GodWeaponryDuplicate")
            state_machine.excute("god_weaponry_duplicate_window_open",0,"")
        elseif genre == 13 then     --荣誉商店（军功商店）
            app.load("client.red_alert.campaign.tourneyfield.TourneyfieldShop")
            state_machine.excute("tourneyfield_shop_window_open",0,"")
        elseif genre == 14 then     --家族商店
            if zstring.tonumber(_ED.union.user_union_info.union_id) > 0 then
                app.load("client.red_alert.union.Union")
                state_machine.excute("union_open", 0, "")
                state_machine.excute("union_shop_open",0,{1})
            else
                TipDlg.drawTextDailog(red_alert_all_str[157])
            end
        elseif genre == 15 then     --无尽之战（无双试炼）
            app.load("client.red_alert.campaign.trialtower.Trialtower")
            state_machine.excute("trialtower_window_open",0,"")
        elseif genre == 16 then     --种族皇者（皇城）
            state_machine.excute("tourneyfield_window_open",0,"")
        elseif genre == 17 then     --运送物资
            app.load("client.red_alert.campaign.shipmilitaryuse.ShipMilitaryUse")
            state_machine.excute("ship_military_use_window_open",0,"")
        elseif genre == 18 then     --集市（马场） 
            app.load("client.red_alert.horse.Racecourse")
            state_machine.excute("racecourse_window_open",0,"")
        elseif genre == 19 then     --主城
            state_machine.excute("build_level_up_window_open",0,{1})
            state_machine.excute("task_window_close",0,"")
        elseif genre == 20 then     --擂台赛

        elseif genre == 21 then     --再战无双
            app.load("client.red_alert.union.create.UnionJoin")
            app.load("client.red_alert.union.Union")
            local function responseCallbackUnion(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    if _ED.union.union_info == nil 
                        or _ED.union.union_info == {} 
                        or _ED.union.union_info.union_id == nil 
                        or _ED.union.union_info.union_id == "" 
                        or tonumber(_ED.union.union_info.union_id) == 0 
                        then
                        state_machine.excute("union_join_open", 0, "")
                    else
                        if tonumber(_ED.union.user_union_info.union_post) == 1 or tonumber(_ED.union.user_union_info.union_post) == 2 then
                            protocol_command.union_examine_list.param_list = _ED.union.union_info.union_id
                            NetworkManager:register(protocol_command.union_examine_list.code, nil, nil, nil, nil, nil, false, nil)
                        end
                        state_machine.excute("union_open", 0, "")
                    end
                end
            end 
            _ED.union.union_list_info = nil
            NetworkManager:register(protocol_command.union_init.code, nil, nil, nil, nil, responseCallbackUnion, false, nil)  
        elseif genre == 22 then     --攻城拔营
            
        elseif genre == 23 then     --占卜

        elseif genre == 24 then     --黑暗神殿（七星台）

        elseif genre == 25 then     --英雄
            if fwin:find("HeroMainClass") == nil then
                state_machine.excute("hero_main_window_open",0,"") 
            else
                state_machine.excute("hero_main_window_show", 0, nil)
                state_machine.excute("hero_main_maneger", 0, {
                    _datas = 
                    {
                        next_terminal_name = "hero_main_change_to_star_page", 
                        current_button_name = "Button_rising_star",
                        fun_open_id = 91,
                    }
                    })
            end  
        elseif genre == 26 then     --装备
            state_machine.excute("equipment_window_open",0,"")
        elseif genre == 27 then     --神器打造 
            app.load("client.red_alert.god_weaponry.GodWeaponry")
            state_machine.excute("god_weaponry_window_open", 0, params_data)
        elseif genre == 28 then     --兵营 
            state_machine.excute("build_level_up_window_open",0,{2})
            state_machine.excute("task_window_close",0,"")
        elseif genre == 29 then     --农场 
            state_machine.excute("build_level_up_window_open",0,{11})
            state_machine.excute("task_window_close",0,"")
        elseif genre == 30 then     --伐木场 
            state_machine.excute("build_level_up_window_open",0,{9})
            state_machine.excute("task_window_close",0,"")
        elseif genre == 31 then     --阵型 
            app.load("client.red_alert.formation.FormationSetting")
            state_machine.excute("formation_setting_window_open",0,"")
        elseif genre == 32 then     --装备分解 
            app.load("client.red_alert.forging.Refining")
            state_machine.excute("refining_window_open",0,{_datas = {page_index = 2}})
        elseif genre == 33 then     --宝物分解 
            app.load("client.red_alert.forging.Refining")
            state_machine.excute("refining_window_open",0,{_datas = {page_index = 3}})
        elseif genre == 34 then     --宝物装备
            app.load("client.red_alert.horse.RacecourseRide")
            state_machine.excute("racecourse_ride_window_open",0,"")
        elseif genre == 35 then    -- 侠客录  
            app.load("client.red_alert.recruit.CatalogueStorage")
            state_machine.excute("catalogue_storage_window_open",0,"")
        elseif genre == 36 then     -- 掌门技能 
            app.load("client.red_alert.home.ProtagonistSkills")
            state_machine.excute("protagonist_skills_window_open",0,"")
        elseif genre == 37 then     -- 开服狂欢
            app.load("client.red_alert.activity.wonderful.WonderfulOpen")
            state_machine.excute("wonderful_open_window_open",0,nil)
        elseif genre == 38 then     -- 每月签到 
            app.load("client.red_alert.activity.wonderful.Wonderful")
            state_machine.excute("wonderful_window_open",0,15)
        elseif genre == 39 then     -- 每日3签 
            app.load("client.red_alert.activity.wonderful.Wonderful")
            state_machine.excute("wonderful_window_open",0,21)
        elseif genre == 40 then     -- 任务
            app.load("client.red_alert.activity.dailytasks.Task")
            state_machine.excute("task_window_open",0,"")
        elseif genre == 41 then     -- 月卡 
            app.load("client.red_alert.activity.wonderful.Wonderful")
            state_machine.excute("wonderful_window_open",0,1)  
        elseif genre == 42 then     -- 江湖 
            app.load("client.red_alert.activity.wonderful.Wonderful")
            app.load("client.red_alert.battle.battle_enum")
            local _Window = fwin:find("NationalWarMapClass")
            if nil == _Window then
                local function responseholdInit(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("national_truce_loading_window_open", 0, {_datas = {open_type = 1}})
                    end
                end
                local function responseCallback2(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        _ED.personal_defender_battle_report_list = {}
                        for i, data in pairs(_ED.city_resource_battle_report) do
                            if tonumber(data.result) == 0 then
                                table.insert(_ED.personal_defender_battle_report_list, data)
                            end
                        end
                        -- responseholdInit({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 1})
                        NetworkManager:register(protocol_command.city_resource_hold_init.code, nil, nil, nil, nil, responseholdInit, false, nil)   
                    end
                end
                local function responseCallback1(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        protocol_command.battlefield_report_get.param_list = battle_enum._fight_type._fight_type_105 + 1000
                        NetworkManager:register(protocol_command.battlefield_report_get.code, nil, nil, nil, nil, responseCallback2, false, nil)
                    end
                end
                protocol_command.user_stronghold_plunder_refresh.param_list = ""
                NetworkManager:register(protocol_command.user_stronghold_plunder_refresh.code, nil, nil, nil, nil, responseCallback1, false, nil)
            end
        elseif genre == 43 then     -- 帮派-药王谷 
            app.load("client.red_alert.union.create.UnionJoin")
            app.load("client.red_alert.union.Union")
            local function responseCallbackUnion(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    if _ED.union.union_info == nil 
                        or _ED.union.union_info == {} 
                        or _ED.union.union_info.union_id == nil 
                        or _ED.union.union_info.union_id == "" 
                        or tonumber(_ED.union.union_info.union_id) == 0 
                        then
                        state_machine.excute("union_join_open", 0, "")
                    else
                        if tonumber(_ED.union.user_union_info.union_post) == 1 or tonumber(_ED.union.user_union_info.union_post) == 2 then
                            protocol_command.union_examine_list.param_list = _ED.union.union_info.union_id
                            NetworkManager:register(protocol_command.union_examine_list.code, nil, nil, nil, nil, nil, false, nil)
                        end
                        state_machine.excute("union_open", 0, "")
                    end
                end
            end 
            _ED.union.union_list_info = nil
            NetworkManager:register(protocol_command.union_init.code, nil, nil, nil, nil, responseCallbackUnion, false, nil)  
        elseif genre == 44 then     -- 充值 
            state_machine.excute("recharge_dialog_window_open",0,"")  
        elseif genre == 45 then     -- 祭祀 
            state_machine.excute("fate_window_open",0,"")  
        elseif genre == 46 then     -- 战功商店
            if zstring.tonumber(_ED.union.user_union_info.union_id) > 0 then
                app.load("client.red_alert.union.Union")
                state_machine.excute("union_open", 0, "")
                state_machine.excute("union_shop_open",0,{2})
            else
                TipDlg.drawTextDailog(red_alert_all_str[157])
            end
        elseif genre == 47 then     -- 至尊转盘 
            if _ED.activity_info == nil or _ED.activity_info["42"] == nil then
                TipDlg.drawTextDailog(red_alert_all_str[260])
            else
                state_machine.excute("activity_cost_rotary_rank_window_open",0,"")  
            end
        else
            TipDlg.drawTextDailog(_function_unopened_tip_string)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--战斗失败跳转
local battel_fail_button_goto_the_way_terminal = {
    _name = "battel_fail_button_goto_the_way",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local goto_index = params[1]
        if _ED._battle_init_type == battle_enum._fight_type._fight_type_0 then      -- 普通
            state_machine.excute("duplicate_manager_window_open",0,{1})
            state_machine.excute("duplicate_title_window_open",0,"")
            state_machine.excute("duplicate_map_window_open",0,"")
            if missionIsOver() == true
                and tonumber(_ED.user_info.user_grade) < 10 
                and _ED.activity_info["2"] ~= nil 
                then
                state_machine.excute("activity_frist_recharge_top_window_open", 0, nil)
            end
        elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_1 then  -- 精英
            state_machine.excute("duplicate_manager_window_open",0,{2})
            state_machine.excute("duplicate_title_window_open",0,"")
            state_machine.excute("duplicate_map_window_open",0,"")
        elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_15 then -- 炼狱
            state_machine.excute("duplicate_manager_window_open",0,{3})
            state_machine.excute("duplicate_title_window_open",0,"")
            state_machine.excute("duplicate_map_window_open",0,"")
        elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_10 then
            state_machine.excute("campaign_window_open",0,"")
            if goto_index == 1 then 
                state_machine.excute("raiders_cut_window_open",0,"")
            end
            -- state_machine.excute("national_truce_loading_window_open", 0, {_datas = {open_type = 1}})
        elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_11 then
            state_machine.excute("tourneyfield_window_open",0,"")
            if goto_index == 1 then 
                state_machine.excute("tourneyfield_officer_window_open",0,"")
            end
            -- 第一次弹出首冲
            if _ED.frist_enter_tourneyField == nil or _ED.frist_enter_tourneyField == false then
                local last_open_scene = 1
                for k,v in pairs(_ED.scene_current_state) do
                    if tonumber(v) >= 0 then
                        last_open_scene = k
                    else
                        break
                    end
                end
                if last_open_scene == 2 then
                    local tempNpcIds = zstring.split(dms.string(dms["pve_scene"], tonumber(last_open_scene), pve_scene.npcs), ",")
                    local minNpcId = tonumber(tempNpcIds[1])
                    local minNpcState = _ED.npc_state[minNpcId]
                    if tonumber(minNpcState) <= 0
                        and _ED.activity_info["2"] ~= nil
                        and zstring.tonumber(_ED.user_info.recharge_all_rmb) == 0
                        then
                        state_machine.excute("activity_frist_recharge_top_window_open", 0, nil)
                    end
                end
            end
            _ED.frist_enter_tourneyField = true
        elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_16 then --宝石
            state_machine.excute("campaign_window_open",0,"")
            if goto_index == 1 then 
                state_machine.excute("gem_duplicate_window_open",0,"")
            end
        elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_17 then -- 兵器
            state_machine.excute("campaign_window_open",0,"")
            if goto_index == 1 then 
                state_machine.excute("weaponry_window_open",0,"")
            end
        elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_18 then  -- 将魂试炼
            state_machine.excute("campaign_window_open",0,"")
            if goto_index == 1 then 
                state_machine.excute("soul_duplicate_window_open",0,"")
            end
        elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_19 then  -- 运送军资
            state_machine.excute("campaign_window_open",0,"")
            if goto_index == 1 then 
                state_machine.excute("ship_military_use_window_open",0,"")
            end
        elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_21 then  -- 工会组队争霸
            app.load("client.red_alert.union.Union")
            state_machine.excute("union_open", 0, "")
            state_machine.excute("union_team_fight_window_open", 0, nil)
        elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_22 then  -- 阿拉希之战
            app.load("client.red_alert.union.Union")
            state_machine.excute("union_open", 0, "")
            state_machine.excute("union_get_physical_fight_window_open", 0, nil)
        elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_23 then  -- 攻城拔寨
            state_machine.excute("campaign_window_open",0,"")
            if _ED.city_resource_battle_end_info ~= nil then
                state_machine.excute("map_rattling_window_open", 0, _ED.city_resource_battle_end_info)
                _ED.city_resource_battle_end_info = nil
            end
            -- state_machine.excute("national_truce_loading_window_open", 0, {_datas = {open_type = 1, open_info = true}})
        elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_102 then -- 无尽之战
            state_machine.excute("campaign_window_open",0,"")
            if goto_index == 1 then 
                state_machine.excute("trialtower_window_open",0,"")
            end
        elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_103 then -- 神兵副本
            app.load("client.red_alert.god_weaponry.GodWeaponryDuplicate")
            state_machine.excute("god_weaponry_duplicate_window_open",0,_ED._god_weaponry_duplicate_level)
        elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_104 then -- 七星台
            state_machine.excute("seven_star_window_open",0,"")
            state_machine.excute("seven_star_map_ui_window_open",0,"")
            state_machine.excute("duplicate_map_window_open",0,"")
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 初始化快捷跳转方式的状态机
local function init_short_cut_terminal()
    state_machine.add(short_cut_go_to_other_window_terminal)
    state_machine.add(battel_fail_button_goto_the_way_terminal)
    state_machine.init()
end

-- call func init shortcut state machine.
init_short_cut_terminal()