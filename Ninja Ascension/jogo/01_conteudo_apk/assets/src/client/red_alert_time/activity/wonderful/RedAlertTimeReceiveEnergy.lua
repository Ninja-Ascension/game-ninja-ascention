-----------------------------
--领取能量
-----------------------------
RedAlertTimeReceiveEnergy = class("RedAlertTimeReceiveEnergyClass", Window)

local red_alert_time_receive_rnergy_window_open_terminal = {
    _name = "red_alert_time_receive_rnergy_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeReceiveEnergyClass") then
            local panel = RedAlertTimeReceiveEnergy:new():init(params)
            fwin:open(panel)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_receive_rnergy_window_open_terminal)
state_machine.init()

function RedAlertTimeReceiveEnergy:ctor()
    self.super:ctor()
    self.roots = {}
    self.isCanReceive = false
    --load lua file
    -- Initialize red_alert_time_receive_rnergy state machine.
    local function init_red_alert_time_receive_rnergy_terminal()
	
        --领取能量
        local red_alert_time_receive_rnergy_activity_codes_terminal = {
          _name = "red_alert_time_receive_rnergy_activity_codes",
          _init = function (terminal) 
              
      
          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params)
                if instance.isCanReceive == false then
                    TipDlg.drawTextDailog(activity_str_tip[58])
                    return 
                end
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
							response.node:onUpdateDraw()
                        end
                        state_machine.excute("red_alert_time_wonderful_update_push", 0, 59)
                        state_machine.excute("main_window_update_userinfo", 0 , "main_window_update_userinfo.")--刷新能量
                    end
                end
				for i,v in pairs(_ED.user_task_infos["3"]) do
					if tonumber(v.task_state) == 1 then
						protocol_command.get_task_reward.param_list = v.task_id .. "\r\n" .. v.task_mould_id
						NetworkManager:register(protocol_command.get_task_reward.code, nil, nil, nil, self, responseCallback, true, nil)
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
         }

         local red_alert_time_receive_rnergy_update_terminal = {
          _name = "red_alert_time_receive_rnergy_update",
          _init = function (terminal) 
              
      
          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params)
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
         }
		
        state_machine.add(red_alert_time_receive_rnergy_activity_codes_terminal)
        state_machine.add(red_alert_time_receive_rnergy_update_terminal)
        state_machine.init()
    end
    
    init_red_alert_time_receive_rnergy_terminal()
end

