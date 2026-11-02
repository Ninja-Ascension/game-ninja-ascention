-----------------------------
--连续充值奖励界面
-----------------------------
RedAlertTime7DaysReward = class("RedAlertTime7DaysRewardClass", Window)

local red_alert_time_7_days_reward_window_open_terminal = {
    _name = "red_alert_time_7_days_reward_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTime7DaysRewardClass") then
            local panel = RedAlertTime7DaysReward:new():init(params)
            fwin:open(panel,fwin._ui)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_7_days_reward_window_close_terminal = {
    _name = "red_alert_time_7_days_reward_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RedAlertTime7DaysRewardClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_7_days_reward_window_open_terminal)
state_machine.add(red_alert_time_7_days_reward_window_close_terminal)
state_machine.init()

function RedAlertTime7DaysReward:ctor()
    self.super:ctor()
    self.roots = {}
	self.activity_type = nil
	self.index = 0
    --load lua file
    -- Initialize red_alert_time_7_days_reward state machine.
    local function init_red_alert_time_7_days_reward_terminal()
	
        --
        local red_alert_time_7_days_reward_activity_codes_terminal = {
          _name = "red_alert_time_7_days_reward_activity_codes",
          _init = function (terminal) 
          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
				local cell = params._datas.cell
				local acitvity = _ED.activity_info[""..self.activity_type]
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							cell:onUpdateDraw()
							checkRewardObtainDraw()
						end
					end
				end		
				protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..""..self.activity_type.."\r\n".."1".."\r\n"..(tonumber(_ED.activity_info[""..cell.activity_type].activity_data[2][tonumber(self.index)].achieve_index)-1).."\r\n0" 
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
         }
		
        state_machine.add(red_alert_time_7_days_reward_activity_codes_terminal)
        state_machine.init()
    end
    
    -- call func init red_alert_time_7_days_reward state machine.
    init_red_alert_time_7_days_reward_terminal()
end

function RedAlertTime7DaysReward:onUpdateDraw()
    local root = self.roots[1]
	ccui.Helper:seekWidgetByName(root,"Text_star_reaward_title"):setString(activity_str_tip[37])
	local Panel_reaward_icon = ccui.Helper:seekWidgetByName(root,"Panel_reaward_icon")
	Panel_reaward_icon:removeAllChildren(true)
    local ListView_rew_icon = ccui.Helper:seekWidgetByName(root,"ListView_rew_icon")
    ListView_rew_icon:removeAllItems()
    local cell_width = 0
	local reward = zstring.split(_ED.activity_info[""..self.activity_type].activity_data[2][tonumber(self.index)].achieve_reward, "|")
    for i = 1 , #reward do 
    	local datas = zstring.split(reward[i], ",")
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
        if cell_width == 0 then
            cell_width = cell:getContentSize().width
        end
    	ccui.Helper:seekWidgetByName(cell.roots[1], "Image_1"):setVisible(false)
    	ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_attribute_icon"):setVisible(false)
    	ListView_rew_icon:addChild(cell)
    end
    local margin = ListView_rew_icon:getItemsMargin()
    local number = #reward
    local tocal_length = (cell_width * number + margin * (number - 1)) * ListView_rew_icon:getScaleX()
    local listViewWidth = ListView_rew_icon:getContentSize().width * ListView_rew_icon:getScaleX()
    ListView_rew_icon:requestRefreshView()
    if tocal_length < listViewWidth then
        ListView_rew_icon:setPositionX(RedAlertTime7DaysReward.listViewPX + listViewWidth / 2 - tocal_length / 2)
	end
    local Text_reward_star_prompt = ccui.Helper:seekWidgetByName(root,"Text_reward_star_prompt")
    if tonumber(_ED.activity_info[""..self.activity_type].activity_data[2][tonumber(self.index)].achieve_state) == 1 then
        ccui.Helper:seekWidgetByName(root, "Button_reaward_receive"):setVisible(true)
    else
        ccui.Helper:seekWidgetByName(root, "Button_reaward_receive"):setVisible(false)
    end
    if tonumber(_ED.activity_info[""..self.activity_type].activity_data[2][tonumber(self.index)].achieve_state) == 2 then
        Text_reward_star_prompt:setString(activity_str_tip[2])
    else
        Text_reward_star_prompt:setString(string.format(activity_str_tip[91], self.index))
    end
end

function RedAlertTime7DaysReward:onUpdate(dt)
	
end

function RedAlertTime7DaysReward:onEnterTransitionFinish()

end

function RedAlertTime7DaysReward:onInit( )
    local csbItem = csb.createNode(config_csb.pve.pve_star_reward)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)
	
	--关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_star_reward_close"), nil, 
    {
        terminal_name = "red_alert_time_7_days_reward_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_window_bg"), nil, 
    {
        terminal_name = "red_alert_time_7_days_reward_window_close", 
        terminal_state = 0, 
    }, nil, 3)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_reaward_receive"), nil, 
    {
        terminal_name = "red_alert_time_7_days_reward_activity_codes", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
		cell = self
    }, nil, 1)
    local ListView_rew_icon = ccui.Helper:seekWidgetByName(root,"ListView_rew_icon")
    if RedAlertTime7DaysReward.listViewPX == nil then
        RedAlertTime7DaysReward.listViewPX = ListView_rew_icon:getPositionX()
    end
	
	self:onUpdateDraw()
end

function RedAlertTime7DaysReward:init(params)
	self.activity_type = params._datas.cells.activity_type
	self.index = params._datas.index
	self:onInit()
    return self
end

function RedAlertTime7DaysReward:onExit()
    state_machine.remove("red_alert_time_7_days_reward_activity_codes")
end
