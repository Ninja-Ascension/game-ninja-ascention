-- ----------------------------------------------------------------------------------------------------
SmActivityActiveReward = class("SmActivityActiveRewardClass", Window)

local sm_activity_active_reward_window_open_terminal = {
    _name = "sm_activity_active_reward_window_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		if fwin:find("SmActivityActiveRewardClass") == nil then
            local panel = SmActivityActiveReward:new():init(params)
            fwin:open(panel, fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_activity_active_reward_window_close_terminal = {
    _name = "sm_activity_active_reward_window_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmActivityActiveRewardClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_activity_active_reward_window_open_terminal)
state_machine.add(sm_activity_active_reward_window_close_terminal)
state_machine.init()
    
function SmActivityActiveReward:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._index = 0
    self._state = 0

    local function init_sm_activity_active_reward_window_terminal()
        local sm_activity_active_reward_get_terminal = {
            _name = "sm_activity_active_reward_get",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        app.load("client.reward.DrawRareReward")
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(42)
                        fwin:open(getRewardWnd, fwin._ui)
                    end
                end
                protocol_command.draw_liveness_reward.param_list = ""..(instance._index - 1)
                NetworkManager:register(protocol_command.dinner_time.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_activity_active_reward_get_terminal)
        state_machine.init()
    end
    init_sm_activity_active_reward_window_terminal()
end

function SmActivityActiveReward:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local Text_title = ccui.Helper:seekWidgetByName(root, "Text_title")
    local ListView_award = ccui.Helper:seekWidgetByName(root, "ListView_award")
    ListView_award:removeAllItems()
    Text_title:setString("")

    local needActive = dms.string(dms["active_reward"], self._index, active_reward.need_active)
    local rewards = zstring.split(dms.string(dms["active_reward"], self._index, active_reward.rewards), "|")
    Text_title:setString(string.format(_new_interface_text[287], needActive))
    for k,v in pairs(rewards) do
        v = zstring.split(v, ",")
        local cell = ResourcesIconCell:createCell()
        cell:init(v[1], tonumber(v[3]),v[2],nil,nil,true,true)
        ListView_award:addChild(cell)
    end
    local Button_receive = ccui.Helper:seekWidgetByName(root,"Button_receive")
    Button_receive:setTouchEnabled(false)
    Button_receive:setHighlighted(false)
    Button_receive:setBright(false)
end

function SmActivityActiveReward:init(params)
    self._index = params[1]
    self._state = params[2]
    self:onInit()
    return self
end

function SmActivityActiveReward:onInit()
    local csbItem = csb.createNode("activity/wonderful/sm_active_box_window.csb")
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbItem)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed_1"), nil, 
    {
        terminal_name = "sm_activity_active_reward_window_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_receive"), nil, 
    {
        terminal_name = "sm_activity_active_reward_get",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)

    self:onUpdateDraw()
end

function SmActivityActiveReward:onExit()
    state_machine.remove("sm_activity_active_reward_get")
end