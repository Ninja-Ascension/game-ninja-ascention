-----------------------------
--传承原侠客选择界面
-----------------------------
InheritLeftPack = class("InheritLeftPackClass", Window)

local inherit_left_pack_window_open_terminal = {
    _name = "inherit_left_pack_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("InheritLeftPackClass")
        if nil == _Window then
            fwin:open(InheritLeftPack:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local inherit_left_pack_window_close_terminal = {
    _name = "inherit_left_pack_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("InheritLeftPackClass"))  
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(inherit_left_pack_window_open_terminal)
state_machine.add(inherit_left_pack_window_close_terminal)
state_machine.init()

function InheritLeftPack:ctor()
    self.super:ctor()
    self.roots = {}

    self._choose_ship = nil

    local function init_inherit_left_pack_terminal()
        local inherit_left_pack_choose_terminal = {
            _name = "inherit_left_pack_choose",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("inherit_choose_left",0,instance._choose_ship)
                state_machine.excute("inherit_left_pack_window_close", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local inherit_left_pack_choose_ship_terminal = {
            _name = "inherit_left_pack_choose_ship",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance._choose_ship = params
                instance:changeSelected(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        state_machine.add(inherit_left_pack_choose_terminal)
        state_machine.add(inherit_left_pack_choose_ship_terminal)
        state_machine.init()
    end
    init_inherit_left_pack_terminal()
end

function InheritLeftPack:changeSelected( ship )
    local root = self.roots[1]
    local ListView_hero = ccui.Helper:seekWidgetByName(root,"ListView_hero")
    for i,v in pairs(ListView_hero:getItems()) do 
        if v.ship == ship then
            v.isSelecet = true
            state_machine.excute("hero_icon_cell_set_seleceted",0,v)
        else
            if v.isSelecet == true then
                v.isSelecet = false
                state_machine.excute("hero_icon_cell_set_seleceted",0,v)
            end
        end
    end
end

function InheritLeftPack:onUpdateDraw(params)
    local root = self.roots[1]
    local ListView_hero = ccui.Helper:seekWidgetByName(root,"ListView_hero")
    ListView_hero:removeAllItems()
    for k,v in pairs(self:getShips()) do
        local cell = state_machine.excute("hero_icon_create_cell",0,{v,14,1})
        if params ~= nil and tonumber(params.ship_id) == tonumber(v.ship_id) then
            cell.isSelecet = true
            state_machine.excute("hero_icon_cell_set_seleceted", 0, cell)
        end
        ListView_hero:addChild(cell)
    end
end

function InheritLeftPack:onInit( params )
    local csbItem = csb.createNode(config_csb.forging.inherit_packs_1)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hero_packs_close"), nil, 
    {
        terminal_name = "inherit_left_pack_choose",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    self:onUpdateDraw(params)
end

function InheritLeftPack:init(params) 
    self:onInit(params)
    return self
end

function InheritLeftPack:getShips()
    local result = {}
    local use_ships = {}
    if _ED.union.union_info ~= nil 
        and _ED.union.union_info.union_id ~= nil 
        and zstring.tonumber(_ED.union.union_info.union_id) > 0 
        and _ED.union.user_union_info.team_fight_use_ships ~= "" then
        use_ships = zstring.split(_ED.union.user_union_info.team_fight_use_ships, ",")
    end
    local growUpLevel = dms.int(dms["ship_config"], 1, ship_config.info)
    for i,ship in pairs(_ED.user_ship) do
        if zstring.tonumber(ship.formation_index) == 0
            and zstring.tonumber(ship.little_partner_formation_index) == 0
            and zstring.tonumber(ship.skill_grow_up_level) >= growUpLevel
            -- and (ship.current_hp == 0 or tonumber(ship.current_hp) >= tonumber(ship.ship_health))
            then
            local isSame = false
            for k1,v1 in pairs(use_ships) do
                if tonumber(ship.ship_id) == tonumber(v1) then
                    isSame = true
                end
            end
            if isSame == false then
                table.insert(result, ship)
            end
        end
    end
    return result
end

function InheritLeftPack:onExit()
    state_machine.remove("inherit_left_pack_choose")
    state_machine.remove("inherit_left_pack_choose_ship")
end
