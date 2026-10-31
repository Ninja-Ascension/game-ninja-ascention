-- ------------------------------------------------------------------------------------------------------------
--  说明：科技捐献
-- ------------------------------------------------------------------------------------------------------------
LegionTechnologyUpRes = class("LegionTechnologyUpResClass", Window)

--打开界面
local legion_technology_up_res_window_open_terminal = {
    _name = "legion_technology_up_res_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("LegionTechnologyUpResClass") == nil then
            local _win = LegionTechnologyUpRes:new()
            local science_id = params[1]
            local index = params[2]
            local donate_type = params[3]
            _win:init(science_id, index, donate_type)
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local legion_technology_up_res_window_close_terminal = {
    _name = "legion_technology_up_res_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LegionTechnologyUpResClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_technology_up_res_window_open_terminal)
state_machine.add(legion_technology_up_res_window_close_terminal)
state_machine.init()

function LegionTechnologyUpRes:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._science_id = 0
    self._index = 0
    self._donate_type = 0
    self._cost_res = 0
    self._cost_gold = 0
    self.m_times = 0
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeRuleInfor")
     -- Initialize alert_home state machine.
    local function init_legion_technology_up_res_terminal()
        local legion_technology_up_res_update_draw_terminal = {
            _name = "legion_technology_up_res_update_draw",
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

        local legion_technology_up_res_sure_donate_terminal = {
            _name = "legion_technology_up_res_sure_donate",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local donate_type = instance._donate_type
                local cost_res = instance._cost_res
                local cost_gold = instance._cost_gold
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            state_machine.excute("legion_technology_up_res_window_close", 0, "")
                        end
                        checkRewardObtainDraw()
                        state_machine.excute("legion_technology_donate_update_draw", 0, "")
                        state_machine.excute("legion_technology_up_update_draw", 0, "")
                        state_machine.excute("legion_infomation_update_draw", 0, "")
                        state_machine.excute("main_window_update_resource", 0, "")

                        if donate_type == 1 then
                            _ED._total_donation_resources = _ED._total_donation_resources + cost_res
                        else
                            _ED._total_donation_gold = _ED._total_donation_gold + cost_gold
                        end
                    end
                end
                local union_id = _ED.union.union_info.union_id
                local donate_type = instance._donate_type - 1
                local donate_index = instance._index - 1
                protocol_command.union_donate.param_list = union_id.."\r\n"..instance._science_id.."\r\n"..donate_type.."\r\n"..donate_index
                NetworkManager:register(protocol_command.union_donate.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 活动规则
        local legion_technology_up_res_act_rule_terminal = {
            _name = "legion_technology_up_res_act_rule",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("red_alert_time_rule_infor_window_open",0,"76")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_technology_up_res_update_draw_terminal)
        state_machine.add(legion_technology_up_res_sure_donate_terminal)
        state_machine.add(legion_technology_up_res_act_rule_terminal)
        state_machine.init()
    end
    -- call func alert_home create state machine.
    init_legion_technology_up_res_terminal()
end

-- 显示信息
function LegionTechnologyUpRes:onUpdateDraw()
    local root = self.roots[1]
    local Button_technology_res_rew_act = ccui.Helper:seekWidgetByName(root, "Button_technology_res_rew_act")
    Button_technology_res_rew_act:setVisible(false)
    if _ED.activity_info["76"] ~= nil then
        Button_technology_res_rew_act:setVisible(true)
    end

    --计算同心协力活动加层
    local activity_add = 0
    if _ED.activity_info["93"] ~= nil then
        local timesData = zstring.split(_ED.activity_info["93"].activity_add_state, ",")
        self.m_times = ((tonumber(timesData[3])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
        if self.m_times > 0 then
            activity_add = tonumber(timesData[8])
        end
    end
   
    local Text_technology_res_rew_n_1 = ccui.Helper:seekWidgetByName(root, "Text_technology_res_rew_n_1")       -- 科技
    local Text_technology_res_rew_n_2 = ccui.Helper:seekWidgetByName(root, "Text_technology_res_rew_n_2")       -- 贡献
    local Text_technology_res_rew_n_3 = ccui.Helper:seekWidgetByName(root, "Text_technology_res_rew_n_3")       -- 声望
    local Text_technology_res_rew_n_4 = ccui.Helper:seekWidgetByName(root, "Text_technology_res_rew_n_4")       -- 技能勋章

    local group_id = dms.int(dms["union_science_mould"], self._science_id, union_science_mould.donate_group)
    local times_info = zstring.split(_ED.union_science_donate_times, ",")
    local current_times = tonumber(times_info[self._index]) + 1
    local base_science_level_info = _ED.base_legion_science_level_info[""..group_id][""..current_times]
    local reward_info = nil
    if self._donate_type == 1 then
        reward_info = base_science_level_info.reward_res
    else
        reward_info = base_science_level_info.reward_gold
    end
    local cost_res_info = zstring.split(base_science_level_info.cost_res[self._index], ",")
    local cost_gold_info = zstring.split(base_science_level_info.cost_gold[self._index], ",")
    self._cost_res = tonumber(cost_res_info[3])
    self._cost_gold = tonumber(cost_gold_info[3])
    for i = 1, 4 do
         local Text_technology_res_rew_n = ccui.Helper:seekWidgetByName(root, "Text_technology_res_rew_n_"..i)
         local reward_count = 0
         if reward_info[i] ~= nil then
            local reward = zstring.split(reward_info[i], ",")
            reward_count = tonumber(reward[3])
        end
        local addition = 0 
        if activity_add > 0 and i < 3 and self._donate_type ~= 1 then
            addition = activity_add
        end
        reward_count = reward_count * ( addition + 1 )
        Text_technology_res_rew_n:setString(string.format(tipString_legion_info[25 + i], reward_count))
    end
end

--初始化界面
function LegionTechnologyUpRes:onInit()
    local csbItem = csb.createNode(config_csb.legion.legion_technology_up_res)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_technology_res_close"), nil, 
    {
        terminal_name = "legion_technology_up_res_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)  
    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "legion_technology_up_res_window_close", 
        terminal_state = 0, 
    }, nil, 3)   

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_technology_res_cancel"), nil, 
    {
        terminal_name = "legion_technology_up_res_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1) 

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_technology_res_sure"), nil, 
    {
        terminal_name = "legion_technology_up_res_sure_donate", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1) 

    -- 活动规则
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_technology_res_rew_act"), nil, 
    {
        terminal_name = "legion_technology_up_res_act_rule",
        terminal_state = 0,
        touch_black = true,
    },
    nil,1)

    self:onUpdateDraw()
end

function LegionTechnologyUpRes:onUpdate(dt)
    if self.m_times > 0 then
        self.m_times = self.m_times - dt
        if self.m_times <= 0 then
            self.m_times = 0
            state_machine.excute("legion_technology_up_res_update_draw",0,"")
        end
    end
end

--初始化
function LegionTechnologyUpRes:init(science_id, index, donate_type)
    self._science_id = science_id
    self._index = index
    self._donate_type = donate_type
    self:onInit()
end

--移除状态机
function LegionTechnologyUpRes:onExit()
    state_machine.remove("legion_technology_up_res_update_draw")
    state_machine.remove("legion_technology_up_res_sure_donate")
    state_machine.remove("legion_technology_up_res_act_rule")
end