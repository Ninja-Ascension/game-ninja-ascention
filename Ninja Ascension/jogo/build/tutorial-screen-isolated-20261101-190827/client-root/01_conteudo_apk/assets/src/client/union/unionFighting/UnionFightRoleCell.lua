UnionFightRoleCell = class("UnionFightRoleCellClass", Window)

function UnionFightRoleCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
    self.chooseCamp = 0
	self.roleInfo = nil
    self.mapIndex = 0
    self.formationIndex = 0

    local function init_union_fight_role_cell_terminal()
		 local union_fight_role_cell_touch_terminal = {
            _name = "union_fight_role_cell_touch",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local formationIndex = cell.formationIndex
                local mapIndex = cell.mapIndex
                local roleInfo = cell.roleInfo
                local chooseCamp = cell.chooseCamp
                if roleInfo == nil then
                    if chooseCamp == 0 and tonumber(_ED.union_fight_state) == 1 then
                        if tonumber(_ED.union.user_union_info.union_post) == 1 or 
                            tonumber(_ED.union.user_union_info.union_post) == 2 then
                            state_machine.excute("union_fight_choose_open", 0, {mapIndex, roleInfo, chooseCamp, formationIndex})
                        else
                            TipDlg.drawTextDailog(tipStringInfo_union_str[64])
                        end
                    end
                else
                    state_machine.excute("union_fight_role_info_open", 0, 
                        {chooseCamp, roleInfo, mapIndex, formationIndex})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(union_fight_role_cell_touch_terminal)
        state_machine.init()
    end
    
    init_union_fight_role_cell_terminal()
end

function UnionFightRoleCell:updateDraw()
    local root = self.roots[1]
    local Panel_youren = ccui.Helper:seekWidgetByName(root, "Panel_youren")
    local Panel_wuren = ccui.Helper:seekWidgetByName(root, "Panel_wuren")
    local Image_3 = ccui.Helper:seekWidgetByName(root, "Image_3")
    local Image_4 = ccui.Helper:seekWidgetByName(root, "Image_4")
    Panel_youren:setVisible(false)
    Panel_wuren:setVisible(false)
    Image_3:setVisible(false)
    Image_4:setVisible(false)
    local mapData = dms.element(dms["union_fight_campsite_mould"], self.mapIndex)
    local fight_formations = zstring.split(dms.atos(mapData, union_fight_campsite_mould.fight_formation), "|")
    local states = zstring.split(fight_formations[2], ",")
    local state = states[self.formationIndex]
    if self.roleInfo == nil then
        if tonumber(_ED.union_fight_state) == 1 then
            Panel_wuren:setVisible(true)
        end
        if tonumber(state) == 1 then
            Image_4:setVisible(true)
        else
            Image_3:setVisible(true)
        end
    else
        Panel_youren:setVisible(true)
        local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
        local Text_2 = ccui.Helper:seekWidgetByName(root, "Text_2")
        local Text_zhanli = ccui.Helper:seekWidgetByName(root, "Text_zhanli")
        local Image_jipo = ccui.Helper:seekWidgetByName(root, "Image_jipo")
        local Image_baolu = ccui.Helper:seekWidgetByName(root, "Image_baolu")
        local Panel_card_role = ccui.Helper:seekWidgetByName(root, "Panel_card_role")
        local Image_5_w = ccui.Helper:seekWidgetByName(root, "Image_5_w")
        local Image_6_z = ccui.Helper:seekWidgetByName(root, "Image_6_z")
        Image_5_w:setVisible(false)
        Image_6_z:setVisible(false)
        Image_jipo:setVisible(false)
        Image_baolu:setVisible(false)
        Text_name:setVisible(true)
        Text_2:setVisible(true)
        Text_zhanli:setVisible(true)
        Text_name:setString(self.roleInfo.userName)
        Text_zhanli:setString(""..self.roleInfo.userFighting)

        if tonumber(self.roleInfo.userId) == tonumber(_ED.user_info.user_id) then
            Image_5_w:setVisible(true)
        else
            Image_6_z:setVisible(true)
        end

        local shipData = dms.element(dms["ship_mould"], self.roleInfo.userHeadId)
        local icon = dms.atos(shipData, ship_mould.head_icon)
        local quality = dms.atos(shipData, ship_mould.ship_type) + 1
        Text_name:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))

        if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
            Panel_card_role:removeAllChildren(true)
            local roleShipId = dms.atos(shipData, ship_mould.bust_index)
            app.load("client.battle.fight.FightEnum")
            local ship_mould_pic_id = _user_pic_index[roleShipId]
            sp.spine_sprite(Panel_card_role, ship_mould_pic_id, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
        elseif __lua_project_id == __lua_project_warship_girl_a or
            __lua_project_id == __lua_project_warship_girl_b then
            local big_icon_path = string.format("images/face/card_head/card_head_%s.png", tonumber(icon) - 1000)
            Panel_card_role:setBackGroundImage(big_icon_path)
        elseif __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
            or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
            local big_icon_path = string.format("images/face/big_head/big_head_%s.png", tonumber(icon) - 1000)
            Panel_card_role:setBackGroundImage(big_icon_path)
        end
        if tonumber(self.roleInfo.userState) == 0 then
            Image_3:setVisible(true)
            if tonumber(state) == 1 then
                Image_baolu:setVisible(true)
                Image_3:setVisible(false)
                Image_4:setVisible(true)
            end
        elseif tonumber(self.roleInfo.userState) == 1 then
            Image_4:setVisible(true)
            -- Text_name:setVisible(false)
            Text_2:setVisible(false)
            Text_zhanli:setVisible(false)
        else
            Image_jipo:setVisible(true)
            if tonumber(state) == 1 then
                Image_baolu:setVisible(true)
                Image_3:setVisible(false)
                Image_4:setVisible(true)
            end
        end
    end
end

function UnionFightRoleCell:onEnterTransitionFinish()
    local root = cacher.createUIRef("legion/legion_pve_legion_k.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)
    self:setContentSize(root:getContentSize())

    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or 
        __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_xiangyin"), nil, 
        {
            terminal_name = "union_fight_role_cell_touch", 
            terminal_state = 0,
            isPressedActionEnabled = true,
            cell = self
        },
        nil, 0)
    end

    self:updateDraw(self.roleInfo)
end

function UnionFightRoleCell:init(roleInfo, formationIndex, mapIndex, chooseCamp)
    self.roleInfo = roleInfo
    self.formationIndex = formationIndex
    self.mapIndex = mapIndex
    self.chooseCamp = chooseCamp
	return self
end

function UnionFightRoleCell:onExit()
    state_machine.remove("union_fight_role_cell_touch")
end

function UnionFightRoleCell:createCell()
	local cell = UnionFightRoleCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
