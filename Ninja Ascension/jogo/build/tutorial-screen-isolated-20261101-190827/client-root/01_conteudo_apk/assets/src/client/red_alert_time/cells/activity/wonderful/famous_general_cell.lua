--------------------------------------------------------------------------------------------------------------
--  活动列表控件
--------------------------------------------------------------------------------------------------------------
FamousGeneralCell = class("FamousGeneralCellClass", Window)
FamousGeneralCell.__size = nil

--创建cell
local famous_general_create_cell_terminal = {
    _name = "famous_general_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local activity_info = params[1]
        local activity_type = params[2]
        local index = params[3]
        local day_index = params[4]
        local cell = FamousGeneralCell:new()
        cell:init(activity_info,activity_type,index,day_index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(famous_general_create_cell_terminal)
state_machine.init()

function FamousGeneralCell:ctor()
	self.super:ctor()
	self.roots = {}

  -- var 
  --活动类型
  self._activity_type = nil
  --活动信息
  self._activity_info = nil
  --下标
  self._index = nil
  --七日活动天数
  self._group_index = nil
  --列表
  self._listview = nil
	 -- Initialize famous_general_cell state machine.
    local function init_famous_general_cell_terminal()
        --领取奖励
        local famous_general_cell_get_reward_terminal = {
            _name = "famous_general_cell_get_reward",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)           
                local cell = params._datas.cell
                local activity_type = tonumber(cell._activity_type)
                local index = tonumber(cell._activity_info.achieve_index)
                local activity_data = _ED.activity_info[""..activity_type].activity_data
                if activity_type == 12 
                    or activity_type == 31
                    or activity_type == 36
                    then
                    if tonumber(cell._activity_info.achieve_state) == 0 then
                        state_machine.excute("recharge_dialog_window_open",0,"")
                        return
                    end
                elseif activity_type == 13 then
                    if tonumber(cell._activity_info.achieve_state) == 0 then
                        local rechargeIndex = activity_data[1][index].achieve_other_info
                        m_reqcharge_info.rechargeIndex = rechargeIndex --渠道充值档位记录
                        if zstring.tonumber(rechargeIndex) > 10 then
                            m_reqcharge_info.rechargeIndex = rechargeIndex-10
                        end
                        local function responseGetServerListCallback(response)
                            fwin:close(fwin:find("ConnectingViewClass"))
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                if cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_WINDOWS 
                                and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_LINUX 
                                and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_MAC then
                                    state_machine.excute("platform_request_for_payment", 0, response.node)
                                    return
                                end
                                local function responseCallback(response)
                                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                       state_machine.excute("one_recharge_set_positiony",0,"")
                                       state_machine.excute("one_recharge_two_set_positiony",0,"")
                                       state_machine.excute("nowday_topup_reward_set_positiony",0,"")
                                    end
                                end
                                protocol_command.vali_top_up_order_number.param_list =  "".._ED.user_info.user_id.."\r\n".._ED.recharge_result.recharge_id.."\r\n".."win32"
                                NetworkManager:register(protocol_command.vali_top_up_order_number.code, nil, nil, nil, nil, responseCallback, false, nil)
                            end
                        end
                        fwin:open(ConnectingView:new(), fwin._windows)
                        protocol_command.request_top_up_order_number.param_list = ""..rechargeIndex.."\r\n"..m_sPayMould
                        NetworkManager:register(protocol_command.request_top_up_order_number.code, nil, nil, nil, nil, responseGetServerListCallback, false, nil)
                        return
                    end
                elseif activity_type == 41 then     -- 41号单笔充值可多次购买领取做特殊处理
                    local achieve_complete_count = zstring.split(cell._activity_info.achieve_complete_count,"/")
                    local activity_add_state = zstring.split(_ED.activity_info[""..activity_type].activity_add_state,",")
                    if tonumber(achieve_complete_count[1]) <= tonumber(activity_add_state[index]) then
                        local rechargeIndex = activity_data[1][index].achieve_other_info
                        m_reqcharge_info.rechargeIndex = rechargeIndex --渠道充值档位记录
                        if zstring.tonumber(rechargeIndex) > 10 then
                            m_reqcharge_info.rechargeIndex = rechargeIndex-10
                        end
                        local function responseGetServerListCallback(response)
                            fwin:close(fwin:find("ConnectingViewClass"))
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                if cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_WINDOWS 
                                and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_LINUX 
                                and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_MAC then
                                    state_machine.excute("platform_request_for_payment", 0, response.node)
                                    return
                                end
                                local function responseCallback(response)
                                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                       state_machine.excute("one_recharge_set_positiony",0,"")
                                       state_machine.excute("one_recharge_two_set_positiony",0,"")
                                       state_machine.excute("nowday_topup_reward_set_positiony",0,"")
                                    end
                                end
                                protocol_command.vali_top_up_order_number.param_list =  "".._ED.user_info.user_id.."\r\n".._ED.recharge_result.recharge_id.."\r\n".."win32"
                                NetworkManager:register(protocol_command.vali_top_up_order_number.code, nil, nil, nil, nil, responseCallback, false, nil)
                            end
                        end
                        fwin:open(ConnectingView:new(), fwin._windows)
                        protocol_command.request_top_up_order_number.param_list = ""..rechargeIndex.."\r\n"..m_sPayMould
                        NetworkManager:register(protocol_command.request_top_up_order_number.code, nil, nil, nil, nil, responseGetServerListCallback, false, nil)
                        return
                    end
                elseif activity_type == 4 
                    or activity_type == 29
                    or activity_type == 30 then
                    if tonumber(cell._activity_info.achieve_state) == 0 then
                        state_machine.excute("wonderful_open_window_close",0,"")
                        if activity_type == 4 then
                            state_machine.excute("duplicate_manager_window_open",0,{2})
                        elseif activity_type == 29 then
                            state_machine.excute("equipment_window_open",0,"")
                        elseif activity_type == 30 then
                            state_machine.excute("hero_main_window_open",0,"")
                        end
                        return
                    end
                end
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("reward_obtain_window_open",0,{1000+activity_type})
                        if cell ~= nil and cell.updateDrawButtons ~= nil then
                            cell:updateDrawButtons()
                        end
                        local index = 0 
                        if activity_type == 3 then      -- 战力达成
                            for k,v in pairs(activity_data[1]) do
                                if tonumber(v.achieve_state) == 2 then 
                                    index = index + 1 
                                end
                            end 
                            if index == #activity_data[1] then
                                state_machine.excute("wonderful_open_remove_page",0,{activity_type})
                            else
                                state_machine.excute("fight_reward_set_positiony",0,"")
                            end
                        elseif activity_type == 4 then  -- 闯关奖励
                            for k,v in pairs(activity_data[1]) do
                                if tonumber(v.achieve_state) == 2 then 
                                    index = index + 1 
                                end
                            end 
                            if index == #activity_data[1] then
                                state_machine.excute("wonderful_open_remove_page",0,{activity_type})
                            else
                                state_machine.excute("confirm_reward_set_positiony",0,"")
                            end
                        elseif activity_type == 5 then  -- 元宝大放送
                            state_machine.excute("wing_sent_set_positiony",0,"")
                        elseif activity_type == 6 then  -- 冲级奖励
                            for k,v in pairs(activity_data[1]) do
                                if tonumber(v.achieve_state) == 2 then 
                                    index = index + 1 
                                end
                            end 
                            if index == #activity_data[1] then
                                state_machine.excute("wonderful_open_remove_page",0,{activity_type})
                            else
                                state_machine.excute("up_level_set_positiony",0,"")
                            end
                        elseif activity_type == 7 then  -- 七天
                            for k,v in pairs(activity_data) do
                                for k1,v1 in pairs(v) do
                                    if tonumber(v1.achieve_state) == 2 then 
                                        index = index + 1 
                                    end
                                end
                            end 
                            if index == #activity_data then
                                state_machine.excute("wonderful_open_remove_page",0,{activity_type})
                            else
                                state_machine.excute("seven_day_update",0,"")
                            end
                        elseif activity_type == 8 then  -- 名将招募
                            state_machine.excute("famous_general_set_positiony",0,"")
                            state_machine.excute("famous_general_set_complite_count",0,"")
                        elseif activity_type == 9 then  -- 成长计划VIP2
                            for k,v in pairs(activity_data[2]) do
                                if tonumber(v.achieve_state) == 2 then 
                                    index = index + 1 
                                end
                            end 
                            if index == #activity_data[2] then
                                state_machine.excute("wonderful_remove_page",0,{activity_type})
                            else
                                state_machine.excute("growth_plan_set_positiony",0,"")
                            end
                        elseif activity_type == 11 then -- 活跃奖励
                            state_machine.excute("active_reward_set_positiony",0,"")
                        elseif activity_type == 12 then -- 累计充值
                            for k,v in pairs(activity_data[1]) do
                                if tonumber(v.achieve_state) == 2 then 
                                    index = index + 1 
                                end
                            end 
                            if index == #activity_data[1] then
                                state_machine.excute("wonderful_open_remove_page",0,{activity_type})
                            else
                                state_machine.excute("topup_reward_set_positiony",0,"")
                            end
                        elseif activity_type == 13 then -- 单笔充值
                            for k,v in pairs(activity_data[1]) do
                                if tonumber(v.achieve_state) == 2 then 
                                    index = index + 1 
                                end
                            end 
                            if index == #activity_data[1] then
                                state_machine.excute("wonderful_remove_page",0,{activity_type})
                            else
                                state_machine.excute("one_recharge_set_positiony",0,"")
                            end
                        elseif activity_type == 14 then -- 邀请好友
                            state_machine.excute("invitation_friend_set_positiony",0,"")
                        elseif activity_type == 17 then -- 杂货铺
                            state_machine.excute("change_props_set_positiony", 0, "")
                        elseif activity_type == 20 then -- 累积消费
                            state_machine.excute("accumlate_consumption_set_positiony", 0, "")
                        elseif activity_type == 24 then -- 成长计划VIP3
                            for k,v in pairs(activity_data[2]) do
                                if tonumber(v.achieve_state) == 2 then 
                                    index = index + 1 
                                end
                            end 
                            if index == #activity_data[2] then
                                state_machine.excute("wonderful_remove_page",0,{activity_type})
                            else
                                state_machine.excute("growth_plan_three_set_positiony",0,"")
                            end
                        elseif activity_type == 25 then -- 成长计划VIP4
                            for k,v in pairs(activity_data[2]) do
                                if tonumber(v.achieve_state) == 2 then 
                                    index = index + 1 
                                end
                            end 
                            if index == #activity_data[2] then
                                state_machine.excute("wonderful_remove_page",0,{activity_type})
                            else
                                state_machine.excute("growth_plan_four_set_positiony",0,"")
                            end
                        elseif activity_type == 26 then  -- 侠客行奖励
                            for k,v in pairs(activity_data[1]) do
                                if tonumber(v.achieve_state) == 2 then 
                                    index = index + 1 
                                end
                            end 
                            if index == #activity_data[1] then
                                state_machine.excute("wonderful_open_remove_page",0,{activity_type})
                            else
                                state_machine.excute("wonderful_trialtower_set_positiony",0,"")
                            end
                        elseif activity_type == 27 then  -- 十四天乐
                            for k,v in pairs(activity_data) do
                                for k1,v1 in pairs(v) do
                                    if tonumber(v1.achieve_state) == 2 then 
                                        index = index + 1 
                                    end
                                end
                            end 
                            if index == #activity_data then
                                state_machine.excute("wonderful_open_remove_page",0,{activity_type})
                            else
                                state_machine.excute("fourteen_days_update",0,"")
                            end
                        elseif activity_type == 28 then  -- 华山论剑
                            for k,v in pairs(activity_data[1]) do
                                if tonumber(v.achieve_state) == 2 then 
                                    index = index + 1 
                                end
                            end 
                            if index == #activity_data[1] then
                                state_machine.excute("wonderful_open_remove_page",0,{activity_type})
                            else
                                state_machine.excute("wonderful_tourneyfield_set_positiony",0,"")
                            end
                        elseif activity_type == 29 then  -- 装备升级
                            for k,v in pairs(activity_data[1]) do
                                if tonumber(v.achieve_state) == 2 then 
                                    index = index + 1 
                                end
                            end 
                            if index == #activity_data[1] then
                                state_machine.excute("wonderful_open_remove_page",0,{activity_type})
                            else
                                state_machine.excute("wonderful_equip_set_positiony",0,"")
                            end
                        elseif activity_type == 30 then  -- 侠客培养
                            for k,v in pairs(activity_data[1]) do
                                if tonumber(v.achieve_state) == 2 then 
                                    index = index + 1 
                                end
                            end 
                            if index == #activity_data[1] then
                                state_machine.excute("wonderful_open_remove_page",0,{activity_type})
                            else
                                state_machine.excute("wonderful_hero_up_set_positiony",0,"")
                            end
                        elseif activity_type == 31 then  -- 累积充值(常驻活动)
                            for k,v in pairs(activity_data[1]) do
                                if tonumber(v.achieve_state) == 2 then 
                                    index = index + 1 
                                end
                            end 
                            if index == #activity_data[1] then
                                state_machine.excute("wonderful_remove_page",0,{activity_type})
                            else
                                state_machine.excute("accumulated_topup_set_positiony",0,"")
                            end
                        elseif activity_type == 36 then -- 每月充值福利
                            state_machine.excute("monthly_topup_reward_set_positiony", 0, "")
                        elseif activity_type == 39 then  -- 冲级奖励(特殊渠道)
                            if response.node ~= nil and response.node.roots ~= nil then
                                local activity_type = tonumber(response.node._activity_type)
                                local activity_data = _ED.activity_info[""..activity_type].activity_data
                                if activity_data ~= nil then
                                    for k,v in pairs(activity_data[response.node._group_index]) do
                                        if tonumber(v.achieve_state) == 2 then 
                                            index = index + 1 
                                        end
                                    end
                                    if index == #activity_data[response.node._group_index] then
                                        state_machine.excute("wonderful_remove_page",0,{activity_type})
                                        return
                                    end
                                end
                            end
                            state_machine.excute("up_level_two_set_positiony",0,"")
                        elseif activity_type == 41 then -- 单笔充值2
                            state_machine.excute("one_recharge_two_set_positiony",0,"")
                        end
                    end
                end
                local acitvity = _ED.activity_info[""..activity_type]
                protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n" ..activity_type .. "\r\n" .. (cell._group_index -1) .."\r\n" .. (index - 1)
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, cell, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(famous_general_cell_get_reward_terminal)
        state_machine.init()
    end
    
    -- call func famous_general_cell create state machine.
    init_famous_general_cell_terminal()
end

function FamousGeneralCell:updateDraw()
    local root = self.roots[1]
    self._listview:removeAllItems()

    local reward_items = self._activity_info.achieve_reward
    reward_items = zstring.split(reward_items,"|")
    for i,reward in pairs(reward_items) do
        local reward_tab = zstring.split(reward,",")
        local _item_value = tonumber(reward_tab[3])
        local _prop_type = tonumber(reward_tab[2])
        local _prop_item = tonumber(reward_tab[1])
        local data = 
        {
            item_value = _item_value,
            prop_type = _prop_type,
            prop_item = _prop_item,
        }
        local cell = nil
        if tonumber(self._activity_type) == 12 
            or tonumber(self._activity_type) == 13 
            or tonumber(self._activity_type) == 20
            or tonumber(self._activity_type) == 31
            or tonumber(self._activity_type) == 36
            or tonumber(self._activity_type) == 41
            then
            if tonumber(data.prop_type) == 6 then    
                if zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(data.prop_item), prop_mould.change_of_equipment))> 0 
                    or zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(data.prop_item), prop_mould.use_of_ship)) > 0  then
                    cell = state_machine.excute("all_resource_create_cell",0,{3,data,data,1,0,true,true,6})
                else
                    cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,1,0,true,true,6})
                end  
            elseif tonumber(data.prop_type) == 34 then    
                cell = state_machine.excute("all_resource_create_cell",0,{5,data,data,1,0,true,true,6})
            else
                cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,1,0,true,true,6})
            end
        else
            if tonumber(data.prop_type) == 6 then    
                if zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(data.prop_item), prop_mould.change_of_equipment))> 0 
                    or zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(data.prop_item), prop_mould.use_of_ship)) > 0  then
                    cell = state_machine.excute("all_resource_create_cell",0,{3,data,data,1,0,true,true})
                else
                    cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,1,0,true,true})
                end  
            elseif tonumber(data.prop_type) == 34 then    
                cell = state_machine.excute("all_resource_create_cell",0,{5,data,data,1,0,true,true})
            else
                cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,1,0,true,true})
            end
        end
        self._listview:addChild(cell)
    end

    self._listview:requestRefreshView()
