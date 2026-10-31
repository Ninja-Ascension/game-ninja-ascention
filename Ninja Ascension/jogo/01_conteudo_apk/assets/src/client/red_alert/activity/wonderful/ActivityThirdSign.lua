-----------------------------
--每日三签(活动类型21)
-----------------------------
ActivityThirdSign = class("ActivityThirdSignClass", Window)

local activity_third_sign_window_open_terminal = {
    _name = "activity_third_sign_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("ActivityThirdSignClass") then
            local panel = ActivityThirdSign:new():init(params)
            fwin:open(panel)
            return panel
        end
    end,
    _terminal = nil,
    _terminals = nil
}

local activity_third_sign_window_close_terminal = {
    _name = "activity_third_sign_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        fwin:close(fwin:find("ActivityThirdSignClass"))    
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(activity_third_sign_window_open_terminal)
state_machine.add(activity_third_sign_window_close_terminal)
state_machine.init()

function ActivityThirdSign:ctor()
    self.super:ctor()
    self.roots = {}

    self._list_view = nil
    self._list_view_poy = 0

    self._current_times = 0

    app.load("client.red_alert.activity.wonderful.ActivityThirdRotary")
    app.load("client.red_alert.cells.activity.wonderful.activity_third_sign_cell")

    local function init_activity_third_sign_terminal()
		local activity_third_sign_get_reward_terminal = {
            _name = "activity_third_sign_get_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("reward_obtain_window_open", 0, {1021})
                        if response.node ~= nil and response.node.roots ~= nil then
                            response.node:onUpdateDraw()
                        end
                    end
                end
                protocol_command.draw_activity_reward.param_list = _ED.activity_info["21"].activity_id .. "\r\n21\r\n0\r\n0"
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local activity_third_sign_update_rotary_times_terminal = {
            _name = "activity_third_sign_update_rotary_times",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:updateRotaryTimes()
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(activity_third_sign_get_reward_terminal)
        state_machine.add(activity_third_sign_update_rotary_times_terminal)
        state_machine.init()
    end
    
    init_activity_third_sign_terminal()
end

function ActivityThirdSign:updateRotaryTimes( ... )
    local root = self.roots[1]
    local Text_sign_in_time_2 = ccui.Helper:seekWidgetByName(root,"Text_sign_in_time_2")
    local day_info = zstring.split(zstring.split(_ED.activity_info["21"].activity_add_state, "|")[1], ",")
    Text_sign_in_time_2:setString(""..day_info[3])
    local Image_point = ccui.Helper:seekWidgetByName(root,"Image_point")
    local Text_point = ccui.Helper:seekWidgetByName(root,"Text_point")
    Image_point:setVisible(false)
    if tonumber(day_info[3]) > 0 then
        Image_point:setVisible(true)
        Text_point:setString(""..day_info[3])
    end
end

function ActivityThirdSign:onUpdateDraw()
    local activity_info = _ED.activity_info["21"]
    local day_info = zstring.split(zstring.split(activity_info.activity_add_state, "|")[1], ",")
    local roundDay = tonumber(day_info[1] + 1)
    local signDay = tonumber(day_info[2])
    local sign_info = tonumber(day_info[4])
    local day = math.floor(roundDay % 7)
    if day == 0 then
        day = 7 
    end
    local need_login_day = zstring.split(activity_info.activity_data[1][day].achieve_complete_count, "/")
    self._current_times = tonumber(need_login_day[1])

    local root = self.roots[1]
    local Panel_reward_1 = ccui.Helper:seekWidgetByName(root,"Panel_reward_1")
    local Panel_reward_2 = ccui.Helper:seekWidgetByName(root,"Panel_reward_2")
    local Panel_reward_3 = ccui.Helper:seekWidgetByName(root,"Panel_reward_3")
    local Panel_reward_4 = ccui.Helper:seekWidgetByName(root,"Panel_reward_4")
    local Text_yuanbao_1 = ccui.Helper:seekWidgetByName(root,"Text_yuanbao_1")
    local Text_yuanbao_v_1 = ccui.Helper:seekWidgetByName(root,"Text_yuanbao_v_1")
    local Text_get_infor_1 = ccui.Helper:seekWidgetByName(root,"Text_get_infor_1")
    local LoadingBar_sanqian = ccui.Helper:seekWidgetByName(root,"LoadingBar_sanqian")
    local Text_loading = ccui.Helper:seekWidgetByName(root,"Text_loading")
    local Text_sign_in_time_2 = ccui.Helper:seekWidgetByName(root,"Text_sign_in_time_2")
    local Image_point = ccui.Helper:seekWidgetByName(root,"Image_point")
    local Text_point = ccui.Helper:seekWidgetByName(root,"Text_point")
    Image_point:setVisible(false)

    local Text_time_1 = ccui.Helper:seekWidgetByName(root,"Text_time_1")
    self.time_text = Text_time_1
    self.time_text:setString("")
    local Text_time_2 = ccui.Helper:seekWidgetByName(root,"Text_time_2")
    Text_time_2:setString("")

    Panel_reward_1:removeAllChildren(true)
    Panel_reward_2:removeAllChildren(true)
    Panel_reward_3:removeAllChildren(true)
    Panel_reward_4:removeAllChildren(true)

    local ListView_right = ccui.Helper:seekWidgetByName(root,"ListView_right")
    ListView_right:removeAllItems()
	
	-- 解析三签数据
    if _ED.third_sign_data == nil or table.nums(_ED.third_sign_data) == 0 then
        initThirdSignData()
    end

    local today_sign = _ED.third_sign_data.every_day_data[day]

    local third_sign_data = nil
    local result = {}
    local minResult = {}
    local maxResult = {}

    local last_max_index = 0
    for k,v in pairs(_ED.third_sign_data.third_times_data) do
        local test = dms.atoi(v, every_three_sign_in_mould.three_sign_finish_need_info)
        if test <= signDay then
            last_max_index = k
            if k == (sign_info+1) then 
                table.insert(maxResult, v)
            elseif signDay >= _ED.third_sign_count_one and k >= _ED.third_sign_times - 2 then 
                table.insert(minResult, v)
                if signDay >= _ED.third_sign_count_two and k >= _ED.third_sign_times then
                    table.insert(maxResult, v)
                end
            end
        else
            table.insert(maxResult, v)
        end
        if #maxResult >= 3 then
            break
        end
    end
    if #maxResult < 0 then
        for i=#minResult - 1 + #maxResult, #minResult do
            table.insert(result, minResult[i])
            if #result + #maxResult >= 3 then
                break
            end
        end
        for k,v in pairs(maxResult) do
            table.insert(result, v)
        end
    else
        if #minResult < 2 then
            result = minResult
            for k,v in pairs(maxResult) do
                table.insert(result, v)
                if #result >= 3 then
                    break
                end
            end
        else
            for i=#minResult - 1, #minResult do
                table.insert(result, minResult[i])
            end
            for k,v in pairs(maxResult) do
                table.insert(result, v)
                if #result >= 3 then
                    break
                end
            end
        end
    end
    third_sign_data = maxResult[1]

    if last_max_index >= #_ED.third_sign_data.third_times_data then
        third_sign_data = _ED.third_sign_data.third_times_data[last_max_index]
    else
        third_sign_data = _ED.third_sign_data.third_times_data[last_max_index + 1]
    end

    local height = 0
    for k,v in pairs(result) do
        local cell = state_machine.excute("activity_third_sign_create_cell", 0, {k, v, signDay, sign_info})
        height = cell:getContentSize().height
        ListView_right:addChild(cell)
    end
    ListView_right:requestRefreshView()
    self._list_view = ListView_right

    -- local total_height = self._list_view:getContentSize().height
    -- if height*(third_sign_count - 1) > total_height then
    --     self._list_view:getInnerContainer():setPositionY(total_height - height)
    -- else
    --     self._list_view:getInnerContainer():setPositionY(0)
    -- end

    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()

    local rewards = zstring.split(dms.atos(today_sign, every_three_sign_in_mould.three_sign_reward), "|")
    for k,v in pairs(rewards) do
        local info = zstring.split(v, ",")
        local data = 
        {
            item_value = info[3],
            prop_type = info[2],
            prop_item = info[1],
        }
        -- local cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,9,0,false,true})
        if zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(data.prop_item), prop_mould.change_of_equipment))> 0 
            or zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(data.prop_item), prop_mould.use_of_ship)) > 0  then
            cell = state_machine.excute("all_resource_create_cell",0,{3,data,data,9,0,false,true})
            if tonumber(data.prop_type) == 7 then 
                cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,9,0,false,true})
            end
        else
            cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,9,0,false,true})
        end  
        ccui.Helper:seekWidgetByName(root,"Panel_reward_"..(k + 1)):addChild(cell)
        if self._current_times >= k then
            ccui.Helper:seekWidgetByName(root, "Panel_yiqian_"..k):setVisible(true)
        else
            ccui.Helper:seekWidgetByName(root, "Panel_yiqian_"..k):setVisible(false)
        end
    end

    local times = dms.atoi(third_sign_data, every_three_sign_in_mould.three_sign_finish_need_info)
    local rewards = zstring.split(dms.atos(third_sign_data, every_three_sign_in_mould.three_sign_reward), ",")
    Text_yuanbao_v_1:setString("x"..rewards[3])
    Text_get_infor_1:setString(dms.atos(third_sign_data, every_three_sign_in_mould.three_sign_dec))
    local progress = math.min(signDay/times*100)
    LoadingBar_sanqian:setPercent(progress)
    Text_loading:setString(signDay.."/"..times)
    Text_sign_in_time_2:setString(""..day_info[3])
    if tonumber(day_info[3]) > 0 then
        Image_point:setVisible(true)
        Text_point:setString(""..day_info[3])
    end
    self:updateCellName(rewards[2], rewards[1], Text_yuanbao_1)
    local data = 
    {
        item_value = rewards[3],
        prop_type = rewards[2],
        prop_item = rewards[1],
    }
    -- local cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,9,0,false,true})
    if zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(data.prop_item), prop_mould.change_of_equipment))> 0 
        or zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(data.prop_item), prop_mould.use_of_ship)) > 0  then
        cell = state_machine.excute("all_resource_create_cell",0,{3,data,data,9,0,false,true})
    else
        cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,9,0,false,true})
    end  
    Panel_reward_1:addChild(cell)
