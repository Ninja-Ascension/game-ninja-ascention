-----------------------------
-- 结伴江湖选择援军
-----------------------------
UnionTeamFightCreate = class("UnionTeamFightCreateClass", Window)

local union_team_fight_create_window_open_terminal = {
    _name = "union_team_fight_create_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:open(UnionTeamFightCreate:new():init(params), fwin._view)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
--关闭
local union_team_fight_create_window_close_terminal = {
    _name = "union_team_fight_create_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("UnionTeamFightCreateClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(union_team_fight_create_window_open_terminal)
state_machine.add(union_team_fight_create_window_close_terminal)
state_machine.init()

function UnionTeamFightCreate:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self._team_info = nil
    self.user_ships = nil
    self.chooseShips = {}

    self.listview = nil
    self.listview_pox = 0

    app.load("client.red_alert.cells.hero.hero_icon_cell")

    local function init_union_team_fight_create_terminal()
        --创建队伍
        local union_team_fight_create_team_ok_terminal = {
            _name = "union_team_fight_create_team_ok",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local info = ""
                local index = 0
                for k,v in pairs(instance.chooseShips) do
                    index = index + 1
                    if index == 1 then
                        info = v.ship_id
                    else
                        info = info .. "," .. v.ship_id
                    end
                end
                if index < dms.int(dms["union_config"], 20, union_config.param) then
                    TipDlg.drawTextDailog(tipStringInfo_union_str[26])
                    return
                end
                if instance._team_info == nil then
                    local inf = 1
                    local function recruitCallBack( response )
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            state_machine.excute("union_team_fight_create_window_close", 0, nil)
                            state_machine.excute("union_team_fight_update", 0, nil)
                        end
                    end
                    protocol_command.union_endless_create_group.param_list = _ED.union.user_union_info.union_id.."\r\n"..info
                    NetworkManager:register(protocol_command.union_endless_create_group.code, nil, nil, nil, instance, recruitCallBack, false, nil)           
                else
                    local function recruitCallBack( response )
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            state_machine.excute("union_team_fight_create_window_close", 0, nil)
                            state_machine.excute("union_team_fight_update", 0, nil)
                        end
                    end
                    protocol_command.union_endless_join_group.param_list = _ED.union.user_union_info.union_id.."\r\n"..info.."\r\n"..instance._team_info.team_id
                    NetworkManager:register(protocol_command.union_endless_join_group.code, nil, nil, nil, instance, recruitCallBack, false, nil)           
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --选择援军
        local union_team_fight_create_choose_hero_terminal = {
            _name = "union_team_fight_create_choose_hero",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:chooseHero(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(union_team_fight_create_team_ok_terminal)
        state_machine.add(union_team_fight_create_choose_hero_terminal)
        state_machine.init()
    end

    init_union_team_fight_create_terminal()
end 

function UnionTeamFightCreate:chooseHero( ship )
    local isRemove = false
    local chooseCell = nil
    for i, v in pairs(self.listview:getItems()) do 
        if v.ship == ship then
            if v.isSelecet == true then
                isRemove = true
            end
            chooseCell = v
        end
    end
    if isRemove == true then
        chooseCell.isSelecet = false
        chooseCell.is_information = false
        state_machine.excute("hero_icon_cell_set_seleceted", 0, chooseCell)
        self.chooseShips[""..ship.ship_id] = nil
    else
        local count = 0
        for k,v in pairs(self.chooseShips) do
            if v ~= nil then
                count = count + 1
            end
        end
        if count >= dms.int(dms["union_config"], 20, union_config.param) then
            TipDlg.drawTextDailog(tipStringInfo_union_str[27])
            return
        end
        chooseCell.isSelecet = true
        state_machine.excute("hero_icon_cell_set_seleceted", 0, chooseCell)
        self.chooseShips[""..ship.ship_id] = ship
        chooseCell.is_information = true
    end
    self:setCellState( ship, isRemove )
    chooseCell:setIsInformation()
end

function UnionTeamFightCreate:setCellState( ship, isEnabled )
    local items = self.listview:getItems()
    for k,v in pairs(items) do
        if tonumber(v.ship.ship_id) ~= tonumber(ship.ship_id)
            and tonumber(v.ship.ship_base_template_id) == tonumber(ship.ship_base_template_id)
            then
            state_machine.excute("hero_icon_cell_set_enabled_state", 0, {v, not isEnabled})
        end
    end
end

function UnionTeamFightCreate:onUpdateDraw( ... )
    local root = self.roots[1]
    local ListView_hero_header = ccui.Helper:seekWidgetByName(root, "ListView_hero_header")
    ListView_hero_header:removeAllItems()

    local index = 1
    for i, ship in pairs(self.user_ships) do
        local cell = state_machine.excute("hero_icon_create_cell", 0, {ship, 9, index})
        index = index + 1
        ListView_hero_header:addChild(cell)
    end
    ListView_hero_header:requestRefreshView()
    self.listview = ListView_hero_header
    self.listview_pox = ListView_hero_header:getInnerContainer():getPositionX()

    ListView_hero_header:requestRefreshView()
end

function UnionTeamFightCreate:onUpdate(dt)
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

function UnionTeamFightCreate:onInit( )
    local csbItem = csb.createNode(config_csb.legion.legion_team_challenge_sent_hero)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    --关闭界面
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "union_team_fight_create_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_make_sure"), nil, 
    {
        terminal_name = "union_team_fight_create_team_ok",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0) 

    self:onUpdateDraw()
end

function UnionTeamFightCreate:getSortForFight()
    local result = {}
    local use_ships = {}
    if _ED.union.user_union_info.team_fight_use_ships ~= "" then
        use_ships = zstring.split(_ED.union.user_union_info.team_fight_use_ships, ",")
    end
    for i,v in pairs(_ED.user_ship) do
        local isSame = false
        for k1,v1 in pairs(use_ships) do
            if tonumber(v.ship_id) == tonumber(v1) then
                isSame = true
            end
        end
        if isSame == false then
            table.insert(result, v)
        end
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
            table.insert(in_formation, ship)
        elseif zstring.tonumber(ship.little_partner_formation_index) > 0 then
            table.insert(in_raleship, ship)
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
    for i,v in pairs(in_formation) do
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

function UnionTeamFightCreate:init(params)
    self._team_info = params
    self.user_ships = self:getSortForFight()
	self:onInit()
    return self
end

function UnionTeamFightCreate:onExit()  
    state_machine.remove("union_team_fight_create_team_ok")
    state_machine.remove("union_team_fight_create_choose_hero")
end