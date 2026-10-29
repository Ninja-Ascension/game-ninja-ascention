-- ----------------------------------------------------------------------------------------------------
-- 说明：日常
-------------------------------------------------------------------------------------------------------
DailyTask = class("DailyTaskClass", Window)

local daily_task_window_open_terminal = {
    _name = "daily_task_window_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("DailyTaskClass") then
            fwin:open(DailyTask:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local daily_task_window_close_terminal = {
    _name = "daily_task_window_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("DailyTaskClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(daily_task_window_open_terminal)
state_machine.add(daily_task_window_close_terminal)
state_machine.init()

function DailyTask:ctor()
    self.super:ctor()
    self.roots = {}
    self.group = {
        _task_page = nil,
        _achievement_page = nil
    }
    self.actions = {}

    self.chests = {}
    self.dailyTaskListView = nil 
    self.dailyTaskListViewPosY = nil
    self.achievementListView = nil 
    self.achievementListViewPosY = nil
    self.dailyTaskListViewUpdate = false

    self.drawRewardStates = {}

    self._showPage = 0

    -- Initialize daily task state machine.
    local function init_daily_task_terminal()
        local daily_task_close_terminal = {
            _name = "daily_task_close",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if nil ~= instance._back_terminal_name then
                    state_machine.excute(instance._back_terminal_name, 0, "")
                end 
		        if __lua_project_id == __lua_project_gragon_tiger_gate
                    -- or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
                    -- or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		            or __lua_project_id == __lua_project_red_alert
                    then
                    state_machine.excute("achieve_develop_close",0,"")
                    cacher.destoryRefPools()
                end
                fwin:close(fwin:find("UserTopInfoAClass"))
                fwin:close(instance)
                state_machine.excute("menu_clean_page_state", 0, "home")
                state_machine.excute("menu_back_home_page", 0, "") 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local daily_task_manager_terminal = {
            _name = "daily_task_manager",
            _init = function (terminal) 
                app.load("client.cells.dailytask.daily_task_list_cell")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if not _ED.local_quest_enabled and params._datas.next_terminal_name == "daily_task_daily_task" and true == funOpenDrawTip(86) then
                    if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                        terminal.select_button:setHighlighted(true)
                        terminal.select_button:setTouchEnabled(false)
                    end
                    return
                end
                if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                    terminal.select_button:setHighlighted(false)
                    terminal.select_button:setTouchEnabled(true)
                end
                if params._datas.current_button_name ~= nil or params._datas.current_button_name ~= "" then
                    terminal.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_button_name)
                end
                if params._datas.current_button_name == "Button_rcrw_1" then
                    instance._showPage = 1
                elseif params._datas.current_button_name == "Button_rcrw_2" then
                    instance._showPage = 2
                end
                if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                    terminal.select_button:setHighlighted(true)
                    terminal.select_button:setTouchEnabled(false)
                end

                -- DSC重塑
                if __lua_project_id == __lua_project_l_digital then
                    -- 日常任务
                    local Text_rcrw_2_1 = ccui.Helper:seekWidgetByName(instance.roots[1], "Text_rcrw_2_1")
                    -- 主线任务
                    local Text_rcrw_1_1 = ccui.Helper:seekWidgetByName(instance.roots[1], "Text_rcrw_1_1")
                    if Text_rcrw_2_1 ~= nil and Text_rcrw_1_1 ~= nil then
                        if params._datas.current_button_name == "Button_rcrw_2" then
                            -- 日常任务
                            Text_rcrw_2_1:setVisible(true)
                            Text_rcrw_1_1:setVisible(false)
                        elseif params._datas.current_button_name == "Button_rcrw_1" then
                            -- 主线任务
                            Text_rcrw_1_1:setVisible(true)
                            Text_rcrw_2_1:setVisible(false)
                        end
                    end
                end
                
                if terminal.last_terminal_name ~= params._datas.next_terminal_name then
                    terminal.last_terminal_name = params._datas.next_terminal_name
                    state_machine.excute(params._datas.next_terminal_name, 0, params)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        -- 进入日常任务页面
        local daily_task_daily_task_terminal = {
            _name = "daily_task_daily_task",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
			--print("进入日常任务页面")
                -- instance:showDailyTaskPage()
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    then
                    instance:showDailyTaskPage()
                else
    				cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
    				cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, instance.showDailyTaskPage, instance)
                    ccui.Helper:seekWidgetByName(instance.roots[1], "Image_rcrw_9"):setVisible(true)
    				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_rcrw_4"):setVisible(false)
                end
                local Button_yjlq = ccui.Helper:seekWidgetByName(instance.roots[1], "Button_yjlq")
                if nil ~= Button_yjlq then
                    if not funOpenDrawTip(204,false) then 
                        Button_yjlq:setVisible(true)
                    else
                        Button_yjlq:setVisible(false)
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        -- 进入成就页面
        local daily_task_achievement_terminal = {
            _name = "daily_task_achievement",
            _init = function (terminal) 
                app.load("client.cells.achievement.achievement_list_cell")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
			--print("进入成就页面")
                -- instance:showAchievementPage()
                if instance._showPage == 2 then
                    if nil ~= params and params.refresh == true then
                        state_machine.excute("plot_task_window_close", 0, 0)
                        instance.group._achievement_page = nil
                    end
                    
                    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
                        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
                        then
                        instance:showAchievementPage()
                    else
        				cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
        				cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, instance.showAchievementPage, instance)
                        ccui.Helper:seekWidgetByName(instance.roots[1], "Image_rcrw_9"):setVisible(false)
        				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_rcrw_4"):setVisible(true)
                    end
                    local Button_yjlq = ccui.Helper:seekWidgetByName(instance.roots[1], "Button_yjlq")
                    if nil ~= Button_yjlq then
                        Button_yjlq:setVisible(false)
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 进入更新页面的积分信息
        local daily_task_update_draw_daily_task_integral_terminal = {
            _name = "daily_task_update_draw_daily_task_integral",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDrawDailyTaskIntegral()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 今天取成就后，需要重新绘制成就列表
        local daily_task_update_draw_achievement_list_view_terminal = {
            _name = "daily_task_update_draw_achievement_list_view",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_gragon_tiger_gate 
        			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        			or __lua_project_id == __lua_project_red_alert 
        			then
                else
                    if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                        instance:updateDrawAchievementListView()
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local daily_task_open_draw_reward_terminal = {
            _name = "daily_task_open_draw_reward",
            _init = function (terminal) 
                app.load("client.activity.dailytask.DailyTaskIntegralRewardDailog")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if fwin:find("DailyTaskIntegralRewardDailogClass") ~= nil then
                    return
                end
                local index = params._datas.index
                fwin:open(DailyTaskIntegralRewardDailog:new():init(index, instance.drawRewardStates[index], nil), fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local daily_task_open_draw_update_terminal = {
            _name = "daily_task_open_draw_update",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
                    instance:updateDrawChestState()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local daily_task_show_oen_key_draw_button_terminal = {
            _name = "daily_task_show_oen_key_draw_button",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
                    instance:showOneKeyDrawButton()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local daily_task_oen_key_draw_reward_terminal = {
            _name = "daily_task_oen_key_draw_reward",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
                    instance:oneKeyDrawReward()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local daily_task_update_daily_list_terminal = {
            _name = "daily_task_update_daily_list",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.dailyTaskListView ~= nil then
                    if instance._showPage == 1 then
                        local posY = zstring.tonumber(instance.dailyTaskListViewPosY)
                        instance:initDailyTaskPage()
                        instance.dailyTaskListView:getInnerContainer():setPositionY(posY)  
                        instance.dailyTaskListViewUpdate = true
                        instance.dailyTaskListViewPosY = instance.dailyTaskListViewPosY - 1
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 无任务时的显示处理
        local daily_task_empty_list_terminal = {
            _name = "daily_task_empty_list",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.dailyTaskListView ~= nil then
                    local mSender = params.mSender
                    instance:showEmptyTip(mSender)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(daily_task_close_terminal)
        state_machine.add(daily_task_manager_terminal)
        state_machine.add(daily_task_daily_task_terminal)
        state_machine.add(daily_task_achievement_terminal)
        state_machine.add(daily_task_update_draw_daily_task_integral_terminal)
        state_machine.add(daily_task_update_draw_achievement_list_view_terminal)
        state_machine.add(daily_task_open_draw_reward_terminal)
        state_machine.add(daily_task_open_draw_update_terminal)
        state_machine.add(daily_task_show_oen_key_draw_button_terminal)
        state_machine.add(daily_task_oen_key_draw_reward_terminal)
        state_machine.add(daily_task_update_daily_list_terminal)
        state_machine.add(daily_task_empty_list_terminal)
        state_machine.init()
    end
    
    -- call func init daily task state machine.
    init_daily_task_terminal()
end

function DailyTask:init(params)
    self._back_terminal_name = params.back_terminal_name
    return self;
end

function DailyTask:showOneKeyDrawButton()
    local root = self.roots[1]
    -- 一键领取
    local Button_yjlq = ccui.Helper:seekWidgetByName(root, "Button_yjlq")
    if nil ~= Button_yjlq then
        if not funOpenDrawTip(204,false) then 
            Button_yjlq:setVisible(true)
        else
            Button_yjlq:setVisible(false)
        end
        local items = self.dailyTaskListView:getItems()
        local is_show = false
        if nil == items or #items == 0 then

        else
            local ids = ""
            for i, v in pairs(items) do
                if v.drawState == 1 then
                    if #ids > 0 then
                        ids = ids .. ","
                    end
                    if v.userDailyTask.daily_task_id ~= nil
                        or v.userDailyTask.month_card_id ~= nil 
                        or v.userDailyTask.dinner_time_id ~= nil 
                        then
                        is_show = true
                        break
                    end
                end
            end
        end
        if is_show == true then
            Button_yjlq:setBright(true)
            Button_yjlq:setTouchEnabled(true)
        else
            Button_yjlq:setBright(false)
            Button_yjlq:setTouchEnabled(false)
        end
    end
end

function DailyTask:oneKeyDrawReward(  )
    local items = self.dailyTaskListView:getItems()
    if nil == items or #items == 0 then
        return
    end

    local ids = ""
    local command_list = {}
    for i, v in pairs(items) do
        if v.drawState == 1 then
            if #ids > 0 then
                ids = ids .. ","
            end
            if v.userDailyTask.daily_task_id ~= nil then
                ids = ids .. v.userDailyTask.daily_task_id
            elseif v.userDailyTask.month_card_id ~= nil then
                local info = {}
                info.param_list = ""..v.userDailyTask.month_card_id
                info.command = protocol_command.draw_month_card_reward
                table.insert(command_list, info)
            elseif v.userDailyTask.dinner_time_id ~= nil then
                local info = {}
                info.param_list = ""..v.userDailyTask.dinner_time_id
                info.command = protocol_command.dinner_time
                table.insert(command_list, info)
            end
        end
    end

    if ids ~= "" then
        local info = {}
        info.param_list = "" .. ids
        info.command = protocol_command.draw_daily_mission_reward
        table.insert(command_list, info)
    end
    
    if #command_list == 0 then
        return
    end

    local function responseDrawDailyMissionCallback(response)
        state_machine.unlock("daily_task_oen_key_draw_reward")
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                app.load("client.reward.DrawRareReward")
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                    checkRewardObtainDraw()
                else
                    local getRewardWnd = DrawRareReward:new()
                    getRewardWnd:init(42)
                    fwin:open(getRewardWnd, fwin._ui)
                end

                if response.node ~= nil and  response.node.roots ~= nil then
                    response.node.group._task_page = nil
                    response.node.dailyTaskListView:removeAllItems()
                    state_machine.excute("daily_task_daily_task", 0, 0)
                end  
                state_machine.excute("daily_task_show_oen_key_draw_button", 0, 0)
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                    -- 检查教学 
                    if zstring.tonumber(_ED.user_info.last_user_grade) ~= zstring.tonumber(_ED.user_info.user_grade) then
                        app.load("client.battle.BattleLevelUp")
                        local win = fwin:find("BattleLevelUpClass")
                        if nil ~= win then
                            fwin:close(win)
                        end
                        fwin:open(BattleLevelUp:new(), fwin._windows)

                        _ED.user_info.last_user_grade = _ED.user_info.user_grade
                        if executeMissionExt(mission_mould_tuition, touch_off_mission_ls_scene, "".._ED.user_info.user_grade, nil, false, nil, false) == false then
                            
                        end
                        if missionIsOver() == false then
                            local windowLock = fwin:find("WindowLockClass")
                            if windowLock == nil then
                                fwin:open(WindowLock:new():init(), fwin._windows)
                            end
                            fwin:close(fwin:find("MoppingResultsClass"))
                            -- 回到主页
                            fwin:close(fwin:find("DailyTaskClass"))
                            cacher.removeAllTextures()
                            fwin:reset(nil)

                            app.load("client.home.Menu")
                            fwin:open(Menu:new(), fwin._taskbar)
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
                            executeNextEvent(nil, true)
                            return
                        end        
                    end
                end
            end
        end
    end

    state_machine.lock("daily_task_oen_key_draw_reward")

    local index = 1
    local function responseCommandCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                local info = command_list[index]
                if info ~= nil then
                    if index < #command_list then
                        info.command.param_list = info.param_list
                        NetworkManager:register(info.command.code, nil, nil, nil, response.node, responseCommandCallback, false, nil)
                    else
                        info.command.param_list = info.param_list
                        NetworkManager:register(info.command.code, nil, nil, nil, response.node, responseDrawDailyMissionCallback, false, nil)
                    end
                    index = index + 1
                end
            else
                state_machine.unlock("daily_task_oen_key_draw_reward")
            end
        else
            state_machine.unlock("daily_task_oen_key_draw_reward")
        end
    end

    _ED.user_info.last_user_food = _ED.user_info.user_food
    _ED.show_reward_list_group_ex = {}
    responseCommandCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0, node = self})

    -- protocol_command.draw_daily_mission_reward.param_list = "" .. ids
    -- NetworkManager:register(protocol_command.draw_daily_mission_reward.code, nil, nil, nil, self, responseDrawDailyMissionCallback, false, nil)
end

function DailyTask:updateDrawChestState()
    if __lua_project_id == __lua_project_gragon_tiger_gate 
    	-- or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
    	-- or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
    	or __lua_project_id == __lua_project_red_alert 
    	then
        self:initIntegralChest()
    else
        for i, v in pairs(self.chests) do
            state_machine.excute("daily_task_integral_chest_update_draw", 0, v)
        end
    end
end

function DailyTask:updateDrawAchievementListView()
    local root = self.roots[1]
    local achievementListView = ccui.Helper:seekWidgetByName(root, "ListView_rcrw_0")
    achievementListView:removeAllItems()
    self:initAchievementPage()
end

function DailyTask:updateDrawDailyTaskIntegral()
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then
        return
    end
    local root = self.roots[1]
    -- 绘制总积分
    local Text_jifen_v = ccui.Helper:seekWidgetByName(root, "Text_jifen_v")
    if Text_jifen_v ~= nil then
        Text_jifen_v:setString("".._ED.daily_task_integral)
    end

    -- 更新宝箱状态
    self:updateDrawChestState()
	
	-- 积分的进度
    local LoadingBar_1 = ccui.Helper:seekWidgetByName(root, "LoadingBar_1")
    if LoadingBar_1 ~= nil then
        local currentIntegral = zstring.tonumber(_ED.daily_task_integral)
        local maxIntegral = 120
        if __lua_project_id == __lua_project_gragon_tiger_gate 
        	or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        	or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
        	or __lua_project_id == __lua_project_red_alert 
        	then
            local persent = math.floor(currentIntegral*100/140)
            LoadingBar_1:setPercent(persent)
        else
            LoadingBar_1:setPercent(currentIntegral / 120 * 95)
        end
    end
end

function DailyTask:initIntegralChestEX()
    local root = self.roots[1]
    self.drawRewardStates = {}
    local config_data = {
        {"Button_reward_1_c", "Button_reward_1_r", "Button_reward_1_o"},
        {"Button_reward_2_c", "Button_reward_2_r", "Button_reward_2_o"},
        {"Button_reward_3_c", "Button_reward_3_r", "Button_reward_3_o"},
        {"Button_reward_4_c", "Button_reward_4_r", "Button_reward_4_o"},
    }

    for i=1,4 do
        local currentIntegral = zstring.tonumber(_ED.daily_task_integral)
        local rewardElement = dms.element(dms["liveness_reward"], i)
        local drawState = zstring.tonumber(_ED.daily_task_draw_index[i])
        local needIntegral = zstring.tonumber(dms.atoi(rewardElement, liveness_reward.need_liveness))
        local Text_jifen = ccui.Helper:seekWidgetByName(root, "Text_jifen_0"..i)
        if Text_jifen ~= nil then
            if __lua_project_id == __lua_project_gragon_tiger_gate 
        		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        		or __lua_project_id == __lua_project_red_alert 
        		then
                Text_jifen:setString(""..needIntegral.."".._string_piece_info[408])
            else
                Text_jifen:setString(""..needIntegral.."".._string_piece_info[267])
            end
        end
        
        local btn1 = ccui.Helper:seekWidgetByName(root, config_data[i][1])
        local btn2 = ccui.Helper:seekWidgetByName(root, config_data[i][2])
        local btn3 = ccui.Helper:seekWidgetByName(root, config_data[i][3])

        if btn1 ~= nil then
            btn1:setVisible(false)
        end
        if btn2 ~= nil then
            btn2:setVisible(false)
        end
        if btn3 ~= nil then
            btn3:setVisible(false)
        end

        if needIntegral > currentIntegral then
            drawState = 0
            if btn1 ~= nil then
                btn1:setVisible(true)
            end
        else
            if drawState == 0 then
                drawState = 1
                if btn2 ~= nil then
                    btn2:setVisible(true)
                end
            else
                drawState = 2
                if btn3 ~= nil then
                    btn3:setVisible(true)
                end
            end
        end
        table.insert(self.drawRewardStates, drawState)
    end
end

function DailyTask:initIntegralChest()
    if __lua_project_id == __lua_project_gragon_tiger_gate 
    	-- or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
    	-- or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
    	or __lua_project_id == __lua_project_red_alert 
    	then
        self:initIntegralChestEX()
        return
    end
    app.load("client.cells.dailytask.daily_task_integral_chest")
    local root = self.roots[1]
    local chestNames = {
        "Panel_jfjl_1",
        "Panel_jfjl_2",
        "Panel_jfjl_3",
        "Panel_jfjl_4",
    }

    for i = 1, 4 do
        local cell = DailyTaskIntegralChest:createCell()
        local cellPad = ccui.Helper:seekWidgetByName(root, chestNames[i])
        if cellPad ~= nil then
            cell:init(i)
            cellPad:addChild(cell)
            table.insert(self.chests, cell)
        end
    end
end

function DailyTask:initDailyTaskPage()
    if not _ED.local_quest_enabled and funOpenDrawTip(86, false) == true then
        return
    end
    state_machine.excute("plot_task_window_close", 0, 0)
    self.group._achievement_page = nil
    local root = self.roots[1]
    local dailyTaskListView = ccui.Helper:seekWidgetByName(root, "ListView_rcrw")
    dailyTaskListView:jumpToTop()
    dailyTaskListView:removeAllItems()
    local uncompItems = {}
    local drawItems = {}
    local closeItems = {}
    local index = 1

    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        -- 月卡重塑对于老月卡改为表控制
        local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 1000)
        if _ED.local_quest_enabled or (activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2) then
        else
            local _drawMonth = dms.searchs(dms["top_up_goods"], top_up_goods.goods_type, 1)
            if tonumber(_ED.month_card[_drawMonth[1][1]].surplus_month_card_time) > 0 then
                local name = _daily_mission_param[1][2]
                local icon = _daily_mission_param[1][1]
                local rewardData = _daily_mission_param[1][4]
                local description = ""
                local description_info = zstring.split(_daily_mission_param[1][3],"|")
                if tonumber(_ED.month_card[_drawMonth[1][1]].surplus_month_card_time) == 0 then
                    description = description_info[1]
                else
                    description_info[2] = string.format(description_info[2],zstring.tonumber(_ED.month_card[_drawMonth[1][1]].surplus_month_card_time))
                    description = description_info[1]..description_info[2] 
                end
                if tonumber(_ED.month_card[_drawMonth[1][1]].draw_month_card_state) == 0 then
                    local cellcard1= DailyTaskListCell:createCell()
                    cellcard1:init(1, {daily_task_complete_count = "1", daily_task_param = "0", month_card_id = _drawMonth[1][1]}, dailyTaskListView, 0, "1\t"..name.."\t"..description.."\t"..icon.."\t25\t1\t"..rewardData.."\t1\t999\t372\t2")
                    -- dailyTaskListView:addChild(cellcard1)
                    table.insert(drawItems, cellcard1)
                else
                    local cellcard1= DailyTaskListCell:createCell()
                    cellcard1:init(1, {daily_task_complete_count = "1", daily_task_param = "1", month_card_id = _drawMonth[1][1]}, dailyTaskListView, 0, "1\t"..name.."\t"..description.."\t"..icon.."\t25\t1\t"..rewardData.."\t1\t999\t372\t2")
                    -- dailyTaskListView:addChild(cellcard1)
                    table.insert(closeItems, cellcard1)
                end
            else
                local name = _daily_mission_param[1][2]
                local icon = _daily_mission_param[1][1]
                local rewardData = _daily_mission_param[1][4]
                local description = ""
                local description_info = zstring.split(_daily_mission_param[1][3],"|")
                if tonumber(_ED.month_card[_drawMonth[1][1]].surplus_month_card_time) == 0 then
                    description = description_info[1]
                else
                    description_info[2] = string.format(description_info[2],zstring.tonumber(_ED.month_card[_drawMonth[1][1]].surplus_month_card_time))
                    description = description_info[1]..description_info[2] 
                end
                local cellcard1= DailyTaskListCell:createCell()
                cellcard1:init(1, {daily_task_complete_count = "0", daily_task_param = "0", month_card_id = _drawMonth[1][1]}, dailyTaskListView, 0, "1\t"..name.."\t"..description.."\t"..icon.."\t25\t1\t"..rewardData.."\t1\t999\t372\t2")
                -- dailyTaskListView:addChild(cellcard1)   
                table.insert(uncompItems, cellcard1) 
            end

            if tonumber(_ED.month_card[_drawMonth[2][1]].surplus_month_card_time) > 0 then
                local name = _daily_mission_param[2][2]
                local icon = _daily_mission_param[2][1]
                local rewardData = _daily_mission_param[2][4]
                local description = ""
                local description_info = zstring.split(_daily_mission_param[2][3],"|")
                if tonumber(_ED.month_card[_drawMonth[2][1]].surplus_month_card_time) == 0 then
                    description = description_info[1]
                else
                    description_info[2] = string.format(description_info[2],zstring.tonumber(_ED.month_card[_drawMonth[2][1]].surplus_month_card_time))
                    description = description_info[1]..description_info[2] 
                end
                if tonumber(_ED.month_card[_drawMonth[2][1]].draw_month_card_state) == 0 then
                    local cellcard2= DailyTaskListCell:createCell()
                    cellcard2:init(1, {daily_task_complete_count = "1", daily_task_param = "0", month_card_id = _drawMonth[2][1]}, dailyTaskListView, 0, "1\t"..name.."\t"..description.."\t"..icon.."\t25\t1\t"..rewardData.."\t1\t999\t372\t3")
                    -- dailyTaskListView:addChild(cellcard2)
                    table.insert(drawItems, cellcard2)
                else
                    local cellcard2= DailyTaskListCell:createCell()
                    cellcard2:init(1, {daily_task_complete_count = "2", daily_task_param = "1", month_card_id = _drawMonth[2][1]}, dailyTaskListView, 0, "1\t"..name.."\t"..description.."\t"..icon.."\t25\t1\t"..rewardData.."\t1\t999\t372\t3")
                    -- dailyTaskListView:addChild(cellcard2)
                    table.insert(closeItems, cellcard2)
                end
            else
                local name = _daily_mission_param[2][2]
                local icon = _daily_mission_param[2][1]
                local rewardData = _daily_mission_param[2][4]
                local description = ""
                local description_info = zstring.split(_daily_mission_param[2][3],"|")
                if tonumber(_ED.month_card[_drawMonth[2][1]].surplus_month_card_time) == 0 then
                    description = description_info[1]
                else
                    description_info[2] = string.format(description_info[2],zstring.tonumber(_ED.month_card[_drawMonth[2][1]].surplus_month_card_time))
                    description = description_info[1]..description_info[2] 
                end
                local cellcard2= DailyTaskListCell:createCell()
                cellcard2:init(1, {daily_task_complete_count = "0", daily_task_param = "0", month_card_id = _drawMonth[2][1]}, dailyTaskListView, 0, "1\t"..name.."\t"..description.."\t"..icon.."\t25\t1\t"..rewardData.."\t1\t999\t372\t3")
                -- dailyTaskListView:addChild(cellcard2)
                table.insert(uncompItems, cellcard2) 
            end   
        end
        --领取体力的
        local energyData = zstring.split(dms.string(dms["activity_config"], 1, activity_config.param), "|")
        local add_enger_info = zstring.split(_ED._add_enger_info,"|")
        for i=1, 4 do
            local name = _daily_mission_param[i+2][2]
            local icon = _daily_mission_param[i+2][1]
            local rewardData = _daily_mission_param[i+2][4]

            local energy_info = zstring.split(energyData[i], ",")
            local add_enger_data = zstring.split(add_enger_info[i],",")
            local current = _ED.system_time + (os.time() - _ED.native_time)
            local earlyMorning1 = tonumber(zstring.split(energy_info[1], ":")[1])*3600
            local earlyMorning2 = tonumber(zstring.split(energy_info[2], ":")[1])*3600
            local temp = os.date("*t", getBaseGTM8Time(zstring.tonumber(current)))
            local m_hour    = tonumber(string.format("%02d", temp.hour))
            local m_min     = tonumber(string.format("%02d", temp.min))
            local m_sec     = tonumber(string.format("%02d", temp.sec))
            local newTimes = m_hour*3600+m_min*60+m_sec
            local createUserData = os.date("*t", getBaseGTM8Time(zstring.tonumber(_ED.user_info.create_time)))
            local createUserTimes = zstring.tonumber(string.format("%02d", createUserData.hour))*3600 + tonumber(string.format("%02d", createUserData.min))*60 + tonumber(string.format("%02d", createUserData.sec))
            if createUserData.year ~= temp.year
                or createUserData.month ~= temp.month
                or createUserData.day ~= temp.day
                or createUserTimes <= earlyMorning2 then
                if newTimes >= earlyMorning1 and newTimes <= earlyMorning2 then
                    if tonumber(add_enger_data[1]) == 0 then
                        local strs = string.format(activity_add_energy_tips[i],(energy_info[1].."-"..energy_info[2]))
                        local cellnew = DailyTaskListCell:createCell()
                        cellnew:init(1, {daily_task_complete_count = "1", daily_task_param = "0", dinner_time_id = i}, dailyTaskListView, 0, "1\t"..name.."\t"..strs.."\t"..icon.."\t25\t1\t"..rewardData.."\t1\t999\t-1\t1\t"..i)
                        dailyTaskListView:addChild(cellnew)
                        break
                    end
                end
            end
        end
    end

    for i, v in ipairs(_ED.daily_task_info) do
        local opened = true
        local by_open_vip = 0
        local dailyTaskMould = dms.element(dms["daily_mission_param"], v.daily_task_mould_id)
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            if dailyTaskMould == nil then
                opened = false
            end
            local dailyTaskTrace = dms.atoi(dailyTaskMould, daily_mission_param.trace_function_id)
            local ntype = dms.atoi(dailyTaskMould, daily_mission_param.ntype)
            -- local openFunctionId = dms.int(dms["function_param"], dailyTaskTrace, function_param.open_function)
            -- if nil == openFunctionId or openFunctionId > 0 and funOpenDrawTip(openFunctionId, false) == false then
            --     opened = true
            -- end
            local dailyTaskCondition = dms.atoi(dailyTaskMould, daily_mission_param.mission_condition)
            local aimConditionId = dms.int(dms["user_config"], 26 ,user_config.param)
            if aimConditionId and dailyTaskCondition == aimConditionId and getWatchAdFuncOpenState() == false then 
                -- 观看广告
                opened = false
            elseif ntype == 1 then
                opened = false
            else 
                if zstring.tonumber(dailyTaskTrace) > 0 then
                    local open_function = dms.int(dms["function_param"], dailyTaskTrace, function_param.open_function)
                    local open_leve=dms.int(dms["function_param"], dailyTaskTrace, function_param.open_leve)
                    local sceneId=dms.int(dms["function_param"], dailyTaskTrace, function_param.open_scene)
                    local npcId=dms.int(dms["function_param"], dailyTaskTrace, function_param.open_npc)
                    by_open_vip=dms.int(dms["function_param"], dailyTaskTrace, function_param.by_open_vip)

                    if open_leve > zstring.tonumber(_ED.user_info.user_grade)
                        or by_open_vip > tonumber(_ED.vip_grade)
                        or (nil ~= sceneId and sceneId > 0 and tonumber(_ED.scene_current_state[sceneId]) < 0)
                        or (nil ~= npcId and npcId > 0 and tonumber(_ED.npc_state[npcId]) <= 0)
                        or (funOpenDrawTip(open_function, false) and tonumber(open_function) > 0 )
                        then
                        opened = false
                    end
                end
            end
        else
            opened = true
        end
        if true == opened then
            local cell = DailyTaskListCell:createCell()
            if __lua_project_id == __lua_project_gragon_tiger_gate 
        		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
                or __lua_project_id == __lua_project_red_alert 
                or __lua_project_id == __lua_project_digimon_adventure 
    	        or __lua_project_id == __lua_project_naruto
                or __lua_project_id == __lua_project_yugioh
                or __lua_project_id == __lua_project_pokemon 
                or __lua_project_id == __lua_project_rouge
                or __lua_project_id == __lua_project_warship_girl_b 
                then
                cell:init(1, v, dailyTaskListView,i,nil,by_open_vip)
            else
                cell:init(1, v, dailyTaskListView)
            end
    		local drawState = -1

    		local conditionParam = zstring.split(dms.atos(dailyTaskMould, daily_mission_param.condition_param), ",")
    		local needCompleteCount =  zstring.tonumber(conditionParam[#conditionParam])
    		local completeCount = zstring.tonumber(v.daily_task_complete_count)
    		local drawRewardState = zstring.tonumber(v.daily_task_param)
    		
    		if drawRewardState == 0 then
    			if completeCount >= needCompleteCount then
    				drawState = 1
    			else
    				drawState = 0
    			end
    		else
    			drawState = 2
    		end
    		
            if drawState == 0 then
                table.insert(uncompItems, cell)
            elseif drawState == 1 then
                table.insert(drawItems, cell)
            elseif drawState == 2 then
                -- table.insert(closeItems, cell)
            end
            -- local drawRewardState = zstring.tonumber(v.daily_task_param)
            -- if drawRewardState == 1 then
            --     table.insert(closeItems, cell)
            -- else
            --     dailyTaskListView:addChild(cell)
            -- end
        end
    end
    local index = 0
    for i, v in pairs(drawItems) do
        index = index + 1
        dailyTaskListView:addChild(v)
        v:sortUpdateInfo(index)
    end
    for i, v in pairs(uncompItems) do
        index = index + 1
        dailyTaskListView:addChild(v)
        v:sortUpdateInfo(index)
    end
    for i, v in pairs(closeItems) do
        index = index + 1
        dailyTaskListView:addChild(v)
        v:sortUpdateInfo(index)
    end
    dailyTaskListView:requestRefreshView()
    
    self.dailyTaskListView = dailyTaskListView 
    self.dailyTaskListViewPosY = dailyTaskListView:getInnerContainer():getPositionY()
    self:initIntegralChest()
    -- 绘制总积分
    self:updateDrawDailyTaskIntegral()
    self:showOneKeyDrawButton()
    -- 无任务时,添加提示
    state_machine.excute("daily_task_empty_list",0,{mSender = dailyTaskListView})
end

-- 无任务时,添加提示    
function DailyTask:showEmptyTip(sender)
    local root = self.roots[1]
    local Image_empty = ccui.Helper:seekWidgetByName(root, "Image_empty")
    if Image_empty then 
        local taskNum = sender:getChildren()
        if #taskNum > 0 then 
            Image_empty:setVisible(false)
        else
            Image_empty:setVisible(true)
        end
    end
end

function DailyTask:onUpdate()
    if __lua_project_id == __lua_project_gragon_tiger_gate 
    	or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
	    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
        or __lua_project_id == __lua_project_red_alert 
        or __lua_project_id == __lua_project_digimon_adventure 
	    or __lua_project_id == __lua_project_naruto
        or __lua_project_id == __lua_project_yugioh
        or __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge
        or __lua_project_id == __lua_project_warship_girl_b 
        then
        self:onUpdateDailyPage()
        -- self:onUpdateAchievementPage()
    end
end

function DailyTask:onUpdateDailyPage()
    if self.dailyTaskListView ~= nil then
        local size = self.dailyTaskListView:getContentSize()
        local posY = self.dailyTaskListView:getInnerContainer():getPositionY()
        if self.dailyTaskListViewPosY == posY then
            return
        end
        self.dailyTaskListViewPosY = posY
        local items = self.dailyTaskListView:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end

        if self.dailyTaskListViewUpdate == true then
            self.dailyTaskListViewPosY = self.dailyTaskListViewPosY + 1
        end
    end
end

function DailyTask:onUpdateAchievementPage()
    if __lua_project_id == __lua_project_gragon_tiger_gate 
    	or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
    	or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
    	or __lua_project_id == __lua_project_red_alert 
    	then
    else
        if self.achievementListView ~= nil then
            local size = self.achievementListView:getContentSize()
            local posY = self.achievementListView:getInnerContainer():getPositionY()
            if self.achievementListViewPosY== posY then
                return
            end
            self.achievementListViewPosY = posY
            local items = self.achievementListView:getItems()
            if items[1] == nil then
                return
            end
            local itemSize = items[1]:getContentSize()
            for i, v in pairs(items) do
                local tempY = v:getPositionY() + posY
                if tempY + itemSize.height * 3 < 0 or tempY > size.height + itemSize.height * 3 then
                    v:unload()
                else
                    v:reload()
                end
            end
        end
    end
end

function DailyTask:clearPageInfo( showDailyTask )
    local root = self.roots[1]
    local dailyTaskListView = ccui.Helper:seekWidgetByName(root, "ListView_rcrw")
    dailyTaskListView:jumpToTop()
    dailyTaskListView:removeAllItems()
    self.group._task_page = nil
end

function DailyTask:showDailyTaskPage()
    local root = self.roots[1]
    if self.group._task_page == nil then
        self.group._task_page = ccui.Helper:seekWidgetByName(root, "Panel_165")
        self:initDailyTaskPage()
    end
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
        then
        self.group._task_page = self.dailyTaskListView
        self.group._task_page:setVisible(true)
    end
    if self.group._achievement_page ~= nil then
        self.group._achievement_page:setVisible(false)
        if __lua_project_id == __lua_project_gragon_tiger_gate 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
            state_machine.excute("achieve_develop_hidden_show",0,false)
        end
    end

end

function DailyTask:initAchievementPageEX()
    app.load("client.cells.achievement.achievement_list_cellEx")
    local root = self.roots[1]
    local achievementListView = ccui.Helper:seekWidgetByName(root, "ListView_rcrw_0")
    achievementListView:removeAllItems()
    local uncompItems = {}
    local drawItems = {}
    local closeItems = {}
    local index = 1
    for i, v in pairs(_ED.daily_task_achievement) do
        local isShow = false
        if __lua_project_id == __lua_project_gragon_tiger_gate 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
            if tonumber(v.daily_task_mould_id) ~= 947 or (tonumber(v.daily_task_mould_id) == 947 and open_share_fun == 1) then
                isShow = true
            end
        else
            isShow = true
        end
        if isShow == true then
            local cell = AchievementListCellEx:createCell()
            local tcell, drawState = cell:init(2, v, achievementListView,i)
            --achievementListView:addChild(cell)
            if drawState == 0 then
                table.insert(uncompItems, cell)
            elseif drawState == 1 then
                table.insert(drawItems, cell)
            elseif drawState == 2 then
                table.insert(closeItems, cell)
            end
        end
    end
    for i, v in pairs(drawItems) do
        achievementListView:addChild(v)
    end
    for i, v in pairs(uncompItems) do
        achievementListView:addChild(v)
    end
    for i, v in pairs(closeItems) do
        achievementListView:addChild(v)
    end
    achievementListView:requestRefreshView()
    self.achievementListView = achievementListView 
    self.achievementListViewPosY = achievementListView:getInnerContainer():getPositionY()
end

function DailyTask:initAchievementPage()
    if __lua_project_id == __lua_project_gragon_tiger_gate 
    	or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
    	or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
    	or __lua_project_id == __lua_project_red_alert 
    	then
        self:initAchievementPageEX()
        return
    end
    app.load("client.cells.achievement.achievement_list_cell")
    local root = self.roots[1]
    local achievementListView = ccui.Helper:seekWidgetByName(root, "ListView_rcrw_0")
    local uncompItems = {}
    local drawItems = {}
    local closeItems = {}
    local index = 1
    for i, v in pairs(_ED.daily_task_achievement) do
        local cell = AchievementListCell:createCell()
        local tcell, drawState = cell:init(2, v, achievementListView)
        --achievementListView:addChild(cell)
        if drawState == 0 then
            table.insert(uncompItems, cell)
        elseif drawState == 1 then
            table.insert(drawItems, cell)
        elseif drawState == 2 then
            table.insert(closeItems, cell)
        end
    end
    for i, v in pairs(drawItems) do
        achievementListView:addChild(v)
    end
    for i, v in pairs(uncompItems) do
        achievementListView:addChild(v)
    end
    for i, v in pairs(closeItems) do
        achievementListView:addChild(v)
    end
    achievementListView:requestRefreshView()
end

function DailyTask:showAchievementPage()
    local root = self.roots[1]
    if self.group._achievement_page == nil then
        if  __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
            or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
            then
            self:clearPageInfo(true)
            app.load("client.activity.dailytask.PlotTaskWindow")
            state_machine.excute("plot_task_window_open", 0, 0)
            self.group._achievement_page = fwin:find("PlotTaskWindowClass")
        elseif __lua_project_id == __lua_project_gragon_tiger_gate
            or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
            or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
	        or __lua_project_id == __lua_project_red_alert 
            then
            app.load("client.activity.dailytask.newachieve.AchieveDevelop")
            self.group._achievement_page = AchieveDevelop:new()
            self.group._achievement_page:init()
            fwin:open(self.group._achievement_page,fwin._view)
        else
            self.group._achievement_page = ccui.Helper:seekWidgetByName(root, "ListView_rcrw_0")
            self:initAchievementPage()
        end
    end
    self.group._achievement_page:setVisible(true)
    if __lua_project_id == __lua_project_gragon_tiger_gate
        or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
	    or __lua_project_id == __lua_project_red_alert 
        then
        state_machine.excute("achieve_develop_hidden_show",0,true)
    end
    if self.group._task_page ~= nil then
        self.group._task_page:setVisible(false)
    end
end

function DailyTask:onEnterTransitionFinish()
    app.load('client.utils.ActionUtils')

    local csbDailyTask = csb.createNode("activity/DailyTasks/dailytasks.csb")
    self:addChild(csbDailyTask)

    -- 绘制顶部用户信息
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
    else
        app.load("client.player.UserInformationHeroStorage") 
        fwin:open(UserInformationHeroStorage:new(),fwin._view)
    end
    local root = csbDailyTask:getChildByName("root")
    table.insert(self.roots, root)

    if __lua_project_id == __lua_project_gragon_tiger_gate 
        or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        or __lua_project_id == __lua_project_red_alert 
        then
        -- local action = csb.createTimeline("activity/DailyTasks/dailytasks.csb") 
        -- table.insert(self.actions, action )
        -- csbDailyTask:runAction(action)
        -- action:play("window_open", false)
        Animations_PlayOpenMainUI({ccui.Helper:seekWidgetByName(root, "Panel_4")}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_CENTER_IN,0.5)
    end
    -- 返回主页的按钮事件响应
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rcrw_3"),       nil, 
    {
        terminal_name = "daily_task_close",   
        current_button_name = "Button_rcrw_3",
        but_image = "Image_close",       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

	local setPressedActionEnabled=true
	if __lua_project_id == __lua_project_gragon_tiger_gate 
        or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        or __lua_project_id == __lua_project_red_alert 
        then
		setPressedActionEnabled=false
	end
    -- 日常任务的按钮事件响应
    local dailyButton = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rcrw_1"),       nil, 
    {
        terminal_name = "daily_task_manager",     
        next_terminal_name = "daily_task_daily_task",     
        current_button_name = "Button_rcrw_1",
        but_image = "Image_daily_task",       
        terminal_state = 0, 
        isPressedActionEnabled = setPressedActionEnabled
    }, 
    nil, 0)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_main_page_daily_activity_daily_page_button",
    _widget = dailyButton,
    _invoke = nil,
    _interval = 0.5,})

    -- 成就的按钮事件响应
    local achievementButton = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rcrw_2"),       nil, 
    {
        terminal_name = "daily_task_manager",     
        next_terminal_name = "daily_task_achievement",     
        current_button_name = "Button_rcrw_2",
        but_image = "Image_achievement",       
        terminal_state = 0, 
        isPressedActionEnabled = setPressedActionEnabled
    }, 
    nil, 0)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_main_page_daily_activity_achievement_page_button",
    _widget = achievementButton,
    _invoke = nil,
    _interval = 0.5,})

    -- 一键领取
    local Button_yjlq = ccui.Helper:seekWidgetByName(root, "Button_yjlq")
    if nil ~= Button_yjlq then
        Button_yjlq:setVisible(false)
        fwin:addTouchEventListener(Button_yjlq,       nil, 
        {
            terminal_name = "daily_task_oen_key_draw_reward",      
            terminal_state = 0, 
            isPressedActionEnabled = true
        }, 
        nil, 0)
    end

    if __lua_project_id == __lua_project_gragon_tiger_gate then
        for i=1,4 do
            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_xy_"..i), nil, 
            {
                terminal_name = "daily_task_open_draw_reward",
                terminal_state = 0,
                index = i,
                isPressedActionEnabled = setPressedActionEnabled
            }, 
            nil, 0)
        end
    end

    local function responseDailyMissionInitCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
                then
                if nil ~= response.node and nil ~= response.node.roots then
                    if _ED.local_quest_enabled or false == funOpenDrawTip(86, false) then
                        local Image_lock = ccui.Helper:seekWidgetByName(response.node.roots[1], "Image_lock")
                        Image_lock:setVisible(false)
                        state_machine.excute("daily_task_manager", 0, {
                            _datas = {
                                terminal_name = "daily_task_manager",     
                                next_terminal_name = "daily_task_daily_task",     
                                current_button_name = "Button_rcrw_1",
                                but_image = "Image_daily_task",       
                                terminal_state = 0, 
                                isPressedActionEnabled = true
                            }
                        })
                    else
                        state_machine.excute("daily_task_manager", 0, {
                            _datas = {
                                terminal_name = "daily_task_manager",     
                                next_terminal_name = "daily_task_achievement",     
                                current_button_name = "Button_rcrw_2",
                                but_image = "Image_achievement",       
                                terminal_state = 0, 
                                isPressedActionEnabled = true
                            }
                        })
                    end
                end
            else
                state_machine.excute("daily_task_manager", 0, {
                        _datas = {
                            terminal_name = "daily_task_manager",     
                            next_terminal_name = "daily_task_daily_task",     
                            current_button_name = "Button_rcrw_1",
                            but_image = "Image_daily_task",       
                            terminal_state = 0, 
                            isPressedActionEnabled = true
                        }
                    })
            end

            -- protocol_command.draw_daily_mission_reward.param_list = ""
            -- NetworkManager:register(protocol_command.draw_daily_mission_reward.code, nil, nil, nil, self, responseDailyMissionInitCallback1, true, nil)

            
        end
    end
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
        if _ED.daily_task_number <= 0 or true then
            protocol_command.daily_mission_init.param_list = ""
            local request = NetworkManager:register(protocol_command.daily_mission_init.code, nil, nil, nil, self, responseDailyMissionInitCallback, false, nil)
    		request.handler = responseDailyMissionInitCallback
        else
            responseDailyMissionInitCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0, node = self})
        end
    else
        if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
            or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
            if _ED.daily_task_number <= 0 then
                protocol_command.daily_mission_init.param_list = ""
                local request = NetworkManager:register(protocol_command.daily_mission_init.code, nil, nil, nil, self, responseDailyMissionInitCallback, false, nil)
                request.handler = responseDailyMissionInitCallback
            else
                responseDailyMissionInitCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0, node = self})
            end
        else
             -- 初始化进入日常任务页面
            state_machine.excute("daily_task_manager", 0, 
            {
                _datas = {
                    terminal_name = "daily_task_manager",     
                    next_terminal_name = "daily_task_daily_task",            
                    current_button_name = "Button_rcrw_1",       
                    but_image = "Image_daily_task",         
                    terminal_state = 0, 
                    isPressedActionEnabled = true
                }
            })
        end
       
    end

    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then
        fwin:close(fwin:find("UserTopInfoAClass"))
        app.load("client.player.UserTopInfoA")
        fwin:open(UserTopInfoA:new(), fwin._view)

        local Panel_effec = ccui.Helper:seekWidgetByName(root, "Panel_effec")
        if Panel_effec ~= nil then
            Panel_effec:removeAllChildren(true)
            local jsonFile = "images/ui/effice/effect_chixu/effect_chixu.json"
            local atlasFile = "images/ui/effice/effect_chixu/effect_chixu.atlas"
            local animation2 = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
            animation2:setPosition(cc.p(Panel_effec:getContentSize().width/2,0))
            Panel_effec:addChild(animation2)
        end
    end
end

function DailyTask:close( ... )
    local Panel_effec = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_effec")
    if Panel_effec ~= nil then
        Panel_effec:removeAllChildren(true)
    end
end

function DailyTask:onExit()
	state_machine.remove("daily_task_close")
    state_machine.remove("daily_task_manager")
    state_machine.remove("daily_task_daily_task")
    state_machine.remove("daily_task_achievement")
    state_machine.remove("daily_task_update_draw_daily_task_integral")
    state_machine.remove("daily_task_update_draw_achievement_list_view")
    state_machine.remove("daily_task_open_draw_reward")
    state_machine.remove("daily_task_open_draw_update")
    state_machine.remove("daily_task_show_oen_key_draw_button")
    state_machine.remove("daily_task_oen_key_draw_reward")
    state_machine.remove("daily_task_update_daily_list")
    state_machine.remove("daily_task_empty_list")
end
