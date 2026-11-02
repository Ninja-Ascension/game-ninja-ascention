-- ----------------------------------------------------------------------------------------------------
-- 说明：日常任务的积分奖励
-------------------------------------------------------------------------------------------------------
DailyTaskIntegralRewardDailog = class("DailyTaskIntegralRewardDailogClass", Window)
    
function DailyTaskIntegralRewardDailog:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.rewardId = 0
    self.integralChestCell = nil
 
    -- Initialize daily task integral reward dailog state machine.
    local function init_daily_task_integral_reward_dailog_terminal()

        local daily_task_integral_reward_dailog_draw_reward_terminal = {
            _name = "daily_task_integral_reward_dailog_draw_reward",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseDrawLivenessRewardCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
                            state_machine.excute("daily_task_open_draw_update",0,"")                      
                        end
                        state_machine.excute("daily_task_integral_reward_dailog_close", 0, "")
                        state_machine.excute("daily_task_integral_chest_update_draw", 0, response.node.integralChestCell) 
                        app.load("client.reward.DrawRareReward")
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(42)
                        fwin:open(getRewardWnd, fwin._ui)
                    end
                end
                protocol_command.draw_liveness_reward.param_list = ""..(self.rewardId - 1)
                NetworkManager:register(protocol_command.draw_liveness_reward.code, nil, nil, nil, instance, responseDrawLivenessRewardCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local daily_task_integral_reward_dailog_close_terminal = {
            _name = "daily_task_integral_reward_dailog_close",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance == nil or instance.actions == nil then
				    return
                end
                instance.actions[1]:play("window_close_"..instance.rewardId, false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(daily_task_integral_reward_dailog_draw_reward_terminal)
        state_machine.add(daily_task_integral_reward_dailog_close_terminal)
        state_machine.init()
    end
    
    -- call func init daily task integral reward dailog state machine.
    init_daily_task_integral_reward_dailog_terminal()
end

function DailyTaskIntegralRewardDailog:init(rewardId, drawState, integralChestCell)
    self.rewardId = rewardId
    self.drawState = drawState
    self.integralChestCell = integralChestCell
    return self
end

function DailyTaskIntegralRewardDailog:initRewardInfo()
    local root = self.roots[1]
    local rewardElement = dms.element(dms["liveness_reward"], self.rewardId)
    local reward_data = {
        {1, -1, dms.atoi(rewardElement, liveness_reward.get_of_silver)},
        {12, -1, dms.atoi(rewardElement, liveness_reward.get_of_combat_food)},
        {2, -1, dms.atoi(rewardElement, liveness_reward.get_of_gold)},
        {3, -1, dms.atoi(rewardElement, liveness_reward.get_of_repute)},
        {-1, -1, dms.atoi(rewardElement, liveness_reward.get_of_power)},
        {-1, -1, dms.atoi(rewardElement, liveness_reward.get_of_fragment)},
        {6, dms.atoi(rewardElement, liveness_reward.get_of_prop), dms.atoi(rewardElement, liveness_reward.get_of_prop_amount)},
		{6, dms.atoi(rewardElement, liveness_reward.get_of_prop2), dms.atoi(rewardElement, liveness_reward.get_of_prop2_amount)},
        {6, dms.atoi(rewardElement, liveness_reward.get_of_prop3), dms.atoi(rewardElement, liveness_reward.get_of_prop3_amount)},
    }

    -- 更新领取状态
    local rewardDrawState = zstring.tonumber(_ED.daily_task_draw_index[self.rewardId]) == 1
    -- 奖励的汽泡信息
    ccui.Helper:seekWidgetByName(root, "Text_44"):setString((rewardDrawState == true and _string_piece_info[181] or dms.atos(rewardElement, liveness_reward.depic)))


    app.load("client.cells.equip.equip_icon_cell")
    app.load("client.cells.prop.prop_icon_cell")
    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.cells.prop.prop_money_icon")
    local drawIndex = 1
    for i, v in pairs(reward_data) do
        local rewardType = zstring.tonumber(v[1])
        if rewardType > 0 and zstring.tonumber(v[3]) > 0 then
            local Panel_12 = ccui.Helper:seekWidgetByName(root, "Panel_75_"..drawIndex)
            drawIndex = drawIndex + 1
            local rewardIcon = nil
            if rewardType == 6 then		--道具
                rewardIcon = PropIconCell:createCell()
                -- rewardIcon:init(16, v[2], v[3])
                if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
                    rewardIcon:init(32, tostring(v[2]), v[3])
                else
                    rewardIcon:init(24, tostring(v[2]), v[3])
                end
            elseif rewardType == 7 then		--装备
                rewardIcon = EquipIconCell:createCell()
                -- rewardIcon:init(8, nil, v[2], nil)
                rewardIcon:init(10, nil, v[2], nil)
            else
				rewardIcon = propMoneyIcon:createCell()
                if rewardType == 1 then
                    rewardIcon:init(""..rewardType, v[3], _All_tip_string_info._fundName)
                elseif rewardType == 2 then
				    rewardIcon:init(""..rewardType, v[3], _All_tip_string_info._crystalName)
                else
                    rewardIcon = ResourcesIconCell:createCell()      
                    rewardIcon:init(rewardType, -1, -1)
                end
            end
            Panel_12:addChild(rewardIcon)
        end
    end
end

function DailyTaskIntegralRewardDailog:onEnterTransitionFinish()
    local csbDailyTaskIntegralRewardDailog = csb.createNode("activity/DailyTasks/dailytasks_award.csb")
    self:addChild(csbDailyTaskIntegralRewardDailog)

    local root = csbDailyTaskIntegralRewardDailog:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline("activity/DailyTasks/dailytasks_award.csb")
	action:setTimeSpeed(app.getTimeSpeed())
    table.insert(self.actions, action)
    csbDailyTaskIntegralRewardDailog:runAction(action)
    -- action:gotoFrameAndPlay(0, action:getDuration(), false)
    action:play("window_open_"..self.rewardId, false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        -- local pos = string.find(str, "change_num_")
        if str == "over"..self.rewardId then
        elseif str == "close"..self.rewardId then
            fwin:close(self)
        end
        
    end)
	
	-- 初始化奖励信息
    self:initRewardInfo()

    -- 奖励已经领取
    ccui.Helper:seekWidgetByName(root, "Image_63"):setVisible(self.drawState == 2)

    -- 领取日常活动积分奖励的按钮事件响应
    local drawButton = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_13"),       nil, 
    {
        terminal_name = "daily_task_integral_reward_dailog_draw_reward",   
        current_button_name = "Button_12",
        but_image = "Image_close",       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0):setVisible(self.drawState <= 1)
    if self.drawState == 0 then
        drawButton:setBright(false)
        drawButton:setTouchEnabled(false)
    end


    -- 返回日常活动页面的按钮事件响应
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_12"),       nil, 
    {
        terminal_name = "daily_task_integral_reward_dailog_close",   
        current_button_name = "Button_12",
        but_image = "Image_close",       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
end

function DailyTaskIntegralRewardDailog:onExit()
	state_machine.remove("daily_task_integral_reward_dailog_draw_reward")
end