end

function FamousGeneralCell:updateDrawButtons()
    local root = self.roots[1]
    if root == nil then
        return
    end
    local activity_type = self._activity_type
    local Text_active_inner = ccui.Helper:seekWidgetByName(root,"Text_active_inner")--描述
    local Text_active_number = ccui.Helper:seekWidgetByName(root,"Text_active_number")--进度
    local Button_recive = ccui.Helper:seekWidgetByName(root,"Button_recive") --领取   
    local Button_go = ccui.Helper:seekWidgetByName(root,"Button_go")         --前往
    local Text_recive = ccui.Helper:seekWidgetByName(root,"Text_recive") -- 前往/领取
    local Image_haved = ccui.Helper:seekWidgetByName(root,"Image_haved") --已领取
    Image_haved:setVisible(false)
    Text_active_inner:setString("")
    Text_active_number:setString("")

    Text_active_inner:setString(self._activity_info.achieve_mould_dec)
    local achieve_complete_count = zstring.split(self._activity_info.achieve_complete_count,"/")
    if tonumber(achieve_complete_count[1]) > tonumber(achieve_complete_count[2]) then 
        achieve_complete_count[1] = achieve_complete_count[2]
    end
    Text_active_number:setString(achieve_complete_count[1] .. "/".. achieve_complete_count[2])
    if tonumber(self._activity_type) == 28 then 
        Text_active_number:setString("")
    end
    Button_recive:setVisible(true)
    Button_go:setVisible(false)
    if tonumber(self._activity_info.achieve_state) == 0 then -- 进行中
        if tonumber(self._activity_type) == 12 
            or tonumber(self._activity_type) == 13 
            or tonumber(self._activity_type) == 31
            or tonumber(self._activity_type) == 36
            or tonumber(self._activity_type) == 4
            or tonumber(self._activity_type) == 29
            or tonumber(self._activity_type) == 30
            then
            Button_go:setVisible(true)
            Button_recive:setVisible(false)
        elseif tonumber(self._activity_type) == 41 then -- 41号单笔充值可多次购买领取做特殊处理
            local activity_add_state = zstring.split(_ED.activity_info[""..self._activity_type].activity_add_state,",")
            if tonumber(achieve_complete_count[1]) <= tonumber(activity_add_state[self._activity_info.achieve_index]) then
                Button_go:setVisible(true)
                Button_recive:setVisible(false)
            else
                Button_recive:setBright(true)
                Button_recive:setTouchEnabled(true)
            end
        else
            Button_recive:setBright(false)
            Button_recive:setTouchEnabled(false)
            Text_recive:setString(red_alert_all_str[170])
        end
    elseif tonumber(self._activity_info.achieve_state) == 1 then -- 完成
        if tonumber(self._activity_type) == 9 then
            if tonumber(_ED.activity_info["9"].activity_data[1][1].achieve_state) >= 1 then
                Button_recive:setBright(true)
                Button_recive:setTouchEnabled(true)
            else
                Button_recive:setBright(false)
                Button_recive:setTouchEnabled(false)
            end
        else
            Button_recive:setBright(true)
            Button_recive:setTouchEnabled(true)
            Text_recive:setString(red_alert_all_str[170])
        end 
    elseif tonumber(self._activity_info.achieve_state) == 2 then -- 已经领取
        Image_haved:setVisible(true)
        Button_recive:setVisible(false)
    end

