UnionFightingAttackCost = class("UnionFightingAttackCostClass", Window)

local union_fighting_attack_cost_open_terminal = {
	_name = "union_fighting_attack_cost_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:open(UnionFightingAttackCost:new():init(params), fwin._ui)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local union_fighting_attack_cost_close_terminal = {
	_name = "union_fighting_attack_cost_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("UnionFightingAttackCostClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(union_fighting_attack_cost_open_terminal)
state_machine.add(union_fighting_attack_cost_close_terminal)
state_machine.init()

function UnionFightingAttackCost:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	self._chooseCell = nil

    local function init_union_fight_attack_rank_cost_terminal()
        local union_fight_attack_rank_cost_ok_terminal = {
            _name = "union_fight_attack_rank_cost_ok",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:detachWithIME()
                local TextField_pk_gem = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_pk_gem")
                local textInfo = TextField_pk_gem:getString()
                if textInfo == nil or #textInfo == 0 then
                    TipDlg.drawTextDailog(tipStringInfo_union_str[97])
                    return
                end
                if tonumber(textInfo) == nil then
                	TipDlg.drawTextDailog(tipStringInfo_union_str[106])
                    return
                end
                if tonumber(textInfo) <= tonumber(instance._chooseCell._info.cost) then
                	TipDlg.drawTextDailog(tipStringInfo_union_str[107])
                	return
                end
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                			state_machine.excute("union_fight_attack_rank_cell_update", 0, response.node._chooseCell)
                			state_machine.excute("union_fighting_attack_cost_close", 0, nil)
                        end
                    end
                end
                protocol_command.union_stronghold_bidding.param_list = _ED.union.union_info.union_id.."\r\n"..instance._chooseCell._info.city_id.."\r\n"..textInfo
                NetworkManager:register(protocol_command.union_stronghold_bidding.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(union_fight_attack_rank_cost_ok_terminal)
        state_machine.init()
    end
    init_union_fight_attack_rank_cost_terminal()
end

function UnionFightingAttackCost:detachWithIME()
    local root = self.roots[1]
    local TextField_pk_gem = ccui.Helper:seekWidgetByName(root, "TextField_pk_gem")
    TextField_pk_gem:didNotSelectSelf()
end

function UnionFightingAttackCost:onUpdateDraw( ... )
    local root = self.roots[1]
    local TextField_pk_gem = ccui.Helper:seekWidgetByName(root, "TextField_pk_gem")
    draw:addEditBox(TextField_pk_gem, tipStringInfo_union_str[96], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_ok"), 16, cc.KEYBOARD_RETURNTYPE_DONE)
end

function UnionFightingAttackCost:onInit(params)
	local csbNode = csb.createNode(config_csb.big_map.map_legion_pk_attack_k)
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "union_fighting_attack_cost_close", 
        terminal_state = 0,
        isPressedActionEnabled = true,
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close_n"), nil, 
    {
        terminal_name = "union_fighting_attack_cost_close", 
        terminal_state = 0,
        isPressedActionEnabled = true,
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ok"), nil, 
    {
        terminal_name = "union_fight_attack_rank_cost_ok", 
        terminal_state = 0,
        isPressedActionEnabled = true,
    }, 
    nil, 0)

    self:onUpdateDraw()
end

function UnionFightingAttackCost:onEnterTransitionFinish()
end

function UnionFightingAttackCost:init(params)
	self._chooseCell = params
    self:onInit()
	return self
end

function UnionFightingAttackCost:onExit()
	state_machine.remove("union_fight_attack_rank_cost_ok")
end
