-----------------------------
--诺曼的馈赠的2级界面
-----------------------------
RedAlertTimeUnknownChest = class("RedAlertTimeUnknownChestClass", Window)

local red_alert_time_unknown_chest_window_open_terminal = {
    _name = "red_alert_time_unknown_chest_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeUnknownChestClass") then
			fwin:open(RedAlertTimeUnknownChest:new():init(params), fwin._ui)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_unknown_chest_window_close_terminal = {
    _name = "red_alert_time_unknown_chest_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RedAlertTimeUnknownChestClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_unknown_chest_window_open_terminal)
state_machine.add(red_alert_time_unknown_chest_window_close_terminal)
state_machine.init()

function RedAlertTimeUnknownChest:ctor()
    self.super:ctor()
    self.roots = {}
    self._mould_id = nil
	self.click_on_time = 0
	self.click_on_number = 0
	self._indexArray = {}
	self._index = 0
    --load lua file
	app.load("client.red_alert_time.leader.LeaderExchangeInfo")
	app.load("client.red_alert_time.cells.activity.wonderful.red_alert_time_discount_label")
    -- Initialize red_alert_time_unknown_chest state machine.
    local function init_red_alert_time_unknown_chest_terminal()
		local red_alert_time_unknown_chest_click_on_terminal = {
          _name = "red_alert_time_unknown_chest_click_on",
          _init = function (terminal) 
          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
				local reward_id = dms.int(dms["prop_mould"], self._mould_id, prop_mould.addition_group_index)
				local reward_info = dms.string(dms["scene_reward"], reward_id, scene_reward.call_library_group)
				local reward_list = zstring.split(reward_info, "|")             -- 可选择道具
				local vip_demand_datas = zstring.split(reward_list[tonumber(params._datas._index)], ",") 
				local vip_demand = zstring.split(vip_demand_datas[2], "-") 
				if tonumber(_ED.vip_grade) >= tonumber(vip_demand[1]) then
					self.click_on_number = self.click_on_number + 1
					self._index = tonumber(params._datas._index)
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
         }
		 
		 local red_alert_time_unknown_chest_jump_terminal = {
          _name = "red_alert_time_unknown_chest_jump",
          _init = function (terminal) 
          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
				if instance.click_on_number == 1 then
					for i=1, 8 do
						ccui.Helper:seekWidgetByName(instance.roots[1], string.format("Image_unknown_chest_hook_%s", i)):setVisible(false)
					end
					ccui.Helper:seekWidgetByName(instance.roots[1], string.format("Image_unknown_chest_hook_%s", self._index)):setVisible(true)
				else
					local use_of_ship = dms.string(dms["prop_mould"], self._indexArray[self._index], prop_mould.use_of_ship)
                    state_machine.excute("leader_exchange_info_window_open", 0, {use_of_ship})
					self._index = 0
				end
				self.click_on_number = 0
				self.click_on_time = 0
				return true
            end,
            _terminal = nil,
            _terminals = nil
         }
		 
		local red_alert_time_unknown_chest_select_terminal = {
          _name = "red_alert_time_unknown_chest_select",
          _init = function (terminal) 
          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
				if self._index > 0 then
					local acitvity = _ED.activity_info["82"]
					local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node ~= nil and response.node.roots ~= nil then
								-- instance:onUpdateDraw()
								-- checkRewardObtainDraw()
								state_machine.excute("red_alert_time_recharge_bonus_update_draw", 0, nil)
								state_machine.excute("red_alert_time_unknown_chest_window_close", 0, nil)
							end
						end
					end		
					protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n".."82".."\r\n".."0".."\r\n"..(acitvity.activity_data[1][self.number_id].achieve_index-1).."\r\n".."0".."\r\n"..self._indexArray[self._index]
					NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
         }
		 
		state_machine.add(red_alert_time_unknown_chest_click_on_terminal)
		state_machine.add(red_alert_time_unknown_chest_jump_terminal)
		state_machine.add(red_alert_time_unknown_chest_select_terminal)
        state_machine.init()
    end
    
    -- call func init red_alert_time_unknown_chest state machine.
    init_red_alert_time_unknown_chest_terminal()
end


function RedAlertTimeUnknownChest:onUpdateDraw()
    local root = self.roots[1]
	local reward_id = dms.int(dms["prop_mould"], self._mould_id, prop_mould.addition_group_index)
	local reward_info = dms.string(dms["scene_reward"], reward_id, scene_reward.call_library_group)
	local reward_list = zstring.split(reward_info, "|")             -- 可选择道具
	for i=1,#reward_list do
		local Panel_unknown_chest_icon = ccui.Helper:seekWidgetByName(root, string.format("Panel_unknown_chest_icon_%s", i))
		Panel_unknown_chest_icon:removeAllChildren(true)
		local m_datas = zstring.split(reward_list[i], ",")
		local _drawMonth = dms.searchs(dms["scene_reward_drop"], scene_reward_drop.library_group, tonumber(m_datas[1]))
		local datas = zstring.split(_drawMonth[1][5],",")
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
		local numbers = zstring.split(datas[3],"-")
		local cell = nil
		if prop_type == 7 then
			local equip_datas = {}
			equip_datas.equipment_name = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.equipment_name)
			equip_datas.pic_index = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.pic_index)
			cell = state_machine.excute("props_icon_create_cell",0,{show_type, 3, equip_datas, tonumber(prop_type), tonumber(numbers[1]),true})
		else
			cell = state_machine.excute("props_icon_create_cell",0,{show_type, 3, tonumber(datas[1]), tonumber(prop_type), tonumber(numbers[1]),true,tonumber(datas[1])})
		end
		Panel_unknown_chest_icon:addChild(cell)
		self._indexArray[i] = tonumber(datas[1])
		local vip_demand = zstring.split(m_datas[2], "-") 
		if tonumber(vip_demand[1]) >= 1 then
			local discountCell = state_machine.excute("red_alert_time_discount_label_cell",0,{tonumber(vip_demand[1]),1})
			Panel_unknown_chest_icon:addChild(discountCell,100)
		end
	end