end

function FamousGeneralCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.activity.wonderful.famous_general_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if FamousGeneralCell.__size == nil then
        FamousGeneralCell.__size = root:getContentSize()
    end

    --领取奖励
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_recive"), nil, 
    {
        terminal_name = "famous_general_cell_get_reward", 
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    -- 前往
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_go"), nil, 
    {
        terminal_name = "famous_general_cell_get_reward", 
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1) 

    local ListView_general_cell = ccui.Helper:seekWidgetByName(root,"ListView_general_cell") --列表
    self._listview = ListView_general_cell
  	self:updateDraw()
    self:updateDrawButtons()
end

function FamousGeneralCell:onEnterTransitionFinish()

end

function FamousGeneralCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function FamousGeneralCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self._listview:removeAllItems()
    cacher.freeRef(config_csb.cells.activity.wonderful.famous_general_cell, root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function FamousGeneralCell:init(activity_info,activity_type,index,group_index)
    self._activity_info = activity_info
    self._activity_type = tonumber(activity_type)
    self._index = index
    self._group_index = group_index
    if index ~= nil and index <= 4 then
	    self:onInit()
    end
    self:setContentSize(FamousGeneralCell.__size)
    return self
end

function FamousGeneralCell:onExit()
    if self._listview ~= nil then
        self._listview:removeAllItems()
    end
    cacher.freeRef(config_csb.cells.activity.wonderful.famous_general_cell, self.roots[1])
end