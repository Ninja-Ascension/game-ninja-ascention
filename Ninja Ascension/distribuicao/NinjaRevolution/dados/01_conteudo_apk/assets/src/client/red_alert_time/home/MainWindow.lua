--------------------------------------------------------------------------------------------------------------
--  说明：主页窗口
--------------------------------------------------------------------------------------------------------------
MainWindow = class("MainWindowClass", Window)

--打开界面
local main_window_open_terminal = {
    _name = "main_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("MainWindowClass") == nil then
            fwin:open(MainWindow:new():init(), fwin._frameview)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local main_window_close_terminal = {
    _name = "main_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)

        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--清除其他的界面，回到主页
local main_window_back_terminal = {
    _name = "main_window_back",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.excute("pve_map_close", 0, "")
        state_machine.excute("pve_manager_window_close", 0, 0)
        fwin:cleanView(fwin._viewdialog)
        fwin:cleanView(fwin._taskbar)
        fwin:cleanView(fwin._ui)
        fwin:cleanView(fwin._windows)
        fwin:unAllCovers(nil, true)
        -- state_machine.excute("wonderful_window_hide", 0, 0)
        _ED.current_window_in_main_city = true
        state_machine.excute("wonderful_window_close", 0, 0)
        state_machine.excute("main_window_show", 0, "main_window_show.")
        state_machine.excute("adventure_mine_manager_hide", 0, "")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(main_window_open_terminal)
state_machine.add(main_window_close_terminal)
state_machine.add(main_window_back_terminal)
state_machine.init()

function MainWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    
    app.load("client.shop.recharge.RechargeDialog")
    app.load("client.utils.ConfirmTip")
    app.load("client.red_alert_time.battle.battle_enum")
    app.load("client.red_alert_time.utils.ShortCut")
    app.load("client.red_alert_time.home.HomeButton")
    app.load("client.red_alert_time.home.HomeMap")
    app.load("client.red_alert_time.player.PlayerInfo")
    app.load("client.red_alert_time.player.PlayerInfoPrestige")
    app.load("client.red_alert_time.player.PlayerInfoBoomUp")
    app.load("client.red_alert_time.player.PlayerInfoBoomWindow")
    app.load("client.red_alert_time.player.PlayerFight")
    app.load("client.red_alert_time.player.PlayerInfoCommand")
    app.load("client.red_alert_time.player.PlayerMilitaryRank")
    app.load("client.red_alert_time.player.PlayerTitleSet")
    
    app.load("client.red_alert_time.campaign.EnemyStrikeWorldBox")

    app.load("client.red_alert_time.pve.PveManager")

    app.load("client.red_alert_time.build_up.BuildUpHeadquarters")
    app.load("client.red_alert_time.build_up.BuildUpTankFactory")
    app.load("client.red_alert_time.build_up.BuildUpReformFactory")
    app.load("client.red_alert_time.build_up.BuildUpRes")
    app.load("client.red_alert_time.build_up.BuildUpResBuild")
    app.load("client.red_alert_time.build_up.BuildUpResBuildInfor")
    app.load("client.red_alert_time.build_up.BuildUpScientific")
    app.load("client.red_alert_time.build_up.BuildUpMakeFactory")
    app.load("client.red_alert_time.build_up.BuildUpTankProduction")
    app.load("client.red_alert_time.build_up.BuildUpTankProductionProc")
    app.load("client.red_alert_time.build_up.BuildUpBbuildQuickly")
    app.load("client.red_alert_time.build_up.BuildUpBuildProductionQuickly")
    app.load("client.red_alert_time.build_up.BuildUpBuildScientificQuickly")
    app.load("client.red_alert_time.build_up.BuildUpTankWarehouse")
    app.load("client.red_alert_time.build_up.BuildUpTankWarehouseEx")

    app.load("client.red_alert_time.formation.Formation")
    app.load("client.red_alert_time.formation.FormationDefend")
    app.load("client.red_alert_time.formation.FormationDefendAttack")
    app.load("client.red_alert_time.leader.LeaderInfo")
    app.load("client.red_alert_time.leader.LeaderSchool")

    app.load("client.red_alert_time.legion.Legion")
    app.load("client.red_alert_time.legion.LegionRewardWindow")
    app.load("client.red_alert_time.legion.LegionCityImageInfor")
    app.load("client.red_alert_time.legion.LegionCity")
    app.load("client.red_alert_time.legion.LegionAddPush")
    app.load("client.red_alert_time.legion.LegionCityShop")
    app.load("client.red_alert_time.legion.LegionCityFormation")
    
    app.load("client.red_alert_time.worldMap.redAlertTimeMineEventQueue")
    app.load("client.red_alert_time.worldMap.redAlertTimeMineWarmTips")

    app.load("client.red_alert_time.props.PropsShopPacks")
    app.load("client.red_alert_time.props.BaseReserve")
    app.load("client.red_alert_time.props.PropsUse")
    app.load("client.red_alert_time.props.BaseReserveTab")
    app.load("client.red_alert_time.cells.props.props_icon_cell")

    app.load("client.red_alert_time.rank.Rank")
    app.load("client.red_alert_time.equipment.Equipment")
    app.load("client.red_alert_time.activity.dailytasks.Task")
    app.load("client.red_alert_time.activity.dailytasks.TaskUrgent")
    app.load("client.red_alert_time.mail.Mail")
    app.load("client.red_alert_time.campaign.Campaign")
    app.load("client.red_alert_time.activity.dailytasks.TaskDetail")

    --notification
    app.load("client.red_alert_time.utils.UtilTips")
    app.load("client.home.WarshipGirlPushInfo")
    app.load("client.red_alert_time.home.HomeHorn")
    app.load("client.red_alert_time.home.HomeHornRedEnvelopes")
    app.load("client.red_alert_time.notification.push_notification_home_button")
    app.load("client.red_alert_time.notification.push_notification_legion")
    app.load("client.red_alert_time.notification.push_notification_campaign")
    app.load("client.red_alert_time.notification.push_notification_treasurehouse")
    app.load("client.red_alert_time.notification.push_notification_world_map")
    app.load("client.red_alert_time.utils.EffectPlay")
    app.load("client.red_alert_time.utils.TeachingWindow")

    app.load("client.red_alert_time.chat.RedAlertTimeChatSent")
    app.load("client.red_alert_time.cells.chats.chat_sent_other_player_cell")
    app.load("client.red_alert_time.cells.chats.chat_sent_player_cell")
    app.load("client.red_alert_time.cells.chats.chat_sent_world_cell")
    app.load("client.red_alert_time.cells.chats.chat_sent_face_cell")
	app.load("client.red_alert_time.chat.SocialPlatforms")
	app.load("client.red_alert_time.system.RedAlertTimeSystemSettings")
	app.load("client.red_alert_time.arena.arena_window")
	app.load("client.red_alert_time.utils.combatEffectivenessUp")
	app.load("client.red_alert_time.activity.wonderful.Wonderful")
	app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeCenter")
	app.load("client.red_alert_time.cells.worldMap.player_head_icon")
	app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeLuckyDraw")
	app.load("client.red_alert_time.cells.activity.wonderful.red_alert_time_active_up_cell")
    app.load("client.red_alert_time.activity.wonderful.RedAlertTimeBoxPreview")

    app.load("client.red_alert_time.activity.wonderful.RedAlertTimeRedEnvelopesRob")
    app.load("client.red_alert_time.campaign.RebelHaunt")
    app.load("client.red_alert_time.game_announcement.GameAnnouncement")

    app.load("client.red_alert_time.utils.RechargeTipWindow")
    app.load("client.red_alert_time.utils.HelpWindow")
    app.load("client.red_alert_time.utils.TopNotificationTimer")
    app.load("client.red_alert_time.utils.PlayerAvatarInfo")

    app.load("client.red_alert_time.armor.Armor")
    app.load("client.red_alert_time.armor.ArmorProduction")

    app.load("client.red_alert_time.world.WorldBattleEventInfo")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeSevenDayActivity")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeRuleInfor")

    app.load("client.battle.fight.FightEnum")

    self.__cdt = 1
    self._reconnect = 30 -- socket 重新连接

    self._get_resource_time = 120 -- 资源收益时间间隔
    self._get_booming_time = 300 -- 繁荣度恢复时间

    self.platform_tx_pay_time = os.time()
    -- 能量回复倒计时
    self._need_time = 0
    self._last_time = nil
    --体力恢复所需时间
    self._text_time = nil

    -- 任务完成状态,0：未完成，1：进行中，2：已完成
    self._task_state = 0         
    self._task_build_id = 0         -- 升级建筑对应id
    self._task_text_pos_x = 0
    self._task_text_pos_y = 0

    self._task_text_time = nil      -- 倒计时文本
    self._task_text_ing = nil
    self._task_image_state = nil
    self._Panel_home_task_box = nil
    self._task_leave_time = nil       -- 紧急任务结束时间

    self._Panel_home_urgent_task_box = nil

    self._isButtonFunShow = true

    self.pushid = 0

    self._is_play_effect = true

    _ED.have_buy_build_pos_count = false

    self._base_client_time = os.time()

    self._home_patrol_tick_time = nil
    self._Image_new = nil

    self._push_legion_total_time = nil
    self._push_legion_time = 0

    -- self._city_shop_text_time = nil
    -- self._city_shop_end_time = 0

    self._keep_alive_time = 0
    
    local function init_main_window_terminal()
        --显示主界面所有
        local main_window_show_terminal = {
            _name = "main_window_show",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onShow()
                state_machine.excute("main_window_update_userinfo", 0, nil)
                state_machine.excute("home_map_update_build", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏主界面所有
        local main_window_hide_terminal = {
            _name = "main_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新玩家信息
        local main_window_update_userinfo_terminal = {
            _name = "main_window_update_userinfo",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:updateDraw()
                checkEffectLevelUp()
                state_machine.excute("red_alert_time_mine_update_city_user_info", 0, nil)
                state_machine.excute("base_reserve_update_draw_page", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 生产快速入口
        local main_window_open_tank_factory_terminal = {
            _name = "main_window_open_tank_factory",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local choose_build_id = 9
                local state_info = {4, 4, 4}        -- 可生产状态：1：没有生产，2：正常生产有等待队列，3：生产队列已满，4：未开启
                local production_count_max = dms.int(dms["base_consume"], 78, tonumber(_ED.vip_grade) + 4)
                if _ED.production_info ~= nil then
                    for i=1, 3 do
                        local base_info = _ED.base_build_info[""..(i + 8)]

                        if funOpenDrawTip(base_info.fun_open_tab_id, false) == false
                            and _ED.home_build[""..(i + 8)] ~= nil 
                            and _ED.home_build[""..(i + 8)].level > 0
                            then
                            local production_count = 0

                            if _ED.production_info[""..(i - 1)] == nil then
                                state_info[i] = 1
                            else
                                if table.nums(_ED.production_info[""..(i - 1)]) < production_count_max then
                                    state_info[i] = 2
                                else
                                    state_info[i] = 3
                                end
                            end
                        end
                    end
                end
                local choose_index = 1
                for i = 1, 3 do
                    if state_info[i] ~= 4 and i ~= choose_index then
                        if state_info[i] < state_info[choose_index] then
                            choose_index = i
                        elseif state_info[i] == state_info[choose_index] then
                            if tonumber(_ED.home_build[""..(8 + i)].level) > tonumber(_ED.home_build[""..(8 + choose_index)].level) then
                                choose_index = i
                            end
                        end
                    end
                end 
                choose_build_id = 8 + choose_index
                local base_build_info = _ED.base_build_info[""..choose_build_id]
                if choose_build_id == 9 or choose_build_id == 10 then
                    state_machine.excute("build_up_tank_factory_window_open", 0, {choose_build_id, base_build_info, 2})
                elseif choose_build_id == 11 then
                    state_machine.excute("build_up_reform_factory_window_open", 0, {choose_build_id, base_build_info, 2})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 科技快速入口
        local main_window_open_scientific_terminal = {
            _name = "main_window_open_scientific",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if _ED.home_build["3"] ~= nil then
                    local choose_build_id = 3
                    local base_build_info = _ED.base_build_info[""..choose_build_id]
                    state_machine.excute("build_up_scientific_window_open",0,{choose_build_id, base_build_info, 2})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 制造快速入口
        local main_window_open_manufacture_terminal = {
            _name = "main_window_manufacture_make",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if _ED.home_build["8"] ~= nil then
                    local choose_build_id = 8
                    local base_build_info = _ED.base_build_info[""..choose_build_id]
                    state_machine.excute("build_up_make_factory_window_open",0,{choose_build_id, base_build_info, 2})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新快速入口信息
        local main_window_update_quick_info_terminal = {
            _name = "main_window_update_quick_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:updateQuickInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local main_window_buy_build_upgrade_pos_terminal = {
            _name = "main_window_buy_build_upgrade_pos",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local maxPos = dms.int(dms["base_consume"], 75, tonumber(_ED.vip_grade) + 4)
                local reset_consume = 0
                for k,v in pairs(dms.element(dms["base_consume"], 75)) do
                    if k >= 4 then
                        if tonumber(v) == _ED.home_build_max_count + 1 then
                            reset_consume = k - 4
                            break
                        end
                    end
                end
                local cost = 0
                local count = _ED.home_build_max_count - 2
                if _ED.home_build_max_count < maxPos then
                    local params = zstring.split(dms.string(dms["major_city_config"], 13, major_city_config.param), ",")
                    if #params <= count+1 then
                        cost = params[#params]
                    else
                        cost = params[count+1]
                    end
                    local tip = ConfirmTip:new()
                    tip:init(instance, instance.sureBuyBuild, string.format(red_alert_all_str[291], cost))
                    fwin:open(tip, fwin._windows) 
                else
                    TipDlg.drawTextDailog(string.format(red_alert_all_str[290], reset_consume))
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local main_window_update_factor_terminal = {
            _name = "main_window_update_factor",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:updateFactor()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local main_window_open_recharge_terminal = {
            _name = "main_window_open_recharge",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("recharge_dialog_window_open", 0, nil)
                if params._datas.choose_type == 2 then
                    if __lua_project_id == __lua_project_pacific_rim then
                        state_machine.excute("recharge_dialog_window_change_show_vip", 0, {_datas = {is_show = true}})
                    else
                        state_machine.excute("show_vip_privilege_red_alert_time", 0, nil)
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local main_window_update_resource_terminal = {
            _name = "main_window_update_resource",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateResource()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local main_window_update_task_info_terminal = {
            _name = "main_window_update_task_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateTaskInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local main_window_click_task_terminal = {
            _name = "main_window_click_task",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params._datas.isUrgent == true then
                    local urgentTask = getUrgentTask()
                    if instance._task_urgent_state == 2 then
                        if urgentTask ~= nil then
                            local task_id = urgentTask.task_id
                            local task_mould_id = urgentTask.task_mould_id
                            _ED.last_user_level = _ED.user_info.user_grade
                            _ED.last_prestige_level = _ED.user_info.credit_level
                            local function responseCallback(response)
                                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                    -- state_machine.excute("task_main_line_list_update_listview",0,"")
                                    state_machine.excute("main_window_update_userinfo", 0, nil)
                                    state_machine.excute("home_map_update_build", 0, nil)
                                    -- 校验开启教学事件
                                    state_machine.excute("main_window_check_mission", 0, 0)
                                end
                            end
                            protocol_command.get_task_reward.param_list = task_id .. "\r\n" .. task_mould_id
                            NetworkManager:register(protocol_command.get_task_reward.code, nil, nil, nil, nil, responseCallback, false, nil)
                        end
                    else
                        local achievement_mould_id = urgentTask.achieve_mould_id
                        local achievement_short_id = dms.int(dms["achievement_mould"], achievement_mould_id, achievement_mould.achievement_short_id)
                        local achievement_reward = zstring.split(dms.string(dms["achievement_mould"], achievement_mould_id, achievement_mould.achievement_reward), "|")
                        state_machine.excute("task_detail_open", 0, {urgentTask, achievement_reward})
                    end
                else
                    if instance._task_state == 2 then
                        if _ED.user_frist_task ~= nil then
                            local task_data = _ED.user_frist_task
                            local task_id = task_data.task_id
                            local task_mould_id = task_data.task_mould_id
                            _ED.last_user_level = _ED.user_info.user_grade
                            _ED.last_prestige_level = _ED.user_info.credit_level
                            local function responseCallback(response)
                                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                    -- state_machine.excute("task_main_line_list_update_listview",0,"")
                                    state_machine.excute("main_window_update_userinfo", 0, nil)
                                    state_machine.excute("home_map_update_build", 0, nil)
                                    -- 校验开启教学事件
                                    state_machine.excute("main_window_check_mission", 0, 0)
                                end
                            end
                            protocol_command.get_task_reward.param_list = task_id .. "\r\n" .. task_mould_id
                            NetworkManager:register(protocol_command.get_task_reward.code, nil, nil, nil, nil, responseCallback, false, nil)
                        end
                    else
                        local task_type = dms.int(dms["task_mould"],_ED.user_frist_task.task_mould_id,task_mould.task_type)
                        local achievement_mould_id = _ED.user_frist_task.achieve_mould_id
                        local achievement_short_id = dms.int(dms["achievement_mould"], achievement_mould_id, achievement_mould.achievement_short_id)
                        if task_type == 5 then
                            local achievement_reward = zstring.split(dms.string(dms["achievement_mould"], achievement_mould_id, achievement_mould.achievement_reward), "|")
                            state_machine.excute("task_detail_open", 0, {_ED.user_frist_task,achievement_reward})
                        else
                            state_machine.excute("short_cut_go_to_other_window",0,{achievement_short_id})
                        end
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local main_window_update_top_button_terminal = {
            _name = "main_window_update_top_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateTopButton()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 活动快速入口
        local main_window_activity_open_terminal = {
            _name = "main_window_activity_open",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				state_machine.excute("wonderful_window_open",0,nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 启动事件
        local main_window_check_mission_terminal = {
            _name = "main_window_check_mission",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:checkMission()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 删除活动列表的button
        local main_window_remove_list_button_terminal = {
            _name = "main_window_remove_list_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:updateRemoveListViewCell(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local main_window_change_button_fun_state_terminal = {
            _name = "main_window_change_button_fun_state",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                -- instance:changeButtonFunState(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local main_window_update_fighting_terminal = {
            _name = "main_window_update_fighting",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:updateFighting()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local main_window_update_gold_info_terminal = {
            _name = "main_window_update_gold_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateGoldInfo()
                checkEffectLevelUp()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local main_window_visible_func_button_terminal = {
            _name = "main_window_visible_func_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:visibleFuncButton(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local main_window_open_rebels_window_terminal = {
            _name = "main_window_open_rebels_window",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if funOpenDrawTip(210) == true then
                    return
                end 
                if funOpenDrawTip(155) == true then
                    return
                end 
                state_machine.excute("rebel_haunt_open", 0, {})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local main_window_update_rebels_window_terminal = {
            _name = "main_window_update_rebels_window",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:updateRebelsButton()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --活动推送
        local main_window_push_activity_terminal = {
            _name = "main_window_push_activity",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("main_window_push_activity_timekeeping",0,0)
                state_machine.excute("push_notification_mine_activity_push", 0, {
                    _isCountPush = true,
                    _widget = ccui.Helper:seekWidgetByName(instance.roots[1], "Button_activity"),
                    _invoke = nil,
                })
                state_machine.excute("red_alert_time_wonderful_update_push", 0, 59)         -- 领取能量推送
                state_machine.excute("red_alert_time_wonderful_update_push", 0, 47)         -- 在线奖励推送
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:updateActivityPushInfo()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --活动计时器
        local main_window_push_activity_timekeeping_terminal = {
            _name = "main_window_push_activity_timekeeping",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if _ED.activity_info== nil then 
                    return true
                end    
                function performWithDelay(node, callback, delay)
                    local delay = cc.DelayTime:create(delay)
                    local sequence = cc.Sequence:create(delay, cc.CallFunc:create(callback))
                    node:runAction(sequence)
                    return sequence
                end
                
                local current = _ED.system_time + (os.time() - _ED.native_time)
                --判断凌晨的差距时间
                local earlyMorning = 23*3600+59*60+59
                --判断中午12点的差距时间
                local noon = 12*3600
                local noonEnd = 14*3600            -- 领取能量结束时间
                local temp = getCurrentGTM8Time()
                local m_hour    = tonumber(string.format("%02d", temp.hour))
                local m_min     = tonumber(string.format("%02d", temp.min))
                local m_sec     = tonumber(string.format("%02d", temp.sec))

                earlyMorning = earlyMorning - (m_hour*3600+m_min*60+m_sec)

                local current_time = m_hour*3600+m_min*60+m_sec
                local isTurnPoint = false
                if current_time < noon then
                    current = noon - current_time
                elseif current_time < noonEnd then
                    current = noonEnd - current_time
                else
                    current = earlyMorning + 2
                    isTurnPoint = true
                end
                function pushTimeActivity()
                    state_machine.excute("main_window_push_activity",0,0)
                    -- if isTurnPoint == true and _ED.user_info.user_id ~= nil and _ED.user_info.user_id ~= "" then
                    --     NetworkManager:register(protocol_command.keep_alive.code, nil, nil, nil, nil, nil, false, nil)
                    -- end
                end
                local a_time = 0
                if _ED.activity_info["47"] ~= nil then
                    local datas = zstring.split(_ED.activity_info["47"].activity_add_state,",")
                    local m_time = (tonumber(datas[3])/1000)+(os.time()-_ED.activity_info["47"].start_time)
                    if _ED.activity_info["47"].activity_data[1]~= nil then
                        for j, w in pairs(_ED.activity_info["47"].activity_data[1]) do
                            local m_datas = zstring.split(w.achieve_complete_count, "/")
                            a_time = tonumber(m_datas[2]) * 60 - m_time
                            if (math.floor(m_time/60) < tonumber(m_datas[2]) and tonumber(w.achieve_state) <= 1) and current > a_time then
                                performWithDelay(ccui.Helper:seekWidgetByName(instance.roots[1], "Button_activity"),pushTimeActivity,tonumber(a_time))
                                return true
                            end
                        end
                    end     
                end
                performWithDelay(ccui.Helper:seekWidgetByName(instance.roots[1], "Button_activity"),pushTimeActivity,tonumber(current))     
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


        --宝藏推送
        local main_window_push_treasure_terminal = {
            _name = "main_window_push_treasure",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("main_window_push_treasure_timekeeping",0,0)
                state_machine.excute("treasure_carnival_hour_push_update", 0, "")
                state_machine.excute("push_notification_mine_treasure_push", 0, {
                _isCountPush = true,
                _widget = ccui.Helper:seekWidgetByName(instance.roots[1], "Button_treasure_house"),
                 _invoke = nil,
                })
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --宝藏计时器
        local main_window_push_treasure_timekeeping_terminal = {
            _name = "main_window_push_treasure_timekeeping",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if _ED.activity_info== nil then 
                    return true 
                end  
                function performWithDelay(node, callback, delay)
                    local delay = cc.DelayTime:create(delay)
                    local sequence = cc.Sequence:create(delay, cc.CallFunc:create(callback))
                    node:runAction(sequence)
                    return sequence
                end
                function pushTimeActivity()
                    state_machine.excute("main_window_push_treasure",0,0)
                end
                local current = _ED.system_time + (os.time() - _ED.native_time)
                --判断凌晨的差距时间
                local earlyMorning = 23*3600+59*60+59
                --判断中午12点的差距时间
                local noon = 12*3600
                local temp = getCurrentGTM8Time()
                local m_hour    = tonumber(string.format("%02d", temp.hour))
                local m_min     = tonumber(string.format("%02d", temp.min))
                local m_sec     = tonumber(string.format("%02d", temp.sec))

                earlyMorning = earlyMorning - (m_hour*3600+m_min*60+m_sec)

                performWithDelay(ccui.Helper:seekWidgetByName(instance.roots[1], "Button_treasure_house"),pushTimeActivity,tonumber(earlyMorning))     
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --红包走马灯
        local red_envelopes_play_terminal = {
            _name = "red_envelopes_play",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function playerInfoOver( sender )
                    _ED.redEnvelopesIsPlaying = false
                    redEnvelopesPlay()
                end
                instance:runAction( cc.Sequence:create(cc.DelayTime:create(0.5),cc.CallFunc:create(playerInfoOver)))  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_horn_play_terminal = {
            _name = "red_horn_play",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function playerInfoOver( sender )
                    _ED.hornIsPlaying = false
                    redHornPlay()
                end
                instance:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.CallFunc:create(playerInfoOver)))  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 公告状态刷新
        local main_window_push_game_announcement_terminal = {
            _name = "main_window_push_game_announcement",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:pushGameAnnouncement()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 更新能量值
        local main_window_update_energy_terminal = {
            _name = "main_window_update_energy",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if tonumber(_ED.user_info.max_user_food) - tonumber(_ED.user_info.user_food) > 0 
                    and zstring.tonumber(_ED._next_energy_recover_time)/1000 < os.time() 
                    then
                    local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil then
                                response.node:updateEnergy()
                            end
                        end
                    end     
                    protocol_command.check_food_recover.param_list = ""
                    NetworkManager:register(protocol_command.check_food_recover.code, nil, nil, nil, instance, responseCallback, false, nil) 
                else
                    instance:updateEnergy()
                end
                 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local main_window_update_boom_info_terminal = {
            _name = "main_window_update_boom_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateBoomInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local main_window_update_head_info_terminal = {
            _name = "main_window_update_head_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updatePlayerHeadInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        local main_window_update_push_terminal = {
            _name = "main_window_update_push",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local ListView_active_icon = ccui.Helper:seekWidgetByName(instance.roots[1],"ListView_active_icon")
                local items = ListView_active_icon:getItems()
                for i,cell in pairs(items) do
                    if tonumber(cell._activity_type) == tonumber(params) then
                        state_machine.excute("red_alert_time_active_up_cell_update_push", 0, cell)
                        break
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local main_window_update_timer_terminal = {
            _name = "main_window_update_timer",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] then
                    instance:onUpdateTimer(params)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --折扣卖场推送刷新
        local treasure_discount_store_push_update_terminal = {
            _name = "treasure_discount_store_push_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if _ED.activity_info == nil or _ED.activity_info["103"] == nil then 
                    return true 
                end
                local function discountStorePushUpdate()
                    state_machine.excute("push_notification_mine_treasure_push", 0, {
                    _isCountPush = true,
                    _widget = ccui.Helper:seekWidgetByName(instance.roots[1], "Button_treasure_house"),
                     _invoke = nil,
                    })
                    state_machine.excute("red_alert_time_center_update_push", 0, 103)
                    state_machine.excute("notification_center_update", 0, "push_notification_discount_store_page_push")
                end
                for i = 1 , 3 do 
                    if discountStorePagePush(i) == false then
                        local DelayTime = zstring.tonumber(cc.UserDefault:getInstance():getStringForKey(getKey("activity_id_".._ED.activity_info["103"].activity_type.."_"..i))) - os.time()
                        instance:runAction(cc.Sequence:create(cc.DelayTime:create(DelayTime), cc.CallFunc:create(discountStorePushUpdate)))
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --狂欢时刻推送刷新
        local treasure_carnival_hour_push_update_terminal = {
            _name = "treasure_carnival_hour_push_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if _ED.activity_info == nil or _ED.activity_info["130"] == nil then 
                    return true 
                end
                local function carnivalHourPushUpdate()
                    state_machine.excute("main_window_push_treasure", 0, "")
                    state_machine.excute("red_alert_time_center_update_push", 0, 130)
                    state_machine.excute("notification_center_update", 0, "push_notification_canival_hour")
                end

                local DelayTime = -1
                local activity_info = _ED.activity_info["130"]
                local activity_add_state_arr = zstring.split(activity_info.activity_add_state,"|")
                local activity_add_state = zstring.split(activity_add_state_arr[1], ",")
                local time_info = zstring.split(activity_add_state_arr[6], ",")
                -- 在线奖励
                local online_delay_time = -1
                local activity_data = activity_info.activity_data[1]

                local data = nil
                for k, v in pairs(activity_data) do
                    if v.achieve_other_info == "-1" and tonumber(v.achieve_state) ~= 2 then
                        data = v
                        break
                    end
                end

                if data ~= nil then
                    local complete_count = zstring.split(data.achieve_complete_count, "/")
                    local need_time = tonumber(complete_count[2]) * 60
                    local have_time = tonumber(activity_add_state[6]) / 1000
                    have_time = have_time + (os.time() + _ED.time_add_or_sub -tonumber(activity_add_state[5]) / 1000)
                    if have_time < need_time then
                        online_delay_time = need_time - have_time
                    else
                        if tonumber(data.achieve_state) == 0 then
                            data.achieve_state = 1
                            online_delay_time = 0
                        end
                    end
                end

                -- 折扣卖场
                local DelayTime = -1
                if online_delay_time >= 0 then
                    DelayTime = online_delay_time
                end

                local shop_delay_time = zstring.tonumber(cc.UserDefault:getInstance():getStringForKey(getKey("activity_id_"..activity_info.activity_type)))
                if shop_delay_time > 0 then
                    if DelayTime < 0 or shop_delay_time - os.time() < DelayTime then
                        DelayTime = shop_delay_time - os.time()
                    end
                end

                if DelayTime >= 0 then
                    instance:runAction(cc.Sequence:create(cc.DelayTime:create(DelayTime), cc.CallFunc:create(carnivalHourPushUpdate)))
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 购买城市能量
        local main_window_buy_city_energy_terminal = {
            _name = "main_window_buy_city_energy",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if funOpenDrawTip(244) == true then
                    return
                end 
                if _ED.mould_function_push_info["14"] == nil 
                    or tonumber(_ED.mould_function_push_info["14"].state) ~= 2
                    then
                    TipDlg.drawTextDailog(world_city_tip_str[33])
                    return
                end
                if _ED.union.union_info == nil 
                    or _ED.union.union_info == {} 
                    or _ED.union.union_info.union_id == nil 
                    or _ED.union.union_info.union_id == "" 
                    or tonumber(_ED.union.union_info.union_id) == 0 then
                    TipDlg.drawTextDailog(red_alert_time_str[158])
                    return
                end
                local cost_info = zstring.split(dms.string(dms["world_city_config"], 18, world_city_config.param), "|")
                local current_count = _ED.world_city_info.my_info.buy_energy_times
                local info = ""
                if cost_info[current_count + 1] == nil then
                    info = cost_info[#cost_info]
                else
                    info = cost_info[current_count + 1]
                end
                info = zstring.split(info, ",")
                local energy = tonumber(info[1])
                local cost = tonumber(info[2])
                state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = {_cost = cost, _energy = energy}, m_type = 30}})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新城市能量
        local main_window_update_city_energy_info_terminal = {
            _name = "main_window_update_city_energy_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateCityEnergy()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 购买城市能量
        local main_window_sure_buy_city_energy_terminal = {
            _name = "main_window_sure_buy_city_energy",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:updateCityEnergy()
                        end
                        TipDlg.drawTextDailog(world_city_tip_str[34])
                        state_machine.excute("red_alert_time_mine_update_city_energy_info", 0, "")
                    end
                end
                protocol_command.world_city_energy_buy.param_list = ""
                NetworkManager:register(protocol_command.world_city_energy_buy.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 城市战
        local main_window_goto_world_city_terminal = {
            _name = "main_window_goto_world_city",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if _ED.union.union_info == nil 
                    or _ED.union.union_info == {} 
                    or _ED.union.union_info.union_id == nil 
                    or _ED.union.union_info.union_id == "" 
                    or tonumber(_ED.union.union_info.union_id) == 0 then
                    state_machine.excute("legion_city_image_infor_window_open", 0, "")
                else
                    state_machine.excute("legion_city_open", 0, {_datas = {_page = 2, show_help = true}})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新出征状态
        local main_window_update_formation_count_terminal = {
            _name = "main_window_update_formation_count",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:updateFormationCount()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
    
        state_machine.add(red_envelopes_play_terminal)
        state_machine.add(red_horn_play_terminal)
        state_machine.add(main_window_show_terminal)
        state_machine.add(main_window_hide_terminal)         
        state_machine.add(main_window_update_userinfo_terminal)
        state_machine.add(main_window_open_tank_factory_terminal)
        state_machine.add(main_window_open_scientific_terminal)
        state_machine.add(main_window_open_manufacture_terminal)
        state_machine.add(main_window_update_quick_info_terminal)
        state_machine.add(main_window_buy_build_upgrade_pos_terminal)
        state_machine.add(main_window_update_factor_terminal)
        state_machine.add(main_window_open_recharge_terminal)
        state_machine.add(main_window_update_resource_terminal)
        state_machine.add(main_window_update_task_info_terminal)
        state_machine.add(main_window_click_task_terminal)
        state_machine.add(main_window_update_top_button_terminal)
        state_machine.add(main_window_activity_open_terminal)
        state_machine.add(main_window_check_mission_terminal)
        state_machine.add(main_window_remove_list_button_terminal)
        state_machine.add(main_window_change_button_fun_state_terminal)
        state_machine.add(main_window_update_fighting_terminal)
        state_machine.add(main_window_update_gold_info_terminal)
        state_machine.add(main_window_visible_func_button_terminal)
        state_machine.add(main_window_push_activity_terminal)
        state_machine.add(main_window_push_activity_timekeeping_terminal)
        state_machine.add(main_window_push_treasure_terminal)
        state_machine.add(main_window_push_treasure_timekeeping_terminal)
        state_machine.add(main_window_open_rebels_window_terminal)
        state_machine.add(main_window_update_rebels_window_terminal)
        state_machine.add(main_window_push_game_announcement_terminal)
        state_machine.add(main_window_update_energy_terminal)
        state_machine.add(main_window_update_boom_info_terminal)
        state_machine.add(main_window_update_head_info_terminal)
        state_machine.add(main_window_update_push_terminal)
        state_machine.add(main_window_update_timer_terminal)
        state_machine.add(treasure_discount_store_push_update_terminal)
        state_machine.add(main_window_buy_city_energy_terminal)
        state_machine.add(main_window_update_city_energy_info_terminal)
        state_machine.add(main_window_sure_buy_city_energy_terminal)
        state_machine.add(main_window_goto_world_city_terminal)
        state_machine.add(treasure_carnival_hour_push_update_terminal)
        state_machine.add(main_window_update_formation_count_terminal)

        state_machine.init()
    end
    
    init_main_window_terminal()
end

function MainWindow:onShow()
    fwin:__show(fwin._frameview)
    state_machine.excute("home_map_play_openness_effect",0,{true})
    self:resume()
    self._is_pause = false

    -- self._HomeMapWindow = fwin:find("HomeMapClass")
    -- if nil ~= self._HomeMapWindow and self._HomeMapWindow._is_pause ~= false then
    --     self._HomeMapWindow:onResume()
    --     self._HomeMapWindow._is_pause = false
    -- end
end

function MainWindow:onHide()
    fwin:__hide(fwin._frameview)
    state_machine.excute("home_map_play_openness_effect",0,{false})
    self:pause()
    self._is_pause = true

    -- self._HomeMapWindow = fwin:find("HomeMapClass")
    -- if nil ~= self._HomeMapWindow and self._HomeMapWindow._is_pause ~= true then
    --     self._HomeMapWindow:onPause()
    --     self._HomeMapWindow._is_pause = true
    -- end
end

function MainWindow:updateFormationCount()
    local root = self.roots[1]
    -- 出征数量
    local Text_world_battle_n = ccui.Helper:seekWidgetByName(root,"Text_world_battle_n")
    if Text_world_battle_n ~= nil then
        local max_count = dms.int(dms["base_consume"], 81, base_consume.vip_0_value + tonumber(_ED.vip_grade))
        local current_count = 0
        if _ED.world_map ~= nil and _ED.world_map.target_event_info ~= nil then
            for i, v in pairs(_ED.world_map.target_event_info) do
                if (tonumber(v._event_type) < 10 or tonumber(v._event_type) >= 18) then
                    current_count = current_count + 1
                end
            end
        end
        Text_world_battle_n:setString(""..current_count.."/"..max_count)
    end
end

function MainWindow:updateCityEnergy()
    -- local root = self.roots[1]
    -- local Panel_legion_city_energe = ccui.Helper:seekWidgetByName(root,"Panel_legion_city_energe") 
    -- -- local Text_legion_city_energe_n = ccui.Helper:seekWidgetByName(root,"Text_legion_city_energe_n")
    -- local Text_legion_city_shop_time_n = ccui.Helper:seekWidgetByName(root,"Text_legion_city_shop_time_n")
    -- local Image_2_0 = ccui.Helper:seekWidgetByName(root,"Image_2_0")

    -- self._city_shop_text_time = nil
    -- if Panel_legion_city_energe ~= nil then
    --     local shop_state = 0
    --     local push_info = _ED.mould_function_push_info["15"]
    --     if push_info ~= nil then
    --         shop_state = tonumber(push_info.state)
    --         self._city_shop_end_time = tonumber(push_info.params) / 1000 + push_info.start_time
    --     end

    --     if shop_state == 0 then
    --         Panel_legion_city_energe:setVisible(false)
    --     else
    --         Panel_legion_city_energe:setVisible(true)
    --         if shop_state == 1 then
    --             Text_legion_city_shop_time_n:setString(tipStringInfo_campaign_info[26])
    --         else
    --             local leave_time = self._city_shop_end_time - (os.time() + _ED.time_add_or_sub)
    --             Text_legion_city_shop_time_n:setString(getRedAlertTimeFormat(leave_time))
    --             self._city_shop_text_time = Text_legion_city_shop_time_n
    --         end
    --     end

    --     -- local open_state = 0
    --     -- if _ED.mould_function_push_info["14"] ~= nil then
    --     --     open_state = tonumber(_ED.mould_function_push_info["14"].state)
    --     -- end

    --     -- if open_state == 2 and _ED.world_city_info ~= nil and _ED.world_city_info.my_info ~= nil then
    --     --     Panel_legion_city_energe:setVisible(true)
    --     --     Text_legion_city_energe_n:setString("".._ED.world_city_info.my_info.energy)
    --     -- end
    -- end
end

function MainWindow:updateEnergy()
    local root = self.roots[1]
    -- 能量值
    local Text_energy_n = ccui.Helper:seekWidgetByName(root,"Text_energy_n")   
    self._text_time = Text_energy_n        
    local LoadingBar_energy = ccui.Helper:seekWidgetByName(root,"LoadingBar_energy")    -- 能量条
    local times = zstring.tonumber(_ED._next_energy_recover_time)/1000 - (_ED.system_time + os.time() - _ED.native_time)
    if times > 0 
        and tonumber(_ED.user_info.user_food) < tonumber(_ED.user_info.max_user_food) then
        self._text_time:setString(zstring.tonumber(_ED.user_info.user_food) .. "/" .. _ED.user_info.max_user_food.."("..exChangeTimeToString(times)..")")
    else
        self._text_time:setString(zstring.tonumber(_ED.user_info.user_food) .. "/" .. _ED.user_info.max_user_food)
    end
    local persent_energy = zstring.tonumber(_ED.user_info.user_food) / zstring.tonumber(_ED.user_info.max_user_food) *100
    LoadingBar_energy:setPercent(persent_energy)
end

function MainWindow:updateRebelsButton()
    local root = self.roots[1]
    local Button_rebel_haunt = ccui.Helper:seekWidgetByName(root,"Button_rebel_haunt")
    Button_rebel_haunt:setVisible(false)
    if _ED.mould_function_push_info["5"] ~= nil then
        if tonumber(_ED.mould_function_push_info["5"].state) ~= 0 then
            if zstring.tonumber(_ED.user_rebel_haunt_last_state) ~= 1 then
                if self._is_play_effect == true then
                    -- checkPlayEffect(72)
                    self._is_play_effect = false
                    state_machine.excute("home_button_window_world_effect_rebel_presence", 0, "")
                end
            end
            Button_rebel_haunt:setVisible(true)
        else
            Button_rebel_haunt:setVisible(false)   
            self._is_play_effect = true  
        end
    end
end

function MainWindow:changeButtonFunState( state )
    if self._isButtonFunShow == state then
        return
    end
    self._isButtonFunShow = state
    local root = self.roots[1]
    for i=1,3 do
        local Panel_button_fun = ccui.Helper:seekWidgetByName(root, "Panel_button_fun_"..i)
        Panel_button_fun:setVisible(false)
        Panel_button_fun:stopAllActions()
        Panel_button_fun:setPosition(cc.p(0, Panel_button_fun:getPositionY()))
        if i == 1 then
            if state == true then
                Animations_PlayOpenMainUI({Panel_button_fun}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN_Ease, 0.2)
            else
                Animations_PlayOpenMainUI({Panel_button_fun}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_OUT, 0.3)
            end
        elseif i == 2 
            or i == 3
            then
            if state == true then
                Animations_PlayOpenMainUI({Panel_button_fun}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_RIGHT_IN_Ease, 0.2)
            else
                Animations_PlayOpenMainUI({Panel_button_fun}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_RIGHT_OUT, 0.3)
            end
        end
        Panel_button_fun:setVisible(true)
    end
end

--清除列表的BUTTON
function MainWindow:updateRemoveListViewCell(activity_type)
	local root = self.roots[1]
	local ListView_active_icon = ccui.Helper:seekWidgetByName(root,"ListView_active_icon")
	local items = ListView_active_icon:getItems()
	for i,v in pairs(items) do
		if tonumber(v._activity_type) == tonumber(activity_type) then
			ListView_active_icon:removeItem(i - 1)
		end
	end
	ListView_active_icon:requestRefreshView()
	local index = 4-#ListView_active_icon:getItems()
	local iemsMargin = ListView_active_icon:getItemsMargin()
    RedAlertTimeActiveUpCell.__size = RedAlertTimeActiveUpCell.__size or {width = 88, height = 100}
	ListView_active_icon:setPositionX(ListView_active_icon._x + index*(RedAlertTimeActiveUpCell.__size.width))
end

-- 刷新顶部活动按钮状态
function MainWindow:updateTopButton( ... )
    local root = self.roots[1]

	local ListView_active_icon = ccui.Helper:seekWidgetByName(root,"ListView_active_icon")
	ListView_active_icon:removeAllItems()
	ListView_active_icon:setVisible(true)
    -- 七天狂欢
    if _ED.activity_info ~= nil and _ED.activity_info["100"] ~= nil and tonumber(_ED.activity_info["100"].activity_state) ~= 2 then
        local cells = state_machine.excute("red_alert_time_active_up_create_cell",0,{100})
        ListView_active_icon:addChild(cells)
    end
    -- 军团奖励
    if tonumber(_ED.union_first_join_reward) == 0 then
        local cells = state_machine.excute("red_alert_time_active_up_create_cell",0,{1000})
        ListView_active_icon:addChild(cells)
    end
	--在线
	if _ED.activity_info~= nil and _ED.activity_info["47"] ~= nil and tonumber(_ED.activity_info["47"].activity_state) ~= 2 then
		local index = 0 
		local activity_data = _ED.activity_info["47"].activity_data[1]
		for k,v in pairs(activity_data) do
			if tonumber(v.achieve_state) == 2 then 
				index = index + 1 
			end
		end 
		if index == #activity_data then
		else
			local cells = state_machine.excute("red_alert_time_active_up_create_cell",0,{47})
			ListView_active_icon:addChild(cells)
		end
	end
    -- 军团在线奖励
    if _ED.activity_info~= nil and _ED.activity_info["128"] ~= nil and tonumber(_ED.activity_info["128"].activity_state) ~= 2 then
        local activity_add_state_arr = zstring.split(_ED.activity_info["128"].activity_add_state, "|")
        local activity_add_state = zstring.split(activity_add_state_arr[1], ",")
        local reward_count = tonumber(activity_add_state[4])
        local reward_max_count = tonumber(activity_add_state[5])
        if reward_count < reward_max_count then
            local cells = state_machine.excute("red_alert_time_active_up_create_cell",0,{128})
            ListView_active_icon:addChild(cells)
            state_machine.excute("red_alert_time_legion_online_reward_update_draw", 0, "")
        else
            state_machine.excute("red_alert_time_legion_online_reward_window_close", 0, "")
        end
    end
	--总部援军
	if _ED.activity_info~= nil and _ED.activity_info["48"] ~= nil and tonumber(_ED.activity_info["48"].activity_state) ~= 2 then
		local index = 0 
		local activity_data = _ED.activity_info["48"].activity_data[1]
		for k,v in pairs(activity_data) do
			if tonumber(v.achieve_state) == 2 then 
				index = index + 1 
			end
		end 
		if index == #activity_data then
		else
			local cells = state_machine.excute("red_alert_time_active_up_create_cell",0,{48})
			ListView_active_icon:addChild(cells)
		end
	end
	--首充
	if _ED.activity_info~= nil and _ED.activity_info["2"] ~= nil and tonumber(_ED.activity_info["2"].activity_state) ~= 2 then
		local cells = state_machine.excute("red_alert_time_active_up_create_cell",0,{2})
		ListView_active_icon:addChild(cells)
	end
	
    if #ListView_active_icon:getItems() > 0 then
    	ListView_active_icon:requestRefreshView()
    	ListView_active_icon:setTouchEnabled(false)
    	local index = 4-#ListView_active_icon:getItems()
    	local iemsMargin = ListView_active_icon:getItemsMargin()
    	ListView_active_icon:setPositionX(ListView_active_icon._x + index*(RedAlertTimeActiveUpCell.__size.width))
    end
end

function MainWindow:updateTaskInfo( ... )
    local root = self.roots[1]
    local Text_home_task_infor = ccui.Helper:seekWidgetByName(root,"Text_home_task_infor")
    local Text_home_task_ing = ccui.Helper:seekWidgetByName(root,"Text_home_task_ing")
    local Text_home_task_time = ccui.Helper:seekWidgetByName(root,"Text_home_task_time")
    local Image_task_icon = ccui.Helper:seekWidgetByName(root,"Image_task_icon")
    local Image_home_task_bg = ccui.Helper:seekWidgetByName(root,"Image_home_task_bg")
    local Image_home_task_state = ccui.Helper:seekWidgetByName(root,"Image_home_task_state")
    local Panel_home_task_box = ccui.Helper:seekWidgetByName(root,"Panel_home_task_box")
    local Panel_home_urgent_task_box = ccui.Helper:seekWidgetByName(root,"Panel_home_urgent_task_box")
    Text_home_task_infor:setString("")
    Text_home_task_ing:setString("")
    Image_home_task_bg:removeAllChildren(true)
    Panel_home_task_box:setVisible(true)
    self._task_state = 0
    self._task_build_id = 0
    self._task_leave_time = nil
    self._task_text_time = Text_home_task_time
    self._task_text_ing = Text_home_task_ing
    self._task_image_state = Image_home_task_state
    self._Panel_home_task_box = Panel_home_task_box
    self._Panel_home_urgent_task_box = Panel_home_urgent_task_box

    if self._Panel_home_urgent_task_box ~= nil then
        self:updateUrgentTask()
    end

    if _ED.user_frist_task ~= nil then
        local task_complete_count = exChangeNumToString(_ED.user_frist_task.task_complete_count)
        local need_complete_count = exChangeNumToString(_ED.user_frist_task.need_complete_count)
        local achieve_mould_id = _ED.user_frist_task.achieve_mould_id
        local achievement_name = dms.string(dms["achievement_mould"], achieve_mould_id, achievement_mould.achievement_name)
        Text_home_task_infor:setString(achievement_name)
        -- Text_home_task_ing:setString("("..task_complete_count.."/"..need_complete_count..")")

        local user_type = dms.int(dms["task_mould"],tonumber(_ED.user_frist_task.task_mould_id),task_mould.task_type)
        if user_type == 5 then  -- 紧急任务
            self._task_leave_time = _ED.user_frist_task.task_end_time - (os.time() + _ED.time_add_or_sub)
            Image_home_task_bg:loadTexture(string.format(config_res.images.ui.home.home_task_bar, 2))
        else                    
            Image_home_task_bg:loadTexture(string.format(config_res.images.ui.home.home_task_bar, 0))
        end

        if tonumber(_ED.user_frist_task.task_complete_count) >= tonumber(_ED.user_frist_task.need_complete_count) then
            self._task_state = 2
            Image_home_task_state:setVisible(false)
            Text_home_task_time:setString("")
            Text_home_task_ing:setString("("..task_complete_count.."/"..need_complete_count..")")
            Text_home_task_time:setPosition(cc.p(self._task_text_pos_x, self._task_text_pos_y))
            Text_home_task_ing:setPosition(cc.p(self._task_text_pos_x, self._task_text_pos_y))
            Image_task_icon:loadTexture(string.format(config_res.images.ui.home.home_task_icon, 2))

            local armature = ccs.Armature:create("effect_task_get")
            draw.initArmature(armature, nil, -1, 0, 1)
            armature:setPosition(cc.p(Image_home_task_bg:getContentSize().width/2, Image_home_task_bg:getContentSize().height/2))
            Image_home_task_bg:addChild(armature)

            if __lua_project_id == __lua_project_pacific_rim then
                if user_type ~= 5 then
                    Image_home_task_bg:loadTexture(string.format(config_res.images.ui.home.home_task_bar, 3))
                end
            end
            return
        else
            self._task_state = 0
            Image_home_task_state:setVisible(true)
            Image_task_icon:loadTexture(string.format(config_res.images.ui.home.home_task_icon, 1))
        end

        local build_achievement_type = {24, 25, 26, 27, 92, 93, 94, 95, 96}                 -- 建筑升级的任务完成类型
        local build_mould_info = {"1", "3", "15", "22", "9,10", "23", "24", "16,17,18,19,20,21", "13,14"}
        local achievement_type_index = 0
        for k, v in pairs(build_achievement_type) do
            if tonumber(_ED.user_frist_task.achievement_finish_type) == v then
                achievement_type_index = k
                break
            end
        end
        local build_id = 0      -- 等级最高的建筑id
        local max_level = 0
        if achievement_type_index > 0 then
            Text_home_task_ing:setString("("..task_complete_count.."/"..need_complete_count..")")
            build_ids = zstring.split(build_mould_info[achievement_type_index], ",")
            if tonumber(build_ids[1]) == 22 or tonumber(build_ids[1]) == 23 or tonumber(build_ids[1]) == 24 then
                for k, build_info in pairs(_ED.home_build) do
                    if tonumber(build_ids[1]) == tonumber(build_info.build_mould_id) then
                        if max_level == 0 or tonumber(build_info.level) > max_level then
                            build_id = tonumber(build_info.base_mould_id)
                            max_level = tonumber(build_info.level)
                        end
                    end
                end
            else
                for k, v in pairs(build_ids) do
                    if _ED.home_build[""..v] ~= nil then
                        if max_level == 0 or tonumber(_ED.home_build[""..v].level) > max_level then
                            build_id = tonumber(v)
                            max_level = tonumber(_ED.home_build[""..v].level)
                        end
                    end
                end
            end
        end

        self._task_build_id = build_id
    else
        Panel_home_task_box:setVisible(false)
    end
end

function MainWindow:updateUrgentTask( ... )
    local root = self.roots[1]
    local Text_home_task_infor = ccui.Helper:seekWidgetByName(root,"Text_home_urgent_task_infor")
    local Text_home_task_ing = ccui.Helper:seekWidgetByName(root,"Text_home_urgent_task_ing")
    local Text_home_task_time = ccui.Helper:seekWidgetByName(root,"Text_home_urgent_task_time")
    local Image_task_icon = ccui.Helper:seekWidgetByName(root,"Image_urgent_task_icon")
    local Image_home_task_bg = ccui.Helper:seekWidgetByName(root,"Image_home_urgent_task_bg")
    local Image_home_task_state = ccui.Helper:seekWidgetByName(root,"Image_home_urgent_task_state")
    Text_home_task_infor:setString("")
    Text_home_task_ing:setString("")
    Image_home_task_bg:removeAllChildren(true)
    self._task_urgent_state = 0
    self._task_urgent_build_id = 0
    self._task_urgent_leave_time = nil
    self._task_urgent_text_time = Text_home_task_time
    self._task_urgent_text_ing = Text_home_task_ing
    self._task_urgent_image_state = Image_home_task_state

    local urgentTask = getUrgentTask()
    if urgentTask ~= nil then
        self._Panel_home_urgent_task_box:setVisible(true)
        local task_complete_count = exChangeNumToString(urgentTask.task_complete_count)
        local need_complete_count = exChangeNumToString(urgentTask.need_complete_count)
        local achieve_mould_id = urgentTask.achieve_mould_id
        local achievement_name = dms.string(dms["achievement_mould"], achieve_mould_id, achievement_mould.achievement_name)
        Text_home_task_infor:setString(achievement_name)

        self._task_urgent_leave_time = urgentTask.task_end_time - (os.time() + _ED.time_add_or_sub)
        Image_home_task_bg:loadTexture(string.format(config_res.images.ui.home.home_task_bar, 2))

        if tonumber(urgentTask.task_complete_count) >= tonumber(urgentTask.need_complete_count) then
            self._task_urgent_state = 2
            Image_home_task_state:setVisible(false)
            Text_home_task_time:setString("")
            Text_home_task_ing:setString("("..task_complete_count.."/"..need_complete_count..")")
            Image_task_icon:loadTexture(string.format(config_res.images.ui.home.home_task_icon, 2))
            Text_home_task_time:setPosition(cc.p(self._task_urgent_text_pos_x, self._task_urgent_text_pos_y))
            Text_home_task_ing:setPosition(cc.p(self._task_urgent_text_pos_x, self._task_urgent_text_pos_y))

            local armature = ccs.Armature:create("effect_task_get")
            draw.initArmature(armature, nil, -1, 0, 1)
            armature:setPosition(cc.p(Image_home_task_bg:getContentSize().width/2, Image_home_task_bg:getContentSize().height/2))
            Image_home_task_bg:addChild(armature)

            Image_home_task_bg:loadTexture(string.format(config_res.images.ui.home.home_task_bar, 3))
            return
        else
            self._task_urgent_state = 0
            Image_home_task_state:setVisible(true)
            Image_task_icon:loadTexture(string.format(config_res.images.ui.home.home_task_icon, 1))
        end

        local build_achievement_type = {24, 25, 26, 27, 92, 93, 94, 95, 96}                 -- 建筑升级的任务完成类型
        local build_mould_info = {"1", "3", "15", "22", "9,10", "23", "24", "16,17,18,19,20,21", "13,14"}
        local achievement_type_index = 0
        for k, v in pairs(build_achievement_type) do
            if tonumber(urgentTask.achievement_finish_type) == v then
                achievement_type_index = k
                break
            end
        end
        local build_id = 0      -- 等级最高的建筑id
        local max_level = 0
        if achievement_type_index > 0 then
            Text_home_task_ing:setString("("..task_complete_count.."/"..need_complete_count..")")
            build_ids = zstring.split(build_mould_info[achievement_type_index], ",")
            if tonumber(build_ids[1]) == 22 or tonumber(build_ids[1]) == 23 or tonumber(build_ids[1]) == 24 then
                for k, build_info in pairs(_ED.home_build) do
                    if tonumber(build_ids[1]) == tonumber(build_info.build_mould_id) then
                        if max_level == 0 or tonumber(build_info.level) > max_level then
                            build_id = tonumber(build_info.base_mould_id)
                            max_level = tonumber(build_info.level)
                        end
                    end
                end
            else
                for k, v in pairs(build_ids) do
                    if _ED.home_build[""..v] ~= nil then
                        if max_level == 0 or tonumber(_ED.home_build[""..v].level) > max_level then
                            build_id = tonumber(v)
                            max_level = tonumber(_ED.home_build[""..v].level)
                        end
                    end
                end
            end
        end
        self._task_urgent_build_id = build_id
    else
        self._Panel_home_urgent_task_box:setVisible(false)
    end
end

function MainWindow:sureBuyBuild(sure_number)
    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            TipDlg.drawTextDailog(red_alert_all_str[292])
            state_machine.excute("main_window_update_quick_info",0,nil)
        end
    end
    if sure_number == 0 then
        NetworkManager:register(protocol_command.buy_build_queue.code, nil, nil, nil, self, responseCallback, false, nil)
    end
end

function MainWindow:playDamageTimeEffect()
    local root = self.roots[1]

    local Image_boom_red = ccui.Helper:seekWidgetByName(root,"Image_boom_red")
    Image_boom_red:setVisible(true)
    Image_boom_red:stopAllActions()

    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    playActions(Image_boom_red)
end

function MainWindow:removeDamageTimeEffect()
    local root = self.roots[1]
    local Image_boom_red = ccui.Helper:seekWidgetByName(root,"Image_boom_red")
    Image_boom_red:setVisible(false)
    Image_boom_red:stopAllActions()
end

-- 刷新增益状态
function MainWindow:updateFactor()
    local root = self.roots[1]
    local fatcor_state = {0, 0, 0, 0, 0, 0}
    local have_gain = false
    for k, v in pairs(_ED.factor_info) do 
        local build_buff_id = tonumber(v.build_buff_id)
        if build_buff_id == 7 then          -- 减伤
            fatcor_state[1] = 1
        elseif build_buff_id == 6 then      -- 加伤
            fatcor_state[2] = 1
        elseif build_buff_id == 8 then      -- 行军速度
            fatcor_state[3] = 1
        elseif build_buff_id >= 1 and build_buff_id <= 5 then      -- 资源增产
            fatcor_state[4] = 1
        elseif build_buff_id == 10 then      -- 侦查
            fatcor_state[5] = 1
        elseif build_buff_id >= 11 and build_buff_id <= 20 then      -- 伪装
            fatcor_state[6] = 1
        end
        if build_buff_id > 0 and _ED.base_build_buff[""..build_buff_id] ~= nil then
            have_gain = true
        end
    end

    for i = 1, 6 do
        local Image_gain_icon = ccui.Helper:seekWidgetByName(root,"Image_gain_icon_"..i)
        local Image_gain_icon_0 = ccui.Helper:seekWidgetByName(root,"Image_gain_icon_0_"..i)
        if fatcor_state[i] > 0 then         -- 有增益
            Image_gain_icon:setVisible(false)
            Image_gain_icon_0:setVisible(true)
        else
            Image_gain_icon:setVisible(true)
            Image_gain_icon_0:setVisible(false)
        end
    end

    -- 增益状态
    local Text_gain_n = ccui.Helper:seekWidgetByName(root,"Text_gain_n")
    if Text_gain_n ~= nil then
        if have_gain == true then
            Text_gain_n:setString(red_alert_time_str[105])
        else
            Text_gain_n:setString(tipString_info_project_pacific_rim[18])
        end
    end
end

-- 可以免费建造时提示
function MainWindow:updateFreeBuildTips(free_build)
    local root = self.roots[1]
    local Text_build_t = ccui.Helper:seekWidgetByName(root,"Text_build_t")
    local Text_build_free = ccui.Helper:seekWidgetByName(root,"Text_build_free")
    if free_build == true then
        Text_build_t:setVisible(false)
        Text_build_free:setVisible(true)
        Text_build_free:stopAllActions()
        local function playActions(sender)
            if sender ~= nil and sender:getParent() ~= nil then
                local scaleOut = cc.ScaleTo:create(0.5, 0.9)
                local scaleIn = cc.ScaleTo:create(0.5, 1)
                sender:runAction(cc.Sequence:create(scaleOut, scaleIn, cc.CallFunc:create(playActions)))
            end
        end
        playActions(Text_build_free)
    else
        Text_build_t:setVisible(true)
        Text_build_free:setVisible(false)
    end
end

function MainWindow:updateQuickInfo( ... )
    local root = self.roots[1]
    local Text_build_n = ccui.Helper:seekWidgetByName(root,"Text_build_n")
    local Text_production_n = ccui.Helper:seekWidgetByName(root,"Text_production_n")
    local Text_technology_n = ccui.Helper:seekWidgetByName(root,"Text_technology_n")
    local Text_manufacture_n = ccui.Helper:seekWidgetByName(root,"Text_manufacture_n")
    local Button_build_position = ccui.Helper:seekWidgetByName(root,"Button_build_position")

    local build_upgrade_count = 0
    local free_build = false
    local free_time = 60 * dms.int(dms["base_consume"], 102, tonumber(_ED.vip_grade) + 4)
    local now_time = os.time()
    for k,v in pairs(_ED.home_build) do
        if zstring.tonumber(v.update_state) == 1 then
            build_upgrade_count = build_upgrade_count + 1

            if free_build == false then
                local leave_time = v.update_time_cd - zstring.tonumber((now_time + _ED.time_add_or_sub - v.update_start_time))
                if leave_time < free_time then
                    free_build = true
                end
            end
        end
    end
    self:updateFreeBuildTips(free_build)
    local barracks_upgrade_count = 0
    for k,v in pairs(_ED.barracks_info) do
        if zstring.tonumber(v.barrack_state) > 0 then
            barracks_upgrade_count = barracks_upgrade_count + 1
        end
    end
    local production_count = 0
    local manufacture_count = 0
    if _ED.production_info ~= nil then
        if _ED.production_info["0"] ~= nil then
            for k,v in pairs(_ED.production_info["0"]) do
                production_count = production_count + 1
            end
        end
        if _ED.production_info["1"] ~= nil then
            for k,v in pairs(_ED.production_info["1"]) do
                production_count = production_count + 1
            end
        end
        if _ED.production_info["2"] ~= nil then
            for k,v in pairs(_ED.production_info["2"]) do
                production_count = production_count + 1
            end
        end
        if _ED.production_info["3"] ~= nil then
            for k,v in pairs(_ED.production_info["3"]) do
                manufacture_count = manufacture_count + 1
            end
        end
    end

    local factory_count = 0              -- 已解锁的工厂数
    for i = 9, 11 do
        if _ED.home_build[""..i] ~= nil and tonumber(_ED.home_build[""..i].level) > 0 then
            factory_count = factory_count + 1
        end
    end

    Text_build_n:setString(build_upgrade_count.."/".._ED.home_build_max_count)
    Text_production_n:setString(production_count.."/"..(dms.int(dms["base_consume"], 78, tonumber(_ED.vip_grade) + 4) * factory_count))
    Text_technology_n:setString(barracks_upgrade_count.."/"..dms.int(dms["base_consume"], 79, tonumber(_ED.vip_grade) + 4))
    Text_manufacture_n:setString(manufacture_count.."/"..dms.int(dms["base_consume"], 80, tonumber(_ED.vip_grade) + 4))

    local maxPos = dms.int(dms["base_consume"], 75, tonumber(_ED.vip_grade) + 4)
    local reset_consume = 0
    for k,v in pairs(dms.element(dms["base_consume"], 75)) do
        if k >= 4 then
            if tonumber(v) == _ED.home_build_max_count + 1 then
                reset_consume = k - 4
            end
        end
    end
    if reset_consume == 0 then
        Button_build_position:setVisible(false)
    end
    if _ED.home_build_max_count < maxPos then
        _ED.have_buy_build_pos_count = true
    else
        _ED.have_buy_build_pos_count = false
    end
    state_machine.excute("notification_center_update", 0, "push_notification_have_buy_build_pos_count")
end

-- 更新资源数量
function MainWindow:updateResource()
    local root = self.roots[1]
    -- 铁矿
    local Text_iron_ore_n = ccui.Helper:seekWidgetByName(root,"Text_iron_ore_n")
    local LoadingBar_iron_ore = ccui.Helper:seekWidgetByName(root,"LoadingBar_iron_ore")    
    Text_iron_ore_n:setString(exChangeNumToString(_ED.user_info.user_iron))
    LoadingBar_iron_ore:setPercent(_ED.user_info.user_iron / _ED.user_info.user_iron_max *100)

    -- 石油
    local Text_petroeum_n = ccui.Helper:seekWidgetByName(root,"Text_petroeum_n")
    local LoadingBar_petroeum = ccui.Helper:seekWidgetByName(root,"LoadingBar_petroeum")    
    Text_petroeum_n:setString(exChangeNumToString(_ED.user_info.oil_field))
    LoadingBar_petroeum:setPercent(_ED.user_info.oil_field / _ED.user_info.oil_field_max *100)

    -- 铅矿
    local Text_lead_ore_n = ccui.Helper:seekWidgetByName(root,"Text_lead_ore_n")
    local LoadingBar_lead_ore = ccui.Helper:seekWidgetByName(root,"LoadingBar_lead_ore")    
    Text_lead_ore_n:setString(exChangeNumToString(_ED.user_info.exploits))
    LoadingBar_lead_ore:setPercent(_ED.user_info.exploits / _ED.user_info.exploits_max *100)

    -- 钛矿
    local Text_titanium_ore_n = ccui.Helper:seekWidgetByName(root,"Text_titanium_ore_n")
    local LoadingBar_titanium_ore = ccui.Helper:seekWidgetByName(root,"LoadingBar_titanium_ore")    
    Text_titanium_ore_n:setString(exChangeNumToString(_ED.user_info.tiger_shaped))
    LoadingBar_titanium_ore:setPercent(_ED.user_info.tiger_shaped / _ED.user_info.tiger_shaped_max *100)

    -- 宝石
    local Text_gemstone_n = ccui.Helper:seekWidgetByName(root,"Text_gemstone_n")
    local LoadingBar_gemstone = ccui.Helper:seekWidgetByName(root,"LoadingBar_gemstone")    
    Text_gemstone_n:setString(exChangeNumToString(_ED.user_info.user_silver))
    LoadingBar_gemstone:setPercent(_ED.user_info.user_silver / _ED.user_info.user_silver_max *100)
end

function MainWindow:updateFighting( ... )
    local root = self.roots[1]
    local Text_fight_n = ccui.Helper:seekWidgetByName(root,"Text_fight_n")              
    Text_fight_n:setString(exChangeNumToString(_ED.user_info.fighter_capacity))
end

function MainWindow:updateGoldInfo( ... )
    local root = self.roots[1]
    local Text_gold_n = ccui.Helper:seekWidgetByName(root,"Text_gold_n")                
    Text_gold_n:setString(_ED.user_info.user_gold)
    -- vip等级
    local Text_vip_n = ccui.Helper:seekWidgetByName(root,"Text_vip_n")                  
    Text_vip_n:setString(_ED.vip_grade)
end

function MainWindow:visibleFuncButton(visible)
    local root = self.roots[1]
    local Panel_button_fun_1 = ccui.Helper:seekWidgetByName(root,"Panel_button_fun_1")
    local Panel_button_fun_2 = ccui.Helper:seekWidgetByName(root,"Panel_button_fun_2")
    local Panel_home_task_box = ccui.Helper:seekWidgetByName(root,"Panel_home_task_box")
    local ListView_active_icon = ccui.Helper:seekWidgetByName(root,"ListView_active_icon")
    Panel_button_fun_1:setVisible(visible)
    Panel_button_fun_2:setVisible(visible)
    Panel_home_task_box:setVisible(visible)
    ListView_active_icon:setVisible(visible)

    if true == visible then
        state_machine.excute("home_button_window_show", 0, 0)
        state_machine.excute("home_map_all_build_visible", 0, true)
    else
        state_machine.excute("home_button_window_hide", 0, 0)
        state_machine.excute("home_map_all_build_visible", 0, false)
    end
end

function MainWindow:updateBoomInfo( ... )
    local root = self.roots[1]
    -- 繁荣度
    local Text_boom_n = ccui.Helper:seekWidgetByName(root,"Text_boom_n")
    Text_boom_n:removeAllChildren(true)
    local boom_state = 0
    local boom_bar = zstring.tonumber(_ED.user_info.booming)/zstring.tonumber(_ED.user_info.forage)
    for i= 1, dms.count(dms["build_boom_lose"]) do
        local boom_proportion = dms.string(dms["build_boom_lose"], i, build_boom_lose.boom_proportion)
        if boom_bar >= tonumber(boom_proportion) then
            boom_state = dms.int(dms["build_boom_lose"], i, build_boom_lose.boom_state)
            break
        end
    end

    if (zstring.tonumber(_ED.user_info.booming) < zstring.tonumber(_ED.user_info.forage)) then
        self:playDamageTimeEffect()
    else
        self:removeDamageTimeEffect()
    end

    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)       
    local re1 = ccui.RichElementText:create(1, cc.c3b(boom_window_color_Type[boom_state+1][1],boom_window_color_Type[boom_state+1][2],boom_window_color_Type[boom_state+1][3]),255, _ED.user_info.booming, "fonts/simhei.ttf",18)
    _richText:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255,"/".. _ED.user_info.forage, "fonts/simhei.ttf",18)
    _richText:pushBackElement(re2)
    _richText:setPosition(cc.p(Text_boom_n:getContentSize().width/2,Text_boom_n:getContentSize().height/2))
    _richText:setContentSize(cc.size(Text_boom_n:getContentSize().width,18))
    Text_boom_n:addChild(_richText)

    if __lua_project_id == __lua_project_pacific_rim then
        if (zstring.tonumber(_ED.user_info.booming) < zstring.tonumber(_ED.user_info.forage)) then
            ccui.Helper:seekWidgetByName(root,"Panel_boom"):setVisible(true)
        else
            ccui.Helper:seekWidgetByName(root,"Panel_boom"):setVisible(false)
        end
    end
end

function MainWindow:updatePlayerHeadInfo( ... )
    local root = self.roots[1]
    -- 人物头像
    local Panel_head_icon = ccui.Helper:seekWidgetByName(root,"Panel_head_icon")        
    Panel_head_icon:removeBackGroundImage()
    local head_data = zstring.split(_ED.user_info.user_head_id, ",")
    local head_info = zstring.split(dms.string(dms["avatar_head"], head_data[1], avatar_head.icon_info), ",")
    Panel_head_icon:setBackGroundImage(string.format(config_res.images.ui.props.props, head_info[1]))
    
    -- 玩家名和等级
    local Text_name_lv = ccui.Helper:seekWidgetByName(root,"Text_name_lv")
    if __lua_project_id == __lua_project_pacific_rim then
        Text_name_lv:setString(_ED.user_info.user_grade)
    else        
        Text_name_lv:setString(_ED.user_info.user_name.." "..string.format(red_alert_all_str[117],_ED.user_info.user_grade))
        if verifySupportLanguage(_lua_release_language_en) == true then
            local Text_exp_t = ccui.Helper:seekWidgetByName(root,"Text_exp_t")
            Text_name_lv:setString(_ED.user_info.user_name)
            Text_exp_t:setString(string.format(red_alert_all_str[117],_ED.user_info.user_grade))
        end
    end

    local Button_teaching = ccui.Helper:seekWidgetByName(root,"Button_teaching")
    local Panel_top_infor = ccui.Helper:seekWidgetByName(root,"Panel_top_infor")
    if Button_teaching ~= nil then
        local ArmatureNode_teaching = Panel_top_infor:getChildByName("ArmatureNode_teaching")
        ArmatureNode_teaching:setVisible(false)
        Button_teaching:setVisible(false)
        local max_level = dms.int(dms["user_config"], 34, user_config.param)
        if tonumber(_ED.user_info.user_grade) < max_level then
            ArmatureNode_teaching:setVisible(true)
            Button_teaching:setVisible(true)
        end
    end
end

function MainWindow:updateActivityPushInfo( ... )
    if self._Image_new ~= nil then
        self._Image_new:setVisible(false)
        for i,v in pairs(_ED.activity_info) do
            if tonumber(v.activity_type) == 2
                or tonumber(v.activity_type) == 4
                or tonumber(v.activity_type) == 8
                or tonumber(v.activity_type) == 9
                or tonumber(v.activity_type) == 17
                or tonumber(v.activity_type) == 41
                or tonumber(v.activity_type) == 50
                or tonumber(v.activity_type) == 51
                or tonumber(v.activity_type) == 52
                or tonumber(v.activity_type) == 53
                or tonumber(v.activity_type) == 54
                or tonumber(v.activity_type) == 55
                or tonumber(v.activity_type) == 56
                or tonumber(v.activity_type) == 60
                or tonumber(v.activity_type) == 61
                or tonumber(v.activity_type) == 62
                or tonumber(v.activity_type) == 63
                or tonumber(v.activity_type) == 64
                or tonumber(v.activity_type) == 65
                or tonumber(v.activity_type) == 66
                or tonumber(v.activity_type) == 68
                or tonumber(v.activity_type) == 69
                or tonumber(v.activity_type) == 70
                or tonumber(v.activity_type) == 72
                or tonumber(v.activity_type) == 73
                or tonumber(v.activity_type) == 74
                or tonumber(v.activity_type) == 76
                or tonumber(v.activity_type) == 77
                or tonumber(v.activity_type) == 79
                or tonumber(v.activity_type) == 80
                or tonumber(v.activity_type) == 32 
                or tonumber(v.activity_type) == 12 
                or tonumber(v.activity_type) == 84
                or tonumber(v.activity_type) == 85
                or tonumber(v.activity_type) == 86
                or tonumber(v.activity_type) == 87
                or tonumber(v.activity_type) == 88
                or tonumber(v.activity_type) == 89
                or tonumber(v.activity_type) == 90
                or tonumber(v.activity_type) == 91
                or tonumber(v.activity_type) == 92
                or tonumber(v.activity_type) == 93
                or tonumber(v.activity_type) == 94
                or tonumber(v.activity_type) == 95
                or tonumber(v.activity_type) == 106
                or tonumber(v.activity_type) == 107
                or tonumber(v.activity_type) == 108
                or tonumber(v.activity_type) == 109
                or tonumber(v.activity_type) == 110
                or tonumber(v.activity_type) == 111
                or tonumber(v.activity_type) == 112
                or tonumber(v.activity_type) == 113
                or tonumber(v.activity_type) == 114
                or tonumber(v.activity_type) == 115
                or tonumber(v.activity_type) == 116
                or tonumber(v.activity_type) == 119
                or tonumber(v.activity_type) == 120
                or tonumber(v.activity_type) == 121
                or tonumber(v.activity_type) == 122
                or tonumber(v.activity_type) == 123
                or tonumber(v.activity_type) == 124
                or tonumber(v.activity_type) == 125
                then
                local currentTime = _ED.system_time + (os.time() - _ED.native_time)
                local addStateInfo = zstring.split(v.activity_add_state, ",")
                local start_time = 0
                if tonumber(v.activity_type) == 8 then
                    start_time = zstring.tonumber(addStateInfo[2])/1000
                else
                    start_time = zstring.tonumber(addStateInfo[1])/1000
                end
                if currentTime - start_time <= 24 * 3600 then
                    self._Image_new:setVisible(true)
                    return
                end
            end
        end
    end
end

function MainWindow:updateDraw()
    local root = self.roots[1]

    -- 经验值
    local Text_exp_n = ccui.Helper:seekWidgetByName(root,"Text_exp_n")                  
    local LoadingBar_exp = ccui.Helper:seekWidgetByName(root,"LoadingBar_exp")          -- 经验条
    Text_exp_n:setString(exChangeNumToString(_ED.user_info.user_experience) .. "/" .. exChangeNumToString(_ED.user_info.user_grade_need_experience))
    local persent_exp = zstring.tonumber(_ED.user_info.user_experience) / zstring.tonumber(_ED.user_info.user_grade_need_experience) *100
    if zstring.tonumber(_ED.user_info.user_experience) == 0 then
        LoadingBar_exp:setPercent(0)
    else
        LoadingBar_exp:setPercent(persent_exp)
    end

    -- 能量值
    local Text_energy_n = ccui.Helper:seekWidgetByName(root,"Text_energy_n")   
    self._text_time = Text_energy_n        
    local LoadingBar_energy = ccui.Helper:seekWidgetByName(root,"LoadingBar_energy")    -- 能量条
    local times = zstring.tonumber(_ED._next_energy_recover_time)/1000 - (_ED.system_time + os.time() - _ED.native_time)
    if times > 0 
        and tonumber(_ED.user_info.user_food) < tonumber(_ED.user_info.max_user_food) then
        self._text_time:setString(zstring.tonumber(_ED.user_info.user_food) .. "/" .. _ED.user_info.max_user_food.."("..exChangeTimeToString(times)..")")
    else
        self._text_time:setString(zstring.tonumber(_ED.user_info.user_food) .. "/" .. _ED.user_info.max_user_food)
    end
    local persent_energy = zstring.tonumber(_ED.user_info.user_food) / zstring.tonumber(_ED.user_info.max_user_food) *100
    LoadingBar_energy:setPercent(persent_energy)

    self:updatePlayerHeadInfo()
    self:updateBoomInfo()
    self:updateGoldInfo()
    self:updateFighting()
    self:updateQuickInfo()
    self:updateFactor()
    self:updateResource()
    self:updateCityEnergy()
    checkRewardObtainDraw()
    state_machine.excute("main_window_update_rebels_window",0,0)
end

function MainWindow:onInit()
    local csbItem = csb.createNode(config_csb.home.main_window)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local Text_home_task_time = ccui.Helper:seekWidgetByName(root,"Text_home_task_time")
    self._task_text_pos_x = Text_home_task_time:getPositionX()
    self._task_text_pos_y = Text_home_task_time:getPositionY()

    local Text_home_urgent_task_time = ccui.Helper:seekWidgetByName(root,"Text_home_urgent_task_time")
    if Text_home_urgent_task_time ~= nil then
        self._task_urgent_text_pos_x = Text_home_urgent_task_time:getPositionX()
        self._task_urgent_text_pos_y = Text_home_urgent_task_time:getPositionY()
    end

    self._Image_new = ccui.Helper:seekWidgetByName(root,"Image_new")
	
	if ccui.Helper:seekWidgetByName(root,"ListView_active_icon")._x == nil then
		ccui.Helper:seekWidgetByName(root,"ListView_active_icon")._x = ccui.Helper:seekWidgetByName(root,"ListView_active_icon"):getPositionX()
	end

    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_task_get)
    local maxPos = dms.int(dms["base_consume"], 75, tonumber(_ED.vip_grade) + 4)
    if _ED.home_build_max_count < maxPos then
        _ED.have_buy_build_pos_count = true
    end

    -- 建造
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_build"), nil, 
    {
        terminal_name = "player_info_window_open",
        terminal_state = 0,
        touch_black = true,
        _page = 3,
    },
    nil,1)
    -- 生产
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_production"), nil, 
    {
        terminal_name = "main_window_open_tank_factory",
        terminal_state = 0,
        touch_black = true,
    },
    nil,1)
    -- 科技
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_technology"), nil, 
    {
        terminal_name = "main_window_open_scientific",
        terminal_state = 0,
        touch_black = true,
    },
    nil,1)
    -- 制造
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_manufacture"), nil, 
    {
        terminal_name = "main_window_manufacture_make",
        terminal_state = 0,
        touch_black = true,
    },
    nil,1)
    -- 购买升级位
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_build_position"), nil, 
    {
        terminal_name = "main_window_buy_build_upgrade_pos",
        terminal_state = 0,
        touch_black = true,
    },
    nil,1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_have_buy_build_pos_count",
    _widget = ccui.Helper:seekWidgetByName(root,"Button_build_position"),
    _m_type = 0,
    _invoke = nil,
    _interval = 0.2,})

    -- 出征
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_world_battle"), nil, 
    {
        terminal_name = "formation_window_open",
        terminal_state = 0,
        touch_black = true,
        page = 2,
    },
    nil,1)

    -- 增益
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_gain"), nil, 
    {
        terminal_name = "base_reserve_window_open",
        terminal_state = 0,
        touch_black = true,
        page_index = 2,
    },
    nil,1)

    -- 玩家详情
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_palyer"), nil, 
    {
        terminal_name = "player_info_window_open",
        terminal_state = 0,
        touch_black = true,
    },
    nil,1)

    -- 繁荣度
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_boom"), nil, 
    {
        terminal_name = "player_infor_boom_window_open",
        terminal_state = 0,
        touch_black = true,
    },
    nil,1)
    -- 充值
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_recharge"), nil, 
    {
        terminal_name = "main_window_open_recharge",
        terminal_state = 0,
        touch_black = true,
        choose_type = 1,
    },
    nil,1)
    -- vip特权
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_vip"), nil, 
    {
        terminal_name = "main_window_open_recharge",
        terminal_state = 0,
        touch_black = true,
        choose_type = 2,
    },
    nil,1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_privilege_packs",
    _widget = ccui.Helper:seekWidgetByName(root,"Button_vip"),
    _m_type = 0,
    _invoke = nil,
    _interval = 0.2,})
    
    -- 战斗力
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_fight"), nil, 
    {
        terminal_name = "player_fight_open",
        terminal_state = 0,
        touch_black = true,
    },
    nil,1)

    -- 活动
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_activity"), nil, 
    {
        terminal_name = "main_window_activity_open",
        terminal_state = 0,
        touch_black = true,
    },
    nil,1)
    state_machine.excute("main_window_push_activity",0,0)

    -- 抽奖
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_luck_draw"), nil, 
    {
        terminal_name = "red_alert_time_lucky_draw_window_open",
        terminal_state = 0,
        touch_black = true,
    },
    nil,1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_mine_lottery_push",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_luck_draw"),
    _invoke = nil,
    _interval = 0.5,})

    -- 宝藏
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_treasure_house"), nil, 
    {
        terminal_name = "red_alert_time_center_window_open",
        terminal_state = 0,
        touch_black = true,
    },
    nil,1)
    state_machine.excute("main_window_push_treasure",0,0)
    state_machine.excute("treasure_discount_store_push_update",0,"treasure_discount_store_push_update.")
    -- 商店
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_shop"), nil, 
    {
        terminal_name = "props_shop_packs_window_open",
        terminal_state = 0,
        touch_black = true,
        page_index = 1,
    },
    nil,1)

    -- 公告
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_notice"), nil, 
    {
        terminal_name = "game_announcement_window_open",
        terminal_state = 0,
        touch_black = true,
    },
    nil,1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_game_announcement",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_notice"),
    _invoke = nil,
    _interval = 0.2,})

    -- 基地储备
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_res_infor"), nil, 
    {
        terminal_name = "base_reserve_window_open",
        terminal_state = 0,
        touch_black = true,
        page_index = 1,
    },
    nil,1)

    -- 增益
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_gain_box"), nil, 
    {
        terminal_name = "base_reserve_window_open",
        terminal_state = 0,
        touch_black = true,
        page_index = 2,
    },
    nil,1)

    -- 任务
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_home_task_box"), nil, 
    {
        terminal_name = "main_window_click_task",
        terminal_state = 0,
        touch_black = true,
    },
    nil,1)

    -- 任务
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_home_urgent_task_box"), nil, 
    {
        terminal_name = "main_window_click_task",
        terminal_state = 0,
        touch_black = true,
        isUrgent = true,
    },
    nil,1)

    -- 叛军按钮
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_rebel_haunt"), nil, 
    {
        terminal_name = "main_window_open_rebels_window",
        terminal_state = 0,
        touch_black = true,
    },
    nil,1)

    -- 小助手
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_teaching"), nil, 
    {
        terminal_name = "teaching_window_open",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    },
    nil,1)

    -- 购买城市能量
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_legion_city_energe"), nil, 
    {
        terminal_name = "main_window_buy_city_energy",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    },
    nil,1)
    
    -- 城市战
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_legion_city_battle"), nil, 
    {
        terminal_name = "legion_city_formation_window_open",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    },
    nil,1)

    -- 城市商店
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_legion_city_shop"), nil, 
    {
        terminal_name = "legion_city_shop_window_open",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    },
    nil,1)

    local Button_facebook_method = ccui.Helper:seekWidgetByName(root, "Button_facebook_method")
    if Button_facebook_method ~= nil then
        Button_facebook_method:setVisible(true)
        app.load("client.operation.platformSDKInterface.platformFacebook.platformFbMethod")
        fwin:addTouchEventListener(Button_facebook_method, nil, 
        {
            terminal_name = "platform_fb_method_open", 
            terminal_state = 0, 
            status = false,
            isPressedActionEnabled = true
        }, 
        nil, 0)

        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_facebook",
                _widget = Button_facebook_method,
                _invoke = nil,
                _interval = 0.5,})
            end
        end
        NetworkManager:register(protocol_command.fb_reward_init.code, nil, nil, nil, nil, responseCallback, true, nil)

        if zstring.tonumber(_ED.server_review) == 1 then 
            Button_facebook_method:setVisible(false)
        end
    end

    local Panel_home_map = ccui.Helper:seekWidgetByName(root,"Panel_home_map")
    Panel_home_map:removeAllChildren(true)
    Panel_home_map:setSwallowTouches(false)
    state_machine.excute("home_map_window_open", 0, {Panel_home_map})
    
    getUserFight()
    self:updateDraw()
    self:updateTaskInfo()
    self:updateTopButton()
    self:getlegionPveReceiveTips()
    self:updateFormationCount()
    getUpdateUserPropTip()
    getRedAlertTimeEquipmentPartsTip()
    getRedAlertTimeTaskTip()

    if _ED.system_notice_ex == nil then
        local function responseSystemNotice(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil and response.node.roots ~= nil then
                    response.node:pushGameAnnouncement()
                end
            end
        end
        
        NetworkManager:register(protocol_command.get_system_notice.code, app.configJson.urlForAnnounce, nil, nil, self, responseSystemNotice, false, nil)
    else
        self:pushGameAnnouncement()
    end

    state_machine.excute("top_notification_timer_open", 0, nil)
    state_machine.excute("home_button_window_open", 0, nil)
    -- state_machine.excute("red_alert_time_mine_event_queue_open", 0, nil)
    state_machine.excute("world_battle_event_info_open", 0, nil)
    
    state_machine.excute("warship_girl_push_info_open",0,{_datas={_openType=0}})

    if zstring.tonumber(_ED.user_info.booming)~=zstring.tonumber(_ED.user_info.forage) then
        local function respondCallBack(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil and response.node.roots ~= nil then
                    state_machine.excute("main_window_update_boom_info", 0, nil)
                end
            end
        end
        NetworkManager:register(protocol_command.check_boom_recover.code, nil, nil, nil, self, respondCallBack, false, nil)
    end

    --添加获取网络强度和网络延时的请求
    state_machine.excute("platform_get_signal_strength_and_network_delay_time_ms", 0, nil)
    --固定时间推送
    state_machine.excute("platform_push_fixed_request_terminal", 0, nil)
end

function MainWindow:onEnterTransitionFinish()

end

function MainWindow:getlegionPveReceiveTips()
    if _ED.union.union_info == nil 
        or _ED.union.union_info == {} 
        or _ED.union.union_info.union_id == nil 
        or _ED.union.union_info.union_id == "" 
        or tonumber(_ED.union.union_info.union_id) == 0 
        then
        _ED._can_receive_count = 0
    else
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                getLegionPveCanReceiveCount()
                state_machine.excute("home_map_update_prodcution_state", 0, {2})
            end
        end
        protocol_command.union_copy_init.param_list = ""
        NetworkManager:register(protocol_command.union_copy_init.code, nil, nil, nil, nil, responseCallback, false, nil)
    end
end

function MainWindow:pushGameAnnouncement()
    local root = self.roots[1]
    local Button_notice = ccui.Helper:seekWidgetByName(root,"Button_notice")
    Button_notice:setVisible(true)
    local game_announcement_push = cc.UserDefault:getInstance():getStringForKey("game_announcement_push")
    game_announcement_push = zstring.split(game_announcement_push,"|||")
    if _ED.system_notice_ex ~= nil then
        local systemNotice = zstring.split(_ED.system_notice_ex,"\\r\\n|") --格式化的内容

        local nCount = 10000
        local nIndex = 1
        local all_announcement = 0
        local is_open_announcement = 0
        while true do
            nCount = nCount - 1
            if nCount < 0 then
                break
            end
            local title = systemNotice[nIndex]
            local isNew = systemNotice[nIndex + 1]
            local nType = systemNotice[nIndex + 2] -- 判断是否为图片
            local titleImage = systemNotice[nIndex + 3]
            local content = systemNotice[nIndex + 4]
            if title == nil or isNew == nil or nType == nil or titleImage == nil or content == nil then
                break
            end
            all_announcement = all_announcement + 1 
            for k,v in pairs(game_announcement_push) do
                if content == v then
                    is_open_announcement = is_open_announcement + 1
                end
            end
            nIndex = nIndex + 5
        end
        if is_open_announcement >= all_announcement then
            Button_notice:setVisible(false)
            _ED.push_game_announcement_state = false
            state_machine.excute("notification_center_update", 0, "push_notification_game_announcement")
        end
    else
        Button_notice:setVisible(false)
    end
    if zstring.tonumber(_ED.server_review) == 1 then
        Button_notice:setVisible(false)
    end
end


function MainWindow:formatTimeString(_time)
    local timeString = ""
    timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)/3600)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor((tonumber(_time)%3600)/60)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)%60))
    return timeString
