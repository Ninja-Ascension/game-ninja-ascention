-----------------------------
--装备界面
-----------------------------
OtherPlayersEquipment = class("OtherPlayersEquipmentClass", Window)

local other_players_equipment_window_open_terminal = {
    _name = "other_players_equipment_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        -- if funOpenDrawTip(68) == true then
        --     return
        -- end      
        local _Window = fwin:find("OtherPlayersEquipmentClass")
        if nil == _Window then
            local user_ships = params[1]
            local show_type = params[2]
            -- fwin:open(OtherPlayersEquipment:new():init(user_ships,show_type), fwin._view)
            fwin:open(OtherPlayersEquipment:new():init(user_ships,show_type), fwin._ui)
        end

        state_machine.excute("home_select_action_window_close",0,"")
        state_machine.excute("user_info_window_hide",0,"")  
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local other_players_equipment_window_close_terminal = {
    _name = "other_players_equipment_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("OtherPlayersEquipmentClass"))
        state_machine.excute("user_info_window_show",0,"")
        if fwin:find("PacksClass") ~= nil then
            state_machine.excute("packs_window_open",0,"") 
        end
        
        state_machine.excute("national_city_hide_game_resource_info", 0, nil)
        -- clear cacher
        cacher.clearWindowCacher()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(other_players_equipment_window_open_terminal)
state_machine.add(other_players_equipment_window_close_terminal)
state_machine.init()

function OtherPlayersEquipment:ctor()
    self.super:ctor()
    self.roots = {}

    self.table_panel_index = nil
    self.user_ships = nil
    self.show_type = 1 --1 自己 2 查看别的玩家
    self.ship = nil
    self.select_equip_icon = 1
    self.change_type = 1
	self.listview = nil
	self.listview_pox = nil

    app.load("client.red_alert.cells.hero.hero_icon_cell")
    app.load("client.red_alert.packs.equipstorage.EquipmentWear")
    app.load("client.red_alert.packs.equipstorage.EquipmentGemInput")
    app.load("client.red_alert.packs.equipstorage.EquipmentGemFuse")
    app.load("client.red_alert.other_players_information.other_players_equipstorage.other_players_equipment_gem_input_cell")
    app.load("client.red_alert.packs.equipstorage.EquipmentGemAttribute")
    app.load("client.red_alert.packs.equipstorage.EquipmentAwaken")
    app.load("client.red_alert.hero.HeroAttributes")

    -- Initialize init_other_players_equipment_terminal state machine.
    local function init_other_players_equipment_terminal()
	
		--显示界面
		local other_players_equipment_window_show_terminal = {
            _name = "other_players_equipment_window_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		--隐藏界面
		local other_players_equipment_window_hide_terminal = {
            _name = "other_players_equipment_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 改变英雄
        local other_players_equipment_change_ship_terminal = {
            _name = "other_players_equipment_change_ship",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local ship = params
                instance.ship = ship
                instance:setHeroCellSelected(ship)
                instance:setHeroIcon()
                instance:setEquipMent()
                instance:setEquipInfo()
                instance:setEquipStreng()
                state_machine.excute("other_players_equipment_change_page_type",0,{
                    _datas = 
                    {
                        terminal_name = "other_players_equipment_change_page_type", 
                        terminal_state = 0, 
                        change_type = 1,
                        touch_scale = true,
                        touch_scale_xy = 0.95, 
                    }
                    })
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        --切换至装备信息面板 1 or 强化面板  2
        local other_players_equipment_change_page_type_terminal = {
            _name = "other_players_equipment_change_page_type",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local change_type = params._datas.change_type
                instance.change_type = change_type
                instance:changeEquipStrengOrInfo()
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --切换已穿戴装备类型
        local other_players_equipment_change_equip_type_terminal = {
            _name = "other_players_equipment_change_equip_type",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.select_equip_icon = params._datas.index
                instance:setIconSelected()
                instance:changeEquipStrengOrInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --切换已穿戴装备类型 打开穿戴界面
        local other_players_equipment_change_equip_type_and_open_wear_terminal = {
            _name = "other_players_equipment_change_equip_type_and_open_wear",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance.select_equip_icon = params._datas.index
                instance.change_type = 1
                instance:setIconSelected()
                instance:changeEquipStrengOrInfo()
                local equip_type = instance.table_panel_index[instance.select_equip_icon]
                state_machine.excute("other_players_equipment_wear_window_open",0,{equip_type,instance.ship})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

		state_machine.add(other_players_equipment_window_show_terminal)	
		state_machine.add(other_players_equipment_window_hide_terminal)
        state_machine.add(other_players_equipment_change_ship_terminal)
        state_machine.add(other_players_equipment_change_page_type_terminal)
        state_machine.add(other_players_equipment_change_equip_type_terminal)
        state_machine.add(other_players_equipment_change_equip_type_and_open_wear_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_other_players_equipment_terminal()
end

function OtherPlayersEquipment:playOneStrengthActions(old_pro,equip_id)
    local root = self.roots[1]
    local Panel_effice = ccui.Helper:seekWidgetByName(root,"Panel_effice")
    Panel_effice:removeAllChildren(true)
    local function ActionCallback( armatureBack )
        armatureBack:removeFromParent(true)
        self:calAddPro(old_pro,equip_id)
    end
    local jsonPath = "images/ui/effice/effice_equi_strengthen_one/effice_equi_strengthen_one.json"
    local atlasPath = "images/ui/effice/effice_equi_strengthen_one/effice_equi_strengthen_one.atlas"
    local animation = sp.spine(jsonPath, atlasPath, 1, 0, "animation_event", true, nil)
    animation:setPosition(cc.p(Panel_effice:getContentSize().width/2,Panel_effice:getContentSize().height/2))
    sp.initArmature(animation, false)
    animation._invoke = ActionCallback
    animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    Panel_effice:addChild(animation)
end

function OtherPlayersEquipment:playTenStrengthActions(old_pro,equip_id)
    local root = self.roots[1]
    local Panel_effice = ccui.Helper:seekWidgetByName(root,"Panel_effice")
    Panel_effice:removeAllChildren(true)
    local function ActionCallback( armatureBack )
        armatureBack:removeFromParent(true)
        self:calAddPro(old_pro,equip_id)
    end
    local jsonPath = "images/ui/effice/effice_equi_strengthen_ten/effice_equi_strengthen_ten.json"
    local atlasPath = "images/ui/effice/effice_equi_strengthen_ten/effice_equi_strengthen_ten.atlas"
    local animation = sp.spine(jsonPath, atlasPath, 1, 0, "animation_event", true, nil)
    animation:setPosition(cc.p(Panel_effice:getContentSize().width/2,Panel_effice:getContentSize().height/2))
    sp.initArmature(animation, false)
    animation._invoke = ActionCallback
    animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    Panel_effice:addChild(animation)
end

function OtherPlayersEquipment:calAddPro(old_pro,equip_id)
    local new_pro = _ED.other_user_equiment[""..equip_id].user_equiment_ability
    local old_table = zstring.split(old_pro,",")
    local new_table = zstring.split(new_pro,",")
    local add_type = tonumber(old_table[1]) + 1
    local add_number = tonumber(new_table[2]) - tonumber(old_table[2])
    local text_table = {
        attribute[add_type].."+"..add_number
    }

    state_machine.excute("add_number_window_open",0,{15,text_table})
end

function OtherPlayersEquipment:onHide()
    self:setVisible(false)
end

function OtherPlayersEquipment:onShow()
    self:setVisible(true)
end

function OtherPlayersEquipment:onUpdateDrawSelectIcon()
    local root = self.roots[1]
    for i,v in pairs(self.table_panel_index) do
        if i == self.select_equip_icon then
             local Panel_equipment_props = ccui.Helper:seekWidgetByName(root,"Panel_equipment_props_"..v)
             for j,cell in pairs(Panel_equipment_props:getChildren()) do
                 state_machine.excute("all_resource_update_draw",0,cell)
             end
        end
    end
    
end

function OtherPlayersEquipment:setIconSelected()
    local root = self.roots[1]
    
    for i,v in pairs(self.table_panel_index) do
        local Image_equipment_select = ccui.Helper:seekWidgetByName(root,"Image_equipment_select_"..v)
        Image_equipment_select:setVisible(false)
        if i == self.select_equip_icon then
            Image_equipment_select:setVisible(true)
        end
    end
end

function OtherPlayersEquipment:DrawGems()
    local root = self.roots[1]
    local Panel_equipment_gem = ccui.Helper:seekWidgetByName(root,"Panel_equipment_gem")
    Panel_equipment_gem:removeAllChildren(true)
    local width = Panel_equipment_gem:getContentSize().width
    local height = Panel_equipment_gem:getContentSize().height
    if zstring.tonumber(self.ship.equipment[self.select_equip_icon].user_equiment_id) == 0 then
        return
    end

    local equip_id = self.ship.equipment[self.select_equip_icon].user_equiment_id
    local equip = _ED.other_user_equiment[""..equip_id]
    -- debug.print_r(equip)
    local can_add_gems = dms.int(dms["equipment_mould"],equip.user_equiment_template,equipment_mould.equipment_gem_numbers)
    -- print("========",can_add_gems)
    for i = 1 , 6 do
        local Panel_gem_icon = ccui.Helper:seekWidgetByName(root,"Panel_gem_icon_"..i)
        Panel_gem_icon:removeAllChildren(true)      
    end

    for i = 1,can_add_gems do
        local gem_id = equip.jewelrys[i]
        local Panel_gem_icon = ccui.Helper:seekWidgetByName(root,"Panel_gem_icon_"..i)
        local cell = state_machine.excute("other_players_equipment_gem_input_create_cell",0,{i,gem_id,equip})
        Panel_gem_icon:addChild(cell)
    end
end

function OtherPlayersEquipment:changeEquipStrengOrInfo()
    local root = self.roots[1]
    local Panel_equipment_right = ccui.Helper:seekWidgetByName(root,"Panel_equipment_right")
    local Panel_equipment_infor = ccui.Helper:seekWidgetByName(root,"Panel_equipment_infor")
    local Panel_equipment_strengthen = ccui.Helper:seekWidgetByName(root,"Panel_equipment_strengthen")
    local Button_equipment = ccui.Helper:seekWidgetByName(root,"Button_equipment")
    local Button_equipment_strengthen = ccui.Helper:seekWidgetByName(root,"Button_equipment_strengthen")
    Button_equipment_strengthen:setVisible(false)
    local Panel_equipment_big_icon_1 = ccui.Helper:seekWidgetByName(root,"Panel_equipment_big_icon_1")
    local Image_equip_bg = ccui.Helper:seekWidgetByName(root,"Image_equip_bg")
    Image_equip_bg:setVisible(true)
    if zstring.tonumber(self.ship.equipment[self.select_equip_icon].user_equiment_id) == 0 and self.change_type == 2 then
        TipDlg.drawTextDailog(red_alert_all_str[35])
        return
    end
    if zstring.tonumber(self.ship.equipment[self.select_equip_icon].user_equiment_id) == 0 then
        Panel_equipment_right:setVisible(false)
        Button_equipment:setTouchEnabled(false)
        Button_equipment:setHighlighted(true) 
        return
    end

    self:DrawGems()
    Panel_equipment_right:setVisible(true)
    if self.change_type == 1 then
        Panel_equipment_infor:setVisible(true)
        Panel_equipment_strengthen:setVisible(false)

        Button_equipment:setTouchEnabled(false)
        Button_equipment:setHighlighted(true) 
        Button_equipment_strengthen:setTouchEnabled(true)
        Button_equipment_strengthen:setHighlighted(false) 
        Image_equip_bg:setVisible(true)
    elseif self.change_type == 2 then
        Panel_equipment_infor:setVisible(false)
        Panel_equipment_strengthen:setVisible(true)

        Button_equipment_strengthen:setTouchEnabled(false)
        Button_equipment_strengthen:setHighlighted(true)         
        Button_equipment:setTouchEnabled(true)
        Button_equipment:setHighlighted(false)
        Image_equip_bg:setVisible(false)
    end

    local equip_id = self.ship.equipment[self.select_equip_icon].user_equiment_id
    local equip = _ED.other_user_equiment[""..equip_id]
    local Text_equipment_fighting = ccui.Helper:seekWidgetByName(root,"Text_equipment_fighting") -- 战力
    local Text_equipment_grade = ccui.Helper:seekWidgetByName(root,"Text_equipment_grade")
    local Panel_equipment_big_icon = ccui.Helper:seekWidgetByName(root,"Panel_equipment_big_icon")
    local Text_equipment_name = ccui.Helper:seekWidgetByName(root,"Text_equipment_name")
    local Text_equipment_strengthen_lv = ccui.Helper:seekWidgetByName(root,"Text_equipment_strengthen_lv")
    local Text_equipment_name_1 = ccui.Helper:seekWidgetByName(root,"Text_equipment_name_1")
    local quality = dms.int(dms["equipment_mould"],equip.user_equiment_template,equipment_mould.grow_level)
    local all_icon = dms.int(dms["equipment_mould"],equip.user_equiment_template,equipment_mould.All_icon)
    local equip_name = dms.string(dms["equipment_mould"],equip.user_equiment_template,equipment_mould.equipment_name)
    local init_pow_number = dms.string(dms["equipment_mould"],equip.user_equiment_template,equipment_mould.initial_value)
    local suit_id = dms.int(dms["equipment_mould"],equip.user_equiment_template,equipment_mould.suit_id)
    init_pow_number = zstring.split(init_pow_number,",")
    init_pow_number = tonumber(init_pow_number[2])
    -- debug.print_r(equip)

    Panel_equipment_big_icon:removeBackGroundImage()
    Panel_equipment_big_icon:setBackGroundImage("images/ui/big_props/big_props_".. all_icon .. ".png")
    Panel_equipment_big_icon_1:removeBackGroundImage()
    Panel_equipment_big_icon_1:setBackGroundImage("images/ui/big_props/big_props_".. all_icon .. ".png")
    Text_equipment_name:setString(equip_name)
    Text_equipment_name_1:setString(equip_name)
    Text_equipment_name_1:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
    Text_equipment_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
    local growup_value_table = zstring.split(equip.growup_value,"|")
    local now_grade = tonumber(equip.user_equiment_grade)

    local equip_grow_type = 0 -- 成长类型
    local grou_up_number = 0
    for i,v in pairs(growup_value_table) do
        local equipment_streng_data = zstring.split(v,",")
        local min_level = tonumber(equipment_streng_data[1])
        local max_level = tonumber(equipment_streng_data[2])
        if now_grade+1 >= min_level and now_grade+1 <= max_level then
            equip_grow_type = tonumber(equipment_streng_data[3])
            grou_up_number = math.floor(tonumber(equipment_streng_data[4]))
        end
    end

    -- local every_grade_add_number = tonumber(growup_value_table[2])
    local pow_table = zstring.split(equip.user_equiment_ability,",")
    local now_pow_number = tonumber(pow_table[2])
    local add_str = attribute[tonumber(equip_grow_type)+1]
    
    local add_pow_number = now_pow_number - init_pow_number
    
    Text_equipment_fighting:setString(equip.equip_fight)
    Text_equipment_fighting:setColor(cc.c3b(color_Type[5][1],color_Type[5][2],color_Type[5][3]))

    Text_equipment_grade:setString(quality)
    Text_equipment_strengthen_lv:setString((now_grade-1).."/".._ED.user_info.user_grade)

    local Text_equipment_11 = ccui.Helper:seekWidgetByName(root,"Text_equipment_11")
    local Text_equipment_12 = ccui.Helper:seekWidgetByName(root,"Text_equipment_12")
    local Text_equipment_13 = ccui.Helper:seekWidgetByName(root,"Text_equipment_13")
    local Text_equipment_14 = ccui.Helper:seekWidgetByName(root,"Text_equipment_14")

    Text_equipment_11:setVisible(true)
    Text_equipment_12:setVisible(true)
    Text_equipment_13:setVisible(true)
    Text_equipment_14:setVisible(true)

    Text_equipment_11:setString(red_alert_all_str[94])
    Text_equipment_12:setString(red_alert_all_str[19]..add_str)
    Text_equipment_13:setString(red_alert_all_str[95])
    Text_equipment_14:setString(red_alert_all_str[20]..add_str)
    local Text_equipment_basic_attack = ccui.Helper:seekWidgetByName(root,"Text_equipment_basic_attack")
    local Text_equipment_streng_attack = ccui.Helper:seekWidgetByName(root,"Text_equipment_streng_attack")
    local Text_equipment_before_lv = ccui.Helper:seekWidgetByName(root,"Text_equipment_before_lv")
    local Text_equipment_after_lv = ccui.Helper:seekWidgetByName(root,"Text_equipment_after_lv")

    Text_equipment_basic_attack:setVisible(true)
    Text_equipment_streng_attack:setVisible(true)
    Text_equipment_before_lv:setVisible(true)
    Text_equipment_after_lv:setVisible(true)

    Text_equipment_basic_attack:setString(init_pow_number)
    Text_equipment_streng_attack:setString(add_pow_number)
    Text_equipment_before_lv:setString(now_grade-1)
    Text_equipment_after_lv:setString(now_grade)

    local Text_equipment_before_attack = ccui.Helper:seekWidgetByName(root,"Text_equipment_before_attack")
    Text_equipment_before_attack:setString("+"..add_pow_number)
    local Text_equipment_after_attack = ccui.Helper:seekWidgetByName(root,"Text_equipment_after_attack")
    Text_equipment_after_attack:setString("+"..add_pow_number+grou_up_number)

    local Text_equipment_23 = ccui.Helper:seekWidgetByName(root,"Text_equipment_23")
    Text_equipment_23:setString(add_str)
    local Text_equipment_27 = ccui.Helper:seekWidgetByName(root,"Text_equipment_27")
    Text_equipment_27:setString(add_str)

    local need_silver = dms.int(dms["equipment_level_requirement"], now_grade, equipment_level_requirement.silver_amount)
    
    --不同装备套装对应强化系数（套装ID,计算参数|...）
    -- 不同装备部位对应强化系数（装备部位,计算参数|...)
    local equip_suit_id_table = dms.string(dms["equipment_config"],1,equipment_config.param)
    equip_suit_id_table = zstring.split(equip_suit_id_table,"|")
    -- debug.print_r(equip_suit_id_table)
    local equip_type_table = dms.string(dms["equipment_config"],2,equipment_config.param)
    equip_type_table = zstring.split(equip_type_table,"|")
    -- debug.print_r(equip_type_table)
    for i,v in pairs(equip_suit_id_table) do
        local temp_data = zstring.split(v,",")
        local suit_id_temp = tonumber(temp_data[1])
        if suit_id == suit_id_temp then
            local tempx = tonumber(temp_data[2]) -- 计算系数1 
            need_silver = need_silver *tempx
        end
    end

    for i,v in pairs(equip_type_table) do
        local temp_data = zstring.split(v,",")
        local equip_type = tonumber(temp_data[1])
        if tonumber(equip.equipment_type) == equip_type then
            local tempx = tonumber(temp_data[2]) -- 计算系数2
            need_silver = need_silver *tempx
        end
    end

    local Text_equipment_consume = ccui.Helper:seekWidgetByName(root,"Text_equipment_consume")
    Text_equipment_consume:setString(math.floor(need_silver))

    local awaken_equipment_id = dms.int(dms["equipment_mould"],equip.user_equiment_template,equipment_mould.awaken_equipment_id)
    local additive_attribute = dms.string(dms["equipment_mould"],equip.user_equiment_template,equipment_mould.additive_attribute)

    if additive_attribute ~= "-1" then
        additive_attribute = zstring.split(additive_attribute,",")
        local add_type = tonumber(additive_attribute[1])
        local add_number = tonumber(additive_attribute[2])
        Text_equipment_11:setString(red_alert_all_str[19]..add_str)
        Text_equipment_13:setString(red_alert_all_str[20]..add_str)
        Text_equipment_12:setString(attribute[add_type+1])
        Text_equipment_14:setVisible(false)

        Text_equipment_grade:setString(init_pow_number)
        Text_equipment_strengthen_lv:setString(add_pow_number)
        Text_equipment_basic_attack:setString(add_number)
        Text_equipment_streng_attack:setVisible(false)
    end
end

function OtherPlayersEquipment:setHeroCellSelected(ship)
    for i ,v in pairs(self.listview:getItems()) do 
        if v.ship == ship then
            v.isSelecet = true
            state_machine.excute("hero_icon_cell_set_seleceted",0,v)
        else
            if v.isSelecet == true then
                v.isSelecet = false
                state_machine.excute("hero_icon_cell_set_seleceted",0,v)
            end
        end
    end
end

function OtherPlayersEquipment:onUpdateDraw()
    local root = self.roots[1]
    local ListView_equipment_icon = ccui.Helper:seekWidgetByName(root,"ListView_equipment_icon")
    ListView_equipment_icon:removeAllItems()
    for i,ship in pairs(self.user_ships) do
        local cell = state_machine.excute("hero_icon_create_cell",0,{ship,6,i})
        ListView_equipment_icon:addChild(cell)
    end
    ListView_equipment_icon:requestRefreshView()
    self.listview = ListView_equipment_icon
    self.listview_pox = ListView_equipment_icon:getInnerContainer():getPositionX()    
    self:setHeroCellSelected(self.ship)
end

function OtherPlayersEquipment:onUpdate(dt)
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

function OtherPlayersEquipment:onEnterTransitionFinish()

end

function OtherPlayersEquipment:setHeroIcon( ... )
    local root = self.roots[1]
    local Panel_equipment_hero = ccui.Helper:seekWidgetByName(root,"Panel_equipment_hero")
    Panel_equipment_hero:removeAllChildren(true)
    local ship = self.ship
    local ship_mould_id = ship.ship_template_id
    app.load("client.battle.fight.FightEnum")
    local temp_bust_index = dms.int(dms["ship_mould"], ship_mould_id, ship_mould.bust_index)
    temp_bust_index = 10000 + temp_bust_index
    local armature = sp.spine_sprite(Panel_equipment_hero, temp_bust_index, _spine_sprite_animation_names[_enum_spine_animation_frame_index.animation_standby_dir_10+1], true, nil, nil, cc.p(0.5, 0))
    armature:setPosition(cc.p(Panel_equipment_hero:getContentSize().width/2, 0))    

    local Text_equ_role_name = ccui.Helper:seekWidgetByName(root,"Text_equ_role_name")
    local quality = ship.ship_type
    Text_equ_role_name:setString(ship.captain_name)
    Text_equ_role_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
end

function OtherPlayersEquipment:setEquipMent( ... )
    local root = self.roots[1]
    -- debug.print_r(self.ship)
    -- debug.print_r(_ED.other_user_equiment)
    for i, equip_type in pairs(self.table_panel_index) do
        local Panel_equipment_props = ccui.Helper:seekWidgetByName(root,"Panel_equipment_props_"..equip_type)
        local Panel_equipment_icon = ccui.Helper:seekWidgetByName(root,"Panel_equipment_icon_"..equip_type)
        local Panel_wearable = ccui.Helper:seekWidgetByName(root,"Panel_wearable_"..equip_type)
        Panel_equipment_props:removeAllChildren(true)
        Panel_wearable:setVisible(false)
        -- debug.print_r(self.ship.equipment)
        if zstring.tonumber(self.ship.equipment[i].user_equiment_id) ~= 0 then     
            local equip = _ED.other_user_equiment[""..self.ship.equipment[i].user_equiment_id]
            local prop_data = {
                item_value = 1,
                prop_type = 7,
                prop_item = equip.user_equiment_template
            }
			local function onUpdateEquipmentIcon()
                local cell = state_machine.excute("all_resource_create_cell",0,{5,prop_data,equip,8,0})  
				Panel_equipment_props:addChild(cell)
            end
			if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
				local run_action  = cc.Sequence:create(cc.DelayTime:create(0.2),cc.CallFunc:create(onUpdateEquipmentIcon))
				self:runAction(run_action)
			else
				onUpdateEquipmentIcon()
			end

            local function buttonTouchEvent(sender, evenType)
                local __spoint = sender:getTouchBeganPosition()
                if ccui.TouchEventType.began == evenType then
                    local function openOtherWindow( ... )
                        if self.open_window == false then
                            state_machine.excute("equipment_information_window_open",0,{
                                5,prop_data,equip,8,0,true,true,cc.p(__spoint.x,__spoint.y),1
                                })
                            self.open_window = true
                        else
                            state_machine.excute("equipment_information_window_close", 0, 0)
                        end
                    end 
                    self.open_window = false        
                    local action = cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create(openOtherWindow))  
                    self:stopAllActions()
                    self:runAction(action)    
                elseif ccui.TouchEventType.moved == evenType then

                elseif ccui.TouchEventType.canceled == evenType then
                    self:stopAllActions()
                    state_machine.excute("equipment_information_window_close", 0, 0)
                elseif ccui.TouchEventType.ended == evenType then
                    self:stopAllActions()
                    state_machine.excute("equipment_information_window_close", 0, 0)
                    if self.open_window == true then
                        return
                    end
                    state_machine.excute("other_players_equipment_change_equip_type",0,{_datas = {index = i,}})
                end
            end

            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_equipment_icon_"..equip_type), buttonTouchEvent, 
            {
                -- terminal_name = "other_players_equipment_change_equip_type", 
                terminal_state = 0, 
                index = i,
            }, nil, 0)
        else
            
            local actions = cc.RepeatForever:create(cc.Sequence:create(cc.ScaleTo:create(0.5,1.05),cc.ScaleTo:create(0.5,1)))
            
            if self:getHaveEquipCanWear(equip_type) == true then
                Panel_wearable:setVisible(false)
                fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_equipment_icon_"..equip_type), nil, 
                {
                    terminal_name = "other_players_equipment_change_equip_type_and_open_wear", 
                    terminal_state = 0, 
                    index = i,
                }, nil, 0)                  
            end
        end  
    end
end

function OtherPlayersEquipment:getHaveEquipCanWear(equip_type)
    for i,equip in pairs(_ED.other_user_equiment) do
        -- print("==============",tonumber(equip.ship_id)  , tonumber(equip.equipment_type) , get_type(equip_type))
        -- local _equip_type = dms.int(dms["equipment_mould"],equip.user_equiment_template,equipment_mould.equipment_type)
        if tonumber(equip.ship_id) == 0 and tonumber(equip.rela_state) == 0 and tonumber(equip.equipment_type) == equip_type then 
            return true
        end
    end
    return false
end

function OtherPlayersEquipment:setEquipInfo()
    local root = self.roots[1]
end

function OtherPlayersEquipment:setEquipStreng()
     local root = self.roots[1]
end

function OtherPlayersEquipment:onInit( )
    local csbItem = csb.createNode(config_csb.packs.equipstorage.equipment)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    --卸
    local Button_equipment_unload = ccui.Helper:seekWidgetByName(root,"Button_equipment_unload")
    Button_equipment_unload:setVisible(false)
    --换
    local Button_equipment_change = ccui.Helper:seekWidgetByName(root,"Button_equipment_change")
    Button_equipment_change:setVisible(false)
    --觉醒
    local Button_red_equipment = ccui.Helper:seekWidgetByName(root,"Button_red_equipment")
    Button_red_equipment:setVisible(false)
    -- 装备兽魂
    local Button_go_racecourse = ccui.Helper:seekWidgetByName(root,"Button_go_racecourse")
    Button_go_racecourse:setVisible(false)
    -- 洗炼信息按钮
    local Button_equipment_clear = ccui.Helper:seekWidgetByName(root,"Button_equipment_clear")
    Button_equipment_clear:setVisible(false)
    -- 装备回炉
    local Button_equip_back = ccui.Helper:seekWidgetByName(root,"Button_equip_back")
    Button_equip_back:setVisible(false)
    
    --阵营背景
    local Panel_camp_bg = ccui.Helper:seekWidgetByName(root,"Panel_camp_bg")
    Panel_camp_bg:setBackGroundImage("images/ui/bg/shared_bg_".._ED.user_info.user_force..".png")
    
    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_equipment_back"), nil, 
    {
        terminal_name = "other_players_equipment_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --装备信息
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_equipment"), nil, 
    {
        terminal_name = "other_players_equipment_change_page_type", 
        terminal_state = 0, 
        change_type = 1,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 查看属性
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_attriute"), nil, 
    {
        terminal_name = "hero_attributes_window_open", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0) 

	if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
    	local function changePageTypeUpdate()
			state_machine.excute("other_players_equipment_change_page_type",0,{
			_datas = 
			{
				terminal_name = "other_players_equipment_change_page_type", 
				terminal_state = 0, 
				change_type = 1,
				touch_scale = true,
				touch_scale_xy = 0.95, 
			}
			})
		end	
		local run_action1  = cc.Sequence:create(cc.DelayTime:create(0.2),cc.CallFunc:create(self.onUpdateDraw))
		self:runAction(run_action1)
		local run_action11  = cc.Sequence:create(cc.DelayTime:create(0.2),cc.CallFunc:create(self.setHeroIcon))
		self:runAction(run_action11)
		local run_action2  = cc.Sequence:create(cc.DelayTime:create(0.3),cc.CallFunc:create(self.setEquipMent))
		self:runAction(run_action2)
		local run_action3  = cc.Sequence:create(cc.DelayTime:create(0.4),cc.CallFunc:create(self.setEquipInfo))
		self:runAction(run_action3)	
		local run_action4  = cc.Sequence:create(cc.DelayTime:create(0.5),cc.CallFunc:create(self.setEquipStreng))
		self:runAction(run_action4)
		local run_action5  = cc.Sequence:create(cc.DelayTime:create(0.6),cc.CallFunc:create(self.setIconSelected))
		self:runAction(run_action5)
		local run_action6  = cc.Sequence:create(cc.DelayTime:create(0.7),cc.CallFunc:create(changePageTypeUpdate))
    	self:runAction(run_action6)
    else
		self:onUpdateDraw()	
		self:setHeroIcon()
		self:setEquipMent()
		self:setEquipInfo()
		self:setEquipStreng()
		self:setIconSelected()
		state_machine.excute("other_players_equipment_change_page_type",0,{
			_datas = 
			{
				terminal_name = "other_players_equipment_change_page_type", 
				terminal_state = 0, 
				change_type = 1,
				touch_scale = true,
				touch_scale_xy = 0.95, 
			}
			})
    end
end

function OtherPlayersEquipment:getSortForFight()
    local result = {}
    for i,v in pairs(_ED.other_user_ship) do

        if tonumber(v.little_partner_formation_index) <= 0 then
            table.insert(result,v)
        end
    end
    return result
end

function OtherPlayersEquipment:init(user_ships,show_type)
    self.user_ships = user_ships or self:getSortForFight()
    self.show_type = show_type or 1
    self.ship = self.user_ships[1]    
    self.table_panel_index = {0,1,2,3,9,10}
    self.select_equip_icon = 1
	self:onInit()
    return self
end

function OtherPlayersEquipment:onExit()
    state_machine.remove("other_players_equipment_window_show")   
    state_machine.remove("other_players_equipment_window_hide")
    state_machine.remove("other_players_equipment_change_ship")
    state_machine.remove("other_players_equipment_change_page_type")
    state_machine.remove("other_players_equipment_change_equip_type")
    state_machine.remove("other_players_equipment_change_equip_type_and_open_wear")
end
