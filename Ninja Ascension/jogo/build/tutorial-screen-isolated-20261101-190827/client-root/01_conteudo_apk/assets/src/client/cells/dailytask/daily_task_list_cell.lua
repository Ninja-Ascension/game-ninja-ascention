----------------------------------------------------------------------------------------------------
-- 说明：日常任务列表控件
----------------------------------------------------------------------------------------------------
DailyTaskListCell = class("DailyTaskListCellClass", Window)
DailyTaskListCell.__size = nil
function DailyTaskListCell:ctor()
    self.super:ctor()
    self.roots = {}

    self.current_type = 0
	self.userDailyTask = nil
    self.listView = listView
    self.vipLevel = 0

    self.drawState = 0    -- 0:不可领取  1：可领取  2：已经领取

	self._enum_type = {
		_DAILY_TASK_PAGE = 1   -- 日常任务页面
	}

    app.load("client.cells.prop.prop_icon_cell")
    app.load("client.cells.prop.prop_icon_new_cell")
    app.load("client.cells.prop.prop_money_icon")  
    app.load("client.cells.utils.resources_icon_cell")

	local function init_daily_task_list_cell_terminal()
        local daily_task_list_cell_show_reward_info_terminal = {
            _name = "daily_task_list_cell_show_reward_info",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)     
                state_machine.excute("shortcut_open_show_reward_item_info", 0, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		local daily_task_list_cell_trace_terminal = {
            _name = "daily_task_list_cell_trace",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local traceFunctionId = params._datas.trace_function_id
				-- print("-------------",traceFunctionId)
				local openFunctionId = dms.int(dms["function_param"], traceFunctionId, function_param.open_function)
				if openFunctionId <= 0 or dms.int(dms["fun_open_condition"], openFunctionId, fun_open_condition.level) <= zstring.tonumber(_ED.user_info.user_grade) then
					if dms.int(dms["function_param"], traceFunctionId, function_param.genre) ~= 27
                        and dms.int(dms["function_param"], traceFunctionId, function_param.genre) ~= 42 
                        then
						fwin:cleanViews({fwin._background, fwin._view, fwin._viewdialog})
					end
					state_machine.excute("shortcut_function_trace", 0, {trace_function_id = traceFunctionId, _datas = {}})
				else
					TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], openFunctionId, fun_open_condition.tip_info))
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local daily_task_list_cell_draw_reward_terminal = {
            _name = "daily_task_list_cell_draw_reward",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                if cell.drawState == 2 then
                    return
                end
                local reworldIndex = 42
                local function responseDrawDailyMissionCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and  response.node.isDrawedUpdateDraw ~= nil then
                            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
                                or __lua_project_id == __lua_project_l_naruto 
                                then
                                cell:runAction(cc.Sequence:create({cc.DelayTime:create(0.5), cc.CallFunc:create(function ( sender )
                                    response.node:isDrawedUpdateDraw()
                                    state_machine.excute("activity_window_update_activity_info", 0, 1000)
                                    state_machine.unlock("daily_task_list_cell_draw_reward", 0, "")
                                    state_machine.excute("daily_task_show_oen_key_draw_button", 0, 0)
                                end)}))
                            else
                                 response.node:isDrawedUpdateDraw()
                                 state_machine.unlock("daily_task_list_cell_draw_reward", 0, "")
                            end
                        end  
                        app.load("client.reward.DrawRareReward")
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(reworldIndex)
                        fwin:open(getRewardWnd, fwin._ui)
                        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                            or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                            then
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
                    else
                        state_machine.unlock("daily_task_list_cell_draw_reward", 0, "")
                    end
                end

                _ED.user_info.last_user_food = _ED.user_info.user_food
                state_machine.lock("daily_task_list_cell_draw_reward", 0, "")
                if dms.atoi(cell.dailyTaskMould, 11) == 1 then
                    reworldIndex = 6
                    protocol_command.dinner_time.param_list = ""..dms.atoi(cell.dailyTaskMould, 12)
                    NetworkManager:register(protocol_command.dinner_time.code, nil, nil, nil, cell, responseDrawDailyMissionCallback, false, nil)
                elseif dms.atoi(cell.dailyTaskMould, 11) == 2 then
                    reworldIndex = 7
                    local _drawMonth = dms.searchs(dms["top_up_goods"], top_up_goods.goods_type, 1)
                    protocol_command.draw_month_card_reward.param_list = "".._drawMonth[1][1]
                    NetworkManager:register(protocol_command.draw_month_card_reward.code, nil, nil, nil, cell, responseDrawDailyMissionCallback, false, nil)  
                elseif dms.atoi(cell.dailyTaskMould, 11) == 3 then
                    reworldIndex = 7
                    local _drawMonth = dms.searchs(dms["top_up_goods"], top_up_goods.goods_type, 1)
                    protocol_command.draw_month_card_reward.param_list = "".._drawMonth[2][1]
                    NetworkManager:register(protocol_command.draw_month_card_reward.code, nil, nil, nil, cell, responseDrawDailyMissionCallback, false, nil)  
                else
                    reworldIndex = 42
                    protocol_command.draw_daily_mission_reward.param_list = ""..cell.userDailyTask.daily_task_id
                    NetworkManager:register(protocol_command.draw_daily_mission_reward.code, nil, nil, nil, cell, responseDrawDailyMissionCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(daily_task_list_cell_show_reward_info_terminal)
        state_machine.add(daily_task_list_cell_trace_terminal)
		state_machine.add(daily_task_list_cell_draw_reward_terminal)
        state_machine.init()
	end
	init_daily_task_list_cell_terminal()
end

function DailyTaskListCell:isDrawedUpdateDraw()
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then
        -- self:retain()
        local task_type = dms.atoi(self.dailyTaskMould, 11)
        if task_type == 1 or task_type == 2 or task_type == 3 then
            -- 月卡
            state_machine.excute("daily_task_update_daily_list", 0, "")
        else
            local itmes = self.listView:getItems()
            for i=1,#itmes do
               if itmes[i] == self then
                    self.listView:removeItem(i - 1)
                    -- self.userDailyTask.daily_task_param = 1
                    -- self.listView:addChild(self)
                    -- self:release()
                    break
               end
            end
        end
    elseif __lua_project_id == __lua_project_gragon_tiger_gate
        or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then
        self.userDailyTask.daily_task_param = 1
        self:onUpdateDraw()
    else
        self:retain()
        local itmes = self.listView:getItems()
        for i=1,#itmes do
           if itmes[i] == self then
                self.listView:removeItem(i - 1)
                self.userDailyTask.daily_task_param = 1
                self.listView:addChild(self)
    			self:release()
                break
           end
        end
    end
    state_machine.excute("daily_task_update_draw_daily_task_integral", 0, "")
end

function DailyTaskListCell:onUpdateDraw()
    local root = self.roots[1]

    local completeCount = zstring.tonumber(self.userDailyTask.daily_task_complete_count)
    local drawRewardState = zstring.tonumber(self.userDailyTask.daily_task_param)

    local dailyTaskMould = self.dailyTaskMould or dms.element(dms["daily_mission_param"], self.userDailyTask.daily_task_mould_id)
    local dailyTaskTrace = dms.atoi(dailyTaskMould, daily_mission_param.trace_function_id)
    -- /**
    --  * 主线副本战斗,次数
    --  * 
    --  */
    -- public static final byte mission_condition_battle_principal = 0;
    
    -- /**
    --  * 名将副本战斗,次数
    --  * 
    --  */
    -- public static final byte mission_condition_battle_branch = 1;
    
    -- /**
    --  * 三国无双战斗,次数
    --  * 
    --  */
    -- public static final byte mission_condition_battle_musou = 2;
    
    -- /**
    --  * 围剿叛军战斗,次数
    --  * 
    --  */
    -- public static final byte mission_condition_battle_suppress = 3;
    
    -- /**
    --  * 竞技场战斗,次数
    --  * 
    --  */
    -- public static final byte mission_condition_battle_arena = 4;
    
    -- /**
    --  * 装备强化,次数
    --  * 
    --  */
    -- public static final byte mission_condition_equipment_escalate = 5;
    
    -- /**
    --  * 装备精炼,次数
    --  * 
    --  */
    -- public static final byte mission_condition_equipment_refining = 6;
    
    -- /**
    --  * 宝物强化,次数
    --  * 
    --  */
    -- public static final byte mission_condition_treasure_escalate = 7;
    
    -- /**
    --  * 宝物精炼,次数
    --  * 
    --  */
    -- public static final byte mission_condition_treasure_refining = 8;
    
    -- /**
    --  * 武将升级,次数
    --  * 
    --  */
    -- public static final byte mission_condition_hero_escalate = 9;
    
    -- /**
    --  * 武将培养,次数
    --  * 
    --  */
    -- public static final byte mission_condition_hero_cultivate = 10;
    
    -- /**
    --  * 合成装备,次数
    --  * 
    --  */
    -- public static final byte mission_condition_compound_equipment = 11;
    
    -- /**
    --  * 合成武将,次数
    --  * 
    --  */
    -- public static final byte mission_condition_compound_hero = 12;
    
    -- /**
    --  * 合成宝物,次数
    --  * 
    --  */
    -- public static final byte mission_condition_compound_treasure = 13;
    
    -- /**
    --  * 商城购买道具道具ID,次数
    --  * 
    --  */
    -- public static final byte mission_condition_shop_prop_purchase = 14;
    
    -- /**
    --  * 商城招贤,次数
    --  * 
    --  */
    -- public static final byte mission_condition_shop_hero_bounty = 15;
    
    -- /**
    --  * 战将招募,次数
    --  * 
    --  */
    -- public static final byte mission_condition_shop_hero_bounty_primary = 16;
    
    -- /**
    --  * 神将招募,次数
    --  * 
    --  */
    -- public static final byte mission_condition_shop_hero_bounty_intermediate = 17;
    
    -- /**
    --  * 阵营招募,次数
    --  * 
    --  */
    -- public static final byte mission_condition_shop_hero_bounty_advaced = 18;
    
    -- /**
    --  * 赠送精力,次数
    --  * 
    --  */
    -- public static final byte mission_condition_present_endurance = 19;
    
    -- /**
    --  * 分享叛军,次数
    --  * 
    --  */
    -- public static final byte mission_condition_share_suppress = 20;
    
    -- /**
    --  * 镇压暴动,次数
    --  * 
    --  */
    -- public static final byte mission_condition_repress_rebellion = 21;
    
    -- /**
    --  * 领地巡逻,时间（时）
    --  * 
    --  */
    -- public static final byte mission_condition_manor_patrol = 22;
    
    -- /**
    --  * 夺宝，次数
    --  * 
    --  */
    -- public static final byte mission_condition_battle_grab = 23;
    
    -- /**
    --  * 精英副本，次数
    --  * 
    --  */
    -- public static final byte mission_condition_battle_elit = 24;
    local condition = dms.atoi(dailyTaskMould, daily_mission_param.mission_condition)
    local conditionParam = zstring.split(dms.atos(dailyTaskMould, daily_mission_param.condition_param), ",") -- 商城购买道具道具ID,次数的conditionParam值为模板id,次数
    local needCompleteCount =  zstring.tonumber(conditionParam[#conditionParam])

    -- 绘制描述信息
    ccui.Helper:seekWidgetByName(root, "Text_rc_1"):setString(dms.atos(dailyTaskMould, daily_mission_param.mission_name))
    -- 绘制日常任务的进度
    local Text_rc_5 = ccui.Helper:seekWidgetByName(root, "Text_rc_5")
    Text_rc_5:setString(completeCount .. "/" ..needCompleteCount)

    -- //---------------------------------------------------------------------------
    -- //资源代号
    -- //---------------------------------------------------------------------------
    -- public static final byte RESOURCE_SILVER = 1;
    -- public static final byte RESOURCE_GOLD = 2;
    -- public static final byte RESOURCE_COMBATFOOD = 3;
    -- public static final byte RESOURCE_BOUNTY = 4;
    -- public static final byte RESOURCE_PROP = 5;
    -- public static final byte RESOURCE_EQUIPMENT = 6;
    -- public static final byte RESOURCE_POWER = 7;
    -- public static final byte RESOURCE_EXPERIENCE = 8;
    -- public static final byte RESOURCE_SOUL = 9;//将魂
    -- public static final byte RESOURCE_DAILY_MISSION_SCORE = 10;//日常任务积分

    -- SILVER_COIN_INFORMATION = 1,                --  1:银币    RESOURCE_SILVER = 1
    --     GOLD_COIN_INFORMATION = 2,                  --  2:金币 RESOURCE_GOLD = 2
    --     REPUTATION_INFORMATION = 3,                 --  3:声望 
    --     HERO_SOUL_INFORMATION = 4,                  --  4:将魂 
    --     SOUL_JADE_INFORMATION = 5,                  --  5:魂玉 RESOURCE_SOUL = 9
    --     PROP_INFORMATION = 6,                       --  6:道具    RESOURCE_PROP = 5
    --     EQUIPMENT_INFORMATION = 7,                  --  7:装备    RESOURCE_EQUIPMENT = 6 
    --     EXPERIENCE_INFORMATION = 8,                 --  8:经验 
    --     ENDURANCE_INFORMATION = 9,                  --  9:耐力 
    --     FUNCTION_INFORMATION = 10,                  --  10:功能点 
    --     BATTLE_NUMBER_PEOPLE_INFORMATION = 11,      --  11:上阵人数 
    --     PHYSICAL_STRENGTH_INFORMATION = 12,         --  12:体力
    --     HERO_INFORMATION = 13,                      --  13:武将 
    --     AREAN_RANK_INFORMATION = 14,                --  14:竞技场排名
    --     DPS_INFORMATION = 15,                       --  15:伤害
    --     DUEL_INFORMATION = 16,                      --  16:比武积分
    --     POWER_INFORMATION = 17,                     --  17:霸气
    --     GLORIES_INFORMATION= 18,                    --  18:威名
    --     DAILYTASK_SCORE_INFORMATION = 19,           --  19:日常任务积分 RESOURCE_DAILY_MISSION_SCORE = 10
    --     FEATS_INFORMATION = 20,                     --  20:功勋
    --     BATTLE_ACHIEVEMENT_INFORMATION = 21,        --  21:战功
    --     RECHARGE_SHOP_INFORMATION = 22,             --  22:充值商店
                                                                        

    -- 任务奖励(资源号-模板,值)
    -- 绘制奖励
    local rewardIcon = dms.atoi(dailyTaskMould, daily_mission_param.pic_index)
    local rewardParam = zstring.split(dms.atos(dailyTaskMould, daily_mission_param.mission_reward), ",")
    local rewardType = zstring.split(rewardParam[1], "-")

    --ccui.Helper:seekWidgetByName(root, "Panel_1"):setBackGroundImage(string.format("images/ui/function_icon/function_icon_%d.png", rewardIcon))
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then
        if ccui.Helper:seekWidgetByName(root, "Panel_richang_icon") ~= nil then
    	   ccui.Helper:seekWidgetByName(root, "Panel_richang_icon"):setBackGroundImage(string.format("images/ui/props/props_%d.png",rewardIcon))
        end
    else
    	ccui.Helper:seekWidgetByName(root, "Panel_1"):setBackGroundImage(string.format("images/ui/props/props_%d.png", rewardIcon))
    end
	
    local rewardString = dms.atos(dailyTaskMould, daily_mission_param.depict)
    -- 绘制描述信息
    ccui.Helper:seekWidgetByName(root, "Text_rc_3"):setString(rewardString)

    -- 领取奖励的事件响应
    local drawButton = ccui.Helper:seekWidgetByName(root, "Button_1")
    drawButton:setVisible(false)
    drawButton:setVisible(drawRewardState == 0 and completeCount >= needCompleteCount)

    -- 前往奖励的事件响应
    local traceButton = ccui.Helper:seekWidgetByName(root, "Button_2")
    traceButton:setVisible(false)
    traceButton:setVisible(drawRewardState == 0 and completeCount < needCompleteCount and dailyTaskTrace > 0)

    -- 根据不同的情况，选项区域响应不同的逻辑
    -- .. 

    ccui.Helper:seekWidgetByName(root, "Image_38"):setVisible(drawRewardState == 1)
    if drawRewardState == 0 then
        if completeCount >= needCompleteCount then
            self.drawState = 1
        else
            self.drawState = 0
        end
    else
        self.drawState = 2
    end

    local Image_vip_tag = ccui.Helper:seekWidgetByName(root, "Image_vip_tag")
    if Image_vip_tag ~= nil then
        if zstring.tonumber(self.vipLevel) > 0 then
            Image_vip_tag:setVisible(true)
        end
    end

    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
        then
        local Image_1 = ccui.Helper:seekWidgetByName(root, "Image_1")
        local Image_klq = ccui.Helper:seekWidgetByName(root, "Image_klq")
        local Panel_klq = ccui.Helper:seekWidgetByName(root, "Panel_klq")
        if __lua_project_id == __lua_project_l_naruto then
            Panel_klq:setVisible(false)
        else
            Panel_klq:removeAllChildren(true)
        end
        if self.drawState >= 1 then
            Text_rc_5:setVisible(false)
            Image_1:setVisible(false)
            Image_klq:setVisible(true)

            if self.drawState == 1 then
                if __lua_project_id == __lua_project_l_naruto then
                    Panel_klq:setVisible(true)
                else
                    local jsonFile = "sprite/spirte_kelingqu.json"
                    local atlasFile = "sprite/spirte_kelingqu.atlas"
                    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
                    Panel_klq:addChild(animation)
                end
            end
        else
            Text_rc_5:setVisible(true)
            Image_1:setVisible(true)
            Image_klq:setVisible(false)
        end
    end
end

function DailyTaskListCell:addIcon()

    app.load("client.cells.prop.prop_icon_new_cell")
    app.load("client.cells.prop.prop_money_icon")  
    local root = self.roots[1]
    local Panel_richang_icon = ccui.Helper:seekWidgetByName(root, "Panel_richang_icon")
    if Panel_richang_icon ~= nil then
        Panel_richang_icon:removeAllChildren(true)
    end
    local dailyTaskMould = self.dailyTaskMould or dms.element(dms["daily_mission_param"], self.userDailyTask.daily_task_mould_id)

    local rewardIcon = dms.atos(dailyTaskMould, daily_mission_param.pic_index)
    local rewardParam = zstring.split(dms.atos(dailyTaskMould, daily_mission_param.mission_reward), ",")
    local rewardType = zstring.split(rewardParam[1], "-")  
    local Type = zstring.tonumber(rewardType[1])
    local function rewardTypeChange(_type)
        if _type == 9 then
            _type = 5
        elseif _type == 5 then
            _type = 6
        elseif _type == 6 then
            _type = 7
        end 
        
        return _type
    end  
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then
        if Panel_richang_icon ~= nil then
    	    Panel_richang_icon:removeBackGroundImage()
    	    Panel_richang_icon:setBackGroundImage(string.format("images/ui/props/props_%d.png", rewardIcon))
        end
	    -- local newType = rewardTypeChange(Type)
	    -- if newType == 6 then
	    --     local cell = PropIconNewCell:createCell()
	    --     cell:init(15,rewardType[2])
	    --     Panel_richang_icon:addChild(cell)
	    -- else
	    --     local cell = propMoneyIcon:createCell()
	    --     cell:init(""..newType)
	    --     Panel_richang_icon:addChild(cell)    
	    -- end

	    -- 绘制奖励信息
	    local Panel_props_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_props_icon_1")
	    if nil ~= Panel_props_icon_1 then
	        -- Panel_richang_icon 任务大图标
	        -- Panel_props_icon_1 绘制奖励1图标 图标ID策划给出
	        -- Text_reward_number_1 奖励1数量 
	        -- Panel_props_icon_2 绘制奖励2图标  图标ID策划给出
	        -- Text_reward_number_2 奖励2数量
	        -- Image_zhandui_exp  战队经验ICON，默认不可见
	        -- Text_reward_number_3 奖励战队经验数量

	        local Text_reward_number_1 = ccui.Helper:seekWidgetByName(root, "Text_reward_number_1")
	        local Panel_props_icon_2 = ccui.Helper:seekWidgetByName(root, "Panel_props_icon_2")
	        local Text_reward_number_2 = ccui.Helper:seekWidgetByName(root, "Text_reward_number_2")
	        local Image_zhandui_exp = ccui.Helper:seekWidgetByName(root, "Image_zhandui_exp")
	        local Text_reward_number_3 = ccui.Helper:seekWidgetByName(root, "Text_reward_number_3")

            local Text_reward_number_4= ccui.Helper:seekWidgetByName(root, "Text_reward_number_4")
            local Panel_props_icon_4 = ccui.Helper:seekWidgetByName(root, "Panel_props_icon_4")
            -- DSC重塑
            local Text_reward_number_5 = ccui.Helper:seekWidgetByName(root, "Text_reward_number_5")
            local Panel_props_icon_5 = ccui.Helper:seekWidgetByName(root, "Panel_props_icon_5")
            if __lua_project_id == __lua_project_l_digital then 
                for i=1,5 do
                    local Panel_richang_di = ccui.Helper:seekWidgetByName(root, "Panel_richang_di_"..i)
                    if Panel_richang_di then 
                        Panel_richang_di:setVisible(false)
                    end
                end
            end

	        Panel_props_icon_1:setVisible(false)
	        Text_reward_number_1:setVisible(false)
	        Panel_props_icon_2:setVisible(false)
	        Text_reward_number_2:setVisible(false)
            if Image_zhandui_exp ~= nil then
	           Image_zhandui_exp:setVisible(false)
            end
	        Text_reward_number_3:setVisible(false)

	        Panel_props_icon_1:removeAllChildren(true)
	        Panel_props_icon_1:removeBackGroundImage()

	        Panel_props_icon_2:removeAllChildren(true)
	        Panel_props_icon_2:removeBackGroundImage()

            if Text_reward_number_4 ~= nil then
                Text_reward_number_4:setVisible(false)
            end
            if Panel_props_icon_4 ~= nil then
                Panel_props_icon_4:removeAllChildren(true)
                Panel_props_icon_4:removeBackGroundImage()
            end

	        local rewardParams = zstring.splits(dms.atos(dailyTaskMould, daily_mission_param.mission_reward), "!", ",")
	        if nil ~= rewardParams[1] then
	            local ppInfo = zstring.split(rewardParams[1][1], "-")
	            local pType = tonumber(ppInfo[1])
	            if pType == 3 then
	                pType = 12
	            elseif pType == 5 then
	                pType = 6
	            end
	            rewardParams[1][3] = rewardParams[1][2]
	            rewardParams[1][1] = ppInfo[1]
                rewardParams[1][2] = ppInfo[2]
                -- DSC重塑
                local Panel_richang_di_1 = ccui.Helper:seekWidgetByName(root, "Panel_richang_di_1")
                if __lua_project_id == __lua_project_l_digital and  Panel_richang_di_1 then 
                    Panel_richang_di_1:setVisible(true)
                end
                Panel_props_icon_1:setVisible(true)
	            if pType == 8 then
                    if __lua_project_id == __lua_project_l_naruto or __lua_project_id == __lua_project_l_digital then
                        Panel_props_icon_1:setVisible(true)
                        local cell = ResourcesIconCell:createCell()
                        cell:init(8, 0, -1)
                        cell:hideCount(false)
                        Panel_props_icon_1:addChild(cell)
                        Text_reward_number_1:setVisible(true)
                        Text_reward_number_1:setString("x" .. rewardParams[1][3])
                    else
                        Image_zhandui_exp:setVisible(true)
                        Text_reward_number_3:setVisible(true)
                        Text_reward_number_3:setString("x" .. rewardParams[1][3])
                    end
                else
	                local info = rewardParams[1]
	                if info[1] == "1" then
	                    local cell = ResourcesIconCell:createCell()
	                    cell:init(1, tonumber(info[3]), -1)
	                    cell:hideCount(false)
	                    Panel_props_icon_1:addChild(cell)
	                elseif info[1] == "2" then
	                    local cell = ResourcesIconCell:createCell()
	                    cell:init(2, tonumber(info[3]), -1)
	                    cell:hideCount(false)
	                    Panel_props_icon_1:addChild(cell)
                    elseif info[1] == "3" or info[1] == "12" then
                        local cell = ResourcesIconCell:createCell()
                        cell:init(12, tonumber(info[3]), -1)
                        cell:hideCount(false)
                        Panel_props_icon_1:addChild(cell)
                    elseif info[1] == "34" then
                        local cell = ResourcesIconCell:createCell()
                        cell:init(34, tonumber(info[3]), -1)
                        cell:hideCount(false)
                        Panel_props_icon_1:addChild(cell)
	                elseif info[1] == "6" or info[1] == "5" then
	                    local cell = PropIconCell:createCell()
	                    local reawrdID = tonumber(info[2])
	                    local rewardNum = tonumber(info[3])
                        cell:hideNameAndCount()
	                    cell:init(23, {user_prop_template = reawrdID, prop_number = 0}, nil, false)
	                    Panel_props_icon_1:addChild(cell)
	                elseif info[1] == "7" then
	                    local reawrdID = tonumber(info[2])
	                    local rewardNum = tonumber(info[3])
                    
	                    local tmpTable = {
	                        user_equiment_template = reawrdID,
	                        mould_id = reawrdID,
	                        user_equiment_grade = 1
	                    }
                    
	                    local cell = EquipIconCell:createCell()
	                    cell:init(10, tmpTable, reawrdID, nil, false)
	                    Panel_props_icon_1:addChild(cell)
                    elseif info[1] == "28" then
                        local cell = ResourcesIconCell:createCell()
                        cell:init(28, tonumber(info[3]), -1)
                        cell:hideCount(false)
                        Panel_props_icon_1:addChild(cell)
                    elseif info[1] == "67" then
                        local cell = ResourcesIconCell:createCell()
                        cell:init(67, tonumber(info[3]), -1)
                        cell:hideCount(false)
                        Panel_props_icon_1:addChild(cell)
	                end

	                Text_reward_number_1:setVisible(true)
	                Text_reward_number_1:setString("x" .. rewardParams[1][3])
	            end
	        end

	        if nil ~= rewardParams[2] then
	            local ppInfo = zstring.split(rewardParams[2][1], "-")
	            local pType = tonumber(ppInfo[1])
	            if pType == 3 then
	                pType = 12
	            elseif pType == 5 then
	                pType = 6
	            end
	            rewardParams[2][3] = rewardParams[2][2]
	            rewardParams[2][1] = ppInfo[1]
	            rewardParams[2][2] = ppInfo[2]
	            if pType == 8 then
                    if __lua_project_id == __lua_project_l_naruto then
                        Panel_props_icon_2:setVisible(true)
                        local cell = ResourcesIconCell:createCell()
                        cell:init(8, 0, -1)
                        cell:hideCount(false)
                        Panel_props_icon_2:addChild(cell)
                        Text_reward_number_2:setVisible(true)
                        Text_reward_number_2:setString("x" .. rewardParams[2][3])
                    else
                        Image_zhandui_exp:setVisible(true)
                        Text_reward_number_3:setVisible(true)
                        Text_reward_number_3:setString("x" .. rewardParams[2][3])
                    end
                else
                    -- DSC重塑
                    local Panel_richang_di_2 = ccui.Helper:seekWidgetByName(root, "Panel_richang_di_2")
                    if __lua_project_id == __lua_project_l_digital and  Panel_richang_di_2 then 
                        Panel_richang_di_2:setVisible(true)
                    end
	                Panel_props_icon_2:setVisible(true)
	                local info = rewardParams[2]
	                if info[1] == "1" then
	                    local cell = ResourcesIconCell:createCell()
	                    cell:init(1, tonumber(info[3]), -1)
	                    cell:hideCount(false)
	                    Panel_props_icon_2:addChild(cell)
	                elseif info[1] == "2" then
	                    local cell = ResourcesIconCell:createCell()
	                    cell:init(2, tonumber(info[3]), -1)
	                    cell:hideCount(false)
	                    Panel_props_icon_2:addChild(cell)
                    elseif info[1] == "3" or info[1] == "12" then
                        local cell = ResourcesIconCell:createCell()
                        cell:init(12, tonumber(info[3]), -1)
                        cell:hideCount(false)
                        Panel_props_icon_2:addChild(cell)
	                elseif info[1] == "6" or info[1] == "5" then
	                    local cell = PropIconCell:createCell()
	                    local reawrdID = tonumber(info[2])
	                    local rewardNum = tonumber(info[3])
                        cell:hideNameAndCount()
	                    cell:init(23, {user_prop_template = reawrdID, prop_number = 0}, nil, false)
	                    Panel_props_icon_2:addChild(cell)
	                elseif info[1] == "7" then
	                    local reawrdID = tonumber(info[2])
	                    local rewardNum = tonumber(info[3])
                    
	                    local tmpTable = {
	                        user_equiment_template = reawrdID,
	                        mould_id = reawrdID,
	                        user_equiment_grade = 1
	                    }
                    
	                    local cell = EquipIconCell:createCell()
	                    cell:init(10, tmpTable, reawrdID, nil, false)
	                    Panel_props_icon_2:addChild(cell)
                    elseif info[1] == "28" then
                        local cell = ResourcesIconCell:createCell()
                        cell:init(28, tonumber(info[3]), -1)
                        cell:hideCount(false)
                        Panel_props_icon_2:addChild(cell)
                    elseif info[1] == "67" then
                        local cell = ResourcesIconCell:createCell()
                        cell:init(67, tonumber(info[3]), -1)
                        cell:hideCount(false)
                        Panel_props_icon_2:addChild(cell)
	                end

	                Text_reward_number_2:setVisible(true)
	                Text_reward_number_2:setString("x" .. rewardParams[2][3])
	            end
	        end

            if nil ~= rewardParams[3] then
                local ppInfo = zstring.split(rewardParams[3][1], "-")
                local pType = tonumber(ppInfo[1])
                if pType == 3 then
                    pType = 12
                elseif pType == 5 then
                    pType = 6
                end
                rewardParams[3][3] = rewardParams[3][2]
                rewardParams[3][1] = ppInfo[1]
                rewardParams[3][2] = ppInfo[2]
                if pType == 8 then
                    if __lua_project_id == __lua_project_l_naruto then
                        Panel_props_icon_4:setVisible(true)
                        local cell = ResourcesIconCell:createCell()
                        cell:init(8, 0, -1)
                        cell:hideCount(false)
                        Panel_props_icon_4:addChild(cell)
                        Text_reward_number_4:setVisible(true)
                        Text_reward_number_4:setString("x" .. rewardParams[3][3])
                    else
                        Image_zhandui_exp:setVisible(true)
                        Text_reward_number_3:setVisible(true)
                        Text_reward_number_3:setString("x" .. rewardParams[3][3])
                    end
                else
                    -- DSC重塑
                    local Panel_richang_di_4 = ccui.Helper:seekWidgetByName(root, "Panel_richang_di_4")
                    if __lua_project_id == __lua_project_l_digital and  Panel_richang_di_4 then 
                        Panel_richang_di_4:setVisible(true)
                    end
                    Panel_props_icon_4:setVisible(true)
                    local info = rewardParams[3]
                    if info[1] == "1" then
                        local cell = ResourcesIconCell:createCell()
                        cell:init(1, tonumber(info[3]), -1)
                        cell:hideCount(false)
                        Panel_props_icon_4:addChild(cell)
                    elseif info[1] == "2" then
                        local cell = ResourcesIconCell:createCell()
                        cell:init(2, tonumber(info[3]), -1)
                        cell:hideCount(false)
                        Panel_props_icon_4:addChild(cell)
                    elseif info[1] == "3" or info[1] == "12" then
                        local cell = ResourcesIconCell:createCell()
                        cell:init(12, tonumber(info[3]), -1)
                        cell:hideCount(false)
                        Panel_props_icon_4:addChild(cell)
                    elseif info[1] == "6" or info[1] == "5" then
                        local cell = PropIconCell:createCell()
                        local reawrdID = tonumber(info[2])
                        local rewardNum = tonumber(info[3])
                        cell:hideNameAndCount()
                        cell:init(23, {user_prop_template = reawrdID, prop_number = 0}, nil, false)
                        Panel_props_icon_4:addChild(cell)
                    elseif info[1] == "7" then
                        local reawrdID = tonumber(info[2])
                        local rewardNum = tonumber(info[3])
                    
                        local tmpTable = {
                            user_equiment_template = reawrdID,
                            mould_id = reawrdID,
                            user_equiment_grade = 1
                        }
                    
                        local cell = EquipIconCell:createCell()
                        cell:init(10, tmpTable, reawrdID, nil, false)
                        Panel_props_icon_4:addChild(cell)
                    elseif info[1] == "28" then
                        local cell = ResourcesIconCell:createCell()
                        cell:init(28, tonumber(info[3]), -1)
                        cell:hideCount(false)
                        Panel_props_icon_4:addChild(cell)
                    elseif info[1] == "67" then
                        local cell = ResourcesIconCell:createCell()
                        cell:init(67, tonumber(info[3]), -1)
                        cell:hideCount(false)
                        Panel_props_icon_4:addChild(cell)
                    end

                    Text_reward_number_4:setVisible(true)
                    Text_reward_number_4:setString("x" .. rewardParams[3][3])
                end
            end
            -- DSC重塑
            if __lua_project_id == __lua_project_l_digital and nil ~= rewardParams[4] and Text_reward_number_5 and Panel_props_icon_5 then
                local ppInfo = zstring.split(rewardParams[4][1], "-")
                local pType = tonumber(ppInfo[1])
                if pType == 3 then
                    pType = 12
                elseif pType == 5 then
                    pType = 6
                end
                rewardParams[4][3] = rewardParams[4][2]
                rewardParams[4][1] = ppInfo[1]
                rewardParams[4][2] = ppInfo[2]
                if pType == 8 then
                    if __lua_project_id == __lua_project_l_naruto then
                        Panel_props_icon_5:setVisible(true)
                        local cell = ResourcesIconCell:createCell()
                        cell:init(8, 0, -1)
                        cell:hideCount(false)
                        Panel_props_icon_5:addChild(cell)
                        Text_reward_number_5:setVisible(true)
                        Text_reward_number_5:setString("x" .. rewardParams[4][3])
                    else
                        Image_zhandui_exp:setVisible(true)
                        Text_reward_number_3:setVisible(true)
                        Text_reward_number_3:setString("x" .. rewardParams[4][3])
                    end
                else
                    -- DSC重塑
                    local Panel_richang_di_5 = ccui.Helper:seekWidgetByName(root, "Panel_richang_di_5")
                    if __lua_project_id == __lua_project_l_digital and  Panel_richang_di_5 then 
                        Panel_richang_di_5:setVisible(true)
                    end
                    Panel_props_icon_5:setVisible(true)
                    local info = rewardParams[4]
                    if info[1] == "1" then
                        local cell = ResourcesIconCell:createCell()
                        cell:init(1, tonumber(info[3]), -1)
                        cell:hideCount(false)
                        Panel_props_icon_5:addChild(cell)
                    elseif info[1] == "2" then
                        local cell = ResourcesIconCell:createCell()
                        cell:init(2, tonumber(info[3]), -1)
                        cell:hideCount(false)
                        Panel_props_icon_5:addChild(cell)
                    elseif info[1] == "3" or info[1] == "12" then
                        local cell = ResourcesIconCell:createCell()
                        cell:init(12, tonumber(info[3]), -1)
                        cell:hideCount(false)
                        Panel_props_icon_5:addChild(cell)
                    elseif info[1] == "6" or info[1] == "5" then
                        local cell = PropIconCell:createCell()
                        local reawrdID = tonumber(info[2])
                        local rewardNum = tonumber(info[3])
                        cell:hideNameAndCount()
                        cell:init(23, {user_prop_template = reawrdID, prop_number = 0}, nil, false)
                        Panel_props_icon_5:addChild(cell)
                    elseif info[1] == "7" then
                        local reawrdID = tonumber(info[2])
                        local rewardNum = tonumber(info[3])
                    
                        local tmpTable = {
                            user_equiment_template = reawrdID,
                            mould_id = reawrdID,
                            user_equiment_grade = 1
                        }
                    
                        local cell = EquipIconCell:createCell()
                        cell:init(10, tmpTable, reawrdID, nil, false)
                        Panel_props_icon_5:addChild(cell)
                    elseif info[1] == "28" then
                        local cell = ResourcesIconCell:createCell()
                        cell:init(28, tonumber(info[3]), -1)
                        cell:hideCount(false)
                        Panel_props_icon_5:addChild(cell)
                    elseif info[1] == "67" then
                        local cell = ResourcesIconCell:createCell()
                        cell:init(67, tonumber(info[3]), -1)
                        cell:hideCount(false)
                        Panel_props_icon_5:addChild(cell)
                    end

                    Text_reward_number_5:setVisible(true)
                    Text_reward_number_5:setString("x" .. rewardParams[4][3])
                end
            end
        end
	else
	    local newType = rewardTypeChange(Type)
	    if newType == 6 then
	        local cell = PropIconNewCell:createCell()
	        cell:init(15,rewardType[2])
	        Panel_richang_icon:addChild(cell)   
	    else
	        local cell = propMoneyIcon:createCell()
	        cell:init(""..newType)
	        Panel_richang_icon:addChild(cell)    
	    end
	end
end
function DailyTaskListCell:initDraw()
    local root = cacher.createUIRef("activity/DailyTasks/dailytasks_list.csb", "root")
	root:removeFromParent(false)
	self:addChild(root)
    table.insert(self.roots, root)

    local controllerPad = ccui.Helper:seekWidgetByName(root, "Panel_rcrw_list")
    -- controllerPad:setSwallowTouches(false)

    self:setContentSize(controllerPad:getContentSize())
    if DailyTaskListCell.__size == nil then
        DailyTaskListCell.__size = controllerPad:getContentSize()
    end

	-- 列表控件动画播放
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
    else
    	local action = csb.createTimeline("activity/DailyTasks/dailytasks_list.csb")
        root:runAction(action)
        -- action:play("list_view_cell_open", false)
    	action:gotoFrameAndPlay(15, 15, false)
    end
	
    local dailyTaskMould = self.dailyTaskMould or dms.element(dms["daily_mission_param"], self.userDailyTask.daily_task_mould_id)
    local dailyTaskTrace = dms.atoi(dailyTaskMould, daily_mission_param.trace_function_id)
    
    -- 读取奖励信息
    local rewardIcon = dms.atos(dailyTaskMould, daily_mission_param.pic_index)
    local rewardParam = zstring.split(dms.atos(dailyTaskMould, daily_mission_param.mission_reward), ",")
    local rewardType = zstring.split(rewardParam[1], "-")
	
	local function rewardTypeChange(_type)
		if _type == 9 then
			_type = 5
		elseif _type == 5 then
			_type = 6
		elseif _type == 6 then
			_type = 7
		end	
		
		return _type
	end
	
    -- 查看奖励信息的事件响应
    local showInfoPanel = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_3"),       nil, 
    {
        terminal_name = "daily_task_list_cell_show_reward_info",      
        terminal_state = 0, 
        cell = self,
        reward = {rewardTypeChange(zstring.tonumber(rewardType[1])), zstring.tonumber(rewardType[2])}
    }, 
    nil, 0)

    -- 领取奖励的事件响应
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"),       nil, 
    {
        terminal_name = "daily_task_list_cell_draw_reward",      
        terminal_state = 0, 
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 前往奖励的事件响应
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"),       nil, 
    {
        terminal_name = "daily_task_list_cell_trace",      
        terminal_state = 0, 
        cell = self,
        trace_function_id = dailyTaskTrace,
        isPressedActionEnabled = true
    }, 
    nil, 0):setSwallowTouches(false)

    -- 根据不同的情况，选项区域响应不同的逻辑
    -- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_rcrw_list"),       nil, 
    -- {
    --     terminal_name = (drawRewardState == 0 and completeCount >= needCompleteCount) == true and "daily_task_list_cell_draw_reward" or "daily_task_list_cell_trace",      
    --     terminal_state = 0, 
    --     cell = self,
    --     trace_function_id = dailyTaskTrace,
    --     isPressedActionEnabled = false
    -- }, 
    -- nil, 0)
    
    self:clearUIInfo()
    self:onUpdateDraw()
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
        self:addIcon()
    end

    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        local Image_klq = ccui.Helper:seekWidgetByName(root, "Image_klq")
        Image_klq:setTouchEnabled(true)
        fwin:addTouchEventListener(Image_klq,       nil, 
        {
            terminal_name = "daily_task_list_cell_draw_reward",      
            terminal_state = 0, 
            cell = self,
            isPressedActionEnabled = true
        }, 
        nil, 0)
    end
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
 --    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.onUpdateDraw, self)
end

function DailyTaskListCell:onEnterTransitionFinish()

end

function DailyTaskListCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:initDraw()
end

function DailyTaskListCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef("activity/DailyTasks/dailytasks_list.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function DailyTaskListCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_richang_icon = ccui.Helper:seekWidgetByName(root, "Panel_richang_icon")
    local Panel_klq = ccui.Helper:seekWidgetByName(root, "Panel_klq")
    local Panel_props_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_props_icon_1")
    local Panel_props_icon_2 = ccui.Helper:seekWidgetByName(root, "Panel_props_icon_2")
    local Panel_props_icon_4 = ccui.Helper:seekWidgetByName(root, "Panel_props_icon_4")

    local Image_vip_tag = ccui.Helper:seekWidgetByName(root, "Image_vip_tag")
    if Image_vip_tag ~= nil then
        Image_vip_tag:setVisible(false)
    end
    if Panel_richang_icon ~= nil then
        Panel_richang_icon:removeAllChildren(true)
    end
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
        then
        if Panel_klq ~= nil then
            Panel_klq:removeAllChildren(true)
        end
    end
    if Panel_props_icon_1 ~= nil then
        Panel_props_icon_1:removeAllChildren(true)
        Panel_props_icon_1:removeBackGroundImage()
    end
    if Panel_props_icon_2 ~= nil then
        Panel_props_icon_2:removeAllChildren(true)
        Panel_props_icon_2:removeBackGroundImage()
    end
    if Panel_props_icon_4 ~= nil then
        Panel_props_icon_4:removeAllChildren(true)
        Panel_props_icon_4:removeBackGroundImage()
    end
    -- DSC重塑
    local Panel_props_icon_5 = ccui.Helper:seekWidgetByName(root, "Panel_props_icon_5")
    if Panel_props_icon_5 ~= nil then
        Panel_props_icon_5:removeAllChildren(true)
        Panel_props_icon_5:removeBackGroundImage()
    end
    local Text_reward_number_5 = ccui.Helper:seekWidgetByName(root, "Text_reward_number_5")
    if Text_reward_number_5 ~= nil then
        Text_reward_number_5:setVisible(false)
    end

    local Text_reward_number_1 = ccui.Helper:seekWidgetByName(root, "Text_reward_number_1")
    local Text_reward_number_2 = ccui.Helper:seekWidgetByName(root, "Text_reward_number_2")
    local Text_reward_number_3 = ccui.Helper:seekWidgetByName(root, "Text_reward_number_3")
    local Text_reward_number_4 = ccui.Helper:seekWidgetByName(root, "Text_reward_number_4")
    if Text_reward_number_1 ~= nil then
        Text_reward_number_1:setVisible(false)
    end
    if Text_reward_number_2 ~= nil then
        Text_reward_number_2:setVisible(false)
    end
    if Text_reward_number_3 ~= nil then
        Text_reward_number_3:setVisible(false)
    end
    if Text_reward_number_4 ~= nil then
        Text_reward_number_4:setVisible(false)
    end
end

function DailyTaskListCell:onExit()
    local root = self.roots[1]
    self:clearUIInfo()
    cacher.freeRef("activity/DailyTasks/dailytasks_list.csb", root)
end

function DailyTaskListCell:init(interfaceType, userDailyTask, listView,index, dailyTaskMould, vipLevel)
    self.dailyTaskMould = dailyTaskMould
    self.current_type = interfaceType
    self.userDailyTask = userDailyTask
    self.listView = listView
    self.vipLevel = vipLevel or 0
    local maxIndex = 8
    if __lua_project_id == __lua_project_digimon_adventure 
        or __lua_project_id == __lua_project_naruto
        or __lua_project_id == __lua_project_yugioh
        or __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge
        or __lua_project_id == __lua_project_warship_girl_b 
        or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
        then
        maxIndex = 5
    end
    local drawRewardState = zstring.tonumber(self.userDailyTask.daily_task_param)
    local dailyTaskMould = self.dailyTaskMould or dms.element(dms["daily_mission_param"], self.userDailyTask.daily_task_mould_id)
    local completeCount = zstring.tonumber(self.userDailyTask.daily_task_complete_count)
    local conditionParam = zstring.split(dms.atos(dailyTaskMould, daily_mission_param.condition_param), ",")
    local needCompleteCount =  zstring.tonumber(conditionParam[#conditionParam])
    if drawRewardState == 0 then
        if completeCount >= needCompleteCount then
            self.drawState = 1
        else
            self.drawState = 0
        end
    else
        self.drawState = 2
    end
    if index ~= nil and index < maxIndex then
        self:initDraw()       
    end
    self:setContentSize(DailyTaskListCell.__size)
    return self, self.drawState
end

function DailyTaskListCell:sortUpdateInfo( index )
    if index < 5 then
        if self.roots[1] == nil then
            self:initDraw()
        end
    else
        self:unload()
    end
end

function DailyTaskListCell:createCell()
	local cell = DailyTaskListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

