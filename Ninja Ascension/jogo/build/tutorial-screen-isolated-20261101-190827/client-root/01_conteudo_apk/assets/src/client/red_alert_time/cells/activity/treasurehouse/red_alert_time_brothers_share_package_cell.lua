-- ------------------------------------------------------------------------------------------------------------
--  说明：兄弟同享的列表cell
-- ------------------------------------------------------------------------------------------------------------
RedAlertTimeBrothersSharePackageCell = class("RedAlertTimeBrothersSharePackageCellClass", Window)
RedAlertTimeBrothersSharePackageCell.__size = nil

--创建cell
local red_alert_time_brothers_share_package_cell_create_terminal = {
    _name = "red_alert_time_brothers_share_package_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = RedAlertTimeBrothersSharePackageCell:new()
        local activity_data = params[1]
        local activity = params[2]
        local index = params[3]
        cell:init(activity_data,activity,index)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(red_alert_time_brothers_share_package_cell_create_terminal)
state_machine.init()

function RedAlertTimeBrothersSharePackageCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.m_time = 0

    self._activity_data = nil
    self._activity = nil
    self._index = 0 
    local function init_red_alert_time_brothers_share_package_cell_terminal()
		local red_alert_time_brothers_share_package_receive_terminal = {
            _name = "red_alert_time_brothers_share_package_receive",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							instance._activity_data.status = 1
							instance._activity_data.receiveNumber = instance._activity_data.receiveNumber + 1
							instance:updateDraw()
							checkRewardObtainDraw()
						end
					end
				end		
				-- debug.print_r(self.activityInfo[1])
				protocol_command.draw_activity_reward.param_list = instance._activity.activity_id .. "\r\n"..instance._activity.activity_type.."\r\n".."0".."\r\n".."0".."\r\n".."1".."\r\n"..tonumber(instance._index)-1
				NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local red_alert_time_brothers_share_refresh_the_data_terminal = {
            _name = "red_alert_time_brothers_share_refresh_the_data",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance._activity_data.status = 1
				instance._activity_data.receiveNumber = instance._activity_data.receiveNumber + 1
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(red_alert_time_brothers_share_package_receive_terminal)
        state_machine.add(red_alert_time_brothers_share_refresh_the_data_terminal)
    end
    init_red_alert_time_brothers_share_package_cell_terminal()
end

function RedAlertTimeBrothersSharePackageCell:refreshTheData()
    if self._activity_data.status == 0 then
    	self._activity_data.status = 1
    	self._activity_data.receiveNumber = self._activity_data.receiveNumber + 1
    end
end

function RedAlertTimeBrothersSharePackageCell:updateDraw()
    local root = self.roots[1]
	
	local Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
	Panel_prop:removeAllChildren(true)
	local datas = zstring.split(self._activity_data.reward, ",")
	if tonumber(datas[1]) == -1 then
		datas[1] = resource_prop_id[tonumber(datas[2])]
		datas[2] = 1
	end
	local prop_type = tonumber(datas[2])
	local show_type = 1
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
	Panel_prop:addChild(cell)
	
	-- 礼品
	-- local Text_brothers_share_n_1 = ccui.Helper:seekWidgetByName(root, "Text_brothers_share_n_1")
	-- Text_brothers_share_n_1:setString("")
	--分享
	local Text_brothers_share_n_2 = ccui.Helper:seekWidgetByName(root, "Text_brothers_share_n_2")
	Text_brothers_share_n_2:setString(self._activity_data.name)
	--领取记录
	local Text_brothers_share_n_3 = ccui.Helper:seekWidgetByName(root, "Text_brothers_share_n_3")
	Text_brothers_share_n_3:setString(self._activity_data.receiveNumber.."/"..self._activity_data.maxNumber-1)
	--剩余时间
	local Text_brothers_share_n_4 = ccui.Helper:seekWidgetByName(root, "Text_brothers_share_n_4")
    self.m_time = tonumber(self._activity_data.enTime)/1000 - (os.time() + tonumber(_ED.system_time) -tonumber(_ED.native_time))
    Text_brothers_share_n_4:setString(exChangeTimeToString(self.m_time))
	-- Text_brothers_share_n_4:setString("")
	local Button_brother_receive = ccui.Helper:seekWidgetByName(root, "Button_brother_receive")
    Button_brother_receive:setVisible(false)
	if tonumber(self._activity_data.status) == 0 then
		-- Button_brother_receive:setVisible(true)
		Text_brothers_share_n_4:setVisible(true)	
	else
		if tonumber(self._activity_data.status) == -1 or self.m_time <0 then
			Text_brothers_share_n_4:setString(activity_str_tip[8])
		else
			Text_brothers_share_n_4:setString(activity_str_tip[2])
		end
		-- Button_brother_receive:setVisible(false)
		Text_brothers_share_n_4:setVisible(true)
	end
end

function RedAlertTimeBrothersSharePackageCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.activity.treasurehouse.brothers_share_package_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if RedAlertTimeBrothersSharePackageCell.__size == nil then
        RedAlertTimeBrothersSharePackageCell.__size = root:getContentSize()
    end

	--
	-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_brother_receive"), nil, 
 --    {
 --        terminal_name = "red_alert_time_brothers_share_package_receive", 
 --        terminal_state = 0,
 --    }, nil, 1)
	
    self:updateDraw()
end

function RedAlertTimeBrothersSharePackageCell:onUpdate(dt)
    if tonumber(self._activity_data.status) == 0 and self.roots[1]~= nil then
        if self.m_time > 0 then
            self.m_time = self.m_time - dt
            ccui.Helper:seekWidgetByName(self.roots[1], "Text_brothers_share_n_4"):setString(exChangeTimeToString(self.m_time))
        else
            self:updateDraw()
        end    
    end    
end

function RedAlertTimeBrothersSharePackageCell:onEnterTransitionFinish()

end

function RedAlertTimeBrothersSharePackageCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function RedAlertTimeBrothersSharePackageCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.brothers_share_package_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function RedAlertTimeBrothersSharePackageCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
    local Text_brothers_share_n_2 = ccui.Helper:seekWidgetByName(root, "Text_brothers_share_n_2")
    local Text_brothers_share_n_3 = ccui.Helper:seekWidgetByName(root, "Text_brothers_share_n_3")
    local Text_brothers_share_n_4 = ccui.Helper:seekWidgetByName(root, "Text_brothers_share_n_4")
    local Button_brother_receive = ccui.Helper:seekWidgetByName(root, "Button_brother_receive")
    if Panel_prop ~= nil then
        Panel_prop:removeAllChildren(true)
        Text_brothers_share_n_2:setString("")
        Text_brothers_share_n_3:setString("")
        Text_brothers_share_n_4:setString("")
        Button_brother_receive:setVisible(true)
    end
    self.m_time = 0
end

function RedAlertTimeBrothersSharePackageCell:init(activity_data,activity,index)
    self._activity_data = activity_data
    self._activity = activity
    self._index = index
    -- if index ~= nil and index <= 5 then
        self:onInit()
    -- end
    self:setContentSize(RedAlertTimeBrothersSharePackageCell.__size)
    return self
end

function RedAlertTimeBrothersSharePackageCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.brothers_share_package_cell, self.roots[1])
end

