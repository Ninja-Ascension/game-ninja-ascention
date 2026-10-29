-- ------------------------------------------------------------------------------------------------------------
--  说明：军团奖励
-- ------------------------------------------------------------------------------------------------------------
LegionRewardWindow = class("LegionRewardWindowClass", Window)

--打开界面
local legion_reward_window_window_open_terminal = {
    _name = "legion_reward_window_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("LegionRewardWindowClass") == nil then
            local _win = LegionRewardWindow:new()
            _win:init()
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local legion_reward_window_window_close_terminal = {
    _name = "legion_reward_window_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LegionRewardWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_reward_window_window_open_terminal)
state_machine.add(legion_reward_window_window_close_terminal)
state_machine.init()

function LegionRewardWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    app.load("client.red_alert_time.legion.LegionList")
    app.load("client.red_alert_time.legion.LegionEstablish")
    app.load("client.red_alert_time.cells.legion.legion_list_cell")

     -- Initialize alert_home state machine.
    local function init_legion_reward_window_terminal()
        -- 创建军团
        local legion_reward_window_establish_legion_terminal = {
            _name = "legion_reward_window_establish_legion",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if funOpenDrawTip(152) == true then
                    return
                end
                state_machine.excute("legion_reward_window_window_close", 0, "")
                state_machine.excute("legion_establish_window_open", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 加入军团
        local legion_reward_window_add_legion_terminal = {
            _name = "legion_reward_window_add_legion",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if funOpenDrawTip(152) == true then
                    return
                end
                state_machine.excute("legion_reward_window_window_close", 0, "")
                state_machine.excute("legion_list_window_open", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 领取
        local legion_reward_window_reward_revice_terminal = {
            _name = "legion_reward_window_reward_revice",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("legion_reward_window_window_close", 0, "")
                        checkRewardObtainDraw()
                        state_machine.excute("main_window_update_top_button", 0, "")
                        state_machine.excute("main_window_update_gold_info", 0, nil)
                    end
                end
                protocol_command.draw_first_join_union_reward.param_list = ""
                NetworkManager:register(protocol_command.draw_first_join_union_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_reward_window_establish_legion_terminal)
        state_machine.add(legion_reward_window_add_legion_terminal)
        state_machine.add(legion_reward_window_reward_revice_terminal)
        state_machine.init()
    end
    -- call func alert_home create state machine.
    init_legion_reward_window_terminal()
end

-- 显示信息
function LegionRewardWindow:onUpdateDraw()
    local root = self.roots[1]


    local rewards = zstring.split(dms.string(dms["union_config"], 55, prop_config.param), "|")
    for i = 1, #rewards do
        local Panel_reward_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_reward_props_icon_"..i)
        Panel_reward_props_icon:removeAllChildren(true)

        local reward_info = zstring.split(rewards[i], ",")
        local prop_data = {}
        prop_data.prop_item = tonumber(reward_info[1])
        prop_data.prop_type = tonumber(reward_info[2])
        prop_data.item_value = tonumber(reward_info[3])
        local cell = createPropIconCell(prop_data, true, false, true)
        Panel_reward_props_icon:addChild(cell)
    end

    local Button_establish_legion = ccui.Helper:seekWidgetByName(root, "Button_establish_legion")
    local Button_add_legion = ccui.Helper:seekWidgetByName(root, "Button_add_legion")
    Button_establish_legion:setBright(true)
    Button_establish_legion:setTouchEnabled(true)
    Button_add_legion:setBright(true)
    Button_add_legion:setTouchEnabled(true)
    if funOpenDrawTip(152, false) == true then
        Button_establish_legion:setBright(false)
        Button_add_legion:setBright(false)
    else
        Button_establish_legion:setBright(true)
        Button_add_legion:setBright(true)
    end 

    -- 奖励领取状态
    local revice_state = 1
    local have_union = false
    if _ED.union.union_info == nil 
        or _ED.union.union_info == {} 
        or _ED.union.union_info.union_id == nil 
        or _ED.union.union_info.union_id == "" 
        or tonumber(_ED.union.union_info.union_id) == 0 
        then
        revice_state = 1
        have_union = false
    else
        revice_state = tonumber(_ED.union_first_join_reward)
        have_union = true
    end
    local Button_reward_revice = ccui.Helper:seekWidgetByName(root, "Button_reward_revice")
    if revice_state == 0 then
        Button_reward_revice:setTouchEnabled(true)
        Button_reward_revice:setBright(true)
        Button_establish_legion:setBright(false)
        Button_establish_legion:setTouchEnabled(false)
        Button_add_legion:setBright(false)
        Button_add_legion:setTouchEnabled(false)
    else
        Button_reward_revice:setTouchEnabled(false)
        Button_reward_revice:setBright(false)
    end

    if have_union == true then
        Button_establish_legion:setVisible(false)
        Button_add_legion:setVisible(false)
        Button_reward_revice:setVisible(true)
    else
        Button_establish_legion:setVisible(true)
        Button_add_legion:setVisible(true)
        Button_reward_revice:setVisible(false)
    end

    for i = 1, 3 do
        local Image_legion_reward_rec = ccui.Helper:seekWidgetByName(root, "Image_legion_reward_rec_"..i)
        if Image_legion_reward_rec ~= nil then
            if tonumber(_ED.union_first_join_reward) == 0 then
                Image_legion_reward_rec:setVisible(false)
            else
                Image_legion_reward_rec:setVisible(true)
            end
        end
    end
end

--初始化界面
function LegionRewardWindow:onInit()
    local csbItem = csb.createNode(config_csb.legion.legion_reward_window)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_boom_up_close"), nil, 
    {
        terminal_name = "legion_reward_window_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)    
    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "legion_reward_window_window_close", 
        terminal_state = 0, 
    }, nil, 3)    

    -- 创建军团
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_establish_legion"), nil, 
    {
        terminal_name = "legion_reward_window_establish_legion", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    -- 加入军团
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_add_legion"), nil, 
    {
        terminal_name = "legion_reward_window_add_legion", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    -- 领取奖励
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_reward_revice"), nil, 
    {
        terminal_name = "legion_reward_window_reward_revice", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    self:onUpdateDraw()
end

--初始化
function LegionRewardWindow:init()

    self:onInit()
end

--移除状态机
function LegionRewardWindow:onExit()
    state_machine.remove("legion_reward_window_establish_legion")
    state_machine.remove("legion_reward_window_add_legion")
    state_machine.remove("legion_reward_window_reward_revice")
end