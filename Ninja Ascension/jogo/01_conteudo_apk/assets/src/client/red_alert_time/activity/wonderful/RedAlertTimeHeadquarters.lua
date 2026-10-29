-----------------------------
--总部援军
-----------------------------
RedAlertTimeHeadquarters = class("RedAlertTimeHeadquartersClass", Window)

local red_alert_time_headquarters_window_open_terminal = {
    _name = "red_alert_time_headquarters_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
    	if _ED.activity_info["48"] ~= nil then
	        if nil == fwin:find("RedAlertTimeHeadquartersClass") then
	            fwin:open(RedAlertTimeHeadquarters:new():init(params), fwin._ui)
	            return panel
	        end       
	    end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_headquarters_window_close_terminal = {
    _name = "red_alert_time_headquarters_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RedAlertTimeHeadquartersClass"))
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_headquarters_window_open_terminal)
state_machine.add(red_alert_time_headquarters_window_close_terminal)
state_machine.init()

function RedAlertTimeHeadquarters:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

	self.activity_type = nil
	self.local_time = 0
	app.load("client.red_alert_time.cells.activity.wonderful.red_alert_time_act_share_cell")
	
    --load lua file
    -- Initialize red_alert_time_headquarters state machine.
    local function init_red_alert_time_headquarters_terminal()
	
        --
        local red_alert_time_headquarters_activity_codes_terminal = {
          _name = "red_alert_time_headquarters_activity_codes",
          _init = function (terminal) 
          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
          		instance:playActionsLotteryTen()
				-- local acitvity = _ED.activity_info["48"]
				-- local function responseCallback(response)
				-- 	if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				-- 		if response.node ~= nil and response.node.roots ~= nil then
				-- 			instance:onUpdateDraw()
				-- 			checkRewardObtainDraw()
				-- 			state_machine.excute("red_alert_time_headquarters_window_close", 0, 0)
				-- 			state_machine.excute("main_window_remove_list_button", 0, 48)
				-- 		end
				-- 	end
				-- end		
				-- protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n".."48".."\r\n".."0".."\r\n".."0"
				-- NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
         }
		
		
		local red_alert_time_headquarters_update_button_terminal = {
          _name = "red_alert_time_headquarters_update_button",
          _init = function (terminal) 
          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
				ccui.Helper:seekWidgetByName(instance.roots[1],"Button_troops_reward_rec"):setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
         }
		 
        state_machine.add(red_alert_time_headquarters_activity_codes_terminal)
        state_machine.add(red_alert_time_headquarters_update_button_terminal)
        state_machine.init()
    end
    
    -- call func init red_alert_time_headquarters state machine.
    init_red_alert_time_headquarters_terminal()
end

function RedAlertTimeHeadquarters:playActionsLotteryTen()
    local root = self.roots[1]
    local Panel_donghua = ccui.Helper:seekWidgetByName(root, "Panel_donghua")
    local Button_troops_reward_rec = ccui.Helper:seekWidgetByName(root, "Button_troops_reward_rec")
    Panel_donghua:setVisible(true)
    Panel_donghua:removeAllChildren(true)
    local baseName = config_res.effect.effice_lottery_ten
    local skeletonNode = sp.spine(baseName..".json", baseName..".atlas", 1, 0, nil, false, nil)
    skeletonNode:registerSpineEventHandler(function (event)
        event.skeletonAnimation:removeFromParent(true)
        Panel_donghua:setVisible(false)
        Button_troops_reward_rec:setVisible(false)
        local acitvity = _ED.activity_info["48"]
		local function responseCallback(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
					response.node:onUpdateDraw()
					checkRewardObtainDraw()
    				state_machine.excute("home_map_update_build", 0, "")
					state_machine.excute("red_alert_time_headquarters_window_close", 0, 0)
					state_machine.excute("main_window_remove_list_button", 0, 48)
				end
			end
		end		
		protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n".."48".."\r\n".."0".."\r\n".."0"
		NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, self, responseCallback, false, nil)  
    end, sp.EventType.ANIMATION_COMPLETE)
    skeletonNode:setAnimation(0, "animation", true)
    skeletonNode:setPosition(cc.p(Panel_donghua:getContentSize().width/2, Panel_donghua:getContentSize().height/2-120))
    Panel_donghua:addChild(skeletonNode)
