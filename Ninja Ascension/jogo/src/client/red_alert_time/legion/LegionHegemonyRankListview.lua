--------------------------------------------------------------------------------------------------------------
--  军团争霸排行榜，奖励列表
--------------------------------------------------------------------------------------------------------------
LegionHegemonyRankListview = class("LegionHegemonyRankListviewClass", Window)

local legion_hegemony_rank_listview_window_open_terminal = {
    _name = "legion_hegemony_rank_listview_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local list_view = LegionHegemonyRankListview:new():init(params)
        fwin:open(list_view)
        return list_view
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(legion_hegemony_rank_listview_window_open_terminal)
state_machine.init()

function LegionHegemonyRankListview:ctor()
    self.super:ctor()
    self.roots = {}

    -- 
    self._list_view = nil
    self._list_view_poy = 0
    self._list_view_height = 0

    self._Image_hegemony_rank_arrow_down = nil
    self._Image_hegemony_rank_arrow_up = nil

    self._shop_type = 1

    -- Initialize legion_hegemony_rank_listview state machine.
    local function init_legion_hegemony_rank_listview_terminal()
        --显示
        local legion_hegemony_rank_listview_window_show_terminal = {
            _name = "legion_hegemony_rank_listview_window_show",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local list_view = params
                if list_view ~= nil and list_view.roots ~= nil and list_view.roots[1] ~= nil then
                    list_view:onShow()
                    state_machine.excute("legion_hegemony_rank_listview_update_draw", 0, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 隐藏
        local legion_hegemony_rank_listview_window_hide_terminal = {
            _name = "legion_hegemony_rank_listview_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local list_view = params
                if list_view ~= nil and list_view.roots ~= nil and list_view.roots[1] ~= nil then
                    list_view:onHide()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 刷新
        local legion_hegemony_rank_listview_update_draw_terminal = {
            _name = "legion_hegemony_rank_listview_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local list_view = params
                if list_view ~= nil and list_view.roots ~= nil and list_view.roots[1] ~= nil then
                    local posY = list_view._list_view_poy
                    list_view:onUpdateDraw()
                    if math.abs(posY) > math.abs(list_view._list_view_height) then
                        posY = list_view._list_view_height
                    end
                    list_view._list_view:getInnerContainer():setPositionY(posY)   
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_hegemony_rank_listview_window_show_terminal)
        state_machine.add(legion_hegemony_rank_listview_window_hide_terminal)
        state_machine.add(legion_hegemony_rank_listview_update_draw_terminal)
        state_machine.init()
    end
    
    -- call func legion_hegemony_rank_listview create state machine.
    init_legion_hegemony_rank_listview_terminal()

end

--显示
function LegionHegemonyRankListview:onShow()
   self:setVisible(true)
end

--隐藏
function LegionHegemonyRankListview:onHide()
   self:setVisible(false)
end

function LegionHegemonyRankListview:onUpdateDraw()
    local root = self.roots[1]

    local ListView_hegemony_rank = ccui.Helper:seekWidgetByName(root, "ListView_hegemony_rank")
    self._list_view = ListView_hegemony_rank
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()

    if self._from_type == 1 then
        if _ED.union.union_union_hegemony_rank_list ~= nil 
            and _ED.union.union_union_hegemony_rank_list["0"] ~= nil 
            and table.nums(_ED.union.union_union_hegemony_rank_list["0"]) > 0
            then
            for k, v in pairs(_ED.union.union_union_hegemony_rank_list["0"]) do
                local cell = state_machine.excute("legion_hegemony_rank_cell_create", 0, {k, v})
                self._list_view:addChild(cell)
            end
        end
    elseif self._from_type == 2 then
        if _ED.union.union_union_hegemony_rank_list ~= nil 
            and _ED.union.union_union_hegemony_rank_list["1"] ~= nil 
            and table.nums(_ED.union.union_union_hegemony_rank_list["1"]) > 0
            then
            for k, v in pairs(_ED.union.union_union_hegemony_rank_list["1"]) do
                local cell = state_machine.excute("legion_hegemony_rank_cell_create", 0, {k, v})
                self._list_view:addChild(cell)
            end
        end
    end

    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()

    self._list_view:requestRefreshView()
end

function LegionHegemonyRankListview:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_hegemony_rank_arrow_down:setVisible(true)
        else
            self._Image_hegemony_rank_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_hegemony_rank_arrow_up:setVisible(true)
        else
            self._Image_hegemony_rank_arrow_up:setVisible(false)
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

function LegionHegemonyRankListview:onInit()
    local csbItem = csb.createNode(config_csb.legion.legion_hegemony_tab_listveiw_2)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self._Image_hegemony_rank_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_hegemony_rank_arrow_down")
    self._Image_hegemony_rank_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_hegemony_rank_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_hegemony_rank_arrow_down:stopAllActions()
    self._Image_hegemony_rank_arrow_up:stopAllActions()
    playActions(self._Image_hegemony_rank_arrow_down)
    playActions(self._Image_hegemony_rank_arrow_up)
    self._Image_hegemony_rank_arrow_down:setVisible(false)
    self._Image_hegemony_rank_arrow_up:setVisible(false)


    self:onUpdateDraw()
end

function LegionHegemonyRankListview:onEnterTransitionFinish()
    
end

function LegionHegemonyRankListview:init(params)
    local rootWindow = params[1]
    self._from_type = params[2]         --1：连胜排行，2：军团排行

    self._rootWindows = rootWindow

    self:onInit()
    return self
end

function LegionHegemonyRankListview:onExit()

end
