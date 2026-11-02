------------------------------------------------------------
-- 个人战胜利宝箱奖励
------------------------------------------------------------

PersonalFightTask = class("PersonalFightTaskClass", Window)

-- 打开界面
local personal_fight_task_window_open_terminal = {
    _name = "personal_fight_task_window_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function (terminal, instance, params)
        local task_index = params
        if fwin:find("PersonalFightTaskClass") == nil then
            fwin:open(PersonalFightTask:new():init(task_index),fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local personal_fight_task_window_close_terminal = {
    _name = "personal_fight_task_window_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function (terminal, instance, params)
        fwin:close(fwin:find("PersonalFightTaskClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(personal_fight_task_window_open_terminal)
state_machine.add(personal_fight_task_window_close_terminal)
state_machine.init()

function PersonalFightTask:ctor()
    self.super:ctor()
    self.roots = {}

    local function init_personal_fight_reward_terminal()
        -- 领取奖励
        local personal_fight_task_get_reward_terminal = {
            _name = "personal_fight_task_get_reward",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function (terminal, instance, params)
                if instance._task_data == nil then
                    return
                end

                local task_id = instance._task_data.task_id
                local task_mould_id = instance._task_data.task_mould_id

                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if _ED.user_task_infos["7"] ~= nil then
                            _ED.user_task_infos["7"][task_id] = nil
                        end
                        state_machine.excute("reward_obtain_window_open",0,{74})
                        state_machine.excute("personal_fight_task_window_close", 0, "")
                        state_machine.excute("personal_fight_update_task_reward", 0, "")
                    end
                end
                protocol_command.get_task_reward.param_list = task_id .. "\r\n" .. task_mould_id
                NetworkManager:register(protocol_command.get_task_reward.code, nil, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 
        local personal_fight_task_go_terminal = {
            _name = "personal_fight_task_go",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function (terminal, instance, params)
                state_machine.excute("personal_fight_task_window_close", 0, "")
                state_machine.excute("personal_fight_main_enter_national", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(personal_fight_task_get_reward_terminal)
        state_machine.add(personal_fight_task_go_terminal)
        state_machine.init()
    end

    init_personal_fight_reward_terminal()
end

function PersonalFightTask:init(task_index)
    self._task_index = task_index

    self._task_data = nil
    self._task_mould_id = 945 + self._task_index

    if _ED.user_task_infos["7"] ~= nil then
        for i, data in pairs(_ED.user_task_infos["7"]) do
            if zstring.tonumber(data.task_mould_id) == self._task_mould_id then
                self._task_data = data
                break
            end
        end
    end

    self:onInit()
    return self
end

function PersonalFightTask:onInit()
    local csbItem = csb.createNode(config_csb.palyer_build.palyer_build_task_window)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self._list_view = ccui.Helper:seekWidgetByName(root,"ListView_star_reward")

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_star_box_window"), nil, 
    {
        terminal_name = "personal_fight_task_window_close", 
        terminal_state = 0,
    },
    nil,0)
    --领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_task_box_receive"), nil, 
    {
        terminal_name = "personal_fight_task_get_reward", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    },
    nil,0)
    --前往
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_task_box_go"), nil, 
    {
        terminal_name = "personal_fight_task_go", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    },
    nil,0)

    self:updateDraw()
end

function PersonalFightTask:updateDraw()
    local root = self.roots[1]
    local Text_task_number = ccui.Helper:seekWidgetByName(root,"Text_task_number")
    local Button_task_box_receive = ccui.Helper:seekWidgetByName(root,"Button_task_box_receive")            -- 领取按钮
    local Button_task_box_go = ccui.Helper:seekWidgetByName(root,"Button_task_box_go")                      -- 前往按钮
    local Image_star_box_have_received = ccui.Helper:seekWidgetByName(root,"Image_star_box_have_received")  -- 已领取标签

    Button_task_box_receive:setVisible(false)
    Button_task_box_go:setVisible(false)
    Image_star_box_have_received:setVisible(false)

    local state = 0             -- 完成状态,0：未领取，1：已领取，2：未完成
    local current = 0
    local total = 0
    local reward_info = ""

    if self._task_data == nil then
        state = 1
        local achieve_mould_id = self._task_mould_id
        local achieve_data = dms.element(dms["achievement_mould"],achieve_mould_id)
        reward_info = dms.atos(achieve_data,achievement_mould.achievement_reward)
        total = dms.atos(achieve_data,achievement_mould.achievement_finish_need_info)
        current = total
    else
        local achieve_mould_id = self._task_data.achieve_mould_id
        local achieve_data = dms.element(dms["achievement_mould"],achieve_mould_id)
        reward_info = dms.atos(achieve_data,achievement_mould.achievement_reward)
        total = zstring.tonumber(self._task_data.need_complete_count)
        current = zstring.tonumber(self._task_data.task_complete_count)
    end

    current = math.min(current, total)
    Text_task_number:setString(string.format(red_alert_all_str[244], current, total))

    if state == 1 then
        Image_star_box_have_received:setVisible(true)
    elseif current == total then
        Button_task_box_receive:setVisible(true)
    else
        Button_task_box_go:setVisible(true)
    end

    -- 显示奖励道具
    self._list_view:removeAllItems()
    local reward_list = zstring.split(reward_info, "|")
    for i, reward in pairs(reward_list) do
        local reward_tab = zstring.split(reward, ",")
        local data = {
            item_value = tonumber(reward_tab[3]),
            prop_type = tonumber(reward_tab[2]),
            prop_item = tonumber(reward_tab[1]),
        }
        local cell = nil
        if tonumber(data.prop_type) == 6 then    
            if zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(data.prop_item), prop_mould.change_of_equipment)) > 0 
                or zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(data.prop_item), prop_mould.use_of_ship)) > 0  then
                cell = state_machine.excute("all_resource_create_cell",0,{3,data,data,touch_type,0,false,true})
            else
                cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,touch_type,0,false,true})
            end  
        elseif tonumber(data.prop_type) == 34 then    
            cell = state_machine.excute("all_resource_create_cell",0,{5,data,data,touch_type,0,false,true})   
        else
            cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,touch_type,0,false,true})
        end
        self._list_view:addChild(cell)
    end

    self._list_view:requestRefreshView()
end

function PersonalFightTask:onExit()
    state_machine.remove("personal_fight_task_get_reward")
    state_machine.remove("personal_fight_task_go")
end

function PersonalFightTask:onEnterTransitionFinish()

end
