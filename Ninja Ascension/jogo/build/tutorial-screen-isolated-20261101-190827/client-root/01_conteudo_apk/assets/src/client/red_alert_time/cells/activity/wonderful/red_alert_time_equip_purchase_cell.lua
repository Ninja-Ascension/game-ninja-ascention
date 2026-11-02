--------------------------------------------------------------------------------------------------------------
--  说明：配件限购活动限购的cell
--------------------------------------------------------------------------------------------------------------
RedAlerTimeEquipPurchaseCell = class("RedAlerTimeEquipPurchaseCellClass", Window)
RedAlerTimeEquipPurchaseCell.__size = nil

--创建cell
local red_alert_time_equip_purchase_cell_terminal = {
    _name = "red_alert_time_equip_purchase_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = RedAlerTimeEquipPurchaseCell:new()
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
state_machine.add(red_alert_time_equip_purchase_cell_terminal)
state_machine.init()

function RedAlerTimeEquipPurchaseCell:ctor()
	self.super:ctor()
	self.roots = {}
	self._activity_type = nil
	self.a_type = 0
	 -- Initialize red_alert_time_act_share_cell state machine.
	 app.load("client.red_alert_time.cells.activity.wonderful.red_alert_time_discount_label")
	 
    local function init_red_alert_time_equip_purchase_cell_terminal()
        local red_alert_time_equip_purchase_cell_receive_award_terminal = {
            _name = "red_alert_time_equip_purchase_cell_receive_award",
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
						state_machine.excute("main_window_update_top_button", 0, nil)
						state_machine.excute("home_map_update_build", 0, nil)
					end
				end		
				protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..cell.a_type.."\r\n"..(tonumber(cell.group)-1).."\r\n"..tonumber(cell._activity_type.achieve_index)-1
				NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, cell, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(red_alert_time_equip_purchase_cell_receive_award_terminal)
        state_machine.init()
    end 
    -- call func red_alert_time_act_share_cell create state machine.
    init_red_alert_time_equip_purchase_cell_terminal()

end

function RedAlerTimeEquipPurchaseCell:updateDraw()
    local root = self.roots[1]
	-- --商品名称
	local Text_strengthen_material_cell_tit = ccui.Helper:seekWidgetByName(root,"Text_strengthen_material_cell_tit")
	-- Text_act_share_tit:setString(self._activity_type.achieve_mould_name)
	Text_strengthen_material_cell_tit:setString(self._activity_type.achieve_mould_name)
	-- --购买进度
	local Text_strengthen_material_buy_time = ccui.Helper:seekWidgetByName(root,"Text_strengthen_material_buy_time")
	local countData = zstring.split(self._activity_type.achieve_complete_count, "/")
	--local datas = string.gsub(activity_str_tip[25], "x", tonumber(countData[2])-tonumber(countData[1]))
	--local buyData = string.gsub(datas, "y", tonumber(countData[2]))
	local curr_buy_numb = tonumber(countData[2])-tonumber(countData[1])
	local buyData = string.format(activity_str_tip[25],curr_buy_numb,tonumber(countData[2]))
	Text_strengthen_material_buy_time:setString(buyData)
	-- Text_act_share_progress_n:setString(self._activity_type.achieve_complete_count)
	-- --道具图标
	local Panel_strengthen_material_icon = ccui.Helper:seekWidgetByName(root,"Panel_strengthen_material_icon")
	Panel_strengthen_material_icon:removeAllChildren(true)
	local datas = zstring.split(self._activity_type.achieve_reward, ",")
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
	Panel_strengthen_material_icon:addChild(cell)
	
	local moneyData = zstring.split(self._activity_type.achieve_other_info, ",")
	if self._activity_type.achieve_other_info == "-1" then
		for i=1,4 do
			moneyData[i] = 0 
		end
	end
	-- --折后价
	local Text_strengthen_material_price = ccui.Helper:seekWidgetByName(root,"Text_strengthen_material_price")
	Text_strengthen_material_price:setString(moneyData[3])
	-- --原价
	local Text_strengthen_material_old_price = ccui.Helper:seekWidgetByName(root,"Text_strengthen_material_old_price") 
	Text_strengthen_material_old_price:setString(moneyData[4])
	--折扣标签
	if tonumber(moneyData[5]) > 0 then
		local discountCell = state_machine.excute("red_alert_time_discount_label_cell",0,{moneyData[5]})
		Panel_strengthen_material_icon:addChild(discountCell,100)
	end
	
	local datas = zstring.split(self._activity_type.achieve_complete_count,"/")
	if tonumber(datas[1]) <= 0 then
		ccui.Helper:seekWidgetByName(root,"Button_strengthen_material_buy"):setTouchEnabled(false)
		ccui.Helper:seekWidgetByName(root,"Button_strengthen_material_buy"):setBright(false)
	else
		ccui.Helper:seekWidgetByName(root,"Button_strengthen_material_buy"):setTouchEnabled(true)
		ccui.Helper:seekWidgetByName(root,"Button_strengthen_material_buy"):setBright(true)
	end
end

function RedAlerTimeEquipPurchaseCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.activity.act_parts_strengthen_material_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if RedAlerTimeEquipPurchaseCell.__size == nil then
        RedAlerTimeEquipPurchaseCell.__size = root:getContentSize()
    end

	--领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_strengthen_material_buy"), nil, 
    {
        terminal_name = "red_alert_time_equip_purchase_cell_receive_award", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
		cells = self
    }, nil, 1)

	self:updateDraw()

end

function RedAlerTimeEquipPurchaseCell:onEnterTransitionFinish()
    local root = self.roots[1]
    
end

function RedAlerTimeEquipPurchaseCell:clearUIInfo( ... )
    local root = self.roots[1]
	local Text_strengthen_material_cell_tit = ccui.Helper:seekWidgetByName(root,"Text_strengthen_material_cell_tit")
	local Text_strengthen_material_buy_time = ccui.Helper:seekWidgetByName(root,"Text_strengthen_material_buy_time")
	local Panel_strengthen_material_icon = ccui.Helper:seekWidgetByName(root,"Panel_strengthen_material_icon")
	local Text_strengthen_material_old_price = ccui.Helper:seekWidgetByName(root,"Text_strengthen_material_old_price")
	local Text_strengthen_material_price = ccui.Helper:seekWidgetByName(root,"Text_strengthen_material_price") 
	if Text_strengthen_material_cell_tit ~= nil then
		Text_strengthen_material_cell_tit:setString("")
		Text_strengthen_material_buy_time:setString("")
		Panel_strengthen_material_icon:removeBackGroundImage()
		Panel_strengthen_material_icon:removeAllChildren(true)
		Text_strengthen_material_old_price:setString("")
		Text_strengthen_material_price:setString("")
	end
end

function RedAlerTimeEquipPurchaseCell:onUpdate()
    if self._push_activity == nil then
       return
    end
    local now_time = os.time()
    if now_time - zstring.tonumber(self._last_time) >= 1 then
        -- self:pushNotificationActivity()
        self._last_time = now_time
    end
end

function RedAlerTimeEquipPurchaseCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function RedAlerTimeEquipPurchaseCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.act_parts_strengthen_material_cell, root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function RedAlerTimeEquipPurchaseCell:init(activity_type,index,a_type,group)
    self._activity_type = activity_type
	self.index = index
	self.a_type = a_type
	self.group = group
    -- if index ~= nil and index < 8 then
	   self:onInit()
    -- end

    self:setContentSize(RedAlerTimeEquipPurchaseCell.__size)
    return self
end

function RedAlerTimeEquipPurchaseCell:onExit()
	self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.act_parts_strengthen_material_cell, self.roots[1])
end