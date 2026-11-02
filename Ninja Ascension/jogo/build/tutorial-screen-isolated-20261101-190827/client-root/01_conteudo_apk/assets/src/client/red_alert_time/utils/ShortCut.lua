
local short_cut_go_to_other_window_terminal = {
    _name = "short_cut_go_to_other_window",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local function_param_id = params[1]
        local short_type = params[2]
        local help_info = params[3]
        local genre = dms.int(dms["function_param"],function_param_id,function_param.genre)
        local fun_open_id = dms.int(dms["function_param"],function_param_id,function_param.open_function)
        if funOpenDrawTip(fun_open_id) == true then
            return
        end
-- -1: 无跳转
--  5: 征战(主线副本)
--  6: 征战-配件补给(精英副本)
--  7: 征战-装甲副本
-- 44: 充值
-- 48: 玩家详情-详情
-- 49: 玩家详情-技能
-- 50: 玩家详情-建造
-- 51: 玩家详情-军衔
-- 52: 基地-司令部-建造
-- 53: 基地-坦克工厂I-建造
-- 54: 基地-坦克工厂I-生产
-- 55: 基地-科研中心-建造
-- 56: 基地-科研中心-研究   
-- 57: 基地-配件车间-配件
-- 58: 将领学堂-将领
-- 59: 基地-仓库I
-- 60: 世界-我的基地
-- 61: 世界-附近的人
-- 62: 世界-附近的矿 
-- 63: 作战中心-战地争霸   
-- 64: 作战中心-远征 
-- 65: 幸运抽奖-普通抽奖
-- 66: 幸运抽奖-高级抽奖
-- 67: 物品-商店    
-- 68: 装甲车间-装甲  
-- 69: 装甲车间-生产  
-- 70: 基地定位仪 
-- 71  资源位跳转（找最新开的资源位，没有则跳转主界面即可）
-- 72  铁矿场（找最高级别的，没有则跳转到主界面即可）
-- 73  石油（找最高级别的，没有则跳转到主界面即可）
-- 74  铅矿场（找最高级别的，没有则跳转到主界面即可）
-- 75  钛矿场（优先空的钛矿场，没有则找最高级别的）
-- 76  宝石矿场
-- 77  军团副本
-- 78  军团商店
-- 79  军团科技
-- 80  军团切磋
-- 81  作战中心-学霸之战
-- 82  作战中心-敌军来袭
-- 83  作战中心-叛军出没
-- 84  作战中心-极限挑战
-- 85  作战中心-军团争霸
-- 86  作战中心-阵营对决
-- 87  作战中心-守卫战
-- 88  作战中心-智冠三军初赛
-- 89  作战中心-智冠三军决赛
-- 90  作战中心-跨服军团争霸
-- 91  任务-主线任务
-- 92  基地-英雄兵营-招募
-- 93  聊天-世界
-- 94  排行榜-战力排行榜
-- 95  基地储备-增益
-- 96  活动-成长计划
-- 97  活动-礼包兑换
-- 98  活动-战地机甲(活动类型58)
-- 99  活动-沙漠雄狮(活动类型75)
-- 100 活动-坦克组装(活动类型71)
-- 101 活动-兄弟同享(活动类型57)
-- 102 好友列表
-- 103 征战（主线副本章节选择页面）
-- 104 改造工厂-生产界面
-- 105 制造工厂-生产界面
        local info = {}
        local isShowPrompt = true
        state_machine.excute("task_window_close",0,"")
        local activityWindow = fwin:find("WonderfulClass")
        if activityWindow ~= nil and activityWindow:isVisible() == true then
            state_machine.excute("wonderful_window_close",0,nil)
        end
        if genre == 5 then          -- 征战(主线副本)
            state_machine.excute("pve_manager_window_open", 0, {_datas = {_page = 1}})
            local scence_id = dms.int(dms["function_param"],function_param_id,function_param.open_scene)
            if nil ~= _ED.scene_current_state then
                local scene_state = tonumber(_ED.scene_current_state[tonumber(scence_id)])
                if scene_state == nil then
                    for k,v in pairs(_ED.scene_current_state) do
                        if tonumber(v) < 0 then
                            state_machine.excute("pve_map_open", 0, {k-1})
                            break
                        end
                    end
                elseif scene_state < 0 then
                    state_machine.excute("pve_map_open", 0, {scence_id-1})
                else
                    state_machine.excute("pve_map_open", 0, {scence_id})
                end
            else
                state_machine.excute("pve_map_open", 0, {scence_id})
            end
        elseif genre == 6 then      -- 征战-配件补给(精英副本)
            state_machine.excute("pve_manager_window_open", 0, {_datas = {_page = 2}})
        elseif genre == 7 then      -- 征战-装甲副本
            state_machine.excute("pve_manager_window_open", 0, {_datas = {_page = 3}})
        elseif genre == 44 then     -- 充值
            state_machine.excute("recharge_dialog_window_open", 0, nil)
        elseif genre == 48 then     -- 玩家详情-详情
            state_machine.excute("player_info_window_open",0,{_datas = {_page = 1}})
            state_machine.excute("props_shop_packs_window_close",0,"")
        elseif genre == 49 then     -- 玩家详情-技能
            state_machine.excute("player_info_window_open",0,{_datas = {_page = 2}})
            state_machine.excute("props_shop_packs_window_close",0,"")
        elseif genre == 50 then     -- 玩家详情-建造
            state_machine.excute("player_info_window_open",0,{_datas = {_page = 3}})
        elseif genre == 51 then     -- 玩家详情-军衔
            state_machine.excute("player_military_rank_window_open",0,"")
        elseif genre == 52 then     -- 基地-司令部-建造
            -- state_machine.excute("build_up_headquarters_window_open",0,{1})
            state_machine.excute("home_map_build_tracking",0,{"build_up_headquarters_window_open", {1}})

            -- info.build_id = 1
            -- state_machine.excute("home_map_scroll_to_panel_city", 0, {1, true, nil, info})
        elseif genre == 53 then     -- 基地-坦克工厂I-建造
            local base_build_info = _ED.base_build_info["9"]
            -- state_machine.excute("build_up_tank_factory_window_open",0,{9,base_build_info})
            state_machine.excute("home_map_build_tracking",0,{"build_up_tank_factory_window_open", {9,base_build_info}})

            -- info.build_id = 9
            -- info.base_build_info = _ED.base_build_info["9"]
            -- state_machine.excute("home_map_scroll_to_panel_city", 0, {9, true, nil, info})
        elseif genre == 54 then     -- 基地-坦克工厂I-生产
            local base_build_info = _ED.base_build_info["9"]
            -- state_machine.excute("build_up_tank_factory_window_open",0,{9,base_build_info,2})
            state_machine.excute("home_map_build_tracking",0,{"build_up_tank_factory_window_open", {9,base_build_info,2}})

            -- info.build_id = 9
            -- info.base_build_info = _ED.base_build_info["9"]
            -- info.open_type = 2
            -- state_machine.excute("home_map_scroll_to_panel_city", 0, {9, true, nil, info})
        elseif genre == 55 then     -- 基地-科研中心-建造
            local base_build_info = _ED.base_build_info["3"]
            -- state_machine.excute("build_up_scientific_window_open",0,{3,base_build_info})
            state_machine.excute("home_map_build_tracking",0,{"build_up_scientific_window_open", {3,base_build_info}})

            -- info.build_id = 3
            -- info.base_build_info = _ED.base_build_info["3"]
            -- state_machine.excute("home_map_scroll_to_panel_city", 0, {3, true, nil, info})
        elseif genre == 56 then     -- 基地-科研中心-研究  
            local base_build_info = _ED.base_build_info["3"]
            -- state_machine.excute("build_up_scientific_window_open",0,{3,base_build_info})
            -- state_machine.excute("build_up_scientific_change_to_introduce_page",0,"")
            state_machine.excute("home_map_build_tracking",0,{"build_up_scientific_window_open", {3,base_build_info,2}})

            -- info.build_id = 3
            -- info.base_build_info = _ED.base_build_info["3"]
            -- info.open_type = 2
            -- state_machine.excute("home_map_scroll_to_panel_city", 0, {3, true, nil, info})
        elseif genre == 57 then     -- 基地-配件车间-配件
            state_machine.excute("equipment_window_open",0,"")
        elseif genre == 58 then     -- 将领学堂-将领
            state_machine.excute("leader_school_window_open",0,{_datas = {_page = 2}})
        elseif genre == 59 then     -- 基地-仓库I
            local base_build_info = _ED.base_build_info["13"]
            -- state_machine.excute("build_up_res_window_open",0,{13,base_build_info})
            state_machine.excute("home_map_build_tracking",0,{"build_up_res_window_open", {13,base_build_info}})

            -- info.build_id = 13
            -- info.base_build_info = _ED.base_build_info["13"]
            -- state_machine.excute("home_map_scroll_to_panel_city", 0, {13, true, nil, info})
        elseif genre == 60 then     -- 世界-我的基地
            state_machine.excute("props_shop_packs_window_close",0,nil)
            state_machine.excute("legion_window_close", 0, 0)
            state_machine.excute("legion_active_close", 0, 0)
            state_machine.excute("red_alert_time_seven_day_activity_window_close", 0, 0)
            state_machine.excute("home_button_select_page", 0, {_datas = {select_page = 2}})
			state_machine.excute("red_alert_time_mine_locate_yourself",0,0)
        elseif genre == 61 then     -- 世界-附近的人
            state_machine.excute("home_button_select_page", 0, {_datas = {select_page = 2}})
			state_machine.excute("red_alert_time_mine_view_nearby",0,1)
        elseif genre == 62 then     -- 世界-附近的矿
            state_machine.excute("home_button_select_page", 0, {_datas = {select_page = 2}})
			state_machine.excute("red_alert_time_mine_view_nearby",0,2)
			state_machine.excute("red_alert_time_mine_Page_Players_and_resources",0,{_datas = {_page = 2}})
        elseif genre == 63 then     -- 作战中心-战地争霸   
            state_machine.excute("arena_window_open",0,"")
        elseif genre == 64 then     -- 作战中心-远征 
            app.load("client.red_alert_time.campaign.ExpeditionManager")
            state_machine.excute("expedition_manager_window_open",0,"")
        elseif genre == 65 then     -- 幸运抽奖-普通抽奖
            state_machine.excute("red_alert_time_lucky_draw_window_open",0,"")
            state_machine.excute("props_shop_packs_window_close",0,"")
        elseif genre == 66 then     -- 幸运抽奖-高级抽奖
            state_machine.excute("red_alert_time_lucky_draw_window_open",0,"")
            state_machine.excute("red_alert_time_lucky_draw_change_page",0,{_datas = {_page = 2 , _fun_open = 231}})
            state_machine.excute("props_shop_packs_window_close",0,"")
        elseif genre == 67 then     -- 物品-商店
            state_machine.excute("props_shop_packs_window_open",0,{_datas = {page_index = 1}})
            if short_type ~= nil then
                state_machine.excute("props_shop_packs_shop_tab_change_page",0,{_datas = {page_index = short_type}})
            end
        elseif genre == 68 then     -- 装甲车间-装甲  
            state_machine.excute("armor_window_open", 0, {_datas = {_page = 2}})
        elseif genre == 69 then     --  装甲车间-生产  
            state_machine.excute("armor_window_open", 0, {_datas = {_page = 1}})
        elseif genre == 70 then     -- 基地定位仪

        elseif genre == 71 then     -- 资源位跳转（找最新开的资源位，没有则跳转主界面即可）
            local result = {}
            for k,v in pairs(_ED.home_build) do
                if tonumber(v.build_mould_id) >= 25 
                    and tonumber(v.build_mould_id) <= 53 
                    then
                    table.insert(result, v)
                end
            end
            local function sortBuild( a, b )
                return tonumber(a.build_mould_id) > tonumber(b.build_mould_id)
            end
            table.sort(result, sortBuild)
            local build = result[1]
            if build ~= nil then
                local base_build_info = _ED.base_build_info[""..build.build_mould_id]
                -- state_machine.excute("build_up_res_build_window_open", 0, {build.base_mould_id, base_build_info})
                state_machine.excute("home_map_build_tracking",0,{"build_up_res_build_window_open", {build.base_mould_id, base_build_info}})

                -- info.build_id = build.base_mould_id
                -- info.base_build_info = _ED.base_build_info[""..build.build_mould_id]
                -- state_machine.excute("home_map_scroll_to_panel_city", 0, {build.base_mould_id, true, nil, info})
            end
        elseif genre == 72          -- 铁矿场（找最高级别的，没有则跳转到主界面即可）
            or genre == 73          -- 石油（找最高级别的，没有则跳转到主界面即可）
            or genre == 74          -- 铅矿场（找最高级别的，没有则跳转到主界面即可）
            then
            local result = {}
            for k,v in pairs(_ED.home_build) do
                if tonumber(v.build_mould_id) == genre - 50 then
                    table.insert(result, v)
                end
            end
            local function sortBuild( a, b )
                return tonumber(a.level) > tonumber(b.level)
            end
            table.sort(result, sortBuild)
            local build = result[1]
            if build ~= nil then
                local base_build_info = _ED.base_build_info[""..build.build_mould_id]
                -- state_machine.excute("build_up_res_window_open", 0, {build.base_mould_id, base_build_info})
                state_machine.excute("home_map_build_tracking",0,{"build_up_res_window_open", {build.base_mould_id, base_build_info}})

                -- info.build_id = build.base_mould_id
                -- info.base_build_info = _ED.base_build_info[""..build.build_mould_id]
                -- state_machine.excute("home_map_scroll_to_panel_city", 0, {build.base_mould_id, true, nil, info})
            end
        elseif genre == 75 then  -- 75  钛矿场（优先空的钛矿场，没有则找最高级别的）
            local result = {}
            local build = nil
            for k,v in pairs(_ED.home_build) do
                if tonumber(v.build_mould_id) >= 16 
                    and tonumber(v.build_mould_id) <= 21 then
                    table.insert(result, v)
                    if tonumber(v.level) == 0 then
                        build = v
                        break
                    end
                end
            end
            if build ~= nil then
                local base_build_info = _ED.base_build_info[""..build.build_mould_id]
                -- state_machine.excute("build_up_res_window_open", 0, {build.base_mould_id, base_build_info})
                state_machine.excute("home_map_build_tracking",0,{"build_up_res_window_open", {build.base_mould_id, base_build_info}})

                -- info.build_id = build.base_mould_id
                -- info.base_build_info = _ED.base_build_info[""..build.build_mould_id]
                -- state_machine.excute("home_map_scroll_to_panel_city", 0, {build.base_mould_id, true, nil, info})
            else
                local function sortBuild( a, b )
                    return tonumber(a.level) > tonumber(b.level)
                end
                table.sort(result, sortBuild)
                build = result[1]
                if build ~= nil then
                    local base_build_info = _ED.base_build_info[""..build.build_mould_id]
                    -- state_machine.excute("build_up_res_window_open", 0, {build.base_mould_id, base_build_info})
                    state_machine.excute("home_map_build_tracking",0,{"build_up_res_window_open", {build.base_mould_id, base_build_info}})
                end
            end
        elseif genre == 76 then  -- 76  宝石矿场
            local result = {}
            for k,v in pairs(_ED.home_build) do
                if tonumber(v.build_mould_id) == 15 then
                    table.insert(result, v)
                end
            end
            local function sortBuild( a, b )
                return tonumber(a.level) > tonumber(b.level)
            end
            table.sort(result, sortBuild)
            local build = result[1]
            if build ~= nil then
                local base_build_info = _ED.base_build_info[""..build.build_mould_id]
                -- state_machine.excute("build_up_res_window_open", 0, {build.base_mould_id, base_build_info})
                state_machine.excute("home_map_build_tracking",0,{"build_up_res_window_open", {build.base_mould_id, base_build_info}})
                
                -- info.build_id = build.base_mould_id
                -- info.base_build_info = _ED.base_build_info[""..build.build_mould_id]
                -- state_machine.excute("home_map_scroll_to_panel_city", 0, {build.base_mould_id, true, nil, info})
            end
        elseif genre == 77 then     -- 军团副本
            if _ED.union.union_info == nil 
                or _ED.union.union_info == {} 
                or _ED.union.union_info.union_id == nil 
                or _ED.union.union_info.union_id == "" 
                or tonumber(_ED.union.union_info.union_id) == 0 
                then
                isShowPrompt = false
                state_machine.excute("legion_window_open", 0, "")
            else
                local function gotoLegionPve()
                    local user_union_info = nil
                    for k,v in pairs(_ED.union.union_member_list_info) do
                        if tonumber(v.id) == tonumber(_ED.user_info.user_id) then
                            user_union_info = v
                        end
                    end
                    app.load("client.red_alert_time.legion.LegionPve")
                    state_machine.excute("legion_pve_window_open", 0, {user_union_info})
                end
                if zstring.tonumber(_ED.union.union_member_list_sum) == 0 then
                    local function responseCallbackUnion(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            gotoLegionPve()
                        end
                    end
                    _ED.union.union_list_info = nil
                    protocol_command.union_init.param_list = "0"
                    NetworkManager:register(protocol_command.union_init.code, nil, nil, nil, nil, responseCallbackUnion, false, nil)
                else
                    gotoLegionPve()
                end
            end
        elseif genre == 78 then     -- 军团商店
            if _ED.union.union_info == nil 
                or _ED.union.union_info == {} 
                or _ED.union.union_info.union_id == nil 
                or _ED.union.union_info.union_id == "" 
                or tonumber(_ED.union.union_info.union_id) == 0 
                then
                state_machine.excute("legion_window_open", 0, "")
            else
                app.load("client.red_alert_time.legion.LegionShop")
                state_machine.excute("legion_shop_window_open", 0, "")
            end
        elseif genre == 79 then     -- 军团科技
            if _ED.union.union_info == nil 
                or _ED.union.union_info == {} 
                or _ED.union.union_info.union_id == nil 
                or _ED.union.union_info.union_id == "" 
                or tonumber(_ED.union.union_info.union_id) == 0 
                then
                state_machine.excute("legion_window_open", 0, "")
            else
                app.load("client.red_alert_time.legion.LegionTechnologyDonate")
                state_machine.excute("legion_technology_donate_window_open", 0, "")
            end
        elseif genre == 80 then     -- 军团切磋
            if _ED.union.union_info == nil 
                or _ED.union.union_info == {} 
                or _ED.union.union_info.union_id == nil 
                or _ED.union.union_info.union_id == "" 
                or tonumber(_ED.union.union_info.union_id) == 0 
                then
                state_machine.excute("legion_window_open", 0, "")
            else
                local function gotoLegionPk()
                    app.load("client.red_alert_time.legion.LegionPK")
                    state_machine.excute("legion_pk_open", 0, "")
                end
                if zstring.tonumber(_ED.union.union_member_list_sum) == 0 then
                    local function responseCallbackUnion(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            gotoLegionPk()
                        end
                    end
                    _ED.union.union_list_info = nil
                    protocol_command.union_init.param_list = "0"
                    NetworkManager:register(protocol_command.union_init.code, nil, nil, nil, nil, responseCallbackUnion, false, nil)
                else
                    gotoLegionPk()
                end
            end
        elseif genre == 81 then     -- 作战中心-学霸之战
            app.load("client.red_alert_time.campaign.SuperScholar")
            state_machine.excute("super_scholar_window_open",0,"")
        elseif genre == 82 then     -- 作战中心-敌军来袭 
            local base_info = zstring.split(zstring.split(dms.string(dms["enemy_boss_config"], 14, enemy_boss_config.param), "|")[1], ",")
            local _x, _y = zstring.tonumber(base_info[1]), zstring.tonumber(base_info[2])
            state_machine.excute("home_button_select_page", 0, {_datas = {select_page = 2}})
            state_machine.excute("adventure_mine_record_view_position", 0, {_x, _y})
            state_machine.excute("adventure_mine_update_view_position", 0, 0)
            state_machine.excute("world_input_window_close", 0, 0)
            protocol_command.world_map_arena_info_refresh.param_list = _x.."\r\n".._y
            NetworkManager:register(protocol_command.world_map_arena_info_refresh.code, nil, nil, nil, nil, nil, false, nil)
            _ED.world_map_focus = {_x, _y}
            state_machine.excute("adventure_mine_enemy_boss_change_state", 0, nil)
            state_machine.excute("enemy_strike_world_box_open",0,"")
        elseif genre == 83 then     -- 作战中心-叛军出没 
            if funOpenDrawTip(210) == true then
                return
            end 
            if funOpenDrawTip(155) == true then
                return
            end 
            app.load("client.red_alert_time.campaign.RebelHaunt")
            state_machine.excute("rebel_haunt_open",0,"")
        elseif genre == 84 then     -- 作战中心-极限挑战 
            app.load("client.red_alert_time.campaign.LimitDekaron")
            state_machine.excute("limit_dekaron_window_open",0,"")
        elseif genre == 85 then     -- 作战中心-军团争霸 
            app.load("client.red_alert_time.legion.LegionHegemony")
            if funOpenDrawTip(155, false) == true then
                TipDlg.drawTextDailog(red_alert_time_str[159])
            else
                state_machine.excute("legion_hegemony_window_open", 0, nil)
            end
        elseif genre == 86 then     -- 作战中心-阵营对决 
            app.load("client.red_alert_time.campaign.CampPk")
            state_machine.excute("camp_pk_open",0,"")
        elseif genre == 87 then     -- 作战中心-守卫战 
            app.load("client.red_alert_time.campaign.GuardBattle")
            state_machine.excute("guard_battle_window_open",0,"")
        -- elseif genre == 88 then     -- 作战中心-智冠三军初赛 
        -- elseif genre == 89 then     -- 作战中心-智冠三军决赛 
        -- elseif genre == 90 then     -- 作战中心-跨服军团争霸 
        elseif genre == 91 then     -- 主线任务
            state_machine.excute("task_window_open",0,"")
        elseif genre == 92 then     -- 将领招募
            state_machine.excute("leader_school_window_open",0,"")
        elseif genre == 93 then     -- 聊天
            state_machine.excute("home_button_window_open_chat",0, {_datas = {_page = 1}})
        elseif genre == 94 then     -- 战力排行榜
            state_machine.excute("rank_window_open",0, {_datas = {list_type = 1}})
        elseif genre == 95 then     -- 增益
            state_machine.excute("base_reserve_window_open",0,{_datas = {page_index = 2}})
        elseif genre == 96 then     -- 活动-成长计划
            if _ED.activity_info["9"] ~= nil then
                state_machine.excute("wonderful_window_open", 0, 9)
            else
                TipDlg.drawTextDailog(_wonderful_string[4])
            end
        elseif genre == 97 then     -- 活动-礼包兑换
            if nil ~= _ED.server_review and zstring.tonumber(_ED.server_review) ~= 1 then
                state_machine.excute("wonderful_window_open", 0, 16)
            else
                TipDlg.drawTextDailog(_wonderful_string[4])
            end
        elseif genre == 98 then     -- 活动-战地机甲(活动类型58)
            if _ED.activity_info["58"] ~= nil then
                state_machine.excute("red_alert_time_center_window_open", 0, "")
                state_machine.excute("red_alert_time_tank_draw_window_open",0,{_ED.activity_info["58"],1})
                state_machine.excute("red_alert_time_chat_sent_window_close_action", 0, 0)
            elseif _ED.activity_info["102"] ~= nil then
                state_machine.excute("red_alert_time_center_window_open", 0, "")
                state_machine.excute("red_alert_time_tank_draw_window_open",0,{_ED.activity_info["102"]}) 
                state_machine.excute("red_alert_time_chat_sent_window_close_action", 0, 0)
            else
                TipDlg.drawTextDailog(_wonderful_string[4])
            end
        elseif genre == 99 then     -- 活动-沙漠雄狮(活动类型75)
            if _ED.activity_info["75"] ~= nil then
                state_machine.excute("red_alert_time_center_window_open", 0, "")
                state_machine.excute("red_alert_time_tank_draw_window_open",0,{_ED.activity_info["75"],1})
                state_machine.excute("red_alert_time_chat_sent_window_close_action", 0, 0)
            elseif _ED.activity_info["102"] ~= nil then
                state_machine.excute("red_alert_time_center_window_open", 0, "")
                state_machine.excute("red_alert_time_tank_draw_window_open",0,{_ED.activity_info["102"]}) 
                state_machine.excute("red_alert_time_chat_sent_window_close_action", 0, 0)
            else
                TipDlg.drawTextDailog(_wonderful_string[4])
            end
        elseif genre == 100 then     -- 活动-坦克组装(活动类型71)
            if _ED.activity_info["71"] ~= nil then
                state_machine.excute("red_alert_time_center_window_open", 0, "")
                state_machine.excute("red_alert_time_equipment_beast_window_open",0,{_ED.activity_info["71"]}) 
                state_machine.excute("red_alert_time_chat_sent_window_close_action", 0, 0)
            elseif _ED.activity_info["104"] ~= nil then
                state_machine.excute("red_alert_time_center_window_open", 0, "")
                state_machine.excute("red_alert_time_equipment_beast_window_open",0,{_ED.activity_info["104"]}) 
                state_machine.excute("red_alert_time_chat_sent_window_close_action", 0, 0)
            elseif _ED.activity_info["105"] ~= nil then
                state_machine.excute("red_alert_time_center_window_open", 0, "")
                state_machine.excute("red_alert_time_equipment_beast_window_open",0,{_ED.activity_info["105"]}) 
                state_machine.excute("red_alert_time_chat_sent_window_close_action", 0, 0)
            else
                TipDlg.drawTextDailog(_wonderful_string[4])
            end
        elseif genre == 101 then     -- 活动-兄弟同享(活动类型57)
            if _ED.activity_info["57"] ~= nil then
                state_machine.excute("red_alert_time_center_window_open", 0, "")
                state_machine.excute("red_alert_time_brothers_share_window_open",0,{_ED.activity_info["57"]})
                state_machine.excute("red_alert_time_chat_sent_window_close_action", 0, 0)
            else
                TipDlg.drawTextDailog(_wonderful_string[4])
            end
        elseif genre == 102 then     -- 好友列表
            state_machine.excute("game_social_platforms_open", 0, {_datas = {page = 1}})
        elseif genre == 103 then     -- 征战（主线副本章节选择页面）
            state_machine.excute("pve_manager_window_open", 0, {_datas = {_page = 1}})
        elseif genre == 104 then     -- 改造工厂-生产界面
            local base_build_info = _ED.base_build_info["11"]
            state_machine.excute("home_map_build_tracking",0,{"build_up_reform_factory_window_open", {11, base_build_info, 2}})
        elseif genre == 105 then     -- 制造工厂-生产界面
            local base_build_info = _ED.base_build_info["8"]
            state_machine.excute("home_map_build_tracking",0,{"build_up_make_factory_window_open", {8, base_build_info, 2}})
        else
            TipDlg.drawTextDailog(_function_unopened_tip_string)
        end
        if isShowPrompt == true and help_info ~= nil and help_info.distribute ~= "" then
            app.load("client.red_alert_time.utils.TeachingChat")
            fwin:addService({
                callback = function ( params )
                    state_machine.excute("teaching_chat_open", 0, help_info)
                end,
                delay = 0.3,
                params = nil
            })
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
            app.load("client.red_alert_time.union.Union")
            state_machine.excute("union_open", 0, "")
            state_machine.excute("union_team_fight_window_open", 0, nil)
        elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_22 then  -- 阿拉希之战
            app.load("client.red_alert_time.union.Union")
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
            app.load("client.red_alert_time.god_weaponry.GodWeaponryDuplicate")
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

-- 请求战斗
local adventure_mine_request_battle_field_init_terminal = {
    _name = "adventure_mine_request_battle_field_init",
    _init = function (terminal)

    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        _ED._battle_init_type = params[1]
        _ED._current_scene_id = params[2]
        _ED._scene_npc_id = params[3]
        _ED._npc_difficulty_index = params[4]

        state_machine.lock("adventure_mine_request_battle_field_init")

        local function responseBattleFieldInitCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                fwin:addService({
                    callback = function ( params )
                        state_machine.unlock("adventure_mine_request_battle_field_init")
                    end,
                    delay = 0.3,
                    params = nil
                })
                if _ED._battle_sweep == 1 then

                else
                    -- fwin:cleanView(fwin._ui)
                    _ED.init_environment_fight_complete = true
                    
                    if _ED._battle_init_type == battle_enum._fight_type._fight_type_204
                        or _ED._battle_init_type == battle_enum._fight_type._fight_type_11
                        then
                    else
                        state_machine.excute("formation_defend_close", 0, 0)
                    end
                    state_machine.excute("formation_window_close", 0, 0)
                    if _ED._battle_init_type == battle_enum._fight_type._fight_type_204 then
                        state_machine.excute("enemy_strike_fight_update_hp_info", 0, {true})
                    else
                        state_machine.excute("fight_window_open", 0, 0)
                    end
                end
            else
                state_machine.unlock("adventure_mine_request_battle_field_init")
                if _ED._battle_init_type == battle_enum._fight_type._fight_type_209 then
                    state_machine.excute("guard_battle_request_guard_list", 0, "")
                end
            end
        end
        
        local data = params[5] or "0"
        local attack_formation = params[6]
        _ED._battle_sweep = params[7]
        local responseCallback = params[8]
        responseCallback = responseCallback or responseBattleFieldInitCallback
        if _ED._battle_init_type == battle_enum._fight_type._fight_type_107 then
            protocol_command.battle_field_init.param_list = _ED._current_scene_id.."\r\n".._ED._scene_npc_id.."\r\n".._ED._npc_difficulty_index .."\r\n".. data .."\r\n"..attack_formation.."\r\n".. params[7]
        elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_24 then
            protocol_command.battle_field_init.param_list = _ED._current_scene_id.."\r\n".._ED._scene_npc_id.."\r\n"..attack_formation
        elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_201 then
            protocol_command.battle_field_init.param_list = _ED._current_scene_id.."\r\n".._ED._scene_npc_id.."\r\n".._ED._npc_difficulty_index.."\r\n"..attack_formation
        elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_202 then
            protocol_command.battle_field_init.param_list = _ED._current_scene_id.."\r\n".._ED._scene_npc_id.."\r\n".._ED._npc_difficulty_index
        elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_203 then
            protocol_command.battle_field_init.param_list = _ED._current_scene_id.."\r\n".._ED._scene_npc_id.."\r\n".._ED._npc_difficulty_index.."\r\n"..attack_formation
        elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_204 then
            protocol_command.battle_field_init.param_list = _ED._current_scene_id.."\r\n".._ED._scene_npc_id.."\r\n".._ED._npc_difficulty_index
        elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_209 then
            protocol_command.battle_field_init.param_list = _ED._current_scene_id.."\r\n".._ED._scene_npc_id.."\r\n".._ED._npc_difficulty_index.."\r\n"..attack_formation
        else
            protocol_command.battle_field_init.param_list = _ED._current_scene_id.."\r\n".._ED._scene_npc_id.."\r\n".._ED._npc_difficulty_index .."\r\n".. data .."\r\n"..attack_formation
        end
        NetworkManager:register(protocol_command.battle_field_init.code, nil, nil, nil, nil, responseCallback, false, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 初始化快捷跳转方式的状态机
local function init_short_cut_terminal()
    state_machine.add(short_cut_go_to_other_window_terminal)
    state_machine.add(battel_fail_button_goto_the_way_terminal)
    state_machine.add(adventure_mine_request_battle_field_init_terminal)
    state_machine.init()
end

-- call func init shortcut state machine.
init_short_cut_terminal()