end

function RedAlertTimeHeadquarters:onUpdateDraw()
    local root = self.roots[1]
	local ListView_reward_icon = ccui.Helper:seekWidgetByName(root,"ListView_reward_icon")
	ListView_reward_icon:removeAllItems()
	local rewarldData = zstring.split(_ED.activity_info["48"].activity_data[1][1].achieve_reward, "|")
	for i=1 ,#rewarldData do
		local datas = zstring.split(rewarldData[i], ",")
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
		-- print(show_type,datas[1],prop_type,datas[3])
		-- local cell = state_machine.excute("props_icon_create_cell",0,{show_type, prop_from_type, tonumber(datas[1]), tonumber(prop_type), tonumber(datas[3]),nil,tonumber(datas[1])})
		local cell = nil
		if prop_type == 7 then
			local equip_datas = {}
			equip_datas.equipment_name = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.equipment_name)
			equip_datas.pic_index = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.pic_index)
			cell = state_machine.excute("props_icon_create_cell",0,{show_type, 3, equip_datas, tonumber(prop_type), tonumber(datas[3])})
		else
			cell = state_machine.excute("props_icon_create_cell",0,{show_type, prop_from_type, tonumber(datas[1]), tonumber(prop_type), tonumber(datas[3]),nil,tonumber(datas[1])})
		end
		ccui.Helper:seekWidgetByName(cell.roots[1], "Image_1"):setVisible(false)
		ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_attribute_icon"):setVisible(false)
		ListView_reward_icon:addChild(cell)
	end
	ListView_reward_icon:requestRefreshView()
	self.local_time = (tonumber(_ED.activity_info["48"].activity_add_state)/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time)))+1
	local Text_leader_synopsis_title = ccui.Helper:seekWidgetByName(root,"Text_leader_synopsis_title")
	local Text_leader_title_0 = ccui.Helper:seekWidgetByName(root,"Text_leader_title_0")
	local Text_leader_title_1 = ccui.Helper:seekWidgetByName(root,"Text_leader_title_1")
	local Text_leader_title_2 = ccui.Helper:seekWidgetByName(root,"Text_leader_title_2")
	if tonumber(_ED.activity_info["48"].activity_data[1][1].achieve_state) == 1 or self.local_time <= 0 then
		Text_leader_synopsis_title:setVisible(true)
		Text_leader_title_0:setVisible(false)
		Text_leader_title_1:setVisible(false)
		Text_leader_title_2:setVisible(false)
		ccui.Helper:seekWidgetByName(root,"Button_troops_reward_rec"):setVisible(true)
	else
		Text_leader_synopsis_title:setVisible(false)
		Text_leader_title_0:setVisible(true)
		Text_leader_title_1:setVisible(true)
		Text_leader_title_2:setVisible(true)
		ccui.Helper:seekWidgetByName(root,"Button_troops_reward_rec"):setVisible(false)
	end
	if self.local_time > 0 then
		local datas = zstring.split(activity_str_tip[27], "!x@")
		Text_leader_title_0:setString(datas[1])
		Text_leader_title_1:setString(getRedAlertTimeFormat(self.local_time))
		Text_leader_title_1:setPositionX(Text_leader_title_1._x+Text_leader_title_0:getContentSize().width)
		Text_leader_title_2:setString(datas[2])
		Text_leader_title_2:setPositionX(Text_leader_title_2._x+Text_leader_title_1:getContentSize().width+Text_leader_title_0:getContentSize().width)
		if verifySupportLanguage(_lua_release_language_en) == true then
			Text_leader_title_1:setPositionX(Text_leader_title_0:getPositionX() + Text_leader_title_0:getContentSize().width)
			Text_leader_title_2:setPositionX(Text_leader_title_1:getContentSize().width + Text_leader_title_1:getPositionX())
		end
	end
end

