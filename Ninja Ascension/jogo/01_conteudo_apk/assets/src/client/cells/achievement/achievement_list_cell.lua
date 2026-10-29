----------------------------------------------------------------------------------------------------
-- 说明：成就列表控件
----------------------------------------------------------------------------------------------------
AchievementListCell = class("AchievementListCellClass", Window)

function AchievementListCell:ctor()
    self.super:ctor()
    self.roots = {}

    self.current_type = 0
	self.userDailyTask = nil
    self.listView = listView

    self.drawState = 0    -- 0:不可领取  1：可领取  2：已经领取

	self._enum_type = {
		_DAILY_TASK_ACHIEVEMENT_PAGE = 2   -- 日常任务成就页面
	}

	local function init_achievement_list_cell_terminal()
		local achievement_list_cell_trace_terminal = {
            _name = "achievement_list_cell_trace",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local traceFunctionId = params._datas.trace_function_id
                if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
                    or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
                    if tonumber(traceFunctionId) == 37 then
                        state_machine.excute("platform_the_request_share", 0, "platform_the_request_share.")
                        return true
                    end
                end
                if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
                    if traceFunctionId == 9999 then
                        app.load("client.system.share.ShareCenter")
                        local invite_id = 0
                        for i=1,#dms["share_reward_mould"] do
                            local share_type = dms.int(dms["share_reward_mould"],i,share_reward_mould.share_type)
                            if share_type == 5 then
                                invite_id = dms.int(dms["share_reward_mould"],i,share_reward_mould.id)
                                break
                            end
                        end
                        state_machine.excute("shareCenter_to_getdata_and_open_share_dlg",0,{ _datas = { share_id = invite_id } })                   
                        return
                    end
                end
				local openFunctionId = dms.int(dms["function_param"], traceFunctionId, function_param.open_function)
                if dms.int(dms["fun_open_condition"], openFunctionId, fun_open_condition.level) <= zstring.tonumber(_ED.user_info.user_grade) then
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

        local achievement_list_cell_show_reward_info_terminal = {
            _name = "achievement_list_cell_show_reward_info",
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

        local achievement_list_cell_draw_reward_terminal = {
            _name = "achievement_list_cell_draw_reward",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                local function responseDrawAchieveRewardCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if __lua_project_id == __lua_project_adventure then
							state_machine.excute("adventure_achievement_update_draw", 0, nil)
							app.load("client.adventure.reward.AdventureTipReward")
                            local reward = getSceneReward(24)
                            if reward ~= nil then 
                                fwin:open(AdventureTipReward:new():init(reward), fwin._windows)
                            end
						else
                            -- if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
                                -- if response ~= nil and response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil  then
                                    -- response.node:isDrawedUpdateDraw()
                                -- end
                            -- else
                            --     response.node:isDrawedUpdateDraw()
                            -- end
							app.load("client.reward.DrawRareReward")
							local getRewardWnd = DrawRareReward:new()
							getRewardWnd:init(24)
							fwin:open(getRewardWnd, fwin._ui)
						end
                    else
                       
                    end
                end
                protocol_command.draw_achieve_reward.param_list = ""..cell.userDailyTask.daily_task_mould_id
                NetworkManager:register(protocol_command.draw_achieve_reward.code, nil, nil, nil, self, responseDrawAchieveRewardCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(achievement_list_cell_trace_terminal)
        state_machine.add(achievement_list_cell_show_reward_info_terminal)
		state_machine.add(achievement_list_cell_draw_reward_terminal)
        state_machine.init()
	end
	init_achievement_list_cell_terminal()
end

function AchievementListCell:isDrawedUpdateDraw()
    state_machine.excute("daily_task_update_draw_achievement_list_view", 0, "")
    -- self:retain()
    -- local itmes = self.listView:getItems()
    -- for i=1,#itmes do
    --    if itmes[i] == self then
    --         self.listView:removeItem(i - 1)
    --         self.userDailyTask.daily_task_param = 1
    --         self.listView:addChild(self)
    --         break
    --    end
    -- end
end

function AchievementListCell:onUpdateDraw()
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

	local PARAM_VALUE_3 = 3            --当前第一参数值为3
    local PARAM_VALUE_4 = 4            --当前第一参数值为4
	
    local completeCount = zstring.tonumber(self.userDailyTask.daily_task_complete_count)
    local drawRewardState = zstring.tonumber(self.userDailyTask.daily_task_param)

    local dailyTaskMould = dms.element(dms["achieve"], self.userDailyTask.daily_task_mould_id)
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
		or useType == ACHIEVE_TYPE_USER_BY_PARTNER_LEVEL
        then
        needCompleteCount = dms.atoi(dailyTaskMould, achieve.param3)
    else
        needCompleteCount = dms.atoi(dailyTaskMould, achieve.param2)
    end 

    --天命成就分为最大等级和所有上阵等级
    --此代码暂时屏蔽，服务器更新过后再打开
    -- if useType == ACHIEVE_TYPE_USER_BY_DESTINY_LEVEL then
    --     local achieveParam3 = dms.atoi(dailyTaskMould, achieve.param3)
    --     if achieveParam3 == -1 then
    --         needCompleteCount = dms.atoi(dailyTaskMould, achieve.param2)
    --     else 
    --         needCompleteCount = achieveParam3
    --     end
    -- end 
	
	if useType == PARAM_VALUE_3 or useType == PARAM_VALUE_4 then
		-- param1 为4||3 时,取param2为值
		needCompleteCount = dms.atoi(dailyTaskMould, achieve.param2)
	end
	
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
        if useType == ACHIEVE_TYPE_USER_BY_PARTNER_LEVEL then
            local limitLevel = 0
            --获取当前上阵英雄的最低等级
            for i ,v in pairs(_ED.user_formetion_status) do
                local shipId = v
                if shipId ~= nil then
                    if zstring.tonumber(shipId) > 0 then
                        if _ED.user_ship[shipId].ship_grade ~= nil then
                            if  limitLevel == 0 then
                                limitLevel = tonumber(_ED.user_ship[shipId].ship_grade)
                                --print("---------------------------",_ED.user_ship[shipId].ship_grade)
                            end
                            if limitLevel > tonumber(_ED.user_ship[shipId].ship_grade) then
                                limitLevel = tonumber(_ED.user_ship[shipId].ship_grade)
                            end
                        end
                    end
                end
            end
            completeCount = limitLevel
            needCompleteCount = dms.atoi(dailyTaskMould, achieve.param2)
        end
    end
    needCompleteCount = needCompleteCount or 100
    -- 绘制描述信息
    ccui.Helper:seekWidgetByName(root, "Text_rc_1"):setString(dms.atos(dailyTaskMould, achieve.title))
    -- 绘制日常任务的进度
    if showComplete == 1 then
		local completeCountStreamline = nil
		local needCompleteCountStreamline = nil
		if zstring.tonumber(completeCount) > 10000 then
			completeCountStreamline = math.floor(zstring.tonumber(completeCount)/1000)..string_equiprety_name[40]
		-- elseif zstring.tonumber(completeCount) > 100000000 then
		-- 	completeCountStreamline = math.floor(zstring.tonumber(completeCount)/100000000)..string_equiprety_name[38]
		else
			completeCountStreamline = zstring.tonumber(completeCount)
		end

		if zstring.tonumber(needCompleteCount) > 10000 then
			needCompleteCountStreamline = math.floor(zstring.tonumber(needCompleteCount)/1000)..string_equiprety_name[40]
		-- elseif zstring.tonumber(needCompleteCount) > 100000000 then
		-- 	needCompleteCountStreamline = math.floor(zstring.tonumber(needCompleteCount)/100000000)..string_equiprety_name[38]
		else
			needCompleteCountStreamline = zstring.tonumber(needCompleteCount)
			
		end
        ccui.Helper:seekWidgetByName(root, "Text_rc_5"):setString(completeCountStreamline .. "/" ..needCompleteCountStreamline)
    else
        ccui.Helper:seekWidgetByName(root, "Text_rc_4"):setVisible(false)
    end

    -- 任务奖励(资源号-模板,值)
    -- 绘制奖励
    local rewardIcon = dms.atos(dailyTaskMould, achieve.pic)
    local rewardParam = zstring.split(dms.atos(dailyTaskMould, achieve.reward_value), "|")
    rewardParam = zstring.split(rewardParam[1], ",")
    local rewardType = zstring.split(rewardParam[1], "-")
    -- ccui.Helper:seekWidgetByName(root, "Panel_1"):setBackGroundImage(string.format("images/ui/function_icon/function_icon_%d.png", rewardIcon))
	if __lua_project_id == __lua_project_adventure then
		ccui.Helper:seekWidgetByName(root, "Panel_1"):setBackGroundImage(string.format("images/ui/props/porps_%d.png", rewardIcon))
	else
		ccui.Helper:seekWidgetByName(root, "Panel_1"):setBackGroundImage(string.format("images/ui/props/props_%d.png", rewardIcon))
	end
    local rewardString = dms.atos(dailyTaskMould, achieve.descript)
    -- 绘制描述信息
    ccui.Helper:seekWidgetByName(root, "Text_rc_3"):setString(rewardString)

	
    -- 查看奖励信息的事件响应
    -- ..

    -- 领取奖励的事件响应
    local drawButton = ccui.Helper:seekWidgetByName(root, "Button_1")
    drawButton:setVisible(false)
    drawButton:setVisible(zstring.tonumber(drawRewardState) == 1 and zstring.tonumber(completeCount) >= zstring.tonumber(needCompleteCount))
	
    -- 前往奖励的事件响应
    local traceButton = ccui.Helper:seekWidgetByName(root, "Button_2")
    traceButton:setVisible(false)
    if __lua_project_id == __lua_project_adventure then
	else
		traceButton:setVisible(zstring.tonumber(drawRewardState) == 0 and zstring.tonumber(completeCount) < zstring.tonumber(needCompleteCount) and zstring.tonumber(dailyTaskTrace) > 0)
	end

    -- 根据不同的情况，选项区域响应不同的逻辑
    -- ..

    -- print("drawRewardState:", drawRewardState)
	if __lua_project_id == __lua_project_adventure then
	else
		ccui.Helper:seekWidgetByName(root, "Image_38"):setVisible(tonumber(drawRewardState) == 2 and tonumber(completeCount) >= tonumber(needCompleteCount)) 
	end

    if zstring.tonumber(drawRewardState) == 0 then
        self.drawState = 0
    elseif zstring.tonumber(drawRewardState) == 1 then
        if zstring.tonumber(completeCount) >= zstring.tonumber(needCompleteCount) then
            self.drawState = 1
        else
            self.drawState = 0
        end
    else
        self.drawState = 2
    end  
end

function AchievementListCell:initDraw()
    local csbDailyTaskListCell= csb.createNode("activity/DailyTasks/dailytasks_list.csb")
    local root = csbDailyTaskListCell:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
    local controllerPad = ccui.Helper:seekWidgetByName(root, "Panel_rcrw_list")
    -- controllerPad:setSwallowTouches(false)

    self:setContentSize(controllerPad:getContentSize())
	
	-- 列表控件动画播放
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
    else
    	local action = csb.createTimeline("activity/DailyTasks/dailytasks_list.csb")
        root:runAction(action)
        -- action:play("list_view_cell_open", false)
    	action:gotoFrameAndPlay(15, 15, false)
    end

    local dailyTaskMould = dms.element(dms["achieve"], self.userDailyTask.daily_task_mould_id)
    local dailyTaskTrace = dms.atoi(dailyTaskMould, achieve.track_address)

    local rewardParam = zstring.split(dms.atos(dailyTaskMould, achieve.reward_value), "|")
	if rewardParam[2] ~= nil then
		rewardParam = zstring.split(rewardParam[2], ",")
	else
		rewardParam = zstring.split(rewardParam[1], ",")
	end

	local function rewardTypeChange(_type)
		-- if _type == 9 then
			-- _type = 5
		-- elseif _type == 5 then
			-- _type = 6
		-- elseif _type == 6 then
			-- _type = 7
		-- end	
		
		return _type
	end
	
    -- 查看奖励信息的事件响应
    local showInfoPanel = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_3"),       nil, 
    {
        terminal_name = "achievement_list_cell_show_reward_info",      
        terminal_state = 0, 
        cell = self,
        reward = {rewardTypeChange(zstring.tonumber(rewardParam[1])), zstring.tonumber(rewardParam[2])}
    }, 
    nil, 0)

    -- 领取奖励的事件响应
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"),       nil, 
    {
        terminal_name = "achievement_list_cell_draw_reward",      
        terminal_state = 0, 
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0):setSwallowTouches(false)

    -- 前往奖励的事件响应
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"),       nil, 
    {
        terminal_name = "achievement_list_cell_trace",      
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

    self:onUpdateDraw()
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
    -- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.onUpdateDraw, self)
end

function AchievementListCell:onEnterTransitionFinish()
    if self.roots[1] ~= nil then
        self:onUpdateDraw()
    end
end

function AchievementListCell:onExit()

end

function AchievementListCell:init(interfaceType, userDailyTask, listView)
	self.current_type = interfaceType
	self.userDailyTask = userDailyTask
	
    self.listView = listView
    self:initDraw()
    return self, self.drawState
end

function AchievementListCell:createCell()
	local cell = AchievementListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

