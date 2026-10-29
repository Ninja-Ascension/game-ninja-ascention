-- ----------------------------------------------------------------------------------------------------
-- 说明：祭天的积分奖励
-------------------------------------------------------------------------------------------------------
UnionHeaverIntegralRewardDailog = class("UnionHeaverIntegralRewardDailogClass", Window)
    
function UnionHeaverIntegralRewardDailog:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.index = 0
    self.rewardInfo = 0
    self.integralChestCell = nil
 
    -- Initialize daily task integral reward dailog state machine.
    local function init_union_heaver_integral_reward_dailog_terminal()

        local union_heaver_integral_reward_dailog_draw_reward_terminal = {
            _name = "union_heaver_integral_reward_dailog_draw_reward",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseDrawLivenessRewardCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("union_heaver_integral_reward_dailog_close", 0, "")
                        state_machine.excute("union_heaver_integral_chest_update_draw", 0, response.node.integralChestCell) 
                        app.load("client.reward.DrawRareReward")
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(54)
                        fwin:open(getRewardWnd, fwin._ui)
                    end
                end
                protocol_command.draw_union_liveness_reward.param_list = ""..(instance.index - 1)
                NetworkManager:register(protocol_command.draw_union_liveness_reward.code, nil, nil, nil, instance, responseDrawLivenessRewardCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_heaver_integral_reward_dailog_close_terminal = {
            _name = "union_heaver_integral_reward_dailog_close",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance.actions[1]:play("window_close_"..instance.index, false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(union_heaver_integral_reward_dailog_draw_reward_terminal)
        state_machine.add(union_heaver_integral_reward_dailog_close_terminal)
        state_machine.init()
    end
    
    -- call func init daily task integral reward dailog state machine.
    init_union_heaver_integral_reward_dailog_terminal()
end

function UnionHeaverIntegralRewardDailog:init(index, rewardInfo, drawState, integralChestCell)
    self.index = index
    self.rewardInfo = rewardInfo
    self.drawState = drawState
    self.integralChestCell = integralChestCell
    return self
end

function UnionHeaverIntegralRewardDailog:initRewardInfo()
    local root = self.roots[1]
    local reward_data = {zstring.split(self.rewardInfo, ",")}

    ccui.Helper:seekWidgetByName(root, "Text_37"):setString(tipStringInfo_union_str[22 + tonumber(self.index)])
    if tonumber(self.drawState) == 0 then
        local getRewardProgress = zstring.split(dms.string(dms["union_lobby_param"], _ED.union.union_info.union_grade, union_lobby_param.getRewardProgress), "|")
        local info = string.format(tipStringInfo_union_str[27], getRewardProgress[tonumber(self.index)])
        ccui.Helper:seekWidgetByName(root, "Text_44"):setString(info)
    elseif tonumber(self.drawState) == 2 then
        ccui.Helper:seekWidgetByName(root, "Text_44"):setString(tipStringInfo_union_str[28])
    else
        ccui.Helper:seekWidgetByName(root, "Text_44"):setString("")
    end

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
                if __lua_project_id == __lua_project_gragon_tiger_gate
                    or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    then
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
                elseif rewardType == 28 then
                    rewardIcon:init(""..rewardType, v[3], _All_tip_string_info._union_exploit)
					-- rewardIcon = ResourcesIconCell:createCell()      
					-- rewardIcon:init(0, 0, 0, {show_reward_list={{prop_type = 28, item_value =v[3] }}})
				else
                    rewardIcon = ResourcesIconCell:createCell()      
                    rewardIcon:init(rewardType, -1, -1)
                end
            end
            Panel_12:addChild(rewardIcon)
        end
    end
end

function UnionHeaverIntegralRewardDailog:onEnterTransitionFinish()
    local csbUnionHeaverIntegralRewardDailog = csb.createNode("activity/DailyTasks/dailytasks_award.csb")
    self:addChild(csbUnionHeaverIntegralRewardDailog)

    local root = csbUnionHeaverIntegralRewardDailog:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline("activity/DailyTasks/dailytasks_award.csb")
	action:setTimeSpeed(app.getTimeSpeed())
    table.insert(self.actions, action)
    csbUnionHeaverIntegralRewardDailog:runAction(action)
    -- action:gotoFrameAndPlay(0, action:getDuration(), false)
    action:play("window_open_"..self.index, false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        -- local pos = string.find(str, "change_num_")
        if str == "over"..self.index then
        elseif str == "close"..self.index then
            fwin:close(self)
        end
        
    end)
	
	-- 初始化奖励信息
    self:initRewardInfo()

    -- 奖励已经领取
    ccui.Helper:seekWidgetByName(root, "Image_63"):setVisible(self.drawState == 2)

    -- 领取积分奖励的按钮事件响应
    local drawButton = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_13"),       nil, 
    {
        terminal_name = "union_heaver_integral_reward_dailog_draw_reward",
        cell = self,
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0):setVisible(self.drawState <= 1)
    if self.drawState == 0 then
        drawButton:setBright(false)
        drawButton:setTouchEnabled(false)
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_12"),       nil, 
    {
        terminal_name = "union_heaver_integral_reward_dailog_close", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 2)
end

function UnionHeaverIntegralRewardDailog:onExit()
	state_machine.remove("union_heaver_integral_reward_dailog_draw_reward")
end