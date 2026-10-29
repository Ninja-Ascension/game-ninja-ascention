-----------------------------
--阿拉希之战
-----------------------------
UnionGetPhysicalFight = class("UnionGetPhysicalFightClass", Window)
--打开
local union_get_physical_fight_window_open_terminal = {
    _name = "union_get_physical_fight_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:open(UnionGetPhysicalFight:new():init(), fwin._view)
        state_machine.excute("player_resource_window_hide", 0, "")
        state_machine.excute("main_window_hide", 0, "")   
        state_machine.excute("home_button_for_action_window_hide",0,"")
        state_machine.excute("chat_view_window_hide",0,"")
        state_machine.excute("duplicate_title_window_hide",0,"")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
--关闭
local union_get_physical_fight_window_close_terminal = {
    _name = "union_get_physical_fight_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("UnionGetPhysicalFightClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(union_get_physical_fight_window_open_terminal)
state_machine.add(union_get_physical_fight_window_close_terminal)
state_machine.init()

function UnionGetPhysicalFight:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    app.load("client.utils.ConfirmTip")
    app.load("client.red_alert.battle.battle_enum")
    app.load("client.red_alert.cells.union.union_get_physical_fight_cell")
    app.load("client.red_alert.union.teamFight.UnionTeamFightRule")

    local function init_union_get_physical_fight_terminal()
        --创建队伍
        local union_get_physical_fight_create_team_terminal = {
            _name = "union_get_physical_fight_create_team",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local nType = params._datas.ntype
                if nType == 1 
                    and dms.int(dms["union_config"], 10, union_config.param) >= zstring.tonumber(_ED.user_info.user_gold)
                    then
                    state_machine.excute("shortcut_open_function_dailog_cancel_and_ok", 0, 
                    {
                        terminal_name = "shortcut_open_recharge_window", 
                        terminal_state = 0, 
                        _msg = red_alert_all_str[185], 
                        _datas= 
                        {
                        }
                    })
                    return
                end
                if nType == 0 
                    and dms.int(dms["union_config"], 9, union_config.param) >= zstring.tonumber(_ED.user_info.user_silver)
                    then
                    TipDlg.drawTextDailog(tipStringInfo_union_str[71])
                    return
                end

                local function respondCallBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("union_get_physical_fight_enter_fight", 0, nil)
                    end
                end
                protocol_command.union_food_copy_create_group.param_list = _ED.union.user_union_info.union_id.."\r\n"..nType
                NetworkManager:register(protocol_command.union_food_copy_create_group.code, nil, nil, nil, instance, respondCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --打开规则
        local union_get_physical_fight_rule_terminal = {
            _name = "union_get_physical_fight_rule",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("union_team_fight_rule_window_open",0,{1})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新
        local union_get_physical_fight_update_terminal = {
            _name = "union_get_physical_fight_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新
        local union_get_physical_fight_enter_fight_terminal = {
            _name = "union_get_physical_fight_enter_fight",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:requestEnterFight()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(union_get_physical_fight_create_team_terminal)
        state_machine.add(union_get_physical_fight_rule_terminal)
        state_machine.add(union_get_physical_fight_update_terminal)
        state_machine.add(union_get_physical_fight_enter_fight_terminal)
        state_machine.init()
    end

    init_union_get_physical_fight_terminal()
end 

function UnionGetPhysicalFight:requestEnterFight( ... )
    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            protocol_command.battle_result_verify.param_list = "".._ED._current_scene_id.."\r\n".._ED._scene_npc_id
            app.load("client.red_alert.battle.battle_loading")
            state_machine.excute("battle_loading_window_open", 0, battle_enum._fight_type._fight_type_22)
        end
    end
    protocol_command.battle_result_start.param_list = battle_enum._fight_type._fight_type_22.."\r\n".._ED._current_scene_id.."\r\n".._ED._scene_npc_id
    NetworkManager:register(protocol_command.battle_result_start.code, nil, nil, nil, nil, responseCallback, false, nil)
end

function UnionGetPhysicalFight:onUpdateDraw()
    _ED._battle_init_type = battle_enum._fight_type._fight_type_22

    local root = self.roots[1]
    local Panel_button_use = ccui.Helper:seekWidgetByName(root, "Panel_button_use")
    local Text_had_battle = ccui.Helper:seekWidgetByName(root, "Text_had_battle")
    local Text_spend_lv_1 = ccui.Helper:seekWidgetByName(root, "Text_spend_lv_1")
    local Text_spend_lv_2 = ccui.Helper:seekWidgetByName(root, "Text_spend_lv_2")
    local ListView_alaxi_batttle = ccui.Helper:seekWidgetByName(root, "ListView_alaxi_batttle")

    Text_spend_lv_1:setString(dms.string(dms["union_config"], 9, union_config.param))
    Text_spend_lv_2:setString(dms.string(dms["union_config"], 10, union_config.param))
    ListView_alaxi_batttle:removeAllItems()

    local npc_level_info = zstring.split(dms.string(dms["union_config"], 26, union_config.param), "|")
    _ED._current_scene_id = dms.string(dms["union_config"], 27, union_config.param)

    for k,v in pairs(npc_level_info) do
        local levels = zstring.split(v, ",")
        local min_level = levels[1]
        local max_level = levels[2]
        local npc_id = levels[3]
        if tonumber(_ED.user_info.user_grade) >= tonumber(min_level)
            and tonumber(_ED.user_info.user_grade) <= tonumber(max_level)
            then
            _ED._scene_npc_id = npc_id
            isPass = tonumber(_ED.npc_current_attack_count[tonumber(npc_id)]) > 0
        end
    end

    if isPass == true then
        Panel_button_use:setVisible(false)
        Text_had_battle:setVisible(true)
    else
        if tonumber(_ED.union.union_get_physical_my_team_id) > 0 then
            Panel_button_use:setVisible(false)
            Text_had_battle:setVisible(false)
        else
            Panel_button_use:setVisible(true)
            Text_had_battle:setVisible(false)
        end
    end

    for k,v in pairs(_ED.union.union_get_physical_info_list) do
    	local cell = state_machine.excute("union_get_physical_fight_create_cell", 0, {i, v, isPass})
    	ListView_alaxi_batttle:addChild(cell)
    end
    ListView_alaxi_batttle:requestRefreshView()
end

function UnionGetPhysicalFight:onEnterTransitionFinish()
   self:checkReward()
end

function UnionGetPhysicalFight:checkReward()
   state_machine.excute("reward_obtain_window_open",0,{25})
end

function UnionGetPhysicalFight:onInit( )
    local csbItem = csb.createNode(config_csb.legion.legion_alaxi_battle)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "union_get_physical_fight_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    --金币劫粮
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_use_money"), nil, 
    {
        terminal_name = "union_get_physical_fight_create_team",
        terminal_state = 0, 
        touch_scale = true,
        ntype = 0,
        touch_scale_xy = 0.95, 
    }, nil, 0) 
    --钻石劫粮
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_use_gem"), nil, 
    {
        terminal_name = "union_get_physical_fight_create_team",
        terminal_state = 0, 
        touch_scale = true,
        ntype = 1,
        touch_scale_xy = 0.95, 
    }, nil, 0) 
    --规则
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_rule"), nil, 
    {
        terminal_name = "union_get_physical_fight_rule",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    self:onUpdateDraw()
end

function UnionGetPhysicalFight:init()
	self:onInit()
    return self
end

function UnionGetPhysicalFight:onExit()  
    state_machine.remove("union_get_physical_fight_create_team")
    state_machine.remove("union_get_physical_fight_rule")
    state_machine.remove("union_get_physical_fight_update")
    state_machine.remove("union_get_physical_fight_enter_fight")
end