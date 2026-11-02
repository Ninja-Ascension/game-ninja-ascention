UnionFightingBuildInfo = class("UnionFightingBuildInfoClass", Window)

local union_fighting_build_info_open_terminal = {
	_name = "union_fighting_build_info_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("UnionFightingBuildInfoClass") == nil then
            fwin:open(UnionFightingBuildInfo:new():init(params), fwin._ui)
        end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local union_fighting_build_info_close_terminal = {
	_name = "union_fighting_build_info_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("UnionFightingBuildInfoClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(union_fighting_build_info_open_terminal)
state_machine.add(union_fighting_build_info_close_terminal)
state_machine.init()

function UnionFightingBuildInfo:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

    self._city_id = 0

    app.load("client.red_alert.cells.union.union_fight_build_info_attack_cell")
    app.load("client.red_alert.cells.union.union_fight_build_info_defend_cell")

    local function init_union_fighting_build_info_terminal()
        local union_fighting_build_info_show_terminal = {
            _name = "union_fighting_open_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance ~= nil and instance.roots ~= nil then
                    instance:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(union_fighting_build_info_show_terminal)
        state_machine.init()
    end

    init_union_fighting_build_info_terminal()
end

function UnionFightingBuildInfo:onUpdateDraw( ... )
    local root = self.roots[1]
    local Panel_build_icon = ccui.Helper:seekWidgetByName(root, "Panel_build_icon")
    local Text_build_legion_name = ccui.Helper:seekWidgetByName(root, "Text_build_legion_name")
    local ListView_infor = ccui.Helper:seekWidgetByName(root, "ListView_infor")
    local ListView_infor_1 = ccui.Helper:seekWidgetByName(root, "ListView_infor_1")
    local Text_build_infor_officer_no = ccui.Helper:seekWidgetByName(root, "Text_build_infor_officer_no")
    local Text_build_infor_officer_no_0 = ccui.Helper:seekWidgetByName(root, "Text_build_infor_officer_no_0")
    Panel_build_icon:removeBackGroundImage()
    ListView_infor:removeAllItems()
    ListView_infor_1:removeAllItems()
    Text_build_infor_officer_no:setVisible(false)
    Text_build_infor_officer_no_0:setVisible(false)

    local info = _ED.union_stronghold_info_list[""..self._city_id]
    if tonumber(info.union_id) == 0 then
        Text_build_legion_name:setString(tipStringInfo_union_str[116])
    else
        Text_build_legion_name:setString(info.union_name)
    end

    Panel_build_icon:setBackGroundImage("images/ui/play/big_map/big_map_build_1.png")

    local defend_list = {}
    local attack_list = {}

    for k,v in pairs(_ED.union_fight_other_city_info.defend_list) do
        if tonumber(v.union_id) == 0 then
        elseif tonumber(v.union_id) == tonumber(info.union_id) then
            table.insert(defend_list, v)
        else
            table.insert(attack_list, v)
        end
    end
    for k,v in pairs(_ED.union_fight_other_city_info.attacker_list) do
        table.insert(attack_list, v)
    end

    function sortFun( a, b )
        return tonumber(a.union_id) > tonumber(b.union_id)
    end
    table.sort(attack_list, sortFun)

    local attack_result = {}
    for k,v in pairs(attack_list) do
        if math.ceil((k - 1)%2) == 0 then
            table.insert(attack_result, {})
        end
        table.insert(attack_result[#attack_result], v)
    end
    if #attack_result == 0 then
        Text_build_infor_officer_no:setVisible(true)
    else
        for k,v in pairs(attack_result) do
            local cell = state_machine.excute("union_fight_build_info_attack_cell_create", 0, {v})
            ListView_infor:addChild(cell)
        end
        ListView_infor:requestRefreshView()
    end

    local defend_result = {}
    for k,v in pairs(defend_list) do
        if math.ceil((k - 1)%4) == 0 then
            table.insert(defend_result, {})
        end
        table.insert(defend_result[#defend_result], v.user_name)
    end
    if #defend_list == 0 then
        Text_build_infor_officer_no_0:setVisible(true)
    else
        for k,v in pairs(defend_result) do
            local cell = state_machine.excute("union_fight_build_info_defend_cell_create", 0, {v})
            ListView_infor_1:addChild(cell)
        end
        ListView_infor_1:requestRefreshView()
    end
end

function UnionFightingBuildInfo:onInit()
	local csbUnion = csb.createNode(config_csb.big_map.map_legion_battle_build_infor)
    local root = csbUnion:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbUnion)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_build_infor_close"), nil, 
    {
        terminal_name = "union_fighting_build_info_close", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    self:onUpdateDraw()
end

function UnionFightingBuildInfo:onEnterTransitionFinish()
end

function UnionFightingBuildInfo:init(params)
    self._city_id = params[1]
    self:onInit()
	return self
end

function UnionFightingBuildInfo:onExit()

end
