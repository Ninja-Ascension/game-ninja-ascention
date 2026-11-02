-- ----------------------------------------------------------------------------------------------------
-- 说明：出战部队信息
-------------------------------------------------------------------------------------------------------
WorldBattleTroopsInfor = class("WorldBattleTroopsInforClass", Window)

local world_battle_troops_infor_open_terminal = {
    _name = "world_battle_troops_infor_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _homeWindow = fwin:find("WorldBattleTroopsInforClass")
        if nil == _homeWindow then
            fwin:open(WorldBattleTroopsInfor:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local world_battle_troops_infor_close_terminal = {
    _name = "world_battle_troops_infor_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _homeWindow = fwin:find("WorldBattleTroopsInforClass")
        if nil ~= _homeWindow then
            fwin:close(fwin:find("WorldBattleTroopsInforClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(world_battle_troops_infor_open_terminal)
state_machine.add(world_battle_troops_infor_close_terminal)
state_machine.init()
    
function WorldBattleTroopsInfor:ctor()
    self.super:ctor()
    self.roots = {}
    
    self._info = nil
    self.local_time = 0
    self.m_second = 0

    self.second_increase_time = 1
    self.second_total = 0

    self._event_type = 0

    self.Text_troops_mining_schedule_n = nil --挖矿进度
    self.Text_troops_time_have_n = nil
    
    app.load("client.red_alert_time.cells.formation.formation_tank_head_cell")
    app.load("client.red_alert_time.cells.formation.formation_leader_head_cell")
    
    local function init_world_battle_troops_infor_terminal()
        -- 定位
        local world_battle_troops_infor_location_terminal = {
            _name = "world_battle_troops_infor_location",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local x = instance._info._dx
                local y = instance._info._dy
                state_machine.excute("world_battle_troops_infor_close", 0, 0)
                state_machine.excute("formation_window_close", 0, 0)
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

        local world_battle_troops_infor_on_close_terminal = {
            _name = "world_battle_troops_infor_on_close",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:addService({
                    callback = function ( params )
                        state_machine.excute("world_battle_troops_infor_close", 0, "")
                    end,
                    delay = 0.4,
                    params = ""
                })
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local world_battle_troops_infor_update_draw_terminal = {
            _name = "world_battle_troops_infor_update_draw",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local key = "" .. instance._info._user_info .. "," .. instance._info._time .. "," .. instance._info._dx .. "," .. instance._info._dy
                local info = _ED.world_map.target_event_info[key]
                if info ~= nil and tonumber(info._event_type) == tonumber(instance._event_type) then
                    -- instance._info = info
                    -- instance:updateDraw()
                else
                    state_machine.excute("world_battle_troops_infor_close", 0, "")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(world_battle_troops_infor_location_terminal)
        state_machine.add(world_battle_troops_infor_on_close_terminal)
        state_machine.add(world_battle_troops_infor_update_draw_terminal)
        state_machine.init()
    end
    
    init_world_battle_troops_infor_terminal()
    
end

function WorldBattleTroopsInfor:init(params)
    self._info = params[1]

    self._event_type = tonumber(self._info._event_type)

    self:onInit()
    return self
end

function WorldBattleTroopsInfor:onInit()
    local csbWorldBattleTroopsInfor = csb.createNode(config_csb.cells.world.world_battle_troops_infor)
    local root = csbWorldBattleTroopsInfor:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbWorldBattleTroopsInfor)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_troops_infor_close"), nil, 
    {
        terminal_name = "world_battle_troops_infor_close",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,3)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "world_battle_troops_infor_close", 
        terminal_state = 0, 
    }, nil, 3)
    
    -- 查看
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_troops_res_look"), nil, 
    {
        terminal_name = "world_battle_troops_infor_location",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)
    
    self:updateDraw()
end

function WorldBattleTroopsInfor:updateDraw()
    local root = self.roots[1]
    local Text_troops_number_n = ccui.Helper:seekWidgetByName(root,"Text_troops_number_n") --部队数量
    local Text_troops_fight_n = ccui.Helper:seekWidgetByName(root,"Text_troops_fight_n") --部队战斗力
    self.Text_troops_mining_schedule_n = ccui.Helper:seekWidgetByName(root,"Text_troops_mining_schedule_n") --挖矿进度
    self.Text_troops_time_have_n = ccui.Helper:seekWidgetByName(root,"Text_troops_time_have_n") --剩余时间
    local troops_number = 0
    local shipFightNumber = 0
    -- local cell = state_machine.excute("world_battle_formation_examine_cell_create", 0, {k, v[1], v[2]})
    ccui.Helper:seekWidgetByName(root,"Text_troops_load_n"):setString(exChangeNumToString(self._info._max_out_put))
    local formation_info = zstring.split(self._info._formation_info, "|")
    for i, v in pairs(formation_info) do
        local Panel_formation_tank = ccui.Helper:seekWidgetByName(root,"Panel_formation_tank_"..i)
        local Panel_formation_leader = ccui.Helper:seekWidgetByName(root,"Panel_formation_leader_"..i)
        local v_info = zstring.split(v, ",")
        local leader_info = nil
        if tonumber(v_info[7]) ~= 0 then
            if tonumber(self._event_type) >= 13 and tonumber(self._event_type)< 18 then
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
            local cell = state_machine.excute("formation_leader_head_cell_create_cell", 0, {i,nil,1,2})
            Panel_formation_leader:addChild(cell)
        end
        if tonumber(v_info[3]) ~= 0 then
            troops_number = troops_number + tonumber(v_info[3])
            if tonumber(self._event_type) >= 13 and tonumber(self._event_type)< 18 then
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
    end
    
    Text_troops_number_n:setString(troops_number)
    if tonumber(self._event_type) == 7
        or (tonumber(self._event_type) >= 13 and tonumber(self._event_type) < 18)
        or tonumber(self._event_type) == 20
        then
        Text_troops_fight_n:setString(exChangeNumToString(math.ceil(self._info._combat_force)))
        self.Text_troops_mining_schedule_n:setVisible(false)
        self.Text_troops_time_have_n:setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Text_troops_mining_schedule_t"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Text_troops_time_have_t"):setVisible(false)
    elseif tonumber(self._event_type) == 19
        or tonumber(self._event_type) == 23
        then
        Text_troops_fight_n:setString(exChangeNumToString(math.ceil(self._info._combat_force)))
        self.Text_troops_mining_schedule_n:setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Text_troops_mining_schedule_t"):setVisible(false)
    else
        Text_troops_fight_n:setString(exChangeNumToString(math.ceil(shipFightNumber)))
        self.Text_troops_mining_schedule_n:setVisible(true)
        self.Text_troops_time_have_n:setVisible(true)
        ccui.Helper:seekWidgetByName(root,"Text_troops_mining_schedule_t"):setVisible(true)
        ccui.Helper:seekWidgetByName(root,"Text_troops_time_have_t"):setVisible(true)
    end
    if (tonumber(self._event_type) == 0 or tonumber(self._event_type) == 1 or tonumber(self._event_type) == 6 or tonumber(self._event_type) == 8 or tonumber(self._event_type) == 18) then 
        self.Text_troops_mining_schedule_n:setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Text_troops_mining_schedule_t"):setVisible(false)
    elseif tonumber(self._event_type) == 5 then
        self.Text_troops_mining_schedule_n:setVisible(true)
        ccui.Helper:seekWidgetByName(root,"Text_troops_mining_schedule_t"):setVisible(true)
    end 

    self.local_time = (tonumber(self._info._start_time)/1000+tonumber(self._info._complete_time))-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time)))
    if tonumber(self._event_type) == 5 then
        self.local_time = (tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time)))-(tonumber(self._info._start_time)/1000)
        if self.local_time < 0 then
            self.local_time = 0
        end
    end

    if tonumber(self._event_type) == 5 then
        if zstring.tonumber(self._info._target_type) > 0 and zstring.tonumber(self._info._target_type) < 1000 then
            local m_mineral = dms.element(dms["world_mine_mould"], self._info._world_mine_mould_id)
            local second_info = zstring.split(dms.atos(m_mineral, world_mine_mould.per_second_output), ",")
            if tonumber(self._info._quality) == 0 then
                if self._info._bonus_value ~= 0 then
                    self.m_second = tonumber(second_info[2])*(1+self._info._bonus_value/100)
                else
                    self.m_second = tonumber(second_info[2])
                end
            else
                if self._info._bonus_value ~= 0 then
                    self.m_second = tonumber(second_info[2]) * (1+tonumber(self._info._quality)*0.5+self._info._bonus_value/100)
                else
                    self.m_second = tonumber(second_info[2]) * (1+tonumber(self._info._quality)*0.5)
                end
            end
        end
    end

    self:onUpdate(0)
