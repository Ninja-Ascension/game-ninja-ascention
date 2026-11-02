----------------------------------------------------------------------------------------------------
-- 说明：七日活动每日成就列表项
----------------------------------------------------------------------------------------------------
EveryDayAchievementListCell = class("EveryDayAchievementListCellClass", Window)

function EveryDayAchievementListCell:ctor()
    self.super:ctor()
    self.roots = {}

    self.achievementIndex = 0
    self.rewardIndex = 0
    self.dayIndex = 0
    self.achievement_reward = nil
    self.listView = nil

    self.command_param_list = ""

    self.drawState = 0    -- 0:不可领取  1：可领取  2：已经领取

    app.load("client.cells.equip.equip_icon_cell")
    app.load("client.cells.prop.prop_icon_cell")
    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.cells.prop.prop_money_icon")

    local function init_every_day_achievement_list_cell_draw_reward_terminal()
        local every_day_achievement_list_cell_trace_terminal = {
            _name = "every_day_achievement_list_cell_trace",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local traceFunctionId = params._datas.trace_function_id
                local openFunctionId = dms.int(dms["function_param"], traceFunctionId, function_param.open_function)
                if openFunctionId > 0 then
                    local user_grade=dms.int(dms["fun_open_condition"], openFunctionId, fun_open_condition.level)
                    if user_grade <= zstring.tonumber(_ED.user_info.user_grade) then
                        
                    else
                        TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], openFunctionId, fun_open_condition.tip_info))
                        return false
                    end
                end
				
				-- 判定开启的前置条件
				-- 如果是跳副本的  26 名将副本
				if traceFunctionId == 26 then
					local lastSceneId, firstScene = instance:getOpenMaxSceneId(9)
					if lastSceneId < 0 then
						local dySceneDes = dms.atos(firstScene, pve_scene.open_condition_describe)
						TipDlg.drawTextDailog(dySceneDes)
						return false
					end
				end
				if dms.int(dms["function_param"], traceFunctionId, function_param.genre) ~= 27 then
					fwin:cleanViews({fwin._background, fwin._view, fwin._viewdialog})
				end
				
                state_machine.excute("shortcut_function_trace", 0, {trace_function_id = traceFunctionId, _datas = {}})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local every_day_achievement_list_cell_draw_reward_request_terminal = {
            _name = "every_day_achievement_list_cell_draw_reward_request",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseDrawWeekRewardCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        response.node:isDrawedUpdateDraw()
                        app.load("client.reward.DrawRareReward")
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(47)
                        fwin:open(getRewardWnd, fwin._ui)
                    end
                end
                local cell = params._datas.cell
                protocol_command.draw_week_reward.param_list = ""..cell.command_param_list
                NetworkManager:register(protocol_command.draw_week_reward.code, nil, nil, nil, cell, responseDrawWeekRewardCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local every_day_achievement_list_cell_draw_reward_terminal = {
            _name = "every_day_achievement_list_cell_draw_reward",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                cell.command_param_list = "" .. cell.dayIndex .. "\r\n" .. cell.achievementIndex ..  "\r\n"..cell.achievement_reward.id .. "\r\n" .. "-1"
                state_machine.excute("every_day_achievement_list_cell_draw_reward_request", 0, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(every_day_achievement_list_cell_trace_terminal)
        state_machine.add(every_day_achievement_list_cell_draw_reward_request_terminal)
        state_machine.add(every_day_achievement_list_cell_draw_reward_terminal)
        state_machine.init()
    end
    init_every_day_achievement_list_cell_draw_reward_terminal()
end


function EveryDayAchievementListCell:getOpenMaxSceneId(currentSceneType)
	local lastSceneId = -1
	local _scenes = dms.searchs(dms["pve_scene"], pve_scene.scene_type, currentSceneType)
	for i, v in pairs(_scenes) do
		local tempSceneId = dms.atoi(v, pve_scene.id)
		if _ED.scene_current_state[tempSceneId] == nil
			or _ED.scene_current_state[tempSceneId] == ""
			or tonumber(_ED.scene_current_state[tempSceneId]) < 0 
			then
			break
		end
		lastSceneId = tempSceneId
	end

	return lastSceneId, _scenes[1]
end

function EveryDayAchievementListCell:drawReward(reward)
    local rewardType = zstring.tonumber(reward[1])
    local rewardIcon = nil
    if rewardType == 6 then     --道具
        rewardIcon = PropIconCell:createCell()
        -- rewardIcon:init(16, reward[2], reward[3])
        rewardIcon:init(24, tostring(reward[2]), reward[3])
    elseif rewardType == 7 then     --装备
        rewardIcon = EquipIconCell:createCell()
        -- rewardIcon:init(8, nil, reward[2], nil)
        rewardIcon:init(10, nil, reward[2], nil)
    else
        rewardIcon = propMoneyIcon:createCell()
        if rewardType == 1 then
            rewardIcon:init(""..rewardType, reward[3], _All_tip_string_info._fundName)
        elseif rewardType == 2 then
            rewardIcon:init(""..rewardType, reward[3], _All_tip_string_info._crystalName)
		elseif rewardType == 3 then
            rewardIcon:init(""..6, reward[3], _All_tip_string_info._glories)
        elseif rewardType == 5 then
            rewardIcon:init(""..rewardType, reward[3], _All_tip_string_info._soulName)
        else
            rewardIcon = ResourcesIconCell:createCell()      
            rewardIcon:init(rewardType, -1, -1)
        end
    end
    -- if rewardIcon ~= nil then
    --     parent:addChild(rewardIcon)
    -- end
    return rewardIcon
end

function EveryDayAchievementListCell:isDrawedUpdateDraw()
    self:retain()
    local itmes = self.listView:getItems()
    for i=1,#itmes do
       if itmes[i] == self then
            self.listView:removeItem(i - 1)
            self.achievement_reward.state = 1
            self.listView:addChild(self)
			self:release()
            break
       end
    end
    -- state_machine.excute("daily_task_update_draw_daily_task_integral", 0, "")
end

function EveryDayAchievementListCell:onUpdateDraw()
   local root = self.roots[1]

    -- /**
    --  * 用户成就判断
    --  */
    local ACHIEVE_TYPE_USER = 0;
    -- /**
    --  * 战斗成就判断
    --  */
    local ACHIEVE_TYPE_FIGHT = 1;
    -- /**
    --  * 消费成就判断
    --  */
    local ACHIEVE_TYPE_CONSUME = 2;
    -- /**
    --  * //操作成就判断
    --  */
    local ACHIEVE_TYPE_OPERATE = 3;
    
    -- //用户成就判断
    -- /**
    --  * 判断用户等级
    --  */
    local ACHIEVE_TYPE_USER_BY_LEVEL = 0            --;//判断用户等级
    local ACHIEVE_TYPE_USER_BY_EQUIPMENT_ESCALATE_LEVE = 1            --; //装备强化等级
    local ACHIEVE_TYPE_USER_BY_EQUIPMENT_REFINE_LEVEL = 2            --; //装备精炼等级
    local ACHIEVE_TYPE_USER_BY_ALL_EQUIPMENT_ESCALATE_LEVE = 3            --;//全部装备强化等级
    local ACHIEVE_TYPE_USER_BY_ALL_EQUIPMENT_REFINE_LEVEL = 4            --;//全部装备精炼等级
    local ACHIEVE_TYPE_USER_BY_EQUIPMENT_QUALITY = 5            --;//装备品质
    local ACHIEVE_TYPE_USER_BY_DESTINY_LEVEL = 6            --;//天命等级
    local ACHIEVE_TYPE_USER_BY_JJC_ORDER = 7            --;//竞技场排名
    local ACHIEVE_TYPE_USER_BY_COMPOUND_TREASURE = 8            --;//合成宝物
    local ACHIEVE_TYPE_USER_BY_UNPARALLELED_ORDER = 9            --;//无双排名
    local ACHIEVE_TYPE_USER_BY_UNPARALLELED_STAR = 10            --;//无双星数
    local ACHIEVE_TYPE_USER_BY_MAX_REBEL_ARMY_DAMAGE = 11            --;//叛军伤害
    local ACHIEVE_TYPE_USER_BY_MAX_REBEL_ARMY_HONNER = 12            --;//叛军功勋
    local ACHIEVE_TYPE_USER_BY_FIGHTING_CAPACITY = 13            --;//战斗力
    local ACHIEVE_TYPE_USER_BY_VIP = 14            --;//VIP
    local ACHIEVE_TYPE_USER_BY_TOTAL_PATROL = 15            --;//巡逻时间
    local ACHIEVE_TYPE_USER_BY_PARTNER_LEVEL = 16            --;//上阵小伙伴等级
    local ACHIEVE_TYPE_USER_BY_INSTANCE_STAR = 17            --;//主线副本星数
    
    -- /**
    --  * 用户操作
    --  */
    local ACHIECE_TYPE_RESET_UNPARALLELED = 0            --;//三国无双重置次数
    local ACHIECE_TYPE_REFRESH_SECRET_SHOP = 1            --;//神秘商店
    local ACHIECE_TYPE_EXCHANGE = 2            --;//神将兑换
    local ACHIECE_TYPE_SUPPERESE_ARMY = 3            --;//镇压暴动
    local ACHIECE_TYPE_PATROLTIME = 4            --; //累积巡逻时间
    local ACHIECE_TYPE_TOLTALKILLARMY = 5            --; //叛军击杀
    local ACHIECE_TYPE_TOLTALCOMPOUND = 6            --; //合成宝物次数

    local completeCount = zstring.tonumber(self.achievement_reward.complete_count)
    local drawRewardState = zstring.tonumber(self.achievement_reward.state)

    local dailyTaskMould = dms.element(dms["achieve"], self.achievement_reward.id)
    local dailyTaskTrace = dms.atoi(dailyTaskMould, achieve.track_address)
    local achiveType = dms.atoi(dailyTaskMould, achieve.achive_type)
    local useType = dms.atoi(dailyTaskMould, achieve.param1)
    local showComplete = dms.atoi(dailyTaskMould, achieve.show_progress)
	
    -- local condition = dms.atoi(dailyTaskMould, achieve.mission_condition)
    -- local conditionParam = zstring.split(dms.atos(dailyTaskMould, achieve.condition_param), ",") -- 商城购买道具道具ID,次数的conditionParam值为模板id,次数
    -- local needCompleteCount =  zstring.tonumber(conditionParam[#conditionParam])
    local needCompleteCount = 0

    if achiveType == ACHIEVE_TYPE_USER then  -- 用户成就判断

    elseif achiveType == ACHIEVE_TYPE_FIGHT then -- 战斗成就判断

    elseif achiveType == ACHIEVE_TYPE_CONSUME then -- 消费成就判断

    elseif achiveType == ACHIEVE_TYPE_OPERATE then -- 操作成就判断

    end   

    if useType == ACHIEVE_TYPE_USER_BY_ALL_EQUIPMENT_ESCALATE_LEVE 
        or useType == ACHIEVE_TYPE_USER_BY_ALL_EQUIPMENT_REFINE_LEVEL
		or useType == ACHIEVE_TYPE_USER_BY_EQUIPMENT_QUALITY
        then
        needCompleteCount = dms.atoi(dailyTaskMould, achieve.param3)
    else
        needCompleteCount = dms.atoi(dailyTaskMould, achieve.param2)
    end

    -- needCompleteCount = needCompleteCount or 100
    -- 绘制描述信息
    local completeString = dms.atos(dailyTaskMould, achieve.title)
    if showComplete == 1 then
        completeString = completeString .. "("..completeCount .. "/" ..needCompleteCount..")"
    end
    ccui.Helper:seekWidgetByName(root, "Text_103"):setString(completeString)
    -- -- 绘制日常任务的进度
    -- ccui.Helper:seekWidgetByName(root, "Text_rc_5"):setString(completeCount .. "/" ..needCompleteCount)

    -- 任务奖励(资源号-模板,值)
    -- 绘制奖励
    -- local rewardIcon = dms.atos(dailyTaskMould, achieve.pic)
    -- local rewardParam = zstring.split(dms.atos(dailyTaskMould, achieve.reward_value), "|")
    -- rewardParam = zstring.split(rewardParam[1], ",")
    -- local rewardType = zstring.split(rewardParam[1], "-")
    -- ccui.Helper:seekWidgetByName(root, "Panel_1"):setBackGroundImage(string.format("images/ui/function_icon/function_icon_%d.png", rewardIcon))
    -- ccui.Helper:seekWidgetByName(root, "Panel_1"):setBackGroundImage(string.format("images/ui/props/props_%d.png", rewardIcon))
    local rewardString = dms.atos(dailyTaskMould, achieve.descript)
    -- -- 绘制描述信息
    -- ccui.Helper:seekWidgetByName(root, "Text_rc_3"):setString(rewardString)

    -- 查看奖励信息的事件响应
    -- ..

    -- -- 领取奖励的事件响应
    -- local drawButton = ccui.Helper:seekWidgetByName(root, "Button_1")
    -- drawButton:setVisible(false)
    -- drawButton:setVisible(drawRewardState == 1 and completeCount >= needCompleteCount)

    -- -- 前往奖励的事件响应
    -- local traceButton = ccui.Helper:seekWidgetByName(root, "Button_2")
    -- traceButton:setVisible(false)
    -- traceButton:setVisible(drawRewardState == 0 and completeCount < needCompleteCount and dailyTaskTrace > 0)

    -- 根据不同的情况，选项区域响应不同的逻辑
    -- ..

    -- -- print("drawRewardState:", drawRewardState)
    -- ccui.Helper:seekWidgetByName(root, "Image_38"):setVisible(drawRewardState == 2 and completeCount >= needCompleteCount) 

    if drawRewardState == 0 then
        if useType == ACHIEVE_TYPE_USER_BY_JJC_ORDER or useType == ACHIEVE_TYPE_USER_BY_UNPARALLELED_ORDER  then
            if completeCount > 0 then
                if completeCount <= needCompleteCount then
                    completeCount = needCompleteCount
                     self.drawState = 1
                else
                    self.drawState = 0
                end
            else
                self.drawState = 0
            end
        else
            if completeCount >= needCompleteCount then
                self.drawState = 1
            else
                self.drawState = 0
            end
        end
    else
        self.drawState = 2
    end
	
    local activity = _ED.active_activity[42]
    local Button_qianwang = ccui.Helper:seekWidgetByName(root, "Button_qianwang")
    local Button_lingqu = ccui.Helper:seekWidgetByName(root, "Button_lingqu")
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
            if Button_lingqu == nil or Button_qianwang == nil then
                return
            end
    end
    Button_lingqu:setVisible(self.drawState == 1 and zstring.tonumber(activity.activity_over_time) >= 0)
    Button_qianwang:setVisible(self.drawState == 0 and zstring.tonumber(activity.activity_over_time) > 0)
    -- ccui.Helper:seekWidgetByName(root, "Button_chongzhi"):setVisible(self.drawState == 0 and needGold > 0)
    -- 未达成的状态显示
    ccui.Helper:seekWidgetByName(root, "Image_14"):setVisible(self.drawState == 0 and zstring.tonumber(activity.activity_over_time) <= 0)
    ccui.Helper:seekWidgetByName(root, "Image_13"):setVisible(self.drawState == 2)
	
	
	if zstring.tonumber(_ED._sevenDaysActivity_currentActivityDayCount) < zstring.tonumber(_ED._sevenDaysActivity_selectActivityDayCount) then

         Button_qianwang:setBright(false)
		 Button_lingqu:setBright(false)
		 
         Button_qianwang:setTouchEnabled(false)
         Button_lingqu:setTouchEnabled(false)
	end
end

function EveryDayAchievementListCell:initDraw()
    local csbEveryDayAchievementListCell= nil
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
        csbEveryDayAchievementListCell= csb.createNode("activity/7days/week_Activities_mubiao_list.csb")      
    else
        csbEveryDayAchievementListCell= csb.createNode("activity/7days/week_Activities_list.csb")
    end
    local root = csbEveryDayAchievementListCell:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
    table.insert(self.roots, root)

    self:setContentSize(root:getContentSize())

	-- 列表控件动画播放
	local action = csb.createTimeline("activity/7days/week_Activities_list.csb")
    root:runAction(action)
    -- action:play("list_view_cell_open", false)
	action:gotoFrameAndPlay(15, 15, false)
	
    -- 绘制奖励信息
    local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
    listView:removeAllItems()
    listView:setSwallowTouches(false)
    local dailyTaskMould = dms.element(dms["achieve"], self.achievement_reward.id)
    local dailyTaskTrace = dms.atoi(dailyTaskMould, achieve.track_address)
    local rewards = zstring.split(dms.atos(dailyTaskMould, achieve.reward_value), "|")
    for i, v in pairs(rewards) do
        local reward = zstring.split(v, ",")
        listView:addChild(self:drawReward(reward))
    end

    -- 领取奖励的事件响应
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_lingqu"),       nil, 
    {
        terminal_name = "every_day_achievement_list_cell_draw_reward",      
        terminal_state = 0, 
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0):setSwallowTouches(false)

    -- 前往的事件响应
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_qianwang"),       nil, 
    {
        terminal_name = "every_day_achievement_list_cell_trace",      
        terminal_state = 0, 
        cell = self,
        trace_function_id = dailyTaskTrace,
        isPressedActionEnabled = true
    }, 
    nil, 0):setSwallowTouches(false)

    -- -- 去充值的事件响应
    -- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chongzhi"),       nil, 
    -- {
    --     terminal_name = "shortcut_open_recharge_window",     
    --     terminal_state = 0, 
    --     isPressedActionEnabled = true
    -- }, 
    -- nil, 0):setSwallowTouches(false)

    self:onUpdateDraw()
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.onUpdateDraw, self)
end

function EveryDayAchievementListCell:onEnterTransitionFinish()
    if self.roots[1] ~= nil then
        self:onUpdateDraw()
    end
end

function EveryDayAchievementListCell:onExit()

end

function EveryDayAchievementListCell:init(achievementIndex, rewardIndex, dayIndex, achievement_reward, listView)
    self.achievementIndex = achievementIndex
    self.rewardIndex = rewardIndex
    self.dayIndex = dayIndex
    self.achievement_reward = achievement_reward
    self.listView = listView
    self:initDraw()
    return self, self.drawState
end

function EveryDayAchievementListCell:createCell()
    local cell = EveryDayAchievementListCell:new()
    cell:registerOnNodeEvent(cell)
    return cell
end
