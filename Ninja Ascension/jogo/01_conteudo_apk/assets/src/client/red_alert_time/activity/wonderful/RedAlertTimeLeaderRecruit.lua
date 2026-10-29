-----------------------------
--将领招募
-----------------------------
RedAlertTimeLeaderRecruit = class("RedAlertTimeLeaderRecruitClass", Window)

local red_alert_time_leader_recruit_window_open_terminal = {
    _name = "red_alert_time_leader_recruit_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeLeaderRecruitClass") then
            local panel = RedAlertTimeLeaderRecruit:new():init(params)
            fwin:open(panel)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_leader_recruit_window_open_terminal)
state_machine.init()

function RedAlertTimeLeaderRecruit:ctor()
    self.super:ctor()
    self.roots = {}
	self.activity_type = nil
	self.m_times = 0
    self.m_reset_times = 0
	app.load("client.red_alert_time.cells.activity.wonderful.red_alert_time_act_share_cell")
	
    --load lua file
    -- Initialize red_alert_time_leader_recruit state machine.
    local function init_red_alert_time_leader_recruit_terminal()
	
        --
        local red_alert_time_leader_recruit_activity_codes_terminal = {
          _name = "red_alert_time_leader_recruit_activity_codes",
          _init = function (terminal) 
              
      
          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
				-- state_machine.excute("rank_window_open",0,{_datas = {list_type = 12}})
				state_machine.excute("leader_school_window_open",0,"")
				state_machine.excute("wonderful_window_close",0,nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
         }
		
        state_machine.add(red_alert_time_leader_recruit_activity_codes_terminal)
        state_machine.init()
    end
    
    -- call func init red_alert_time_leader_recruit state machine.
    init_red_alert_time_leader_recruit_terminal()
end

function RedAlertTimeLeaderRecruit:onUpdateDraw()
    local root = self.roots[1]
	
	--活动名称
	local Text_leader_recruit_name = ccui.Helper:seekWidgetByName(root,"Text_leader_recruit_name")
	Text_leader_recruit_name:setString(_ED.activity_info[""..self.activity_type].activity_title)
	--活动描述
	local Text_leader_recruit_infor_p = ccui.Helper:seekWidgetByName(root,"Text_leader_recruit_infor_p")
	Text_leader_recruit_infor_p:setString(_ED.activity_info[""..self.activity_type].activity_dec)
	
	--活动开启结束时间
	local timesData = zstring.split(_ED.activity_info[""..self.activity_type].activity_add_state, ",")
	local startTime = getRedAlertTimeFormatYMDHMS(tonumber(timesData[2])/1000)
	local endTime = getRedAlertTimeFormatYMDHMS(tonumber(timesData[3])/1000-1)
    local intervalTime = ((tonumber(timesData[3])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))/86400
    self.m_times = ((tonumber(timesData[3])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))

    -- 结束和关闭倒计时
    local Text_parts_strengthen_act_time_1 = ccui.Helper:seekWidgetByName(root,"Text_parts_strengthen_act_time_1")
    Text_parts_strengthen_act_time_1:removeAllChildren(true)
    Text_parts_strengthen_act_time_1:setString("")
    local font_size = Text_parts_strengthen_act_time_1:getFontSize()
    local time_info = cc.Label:createWithTTF(activity_str_tip[93], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_info:setName("time_info")
    time_info:setAnchorPoint(cc.p(0, 0.5))
    time_info:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    time_info:setPositionX(0)
    time_info:setPositionY(Text_parts_strengthen_act_time_1:getContentSize().height / 2)
    time_info:setTag(200)
    Text_parts_strengthen_act_time_1:addChild(time_info)
    local time_int = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_int:setName("time_int")
    time_int:setAnchorPoint(cc.p(0, 0.5))
    time_int:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    time_int:setPositionX(time_info:getContentSize().width)
    time_int:setPositionY(Text_parts_strengthen_act_time_1:getContentSize().height / 2)
    time_int:setTag(100)
    Text_parts_strengthen_act_time_1:addChild(time_int)

    -- 重置倒计时
    local server_time = getCurrentGTM8Time()
    self.m_reset_times = (24 - server_time.hour) * 3600 + (0 - server_time.min) * 60 + 0 - server_time.sec - 1

    local Text_parts_strengthen_act_time_2 = ccui.Helper:seekWidgetByName(root,"Text_parts_strengthen_act_time_2")
    Text_parts_strengthen_act_time_2:removeAllChildren(true)
    Text_parts_strengthen_act_time_2:setString("")
    local reset_time_int = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    reset_time_int:setName("reset_time_int")
    reset_time_int:setAnchorPoint(cc.p(0, 0.5))
    reset_time_int:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    reset_time_int:setPositionX(Text_parts_strengthen_act_time_2:getContentSize().width - 80)
    reset_time_int:setPositionY(Text_parts_strengthen_act_time_2:getContentSize().height / 2)
    reset_time_int:setTag(100)
    Text_parts_strengthen_act_time_2:addChild(reset_time_int)
    local reset_time_info = cc.Label:createWithTTF(activity_str_tip[94], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    reset_time_info:setName("reset_time_info")
    reset_time_info:setAnchorPoint(cc.p(1, 0.5))
    reset_time_info:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    reset_time_info:setPositionX(Text_parts_strengthen_act_time_2:getContentSize().width - 80)
    reset_time_info:setPositionY(Text_parts_strengthen_act_time_2:getContentSize().height / 2)
    reset_time_info:setTag(200)
    Text_parts_strengthen_act_time_2:addChild(reset_time_info)
end

function RedAlertTimeLeaderRecruit:onUpdate(dt)
    if self.m_reset_times > 0 then
        self.m_reset_times = self.m_reset_times - dt
        if ccui.Helper:seekWidgetByName(self.roots[1],"Text_parts_strengthen_act_time_2"):getChildByTag(100) ~= nil then
            ccui.Helper:seekWidgetByName(self.roots[1],"Text_parts_strengthen_act_time_2"):getChildByTag(100):setString(getRedAlertTimeActivityFormat(self.m_reset_times))
        end
        if self.m_reset_times <= 0 then
            self.m_reset_times = 0
            self:onUpdateDraw()
        end
    end
    if self.m_times > 0 then
        self.m_times = self.m_times - dt
        if ccui.Helper:seekWidgetByName(self.roots[1],"Text_parts_strengthen_act_time_1"):getChildByTag(100) ~= nil then
            ccui.Helper:seekWidgetByName(self.roots[1],"Text_parts_strengthen_act_time_1"):getChildByTag(100):setString(getRedAlertTimeActivityFormat(self.m_times))
        end
        if self.m_times <= 0 then
            self.m_times = 0
            state_machine.excute("red_alert_time_wonderful_update_first",0,self.activity_type)
        end
    end
end

function RedAlertTimeLeaderRecruit:onEnterTransitionFinish()

end

function RedAlertTimeLeaderRecruit:onInit( )
    local csbItem = csb.createNode(config_csb.activity.act_leader_recruit)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)
	
	--前往
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_leader_recruit_go"), nil, 
    {
        terminal_name = "red_alert_time_leader_recruit_activity_codes", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)
	
	self:onUpdateDraw()
end

function RedAlertTimeLeaderRecruit:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
	self.activity_type = params[2]
	self:onInit()
    return self
end

function RedAlertTimeLeaderRecruit:onExit()
    state_machine.remove("red_alert_time_leader_recruit_activity_codes")
end
