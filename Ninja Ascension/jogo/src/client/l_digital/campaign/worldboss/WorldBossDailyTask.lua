-- ----------------------------------------------------------------------------------------------------
-- 说明：世界boss每日奖励
-------------------------------------------------------------------------------------------------------
WorldBossDailyTask = class("WorldBossDailyTaskClass", Window)

local world_boss_daily_task_open_terminal = {
    _name = "world_boss_daily_task_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
    	fwin:open(WorldBossDailyTask:new(), fwin._view)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local world_boss_daily_task_close_terminal = {
    _name = "world_boss_daily_task_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
    	fwin:close(fwin:find("WorldBossDailyTaskClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(world_boss_daily_task_open_terminal)
state_machine.add(world_boss_daily_task_close_terminal)
state_machine.init()

function WorldBossDailyTask:ctor()
    self.super:ctor()
    self.roots = {}
    self.button_group = {}
    self.button_text = {}	-- DSC重塑
    self.page = 1
    self.listView = nil
    app.load("client.l_digital.campaign.worldboss.WorldBossDailyTaskCell")
    app.load("client.l_digital.campaign.worldboss.WorldBossRewardRankCell")

    local function init_world_boss_reward_terminal()
        --切换奖励标签
        local world_boss_reward_change_page_terminal = {
            _name = "world_boss_reward_change_page",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if self.page == params._datas._page then
                    return
                end
                self.page = params._datas._page
                instance:changePage()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(world_boss_reward_change_page_terminal)
        state_machine.init()
    end
    init_world_boss_reward_terminal()
--    init_world_boss_daily_task_terminal()
end

function WorldBossDailyTask:onUpdate(dt)
    if self.ListView_exploration_integral ~= nil and self.dailyListContainer ~= nil then
        local size = self.ListView_exploration_integral:getContentSize()
        local posY = self.dailyListContainer:getPositionY()
        if self.dailyListContainerPosY == posY then
            return
        end
        self.dailyListContainerPosY = posY
        local items = self.ListView_exploration_integral:getItems()
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
--绘制每日目标奖励
function WorldBossDailyTask:drawTargetReward()
    local items = self:sortIds()
    for i, data in ipairs(items) do
        local cell = state_machine.excute("world_boss_daily_task_cell", 0, {data.id, i})
        self.listView:pushBackCustomItem(cell)
    end
    self.listView:requestRefreshView()
    self.listView:jumpToTop()
    self.ListView_exploration_integral = self.listView
    self.dailyListContainer = self.listView:getInnerContainer()
    self.dailyListContainerPosY = self.dailyListContainer:getPositionY()
end
--绘制个人排行奖励
function WorldBossDailyTask:drawPersonRankReward()
    local items = self:rankItems()
    for i, data in ipairs(items) do
        local cell = state_machine.excute("world_boss_reward_rank_cell", 0, {data, i})
        self.listView:pushBackCustomItem(cell)
    end
    self.listView:requestRefreshView()
    self.listView:jumpToTop()
    self.ListView_exploration_integral = self.listView
    self.dailyListContainer = self.listView:getInnerContainer()
    self.dailyListContainerPosY = self.dailyListContainer:getPositionY()
end
--绘制公会排行奖励
function WorldBossDailyTask:drawGuildRankReward()
    local items = self:rankGuildItems()
    for i, data in ipairs(items) do
        local cell = state_machine.excute("world_boss_reward_rank_cell", 0, {data, i})
        self.listView:pushBackCustomItem(cell)
    end
    self.listView:requestRefreshView()
    self.listView:jumpToTop()
    self.ListView_exploration_integral = self.listView
    self.dailyListContainer = self.listView:getInnerContainer()
    self.dailyListContainerPosY = self.dailyListContainer:getPositionY()
end
--绘制特殊奖励
function WorldBossDailyTask:drawSpecialReward()
    local items = self:rankSpecialItems()
    for i, data in ipairs(items) do
        local cell = state_machine.excute("world_boss_reward_rank_cell", 0, {data, i})
        self.listView:pushBackCustomItem(cell)
    end
    self.listView:requestRefreshView()
    self.listView:jumpToTop()
    self.ListView_exploration_integral = self.listView
    self.dailyListContainer = self.listView:getInnerContainer()
    self.dailyListContainerPosY = self.dailyListContainer:getPositionY()
end
--function WorldBossDailyTask:onUpdateDraw()
--    local root = self.roots[1]
--    local ListView_exploration_integral = ccui.Helper:seekWidgetByName(root, "ListView_exploration_integral")
--    ListView_exploration_integral:removeAllItems()
--
--    local items = self:sortIds()
--    for i, data in ipairs(items) do
--        local cell = state_machine.excute("world_boss_daily_task_cell", 0, {data.id, i})
--        ListView_exploration_integral:pushBackCustomItem(cell)
--    end
--    ListView_exploration_integral:requestRefreshView()
--    ListView_exploration_integral:jumpToTop()
--    self.ListView_exploration_integral = ListView_exploration_integral
--    self.dailyListContainer = ListView_exploration_integral:getInnerContainer()
--    self.dailyListContainerPosY = self.dailyListContainer:getPositionY()
--end
--每日目标奖励
function WorldBossDailyTask:sortIds()
    local ids = {}
    for i = 1, #dms["world_boss_daily_reward"] do
        local data = {}
        local condition = dms.int(dms["world_boss_daily_reward"], i, 2)
        local needcount = dms.int(dms["world_boss_daily_reward"], i, 3)
        local curCount = _ED.world_boss_my_info.allTask.taskInfo[condition .. ""]
        data.id = i
        if (table.containValue(_ED.world_boss_my_info.allTask.drawTaskId, "" .. i) or table.containValue(_ED.world_boss_my_info.allTask.drawTaskId, i)) then -- 已经领取
            data.state = 2
        else
            if tonumber(curCount) >= needcount then --已完成
                data.state = 0
            else--未完成
                data.state = 1
            end
        end
        table.insert(ids, data)
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
    table.sort(ids, sortList)
    return ids
end
--个人排行奖励数据
function WorldBossDailyTask:rankItems()
    local itemData = {}
    local reward_dms = dms["world_boss_person_reward"]
    for i = 1, #reward_dms do
        local data = {}
        local min = dms.int(reward_dms, i, 2)
        local max = dms.int(reward_dms, i, 3)
        local rewards = zstring.splits(dms.string(reward_dms, i, 4), "|", ",")
        data.id = i
        data.min = min
        data.max = max
        data.rewards = rewards
        table.insert(itemData, data)
    end
    return itemData
end
--公会排行奖励数据
function WorldBossDailyTask:rankGuildItems()
    local itemData = {}
    local reward_dms = dms["world_boss_guild_reward"]
    for i = 1, #reward_dms do
        local data = {}
        local min = dms.int(reward_dms, i, 2)
        local max = dms.int(reward_dms, i, 3)
        local rewards = zstring.splits(dms.string(reward_dms, i, 4), "|", ",")
        data.id = i
        data.min = min
        data.max = max
        data.rewards = rewards
        table.insert(itemData, data)
    end
    return itemData
end
--特殊奖励数据
function WorldBossDailyTask:rankSpecialItems()
    local itemData = {}
    local data1 = {}
    local min = 666666
    local max = 666666
    local boss_level = dms.int(dms["world_boss"], _ED.world_boss_info.bossId, 2)
    local rewards = zstring.splits(dms.string(dms["world_boss"], boss_level, 7), "|", ",")
    data1.id = 1
    data1.min = min
    data1.max = max
    data1.rewards = rewards
    table.insert(itemData, data1)

    local data2 = {}
    min = 777777
    max = 777777
    rewards = zstring.splits(dms.string(dms["world_boss"], boss_level, 8), "|", ",")
    data2.id = 1
    data2.min = min
    data2.max = max
    data2.rewards = rewards
    table.insert(itemData, data2)
    return itemData
end
--切换标签
function WorldBossDailyTask:changePage()
    local root = self.roots[1]
--    local Panel_xinxi = ccui.Helper:seekWidgetByName(root, "Panel_exploration_integral")
    if self.listView then
        self.listView:removeAllItems()
    end
    local Text_reward_tips = ccui.Helper:seekWidgetByName(root, "Text_reward_tips")
    local tips_str = ""
    if self.page == 2 or self.page == 3 then
        tips_str = tipStringInfo_world_boss[14]
    elseif self.page == 4 then
        tips_str = tipStringInfo_world_boss[15]
    end
    Text_reward_tips:setString(tips_str)

    for i = 1 , 4 do
--        state_machine.excute(self.terminal_group[i][3],0,"") -- 全隐藏
        if i == self.page then
            self.button_group[i]:setHighlighted(true)
            -- DSC重塑
			if __lua_project_id == __lua_project_l_digital then 
                if self.button_text[i] then
                    self.button_text[i][1]:setVisible(false)
                    self.button_text[i][2]:setVisible(true)
                end
                self.button_group[i]:setTouchEnabled(false)
            end
            if i == 1 then
                self:drawTargetReward()
            elseif i == 2 then
                self:drawPersonRankReward()
            elseif i == 3 then
                self:drawGuildRankReward()
            elseif i == 4 then
                self:drawSpecialReward()
            end
--            if self.page_group[i] == nil then
--                self.page_group[i] = state_machine.excute(self.terminal_group[i][1],0,Panel_xinxi)
--                Panel_xinxi:addChild(self.page_group[i])
--            else
--                state_machine.excute(self.terminal_group[i][2],0,"")
--            end
        else
            self.button_group[i]:setHighlighted(false)
            -- DSC重塑
			if __lua_project_id == __lua_project_l_digital then 
                if self.button_text[i] then
                    self.button_text[i][1]:setVisible(true)
                    self.button_text[i][2]:setVisible(false)
                end
                self.button_group[i]:setTouchEnabled(true)
            end
        end
    end
end
function WorldBossDailyTask:onEnterTransitionFinish()
    local csbNode = csb.createNode("campaign/world_boss/world_boss_reward.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    local Panel_exploration_integral = ccui.Helper:seekWidgetByName(root, "Panel_exploration_integral")
    local tabNode = csb.createNode("campaign/world_boss/world_boss_reward_tab.csb")
    local tabRoot = tabNode:getChildByName("root")
    self.listView = ccui.Helper:seekWidgetByName(tabRoot, "ListView_exploration_integral")
    self.listView:removeFromParent(true)
    Panel_exploration_integral:addChild(self.listView)

    -- 关闭窗口
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil, 
    {
        terminal_name = "world_boss_daily_task_close", 
        isPressedActionEnabled = true
    },
    nil, 0)
    self.button_group = {
        ccui.Helper:seekWidgetByName(root, "Button_integral_add_0_0"),              --每日目标奖励
        ccui.Helper:seekWidgetByName(root, "Button_integral_everyday"),             --个人排行奖励
        ccui.Helper:seekWidgetByName(root, "Button_legion_reward"),                 --公会排行奖励
        ccui.Helper:seekWidgetByName(root, "Button_integral_add_0"),                --特别奖励
    }

    -- DSC重塑
    if __lua_project_id == __lua_project_l_digital then 
        for i=1,4 do
            local Text_blue = ccui.Helper:seekWidgetByName(root, "Text_blue_"..i)
            local Text_white = ccui.Helper:seekWidgetByName(root, "Text_white_"..i)
            if Text_blue and Text_white then 
                self.button_text[i] = {Text_blue,Text_white}
            end
        end
    end
    

    for i = 1 , 4 do
        fwin:addTouchEventListener(self.button_group[i],nil,
            {
                terminal_name = "world_boss_reward_change_page",
                terminal_state = 0,
                _page = i,
                isPressedActionEnabled = false
            },
            nil, 0)
    end
    self:changePage()
end

function WorldBossDailyTask:init()

end

function WorldBossDailyTask:onExit()
    state_machine.remove("world_boss_reward_change_page")
end
function WorldBossDailyTask:destroy( window )

end