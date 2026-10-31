--------------------------------------------------------------------------------------------------------------
--  说明：配件进化cell
--------------------------------------------------------------------------------------------------------------
RedAlerTimeEquipEvolutionCell = class("RedAlerTimeEquipEvolutionCellClass", Window)
RedAlerTimeEquipEvolutionCell.__size = nil

--创建cell
local red_alert_time_equip_evolution_cell_terminal = {
    _name = "red_alert_time_equip_evolution_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = RedAlerTimeEquipEvolutionCell:new()
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
state_machine.add(red_alert_time_equip_evolution_cell_terminal)
state_machine.init()

function RedAlerTimeEquipEvolutionCell:ctor()
	self.super:ctor()
	self.roots = {}
	self._activity_type = nil
	self.a_type = 0
	 -- Initialize red_alert_time_act_share_cell state machine.
	 
    local function init_red_alert_time_equip_evolution_cell_terminal()
        local red_alert_time_equip_evolution_cell_receive_award_terminal = {
            _name = "red_alert_time_equip_evolution_cell_receive_award",
            _init = function (terminal)       
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- state_machine.excute("rank_window_open",0,{_datas = {list_type = 11}})
				state_machine.excute("short_cut_go_to_other_window",0,{11})
				state_machine.excute("wonderful_window_close",0,nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(red_alert_time_equip_evolution_cell_receive_award_terminal)
        state_machine.init()
    end 
    -- call func red_alert_time_act_share_cell create state machine.
    init_red_alert_time_equip_evolution_cell_terminal()

end

function RedAlerTimeEquipEvolutionCell:updateDraw()
    local root = self.roots[1]
	local ListView_parts_strengthen_props = ccui.Helper:seekWidgetByName(root,"ListView_parts_strengthen_props")
	ListView_parts_strengthen_props:removeAllItems()
	local reward = zstring.split(self._activity_type.achieve_reward, "|")
	for i,v in pairs(reward) do
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
		local cell = nil
		if prop_type == 7 then
			local equip_datas = {}
			equip_datas.equipment_name = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.equipment_name)
			equip_datas.pic_index = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.pic_index)
			cell = state_machine.excute("props_icon_create_cell",0,{show_type, 3, equip_datas, tonumber(prop_type), 0})
		else
			cell = state_machine.excute("props_icon_create_cell",0,{show_type, 3, tonumber(datas[1]), tonumber(prop_type), 0,nil,tonumber(datas[1])})
		end
		ListView_parts_strengthen_props:addChild(cell)
	end
	ListView_parts_strengthen_props:requestRefreshView()
	local Text_parts_strengthen_cell_tit = ccui.Helper:seekWidgetByName(root,"Text_parts_strengthen_cell_tit")
	Text_parts_strengthen_cell_tit:setString(self._activity_type.achieve_mould_name)
	local Text_parts_strengthen_cell_p = ccui.Helper:seekWidgetByName(root,"Text_parts_strengthen_cell_p")
	Text_parts_strengthen_cell_p:setString(self._activity_type.achieve_mould_dec)
	
	if tonumber(self.index) == 1 then
		ccui.Helper:seekWidgetByName(root,"Button_parts_strengthen_go"):setTitleText(activity_str_tip[38]) 
	else
		ccui.Helper:seekWidgetByName(root,"Button_parts_strengthen_go"):setTitleText(activity_str_tip[39]) 
	end
end

function RedAlerTimeEquipEvolutionCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.activity.act_parts_strengthen_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if RedAlerTimeEquipEvolutionCell.__size == nil then
        RedAlerTimeEquipEvolutionCell.__size = root:getContentSize()
    end

	--领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_parts_strengthen_go"), nil, 
    {
        terminal_name = "red_alert_time_equip_evolution_cell_receive_award", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
		cells = self
    }, nil, 1)

	self:updateDraw()
end

function RedAlerTimeEquipEvolutionCell:onEnterTransitionFinish()
    local root = self.roots[1]
    
end

function RedAlerTimeEquipEvolutionCell:clearUIInfo( ... )
    local root = self.roots[1]
	local ListView_parts_strengthen_props = ccui.Helper:seekWidgetByName(root,"ListView_parts_strengthen_props")
    local Text_parts_strengthen_cell_tit = ccui.Helper:seekWidgetByName(root,"Text_parts_strengthen_cell_tit")
    local Text_parts_strengthen_cell_p = ccui.Helper:seekWidgetByName(root,"Text_parts_strengthen_cell_p")
    if ListView_parts_strengthen_props ~= nil then
        ListView_parts_strengthen_props:removeAllItems()
        Text_parts_strengthen_cell_tit:setString("")
        Text_parts_strengthen_cell_p:setString("")
    end
end

function RedAlerTimeEquipEvolutionCell:onUpdate()
    if self._push_activity == nil then
       return
    end
    local now_time = os.time()
    if now_time - zstring.tonumber(self._last_time) >= 1 then
        -- self:pushNotificationActivity()
        self._last_time = now_time
    end
end

function RedAlerTimeEquipEvolutionCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function RedAlerTimeEquipEvolutionCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.act_parts_strengthen_cell, root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function RedAlerTimeEquipEvolutionCell:init(activity_type,index,a_type,group)
    self._activity_type = activity_type
	self.index = index
	self.a_type = a_type
	self.group = group
    -- if index ~= nil and index < 8 then
	   self:onInit()
    -- end

    self:setContentSize(RedAlerTimeEquipEvolutionCell.__size)
    return self
end

function RedAlerTimeEquipEvolutionCell:onExit()
	self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.act_parts_strengthen_cell, self.roots[1])
end