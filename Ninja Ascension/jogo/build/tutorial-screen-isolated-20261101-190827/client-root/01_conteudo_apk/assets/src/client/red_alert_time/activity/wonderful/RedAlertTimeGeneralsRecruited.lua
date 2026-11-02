-----------------------------
--配件进化
-----------------------------
RedAlertTimeGeneralsRecruited = class("RedAlertTimeGeneralsRecruitedClass", Window)

local red_alert_time_generals_recruited_window_open_terminal = {
    _name = "red_alert_time_generals_recruited_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeGeneralsRecruitedClass") then
            local panel = RedAlertTimeGeneralsRecruited:new():init(params)
            fwin:open(panel)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_generals_recruited_window_open_terminal)
state_machine.init()

function RedAlertTimeGeneralsRecruited:ctor()
    self.super:ctor()
    self.roots = {}
	self.activity_type = nil
	self.m_times = 0
    self.m_reset_times = 0
	app.load("client.red_alert_time.cells.activity.wonderful.red_alert_time_act_share_cell")
	app.load("client.red_alert_time.cells.activity.wonderful.red_alert_time_equip_evolution_cell")
	app.load("client.red_alert_time.cells.activity.wonderful.red_alert_time_equip_purchase_cell")
	
    self._list_view = nil
    self._list_view_poy = 0
    self._list_view_height = 0

    self._Image_parts_strengthen_arrow_down = nil
    self._Image_parts_strengthen_arrow_up = nil
    --load lua file
    -- Initialize red_alert_time_generals_recruited state machine.
    local function init_red_alert_time_generals_recruited_terminal()
	
        --
        local red_alert_time_generals_recruited_activity_codes_terminal = {
          _name = "red_alert_time_generals_recruited_activity_codes",
          _init = function (terminal) 
          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
         }
		 
		 local red_alert_time_generals_recruited_page_terminal = {
            _name = "red_alert_time_generals_recruited_page",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params._datas._page == 2 then
                    _ED.push_parts_activity_state = false
                    state_machine.excute("notification_center_update", 0, "push_notification_parts_activity_state")
                end
            	instance:changeSelectPage(params._datas._page)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(red_alert_time_generals_recruited_activity_codes_terminal)
        state_machine.add(red_alert_time_generals_recruited_page_terminal)
        state_machine.init()
    end
    
    -- call func init red_alert_time_generals_recruited state machine.
    init_red_alert_time_generals_recruited_terminal()
end

function RedAlertTimeGeneralsRecruited:changeSelectPage( page )
    local root = self.roots[1]
    local Button_parts_strengthen_up = ccui.Helper:seekWidgetByName(root, "Button_parts_strengthen_up")
    local Button_parts_strengthen_material = ccui.Helper:seekWidgetByName(root, "Button_parts_strengthen_material")
    if page == self._current_page then
        if page == 1 then
            Button_parts_strengthen_up:setHighlighted(true)
        elseif page == 2 then
            Button_parts_strengthen_material:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_parts_strengthen_up:setHighlighted(false)
    Button_parts_strengthen_material:setHighlighted(false)
    if page == 1 then
        Button_parts_strengthen_up:setHighlighted(true)
	elseif page == 2 then
		Button_parts_strengthen_material:setHighlighted(true)
	end
	self:onUpdateDrawPage(page)
end

function RedAlertTimeGeneralsRecruited:onUpdateDrawPage(page)
	local root = self.roots[1]
	local ListView_parts_strengthen = ccui.Helper:seekWidgetByName(root,"ListView_parts_strengthen")
    ListView_parts_strengthen:jumpToTop()
	ListView_parts_strengthen:removeAllItems()
	for i,v in pairs(_ED.activity_info[""..self.activity_type].activity_data[page]) do
		local cell = nil
		if page == 1 then
			cell = state_machine.excute("red_alert_time_equip_evolution_cell",0,{v,tonumber(v.achieve_index),self.activity_type,page})
		else
			cell = state_machine.excute("red_alert_time_equip_purchase_cell",0,{_ED.activity_info[""..self.activity_type].activity_data[2][i],v.achieve_index,self.activity_type,2})
		end
		if cell~= nil then
			ListView_parts_strengthen:addChild(cell)
		end
	end
    self._list_view = ListView_parts_strengthen
    self._list_view:requestRefreshView()
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
end	

function RedAlertTimeGeneralsRecruited:onUpdate(dt)
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
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_parts_strengthen_arrow_down:setVisible(true)
        else
            self._Image_parts_strengthen_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_parts_strengthen_arrow_up:setVisible(true)
        else
            self._Image_parts_strengthen_arrow_up:setVisible(false)
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
                -- v:unload()
            else
                -- v:reload()
            end
        end
    end
end

function RedAlertTimeGeneralsRecruited:onUpdateDraw()
    local root = self.roots[1]
	-- debug.print_r(_ED.activity_info[""..self.activity_type])
	--活动名称
	local Text_parts_strengthen_name = ccui.Helper:seekWidgetByName(root,"Text_parts_strengthen_name")
	Text_parts_strengthen_name:setString(_ED.activity_info[""..self.activity_type].activity_title)
	--活动描述
	local Text_parts_strengthen_infor_p = ccui.Helper:seekWidgetByName(root,"Text_parts_strengthen_infor_p")
	Text_parts_strengthen_infor_p:setString(_ED.activity_info[""..self.activity_type].activity_dec)
	
	--活动开启结束时间
	local timesData = zstring.split(_ED.activity_info[""..self.activity_type].activity_add_state, ",")
	local startTime = getRedAlertTimeFormatYMDHMS(tonumber(timesData[1])/1000)
	local endTime = getRedAlertTimeFormatYMDHMS(tonumber(timesData[2])/1000-1)
    local intervalTime = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))/86400
    self.m_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))

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
    local reset_time_info = cc.Label:createWithTTF(activity_str_tip[99], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    reset_time_info:setName("reset_time_info")
    reset_time_info:setAnchorPoint(cc.p(1, 0.5))
    reset_time_info:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    reset_time_info:setPositionX(Text_parts_strengthen_act_time_2:getContentSize().width - 80)
    reset_time_info:setPositionY(Text_parts_strengthen_act_time_2:getContentSize().height / 2)
    reset_time_info:setTag(200)
    Text_parts_strengthen_act_time_2:addChild(reset_time_info)
	
end

function RedAlertTimeGeneralsRecruited:onEnterTransitionFinish()

end

function RedAlertTimeGeneralsRecruited:onInit( )
    local csbItem = csb.createNode(config_csb.activity.act_parts_strengthen)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_parts_strengthen_up"), nil, 
    {
        terminal_name = "red_alert_time_generals_recruited_page", 
        terminal_state = 0, 
		_page = 1,
    }, nil, 1)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_parts_strengthen_material"), nil, 
    {
        terminal_name = "red_alert_time_generals_recruited_page", 
        terminal_state = 0, 
		_page = 2,
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_parts_activity_state",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_parts_strengthen_material"),
    _invoke = nil,
    _interval = 0.2,})

    self._Image_parts_strengthen_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_parts_strengthen_arrow_down")
    self._Image_parts_strengthen_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_parts_strengthen_arrow_up")
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_parts_strengthen_arrow_down:stopAllActions()
    self._Image_parts_strengthen_arrow_up:stopAllActions()
    playActions(self._Image_parts_strengthen_arrow_down)
    playActions(self._Image_parts_strengthen_arrow_up)
    self._Image_parts_strengthen_arrow_down:setVisible(false)
    self._Image_parts_strengthen_arrow_up:setVisible(false)
	
	self:onUpdateDraw()
	self:changeSelectPage(1)
end

function RedAlertTimeGeneralsRecruited:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
	self.activity_type = params[2]
	self:onInit()
    return self
end

function RedAlertTimeGeneralsRecruited:onExit()
    _ED.push_parts_activity_state = false
    state_machine.remove("red_alert_time_generals_recruited_activity_codes")
end
