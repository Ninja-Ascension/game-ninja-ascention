-- ----------------------------------------------------------------------------------------------------
-- 说明：大冒险获得奖励
-------------------------------------------------------------------------------------------------------
AdventureRewardWindow = class("AdventureRewardWindowClass", Window)

local adventure_reward_window_open_terminal = {
    _name = "adventure_reward_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("AdventureRewardWindowClass") == nil then
            fwin:open(AdventureRewardWindow:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local adventure_reward_window_close_terminal = {
    _name = "adventure_reward_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if  fwin:find("AdventureRewardWindowClass") then
            fwin:close(fwin:find("AdventureRewardWindowClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(adventure_reward_window_open_terminal)
state_machine.add(adventure_reward_window_close_terminal)
state_machine.init()

function AdventureRewardWindow:ctor()
    self.super:ctor()
    self.roots = {}
    app.load("client.activity.adventure.AdventureRewardCell")
end

function AdventureRewardWindow:init(params)
    return self
end

function AdventureRewardWindow:onUpdate(dt)
    if self.currentScrollView ~= nil and self.currentInnerContainer ~= nil then
        local size = self.currentScrollView:getContentSize()
        local posY = self.currentInnerContainer:getPositionY()
        if self.currentInnerContainerPosY == posY then
            return
        end
        self.currentInnerContainerPosY = posY
        local items = self.currentScrollView:getChildren()
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

function AdventureRewardWindow:onUpdateDraw()
    local root = self.roots[1]
    local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_obtained_gun")
    if table.nums(self.rewards) > 0 then
        m_ScrollView:removeAllChildren(true)
        local horizontalNumber = 6
        local panel = m_ScrollView:getInnerContainer()
        panel:setContentSize(m_ScrollView:getContentSize())
        panel:setPosition(cc.p(0,0))
        panel:removeAllChildren(true)
        local sSize = panel:getContentSize()
        local sHeight = sSize.height
        local sWidth = sSize.width
        local controlSize = m_ScrollView:getInnerContainerSize()
        local nextY = sSize.height
        local nextX = sSize.width
        local tHeight = 0
        local cellHeight = 0
        local tWidth = 0
        local wPosition = sWidth/horizontalNumber
        local Hlindex = 0
        local number = table.nums(self.rewards)
        local m_number = math.ceil(number/horizontalNumber)
        cellHeight = m_number*(m_ScrollView:getContentSize().width/horizontalNumber)
        sHeight = math.max(sHeight, cellHeight)
        panel:setContentSize(m_ScrollView:getContentSize().width, sHeight + 10)

        local totalRewardCount = 0
        for j, v in pairs(self.rewards) do
            local rewardType = zstring.tonumber(v[1])
            local cell = ResourcesIconCell:createCell()
            if 13 == rewardType then
                local table = {}
                if v[4] ~= nil and tonumber(v[4]) ~= -1 then
                    table.shipStar = tonumber(v[4])
                end
                cell:init(rewardType, tonumber(v[3]), tonumber(v[2]),nil,nil,true,true,1,table)
            else
                cell:init(rewardType, tonumber(v[3]), tonumber(v[2]),nil,nil,true,true,1)
            end
            panel:addChild(cell)
            tWidth = tWidth + wPosition
            if (j-1)%horizontalNumber == 0 then
                Hlindex = Hlindex+1
                tWidth = 0
                tHeight = sHeight - (wPosition + 2)*Hlindex  
            end
            if j <= horizontalNumber then
                tHeight = sHeight - wPosition
            end
            cell:setPosition(cc.p(tWidth, tHeight))

            totalRewardCount = totalRewardCount + 1
        end
        m_ScrollView:jumpToTop()
    end
    self.currentScrollView = m_ScrollView
    self.currentInnerContainer = self.currentScrollView:getInnerContainer()
    self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
end

function AdventureRewardWindow:initRewardData(  )
    self.rewards = {}
    local ids = {}
    local info = json.decode(_ED.active_activity[147].activity_params)
    local taskIds = info.taskIds
    for i,v in pairs(taskIds) do
        if not ids[v] then
            ids[v] = {}
            table.insert(ids[v], v)
        else
            table.insert(ids[v], v)
        end
    end
    for k,v in pairs(ids) do
        local num = table.nums(v)
        local rewards = zstring.splits(dms.string(dms["activity_monopoly_task_mould"], k, 4), "|", ",")
        for i, info in pairs(rewards) do
            info[3] = tonumber(info[3])*num
            table.insert(self.rewards, info)
        end
    end

end


function AdventureRewardWindow:onEnterTransitionFinish()
    local csbNode = csb.createNode("activity/adventure/adv_obtained.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbNode)

     -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy_power_close"), nil, 
    {
        terminal_name = "adventure_reward_window_close", 
        isPressedActionEnabled = true
    },
    nil, 0)
    self:initRewardData()
    self:onUpdateDraw()
end

function AdventureRewardWindow:onExit()

end
