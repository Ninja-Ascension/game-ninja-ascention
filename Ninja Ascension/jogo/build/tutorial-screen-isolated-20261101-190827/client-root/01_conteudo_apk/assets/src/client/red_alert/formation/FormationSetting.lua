-----------------------------
--阵型设置
-----------------------------
FormationSetting = class("FormationSettingClass", Window)

local formation_setting_window_open_terminal = {
    _name = "formation_setting_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if missionIsOver() == true and funOpenDrawTip(67) == true then
            return
        end
        _ED.last_formetion = {}
        for i,v in pairs(_ED.formetion) do
            table.insert(_ED.last_formetion,v)
        end
        local win = FormationSetting:new()
        win:init()
        fwin:open(win, fwin._ui)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local formation_setting_window_close_terminal = {
    _name = "formation_setting_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local FormationWindow = fwin:find("FormationSettingClass")
        if FormationWindow ~= nil then
            fwin:close(FormationWindow)
        end 
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(formation_setting_window_open_terminal)
state_machine.add(formation_setting_window_close_terminal)
state_machine.init()

function FormationSetting:ctor()
    self.super:ctor()
    self.roots = {}

    --var
    self.listview = nil
    self.listview_pox = nil
    self.formation_type = 1
    self._base_formation = {}

    --第一次进入不播放光效
    self.show_init = true
	

    self._last_formetion = {}
    app.load("client.red_alert.cells.hero.hero_icon_cell")

    -- Initialize FormationSetting state machine.
    local function init_FormationSetting_terminal()
    
        --换上一个阵容（左翻页）
        local formation_setting_turn_left_terminal = {
            _name = "formation_setting_turn_left",
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
        local formation_setting_turn_right_terminal = {
            _name = "formation_setting_turn_right",
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
        local formation_setting_save_terminal = {
            _name = "formation_setting_save",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                --请求，带参数。阵型参数，对应所有武将

                local function responseFormationCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("formation_setting_window_close",0,"")
                    end
                end

                local str = ""      
                for i = 2 ,6 do
                    if zstring.tonumber(instance._base_formation[i]) == 0 then
                        instance._base_formation[i] = "0"
                    end
                    if i == 2 then
                        str = zstring.tonumber(instance._base_formation[i])
                    else
                        str = str .. "," .. zstring.tonumber(instance._base_formation[i])
                    end
                end

                local can_save = false
                for i = 2 ,6 do
                    if zstring.tonumber(instance._base_formation[i]) ~= 0 then
                        can_save = true
                    end
                end
                if can_save == false then
                    TipDlg.drawTextDailog(red_alert_all_str[188])
                    return
                end
                protocol_command.formation_change.param_list = str .."\r\n" .. self.formation_type.."\r\n".."2"
                NetworkManager:register(protocol_command.formation_change.code, nil, nil, nil, nil, responseFormationCallback, false, nil)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新所有武将  
        local formation_setting_update_hero_terminal = {
            _name = "formation_setting_update_hero",
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
        local formation_setting_add_hero_terminal = {
            _name = "formation_setting_add_hero",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local ship = params
                -- 模拟上阵
                instance:FormationSettingAddHero(ship)
                state_machine.excute("formation_setting_update_hero",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        --移除武将
        local formation_setting_remove_hero_terminal = {
            _name = "formation_setting_remove_hero",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local ship = params
                -- 模拟上阵
                instance:FormationSettingRemoveHero(ship)
                state_machine.excute("formation_setting_update_hero",0,"")

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }         
        state_machine.add(formation_setting_turn_left_terminal) 
        state_machine.add(formation_setting_turn_right_terminal)
        state_machine.add(formation_setting_save_terminal)
        state_machine.add(formation_setting_update_hero_terminal)
        state_machine.add(formation_setting_add_hero_terminal)
        state_machine.add(formation_setting_remove_hero_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_FormationSetting_terminal()
end

function FormationSetting:FormationSettingAddHero(ship )
    for i = 2 ,6 do
        if zstring.tonumber(self._base_formation[i]) == 0 then
            self._base_formation[i] = ship.ship_id
            break
        end
    end
    self:sortFormation()
    playEffect(formatMusicFile("effect", 10016))
end

function FormationSetting:sortFormation()
    local formation_temp = {}
    -- debug.print_r(_ED.formetion)
    for i=2,6 do
        if zstring.tonumber(self._base_formation[i]) ~= 0 then
            local ship = _ED.user_ship[""..self._base_formation[i]]
            local base_mould_priority = dms.int(dms["ship_mould"],ship.ship_template_id,ship_mould.base_mould_priority)
            local data = 
            {
                ship_id = self._base_formation[i],
                index = base_mould_priority;
            }
            table.insert(formation_temp,data)
        end
    end

    local function sortShip( a, b )
        return tonumber(a.index) < tonumber(b.index)
    end
    if #formation_temp == 0 then
        return
    end
    -- debug.print_r(formation_temp)
    table.sort(formation_temp,sortShip)
    
    for i = 2 ,6 do
        self._base_formation[i] = "0"
    end

    for i,v in pairs(formation_temp) do
        self._base_formation[i+1] = v.ship_id
    end
    -- debug.print_r(_ED.formetion)
end

function FormationSetting:FormationSettingRemoveHero(ship )
    for i = 2 ,6 do
        if self._base_formation[i] == ship.ship_id then
            self._base_formation[i] = 0
            table.remove(self._base_formation,i)
            table.insert(self._base_formation,"0")
        end
    end
    self:sortFormation()
    playEffect(formatMusicFile("effect", 10016))
end

function FormationSetting:getSortHero()
    local result = {}
    local formation_temp = {}
    -- debug.print_r(_ED.formetion)
    local position_str = dms.string(dms["formation_mould"],self.formation_type,formation_mould.position)
    position_str = zstring.split(position_str,",")
    for i,v in pairs(position_str) do
        if zstring.tonumber(self._base_formation[i+1]) ~= 0 then
            table.insert(formation_temp,_ED.user_ship[""..self._base_formation[i+1]])
        end
    end

    local formation_temp_change_index = {}
    for i,v in pairs(formation_temp) do
        table.insert(formation_temp_change_index,formation_temp[#formation_temp-i+1])
    end

    for i,v in pairs(_ED.user_ship) do
        table.insert(result,v)
    end
    local function sortShipFight( a, b )
        return tonumber(a.hero_fight) > tonumber(b.hero_fight)
    end
    table.sort(result, sortShipFight)

    local all_result = {}
    local in_formation = {}
    local in_raleship = {}
    local gold_ship = {} -- 6
    local red_ship = {}  -- 5
    local orange_ship = {} -- 4
    local purple_ship = {} -- 3
    local blue_ship = {} -- 2 
    local green_ship = {} -- 1
    local white_ship = {} -- 0
    for i,ship in pairs(result) do
        -- debug.print_r(ship)
        if zstring.tonumber(ship.formation_index) > 0 then
            -- table.insert(in_formation, ship)
        elseif zstring.tonumber(ship.little_partner_formation_index) > 0 then
        --     table.insert(in_raleship, ship)
        elseif zstring.tonumber(ship.ship_type) == 6 then
            table.insert(gold_ship, ship)
        elseif zstring.tonumber(ship.ship_type) == 5 then
            table.insert(red_ship, ship)
        elseif zstring.tonumber(ship.ship_type) == 4 then
            table.insert(orange_ship, ship)
        elseif zstring.tonumber(ship.ship_type) == 3 then
            table.insert(purple_ship, ship)
        elseif zstring.tonumber(ship.ship_type) == 2 then
            table.insert(blue_ship, ship)
        elseif zstring.tonumber(ship.ship_type) == 1 then
            table.insert(green_ship, ship)
        elseif zstring.tonumber(ship.ship_type) == 0 then
            table.insert(white_ship, ship)
        end
    end
    for i,v in pairs(gold_ship) do
       table.insert(all_result,v)
    end
    for i,v in pairs(red_ship) do
       table.insert(all_result,v)
    end
    for i,v in pairs(orange_ship) do
       table.insert(all_result,v)
    end
    for i,v in pairs(purple_ship) do
       table.insert(all_result,v)
    end
    for i,v in pairs(blue_ship) do
       table.insert(all_result,v)
    end
    for i,v in pairs(green_ship) do
        table.insert(all_result,v)
    end  
    for i,v in pairs(white_ship) do
       table.insert(all_result,v)
    end

    local the_hero_ship = {}
    for i ,v in pairs(formation_temp_change_index) do
        table.insert(the_hero_ship,v)
    end
    local insert_bool = true
    for i,v in pairs(all_result) do
        for j,k in pairs(the_hero_ship) do
            if k.ship_base_template_id == v.ship_base_template_id or tonumber(v.little_partner_formation_index) > 0 then
                insert_bool = false
            end
        end
        if insert_bool == true then
            table.insert(the_hero_ship,v)
        end
        insert_bool = true
    end
    return the_hero_ship
end

--切换阵型播放动画
function FormationSetting:playActions()
    local root = self.roots[1]
    local Panel_line_set = ccui.Helper:seekWidgetByName(root,"Panel_line_set")
    local position_str = dms.string(dms["formation_mould"],self.formation_type,formation_mould.position)
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
                    if zstring.tonumber(self._base_formation[i+1]) ~= 0 then
                        local ArmatureNode_ro = Panel_line_set:getChildByName("ArmatureNode_ro_"..v)
                        local animation = ArmatureNode_ro:getAnimation()
                        animation:playWithIndex(0, 0, 0)
                        -- self:createHero(Panel_role,_ED.formetion[i+1])
                        self:onUpdateHero()
                    end
                end
            end
        end
    end)

    Panel_change:addChild(animation)

end

function FormationSetting:onUpdateHeroIcon()
    local root = self.roots[1]
    local ListView_hero_icon = ccui.Helper:seekWidgetByName(root,"ListView_hero_icon")
    local index = 1
    for i,ship in pairs(self:getSortHero()) do
        if index > 7 then 
            local cell = state_machine.excute("hero_icon_create_cell",0,{ship,1,index})
            ListView_hero_icon:addChild(cell)
        end
        index = index + 1
    end
    ListView_hero_icon:requestRefreshView()
    self.listview = ListView_hero_icon
    self.listview_pox = ListView_hero_icon:getInnerContainer():getPositionX()
end

function FormationSetting:onUpdateDraw()
    local root = self.roots[1]
    local ListView_hero_icon = ccui.Helper:seekWidgetByName(root,"ListView_hero_icon")
    ListView_hero_icon:removeAllChildren(true)
	local index = 1
	for i,ship in pairs(self:getSortHero()) do
        if index <= 7 then 
            local cell = state_machine.excute("hero_icon_create_cell",0,{ship,1,index})
    		index = index + 1
		    ListView_hero_icon:addChild(cell)
        else
            break
        end
	end
    ListView_hero_icon:requestRefreshView()
    self.listview = ListView_hero_icon
    self.listview_pox = ListView_hero_icon:getInnerContainer():getPositionX()
	-- self:onUpdateHeroIcon()
    local run_action  = cc.Sequence:create(cc.DelayTime:create(0.5),cc.CallFunc:create(self.onUpdateHeroIcon))
    self:runAction(run_action)
end

function FormationSetting:onUpdateHero()
    local root = self.roots[1]
    local Panel_line_set = ccui.Helper:seekWidgetByName(root,"Panel_line_set")
    for i=1,9 do
        local Panel_role = ccui.Helper:seekWidgetByName(root,"Panel_role_"..i)
        Panel_role:removeAllChildren(true)
        Panel_role:setVisible(false)
    end
    local position_str = dms.string(dms["formation_mould"],self.formation_type,formation_mould.position)
    position_str = zstring.split(position_str,",")

    local formation = {}
    for i, v in pairs(self._base_formation) do
        table.insert(formation, v)
    end

    for i,v in pairs(position_str) do
        local Panel_role = ccui.Helper:seekWidgetByName(root,"Panel_role_"..v)
        Panel_role:setVisible(true)
        if zstring.tonumber(formation[i+1]) ~= 0 then
            if self.show_init == true then
                
            else
                if self._last_formetion[i+1] ~= formation[i+1] then
                    local ArmatureNode_ro = Panel_line_set:getChildByName("ArmatureNode_ro_"..v)
                    local animation = ArmatureNode_ro:getAnimation()
                    animation:playWithIndex(0, 0, 0)
                end
            end
            local function onUpdateHeroIcon()
                self:createHero(Panel_role,formation[i+1])
            end
			-- onUpdateHeroIcon()
            local run_action  = cc.Sequence:create(cc.DelayTime:create(0),cc.CallFunc:create(onUpdateHeroIcon))
            self:runAction(run_action)
        end
    end
    self._last_formetion = {}
    for i,v in pairs(self._base_formation) do
        table.insert(self._last_formetion,v)
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
    --Text_line:setString(formation_type_string[self.formation_type])

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

function FormationSetting:createHero(Panel_role , ship_id)
    local ship = _ED.user_ship[""..ship_id]
    local ship_mould_id = ship.ship_template_id
    app.load("client.battle.fight.FightEnum")
    local temp_bust_index = dms.int(dms["ship_mould"], ship_mould_id, ship_mould.bust_index)
    temp_bust_index = 10000 + temp_bust_index
    
    local armature = sp.spine_sprite(Panel_role, temp_bust_index, _spine_sprite_animation_names[_enum_spine_animation_frame_index.animation_standby_dir_4+1], true, nil, nil, cc.p(0.5, 0))
    armature:setPosition(cc.p(Panel_role:getContentSize().width/2, 0))    
end

function FormationSetting:onUpdate(dt)
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

function FormationSetting:onEnterTransitionFinish()
    -- 跑马灯
    if funOpenDrawTip(55,false) == false then  
        app.load("client.home.WarshipGirlPushInfo")
        state_machine.excute("warship_girl_push_info_open",0,{_datas={_openType=0}})
    end

    --跑马灯top
    if funOpenDrawTip(55,false) == false then  
        app.load("client.home.WarshipGirlPushInfoTop")
        state_machine.excute("warship_girl_push_info_top_open",0,{_datas={_openType=0}})
    end
end

function FormationSetting:onInit( )
    local csbItem = csb.createNode(config_csb.formation.formation_setting)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
		local Panel_line = ccui.Helper:seekWidgetByName(root,"Panel_line") 
		Panel_line:removeAllChildren(true)
		Panel_line:setBackGroundImage(string.format("images/ui/decorative/line_bg%d.png", self.formation_type))
    end
    --保存退出
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4"), nil, 
    {
        terminal_name = "formation_setting_save", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --上一个阵型
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_line_set_left"), nil, 
    {
        terminal_name = "formation_setting_turn_left", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)    
    --下一个阵型
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_line_set_right"), nil, 
    {
        terminal_name = "formation_setting_turn_right", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)   
	-- self:onUpdateDraw()	
	-- self:onUpdateHero()
	local run_action1  = cc.Sequence:create(cc.DelayTime:create(0),cc.CallFunc:create(self.onUpdateDraw))
    self:runAction(run_action1)
	
    local run_action  = cc.Sequence:create(cc.DelayTime:create(0.2),cc.CallFunc:create(self.onUpdateHero))
    self:runAction(run_action)
end

function FormationSetting:init(formation_type)
    for i,v in pairs(_ED.formetion) do
        table.insert(self._base_formation,v)
    end
    self.formation_type = tonumber(self._base_formation[1]) or dms.int(dms["user_config"],25,user_config.param)
    self:sortFormation()
    self:onInit()
end

function FormationSetting:close()
    local root = self.roots[1]
    for i=1,9 do
        local Panel_role = ccui.Helper:seekWidgetByName(root,"Panel_role_"..i)
        Panel_role:removeAllChildren(true)
    end
    self:stopAllActions()
end

function FormationSetting:destroy()
    for i = 2, 7 do
        local ship_id = zstring.tonumber(self._base_formation[i])
        if ship_id ~= 0 then
            local user_ship = _ED.user_ship[""..ship_id]
            local base_ship_mould_id = user_ship.ship_base_template_id
            
            local new_ship = true
            for j = 2 ,7 do
                if ship_id == zstring.tonumber(_ED.last_formetion[j]) then
                    new_ship = false
                end
            end
            
            if new_ship == true and cacher.getObject("formation_"..base_ship_mould_id) == nil then
                local temp_bust_index = dms.int(dms["ship_mould"], base_ship_mould_id, ship_mould.bust_index)
                -- temp_bust_index = 1005
                
                local jsonFile = string.format("sprite/spirte_%s.json", temp_bust_index)
                local atlasFile = string.format("sprite/spirte_%s.atlas", temp_bust_index)

                local animation = sp.spine(jsonFile, atlasFile, 1, 0, _spine_sprite_animation_names[_enum_spine_animation_frame_index.animation_standby_dir_4+1], true, nil)
                animation.__cname = "formation_"..base_ship_mould_id
                cacher.addObject(animation)
            end
        end
    end

    for i = 2, 7 do
        local ship_id = zstring.tonumber(_ED.last_formetion[i])
        if ship_id > 0 then
            local user_ship = _ED.user_ship[""..ship_id]
            local base_ship_mould_id = user_ship.ship_base_template_id
            local remove_ship = true
            for j = 2 ,7 do
                if ship_id == zstring.tonumber(self._base_formation[j]) then
                    remove_ship = false
                end
            end
            if remove_ship == true and cacher.getObject("formation_"..base_ship_mould_id) ~= nil then 
                cacher.removeObject("formation_"..base_ship_mould_id)
            end
        end

    end

    -- debug.print_r(cacher._ObjectPool)
end

function FormationSetting:onExit()
    state_machine.remove("formation_setting_turn_left") 
    state_machine.remove("formation_setting_turn_right")
    state_machine.remove("formation_setting_save")
    state_machine.remove("formation_setting_update_hero")
    state_machine.remove("formation_setting_add_hero")
    state_machine.remove("formation_setting_remove_hero")   
end
