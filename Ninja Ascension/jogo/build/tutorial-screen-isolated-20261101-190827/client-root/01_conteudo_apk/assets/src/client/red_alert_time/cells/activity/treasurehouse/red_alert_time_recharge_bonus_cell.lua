--------------------------------------------------------------------------------------------------------------
--  说明：诺曼的馈赠的cell
--------------------------------------------------------------------------------------------------------------
RedAlerTimeRechargeBonusCell = class("RedAlerTimeRechargeBonusCellClass", Window)
RedAlerTimeRechargeBonusCell.__size = nil

--创建cell
local red_alert_time_recharge_bonus_cell_terminal = {
    _name = "red_alert_time_recharge_bonus_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = RedAlerTimeRechargeBonusCell:new()
		local activity_type = params[1]
		local index = tonumber(params[2])
		local a_type = tonumber(params[3]) or 0
		local group = tonumber(params[4]) or 0
        cell:init(activity_type,index,a_type,group)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(red_alert_time_recharge_bonus_cell_terminal)
state_machine.init()

function RedAlerTimeRechargeBonusCell:ctor()
	self.super:ctor()
	self.roots = {}
	self._activity_type = nil
	self.a_type = 0
	self.index = 0
	self.group = nil
	 -- Initialize red_alert_time_act_share_cell state machine.
    local function init_red_alert_time_recharge_bonus_cell_terminal()
        local red_alert_time_recharge_bonus_cell_receive_award_terminal = {
            _name = "red_alert_time_act_share_cell_receive_award",
            _init = function (terminal)       
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- print("活动领取接口")
				local cell = params._datas.cells
				local acitvity = _ED.activity_info[""..cell.a_type]
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
							response.node:updateDraw()
						end
						checkRewardObtainDraw()
					end
				end		
				protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..cell.a_type.."\r\n"..(cell.group-1).."\r\n"..tonumber(cell._activity_type.achieve_index)-1
				NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, cell, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(red_alert_time_recharge_bonus_cell_receive_award_terminal)
        state_machine.init()
    end 
    -- call func red_alert_time_act_share_cell create state machine.
    init_red_alert_time_recharge_bonus_cell_terminal()

end

function RedAlerTimeRechargeBonusCell:updateDraw()
    local root = self.roots[1]
	local Text_recharge_bonus_n_1 = ccui.Helper:seekWidgetByName(root,"Text_recharge_bonus_n_1")
	local count = zstring.split(self._activity_type.achieve_complete_count, "/")
	Text_recharge_bonus_n_1:setString(count[2])
	
	local ListView_recharge_bonus_reward_1 = ccui.Helper:seekWidgetByName(root,"ListView_recharge_bonus_reward_1")
	ListView_recharge_bonus_reward_1:removeAllItems()
	local rewarldData = zstring.split(self._activity_type.achieve_reward, "|")
	local obejct = zstring.split(_ED.activity_info["82"].activity_add_state, "|")
	local m_object = zstring.split(obejct[2], ",")
	for i=1 ,#rewarldData do
		local datas = zstring.split(rewarldData[i], ",")
		if tonumber(datas[1]) == -1 then
			datas[1] = resource_prop_id[tonumber(datas[2])]
			datas[2] = 1
		end
		local prop_type = tonumber(datas[2])
		local show_type = 6
		if tonumber(datas[2]) == 13 then --坦克
			prop_type = 3
		elseif tonumber(datas[2]) == 6 then --道具	
			prop_type = 1
		elseif tonumber(datas[2]) == 7 then --配件	
			prop_type = 7
		else
			prop_type = 1
		end
		-- local cell = state_machine.excute("props_icon_create_cell",0,{show_type, 3, tonumber(datas[1]), tonumber(prop_type), tonumber(datas[3])})
		local cell = nil
		if prop_type == 7 then
			local equip_datas = {}
			equip_datas.equipment_name = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.equipment_name)
			equip_datas.pic_index = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.pic_index)
			cell = state_machine.excute("props_icon_create_cell",0,{show_type, 3, equip_datas, tonumber(prop_type), tonumber(datas[3])})
		else
			if tonumber(datas[1]) == 671 or tonumber(datas[1]) == 672 or tonumber(datas[1]) == 673 then
				cell = state_machine.excute("props_icon_create_cell",0,{show_type, 12, tonumber(datas[1]), tonumber(prop_type), self.index})
				ccui.Helper:seekWidgetByName(cell.roots[1], "Image_num_bg"):setVisible(false)
				ccui.Helper:seekWidgetByName(cell.roots[1], "Text_props_n"):setVisible(false)
			else
				cell = state_machine.excute("props_icon_create_cell",0,{show_type, 1, tonumber(datas[1]), tonumber(prop_type), tonumber(datas[3])})
				if tonumber(datas[3]) > 0 then
					ccui.Helper:seekWidgetByName(cell.roots[1], "Image_num_bg"):setVisible(true)
					ccui.Helper:seekWidgetByName(cell.roots[1], "Text_props_n"):setVisible(true)
				end
			end
		end
        if i==1 then
            if tonumber(m_object[tonumber(self._activity_type.achieve_index)]) ~= -1 then
                local prop_id = tonumber(m_object[tonumber(self._activity_type.achieve_index)])
                local prop_cell = state_machine.excute("props_icon_create_cell",0,{9, 3, tonumber(prop_id), 1})
                ccui.Helper:seekWidgetByName(prop_cell.roots[1], "Image_num_bg"):setVisible(false)
                ccui.Helper:seekWidgetByName(prop_cell.roots[1], "Text_props_n"):setVisible(false)
                cell:addChild(prop_cell)
            end
        end
		ccui.Helper:seekWidgetByName(cell.roots[1], "Image_1"):setVisible(false)
		ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_attribute_icon"):setVisible(false)
		ListView_recharge_bonus_reward_1:addChild(cell)
	end
	ListView_recharge_bonus_reward_1:requestRefreshView()
	local Button_recharge_bonus_rec_1 = ccui.Helper:seekWidgetByName(root,"Button_recharge_bonus_rec_1")
	local Text_recharge_bonus_not_1 = ccui.Helper:seekWidgetByName(root,"Text_recharge_bonus_not_1")
	local LoadingBar_integral_bar = ccui.Helper:seekWidgetByName(root,"LoadingBar_integral_bar")
    local percent_number = tonumber(count[1])
    local max_number = tonumber(count[2])
    local min_number = tonumber(count[2])
    if _ED.activity_info["82"].activity_data[1][tonumber(self.index)+1] ~= nil then
        local indexLoad = zstring.split(_ED.activity_info["82"].activity_data[1][tonumber(self.index)+1].achieve_complete_count, "/")
        min_number = tonumber(indexLoad[2])
    end

	if percent_number >= max_number then
		LoadingBar_integral_bar:setPercent(100)	
		if tonumber(self._activity_type.achieve_state) == 2 then
			Button_recharge_bonus_rec_1:setVisible(false)
			Text_recharge_bonus_not_1:setVisible(true)
			Text_recharge_bonus_not_1:setString(activity_str_tip[2])
		else
			Button_recharge_bonus_rec_1:setVisible(true)
			Text_recharge_bonus_not_1:setVisible(false)
		end
	else
		if percent_number > min_number then
            local percent = (percent_number - min_number) / (max_number - min_number) * 100
            LoadingBar_integral_bar:setPercent(percent)
		else
			LoadingBar_integral_bar:setPercent(0)	
		end
		Button_recharge_bonus_rec_1:setVisible(false)
		Text_recharge_bonus_not_1:setVisible(true)
	end