end

function ActivityThirdSign:updateCellName( prop_type, prop_id, Text_yuanbao )
    local quality = 4
    local name = ""
    if tonumber(prop_type) == 1 then
        name = _All_tip_string_info._fundName
        quality = 4
    elseif tonumber(prop_type) == 2 then
        name = _All_tip_string_info._crystalName
        quality = 4 
    elseif tonumber(prop_type) == 3 then
        name = _All_tip_string_info._reputation
        quality = 4         
    elseif tonumber(prop_type) == 5 then
        name = _All_tip_string_info._hero
        quality = 4
    elseif tonumber(prop_type) == 6 then
        name = dms.string(dms["prop_mould"],prop_id,prop_mould.prop_name)
        quality = dms.int(dms["prop_mould"],prop_id,prop_mould.prop_quality)
    elseif tonumber(prop_type) == 7 then
        name = dms.string(dms["equipment_mould"],prop_id,equipment_mould.equipment_name)
        quality = dms.int(dms["equipment_mould"],prop_id,equipment_mould.grow_level)
    elseif tonumber(prop_type) == 12 then
        name = _All_tip_string_info._energyName
        quality = 4
    elseif tonumber(prop_type) == 13 then
        name = dms.string(dms["ship_mould"],prop_id,ship_mould.captain_name)
        quality = dms.int(dms["ship_mould"],prop_id,ship_mould.ship_type)
    elseif tonumber(prop_type) == 28 then   --军团贡献
        name = _All_tip_string_info._guide
        quality = 4
    elseif tonumber(prop_type) == 31 then       --战神令
        name = _All_tip_string_info._zhanshenling
        quality = 4
    elseif tonumber(prop_type) == 32 then       --气势值
        name = _All_tip_string_info._qishizhi
        quality = 4
    elseif tonumber(prop_type) == 33 then       --木材
        name = _All_tip_string_info._martix
        quality = 4
    elseif tonumber(prop_type) == 34 then       --宝石
        name = dms.string(dms["gems_mould"],prop_id,gems_mould.name)
        quality = dms.int(dms["gems_mould"],prop_id,gems_mould.quality)
    elseif tonumber(prop_type) == 35 then       -- 马
        name = dms.string(dms["horse_mould"],prop_id,horse_mould.horse_name)
        quality = dms.int(dms["horse_mould"], prop_id, horse_mould.quality)
    elseif tonumber(prop_type) == 36 then       --马魂
        name = dms.string(dms["horse_spirit_mould"],prop_id,horse_spirit_mould.horse_spirit_name)
        quality = dms.int(dms["horse_spirit_mould"],prop_id,horse_spirit_mould.quality)
    elseif tonumber(prop_type) == 37 then       --龙马碎片
        name = _All_tip_string_info._horse_spirit
        quality = 4
    elseif tonumber(prop_type) == 38 then       --马魂碎片
        name = _All_tip_string_info._horse
        quality = 4
    elseif tonumber(prop_type) == 39 then       --VIP经验
        name = _All_tip_string_info._vipExp
        quality = 4
    end
    Text_yuanbao:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
    Text_yuanbao:setString(name)
