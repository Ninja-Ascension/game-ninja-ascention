--------------------------------------------------------------------------------------------------------------
--  说明：英雄头像
--------------------------------------------------------------------------------------------------------------
HeroIconCell = class("HeroIconCellClass", Window)
HeroIconCell.__size = nil

--创建cell
local hero_icon_create_cell_terminal = {
    _name = "hero_icon_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local ship = params[1]
        local from_type = params[2]
        local index = params[3]
        local show_name = params[4]
        local cell = HeroIconCell:new()
        cell:init(ship, from_type , index ,show_name)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(hero_icon_create_cell_terminal)
state_machine.init()

function HeroIconCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.ship = nil
    -- 1 布阵 2 武将 3 装备 4 --其他无响应 --5兵器冢 -- 6其他玩家信息 -- 7 图鉴 
    -- 8 宝物装备 -- 9 工会组队战 --10 工会组队战布阵 -- 11 神兵 -- 12其他玩家神兵信息 
    -- 13兵符 -- 14传承左  -- 15传承右
    self.from_type = nil  
    self.is_information = nil
    --设置显示
    self.isSelecet = false
    --设置显示名字
    self.show_name = nil
    --推送红点
    self._push_notification = nil
    --宝石推送
    self._push_notification_gem = nil
    --禁用状态
    self._is_enabled = nil
	 -- Initialize hero_icon_cell state machine.
    local function init_hero_icon_cell_terminal()
		
        -- 点击响应
		local hero_icon_cell_click_head_terminal = {
            _name = "hero_icon_cell_click_head",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local ship = params._datas.cell.ship
                local from_type = params._datas.cell.from_type
                local is_information = params._datas.cell.is_information
                local function checkFormationFull()
                    local isfull = true
                    local formationWindow = fwin:find("FormationSettingClass")
                    if formationWindow ~= nil then
                        for i = 2 ,6 do
                            if zstring.tonumber(formationWindow._base_formation[i]) == 0 then
                                isfull = false
                            end
                        end
                    end
                    return isfull
                end
                if from_type == 1 then
                    if is_information == true then
                        state_machine.excute("formation_setting_remove_hero",0,ship)
                        params._datas.cell.is_information = false
                    else
                        if checkFormationFull() == true then
                            return
                        end
                        state_machine.excute("formation_setting_add_hero",0,ship)
                        params._datas.cell.is_information = true
                    end
                    local sound_index = mainShipSound(ship.ship_template_id)
                    playEffectOld(formatMusicFile("effect", sound_index))
                    params._datas.cell:setIsInformation()
                elseif from_type == 2 then
                    state_machine.excute("hero_main_change_ship",0,ship)
                    local sound_index = mainShipSound(ship.ship_template_id)
                    playEffectOld(formatMusicFile("effect", sound_index))
                elseif from_type == 3 then
                    -- print("=====装备==",ship.captain_name)
                    state_machine.excute("equipment_change_ship",0,ship)
                    local sound_index = mainShipSound(ship.ship_template_id)
                    playEffectOld(formatMusicFile("effect", sound_index))
                elseif from_type == 4 then 
                elseif from_type == 5 then 
                    state_machine.excute("weaponry_un_setselect",0,"")
                    params._datas.cell.isSelecet = true
                    state_machine.excute("hero_icon_cell_set_seleceted",0,params._datas.cell)
                    -- 这里的ship 是 npc信息
                    state_machine.excute("weaponry_updatedraw_right",0,{params._datas.cell.ship})
                elseif from_type == 6 then
                    state_machine.excute("other_players_hero_main_change_ship",0,ship)
                    state_machine.excute("other_players_equipment_change_ship",0,ship)
                    state_machine.excute("other_players_racecourse_ride_change_ship",0,ship)
                    local sound_index = mainShipSound(ship.ship_template_id)
                    playEffectOld(formatMusicFile("effect", sound_index))
                elseif from_type == 7 then
                    -- state_machine.excute("catalogue_storage_un_select",0,"")
                    -- params._datas.cell.isSelecet = true
                    -- state_machine.excute("hero_icon_cell_set_seleceted",0,params._datas.cell)
                    
                    state_machine.excute("catalogue_storage_choose_on_ship",0,ship)
                elseif from_type == 8 then
                    state_machine.excute("racecourse_ride_change_ship",0,ship)
                    local sound_index = mainShipSound(ship.ship_template_id)
                    playEffectOld(formatMusicFile("effect", sound_index))
                elseif from_type == 9 then
                    state_machine.excute("union_team_fight_create_choose_hero",0,ship)
                elseif from_type == 10 then
                    if is_information == true then
                        state_machine.excute("union_team_fight_formation_remove_hero",0,ship)
                        params._datas.cell.is_information = false
                    else
                        if state_machine.excute("union_team_fight_formation_get_formation_count",0,nil) == true then
                            return
                        end
                        state_machine.excute("union_team_fight_formation_add_hero",0,ship)
                        params._datas.cell.is_information = true
                    end
                    params._datas.cell:setIsInformation()
                elseif from_type == 11 then
                    state_machine.excute("god_weaponry_change_ship",0,ship)
                    local sound_index = mainShipSound(ship.ship_template_id)
                    playEffectOld(formatMusicFile("effect", sound_index))
                elseif from_type == 12 then    
                    state_machine.excute("other_players_god_weaponry_change_ship",0,ship)
                    local sound_index = mainShipSound(ship.ship_template_id)
                    playEffectOld(formatMusicFile("effect", sound_index))
                elseif from_type == 13 then
                    state_machine.excute("weapon_book_main_change_ship",0,ship)
                    local sound_index = mainShipSound(ship.ship_template_id)
                    playEffectOld(formatMusicFile("effect", sound_index))
                elseif from_type == 14 then
                    state_machine.excute("inherit_left_pack_choose_ship",0,ship)
                    -- local sound_index = mainShipSound(ship.ship_template_id)
                    -- playEffectOld(formatMusicFile("effect", sound_index))
                elseif from_type == 15 then
                    state_machine.excute("inherit_right_pack_choose_ship",0,ship)
                    -- local sound_index = mainShipSound(ship.ship_template_id)
                    -- playEffectOld(formatMusicFile("effect", sound_index))
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --选中
        local hero_icon_cell_set_seleceted_terminal = {
            _name = "hero_icon_cell_set_seleceted",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params
                cell:setSeclected()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --改变状态（禁用，启用）
        local hero_icon_cell_set_enabled_state_terminal = {
            _name = "hero_icon_cell_set_enabled_state",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params[1]
                local isEnabled = params[2]
                cell:setEnabledState(isEnabled)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(hero_icon_cell_click_head_terminal)
        state_machine.add(hero_icon_cell_set_seleceted_terminal)
        state_machine.add(hero_icon_cell_set_enabled_state_terminal)
        state_machine.init()
    end
    
    -- call func home_build_cell create state machine.
    init_hero_icon_cell_terminal()

end

--刷新界面
function HeroIconCell:updateDraw()
    local root = self.roots[1]
    local picIndex = dms.int(dms["ship_mould"], self.ship_mould_id, ship_mould.head_icon)       --头像图标
    local quality = dms.int(dms["ship_mould"], self.ship_mould_id, ship_mould.ship_type)        --角色颜色品质
    local name = dms.string(dms["ship_mould"], self.ship_mould_id, ship_mould.captain_name)     --主角名称

    local Panel_head_icon = ccui.Helper:seekWidgetByName(root, "Panel_head_icon")               --头像icon
    local Panel_quality_box = ccui.Helper:seekWidgetByName(root, "Panel_quality_box")           --头像背景
    local Text_role_name = ccui.Helper:seekWidgetByName(root,"Text_role_name")                  --角色名字
    local Image_name_bg = ccui.Helper:seekWidgetByName(root,"Image_name_bg")                    --名字背景
    local Image_lock = ccui.Helper:seekWidgetByName(root,"Image_lock")                          --锁
    local Panel_head_box = ccui.Helper:seekWidgetByName(root,"Panel_head_box")                  --头像层
    local Image_push = ccui.Helper:seekWidgetByName(root,"Image_push")                          --推送红点
    local Image_hook = ccui.Helper:seekWidgetByName(root,"Image_hook")
    local Image_fetter = ccui.Helper:seekWidgetByName(root,"Image_fetter")
    local Panel_types = ccui.Helper:seekWidgetByName(root, "Panel_types")
    
    Panel_head_box:setTouchEnabled(true)
    if Image_push ~= nil then
        self._push_notification = Image_push
        self._push_notification:setVisible(false)
    end
    local Panel_push = ccui.Helper:seekWidgetByName(root,"Panel_push")                          --宝石推送
    if Panel_push ~= nil then
        self._push_notification_gem = Panel_push
        self._push_notification_gem:setVisible(false)
    end
    if Image_hook ~= nil then
        Image_hook:setVisible(false)
    end
    local Image_head_light = ccui.Helper:seekWidgetByName(root,"Image_head_light")
    local Image_head_light_0 = ccui.Helper:seekWidgetByName(root,"Image_head_light_0")
    if Image_head_light ~= nil then
        Image_head_light:setVisible(false)
    end
    if Image_head_light_0 ~= nil then
        Image_head_light_0:setVisible(false)
    end
    if Panel_quality_box ~= nil then
        Panel_quality_box:removeBackGroundImage()
        Panel_quality_box:setBackGroundImage(string.format("images/ui/quality/hero_icon_quality_%d.png", quality))
    end
    Panel_head_box:setColor(cc.c3b(un_gray_color[1],un_gray_color[2],un_gray_color[3])) 
    Panel_head_icon:setColor(cc.c3b(un_gray_color[1],un_gray_color[2],un_gray_color[3])) 
    Image_lock:setVisible(false)
    Image_name_bg:setVisible(true)
    Image_fetter:setVisible(false)
    Panel_head_icon:removeBackGroundImage()
    Panel_types:removeBackGroundImage()
    Panel_head_icon:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
    local skillGrowUpLevel = ""
    if nil ~= self.ship and type(self.ship) == "table" and nil ~= self.ship.skill_grow_up_level then
        skillGrowUpLevel = "+" .. self.ship.skill_grow_up_level
    end
    Text_role_name:setString(name .. skillGrowUpLevel)
    Text_role_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
    local sign_msg = dms.int(dms["ship_mould"], self.ship_mould_id, ship_mould.sign_msg)
    if sign_msg > 0 then
        Panel_types:setBackGroundImage(string.format("images/ui/quality/types_%d.png", sign_msg))
    end

    Text_role_name:setVisible(true)
    Panel_types:setVisible(true)
    if self.show_name == true then
        Image_name_bg:setVisible(true)
    else
        Text_role_name:setString("")
        Image_name_bg:setVisible(false)
    end
    if self.from_type == 1 
        or self.from_type == 14
        or self.from_type == 15
        then
        Image_hook:setVisible(self.is_information)
        if self.is_information == true then
            Panel_head_icon:setColor(cc.c3b(gray_color[1],gray_color[2],gray_color[3])) 
        else
            Panel_head_icon:setColor(cc.c3b(un_gray_color[1],un_gray_color[2],un_gray_color[3])) 
        end
    elseif self.from_type == 2 
        or self.from_type == 3
        or self.from_type == 4
        or self.from_type == 6
        or self.from_type == 8
        or self.from_type == 11
        or self.from_type == 12
        or self.from_type == 13
        then
        local Image_head_light = ccui.Helper:seekWidgetByName(root,"Image_head_light")
        Image_head_light:setVisible(self.isSelecet)     
    elseif self.from_type == 5 then
        local Image_head_light = ccui.Helper:seekWidgetByName(root,"Image_head_light")
        Image_head_light:setVisible(self.isSelecet)
        local npc_id = self.ship.npc_id
        local attack_level_limit = dms.int(dms["npc"],npc_id,npc.attack_level_limit)
        if attack_level_limit > tonumber(_ED.user_info.user_grade) then
            Image_lock:setVisible(true)
            Panel_head_box:setColor(cc.c3b(gray_color[1],gray_color[2],gray_color[3])) 
        else
            Image_lock:setVisible(false)
            Panel_head_box:setColor(cc.c3b(un_gray_color[1],un_gray_color[2],un_gray_color[3])) 
        end

        if tonumber(_ED.npc_state[npc_id]) < 0 then
            Image_lock:setVisible(true)
            Panel_head_box:setColor(cc.c3b(gray_color[1],gray_color[2],gray_color[3])) 
        else
            Image_lock:setVisible(false)
            Panel_head_box:setColor(cc.c3b(un_gray_color[1],un_gray_color[2],un_gray_color[3])) 
        end
    elseif self.from_type == 9 
        or self.from_type == 10 then
        -- self:setEnabledState(self._is_enabled)
        -- self:setIsInformation()
        Image_hook:setVisible(self.is_information)
        if self.is_information == true or self._is_enabled == true then
            Panel_head_icon:setColor(cc.c3b(gray_color[1],gray_color[2],gray_color[3])) 
        else
            Panel_head_icon:setColor(cc.c3b(un_gray_color[1],un_gray_color[2],un_gray_color[3])) 
        end
        if self._is_enabled == true then
            ccui.Helper:seekWidgetByName(root, "Panel_head_box"):setTouchEnabled(false)
        else
            ccui.Helper:seekWidgetByName(root, "Panel_head_box"):setTouchEnabled(true)
        end
        if self.ship.isUnionPartner == true then
            Image_fetter:setVisible(true)
        end
    end

    local Panel_star = ccui.Helper:seekWidgetByName(root,"Panel_star")
    Panel_star:removeAllChildren(true)
    local stars,stars_level = getHeroStars(self.ship_mould_id)
    draw.addHeroStar(Panel_star,stars,stars_level)
end

--设置头像信息
function HeroIconCell:setIsInformation()
    local root = self.roots[1]    
    local Image_hook = ccui.Helper:seekWidgetByName(root,"Image_hook")
    local Panel_head_icon = ccui.Helper:seekWidgetByName(root, "Panel_head_icon")
    if Image_hook == nil then
        return
    end
    Image_hook:setVisible(self.is_information)
    if self.is_information == true or self._is_enabled == true then
        Panel_head_icon:setColor(cc.c3b(gray_color[1],gray_color[2],gray_color[3])) 
    else
        Panel_head_icon:setColor(cc.c3b(un_gray_color[1],un_gray_color[2],un_gray_color[3])) 
    end    
end

--设置显示
function HeroIconCell:setSeclected()
    local root = self.roots[1]    
    local Image_head_light = ccui.Helper:seekWidgetByName(root,"Image_head_light")
    local Image_head_light_0 = ccui.Helper:seekWidgetByName(root,"Image_head_light_0")
    if Image_head_light == nil then
        return
    end
    Image_head_light:setVisible(self.isSelecet)
    if Image_head_light_0 == nil then
        return
    end
    if self.from_type == 5 then
        Image_head_light_0:setVisible(self.isSelecet)
    elseif self.from_type == 14 or self.from_type == 15 then
        local Panel_head_icon = ccui.Helper:seekWidgetByName(root, "Panel_head_icon")
        if self.isSelecet == true then
            ccui.Helper:seekWidgetByName(root, "Image_hook"):setVisible(true)
            Panel_head_icon:setColor(cc.c3b(gray_color[1], gray_color[2], gray_color[3]))
        else
            ccui.Helper:seekWidgetByName(root, "Image_hook"):setVisible(false)
            Panel_head_icon:setColor(cc.c3b(un_gray_color[1], un_gray_color[2], un_gray_color[3]))
        end
    end
end

--设置禁用状态
function HeroIconCell:setEnabledState(isEnabled)
    self._is_enabled = isEnabled
    local root = self.roots[1]    
    local Image_head_light = ccui.Helper:seekWidgetByName(root, "Image_head_light")
    local Panel_head_icon = ccui.Helper:seekWidgetByName(root, "Panel_head_icon")
    if Image_head_light == nil then
        return
    end
    Image_head_light:setVisible(false)
    if isEnabled == true or self.is_information == true then
        if isEnabled == true then
            ccui.Helper:seekWidgetByName(root, "Panel_head_box"):setTouchEnabled(false)
        end
        if self.is_information == true then
            ccui.Helper:seekWidgetByName(root, "Panel_head_box"):setTouchEnabled(true)
        end
        Panel_head_icon:setColor(cc.c3b(gray_color[1], gray_color[2], gray_color[3]))
    else
        ccui.Helper:seekWidgetByName(root, "Panel_head_box"):setTouchEnabled(true)
        Panel_head_icon:setColor(cc.c3b(un_gray_color[1], un_gray_color[2], un_gray_color[3]))
    end
end

-- 是否有英雄天赋可铭刻
function HeroIconCell:checkShipNeedStarupPush(prop_mould_id , need_count ,need_silver,need_ship_numbers,ship)
    local now_have_prop = false
    for i,prop in pairs(_ED.user_prop) do
        if tonumber(prop.user_prop_template) == prop_mould_id then
            if tonumber(prop.prop_number) >= need_count and tonumber(_ED.user_info.user_silver) >= need_silver then
                now_have_prop = true
            else
                return false
            end
        end
    end

    if now_have_prop == false then
        return false
    end

    local ship_numbers = findTheSameBaseShipMouldBy(ship)
    if ship_numbers >= need_ship_numbers then
    else
        return false
    end
    return true
end

-- 是否有英雄星格可铭刻
function HeroIconCell:checkShipNeedPush(prop_mould_id , need_count , need_silver)
    for i,prop in pairs(_ED.user_prop) do
        if tonumber(prop.user_prop_template) == prop_mould_id then
            if tonumber(prop.prop_number) >= need_count and tonumber(_ED.user_info.user_silver) >= need_silver then
                return true
            end
        end
    end
    return false
end

--英雄推送
function HeroIconCell:getShipHeroIconAllTip()
    local star_id_tab = self.ship.stars_state
    local can_up_star = true
    for i,v in pairs(star_id_tab) do
        local star_id = v.star_id
        if zstring.tonumber(star_id) == -1 or zstring.tonumber(star_id) == 0 then
            can_up_star = false
        else
            local state = v.state
            local star_data = dms.element(dms["star_mould"],star_id)
            local need_prop1 = dms.atoi(star_data,star_mould.need_prop1)
            local need_prop1_count = dms.atoi(star_data,star_mould.need_prop1_count)
            local need_silver1 = dms.atoi(star_data,star_mould.need_silver1)
            if tonumber(state) ~= 1 then
                can_up_star = false
                -- 是否有英雄星格可铭刻
                if self:checkShipNeedPush(need_prop1,need_prop1_count,need_silver1) == true then
                    return true
                end
            end
        end
    end

    local required_material_id = dms.string(dms["ship_mould"],self.ship.ship_template_id,ship_mould.required_material_id)   --进阶需求索引
    local ship_grow_requirement_data = dms.element(dms["ship_grow_requirement"], required_material_id)
    local star_up_need_prop = dms.atoi(ship_grow_requirement_data,ship_grow_requirement.need_prop1)                 --需求的材料
    local star_up_need_count = dms.atoi(ship_grow_requirement_data,ship_grow_requirement.need_prop1_count)          --需求的材料数量
    local star_up_need_silver = dms.atoi(ship_grow_requirement_data,ship_grow_requirement.need_silver)              --需求的金币
    local need_same_card_count = dms.atoi(ship_grow_requirement_data,ship_grow_requirement.need_same_card_count)    --需求同ID武将数量
    local ship = self.ship
    if can_up_star == true and      -- 是否有英雄天赋可铭刻
        self:checkShipNeedStarupPush(star_up_need_prop,
                            star_up_need_count,
                            star_up_need_silver,
                            need_same_card_count,
                            ship) == true then  
        return true
    end
    return false
end

--装备推送
function HeroIconCell:getShipHaveEquipCanWear(ship)
    local table_panel_index = {0,1,2,3,9,10}
    for i, equip_type in pairs(table_panel_index) do
        local equipment_id = ship.equipment[i].user_equiment_id
        if zstring.tonumber(equipment_id) > 0 then
            for k,v in pairs(_ED.user_equiment) do
                --可更换更好的装备
                if tonumber(v.ship_id) == 0 and tonumber(v.rela_state) == 0 then 
                    local equipment = _ED.user_equiment[""..equipment_id]
                    if equipment ~= nil 
                        and zstring.tonumber(equipment.equipment_type) == zstring.tonumber(v.equipment_type) 
                        and zstring.tonumber(equipment.rank_level) < zstring.tonumber(v.rank_level) 
                        then
                        return true
                    end
                end
            end
        else  --可穿戴装备
            for j,equip in pairs(_ED.user_equiment) do
                if zstring.tonumber(equip.ship_id) == 0 and zstring.tonumber(equip.rela_state) == 0 and zstring.tonumber(equip.equipment_type) == equip_type then 
                    return true
                end
            end
        end
    end
    return false
end

--宝石推送
function HeroIconCell:getShipHaveGemCanWear(ship)
    local table_panel_index = {0,1,2,3,9,10}
    for i, equip_type in pairs(table_panel_index) do
        local equip_id = ship.equipment[i].user_equiment_id
        if zstring.tonumber(equip_id) > 0 then
            local equip = _ED.user_equiment[""..equip_id]
            local table_gem_type = {}
            if equip ~= nil then
                for n,v in pairs(equip.jewelrys) do
                    if tonumber(v) ~= 0 then
                        local gem = _ED.user_gems[""..v]
                        local gem_type = dms.int(dms["gems_mould"],gem.mould_id,gems_mould.gem_type)
                        table.insert(table_gem_type,gem_type)
                    end
                end
                for l,gem_id in pairs(equip.jewelrys) do
                    --宝石可镶嵌
                    if tonumber(gem_id) <= 0 then
                        local can_add_gems = dms.int(dms["equipment_mould"],equip.user_equiment_template,equipment_mould.equipment_gem_numbers)
                        if l <= can_add_gems then
                            for n,v in pairs(_ED.user_gems) do
                                local can_push = false
                                local have_type = false
                                if tonumber(v.equip_id) > 0 then
                                else
                                    local gem_type = dms.int(dms["gems_mould"],v.mould_id,gems_mould.gem_type)
                                    can_push = true
                                    for k,m in pairs(table_gem_type) do
                                        if gem_type == m then
                                            have_type = true
                                            break
                                        end
                                    end
                                end

                                if can_push == true and have_type == false then
                                    return true
                                end
                            end
                        end
                    else    --宝石可升级
                        local gem = _ED.user_gems[""..gem_id]
                        local getExp = 0
                        for n,v in pairs(_ED.user_gems) do
                            if tonumber(v.equip_id) > 0 then
                            else
                                local gem_type = dms.int(dms["gems_mould"],v.mould_id,gems_mould.gem_type)
                                if gem_type == gem.gem_type then
                                    getExp = getExp + v.give_exp
                                end
                            end
                        end
                        if gem.up_need_exp > 0 then 
                            if getExp >= gem.up_need_exp - gem.exp then
                                return true
                            end
                        end
                    end
                end
            end
        end
    end
    return false
end

function HeroIconCell:pushNotification()
    local ship = self.ship
    --英雄
    if self._push_notification == nil or self._push_notification_gem == nil then
        return
    end
    self._push_notification:setVisible(false)
    self._push_notification_gem:setVisible(false)
    if self.from_type == 2 then
        -- if self:getShipHeroIconAllTip() == true then
        if getheroIconAllTip(ship) == true then
            self._push_notification:setVisible(true)
        elseif getheroFettersTip(ship) == true then
            self._push_notification:setVisible(true)
        elseif getheroGradeUpTip(ship) == true then
            self._push_notification:setVisible(true)
        end
    --装备
    elseif self.from_type == 3 then
        if self:getShipHaveEquipCanWear(ship) == true then
            self._push_notification:setVisible(true)
            return
        end
        --宝石
        if self:getShipHaveGemCanWear(ship) == true then
            self._push_notification_gem:setVisible(true)
        end
    -- 珍兽
    elseif self.from_type == 8 then
        if getOneHorseTips(ship) == true then
            self._push_notification:setVisible(true)
        elseif getOneHorseTips(ship) == 1 then
            self._push_notification_gem:setVisible(true)
        end
    elseif self.from_type == 13 then
        -- TODO...
    end
end 

--推送
function HeroIconCell:onUpdate()
    if self.roots ~= nil and self.roots[1] ~= nil then
        local now_time = os.time()
        if now_time - zstring.tonumber(self._last_time) >= 1 then
            self:pushNotification()
            self._last_time = now_time
        end
    end
end

--初始化界面
function HeroIconCell:onInit() 
    -- 推送箭头动画资源加载
    for i, v in pairs(config_res.sprites_cached["push_arrows"]) do
        cc.SpriteFrameCache:getInstance():addSpriteFrames(v)
    end
    local root = cacher.createUIRef(config_csb.cells.hero.hero_icon_cell,"root")
    table.insert(self.roots, root)
    self:addChild(root)
    local Panel_head_box = ccui.Helper:seekWidgetByName(root, "Panel_head_box")
    Panel_head_box:setSwallowTouches(false)
    
    if HeroIconCell.__size == nil then
        local __size = Panel_head_box:getContentSize()
        HeroIconCell.__size = __size
    end

    fwin:addTouchEventListener(Panel_head_box, nil, 
    {
        terminal_name = "hero_icon_cell_click_head", 
        terminal_state = 0, 
        cell = self, 
        -- touch_scale = true,
        -- touch_scale_xy = 0.95, 
    }, nil, 3)

	self:updateDraw()
end

function HeroIconCell:onEnterTransitionFinish()

end

--重新加载
function HeroIconCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    if self._push_notification ~= nil and self._push_notification_gem ~= nil then
        self._push_notification:setVisible(false)
        self._push_notification_gem:setVisible(false)
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

--卸载
function HeroIconCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    if self._push_notification ~= nil and self._push_notification_gem ~= nil then
        self._push_notification:setVisible(false)
        self._push_notification_gem:setVisible(false)
    end
    cacher.freeRef(config_csb.cells.hero.hero_icon_cell, root)
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)    
    self.roots = {}
end

function HeroIconCell:getIsInFormation( ship )
    for i = 2 ,7 do
        if _ED.formetion[i] == ship.ship_id then
            return true
        end
    end
    return false
end

--初始化
function HeroIconCell:init(ship,from_type,index,show_name)
    self.ship = ship
    if type(ship) == "table" then
        self.ship_mould_id = self.ship.ship_template_id or self.ship.ship_mould_id
    else
        self.ship_mould_id = ship
    end
    self.from_type = from_type
    if show_name == nil then
       self.show_name = true
    else
       self.show_name = show_name
    end
    if type(ship) ~= "number" then
        self.is_information = self:getIsInFormation(ship)
    end
    if from_type == 10 or from_type == 9 then
        self.is_information = false
    end
    if index ~= nil and index < 7 then
	   self:onInit()
    end
    self:setContentSize(HeroIconCell.__size)
end

--退出
function HeroIconCell:onExit()
    if self._push_notification ~= nil and self._push_notification_gem ~= nil then
        self._push_notification:setVisible(false)
        self._push_notification_gem:setVisible(false)
    end
    self:unregisterOnNoteUpdate(self)
    cacher.freeRef(config_csb.cells.hero.hero_icon_cell, self.roots[1])
end