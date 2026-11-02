-- ------------------------------------------------------------------------------------------------------------
--  说明：极限挑战奖励
-- ------------------------------------------------------------------------------------------------------------
LimitDekaronReward = class("LimitDekaronRewardClass", Window)

--打开界面
local limit_dekaron_reward_open_terminal = {
    _name = "limit_dekaron_reward_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        local panel = LimitDekaronReward:new():init(params)
        fwin:open(panel, fwin._ui)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(limit_dekaron_reward_open_terminal)
state_machine.init()

function LimitDekaronReward:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._list_view = nil
    self._list_view_poy = 0
    self._list_view_height = 0

    self._Image_dekarona_reward_arrow_down = nil
    self._Image_dekarona_reward_arrow_up = nil

    local function init_limit_dekaron_reward_terminal()
        local limit_dekaron_reward_show_terminal = {
            _name = "limit_dekaron_reward_show",
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

        local limit_dekaron_reward_hide_terminal = {
            _name = "limit_dekaron_reward_hide",
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

        local limit_dekaron_reward_update_draw_terminal = {
            _name = "limit_dekaron_reward_update_draw",
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

        local limit_dekaron_reward_battle_rule_terminal = {
            _name = "limit_dekaron_reward_battle_rule",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("expedition_rule_infor_window_open",0,6)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(limit_dekaron_reward_show_terminal)
        state_machine.add(limit_dekaron_reward_hide_terminal)
        state_machine.add(limit_dekaron_reward_update_draw_terminal)
        state_machine.add(limit_dekaron_reward_battle_rule_terminal)
        state_machine.init()
    end
    init_limit_dekaron_reward_terminal()
end

function LimitDekaronReward:onUpdateDraw()
    local root = self.roots[1]

    local ListView_limit_dekarona_reward = ccui.Helper:seekWidgetByName(root, "ListView_limit_dekarona_reward")
    self._list_view = ListView_limit_dekarona_reward
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()

    local counts = dms.count(dms["limit_challenge_reward"])
    for i = 1, counts do
        local answer_data = dms.element(dms["limit_challenge_reward"], i)
        local info = {
            min_rank = dms.atoi(answer_data, limit_challenge_reward.min_rank),
            max_rank = dms.atoi(answer_data, limit_challenge_reward.max_rank),
            rewards = dms.atos(answer_data, limit_challenge_reward.rewards),
            activation_title = dms.atoi(answer_data, limit_challenge_reward.activation_title),
        }
        local cell = state_machine.excute("limit_dekarona_reward_cell_create", 0, {i, info,counts})
        self._list_view:addChild(cell)
    end

    self._list_view:requestRefreshView()
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
end

function LimitDekaronReward:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_dekarona_reward_arrow_down:setVisible(true)
        else
            self._Image_dekarona_reward_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_dekarona_reward_arrow_up:setVisible(true)
        else
            self._Image_dekarona_reward_arrow_up:setVisible(false)
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

function LimitDekaronReward:onInit()
    local csbItem = csb.createNode(string.format(config_csb.campaign.limit_dekarona_tab, 3))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_limit_dekarona_reward_infor"), nil, 
    {
        terminal_name = "limit_dekaron_reward_battle_rule", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

    self._Image_dekarona_reward_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_dekarona_reward_arrow_down")
    self._Image_dekarona_reward_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_dekarona_reward_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_dekarona_reward_arrow_down:stopAllActions()
    self._Image_dekarona_reward_arrow_up:stopAllActions()
    playActions(self._Image_dekarona_reward_arrow_down)
    playActions(self._Image_dekarona_reward_arrow_up)
    self._Image_dekarona_reward_arrow_down:setVisible(false)
    self._Image_dekarona_reward_arrow_up:setVisible(false)

    self:onUpdateDraw()
end

function LimitDekaronReward:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
    self:onInit()
    return self
end

function LimitDekaronReward:onExit()
    state_machine.remove("limit_dekaron_reward_show")
    state_machine.remove("limit_dekaron_reward_hide")
    state_machine.remove("limit_dekaron_reward_update_draw")
    state_machine.remove("limit_dekaron_reward_battle_rule")
end