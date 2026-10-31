-- ------------------------------------------------------------------------------------------------------------
--  说明：学霸之战奖励
-- ------------------------------------------------------------------------------------------------------------
SuperScholarReward = class("SuperScholarRewardClass", Window)

--打开界面
local super_scholar_reward_open_terminal = {
    _name = "super_scholar_reward_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        local panel = SuperScholarReward:new():init(params)
        fwin:open(panel, fwin._ui)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(super_scholar_reward_open_terminal)
state_machine.init()

function SuperScholarReward:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_super_scholar_reward_down = nil
    self._Image_super_scholar_reward_up = nil

    local function init_super_scholar_reward_terminal()
        local super_scholar_reward_show_terminal = {
            _name = "super_scholar_reward_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                instance:onUpdateRankInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local super_scholar_reward_hide_terminal = {
            _name = "super_scholar_reward_hide",
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

        local super_scholar_reward_update_draw_terminal = {
            _name = "super_scholar_reward_update_draw",
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

        local super_scholar_reward_update_rank_info_terminal = {
            _name = "super_scholar_reward_update_rank_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateRankInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local super_scholar_reward_get_reward_terminal = {
            _name = "super_scholar_reward_get_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            state_machine.excute("super_scholar_reward_update_rank_info", 0, "")
                        end
                        checkRewardObtainDraw()
                    end
                end
                protocol_command.draw_answer_reward.param_list = ""
                NetworkManager:register(protocol_command.draw_answer_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(super_scholar_reward_show_terminal)
        state_machine.add(super_scholar_reward_hide_terminal)
        state_machine.add(super_scholar_reward_update_draw_terminal)
        state_machine.add(super_scholar_reward_update_rank_info_terminal)
        state_machine.add(super_scholar_reward_get_reward_terminal)
        state_machine.init()
    end
    init_super_scholar_reward_terminal()
end

function SuperScholarReward:onUpdateRankInfo()
    local root = self.roots[1]
    local Text_super_scholar_integral_n = ccui.Helper:seekWidgetByName(root, "Text_super_scholar_integral_n")
    local Text_super_scholar_integral_rank_n = ccui.Helper:seekWidgetByName(root, "Text_super_scholar_integral_rank_n")
    
    if _ED.answer_user_info == nil then
        Text_super_scholar_integral_n:setString("0")
        Text_super_scholar_integral_rank_n:setString(red_alert_time_str[112])
    else
        Text_super_scholar_integral_n:setString(_ED.answer_user_info.score)
        if tonumber(_ED.answer_user_info.rank) > 0 then
            Text_super_scholar_integral_rank_n:setString(_ED.answer_user_info.rank)
        else
            Text_super_scholar_integral_rank_n:setString(red_alert_time_str[112])
        end
    end

    -- 领取状态
    local Button_answer_choose_2 = ccui.Helper:seekWidgetByName(root, "Button_answer_choose_2")

    if _ED.answer_question_info ~= nil and tonumber(_ED.answer_question_info.state) ~= 0 then
        Button_answer_choose_2:setTouchEnabled(false)
        Button_answer_choose_2:setBright(false)
        Button_answer_choose_2:setTitleText(red_alert_time_str[128])
    elseif _ED.answer_user_info ~= nil and tonumber(_ED.answer_user_info.rank) > 0 and tonumber(_ED.answer_user_info.rank) <= 20 then
        if tonumber(_ED.answer_user_info.reward_state) == 1 then
            Button_answer_choose_2:setTouchEnabled(true)
            Button_answer_choose_2:setBright(true)
            Button_answer_choose_2:setTitleText(red_alert_time_str[128])
        else
            Button_answer_choose_2:setTouchEnabled(false)
            Button_answer_choose_2:setBright(false)
            Button_answer_choose_2:setTitleText(red_alert_time_str[129])
        end
    else
        Button_answer_choose_2:setTouchEnabled(false)
        Button_answer_choose_2:setBright(false)
        Button_answer_choose_2:setTitleText(red_alert_time_str[128])
    end
end

function SuperScholarReward:onUpdateDraw()
    local root = self.roots[1]

    local ListView_super_scholar_reward = ccui.Helper:seekWidgetByName(root, "ListView_super_scholar_reward")
    self._list_view = ListView_super_scholar_reward
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()
    if nil ~= ListView_super_scholar_reward.setBounceLeftBoundary then
        ListView_super_scholar_reward:setBounceLeftBoundary(0)
    end

    for i = 1, dms.count(dms["answer_reward"]) do
        local answer_data = dms.element(dms["answer_reward"], i)
        local info = {
            min_rank = dms.atoi(answer_data, answer_reward.min_rank),
            max_rank = dms.atoi(answer_data, answer_reward.max_rank),
            rewards = dms.atos(answer_data, answer_reward.rewards),
        }
        local cell = state_machine.excute("super_scholar_reward_cell_create", 0, {i, info})
        self._list_view:addChild(cell)
    end

    self._list_view:requestRefreshView()
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()

    self:onUpdateRankInfo()
end

function SuperScholarReward:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_super_scholar_reward_down:setVisible(true)
        else
            self._Image_super_scholar_reward_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_super_scholar_reward_up:setVisible(true)
        else
            self._Image_super_scholar_reward_up:setVisible(false)
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

function SuperScholarReward:onInit()
    local csbItem = csb.createNode(string.format(config_csb.campaign.super_scholar_tab, 3))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_answer_choose_2"), nil, 
    {
        terminal_name = "super_scholar_reward_get_reward", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    self._Image_super_scholar_reward_down = ccui.Helper:seekWidgetByName(root, "Image_super_scholar_reward_down")
    self._Image_super_scholar_reward_up = ccui.Helper:seekWidgetByName(root, "Image_super_scholar_reward_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_super_scholar_reward_down:stopAllActions()
    self._Image_super_scholar_reward_up:stopAllActions()
    playActions(self._Image_super_scholar_reward_down)
    playActions(self._Image_super_scholar_reward_up)
    self._Image_super_scholar_reward_down:setVisible(false)
    self._Image_super_scholar_reward_up:setVisible(false)

    self:onUpdateDraw()
end

function SuperScholarReward:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
    self:onInit()
    return self
end

function SuperScholarReward:onExit()
    state_machine.remove("super_scholar_reward_show")
    state_machine.remove("super_scholar_reward_hide")
    state_machine.remove("super_scholar_reward_update_draw")
    state_machine.remove("super_scholar_reward_update_rank_info")
    state_machine.remove("super_scholar_reward_get_reward")
end