-- ----------------------------------------------------------------------------------------------------
-- 说明：资源点listview
-- ----------------------------------------------------------------------------------------------------
MapRattlingRankingListView = class("MapRattlingRankingListViewClass", Window)

local map_rattling_ranking_listview_window_open_terminal = {
    _name = "map_rattling_ranking_listview_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local list_view = MapRattlingRankingListView:new():init(params)
        fwin:open(list_view)
        return list_view
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(map_rattling_ranking_listview_window_open_terminal)
state_machine.init()

function MapRattlingRankingListView:ctor()
	self.super:ctor()
	self.roots = {}
    
    self._list_view = nil
    self._list_view_poy = nil
    self._from_type = nil 

    local function init_ranking_listview_terminal()
   
    end
    
    init_ranking_listview_terminal()

end

function MapRattlingRankingListView:updateDraw()
    local root = self.roots[1]
    local ListView_ranking_right = ccui.Helper:seekWidgetByName(root, "ListView_ranking_right")
    ListView_ranking_right:removeAllItems()
    ListView_ranking_right:jumpToTop()
    local info_list = _ED.city_resource_rank_info
    if info_list ~= nil then
        for i,v in pairs(info_list) do
            local cell = state_machine.excute("map_rattling_ranking_create_cell",0,{i, v, self._from_type})
            ListView_ranking_right:addChild(cell)
        end
    end
    ListView_ranking_right:requestRefreshView()
    self._list_view = ListView_ranking_right
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
end

function MapRattlingRankingListView:onUpdate(dt)
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

function MapRattlingRankingListView:onInit()
    local csbItem = csb.createNode(config_csb.rank.ranking_listview_top)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self:updateDraw()
end

function MapRattlingRankingListView:onEnterTransitionFinish()
    
end

function MapRattlingRankingListView:init(params)
    local rootWindow = params[1]
    self._from_type = params[2]
    self._rootWindows = rootWindow
    self:onInit()
    return self
end

function MapRattlingRankingListView:onExit()
   
end