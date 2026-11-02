-- ----------------------------------------------------------------------------------------------------
-- 说明：活动体力补领确认
-------------------------------------------------------------------------------------------------------
SmActivityBuyEnergy = class("SmActivityBuyEnergyClass", Window)

local sm_activity_buy_energy_window_open_terminal = {
    _name = "sm_activity_buy_energy_window_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmActivityBuyEnergyClass")
        if nil == _homeWindow then
            local panel = SmActivityBuyEnergy:new():init(params)
            fwin:open(panel,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_activity_buy_energy_window_close_terminal = {
    _name = "sm_activity_buy_energy_window_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmActivityBuyEnergyClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmActivityBuyEnergyClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_activity_buy_energy_window_open_terminal)
state_machine.add(sm_activity_buy_energy_window_close_terminal)
state_machine.init()
    
function SmActivityBuyEnergy:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.ship_id = 0
    local function init_sm_activity_buy_energy_window_terminal()
        -- 显示界面
        local sm_activity_buy_energy_window_display_terminal = {
            _name = "sm_activity_buy_energy_window_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmActivityBuyEnergyWindow = fwin:find("SmActivityBuyEnergyClass")
                if SmActivityBuyEnergyWindow ~= nil then
                    SmActivityBuyEnergyWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_activity_buy_energy_window_hide_terminal = {
            _name = "sm_activity_buy_energy_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmActivityBuyEnergyWindow = fwin:find("SmActivityBuyEnergyClass")
                if SmActivityBuyEnergyWindow ~= nil then
                    SmActivityBuyEnergyWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_activity_buy_energy_window_confirm_terminal = {
            _name = "sm_activity_buy_energy_window_confirm",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseGetServerListCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        app.load("client.reward.DrawRareReward")
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(6)
                        fwin:open(getRewardWnd, fwin._ui)
                        state_machine.excute("activity_add_energy_update_draw", 0, "")
                        state_machine.excute("sm_activity_buy_energy_window_close", 0, "")
                        state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 1001)
                    end
                end
                protocol_command.dinner_time.param_list = ""..instance.page
                NetworkManager:register(protocol_command.dinner_time.code, nil, nil, nil, instance, responseGetServerListCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


        state_machine.add(sm_activity_buy_energy_window_display_terminal)
        state_machine.add(sm_activity_buy_energy_window_hide_terminal)
        state_machine.add(sm_activity_buy_energy_window_confirm_terminal)
        state_machine.init()
    end
    init_sm_activity_buy_energy_window_terminal()
end

function SmActivityBuyEnergy:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local Text_gem_n = ccui.Helper:seekWidgetByName(root,"Text_gem_n")
    Text_gem_n:setString("20")
    
end

function SmActivityBuyEnergy:init(params)
    self.page = tonumber(params)
    self:onInit()
    return self
end

function SmActivityBuyEnergy:onInit()
    local csbSmActivityBuyEnergy = csb.createNode("activity/wonderful/add_strength_buy.csb")
    local root = csbSmActivityBuyEnergy:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmActivityBuyEnergy)
    self:onUpdateDraw()

    -- self:showImageAnimation()
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_buy_power_close"), nil, 
    {
        terminal_name = "sm_activity_buy_energy_window_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_buy_power"), nil, 
    {
        terminal_name = "sm_activity_buy_energy_window_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)
	--确认
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_buy_power_connle"), nil, 
    {
        terminal_name = "sm_activity_buy_energy_window_confirm",
        terminal_state = 0,
        touch_black = true,
    },
    nil,0)
end

function SmActivityBuyEnergy:onExit()
    state_machine.remove("sm_activity_buy_energy_window_display")
    state_machine.remove("sm_activity_buy_energy_window_hide")
end