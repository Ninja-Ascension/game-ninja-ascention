-----------------------------
--基地冲级
-----------------------------
RedAlertTimeBaseLevel = class("RedAlertTimeBaseLevelClass", Window)

local red_alert_time_base_level_window_open_terminal = {
    _name = "red_alert_time_base_level_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeBaseLevelClass") then
            local panel = RedAlertTimeBaseLevel:new():init(params)
            fwin:open(panel)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_base_level_window_open_terminal)
state_machine.init()

function RedAlertTimeBaseLevel:ctor()
    self.super:ctor()
    self.roots = {}
	self.activity_type = nil
	self.m_times = 0
	self.interval_time = 0
	self._list_view = nil
    self._list_view_poy = 0
    self._list_view_height = 0

    self._Image_act_share_arrow_down = nil
    self._Image_act_share_arrow_up = nil
	
    --load lua file
	app.load("client.red_alert_time.cells.activity.wonderful.red_alert_time_act_share_cell")
    -- Initialize red_alert_time_base_level state machine.
    local function init_red_alert_time_base_level_terminal()
	
        --
        local red_alert_time_base_level_activity_codes_terminal = {
          _name = "red_alert_time_base_level_activity_codes",
          _init = function (terminal) 
              
      
          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
				self:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
         }
		
        state_machine.add(red_alert_time_base_level_activity_codes_terminal)
        state_machine.init()
    end
    
    -- call func init red_alert_time_base_level state machine.
    init_red_alert_time_base_level_terminal()
end

function RedAlertTimeBaseLevel:onUpdateDraw()
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

    local Text_act_share_infor = ccui.Helper:seekWidgetByName(root,"Text_act_share_infor")
    Text_act_share_infor:setString(_ED.activity_info[""..self.activity_type].activity_dec)
	--活动开启结束时间
	local timesData = zstring.split(_ED.activity_info[""..self.activity_type].activity_add_state, ",")
	local startTime = getRedAlertTimeFormatYMDHMS(tonumber(timesData[1])/1000)
	local endTime = getRedAlertTimeFormatYMDHMS(tonumber(timesData[2])/1000-1)
    local intervalTime = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))/86400
    self.m_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
    -- 结束和关闭倒计时
    local Text_act_share_act_time_1 = ccui.Helper:seekWidgetByName(root,"Text_act_share_act_time_1")
    Text_act_share_act_time_1:removeAllChildren(true)
    Text_act_share_act_time_1:setString("")
    local font_size = Text_act_share_act_time_1:getFontSize()
    local time_info = cc.Label:createWithTTF(activity_str_tip[93], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_info:setName("time_info")
    time_info:setAnchorPoint(cc.p(0, 0.5))
    time_info:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    time_info:setPositionX(0)
    time_info:setPositionY(Text_act_share_act_time_1:getContentSize().height / 2)
    time_info:setTag(200)
    Text_act_share_act_time_1:addChild(time_info)
    local time_int = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_int:setName("time_int")
    time_int:setAnchorPoint(cc.p(0, 0.5))
    time_int:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    time_int:setPositionX(time_info:getContentSize().width)
    time_int:setPositionY(Text_act_share_act_time_1:getContentSize().height / 2)
    time_int:setTag(100)
    Text_act_share_act_time_1:addChild(time_int)
end

function RedAlertTimeBaseLevel:onUpdate(dt)
	if self.m_times > 0 then
		self.m_times = self.m_times - dt
        if ccui.Helper:seekWidgetByName(self.roots[1],"Text_act_share_act_time_1"):getChildByTag(100) ~= nil then
            ccui.Helper:seekWidgetByName(self.roots[1],"Text_act_share_act_time_1"):getChildByTag(100):setString(getRedAlertTimeActivityFormat(self.m_times))
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

function RedAlertTimeBaseLevel:onEnterTransitionFinish()

end

function RedAlertTimeBaseLevel:onInit( )
    local csbItem = csb.createNode(config_csb.activity.act_share_tab)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)

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

function RedAlertTimeBaseLevel:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
	self.activity_type = params[2]
	self:onInit()
    return self
end

function RedAlertTimeBaseLevel:onExit()
    state_machine.remove("red_alert_time_base_level_activity_codes")
end
