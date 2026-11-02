-----------------------------
-- 折扣卖场
-----------------------------
RedAlertTimeDiscountStoreReward = class("RedAlertTimeDiscountStoreRewardClass", Window)

local red_alert_time_discount_store_reward_window_open_terminal = {
    _name = "red_alert_time_discount_store_reward_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeDiscountStoreRewardClass") then
            local panel = RedAlertTimeDiscountStoreReward:new():init(params)
            fwin:open(panel, fwin._ui)
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_discount_store_reward_window_close_terminal = {
    _name = "red_alert_time_discount_store_reward_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local activityWindow = fwin:find("RedAlertTimeDiscountStoreRewardClass")
        fwin:close(activityWindow)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_discount_store_reward_window_open_terminal)
state_machine.add(red_alert_time_discount_store_reward_window_close_terminal)
state_machine.init()

function RedAlertTimeDiscountStoreReward:ctor()
    self.super:ctor()
    self.roots = {}

    self._activity_info = nil
    self._activity_type = 0
    
    self._list_view = nil
    self._list_view_poy = 0
    self._list_view_height = 0
    
    self._Image_arrow_down = nil
    self._Image_arrow_up = nil

    app.load("client.red_alert_time.cells.activity.treasurehouse.red_alert_time_discount_store_reward_cell")
    
    local function init_red_alert_time_discount_store_reward_terminal()
        -- 刷新
        local red_alert_time_discount_store_reward_update_draw_terminal = {
            _name = "red_alert_time_discount_store_reward_update_draw",
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
                instance._list_view_poy = posY + 1
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_discount_store_reward_update_gold_info_terminal = {
            _name = "red_alert_time_discount_store_reward_update_gold_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateGoldInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_discount_store_reward_rule_infor_terminal = {
            _name = "red_alert_time_discount_store_reward_rule_infor",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("red_alert_time_rule_infor_window_open",0,instance._activity_type)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_discount_store_reward_update_draw_terminal)
        state_machine.add(red_alert_time_discount_store_reward_update_gold_info_terminal)
        state_machine.add(red_alert_time_discount_store_reward_rule_infor_terminal)
        state_machine.init()
    end
    init_red_alert_time_discount_store_reward_terminal()
end

-- 刷新界面
function RedAlertTimeDiscountStoreReward:onUpdateDraw()
    local root = self.roots[1]
    self._activity_info = _ED.activity_info[""..self._activity_type]

    -- 活动说明
    local Text_discount_store_reward_name = ccui.Helper:seekWidgetByName(root,"Text_discount_store_reward_name")
    local Text_discount_store_reward_infor_p_1 = ccui.Helper:seekWidgetByName(root,"Text_discount_store_reward_infor_p_1")

    Text_discount_store_reward_name:setString(self._activity_info.activity_title)
    Text_discount_store_reward_infor_p_1:setString(self._activity_info.activity_dec)

    -- 活动结束倒计时
    local activity_add_state = zstring.split(self._activity_info.activity_add_state, ",")
    self.m_times = tonumber(activity_add_state[2]) / 1000 - (os.time() + _ED.time_add_or_sub)

    local Text_discount_store_reward_time_1 = ccui.Helper:seekWidgetByName(root,"Text_discount_store_reward_time_1")
    Text_discount_store_reward_time_1:removeAllChildren(true)
    Text_discount_store_reward_time_1:setString("")
    local time_info, time_int = createActivityTimeLable(Text_discount_store_reward_time_1, 0, activity_str_tip[93], getRedAlertTimeActivityFormat(self.m_times))
    Text_discount_store_reward_time_1:addChild(time_info)
    Text_discount_store_reward_time_1:addChild(time_int)
    self._label_close_text = time_int

    self:onUpdateGoldInfo()
    self:onUpdateList()
end

function RedAlertTimeDiscountStoreReward:onUpdateGoldInfo()
    local root = self.roots[1]
    -- 拥有金币
    local Text_discount_store_reward_gold_n = ccui.Helper:seekWidgetByName(root,"Text_discount_store_reward_gold_n")
    Text_discount_store_reward_gold_n:setString(_ED.user_info.user_gold)
end

function RedAlertTimeDiscountStoreReward:onUpdateList()
    local root = self.roots[1]
    self._activity_info = _ED.activity_info[""..self._activity_type]
    
    local ListView_discount_store_reward = ccui.Helper:seekWidgetByName(root,"ListView_discount_store_reward")
    self._list_view = ListView_discount_store_reward
    self._list_view:jumpToTop()

    local result = self._activity_info.activity_data[1]

    local items = self._list_view:getItems()
    for k,v in pairs(items) do
        state_machine.excute("red_alert_time_discount_store_reward_cell_update_info", 0, {cell = v, index = k, info = result[k]})
    end

    if #items > #result then
        local index = 0
        for i=#result + 1, #items do
            self._list_view:removeItem(#items - index - 1)
            index = index + 1
        end
    elseif #items < #result then
        for i=#items + 1, #result do
            local cell = state_machine.excute("red_alert_time_discount_store_reward_cell_create", 0, {i, result[i], self._activity_type, 1})
            self._list_view:addChild(cell)
        end
    end

    self._list_view:requestRefreshView()
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
end

function RedAlertTimeDiscountStoreReward:onEnterTransitionFinish()

end

function RedAlertTimeDiscountStoreReward:onUpdate(dt)
    if self.m_times > 0 then
        self.m_times = self.m_times - dt
        if self._label_close_text ~= nil then
            self._label_close_text:setString(getRedAlertTimeActivityFormat(self.m_times))
        end
        if self.m_times <= 0 then
            self.m_times = 0
            state_machine.excute("notification_center_update", 0, "red_alert_time_discount_store_reward_window_close")
        end
    end

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

function RedAlertTimeDiscountStoreReward:onInit( )
    local csbItem = csb.createNode(config_csb.treasurehouse.discount_store_reward)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    --关闭响应
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_discount_store_reward_close"), nil, 
    {
        terminal_name = "red_alert_time_discount_store_reward_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_discount_store_reward_rule_infor"), nil, 
    {
        terminal_name = "red_alert_time_discount_store_reward_rule_infor", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)
    
    self._Image_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_discount_store_reward_arrow_down")
    self._Image_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_discount_store_reward_arrow_up")
    
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

function RedAlertTimeDiscountStoreReward:init(params)
    self._activity_info = params[1]
    self._activity_type = self._activity_info.activity_type
    self:onInit()
    return self
end

function RedAlertTimeDiscountStoreReward:onExit()
    -- 移除状态机
    state_machine.remove("red_alert_time_discount_store_reward_update_draw")
    state_machine.remove("red_alert_time_discount_store_reward_update_gold_info")
    state_machine.remove("red_alert_time_discount_store_reward_rule_infor")
end
