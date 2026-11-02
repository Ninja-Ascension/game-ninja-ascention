--------------------------------------------------------------------------------------------------------------
--  开服冲top Listview
--------------------------------------------------------------------------------------------------------------
RankingListviewTop = class("RankingListviewTopClass", Window)

local ranking_listview_top_window_open_terminal = {
    _name = "ranking_listview_top_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local window = RankingListviewTop:new():init(params)
        fwin:open(window)
        return window
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(ranking_listview_top_window_open_terminal)
state_machine.init()

function RankingListviewTop:ctor()
    self.super:ctor()
    self.roots = {}
    
    self._laft_page = 0     -- 1 等级排行  2 战力排行  3 侠客行  4 星星排行
    self._day_index = 0     -- 1 三天奖励  2 七天奖励  3 14天奖励 

    -- Initialize ranking_listview state machine.
    local function init_ranking_listview_top_terminal()
   
    end
    
    -- call func ranking_listview create state machine.
    init_ranking_listview_top_terminal()

end

function RankingListviewTop:updateDraw()
    local root = self.roots[1]
    local ListView_ranking_right = ccui.Helper:seekWidgetByName(root,"ListView_ranking_right")
    ListView_ranking_right:removeAllItems()

    -- if _ED.server_rank_info[self._laft_page] ~= nil then
        -- local info = _ED.server_rank_info[self._laft_page][self._day_index]
        -- if info ~= nil then
            local nType = 0
            if self._laft_page == 1 then        -- 等级排行  
                nType = 76
            elseif self._laft_page == 2 then    -- 战力排行
                nType = 77
            elseif self._laft_page == 3 then    -- 侠客行
                nType = 79
            elseif self._laft_page == 4 then    -- 星星排行
                nType = 80
            end
        local index = 0
        local rewardName = "open_server_top_rank_reward"
        if _ED.activity_info["40"] ~= nil then
            rewardName = "open_server_top_rank_rewardex"
        end
        for i=1,dms.count(dms[rewardName]) do
            local data = dms.element(dms[rewardName], i)
            local tab_type = dms.atoi(data, open_server_top_rank_reward.tab_type)       -- 排名类型
            local rank_info = dms.atos(data, open_server_top_rank_reward.rank_info)     -- 排名区间
            local reward = dms.atos(data, open_server_top_rank_reward.reward)           -- 排名奖励
            if tab_type == nType then
                index = index + 1
                local rewards = zstring.split(reward, "!")
                local reward_info = ""
                if self._day_index == 1 then        -- 三天奖励
                    reward_info = rewards[4]    
                elseif self._day_index == 2 then     -- 七天奖励
                    reward_info = rewards[8]    
                else                                -- 14天奖励
                    reward_info = rewards[15]
                end
                --创建列表
                local cell = state_machine.excute("server_top_rank_rihgt_create_cell",0,{index, reward_info, self._laft_page, rank_info,self._day_index})
                ListView_ranking_right:addChild(cell)
            end
            -- if index >= 10 then
            --     break
            -- end

        end
        -- end
    -- end
    ListView_ranking_right:requestRefreshView()
    self._list_view = ListView_ranking_right
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
end

function RankingListviewTop:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_poy == posY then
            return
        end
        self._list_view_poy = posY
        local items = self._list_view:getItems()
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

function RankingListviewTop:onInit()
    local csbItem = csb.createNode(config_csb.rank.ranking_listview_top)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self:updateDraw()
end

function RankingListviewTop:onEnterTransitionFinish()
    
end

function RankingListviewTop:init(params)
    local rootWindow = params[1]
    self._laft_page = params[2]
    self._day_index = params[3]
    self._rootWindows = rootWindow
    self:onInit()
    return self
end

function RankingListviewTop:onExit()

end