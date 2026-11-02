-- ----------------------------------------------------------------------------------------------------
-- 说明：出战部队信息
-------------------------------------------------------------------------------------------------------
redAlertTimeMineBattleTroopsInfor = class("redAlertTimeMineBattleTroopsInforClass", Window)

local red_alert_time_mine_battle_troops_infor_open_terminal = {
    _name = "red_alert_time_mine_battle_troops_infor_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("redAlertTimeMineBattleTroopsInforClass")
        if nil == _homeWindow then
    		fwin:open(redAlertTimeMineBattleTroopsInfor:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_mine_battle_troops_infor_close_terminal = {
    _name = "red_alert_time_mine_battle_troops_infor_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("redAlertTimeMineBattleTroopsInforClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("redAlertTimeMineBattleTroopsInforClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_mine_battle_troops_infor_open_terminal)
state_machine.add(red_alert_time_mine_battle_troops_infor_close_terminal)
state_machine.init()
    
function redAlertTimeMineBattleTroopsInfor:ctor()
    self.super:ctor()
    self.roots = {}
	self.m_object = nil
	self.Text_troops_mining_schedule_n = nil
	self.Text_troops_time_have_n = nil
	
	app.load("client.red_alert_time.cells.formation.formation_tank_head_cell")
	app.load("client.red_alert_time.cells.formation.formation_leader_head_cell")
	
	local function init_red_alert_time_mine_battle_troops_infor_terminal()
		-- 定位
        local red_alert_time_mine_battle_troops_infor_location_terminal = {
            _name = "red_alert_time_mine_battle_troops_infor_location",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local x = instance.m_object.m_object._dx
            	local y = instance.m_object.m_object._dy
           	 	state_machine.excute("red_alert_time_mine_battle_troops_infor_close", 0, 0)
				state_machine.excute("home_button_select_page", 0, {_datas = {select_page = 2}})
				state_machine.excute("adventure_mine_record_view_position", 0, {x,y})
				state_machine.excute("adventure_mine_update_view_position", 0, 0)

				protocol_command.world_map_arena_info_refresh.param_list = "" .. x .. "\r\n" .. y
				NetworkManager:register(protocol_command.world_map_arena_info_refresh.code, nil, nil, nil, nil, nil, false, nil)
				
				
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_mine_battle_troops_infor_location_terminal)
	
		state_machine.init()
	end
	
	init_red_alert_time_mine_battle_troops_infor_terminal()
	
end

function redAlertTimeMineBattleTroopsInfor:init(cells)
	self.m_object = cells._datas.cells
    self:onInit()
    return self
end

function redAlertTimeMineBattleTroopsInfor:onInit()
    local csbredAlertTimeMineBattleTroopsInfor = csb.createNode(config_csb.cells.world.world_battle_troops_infor)
    local root = csbredAlertTimeMineBattleTroopsInfor:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbredAlertTimeMineBattleTroopsInfor)
	
	
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_troops_infor_close"), nil, 
    {
        terminal_name = "red_alert_time_mine_battle_troops_infor_close",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,3)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "red_alert_time_mine_battle_troops_infor_close", 
        terminal_state = 0, 
    }, nil, 3)
	
	-- 查看
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_troops_res_look"), nil, 
    {
        terminal_name = "red_alert_time_mine_battle_troops_infor_location",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)
	
	self:updateDraw()
end

function redAlertTimeMineBattleTroopsInfor:updateDraw()
	local root = self.roots[1]
	local Text_troops_number_n = ccui.Helper:seekWidgetByName(root,"Text_troops_number_n") --部队数量
	local Text_troops_fight_n = ccui.Helper:seekWidgetByName(root,"Text_troops_fight_n") --部队战斗力
	self.Text_troops_mining_schedule_n = ccui.Helper:seekWidgetByName(root,"Text_troops_mining_schedule_n") --挖矿进度
	self.Text_troops_time_have_n = ccui.Helper:seekWidgetByName(root,"Text_troops_time_have_n") --剩余时间
	local troops_number = 0
	local shipFightNumber = 0
	-- local cell = state_machine.excute("world_battle_formation_examine_cell_create", 0, {k, v[1], v[2]})
	ccui.Helper:seekWidgetByName(root,"Text_troops_load_n"):setString(exChangeNumToString(self.m_object.m_object._max_out_put))
	local formation_info = zstring.split(self.m_object.m_object._formation_info, "|")
	for i, v in pairs(formation_info) do
		local Panel_formation_tank = ccui.Helper:seekWidgetByName(root,"Panel_formation_tank_"..i)
		local Panel_formation_leader = ccui.Helper:seekWidgetByName(root,"Panel_formation_leader_"..i)
		local v_info = zstring.split(v, ",")
        local leader_info = nil
        if tonumber(v_info[7]) ~= 0 then
            if tonumber(self.m_object.m_object._event_type) >= 13 and tonumber(self.m_object.m_object._event_type)< 18 then
                local ship = {}
                ship.ship_template_id = v_info[7]
                local ship_data = dms.element(dms["ship_mould"], ship.ship_template_id)
                ship.captain_name = dms.atos(ship_data, ship_mould.captain_name)
                ship.ship_type = dms.atoi(ship_data, ship_mould.ship_type)
                local cell = state_machine.excute("formation_leader_head_cell_create_cell", 0, {i,ship,1,2})
                Panel_formation_leader:addChild(cell)
            else
                for i,ship in pairs(_ED.user_ship) do
                    if tonumber(ship.ship_template_id) == tonumber(v_info[7]) then
                        local cell = state_machine.excute("formation_leader_head_cell_create_cell", 0, {i,ship,1,2})
                        Panel_formation_leader:addChild(cell)
                        leader_info = ship
                    end
                end 
            end 
        else
		if tonumber(v_info[3]) ~= 0 then
			troops_number = troops_number + tonumber(v_info[3])
			if tonumber(self.m_object.m_object._event_type) >= 13 and tonumber(self.m_object.m_object._event_type)< 18 then
				local ship = {}
				ship.ship_template_id = v_info[2]
				local cell = state_machine.excute("formation_tank_head_cell_create_cell", 0, {i, ship, tonumber(v_info[3]),3})
				Panel_formation_tank:addChild(cell)
			else
				for j,ship in pairs(_ED.user_ship) do
					if tonumber(ship.ship_id) == tonumber(v_info[1]) then
						shipFightNumber = shipFightNumber + getShipFightNumber(ship,tonumber(v_info[3]), leader_info, i)
						local cell = state_machine.excute("formation_tank_head_cell_create_cell", 0, {i, ship, tonumber(v_info[3]),3})
						Panel_formation_tank:addChild(cell)
					end
				end
			end
		else
			local cell = state_machine.excute("formation_tank_head_cell_create_cell", 0, {i, nil, 0,3})
			Panel_formation_tank:addChild(cell)
		end
			local cell = state_machine.excute("formation_leader_head_cell_create_cell", 0, {i,nil,1,2})
			Panel_formation_leader:addChild(cell)
		end
		
		 
		-- local cell = state_machine.excute("world_battle_formation_examine_cell_create", 0, v)
		-- Panel_form_point:addChild(cell)
	end
	
	Text_troops_number_n:setString(troops_number)
	if tonumber(self.m_object.m_object._event_type) == 7
        or (tonumber(self.m_object.m_object._event_type) >= 13 and tonumber(self.m_object.m_object._event_type)< 18)
        then
		Text_troops_fight_n:setString(exChangeNumToString(math.ceil(self.m_object.m_object._combat_force)))
		self.Text_troops_mining_schedule_n:setVisible(false)
		self.Text_troops_time_have_n:setVisible(false)
		ccui.Helper:seekWidgetByName(root,"Text_troops_mining_schedule_t"):setVisible(false)
		ccui.Helper:seekWidgetByName(root,"Text_troops_time_have_t"):setVisible(false)
	else
		Text_troops_fight_n:setString(exChangeNumToString(math.ceil(shipFightNumber)))
		self.Text_troops_mining_schedule_n:setVisible(true)
		self.Text_troops_time_have_n:setVisible(true)
		ccui.Helper:seekWidgetByName(root,"Text_troops_mining_schedule_t"):setVisible(true)
		ccui.Helper:seekWidgetByName(root,"Text_troops_time_have_t"):setVisible(true)
	end
	if (tonumber(self.m_object.m_object._event_type) == 0 or tonumber(self.m_object.m_object._event_type) == 1 or tonumber(self.m_object.m_object._event_type) == 6 or tonumber(self.m_object.m_object._event_type) == 8) then 
		self.Text_troops_time_have_n:setString(ccui.Helper:seekWidgetByName(self.m_object.roots[1],"Text_distance_ing"):getString())
		self.Text_troops_mining_schedule_n:setVisible(false)
		ccui.Helper:seekWidgetByName(root,"Text_troops_mining_schedule_t"):setVisible(false)
	elseif tonumber(self.m_object.m_object._event_type) == 5 then
		self.Text_troops_mining_schedule_n:setVisible(true)
		ccui.Helper:seekWidgetByName(root,"Text_troops_mining_schedule_t"):setVisible(true)
		self.Text_troops_mining_schedule_n:setString(ccui.Helper:seekWidgetByName(self.m_object.roots[1],"Text_distance_ing"):getString())
	end	
end

function redAlertTimeMineBattleTroopsInfor:onUpdate(dt)
	if (tonumber(self.m_object.m_object._event_type) == 0 or tonumber(self.m_object.m_object._event_type) == 1 or tonumber(self.m_object.m_object._event_type) == 6 or tonumber(self.m_object.m_object._event_type) == 8) then 
		self.Text_troops_time_have_n:setString(ccui.Helper:seekWidgetByName(self.m_object.roots[1],"Text_distance_ing"):getString())
		self.Text_troops_mining_schedule_n:setVisible(false)
		ccui.Helper:seekWidgetByName(self.roots[1],"Text_troops_mining_schedule_t"):setVisible(false)
	elseif tonumber(self.m_object.m_object._event_type) == 5 then
		self.Text_troops_mining_schedule_n:setVisible(true)
		ccui.Helper:seekWidgetByName(self.roots[1],"Text_troops_mining_schedule_t"):setVisible(true)
		self.Text_troops_mining_schedule_n:setString(ccui.Helper:seekWidgetByName(self.m_object.roots[1],"Text_distance_ing"):getString())
		local distance_ing = tonumber(self.m_object.m_object._max_out_put) * (1-ccui.Helper:seekWidgetByName(self.m_object.roots[1],"LoadingBar_distance_bar"):getPercent()/100)/tonumber(self.m_object.m_second)
		self.Text_troops_time_have_n:setString(exChangeTimeToString(distance_ing))
	end
end

function redAlertTimeMineBattleTroopsInfor:onExit()
	
end