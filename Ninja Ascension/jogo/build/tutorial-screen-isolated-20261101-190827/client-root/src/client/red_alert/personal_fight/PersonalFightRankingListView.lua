--------------------------------------
-- 个人居所排行榜显示列表
--------------------------------------
PersonalFightRankingListView = class("PersonalFightRankingListViewClass", Window)

local personal_fight_ranking_list_view_create_terminal = {
    _name = "personal_fight_ranking_list_view_create",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function (terminal, instance, params)
        local root_view = params[1]
        local rank_type = params[2]
        local window = PersonalFightRankingListView:new()
        window:init(root_view, rank_type)
        fwin:open(window)
        return window
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(personal_fight_ranking_list_view_create_terminal)
state_machine.init()

function PersonalFightRankingListView:ctor()
    self.super:ctor()
    self.roots = {}

    self._list_view = nil           --列表容器
    self._list_view_poy = 0         --列表滚动位置
    self._rank_type = 0             --排行榜类型：1，全服，2：本服，3：帮派，4：积分奖励
end

function PersonalFightRankingListView:init(root_view, rank_type)
    self._rootWindows = root_view
    self._rank_type = rank_type

    self:onInit()
    return self
end

function PersonalFightRankingListView:onInit()
    local csbItem = csb.createNode(config_csb.palyer_build.palyer_build_ranking_listview)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self._list_view = ccui.Helper:seekWidgetByName(root, "ListView_rank")
    local nType = tonumber(self._rank_type) - 1
    if nType > 0 and nType <= 2 then 
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                    response.node:updateDraw()
                end 
            end
        end
        protocol_command.user_stronghold_view_score_rank.param_list = ""..nType
        NetworkManager:register(protocol_command.user_stronghold_view_score_rank.code, nil, nil, nil, self, responseCallback, false, nil)
    else
        self:updateDraw()
    end
end

function PersonalFightRankingListView:updateDraw()
    local nType = tonumber(self._rank_type) - 1
    self._list_view:removeAllItems()

    if nType >= 0 and nType <= 2 then
        for i, data in pairs(_ED.user_stronghold_view_score_ranks[""..nType]) do
            local cell = state_machine.excute("personal_fight_ranking_cell_create", 0, {self._rank_type, data, i})
            self._list_view:addChild(cell)
        end
    elseif nType == 3 then          -- 显示积分段位奖励
        local count = dms.count(dms["user_stronghold"])
        for i = 1, count do
            local cell = state_machine.excute("personal_fight_ranking_reward_cell_create", 0, {i, count - i + 1})
            self._list_view:addChild(cell)
        end
    end

    self._list_view:requestRefreshView()
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()

    state_machine.excute("personal_fight_ranking_update_rank", 0, "")
end

function PersonalFightRankingListView:onExit()

end

function PersonalFightRankingListView:onEnterTransitionFinish()

end

function PersonalFightRankingListView:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if posY == self._list_view_poy then
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
            if tempY + itemSize.height * 2 < 0 or tempY - itemSize.height * 2 > size.height then
                v:unload()
            else
                v:reload()
            end
        end
    end
end
