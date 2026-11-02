-- ----------------------------------------------------------------------------------------------------
-- 说明：探索积分
-------------------------------------------------------------------------------------------------------
ExplorationScore = class("ExplorationScoreClass", Window)

local exploration_score_window_open_terminal = {
    _name = "exploration_score_open_box_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("ExplorationScoreClass") == nil then
            fwin:open(ExplorationScore:new():init(params), fwin._view)
        end

        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local exploration_score_window_close_terminal = {
    _name = "exploration_score_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if  fwin:find("ExplorationScoreClass") then
            fwin:close(fwin:find("ExplorationScoreClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(exploration_score_window_open_terminal)
state_machine.add(exploration_score_window_close_terminal)
state_machine.init()

function ExplorationScore:ctor()
    self.super:ctor()
    self.roots = {}
    app.load("client.l_digital.campaign.exploration.ExplorationScoreCell")
    local function init_exploration_score_terminal()
        local exploration_score_type_terminal = {
            _name = "exploration_score_type",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local _type = params._datas._type
                instance:sorceTypeTab(_type)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local exploration_score_update_terminal = {
            _name = "exploration_score_update",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local _type = params
                instance:onUpdateDraw(_type)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(exploration_score_type_terminal)
        state_machine.add(exploration_score_update_terminal)
        state_machine.init()
    end
    
    init_exploration_score_terminal()
end

function ExplorationScore:init(params)
    return self
end

function ExplorationScore:onUpdate(dt)
    if self._type == 0 then
        if self.dailyList ~= nil and self.dailyListContainer ~= nil then
            local size = self.dailyList:getContentSize()
            local posY = self.dailyListContainer:getPositionY()
            if self.dailyListContainerPosY == posY then
                return
            end
            self.dailyListContainerPosY = posY
            local items = self.dailyList:getItems()
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
    else
        if self.addList ~= nil and self.addListContainer ~= nil then
            local size = self.addList:getContentSize()
            local posY = self.addListContainer:getPositionY()
            if self.addListContainerPosY == posY then
                return
            end
            self.addListContainerPosY = posY
            local items = self.addList:getItems()
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
end

function ExplorationScore:sorceTypeTab( _type )
    local root = self.roots[1]
    self._type = _type
    local day = ccui.Helper:seekWidgetByName(root, "Button_integral_everyday")
    local add = ccui.Helper:seekWidgetByName(root, "Button_integral_add")
    local Text_exploration_integral_tip = ccui.Helper:seekWidgetByName(root, "Text_exploration_integral_tip")
    if _type == 0 then
        day:setTouchEnabled(false)
        day:setHighlighted(true)
        add:setTouchEnabled(true)
        add:setHighlighted(false)
        self.dailyList:setVisible(true)
        self.addList:setVisible(false)
        Text_exploration_integral_tip:setString(tipStringInfo_exploration_tips[9])
    else
        day:setTouchEnabled(true)
        day:setHighlighted(false)
        add:setTouchEnabled(false)
        add:setHighlighted(true)
        self.dailyList:setVisible(false)
        self.addList:setVisible(true)
        Text_exploration_integral_tip:setString(tipStringInfo_exploration_tips[10])
    end

end

function ExplorationScore:onUpdateDraw(_type)
    local root = self.roots[1]
    -- self.initData()
    local ListView_exploration_everyday_integral = ccui.Helper:seekWidgetByName(root, "ListView_exploration_everyday_integral")
    local ListView_exploration_integral = ccui.Helper:seekWidgetByName(root, "ListView_exploration_integral")
    local Text_integral_t_n = ccui.Helper:seekWidgetByName(root, "Text_integral_t_n")
    local Text_integral_a_n = ccui.Helper:seekWidgetByName(root, "Text_integral_a_n")

    Text_integral_t_n:setString(_ED.pokemonExplore.scoreInfo.todayScore) -- 今日积分
    Text_integral_a_n:setString(_ED.pokemonExplore.scoreInfo.totalScore) -- 总积分
    
    ListView_exploration_everyday_integral:removeAllItems()
    ListView_exploration_integral:removeAllItems()

    local dailyList = self:sortScoreIds()[0]
    local totalList = self:sortScoreIds()[1]

    for k,v in pairs(dailyList) do
        local cell = state_machine.excute("exploration_score_cell", 0, {_type = 0, id = v.id, _index = k})
        ListView_exploration_everyday_integral:pushBackCustomItem(cell)
    end
    ListView_exploration_everyday_integral:requestRefreshView()
    ListView_exploration_everyday_integral:jumpToTop()

    local count = 0
    for k,v in pairs(totalList) do
        local cell = state_machine.excute("exploration_score_cell", 0, {_type = 1, id = v.id, _index = k})
        ListView_exploration_integral:pushBackCustomItem(cell)
    end
    ListView_exploration_integral:requestRefreshView()
    ListView_exploration_integral:jumpToTop()

    self.dailyList = ListView_exploration_everyday_integral
    self.dailyListContainer = ListView_exploration_everyday_integral:getInnerContainer()
    self.dailyListContainerPosY = self.dailyListContainer:getPositionY()

    self.addList = ListView_exploration_integral
    self.addListContainer = ListView_exploration_integral:getInnerContainer()
    self.addListContainerPosY = self.addListContainer:getPositionY()
    local _type1 = _type or 0
    self:sorceTypeTab(_type1)
end

function ExplorationScore:sortScoreIds()
    local ids = {}
    ids[0] = {}
    ids[1] = {}
    for i = 1, #dms["role_explore_daily_score"] do
        local data = {}
        local needScore = dms.int(dms["role_explore_daily_score"], i, 2)
        local scoreCompelet = _ED.pokemonExplore.scoreInfo.todayScoreR
        local curScore = _ED.pokemonExplore.scoreInfo.todayScore
        data.id = i
        if (table.containValue(scoreCompelet, "" .. i) or table.containValue(scoreCompelet, i)) then -- 已经领取
            data.state = 2
        else
            if tonumber(curScore) >= needScore then --已完成
                data.state = 0
            else--未完成
                data.state = 1
            end
        end
        table.insert(ids[0], data)
    end

    for i = 1, #dms["role_explore_gather_score"] do
        local data = {}
        local needScore = dms.int(dms["role_explore_gather_score"], i, 2)
        local scoreCompelet = _ED.pokemonExplore.scoreInfo.totalScoreR
        local curScore = _ED.pokemonExplore.scoreInfo.totalScore
        data.id = i
        if (table.containValue(scoreCompelet, "" .. i) or table.containValue(scoreCompelet, i)) then -- 已经领取
            data.state = 2
        else
            if tonumber(curScore) >= needScore then --已完成
                data.state = 0
            else--未完成
                data.state = 1
            end
        end
        table.insert(ids[1], data)
    end
    
    local function sortList( a, b )
        if a.state < b.state then
            return true
        elseif a.state == b.state then
            return a.id < b.id
        else
            return false
        end
    end
    table.sort(ids[0], sortList)
    table.sort(ids[1], sortList)

    return ids
end

function ExplorationScore:onEnterTransitionFinish()
    local csbNode = csb.createNode("campaign/exploration/exploration_integral.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbNode)
    -- 开启
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil, 
    {
        terminal_name = "exploration_score_window_close", 
        isPressedActionEnabled = true
    },
    nil, 0)

     -- 每日积分
     fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_integral_everyday"), nil, 
     {
         terminal_name = "exploration_score_type", 
         isPressedActionEnabled = true,
         _type = 0
     },
     nil, 0)

     -- 累计积分
     fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_integral_add"), nil, 
     {
         terminal_name = "exploration_score_type", 
         isPressedActionEnabled = true,
          _type = 1
     },
     nil, 0)

    self:onUpdateDraw()
end

function ExplorationScore:onExit()

end