end

function WorldBattleTroopsInfor:onUpdate(dt)
    if self.roots == nil or self.roots[1] == nil or self._info == nil then
        state_machine.excute("world_battle_troops_infor_on_close", 0, "")
        return
    end

    if tonumber(self._event_type) == 0 
        or tonumber(self._event_type) == 1 
        or tonumber(self._event_type) == 6 
        or tonumber(self._event_type) == 8 
        or tonumber(self._event_type) == 18 
        or tonumber(self._event_type) == 19 
        or tonumber(self._event_type) == 23 
        then 
        self.local_time = self.local_time - dt
        self.Text_troops_time_have_n:setString(exChangeTimeToString(self.local_time))
        if self.local_time <= 0 then
            state_machine.excute("world_battle_troops_infor_on_close", 0, "")
        end
    elseif tonumber(self._event_type) == 5 then
        self.second_increase_time = self.second_increase_time + dt
        if self.second_increase_time >= 1 and self.second_total < tonumber(self._info._max_out_put) then
            self.second_increase_time = 0
            self.local_time = (tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time)))-(tonumber(self._info._start_time)/1000)
            self.second_total = zstring.tonumber(self._info._prev_out_put) + self.m_second*self.local_time
        elseif self.second_total >= tonumber(self._info._max_out_put) then
            self.second_total = tonumber(self._info._max_out_put)
        end
        self.second_total = math.max(0,self.second_total)
        self.Text_troops_mining_schedule_n:setString(exChangeNumToString(math.floor(self.second_total)).."/"..exChangeNumToString(tonumber(self._info._max_out_put)))
        
        local distance_ing = (tonumber(self._info._max_out_put) - self.second_total) / self.m_second
        self.Text_troops_time_have_n:setString(exChangeTimeToString(distance_ing))
    end
end

function WorldBattleTroopsInfor:onExit()
    state_machine.remove("world_battle_troops_infor_location")
    state_machine.remove("world_battle_troops_infor_on_close")
    state_machine.remove("world_battle_troops_infor_update_draw")
end