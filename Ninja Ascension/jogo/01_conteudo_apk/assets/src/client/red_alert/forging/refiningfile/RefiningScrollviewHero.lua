-----------------------------
--分解滚动层 -英雄
-----------------------------
RefiningScrollviewHero = class("RefiningScrollviewHeroClass", Window)

local refining_scrollview_hero_window_open_terminal = {
    _name = "refining_scrollview_hero_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("RefiningScrollviewHeroClass")
        if nil == _Window then
            fwin:open(RefiningScrollviewHero:new():init(params))
        end  
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(refining_scrollview_hero_window_open_terminal)
state_machine.init()

function RefiningScrollviewHero:ctor()
    self.super:ctor()
    self.roots = {}
    self.prop_numbers = 0
    self.user_ships = {}

    self.scroll_view = nil
    self.scroll_view_poy = nil
    -- Initialize refining_scrollview_hero state machine.
    local function init_refining_scrollview_hero_terminal()
		--显示界面
		local refining_scrollview_hero_window_show_terminal = {
            _name = "refining_scrollview_hero_window_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		--隐藏界面
		local refining_scrollview_hero_window_hide_terminal = {
            _name = "refining_scrollview_hero_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
        --取消所有选中
        local refining_scrollview_hero_un_set_selected_terminal = {
            _name = "refining_scrollview_hero_un_set_selected",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:setUnSelecet()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 批量添加
        local refining_scrollview_hero_add_batch_terminal = {
            _name = "refining_scrollview_hero_add_batch",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("refining_scrollview_hero_un_set_selected",0,"")
                instance:addBatch(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 分解后重新绘制英雄
        local refining_scrollview_hero_updatedraw_all_terminal = {
            _name = "refining_scrollview_hero_updatedraw_all",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.user_ships = instance:getAllData() 
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(refining_scrollview_hero_window_show_terminal)	
		state_machine.add(refining_scrollview_hero_window_hide_terminal)
        state_machine.add(refining_scrollview_hero_un_set_selected_terminal)
        state_machine.add(refining_scrollview_hero_add_batch_terminal)
        state_machine.add(refining_scrollview_hero_updatedraw_all_terminal)
        state_machine.init()
    end
    
    -- call func init refining_scrollview_hero state machine.
    init_refining_scrollview_hero_terminal()
end

function RefiningScrollviewHero:onHide( ... )
    self:setVisible(false)
end

function RefiningScrollviewHero:onShow( ... )
    self:setVisible(true)
end

function RefiningScrollviewHero:addBatch(select_index_table)
    local select_table = {}
    for i,ship_data in pairs(self.user_ships) do
        for j,k in pairs(select_index_table) do
            if tonumber(ship_data.prop.ship_type) == k then
                table.insert(select_table,ship_data.prop.ship_id)
            end
        end
    end
    self:setAllSelecet(select_table)
    state_machine.excute("refining_add_batch_item",0,select_table)
end

function RefiningScrollviewHero:setAllSelecet(select_table)
    local root = self.roots[1]
    local ScrollView_packs = ccui.Helper:seekWidgetByName(root,"ScrollView_packs")
    for i,v in pairs(ScrollView_packs:getChildren()) do
        for j,k in pairs(select_table) do
            if v.prop ~= nil then
                if tonumber(v.prop.ship_id) == tonumber(k) then
                    v.selected = true
                    v:setSelected()
                end
            end
        end
    end
end

function RefiningScrollviewHero:setUnSelecet()
    local root = self.roots[1]
    local ScrollView_packs = ccui.Helper:seekWidgetByName(root,"ScrollView_packs")
    for i,v in pairs(ScrollView_packs:getChildren()) do
        if v.selected == true then
            v.selected = false
            v:setSelected()
        end
    end
end

function RefiningScrollviewHero:onUpdateDraw()
    local root = self.roots[1]
    local all_row = 0
    local all_col = 0
    local ScrollView_packs = ccui.Helper:seekWidgetByName(root,"ScrollView_packs")
    ScrollView_packs:removeAllChildren(true)
    local width = ScrollView_packs:getContentSize().width
    local height = ScrollView_packs:getContentSize().height
    local scroll_height = 0
    local index = 0
    local cell_temp = state_machine.excute("packs_icon_bg_create_cell",0,"")
    local cell_height = cell_temp:getContentSize().height
    for i = 1,10000 do
        local v = self.user_ships[i]
        index = index + 1
        local wight_n = 1
        local height_n = 1
        if i % 4 == 0 then
            wight_n = 4
        else
            wight_n = i % 4
        end
        if wight_n == 4 and v == nil and i >= 5*4 then
            break
        end
    end
    if index % 4 == 0 then
        scroll_height = index / 4
    else
        scroll_height = math.floor(index / 4) + 1
    end

    if scroll_height*cell_height > height then
        height = scroll_height*cell_height
    end  
    for i = 1,10000 do
        local v = self.user_ships[i]
        local wight_n = 1
        local height_n = 1
        if i % 4 == 0 then
            wight_n = 4
        else
            wight_n = i % 4
        end

        if i % 4 == 0 then
            height_n = i / 4
        else
            height_n = math.floor(i / 4) + 1
        end
        local cell = nil
        if v == nil then
            cell = state_machine.excute("packs_icon_bg_create_cell",0,"")
        else
            cell = state_machine.excute("all_resource_create_cell",0,{7,v.prop_data,v.prop,3,height_n})
        end
        cell:setAnchorPoint(cc.p(0,1))
        -- print("============",wight_n,height_n,(wight_n-1)*(width/4),height - (height_n-1)*92)
        cell:setPosition(cc.p((wight_n-1)*(width/4),height - (height_n-1)*cell_height))
        ScrollView_packs:addChild(cell)
        if wight_n == 4 and v == nil and i >= 5*4 then
            break
        end
    end

    ScrollView_packs:getInnerContainer():setContentSize(cc.size(width,height))
    ScrollView_packs:jumpToTop()

    self.scroll_view = ScrollView_packs
    self.scroll_view_poy = ScrollView_packs:getInnerContainer():getPositionY()
          
end

function RefiningScrollviewHero:onUpdate(dt) 
    if self.scroll_view ~= nil then
        local size = self.scroll_view:getContentSize()
        local posY = self.scroll_view:getInnerContainer():getPositionY()
        if self.scroll_view_poy == posY then
            return
        end
        self.scroll_view_poy = posY
        local items = self.scroll_view:getChildren()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function RefiningScrollviewHero:getAllData( ... )
    local user_ships = _ED.user_ship
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
    self.prop_numbers = 0

    local function sortShipFight( a, b )
        return tonumber(a.hero_fight) > tonumber(b.hero_fight)
    end
    table.sort(user_ships, sortShipFight)
    local canRefiningUnionShips = {}
    if _ED.union.union_info ~= nil 
        and _ED.union.union_info.union_id ~= nil 
        and zstring.tonumber(_ED.union.union_info.union_id) > 0 
        and _ED.union.user_union_info.team_fight_use_ships ~= "" then
        canRefiningUnionShips = zstring.split(_ED.union.user_union_info.team_fight_use_ships, ",")
    end
    for i,ship in pairs(user_ships) do
        local ship_mould_id = tonumber(ship.ship_template_id)
        local base_mould_id = dms.int(dms["ship_mould"],ship_mould_id,ship_mould.base_mould)
        local base_god_mould_id = dms.int(dms["ship_mould"],base_mould_id,ship_mould.advanced_ship_mould)
        local lightedStar = false
        for j,k in pairs(ship.stars_state) do
            if tonumber(k.state) == 1 then
                lightedStar = true
            end
        end
        local isInUnionTeam = false
        for k1,v1 in pairs(canRefiningUnionShips) do
            if tonumber(ship.ship_id) == tonumber(v1) then
                isInUnionTeam = true
            end
        end
        if isInUnionTeam == true then
        -- debug.print_r(ship)
        elseif zstring.tonumber(ship.formation_index) > 0 then
            -- table.insert(in_formation, ship)
        elseif zstring.tonumber(ship.little_partner_formation_index) > 0 then
            -- table.insert(in_raleship, ship)
        elseif (ship_mould_id == base_mould_id and lightedStar == true) 
            or (ship_mould_id ~= base_mould_id and tonumber(ship.god_weaponry) <= 0) 
            or (tonumber(ship.god_weaponry) > 0 and base_god_mould_id ~= ship_mould_id) then

        elseif nil ~= ship.skill_grow_up_level and ship.skill_grow_up_level > 0 then

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
    for i,v in pairs(blue_ship) do
       table.insert(all_result,v)
    end
    for i,v in pairs(green_ship) do
        table.insert(all_result,v)
    end      
    for i,v in pairs(white_ship) do
       table.insert(all_result,v)
    end

    local sort_table = {}
    for i,ship in pairs(all_result) do
        local data = 
        {
            prop_data = 
            {
                item_value = 1,
                prop_type = 13,
                prop_item = ship.ship_template_id,
            },
            prop = ship ,
        }
        self.prop_numbers = self.prop_numbers + 1
        table.insert(sort_table,data)
    end
    return sort_table
end

function RefiningScrollviewHero:onEnterTransitionFinish()

end

function RefiningScrollviewHero:onInit( )
    local csbItem = csb.createNode(config_csb.forging.forging_scrollview)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)
	self:onUpdateDraw()	
end

function RefiningScrollviewHero:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow  
    self.user_ships = self:getAllData()
	self:onInit()
    return self
end

function RefiningScrollviewHero:onExit()
    state_machine.remove("refining_scrollview_hero_window_show")    
    state_machine.remove("refining_scrollview_hero_window_hide")
    state_machine.remove("refining_scrollview_hero_un_set_selected")
    state_machine.remove("refining_scrollview_hero_add_batch")
    state_machine.remove("refining_scrollview_hero_updatedraw_all")
end
