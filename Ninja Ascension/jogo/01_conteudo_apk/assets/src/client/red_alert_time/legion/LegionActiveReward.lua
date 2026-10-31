-- ------------------------------------------------------------------------------------------------------------
--  说明：军团活跃福利
-- ------------------------------------------------------------------------------------------------------------
LegionActiveReward = class("LegionActiveRewardClass", Window)

--打开界面
local legion_active_reward_open_terminal = {
    _name = "legion_active_reward_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        local panel = LegionActiveReward:new():init(params)
        fwin:open(panel, fwin._ui)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(legion_active_reward_open_terminal)
state_machine.init()

function LegionActiveReward:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    local function init_legion_active_reward_terminal()
        local legion_active_reward_show_terminal = {
            _name = "legion_active_reward_show",
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

        local legion_active_reward_hide_terminal = {
            _name = "legion_active_reward_hide",
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

        local legion_active_reward_get_reward_terminal = {
            _name = "legion_active_reward_get_reward",
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
                        state_machine.excute("main_window_update_resource", 0, "")
                    end
                end
                protocol_command.draw_union_active_share.param_list = ""
                NetworkManager:register(protocol_command.draw_union_active_share.code, nil, nil, nil, instance, responseCallback, false, nil)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local legion_active_reward_go_collect_terminal = {
            _name = "legion_active_reward_go_collect",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("legion_active_close", 0, "")
                state_machine.excute("legion_window_close", 0, "")
                state_machine.excute("short_cut_go_to_other_window",0,{16})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_active_reward_show_terminal)
        state_machine.add(legion_active_reward_hide_terminal)
        state_machine.add(legion_active_reward_get_reward_terminal)
        state_machine.add(legion_active_reward_go_collect_terminal)
        state_machine.init()
    end
    init_legion_active_reward_terminal()
end

function LegionActiveReward:onUpdateDraw()
    local root = self.roots[1]

    local get_rewards = zstring.split(_ED.union_active_info.get_reward,",")              -- 已领取奖励
    local can_get_rewards = zstring.split(_ED.union_active_info.share_reward,",")          -- 可领取奖励
    local reward_type_str = dms.string(dms["union_active_level"], tonumber(_ED.union_active_info.active_level), union_active_level.share_res_type)
    local reward_type_info = zstring.split(reward_type_str, "|")
    local is_have_reward = false
    for i=1,5 do
        local Panel_welfare_res = ccui.Helper:seekWidgetByName(root, "Panel_welfare_res_"..i)
        local Text_welfare_res_n = ccui.Helper:seekWidgetByName(root, "Text_welfare_res_n_"..i)
        local Panel_share_res = ccui.Helper:seekWidgetByName(root, "Panel_share_res_"..i)
        local Text_share_res = ccui.Helper:seekWidgetByName(root, "Text_share_res_"..i)
        Panel_welfare_res:removeAllChildren(true)
        Panel_share_res:removeAllChildren(true)

        local reward_info = zstring.split(reward_type_info[i], ",")
        local get_cell = state_machine.excute("props_icon_create_cell", 0, {1, 1, tonumber(reward_info[1]), 5})
        local can_get_cell = state_machine.excute("props_icon_create_cell", 0, {1, 1, tonumber(reward_info[1]), 5})
        Panel_welfare_res:addChild(get_cell)
        Panel_share_res:addChild(can_get_cell)
        Text_welfare_res_n:setString(exChangeNumToString(get_rewards[i]))
        Text_share_res:setString(exChangeNumToString(can_get_rewards[i]))
        if tonumber(can_get_rewards[i]) > 0 then
            is_have_reward = true
        end
    end

    local Button_share_res_receive = ccui.Helper:seekWidgetByName(root, "Button_share_res_receive")
    if is_have_reward == true then
        Button_share_res_receive:setBright(true)
        Button_share_res_receive:setTouchEnabled(true)
    else
        Button_share_res_receive:setBright(false)
        Button_share_res_receive:setTouchEnabled(false)
    end
end

function LegionActiveReward:onInit()
    local csbItem = csb.createNode(string.format(config_csb.legion.legion_active_tab, 2))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_go_collect"), nil, 
    {
        terminal_name = "legion_active_reward_go_collect", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_share_res_receive"), nil, 
    {
        terminal_name = "legion_active_reward_get_reward", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    self:onUpdateDraw()
end

function LegionActiveReward:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
    self:onInit()
    return self
end

function LegionActiveReward:onExit()
    state_machine.remove("legion_active_reward_show")
    state_machine.remove("legion_active_reward_hide")
    state_machine.remove("legion_active_reward_get_reward")
    state_machine.remove("legion_active_reward_go_collect")
end