-- ------------------------------------------------------------------------------------------------------------
--  说明：军团副本
-- ------------------------------------------------------------------------------------------------------------
LegionPve = class("LegionPveClass", Window)

--打开界面
local legion_pve_window_open_terminal = {
    _name = "legion_pve_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        state_machine.lock("legion_pve_window_open", 0, 0)
        local function responseCallback(response)
            state_machine.unlock("legion_pve_window_open", 0, 0)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if fwin:find("LegionPveClass") == nil then
                    local _win = LegionPve:new()
                    _win:init(params)
                    fwin:open(_win,fwin._ui)
                end
            end
        end
        protocol_command.union_copy_init.param_list = ""
        NetworkManager:register(protocol_command.union_copy_init.code, nil, nil, nil, nil, responseCallback, false, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local legion_pve_window_close_terminal = {
    _name = "legion_pve_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LegionPveClass"))
        state_machine.excute("notification_center_update", 0, "push_notification_home_button_packs")
        state_machine.excute("legion_active_task_update_draw", 0, "")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_pve_window_open_terminal)
state_machine.add(legion_pve_window_close_terminal)
state_machine.init()

function LegionPve:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._info = nil

    self._isAutoCost = true

    app.load("client.red_alert_time.legion.LegionPveAttackInfor")
    app.load("client.red_alert_time.legion.LegionPveHelp")
    app.load("client.red_alert_time.cells.legion.legion_pve_chapter_cell")

     -- Initialize alert_home state machine.
    local function init_legion_pve_terminal()
        local legion_pve_update_draw_terminal = {
            _name = "legion_pve_update_draw",
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

        local legion_pve_fast_receive_terminal = {
            _name = "legion_pve_fast_receive",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:onUpdateDraw()
                        end 
                        checkRewardObtainDraw()
                        state_machine.excute("notification_center_update", 0, "push_notification_legion_pve_receive")
                    end
                end
                local costState = 0
                if instance._isAutoCost == false then
                    costState = 1
                end
                protocol_command.draw_union_copy_reward.param_list = "-1\r\n-1\r\n-1\r\n"..costState
                NetworkManager:register(protocol_command.draw_union_copy_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local legion_pve_change_cost_con_state_terminal = {
            _name = "legion_pve_change_cost_con_state",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance._isAutoCost = not instance._isAutoCost
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_pve_update_draw_terminal)
        state_machine.add(legion_pve_fast_receive_terminal)  
        state_machine.add(legion_pve_change_cost_con_state_terminal)
        state_machine.init()
    end
    -- call func alert_home create state machine.
    init_legion_pve_terminal()
end

-- 显示信息
function LegionPve:onUpdateDraw()
    local root = self.roots[1]
    local ListView_legion_pve = ccui.Helper:seekWidgetByName(root, "ListView_legion_pve")
    ListView_legion_pve:jumpToTop()
    ListView_legion_pve:removeAllItems()

    local Text_frequency = ccui.Helper:seekWidgetByName(root, "Text_frequency")
    local attack_times = dms.int(dms["base_consume"], 95, base_consume.vip_0_value + tonumber(_ED.vip_grade))   -- 总攻击次数
    local leave_times = attack_times - _ED.union_pve_attack_times  -- 剩余攻击次数
    Text_frequency:setString(leave_times.."/"..attack_times)

    local Text_contribution = ccui.Helper:seekWidgetByName(root, "Text_contribution")
    Text_contribution:setString(_ED.union.user_union_info.rest_contribution)

    local count = 0
    local canReceiveCount = 0
    for k,v in pairs(_ED.scene_current_state) do
        local _scene_type = dms.int(dms["pve_scene"], k, pve_scene.scene_type) 
        if _scene_type == battle_enum._fight_type._fight_type_107 then
            count = count + 1
            local cell = state_machine.excute("legion_pve_chapter_create_cell", 0, {count, k, v})
            ListView_legion_pve:addChild(cell)
            local scene_id = dms.int(dms["pve_scene"], k, pve_scene.scene_id) 
            local npcs = zstring.split(dms.string(dms["pve_scene"], k, pve_scene.npcs), ",")
            local is_receive = zstring.split(_ED.union_pve_is_receive[scene_id], ",")
            for i=1,#npcs do
                local scene_npc_state = tonumber(_ED.union_pve_info[""..scene_id][""..i].npc_state)
                local scene_is_receive = tonumber(is_receive[i])
                if scene_npc_state == 1 and scene_is_receive == 0 then
                    canReceiveCount = canReceiveCount + 1
                end
            end
        end
    end
    local Button_fast_receive = ccui.Helper:seekWidgetByName(root, "Button_fast_receive")
    _ED._can_receive_count = canReceiveCount
    if canReceiveCount > 0 then
        Button_fast_receive:setBright(true)
        Button_fast_receive:setTouchEnabled(true)
    else
        Button_fast_receive:setBright(false)
        Button_fast_receive:setTouchEnabled(false)
    end

    ListView_legion_pve:requestRefreshView()
    self.listview = ListView_legion_pve
    self.listview_poy = ListView_legion_pve:getInnerContainer():getPositionY()
    self.listview_height = ListView_legion_pve:getInnerContainer():getPositionY()
end

function LegionPve:onUpdate(dt)
    if self.listview ~= nil then
        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
        if self.listview_height == 0 then
            self.listview_height = posY
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

--初始化界面
function LegionPve:onInit()
    local csbItem = csb.createNode(config_csb.legion.legion_pve)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pve_close"), nil, 
    {
        terminal_name = "legion_pve_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)    

    -- 一键领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_fast_receive"), nil, 
    {
        terminal_name = "legion_pve_fast_receive", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)    

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "CheckBox_creeps"), nil, 
    {
        terminal_name = "legion_pve_change_cost_con_state",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)    

    self:onUpdateDraw()
end

--初始化
function LegionPve:init(params)
    self._info = params[1]
    self:setTouchEnabled(true)
    self:onInit()
end

--移除状态机
function LegionPve:onExit()
    state_machine.remove("legion_pve_update_draw")
    state_machine.remove("legion_pve_fast_receive")
    state_machine.remove("legion_pve_change_cost_con_state")
end