function RedAlertTimeReceiveEnergy:onUpdateDraw()
    local root = self.roots[1]
    local Button_add_anerge = ccui.Helper:seekWidgetByName(root,"Button_add_anerge")
    local Button_text_add_anerge = ccui.Helper:seekWidgetByName(root,"Button_text_add_anerge")
    Button_add_anerge:setTouchEnabled(true)
    Button_add_anerge:setTouchEnabled(false)
    local current = _ED.system_time + (os.time() - _ED.native_time)
    --判断中午12点的差距时间
    local noon = 12*3600
    local noonEnd = 14*3600
    local temp = getCurrentGTM8Time()
    local m_hour    = tonumber(string.format("%02d", temp.hour))
    local m_min     = tonumber(string.format("%02d", temp.min))
    local m_sec     = tonumber(string.format("%02d", temp.sec))
    if m_hour*3600+m_min*60+m_sec >= noon  and m_hour*3600+m_min*60+m_sec <= noonEnd then
    	if _ED.user_task_infos["3"] ~= nil then
    		self.isCanReceive = false
    		Button_add_anerge:setBright(false)
    		Button_add_anerge:setTitleText(wonderfun_receive_energy[3])
    		for i,v in pairs(_ED.user_task_infos["3"]) do
    			if tonumber(v.task_state) == 1 then
    				self.isCanReceive = true
    				Button_add_anerge:setBright(true)
    				Button_add_anerge:setTitleText(wonderfun_receive_energy[2])
    			end
    		end
    		
    	else
    		self.isCanReceive = false
    		Button_add_anerge:setBright(false)
    		Button_add_anerge:setTitleText(wonderfun_receive_energy[3])
    	end
    else
        self.isCanReceive = false
        Button_add_anerge:setBright(false)
        Button_add_anerge:setTitleText(wonderfun_receive_energy[3])
    end
    if Button_text_add_anerge ~= nil then
        Button_text_add_anerge:setString(Button_add_anerge:getTitleText())
        Button_add_anerge:setTitleText("")
    end
    Button_add_anerge:setTouchEnabled(true)
	
	local Panel_anerge_icon = ccui.Helper:seekWidgetByName(root,"Panel_anerge_icon")
	Panel_anerge_icon:removeAllChildren(true)
	cell = state_machine.excute("props_icon_create_cell",0,{5, 1, 12, 1, 10})
	Panel_anerge_icon:addChild(cell)
	
    local Text_add_anerge_time_2 = ccui.Helper:seekWidgetByName(root,"Text_add_anerge_time_2")
    Text_add_anerge_time_2:setString("")
    Text_add_anerge_time_2:removeAllChildren(true)
    local font_size = Text_add_anerge_time_2:getFontSize()
    local time_info_2 = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_info_2:setName("time_info_2")
    time_info_2:setAnchorPoint(cc.p(1, 0.5))
    time_info_2:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    time_info_2:setPositionX(Text_add_anerge_time_2:getContentSize().width - 80)
    time_info_2:setPositionY(Text_add_anerge_time_2:getContentSize().height / 2)
    time_info_2:setTag(200)
    Text_add_anerge_time_2:addChild(time_info_2)
    local time_int_2 = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_int_2:setName("time_int_2")
    time_int_2:setAnchorPoint(cc.p(0, 0.5))
    time_int_2:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    time_int_2:setPositionX(Text_add_anerge_time_2:getContentSize().width - 80)
    time_int_2:setPositionY(Text_add_anerge_time_2:getContentSize().height / 2)
    time_int_2:setTag(100)
    Text_add_anerge_time_2:addChild(time_int_2)
end

function RedAlertTimeReceiveEnergy:onUpdate(dt)
    local server_time = getCurrentGTM8Time()
    local leave_time = 0 
    local str = activity_str_tip[102]
    if server_time.hour < 12 then
        leave_time = (12 - server_time.hour) * 3600 - server_time.min * 60 - server_time.sec
    elseif server_time.hour >= 12 and server_time.hour < 14 and self.isCanReceive == true then
        leave_time = (14 - server_time.hour) * 3600 - server_time.min * 60 - server_time.sec
        str = activity_str_tip[103]
    elseif server_time.hour >= 12 and server_time.hour < 14 and self.isCanReceive == false then
        leave_time = (24 - server_time.hour + 12) * 3600 - server_time.min * 60 - server_time.sec
    elseif server_time.hour >= 14 then
        leave_time = (24 - server_time.hour + 12) * 3600 - server_time.min * 60 - server_time.sec
    end

    if ccui.Helper:seekWidgetByName(self.roots[1],"Text_add_anerge_time_2"):getChildByTag(100) ~= nil then
        ccui.Helper:seekWidgetByName(self.roots[1],"Text_add_anerge_time_2"):getChildByTag(100):setString(getRedAlertTimeActivityFormat(leave_time))
    end
    if ccui.Helper:seekWidgetByName(self.roots[1],"Text_add_anerge_time_2"):getChildByTag(200) ~= nil then
        ccui.Helper:seekWidgetByName(self.roots[1],"Text_add_anerge_time_2"):getChildByTag(200):setString(str)
    end
end

function RedAlertTimeReceiveEnergy:onEnterTransitionFinish()

end

function RedAlertTimeReceiveEnergy:onInit( )
    local csbItem = csb.createNode(config_csb.activity.act_add_anerge)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)
	
	--领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_add_anerge"), nil, 
    {
        terminal_name = "red_alert_time_receive_rnergy_activity_codes", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)
	
	self:onUpdateDraw()
end

function RedAlertTimeReceiveEnergy:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
	self:onInit()
    return self
end

function RedAlertTimeReceiveEnergy:onExit()
    state_machine.remove("red_alert_time_receive_rnergy_activity_codes")
end
