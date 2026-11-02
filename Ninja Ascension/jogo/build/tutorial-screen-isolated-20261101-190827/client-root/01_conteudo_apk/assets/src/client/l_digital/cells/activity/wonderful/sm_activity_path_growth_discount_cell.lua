--------------------------------------------------------------------------------------------------------------
--  说明：7天乐奖励的单个控件
--------------------------------------------------------------------------------------------------------------
SmActivityPathGrowthDiscountCell = class("SmActivityPathGrowthDiscountCellClass", Window)
SmActivityPathGrowthDiscountCell.__size = nil

--创建cell
local sm_activity_path_growth_discount_cell_terminal = {
    _name = "sm_activity_path_growth_discount_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmActivityPathGrowthDiscountCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

-- 领取
local sm_activity_path_growth_discount_cell_check_terminal = {
    _name = "sm_activity_path_growth_discount_cell_check",
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
                --debug.print_r(cell.reworld_sorting)
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

state_machine.add(sm_activity_path_growth_discount_cell_terminal)
state_machine.add(sm_activity_path_growth_discount_cell_check_terminal)
state_machine.init()

function SmActivityPathGrowthDiscountCell:ctor()
	self.super:ctor()
	self.roots = {}
    self.rewardState = 0
    self.reworld_sorting = {}

    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.l_digital.activity.wonderful.PathGrowth")

    local function init_sm_activity_carnival_reward_cell_terminal()

        local sm_activity_path_growth_discount_cell_set_number_terminal = {
            _name = "sm_activity_path_growth_discount_cell_set_number",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params[1]
                local mm_index = tonumber(params[2])
                if params[3] ~= nil and params[3] == true then
                else
                    cell:runAction(cc.Sequence:create({cc.DelayTime:create((mm_index - 1) * 0.1), cc.CallFunc:create(function ( sender )
                    cell:setVisible(true)
                    sender:runAction(cc.Sequence:create(
                        cc.ScaleTo:create(0.2, 0.9),
                        cc.ScaleTo:create(0.1, 1)
                        ))
                    end)}))
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_activity_path_growth_discount_cell_set_number_terminal)
        state_machine.init()
    end 

    init_sm_activity_carnival_reward_cell_terminal()

end

function SmActivityPathGrowthDiscountCell:updateDraw()
    local root = self.roots[1]
    local Text_discount_name_1 = ccui.Helper:seekWidgetByName(root,"Text_discount_name_1")
    local Text_prop_sell_1 = ccui.Helper:seekWidgetByName(root,"Text_prop_sell_1")
    local Text_prop_disount_1 = ccui.Helper:seekWidgetByName(root,"Text_prop_disount_1")
    local Image_ywc_1 = ccui.Helper:seekWidgetByName(root,"Image_ylq_1")

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
        Text_prop_sell_1:setString(tipStringInfo_path_growth_tips[2])
    elseif act_type == 2 then
        local des = dms.string(dms["achieve"], condition, 2)
        Text_prop_sell_1:setString(des)
        local isShowPro = dms.int(dms["achieve"], condition, 13)
        if isShowPro == 1 then
            local max = dms.string(dms["achieve"], condition, 7)
            Text_prop_disount_1:setString(self.activity.cc .. "/" .. max)
        end
    elseif act_type == 3 then
        local cost = zstring.splits(condition, "|", ",")
        Text_prop_sell_1:setString(cost[1][3])
        Text_prop_disount_1:setString(cost[2][3])
    elseif act_type == 4 then
        Text_prop_sell_1:setString(condition)
    end

    -- 奖励
    local rewordId = dms.int(dms["activity_level_reward"], self.activity.id, 7)
    local reward = zstring.split(dms.string(dms["program_reward"], rewordId, 63), ",")
    local rewardType = zstring.tonumber(reward[1])
    local Panel_discount_icon_1 = ccui.Helper:seekWidgetByName(root,"Panel_discount_icon_1")
    Panel_discount_icon_1:removeAllChildren(true)
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
        Text_discount_name_1:setString(name)
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
        Text_discount_name_1:setString(name)
    end
    local rewardinfo = {}
    rewardinfo.type = rewardType
    rewardinfo.id = reward[2]
    rewardinfo.number = tonumber(reward[3])
    self.reworld_sorting[1] = rewardinfo
    Panel_discount_icon_1:addChild(cell)
    
    local Button_lq_1 = ccui.Helper:seekWidgetByName(root,"Button_discount_buy_1")
    local Button_discount_lq_1 = ccui.Helper:seekWidgetByName(root,"Button_discount_lq_1")
    Button_discount_lq_1:setVisible(false)
    -- 进度没完成，不能领取 
    if tonumber(self.activity.st) == 0 then
        Button_lq_1:setBright(false)
        Button_lq_1:setTouchEnabled(false)
        Image_ywc_1:setVisible(false)
        Button_lq_1:setVisible(true)
        if act_type == 3 or act_type == 4 then
            Button_lq_1:setBright(true)
            Button_lq_1:setTouchEnabled(true)
            Image_ywc_1:setVisible(false)
            Button_lq_1:setVisible(true)
        end
    -- 进度已完成，可以领取
    elseif tonumber(self.activity.st) == 1 then
        Button_lq_1:setBright(true)
        Button_lq_1:setTouchEnabled(true)
        Image_ywc_1:setVisible(false)
        Button_lq_1:setVisible(true)
    -- 已经领取
    elseif tonumber(self.activity.st) == 2 then
        Button_lq_1:setBright(false)
        Button_lq_1:setTouchEnabled(false)
        Image_ywc_1:setVisible(true)
        Button_lq_1:setVisible(false)
    end
end

function SmActivityPathGrowthDiscountCell:onUpdate(dt)
    
end

function SmActivityPathGrowthDiscountCell:onInit()
    local root = cacher.createUIRef("activity/wonderful/path_growth_discount_tab.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if SmActivityPathGrowthDiscountCell.__size == nil then
        SmActivityPathGrowthDiscountCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_discount_buy_1"), nil, 
    {
        terminal_name = "sm_activity_path_growth_discount_cell_check", 
        terminal_state = 0, 
        touch_black = true,
		cells = self,
    }, nil, 1)


	self:updateDraw()
end

function SmActivityPathGrowthDiscountCell:onEnterTransitionFinish()
    local root = self.roots[1]
end

function SmActivityPathGrowthDiscountCell:clearUIInfo()
    local root = self.roots[1]
    local Text_welfare_p_1 = ccui.Helper:seekWidgetByName(root,"Text_welfare_p_1")
    local Text_welfare_p_2 = ccui.Helper:seekWidgetByName(root,"Text_welfare_p_2")
    local Image_ywc_1 = ccui.Helper:seekWidgetByName(root,"Image_ywc_1")
    local Button_lq_1 = ccui.Helper:seekWidgetByName(root,"Button_lq_1")
    if Text_welfare_p_1 ~= nil then
        Text_welfare_p_1:setString("")
        Text_welfare_p_2:setString("")
        Image_ywc_1:setVisible(false)
        Button_lq_1:setBright(false)
        Button_lq_1:setTouchEnabled(false)
        Button_lq_1:setVisible(true)
    end
end

function SmActivityPathGrowthDiscountCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end

    self:onInit()
end

function SmActivityPathGrowthDiscountCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("activity/wonderful/path_growth_discount_tab.csb", root)
    root:stopAllActions()

    root:removeFromParent(true)
    self.roots = {}
end

function SmActivityPathGrowthDiscountCell:init(params)
    self.activity = params[1]
    self.level = params[2]

	self:onInit()

    self:setContentSize(SmActivityPathGrowthDiscountCell.__size)
    return self
end

function SmActivityPathGrowthDiscountCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("activity/wonderful/path_growth_discount_tab.csb", self.roots[1])
end