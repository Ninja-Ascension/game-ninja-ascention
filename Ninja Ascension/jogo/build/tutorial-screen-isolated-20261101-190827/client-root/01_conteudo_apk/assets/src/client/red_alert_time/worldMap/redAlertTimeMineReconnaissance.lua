-- ----------------------------------------------------------------------------------------------------
-- 说明：侦察界面
-------------------------------------------------------------------------------------------------------
redAlertTimeMineReconnaissance = class("redAlertTimeMineReconnaissanceClass", Window)

local red_alert_time_mine_reconnaissance_open_terminal = {
    _name = "red_alert_time_mine_reconnaissance_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("redAlertTimeMineReconnaissanceClass")
        if nil == _homeWindow then
    		fwin:open(redAlertTimeMineReconnaissance:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_mine_reconnaissance_close_terminal = {
    _name = "red_alert_time_mine_reconnaissance_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("redAlertTimeMineReconnaissanceClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("redAlertTimeMineReconnaissanceClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_mine_reconnaissance_investigate_terminal = {
    _name = "red_alert_time_mine_reconnaissance_investigate",
    _init = function (terminal) 
        app.load("client.red_alert_time.worldMap.redAlertTimeMineDetectResult")
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cells = params[1]
        local isForce = params[2] or 0
        local from_type = params[3] or 0
        local function requestReconnaissance(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if from_type == 0 then
                    state_machine.excute("red_alert_time_mine_detect_result_open", 0, cells)
                else
                    state_machine.excute("formation_defend_add_investigate_formation_info", 0, {cells, true})
                end
                state_machine.excute("red_alert_time_mine_reconnaissance_close", 0, 0)
                if fwin:find("redAlertTimeMineResourcePointOperationInterfaceClass") ~= nil then
                    state_machine.excute("red_alert_time_mine_resource_point_operation_interface_close", 0, 0)
                elseif fwin:find("redAlertTimeMineBaseOperationInterfaceClass") ~= nil then
                    state_machine.excute("red_alert_time_mine_base_operation_interface_close", 0, 0)
                elseif fwin:find("RebelHauntAttackClass") ~= nil then
                    state_machine.excute("rebel_haunt_attack_close", 0, 0)
                end
            end
            state_machine.excute("red_alert_time_mine_update_players_resources", 0, 0)
        end
        protocol_command.world_look_mine_info.param_list = cells.info._x.."\r\n"..cells.info._y.."\r\n"..isForce
        NetworkManager:register(protocol_command.world_look_mine_info.code, nil, nil, nil, nil, requestReconnaissance, false, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}


state_machine.add(red_alert_time_mine_reconnaissance_open_terminal)
state_machine.add(red_alert_time_mine_reconnaissance_close_terminal)
state_machine.add(red_alert_time_mine_reconnaissance_investigate_terminal)
state_machine.init()
    
function redAlertTimeMineReconnaissance:ctor()
    self.super:ctor()
    self.roots = {}
	self.m_type = 0
	self.isForce = 0
    self.demand = 0
	self.cell = nil
	
	local function init_red_alert_time_mine_reconnaissance_terminal()
		-- 侦察请求
        local red_alert_time_mine_reconnaissance_detect_request_terminal = {
            _name = "red_alert_time_mine_reconnaissance_detect_request",
            _init = function (terminal)
				app.load("client.red_alert_time.worldMap.redAlertTimeMineDetectResult")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.demand > tonumber(_ED.user_info.user_silver) then
                    local need_gold = getUpgradeCostGoldNum(instance:isCanConsumeGold(instance.demand))
                    local tip = ConfirmTip:new()
                    tip:init(instance, instance.sureGoldUpgrade, string.format(red_alert_all_str[296],need_gold))
                    fwin:open(tip,fwin._windows) 
                    return
                end
                state_machine.excute("red_alert_time_mine_reconnaissance_investigate", 0, {params._datas.cells, instance.isForce, instance.from_type})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(red_alert_time_mine_reconnaissance_detect_request_terminal)
		state_machine.init()
	end
	
	init_red_alert_time_mine_reconnaissance_terminal()
	
end

-- 金币升级
function redAlertTimeMineReconnaissance:sureGoldUpgrade(sure_number)
    if self.roots == nil then
        return
    end
    local root = self.roots[1]
    if root == nil then
        return
    end
    
    if sure_number == 0 then
        state_machine.excute("red_alert_time_mine_reconnaissance_investigate", 0, {self.cell, self.isForce, self.from_type})
    end
end

-- 检查消耗多少金币
function redAlertTimeMineReconnaissance:isCanConsumeGold(datas)
    local cost_iron = 0
    local cost_oil = 0
    local cost_lead = 0
    local cost_tita = 0
    local cost_gem = datas

    local lave_info = {cost_iron - _ED.user_info.user_iron ,
                    cost_oil - _ED.user_info.oil_field,
                    cost_lead - _ED.user_info.exploits,
                    cost_tita - _ED.user_info.tiger_shaped,
                    cost_gem - _ED.user_info.user_silver,}
    local lave_info_table = {}
    for i,v in pairs(lave_info) do
        if v > 0 then
            table.insert(lave_info_table, v) 
        end
    end
    return lave_info_table
end

function redAlertTimeMineReconnaissance:init(params)
	self.cell = params._datas.cells
	self.m_type = zstring.tonumber(params._datas.m_type)
	self.isForce = tonumber(params._datas.isForce) or 0
    self.from_type = tonumber(params._datas.from_type) or 0         -- 0：显示侦查结果，1：刷新阵型界面
    self:onInit()
    return self
end

function redAlertTimeMineReconnaissance:onInit()
    local csbredAlertTimeMineReconnaissance = csb.createNode(config_csb.world_map.res_spy)
    local root = csbredAlertTimeMineReconnaissance:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbredAlertTimeMineReconnaissance)
	
	local Text_consume_infor = ccui.Helper:seekWidgetByName(root,"Text_consume_infor")
    local Text_huafei = ccui.Helper:seekWidgetByName(root,"Text_huafei")
	---1是资源，2是玩家
    local con_info = nil 
	if self.m_type == 1 then
		local element = dms.element(dms["world_mine_mould"], self.cell.info._mould_id)
		local mine_level = dms.atoi(element, world_mine_mould.level)
		local consumption_element = dms.element(dms["world_investigate_need_param"], ""..mine_level)
		local consumption = dms.atos(consumption_element, world_investigate_need_param.need_param)
		con_info = zstring.split(consumption, ",")
		Text_consume_infor:setString(exChangeNumToString(zstring.tonumber(con_info[3]))..tipStringInfo_consumption_info[1])
        self.demand = zstring.tonumber(con_info[3])
    elseif self.m_type == 3 then
        local consumption_element = dms.element(dms["world_investigate_need_param"], "".._ED.world_level)
        local consumption = dms.atos(consumption_element, world_investigate_need_param.need_param)
        con_info = zstring.split(consumption, ",")
        Text_consume_infor:setString(exChangeNumToString(zstring.tonumber(con_info[3]))..tipStringInfo_consumption_info[1])
        self.demand = zstring.tonumber(con_info[3])
	else
		local consumption_element = dms.element(dms["world_investigate_need_param"], ""..self.cell.info._level)
		local consumption = dms.atos(consumption_element, world_investigate_need_param.need_param)
		con_info = zstring.split(consumption, ",")
		Text_consume_infor:setString(exChangeNumToString(zstring.tonumber(con_info[3]))..tipStringInfo_consumption_info[1])
        self.demand = zstring.tonumber(con_info[3])
	end
	if Text_huafei ~= nil then
        Text_huafei:setString(exChangeNumToString(zstring.tonumber(con_info[3])))
        Text_consume_infor:setString(tipStringInfo_consumption_info[1])
    end
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_res_infor_close"), nil, 
    {
        terminal_name = "red_alert_time_mine_reconnaissance_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_res_spy_cancel"), nil, 
    {
        terminal_name = "red_alert_time_mine_reconnaissance_close",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,3)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_window_bg"), nil, 
    {
        terminal_name = "red_alert_time_mine_reconnaissance_close",
        terminal_state = 0,
    },
    nil,3)
	
	--确定
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_res_spy_sure"), nil, 
    {
        terminal_name = "red_alert_time_mine_reconnaissance_detect_request",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
		cells = self.cell,
    },
    nil,1)
	
end

function redAlertTimeMineReconnaissance:onExit()
	
end