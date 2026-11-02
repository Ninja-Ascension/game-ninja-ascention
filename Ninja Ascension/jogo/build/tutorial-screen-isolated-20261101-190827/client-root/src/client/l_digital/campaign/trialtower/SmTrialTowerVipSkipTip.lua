-----------------------------
-- 试炼Vip跳过的界面
-----------------------------
SmTrialTowerVipSkipTip = class("SmTrialTowerVipSkipTipClass", Window)

local sm_trial_tower_vip_skip_tip_open_terminal = {
	_name = "sm_trial_tower_vip_skip_tip_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("SmTrialTowerVipSkipTipClass") == nil then
			fwin:open(SmTrialTowerVipSkipTip:new():init(params), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local sm_trial_tower_vip_skip_tip_close_terminal = {
	_name = "sm_trial_tower_vip_skip_tip_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmTrialTowerVipSkipTipClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_trial_tower_vip_skip_tip_open_terminal)
state_machine.add(sm_trial_tower_vip_skip_tip_close_terminal)
state_machine.init()

function SmTrialTowerVipSkipTip:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}

    local function init_sm_trial_tower_vip_skip_tip_terminal()
        local sm_trial_tower_vip_skip_tip_give_up_terminal = {
            _name = "sm_trial_tower_vip_skip_tip_give_up",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                app.load("client.utils.ConfirmTip")
                local tip = ConfirmTip:new()
                tip:init(instance, instance.quxSureTipCallBack, _new_interface_text[243])
                fwin:open(tip, fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_trial_tower_vip_skip_tip_give_up_terminal)
        state_machine.init()
    end
    init_sm_trial_tower_vip_skip_tip_terminal()
end

function SmTrialTowerVipSkipTip:quxSureTipCallBack( n )
    if n == 0 then
        protocol_command.three_kingdoms_sweep.param_list = "5\r\n0\r\n0\r\n0\r\n0\r\n\r\n0"
        NetworkManager:register(protocol_command.three_kingdoms_sweep.code, nil, nil, nil, nil, responseCallback, false, nil)
        state_machine.excute("sm_trial_tower_vip_skip_tip_close", 0, nil)
    end
end

function SmTrialTowerVipSkipTip:updateDraw()
	local root = self.roots[1]
	local Text_floor = ccui.Helper:seekWidgetByName(root,"Text_floor")
    local jumpFloor = dms.int(dms["base_consume"], 66, base_consume.vip_0_value + tonumber(_ED.vip_grade))
	-- 19-oct (Quick Trial): el piso va DENTRO de la frase («%d» en Text_tip, en los 13 idiomas). Text_floor era un
	-- rotulo suelto en una posicion fija que no cuadraba con el texto de ningun idioma (salia encima de otra palabra).
	-- tools/i18n/parche_quick_trial_piso.py. Sin «%d» (maqueta vieja) se hace lo de antes.
	local Text_tip = ccui.Helper:seekWidgetByName(root,"Text_tip")
	local tip = Text_tip ~= nil and Text_tip:getString() or ""
	if string.find(tip, "%d", 1, true) ~= nil then
		Text_tip:setString((string.gsub(tip, "%%d", tostring(jumpFloor))))
		Text_floor:setVisible(false)
		local Text_tip_0 = ccui.Helper:seekWidgetByName(root,"Text_tip_0")
		if Text_tip_0 ~= nil then
			Text_tip_0:setVisible(false)
		end
	else
		Text_floor:setString(jumpFloor)
	end
end

function SmTrialTowerVipSkipTip:init(params)
	self:onInit()
    return self
end

function SmTrialTowerVipSkipTip:onInit()
    local csbItem = csb.createNode("campaign/TrialTower/sm_trial_tower_rweep_tip.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    local action = csb.createTimeline("campaign/TrialTower/sm_trial_tower_rweep_tip.csb")  
    table.insert(self.actions, action)
    csbItem:runAction(action)
    action:play("window_open", false)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_cancel"), nil, 
    {
        terminal_name = "sm_trial_tower_vip_skip_tip_give_up", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_ok"), nil, 
    {
        terminal_name = "sm_trial_tower_sweep_window_open", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "sm_trial_tower_vip_skip_tip_give_up", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 0)

	self:updateDraw()
end

function SmTrialTowerVipSkipTip:onEnterTransitionFinish()
end

function SmTrialTowerVipSkipTip:onExit()
    state_machine.remove("sm_trial_tower_vip_skip_tip_give_up")
end

