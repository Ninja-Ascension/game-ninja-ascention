-----------------------------
-- 结伴江湖阵型选择
-----------------------------
UnionTeamFightFormation = class("UnionTeamFightFormationClass", Window)

local union_team_fight_formation_window_open_terminal = {
    _name = "union_team_fight_formation_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:open(UnionTeamFightFormation:new():init(), fwin._ui)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local union_team_fight_formation_window_close_terminal = {
    _name = "union_team_fight_formation_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local UnionTeamFightFormationWindow = fwin:find("UnionTeamFightFormationClass")
        if UnionTeamFightFormationWindow ~= nil then
            fwin:close(UnionTeamFightFormationWindow)
        end 
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(union_team_fight_formation_window_open_terminal)
state_machine.add(union_team_fight_formation_window_close_terminal)
state_machine.init()

function UnionTeamFightFormation:ctor()
    self.super:ctor()
    self.roots = {}

    --var
	self.listview = nil
	self.listview_pox = nil
    self.formation_type = 1

    --第一次进入不播放光效
    self.show_init = true

    self._all_ship = {}
    self._temp_ship = {}
    self._choose_formation = {}
    self._last_formetion = {}

    app.load("client.red_alert.cells.hero.hero_icon_cell")

    local function init_UnionTeamFightFormation_terminal()
		--换上一个阵容（左翻页）
		local union_team_fight_formation_turn_left_terminal = {
            _name = "union_team_fight_formation_turn_left",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance.formation_type == 1 then
                    return
                end
                instance.formation_type = instance.formation_type -1
                instance:playActions()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		--换下一个阵容（右翻页）
		local union_team_fight_formation_turn_right_terminal = {
            _name = "union_team_fight_formation_turn_right",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance.formation_type == 5 then
                    return
                end            
                instance.formation_type = instance.formation_type + 1
                instance:playActions()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	

		--保存布阵信息
		local union_team_fight_formation_save_terminal = {
            _name = "union_team_fight_formation_save",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local count = 0
                _ED.union.union_team_fight_info = {}
                _ED.union.union_team_fight_info.ships = {}
                for k,v in pairs(instance._choose_formation) do
                    if tonumber(v) > 0 then
                        count = count + 1
                        _ED.union.union_team_fight_info.ships[""..v] = instance._temp_ship[""..v]
                    end
                end
                if count == 0 then
                    TipDlg.drawTextDailog(tipStringInfo_union_str[77])
                    return
                end
                _ED.union.union_team_fight_info.formation_type = instance.formation_type
                _ED.union.union_team_fight_info.formation = {"0"}
                for k,v in pairs(instance._choose_formation) do
                    table.insert(_ED.union.union_team_fight_info.formation, v)
                end

                _ED._battle_init_type = battle_enum._fight_type._fight_type_21

                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("union_team_fight_formation_window_close", 0, nil)
                        app.load("client.red_alert.battle.battle_loading")
                        state_machine.excute("battle_loading_window_open", 0, battle_enum._fight_type._fight_type_21)                                            
                    end
                end
                protocol_command.battle_result_start.param_list = ""..battle_enum._fight_type._fight_type_21.."\r\n".._ED._current_scene_id.."\r\n".._ED._scene_npc_id
                NetworkManager:register(protocol_command.battle_result_start.code, nil, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新所有武将  
		local union_team_fight_formation_update_hero_terminal = {
            _name = "union_team_fight_formation_update_hero",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateHero()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        --添加武将
		local union_team_fight_formation_add_hero_terminal = {
            _name = "union_team_fight_formation_add_hero",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local ship = params
                instance:FormationSettingAddHero(ship)
                state_machine.excute("union_team_fight_formation_update_hero",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        --移除武将
		local union_team_fight_formation_remove_hero_terminal = {
            _name = "union_team_fight_formation_remove_hero",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local ship = params
                instance:FormationSettingRemoveHero(ship)
                state_machine.excute("union_team_fight_formation_update_hero",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        --获取上阵人数限制
        local union_team_fight_formation_get_formation_count_terminal = {
            _name = "union_team_fight_formation_get_formation_count",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local count = 0
                for k,v in pairs(self._choose_formation) do
                    if tonumber(v) > 0 then
                        count = count + 1
                    end
                end
                return count >= dms.int(dms["union_config"], 19, union_config.param)
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(union_team_fight_formation_turn_left_terminal)	
		state_machine.add(union_team_fight_formation_turn_right_terminal)
		state_machine.add(union_team_fight_formation_save_terminal)
		state_machine.add(union_team_fight_formation_update_hero_terminal)
		state_machine.add(union_team_fight_formation_add_hero_terminal)
		state_machine.add(union_team_fight_formation_remove_hero_terminal)
        state_machine.add(union_team_fight_formation_get_formation_count_terminal)
        state_machine.init()
    end
    
    init_UnionTeamFightFormation_terminal()
end

function UnionTeamFightFormation:FormationSettingAddHero(ship)
    for i = 1, 6 do
        if zstring.tonumber(self._choose_formation[i]) == 0 then
            self._choose_formation[i] = ship.ship_id
            break
        end
    end
    self:setCellState(ship, true)
    self:sortFormation()
    playEffect(formatMusicFile("effect", 10016))
end

function UnionTeamFightFormation:FormationSettingRemoveHero(ship)
    for i = 1 ,6 do
        if tonumber(self._choose_formation[i]) == tonumber(ship.ship_id) then
            self._choose_formation[i] = 0
        end
    end
    self:setCellState(ship, false)
    self:sortFormation()
    playEffect(formatMusicFile("effect", 10016))
end

function UnionTeamFightFormation:setCellState( ship, isEnabled )
    local items = self.listview:getItems()
    for k,v in pairs(items) do
        if tonumber(v.ship.ship_id) ~= tonumber(ship.ship_id)
            and tonumber(v.ship.ship_base_template_id) == tonumber(ship.ship_base_template_id)
            then
            state_machine.excute("hero_icon_cell_set_enabled_state", 0, {v, isEnabled})
        end
    end
end

function UnionTeamFightFormation:sortFormation()
    local formation_temp = {}
    for i=1, 6 do
        if zstring.tonumber(self._choose_formation[i]) ~= 0 then
            local ship = self._temp_ship[""..self._choose_formation[i]]
            local base_mould_priority = dms.int(dms["ship_mould"],ship.ship_template_id,ship_mould.base_mould_priority)
            local data = 
            {
                ship_id = ship.ship_id,
                index = base_mould_priority,
            }
            table.insert(formation_temp, data)
        end
    end

    local function sortShip( a, b )
        return tonumber(a.index) < tonumber(b.index)
    end
    if #formation_temp == 0 then
        return
    end
    table.sort(formation_temp, sortShip)
    
    for i = 1, 6 do
        self._choose_formation[i] = "0"
    end

    for i,v in pairs(formation_temp) do
        self._choose_formation[i] = v.ship_id
    end
end

function UnionTeamFightFormation:getSortHero()
    local my_user_ships = {}
    for i,v in pairs(_ED.user_ship) do
        table.insert(my_user_ships, v)
    end
    local function sortShipFight( a, b )
        return tonumber(a.hero_fight) > tonumber(b.hero_fight)
    end
    table.sort(my_user_ships, sortShipFight)

    local the_hero_ship = {}
    local insert_bool = true
    for i,v in pairs(my_user_ships) do
        for j,k in pairs(the_hero_ship) do
            if k.ship_base_template_id == v.ship_base_template_id then
                insert_bool = false
            end
        end
        if insert_bool == true then
            table.insert(the_hero_ship, v)
        end
        insert_bool = true
    end

    local result = {}
    for i,v in pairs(_ED.union.union_team_fight_ship_info) do
        table.insert(result, v)
        self._temp_ship[""..v.ship_id] = v
    end
    for i,v in pairs(the_hero_ship) do
        table.insert(result, v)
        self._temp_ship[""..v.ship_id] = v
    end
    return result
end

--切换阵型播放动画
function UnionTeamFightFormation:playActions()
    local root = self.roots[1]
    local Panel_line_set = ccui.Helper:seekWidgetByName(root,"Panel_line_set")
    local position_str = dms.string(dms["formation_mould"],self.formation_type,formation_mould.position_six)
    position_str = zstring.split(position_str,",")
    local Panel_change = ccui.Helper:seekWidgetByName(root,"Panel_change")
    Panel_change:removeAllChildren(true)
    for i=1,9 do
        local Panel_role = ccui.Helper:seekWidgetByName(root,"Panel_role_"..i)
        Panel_role:removeAllChildren(true)
        Panel_role:setVisible(false)
    end
    local jsonPath = "images/ui/effice/effect_zrgx/effect_zrgx.json"
    local atlasPath = "images/ui/effice/effect_zrgx/effect_zrgx.atlas"
    local animation = sp.spine(jsonPath, atlasPath, 1, 0, "animation_event", true, nil)
    animation:setPosition(cc.p(Panel_change:getContentSize().width/2,Panel_change:getContentSize().height/2))
    sp.initArmature(animation, false)
    animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    animation:getAnimation():setFrameEventCallFunc(
    function(bone,evt,originFrameIndex,currentFrameIndex)
        local tempArmature = bone:getArmature()
        if tempArmature:isVisible() == true then
            if evt == "change" then
                for i,v in pairs(position_str) do
                    local Panel_role = ccui.Helper:seekWidgetByName(root,"Panel_role_"..v)
                    Panel_role:setVisible(true)
                    if zstring.tonumber(self._choose_formation[i]) ~= 0 then
                        local ArmatureNode_ro = Panel_line_set:getChildByName("ArmatureNode_ro_"..v)
                        local animation = ArmatureNode_ro:getAnimation()
                        animation:playWithIndex(0, 0, 0)
                        self:createHero(Panel_role, self._choose_formation[i])
                        self:onUpdateHero()
                    end
                end
            end
        end
    end)
    Panel_change:addChild(animation)
end

function UnionTeamFightFormation:onUpdateDraw()
	local root = self.roots[1]
	local ListView_hero_icon = ccui.Helper:seekWidgetByName(root,"ListView_hero_icon")
    ListView_hero_icon:removeAllItems()
    self._all_ship = self:getSortHero()
	for i,ship in pairs(self._all_ship) do
        local cell = state_machine.excute("hero_icon_create_cell", 0, {ship, 10, i})
		ListView_hero_icon:addChild(cell)
	end
	ListView_hero_icon:requestRefreshView()
	self.listview = ListView_hero_icon
	self.listview_pox = ListView_hero_icon:getInnerContainer():getPositionX()
end

function UnionTeamFightFormation:onUpdateHero()
    local root = self.roots[1]
    local Panel_line_set = ccui.Helper:seekWidgetByName(root, "Panel_line_set")
    for i=1,9 do
        local Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role_"..i)
        Panel_role:removeAllChildren(true)
        Panel_role:setVisible(false)
    end
    local position_str = dms.string(dms["formation_mould"],self.formation_type,formation_mould.position_six)
    position_str = zstring.split(position_str,",")
    for i,v in pairs(position_str) do
        local Panel_role = ccui.Helper:seekWidgetByName(root,"Panel_role_"..v)
        Panel_role:setVisible(true)
        if zstring.tonumber(self._choose_formation[i]) ~= 0 then
            if self.show_init == true then
                
            else
                if self._last_formetion[i] ~= self._choose_formation[i] then
                    local ArmatureNode_ro = Panel_line_set:getChildByName("ArmatureNode_ro_"..v)
                    local animation = ArmatureNode_ro:getAnimation()
                    animation:playWithIndex(0, 0, 0)
                end
            end
            self:createHero(Panel_role, self._choose_formation[i])
        end
    end
    self._last_formetion = {}
    for i,v in pairs(self._choose_formation) do
        table.insert(self._last_formetion, v)
    end

    self.show_init = false
	if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
		local Panel_line = ccui.Helper:seekWidgetByName(root,"Panel_line") 
		Panel_line:removeAllChildren(true)
		Panel_line:setBackGroundImage(string.format("images/ui/decorative/line_bg%d.png", self.formation_type))
    else
		for i = 1,5 do
			local Image_line_name = ccui.Helper:seekWidgetByName(root,"Image_line_name_"..i) 
			Image_line_name:setVisible(false)
			if self.formation_type == i then
				Image_line_name:setVisible(true)
			end
		end
    end

    local Text_line = ccui.Helper:seekWidgetByName(root,"Text_line")
    local position_explain = dms.string(dms["formation_mould"],self.formation_type,formation_mould.explain)
    Text_line:setString(position_explain)
    -- Text_line:setString(formation_type_string[self.formation_type])

    local Button_line_set_left = ccui.Helper:seekWidgetByName(root,"Button_line_set_left")
    local Button_line_set_right = ccui.Helper:seekWidgetByName(root,"Button_line_set_right")
    if self.formation_type == 5 then
        Button_line_set_right:setVisible(false)
    else
        Button_line_set_right:setVisible(true)
    end    
    if self.formation_type == 1 then
        Button_line_set_left:setVisible(false)
    else
        Button_line_set_left:setVisible(true)
    end                  
end

function UnionTeamFightFormation:createHero(Panel_role , ship_id)
    local ship = self._temp_ship[""..ship_id]
    local ship_mould_id = ship.ship_template_id
    app.load("client.battle.fight.FightEnum")
    local temp_bust_index = dms.int(dms["ship_mould"], ship_mould_id, ship_mould.bust_index)
    temp_bust_index = 10000 + temp_bust_index
    local armature = sp.spine_sprite(Panel_role, temp_bust_index, _spine_sprite_animation_names[_enum_spine_animation_frame_index.animation_standby_dir_4+1], true, nil, nil, cc.p(0.5, 0))
    armature:setPosition(cc.p(Panel_role:getContentSize().width/2, 0))    
end

function UnionTeamFightFormation:onUpdate(dt)
	if self.listview ~= nil then
		local size = self.listview:getContentSize()
		local posx = self.listview:getInnerContainer():getPositionX()
		if self.listview_pox == posx then
			return
		end
		self.listview_pox = posx
		local items = self.listview:getItems()
		if items[1] == nil then
			return
		end
		local itemSize = items[1]:getContentSize()
		for i, v in pairs(items) do
			local tempx = v:getPositionX() + posx
			if tempx + itemSize.width * 2 < 0 or tempx > size.width + itemSize.width * 2 then
				v:unload()
			else
				v:reload()
			end
		end
	end
end

function UnionTeamFightFormation:onEnterTransitionFinish()

end

function UnionTeamFightFormation:onInit( )
    local csbItem = csb.createNode(config_csb.formation.formation_setting)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)
	if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
		local Panel_line = ccui.Helper:seekWidgetByName(root,"Panel_line") 
		Panel_line:removeAllChildren(true)
		Panel_line:setBackGroundImage(string.format("images/ui/decorative/line_bg%d.png", self.formation_type))
    end
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4"), nil, 
    {
        terminal_name = "union_team_fight_formation_save", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_line_set_left"), nil, 
    {
        terminal_name = "union_team_fight_formation_turn_left", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)    

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_line_set_right"), nil, 
    {
        terminal_name = "union_team_fight_formation_turn_right", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    local Button_close = ccui.Helper:seekWidgetByName(root, "Button_close")
    Button_close:setVisible(true)
    fwin:addTouchEventListener(Button_close, nil, 
    {
        terminal_name = "union_team_fight_formation_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

	self:onUpdateDraw()	

    local run_action = cc.Sequence:create(cc.DelayTime:create(0),cc.CallFunc:create(self.onUpdateHero))
    self:runAction(run_action)
end

function UnionTeamFightFormation:init(formation_type)
    self.formation_type = tonumber(_ED.formetion[1]) or dms.int(dms["user_config"], 25, user_config.param)
    self:sortFormation()
	self:onInit()

    return self
end

function UnionTeamFightFormation:close()
    local root = self.roots[1]
    for i=1,9 do
        local Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role_"..i)
        Panel_role:removeAllChildren(true)
    end
    ccui.Helper:seekWidgetByName(root, "ListView_hero_icon"):removeAllItems()
end

function UnionTeamFightFormation:destroy()
    
end

function UnionTeamFightFormation:onExit()
	state_machine.remove("union_team_fight_formation_turn_left")	
	state_machine.remove("union_team_fight_formation_turn_right")
	state_machine.remove("union_team_fight_formation_save")
	state_machine.remove("union_team_fight_formation_update_hero")
	state_machine.remove("union_team_fight_formation_add_hero")
	state_machine.remove("union_team_fight_formation_remove_hero")
    state_machine.remove("union_team_fight_formation_get_formation_count")
end
