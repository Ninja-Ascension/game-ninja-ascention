-----------------------------
-- 至尊转盘(活动类型42)
-----------------------------
ActivityCostRotaryRank = class("ActivityCostRotaryRankClass", Window)

local activity_cost_rotary_rank_window_open_terminal = {
    _name = "activity_cost_rotary_rank_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if funOpenDrawTip(54) == true then
            return
        end  
        local add_state_info = zstring.split(_ED.activity_info["42"].activity_add_state, "|")
        local server_info = zstring.split(add_state_info[2], ",")
        local server_link = server_info[1]
        local server_number = server_info[2]
        local base_server_numer = server_info[3]
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if nil == fwin:find("ActivityCostRotaryRankClass") then
                    fwin:open(ActivityCostRotaryRank:new():init(), fwin._ui)
                end
            end
        end
        protocol_command.user_accumlate_consumption_score_get.param_list = "".._ED.user_info.user_id.."\r\n"..server_number.."\r\n"..base_server_numer.."\r\n".._ED.user_info.user_name
        NetworkManager:register(protocol_command.user_accumlate_consumption_score_get.code, server_link, nil, nil, nil, responseCallback, false, nil)

        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local activity_cost_rotary_rank_window_close_terminal = {
    _name = "activity_cost_rotary_rank_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        fwin:close(fwin:find("ActivityCostRotaryRankClass"))    
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(activity_cost_rotary_rank_window_open_terminal)
state_machine.add(activity_cost_rotary_rank_window_close_terminal)
state_machine.init()

function ActivityCostRotaryRank:ctor()
    self.super:ctor()
    self.roots = {}

    self._panel_list = {}
    self._image_list = {}
    self._list_view = nil
    self._list_view_poy = 0

    self.Text_limit_time_v = nil        -- 倒计时
    self.Text_limit_time = nil          -- 显示是活动或者领奖
    self._round = 0

    self._end_time = 0          -- 活动结束时间
    self._last_time = 0         -- 领奖结束时间

    app.load("client.red_alert.cells.activity.wonderful.active_cost_rotary_rank_cell")
    app.load("client.red_alert.activity.wonderful.ActivityCostRotaryRule")

    local function init_activity_cost_rotary_rank_terminal()
        --抽一次
		local activity_cost_rotary_rank_get_reward_terminal = {
            _name = "activity_cost_rotary_rank_get_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("activity_cost_rotary_rank_get_reward")
                state_machine.lock("activity_cost_rotary_rank_window_close")
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            response.node:beginRotary()
                        else
                            state_machine.unlock("activity_cost_rotary_rank_get_reward")
                            state_machine.unlock("activity_cost_rotary_rank_window_close")
                        end
                    else
                        state_machine.unlock("activity_cost_rotary_rank_get_reward")
                        state_machine.unlock("activity_cost_rotary_rank_window_close")
                    end
                end
                protocol_command.draw_activity_reward.param_list = _ED.activity_info["42"].activity_id .. "\r\n42\r\n0\r\n0\r\n1"
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新
        local activity_cost_rotary_rank_update_draw_terminal = {
            _name = "activity_cost_rotary_rank_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local add_state_info = zstring.split(_ED.activity_info["42"].activity_add_state, "|")
                local server_info = zstring.split(add_state_info[2], ",")
                local server_link = server_info[1]
                local server_number = server_info[2]
                local base_server_numer = server_info[3]
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:onUpdateDraw()
                        end
                    end
                end
                protocol_command.user_accumlate_consumption_score_get.param_list = "".._ED.user_info.user_id.."\r\n"..server_number.."\r\n"..base_server_numer.."\r\n".._ED.user_info.user_name
                NetworkManager:register(protocol_command.user_accumlate_consumption_score_get.code, server_link, nil, nil, instance, responseCallback, false, nil)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 抽十次
        local activity_cost_rotary_rank_get_reward_10_terminal = {
            _name = "activity_cost_rotary_rank_get_reward_10",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local ntype = params._datas.ntype
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("reward_obtain_window_open", 0, {1042})
                        state_machine.excute("activity_cost_rotary_rank_update_draw", 0, "")
                    end
                end
                protocol_command.draw_activity_reward.param_list = _ED.activity_info["42"].activity_id .. "\r\n42\r\n0\r\n0\r\n10"
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 抽三十次
        local activity_cost_rotary_rank_get_reward_30_terminal = {
            _name = "activity_cost_rotary_rank_get_reward_30",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local ntype = params._datas.ntype
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("reward_obtain_window_open", 0, {1042})
                        state_machine.excute("activity_cost_rotary_rank_update_draw", 0, "")
                    end
                end
                protocol_command.draw_activity_reward.param_list = _ED.activity_info["42"].activity_id .. "\r\n42\r\n0\r\n0\r\n30"
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(activity_cost_rotary_rank_get_reward_terminal)	
        state_machine.add(activity_cost_rotary_rank_update_draw_terminal) 
        state_machine.add(activity_cost_rotary_rank_get_reward_10_terminal) 
        state_machine.add(activity_cost_rotary_rank_get_reward_30_terminal) 
        state_machine.init()
    end
    
    init_activity_cost_rotary_rank_terminal()
end

function ActivityCostRotaryRank:endRotary( ... )
    self._round = 0
    state_machine.unlock("activity_cost_rotary_rank_get_reward")
    state_machine.unlock("activity_cost_rotary_rank_window_close")
    local function playActionOne(sender)
        if sender.roots ~= nil then
            sender:stopAllActions()
            state_machine.excute("activity_cost_rotary_rank_update_draw", 0, "")
        end
        state_machine.excute("reward_obtain_window_open", 0, {1042})
    end
    local action = cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(0.2),cc.CallFunc:create(playActionOne)))
    self:runAction(action)
end

function ActivityCostRotaryRank:beginRotary( ... )
    local root = self.roots[1]
    local index = 0
    local delayTime = 0
    local max_times = 0
    self._round = self._round + 1
    if self._round == 1 then
        delayTime = 0.003
        max_times = 16
    elseif self._round == 2 then
        delayTime = 0.005
        max_times = 16 + zstring.tonumber(_ED.activity_rotary_index) - 1
    end

    local function playActionOne(sender)
        index = index + 1
        if index > max_times then
            sender:stopAllActions()
            if sender._round ~= 2 then
                sender:beginRotary()
            else
                sender:endRotary()
            end
        else
            local cell_index = math.floor(index%16)
            for k,v in pairs(sender._image_list) do
                if k == cell_index + 1 then
                    v:setVisible(true)
                else
                    v:setVisible(false)
                end
            end
        end
    end
    local action = cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(delayTime),cc.CallFunc:create(playActionOne)))
    self:runAction(action)
end

function ActivityCostRotaryRank:onUpdateDraw()
    local root = self.roots[1]
    local activity_info = _ED.activity_info["42"]
    local activity_data = activity_info.activity_data[1]
    self._panel_list = {}
    self._image_list = {}
    for i=1,16 do
		local function showCell()
			local panel = ccui.Helper:seekWidgetByName(root,"Panel_reward_"..i)
			local image = ccui.Helper:seekWidgetByName(root,"Image_reward_get_"..i)
			panel:removeAllChildren(true)
			image:setVisible(false)
			table.insert(self._panel_list, panel)
			table.insert(self._image_list, image)

			if activity_data ~= nil then
				local info = zstring.split(activity_data[i].achieve_reward, ",")
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
				
				panel:addChild(cell)
			end
		end
		if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
			local run_action2  = cc.Sequence:create(cc.DelayTime:create(0.05*i),cc.CallFunc:create(showCell))
			self:runAction(run_action2)
		else
			showCell()
		end
    end

    self.Text_limit_time_v = ccui.Helper:seekWidgetByName(root,"Text_limit_time_v")
    self.Text_limit_time = ccui.Helper:seekWidgetByName(root,"Text_limit_time")
    local add_state_info = zstring.split(activity_info.activity_add_state, "|")
    local infos = zstring.split(add_state_info[1], ",")
    self._last_time = tonumber(infos[4])/1000 - os.time() + _ED.time_add_or_sub
    self._end_time = tonumber(add_state_info[5])/1000 - os.time() + _ED.time_add_or_sub

    local add_satte_info = zstring.split(_ED.activity_info["42"].activity_add_state, "|")
    local cost_info = zstring.split(add_satte_info[3], ",")
    local Text_200 = ccui.Helper:seekWidgetByName(root,"Text_200")
    local Text_1800 = ccui.Helper:seekWidgetByName(root,"Text_1800")
    local Text_4800 = ccui.Helper:seekWidgetByName(root,"Text_4800")

    Text_200:setString(cost_info[1])
    Text_1800:setString(cost_info[2])
    Text_4800:setString(cost_info[3])
    -- 至尊转盘卷推送(如果有显示数量和红点)
    local Image_free_t = ccui.Helper:seekWidgetByName(root,"Image_free_t")
    local Text_time_n = ccui.Helper:seekWidgetByName(root,"Text_time_n")
    local Image_gem_1 = ccui.Helper:seekWidgetByName(root,"Image_gem_1")
    Image_free_t:setVisible(false)
    Text_time_n:setString("")
    Image_gem_1:setVisible(true)
    Text_200:setVisible(true)
    local rotary_count = 0 
    if fundPropWidthId(357) ~= nil then 
        local token = fundPropWidthId(357)
        rotary_count = zstring.tonumber(token.prop_number)
    end
    if rotary_count > 0 then
        Image_free_t:setVisible(true)
        Text_time_n:setString(rotary_count)
        Image_gem_1:setVisible(false)
        Text_200:setVisible(false)
    end
    self:updateRewardInfo()
    self:updateLeftReward()
end

function ActivityCostRotaryRank:updateRewardInfo()
    local root = self.roots[1]

    local ListView_2 = ccui.Helper:seekWidgetByName(root,"ListView_2")
    ListView_2:removeAllItems()

    for i = #_ED.activity_cost_ratory_rank_messages, 1, -1 do
        message = _ED.activity_cost_ratory_rank_messages[i]
        local _richText1 = ccui.RichText:create()
        local _richText2 = ccui.RichText:create()
        _richText1:ignoreContentAdaptWithSize(false)
        _richText2:ignoreContentAdaptWithSize(false)
        _richText1:setContentSize(cc.size(ListView_2:getContentSize().width,20))
        _richText2:setContentSize(cc.size(ListView_2:getContentSize().width,20))

        local name = self:getUserName(message)

        local re1 =ccui.RichElementText:create(1, tipStringInfo_activity_rotary_rank_color_Type[1],255, name, "fonts/simhei.ttf",14)
        _richText1:pushBackElement(re1)  

        local re2 = ccui.RichElementText:create(1, tipStringInfo_activity_rotary_rank_color_Type[2],255, tipStringInfo_activity_rotary_rank_str[1],"fonts/simhei.ttf",14)
        _richText2:pushBackElement(re2)
        local text = string.format(tipStringInfo_activity_rotary_rank_str[3], message.times)
        local re3 = ccui.RichElementText:create(1, tipStringInfo_activity_rotary_rank_color_Type[3],255, text,"fonts/simhei.ttf",14)
        _richText2:pushBackElement(re3)
        local re4 = ccui.RichElementText:create(1, tipStringInfo_activity_rotary_rank_color_Type[2],255, tipStringInfo_activity_rotary_rank_str[2],"fonts/simhei.ttf",14)
        _richText2:pushBackElement(re4)

        local reward_data = self:getRewardData(message.rewardInfo)
        local color = cc.c3b(tipStringInfo_quality_color_Type[reward_data.quality+1][1],tipStringInfo_quality_color_Type[reward_data.quality+1][2],tipStringInfo_quality_color_Type[reward_data.quality+1][3])
        local re5 = ccui.RichElementText:create(1, color, 255, reward_data.name,"fonts/simhei.ttf",14)
        _richText2:pushBackElement(re5)


        _richText1:setAnchorPoint(cc.p(0.5,0.5))
        _richText2:setAnchorPoint(cc.p(0.5,0.5))
        ListView_2:addChild(_richText1)
        ListView_2:addChild(_richText2)
    end

    ListView_2:jumpToTop()
    ListView_2:requestRefreshView()
end

function ActivityCostRotaryRank:getRewardData(data)
    local reward_data = {}

    local name = reward_prop_list[data.prop_type]
    local quality = 4
    local prop_id = data.prop_item
    local prop_type = data.prop_type
    if prop_type == 6 then
        name = dms.string(dms["prop_mould"], prop_id, prop_mould.prop_name)
        quality = dms.int(dms["prop_mould"], prop_id, prop_mould.prop_quality)
    elseif prop_type == 7 then
        name = dms.string(dms["equipment_mould"],prop_id,equipment_mould.equipment_name)
        quality = dms.int(dms["equipment_mould"],prop_id,equipment_mould.grow_level)
    elseif prop_type == 13 then
        name = dms.string(dms["ship_mould"],prop_id,ship_mould.captain_name)
        quality = dms.int(dms["ship_mould"],prop_id,ship_mould.ship_type)
    elseif prop_type == 34 then
        quality = dms.int(dms["gems_mould"],prop_id,gems_mould.quality)
        name = dms.string(dms["gems_mould"],prop_id,gems_mould.name)
    elseif prop_type == 35 then
        quality = dms.int(dms["horse_mould"], prop_id, horse_mould.quality)
        name = dms.string(dms["horse_mould"], prop_id, horse_mould.horse_name)
    elseif prop_type == 36 then
        quality = dms.int(dms["horse_spirit_mould"],prop_id,horse_spirit_mould.quality)
        name = dms.string(dms["horse_spirit_mould"],prop_id,horse_spirit_mould.horse_spirit_name)
    end

    reward_data.name = name
    reward_data.quality = quality

    return reward_data
end

function ActivityCostRotaryRank:getUserName(info)
    local name = ""
    local server_number = 0
    local server_info = _ED.all_servers[""..info.user_server_number]
    if server_info ~= nil and server_info.server_code ~= nil and tonumber(server_info.server_code) ~= nil then
        server_number = server_info.server_code
    end
    local server_flag = ""
    if server_info ~= nil and server_info.server_flag ~= nil then
        server_flag = server_info.server_flag
    end
    -- if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
    --     if server_info ~= nil and server_info.server_code ~= nil then
    --         name = info.name.."("..server_info.server_code..")"
    --     else
    --         name = info.name
    --     end
    -- else
    --     name = string.format(red_alert_all_str[239], info.name, server_number)
    -- end
    
    name = string.format(red_alert_all_str[239], info.name, server_flag, server_number)

    return name
end

function ActivityCostRotaryRank:updateLeftReward( ... )
    local root = self.roots[1]
    local ListView_left = ccui.Helper:seekWidgetByName(root, "ListView_left")
    local Text_rank_me = ccui.Helper:seekWidgetByName(root, "Text_rank_me")
    local Text_rank_1 = ccui.Helper:seekWidgetByName(root, "Text_rank_1")
    local Text_rank_2 = ccui.Helper:seekWidgetByName(root, "Text_rank_2")
    ListView_left:removeAllItems()
    ListView_left:jumpToTop()

    local info = _ED.activity_cost_ratory_rank_my_info
    if tonumber(info.id) > 0 then
        Text_rank_me:setString(string.format(red_alert_all_str[259], info.rank, self:getUserName(info), info.score))
    
        info = _ED.activity_cost_ratory_rank_prev_info
        if tonumber(info.id) > 0 then
            Text_rank_1:setString(string.format(red_alert_all_str[259], info.rank, self:getUserName(info), info.score))
        else
            Text_rank_1:setString("")
        end
        info = _ED.activity_cost_ratory_rank_next_info
        if tonumber(info.id) > 0 then
            Text_rank_2:setString(string.format(red_alert_all_str[259], info.rank, self:getUserName(info), info.score))
        else
            Text_rank_2:setString("")
        end
    else                    -- 未上榜，没有排名
        Text_rank_me:setString("")
        Text_rank_1:setString("")
        Text_rank_2:setString("")
    end

    local activity_info = _ED.activity_info["42"]
    local activity_data = activity_info.activity_data[2]
    local show = false
    if self._end_time <= 0 and self._last_time > 0 then             -- 活动结束，领奖时间未结束
        show = true
    end

    local index = 0 
    for k,v in pairs(activity_data) do
        index = index + 1 
        local cell = state_machine.excute("activity_cost_rotary_rank_create_cell", 0, {k, v, index, show})
        ListView_left:addChild(cell)
    end
    ListView_left:requestRefreshView()
    self._list_view = ListView_left
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
end

function ActivityCostRotaryRank:updateListViewPos()
    if tonumber(_ED.activity_cost_ratory_rank_my_info.id) <= 0 then
        return
    end
    
    local my_rank = tonumber(_ED.activity_cost_ratory_rank_my_info.rank)
    local index = 0
    for k, data in pairs(_ED.activity_info["42"].activity_data[2]) do
        local rank_range = zstring.split(data.achieve_other_info, ",")
        if my_rank >= tonumber(rank_range[1]) and my_rank <= tonumber(rank_range[2]) then
            index = k
            break
        end
    end

    if index > 0 then
        local items = self._list_view:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        local height = itemSize.height * (index - 1)
        self._list_view:getInnerContainer():setPositionY(height)
    end
end


function ActivityCostRotaryRank:onUpdate(dt)
    if _ED.activity_info["42"] ~= nil and self.roots ~= nil and self.roots[1] ~= nil then
        self._last_time = self._last_time - dt
        self._end_time = self._end_time - dt
        if self._last_time <= 0 then
            self._last_time = 0
        end
        if self._end_time <= 0 then
            self._end_time = 0
        end

        local time = math.modf(self._end_time)
        if self._end_time == 0 then
            time = math.modf(self._last_time)
        end
        local day = math.floor(tonumber(time)/3600/24)
        local hour = math.floor(tonumber(time)/3600%24)
        local minute = math.floor((tonumber(time)%3600)/60)
        local second = math.floor((tonumber(time)%3600)%60)
        if hour < 10 then
            hour = "0"..hour
        end
        if minute < 10 then
            minute = "0"..minute
        end
        if second < 10 then
            second = "0"..second
        end
        if self.Text_limit_time_v ~= nil and self.Text_limit_time ~= nil then
            if self._end_time == 0 then         -- 活动结束，显示领奖倒计时
                self.Text_limit_time:setString(red_alert_all_str[267])
            else                                -- 显示活动倒计时
                self.Text_limit_time:setString(red_alert_all_str[266])
            end
            self.Text_limit_time_v:setString(string.format(red_alert_all_str[180], ""..day, ""..hour, ""..minute, ""..second))
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
end

function ActivityCostRotaryRank:onEnterTransitionFinish()

end

function ActivityCostRotaryRank:onInit( )
    local csbItem = csb.createNode(config_csb.activity.wonderful.activity_cost_rotary_rank)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "activity_cost_rotary_rank_window_close", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    -- 抽一次
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chou_1"), nil, 
    {
        terminal_name = "activity_cost_rotary_rank_get_reward", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)
    -- 抽十次
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chou_10"), nil, 
    {
        terminal_name = "activity_cost_rotary_rank_get_reward_10", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)
    -- 抽三十次
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chou_30"), nil, 
    {
        terminal_name = "activity_cost_rotary_rank_get_reward_30", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)
    -- 说明
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_infor"), nil, 
    {
        terminal_name = "activity_cost_rotary_rule_window_open", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

	self:onUpdateDraw()
    self:updateListViewPos()  -- 打开页面时排名显示到玩家当前位置
end

function ActivityCostRotaryRank:init()
	self:onInit()
    return self
end

function ActivityCostRotaryRank:onExit()
    state_machine.remove("activity_cost_rotary_rank_get_reward")
    state_machine.remove("activity_cost_rotary_rank_update_draw")
    state_machine.remove("activity_cost_rotary_rank_get_reward_10")
    state_machine.remove("activity_cost_rotary_rank_get_reward_30")
end
