--------------------------------------------------------------------------------------------------------------
--  说明：活动中心单个活动控件cell
--------------------------------------------------------------------------------------------------------------
RedAlertTimeCenterCell = class("RedAlertTimeCenterCellClass", Window)
RedAlertTimeCenterCell.__size = nil

--创建cell
local red_alert_time_center_create_cell_terminal = {
    _name = "red_alert_time_center_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = RedAlertTimeCenterCell:new()
		local activity = params[1]
		local index = tonumber(params[2])
        cell:init(activity,index)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(red_alert_time_center_create_cell_terminal)
state_machine.init()

function RedAlertTimeCenterCell:ctor()
	self.super:ctor()
	self.roots = {}
	self._activity = nil

    --推送刷新
    self._last_time = os.time()

    --活动推送
    self._push_activity = nil

    self.m_times = 0
    self.m_reset_times = 0
    self.accept_the_prize = false

	 -- Initialize red_alert_time_center_cell state machine.
    local function init_red_alert_time_center_cell_terminal()
        local red_alert_time_center_cell_open_activity_terminal = {
            _name = "red_alert_time_center_cell_open_activity",
            _init = function (terminal)       
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params._datas.cells
                local server_time_month = os.date("%m", zstring.exchangeFrom(_ED.system_time + (os.time() - _ED.native_time)))
                local server_time_day = os.date("%d", zstring.exchangeFrom(_ED.system_time + (os.time() - _ED.native_time)))
                if tonumber(cell._activity.activity_type) == 57 
                    or tonumber(cell._activity.activity_type) == 58 
                    or tonumber(cell._activity.activity_type) == 75
                    or tonumber(cell._activity.activity_type) == 102 
                    then
                    local saveActiveTime_month = os.date("%m", zstring.exchangeFrom(zstring.tonumber(cc.UserDefault:getInstance():getStringForKey(getKey("activity_id_"..cell._activity.activity_type)))))
                    local saveActiveTime_day = os.date("%d", zstring.exchangeFrom(zstring.tonumber(cc.UserDefault:getInstance():getStringForKey(getKey("activity_id_"..cell._activity.activity_type)))))
                    if tonumber(server_time_month) > tonumber(saveActiveTime_month) or tonumber(server_time_day) > tonumber(saveActiveTime_day) then
                        cc.UserDefault:getInstance():setStringForKey(getKey("activity_id_"..cell._activity.activity_type), _ED.system_time + (os.time() - _ED.native_time))
                        cc.UserDefault:getInstance():flush()
                        cell._push_activity:setVisible(false)
                    end
                end
                cell:openActivityWindow(cell._activity)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_center_cell_update_push_terminal = {
            _name = "red_alert_time_center_cell_update_push",
            _init = function (terminal)       
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params.pushNotificationActivity ~= nil then
                    params:pushNotificationActivity()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_center_cell_open_activity_terminal)
        state_machine.add(red_alert_time_center_cell_update_push_terminal)
        state_machine.init()
    end 
    -- call func red_alert_time_center_cell create state machine.
    init_red_alert_time_center_cell_terminal()

end

function RedAlertTimeCenterCell:openActivityWindow(m_object)
	-- debug.print_r(_ED.activity_info[""..m_object.activity_type])
	if tonumber(m_object.activity_type) == 7 then
		state_machine.excute("red_alert_time_day_sign_seven_window_open",0,{m_object,1})
	elseif tonumber(m_object.activity_type) == 83 then	
		state_machine.excute("red_alert_time_day_sign_window_open",0,{m_object,2})
	elseif tonumber(m_object.activity_type) == 57 then		
		state_machine.excute("red_alert_time_brothers_share_window_open",0,{m_object})
	elseif tonumber(m_object.activity_type) == 82 then	
		state_machine.excute("red_alert_time_recharge_bonus_window_open",0,{m_object,1})
	elseif tonumber(m_object.activity_type) == 58 or tonumber(m_object.activity_type) == 75 or tonumber(m_object.activity_type) == 102 then		--坦克拉霸
		state_machine.excute("red_alert_time_tank_draw_window_open",0,{m_object,1})
	elseif tonumber(m_object.activity_type) == 71 or tonumber(m_object.activity_type) == 104 or tonumber(m_object.activity_type) == 105 then									--装甲猛兽
		state_machine.excute("red_alert_time_equipment_beast_window_open",0,{m_object})	
	elseif tonumber(m_object.activity_type) == 81 then									--消费转盘
		state_machine.excute("red_alert_time_consumption_turntable_window_open",0,{m_object,1})		
	elseif tonumber(m_object.activity_type) == 67 then		
		state_machine.excute("red_alert_time_secret_window_open",0,{m_object,1})	
	elseif tonumber(m_object.activity_type) == 78 then	 								--军资集结
		state_machine.excute("red_alert_time_funding_aggregation_window_open",0,{m_object})
    elseif tonumber(m_object.activity_type) == 96 then                                  --清盘计划
        state_machine.excute("red_alert_time_winding_up_plan_open",0,{m_object})
    elseif tonumber(m_object.activity_type) == 97 then                                  --摧枯拉朽
        state_machine.excute("red_alert_time_military_exploit_window_open",0,{m_object})
    elseif tonumber(m_object.activity_type) == 98 then                                  --消消乐
        state_machine.excute("red_alert_time_eliminate_music_window_open",0,{m_object})
    elseif tonumber(m_object.activity_type) == 99 then                                  --火线将领
        state_machine.excute("red_alert_time_leader_senior_window_open",0,{m_object})
    elseif tonumber(m_object.activity_type) == 101 then                                  --军事讲坛
        state_machine.excute("red_alert_time_military_pulpit_window_open",0,{m_object})
    elseif tonumber(m_object.activity_type) == 103 then                                  --折扣卖场
        state_machine.excute("red_alert_time_discount_store_window_open",0,{m_object})
    elseif tonumber(m_object.activity_type) == 46 then                                   -- 幸运抽奖
        state_machine.excute("red_alert_time_lucky_draw_window_open",0,{m_object,1})
    elseif tonumber(m_object.activity_type) == 117 then                                   -- 火力驱动
        state_machine.excute("red_alert_time_scientific_quicke_window_open",0,{m_object,1})
    elseif tonumber(m_object.activity_type) == 118 then                                   -- 慷慨馈赠
        state_machine.excute("red_alert_time_largesse_give_window_open",0,{m_object,1})
    elseif tonumber(m_object.activity_type) == 119 then                                   -- 传奇名将
        state_machine.excute("red_alert_time_leader_senior_legend_window_open",0,{m_object,1})
    elseif tonumber(m_object.activity_type) == 126 then                                   -- 传奇名将
        state_machine.excute("red_alert_time_discount_store_reward_window_open", 0, {m_object})
    elseif tonumber(m_object.activity_type) == 127 then                                   -- 火力全开
        state_machine.excute("red_alert_time_full_vitality_window_open", 0, {m_object})
    elseif tonumber(m_object.activity_type) == 129 then                                   -- 欢乐团购
        state_machine.excute("red_alert_time_happy_buy_window_open", 0, {m_object,1})
    elseif tonumber(m_object.activity_type) == 130 then                                   -- 狂欢时刻
        state_machine.excute("red_alert_time_carnival_hour_window_open", 0, {m_object})
    elseif tonumber(m_object.activity_type) == 132 then                                   -- 节日祝福
        state_machine.excute("red_alert_time_festival_each_child_window_open", 0, {m_object})
	end
end

function RedAlertTimeCenterCell:updateDraw()
    local root = self.roots[1]
	--图标
	local Panel_active_icon = ccui.Helper:seekWidgetByName(root,"Panel_active_icon")
	Panel_active_icon:removeAllChildren(true)
	Panel_active_icon:removeBackGroundImage()
	local pic = zstring.split(self._activity.activity_pic, ",")
	Panel_active_icon:setBackGroundImage(string.format(config_res.images.ui.props.props, tonumber(pic[1])))
	--名称
	local Text_active_name = ccui.Helper:seekWidgetByName(root,"Text_active_name")
	Text_active_name:setString(self._activity.activity_title)
	--时间
	local Text_active_infor = ccui.Helper:seekWidgetByName(root,"Text_active_infor")
    Text_active_infor:removeAllChildren(true)
    Text_active_infor:setString("")
    local font_size = Text_active_infor:getFontSize()
	local timesData = zstring.split(self._activity.activity_add_state, ",")
    if tonumber(self._activity.activity_type) == 129 then
        local activity_add_state_arr = zstring.split(self._activity.activity_add_state, "|")
        timesData = zstring.split(activity_add_state_arr[1], ",")
    end
    if tonumber(self._activity.activity_type) == 7
        or tonumber(self._activity.activity_type) == 83
        or tonumber(self._activity.activity_type) == 46
        then
        Text_active_infor:setString(activity_str_tip[14])
    else
    	if tonumber(timesData[1]) == 1 or tonumber(timesData[1]) == 0 or tonumber(self._activity.activity_add_state) == -1 then
    		Text_active_infor:setString(activity_str_tip[14])
    	else
            local time_str = activity_str_tip[93]
            if tonumber(timesData[1]) > 0 and tonumber(timesData[2]) > 0 then
                if tonumber(self._activity.activity_type) == 67 then    -- 超级配件
                    if tonumber(timesData[10])/1000 > (tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))) then
                        self.accept_the_prize = false
                        self.m_times = ((tonumber(timesData[10])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
                        time_str = activity_str_tip[93]
                    else
                        self.accept_the_prize = true
                        self.m_times = ((tonumber(timesData[2])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
                        time_str = activity_str_tip[92]
                    end
                    -- Text_active_infor:setString(getRedAlertTimeFormatYMDHMS(tonumber(timesData[1])/1000).."~"..getRedAlertTimeFormatYMDHMS(tonumber(timesData[10])/1000-1))
                elseif tonumber(self._activity.activity_type) == 96 --清盘计划
                    or tonumber(self._activity.activity_type) == 97 --摧枯拉朽
                    or tonumber(self._activity.activity_type) == 99 --火线将领
                    or tonumber(self._activity.activity_type) == 101 --军事讲坛
                    or tonumber(self._activity.activity_type) == 118 --慷慨馈赠
                    or tonumber(self._activity.activity_type) == 127 --火力全开
                    or tonumber(self._activity.activity_type) == 129 --欢乐团购
                    or tonumber(self._activity.activity_type) == 132 --节日祝福
                    then    
                    if tonumber(timesData[3])/1000 > (tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))) then
                        self.accept_the_prize = false
                        self.m_times = ((tonumber(timesData[3])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
                        time_str = activity_str_tip[93]
                    else
                        self.accept_the_prize = true
                        self.m_times = ((tonumber(timesData[2])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
                        time_str = activity_str_tip[111]
                    end
                elseif tonumber(self._activity.activity_type) == 81 then    -- 积分转盘
                    if tonumber(timesData[11])/1000 > (tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))) then
                        self.accept_the_prize = false
                        self.m_times = ((tonumber(timesData[11])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
                        time_str = activity_str_tip[93]
                    else
                        self.accept_the_prize = true
                        self.m_times = ((tonumber(timesData[2])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
                        time_str = activity_str_tip[92]
                    end
                    -- Text_active_infor:setString(getRedAlertTimeFormatYMDHMS(tonumber(timesData[1])/1000).."~"..getRedAlertTimeFormatYMDHMS(tonumber(timesData[11])/1000-1))
                else
                    self.accept_the_prize = true
        	        self.m_times = ((tonumber(timesData[2])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
                  -- Text_active_infor:setString(getRedAlertTimeFormatYMDHMS(tonumber(timesData[1])/1000).."~"..getRedAlertTimeFormatYMDHMS(tonumber(timesData[2])/1000-1))
                end
            end
            local time_info = cc.Label:createWithTTF(time_str, config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
            time_info:setName("time_info")
            time_info:setAnchorPoint(cc.p(0, 0.5))
            time_info:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            time_info:setPositionX(0)
            time_info:setPositionY(Text_active_infor:getContentSize().height / 2)
            time_info:setTag(200)
            Text_active_infor:addChild(time_info)
            local time_int = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
            time_int:setName("time_int")
            time_int:setAnchorPoint(cc.p(0, 0.5))
            time_int:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
            time_int:setPositionX(time_info:getContentSize().width)
            time_int:setPositionY(Text_active_infor:getContentSize().height / 2)
            time_int:setTag(100)
            Text_active_infor:addChild(time_int)

            if self.accept_the_prize == true then
                state_machine.excute("red_alert_time_center_remove",0,{self})
            end
        end
    end

    -- 重置倒计时
    if tonumber(self._activity.activity_type) == 83
        or tonumber(self._activity.activity_type) == 82
        or tonumber(self._activity.activity_type) == 58
        or tonumber(self._activity.activity_type) == 71
        or tonumber(self._activity.activity_type) == 104
        or tonumber(self._activity.activity_type) == 105
        or tonumber(self._activity.activity_type) == 81
        or tonumber(self._activity.activity_type) == 67
        or tonumber(self._activity.activity_type) == 78
        or tonumber(self._activity.activity_type) == 75
        or tonumber(self._activity.activity_type) == 7
        or tonumber(self._activity.activity_type) == 98
        or tonumber(self._activity.activity_type) == 99
        or tonumber(self._activity.activity_type) == 101
        or tonumber(self._activity.activity_type) == 102
        or tonumber(self._activity.activity_type) == 46
        or tonumber(self._activity.activity_type) == 119
        or tonumber(self._activity.activity_type) == 127
        or tonumber(self._activity.activity_type) == 130
        or tonumber(self._activity.activity_type) == 132
        then
        local server_time = getCurrentGTM8Time()
        self.m_reset_times = (24 - server_time.hour) * 3600 + (0 - server_time.min) * 60 + 0 - server_time.sec - 1

        local time_str = activity_str_tip[94]
        if tonumber(self._activity.activity_type) == 78 then
            time_str = activity_str_tip[98]
        elseif tonumber(self._activity.activity_type) == 75
            or tonumber(self._activity.activity_type) == 81
            or tonumber(self._activity.activity_type) == 71
            or tonumber(self._activity.activity_type) == 104
            or tonumber(self._activity.activity_type) == 105
            or tonumber(self._activity.activity_type) == 67
            or tonumber(self._activity.activity_type) == 58
            or tonumber(self._activity.activity_type) == 98
            or tonumber(self._activity.activity_type) == 99
            or tonumber(self._activity.activity_type) == 101
            or tonumber(self._activity.activity_type) == 102
            or tonumber(self._activity.activity_type) == 46
            or tonumber(self._activity.activity_type) == 119
            then
            time_str = activity_str_tip[96]
        elseif tonumber(self._activity.activity_type) == 83 
            or tonumber(self._activity.activity_type) == 7
            or tonumber(self._activity.activity_type) == 130
            then
            time_str = activity_str_tip[97]
        end

        local Text_active_time = ccui.Helper:seekWidgetByName(root,"Text_active_time")
        Text_active_time:removeAllChildren(true)
        Text_active_time:setString("")
        local reset_time_int = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
        reset_time_int:setName("reset_time_int")
        reset_time_int:setAnchorPoint(cc.p(0, 0.5))
        reset_time_int:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
        reset_time_int:setPositionX(Text_active_time:getContentSize().width - 80)
        reset_time_int:setPositionY(Text_active_time:getContentSize().height / 2)
        reset_time_int:setTag(100)
        Text_active_time:addChild(reset_time_int)
        local reset_time_info = cc.Label:createWithTTF(time_str, config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
        reset_time_info:setName("reset_time_info")
        reset_time_info:setAnchorPoint(cc.p(1, 0.5))
        reset_time_info:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
        reset_time_info:setPositionX(Text_active_time:getContentSize().width - 80)
        reset_time_info:setPositionY(Text_active_time:getContentSize().height / 2)
        reset_time_info:setTag(200)
        Text_active_time:addChild(reset_time_info)
    	if self.m_times < 24 * 3600 then
            Text_active_time:setVisible(false)
        else
            Text_active_time:setVisible(true)
        end
        if tonumber(self._activity.activity_type) == 67 
            or tonumber(self._activity.activity_type) == 96 --清盘计划
            or tonumber(self._activity.activity_type) == 97 --摧枯拉朽
            or tonumber(self._activity.activity_type) == 99 --火线将领
            or tonumber(self._activity.activity_type) == 101 --军事讲坛
            or tonumber(self._activity.activity_type) == 81     -- 积分转盘
            or tonumber(self._activity.activity_type) == 127    -- 火力全开
            or tonumber(self._activity.activity_type) == 132    -- 节日祝福
            then
            if self.accept_the_prize == true then
                Text_active_time:setVisible(false)
            end
        end
    end
end

function RedAlertTimeCenterCell:onUpdate(dt)
    if self.m_reset_times > 0 then
        self.m_reset_times = self.m_reset_times - dt
        if ccui.Helper:seekWidgetByName(self.roots[1],"Text_active_time"):getChildByTag(100) ~= nil then
            ccui.Helper:seekWidgetByName(self.roots[1],"Text_active_time"):getChildByTag(100):setString(getRedAlertTimeActivityFormat(self.m_reset_times))
        end
        if self.m_reset_times <= 0 then
            self.m_reset_times = 0
            self:updateDraw()
        end
    end

    if self.m_times > 0 then
        self.m_times = self.m_times - dt
        if ccui.Helper:seekWidgetByName(self.roots[1],"Text_active_infor"):getChildByTag(100) ~= nil then
            ccui.Helper:seekWidgetByName(self.roots[1],"Text_active_infor"):getChildByTag(100):setString(getRedAlertTimeActivityFormat(self.m_times))
        end

        if self.m_times <= 0 then
            self.m_times = 0
            if self.accept_the_prize == true then
                -- state_machine.excute("red_alert_time_center_update_first",0,tonumber(self._activity.activity_type))
            else
                self:updateDraw()
                state_machine.excute("main_window_push_treasure",0,0)
                state_machine.excute("red_alert_time_center_update_push", 0, tonumber(self._activity.activity_type))
            end
        end
    end
end

function RedAlertTimeCenterCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.activity.active_center_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if RedAlertTimeCenterCell.__size == nil then
        RedAlertTimeCenterCell.__size = root:getContentSize()
    end

	--进入
    fwin:addTouchEventListener(root, nil, 
    {
        terminal_name = "red_alert_time_center_cell_open_activity", 
        terminal_state = 0, 
        touch_black = true,
		cells = self,
    }, nil, 1)

    self._push_activity = ccui.Helper:seekWidgetByName(root,"Image_active_push")

	self:updateDraw()
    self:pushNotificationActivity()
end

function RedAlertTimeCenterCell:onEnterTransitionFinish()
    local root = self.roots[1]
   
end

function RedAlertTimeCenterCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_active_icon = ccui.Helper:seekWidgetByName(root,"Panel_active_icon")
	local Text_active_name = ccui.Helper:seekWidgetByName(root,"Text_active_name")
	local Text_active_infor = ccui.Helper:seekWidgetByName(root,"Text_active_infor")
    local Text_active_time = ccui.Helper:seekWidgetByName(root,"Text_active_time")
	if Panel_active_icon ~= nil then
		Panel_active_icon:removeAllChildren(true)
		Panel_active_icon:removeBackGroundImage()
		Text_active_name:setString("")
        Text_active_time:removeAllChildren(true)
		Text_active_infor:setString("")
        Text_active_infor:removeAllChildren(true)
	end
end

function RedAlertTimeCenterCell:pushNotificationActivity()
    self._push_activity:setVisible(false)
    if getPushActivityType(self._activity.activity_type) == true then
        self._push_activity:setVisible(true)
    end
end

-- function RedAlertTimeCenterCell:onUpdate(dt)
--     if self._push_activity == nil then
--        return
--     end
--     local now_time = os.time()
--     if now_time - zstring.tonumber(self._last_time) >= 1 then
--         self:pushNotificationActivity()
--         self._last_time = now_time
--     end
-- end

function RedAlertTimeCenterCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function RedAlertTimeCenterCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.active_center_cell, root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function RedAlertTimeCenterCell:init(activity,index)
    self._activity = activity
    -- if index ~= nil and index < 8 then
	   self:onInit()
    -- end

    self:setContentSize(RedAlertTimeCenterCell.__size)
    return self
end

function RedAlertTimeCenterCell:onExit()
	self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.active_center_cell, self.roots[1])
end