function RedAlertTimeHeadquarters:updateTextInfo()
	local root = self.roots[1]
	local Text_leader_title_0 = ccui.Helper:seekWidgetByName(root,"Text_leader_title_0")
	local Text_leader_title_1 = ccui.Helper:seekWidgetByName(root,"Text_leader_title_1")
	local Text_leader_title_2 = ccui.Helper:seekWidgetByName(root,"Text_leader_title_2")
	local datas = zstring.split(activity_str_tip[27], "!x@")
	Text_leader_title_0:setString(datas[1])
	Text_leader_title_1:setString(getRedAlertTimeFormat(self.local_time))
	Text_leader_title_1:setPositionX(Text_leader_title_1._x+Text_leader_title_0:getContentSize().width)
	Text_leader_title_2:setString(datas[2])
	Text_leader_title_2:setPositionX(Text_leader_title_2._x+Text_leader_title_1:getContentSize().width+Text_leader_title_0:getContentSize().width)
	if verifySupportLanguage(_lua_release_language_en) == true then
		Text_leader_title_1:setPositionX(Text_leader_title_0:getPositionX() + Text_leader_title_0:getContentSize().width)
		Text_leader_title_2:setPositionX(Text_leader_title_1:getContentSize().width + Text_leader_title_1:getPositionX())
	end
end

function RedAlertTimeHeadquarters:onEnterTransitionFinish()
	
end

function RedAlertTimeHeadquarters:onInit( )
    local csbItem = csb.createNode(config_csb.activity.help_troops_reward)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)

  	local action = csb.createTimeline(config_csb.activity.help_troops_reward)
    table.insert(self.actions, action)
    action:play("window_open", false)
    csbItem:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "window_open_over" then

        end  
    end)
	
	if ccui.Helper:seekWidgetByName(root,"Text_leader_title_1")._x == nil then
		ccui.Helper:seekWidgetByName(root,"Text_leader_title_1")._x = ccui.Helper:seekWidgetByName(root,"Text_leader_title_1"):getPositionX()
	end
	ccui.Helper:seekWidgetByName(root,"Text_leader_title_1"):setPositionX(ccui.Helper:seekWidgetByName(root,"Text_leader_title_1")._x)
	if ccui.Helper:seekWidgetByName(root,"Text_leader_title_2")._x == nil then
		ccui.Helper:seekWidgetByName(root,"Text_leader_title_2")._x = ccui.Helper:seekWidgetByName(root,"Text_leader_title_2"):getPositionX()
	end
	ccui.Helper:seekWidgetByName(root,"Text_leader_title_2"):setPositionX(ccui.Helper:seekWidgetByName(root,"Text_leader_title_2")._x)
	--领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_troops_reward_rec"), nil, 
    {
        terminal_name = "red_alert_time_headquarters_activity_codes", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
		cells = self
    }, nil, 1)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_window_bg"), nil, 
    {
        terminal_name = "red_alert_time_headquarters_window_close", 
        terminal_state = 0, 
    }, nil, 3)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_window_box_c"), nil, 
    {
        terminal_name = "red_alert_time_headquarters_window_close", 
        terminal_state = 0, 
    }, nil, 3)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_help_troops_close"), nil, 
    {
        terminal_name = "red_alert_time_headquarters_window_close", 
        terminal_state = 0, 
    }, nil, 3)

	local Panel_donghua = ccui.Helper:seekWidgetByName(root, "Panel_donghua")
    Panel_donghua:setVisible(false)
	
	self:onUpdateDraw()
end

function RedAlertTimeHeadquarters:onUpdate(dt)
	local root = self.roots[1]
	if self.local_time > 0 then
		self.local_time = self.local_time - dt
		-- ccui.Helper:seekWidgetByName(root,"Button_troops_reward_rec"):setTitleText(exChangeTimeToString(tonumber(self.local_time)))
		self:updateTextInfo()
		if self.local_time <= 0 then
			_ED.activity_info["48"].activity_data[1][1].achieve_state = "1"
			state_machine.excute("red_alert_time_headquarters_update_button", 0, nil)
		end
	end
end

function RedAlertTimeHeadquarters:init(params)
	self:onInit()
    return self
end

function RedAlertTimeHeadquarters:onExit()
    state_machine.remove("red_alert_time_headquarters_activity_codes")
end
