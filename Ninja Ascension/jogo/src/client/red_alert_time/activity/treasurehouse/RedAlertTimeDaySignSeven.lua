-----------------------------
--7天签到1
-----------------------------
RedAlertTimeDaySignSeven = class("RedAlertTimeDaySignSevenClass", Window)

local red_alert_time_day_sign_seven_window_open_terminal = {
    _name = "red_alert_time_day_sign_seven_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeDaySignSevenClass") then
			fwin:open(RedAlertTimeDaySignSeven:new():init(params), fwin._ui)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_day_sign_seven_window_close_terminal = {
    _name = "red_alert_time_day_sign_seven_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RedAlertTimeDaySignSevenClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_day_sign_seven_window_open_terminal)
state_machine.add(red_alert_time_day_sign_seven_window_close_terminal)
state_machine.init()

function RedAlertTimeDaySignSeven:ctor()
    self.super:ctor()
    self.roots = {}
	self._activity = nil
	self.group = nil
    --load lua file

    self.m_reset_times = 0

	app.load("client.red_alert_time.cells.activity.treasurehouse.red_alert_time_act_day_sign_cell")
	
    -- Initialize red_alert_time_day_sign_seven state machine.
    local function init_red_alert_time_day_sign_seven_terminal()
		
		-- local copy_paste_text_start_terminal = {
          -- _name = "copy_paste_text_start",
          -- _init = function (terminal) 
              
      
          -- end,
          -- _inited = false,
          -- _instance = self,
          -- _state = 0,
          -- _invoke = function(terminal, instance, params) 
				-- handlePlatformRequest(0, CC_COPY_PASTE_TEXT_START, "")
                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
          -- }

        -- state_machine.add(copy_paste_text_terminal)
        state_machine.init()
    end
    
    -- call func init red_alert_time_day_sign_seven state machine.
    init_red_alert_time_day_sign_seven_terminal()
end


function RedAlertTimeDaySignSeven:onUpdateDraw()
    local root = self.roots[1]
    --标题
    ccui.Helper:seekWidgetByName(root,"Text_day_sign_title"):setString(self._activity.activity_title)
    
    local ListView_day_sign = ccui.Helper:seekWidgetByName(root,"ListView_day_sign")
	ListView_day_sign:removeAllItems()
	local index = 0
	for i=1,#self._activity.activity_data[tonumber(self.group)] do
		-- debug.print_r(self._activity.activity_data[tonumber(self.group)])
		local cell = state_machine.excute("red_alert_time_act_day_sign_cell",0,{self._activity.activity_data[tonumber(self.group)][i], i, self._activity.activity_type,self.group})
		ListView_day_sign:addChild(cell)
	end
	ListView_day_sign:requestRefreshView()

-- 重置倒计时
    local server_time = getCurrentGTM8Time()
    self.m_reset_times = (24 - server_time.hour) * 3600 + (0 - server_time.min) * 60 + 0 - server_time.sec - 1

    local Text_day_act_time_2 = ccui.Helper:seekWidgetByName(root,"Text_day_act_time_2")
    Text_day_act_time_2:removeAllChildren(true)
    Text_day_act_time_2:setString("")
    local font_size = Text_day_act_time_2:getFontSize()
    local reset_time_int = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    reset_time_int:setName("reset_time_int")
    reset_time_int:setAnchorPoint(cc.p(0, 0.5))
    reset_time_int:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    reset_time_int:setPositionX(Text_day_act_time_2:getContentSize().width)
    reset_time_int:setPositionY(Text_day_act_time_2:getContentSize().height / 2)
    reset_time_int:setTag(100)
    Text_day_act_time_2:addChild(reset_time_int)
    local reset_time_info = cc.Label:createWithTTF(activity_str_tip[97], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    reset_time_info:setName("reset_time_info")
    reset_time_info:setAnchorPoint(cc.p(1, 0.5))
    reset_time_info:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    reset_time_info:setPositionX(Text_day_act_time_2:getContentSize().width)
    reset_time_info:setPositionY(Text_day_act_time_2:getContentSize().height / 2)
    reset_time_info:setTag(200)
    Text_day_act_time_2:addChild(reset_time_info)
end

function RedAlertTimeDaySignSeven:onUpdate(dt)
    if self.m_reset_times > 0 then
        self.m_reset_times = self.m_reset_times - dt
        if ccui.Helper:seekWidgetByName(self.roots[1],"Text_day_act_time_2"):getChildByTag(100) ~= nil then
            ccui.Helper:seekWidgetByName(self.roots[1],"Text_day_act_time_2"):getChildByTag(100):setString(getRedAlertTimeActivityFormat(self.m_reset_times))
        end
        if self.m_reset_times <= 0 then
            self.m_reset_times = 0
            self:onUpdateDraw()
        end
    end
end

function RedAlertTimeDaySignSeven:onEnterTransitionFinish()

end

function RedAlertTimeDaySignSeven:onInit( )
    local csbItem = csb.createNode(config_csb.treasurehouse.day_sign_seven)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_day_sign_close"), nil, 
    {
        terminal_name = "red_alert_time_day_sign_seven_window_close", 
        terminal_state = 0,
        touch_black = true,
    }, nil, 3)
	
	self:onUpdateDraw()
end

function RedAlertTimeDaySignSeven:init(params)
	self._activity = params[1]
	self.group = params[2]
	self:onInit()
    return self
end

function RedAlertTimeDaySignSeven:onExit()
    -- state_machine.remove("red_alert_time_day_sign_seven_activity_codes")
end
