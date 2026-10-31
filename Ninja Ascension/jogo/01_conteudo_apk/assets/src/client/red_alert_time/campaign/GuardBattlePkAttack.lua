--------------------------------------------------------------------------------------------------------------
--  说明：守卫战进攻
--------------------------------------------------------------------------------------------------------------
GuardBattlePkAttack = class("GuardBattlePkAttackClass", Window)

--打开界面
local guard_battle_pk_attack_open_terminal = {
    _name = "guard_battle_pk_attack_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("GuardBattlePkAttackClass") == nil then
            fwin:open(GuardBattlePkAttack:new():init(params), fwin._ui)  
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local guard_battle_pk_attack_close_terminal = {
    _name = "guard_battle_pk_attack_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("GuardBattlePkAttackClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(guard_battle_pk_attack_open_terminal)
state_machine.add(guard_battle_pk_attack_close_terminal)
state_machine.init()

function GuardBattlePkAttack:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._info_data = nil

    app.load("client.red_alert_time.cells.formation.formation_tank_head_cell")
    app.load("client.red_alert_time.cells.formation.formation_leader_head_cell")
    app.load("client.red_alert_time.battle.battle_enum")
    app.load("client.red_alert_time.pve.PveRaid")
    local function init_guard_battle_pk_attack_terminal()
        local guard_battle_pk_attack_show_terminal = {
            _name = "guard_battle_pk_attack_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local guard_battle_pk_attack_hide_terminal = {
            _name = "guard_battle_pk_attack_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local guard_battle_pk_attack_begin_fight_terminal = {
            _name = "guard_battle_pk_attack_begin_fight",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local leave_time = _ED.guard_battle_user_info.cd_end_time - (os.time() + _ED.time_add_or_sub)
                if leave_time > 0 then
                    state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {m_type = 25}})
                else
                    _ED._battle_init_type = battle_enum._fight_type._fight_type_209
                    _ED._current_scene_id = 1
                    _ED._scene_npc_id = instance._info_data.id
                    _ED._npc_difficulty_index = instance._info_data.user_type
                    state_machine.excute("formation_window_open",0,{_datas = {form_type = 13}})
                    state_machine.excute("guard_battle_pk_attack_close", 0, 0)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新界面
        local guard_battle_pk_attack_update_draw_terminal = {
            _name = "guard_battle_pk_attack_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local new_info = _ED.guard_battle_list_info[""..instance._info_data.id]
                if new_info == nil then
                    TipDlg.drawTextDailog(red_alert_time_str[298])
                    state_machine.excute("guard_battle_pk_attack_close", 0, "")
                else
                    instance._info_data = new_info
                    instance:updateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(guard_battle_pk_attack_show_terminal)
        state_machine.add(guard_battle_pk_attack_hide_terminal)
        state_machine.add(guard_battle_pk_attack_begin_fight_terminal)
        state_machine.add(guard_battle_pk_attack_update_draw_terminal)
        state_machine.init()
    end
    
    init_guard_battle_pk_attack_terminal()
end

function GuardBattlePkAttack:updateDraw()
    local root = self.roots[1]
    local Text_npc_name = ccui.Helper:seekWidgetByName(root,"Text_get_t")
    local Text_get_t = ccui.Helper:seekWidgetByName(root,"Text_get_t")
    local Button_pve_sweep = ccui.Helper:seekWidgetByName(root,"Button_pve_sweep")
    local Text_all_star_prompt = ccui.Helper:seekWidgetByName(root,"Text_all_star_prompt")
    Text_get_t:setVisible(false)
    Button_pve_sweep:setVisible(false)

    local fontName = config_res.font.font_name
    if isContentZh_TW() == true then
        fontName = ""
    end
    if self._info_data.user_type ~= nil and zstring.tonumber(self._info_data.user_type) == -1 then
        fontName = config_res.font.font_name
    end
    Text_npc_name:setFontName(fontName)
    Text_npc_name:setFontSize(Text_npc_name:getFontSize())
    
    Text_npc_name:setString(string.format(red_alert_time_str[174], self._info_data.name))
    
    local Text_enemy_formtion = ccui.Helper:seekWidgetByName(root,"Text_enemy_formtion")
    local current_enemy_formation = zstring.split(self._info_data.formation_info, "|")
    local have_count = 0
    for i=1,6 do
        local current_enemy_info = zstring.split(current_enemy_formation[i], ",")
        if tonumber(current_enemy_info[3]) > 0 then
            have_count = have_count + current_enemy_info[3]
        end
        local Panel_form_point = ccui.Helper:seekWidgetByName(root,"Panel_form_point_"..i)
        local Panel_formation_tank = ccui.Helper:seekWidgetByName(root, "Panel_formation_tank_"..i)
        Panel_formation_tank:removeAllChildren(true)
        local Panel_formation_leader = ccui.Helper:seekWidgetByName(root, "Panel_formation_leader_"..i)
        Panel_formation_leader:removeAllChildren(true)
        local info_ship = {ship_template_id = current_enemy_info[2]}
        local leader = {ship_template_id = current_enemy_info[7]}
        local cell = state_machine.excute("formation_tank_head_cell_create_cell", 0, {i, info_ship, current_enemy_info[3],3})
        Panel_formation_tank:addChild(cell)

        local cell = state_machine.excute("formation_leader_head_cell_create_cell", 0, {i,leader,2, 2})
        Panel_formation_leader:addChild(cell)
    end
    Text_enemy_formtion:setString(string.format(arena_tip_text[14], have_count))

    local Button_attack = ccui.Helper:seekWidgetByName(root,"Button_attack")
    Button_attack:setPositionX(320)
    Text_all_star_prompt:setVisible(false)

    if _ED.guard_battle_user_info ~= nil and tonumber(_ED.guard_battle_user_info.battle_type) == 0 then
        Button_attack:setVisible(false)
    else
        Button_attack:setVisible(true)
    end
end

--初始化
function GuardBattlePkAttack:onInit()
    local csbItem = csb.createNode(config_csb.pve.pve_attack_winodw)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pve_attack_close"), nil, 
    {
        terminal_name = "guard_battle_pk_attack_close",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "guard_battle_pk_attack_close", 
        terminal_state = 0, 
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_attack"), nil, 
    {
        terminal_name = "guard_battle_pk_attack_begin_fight",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)

    self:updateDraw()
end

function GuardBattlePkAttack:onEnterTransitionFinish()

end

function GuardBattlePkAttack:init(params)
    self._info_data = params[1]
    self:onInit()
    return self
end

function GuardBattlePkAttack:onExit()
    state_machine.remove("guard_battle_pk_attack_show")
    state_machine.remove("guard_battle_pk_attack_hide")
    state_machine.remove("guard_battle_pk_attack_begin_fight")
    state_machine.remove("guard_battle_pk_attack_update_draw")
end