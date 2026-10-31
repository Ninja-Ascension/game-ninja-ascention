-- ------------------------------------------------------------------------------------------------------------
--  奖励仓库
-- ------------------------------------------------------------------------------------------------------------
LegionWelfareReward = class("LegionWelfareRewardClass", Window)

local legion_welfare_reward_window_open_terminal = {
    _name = "legion_welfare_reward_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _wind = LegionWelfareReward:new():init(params)
        fwin:open(_wind)
        return _wind
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(legion_welfare_reward_window_open_terminal)
state_machine.init()

function LegionWelfareReward:ctor()
    self.super:ctor()
    self.roots = {}

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_welfare_arrow_down = nil
    self._Image_welfare_arrow_up = nil

    -- Initialize legion_welfare_reward state machine.
    local function init_legion_welfare_reward_terminal()
        --显示
        local legion_welfare_reward_window_show_terminal = {
            _name = "legion_welfare_reward_window_show",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 隐藏
        local legion_welfare_reward_window_hide_terminal = {
            _name = "legion_welfare_reward_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 刷新
        local legion_welfare_reward_update_draw_terminal = {
            _name = "legion_welfare_reward_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_welfare_reward_window_show_terminal)
        state_machine.add(legion_welfare_reward_window_hide_terminal)
        state_machine.add(legion_welfare_reward_update_draw_terminal)
        state_machine.init()
    end

    init_legion_welfare_reward_terminal()
end

--显示
function LegionWelfareReward:onShow()
   self:setVisible(true)
end

--隐藏
function LegionWelfareReward:onHide()
   self:setVisible(false)
end

function LegionWelfareReward:onUpdateDraw()
    local root = self.roots[1]

    local ListView_legion_welfare = ccui.Helper:seekWidgetByName(root, "ListView_legion_welfare")
    self._list_view = ListView_legion_welfare
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()

    if _ED.union.union_pack_reward_info ~= nil and _ED.union.union_pack_reward_info ~= "-1" then
        local reward_info = zstring.split(_ED.union.union_pack_reward_info, "|")
        for k,v in pairs(reward_info) do
            local cell = state_machine.excute("legion_welfare_cell_create", 0, {k, v})
            self._list_view:addChild(cell)
        end
    end

    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()

    self._list_view:requestRefreshView()
end

function LegionWelfareReward:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_welfare_arrow_down:setVisible(true)
        else
            self._Image_welfare_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_welfare_arrow_up:setVisible(true)
        else
            self._Image_welfare_arrow_up:setVisible(false)
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

function LegionWelfareReward:onInit()
    local csbItem = csb.createNode(string.format(config_csb.legion.legion_welfare_tab, 1))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_reward_distrbution"), nil, 
    {
        terminal_name = "legion_welfare_distribution_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    self._Image_welfare_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_welfare_arrow_down")
    self._Image_welfare_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_welfare_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_welfare_arrow_down:stopAllActions()
    self._Image_welfare_arrow_up:stopAllActions()
    playActions(self._Image_welfare_arrow_down)
    playActions(self._Image_welfare_arrow_up)
    self._Image_welfare_arrow_down:setVisible(false)
    self._Image_welfare_arrow_up:setVisible(false)


    self:onUpdateDraw()
end

function LegionWelfareReward:onEnterTransitionFinish()
    
end

function LegionWelfareReward:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
    self:onInit()
    return self
end

function LegionWelfareReward:onExit()
    state_machine.remove("legion_welfare_reward_window_show")
    state_machine.remove("legion_welfare_reward_window_hide")
    state_machine.remove("legion_welfare_reward_update_draw")
end
