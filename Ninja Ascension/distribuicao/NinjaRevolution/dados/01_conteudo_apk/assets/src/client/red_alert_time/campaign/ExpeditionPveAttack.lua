--------------------------------------------------------------------------------------------------------------
--  说明：远征挑战界面
--------------------------------------------------------------------------------------------------------------
ExpeditionPveAttack = class("ExpeditionPveAttackClass", Window)

--打开界面
local expedition_pve_attack_open_terminal = {
	_name = "expedition_pve_attack_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("ExpeditionPveAttackClass") == nil then
    		fwin:open(ExpeditionPveAttack:new():init(params), fwin._ui)  
        end
	    return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local expedition_pve_attack_close_terminal = {
	_name = "expedition_pve_attack_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ExpeditionPveAttackClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(expedition_pve_attack_open_terminal)
state_machine.add(expedition_pve_attack_close_terminal)
state_machine.init()

function ExpeditionPveAttack:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}

    self._npc_index = 0

    app.load("client.red_alert_time.cells.formation.formation_tank_head_cell")
    app.load("client.red_alert_time.cells.formation.formation_leader_head_cell")
    app.load("client.red_alert_time.battle.battle_enum")
    app.load("client.red_alert_time.pve.PveRaid")
    local function init_expedition_pve_attack_terminal()
        local expedition_pve_attack_show_terminal = {
            _name = "expedition_pve_attack_show",
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

        local expedition_pve_attack_hide_terminal = {
            _name = "expedition_pve_attack_hide",
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

        local expedition_pve_attack_begin_fight_terminal = {
            _name = "expedition_pve_attack_begin_fight",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                _ED._battle_init_type = battle_enum._fight_type._fight_type_201
                _ED._current_scene_id = 1
                _ED._scene_npc_id = 1
                _ED._npc_difficulty_index = self._npc_index - 1
                state_machine.excute("formation_window_open",0,{_datas = {form_type = 8}})
                state_machine.excute("expedition_pve_attack_close", 0, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新界面
        local expedition_pve_attack_update_draw_terminal = {
            _name = "expedition_pve_attack_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(expedition_pve_attack_show_terminal)
        state_machine.add(expedition_pve_attack_hide_terminal)
        state_machine.add(expedition_pve_attack_begin_fight_terminal)
        state_machine.add(expedition_pve_attack_update_draw_terminal)
        state_machine.init()
    end
    
    init_expedition_pve_attack_terminal()
end

function ExpeditionPveAttack:updateDraw()
    local root = self.roots[1]
    local Text_get_t = ccui.Helper:seekWidgetByName(root,"Text_get_t")
    local Button_pve_sweep = ccui.Helper:seekWidgetByName(root,"Button_pve_sweep")
    local Text_all_star_prompt = ccui.Helper:seekWidgetByName(root,"Text_all_star_prompt")
    local Text_npc_name = ccui.Helper:seekWidgetByName(root,"Text_npc_name")
    local Text_get_reward = ccui.Helper:seekWidgetByName(root,"Text_get_reward")

    local rewardFontSize = Text_get_reward:getFontSize()

    Text_npc_name:setString(arena_tip_text[12])
    Text_get_t:setVisible(false)
    Button_pve_sweep:setVisible(false)
    
    local Text_enemy_formtion = ccui.Helper:seekWidgetByName(root,"Text_enemy_formtion")
    local current_enemy_formation = zstring.split(_ED.user_expedition_info.current_enemy_formation, "|")
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
        info_ship = {ship_template_id = current_enemy_info[2]}
        leader = {ship_template_id = current_enemy_info[7]}
        local cell = state_machine.excute("formation_tank_head_cell_create_cell", 0, {i, info_ship, current_enemy_info[3],3})
        Panel_formation_tank:addChild(cell)

        local cell = state_machine.excute("formation_leader_head_cell_create_cell", 0, {i,leader,2, 2})
        Panel_formation_leader:addChild(cell)
    end
    Text_enemy_formtion:setString(string.format(arena_tip_text[14],exChangeNumToString(have_count)))

    local Button_attack = ccui.Helper:seekWidgetByName(root,"Button_attack")
    local Button_arena_attack = ccui.Helper:seekWidgetByName(root,"Button_arena_attack")
    Button_attack:setVisible(false)
    Button_arena_attack:setVisible(true)
    
    Text_all_star_prompt:setString(red_alert_time_str[132])
    Text_all_star_prompt:setPositionX(320)
    Text_all_star_prompt:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))

    Text_get_reward:setString("")
    Text_get_reward:removeAllChildren(true)

    local _richText_2 = ccui.RichText:create()
    _richText_2:ignoreContentAdaptWithSize(false) 
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, tipStringInfo_campaign_info[38], "fonts/simhei.ttf",rewardFontSize)
    _richText_2:pushBackElement(re1)

    for i= 1, dms.count(dms["expedition_reward"]) do
        local expedition_reward_info = dms.element(dms["expedition_reward"], i)
        local level = dms.atoi(expedition_reward_info, expedition_reward.level)
        if level == tonumber(_ED.user_info.user_grade) then
            local score_info = dms.atos(expedition_reward_info, expedition_reward.score_info)
            score_info = zstring.split(score_info, "|")
            for k,v in pairs(score_info) do
                if k == self._npc_index then
                    local info = zstring.split(v, ",")
                    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]), 255, reward_prop_list[tonumber(info[2])], "fonts/simhei.ttf",rewardFontSize)
                    _richText_2:pushBackElement(re2)
                    local re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]), 255, "+"..info[3], "fonts/simhei.ttf", rewardFontSize)
                    _richText_2:pushBackElement(re3)
                end
            end
            local reward_info = dms.atos(expedition_reward_info, expedition_reward.reward_info)
            reward_info = zstring.split(reward_info, ",")
            for k,v in pairs(reward_info) do
                if k == self._npc_index then
                    local reward_items = zstring.split(dms.string(dms["scene_reward"], v, scene_reward.reward_items), ",")
                    local reward_name = dms.string(dms["prop_mould"], reward_items[1], prop_mould.prop_name)
                    local re4 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]), 255, "，"..reward_name, "fonts/simhei.ttf", rewardFontSize)
                    _richText_2:pushBackElement(re4)
                end
            end
        end
    end
    _richText_2:setPosition(cc.p(Text_get_reward:getContentSize().width/2,Text_get_reward:getContentSize().height/2))
    _richText_2:setContentSize(cc.size(Text_get_reward:getContentSize().width,rewardFontSize))
    Text_get_reward:addChild(_richText_2)
end

--初始化
function ExpeditionPveAttack:onInit()
    local csbItem = csb.createNode(config_csb.pve.pve_attack_winodw)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pve_attack_close"), nil, 
    {
        terminal_name = "expedition_pve_attack_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "expedition_pve_attack_close", 
        terminal_state = 0, 
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_attack"), nil, 
    {
        terminal_name = "expedition_pve_attack_begin_fight",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_arena_attack"), nil, 
    {
        terminal_name = "expedition_pve_attack_begin_fight",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)

    self:updateDraw()
end

function ExpeditionPveAttack:onEnterTransitionFinish()

end

function ExpeditionPveAttack:init(params)
    self._npc_index = params[1]
	self:onInit()
    return self
end

function ExpeditionPveAttack:onExit()
    state_machine.remove("expedition_pve_attack_show")
    state_machine.remove("expedition_pve_attack_hide")
    state_machine.remove("expedition_pve_attack_begin_fight")
    state_machine.remove("expedition_pve_attack_update_draw")
end