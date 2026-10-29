-- ----------------------------------------------------------------------------------------------------
-- 说明：能量屋上阵选择界面
-------------------------------------------------------------------------------------------------------
SmUnionEnergyHouseSelect = class("SmUnionEnergyHouseSelectClass", Window)

local sm_union_energy_house_select_open_terminal = {
    _name = "sm_union_energy_house_select_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionEnergyHouseSelectClass")
        if nil == _homeWindow then
            local panel = SmUnionEnergyHouseSelect:new():init(params)
            fwin:open(panel,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_union_energy_house_select_close_terminal = {
    _name = "sm_union_energy_house_select_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionEnergyHouseSelectClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmUnionEnergyHouseSelectClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_union_energy_house_select_open_terminal)
state_machine.add(sm_union_energy_house_select_close_terminal)
state_machine.init()
    
function SmUnionEnergyHouseSelect:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.tSortedHeroes = {}
    -- app.load("client.l_digital.union.heaven.UnionHeaven")
    -- app.load("client.l_digital.union.heaven.SmUnionInstituteDonate")
    app.load("client.cells.utils.multiple_list_view_cell")
    app.load("client.l_digital.cells.union.union_energy_house_select_list_cell")
    local function init_sm_union_energy_house_select_terminal()
        -- 显示界面
        local sm_union_energy_house_select_display_terminal = {
            _name = "sm_union_energy_house_select_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionEnergyHouseSelectWindow = fwin:find("SmUnionEnergyHouseSelectClass")
                if SmUnionEnergyHouseSelectWindow ~= nil then
                    SmUnionEnergyHouseSelectWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_union_energy_house_select_hide_terminal = {
            _name = "sm_union_energy_house_select_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionEnergyHouseSelectWindow = fwin:find("SmUnionEnergyHouseSelectClass")
                if SmUnionEnergyHouseSelectWindow ~= nil then
                    SmUnionEnergyHouseSelectWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_union_energy_house_select_display_terminal)
        state_machine.add(sm_union_energy_house_select_hide_terminal)
        state_machine.init()
    end
    init_sm_union_energy_house_select_terminal()
end

function SmUnionEnergyHouseSelect:getSortedHeroes()
    local function fightingCapacity(a,b)
        local al = tonumber(a.hero_fight)
        local bl = tonumber(b.hero_fight)
        local result = false
        if al > bl then
            result = true
        end
        return result 
    end

    local tSortedHeroes = {}
    -- 上阵武将数组
    local arrBusyHeroes = {}
    -- 各星级武将数组
    local arrStarLevelHeroesWhite = {}--白
    local arrStarLevelHeroesGreen = {}--绿
    local arrStarLevelHeroesKohlrabiblue= {}--蓝
    local arrStarLevelHeroesPurple = {}--紫
    local arrStarLevelHeroesOrange = {}--橙
    local arrStarLevelHeroesRed = {}--红
    local arrStarLevelHeroesGold = {}--金
    local my_data = zstring.split(_ED.union_personal_energy_info,"|")
    for i, ship in pairs(_ED.user_ship) do
        local isSame = false
        if ship.ship_id ~= nil then
            for i=1, 8 do
                local shipData = zstring.split(my_data[2+i],",")
                if tonumber(shipData[3]) == tonumber(ship.ship_id) then
                    isSame = true 
                    break
                end
            end
            if isSame == false then
                if zstring.tonumber(ship.formation_index) > 0 or zstring.tonumber(ship.little_partner_formation_index) > 0 then
                    table.insert(arrBusyHeroes, ship)
                else
                    table.insert(arrStarLevelHeroesWhite, ship) 
                end
            end
        end
    end
    table.sort(arrBusyHeroes, fightingCapacity)
    table.sort(arrStarLevelHeroesWhite, fightingCapacity)
    for i=1, #arrBusyHeroes do
        table.insert(tSortedHeroes, arrBusyHeroes[i])
    end
    for i=1, #arrStarLevelHeroesWhite do
        table.insert(tSortedHeroes, arrStarLevelHeroesWhite[i])
    end
    return tSortedHeroes
end

function SmUnionEnergyHouseSelect:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local ListView_sm_xz = ccui.Helper:seekWidgetByName(root, "ListView_sm_xz")
    ListView_sm_xz:removeAllItems()
    local preMultipleCell = nil
    local multipleCell = nil
    for i,v in pairs(self.tSortedHeroes) do
        local cell = nil
        cell = unionEnergyHouseSelectListCell:createCell()
        cell:init(v, self.index)
        if multipleCell == nil then
            multipleCell = MultipleListViewCell:createCell()
            multipleCell:init(ListView_sm_xz, unionEnergyHouseSelectListCell.__size)
            ListView_sm_xz:addChild(multipleCell)
            multipleCell.prev = preMultipleCell
            if preMultipleCell ~= nil then
                preMultipleCell.next = multipleCell
            end
        end
        multipleCell:addNode(cell)
        if multipleCell.child2 ~= nil then
            preMultipleCell = multipleCell
            multipleCell = nil
        end
    end
end

function SmUnionEnergyHouseSelect:init(params)
    self.index = params
    self:onInit()
    return self
end

function SmUnionEnergyHouseSelect:onInit()
    local csbSmUnionEnergyHouseSelect = csb.createNode("legion/sm_legion_energy_house_select.csb")
    local root = csbSmUnionEnergyHouseSelect:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmUnionEnergyHouseSelect)

    self.tSortedHeroes = self:getSortedHeroes()
    self:onUpdateDraw()

    -- self:showImageAnimation()
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "sm_union_energy_house_select_close",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil,3)
    
end

function SmUnionEnergyHouseSelect:onExit()
    state_machine.remove("sm_union_energy_house_select_display")
    state_machine.remove("sm_union_energy_house_select_hide")
end