end

function MainWindow:onUpdateTimer(dt)
    local current_time = os.time()
    if math.abs(current_time - self._base_client_time) >= 60 then
        local function respondCallBack(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                
            end
        end
        NetworkManager:register(protocol_command.verify_system_time.code, nil, nil, nil, self, respondCallBack, false, nil)
    end
    self._base_client_time = current_time

    if math.abs(current_time - self._keep_alive_time) >= 5 then
        self._keep_alive_time = current_time
        local temp = getCurrentGTM8Time()
        local m_hour = tonumber(string.format("%02d", temp.hour))
        local m_min = tonumber(string.format("%02d", temp.min))
        local m_sec = tonumber(string.format("%02d", temp.sec))
        if m_hour == 0 and m_min == 0 and m_sec <= 40 then
            NetworkManager:register(protocol_command.keep_alive.code, nil, nil, nil, nil, nil, false, nil)
        end
    end

    if m_recharge_protocol_is_ok == true and m_recharge_thirdparty_is_ok == true then
        if _ED.recharge_result_cheak.recharge_id ~= nil and _ED.recharge_result_cheak.recharge_id ~= "" 
            then
            local recharge_id = 0
            if tonumber(_ED.recharge_result_cheak.recharge_id) > 6 then
                local _gradeMonthCard = dms.string(dms["top_up_goods"], tonumber(_ED.recharge_result_cheak.recharge_id), top_up_goods.money)
                local crossPiece = dms.searchs(dms["top_up_goods"], top_up_goods.money, _gradeMonthCard)
                recharge_id = tonumber(crossPiece[1][1])
            else
               recharge_id = tonumber(_ED.recharge_result_cheak.recharge_id) 
            end
            local FBmissId = recharge_id+10
            --如果其他平台充值发送新加的事件
            if tonumber(m_platform_app_ptext) == 3 then
                FBmissId = FBmissId + 6
            end
            jttd.facebookAPPeventSlogger(FBmissId.."|"..dms.string(dms["top_up_goods"], tonumber(_ED.recharge_result_cheak.recharge_id), top_up_goods.money))
            jttd.facebookAPPeventSlogger("10".."|"..dms.string(dms["top_up_goods"], tonumber(_ED.recharge_result_cheak.recharge_id), top_up_goods.money))
        end
        m_recharge_protocol_is_ok = false
        m_recharge_thirdparty_is_ok = false
    end
    self._reconnect = self._reconnect - dt
    self._get_resource_time = self._get_resource_time - dt
    self._get_booming_time = self._get_booming_time - dt
    -- if self._reconnect < 0 then
    --     --断线重连后的处理
    --     self._reconnect = 5
    --     if NetworkAdaptor.socketIsOpen() == false then
    --         if false == NetworkAdaptor.LuaSocket.reconnect then
    --             -- -- self._reconnect = 30
    --             -- NetworkAdaptor.LuaSocket.reconnect = true
    --             -- NetworkAdaptor.intSocket()
    --             NetworkAdaptor.reconnectSocket()
    --         else
    --             -- NetworkAdaptor.LuaSocket.reconnect = false
    --             -- state_machine.excute("logout_tip_window_open", 0, 0)
    --         end
    --     else
    --         -- if true == NetworkAdaptor.LuaSocket.reconnect then
    --         --     local sendStr = NetworkProtocol.command_func(protocol_command.init_user_socket_service.code)
    --         --     NetworkAdaptor.socketSend(sendStr)
    --         -- end
    --     end
    -- end
    
    if self._text_time ~= nil and tonumber(_ED.user_info.user_food) < tonumber(_ED.user_info.max_user_food) then
        local now_time = (_ED.system_time + current_time - _ED.native_time)
        local times = zstring.tonumber(_ED._next_energy_recover_time)/1000 - now_time
        if times > 0 then
            self._text_time:setString(zstring.tonumber(_ED.user_info.user_food) .. "/" .. _ED.user_info.max_user_food.."("..exChangeTimeToString(times)..")")
        else
            self._text_time:setString(zstring.tonumber(_ED.user_info.user_food) .. "/" .. _ED.user_info.max_user_food)
        end
        self._last_time = now_time
    end

    if self._get_resource_time < 0 then
        -- local function respondCallBack(response)
        --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
        --         if response.node ~= nil and response.node.roots ~= nil then
        --             response.node._get_resource_time = 120
        --             state_machine.excute("main_window_update_userinfo", 0, nil)
        --         end
        --     end
        -- end
        -- NetworkManager:register(protocol_command.get_home_resource.code, nil, nil, nil, self, respondCallBack, false, nil)
    end

    if tonumber(_ED.user_info.booming) < tonumber(_ED.user_info.forage) then
        if self._get_booming_time < 0 then
            -- _ED.user_info.booming_time
            self._get_booming_time = 300
            local function respondCallBack(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    if response.node ~= nil and response.node.roots ~= nil then
                        state_machine.excute("main_window_update_boom_info", 0, nil)
                    end
                end
            end
            NetworkManager:register(protocol_command.check_boom_recover.code, nil, nil, nil, self, respondCallBack, false, nil)
        end
    end

    if _ED.home_patrol_reeard_info ~= nil then
        if self._home_patrol_tick_time == nil then
            self._home_patrol_tick_time = tonumber(zstring.split(dms.string(dms["build_patrol_config"], 2, build_patrol_config.param), ",")[1])
        end
        if zstring.tonumber(_ED.home_patrol_reeard_info.high_reward_times) < 2 then
            if (_ED.system_time + current_time - _ED.native_time) - _ED.home_patrol_reeard_info.last_calc_times >= self._home_patrol_tick_time * 60 then
                local function patrolRewardRespondCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("home_map_update_patrol_reward_state", 0, nil)
                    end
                end
                NetworkManager:register(protocol_command.build_patrol_check_time.code, nil, nil, nil, self, patrolRewardRespondCallBack, false, nil)
            end
        end
    end

    state_machine.excute("player_title_set_check_time", 0, current_time)
    state_machine.excute("base_reserve_tab_gain_check_time", 0, current_time)
    state_machine.excute("armor_production_check_time", 0, current_time)

    state_machine.excute("red_alert_time_chat_update_chat_infomation", 0, current_time)
    state_machine.excute("enemy_strike_update_chat_infomation", 0, current_time)

    if app.configJson.OperatorName == "tencent" or app.configJson.OperatorName == "gdtppk" then
        if m_tx_pay_index < zstring.tonumber(m_tencent_pay_number) and (current_time - self.platform_tx_pay_time) > 1 then
            m_tx_pay_index = m_tx_pay_index+1
            self.platform_tx_pay_time = current_time
            state_machine.excute("tencent_balance_inquiry", 0, "tencent_balance_inquiry.")
        end
    end
    --morefun添加效验订单请求
    if app.configJson.OperatorName == "morefun" then
        if m_tx_pay_index < zstring.tonumber(m_tencent_pay_number) and m_tx_pay_start == true and (current_time - self.platform_tx_pay_time) > 1 then
            m_tx_pay_index = m_tx_pay_index+1
            self.platform_tx_pay_time = current_time
            --Sender(protocol_command.vali_top_up_order_number.code, nil, nil, nil, nil, nil, -1)
            protocol_command.vali_top_up_order_number.param_list =  "".._ED.user_info.user_id.."\r\n".._ED.recharge_result.recharge_id.."\r\n"..getPlatform()
            NetworkManager:register(protocol_command.vali_top_up_order_number.code, nil, nil, nil, nil, nil, false, nil)
        end
    end

    if self._task_build_id > 0 and self._task_text_time ~= nil then
        local build_info = _ED.home_build[""..self._task_build_id]
        if zstring.tonumber(build_info.update_state) == 1 then
            local max_time = build_info.update_time_cd
            local now_time = current_time
            local leave_time = max_time - zstring.tonumber((now_time + _ED.time_add_or_sub - build_info.update_start_time))
            self._task_text_time:setString(exChangeTimeToString(leave_time))
            self._task_text_time:setPosition(cc.p(self._task_text_pos_x, self._task_text_pos_y + 10))
            self._task_text_ing:setPosition(cc.p(self._task_text_pos_x, self._task_text_pos_y - 10))
            self._task_image_state:setVisible(false)
        else
            self._task_text_time:setString("")
            self._task_text_ing:setString("")
            self._task_text_time:setPosition(cc.p(self._task_text_pos_x, self._task_text_pos_y))
            self._task_text_ing:setPosition(cc.p(self._task_text_pos_x, self._task_text_pos_y))
            self._task_image_state:setVisible(true)
        end
    end
    if zstring.tonumber(self._task_urgent_build_id) > 0 and self._task_urgent_text_time ~= nil then
        local build_info = _ED.home_build[""..self._task_urgent_build_id]
        if zstring.tonumber(build_info.update_state) == 1 then
            local max_time = build_info.update_time_cd
            local now_time = current_time
            local leave_time = max_time - zstring.tonumber((now_time + _ED.time_add_or_sub - build_info.update_start_time))
            self._task_urgent_text_time:setString(exChangeTimeToString(leave_time))
            self._task_urgent_text_time:setPosition(cc.p(self._task_urgent_text_pos_x, self._task_urgent_text_pos_y + 10))
            self._task_urgent_text_ing:setPosition(cc.p(self._task_urgent_text_pos_x, self._task_urgent_text_pos_y - 10))
            self._task_urgent_image_state:setVisible(false)
        else
            self._task_urgent_text_time:setString("")
            self._task_urgent_text_ing:setString("")
            self._task_urgent_text_time:setPosition(cc.p(self._task_urgent_text_pos_x, self._task_urgent_text_pos_y))
            self._task_urgent_text_ing:setPosition(cc.p(self._task_urgent_text_pos_x, self._task_urgent_text_pos_y))
            self._task_urgent_image_state:setVisible(true)
        end
    end

    if fwin._touch_wait_time > 15 then
        if tonumber(_ED.user_info.user_grade) <= 10
            and nil ~= self._Panel_home_task_box 
            and missionIsOver() == true
            and _ED.current_window_in_main_city == true
            then
            local showController = true
            for i, v in pairs(fwin._list) do
                if nil ~= v and v._view ~= nil and v.__cname ~= "WindowLockClass" 
                    and v._view._z > 10000 and v._view._z < 70000 
                    then
                    showController = false
                    break
                end
            end
            if showController == true then
                state_machine.excute("tuition_controller_touch_normal", 0, {self._Panel_home_task_box, true})
            end
        end
        fwin._touch_wait_time = 0
    end

    -- 紧急任务时间校验
    if self._task_urgent_text_time ~= nil then
        local urgentTask = getUrgentTask()
        if urgentTask ~= nil then
            self._task_urgent_leave_time = self._task_urgent_leave_time - dt
            if self._task_urgent_leave_time < 0 then
                protocol_command.check_task_time.param_list = urgentTask.task_id
                NetworkManager:register(protocol_command.check_task_time.code, nil, nil, nil, nil, nil, false, nil)
            end
        end
    else
        if self._task_leave_time ~= nil and _ED.user_frist_task ~= nil then
            self._task_leave_time = self._task_leave_time - dt
            if self._task_leave_time < 0 then
                protocol_command.check_task_time.param_list = _ED.user_frist_task.task_id
                NetworkManager:register(protocol_command.check_task_time.code, nil, nil, nil, nil, nil, false, nil)
            end
        end
    end

    if _ED.push_system_notice_info ~= nil 
        and table.nums(_ED.push_system_notice_info) > 0 
        and _ED.base_system_push_info ~= nil
        then
        for k,v in pairs(_ED.push_system_notice_info) do
            if v ~= nil and _ED.base_system_push_info[""..v] ~= nil then
                for index, info in pairs(_ED.base_system_push_info[""..v]) do
                    if info.havePush == nil or info.havePush == false then
                        local server_time = getCurrentGTM8Time()
                        local open_time = zstring.split(info.time, ":")
                        local leave_time = (tonumber(open_time[1]) - server_time.hour) * 3600 + (tonumber(open_time[2]) - server_time.min) * 60 + tonumber(open_time[3]) - server_time.sec
                        if leave_time <= 0 then
                            info.havePush = true
                            _ED.base_system_push_info[""..v][index].havePush = true
                            if leave_time >= -3 then
                                sendSystemInformation(info.pushId, info.params)
                            end
                        end
                    end
                    if info.havePush == true and index == table.nums(_ED.base_system_push_info[""..v]) then
                        _ED.push_system_notice_info[""..k] = nil
                        for k, timeInfo in pairs(_ED.base_system_push_info[""..v]) do
                            timeInfo.havePush = false
                        end
                        return
                    end
                end
            end
        end
    end

    if self._push_legion_total_time == nil then
        self._push_legion_total_time = dms.int(dms["union_config"], 60, union_config.param)           -- 弹出间隔时间
    end
    if getLegionAddPushState() == true then
        self._push_legion_time = self._push_legion_time + dt
        if self._push_legion_time >= self._push_legion_total_time then
            self._push_legion_time = 0
            protocol_command.get_union_create_info.param_list = ""
            NetworkManager:register(protocol_command.get_union_create_info.code, nil, nil, nil, nil, nil, false, nil)
        end
    end

    -- if self._city_shop_text_time ~= nil then
    --     local leave_time = self._city_shop_end_time - (current_time + _ED.time_add_or_sub)
    --     self._city_shop_text_time:setString(getRedAlertTimeFormat(leave_time))
    --     state_machine.excute("red_alert_time_mine_update_city_shop_time", 0, leave_time)
    -- end
end

function MainWindow:checkMission()
    local nCount = #fwin._list
    for i=1, nCount do
        local v = fwin._list[nCount - i + 1]
        if nil ~= v and v._view ~= nil and v._view == fwin._ui 
            and "redAlertTimeMineEventQueueMarchClass" ~= v.__cname
            and "redAlertTimeMineEventQueueStruckClass" ~= v.__cname
            and "redAlertTimeMineEventQueueDefenseClass" ~= v.__cname
            then
            return
        end
    end
    -- print("==11111111111===========")
    if missionIsOver() == false then
        -- print("==11111111111===========")
        -- executeNextEvent(nil, false)
    else

        if _ED.easy_now_scene_id > 0 then
            local sceneParam = "sc".._ED.scene_current_state[zstring.tonumber("".._ED.easy_now_scene_id)]..
                "m".._ED.scene_max_state[zstring.tonumber("".._ED.easy_now_scene_id)]
            if executeMissionExt(mission_mould_tuition, touch_off_mission_into_home, "".._ED.easy_now_scene_id, nil, true, sceneParam, true) == false then
            end
        end
        if missionIsOver() == false then
        else
            -- print("=======","l".._ED.user_info.user_grade.."e".._ED.user_info.user_experience)
            if executeMissionExt(mission_mould_tuition, nil, nil, nil, true, "l".._ED.user_info.user_grade, true) == false then
                if executeMissionExt(mission_mould_tuition, nil, nil, nil, true, "l".._ED.user_info.user_grade.."e".._ED.user_info.user_experience, true) == false then
                    -- print("=======","lb1v"..zstring.tonumber(_ED.home_build[""..1].level))
                    if executeMissionExt(mission_mould_tuition, nil, nil, nil, true, "lb1v"..zstring.tonumber(_ED.home_build[""..1].level), true) == false then
                        -- print("=======","lb9v"..zstring.tonumber(_ED.home_build[""..9].level))
                        if executeMissionExt(mission_mould_tuition, nil, nil, nil, true, "lb9v"..zstring.tonumber(_ED.home_build[""..9].level), true) == false then
                            -- print("=======","lb3v"..zstring.tonumber(_ED.home_build[""..3].level))
                            if executeMissionExt(mission_mould_tuition, nil, nil, nil, true, "lb3v"..zstring.tonumber(_ED.home_build[""..3].level), true) == false then
                                -- print("==333333333333===========")
                            end
                        end
                    end
                end
            end
        end
    end
end

function MainWindow:init()

    self:onInit()
    return self
end

function MainWindow:close( ... )
end

function MainWindow:onExit()
    state_machine.remove("main_window_show")
    state_machine.remove("main_window_hide")
    state_machine.remove("main_window_update_userinfo")
    state_machine.remove("main_window_open_tank_factory")
    state_machine.remove("main_window_open_scientific")
    state_machine.remove("main_window_manufacture_make")
    state_machine.remove("main_window_update_quick_info")
    state_machine.remove("main_window_buy_build_upgrade_pos")
    state_machine.remove("main_window_update_factor")
    state_machine.remove("main_window_open_recharge")
    state_machine.remove("main_window_update_resource")
    state_machine.remove("main_window_update_task_info")
    state_machine.remove("main_window_click_task")
    state_machine.remove("main_window_update_top_button")
    state_machine.remove("main_window_activity_open")
    state_machine.remove("main_window_check_mission")
    state_machine.remove("main_window_change_button_fun_state")
    state_machine.remove("main_window_update_fighting")
    state_machine.remove("main_window_update_gold_info")
    state_machine.remove("main_window_visible_func_button")
    state_machine.remove("red_envelopes_play") 
    state_machine.remove("red_horn_play")
    state_machine.remove("main_window_push_game_announcement")
    state_machine.remove("main_window_update_energy")
    state_machine.remove("main_window_update_boom_info")
    state_machine.remove("main_window_update_head_info")
    state_machine.remove("main_window_update_push")
    state_machine.remove("main_window_remove_list_button")
    state_machine.remove("main_window_open_rebels_window")
    state_machine.remove("main_window_update_rebels_window")
    state_machine.remove("main_window_push_activity")
    state_machine.remove("main_window_push_activity_timekeeping")
    state_machine.remove("main_window_push_treasure")
    state_machine.remove("main_window_push_treasure_timekeeping")
    state_machine.remove("main_window_update_timer")
    state_machine.remove("treasure_discount_store_push_update")  
    state_machine.remove("main_window_buy_city_energy")  
    state_machine.remove("main_window_update_city_energy_info")  
    state_machine.remove("main_window_sure_buy_city_energy")  
    state_machine.remove("main_window_goto_world_city") 
    state_machine.remove("treasure_carnival_hour_push_update")   
    state_machine.remove("main_window_update_formation_count")   
end