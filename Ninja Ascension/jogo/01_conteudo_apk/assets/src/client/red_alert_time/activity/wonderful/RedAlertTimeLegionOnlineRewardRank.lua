-----------------------------
-- 军团在线奖励幸运榜
-----------------------------
RedAlertTimeLegionOnlineRewardRank = class("RedAlertTimeLegionOnlineRewardRankClass", Window)

local red_alert_time_legion_online_reward_rank_window_open_terminal = {
    _name = "red_alert_time_legion_online_reward_rank_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeLegionOnlineRewardRankClass") then
            local panel = RedAlertTimeLegionOnlineRewardRank:new():init(params)
            fwin:open(panel, fwin._ui)
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_legion_online_reward_rank_window_close_terminal = {
    _name = "red_alert_time_legion_online_reward_rank_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local activityWindow = fwin:find("RedAlertTimeLegionOnlineRewardRankClass")
        fwin:close(activityWindow)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_legion_online_reward_rank_window_open_terminal)
state_machine.add(red_alert_time_legion_online_reward_rank_window_close_terminal)
state_machine.init()

function RedAlertTimeLegionOnlineRewardRank:ctor()
    self.super:ctor()
    self.roots = {}
    
    -- 定义变量
    self._list_view = nil
    self._list_view_poy = 0
    self._list_view_height = 0
    
    self._Image_arrow_down = nil
    self._Image_arrow_up = nil

    local function init_red_alert_time_legion_online_reward_rank_terminal()

    end
    init_red_alert_time_legion_online_reward_rank_terminal()
end

-- 刷新界面
function RedAlertTimeLegionOnlineRewardRank:onUpdateDraw()
    local root = self.roots[1]

    local ListView_legion_reward_rank = ccui.Helper:seekWidgetByName(root,"ListView_legion_reward_rank")
    self._list_view = ListView_legion_reward_rank
    self._list_view:removeAllItems()

    local result = {}
    if _ED.leagion_online_reward_record ~= nil then
        result = _ED.leagion_online_reward_record
    end
    local function sortFunction(a, b)
        return a.time > b.time
    end
    table.sort(result, sortFunction)

    for k, v in pairs(result) do
        local cell = state_machine.excute("legion_online_reward_rank_cell_create", 0, {k, v})
        self._list_view:addChild(cell)
    end

    self._list_view:requestRefreshView()
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
end

function RedAlertTimeLegionOnlineRewardRank:onEnterTransitionFinish()

end

function RedAlertTimeLegionOnlineRewardRank:onUpdate(dt)
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

function RedAlertTimeLegionOnlineRewardRank:onInit( )
    local csbItem = csb.createNode(config_csb.utils.legion_online_reward_rank) 
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    --关闭响应
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_window_bg"), nil, 
    {
        terminal_name = "red_alert_time_legion_online_reward_rank_window_close", 
        terminal_state = 0, 
    }, nil, 3)

    --关闭响应
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_legion_reward_rank_close"), nil, 
    {
        terminal_name = "red_alert_time_legion_online_reward_rank_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
    
    self._Image_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_reward_rank_arrow_down")
    self._Image_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_reward_rank_arrow_up")
    
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

function RedAlertTimeLegionOnlineRewardRank:init(params)
    self:onInit()
    return self
end

function RedAlertTimeLegionOnlineRewardRank:onExit()

end
