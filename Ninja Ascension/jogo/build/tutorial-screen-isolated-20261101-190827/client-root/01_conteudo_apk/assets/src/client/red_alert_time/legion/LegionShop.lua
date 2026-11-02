-- ------------------------------------------------------------------------------------------------------------
--  说明：军团商店
-- ------------------------------------------------------------------------------------------------------------
LegionShop = class("LegionShopClass", Window)

--打开界面
local legion_shop_window_open_terminal = {
    _name = "legion_shop_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        state_machine.lock("legion_shop_window_open", 0, 0)
        local function responseCallback(response)
            state_machine.unlock("legion_shop_window_open", 0, 0)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if fwin:find("LegionShopClass") == nil then
                    local _win = LegionShop:new()
                    _win:init()
                    fwin:open(_win,fwin._ui)
                end
            end
        end
        protocol_command.union_shop_init.param_list = _ED.union.union_info.union_id
        NetworkManager:register(protocol_command.union_shop_init.code, nil, nil, nil, nil, responseCallback, false, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local legion_shop_window_close_terminal = {
    _name = "legion_shop_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LegionShopClass"))
        state_machine.excute("legion_active_task_update_draw", 0, "")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_shop_window_open_terminal)
state_machine.add(legion_shop_window_close_terminal)
state_machine.init()

function LegionShop:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- 1：道具，2：珍品
    self._last_page_index = 1

    self._list_view_page = {}

    app.load("client.red_alert_time.legion.LegionShopListview")
    app.load("client.red_alert_time.legion.LegionShopHelp")
    app.load("client.red_alert_time.cells.legion.legion_shop_cell")
    
     -- Initialize alert_home state machine.
    local function init_legion_shop_terminal()
        -- 切换页面
        local legion_shop_change_page_terminal = {
            _name = "legion_shop_change_page",
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
        local legion_shop_update_draw_terminal = {
            _name = "legion_shop_update_draw",
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

        local legion_shop_update_draw_all_terminal = {
            _name = "legion_shop_update_draw_all",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDrawAll()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_shop_change_page_terminal)
        state_machine.add(legion_shop_update_draw_terminal)
        state_machine.add(legion_shop_update_draw_all_terminal)  
        state_machine.init()
    end
    -- call func alert_home create state machine.
    init_legion_shop_terminal()
end

function LegionShop:onUpdateDrawAll()
    local root = self.roots[1]
    local Text_task_infor_1_0 = ccui.Helper:seekWidgetByName(root, "Text_task_infor_1_0")
    Text_task_infor_1_0:setString(_ED.union.user_union_info.rest_contribution)
    for k, v in pairs(self._list_view_page) do
        state_machine.excute("legion_shop_listview_update_draw", 0, v)
    end
end

-- 显示信息
function LegionShop:onUpdateDraw()
    local root = self.roots[1]

    local Panel_shop_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_shop_tab_box")
    local Button_legion_shop_props = ccui.Helper:seekWidgetByName(root, "Button_legion_shop_props")
    local Button_legion_shop_senior = ccui.Helper:seekWidgetByName(root, "Button_legion_shop_senior")
    local Text_task_infor_1_0 = ccui.Helper:seekWidgetByName(root, "Text_task_infor_1_0")
    local Text_task_infor_2 = ccui.Helper:seekWidgetByName(root, "Text_task_infor_2")

    Text_task_infor_1_0:setString(_ED.union.user_union_info.rest_contribution)

    for k, v in pairs(self._list_view_page) do
        state_machine.excute("legion_shop_listview_window_hide", 0, v)
    end
    Button_legion_shop_props:setTouchEnabled(false)
    Button_legion_shop_props:setHighlighted(true)
    Button_legion_shop_senior:setTouchEnabled(false)
    Button_legion_shop_senior:setHighlighted(true)
    if self._last_page_index == 1 then
        Button_legion_shop_senior:setTouchEnabled(true)
        Button_legion_shop_senior:setHighlighted(false)
        Text_task_infor_2:setString(tipString_legion_info[20])
        Text_task_infor_2:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
    else
        Button_legion_shop_props:setTouchEnabled(true)
        Button_legion_shop_props:setHighlighted(false)
        Text_task_infor_2:setString(tipString_legion_info[21])
        Text_task_infor_2:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
    end

    if self._list_view_page[""..self._last_page_index] == nil then
        self._list_view_page[""..self._last_page_index] = state_machine.excute("legion_shop_listview_window_open", 0, {Panel_shop_tab_box, self._last_page_index})
    else
        state_machine.excute("legion_shop_listview_window_show", 0, self._list_view_page[""..self._last_page_index])
    end
end

--初始化界面
function LegionShop:onInit()
    local csbItem = csb.createNode(config_csb.legion.legion_shop)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_shop_close"), nil, 
    {
        terminal_name = "legion_shop_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)    

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_shop_props"), nil, 
    {
        terminal_name = "legion_shop_change_page", 
        terminal_state = 0, 
        page_index = 1,
    }, nil, 1)    

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_shop_senior"), nil, 
    {
        terminal_name = "legion_shop_change_page", 
        terminal_state = 0, 
        page_index = 2,
    }, nil, 1)    

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_task_infor"), nil, 
    {
        terminal_name = "legion_shop_help_window_open", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)   

    self:onUpdateDraw()
end

--初始化
function LegionShop:init()
    self:setTouchEnabled(true)
    self:onInit()
end

--移除状态机
function LegionShop:onExit()
    state_machine.remove("legion_shop_change_page")
    state_machine.remove("legion_shop_update_draw")
    state_machine.remove("legion_shop_update_draw_all")
end