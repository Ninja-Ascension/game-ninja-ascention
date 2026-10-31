-- ----------------------------------------------------------------------------------------------------
-- 说明：收藏选择
-------------------------------------------------------------------------------------------------------
redAlertTimeMineCollectionSelection = class("redAlertTimeMineCollectionSelectionClass", Window)

local red_alert_time_mine_collection_selection_open_terminal = {
    _name = "red_alert_time_mine_collection_selection_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("redAlertTimeMineCollectionSelectionClass")
        if nil == _homeWindow then
    		fwin:open(redAlertTimeMineCollectionSelection:new():init(params._datas.m_type,params._datas.cells), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_mine_collection_selection_close_terminal = {
    _name = "red_alert_time_mine_collection_selection_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("redAlertTimeMineCollectionSelectionClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("redAlertTimeMineCollectionSelectionClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_mine_collection_selection_open_terminal)
state_machine.add(red_alert_time_mine_collection_selection_close_terminal)
state_machine.init()
    
function redAlertTimeMineCollectionSelection:ctor()
    self.super:ctor()
    self.roots = {}
	self.m_type = 0
	self.m_Object = nil
	
	local function init_red_alert_time_mine_collection_selection_terminal()
	
		-- 请求收藏
        local red_alert_time_mine_collection_selection_request_terminal = {
            _name = "red_alert_time_mine_collection_selection_request",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local function requestCollectionCoordinate(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
							if response.node.m_Object.collection_type == 1 then
								local m_Object_info = {}
								if response.node.m_Object.info._type == 0 then
									m_Object_info.name = response.node.m_Object.info._nickname
									m_Object_info.level = response.node.m_Object.info._level
									m_Object_info.coords = response.node.m_Object.info._x..","..response.node.m_Object.info._y
                                elseif response.node.m_Object.info._type == 3000
                                    or response.node.m_Object.info._type == 3001
                                    or response.node.m_Object.info._type == 3002
                                    then
                                    local city_data = dms.element(dms["world_city_mould"], response.node.m_Object.info._mould_id)
                                    local name = dms.atos(city_data, world_city_mould.name)
                                    local level = dms.atoi(city_data, world_city_mould.level)
                                    local position = dms.atos(city_data, world_city_mould.position)
                                    m_Object_info.name = name
                                    m_Object_info.level = level
                                    m_Object_info.coords = position
								else
									local element = dms.element(dms["world_mine_mould"], response.node.m_Object.info._mould_id)
									local mine_name = dms.atos(element, world_mine_mould.name)
									local mine_level = dms.atos(element, world_mine_mould.level)
									m_Object_info.name = mine_name
									m_Object_info.level = mine_level
									m_Object_info.coords = response.node.m_Object.info._x..","..response.node.m_Object.info._y
								end
								
								_ED.world_map.coord_collent = _ED.world_map.coord_collent or {}
								local valueList = _ED.world_map.coord_collent[""..response.node.m_type]
								if nil == valueList then
									 valueList = {}
									 _ED.world_map.coord_collent[""..response.node.m_type] = valueList
								end
								valueList[response.node.m_Object.info._type .. "," .. response.node.m_Object.info._id] = m_Object_info
								TipDlg.drawTextDailog(friends_tip_string[10])
							else
								_ED.world_map.coord_collent[""..response.node.m_type][response.node.m_Object.info._type .. "," .. response.node.m_Object.info._id] = nil
							end
							if fwin:find("redAlertTimeMineResourcePointOperationInterfaceClass") ~= nil then
								state_machine.excute("red_alert_time_mine_resource_point_operation_interface_update", 0, 0)
							end
							if fwin:find("redAlertTimeMineBaseOperationInterfaceClass") ~= nil then
								state_machine.excute("red_alert_time_mine_back_to_base_update", 0, 0)
							end
                            if fwin:find("LegionCityInforCellClass") ~= nil then
                                state_machine.excute("legion_city_infor_cell_update_draw", 0, 0)
                            end
                            if fwin:find("LegionCityFactoryInforClass") ~= nil then
                                state_machine.excute("legion_city_factory_infor_update_draw", 0, 0)
                            end
                            if fwin:find("LegionCityInforAttackClass") ~= nil then
                                state_machine.excute("legion_city_infor_attack_collection_update", 0, 0)
                            end
							state_machine.excute("red_alert_time_mine_collection_selection_close", 0, 0)
						end
					end
				end
				local maxNumber = dms.int(dms["world_config"], 15 , world_config.param)
				if _ED.world_map ~= nil and _ED.world_map.coord_collent ~= nil then
					local counts = 0
					for i=1,3 do
						if _ED.world_map.coord_collent ~= nil and _ED.world_map.coord_collent[""..i]~= nil then
							for j, v in pairs(_ED.world_map.coord_collent[""..i]) do
								if v ~= nil then
									counts = counts + 1
								end
							end
						end
					end
					if counts>=maxNumber then
						TipDlg.drawTextDailog(friends_tip_string[13])
						return
					end
				end
				if instance.m_Object.info._type == 0 then
					protocol_command.world_coord_collect.param_list = instance.m_Object.collection_type .. "\r\n" .. "" .. instance.m_type .. "-" ..instance.m_Object.info._type .. "," .. instance.m_Object.info._id .."\r\n"..instance.m_Object.info._nickname.."|"..instance.m_Object.info._level.."|"..instance.m_Object.info._x..","..instance.m_Object.info._y
				elseif instance.m_Object.info._type == 3000
                    or instance.m_Object.info._type == 3001
                    or instance.m_Object.info._type == 3002
                    then
                    local city_data = dms.element(dms["world_city_mould"], instance.m_Object.info._mould_id)
                    local name = dms.atos(city_data, world_city_mould.name)
                    local level = dms.atoi(city_data, world_city_mould.level)
                    protocol_command.world_coord_collect.param_list = instance.m_Object.collection_type .. "\r\n" .. "" .. instance.m_type .. "-" ..instance.m_Object.info._type .. "," .. instance.m_Object.info._id .."\r\n"..name.."|"..level.."|"..instance.m_Object.info._x..","..instance.m_Object.info._y
                else
					local element = dms.element(dms["world_mine_mould"], instance.m_Object.info._mould_id)
					local mine_name = dms.atos(element, world_mine_mould.name)
					local mine_level = dms.atos(element, world_mine_mould.level)
					--protocol_command.world_coord_collect.param_list = instance.m_Object.collection_type .. "\r\n" .. "" .. instance.m_type .. "-" ..instance.m_Object.info._type .. "," .. instance.m_Object.info._id .."\r\n"..mine_name.."|"..mine_level.."|"..instance.m_Object.info._x..","..instance.m_Object.info._y
					--如果是矿传id
					protocol_command.world_coord_collect.param_list = instance.m_Object.collection_type .. "\r\n" .. "" .. instance.m_type .. "-" ..instance.m_Object.info._type .. "," .. instance.m_Object.info._id .."\r\n"..instance.m_Object.info._mould_id.."|"..mine_level.."|"..instance.m_Object.info._x..","..instance.m_Object.info._y
				end
				NetworkManager:register(protocol_command.world_coord_collect.code, nil, nil, nil, instance, requestCollectionCoordinate, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--选择
		local red_alert_time_mine_collection_selection_select_terminal = {
            _name = "red_alert_time_mine_collection_selection_select",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:updateSelectOne(zstring.tonumber(params._datas.m_types))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_mine_collection_selection_request_terminal)
        state_machine.add(red_alert_time_mine_collection_selection_select_terminal)

        state_machine.init()
    end
    
    -- call func init adventure mine workshop state machine.
    init_red_alert_time_mine_collection_selection_terminal()

end

function redAlertTimeMineCollectionSelection:init(params,m_object)
	self.m_type = params
	self.m_Object = m_object
    self:onInit()
    return self
end

function redAlertTimeMineCollectionSelection:updateSelectOne(indexs)
	local root = self.roots[1]
	self.m_type = indexs
	if indexs == 1 then
		ccui.Helper:seekWidgetByName(root, "CheckBox_res"):setTouchEnabled(false)
		ccui.Helper:seekWidgetByName(root, "CheckBox_friend"):setTouchEnabled(true)
		ccui.Helper:seekWidgetByName(root, "CheckBox_enemy"):setTouchEnabled(true)
		ccui.Helper:seekWidgetByName(root, "CheckBox_friend"):setSelected(false)
		ccui.Helper:seekWidgetByName(root, "CheckBox_enemy"):setSelected(false)
	elseif indexs == 2 then
		ccui.Helper:seekWidgetByName(root, "CheckBox_friend"):setTouchEnabled(false)
		ccui.Helper:seekWidgetByName(root, "CheckBox_res"):setTouchEnabled(true)
		ccui.Helper:seekWidgetByName(root, "CheckBox_enemy"):setTouchEnabled(true)
		ccui.Helper:seekWidgetByName(root, "CheckBox_res"):setSelected(false)
		ccui.Helper:seekWidgetByName(root, "CheckBox_enemy"):setSelected(false)
	elseif indexs == 3 then
		ccui.Helper:seekWidgetByName(root, "CheckBox_enemy"):setTouchEnabled(false)
		ccui.Helper:seekWidgetByName(root, "CheckBox_res"):setTouchEnabled(true)
		ccui.Helper:seekWidgetByName(root, "CheckBox_friend"):setTouchEnabled(true)
		ccui.Helper:seekWidgetByName(root, "CheckBox_res"):setSelected(false)
		ccui.Helper:seekWidgetByName(root, "CheckBox_friend"):setSelected(false)
	end
	
	local Text_coordinate_n = ccui.Helper:seekWidgetByName(root, "Text_coordinate_n")
    Text_coordinate_n:setString(""..self.m_Object.info._x..","..self.m_Object.info._y)
end

function redAlertTimeMineCollectionSelection:onInit()
    local csbredAlertTimeMineCollectionSelection = csb.createNode(config_csb.world_map.res_collection)
    local root = csbredAlertTimeMineCollectionSelection:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbredAlertTimeMineCollectionSelection)
	
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_res_infor_close"), nil, 
    {
        terminal_name = "red_alert_time_mine_collection_selection_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_window_bg"), nil, 
    {
        terminal_name = "red_alert_time_mine_collection_selection_close",
        terminal_state = 0,
    },
    nil,3)
	
	--收藏
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_res_collection"), nil, 
    {
        terminal_name = "red_alert_time_mine_collection_selection_request",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)
	
	--资源
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"CheckBox_res"), nil, 
    {
        terminal_name = "red_alert_time_mine_collection_selection_select",
        terminal_state = 0,
		m_types = 1,
    },
    nil,1)
	
	--好友
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"CheckBox_friend"), nil, 
    {
        terminal_name = "red_alert_time_mine_collection_selection_select",
        terminal_state = 0,
		m_types = 2,
    },
    nil,1)
	
	--敌人
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"CheckBox_enemy"), nil, 
    {
        terminal_name = "red_alert_time_mine_collection_selection_select",
        terminal_state = 0,
		m_types = 3,
    },
    nil,1)
	
	if self.m_type == nil or self.m_type == 0 or self.m_type == "" then
		self:updateSelectOne(1)
	else
		self:updateSelectOne(self.m_type)
	end
	
end

function redAlertTimeMineCollectionSelection:onExit()
	state_machine.remove("red_alert_time_mine_collection_selection_request")
    state_machine.remove("red_alert_time_mine_collection_selection_select")
end