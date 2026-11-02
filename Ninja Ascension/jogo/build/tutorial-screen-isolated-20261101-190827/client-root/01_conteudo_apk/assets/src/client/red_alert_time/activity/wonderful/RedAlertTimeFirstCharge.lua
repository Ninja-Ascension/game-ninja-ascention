-----------------------------
--首冲(活动类型2)
-----------------------------
RedAlertTimeFirstCharge = class("RedAlertTimeFirstChargeClass", Window)

local red_alert_time_first_charge_open_terminal = {
    _name = "red_alert_time_first_charge_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeFirstChargeClass") then
            local panel = RedAlertTimeFirstCharge:new():init(params)
            fwin:open(panel)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_first_charge_open_terminal)
state_machine.init()

function RedAlertTimeFirstCharge:ctor()
    self.super:ctor()
    self.roots = {}
	self.activity_type = nil

    self.firsr_recharge_state = nil

    -- Initialize first_charge state machine.
    local function init_first_charge_terminal()
        --领取
        local first_charge_get_reward_terminal = {
        _name = "first_charge_get_reward",
        _init = function (terminal) 
            
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params) 
			if tonumber(_ED.activity_info[""..self.activity_type].activity_data[1][1].achieve_state) == 0 then
				state_machine.excute("recharge_dialog_window_open",0,0)
			else
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        checkRewardObtainDraw()
                        state_machine.excute("main_window_update_top_button", 0, nil)
                        state_machine.excute("home_map_update_build", 0, nil)
						state_machine.excute("first_charge_update_draw",0,"")
						state_machine.excute("red_alert_time_wonderful_update_first",0,self.activity_type)
					end
				end
				protocol_command.draw_activity_reward.param_list = _ED.activity_info[""..self.activity_type].activity_id .. "\r\n"..self.activity_type.."\r\n0\r\n0"
				NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
			end
            return true
        end,
        _terminal = nil,
        _terminals = nil
       }
    --刷新
        local first_charge_update_draw_terminal = {
        _name = "first_charge_update_draw",
        _init = function (terminal) 
            
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params) 
            instance:onUpdateDraw()
            instance:onUpdateDrawButton()
            return true
        end,
        _terminal = nil,
        _terminals = nil
      }
      state_machine.init()
      state_machine.add(first_charge_get_reward_terminal)
      state_machine.add(first_charge_update_draw_terminal)
    end
    
    -- call func init first_charge state machine.
    init_first_charge_terminal()
end

function RedAlertTimeFirstCharge:onUpdate()
    if _ED.activity_info["2"] == nil then
        return
    end
    if self.firsr_recharge_state ~= tonumber(_ED.activity_info[""..self.activity_type].activity_data[1][1].achieve_state) then
        self:onUpdateDrawButton()
        self.firsr_recharge_state = tonumber(_ED.activity_info[""..self.activity_type].activity_data[1][1].achieve_state)
    end
end

