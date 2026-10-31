-----------------------------
--武将包裹全部
-----------------------------
HeroPacksScrollviewBack = class("HeroPacksScrollviewBackClass", Window)



local hero_packs_scrollview_back_window_open_terminal = {
    _name = "hero_packs_scrollview_back_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("HeroPacksScrollviewBackClass")
        if nil == _Window then
            fwin:open(HeroPacksScrollviewBack:new():init(params))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local hero_packs_scrollview_back_window_close_terminal = {
    _name = "hero_packs_scrollview_back_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("HeroPacksScrollviewBackClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(hero_packs_scrollview_back_window_open_terminal)
state_machine.add(hero_packs_scrollview_back_window_close_terminal)
state_machine.init()

function HeroPacksScrollviewBack:ctor()
    self.super:ctor()
    self.roots = {}
    self.user_ships = {}
    self.ship_numbers = 0

	self.draw_type = 0
	
    -- load lua file
    app.load("client.red_alert_time.cells.hero.hero_packs_icon_cell")
    
    -- Initialize hero_packs_scrollview_back state machine.
    local function init_hero_packs_scrollview_back_terminal()
	
		--显示界面
		local hero_packs_scrollview_back_window_show_terminal = {
            _name = "hero_packs_scrollview_back_window_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onShow()
                state_machine.excute("hero_packs_updatedraw_hero_numbers",0,instance.ship_numbers)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		--隐藏界面
		local hero_packs_scrollview_back_window_hide_terminal = {
            _name = "hero_packs_scrollview_back_window_hide",
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
  

		state_machine.add(hero_packs_scrollview_back_window_show_terminal)	
		state_machine.add(hero_packs_scrollview_back_window_hide_terminal)
        state_machine.init()
    end
    
    -- cback func init hom state machine.
    init_hero_packs_scrollview_back_terminal()
end

function HeroPacksScrollviewBack:onHide( ... )
    self:setVisible(false)
end

function HeroPacksScrollviewBack:onShow( ... )
    self:setVisible(true)
end

function HeroPacksScrollviewBack:onUpdateDraw()
    local root = self.roots[1]
    local col_numbers = 5 --每列多少个
    local ScrollView_hero_packs = ccui.Helper:seekWidgetByName(root,"ScrollView_hero_packs")
    ScrollView_hero_packs:removeAllChildren(true)
    local width = ScrollView_hero_packs:getContentSize().width
    local height = ScrollView_hero_packs:getContentSize().height
    local scroll_height = 0
    if self.ship_numbers % col_numbers == 0 then
        scroll_height = self.ship_numbers / col_numbers
    else
        scroll_height = math.floor(self.ship_numbers / col_numbers) + 1
    end 
    if scroll_height*120 > height then
        height = scroll_height*120
    end
    for i,ship in pairs(self.user_ships) do
        
        local wight_n = 1
        local height_n = 1
        if i % col_numbers == 0 then
            wight_n = col_numbers
        else
            wight_n = i % col_numbers
        end

        if i % col_numbers == 0 then
            height_n = i / col_numbers
        else
            height_n = math.floor(i / col_numbers) + 1
        end  
        local cell = state_machine.excute("hero_packs_icon_create_cell",0,{ship,1,height_n,self.draw_type})
        cell:setAnchorPoint(cc.p(0,1))
        cell:setPosition(cc.p((wight_n-1)*(width/col_numbers),height - (height_n-1)*120))
        ScrollView_hero_packs:addChild(cell)
    end 
    ScrollView_hero_packs:getInnerContainer():setContentSize(cc.size(width,height))
    ScrollView_hero_packs:jumpToTop()

    self.scroll_view = ScrollView_hero_packs
    self.scroll_view_poy = ScrollView_hero_packs:getInnerContainer():getPositionY()      
end

function HeroPacksScrollviewBack:onEnterTransitionFinish()

end

function HeroPacksScrollviewBack:onUpdate(dt) 
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

function HeroPacksScrollviewBack:getSortShips( ... )
    self.ship_numbers = 0
    self.user_ships = _ED.user_ship
    local back_result = {}
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
    table.sort(self.user_ships, sortShipFight)
    for i,ship in pairs(self.user_ships) do
        -- debug.print_r(ship)
        if tonumber(ship.capacity) > 6 then
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
    end
    for i,v in pairs(in_formation) do
       table.insert(back_result,v)
       self.ship_numbers = self.ship_numbers + 1
    end
    for i,v in pairs(in_raleship) do
       table.insert(back_result,v)
       self.ship_numbers = self.ship_numbers + 1
    end
    for i,v in pairs(gold_ship) do
       table.insert(back_result,v)
       self.ship_numbers = self.ship_numbers + 1
    end
    for i,v in pairs(red_ship) do
       table.insert(back_result,v)
       self.ship_numbers = self.ship_numbers + 1
    end
    for i,v in pairs(orange_ship) do
       table.insert(back_result,v)
       self.ship_numbers = self.ship_numbers + 1
    end
    for i,v in pairs(purple_ship) do
       table.insert(back_result,v)
       self.ship_numbers = self.ship_numbers + 1
    end
    for i,v in pairs(blue_ship) do
       table.insert(back_result,v)
       self.ship_numbers = self.ship_numbers + 1
    end
    for i,v in pairs(green_ship) do
        table.insert(back_result,v)
        self.ship_numbers = self.ship_numbers + 1        
    end      
    for i,v in pairs(white_ship) do
       table.insert(back_result,v)
       self.ship_numbers = self.ship_numbers + 1
    end
    self.user_ships = back_result
end

function HeroPacksScrollviewBack:onInit( )
    local csbItem = csb.createNode(config_csb.packs.herostorage.hero_packs_scrollview)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)
    self:getSortShips()
	self:onUpdateDraw()	
end

function HeroPacksScrollviewBack:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow  
	if params[2]~= nil and params[2]~= "" then
		self.draw_type = params[2]
	end
    self:onInit()
    return self
end

function HeroPacksScrollviewBack:onExit()
    state_machine.remove("hero_packs_scrollview_back_window_show")   
    state_machine.remove("hero_packs_scrollview_back_window_hide")
end
