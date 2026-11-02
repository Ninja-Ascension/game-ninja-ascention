----------------------------------------------------------------------------------------------------
-- 说明：七日活动每日福利列表
-------------------------------------------------------------------------------------------------------
SevenDaysBoxDialog = class("SevenDaysBoxDialogClass", Window)
app.load("client.cells.equip.equip_icon_cell")
app.load("client.cells.prop.prop_icon_cell")
app.load("client.cells.utils.resources_icon_cell")
app.load("client.cells.prop.prop_money_icon")
local seven_days_box_open_terminal = {
    _name = "seven_days_box_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local day_index = params._datas.day_index
        local box = SevenDaysBoxDialog:new()
        box:init(day_index)
        fwin:open(box,fwin._ui)
       return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(seven_days_box_open_terminal)
state_machine.init()

function SevenDaysBoxDialog:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self.reward_id = nil
    self.day_index = nil
    -- Initialize seven days activity for every day welfare page state machine.
    local function init_seven_days_box_terminal()
        
        --关闭
        local seven_days_box_close_terminal = {
            _name = "seven_days_box_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:close(instance)
               return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local seven_days_box_getreward_terminal = {
            _name = "seven_days_box_getreward",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseDrawWeekRewardCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        for i,v in ipairs(_ED.active_activity[42].seven_days_rewards[response.node.day_index].welfare) do
                            if response.node.reward_id == tonumber(v.id) then
                                _ED.active_activity[42].seven_days_rewards[response.node.day_index].welfare[i].state = "1"
                            end
                        end
                        response.node:onUpdateDraw()
                        app.load("client.reward.DrawRareReward")
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(47)
                        fwin:open(getRewardWnd, fwin._ui)
                        state_machine.excute("seven_days_every_day_update_state",0,"")
                        fwin:close(response.node)
                    end
                end
                protocol_command.draw_week_reward.param_list = "" .. instance.day_index .. "\r\n" .. 0 ..  "\r\n"..instance.reward_id .. "\r\n" .. "-1"
                NetworkManager:register(protocol_command.draw_week_reward.code, nil, nil, nil, instance, responseDrawWeekRewardCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(seven_days_box_close_terminal)
        state_machine.add(seven_days_box_getreward_terminal)
        state_machine.init()
    end
    
    -- call func init_seven_days_welfare_terminal state machine.
    init_seven_days_box_terminal()
end
function SevenDaysBoxDialog:initListView()
    local root = self.roots[1]
    local ListView_123 = ccui.Helper:seekWidgetByName(root,"ListView_123")
    local items = ListView_123:getItems()
    for i,v in pairs(items) do 
        local button = v
        fwin:addTouchEventListener(button,nil, 
        {
            terminal_name = "seven_days_welfare_change_day",      
            terminal_state = 0,
            _day_index = i,
            isPressedActionEnabled = true
        }, 
        nil, 0)
    end
end
function SevenDaysBoxDialog:onUpdateDraw()
    local root = self.roots[1]

    local rewards = nil
    local rewards_str_table = dms.searchs(dms["daily_welfare"],daily_welfare.reward_need_gold,0)

    for i, v in pairs(rewards_str_table) do
        if i == self.day_index then
            local id = dms.atoi(v,daily_welfare.id)
            local rewards_str = dms.string(dms["daily_welfare"],id,daily_welfare.reward_value)
            local rewards_table = zstring.split(rewards_str,"|")
            self.reward_id = id
            rewards = rewards_table
        end
    end


    local listView = ccui.Helper:seekWidgetByName(root, "ListView_jiangli")
    -- listView:removeAllChildren(true)
    listView:removeAllItems()
    for i,v in pairs(rewards) do
        local reward = zstring.split(v,",")

        local rewardType = zstring.tonumber(reward[1])
        local rewardCell = nil
        if rewardType == 6 then     --道具
            rewardCell = PropIconCell:createCell()
            rewardCell:init(27, tostring(reward[2]), reward[3])
        elseif rewardType == 7 then     --装备
            rewardCell = EquipIconCell:createCell()
            rewardCell:init(10, nil, reward[2], nil)
        elseif rewardType == 13 then     --武将
            rewardCell = ShipHeadCell:createCell()
            rewardCell:init(nil, 13, tostring(reward[2]), reward[3], true)
        else
            rewardCell = propMoneyIcon:createCell()
            if rewardType == 1 then
                rewardCell:init(""..rewardType, reward[3], _All_tip_string_info._fundName)
            elseif rewardType == 2 then
                rewardCell:init(""..rewardType, reward[3], _All_tip_string_info._crystalName)
            elseif rewardType == 5 then
                rewardCell:init(""..rewardType, reward[3], _All_tip_string_info._soulName)
            else
                rewardCell = ResourcesIconCell:createCell()      
                rewardCell:init(rewardType, -1, -1)
            end
        end
        listView:addChild(rewardCell)
    end
    listView:requestRefreshView()

    local Button_13 = ccui.Helper:seekWidgetByName(root, "Button_13")

    if _ED._sevenDaysActivity_currentActivityDayCount < self.day_index then
        Button_13:setTouchEnabled(false)
        Button_13:setBright(false)
        -- return
    end

    local state = 0
    for i,v in ipairs(_ED.active_activity[42].seven_days_rewards[self.day_index].welfare) do
        if self.reward_id == tonumber(v.id) then
            state = tonumber(v.state)
        end
    end

    local Image_63 = ccui.Helper:seekWidgetByName(root, "Image_63")
    if state == 1 then
        Image_63:setVisible(true)
        Button_13:setVisible(false)
    end
end

function SevenDaysBoxDialog:onEnterTransitionFinish()
end

function SevenDaysBoxDialog:onInit()
    local csbSevenDaysWelfare = csb.createNode("activity/7days/week_Activities_award.csb")
    self:addChild(csbSevenDaysWelfare)
    local root = csbSevenDaysWelfare:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline("activity/7days/week_Activities_award.csb")
    table.insert(self.actions, action)
    csbSevenDaysWelfare:runAction(action)
    action:play("window_open", false)
    self:onUpdateDraw()

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_12"),nil, 
    {
        terminal_name = "seven_days_box_close",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_13"),nil, 
    {
        terminal_name = "seven_days_box_getreward",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)    
end

function SevenDaysBoxDialog:onExit()
    state_machine.remove("seven_days_box_close")
    state_machine.remove("seven_days_box_getreward")
end

function SevenDaysBoxDialog:init(day_index)
    self.day_index = day_index
    self:onInit()
end
