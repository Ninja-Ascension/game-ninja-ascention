-----------------------------
-- 试炼BUFF选择数码兽的界面
-----------------------------
SmTrialTowerBuffSelectWindow = class("SmTrialTowerBuffSelectWindowClass", Window)

--打开界面
local sm_trial_tower_buff_select_window_open_terminal = {
	_name = "sm_trial_tower_buff_select_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("SmTrialTowerBuffSelectWindowClass") == nil then
			fwin:open(SmTrialTowerBuffSelectWindow:new():init(params), fwin._windows)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local sm_trial_tower_buff_select_window_close_terminal = {
	_name = "sm_trial_tower_buff_select_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmTrialTowerBuffSelectWindowClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_trial_tower_buff_select_window_open_terminal)
state_machine.add(sm_trial_tower_buff_select_window_close_terminal)
state_machine.init()

function SmTrialTowerBuffSelectWindow:ctor()
	self.super:ctor()
	self.roots = {}
	app.load("client.l_digital.cells.campaign.sm_trial_tower_change_window_list_cell")
    local function init_sm_trial_tower_buff_select_window_terminal()
        --
        local sm_trial_tower_buff_select_add_ship_buff_terminal = {
            _name = "sm_trial_tower_buff_select_add_ship_buff",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("sm_trial_tower_Addition_select_set_up_ship", 0, {instance.pages,params})
                state_machine.excute("sm_trial_tower_buff_select_window_close", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_trial_tower_buff_select_add_ship_buff_terminal)

        state_machine.init()
    end
    init_sm_trial_tower_buff_select_window_terminal()
end

function SmTrialTowerBuffSelectWindow:onUpdate(dt)
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

function SmTrialTowerBuffSelectWindow:getSortedHeroes()
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

--加血列表
function SmTrialTowerBuffSelectWindow:getAddHpSortedHeroes()
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

    for i,v in pairs(_ED.user_try_ship_infos) do
        if tonumber(v.maxHp) ~= 100 and tonumber(v.maxHp) > 0 then
            if tonumber(_ED.user_ship[""..v.id].ship_grade) >= 10 then
                table.insert(tSortedHeroes, _ED.user_ship[""..v.id])
            end
        end
    end
    table.sort(tSortedHeroes, fightingCapacity)

    return tSortedHeroes
end

--复活列表
function SmTrialTowerBuffSelectWindow:getResurrectionSortedHeroes()
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

    for i,v in pairs(_ED.user_try_ship_infos) do
        if tonumber(v.maxHp) == 0 then
            if tonumber(_ED.user_ship[""..v.id].ship_grade) >= 10 then
                table.insert(tSortedHeroes, _ED.user_ship[""..v.id])
            end
        end
    end
    table.sort(tSortedHeroes, fightingCapacity)
    
    return tSortedHeroes
end

--加怒气列表
function SmTrialTowerBuffSelectWindow:getAddMpSortedHeroes()
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
    local fightParams = zstring.split(dms.string(dms["fight_config"], 5 ,user_config.param),",")
    for i,v in pairs(_ED.user_try_ship_infos) do
        if tonumber(v.newanger) < tonumber(fightParams[4]) then
            if tonumber(_ED.user_ship[""..v.id].ship_grade) >= 10 then
                table.insert(tSortedHeroes, _ED.user_ship[""..v.id])
            end
        end
    end
    table.sort(tSortedHeroes, fightingCapacity)
    
    return tSortedHeroes
end

function SmTrialTowerBuffSelectWindow:updateDraw()
	local root = self.roots[1]
	local ListView_digimon = ccui.Helper:seekWidgetByName(root, "ListView_digimon")
    ListView_digimon:removeAllItems()

    SmTrialTowerBuffSelectWindow._self = self
    SmTrialTowerBuffSelectWindow.myListView = ListView_digimon
    SmTrialTowerBuffSelectWindow.tSortedHeroes = self:getSortedHeroes()
    local list = zstring.split( dms.string(dms["three_kingdoms_attribute"], self.pages.attribute_id, three_kingdoms_attribute.attribute_value),",")
    
    if tonumber(list[1])== 4 then
        --加血
        SmTrialTowerBuffSelectWindow.tSortedHeroes = self:getAddHpSortedHeroes()
    elseif tonumber(list[1])== 41 then
        --加怒
        SmTrialTowerBuffSelectWindow.tSortedHeroes = self:getAddMpSortedHeroes()
    elseif tonumber(list[1])== 999 then
        --复活
        SmTrialTowerBuffSelectWindow.tSortedHeroes = self:getResurrectionSortedHeroes()
    end
    SmTrialTowerBuffSelectWindow.asyncIndex = 1
    app.load("client.cells.utils.multiple_list_view_cell")
    local preMultipleCell = nil
    local multipleCell = nil
    for i,v in pairs(SmTrialTowerBuffSelectWindow.tSortedHeroes) do
        local cell = state_machine.excute("sm_trial_tower_change_window_list_cell",0,{i,v,0,list[1]})
        table.insert(SmTrialTowerBuffSelectWindow._self.roots, cell.roots[1])
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

function SmTrialTowerBuffSelectWindow:init(params)
    self.pages = params
	self:onInit()
    return self
end

function SmTrialTowerBuffSelectWindow:onInit()
    local csbItem = csb.createNode("campaign/TrialTower/sm_trial_tower_change_window.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

	--关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "sm_trial_tower_buff_select_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
	
	self:updateDraw()
end

function SmTrialTowerBuffSelectWindow:onEnterTransitionFinish()
    
end


function SmTrialTowerBuffSelectWindow:onExit()

end

