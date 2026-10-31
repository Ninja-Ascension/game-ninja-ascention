--------------------------------------------------------------------------------------------------------------
--  排汗榜列表
--------------------------------------------------------------------------------------------------------------
RankingListview = class("RankingListviewClass", Window)

local ranking_listview_window_open_terminal = {
    _name = "ranking_listview_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local list_view = RankingListview:new():init(params)
        fwin:open(list_view)
        return list_view
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(ranking_listview_window_open_terminal)
state_machine.init()

function RankingListview:ctor()
	self.super:ctor()
	self.roots = {}
    
    --var 
    --列表
    self._list_view = nil
    --列表初始高度
    self._list_view_poy = nil
    --排行类型 1：战力，2：等级，3：侠客行，4：华山论剑，5：帮派
    self._from_type = nil 

	-- Initialize ranking_listview state machine.
    local function init_ranking_listview_terminal()
   
    end
    
    -- call func ranking_listview create state machine.
    init_ranking_listview_terminal()

end

function RankingListview:updateDraw()
    local root = self.roots[1]
    local ListView_ranking_right = ccui.Helper:seekWidgetByName(root,"ListView_ranking_right")
    ListView_ranking_right:removeAllItems()

    local rank_info = {}        --排行榜数据
    if self._from_type == 1 then                --战力排行
        rank_info = _ED.fight_ranks.other_user   
    elseif self._from_type == 2 then            --等级排行
        rank_info = _ED.level_rank.other_user
    elseif self._from_type == 3 then            --侠客行
        rank_info = _ED.trialtower_ranking_info.other_info   
    elseif self._from_type == 4 then            --华山论剑排行
        rank_info = _ED.city_rank.other_user[1]
    elseif self._from_type == 5 then            --帮派排行
        rank_info = _ED.union.rank_union_list_info
    end   

    for i, v in pairs(rank_info) do
        if self._from_type == 5 and v.union_id ~= nil and tonumber(v.union_id) > 0 then
            local cell = state_machine.excute("ranking_right_create_cell",0,{v, self._from_type, i})
            ListView_ranking_right:addChild(cell)
        end

        if self._from_type ~= 5 and v.user_id ~= nil and tonumber(v.user_id) > 0 then
            local cell = state_machine.excute("ranking_right_create_cell",0,{v, self._from_type, i})
            ListView_ranking_right:addChild(cell)
        end
    end

    ListView_ranking_right:requestRefreshView()
    self._list_view = ListView_ranking_right
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
end

function RankingListview:onUpdate(dt)
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

function RankingListview:onInit()
    local csbItem = csb.createNode(config_csb.rank.ranking_listview)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self:updateDraw()
end

function RankingListview:onEnterTransitionFinish()
    
end

function RankingListview:init(params)
    local rootWindow = params[1]
    self._from_type = params[2]
    self._rootWindows = rootWindow
    self:onInit()
    return self
end

function RankingListview:onExit()
   
end