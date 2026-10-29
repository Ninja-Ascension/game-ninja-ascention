--------------------------------------------------------------------------------------------------------------
--  说明：转盘
--------------------------------------------------------------------------------------------------------------
RedAlertTimeConsumptionTurntableTransfer = class("RedAlertTimeConsumptionTurntableTransferClass", Window)

--打开界面
local red_alert_time_consumption_turntable_open_terminal = {
	_name = "red_alert_time_consumption_turntable_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("RedAlertTimeConsumptionTurntableTransferClass") == nil then
    		fwin:open(RedAlertTimeConsumptionTurntableTransfer:new():init(params), fwin._ui)  
        end
	    return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local red_alert_time_consumption_turntable_close_terminal = {
	_name = "red_alert_time_consumption_turntable_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RedAlertTimeConsumptionTurntableTransferClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(red_alert_time_consumption_turntable_open_terminal)
state_machine.add(red_alert_time_consumption_turntable_close_terminal)
state_machine.init()

function RedAlertTimeConsumptionTurntableTransfer:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}
    -- 奖励绘制
    self._panel_list = {}
    self._image_list = {}
    -- 转盘动画
    self._round = 0
    self.m_times = 0
    self.m_reset_times = 0
    self.accept_the_prize = false
    self.ranking_refresh_time = 0

    self._label_close_text = nil
    self._label_reset_text = nil

    local function init_red_alert_time_consumption_turntable_terminal()
        local red_alert_time_consumption_turntable_show_terminal = {
            _name = "red_alert_time_consumption_turntable_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_consumption_turntable_hide_terminal = {
            _name = "red_alert_time_consumption_turntable_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 转盘
        local red_alert_time_consumption_turntable_buy_terminal = {
            _name = "red_alert_time_consumption_turntable_buy",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- debug.print_r(_ED.activity_info["22"])
                -- state_machine.lock("red_alert_time_consumption_turntable_buy")
                -- state_machine.lock("red_alert_time_consumption_turntable_window_close")
                local activity = _ED.activity_info[""..instance._activity_type.activity_type]
                local activity_add_state = zstring.split(activity.activity_add_state,",")
                if tonumber(activity_add_state[11])/1000 > (tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))) then
                else
                    TipDlg.drawTextDailog(activity_str_tip[88])
                    return
                end
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            response.node:beginRotary()
                        else
                            state_machine.unlock("red_alert_time_consumption_turntable_buy")
                            state_machine.unlock("red_alert_time_consumption_turntable_window_close")
                        end
                    else
                        state_machine.unlock("red_alert_time_consumption_turntable_buy")
                        state_machine.unlock("red_alert_time_consumption_turntable_window_close")
                    end
                    checkPlayEffect(68)
                end
                protocol_command.draw_activity_reward.param_list = activity.activity_id .. "\r\n"..activity.activity_type.."\r\n0\r\n0".."\r\n"..params._datas._type
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil) 
                -- instance:beginRotary()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_consumption_turntable_show_terminal)
        state_machine.add(red_alert_time_consumption_turntable_hide_terminal)
        state_machine.add(red_alert_time_consumption_turntable_buy_terminal)
        state_machine.init()
    end
    
    init_red_alert_time_consumption_turntable_terminal()
end

