-----------------------------
--七天(活动类型7)
-----------------------------
SevenDay = class("SevenDayClass", Window)

local seven_day_window_open_terminal = {
    _name = "seven_day_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        if nil == fwin:find("SevenDayClass") then
            local panel = SevenDay:new():init(params)
            fwin:open(panel)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(seven_day_window_open_terminal)
state_machine.init()

function SevenDay:ctor()
    self.super:ctor()
    self.roots = {}

    -- Initialize seven_day state machine.
    local function init_seven_day_terminal()

            -- 领取
            local seven_day_get_reward_terminal = {
                _name = "seven_day_get_reward",
                _init = function (terminal) 
                    
                end,
                _inited = false,
                _instance = self,
                _state = 0,
                _invoke = function(terminal, instance, params) 
                    local index_day = params._datas.index
                    local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            state_machine.excute("reward_obtain_window_open",0,{1007})
                            local index = 0 
                            for k,v in pairs(self._seven_activity_data) do
                                for k1,v1 in pairs(v) do
                                    if tonumber(v1.achieve_state) == 2 then 
                                        index = index + 1 
                                    end
                                end
                            end 
                            if index == #self._seven_activity_data then
                                state_machine.excute("wonderful_open_remove_page",0,{7})
                            else
                                if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                    response.node:onUpdateDraw()
                                end
                            end
                        end
                    end
                    local acitvity = _ED.activity_info["7"]
                    protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n7\r\n"..(index_day - 1).."\r\n0"
                    NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
                    return true
                end,
                _terminal = nil,
                _terminals = nil
            }

            state_machine.add(seven_day_get_reward_terminal)    
        state_machine.init()
    end
    
    -- call func init sign_in state machine.
    init_seven_day_terminal()
end


function SevenDay:onUpdateDraw()
    local root = self.roots[1]
    for i = 1,7 do
        local Panel_recive = ccui.Helper:seekWidgetByName(root,"Panel_recive_"..i) -- 可领取状态
        Panel_recive:setVisible(false)
        local Panel_get = ccui.Helper:seekWidgetByName(root,"Panel_get_"..i)       -- 已领取状态
        Panel_get:setVisible(false)
        local achieve_state = tonumber(self._seven_activity_data[i][1].achieve_state)
        if achieve_state == 1 then
            Panel_recive:setVisible(true)
        elseif achieve_state == 2 then
            Panel_get:setVisible(true)
        end
    end
end

function SevenDay:onEnterTransitionFinish()

end

function SevenDay:onInit( )
    self:removeAllChildren(true)
    self.roots = {}
    local csbItem = csb.createNode(config_csb.activity.wonderful.seven_day)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)

    -- 领取
    for i=1,7 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_sday_"..i), nil, 
        {
            terminal_name = "seven_day_get_reward", 
            terminal_state = 0, 
            touch_scale = true,
            touch_scale_xy = 0.95, 
            index = i, 
        }, nil, 0)
    end
    self:onUpdateDraw()
end

function SevenDay:init(params)
    -- debug.print_r(_ED.activity_info["7"])
    local rootWindow = params[1]
    self._rootWindows = rootWindow
    self._seven_activity_data = _ED.activity_info["7"].activity_data
	self:onInit()
    return self
end

function SevenDay:onExit()
    state_machine.remove("seven_day_get_reward")
end
