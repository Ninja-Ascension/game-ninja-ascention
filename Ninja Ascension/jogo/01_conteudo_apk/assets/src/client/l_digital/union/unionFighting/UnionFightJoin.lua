UnionFightingJoin = class("UnionFightingJoinClass", Window)

local union_fighting_join_open_terminal = {
	_name = "union_fighting_join_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local window = fwin:find("UnionFightingJoinClass")
		if window ~= nil and window:isVisible() == true then
			return true
		end
        state_machine.lock("union_fighting_join_open")
		fwin:open(UnionFightingJoin:new():init(), fwin._view)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local union_fighting_join_close_terminal = {
	_name = "union_fighting_join_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local window = fwin:find("UnionFightingJoinClass")
		if window ~= nil then
			fwin:close(window)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(union_fighting_join_open_terminal)
state_machine.add(union_fighting_join_close_terminal)
state_machine.init()

function UnionFightingJoin:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        app.load("client.l_digital.union.unionFighting.UnionFightingMain")
    else
        app.load("client.union.unionFighting.UnionFightingMain")
    end
    local function init_union_fight_join_terminal()
		local union_fight_join_return_terminal = {
            _name = "union_fight_join_return",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("union_fighting_join_close", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_fight_request_join_terminal = {
            _name = "union_fight_request_join",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if tonumber(_ED.union.user_union_info.union_post) ~= 1 and
                    tonumber(_ED.union.user_union_info.union_post) ~= 2 then
                    TipDlg.drawTextDailog(tipStringInfo_union_str[64])
                    return
                end
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil then
                            _ED.union_fight_is_join = true
                            response.node:updateDraw()
                        end
                    end
                end
                if _ED.union_fight_url ~= nil and _ED.union_fight_url ~= "" then
                    protocol_command.unino_fight_apply.param_list = _ED.union.union_info.union_id.."\r\n".._ED.union.user_union_info.union_post.."\r\n".._ED.user_current_server_number
                    NetworkManager:register(protocol_command.unino_fight_apply.code, _ED.union_fight_url, nil, nil, self, responseCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_fight_join_enter_main_terminal = {
            _name = "union_fight_join_enter_main",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("union_fighting_main_open", 0, "")
                state_machine.excute("union_fighting_join_close", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_fight_join_enter_info_terminal = {
            _name = "union_fight_join_enter_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                app.load("client.refinery.TreasureInfo")
                local cell = TreasureInfo:new()
                cell:init(8)
                fwin:open(cell, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_fight_join_update_terminal = {
            _name = "union_fight_join_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    instance:updateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(union_fight_join_return_terminal)
        state_machine.add(union_fight_request_join_terminal)
        state_machine.add(union_fight_join_enter_main_terminal)
        state_machine.add(union_fight_join_enter_info_terminal)
        state_machine.add(union_fight_join_update_terminal)
        state_machine.init()
    end
    init_union_fight_join_terminal()
end

function UnionFightingJoin:updateDraw()
    local root = self.roots[1]
    if root == nil then
        return
    end
    ccui.Helper:seekWidgetByName(root, "Image_yibaoming"):setVisible(false)
    if tonumber(_ED.union_fight_state) == 0 then
        ccui.Helper:seekWidgetByName(root, "Button_jinru"):setVisible(false)
        if _ED.union_fight_is_join == true then
            ccui.Helper:seekWidgetByName(root, "Image_yibaoming"):setVisible(true)
            ccui.Helper:seekWidgetByName(root, "Button_baoming"):setVisible(false)
        else
            ccui.Helper:seekWidgetByName(root, "Button_baoming"):setVisible(true)
        end
    elseif tonumber(_ED.union_fight_state) == 3 then
        ccui.Helper:seekWidgetByName(root, "Button_baoming"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "Button_jinru"):setVisible(false)
    else
        if _ED.union_fight_is_join == true then
            ccui.Helper:seekWidgetByName(root, "Button_baoming"):setVisible(false)
            ccui.Helper:seekWidgetByName(root, "Button_jinru"):setVisible(true)
        else
            ccui.Helper:seekWidgetByName(root, "Button_baoming"):setVisible(false)
            ccui.Helper:seekWidgetByName(root, "Button_jinru"):setVisible(false)
        end
    end
end

function UnionFightingJoin:onInit()
	local csbUnion = csb.createNode("legion/legion_pve_baoming.csb")
    local root = csbUnion:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbUnion)

    self:updateDraw()

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_baoming"), nil, 
    {
        terminal_name = "union_fight_request_join", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_bm_close"), nil, 
    {
        terminal_name = "union_fight_join_return", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jinru"), nil, 
    {
        terminal_name = "union_fight_join_enter_main", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4"), nil, 
    {
        terminal_name = "union_fight_join_enter_info", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    state_machine.unlock("union_fighting_join_open")
end

function UnionFightingJoin:onEnterTransitionFinish()
end

function UnionFightingJoin:init()
	self:onInit()
	return self
end

function UnionFightingJoin:onExit()
	state_machine.remove("union_fight_request_join")
    state_machine.remove("union_fight_join_enter_main")
    state_machine.remove("union_fight_join_enter_info")
    state_machine.remove("union_fight_join_update")
end
