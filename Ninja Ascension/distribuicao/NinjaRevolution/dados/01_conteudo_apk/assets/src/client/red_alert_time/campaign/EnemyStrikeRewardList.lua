--------------------------------------------------------------------------------------------------------------
--  说明：敌军来袭-奖励列表
--------------------------------------------------------------------------------------------------------------
EnemyStrikeRewardList = class("EnemyStrikeRewardListClass", Window)

--打开界面
local enemy_strike_reward_list_open_terminal = {
    _name = "enemy_strike_reward_list_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = EnemyStrikeRewardList:new():init(params)
        fwin:open(panel)
        state_machine.excute("notification_center_update", 0, "push_notification_enemy_strike_reward")
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(enemy_strike_reward_list_open_terminal)
state_machine.init()

function EnemyStrikeRewardList:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self.listview = nil
    self.listview_poy = 0
    self.listview_height = 0
    self._Image_rebel_rank_arrow_down = nil
    self._Image_rebel_rank_arrow_up = nil

    self._max_count = 0

    local function init_enemy_strike_reward_list_terminal()
        local enemy_strike_reward_list_show_terminal = {
            _name = "enemy_strike_reward_list_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                instance.listview:jumpToBottom()
                state_machine.excute("notification_center_update", 0, "push_notification_enemy_strike_reward")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local enemy_strike_reward_list_hide_terminal = {
            _name = "enemy_strike_reward_list_hide",
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

        local enemy_strike_reward_list_update_info_terminal = {
            _name = "enemy_strike_reward_list_update_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(enemy_strike_reward_list_show_terminal)
        state_machine.add(enemy_strike_reward_list_hide_terminal)
        state_machine.add(enemy_strike_reward_list_update_info_terminal)
        state_machine.init()
    end
    
    init_enemy_strike_reward_list_terminal()
end

function EnemyStrikeRewardList:updateDraw()
    local root = self.roots[1]
    local ListView_rebel_week_rank = ccui.Helper:seekWidgetByName(root, "ListView_rebel_week_rank")
    ListView_rebel_week_rank:jumpToTop()
    ListView_rebel_week_rank:removeAllItems()

    local result = {}
    for k, v in pairs(_ED.enemy_strike_reward_list) do
        table.insert(result, v)
    end

    local function sortFunction(a, b)
        return a.times > b.times
    end
    table.sort(result, sortFunction)

    local reward_list = {}
    for i = 1, self._max_count do
        if result[i] ~= nil then
            table.insert(reward_list, result[i])
        end
    end

    for i = 1, #reward_list do
        local index = #reward_list - i + 1
        local cell = state_machine.excute("enemy_strike_reward_create_cell", 0, {1, 4, i, reward_list[index]})
        ListView_rebel_week_rank:addChild(cell)
    end
    
    ListView_rebel_week_rank:requestRefreshView()
    self.listview = ListView_rebel_week_rank
    self.listview_poy = ListView_rebel_week_rank:getInnerContainer():getPositionY()
    self.listview_height = ListView_rebel_week_rank:getInnerContainer():getPositionY()

    ListView_rebel_week_rank:getInnerContainer():setPositionY(10000)

    if _ED.user_enemy_strike_info ~= nil then
        _ED.last_enemy_strke_join_times = tonumber(_ED.user_enemy_strike_info.join_times)
    end
    state_machine.excute("notification_center_update", 0, "push_notification_enemy_strike_reward")
end

function EnemyStrikeRewardList:onUpdate(dt)
    if self.listview ~= nil then
        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
        if self.listview_height == 0 then
            self.listview_height = posY
        end
        if self.listview_poy <= -30 then
            self._Image_rebel_rank_arrow_down:setVisible(true)
        else
            self._Image_rebel_rank_arrow_down:setVisible(false)
        end
        if self.listview_poy >= self.listview_height + 30 then
            self._Image_rebel_rank_arrow_up:setVisible(true)
        else
            self._Image_rebel_rank_arrow_up:setVisible(false)
        end
        if self.listview_poy == posY then
            return
        end
        self.listview_poy = posY
        local items = self.listview:getItems()
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

--初始化
function EnemyStrikeRewardList:onInit()
    local csbItem = csb.createNode(string.format(config_csb.campaign.enemy_strike_tab, 4))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self._max_count = dms.int(dms["enemy_boss_config"], 15, enemy_boss_config.param)

    self._Image_rebel_rank_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_rebel_rank_arrow_down")
    self._Image_rebel_rank_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_rebel_rank_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_rebel_rank_arrow_down:stopAllActions()
    self._Image_rebel_rank_arrow_up:stopAllActions()
    playActions(self._Image_rebel_rank_arrow_down)
    playActions(self._Image_rebel_rank_arrow_up)
    self._Image_rebel_rank_arrow_down:setVisible(false)
    self._Image_rebel_rank_arrow_up:setVisible(false)

    self:updateDraw()
end

function EnemyStrikeRewardList:onEnterTransitionFinish()

end

function EnemyStrikeRewardList:init(param)
    self._rootWindows = param[1]
    self:onInit()
    return self
end

function EnemyStrikeRewardList:onExit()
    state_machine.remove("enemy_strike_reward_list_show")
    state_machine.remove("enemy_strike_reward_list_hide")
    state_machine.remove("enemy_strike_reward_list_update_info")
end