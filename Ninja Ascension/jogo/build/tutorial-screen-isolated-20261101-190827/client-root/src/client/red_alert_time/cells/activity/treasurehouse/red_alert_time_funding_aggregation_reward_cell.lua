--------------------------------------------------------------------------------------------------------------
--  说明：军资集结控件cell
--------------------------------------------------------------------------------------------------------------
RedAlerTimeFundingAggregationRewardCell = class("RedAlerTimeFundingAggregationRewardCellClass", Window)
RedAlerTimeFundingAggregationRewardCell.__size = nil

--创建cell
local red_alert_time_funding_aggregation_reward_cell_terminal = {
    _name = "red_alert_time_funding_aggregation_reward_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = RedAlerTimeFundingAggregationRewardCell:new()
		local activity_type = params[1]
		local index = tonumber(params[2])
		local a_type = tonumber(params[3]) or 0
		local group = tonumber(params[4]) or 0
        cell:init(activity_type,index,a_type,group)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell, 0.5)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(red_alert_time_funding_aggregation_reward_cell_terminal)
state_machine.init()

function RedAlerTimeFundingAggregationRewardCell:ctor()
	self.super:ctor()
	self.roots = {}
	self._activity_type = nil
	self.a_type = 0
	self.group = 0
	self.m_time = -1
	 -- Initialize red_alert_time_funding_aggregation_reward_cell state machine.
    local function init_red_alert_time_funding_aggregation_reward_cell_terminal()
        local red_alert_time_funding_aggregation_reward_cell_receive_award_terminal = {
            _name = "red_alert_time_funding_aggregation_reward_cell_receive_award",
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
						state_machine.excute("notification_center_update", 0, "push_notification_funding_personal")
					end
				end		
				protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..cell.a_type.."\r\n"..(tonumber(cell.group)-1).."\r\n"..(tonumber(cell._activity_type.achieve_index)-1).."\r\n0"
				NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, cell, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(red_alert_time_funding_aggregation_reward_cell_receive_award_terminal)
        state_machine.init()
    end 
    -- call func red_alert_time_funding_aggregation_reward_cell create state machine.
    init_red_alert_time_funding_aggregation_reward_cell_terminal()

end

function RedAlerTimeFundingAggregationRewardCell:updateDraw()
    local root = self.roots[1]
	--名称
	local Text_funding_aggregation_reward_reward_tit = ccui.Helper:seekWidgetByName(root,"Text_funding_aggregation_reward_reward_tit")
	Text_funding_aggregation_reward_reward_tit:setString(self._activity_type.achieve_mould_name)
	
	local Text_funding_aggregation_reward_rec_p = ccui.Helper:seekWidgetByName(root,"Text_funding_aggregation_reward_rec_p")
	--奖励
	local ListView_funding_aggregation_reward = ccui.Helper:seekWidgetByName(root,"ListView_funding_aggregation_reward")
	ListView_funding_aggregation_reward:removeAllItems()
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
			prop_type = 7
			prop_from_type = 4
		else
			prop_type = 1
			prop_from_type = 1
		end
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
		cell.roots[1]:setPositionX(10)
		ListView_funding_aggregation_reward:addChild(cell)
	end
	if #ListView_funding_aggregation_reward:getItems() <= 3 then
		ListView_funding_aggregation_reward:setTouchEnabled(false)
	else
		ListView_funding_aggregation_reward:setTouchEnabled(true)
	end
	ListView_funding_aggregation_reward:requestRefreshView()

	if tonumber(self._activity_type.achieve_state) <= 1 then
		local datas = zstring.split(self._activity_type.achieve_complete_count, "/")
		if tonumber(datas[1]) < tonumber(datas[2]) then
			ccui.Helper:seekWidgetByName(root,"Button_funding_aggregation_reward_rec"):setVisible(false)
			Text_funding_aggregation_reward_rec_p:setVisible(true)
			Text_funding_aggregation_reward_rec_p:setColor(chat_rich_text_color[6])
			Text_funding_aggregation_reward_rec_p:setString(activity_str_tip[8])
		else
			ccui.Helper:seekWidgetByName(root,"Button_funding_aggregation_reward_rec"):setVisible(true)
			Text_funding_aggregation_reward_rec_p:setVisible(false)
		end
	else
		ccui.Helper:seekWidgetByName(root,"Button_funding_aggregation_reward_rec"):setVisible(false)
		Text_funding_aggregation_reward_rec_p:setVisible(true)
		Text_funding_aggregation_reward_rec_p:setColor(chat_rich_text_color[1])
		Text_funding_aggregation_reward_rec_p:setString(activity_str_tip[2])
	end
	
end

function RedAlerTimeFundingAggregationRewardCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.activity.treasurehouse.funding_aggregation_reward_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if RedAlerTimeFundingAggregationRewardCell.__size == nil then
        RedAlerTimeFundingAggregationRewardCell.__size = root:getContentSize()
    end
	if ccui.Helper:seekWidgetByName(root,"ListView_funding_aggregation_reward")._y == nil then
		ccui.Helper:seekWidgetByName(root,"ListView_funding_aggregation_reward")._y = ccui.Helper:seekWidgetByName(root,"ListView_funding_aggregation_reward"):getPositionY()
	end
	ccui.Helper:seekWidgetByName(root,"ListView_funding_aggregation_reward"):setPositionY(ccui.Helper:seekWidgetByName(root,"ListView_funding_aggregation_reward")._y)
	--领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_funding_aggregation_reward_rec"), nil, 
    {
        terminal_name = "red_alert_time_funding_aggregation_reward_cell_receive_award", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
		cells = self
    }, nil, 1)

	self:updateDraw()
end

function RedAlerTimeFundingAggregationRewardCell:onEnterTransitionFinish()
    local root = self.roots[1]
    
end

function RedAlerTimeFundingAggregationRewardCell:clearUIInfo( ... )
    local root = self.roots[1]
	local Text_funding_aggregation_reward_reward_tit = ccui.Helper:seekWidgetByName(root,"Text_funding_aggregation_reward_reward_tit")
	local Text_funding_aggregation_reward_rec_p = ccui.Helper:seekWidgetByName(root,"Text_funding_aggregation_reward_rec_p")
	local ListView_funding_aggregation_reward = ccui.Helper:seekWidgetByName(root,"ListView_funding_aggregation_reward")
	if Text_funding_aggregation_reward_reward_tit ~= nil then
		Text_funding_aggregation_reward_reward_tit:setString("")
		Text_funding_aggregation_reward_rec_p:setString("")
		ListView_funding_aggregation_reward:removeAllItems()
	end
	self.m_time = -1
end

function RedAlerTimeFundingAggregationRewardCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self, 0.5)
    self:onInit()
end

function RedAlerTimeFundingAggregationRewardCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.funding_aggregation_reward_cell, root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function RedAlerTimeFundingAggregationRewardCell:init(activity_type,index,a_type,group)
    self._activity_type = activity_type
	self.index = index
	self.a_type = a_type
	self.group = group
    -- if index ~= nil and index < 8 then
	   self:onInit()
    -- end

    self:setContentSize(RedAlerTimeFundingAggregationRewardCell.__size)
    return self
end

function RedAlerTimeFundingAggregationRewardCell:onExit()
	self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.funding_aggregation_reward_cell, self.roots[1])
end