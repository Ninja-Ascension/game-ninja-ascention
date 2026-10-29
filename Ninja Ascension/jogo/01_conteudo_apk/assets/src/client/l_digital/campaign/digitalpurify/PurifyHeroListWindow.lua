-- ----------------------------------------------------------------------------------------------------
-- 说明：数码净化上阵武将选择
-------------------------------------------------------------------------------------------------------
PurifyHeroListWindow = class("PurifyHeroListWindowClass", Window)

local purify_hero_list_window_open_terminal = {
    _name = "purify_hero_list_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        fwin:open(PurifyHeroListWindow:new():init(params), fwin._ui)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local purify_hero_list_window_close_terminal = {
    _name = "purify_hero_list_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        fwin:close(fwin:find("PurifyHeroListWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(purify_hero_list_window_open_terminal)
state_machine.add(purify_hero_list_window_close_terminal)
state_machine.init()

function PurifyHeroListWindow:ctor()
    self.super:ctor()
    self.roots = {}

    -- load luf file
    app.load("client.l_digital.cells.campaign.digitalpurify.purify_player_hero_info_cell")

    -- var
    
    -- Initialize purify team page state machine.
    local function init_purify_help_terminal()

        state_machine.init()
    end
    
    -- call func init purify team state machine.
    init_purify_help_terminal()
end

function PurifyHeroListWindow:init( params )
    return self
end

function PurifyHeroListWindow:onUpdate(dt)
    if self.currentListView ~= nil and self.currentInnerContainer ~= nil then
        local size = self.currentListView:getContentSize()
        local posY = self.currentInnerContainer:getPositionY()
        if self.currentInnerContainerPosY == posY then
            return
        end
        self.currentInnerContainerPosY = posY
        local items = self.currentListView:getItems()
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

function PurifyHeroListWindow:getSortedHeroes()
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
    local arrStarLevelHeroesRead = {}--红
    local allSkill = {}--合击
    local relationship = {}--缘分
    -- 主角放在第一位
    for i, ship in pairs(_ED.user_ship) do
        if ship.ship_id ~= nil then
            table.insert(tSortedHeroes, ship)
        end
    end
    table.sort(tSortedHeroes, fightingCapacity)
    
    return tSortedHeroes
end


function PurifyHeroListWindow:onUpdateDraw()
    local root = self.roots[1]

    local ListView_digimon = ccui.Helper:seekWidgetByName(root, "ListView_digimon")
    ListView_digimon:removeAllItems()

    PurifyHeroListWindow._self = self
    PurifyHeroListWindow.myListView = ListView_digimon
    PurifyHeroListWindow.tSortedHeroes = self:getSortedHeroes()
    PurifyHeroListWindow.asyncIndex = 1
    app.load("client.cells.utils.multiple_list_view_cell")
    local preMultipleCell = nil
    local multipleCell = nil
    for i,v in pairs(PurifyHeroListWindow.tSortedHeroes) do
        local cell = PurifyPlayerHeroInfoCell:createCell()
        cell:init(i, v)
        table.insert(PurifyHeroListWindow._self.roots, cell.roots[1])
        if multipleCell == nil then
            multipleCell = MultipleListViewCell:createCell()
            multipleCell:init(ListView_digimon, PurifyPlayerHeroInfoCell.__size)
            ListView_digimon:addChild(multipleCell)
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

    ListView_digimon:requestRefreshView()

    self.currentListView = ListView_digimon
    self.currentInnerContainer = self.currentListView:getInnerContainer()
    self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
end

function PurifyHeroListWindow:onEnterTransitionFinish()
    local csbPurifyHeroListWindow = csb.createNode("campaign/DigitalPurify/digital_purify_change_window.csb")
    self:addChild(csbPurifyHeroListWindow)
    local root = csbPurifyHeroListWindow:getChildByName("root")
    table.insert(self.roots, root)

    -- 关闭窗口
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil, 
    {
        terminal_name = "purify_hero_list_window_close", 
        isPressedActionEnabled = true
    },
    nil,0)

    self:onUpdateDraw()
end

function PurifyHeroListWindow:onExit()

end
