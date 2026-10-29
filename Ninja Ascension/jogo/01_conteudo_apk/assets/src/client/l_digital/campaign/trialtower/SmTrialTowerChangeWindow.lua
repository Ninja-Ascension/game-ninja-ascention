-----------------------------
-- 试炼数码兽上阵的界面
-----------------------------
SmTrialTowerChangeWindow = class("SmTrialTowerChangeWindowClass", Window)

--打开界面
local sm_trial_tower_change_window_open_terminal = {
	_name = "sm_trial_tower_change_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("SmTrialTowerChangeWindowClass") == nil then
			fwin:open(SmTrialTowerChangeWindow:new():init(params), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local sm_trial_tower_change_window_close_terminal = {
	_name = "sm_trial_tower_change_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmTrialTowerChangeWindowClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_trial_tower_change_window_open_terminal)
state_machine.add(sm_trial_tower_change_window_close_terminal)
state_machine.init()

function SmTrialTowerChangeWindow:ctor()
	self.super:ctor()
	self.roots = {}
	app.load("client.l_digital.cells.campaign.sm_trial_tower_change_window_list_cell")
    local function init_sm_trial_tower_change_window_terminal()
        --
        local sm_ranking_union_view_the_first_place_terminal = {
            _name = "sm_ranking_union_view_the_first_place",
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

        state_machine.add(sm_ranking_union_view_the_first_place_terminal)

        state_machine.init()
    end
    init_sm_trial_tower_change_window_terminal()
end

function SmTrialTowerChangeWindow:onUpdate(dt)
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

function SmTrialTowerChangeWindow:getSortedHeroes()
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

    local arrAliveHeroes = {}  -- 存活
    local arrDeadHeros = {} -- 阵亡
    local arrIncorrectHeros = {} -- 不符合条件的
    
    for i, ship in pairs(_ED.user_ship) do
        if ship.ship_id ~= nil then
            local shipInfo = _ED.user_try_ship_infos["" .. ship.ship_id]
            if tonumber(ship.ship_grade) < dms.int(dms["play_config"], 24, play_config.param) then
                table.insert(arrIncorrectHeros, ship)
            else
                if nil ~= shipInfo and tonumber(shipInfo.newHp) <= 0 then
                    table.insert(arrDeadHeros, ship)
                else
                    table.insert(arrAliveHeroes, ship)
                end
            end
        end
    end
    table.sort(arrAliveHeroes, fightingCapacity)
    table.sort(arrDeadHeros, fightingCapacity)
    table.sort(arrIncorrectHeros, fightingCapacity)
    local temp_table = {arrAliveHeroes, arrDeadHeros, arrIncorrectHeros}
    for i, v in ipairs(temp_table) do
        if v then
            for k, item in ipairs(v) do
                if item then
                    table.insert(tSortedHeroes, item)
                end
            end
        end
    end
    
    return tSortedHeroes
end

function SmTrialTowerChangeWindow:updateDraw()
	local root = self.roots[1]
	local ListView_digimon = ccui.Helper:seekWidgetByName(root, "ListView_digimon")
    ListView_digimon:removeAllItems()

    SmTrialTowerChangeWindow._self = self
    SmTrialTowerChangeWindow.myListView = ListView_digimon
    SmTrialTowerChangeWindow.tSortedHeroes = self:getSortedHeroes()
    SmTrialTowerChangeWindow.asyncIndex = 1
    app.load("client.cells.utils.multiple_list_view_cell")
    local preMultipleCell = nil
    local multipleCell = nil
    for i,v in pairs(SmTrialTowerChangeWindow.tSortedHeroes) do
        local cell = state_machine.excute("sm_trial_tower_change_window_list_cell",0,{i,v,self.pages})
        table.insert(SmTrialTowerChangeWindow._self.roots, cell.roots[1])
        if multipleCell == nil then
            multipleCell = MultipleListViewCell:createCell()
            multipleCell:init(ListView_digimon, SmTrialTowerChangeWindowListCell.__size)
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

function SmTrialTowerChangeWindow:init(params)
    self.pages = params
	self:onInit()
    return self
end

function SmTrialTowerChangeWindow:onInit()
    local csbItem = csb.createNode("campaign/TrialTower/sm_trial_tower_change_window.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

	--关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "sm_trial_tower_change_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
	self:updateDraw()
end

function SmTrialTowerChangeWindow:onEnterTransitionFinish()
    
end


function SmTrialTowerChangeWindow:onExit()
    state_machine.remove("sm_trial_tower_change_window_change_page")
	state_machine.remove("sm_trial_tower_change_window_open_rank")
end

