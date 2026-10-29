-----------------------------
--全服冲V,军备竞赛
-----------------------------
RedAlertTimeLevelingVip = class("RedAlertTimeLevelingVipClass", Window)

local red_alert_time_leveling_vip_window_open_terminal = {
    _name = "red_alert_time_leveling_vip_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeLevelingVipClass") then
            local panel = RedAlertTimeLevelingVip:new():init(params)
            fwin:open(panel)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_leveling_vip_window_open_terminal)
state_machine.init()

function RedAlertTimeLevelingVip:ctor()
    self.super:ctor()
    self.roots = {}
  	self.activity_type = nil
  	self.ranking_type = 0
  	self.m_times = 0

    self._list_view = nil
    self._list_view_poy = 0
    self._list_view_height = 0

    self._Image_act_share_arrow_down = nil
    self._Image_act_share_arrow_up = nil
    self.originalGoButtonText = nil
    --load lua file
  	app.load("client.red_alert_time.cells.activity.wonderful.red_alert_time_act_share_cell")
  	app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeRuleInfor")
    -- Initialize red_alert_time_leveling_vip state machine.
    local function init_red_alert_time_leveling_vip_terminal()
	
        --
        local red_alert_time_leveling_vip_go_to_terminal = {
          _name = "red_alert_time_leveling_vip_go_to",
          _init = function (terminal) 

          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
				state_machine.excute("red_alert_time_leveling_vip_rule",0,instance.activity_type)
                return true
            end,
            _terminal = nil,
            _terminals = nil
         }
		
		local red_alert_time_leveling_vip_to_view_terminal = {
          _name = "red_alert_time_leveling_vip_to_view",
          _init = function (terminal) 

          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params)
                if instance.activity_type == 86 then
                  state_machine.excute("short_cut_go_to_other_window",0,{8})
                else
                  state_machine.excute("recharge_dialog_window_open",0,"recharge_dialog_window_open.")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
         }
		 --规则
		 local red_alert_time_leveling_vip_rule_terminal = {
          _name = "red_alert_time_leveling_vip_rule",
          _init = function (terminal) 

          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
				-- print("进入规则界面=="..params)
				state_machine.excute("red_alert_time_rule_infor_window_open",0,instance.activity_type)
                return true
            end,
            _terminal = nil,
            _terminals = nil
         }

         local red_alert_time_leveling_vip_update_draw_terminal = {
          _name = "red_alert_time_leveling_vip_update_draw",
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
		 
        state_machine.add(red_alert_time_leveling_vip_go_to_terminal)
        state_machine.add(red_alert_time_leveling_vip_to_view_terminal)
        state_machine.add(red_alert_time_leveling_vip_rule_terminal)
        state_machine.add(red_alert_time_leveling_vip_update_draw_terminal)
        state_machine.init()
    end
    
    -- call func init red_alert_time_leveling_vip state machine.
    init_red_alert_time_leveling_vip_terminal()
end

function RedAlertTimeLevelingVip:onUpdateDraw()
    local root = self.roots[1]
	local ListView_act_share = ccui.Helper:seekWidgetByName(root,"ListView_act_share")
	ListView_act_share:removeAllItems()
	local index = 1
	for i=1, #_ED.activity_info[""..self.activity_type].activity_data[1] do
	-- for i,v in pairs(_ED.activity_info["44"].activity_data[2]) do
		local cell = state_machine.excute("red_alert_time_act_share_create_cell",0,{_ED.activity_info[""..self.activity_type].activity_data[1][i],index,self.activity_type,1})
        ListView_act_share:addChild(cell)
		index = index + 1 
	end
	self._list_view = ListView_act_share
  self._list_view:requestRefreshView()
  self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
  self._list_view_height = self._list_view:getInnerContainer():getPositionY()
	--活动名称
	local Text_act_share_name = ccui.Helper:seekWidgetByName(root,"Text_act_share_name")
	Text_act_share_name:setString(_ED.activity_info[""..self.activity_type].activity_title)
	--活动描述
	local Text_act_share_infor = ccui.Helper:seekWidgetByName(root,"Text_act_share_infor")
	Text_act_share_infor:setString(_ED.activity_info[""..self.activity_type].activity_dec)
	--活动开启结束时间
	local Text_act_share_time_n = ccui.Helper:seekWidgetByName(root,"Text_act_share_time_n")
  local Button_go_legion = ccui.Helper:seekWidgetByName(root,"Button_go_legion")

  Text_act_share_time_n:removeAllChildren(true)
  Text_act_share_time_n:setString("")
  local Text_act_share_act_time_1 = ccui.Helper:seekWidgetByName(root,"Text_act_share_act_time_1")
  local Text_act_share_act_time_2 = ccui.Helper:seekWidgetByName(root,"Text_act_share_act_time_2")
  Text_act_share_act_time_1:removeAllChildren(true)
  Text_act_share_act_time_1:setString("")
  Text_act_share_act_time_2:removeAllChildren(true)
  Text_act_share_act_time_2:setString("")
	local timesData = zstring.split(_ED.activity_info[""..self.activity_type].activity_add_state, ",")
	local startTime = getRedAlertTimeFormatYMDHMS(tonumber(timesData[1])/1000)
	local endTime = getRedAlertTimeFormatYMDHMS(tonumber(timesData[2])/1000-1)
  -- local intervalTime = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))/86400
  self.m_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
    local font_size = Text_act_share_act_time_1:getFontSize()
    local time_info_1 = cc.Label:createWithTTF(activity_str_tip[93], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_info_1:setName("time_info_1")
    time_info_1:setAnchorPoint(cc.p(0, 0.5))
    time_info_1:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    time_info_1:setPositionX(0)
    time_info_1:setPositionY(Text_act_share_act_time_1:getContentSize().height / 2)
    time_info_1:setTag(200)
    Text_act_share_act_time_1:addChild(time_info_1)
    local time_int_1 = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_int_1:setName("time_int_1")
    time_int_1:setAnchorPoint(cc.p(0, 0.5))
    time_int_1:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    time_int_1:setPositionX(time_info_1:getContentSize().width)
    time_int_1:setPositionY(Text_act_share_act_time_1:getContentSize().height / 2)
    time_int_1:setTag(100)
    Text_act_share_act_time_1:addChild(time_int_1)
    local blueButtonTexture = config_res.images.ui.share.blue_button
    local yellowButtonTexture = config_res.images.ui.share.yellow_button
    local grayButtonTexture = config_res.images.ui.share.gray_button
    if self.activity_type == 86 then
        Button_go_legion:setTitleText(activity_str_tip[105])
        Button_go_legion:loadTextures(blueButtonTexture,blueButtonTexture,grayButtonTexture,1)
    else
        Button_go_legion:loadTextures(yellowButtonTexture,yellowButtonTexture,grayButtonTexture,1)
        Button_go_legion:setTitleText(self.originalGoButtonText)
        local time_info_2 = cc.Label:createWithTTF(activity_str_tip[100], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
        time_info_2:setName("time_info_2")
        time_info_2:setAnchorPoint(cc.p(1, 0.5))
        time_info_2:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
        time_info_2:setPositionX(Text_act_share_act_time_1:getContentSize().width - 80)
        time_info_2:setPositionY(Text_act_share_act_time_1:getContentSize().height / 2)
        time_info_2:setTag(200)
        Text_act_share_act_time_2:addChild(time_info_2)
        local time_int_2 = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
        time_int_2:setName("time_int_2")
        time_int_2:setAnchorPoint(cc.p(0, 0.5))
        time_int_2:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
        time_int_2:setPositionX(Text_act_share_act_time_2:getContentSize().width - 80)
        time_int_2:setPositionY(Text_act_share_act_time_2:getContentSize().height / 2)
        time_int_2:setTag(100)
        Text_act_share_act_time_2:addChild(time_int_2)
	  end
	ccui.Helper:seekWidgetByName(root,"Button_look_rank"):setTitleText(activity_str_tip[12])
end

function RedAlertTimeLevelingVip:onEnterTransitionFinish()

end

function RedAlertTimeLevelingVip:onUpdate(dt)
	if self.m_times > 0 then
  		self.m_times = self.m_times - dt
      if ccui.Helper:seekWidgetByName(self.roots[1],"Text_act_share_act_time_1"):getChildByTag(100) ~= nil then
          ccui.Helper:seekWidgetByName(self.roots[1],"Text_act_share_act_time_1"):getChildByTag(100):setString(getRedAlertTimeActivityFormat(self.m_times))
      end
      local server_time = getCurrentGTM8Time()
      local leave_time = 86400 - (server_time.hour * 3600 + server_time.min * 60 + server_time.sec)
      if ccui.Helper:seekWidgetByName(self.roots[1],"Text_act_share_act_time_2"):getChildByTag(100) ~= nil then
          ccui.Helper:seekWidgetByName(self.roots[1],"Text_act_share_act_time_2"):getChildByTag(100):setString(getRedAlertTimeActivityFormat(leave_time))
      end
      if leave_time <= 0 then
          self:onUpdateDraw()
      end
      if self.m_times <= 0 then
  			self.m_times = 0
  			state_machine.excute("red_alert_time_wonderful_update_first",0,self.activity_type)
  		end
	end
  if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_act_share_arrow_down:setVisible(true)
        else
            self._Image_act_share_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_act_share_arrow_up:setVisible(true)
        else
            self._Image_act_share_arrow_up:setVisible(false)
        end
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

function RedAlertTimeLevelingVip:onInit( )
    local csbItem = csb.createNode(config_csb.activity.act_share_tab_4)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)
	
	if ccui.Helper:seekWidgetByName(root,"ListView_act_share")._y == nil then
		ccui.Helper:seekWidgetByName(root,"ListView_act_share")._y = ccui.Helper:seekWidgetByName(root,"ListView_act_share"):getPositionY()
	end
	ccui.Helper:seekWidgetByName(root,"ListView_act_share"):setPositionY(ccui.Helper:seekWidgetByName(root,"ListView_act_share")._y)
	
	--前往活动或者查看活动
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_go_legion"), nil, 
    {
        terminal_name = "red_alert_time_leveling_vip_to_view", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)
	
	--前往排行或者活动规则
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_look_rank"), nil, 
    {
        terminal_name = "red_alert_time_leveling_vip_go_to", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    if self.originalGoButtonText == nil then
      self.originalGoButtonText = ccui.Helper:seekWidgetByName(root,"Button_go_legion"):getTitleText()
    end
	  self._Image_act_share_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_act_share_arrow_down")
    self._Image_act_share_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_act_share_arrow_up")
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_act_share_arrow_down:stopAllActions()
    self._Image_act_share_arrow_up:stopAllActions()
    playActions(self._Image_act_share_arrow_down)
    playActions(self._Image_act_share_arrow_up)
    self._Image_act_share_arrow_down:setVisible(false)
    self._Image_act_share_arrow_up:setVisible(false)

	self:onUpdateDraw()
end

function RedAlertTimeLevelingVip:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
	self.activity_type = params[2]
	self:onInit()
    return self
end

function RedAlertTimeLevelingVip:onExit()
    state_machine.remove("red_alert_time_leveling_vip_go_to")
    state_machine.remove("red_alert_time_leveling_vip_to_view")
    state_machine.remove("red_alert_time_leveling_vip_rule")
    state_machine.remove("red_alert_time_leveling_vip_update_draw")
    
end
