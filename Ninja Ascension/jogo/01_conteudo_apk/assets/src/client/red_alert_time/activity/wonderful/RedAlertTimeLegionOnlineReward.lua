-----------------------------
-- 军团在线奖励界面
-----------------------------
RedAlertTimeLegionOnlineReward = class("RedAlertTimeLegionOnlineRewardClass", Window)

local red_alert_time_legion_online_reward_window_open_terminal = {
    _name = "red_alert_time_legion_online_reward_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeLegionOnlineRewardClass") then
            local panel = RedAlertTimeLegionOnlineReward:new():init(params)
            fwin:open(panel, fwin._ui)
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_legion_online_reward_window_close_terminal = {
    _name = "red_alert_time_legion_online_reward_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local activityWindow = fwin:find("RedAlertTimeLegionOnlineRewardClass")
        fwin:close(activityWindow)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_legion_online_reward_window_open_terminal)
state_machine.add(red_alert_time_legion_online_reward_window_close_terminal)
state_machine.init()

function RedAlertTimeLegionOnlineReward:ctor()
    self.super:ctor()
    self.roots = {}
    
    self._activity_type = 0

    self._text_time = nil
    self._online_time = 0
    self._max_time = 0
    self._have_legion = false
    self._start_time = 0

    app.load("client.red_alert_time.activity.wonderful.RedAlertTimeLegionOnlineRewardRank")
    app.load("client.red_alert_time.cells.activity.wonderful.legion_online_reward_rank_cell")

    -- 初始化状态机
    local function init_red_alert_time_legion_online_reward_terminal()
        -- 刷新
        local red_alert_time_legion_online_reward_update_draw_terminal = {
            _name = "red_alert_time_legion_online_reward_update_draw",
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

        -- 领取
        local red_alert_time_legion_online_reward_get_reward_terminal = {
            _name = "red_alert_time_legion_online_reward_get_reward",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local acitvity = _ED.activity_info[""..instance._activity_type]
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:onUpdateDraw()
                            response.node:onUpdateLuckRecord()
                        end
                        checkRewardObtainDraw()
                        state_machine.excute("main_window_update_top_button", 0, "")
                        state_machine.excute("main_window_update_gold_info", 0, nil)
                    end
                end     
                protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..acitvity.activity_type.."\r\n".."0".."\r\n".."0".."\r\n".."0"
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_legion_online_reward_update_draw_terminal)
        state_machine.add(red_alert_time_legion_online_reward_get_reward_terminal)
        state_machine.init()
    end
    init_red_alert_time_legion_online_reward_terminal()
end

function RedAlertTimeLegionOnlineReward:onUpdateLuckRecord()
    local root = self.roots[1]

    local result = {}
    if _ED.leagion_online_reward_record ~= nil then
        result = _ED.leagion_online_reward_record
    end
    local function sortFunction(a, b)
        return a.time > b.time
    end
    table.sort(result, sortFunction)

    local Panel_lucky_rank = ccui.Helper:seekWidgetByName(root,"Panel_lucky_rank")
    Panel_lucky_rank:removeAllChildren(true)

    local height = Panel_lucky_rank:getContentSize().height
    for i = 1, 2 do
        if result[i] ~= nil then
            local cell = state_machine.excute("legion_online_reward_rank_cell_create", 0, {i, result[i]})
            Panel_lucky_rank:addChild(cell)
            height = height - cell:getContentSize().height
            cell:setPositionY(height)
        end
    end
end

-- 刷新界面
function RedAlertTimeLegionOnlineReward:onUpdateDraw()
    local root = self.roots[1]

    local Text_legion_online_reward_time = ccui.Helper:seekWidgetByName(root,"Text_legion_online_reward_time")
    local Text_legion_online_reward_t_2 = ccui.Helper:seekWidgetByName(root,"Text_legion_online_reward_t_2")
    local Button_legion_online_reward_rec = ccui.Helper:seekWidgetByName(root,"Button_legion_online_reward_rec")
    local Text_legion_online_reward_p = ccui.Helper:seekWidgetByName(root,"Text_legion_online_reward_p")

    local activity_info = _ED.activity_info[""..self._activity_type]
    local activity_add_state_arr = zstring.split(activity_info.activity_add_state, "|")
    local activity_add_state = zstring.split(activity_add_state_arr[1], ",")

    local reward_info = nil
    for i = 2, #activity_add_state_arr do
        local info = zstring.split(activity_add_state_arr[i], ",")
        if tonumber(_ED.user_info.user_grade) >= tonumber(info[1]) and tonumber(_ED.user_info.user_grade) <= tonumber(info[2]) then
            reward_info = info
            break
        end
    end

    -- 已领取次数
    local reward_count = tonumber(activity_add_state[4])
    local reward_max_count = tonumber(activity_add_state[5])

    self._text_time = nil

    if reward_count < reward_max_count then
        local last_online_time = 0
        if reward_count > 0 then
            last_online_time = tonumber(reward_info[2 + (reward_count - 1) * 2 + 1]) * 60
        end
        -- 倒计时 
        self._max_time = tonumber(reward_info[2 + reward_count * 2 + 1]) * 60
        self._max_time = self._max_time - last_online_time
        if _ED.union.union_info == nil 
            or _ED.union.union_info == {} 
            or _ED.union.union_info.union_id == nil 
            or _ED.union.union_info.union_id == "" 
            or tonumber(_ED.union.union_info.union_id) == 0 
            then
            self._have_legion = false
        else
            self._have_legion = true
        end

        self._online_time = tonumber(activity_add_state[7]) / 1000
        self._start_time = tonumber(activity_add_state[6]) / 1000
        local online_time = self._online_time
        if self._have_legion == true then
            online_time = online_time + os.time() + _ED.time_add_or_sub - self._start_time
            Text_legion_online_reward_p:setVisible(false)
        else
            Text_legion_online_reward_p:setVisible(true)
        end
        local leave_time = self._max_time - online_time
        Text_legion_online_reward_time:setString(getRedAlertTimeFormat(leave_time))

        -- 领取状态
        if leave_time <= 0 then
            Button_legion_online_reward_rec:setTouchEnabled(true)
            Button_legion_online_reward_rec:setBright(true)
            Text_legion_online_reward_time:setVisible(false)
            Text_legion_online_reward_t_2:setVisible(false)
        else
            Button_legion_online_reward_rec:setTouchEnabled(false)
            Button_legion_online_reward_rec:setBright(false)
            Text_legion_online_reward_time:setVisible(true)
            Text_legion_online_reward_t_2:setVisible(true)
            self._text_time = Text_legion_online_reward_time
        end

        -- 奖励
        local scene_reward_id = reward_info[2 + reward_count * 2 + 2]
        local rewards = zstring.split(dms.string(dms["scene_reward"], scene_reward_id, scene_reward.reward_items),"|")
        local ScrollView_legion_online_reward = ccui.Helper:seekWidgetByName(root,"ScrollView_legion_online_reward")
        ScrollView_legion_online_reward:removeAllChildren(true)

        local iconGroup = {}
        local width = ScrollView_legion_online_reward:getContentSize().width
        local height = ScrollView_legion_online_reward:getContentSize().height
        local tocalHeight = 0
        local cell_size = nil
        for i,v in pairs(rewards) do
            local temp_tab = zstring.split(v, ",")
            local reward_data = {
                item_value = temp_tab[3],
                prop_type = temp_tab[2],
                prop_item = temp_tab[1],
            }
            local cell = createPropIconCell(reward_data, true, true, true)

            table.insert(iconGroup, cell)
            ScrollView_legion_online_reward:addChild(cell)

            if cell_size == nil then
                cell_size = cell:getContentSize()
            end
        end
        local cell_height = cell_size.height + 40
        local cell_width = cell_size.width
        tocalHeight = cell_height * (math.ceil( #rewards / 4 ))
        tocalHeight = math.max(tocalHeight , height)
        ScrollView_legion_online_reward:setInnerContainerSize(cc.size(width, tocalHeight))
        for i, v in pairs(iconGroup) do
            local wight_n = 1
            local height_n = 1
            if i % 4 == 0 then
                wight_n = 4
            else
                wight_n = i % 4
            end
            local interval = (width - 4 * cell_width) / 2 - 18
            if i % 4 == 0 then
                height_n = i / 4
            else
                height_n = math.floor(i / 4) + 1
            end
            v:setPosition(cc.p(width / 4 * (wight_n - 1), tocalHeight - cell_height * height_n + 40))
        end
    end
end

function RedAlertTimeLegionOnlineReward:onUpdate(dt)
    if self._text_time ~= nil and self._have_legion == true then
        local activity_info = _ED.activity_info[""..self._activity_type]
        local online_time = self._online_time + os.time() + _ED.time_add_or_sub - self._start_time
        local leave_time = self._max_time - online_time
        self._text_time:setString(getRedAlertTimeFormat(leave_time))
        if leave_time <= 0 then
            self:onUpdateDraw()
        end
    end
end

function RedAlertTimeLegionOnlineReward:onEnterTransitionFinish()

end

function RedAlertTimeLegionOnlineReward:onInit( )
    local csbItem = csb.createNode(config_csb.utils.legion_online_reward) 
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_legion_online_reward_close"), nil, 
    {
        terminal_name = "red_alert_time_legion_online_reward_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_window_bg"), nil, 
    {
        terminal_name = "red_alert_time_legion_online_reward_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_legion_online_reward_rec"), nil, 
    {
        terminal_name = "red_alert_time_legion_online_reward_get_reward",
        terminal_state = 0,
        touch_black = true,
    },
    nil,1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_lucky_rank_icon"), nil, 
    {
        terminal_name = "red_alert_time_legion_online_reward_rank_window_open",
        terminal_state = 0,
    },
    nil,1)

    self:onUpdateDraw()

    local acitvity = _ED.activity_info[""..self._activity_type]
    local function responseCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                response.node:onUpdateLuckRecord()
            end
        end
    end     
    protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..acitvity.activity_type.."\r\n".."0".."\r\n".."0".."\r\n".."1"
    NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, self, responseCallback, false, nil)  
end

function RedAlertTimeLegionOnlineReward:init(params)
    self._activity_type = params[1]
    self:onInit()
    return self
end

function RedAlertTimeLegionOnlineReward:onExit()
    -- 移除状态机
    state_machine.remove("red_alert_time_legion_online_reward_update_draw")
    state_machine.remove("red_alert_time_legion_online_reward_get_reward")
end
