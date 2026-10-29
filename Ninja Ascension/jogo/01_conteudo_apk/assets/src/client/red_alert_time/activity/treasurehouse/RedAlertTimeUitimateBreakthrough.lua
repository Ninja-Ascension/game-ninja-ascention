-----------------------------
-- 极限突破
-----------------------------
RedAlertTimeUitimateBreakthrough = class("RedAlertTimeUitimateBreakthroughClass", Window)

local red_alert_time_uitimate_breakthrough_window_open_terminal = {
    _name = "red_alert_time_uitimate_breakthrough_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeUitimateBreakthroughClass") then
            local panel = RedAlertTimeUitimateBreakthrough:new():init(params)
            fwin:open(panel, fwin._ui)
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_uitimate_breakthrough_window_close_terminal = {
    _name = "red_alert_time_uitimate_breakthrough_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local activityWindow = fwin:find("RedAlertTimeUitimateBreakthroughClass")
        fwin:close(activityWindow)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_uitimate_breakthrough_window_open_terminal)
state_machine.add(red_alert_time_uitimate_breakthrough_window_close_terminal)
state_machine.init()

function RedAlertTimeUitimateBreakthrough:ctor()
    self.super:ctor()
    self.roots = {}
    
    -- 定义变量
    self._current_page = 0

    self._gift_panel = nil
    self._bless_panel = nil

    self._activity_info = nil
    self._activity_type = 0

    self.m_times = 0

    -- 加载lua文件
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeUitimateBreakthroughBuy")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeFalconAssaultReform")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeUitimateBreakthroughRecord")

    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeLeaderSeniorOnce")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeLeaderSeniorTen")

    -- 初始化状态机
    local function init_red_alert_time_uitimate_breakthrough_terminal()
        -- 刷新
        local red_alert_time_uitimate_breakthrough_update_draw_terminal = {
            _name = "red_alert_time_uitimate_breakthrough_update_draw",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDraw()
                state_machine.excute("red_alert_time_uitimate_breakthrough_buy_update_draw", 0, "")
                state_machine.excute("red_alert_time_falcon_assault_reform_update_draw", 0, "")
                state_machine.excute("red_alert_time_uitimate_breakthrough_record_update_draw", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        local red_alert_time_uitimate_breakthrough_change_page_terminal = {
            _name = "red_alert_time_uitimate_breakthrough_change_page",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:changeSelectPage(tonumber(params._datas._page))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_uitimate_breakthrough_update_draw_terminal)
        state_machine.add(red_alert_time_uitimate_breakthrough_change_page_terminal)
        state_machine.init()
    end
    init_red_alert_time_uitimate_breakthrough_terminal()
end

-- 切换页面
function RedAlertTimeUitimateBreakthrough:changeSelectPage( page )
    local root = self.roots[1]

    local Panel_largesse_give_tab = ccui.Helper:seekWidgetByName(root, "Panel_largesse_give_tab")
    local Button_discount_store_hot_buy = ccui.Helper:seekWidgetByName(root, "Button_discount_store_hot_buy")
    local Button_discount_store_buy = ccui.Helper:seekWidgetByName(root, "Button_discount_store_buy")
    local Button_discount_store_shop = ccui.Helper:seekWidgetByName(root, "Button_discount_store_shop")
    if page == self._current_page then
        if page == 1 then
            Button_discount_store_hot_buy:setHighlighted(true)
        elseif page == 2 then
            Button_discount_store_buy:setHighlighted(true)
        elseif page == 3 then
            Button_discount_store_shop:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_discount_store_hot_buy:setHighlighted(false)
    Button_discount_store_buy:setHighlighted(false)
    Button_discount_store_shop:setHighlighted(false)
    state_machine.excute("red_alert_time_uitimate_breakthrough_buy_hide", 0, nil)
    state_machine.excute("red_alert_time_falcon_assault_reform_hide", 0, nil)
    state_machine.excute("red_alert_time_uitimate_breakthrough_record_hide", 0, nil)
    if page == 1 then
        Button_discount_store_hot_buy:setHighlighted(true)
        if self._buy_panel == nil then
            self._buy_panel = state_machine.excute("red_alert_time_uitimate_breakthrough_buy_open", 0, {Panel_largesse_give_tab, self._activity_type})
        else
            state_machine.excute("red_alert_time_uitimate_breakthrough_buy_show", 0, nil)
        end
    elseif page == 2 then
        Button_discount_store_buy:setHighlighted(true)
        if self._reform_panel == nil then
            self._reform_panel = state_machine.excute("red_alert_time_falcon_assault_reform_open", 0, {Panel_largesse_give_tab, self._activity_type})
        else
            state_machine.excute("red_alert_time_falcon_assault_reform_show", 0, nil)
        end
    elseif page == 3 then
        Button_discount_store_shop:setHighlighted(true)
        if self._record_panel == nil then
            self._record_panel = state_machine.excute("red_alert_time_uitimate_breakthrough_record_open", 0, {Panel_largesse_give_tab, self._activity_type})
        else
            state_machine.excute("red_alert_time_uitimate_breakthrough_record_show", 0, nil)
        end
    end

    self:onUpdateDraw()
end

-- 刷新界面
function RedAlertTimeUitimateBreakthrough:onUpdateDraw()
    local root = self.roots[1]
    
    local activity_info = _ED.activity_info[""..self._activity_type]
    local activity_add_state_arr = zstring.split(activity_info.activity_add_state, "!")
    local activity_add_state = zstring.split(activity_add_state_arr[1], ",")

    -- 名称
    local Text_recharge_bonus_name = ccui.Helper:seekWidgetByName(root,"Text_recharge_bonus_name")
    Text_recharge_bonus_name:setString(activity_info.activity_title)

    -- 结束时间
    self.m_times = tonumber(activity_add_state[2]) / 1000 - (os.time() + _ED.time_add_or_sub)
end

function RedAlertTimeUitimateBreakthrough:onUpdate(dt)
    if self.m_times > 0 then
        self.m_times = self.m_times - dt
        if self.m_times <= 0 then
            self.m_times = 0
            state_machine.excute("notification_center_update", 0, "red_alert_time_uitimate_breakthrough_window_close")
        end
    end
end

function RedAlertTimeUitimateBreakthrough:onEnterTransitionFinish()

end

function RedAlertTimeUitimateBreakthrough:onInit( )
    local csbItem = csb.createNode(config_csb.treasurehouse.uitimate_breakthrough)  
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    --关闭响应(替换按钮)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_recharge_bonus_close"), nil, 
    {
        terminal_name = "red_alert_time_uitimate_breakthrough_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_discount_store_hot_buy"), nil, 
    {
        terminal_name = "red_alert_time_uitimate_breakthrough_change_page", 
        terminal_state = 0, 
        _page = 1,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_discount_store_buy"), nil, 
    {
        terminal_name = "red_alert_time_uitimate_breakthrough_change_page", 
        terminal_state = 0, 
        _page = 2,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_discount_store_shop"), nil, 
    {
        terminal_name = "red_alert_time_uitimate_breakthrough_change_page", 
        terminal_state = 0, 
        _page = 3,
    }, nil, 1)

    self:changeSelectPage(1)
end

function RedAlertTimeUitimateBreakthrough:init(params)
    self._activity_info = params[1]
    self._activity_type = tonumber(self._activity_info.activity_type)
    self:onInit()
    return self
end

function RedAlertTimeUitimateBreakthrough:onExit()
    -- 移除状态机
    state_machine.remove("red_alert_time_uitimate_breakthrough_update_draw")
    state_machine.remove("red_alert_time_uitimate_breakthrough_change_page")
end