function RedAlertTimeFirstCharge:onUpdateDraw()
    local root = self.roots[1]
    local reward_items = _ED.activity_info[""..self.activity_type].activity_data[1]
    for j = 1 , 5 do
        local reward_info = zstring.split(reward_items[j].achieve_reward,"|")
        local ListView_reward_icon = ccui.Helper:seekWidgetByName(root, "ListView_reward_icon_"..j)
        ListView_reward_icon:removeAllItems()
        for i,reward in ipairs(reward_info) do
            local datas = zstring.split(reward, ",")
    		if tonumber(datas[1]) == -1 then
    			datas[1] = resource_prop_id[tonumber(datas[2])]
    			datas[2] = 1
    		end
    		local prop_type = tonumber(datas[2])
    		local show_type = 9
    		local prop_from_type = 3
    		if tonumber(datas[2]) == 13 then --坦克
    			prop_type = 3
    			prop_from_type = 10
                if dms.int(dms["ship_mould"], tonumber(datas[1]), ship_mould.camp_preference) == 0 then
                    prop_from_type = 9
                end
    		elseif tonumber(datas[2]) == 6 then --道具	
    			prop_type = 1
    			prop_from_type = 1
    		elseif tonumber(datas[2]) == 7 then --配件	
    			prop_type = 7
    			prop_from_type = 3
    		else
    			prop_type = 1
    			prop_from_type = 1
    		end
    		-- local cell = state_machine.excute("props_icon_create_cell",0,{show_type, prop_from_type, tonumber(datas[1]), tonumber(prop_type), tonumber(datas[3]),nil,tonumber(datas[1])})
    		local cell = nil
    		if prop_type == 7 then
    			local equip_datas = {}
    			equip_datas.equipment_name = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.equipment_name)
    			equip_datas.pic_index = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.pic_index)
    			cell = state_machine.excute("props_icon_create_cell",0,{show_type, 3, equip_datas, tonumber(prop_type), tonumber(datas[3])})
    		else
                if prop_from_type == 9 then
                    cell = state_machine.excute("props_icon_create_cell",0,{show_type, prop_from_type, tonumber(datas[1]), tonumber(prop_type), tonumber(datas[3])})
                else
                    cell = state_machine.excute("props_icon_create_cell",0,{show_type, prop_from_type, tonumber(datas[1]), tonumber(prop_type), tonumber(datas[3]),nil,tonumber(datas[1])})
                end
    		    if tonumber(datas[1]) == 2 then
                    ccui.Helper:seekWidgetByName(cell.roots[1], "Text_props_name"):setString(activity_str_tip[47])
                end    
            end
    		-- ccui.Helper:seekWidgetByName(cell.roots[1], "Image_1"):setVisible(false)
    		-- ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_attribute_icon"):setVisible(false)
    		cell.roots[1]:setPositionX(10)
            if tonumber(datas[3]) <= 0 then
                ccui.Helper:seekWidgetByName(cell.roots[1], "Image_num_bg"):setVisible(false)
                ccui.Helper:seekWidgetByName(cell.roots[1], "Text_props_n"):setVisible(false)
            else
                ccui.Helper:seekWidgetByName(cell.roots[1], "Image_num_bg"):setVisible(true)
                ccui.Helper:seekWidgetByName(cell.roots[1], "Text_props_n"):setVisible(true)
            end
            ListView_reward_icon:addChild(cell)
        end
        ListView_reward_icon:requestRefreshView()
    end
end

function RedAlertTimeFirstCharge:onUpdateDrawButton()
    local root = self.roots[1]
    local Button_first_charge_go = ccui.Helper:seekWidgetByName(root,"Button_first_charge_go")
    if tonumber(_ED.activity_info[""..self.activity_type].activity_data[1][1].achieve_state) == 1 then
        -- Button_receive:setVisible(true)
        local button_name = config_res.images.ui.share.yellow_button
        Button_first_charge_go:loadTextures(button_name,button_name,button_name,1)
		Button_first_charge_go:setTitleText(activity_str_tip[5]) 
    else
        -- Button_first_charge:setVisible(true)
        local button_name = config_res.images.ui.share.blue_button
        Button_first_charge_go:loadTextures(button_name,button_name,button_name,1)
		Button_first_charge_go:setTitleText(activity_str_tip[4]) 
    end
    self.firsr_recharge_state = tonumber(_ED.activity_info[""..self.activity_type].activity_data[1][1].achieve_state)
end

function RedAlertTimeFirstCharge:onEnterTransitionFinish()

end

function RedAlertTimeFirstCharge:onInit( )
    self:removeAllChildren(true)
    self.roots = {}
    local csbItem = nil
    csbItem = csb.createNode(config_csb.activity.act_first_charge_tab)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)

    --去充值和领奖
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_first_charge_go"), nil, 
    {
        terminal_name = "first_charge_get_reward", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

  	self:onUpdateDraw()
    self:onUpdateDrawButton()
end

function RedAlertTimeFirstCharge:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
	self.activity_type = params[2]
	self:onInit()
    return self
end

function RedAlertTimeFirstCharge:onExit()
    state_machine.remove("first_charge_get_reward")
    state_machine.remove("first_charge_update_draw")
    
end
