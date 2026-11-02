--------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------
ActivitySuperPackCell = class("ActivitySuperPackCellClass", Window)
ActivitySuperPackCell.__size = nil

local activity_super_pack_cell_create_new_terminal = {
    _name = "activity_super_pack_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = ActivitySuperPackCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(activity_super_pack_cell_create_new_terminal)
state_machine.init()

function ActivitySuperPackCell:ctor()
	self.super:ctor()
	self.roots = {}

    self._info = nil
    self.reworld_sorting = {}

    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.cells.equip.equip_icon_cell")
    app.load("client.cells.prop.prop_icon_cell")
    app.load("client.shop.recharge.RechargeDialog")
    app.load("client.reward.DrawRareReward")
    app.load("client.cells.prop.prop_money_icon")
    -- app.load("client.l_digital.activity.wonderful.ActivityDailyOnceRecharge")
    app.load("client.l_digital.activity.wonderful.ActivityOnceRecharge")

    -- 新的单笔充值界面
    app.load("client.activity.wonderful.ActivitySuperPack")
-- 
-- 
    local function init_activity_super_pack_cell_terminal()
        local activity_super_pack_cell_choose_terminal = {
            _name = "activity_super_pack_cell_choose",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                if cell.isComplete then
                    local function responseGetServerListCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            local getRewardWnd = DrawRareReward:new()
                            getRewardWnd:init(7, nil, rewardinfo)
                            fwin:open(getRewardWnd, fwin._ui)
                            if tonumber(cell.actType) == 151 then
                                state_machine.excute("activity_once_recharge", 0, nil)
                            -- FURY: y el 29150 (Monedas Premium) usa esta misma celda.
                            elseif tonumber(cell.actType) == 179 or tonumber(cell.actType) == 29150 then
                                -- state_machine.excute("activity_daily_once_recharge", 0, nil)
                                -- 新的刷新界面的状态机
                                state_machine.excute("activity_super_pack_refresh", 0, nil)
                            end
                        end
                    end
                    local activityId = _ED.active_activity[cell.actType].activity_id   
                    protocol_command.get_activity_reward.param_list = activityId.."\r\n"..(tonumber(cell._info.index)-1).."\r\n1"
                    NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, cell, responseGetServerListCallback, false, nil)
                    return true
                else
                    local rechargeDimond = tonumber(zstring.split(cell._info.activityInfo_need_day, ",")[1])
                    local function reCallback()
                        state_machine.excute("shortcut_open_recharge_window", 0, "")
                    end
                    app.load("client.shop.recharge.RechargeVoucher")
                    RechargeVoucher.getCanUseVoucher({recharge_dimond = rechargeDimond},reCallback)
                    
                    
                    if fwin:find("ActivityWindowClass") then
                        app.load("client.activity.ActivityWindow")
                        state_machine.excute("activity_window_close",0, "")
                    end

                    -- 打开充值界面 关闭活动界面
                    if fwin:find("ActivitySuperPackClass") then
                        state_machine.excute("activity_super_pack_window_close", 0, nil)
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(activity_super_pack_cell_choose_terminal)
        state_machine.init()
    end
    init_activity_super_pack_cell_terminal()
end

function ActivitySuperPackCell:updateDraw()
    local root = self.roots[1]
    self.isComplete = false
    local Text_11 = ccui.Helper:seekWidgetByName(root, "Text_11")
    local Button_12 = ccui.Helper:seekWidgetByName(root, "Button_12")
    local Button_11 = ccui.Helper:seekWidgetByName(root, "Button_11")
    local ListView_11 = ccui.Helper:seekWidgetByName(root, "ListView_11")
    local Image_ylq = ccui.Helper:seekWidgetByName(root, "Image_16_0")
    local Button_qw = ccui.Helper:seekWidgetByName(root, "Button_13")
    local Text_13 = ccui.Helper:seekWidgetByName(root, "Text_13")

    Button_11:setVisible(false)
    Button_12:setVisible(false)
    Image_ylq:setVisible(false)
    Button_qw:setVisible(false)
    ListView_11:removeAllItems()

    local activity_info = _ED.active_activity[self.actType]
    local activity_params = zstring.split(activity_info.activity_params, ",")

    -- 多语言活动配置
    local activity_name = nil
    if tipStringInfo_activity_local_data_property then
        -- FURY: el 29150 (Monedas Premium) nombra sus filas como el 179 («Recarga diaria %d diamantes»).
        local fury_name_type = tonumber(self.actType) == 29150 and 179 or self.actType
        activity_name = tipStringInfo_activity_local_data_property[tostring(fury_name_type)]
    end
    if nil ~= activity_name and "" ~= activity_name then
        activity_name = string.format(activity_name,tonumber(zstring.split(self._info.activityInfo_need_day, ",")[1]))
    else
        activity_name = self._info.activityInfo_name
    end
    Text_11:setString(activity_name)

    local maxCompNum = zstring.split(self._info.activityInfo_need_day, ",")[2]
    local leftNum = tonumber(maxCompNum) - self._info.curGetReward
    Text_13:setString(leftNum .. "/" .. maxCompNum)

    if tonumber(self._info.state) == 0 then
        Button_12:setVisible(false)
        Image_ylq:setVisible(false)
        Button_qw:setVisible(true)
        Text_13:setVisible(true)
        self.isComplete = false
    elseif tonumber(self._info.state) == 1 then
        Button_12:setVisible(true)
        Image_ylq:setVisible(false)
        Button_qw:setVisible(false)
        Text_13:setVisible(true)
        self.isComplete = true
    elseif tonumber(self._info.state) == 2 then
        Button_12:setVisible(false)
        Image_ylq:setVisible(true)
        Button_qw:setVisible(false)
        Text_13:setVisible(false)
    end

    local rewards = zstring.splits(self._info.activityInfo_reward_select, "|", ",")
    local activity_count = tonumber(#rewards)
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
        ListView_11:addChild(cell)
    end
    
    ListView_11:requestRefreshView()
end

function ActivitySuperPackCell:onInit()
    local csbActivityDiscount = csb.createNode("activity/wonderful/sm_value_packag_list.csb")
    local root = csbActivityDiscount:getChildByName("root")
    table.insert(self.roots, root)
    root:removeFromParent(false)
    self:addChild(root)

    if ActivitySuperPackCell.__size == nil then
        ActivitySuperPackCell.__size = ccui.Helper:seekWidgetByName(root, "Panel_land_list"):getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_12"), nil, 
    {
        terminal_name = "activity_super_pack_cell_choose", 
        terminal_state = 0,
        isPressedActionEnabled = true,
        cell = self,
    },
    nil,0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_13"), nil, 
    {
        terminal_name = "activity_super_pack_cell_choose", 
        terminal_state = 0,
        isPressedActionEnabled = true,
        cell = self,
    },
    nil,0)

	self:updateDraw()
end

function ActivitySuperPackCell:onEnterTransitionFinish()
end

function ActivitySuperPackCell:init(params)
    self._info = params[1]
    self.actType = params[2]
	self:onInit()
    self:setContentSize(ActivitySuperPackCell.__size)
    return self
end

function ActivitySuperPackCell:onExit()
end
