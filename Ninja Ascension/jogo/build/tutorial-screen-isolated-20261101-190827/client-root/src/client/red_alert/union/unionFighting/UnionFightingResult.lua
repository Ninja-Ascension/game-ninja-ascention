UnionFightingResult = class("UnionFightingResultClass", Window)

local union_fighting_result_open_terminal = {
	_name = "union_fighting_result_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		state_machine.excute("union_fighting_one_battle_result_close", 0, nil)
        if fwin:find("UnionFightingResultClass") == nil then
            fwin:open(UnionFightingResult:new():init(params), fwin._ui)
        end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local union_fighting_result_close_terminal = {
	_name = "union_fighting_result_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        _ED.union_fight_city_result = nil
		fwin:close(fwin:find("UnionFightingResultClass"))
        if tonumber(_ED.union_fight_city_attack_union_id) ~= tonumber(_ED.union.union_info.union_id) then
            state_machine.excute("union_fighting_main_close", 0, nil)
            state_machine.excute("union_fighting_fail_open", 0, nil)
        else
            state_machine.excute("union_fighting_main_change_fight_scene_info", 0, nil)
        end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(union_fighting_result_open_terminal)
state_machine.add(union_fighting_result_close_terminal)
state_machine.init()

function UnionFightingResult:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
end

function UnionFightingResult:onInit(params)
	local csbUnion = csb.createNode(config_csb.big_map.map_legion_battle_win)
    local root = csbUnion:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbUnion)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_victory_in_battle_go_on"), nil, 
    {
        terminal_name = "union_fighting_result_close", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    local Panel_build = ccui.Helper:seekWidgetByName(root, "Panel_build")
    Panel_build:removeAllChildren(true)
    local baseName = "effect/effect_chengchiyizhu"
    local skeletonNode = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)
    skeletonNode:setAnimation(0, "animation", true)
    Panel_build:addChild(skeletonNode)

    local Text_build_infor = ccui.Helper:seekWidgetByName(root, "Text_build_infor")
    local Text_legion_name_2 = ccui.Helper:seekWidgetByName(root, "Text_legion_name_2")

    if tonumber(_ED.union_fight_city_result) == 0 then
    	Text_build_infor:setString(string.format(tipStringInfo_union_str[113], _ED.union_fight_city_attack_union_name))
    else
    	Text_build_infor:setString(string.format(tipStringInfo_union_str[113], _ED.union_fight_city_defend_union_name))
    end
end

function UnionFightingResult:onEnterTransitionFinish()
end

function UnionFightingResult:init(params)
    self:onInit(params)
	return self
end

function UnionFightingResult:onExit()

end
