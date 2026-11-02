--------------------------------------------------------------------------------------------------------------
--  说明：宝藏的子界面的cell
--------------------------------------------------------------------------------------------------------------
RedAlerTimeActDaySignCell = class("RedAlerTimeActDaySignCellClass", Window)
RedAlerTimeActDaySignCell.__size = nil

--创建cell
local red_alert_time_act_day_sign_cell_terminal = {
    _name = "red_alert_time_act_day_sign_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = RedAlerTimeActDaySignCell:new()
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
state_machine.add(red_alert_time_act_day_sign_cell_terminal)
state_machine.init()

function RedAlerTimeActDaySignCell:ctor()
	self.super:ctor()
	self.roots = {}
	self._activity_type = nil
	self.a_type = 0
	self.index = 0
	self.group = nil
	 -- Initialize red_alert_time_act_share_cell state machine.
    local function init_red_alert_time_act_day_sign_cell_terminal()
        local red_alert_time_act_day_sign_cell_receive_award_terminal = {
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
						if response.node ~= nil and response.node.roots ~= nil then
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
        state_machine.add(red_alert_time_act_day_sign_cell_receive_award_terminal)
        state_machine.init()
    end 
    -- call func red_alert_time_act_share_cell create state machine.
    init_red_alert_time_act_day_sign_cell_terminal()

end

function RedAlerTimeActDaySignCell:updateDraw()
    local root = self.roots[1]
	-- debug.print_r(self._activity_type)
	local Text_day_sign_rec_p = ccui.Helper:seekWidgetByName(root,"Text_day_sign_rec_p")
    local Text_day_sign_day_n = ccui.Helper:seekWidgetByName(root,"Text_day_sign_n")
	--名称
	Text_day_sign_day_n:setString(self._activity_type.achieve_mould_name)
	
	--奖励
	local ListView_day_sign_reward = ccui.Helper:seekWidgetByName(root,"ListView_day_sign_reward")
	ListView_day_sign_reward:removeAllItems()
	local rewarldData = zstring.split(self._activity_type.achieve_reward, "|")
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
			prop_type = 15
			prop_from_type = 14
		else
			prop_type = 1
			prop_from_type = 1
		end
		local cell = nil
		if prop_type == 15 then
			local equip_datas = {}
			equip_datas.equipment_name = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.equipment_name)
			equip_datas.pic_index = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.pic_index)
			cell = state_machine.excute("props_icon_create_cell",0,{show_type, prop_from_type, tonumber(datas[1]), tonumber(prop_type), tonumber(datas[3]),false})
		else
			cell = state_machine.excute("props_icon_create_cell",0,{show_type, prop_from_type, tonumber(datas[1]), tonumber(prop_type), tonumber(datas[3]),false})
		end
		ListView_day_sign_reward:addChild(cell)
		ccui.Helper:seekWidgetByName(cell.roots[1], "Image_1"):setVisible(false)
		ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_attribute_icon"):setVisible(false)
	end
	ListView_day_sign_reward:requestRefreshView()
	local Button_day_sign_rec = ccui.Helper:seekWidgetByName(root,"Button_day_sign_rec")
	local completeDatas = zstring.split(self._activity_type.achieve_complete_count, "/")

	if tonumber(self._activity_type.achieve_state) == 0 then	--不能领
		Button_day_sign_rec:setVisible(false)
		Text_day_sign_rec_p:setVisible(true)
		if tonumber(completeDatas[2]) > tonumber(completeDatas[1]) then
			if tonumber(completeDatas[2]) - tonumber(completeDatas[1]) ~= 1 then
				Text_day_sign_rec_p:setVisible(false)
			end
		end
	elseif tonumber(self._activity_type.achieve_state) == 1 then--可以领
		Button_day_sign_rec:setVisible(true)
		Text_day_sign_rec_p:setVisible(false)
	else														--领完了
		Button_day_sign_rec:setVisible(false)
		Text_day_sign_rec_p:setVisible(true)
		Text_day_sign_rec_p:setString(red_alert_time_str[129])
	end
end

function RedAlerTimeActDaySignCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.activity.treasurehouse.day_sign_seven_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if RedAlerTimeActDaySignCell.__size == nil then
        RedAlerTimeActDaySignCell.__size = root:getContentSize()
    end

	--领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_day_sign_rec"), nil, 
    {
        terminal_name = "red_alert_time_act_share_cell_receive_award", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
		cells = self
    }, nil, 1)

	self:updateDraw()

end

function RedAlerTimeActDaySignCell:onEnterTransitionFinish()
    local root = self.roots[1]
    
end


function RedAlerTimeActDaySignCell:onUpdate()
    if self._push_activity == nil then
       return
    end
    local now_time = os.time()
    if now_time - zstring.tonumber(self._last_time) >= 1 then
        -- self:pushNotificationActivity()
        self._last_time = now_time
    end
end

function RedAlerTimeActDaySignCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Button_day_sign_rec = ccui.Helper:seekWidgetByName(root,"Button_day_sign_rec")
    local Text_day_sign_rec_p = ccui.Helper:seekWidgetByName(root,"Text_day_sign_rec_p")
    local Text_day_sign_day_n = ccui.Helper:seekWidgetByName(root,"Text_day_sign_n")
    local ListView_day_sign_reward = ccui.Helper:seekWidgetByName(root,"ListView_day_sign_reward")
	if Button_day_sign_rec ~= nil then
		Button_day_sign_rec:setVisible(true)
		ListView_day_sign_reward:removeAllItems()
		-- Text_day_sign_rec_p:setString("")
		-- Text_day_sign_day_n:setString("")
	end
end

function RedAlerTimeActDaySignCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function RedAlerTimeActDaySignCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.day_sign_seven_cell, root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function RedAlerTimeActDaySignCell:init(activity_type,index,a_type,group)
    self._activity_type = activity_type
	self.index = index
	self.a_type = a_type
	self.group = group
    -- if index ~= nil and index < 8 then
	   self:onInit()
    -- end
	
    self:setContentSize(RedAlerTimeActDaySignCell.__size)
    return self
end

function RedAlerTimeActDaySignCell:onExit()
	self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.day_sign_seven_cell, self.roots[1])
end