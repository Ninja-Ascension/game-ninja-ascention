--------------------------------------------------------------------------------------------------------------
--  说明：工会pk挑战界面
--------------------------------------------------------------------------------------------------------------
LegionPKAttack = class("LegionPKAttackClass", Window)

--打开界面
local legion_pk_attack_open_terminal = {
	_name = "legion_pk_attack_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("LegionPKAttackClass") == nil then
    		fwin:open(LegionPKAttack:new():init(params), fwin._ui)  
        end
	    return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local legion_pk_attack_close_terminal = {
	_name = "legion_pk_attack_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LegionPKAttackClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(legion_pk_attack_open_terminal)
state_machine.add(legion_pk_attack_close_terminal)
state_machine.init()

function LegionPKAttack:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}

    self._info = nil
    self._type = 0 

    app.load("client.red_alert_time.cells.formation.formation_tank_head_cell")
    app.load("client.red_alert_time.cells.formation.formation_leader_head_cell")
    app.load("client.red_alert_time.utils.ShortCut")
    local function init_legion_pk_attack_terminal()
        local legion_pk_attack_begin_fight_terminal = {
            _name = "legion_pk_attack_begin_fight",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance._type <= 0 then
                    _ED._battle_init_type = battle_enum._fight_type._fight_type_24
                    _ED._current_scene_id = 1
                    _ED._legion_pk_defender_id = instance._info.id
                    state_machine.excute("formation_window_open", 0, {_datas = {form_type = 5}})
                else
                    local fight_type = battle_enum._fight_type._fight_type_202
                    local scene_id = 1
                    local npc_id = 1
                    local difficulty = instance._type - 1
                    state_machine.excute("adventure_mine_request_battle_field_init", 0, {fight_type, scene_id, npc_id, difficulty})
                end

                state_machine.excute("legion_pk_attack_close", 0, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_pk_attack_begin_fight_terminal)
        state_machine.init()
    end
    init_legion_pk_attack_terminal()
end

function LegionPKAttack:updateDraw()
    local root = self.roots[1]
    local play_formation_info = nil
    local Text_npc_name = ccui.Helper:seekWidgetByName(root,"Text_npc_name")
    Text_npc_name:setString(arena_tip_text[12])
    if self._type <= 0 then
        play_formation_info = zstring.split(self._info.play_formation_info, "|")
    else
        play_formation_info = zstring.split(self._info, "|")
    end
    local formation_times = 0
    for i=1,6 do
        local Panel_form_point = ccui.Helper:seekWidgetByName(root,"Panel_form_point_"..i)
        local Panel_formation_tank = ccui.Helper:seekWidgetByName(root, "Panel_formation_tank_"..i)
        Panel_formation_tank:removeAllChildren(true)
        local Panel_formation_leader = ccui.Helper:seekWidgetByName(root, "Panel_formation_leader_"..i)
        Panel_formation_leader:removeAllChildren(true)
        local choose_count = 0
        local info_ship = nil
        local leader = nil
        if play_formation_info[i] ~= nil then
            local formation_info = zstring.split(play_formation_info[i], ",")
            choose_count = tonumber(formation_info[3])
            info_ship = {ship_template_id = formation_info[2]}
            leader = {ship_template_id = formation_info[7]}
        end
        formation_times = formation_times + choose_count
        local cell = state_machine.excute("formation_tank_head_cell_create_cell", 0, {i, info_ship, choose_count,3})
        Panel_formation_tank:addChild(cell)

        local cell = state_machine.excute("formation_leader_head_cell_create_cell", 0, {i,leader,2, 2})
        Panel_formation_leader:addChild(cell)
    end

    local Text_get_reward = ccui.Helper:seekWidgetByName(root,"Text_get_reward")
    local Text_get_t = ccui.Helper:seekWidgetByName(root,"Text_get_t")
    if self._type <= 0 then
        Text_get_reward:setString(tipString_legion_info[42]..exChangeNumToString(self._info.formation_capactity))
        Text_get_t:setString(tipString_legion_info[43]..formation_times)
    else
        Text_get_t:setString("")
    end

    local Text_all_star_prompt = ccui.Helper:seekWidgetByName(root,"Text_all_star_prompt")
    local Button_pve_sweep = ccui.Helper:seekWidgetByName(root,"Button_pve_sweep")
    local Button_attack = ccui.Helper:seekWidgetByName(root,"Button_attack")
    local Button_arena_attack = ccui.Helper:seekWidgetByName(root,"Button_arena_attack")
    Text_all_star_prompt:setVisible(false)
    Button_pve_sweep:setVisible(false)
    Button_attack:setVisible(false)
    Button_arena_attack:setVisible(true)
end

--初始化
function LegionPKAttack:onInit()
    local csbItem = csb.createNode(config_csb.pve.pve_attack_winodw)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pve_attack_close"), nil, 
    {
        terminal_name = "legion_pk_attack_close",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,3)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "legion_pk_attack_close", 
        terminal_state = 0, 
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_attack"), nil, 
    {
        terminal_name = "legion_pk_attack_begin_fight",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_arena_attack"), nil, 
    {
        terminal_name = "legion_pk_attack_begin_fight",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)

    self:updateDraw()
end

function LegionPKAttack:onEnterTransitionFinish()

end

function LegionPKAttack:init(params)
    self._info = params[1]
    self._type = params[2]
	self:onInit()
    return self
end

function LegionPKAttack:onExit()
    state_machine.remove("legion_pk_attack_begin_fight")
end