--------------------------------------------------------------------------------------------------------------
--  守卫战奖励列表
--------------------------------------------------------------------------------------------------------------
GuardBattleRankReward = class("GuardBattleRankRewardClass", Window)

local guard_battle_rank_reward_window_open_terminal = {
    _name = "guard_battle_rank_reward_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local list_view = GuardBattleRankReward:new():init(params)
        fwin:open(list_view)
        return list_view
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(guard_battle_rank_reward_window_open_terminal)
state_machine.init()

function GuardBattleRankReward:ctor()
    self.super:ctor()
    self.roots = {}

    -- 
    self._list_view = nil
    self._list_view_poy = 0
    self._list_view_height = 0

    self._Image_arrow_down = nil
    self._Image_arrow_up = nil

    self._current_page = 0

    -- Initialize guard_battle_rank_reward state machine.
    local function init_guard_battle_rank_reward_terminal()
        --显示
        local guard_battle_rank_reward_window_show_terminal = {
            _name = "guard_battle_rank_reward_window_show",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 隐藏
        local guard_battle_rank_reward_window_hide_terminal = {
            _name = "guard_battle_rank_reward_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 刷新
        local guard_battle_rank_reward_update_draw_terminal = {
            _name = "guard_battle_rank_reward_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local posY = instance._list_view_poy
                instance:onUpdateDraw()
                if math.abs(posY) > math.abs(instance._list_view_height) then
                    posY = instance._list_view_height
                end
                instance._list_view:getInnerContainer():setPositionY(posY)   
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local guard_battle_rank_reward_change_page_terminal = {
            _name = "guard_battle_rank_reward_change_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local page = params._datas._page
                instance:changePage(page)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(guard_battle_rank_reward_window_show_terminal)
        state_machine.add(guard_battle_rank_reward_window_hide_terminal)
        state_machine.add(guard_battle_rank_reward_update_draw_terminal)
        state_machine.add(guard_battle_rank_reward_change_page_terminal)
        state_machine.init()
    end
    
    -- call func guard_battle_rank_reward create state machine.
    init_guard_battle_rank_reward_terminal()

end

function GuardBattleRankReward:changePage(page)
    local root = self.roots[1]
    if page == self._current_page then
        return
    end

    local Button_guard_personal_contribution = ccui.Helper:seekWidgetByName(root, "Button_guard_active_reward")
    local Button_guard_legion_reward = ccui.Helper:seekWidgetByName(root, "Button_guard_legion_reward")
    Button_guard_personal_contribution:setHighlighted(false)
    Button_guard_legion_reward:setHighlighted(false)

    if page == 1 then
        Button_guard_personal_contribution:setHighlighted(true)
    else
        Button_guard_legion_reward:setHighlighted(true)
    end
    self._current_page = page
    self:onUpdateDraw()
end

function GuardBattleRankReward:onUpdateDraw()
    local root = self.roots[1]
    local Text_guard_battle_time_n = ccui.Helper:seekWidgetByName(root, "Text_guard_battle_time_n")
    if _ED.guard_battle_user_info ~= nil then
        Text_guard_battle_time_n:setString(_ED.guard_battle_user_info.fight_count)
    else
        Text_guard_battle_time_n:setString("0")
    end

    local ListView_guard_battle_reward = ccui.Helper:seekWidgetByName(root, "ListView_guard_battle_reward")
    self._list_view = ListView_guard_battle_reward
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()

    if self._current_page == 1 then
        for i = 1, dms.count(dms["guard_active_reward"]) do
            local cell = state_machine.excute("guard_battle_rank_reward_cell_create", 0, {i, 2, i})
            self._list_view:addChild(cell)
        end
    else
        local cell = state_machine.excute("guard_battle_rank_reward_cell_create", 0, {1, 1, 0})
        self._list_view:addChild(cell)
        for i = 1, dms.count(dms["guard_union_reward"]) do
            local cell = state_machine.excute("guard_battle_rank_reward_cell_create", 0, {i + 1, 3, i})
            self._list_view:addChild(cell)
        end
    end

    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()

    self._list_view:requestRefreshView()
end

function GuardBattleRankReward:onUpdate(dt)
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

function GuardBattleRankReward:onInit()
    local csbItem = csb.createNode(string.format(config_csb.campaign.guard_battle_rank_tab, 2))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_guard_active_reward"), nil, 
    {
        terminal_name = "guard_battle_rank_reward_change_page", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        _page = 1,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_guard_legion_reward"), nil, 
    {
        terminal_name = "guard_battle_rank_reward_change_page", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        _page = 2,
    }, nil, 1)

    self._Image_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_guard_reward_arrow_down")
    self._Image_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_guard_reward_arrow_up")
    
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

    self:changePage(1)
end

function GuardBattleRankReward:onEnterTransitionFinish()
    
end

function GuardBattleRankReward:init(params)
    local rootWindow = params[1]

    self._rootWindows = rootWindow

    self:onInit()
    return self
end

function GuardBattleRankReward:onExit()
    state_machine.remove("guard_battle_rank_reward_window_show")
    state_machine.remove("guard_battle_rank_reward_window_hide")
    state_machine.remove("guard_battle_rank_reward_update_draw")
    state_machine.remove("guard_battle_rank_reward_change_page")   
end
