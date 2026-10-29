--------------------------------------------------------------------------------------------------------------
--  说明：7天乐奖励的单个控件
--------------------------------------------------------------------------------------------------------------
SmActivityPathGrowthWelfareCell = class("SmActivityPathGrowthWelfareCellClass", Window)
SmActivityPathGrowthWelfareCell.__size = nil

--创建cell
local sm_activity_path_growth_welfare_cell_terminal = {
    _name = "sm_activity_path_growth_welfare_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmActivityPathGrowthWelfareCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

-- 领取
local sm_activity_path_growth_welfare_cell_check_terminal = {
    _name = "sm_activity_path_growth_welfare_cell_check",
    _init = function (terminal)       
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if _ED.active_activity[142] == nil then
            return
        end

        local cells = params._datas.cells

        local function callback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node == nil or response.node.roots == nil or response.node.roots[1] == nil then
                    return
                end

                local cell = response.node
                app.load("client.reward.DrawRareReward")
                local getRewardWnd = DrawRareReward:new()

                getRewardWnd:init(7)
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

                if getArrData(cell.level) then
                    cell:updateDraw()
                    local act_type = dms.int(dms["activity_level_reward"], cell.activity.id, 2)
                    fwin:addService({
                        callback = function ( params )
                            state_machine.excute("notification_center_update", 0, "push_notification_path_growth_level_day_push")
                            state_machine.excute("sm_activity_path_growth_tab_type_update", 0, {cell.level, act_type})
                        end,
                        delay = 0,
                    })
                else
                    app.load("client.l_digital.activity.wonderful.PathGrowth")
                    state_machine.excute("sm_activity_path_growth_update", 0, 0)
                end
            end
        end

        local act_type = dms.int(dms["activity_level_reward"], cells.activity.id, 5)
        -- 请求订单
        if act_type == 4 and tonumber(cells.activity.st) == 0 then
            local rechargeIndex = dms.int(dms["activity_level_reward"], cells.activity.id, 6)
            m_reqcharge_info.prevRechargeIndex = rechargeIndex
            local function responseRechargeCallback(response)
                fwin:close(fwin:find("ConnectingViewClass"))
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    if cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_WINDOWS 
                        and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_LINUX 
                        and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_MAC 
                        then
                        local cur_need_money = dms.int(dms["top_up_goods"], rechargeIndex, 4)
                        local temp_rechargeIndex = 7
                        for i = 1, 7 do
                            local temp_money = dms.int(dms["top_up_goods"], i, 4)
                            if cur_need_money == temp_money then
                                temp_rechargeIndex = i
                            end
                        end
             --            if app.configJson.OperatorName == "cayenne" then
             --                -- if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPHONE or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPAD then
             -- --                     m_reqcharge_info.rechargeIndex = "5"
             -- --                 else
             --                    m_reqcharge_info.rechargeIndex = rechargeIndex
             --                -- end
             --            else
             --                m_reqcharge_info.rechargeIndex = "5"
             --            end
                        m_reqcharge_info.rechargeIndex = "" .. temp_rechargeIndex
                        state_machine.excute("platform_request_for_payment", 0, response.node)
                        return
                    else
                        state_machine.excute("recharge_for_path_growth_activity_request_recharge_vali", 0, 0)
                    end
                end
            end
            cc.UserDefault:getInstance():setStringForKey("paySpecialpid", ""..rechargeIndex)
            cc.UserDefault:getInstance():flush()
            protocol_command.request_top_up_order_number.param_list = "".. rechargeIndex .."\r\n"..m_sPayMould
            NetworkManager:register(protocol_command.request_top_up_order_number.code, nil, nil, nil, instance, responseRechargeCallback, false, nil)
        else
            local req = {}
            req.actId = _ED.active_activity[142].activity_id
            req.actType = 142
            req.rLev = cells.level
            req.rId = tonumber(cells.activity.id)

            local reqStr = json.encode(req)
            protocol_command.reward_grow_by_level.param_list = reqStr
            NetworkManager:register(protocol_command.reward_grow_by_level.code, nil, nil, nil, cells, callback, false, nil)
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_activity_path_growth_welfare_cell_terminal)
state_machine.add(sm_activity_path_growth_welfare_cell_check_terminal)
state_machine.init()

function SmActivityPathGrowthWelfareCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.rewardState = 0
    self.reworld_sorting = {}

    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.l_digital.activity.wonderful.PathGrowth")

    local function init_sm_activity_carnival_reward_cell_terminal()
        --请求完成订单
        local recharge_for_path_growth_activity_request_recharge_vali_terminal = {
            _name = "recharge_for_path_growth_activity_request_recharge_vali",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseRechargeCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("sm_activity_path_growth_update", 0, 0)
                    end
                end
                if app.configJson.UserAccountPlatformName ~= "jar-world" then
                    if m_play_pay_type~= nil and m_play_pay_type~="" then
                        protocol_command.vali_top_up_order_number.param_list =  "".._ED.user_info.user_id.."\r\n".._ED.recharge_result.recharge_id..m_play_pay_type
                    else
                        protocol_command.vali_top_up_order_number.param_list =  "".._ED.user_info.user_id.."\r\n".._ED.recharge_result.recharge_id
                    end
                else
                    protocol_command.vali_top_up_order_number.param_list =  "".._ED.user_info.user_id.."\r\n".._ED.recharge_result.recharge_id.."\r\n".."win32"
                end
                NetworkManager:register(protocol_command.vali_top_up_order_number.code, nil, nil, nil, instance, responseRechargeCallback, false, nil)
                -- NetworkManager:register(protocol_command.keep_alive.code, nil, nil, nil, nil, nil, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(recharge_for_path_growth_activity_request_recharge_vali_terminal)
        state_machine.init()
    end 

    init_sm_activity_carnival_reward_cell_terminal()
end

function SmActivityPathGrowthWelfareCell:getRewardShow()
    -- body
end

function SmActivityPathGrowthWelfareCell:updateDraw()
    local root = self.roots[1]
    local Text_welfare_name_1 = ccui.Helper:seekWidgetByName(root,"Text_welfare_name_1")
    local Text_welfare_p_1 = ccui.Helper:seekWidgetByName(root,"Text_welfare_p_1")
    local Text_welfare_p_2 = ccui.Helper:seekWidgetByName(root,"Text_welfare_p_2")
    local Image_ywc_1 = ccui.Helper:seekWidgetByName(root,"Image_ywc_1")
    local Button_lq_1 = ccui.Helper:seekWidgetByName(root,"Button_lq_1")
    local Text_1318 = ccui.Helper:seekWidgetByName(root,"Text_1318")

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

    if act_type == 1 then
        Text_welfare_p_1:setString(tipStringInfo_path_growth_tips[2])
    elseif act_type == 2 then
        local des = dms.string(dms["achieve"], condition, 2)
        local isShowPro = dms.int(dms["achieve"], condition, 13)
        Text_welfare_p_1:setString(des)
        if isShowPro == 1 then
            local max = dms.string(dms["achieve"], condition, 7)
            Text_welfare_p_2:setString(self.activity.cc .. "/" .. max)
        end
    elseif act_type == 3 then
        local cost = zstring.splits(condition, "|", ",")
        Text_prop_sell_1:setString(cost[1][3])
        Text_prop_disount_1:setString(cost[2][3])
    elseif act_type == 4 then
        local cost = dms.int(dms["top_up_goods"], condition, 4)
        if tonumber(self.activity.st) == 0 then
            Text_1318:setString(tipStringInfo_path_growth_tips[3] .. cost)
        else
            Text_1318:setString(tipStringInfo_path_growth_tips[5])
        end
        Text_welfare_p_1:setString(tipStringInfo_path_growth_tips[4])
    end

    -- 奖励
    local rewordId = dms.int(dms["activity_level_reward"], self.activity.id, 7)
    local reward = zstring.split(dms.string(dms["program_reward"], rewordId, 63), ",")
    local rewardType = zstring.tonumber(reward[1])
    local Panel_welfare_icon_1 = ccui.Helper:seekWidgetByName(root,"Panel_welfare_icon_1")
    Panel_welfare_icon_1:removeAllChildren(true)
    local cell = ResourcesIconCell:createCell()
    if 13 == rewardType then
        local table = {}
        if reward[4] ~= nil and tonumber(reward[4]) ~= -1 then
            table.shipStar = tonumber(reward[4])
        end
        cell:init(rewardType, tonumber(reward[3]), tonumber(reward[2]),nil,nil,true,true,1,table)
        local evo_image = dms.string(dms["ship_mould"], reward[2], ship_mould.fitSkillTwo)
        local evo_info = zstring.split(evo_image, ",")
        local evo_mould_id = evo_info[dms.int(dms["ship_mould"], reward[2], ship_mould.captain_name)]
        local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
        local word_info = dms.element(dms["word_mould"], name_mould_id)
        local name = word_info[3]
        Text_welfare_name_1:setString(name)
    else
        cell:init(rewardType, tonumber(reward[3]), tonumber(reward[2]),nil,nil,true,true,1)
        local types = tonumber(reward[1])
        if types == 1 then
            name = _All_tip_string_info._fundName
        elseif types == 2 then
            name = _All_tip_string_info._crystalName
        elseif types == 5 then
            name = _All_tip_string_info._soulName
        elseif types == 8 then
            name = reward_prop_list[8]
        elseif types == 18 then
            name = _All_tip_string_info._glories
        elseif types == 3 then
            name = _All_tip_string_info._reputation
        elseif types == 31 then
            name = red_alert_resouce_tip[1][1]
        elseif types == 33 then 
            name = _my_gane_name[14]
        elseif types == 34 then 
            name = _my_gane_name[15]
        elseif types == 4 then
            name = _All_tip_string_info._hero
        elseif 6 == rewardType then
            name = setThePropsIcon(tonumber(reward[2]))[2]
        elseif types == 7 then
            --获取装备名称索引
            local nameindex = dms.int(dms["equipment_mould"], tonumber(reward[2]), equipment_mould.equipment_name)
            --通过索引找到word_mould
            local word_info = dms.element(dms["word_mould"], nameindex)
            name = word_info[3]
        end
        Text_welfare_name_1:setString(name)
    end
    local rewardinfo = {}
    rewardinfo.type = rewardType
    rewardinfo.id = reward[2]
    rewardinfo.number = tonumber(reward[3])
    self.reworld_sorting[1] = rewardinfo
    Panel_welfare_icon_1:addChild(cell)   

    -- 进度没完成，不能领取 
    if tonumber(self.activity.st) == 0 then
        Button_lq_1:setBright(false)
        Button_lq_1:setTouchEnabled(false)
        Image_ywc_1:setVisible(false)
        if act_type == 3 or act_type == 4 then
            Button_lq_1:setBright(true)
            Button_lq_1:setTouchEnabled(true)
            Image_ywc_1:setVisible(false)
        end
    -- 进度已完成，可以领取
    elseif tonumber(self.activity.st) == 1 then
        Button_lq_1:setBright(true)
        Button_lq_1:setTouchEnabled(true)
        Image_ywc_1:setVisible(false)
    -- 已经领取
    elseif tonumber(self.activity.st) == 2 then
        Button_lq_1:setBright(false)
        Button_lq_1:setTouchEnabled(false)
        Image_ywc_1:setVisible(true)
    end

end

function SmActivityPathGrowthWelfareCell:onUpdate(dt)
    
end

function SmActivityPathGrowthWelfareCell:onInit()
    local root = cacher.createUIRef("activity/wonderful/path_growth_welfare_tab.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if SmActivityPathGrowthWelfareCell.__size == nil then
        SmActivityPathGrowthWelfareCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_lq_1"), nil, 
    {
        terminal_name = "sm_activity_path_growth_welfare_cell_check", 
        terminal_state = 0, 
        touch_black = true,
        cells = self,
    }, nil, 1)

    self:updateDraw()
end

function SmActivityPathGrowthWelfareCell:onEnterTransitionFinish()
    local root = self.roots[1]
end

function SmActivityPathGrowthWelfareCell:clearUIInfo()
    local root = self.roots[1]
    local Text_welfare_p_1 = ccui.Helper:seekWidgetByName(root,"Text_welfare_p_1")
    local Text_welfare_p_2 = ccui.Helper:seekWidgetByName(root,"Text_welfare_p_2")
    local Image_ywc_1 = ccui.Helper:seekWidgetByName(root,"Image_ywc_1")
    local Button_lq_1 = ccui.Helper:seekWidgetByName(root,"Button_lq_1")
    local Text_1318 = ccui.Helper:seekWidgetByName(root,"Text_1318")

    if Text_welfare_p_1 ~= nil then
        Text_welfare_p_1:setString("")
        Text_welfare_p_2:setString("")
        Image_ywc_1:setVisible(false)
        Button_lq_1:setBright(false)
        Button_lq_1:setTouchEnabled(false)
        Text_1318:setString(tipStringInfo_path_growth_tips[5])
    end
end

function SmActivityPathGrowthWelfareCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end

    self:onInit()
end

function SmActivityPathGrowthWelfareCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef("activity/wonderful/path_growth_welfare_tab.csb", root)
    root:stopAllActions()

    root:removeFromParent(true)
    self.roots = {}
end

function SmActivityPathGrowthWelfareCell:init(params)
    self.activity = params[1]
    self.level = params[2]

    self:onInit()

    self:setContentSize(SmActivityPathGrowthWelfareCell.__size)
    return self
end

function SmActivityPathGrowthWelfareCell:onExit()
    self:clearUIInfo()
    cacher.freeRef("activity/wonderful/path_growth_welfare_tab.csb", self.roots[1])
end