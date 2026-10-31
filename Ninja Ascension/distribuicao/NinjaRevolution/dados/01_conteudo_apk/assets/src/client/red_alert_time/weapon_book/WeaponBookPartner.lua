
WeaponBookPartner = class("WeaponBookPartnerClass", Window)

local weapon_book_partner_window_open_terminal = {
    _name = "weapon_book_partner_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if funOpenDrawTip(35) == true then
            return
        end
        state_machine.excute("home_select_action_window_close",0,"")
        local _WeaponBookPartnerWindow = fwin:find("WeaponBookPartnerClass")
        if nil == _WeaponBookPartnerWindow then
            fwin:open(WeaponBookPartner:new():init(), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
--关闭
local weapon_book_partner_window_close_terminal = {
    _name = "weapon_book_partner_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("WeaponBookPartnerClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(weapon_book_partner_window_open_terminal)
state_machine.add(weapon_book_partner_window_close_terminal)
state_machine.init()

function WeaponBookPartner:ctor()
    self.super:ctor()
    self.roots = {}
    self.user_ships = {}
    self.ship = nil

    --英雄icon列表
    self.listview = nil 
    --列表x轴
    self.listview_pox = nil

    -- load lua file
    app.load("client.utils.ConfirmTip")
    app.load("client.red_alert_time.cells.hero.hero_icon_cell")
    app.load("client.red_alert_time.weapon_book.WeaponBookPartnerRule")
    app.load("client.red_alert_time.weapon_book.WeaponBookPartnerTalent")
    app.load("client.red_alert_time.weapon_book.WeaponBookPartnerInfo")

    local function init_weapon_book_partner_terminal()
        local weapon_book_partner_change_terminal = {
            _name = "weapon_book_partner_change",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                -- local function responseCallback( response )
                --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                --         state_machine.excute("racecourse_ride_change_ship",0,nil)
                --     end
                -- end
                -- protocol_command.rider_horse.param_list = "0\r\n"..instance.ship.ship_id
                -- NetworkManager:register(protocol_command.rider_horse.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local weapon_book_partner_buy_talent_terminal = {
            _name = "weapon_book_partner_buy_talent",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        local weapon_book_partner_reset_talent_terminal = {
            _name = "weapon_book_partner_reset_talent",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local costs = zstring.split(dms.string(dms["city_resource_hold_config"], 7, city_resource_hold_config.param), ",")
                if tonumber(_ED.city_resource_user_info.buyRobotCount) + 1 > #costs then
                    _ED.city_resource_user_info.buyRobotCount = #costs - 1
                end
                local cost = costs[tonumber(_ED.city_resource_user_info.buyRobotCount) + 1]
                if zstring.tonumber(cost) <= zstring.tonumber(_ED.user_info.user_gold) then
                    local tip = ConfirmTip:new()
                    local info = string.format(string_map_rattling_info[3], cost)
                    tip:init(instance, instance.sureResetTalent, info)
                    fwin:open(tip, fwin._windows)
                else
                    state_machine.excute("shortcut_open_function_dailog_cancel_and_ok", 0, 
                    {
                        terminal_name = "shortcut_open_recharge_window", 
                        terminal_state = 0, 
                        _msg = red_alert_all_str[185], 
                        _datas= 
                        {
                        }
                    })
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local weapon_book_partner_update_talent_terminal = {
            _name = "weapon_book_partner_update_talent",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local weapon_book_partner_update_active_partner_terminal = {
            _name = "weapon_book_partner_update_active_partner",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(weapon_book_partner_change_terminal)
        state_machine.add(weapon_book_partner_buy_talent_terminal)
        state_machine.add(weapon_book_partner_reset_talent_terminal)
        state_machine.add(weapon_book_partner_update_talent_terminal)
        state_machine.add(weapon_book_partner_update_active_partner_terminal)
        state_machine.init()
    end
    init_weapon_book_partner_terminal()
end

function WeaponBookPartner:sureResetTalent( sure_number )
    local function responseCallBack( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                response.node:onUpdateDraw()
            end
        end
    end
    -- if sure_number == 0 then
    --     NetworkManager:register(protocol_command.city_resource_hold_buy_robot_count.code, nil, nil, nil, self, responseCallBack, false, nil)      
    -- end
end

function WeaponBookPartner:updateInfo( ... )
    local root = self.roots[1]

    local Text_2 = ccui.Helper:seekWidgetByName(root, "Text_2")
    Text_2:setString("")
    local Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star")
    Panel_star:removeAllChildren(true)
    
end

function WeaponBookPartner:onUpdateDraw( ... )
    local root = self.roots[1]
    local ListView_hero_icon = ccui.Helper:seekWidgetByName(root, "ListView_hreo_icon")
    ListView_hero_icon:removeAllItems()
    local index = 1
    for i, ship in pairs(self.user_ships) do
        local cell = state_machine.excute("hero_icon_create_cell", 0, {ship, 13, index})
        index = index + 1
        ListView_hero_icon:addChild(cell)
    end
    ListView_hero_icon:requestRefreshView()
    self.listview = ListView_hero_icon
    self.listview_pox = ListView_hero_icon:getInnerContainer():getPositionX()

    self:setHeroCellSelected(self.ship)
    self:updateInfo()
end

function WeaponBookPartner:setHeroCellSelected(ship)
    for i, v in pairs(self.listview:getItems()) do 
        if v.ship == ship then
            v.isSelecet = true
            state_machine.excute("hero_icon_cell_set_seleceted", 0, v)
        else
            if v.isSelecet == true then
                v.isSelecet = false
                state_machine.excute("hero_icon_cell_set_seleceted", 0, v)
            end
        end
    end
end

function WeaponBookPartner:getSortForFight()
    local result = {}
    for i,v in pairs(_ED.user_ship) do
        table.insert(result,v)
    end
    local all_result = {}
    local in_formation = {}
    local in_raleship = {}
    local gold_ship = {} -- 6
    local red_ship = {}  -- 5
    local orange_ship = {} -- 4
    local purple_ship = {} -- 3
    local blue_ship = {} -- 2 
    local green_ship = {} -- 1
    local white_ship = {} -- 0
    local function sortShipFight( a, b )
        return tonumber(a.hero_fight) > tonumber(b.hero_fight)
    end
    table.sort(result, sortShipFight)

    for i,ship in pairs(result) do
        if zstring.tonumber(ship.formation_index) > 0 then
            -- table.insert(in_formation, ship)
        elseif zstring.tonumber(ship.little_partner_formation_index) > 0 then
        --     table.insert(in_raleship, ship)
        elseif zstring.tonumber(ship.ship_type) == 6 then
            table.insert(gold_ship, ship)
        elseif zstring.tonumber(ship.ship_type) == 5 then
            table.insert(red_ship, ship)
        elseif zstring.tonumber(ship.ship_type) == 4 then
            table.insert(orange_ship, ship)
        elseif zstring.tonumber(ship.ship_type) == 3 then
            table.insert(purple_ship, ship)
        elseif zstring.tonumber(ship.ship_type) == 2 then
            table.insert(blue_ship, ship)
        elseif zstring.tonumber(ship.ship_type) == 1 then
            table.insert(green_ship, ship)
        elseif zstring.tonumber(ship.ship_type) == 0 then
            table.insert(white_ship, ship)
        end
    end
    self.ship_numbers = 0
    -- for i,v in pairs(in_formation) do
    --    table.insert(all_result,v)
    -- end
    local formation_temp = {}
    local position_str = dms.string(dms["formation_mould"],tonumber(_ED.formetion[1]),formation_mould.position)
    position_str = zstring.split(position_str,",")
    for i,v in pairs(position_str) do
        if zstring.tonumber(_ED.formetion[i+1]) ~= 0 then
            table.insert(formation_temp,_ED.user_ship["".._ED.formetion[i+1]])
        end
    end

    local formation_temp_change_index = {}
    for i,v in pairs(formation_temp) do
        table.insert(formation_temp_change_index,formation_temp[#formation_temp-i+1])
    end

    for i,v in pairs(formation_temp_change_index) do
       table.insert(all_result,v)
    end
    
    for i,v in pairs(in_raleship) do
       table.insert(all_result,v)
    end

    for i,v in pairs(gold_ship) do
       table.insert(all_result,v)
    end
    for i,v in pairs(red_ship) do
       table.insert(all_result,v)
    end
    for i,v in pairs(orange_ship) do
       table.insert(all_result,v)
    end
    for i,v in pairs(purple_ship) do
       table.insert(all_result,v)
    end
    for i,v in pairs(green_ship) do
        table.insert(all_result,v)
    end  
    for i,v in pairs(blue_ship) do
       table.insert(all_result,v)
    end
    for i,v in pairs(white_ship) do
       table.insert(all_result,v)
    end
    return all_result
end

function WeaponBookPartner:onUpdate(dt)
    if self.listview ~= nil then
        local size = self.listview:getContentSize()
        local posx = self.listview:getInnerContainer():getPositionX()
        if self.listview_pox == posx then
            return
        end
        self.listview_pox = posx
        local items = self.listview:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempx = v:getPositionX() + posx
            if tempx + itemSize.width * 2 < 0 or tempx > size.width + itemSize.width * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function WeaponBookPartner:onInit( )
    local csbItem = csb.createNode(config_csb.weapon_book.weapon_book)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_back"), nil, 
    {
        terminal_name = "weapon_book_partner_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_decomposition_1"), nil, 
    {
        terminal_name = "weapon_book_partner_rule_window_open",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    self:onUpdateDraw()
end

function WeaponBookPartner:close()
end

function WeaponBookPartner:init(ship)
    self:onInit()
    return self
end

function WeaponBookPartner:onExit()
    state_machine.remove("weapon_book_partner_change")
    state_machine.remove("weapon_book_partner_buy_talent")
    state_machine.remove("weapon_book_partner_reset_talent")
    state_machine.remove("weapon_book_partner_update_talent")
    state_machine.remove("weapon_book_partner_update_active_partner")
end