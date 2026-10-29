----------------------------------------------------------------------------------------------------
-- 说明：七日活动每日福利列表项
----------------------------------------------------------------------------------------------------
EveryDayWelfareListCell = class("EveryDayWelfareListCellClass", Window)

function EveryDayWelfareListCell:ctor()
    self.super:ctor()
    self.roots = {}

    self.rewardIndex = 0
    self.dayIndex = 0
    self.welfare = nil
    self.listView = nil

    self.command_param_list = ""

    self.drawState = 0    -- 0:不可领取  1：可领取  2：已经领取

    self.activity_recharge_gold = "0"

    app.load("client.cells.equip.equip_icon_cell")
    app.load("client.cells.prop.prop_icon_cell")
    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.cells.prop.prop_money_icon")
	app.load("client.cells.ship.ship_head_cell")

	local function init_every_day_welfare_list_cell_draw_reward_terminal()
        local every_day_welfare_list_cell_draw_reward_request_terminal = {
            _name = "every_day_welfare_list_cell_draw_reward_request",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseDrawWeekRewardCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
                            local reward_id = tonumber(response.node.welfare.id)
                            local dayIndex =  tonumber(response.node.dayIndex)
                            for i,v in ipairs(_ED.active_activity[42].seven_days_rewards[dayIndex].welfare) do
                                if reward_id == tonumber(v.id) then
                                    _ED.active_activity[42].seven_days_rewards[dayIndex].welfare[i].state = "1"
                                end
                            end     
                        end                           
                        response.node:isDrawedUpdateDraw()
                        app.load("client.reward.DrawRareReward")
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(47)
                        fwin:open(getRewardWnd, fwin._ui)

                        state_machine.excute("seven_days_activity_for_draw_ship_close", 0, "")
                    end
                end
				if TipDlg.drawStorageTipo() == false then
					local cell = params._datas.cell
					protocol_command.draw_week_reward.param_list = ""..cell.command_param_list
					NetworkManager:register(protocol_command.draw_week_reward.code, nil, nil, nil, cell, responseDrawWeekRewardCallback, false, nil)
                end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local every_day_welfare_list_cell_draw_reward_terminal = {
            _name = "every_day_welfare_list_cell_draw_reward",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                local dailyEelfareElement = dms.element(dms["daily_welfare"], cell.welfare.id)
                cell.command_param_list = "" .. cell.dayIndex .. "\r\n" .. 0 ..  "\r\n"..cell.welfare.id .. "\r\n"
                if dms.atoi(dailyEelfareElement, daily_welfare.is_select) == 1 then
                    app.load("client.activity.sevendays.SevenDaysForDrawShip")
                    fwin:open(SevenDaysForDrawShip:new():init(params), fwin._view)
                else
                    cell.command_param_list = cell.command_param_list .. "-1"
                    state_machine.excute("every_day_welfare_list_cell_draw_reward_request", 0, params)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(every_day_welfare_list_cell_draw_reward_request_terminal)
		state_machine.add(every_day_welfare_list_cell_draw_reward_terminal)
        state_machine.init()
	end
	init_every_day_welfare_list_cell_draw_reward_terminal()
end

function EveryDayWelfareListCell:isDrawedUpdateDraw()
    self:retain()
    local itmes = self.listView:getItems()
    for i=1,#itmes do
       if itmes[i] == self then
            self.listView:removeItem(i - 1)
            self.welfare.state = 1
            self.listView:addChild(self)
			self:release()
            break
       end
    end
    -- state_machine.excute("daily_task_update_draw_daily_task_integral", 0, "")
end

function EveryDayWelfareListCell:onUpdate(dt)
    local activity = _ED.active_activity[42]
    if activity ~= nil and self.activity_recharge_gold ~= activity.activity_recharge_gold then
        self:onUpdateDraw()
    end
end

function EveryDayWelfareListCell:onUpdateDraw()
    local root = self.roots[1]
    local completeCount = 0
    local needCompleteCount = 0
    local dailyEelfareElement = dms.element(dms["daily_welfare"], self.welfare.id)

    local activity = _ED.active_activity[42]

    local titleName = dms.atos(dailyEelfareElement, daily_welfare.descript)

    local needGold = dms.atoi(dailyEelfareElement, daily_welfare.reward_need_gold)
    if needGold > 0 then
        titleName = titleName .. "(" .. activity.activity_recharge_gold .. "/" .. needGold .. ")"
        completeCount = zstring.tonumber(activity.activity_recharge_gold)
        needCompleteCount = needGold
    end

    self.activity_recharge_gold = activity.activity_recharge_gold

    ccui.Helper:seekWidgetByName(root, "Text_103"):setString(titleName)

    local drawRewardState = zstring.tonumber(self.welfare.state)

	if drawRewardState == 0 then
		if completeCount >= needCompleteCount then
			self.drawState = 1
		else
			self.drawState = 0
		end
	else
		self.drawState = 2
	end

    -- if needGold > 0 then
    --     if zstring.tonumber(activity.activity_over_time) < 0 and zstring.tonumber(self.welfare.state) ~= 1 and self.drawState == 0 then
    --         ccui.Helper:seekWidgetByName(root, "Button_chongzhi"):setVisible(false)
    --         ccui.Helper:seekWidgetByName(root, "Button_lingqu"):setVisible(false)
    --         ccui.Helper:seekWidgetByName(root, "Image_14"):setVisible(true)
    --     else
    --         ccui.Helper:seekWidgetByName(root, "Button_chongzhi"):setVisible(self.drawState == 0 and needGold > 0)
    --         ccui.Helper:seekWidgetByName(root, "Button_lingqu"):setVisible(self.drawState == 1)
    --     end
    -- else
    --     ccui.Helper:seekWidgetByName(root, "Button_chongzhi"):setVisible(self.drawState == 0 and needGold > 0)
    --     ccui.Helper:seekWidgetByName(root, "Button_lingqu"):setVisible(self.drawState == 1)
    -- end
	
    ccui.Helper:seekWidgetByName(root, "Button_chongzhi"):setVisible(zstring.tonumber(activity.activity_over_time) >= 0 and self.drawState == 0)
    ccui.Helper:seekWidgetByName(root, "Button_lingqu"):setVisible(self.drawState == 1)
    ccui.Helper:seekWidgetByName(root, "Image_14"):setVisible(zstring.tonumber(activity.activity_over_time) < 0 and self.drawState == 0)
    ccui.Helper:seekWidgetByName(root, "Image_13"):setVisible(zstring.tonumber(self.welfare.state) == 1)
	
	
	if zstring.tonumber(_ED._sevenDaysActivity_currentActivityDayCount) < zstring.tonumber(_ED._sevenDaysActivity_selectActivityDayCount) then
		 ccui.Helper:seekWidgetByName(root, "Button_chongzhi"):setBright(false)
		 ccui.Helper:seekWidgetByName(root, "Button_lingqu"):setBright(false)
		 
		 ccui.Helper:seekWidgetByName(root, "Button_chongzhi"):setTouchEnabled(false)
		 ccui.Helper:seekWidgetByName(root, "Button_lingqu"):setTouchEnabled(false)
	end
	
end

function EveryDayWelfareListCell:drawReward(reward)
    local rewardType = zstring.tonumber(reward[1])
    local rewardIcon = nil
    if rewardType == 6 then     --道具
        rewardIcon = PropIconCell:createCell()
        -- rewardIcon:init(16, reward[2], reward[3])
        rewardIcon:init(27, tostring(reward[2]), reward[3])
    elseif rewardType == 7 then     --装备
        rewardIcon = EquipIconCell:createCell()
        -- rewardIcon:init(8, nil, reward[2], nil)
        rewardIcon:init(10, nil, reward[2], nil)
	elseif rewardType == 13 then     --武将
		rewardIcon = ShipHeadCell:createCell()
		rewardIcon:init(nil, 13, tostring(reward[2]), reward[3], true)
    else
        rewardIcon = propMoneyIcon:createCell()
        if rewardType == 1 then
            rewardIcon:init(""..rewardType, reward[3], _All_tip_string_info._fundName)
        elseif rewardType == 2 then
            rewardIcon:init(""..rewardType, reward[3], _All_tip_string_info._crystalName)
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

function EveryDayWelfareListCell:initDraw()
    local csbEveryDayWelfareListCell= nil
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
        csbEveryDayWelfareListCell = csb.createNode("activity/7days/week_Activities_fuli_list.csb")
    else
        csbEveryDayWelfareListCell = csb.createNode("activity/7days/week_Activities_list.csb")
        
    end
    local root = csbEveryDayWelfareListCell:getChildByName("root")
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
    local dailyEelfareElement = dms.element(dms["daily_welfare"], self.welfare.id)
    local rewards = zstring.split(dms.atos(dailyEelfareElement, daily_welfare.reward_value), "|")
    for i, v in pairs(rewards) do
        local reward = zstring.split(v, ",")
        listView:addChild(self:drawReward(reward))
    end

    -- 领取奖励的事件响应
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_lingqu"),       nil, 
    {
        terminal_name = "every_day_welfare_list_cell_draw_reward",      
        terminal_state = 0, 
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0):setSwallowTouches(false)

    -- 去充值的事件响应
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chongzhi"),       nil, 
    {
        terminal_name = "shortcut_open_recharge_window",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0):setSwallowTouches(false)

    self:onUpdateDraw()
end

function EveryDayWelfareListCell:onEnterTransitionFinish()
    if self.roots[1] ~= nil then
        self:onUpdateDraw()
    end
end

function EveryDayWelfareListCell:onExit()

end

function EveryDayWelfareListCell:init(rewardIndex, dayIndex, welfare, listView)
    self.rewardIndex = rewardIndex
	self.dayIndex = dayIndex
	self.welfare = welfare
    self.listView = listView
    self:initDraw()
    return self, self.drawState
end

function EveryDayWelfareListCell:createCell()
	local cell = EveryDayWelfareListCell:new()
	cell:registerOnNodeEvent(cell)
    cell:registerOnNoteUpdate(cell, 0.5)
	return cell
end

