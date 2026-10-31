-- ----------------------------------------------------------------------------------------------------
-- 说明：数码活动成就类型cell
-------------------------------------------------------------------------------------------------------
SmActivityPathGrowthAchieveCell = class("SmActivityPathGrowthAchieveCellClass", Window)
    
function SmActivityPathGrowthAchieveCell:ctor()
    self.super:ctor()
    self.roots = {}
    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.cells.equip.equip_icon_cell")
    app.load("client.cells.prop.prop_icon_cell")
    app.load("client.shop.recharge.RechargeDialog")
    app.load("client.reward.DrawRareReward")
    app.load("client.cells.prop.prop_money_icon")
    app.load("client.l_digital.activity.wonderful.PathGrowth")
    self.example = nil
    self.index = 0
    self.activityType = 0
    self.rewardState = 0

    self.reworld_sorting = {}
    -- Initialize SmActivityPathGrowthAchieveCell state machine.
    local function init_SmActivityPathGrowthAchieveCell_terminal()
        
        --领取
        local sm_activity_path_growth_achieve_reward_terminal = {
            _name = "sm_activity_path_growth_achieve_reward",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if _ED.active_activity[142] == nil then
                    return
                end

                local cells = params._datas._cell

                local function callback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node == nil or response.node.roots == nil or response.node.roots[1] == nil then
                            return
                        end

                        local cell = response.node
                        app.load("client.reward.DrawRareReward")
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(7, nil, cells.reworld_sorting)
                        fwin:open(getRewardWnd, fwin._ui)

                        local function getArrData( level )
                            local activity_params = _ED.active_activity[142].activity_params
                            for k,v in pairs(activity_params.actData) do
                                if tonumber(v.lev) == level then
                                    return v.taskArr
                                end
                            end
                            return nil
                        end

                        if getArrData(cells.level) then
                            cell:updateRewardInfo()
                            local act_type = dms.int(dms["activity_level_reward"], cell.activity.id, 2)
                            fwin:addService({
                                callback = function ( params )
                                    state_machine.excute("notification_center_update", 0, "push_notification_path_growth_level_day_push")
                                    state_machine.excute("sm_activity_path_growth_tab_type_update", 0, {cell.level, act_type})
                                end,
                                delay = 0,
                            })
                        else
                            state_machine.excute("sm_activity_path_growth_update", 0, 0)
                        end
                    end
                end

                local req = {}
                req.actId = _ED.active_activity[142].activity_id
                req.actType = 142
                req.rLev = cells.level
                req.rId = tonumber(cells.activity.id)

                local reqStr = json.encode(req)
                protocol_command.reward_grow_by_level.param_list = reqStr
                NetworkManager:register(protocol_command.reward_grow_by_level.code, nil, nil, nil, cells, callback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 前往
        local sm_activity_path_growth_achieve_go_to_terminal = {
            _name = "sm_activity_path_growth_achieve_go_to",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas._cell
                local condition = dms.string(dms["activity_level_reward"], cell.activity.id, 6)
                local trace_id = dms.int(dms["achieve"], condition, 13)
                if trace_id > 0 then
                    state_machine.excute("shortcut_function_trace", 0, {trace_function_id = trace_id, _datas = {}})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(sm_activity_path_growth_achieve_reward_terminal)
        state_machine.add(sm_activity_path_growth_achieve_go_to_terminal)
        state_machine.init()
    end
    
    -- call func init SmActivityPathGrowthAchieveCell state machine.
    init_SmActivityPathGrowthAchieveCell_terminal()
end

function SmActivityPathGrowthAchieveCell:onUpdateDraw()
    local root = self.roots[1]
    local GetButton = ccui.Helper:seekWidgetByName(root, "Button_12")       -- 领取   
    local Button_11 = ccui.Helper:seekWidgetByName(root, "Button_11")       -- 充值
    local Button_13 = ccui.Helper:seekWidgetByName(root, "Button_13")       -- 前往
    local Image_13 = ccui.Helper:seekWidgetByName(root, "Image_13")         -- 已领取
    Button_11:setVisible(false)
    GetButton:setVisible(false)
    GetButton:setTouchEnabled(true)
    GetButton:setBright(true)
    Button_13:setVisible(false)
    Image_13:setVisible(false)
end

function SmActivityPathGrowthAchieveCell:updateRewardInfo()
    local root = self.roots[1]
    local root = self.roots[1]
    local Text_11 = ccui.Helper:seekWidgetByName(root,"Text_11")
    local Text_13 = ccui.Helper:seekWidgetByName(root,"Text_13")

    local Image_ywc_1 = ccui.Helper:seekWidgetByName(root,"Image_16_0")

    local function getArrData( level )
        local activity_params = _ED.active_activity[142].activity_params
        for k,v in pairs(activity_params.actData) do
            if tonumber(v.lev) == level then
                return v.taskArr
            end
        end
        return nil
    end

    for i,v in ipairs(getArrData(self.level)) do
        if tonumber(self.activity.id) == tonumber(v.id) then
            self.activity = v
            break
        end
    end


    local act_type = dms.int(dms["activity_level_reward"], self.activity.id, 5)
    local condition = dms.string(dms["activity_level_reward"], self.activity.id, 6)

    local des = dms.string(dms["achieve"], condition, 2)
    local max = dms.string(dms["achieve"], condition, 7)
    local max1 = dms.int(dms["achieve"], condition, 8)
    local _achiv_type = dms.int(dms["achieve"], condition, 6)
    max = (_achiv_type == 25 or _achiv_type == 28) and max1 or max
    Text_11:setString(des)
    if self.activity ~= nil and self.activity.cc ~= nil then
        Text_13:setString(self.activity.cc .. "/" .. max)
    end

    local index = 1
    -- 奖励
    local rewordId = dms.int(dms["activity_level_reward"], self.activity.id, 7)
    local rewards = zstring.splits(dms.string(dms["program_reward"], rewordId, 63), "|", ",")
    local ListView_11 = ccui.Helper:seekWidgetByName(root,"ListView_11")
    ListView_11:removeAllItems()

    for i, reward in ipairs(rewards) do
        local rewardType = zstring.tonumber(reward[1])
        local cell = ResourcesIconCell:createCell()
        if 13 == rewardType then
            local table = {}
            if reward[4] ~= nil and tonumber(reward[4]) ~= -1 then
                table.shipStar = tonumber(reward[4])
            end
            cell:init(rewardType, tonumber(reward[3]), tonumber(reward[2]),nil,nil,true,true,1,table)
        else
            cell:init(rewardType, tonumber(reward[3]), tonumber(reward[2]),nil,nil,true,true,1)
        end
        local rewardinfo = {}
        rewardinfo.type = rewardType
        rewardinfo.id = reward[2]
        rewardinfo.number = tonumber(reward[3])
        self.reworld_sorting[index] = rewardinfo
        index = index + 1
        ListView_11:addChild(cell)

        local GetButton = ccui.Helper:seekWidgetByName(root, "Button_12")       -- 领取   
        local Button_11 = ccui.Helper:seekWidgetByName(root, "Button_11")       -- 充值
        local Button_13 = ccui.Helper:seekWidgetByName(root, "Button_13")       -- 前往
        local Image_13 = ccui.Helper:seekWidgetByName(root, "Image_13")         -- 已领取

        -- 进度已完成，可以领取
        if tonumber(self.activity.st) == 1 then
            GetButton:setVisible(true)
            Button_13:setVisible(false)
            Image_13:setVisible(false)
        -- 进度没完成，不能领取
        elseif tonumber(self.activity.st) == 0 then
            GetButton:setVisible(false)
            Button_13:setVisible(true)
            Image_13:setVisible(false)
        -- 已经领取
        elseif tonumber(self.activity.st) == 2 then
            GetButton:setVisible(false)
            Button_13:setVisible(false)
            Image_13:setVisible(true)
        end
    end
end

function SmActivityPathGrowthAchieveCell:onEnterTransitionFinish()

end

function SmActivityPathGrowthAchieveCell:onInit()
    local root = cacher.createUIRef("activity/wonderful/path_growth_list.csb", "root")
    table.insert(self.roots, root)
    root:removeFromParent(false)
    self:addChild(root)
    
    self:setContentSize(root:getChildByName("Panel_land_list"):getContentSize())
    state_machine.excute("shortcut_function_goto_log", 0, shortcut.shortcut_function_back_scene_enum.AccumlateConsumption)
    
    self:onUpdateDraw()
    self:updateRewardInfo()

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_12"), nil, 
        {
            terminal_name = "sm_activity_path_growth_achieve_reward", 
            terminal_state = 0, 
            _index = self.index,
            _cell = self,           
            isPressedActionEnabled = true
        },
        nil,0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_13"), nil, 
    {
        terminal_name = "sm_activity_path_growth_achieve_go_to", 
        terminal_state = 0, 
        _cell = self,           
        isPressedActionEnabled = true
    },
    nil,0)
end

function SmActivityPathGrowthAchieveCell:clearUIInfo( ... )
    local root = self.roots[1]
    local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_11")
    if ListViewDraw ~= nil then
        ListViewDraw:removeAllItems()
    end
    local Button_11 = ccui.Helper:seekWidgetByName(root, "Button_11")
    local Button_12 = ccui.Helper:seekWidgetByName(root, "Button_12")
    local Button_13 = ccui.Helper:seekWidgetByName(root, "Button_13")
    local Image_13 = ccui.Helper:seekWidgetByName(root, "Image_13")
    local Text_13 = ccui.Helper:seekWidgetByName(root, "Text_13")
    if Button_11 ~= nil then
        Button_11:setVisible(true)
        Button_12:setVisible(true)
        Button_12:setTouchEnabled(true)
        Button_12:setBright(true)
        Button_13:setVisible(false)
        Image_13:setVisible(false)
        Text_13:setVisible(true)
        Text_13:setString("")
    end
end

function SmActivityPathGrowthAchieveCell:onExit()
    self:clearUIInfo()
    cacher.freeRef("activity/wonderful/path_growth_list.csb", self.roots[1])
end

function SmActivityPathGrowthAchieveCell:init(params)
    self.activity = params[1]
    self.level = params[2]
    self:onInit()
end

function SmActivityPathGrowthAchieveCell:createCell()
    local cell = SmActivityPathGrowthAchieveCell:new()
    cell:registerOnNodeEvent(cell)
    return cell
end