end

function RedAlerTimeRechargeBonusCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.activity.treasurehouse.recharge_bonus_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if RedAlerTimeRechargeBonusCell.__size == nil then
        RedAlerTimeRechargeBonusCell.__size = root:getContentSize()
    end

	--领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_recharge_bonus_rec_1"), nil, 
    {
        terminal_name = "red_alert_time_act_share_cell_receive_award", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
		cells = self
    }, nil, 1)

	self:updateDraw()

end

function RedAlerTimeRechargeBonusCell:onEnterTransitionFinish()
    local root = self.roots[1]
    
end


function RedAlerTimeRechargeBonusCell:onUpdate()
    if self._push_activity == nil then
       return
    end
    local now_time = os.time()
    if now_time - zstring.tonumber(self._last_time) >= 1 then
        -- self:pushNotificationActivity()
        self._last_time = now_time
    end
end

function RedAlerTimeRechargeBonusCell:clearUIInfo( ... )
    local root = self.roots[1]
	local Text_recharge_bonus_n_1 = ccui.Helper:seekWidgetByName(root,"Text_recharge_bonus_n_1")
    local ListView_recharge_bonus_reward_1 = ccui.Helper:seekWidgetByName(root,"ListView_recharge_bonus_reward_1")
	local Button_recharge_bonus_rec_1 = ccui.Helper:seekWidgetByName(root,"Button_recharge_bonus_rec_1")
	local Text_recharge_bonus_not_1 = ccui.Helper:seekWidgetByName(root,"Text_recharge_bonus_not_1")
	local LoadingBar_integral_bar = ccui.Helper:seekWidgetByName(root,"LoadingBar_integral_bar")
	if Text_recharge_bonus_n_1~= nil then
		Text_recharge_bonus_n_1:setString("")
		ListView_recharge_bonus_reward_1:removeAllItems()
		Button_recharge_bonus_rec_1:setVisible(true)
		Text_recharge_bonus_not_1:setVisible(true)
		Text_recharge_bonus_not_1:setString("")
		LoadingBar_integral_bar:setPercent(0)	
	end
end

function RedAlerTimeRechargeBonusCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function RedAlerTimeRechargeBonusCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.recharge_bonus_cell, root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function RedAlerTimeRechargeBonusCell:init(activity_type,index,a_type,group)
    self._activity_type = activity_type
	self.index = index
	self.a_type = a_type
	self.group = group
    -- if index ~= nil and index < 8 then
	   self:onInit()
    -- end
	
    self:setContentSize(RedAlerTimeRechargeBonusCell.__size)
    return self
end

function RedAlerTimeRechargeBonusCell:onExit()
	self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.recharge_bonus_cell, self.roots[1])
end