function RedAlertTimeConsumptionTurntableTransfer:updateDraw()
	-- debug.print_r(_ED.activity_info["81"])
    local root = self.roots[1]
    local activity_type = tonumber(self._activity_type.activity_type)
    self._activity_type = _ED.activity_info[""..activity_type]
    -- 描述
    local Text_consumption_turntable_infor_p_1 = ccui.Helper:seekWidgetByName(root,"Text_consumption_turntable_infor_p_1")
    Text_consumption_turntable_infor_p_1:setString(self._activity_type.activity_dec)
	
	local Text_consumption_p_2 =  ccui.Helper:seekWidgetByName(root,"Text_consumption_p_2")
	local m_datas = zstring.split(self._activity_type.activity_add_state,",")
    local count = math.floor(tonumber(m_datas[4])/tonumber(m_datas[7]))-tonumber(m_datas[5])
    if count < 0 then
        count = 0
    end
	Text_consumption_p_2:setString(count)

    local Button_consumption_one = ccui.Helper:seekWidgetByName(root,"Button_consumption_one")
    local Button_consumption_ten = ccui.Helper:seekWidgetByName(root,"Button_consumption_ten")
    local Button_consumption_free = ccui.Helper:seekWidgetByName(root,"Button_consumption_free")
    self.Button_consumption_one = Button_consumption_one
    self.Button_consumption_ten = Button_consumption_ten
    self.Button_consumption_free = Button_consumption_free
    Button_consumption_one:setBright(true)
    Button_consumption_one:setTouchEnabled(true)
    Button_consumption_ten:setBright(true)
    Button_consumption_ten:setTouchEnabled(true)
    Button_consumption_free:setBright(true)
    Button_consumption_free:setTouchEnabled(true)
    if tonumber(m_datas[10]) - tonumber(m_datas[9]) > 0 then
        Text_consumption_p_2:setString(count + tonumber(m_datas[10]) - tonumber(m_datas[9]))
        Button_consumption_free:setVisible(true)
        Button_consumption_one:setVisible(false)
        Button_consumption_ten:setBright(false)
        Button_consumption_ten:setTouchEnabled(false)
    else
        Button_consumption_one:setVisible(true)
        Button_consumption_free:setVisible(false)
        if count <= 0 then
            Button_consumption_one:setBright(false)
            Button_consumption_one:setTouchEnabled(false)
            Button_consumption_ten:setBright(false)
            Button_consumption_ten:setTouchEnabled(false)
        end
    end
	
    local Text_consumption_p_3 = ccui.Helper:seekWidgetByName(root,"Text_consumption_p_3")
    local Text_consumption_p_4 = ccui.Helper:seekWidgetByName(root,"Text_consumption_p_4")
    local Text_consumption_p_5 = ccui.Helper:seekWidgetByName(root,"Text_consumption_p_5")
	local Text_consumption_p_6 = ccui.Helper:seekWidgetByName(root,"Text_consumption_p_6")
    if activity_type == 81 then      -- 积分转盘
        Text_consumption_p_4:setVisible(true)
        Text_consumption_p_5:setVisible(true)
        Text_consumption_p_6:setVisible(true)
    	Text_consumption_p_5:setString(m_datas[6])
        Text_consumption_p_3:setString(string.format(activity_str_tip[166], tonumber(m_datas[7])))
    elseif activity_type == 20000 then      -- 充值转盘
        Text_consumption_p_4:setVisible(false)
        Text_consumption_p_5:setVisible(false)
        Text_consumption_p_6:setVisible(false)
        Text_consumption_p_3:setString(string.format(activity_str_tip[167], tonumber(m_datas[7])))
    end

    -- 时间
    local activity_add_state = zstring.split(self._activity_type.activity_add_state,",")
    local isEnd = false
    if activity_type == 81 then      -- 积分转盘
        if tonumber(activity_add_state[11])/1000 > (tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))) then
            isEnd = false
        else
            isEnd = true
            Button_consumption_one:setBright(false)
            Button_consumption_one:setTouchEnabled(false)
            Button_consumption_ten:setBright(false)
            Button_consumption_ten:setTouchEnabled(false)
            Button_consumption_free:setBright(false)
            Button_consumption_free:setTouchEnabled(false)
        end
    elseif activity_type == 20000 then      -- 充值转盘
        isEnd = true
    end
    self.accept_the_prize = isEnd
    local intervalTime = 0
    local time_str = ""
    if isEnd == true then
        self.m_times = ((tonumber(activity_add_state[2])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
        intervalTime = ((tonumber(activity_add_state[2])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))/86400
        time_str = activity_str_tip[92]
        if activity_type == 20000 then
            time_str = activity_str_tip[93]
        end
    else
        self.m_times = ((tonumber(activity_add_state[11])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
        intervalTime = ((tonumber(activity_add_state[11])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))/86400
        time_str = activity_str_tip[93]
    end
    -- 结束和关闭倒计时
    local Text_consumption_act_time_1 = ccui.Helper:seekWidgetByName(root,"Text_consumption_act_time_1")
    Text_consumption_act_time_1:removeAllChildren(true)
    Text_consumption_act_time_1:setString("")
    local font_size = Text_consumption_act_time_1:getFontSize()
    local time_info = cc.Label:createWithTTF(time_str, config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_info:setName("time_info")
    time_info:setAnchorPoint(cc.p(0, 0.5))
    time_info:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    time_info:setPositionX(0)
    time_info:setPositionY(Text_consumption_act_time_1:getContentSize().height / 2)
    time_info:setTag(200)
    Text_consumption_act_time_1:addChild(time_info)
    local time_int = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_int:setName("time_int")
    time_int:setAnchorPoint(cc.p(0, 0.5))
    time_int:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    time_int:setPositionX(time_info:getContentSize().width)
    time_int:setPositionY(Text_consumption_act_time_1:getContentSize().height / 2)
    time_int:setTag(100)
    Text_consumption_act_time_1:addChild(time_int)
    self._label_close_text = time_int

    -- 重置倒计时
    local server_time = getCurrentGTM8Time()
    self.m_reset_times = (24 - server_time.hour) * 3600 + (0 - server_time.min) * 60 + 0 - server_time.sec - 1

    local Text_consumption_act_time_2 = ccui.Helper:seekWidgetByName(root,"Text_consumption_act_time_2")
    Text_consumption_act_time_2:removeAllChildren(true)
    Text_consumption_act_time_2:setString("")
    local reset_time_int = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    reset_time_int:setName("reset_time_int")
    reset_time_int:setAnchorPoint(cc.p(0, 0.5))
    reset_time_int:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    reset_time_int:setPositionX(Text_consumption_act_time_2:getContentSize().width - 80)
    reset_time_int:setPositionY(Text_consumption_act_time_2:getContentSize().height / 2)
    reset_time_int:setTag(100)
    Text_consumption_act_time_2:addChild(reset_time_int)
    local reset_time_info = cc.Label:createWithTTF(activity_str_tip[96], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    reset_time_info:setName("reset_time_info")
    reset_time_info:setAnchorPoint(cc.p(1, 0.5))
    reset_time_info:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    reset_time_info:setPositionX(Text_consumption_act_time_2:getContentSize().width - 80)
    reset_time_info:setPositionY(Text_consumption_act_time_2:getContentSize().height / 2)
    reset_time_info:setTag(200)
    Text_consumption_act_time_2:addChild(reset_time_info)
    self._label_reset_text = reset_time_int

    -- 绘制奖励
    local activity_data = self._activity_type.activity_data[1]
    self._panel_list = {}
    self._image_list = {}
    for i=1,12 do
        local function showCell()
            local panel = ccui.Helper:seekWidgetByName(root,"Panel_consumption_icon_"..i)
            local image = ccui.Helper:seekWidgetByName(root,"Image_consumption_hook_"..i)
            panel:removeAllChildren(true)
            image:setVisible(false)
            table.insert(self._panel_list, panel)
            table.insert(self._image_list, image)
            -- 如果奖励存在绘制奖励
            if activity_data ~= nil then
                local datas = zstring.split(activity_data[i].achieve_reward, ",")
                if tonumber(datas[1]) == -1 then
                    datas[1] = resource_prop_id[tonumber(datas[2])]
                    datas[2] = 1
                end
                local prop_type = tonumber(datas[2])
                local show_type = 6
                local prop_from_type = 3
                if tonumber(datas[2]) == 13 then --坦克
                    prop_type = 3
                    prop_from_type = 10
                elseif tonumber(datas[2]) == 6 then --道具    
                    prop_type = 1
                    prop_from_type = 1
                elseif tonumber(datas[2]) == 7 then --配件    
                    prop_type = 7
                    prop_from_type = 4
                else
                    prop_type = 1
                    prop_from_type = 1
                end
				local cell = nil
				if prop_type == 7 then
					local equip_datas = {}
					equip_datas.equipment_name = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.equipment_name)
					equip_datas.pic_index = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.pic_index)
					cell = state_machine.excute("props_icon_create_cell",0,{show_type, 3, equip_datas, tonumber(prop_type), tonumber(datas[3])})
				else
					cell = state_machine.excute("props_icon_create_cell",0,{show_type, prop_from_type, tonumber(datas[1]), tonumber(prop_type), tonumber(datas[3]),false,tonumber(datas[1])})
				end
				ccui.Helper:seekWidgetByName(cell.roots[1], "Image_1"):setVisible(false)
				ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_attribute_icon"):setVisible(false)
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
end

function RedAlertTimeConsumptionTurntableTransfer:onUpdate(dt)
    if self.accept_the_prize == false then
        if self.ranking_refresh_time <= 0 then
            self.ranking_refresh_time = self.ranking_refresh_time + dt
            if self.ranking_refresh_time >= 5*60 then
                self:rankingRefresh()
                self.ranking_refresh_time = 0
            end
        end
    end

    if self.m_reset_times > 0 then
        self.m_reset_times = self.m_reset_times - dt
        if self._label_reset_text ~= nil then
            self._label_reset_text:setString(getRedAlertTimeActivityFormat(self.m_reset_times))
        end
        if self.m_reset_times <= 0 then
            self.m_reset_times = 0
            self:updateDraw()
        end
    end
    if self.m_times > 0 then
        self.m_times = self.m_times - dt
        if self._label_close_text ~= nil then
            self._label_close_text:setString(getRedAlertTimeActivityFormat(self.m_times))
        end
        if self.m_times <= 0 then
            self.m_times = 0
            if self.accept_the_prize == true then
                -- state_machine.excute("red_alert_time_center_find",0,"red_alert_time_consumption_turntable_close")
            else
                self:updateDraw()
            end
        end
    end
end

-- 转盘抽奖动画结束
function RedAlertTimeConsumptionTurntableTransfer:endRotary()
    self._round = 0
    state_machine.unlock("red_alert_time_consumption_turntable_buy")
    state_machine.unlock("red_alert_time_consumption_turntable_window_close")
    local function playActionOne(sender)
        if sender.roots ~= nil then
            sender:stopAllActions()
            sender:updateDraw()
        end
        state_machine.excute("main_window_update_userinfo", 0, nil)
        state_machine.excute("home_map_update_build", 0, nil)
    end
    local action = cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(0.2),cc.CallFunc:create(playActionOne)))
    self:runAction(action)
end
-- 转盘抽奖动画开始
function RedAlertTimeConsumptionTurntableTransfer:beginRotary()
    local root = self.roots[1]
    local index = 0
    local delayTime = 0
    local max_times = 0
    self._round = self._round + 1
    if self._round == 1 then
        delayTime = 0.06
        max_times = 12
    elseif self._round == 2 then
        delayTime = 0.07
        max_times = 12 + zstring.tonumber(_ED.activity_rotary_index) - 1
    end
    local function playActionOne(sender)
        index = index + 1
        if index > max_times then
            sender:stopAllActions()
            if sender._round ~= 3 then
                sender:beginRotary()
            else
                sender:endRotary()
            end
        else
            local cell_index = math.floor(index%12)
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
--初始化
function RedAlertTimeConsumptionTurntableTransfer:onInit()
    local csbItem = csb.createNode(config_csb.treasurehouse.consumption_turntable_tab_1)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

    -- 单次转盘
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_consumption_one"), nil, 
    {
        terminal_name = "red_alert_time_consumption_turntable_buy", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
		_type = 0,
    }, nil, 1)

    -- 免费探索
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_consumption_free"), nil, 
    {
        terminal_name = "red_alert_time_consumption_turntable_buy", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
		_type = 0,
    }, nil, 1)

    -- 一键转盘
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_consumption_ten"), nil, 
    {
        terminal_name = "red_alert_time_consumption_turntable_buy", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
		_type = 1,
    }, nil, 1)

    self:updateDraw()
end

function RedAlertTimeConsumptionTurntableTransfer:onEnterTransitionFinish()

end

function RedAlertTimeConsumptionTurntableTransfer:init(params)
    self._rootWindows = params[1]
    self._activity_type = params[2]
	self:onInit()
    return self
end

function RedAlertTimeConsumptionTurntableTransfer:onExit()
    state_machine.remove("red_alert_time_consumption_turntable_show")
    state_machine.remove("red_alert_time_consumption_turntable_hide")
    state_machine.remove("red_alert_time_consumption_turntable_buy")
end