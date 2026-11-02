--------------------------------------------------------------------------------------------------------------
--  守卫战排行榜
--------------------------------------------------------------------------------------------------------------
GuardBattleRankListview = class("GuardBattleRankListviewClass", Window)

local guard_battle_rank_listview_window_open_terminal = {
    _name = "guard_battle_rank_listview_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local list_view = GuardBattleRankListview:new():init(params)
        fwin:open(list_view)
        return list_view
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(guard_battle_rank_listview_window_open_terminal)
state_machine.init()

function GuardBattleRankListview:ctor()
    self.super:ctor()
    self.roots = {}

    -- 
    self._list_view = nil
    self._list_view_poy = 0
    self._list_view_height = 0

    self._Image_arrow_down = nil
    self._Image_arrow_up = nil

    self._from_type = 1

    -- Initialize guard_battle_rank_listview state machine.
    local function init_guard_battle_rank_listview_terminal()
        --显示
        local guard_battle_rank_listview_window_show_terminal = {
            _name = "guard_battle_rank_listview_window_show",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local list_view = params
                if list_view ~= nil and list_view.roots ~= nil and list_view.roots[1] ~= nil then
                    list_view:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 隐藏
        local guard_battle_rank_listview_window_hide_terminal = {
            _name = "guard_battle_rank_listview_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local list_view = params
                if list_view ~= nil and list_view.roots ~= nil and list_view.roots[1] ~= nil then
                    list_view:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 刷新
        local guard_battle_rank_listview_update_draw_terminal = {
            _name = "guard_battle_rank_listview_update_draw",
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

        state_machine.add(guard_battle_rank_listview_window_show_terminal)
        state_machine.add(guard_battle_rank_listview_window_hide_terminal)
        state_machine.add(guard_battle_rank_listview_update_draw_terminal)
        state_machine.init()
    end
    init_guard_battle_rank_listview_terminal()
end

function GuardBattleRankListview:onUpdateDraw()
    local root = self.roots[1]

    local ListView_guard_rank = ccui.Helper:seekWidgetByName(root, "ListView_guard_rank")
    self._list_view = ListView_guard_rank
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()

    local nType = self._from_type - 1
    local user_info = nil
    local my_id = 0
    if nType == 0 then
        my_id = tonumber(_ED.user_info.user_id)
    else
        if _ED.union.union_info == nil 
            or _ED.union.union_info == {} 
            or _ED.union.union_info.union_id == nil 
            or _ED.union.union_info.union_id == "" 
            or tonumber(_ED.union.union_info.union_id) == 0 
            then
        else
            my_id = tonumber(_ED.union.union_info.union_id)
        end
    end
    if _ED.guard_battle_rank_list ~= nil and _ED.guard_battle_rank_list[""..nType] ~= nil then
        for k, v in pairs(_ED.guard_battle_rank_list[""..nType]) do
            if tonumber(v.id) == my_id then
                user_info = v
            end
            local cell = state_machine.excute("guard_battle_rank_cell_create", 0, {k, v})
            self._list_view:addChild(cell)
        end
    end

    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()

    self._list_view:requestRefreshView()

    -- 个人信息
    local Text_guard_legion_name_t = ccui.Helper:seekWidgetByName(root, "Text_guard_legion_name_t")
    if self._from_type == 1 then
        Text_guard_legion_name_t:setString(red_alert_time_str[168])
    else
        Text_guard_legion_name_t:setString(red_alert_time_str[169])
    end
    local Text_guard_rank_now_n = ccui.Helper:seekWidgetByName(root, "Text_guard_rank_now_n")
    local Text_guard_rank_cotribution_n = ccui.Helper:seekWidgetByName(root, "Text_guard_rank_cotribution_n")
    if user_info == nil then
        Text_guard_rank_now_n:setString(red_alert_time_str[1])
        Text_guard_rank_cotribution_n:setString("0")
    else
        if zstring.tonumber(user_info.rank) > 0 then
            Text_guard_rank_now_n:setString(user_info.rank)
        else
            Text_guard_rank_now_n:setString(user_info.rank)
        end
        Text_guard_rank_cotribution_n:setString(exChangeNumToString(user_info.contribution))
    end
end

function GuardBattleRankListview:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_arrow_down:setVisible(true)
        else
            self._Image_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_arrow_up:setVisible(true)
        else
            self._Image_arrow_up:setVisible(false)
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

function GuardBattleRankListview:onInit()
    local csbItem = csb.createNode(string.format(config_csb.campaign.guard_battle_rank_tab, 1))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self._Image_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_guard_rank_arrow_down")
    self._Image_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_guard_rank_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_arrow_down:stopAllActions()
    self._Image_arrow_up:stopAllActions()
    playActions(self._Image_arrow_down)
    playActions(self._Image_arrow_up)
    self._Image_arrow_down:setVisible(false)
    self._Image_arrow_up:setVisible(false)

    self:onUpdateDraw()
end

function GuardBattleRankListview:onEnterTransitionFinish()
    
end

function GuardBattleRankListview:init(params)
    local rootWindow = params[1]
    self._from_type = params[2]         --1：个人贡献，2：军团贡献

    self._rootWindows = rootWindow

    self:onInit()
    return self
end

function GuardBattleRankListview:onExit()

end
