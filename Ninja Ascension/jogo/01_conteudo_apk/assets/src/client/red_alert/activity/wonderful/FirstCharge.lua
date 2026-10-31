-----------------------------
--首冲(活动类型2)
-----------------------------
FirstCharge = class("FirstChargeClass", Window)

local first_charge_window_open_terminal = {
    _name = "first_charge_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("FirstChargeClass") then
            local panel = FirstCharge:new():init(params)
            fwin:open(panel)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(first_charge_window_open_terminal)
state_machine.init()

function FirstCharge:ctor()
    self.super:ctor()
    self.roots = {}

    self.firsr_recharge_state = nil
    self._currentIndex = 1
    --load lua file

    -- Initialize first_charge state machine.
    local function init_first_charge_terminal()
        --领取
        local first_charge_get_reward_terminal = {
        _name = "first_charge_get_reward",
        _init = function (terminal) 
            
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params) 
            local function responseCallback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    state_machine.excute("reward_obtain_window_open",0,{1002})
                    if tonumber(instance._currentIndex) == 3 then 
                        state_machine.excute("wonderful_remove_page",0,{2})
                        return
                    end
                    state_machine.excute("first_charge_update_draw",0,"")
                    state_machine.excute("wonderful_update_first",0,2)
                end
            end
            local currentIndex = instance._currentIndex - 1
            protocol_command.draw_activity_reward.param_list = _ED.activity_info["2"].activity_id .. "\r\n2\r\n0\r\n"..currentIndex
            NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
            return true
        end,
        _terminal = nil,
        _terminals = nil
       }
    --刷新
        local first_charge_update_draw_terminal = {
        _name = "first_charge_update_draw",
        _init = function (terminal) 
            
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params) 
            instance:onInit()
            return true
        end,
        _terminal = nil,
        _terminals = nil
      }
      state_machine.init()
      state_machine.add(first_charge_get_reward_terminal)
      state_machine.add(first_charge_update_draw_terminal)
    end
    
    -- call func init first_charge state machine.
    init_first_charge_terminal()
end

function FirstCharge:onUpdate()
    if _ED.activity_info["2"] == nil then
        return
    end
    if self.firsr_recharge_state ~= tonumber(_ED.activity_info["2"].activity_data[1][self._currentIndex].achieve_state) then
        self:onUpdateDrawButton()
        self.firsr_recharge_state = tonumber(_ED.activity_info["2"].activity_data[1][self._currentIndex].achieve_state)
    end
end

function FirstCharge:onUpdateDraw()
    local root = self.roots[1]
    local ListView_charge = ccui.Helper:seekWidgetByName(root, "ListView_charge")
    ListView_charge:removeAllItems()
    
    local reward_items = _ED.activity_info["2"].activity_data[1][self._currentIndex].achieve_reward
    reward_items = zstring.split(reward_items,"|")
    for i,reward in ipairs(reward_items) do
        local reward_tab = zstring.split(reward,",")
        local _item_value = tonumber(reward_tab[3])
        local _prop_type = tonumber(reward_tab[2])
        local _prop_item = tonumber(reward_tab[1])
        local data = 
        {
            item_value = _item_value,
            prop_type = _prop_type,
            prop_item = _prop_item,
        }

        local cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,9,0,false,true})
        ListView_charge:addChild(cell)
    end
       
end

function FirstCharge:onUpdateDrawButton()
    local root = self.roots[1]
    local Button_first_charge = ccui.Helper:seekWidgetByName(root,"Button_first_charge")
    local Button_receive = ccui.Helper:seekWidgetByName(root,"Button_receive")
    Button_receive:setVisible(false)
    Button_first_charge:setVisible(false)
    if tonumber(_ED.activity_info["2"].activity_data[1][self._currentIndex].achieve_state) == 1 then
        Button_receive:setVisible(true)
    else
        Button_first_charge:setVisible(true)
    end
    self.firsr_recharge_state = tonumber(_ED.activity_info["2"].activity_data[1][self._currentIndex].achieve_state)
end

function FirstCharge:onEnterTransitionFinish()

end

function FirstCharge:onInit( )
    self:removeAllChildren(true)
    self.roots = {}
    local csbItem = nil
    -- 如果首冲未完成显示首冲界面，完成了显示二冲界面，如果二冲完成了显示三冲界面
    if tonumber(_ED.activity_info["2"].activity_data[1][1].achieve_state) < 2 then
        csbItem = csb.createNode(config_csb.activity.wonderful.first_charge)
        self._currentIndex = 1
    elseif tonumber(_ED.activity_info["2"].activity_data[1][2].achieve_state) < 2 then
        csbItem = csb.createNode(config_csb.activity.wonderful.first_charge_2)
        self._currentIndex = 2
    elseif tonumber(_ED.activity_info["2"].activity_data[1][3].achieve_state) < 2 then
        csbItem = csb.createNode(config_csb.activity.wonderful.first_charge_3)
        self._currentIndex = 3
    end
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)

    --去充值
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_first_charge"), nil, 
    {
        terminal_name = "recharge_dialog_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --领取奖励
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_receive"), nil, 
    {
        terminal_name = "first_charge_get_reward", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

  	self:onUpdateDraw()
    self:onUpdateDrawButton()
end

function FirstCharge:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
	self:onInit()
    return self
end

function FirstCharge:onExit()
    state_machine.remove("first_charge_get_reward")
    state_machine.remove("first_charge_update_draw")
    
end