end

function RedAlertTimeUnknownChest:onEnterTransitionFinish()

end

function RedAlertTimeUnknownChest:onInit()
    local csbItem = csb.createNode(config_csb.treasurehouse.unknown_chest_choose_window)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)
	
	for i=1, 8 do
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, string.format("Panel_unknown_chest_icon_%s", i)), nil, 
		{
			terminal_name = "red_alert_time_unknown_chest_click_on", 
			terminal_state = 0,
			touch_black = true,
			_index = i,
		}, nil, 3)
	end
	
	--关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_unknown_chest_close"), nil, 
    {
        terminal_name = "red_alert_time_unknown_chest_window_close", 
        terminal_state = 0,
        touch_black = true,
    }, nil, 3)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_window_bg"), nil, 
    {
        terminal_name = "red_alert_time_unknown_chest_window_close", 
        terminal_state = 0,
    }, nil, 3)
	
	--领取
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_unknown_chest_sure"), nil, 
    {
        terminal_name = "red_alert_time_unknown_chest_select", 
        terminal_state = 0,
        touch_black = true,
    }, nil, 1)
	
	
	self:onUpdateDraw()
end

function RedAlertTimeUnknownChest:onUpdate(dt)
	local root = self.roots[1]
	if self.click_on_number >= 1 then
		self.click_on_time = self.click_on_time + dt
	end
	if self.click_on_number > 1 then
		state_machine.excute("red_alert_time_unknown_chest_jump", 0, nil)
	else
		if self.click_on_time >= 0.3 then
			state_machine.excute("red_alert_time_unknown_chest_jump", 0, nil)
		end	
	end
end

function RedAlertTimeUnknownChest:init(params)
    self._mould_id = params[1]
    self.number_id = tonumber(params[2])
	self:onInit()
    return self
end

function RedAlertTimeUnknownChest:onExit()
	
end
