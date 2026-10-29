-----------------------------
--充值返钻
-----------------------------
SmRechargeReturnInterest = class("SmRechargeReturnInterestClass", Window)

local sm_recharge_return_interest_open_terminal = {
	_name = "sm_recharge_return_interest_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("SmRechargeReturnInterestClass") == nil then
			fwin:open(SmRechargeReturnInterest:new():init(params), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local sm_recharge_return_interest_close_terminal = {
	_name = "sm_recharge_return_interest_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmRechargeReturnInterestClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_recharge_return_interest_open_terminal)
state_machine.add(sm_recharge_return_interest_close_terminal)
state_machine.init()

function SmRechargeReturnInterest:ctor()
	self.super:ctor()
	self.roots = {}
    
    self._tick_time = 0
    self._text_time = nil

    app.load("client.l_digital.cells.activity.wonderful.SmActivityRechargeReturnInterestCell")
    local function init_sm_recharge_interest_terminal()
        local sm_recharge_interest_update_draw_new_terminal = {
            _name = "sm_recharge_interest_update_draw_new",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                	instance:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_recharge_interest_update_draw_new_terminal)
        state_machine.init()
    end
    init_sm_recharge_interest_terminal()
end

function SmRechargeReturnInterest:onUpdateDraw()
    local root = self.roots[1]
    local ListView_tab_1 = ccui.Helper:seekWidgetByName(root, "ListView_tab_1")
    self._text_time = ccui.Helper:seekWidgetByName(root,"Text_time_1")
    ListView_tab_1:removeAllItems()

    local activity_info = _ED.active_activity[self.actType]

    -- FURY: LOS TRAMOS SALEN EN EL ORDEN DEL CATALOGO.
    -- `activity_Info` ya llega ordenada por tramo: el parser la rellena con
    -- `activity.activity_Info[i]` de 1 a `activity_count`
    -- (ProtocolParserCopy.lua:4353-4592), asi que `ipairs` la recorre en el
    -- orden en que la mando el servidor.
    --
    -- Aqui habia un reparto en tres cubos -cobrable / no completado /
    -- completado- que se volvian a concatenar en ese orden, o sea que HUNDIA
    -- al final los tramos ya cobrados: con el de 600 cobrado, el 178 pintaba
    -- 1980, 6480, 600 aunque `recharge_tiers:catalog(178)` los manda 600,
    -- 1980, 6480. El `pairs` no era el culpable (sobre una tabla 1..n de Lua
    -- 5.1 recorre en orden); el culpable era el reparto.
    for k, v in ipairs(activity_info.activity_Info) do
        local cell = state_machine.excute("sm_activity_recharge_interest_cell_new_create", 0, {v, self.actType})
        ListView_tab_1:addChild(cell)
    end
    ListView_tab_1:requestRefreshView()

    self._tick_time =  (tonumber(activity_info.end_time) - (os.time() + _ED.time_add_or_sub) * 1000) / 1000
    self._text_time:setString(getRedAlertTimeActivityFormat(self._tick_time))
end

function SmRechargeReturnInterest:onUpdate(dt)
    if self._text_time ~= nil and self._tick_time > 0 then 
        self._tick_time = self._tick_time - dt
        self._text_time:setString(getRedAlertTimeActivityFormat(self._tick_time))
        if self._tick_time <= 0 then
            self._tick_time = nil
        end
    end
end

function SmRechargeReturnInterest:init(params)
    self.actType = params
	self:onInit()
    return self
end

function SmRechargeReturnInterest:onInit()
    local csbItem = csb.createNode("activity/wonderful/recharge_rebate.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_7day_back"), nil, 
    {
        terminal_name = "sm_recharge_return_interest_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    self:onUpdateDraw()
end

function SmRechargeReturnInterest:onEnterTransitionFinish()
end

function SmRechargeReturnInterest:onExit()
	state_machine.remove("sm_recharge_interest_update_draw_new")
end

