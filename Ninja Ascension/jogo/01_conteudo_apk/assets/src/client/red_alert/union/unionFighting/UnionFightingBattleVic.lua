UnionFightingBattleVic = class("UnionFightingBattleVicClass", Window)

local union_fighting_battle_vic_open_terminal = {
	_name = "union_fighting_battle_vic_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:open(UnionFightingBattleVic:new():init(params), fwin._ui)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local union_fighting_battle_vic_close_terminal = {
	_name = "union_fighting_battle_vic_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("UnionFightingBattleVicClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(union_fighting_battle_vic_open_terminal)
state_machine.add(union_fighting_battle_vic_close_terminal)
state_machine.init()

function UnionFightingBattleVic:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
end

function UnionFightingBattleVic:onInit(params)
	local csbUnion = csb.createNode(config_csb.big_map.map_legion_battle_vic)
    local root = csbUnion:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbUnion)

    -- ccui.Helper:seekWidgetByName(root, "Text_3")

    local action = csb.createTimeline(config_csb.big_map.map_legion_battle_vic)
    table.insert(self.actions, action)
    csbUnion:runAction(action)
    action:play("battle_vic", false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "window_open_over" then
            state_machine.excute("union_fighting_battle_vic_close", 0, nil)
        end
    end)
end

function UnionFightingBattleVic:onEnterTransitionFinish()
end

function UnionFightingBattleVic:init(params)
    self:onInit(params)
	return self
end

function UnionFightingBattleVic:onExit()

end
