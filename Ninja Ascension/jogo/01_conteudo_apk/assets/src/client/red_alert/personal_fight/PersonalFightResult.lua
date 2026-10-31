-----------------------------
-- 个人战战斗胜利
-----------------------------
PersonalFightResult = class("PersonalFightResultClass", Window)

local personal_fight_result_open_terminal = {
	_name = "personal_fight_result_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("PersonalFightResultClass") == nil then
            fwin:open(PersonalFightResult:new():init(params), fwin._ui)
        end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local personal_fight_result_close_terminal = {
	_name = "personal_fight_result_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("PersonalFightResultClass"))
        fwin:removeAll()
        cacher.destorySystemCacher()
        state_machine.excute("national_truce_loading_window_open", 0, {_datas = {open_type = 1}})
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(personal_fight_result_open_terminal)
state_machine.add(personal_fight_result_close_terminal)
state_machine.init()

function PersonalFightResult:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
end

function PersonalFightResult:onInit(params)
	local csbItem = csb.createNode(config_csb.palyer_build.palyer_build_battle_vic)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbItem)

    local action = csb.createTimeline(config_csb.palyer_build.palyer_build_battle_vic)
    table.insert(self.actions,action)
    csbItem:runAction(action)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_victory_in_battle_go_on"), nil, 
    {
        terminal_name = "personal_fight_result_close", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    local treward_data = getSceneReward(78)
    if treward_data ~= nil and treward_data.show_reward_list ~= nil then
        for i=1,4 do
            local Panel_res = ccui.Helper:seekWidgetByName(root, "Panel_res_"..i)
            Panel_res:removeAllChildren(true)
            local info = treward_data.show_reward_list[i]
            if info ~= nil then
                local cell = state_machine.excute("all_resource_create_cell",0,{2,info,info,1,0,true,true})
                Panel_res:addChild(cell)
            end
        end
    end

    local ListView_battle_role = ccui.Helper:seekWidgetByName(root, "ListView_battle_role")
    ListView_battle_role:removeAllItems()
    local Panel_fail = ccui.Helper:seekWidgetByName(root, "Panel_fail")
    local Panel_text_win = ccui.Helper:seekWidgetByName(root, "Panel_text_win")
    Panel_fail:setVisible(false)
    Panel_text_win:setVisible(false)
    if params[1] == true then
        action:play("window_open", false)
        Panel_text_win:setVisible(true)
        local ArmatureNode_win = Panel_text_win:getChildByName("ArmatureNode_win")
        if nil ~= ArmatureNode_win:getAnimation() then
            ArmatureNode_win:getAnimation():playWithIndex(0, 0, 0)
        end
    else
        Panel_fail:setVisible(true)
    end

    -- local result = ""
    -- local index = 0
    -- for i=2,6 do
    --     local ship_id = _ED.formetion[i]
    --     if tonumber(ship_id) > 0 then
    --         local ship = _ED.user_ship[""..ship_id]
    --         if ship ~= nil 
    --             and tonumber(ship.current_hp) < tonumber(ship.ship_health) 
    --             then
    --             index = index + 1
    --             local loseHp = tonumber(ship.ship_health) - tonumber(ship.current_hp)
    --             if index == 1 then
    --                 result = result..ship.ship_base_template_id..","..math.ceil(loseHp)..","..ship.ship_id..","..math.ceil(ship.ship_health)
    --             else
    --                 result = result.."|"..ship.ship_base_template_id..","..math.ceil(loseHp)..","..ship.ship_id..","..math.ceil(ship.ship_health)
    --             end
    --         end
    --     end
    -- end
    -- if result ~= "" and index > 0 then
    --     protocol_command.user_stronghold_revived.param_list = "0\r\n"..result
    --     NetworkManager:register(protocol_command.user_stronghold_revived.code, nil, nil, nil, nil, nil, false, nil)
    -- end

    local myHpInfo = zstring.split(params[2], "|")
    for k,v in pairs(myHpInfo) do
        local ship_infos = zstring.split(v, ",")
        local ship = _ED.user_ship[""..ship_infos[1]]
        if ship ~= nil then
            local hp = ship.current_hp
            if tonumber(ship_infos[4]) == 0 then
                hp = 0
            end
            local v = {shipid = ship.ship_id, lessHp = hp, maxHp = ship_infos[3], ship_template_id = ship.ship_template_id, ship_type = ship.ship_type}
            local cell = state_machine.excute("battle_ui_icon_cell",0,{v})
            ListView_battle_role:addChild(cell)
            state_machine.excute("battle_ui_icon_cell_update_hp", 0, {cell = cell, role = nil, shipId = nil, hp = hp, maxHp = ship_infos[3]})
            ccui.Helper:seekWidgetByName(root, "Text_bolld_"..k):setString("-"..(math.ceil(ship_infos[3]) - math.ceil(ship_infos[4])))
        end
    end
end

function PersonalFightResult:onEnterTransitionFinish()
end

function PersonalFightResult:init(params)
    self:onInit(params)
	return self
end

function PersonalFightResult:onExit()

end
