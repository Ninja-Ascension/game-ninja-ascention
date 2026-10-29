-----------------------------
-- 选择传功侠客界面
-----------------------------
InheritRightPack = class("InheritRightPackClass", Window)

local inherit_right_pack_window_open_terminal = {
    _name = "inherit_right_pack_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("InheritRightPackClass")
        if nil == _Window then
            fwin:open(InheritRightPack:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local inherit_right_pack_window_close_terminal = {
    _name = "inherit_right_pack_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("InheritRightPackClass"))  
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(inherit_right_pack_window_open_terminal)
state_machine.add(inherit_right_pack_window_close_terminal)
state_machine.init()

function InheritRightPack:ctor()
    self.super:ctor()
    self.roots = {}

    self._choose_ship = nil
    self.all_cells = {}

    local function init_inherit_right_pack_terminal()
        local inherit_right_pack_choose_terminal = {
            _name = "inherit_right_pack_choose",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("inherit_choose_right",0,instance._choose_ship)
                state_machine.excute("inherit_right_pack_window_close", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local inherit_right_pack_choose_ship_terminal = {
            _name = "inherit_right_pack_choose_ship",
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

        state_machine.add(inherit_right_pack_choose_terminal)
        state_machine.add(inherit_right_pack_choose_ship_terminal)
        state_machine.init()
    end
    init_inherit_right_pack_terminal()
end

function InheritRightPack:changeSelected( ship )
    local root = self.roots[1]
    for i,v in pairs(self.all_cells) do 
        if tonumber(v.ship) == tonumber(ship) then
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

function InheritRightPack:onUpdateDraw(params)
    local root = self.roots[1]
    local ScrollView_hero = ccui.Helper:seekWidgetByName(root, "ScrollView_hero")
    ScrollView_hero:removeAllChildren(true)
    local leftShip = params[1]
    local rightShip = params[2]
    local info = zstring.split(dms.string(dms["ship_config"], 3, ship_config.info), "|")
    local show_info = {}
    for k,v in pairs(info) do
        local ships = zstring.split(v, ",")
        for index, shipId in pairs(ships) do
            if tonumber(shipId) == tonumber(leftShip.ship_base_template_id) then
                show_info = ships
                break
            end
        end
    end

    local col_numbers = 5
    local width = ScrollView_hero:getContentSize().width
    local height = ScrollView_hero:getContentSize().height
    local index = 0
    for i,v in pairs(show_info) do
        if tonumber(v) ~= tonumber(leftShip.ship_base_template_id) then
            index = index + 1
            local wight_n = 1
            local height_n = 1
            if index % col_numbers == 0 then
                wight_n = col_numbers
            else
                wight_n = index % col_numbers
            end

            if index % col_numbers == 0 then
                height_n = index / col_numbers
            else
                height_n = math.floor(index / col_numbers) + 1
            end
            local cell = state_machine.excute("hero_icon_create_cell",0,{v,15,1})
            if rightShip ~= nil and tonumber(rightShip) == tonumber(v) then
                cell.isSelecet = true
                state_machine.excute("hero_icon_cell_set_seleceted",0,cell)
            end
            cell:setAnchorPoint(cc.p(0,1))
            cell:setPosition(cc.p((wight_n-1)*(width/col_numbers), height - (height_n-1)*105))
            ScrollView_hero:addChild(cell)

            table.insert(self.all_cells, cell)
        end
    end
    ScrollView_hero:getInnerContainer():setContentSize(cc.size(width, height))
    ScrollView_hero:jumpToTop()
end

function InheritRightPack:onInit( params )
    local csbItem = csb.createNode(config_csb.forging.inherit_packs_2)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hero_packs_close"), nil, 
    {
        terminal_name = "inherit_right_pack_choose",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    self:onUpdateDraw(params)
end

function InheritRightPack:init(params) 
    self:onInit(params)
    return self
end

function InheritRightPack:onExit()
    state_machine.remove("inherit_right_pack_choose")
    state_machine.remove("inherit_right_pack_choose_ship")
end
