-----------------------------
--主界面顶部活动按钮
-----------------------------
HomeButtonCell = class("HomeButtonCellClass", Window)
HomeButtonCell.__size = nil

local home_button_cell_create_terminal = {
    _name = "home_button_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = HomeButtonCell:new()
        local activity_type = params[1]
        cell:init(activity_type)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(home_button_cell_create_terminal)
state_machine.init()

function HomeButtonCell:ctor()
    self.super:ctor()
    self.roots = {}
    self._type = 0

    -- Initialize home_button_cell state machine.
    local function init_home_button_cell_terminal()
        -- 打开开服狂欢活动
        local home_button_cell_choose_activity_terminal = {
            _name = "home_button_cell_choose_activity",
            _init = function (terminal)
                  
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)           
                state_machine.excute("wonderful_open_window_open", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local home_button_cell_open_select_open_activity_terminal = {
            _name = "home_button_cell_open_select_open_activity",
            _init = function (terminal)
                  
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)           
                state_machine.excute("wonderful_window_open", 0, params._datas.activity_type)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(home_button_cell_choose_activity_terminal)
        state_machine.add(home_button_cell_open_select_open_activity_terminal)
        state_machine.init()
    end
    
    init_home_button_cell_terminal()
end

-- 判断大转盘活动是否存在当达到积分或可以开宝箱时显示推送动画
function HomeButtonCell:onUpdate()
    if self._activity == nil and self._panel_cost == nil then
        return
    end
    self._panel_cost:setVisible(false)
    if getActivityCostRaotaryTips() == true then 
        self._panel_cost:setVisible(true)
    end
end

function HomeButtonCell:onInit()
    -- 主界面顶部活动动画资源加载
    for i, v in pairs(config_res.sprites_cached["home_button_activity"]) do
        cc.SpriteFrameCache:getInstance():addSpriteFrames(v)
    end
    -- 绘图初始化
    local root = cacher.createUIRef(config_csb.cells.home.home_button_cell, "root")
    -- local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)

    if HomeButtonCell.__size == nil then
        HomeButtonCell.__size = root:getContentSize()
    end

    self:setContentSize(HomeButtonCell.__size)

    -- 登录送
    local Button_login = ccui.Helper:seekWidgetByName(root, "Button_login")
    Button_login:setVisible(false)

    -- 开服活动
    local Button_open_woderful = ccui.Helper:seekWidgetByName(root, "Button_open_woderful")
    Button_open_woderful:setVisible(false)
    fwin:addTouchEventListener(Button_open_woderful, nil, 
    {
        terminal_name = "home_button_cell_choose_activity",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 2)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_home_button_open_activity",
    _widget = Button_open_woderful,
    _invoke = nil,
    _interval = 0.5,})

    -- 98元五倍返
    local Button_98 = ccui.Helper:seekWidgetByName(root, "Button_98")
    Button_98:setVisible(false)


    -- 首冲/二冲/三冲
    local Button_first_charge = ccui.Helper:seekWidgetByName(root, "Button_first_charge")
    Button_first_charge:setVisible(false)
    fwin:addTouchEventListener(Button_first_charge, nil, 
    {
        terminal_name = "activity_frist_recharge_top_window_open",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 2)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_home_button_activity_frsit_recharge",
    _widget = Button_first_charge,
    _invoke = nil,
    _interval = 0.5,})

    -- 开服冲Top
    local Button_top = ccui.Helper:seekWidgetByName(root, "Button_top")
    Button_top:setVisible(false)
    fwin:addTouchEventListener(Button_top, nil, 
    {
        terminal_name = "server_top_rank_window_open",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 2)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_home_button_server_top_rank",
    _widget = Button_top,
    _invoke = nil,
    _interval = 0.5,})

    -- 积分大转盘
    local Button_cost_rotary = ccui.Helper:seekWidgetByName(root, "Button_cost_rotary")
    Button_cost_rotary:setVisible(false)
    fwin:addTouchEventListener(Button_cost_rotary, nil, 
    {
        terminal_name = "activity_cost_rotary_window_open",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 2)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_home_button_activity_cost_rotary",
    _widget = Button_cost_rotary,
    _invoke = nil,
    _interval = 0.5,})

    -- 积分大转盘排行榜
    local Button_cost_rotary_rank = ccui.Helper:seekWidgetByName(root, "Button_cost_rotary_rank")
    print(Button_cost_rotary_rank)
    Button_cost_rotary_rank:setVisible(false)
    fwin:addTouchEventListener(Button_cost_rotary_rank, nil, 
    {
        terminal_name = "activity_cost_rotary_rank_window_open",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 2)

    -- 元宝大转盘
    local Button_cost_rotary_all = ccui.Helper:seekWidgetByName(root, "Button_cost_rotary_all")
    Button_cost_rotary_all:setVisible(false)
    fwin:addTouchEventListener(Button_cost_rotary_all, nil, 
    {
        terminal_name = "activity_cost_rotary_all_window_open",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 2)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_home_button_activity_cost_rotary_all",
    _widget = Button_cost_rotary_all,
    _invoke = nil,
    _interval = 0.5,})
    
    -- 冲级奖励(特殊渠道)
    local Button_up_lv = ccui.Helper:seekWidgetByName(root, "Button_up_lv")
    Button_up_lv:setVisible(false)
    fwin:addTouchEventListener(Button_up_lv, nil, 
    {
        terminal_name = "home_button_cell_open_select_open_activity",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
        activity_type = 39,
    }, nil, 2)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_home_button_activity_up_level_two",
    _widget = Button_up_lv,
    _invoke = nil,
    _interval = 0.5,})

    -- 首冲
    local Panel_charge_1 = ccui.Helper:seekWidgetByName(root, "Panel_charge_1")
    local Image_first_1 = ccui.Helper:seekWidgetByName(root, "Image_first_1")
    Panel_charge_1:setVisible(false)
    Image_first_1:setVisible(false)
    -- 二冲
    local Panel_charge_2 = ccui.Helper:seekWidgetByName(root, "Panel_charge_2")
    local Image_first_2 = ccui.Helper:seekWidgetByName(root, "Image_first_2")
    Panel_charge_2:setVisible(false)
    Image_first_2:setVisible(false)
    -- 三冲
    local Panel_charge_3 = ccui.Helper:seekWidgetByName(root, "Panel_charge_3")
    local Image_first_3 = ccui.Helper:seekWidgetByName(root, "Image_first_3")
    Panel_charge_3:setVisible(false)
    Image_first_3:setVisible(false)
    
    if self._type == 22 then    -- 积分大转盘
        Button_cost_rotary:setVisible(true)
    elseif self._type == 2 then     
        if tonumber(_ED.activity_info["2"].activity_data[1][1].achieve_state) < 2 then -- 首冲
            Image_first_1:setVisible(true)
            Panel_charge_1:setVisible(true)
        elseif tonumber(_ED.activity_info["2"].activity_data[1][2].achieve_state) < 2 then -- 二冲
            Image_first_2:setVisible(true)
            Panel_charge_2:setVisible(true)
        elseif tonumber(_ED.activity_info["2"].activity_data[1][3].achieve_state) < 2 then -- 三冲
            Image_first_3:setVisible(true)
            Panel_charge_3:setVisible(true)
        end
        Button_first_charge:setVisible(true)
    elseif self._type == 23 or self._type == 40 then --开服冲Top
        Button_top:setVisible(true)
    elseif self._type == 100 then -- 开服活动
        Button_open_woderful:setVisible(true)
    elseif self._type == 37 then    -- 元宝大转盘
        Button_cost_rotary_all:setVisible(true)
    elseif self._type == 39 then    -- 冲级奖励(特殊渠道)
        local page = tonumber(zstring.split(_ED.activity_info["39"].activity_add_state, ",")[1]) + 1
        if table.nums(_ED.activity_info["39"].activity_data[page]) > 0 then
            Button_up_lv:setVisible(true)
            local name = zstring.split(_ED.activity_info["39"].activity_add_state, ",")[2]
            local button_name = "images/ui/wonderful/button_acti_road_"..name..".png"
            if cc.FileUtils:getInstance():isFileExist(button_name) == false then
                button_name = "images/ui/wonderful/button_acti_road_"..wonderful_operator_activity_str[1][1]..".png"
            end
            Button_up_lv:loadTextures(button_name,button_name,button_name)
        end
    elseif self._type == 42 then    -- 积分大转盘排行榜
        Button_cost_rotary_rank:setVisible(true)
    end

    -- 判断大转盘活动是否存在添加推送动画
    if _ED.activity_info["22"] ~= nil then 
        self._activity = _ED.activity_info["22"]
    end
    self._panel_cost = ccui.Helper:seekWidgetByName(root, "Panel_cost")
    if self._panel_cost ~= nil then
        self._panel_cost:setVisible(false)
    end
end

function HomeButtonCell:init(activity_type)
    self._type = activity_type
    self:onInit()
    return self
end

function HomeButtonCell:onExit()
    cacher.freeRef(config_csb.cells.home.home_button_cell, self.roots[1])
end