end

function ActivityThirdSign:onUpdate(dt)
    local infos = zstring.split(_ED.activity_info["21"].activity_add_state, "|")
    local server_time = _ED.system_time + (os.time() - _ED.native_time)
    local timeString = ""
    if tonumber(infos[5]) < 0 then
        self.time_text:setString(red_alert_all_str[195])
    elseif tonumber(infos[5]) == 2 then
        self.time_text:setString(red_alert_all_str[194])
    else
        local now_time = math.max(tonumber(infos[6] - server_time),0)
        if now_time > 0 then
            timeString = timeString .. string.format("%02d", math.floor(now_time/3600)) .. ":"
            timeString = timeString .. string.format("%02d", math.floor((now_time%3600)/60)) .. ":"
            timeString = timeString .. string.format("%02d", math.floor(now_time%60))
            self.time_text:setString(timeString)
        else
            self.time_text:setString(red_alert_all_str[195])
        end
    end
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_poy == posY then
            return
        end
        self._list_view_poy = posY
        local items = self._list_view:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function ActivityThirdSign:onEnterTransitionFinish()

end

function ActivityThirdSign:onInit( )
    local csbItem = csb.createNode(config_csb.activity.wonderful.activity_third_sign)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "activity_third_sign_window_close", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_choujaing"), nil, 
    {
        terminal_name = "activity_third_rotary_window_open", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_qiandao"), nil, 
    {
        terminal_name = "activity_third_sign_get_reward", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

	self:onUpdateDraw()
end

function ActivityThirdSign:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
    self:onInit()
    return self
end

function ActivityThirdSign:onExit()
    state_machine.remove("activity_third_sign_get_reward")
    state_machine.remove("activity_third_sign_update_rotary_times")
end
