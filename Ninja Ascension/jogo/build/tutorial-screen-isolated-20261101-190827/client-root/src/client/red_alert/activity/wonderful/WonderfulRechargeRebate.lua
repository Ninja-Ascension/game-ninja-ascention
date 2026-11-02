-----------------------------
-- 内测返利
-----------------------------
WonderfulRechargeRebate = class("WonderfulRechargeRebateClass", Window)

local wonderful_recharge_rebate_window_open_terminal = {
    _name = "wonderful_recharge_rebate_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("WonderfulRechargeRebateClass") then
            local panel = WonderfulRechargeRebate:new():init(params)
            fwin:open(panel)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(wonderful_recharge_rebate_window_open_terminal)
state_machine.init()

function WonderfulRechargeRebate:ctor()
    self.super:ctor()
    self.roots = {}

    self._height = 0
    --load lua file

    -- Initialize wonderful_recharge_rebate state machine.
    local function init_wonderful_recharge_rebate_terminal()
	
		--刷新
		local wonderful_recharge_rebate_set_positiony_terminal = {
            _name = "wonderful_recharge_rebate_set_positiony",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                TipDlg.drawTextDailog(red_alert_all_str[240])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(wonderful_recharge_rebate_set_positiony_terminal)	
        state_machine.init()
    end
    
    -- call func init wonderful_recharge_rebate state machine.
    init_wonderful_recharge_rebate_terminal()
end

function WonderfulRechargeRebate:onUpdateDraw()
    local root = self.roots[1]
    local Text_props_n_1 = ccui.Helper:seekWidgetByName(root, "Text_props_n_1")
    Text_props_n_1:setString(_ED.user_open_server_recharge_rebate_info.recharge_money)
    local Text_props_n_2 = ccui.Helper:seekWidgetByName(root, "Text_props_n_2")
    Text_props_n_2:setString(_ED.user_open_server_recharge_rebate_info.vip_exp)
end


function WonderfulRechargeRebate:onEnterTransitionFinish()

end

function WonderfulRechargeRebate:onInit( )
    local csbItem = csb.createNode(config_csb.activity.wonderful.wonderful_neicefanli)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)

    for i=1,8 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_props_icon_"..i), nil, 
        {
            terminal_name = "wonderful_recharge_rebate_set_positiony",
            terminal_state = 0, 
            touch_scale = true,
            touch_scale_xy = 0.95, 
        }, nil, 0) 
    end

	self:onUpdateDraw()
end

function WonderfulRechargeRebate:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
	self:onInit()
    return self
end

function WonderfulRechargeRebate:onExit()
    state_machine.remove("wonderful_recharge_rebate_set_positiony")
end
