-----------------------------
--兄弟同享的列表页
-----------------------------
RedAlertTimeBrothersPackage = class("RedAlertTimeBrothersPackageClass", Window)

local red_alert_time_brothers_package_window_open_terminal = {
    _name = "red_alert_time_brothers_package_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = RedAlertTimeBrothersPackage:new():init(params)
        fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_brothers_package_window_open_terminal)
state_machine.init()

function RedAlertTimeBrothersPackage:ctor()
    self.super:ctor()
    self.roots = {}
	self.activityInfo = nil

    self._list_view = nil
    self._list_view_poy = 0
    self._list_view_height = 0

    self._Image_brothers_share_arrow_down = nil
    self._Image_brothers_share_arrow_up = nil
	
	app.load("client.red_alert_time.cells.activity.treasurehouse.red_alert_time_brothers_share_package_cell")

    local function init_red_alert_time_brothers_package_terminal()
		--显示界面
		local red_alert_time_brothers_package_show_terminal = {
            _name = "red_alert_time_brothers_package_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--隐藏界面
		local red_alert_time_brothers_package_hide_terminal = {
            _name = "red_alert_time_brothers_package_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		--全部领取
		local red_alert_time_brothers_package_all_received_terminal = {
            _name = "red_alert_time_brothers_package_all_received",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							local items = self._list_view:getItems()
							for i,v in pairs(items) do
								v:refreshTheData()
							end
							instance:onUpdateDraw()
							checkRewardObtainDraw()
                            if _ED.mould_function_push_info["11"] ~= nil then
                                _ED.mould_function_push_info["11"].params = 0
                            end
                            state_machine.excute("notification_center_update", 0, "push_notification_brothers_personal")
                            state_machine.excute("notification_center_update", 0, "push_notification_mine_treasure_push")
                            state_machine.excute("red_alert_time_center_update_push", 0, 57)
						end
					end
				end		
				-- debug.print_r(self.activityInfo[1])
				local index = 0
				if _ED.list_of_activities_brothers~= nil then
					for k,v in pairs(_ED.list_of_activities_brothers) do
						if tonumber(v.status) == 0 then
							index = k-1
							break
						end
					end
				end
				protocol_command.draw_activity_reward.param_list = self.activityInfo[1].activity_id .. "\r\n"..self.activityInfo[1].activity_type.."\r\n".."0".."\r\n".."0".."\r\n".."1".."\r\n"..tonumber(index)
				NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(red_alert_time_brothers_package_show_terminal)	
		state_machine.add(red_alert_time_brothers_package_hide_terminal)
		state_machine.add(red_alert_time_brothers_package_all_received_terminal)
        state_machine.init()
    end
    init_red_alert_time_brothers_package_terminal()
end

function RedAlertTimeBrothersPackage:onHide()
    self:setVisible(false)
end

function RedAlertTimeBrothersPackage:onShow()
    self:setVisible(true)
	local function responseCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if response.node ~= nil and response.node.roots ~= nil then
				self:onUpdateDraw()
			end
		end
	end		
	-- debug.print_r(self.activityInfo[1])
	protocol_command.draw_activity_reward.param_list = self.activityInfo[1].activity_id .. "\r\n"..self.activityInfo[1].activity_type.."\r\n".."0".."\r\n".."0".."\r\n".."0"
	NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, self, responseCallback, false, nil)  
end

function RedAlertTimeBrothersPackage:onUpdateDraw()
    local root = self.roots[1]
    local Text_brothers_share_reward_not = ccui.Helper:seekWidgetByName(root, "Text_brothers_share_reward_not")
    local Button_brothers_share_rec = ccui.Helper:seekWidgetByName(root, "Button_brothers_share_rec")
    Text_brothers_share_reward_not:setVisible(false)
    Button_brothers_share_rec:setBright(true)
    Button_brothers_share_rec:setTouchEnabled(true)
    
    local ListView_brothers_share_tab = ccui.Helper:seekWidgetByName(root, "ListView_brothers_share_tab")
    self._list_view = ListView_brothers_share_tab
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()
    local isReceive = false
	local index = 0 
	if _ED.list_of_activities_brothers~= nil then
        if #_ED.list_of_activities_brothers <= 0 then
            Text_brothers_share_reward_not:setVisible(true)
        end
		for k,v in pairs(_ED.list_of_activities_brothers) do
			index = index + 1
			local cell = state_machine.excute("red_alert_time_brothers_share_package_cell_create", 0, {v,self.activityInfo[1],index})
			self._list_view:addChild(cell)
            if tonumber(v.status) == 0 then
                isReceive = true
            end
		end
    else
        Text_brothers_share_reward_not:setVisible(true)
        Button_brothers_share_rec:setBright(false)
        Button_brothers_share_rec:setTouchEnabled(false)
    end
    self._list_view:requestRefreshView()
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
    local Button_brothers_share_rec = ccui.Helper:seekWidgetByName(root,"Button_brothers_share_rec")
    if isReceive == false then
        ccui.Helper:seekWidgetByName(root,"Button_brothers_share_rec"):setTouchEnabled(false)
        ccui.Helper:seekWidgetByName(root,"Button_brothers_share_rec"):setBright(false)
    else
        ccui.Helper:seekWidgetByName(root,"Button_brothers_share_rec"):setTouchEnabled(true)
        ccui.Helper:seekWidgetByName(root,"Button_brothers_share_rec"):setBright(true)
    end

end

function RedAlertTimeBrothersPackage:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_brothers_share_arrow_down:setVisible(true)
        else
            self._Image_brothers_share_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_brothers_share_arrow_up:setVisible(true)
        else
            self._Image_brothers_share_arrow_up:setVisible(false)
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

function RedAlertTimeBrothersPackage:onEnterTransitionFinish()

end

function RedAlertTimeBrothersPackage:onInit( )
    local csbItem = csb.createNode(config_csb.treasurehouse.brothers_share_tab_2)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    self._Image_brothers_share_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_brothers_share_arrow_down")
    self._Image_brothers_share_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_brothers_share_arrow_up")
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_brothers_share_arrow_down:stopAllActions()
    self._Image_brothers_share_arrow_up:stopAllActions()
    playActions(self._Image_brothers_share_arrow_down)
    playActions(self._Image_brothers_share_arrow_up)
    self._Image_brothers_share_arrow_down:setVisible(false)
    self._Image_brothers_share_arrow_up:setVisible(false)

	local function responseCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if response.node ~= nil and response.node.roots ~= nil then
				self:onUpdateDraw()
			end
		end
	end		
	-- debug.print_r(self.activityInfo[1])
	protocol_command.draw_activity_reward.param_list = self.activityInfo[1].activity_id .. "\r\n"..self.activityInfo[1].activity_type.."\r\n".."0".."\r\n".."0".."\r\n".."0"
	NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, self, responseCallback, false, nil)  
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_brothers_share_rec"), nil, 
    {
        terminal_name = "red_alert_time_brothers_package_all_received", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)
end

function RedAlertTimeBrothersPackage:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow     
	self.activityInfo = params[2]	
	self:onInit()
    return self
end

function RedAlertTimeBrothersPackage:onExit()
    state_machine.remove("red_alert_time_brothers_package_show")
    state_machine.remove("red_alert_time_brothers_package_hide")
    state_machine.remove("red_alert_time_brothers_package_all_received")
end
