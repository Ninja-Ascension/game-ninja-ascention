-- ------------------------------------------------------------------------------------------------------------
--  说明：商店和背包
-- ------------------------------------------------------------------------------------------------------------
PropsShopPacks = class("PropsShopPacksClass", Window)

--打开界面
local props_shop_packs_window_open_terminal = {
    _name = "props_shop_packs_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("PropsShopPacksClass") == nil then
            local page_index = params._datas.page_index
            local _win = PropsShopPacks:new()
            _win:init(page_index)
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local props_shop_packs_window_close_terminal = {
    _name = "props_shop_packs_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PropsShopPacksClass"))
        state_machine.excute("notification_center_update", 0, "push_notification_home_button_packs")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(props_shop_packs_window_open_terminal)
state_machine.add(props_shop_packs_window_close_terminal)
state_machine.init()

function PropsShopPacks:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- 1：商店，2：背包
    self._last_page_index = 0

    self._pages = {}

    app.load("client.red_alert_time.props.PropsShopPacksPacksTab")
    app.load("client.red_alert_time.props.PropsShopPacksShopTab")
    app.load("client.red_alert_time.props.PropsBatchUse")
     -- Initialize alert_home state machine.
    local function init_props_shop_packs_terminal()
        --显示所有
        local props_shop_packs_window_show_terminal = {
            _name = "props_shop_packs_window_show",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    instance:onShow()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 隐藏所有
        local props_shop_packs_window_hide_terminal = {
            _name = "props_shop_packs_window_hide",
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
        -- 切换页面
        local props_shop_packs_change_page_terminal = {
            _name = "props_shop_packs_change_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance._last_page_index = params._datas.page_index
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新
        local props_shop_packs_update_draw_terminal = {
            _name = "props_shop_packs_update_draw",
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

        -- 关闭
        local props_shop_packs_window_close_check_terminal = {
            _name = "props_shop_packs_window_close_check",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("props_shop_packs_window_close", 0, 0)
                state_machine.excute("main_window_check_mission", 0, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(props_shop_packs_window_show_terminal)
        state_machine.add(props_shop_packs_window_hide_terminal)  
        state_machine.add(props_shop_packs_change_page_terminal)  
        state_machine.add(props_shop_packs_update_draw_terminal)
        state_machine.add(props_shop_packs_window_close_check_terminal)  
        state_machine.init()
    end
    -- call func alert_home create state machine.
    init_props_shop_packs_terminal()
end

--显示
function PropsShopPacks:onShow()
   self:setVisible(true)
end

--隐藏
function PropsShopPacks:onHide()
   self:setVisible(false)
end

--初始化界面
function PropsShopPacks:onInit()
    local csbItem = csb.createNode(config_csb.props.props_shop_packs)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    self.__check_covers = true
    root.__cwindow = self
    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_shop_packs_close"), nil, 
    {
        terminal_name = "props_shop_packs_window_close_check", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)    

    -- 商店
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_shop"), nil, 
    {
        terminal_name = "props_shop_packs_change_page", 
        terminal_state = 0, 
        page_index = 1,
    }, nil, 1)   

    -- 背包
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_packs"), nil, 
    {
        terminal_name = "props_shop_packs_change_page", 
        terminal_state = 0, 
        page_index = 2,
    }, nil, 1)   
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_packs",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_packs"),
    _invoke = nil,
    _interval = 0.2,})

    self:onUpdateDraw()
end

-- 显示信息
function PropsShopPacks:onUpdateDraw()
    local root = self.roots[1]

    local Text_have_gold_n = ccui.Helper:seekWidgetByName(root, "Text_have_gold_n")
    Text_have_gold_n:setString(_ED.user_info.user_gold)

    local Panel_props_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_props_tab_box")
    local Button_shop = ccui.Helper:seekWidgetByName(root, "Button_shop")
    local Button_packs = ccui.Helper:seekWidgetByName(root, "Button_packs")

    for i, page in pairs(self._pages) do 
        page:setVisible(false)
    end   

    if self._last_page_index == 1 then
        Button_shop:setHighlighted(true)
        Button_shop:setTouchEnabled(false)
        Button_packs:setHighlighted(false)
        Button_packs:setTouchEnabled(true)
        if self._pages["1"] == nil then
            self._pages["1"] = state_machine.excute("props_shop_packs_shop_tab_window_open", 0, {Panel_props_tab_box})
        end
        self._pages["1"]:setVisible(true)
    else
        Button_shop:setHighlighted(false)
        Button_shop:setTouchEnabled(true)
        Button_packs:setHighlighted(true)
        Button_packs:setTouchEnabled(false)

        if self._pages["2"] == nil then
            self._pages["2"] = state_machine.excute("props_shop_packs_packs_tab_window_open", 0, {Panel_props_tab_box})
        else
            state_machine.excute("props_shop_packs_packs_tab_change_page", 0, nil)
        end
        self._pages["2"]:setVisible(true)
    end

end

--初始化
function PropsShopPacks:init(params)
    self._last_page_index = params
    self:setTouchEnabled(true)
    self:onInit()
end

--移除状态机
function PropsShopPacks:onExit()
    state_machine.remove("props_shop_packs_window_show")
    state_machine.remove("props_shop_packs_window_hide")
    state_machine.remove("props_shop_packs_change_page")
    state_machine.remove("props_shop_packs_update_draw")
    state_machine.remove("props_shop_packs_window_close_check")
end