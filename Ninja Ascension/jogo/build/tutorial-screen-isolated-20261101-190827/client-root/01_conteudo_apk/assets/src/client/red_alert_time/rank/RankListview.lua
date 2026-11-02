--------------------------------------------------------------------------------------------------------------
--  排汗榜列表
--------------------------------------------------------------------------------------------------------------
RankListview = class("RankListviewClass", Window)

local rank_listview_window_open_terminal = {
    _name = "rank_listview_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local list_view = RankListview:new():init(params)
        fwin:open(list_view)
        return list_view
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(rank_listview_window_open_terminal)
state_machine.init()

function RankListview:ctor()
    self.super:ctor()
    self.roots = {}
    
    --var 
    --列表
    self._list_view = nil
    self._list_view_poy = 0
    self._list_view_height = 0
    --排行类型 1：战力，2：关卡，3：军功，4：军团，5：战地，6：学霸，7：平叛，8：歼敌，9：参战
    self._from_type = nil 
    self._Image_rank_arrow_down = nil
    self._Image_rank_arrow_up = nil

    self._last_info_count = 0

    app.load("client.red_alert_time.cells.arena.arena_rank_more_cell")
    -- Initialize rank_listview state machine.
    local function init_rank_listview_terminal()
        -- 刷新
        local rank_listview_update_draw_terminal = {
            _name = "rank_listview_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local listview = params
                if listview ~= nil then
                    local posY = listview._list_view_poy
                    listview:updateDraw()
                    if math.abs(posY) > math.abs(listview._list_view_height) then
                        posY = listview._list_view_height
                    end
                    listview._list_view:getInnerContainer():setPositionY(posY) 
                end   
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        state_machine.add(rank_listview_update_draw_terminal)
        state_machine.init()
    end
    
    -- call func rank_listview create state machine.
    init_rank_listview_terminal()

end

function RankListview:updateDraw()
    local root = self.roots[1]
    local ListView_rank = ccui.Helper:seekWidgetByName(root,"ListView_rank")
    ListView_rank:jumpToTop()
    ListView_rank:removeAllItems()
    local width = ListView_rank:getContentSize().width

    local rank_info = {}        --排行榜数据
    if self._from_type == 1 then
        rank_info = _ED.fight_ranks.other_user
    elseif self._from_type == 2 then                --关卡排行
        if _ED.npc_rank ~= nil then
            rank_info = _ED.npc_rank.other_user 
        end
    elseif self._from_type == 3 then                --军功排行
        if _ED.exploit_rank ~= nil then
            rank_info = _ED.exploit_rank.other_user 
        end
    elseif self._from_type == 4 then                --军团排行
        rank_info = _ED.union.rank_union_list_info 
    elseif self._from_type == 5 and _ED.city_rank ~= nil and _ED.city_rank.other_user ~= nil then                --战地排行
        rank_info = _ED.city_rank.other_user[1]
    elseif self._from_type == 6 then                --学霸排行
        rank_info = _ED.answer_rank_list_info
    elseif self._from_type == 7 then
        rank_info = _ED.user_rebel_haunt_total_rank_info
    elseif self._from_type == 8 then                --歼敌排行
        if _ED.user_enemy_strike_rank_info ~= nil and _ED.user_enemy_strike_rank_info.rank_hurt_list ~= nil then
            for k, v in pairs(_ED.user_enemy_strike_rank_info.rank_hurt_list) do
                if tonumber(v.rank) > 0 then
                    table.insert(rank_info, v)
                end
            end
            local function sortFunction(a, b)
                return tonumber(a.rank) < tonumber(b.rank)
            end
            table.sort(rank_info, sortFunction)
        end
    elseif self._from_type == 9 then                --参战排行
        if _ED.user_enemy_strike_rank_info ~= nil and _ED.user_enemy_strike_rank_info.rank_times_list ~= nil then
            for k, v in pairs(_ED.user_enemy_strike_rank_info.rank_times_list) do
                if tonumber(v.rank) > 0 then
                    table.insert(rank_info, v)
                end
            end
            local function sortFunction(a, b)
                return tonumber(a.rank) < tonumber(b.rank)
            end
            table.sort(rank_info, sortFunction)
        end
    end   

    if rank_info ~= nil then
        for i, v in pairs(rank_info) do
            if self._from_type == 4 and v.union_id ~= nil and tonumber(v.union_id) > 0 then
                local cell = state_machine.excute("rank_create_cell",0,{i, self._from_type, v})
                ListView_rank:addChild(cell)
            end

            if self._from_type ~= 4 and v.user_id ~= nil and tonumber(v.user_id) > 0 then
                local cell = state_machine.excute("rank_create_cell",0,{i, self._from_type, v})
                ListView_rank:addChild(cell)
            end
        end
        if #rank_info < 100 
            and #rank_info > 0 
            and (#rank_info % 20) == 0 
            and self._from_type ~= 6 
            and #rank_info ~= self._last_info_count
            then
            local cell = state_machine.excute("arena_rank_more_cell_create", 0, {#rank_info + 1,self._from_type,2})
            ListView_rank:addChild(cell)
        end
        self._last_info_count = #rank_info
    end
    
    ListView_rank:requestRefreshView()
    self._list_view = ListView_rank
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
end

function RankListview:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_rank_arrow_down:setVisible(true)
        else
            self._Image_rank_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_rank_arrow_up:setVisible(true)
        else
            self._Image_rank_arrow_up:setVisible(false)
        end
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

function RankListview:onInit()
    local csbItem = csb.createNode(config_csb.rank.rank_listview)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self._Image_rank_arrow_up = ccui.Helper:seekWidgetByName(root,"Image_rank_arrow_up")
    self._Image_rank_arrow_down = ccui.Helper:seekWidgetByName(root,"Image_rank_arrow_down")

    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_rank_arrow_down:stopAllActions()
    self._Image_rank_arrow_up:stopAllActions()
    playActions(self._Image_rank_arrow_down)
    playActions(self._Image_rank_arrow_up)
    self._Image_rank_arrow_down:setVisible(false)
    self._Image_rank_arrow_up:setVisible(false)

    self:updateDraw()
end

function RankListview:onEnterTransitionFinish()
    
end

function RankListview:init(params)
    local rootWindow = params[1]
    self._from_type = params[2]
    self._rootWindows = rootWindow
    self:onInit()
    return self
end

function RankListview:onExit()

end