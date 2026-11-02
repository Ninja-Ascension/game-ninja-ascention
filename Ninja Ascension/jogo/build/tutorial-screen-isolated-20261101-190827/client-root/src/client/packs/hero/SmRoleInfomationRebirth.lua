-----------------------------
-- 还原界面
-----------------------------
SmRoleInfomationRebirth = class("SmRoleInfomationRebirthClass", Window)

local sm_role_infomation_rebirth_window_open_terminal = {
	_name = "sm_role_infomation_rebirth_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("SmRoleInfomationRebirthClass") == nil then
			fwin:open(SmRoleInfomationRebirth:new():init(params), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local sm_role_infomation_rebirth_window_close_terminal = {
	_name = "sm_role_infomation_rebirth_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmRoleInfomationRebirthClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_role_infomation_rebirth_window_open_terminal)
state_machine.add(sm_role_infomation_rebirth_window_close_terminal)
state_machine.init()

function SmRoleInfomationRebirth:ctor()
	self.super:ctor()
	self.roots = {}

    self._choose_state = 0
    self._choose_ship = nil

    app.load("client.packs.hero.SmRoleInfomationRebirthReward")
    app.load("client.packs.hero.SmRoleInfomationRebirthHelp")
    app.load("client.packs.hero.SmRoleInfomationRebirthChoose")
    app.load("client.packs.hero.SmRoleInfomationRebirthPrompt")
    
    local function init_sm_role_infomation_rebirth_terminal()
        local sm_role_infomation_rebirth_success_update_terminal = {
            _name = "sm_role_infomation_rebirth_success_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params
                local equipIndex = -1
                if index == 1 then
                    index = 2
                elseif index == 2 then
                    index = -1
                elseif index == 3 then
                    index = 5
                elseif index == 4 then
                    index = 6
                elseif index == 5 then
                    index = 7
                    equipIndex = 1
                elseif index == 6 then
                    index = 7
                    equipIndex = 5
                elseif index == 7 then
                    index = 7
                    equipIndex = 6
                elseif index == 8 then
                    index = 9
                end    
                -- 1强化2进阶3升星4技能5斗魂6进化7装备升级8装备进阶9装备觉醒
                state_machine.excute("sm_role_infomation_rebirth_prompt_window_close", 0, nil)
                state_machine.excute("sm_role_infomation_rebirth_reward_window_close", 0, nil)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance._choose_state = 0
                    instance:updateHeroInfo()
                    instance:onUpdateDraw()

                    instance._choose_ship = _ED.user_ship[""..instance._choose_ship.ship_id]
                    -- 优化效率，分开刷新，避免一次刷太多，卡顿太严重
                    if index > 0 then
                        for i,v in pairs(_ED.user_ship) do
                            if index == 7 then
                                if equipIndex == 1 then
                                    setShipPushData(v.ship_id, index, 1)
                                    setShipPushData(v.ship_id, index, 2)
                                    setShipPushData(v.ship_id, index, 3)
                                    setShipPushData(v.ship_id, index, 4)
                                    setShipPushData(v.ship_id, 8, 1)
                                    setShipPushData(v.ship_id, 8, 2)
                                    setShipPushData(v.ship_id, 8, 3)
                                    setShipPushData(v.ship_id, 8, 4)
                                else
                                    setShipPushData(v.ship_id, 8, 3)
                                    setShipPushData(v.ship_id, 8, 4)
                                end
                            else
                                setShipPushData(v.ship_id, index, equipIndex)
                            end
                        end
                    end
                    if fwin:find("HeroDevelopClass") ~= nil then
                        -- state_machine.excute("sm_equipment_qianghua_update_ship", 0, instance._choose_ship)
                        -- state_machine.excute("sm_equipment_qianghua_update_ship_info", 0, nil)
                        -- state_machine.excute("sm_equipment_tab_up_product_update_draw", 0, nil)
                        state_machine.excute("hero_develop_page_strength_to_update_all_icon",0,instance._choose_ship)
                        state_machine.excute("hero_develop_page_strength_to_update_ship", 0, instance._choose_ship)
                    else
                        for i, v in pairs(_ED.user_formetion_status) do
                            if tonumber(v) == tonumber(instance._choose_ship.ship_id) then
                                state_machine.excute("formation_set_ship", 0, instance._choose_ship)
                                break
                            end
                        end
                        -- state_machine.excute("sm_equipment_qianghua_to_update_equip_icon",0,"")
                        state_machine.excute("hero_icon_listview_update_all_icon",0,instance._choose_ship)
                        -- state_machine.excute("hero_icon_listview_icon_push_updata",0,"hero_icon_listview_icon_push_updata.")

                    end
                    smFightingChange()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_role_infomation_rebirth_update_ship_terminal = {
            _name = "sm_role_infomation_rebirth_update_ship",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("sm_role_infomation_rebirth_choose_window_close", 0, nil)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance._choose_ship = params._datas._ship
                    instance:updateHeroInfo()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_role_infomation_rebirth_change_ship_terminal = {
            _name = "sm_role_infomation_rebirth_change_ship",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("sm_role_infomation_rebirth_choose_window_open", 0, {instance._choose_ship})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		local sm_role_infomation_rebirth_choose_ship_or_equip_terminal = {
            _name = "sm_role_infomation_rebirth_choose_ship_or_equip",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._choose_state == params._datas.index then
                    instance._choose_state = 0
                else
                    instance._choose_state = params._datas.index
                end
				instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_role_infomation_rebirth_choose_rebirth_terminal = {
            _name = "sm_role_infomation_rebirth_choose_rebirth",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("sm_role_infomation_rebirth_choose_rebirth")
                local index = params._datas.index
                if index == 1 then
                    local needQuality = dms.int(dms["ship_config"], 15, ship_config.param)
                    if tonumber(instance._choose_ship.Order) < needQuality then
                        TipDlg.drawTextDailog(_new_interface_text[251])
                        state_machine.unlock("sm_role_infomation_rebirth_choose_rebirth")
                        return
                    end
                    local needProps = zstring.split(dms.string(dms["ship_config"], 16, ship_config.param), ",")
                    local havePropCount = getPropAllCountByMouldId(needProps[2])
                    if zstring.tonumber(havePropCount) < tonumber(needProps[3]) then
                        TipDlg.drawTextDailog(_new_interface_text[258])
                        state_machine.unlock("sm_role_infomation_rebirth_choose_rebirth")
                        return
                    end
                elseif index == 2 then
                    local needProps = zstring.split(dms.string(dms["ship_config"], 19, ship_config.param), ",")
                    local havePropCount = getPropAllCountByMouldId(needProps[2])
                    if zstring.tonumber(havePropCount) < tonumber(needProps[3]) then
                        TipDlg.drawTextDailog(_new_interface_text[258])
                        state_machine.unlock("sm_role_infomation_rebirth_choose_rebirth")
                        return
                    end
                    local needSkillPoint = dms.int(dms["ship_config"], 18, ship_config.param)
                    local skillLevels = zstring.split(instance._choose_ship.skillLevel, ",")
                    local totalLevel = 0
                    for k,v in pairs(skillLevels) do
                        totalLevel = totalLevel + zstring.tonumber(v)
                    end
                    if totalLevel < needSkillPoint then
                        TipDlg.drawTextDailog(string.format(_new_interface_text[252], needSkillPoint))
                        state_machine.unlock("sm_role_infomation_rebirth_choose_rebirth")
                        return
                    end
                elseif index == 3 then
                    local needProps = zstring.split(dms.string(dms["ship_config"], 23, ship_config.param), ",")
                    local havePropCount = getPropAllCountByMouldId(needProps[2])
                    if zstring.tonumber(havePropCount) < tonumber(needProps[3]) then
                        TipDlg.drawTextDailog(_new_interface_text[258])
                        state_machine.unlock("sm_role_infomation_rebirth_choose_rebirth")
                        return
                    end
                    local faction_id = zstring.split(dms.string(dms["ship_mould"], instance._choose_ship.ship_template_id, ship_mould.faction_id),",")
                    local needSoulLevel = dms.int(dms["ship_config"], 22, ship_config.param)
                    local soul_data = zstring.split(instance._choose_ship.ship_fighting_spirit, "|")
                    debug.print_r(soul_data)
                    debug.print_r(faction_id)
                    local totalLevel = 0
                    for k,v in pairs(soul_data) do
                        if faction_id[k] ~= nil then
                            -- local unlock_condition = dms.int(dms["ship_soul_mould"], faction_id[k], ship_soul_mould.unlock_condition)
                            -- if unlock_condition <= tonumber(instance._choose_ship.Order) then
                                totalLevel = totalLevel + zstring.tonumber(zstring.split(v, ",")[1])
                            -- end
                        end
                    end
                    if totalLevel < needSoulLevel then
                        TipDlg.drawTextDailog(string.format(_new_interface_text[253], needSoulLevel))
                        state_machine.unlock("sm_role_infomation_rebirth_choose_rebirth")
                        return
                    end
                elseif index == 4 then
                    local needLevel = dms.int(dms["ship_config"], 27, ship_config.param)
                    if tonumber(instance._choose_ship.ship_grade) < needLevel then
                        TipDlg.drawTextDailog(string.format(_new_interface_text[254], needLevel))
                        state_machine.unlock("sm_role_infomation_rebirth_choose_rebirth")
                        return
                    end
                elseif index == 5 then
                    local needProps = zstring.split(dms.string(dms["equipment_config"], 9, equipment_config.param), ",")
                    local havePropCount = getPropAllCountByMouldId(needProps[2])
                    if zstring.tonumber(havePropCount) < tonumber(needProps[3]) then
                        TipDlg.drawTextDailog(_new_interface_text[258])
                        state_machine.unlock("sm_role_infomation_rebirth_choose_rebirth")
                        return
                    end
                    local needLevel = dms.int(dms["equipment_config"], 8, equipment_config.param)
                    local shipEquip = zstring.split(instance._choose_ship.equipInfo, "|")
                    local levels = zstring.split(shipEquip[1], ",")
                    local totalLevel = 0
                    for i=1,4 do
                        totalLevel = totalLevel + zstring.tonumber(levels[i])
                    end
                    if totalLevel < needLevel then
                        TipDlg.drawTextDailog(string.format(_new_interface_text[255], needLevel))
                        state_machine.unlock("sm_role_infomation_rebirth_choose_rebirth")
                        return
                    end
                elseif index == 6 then
                    local needLevel = dms.int(dms["equipment_config"], 18, equipment_config.param)
                    if tonumber(instance._choose_ship.ship_grade) < needLevel then
                        TipDlg.drawTextDailog(string.format(_new_interface_text[281], needLevel))
                        state_machine.unlock("sm_role_infomation_rebirth_choose_rebirth")
                        return
                    end
                    local shipEquip = zstring.split(instance._choose_ship.equipInfo, "|")
                    local levels = zstring.split(shipEquip[1], ",")
                    if zstring.tonumber(levels[5]) <= 1 then
                        TipDlg.drawTextDailog(_new_interface_text[256])
                        state_machine.unlock("sm_role_infomation_rebirth_choose_rebirth")
                        return
                    end
                elseif index == 7 then
                    local needLevel = dms.int(dms["equipment_config"], 18, equipment_config.param)
                    if tonumber(instance._choose_ship.ship_grade) < needLevel then
                        TipDlg.drawTextDailog(string.format(_new_interface_text[281], needLevel))
                        state_machine.unlock("sm_role_infomation_rebirth_choose_rebirth")
                        return
                    end
                    local shipEquip = zstring.split(instance._choose_ship.equipInfo, "|")
                    local levels = zstring.split(shipEquip[1], ",")
                    if zstring.tonumber(levels[6]) <= 1 then
                        TipDlg.drawTextDailog(_new_interface_text[256])
                        state_machine.unlock("sm_role_infomation_rebirth_choose_rebirth")
                        return
                    end
                elseif index == 8 then
                    local shipEquip = zstring.split(instance._choose_ship.equipInfo, "|")
                    local starInfos = zstring.split(shipEquip[4], ",")
                    local currentLevel = 0
                    for k,v in pairs(starInfos) do
                        currentLevel = currentLevel + zstring.tonumber(starInfos[k])
                    end
                    if currentLevel < 1 then
                        TipDlg.drawTextDailog(_new_interface_text[257])
                        state_machine.unlock("sm_role_infomation_rebirth_choose_rebirth")
                        return
                    end
                else
                    state_machine.unlock("sm_role_infomation_rebirth_choose_rebirth")
                    return
                end
                local ship = instance._choose_ship
                local state = instance._choose_state
                local function responseCallBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.unlock("sm_role_infomation_rebirth_choose_rebirth")
                        state_machine.excute("sm_role_infomation_rebirth_reward_window_open", 0, {ship, state, index})
                    end
                end
                if index <= 4 then
                    protocol_command.ship_rebirth_init.param_list = ship.ship_id.."\r\n"..(index - 1)
                    NetworkManager:register(protocol_command.ship_rebirth_init.code, nil, nil, nil, instance, responseCallBack, false, nil)
                else
                    protocol_command.equipment_rebirth_init.param_list = ship.ship_id.."\r\n"..(index - 5)
                    NetworkManager:register(protocol_command.equipment_rebirth_init.code, nil, nil, nil, instance, responseCallBack, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_role_infomation_rebirth_success_update_terminal)
        state_machine.add(sm_role_infomation_rebirth_update_ship_terminal)
        state_machine.add(sm_role_infomation_rebirth_change_ship_terminal)
        state_machine.add(sm_role_infomation_rebirth_choose_ship_or_equip_terminal)
        state_machine.add(sm_role_infomation_rebirth_choose_rebirth_terminal)
        state_machine.init()
    end
    init_sm_role_infomation_rebirth_terminal()
end

function SmRoleInfomationRebirth:onUpdateDraw()
    local root = self.roots[1]
    local Panel_smh = ccui.Helper:seekWidgetByName(root, "Panel_smh")
    local Panel_zb = ccui.Helper:seekWidgetByName(root, "Panel_zb")
    if self._choose_state == 0 then
        Panel_smh:setVisible(false)
        Panel_zb:setVisible(false)
    else
        if self._choose_state == 1 then
            Panel_smh:setVisible(true)
            Panel_zb:setVisible(false)
        else
            Panel_smh:setVisible(false)
            Panel_zb:setVisible(true)
        end
    end
end

function SmRoleInfomationRebirth:updateHeroInfo( ... )
    local root = self.roots[1]
    local Panel_head = ccui.Helper:seekWidgetByName(root, "Panel_head")
    local Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon")
    local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
    Panel_head:removeAllChildren(true)
    Panel_icon:removeBackGroundImage()
    Text_name:setString("")

    local evo_image = dms.string(dms["ship_mould"], self._choose_ship.ship_template_id, ship_mould.fitSkillTwo)
    local evo_info = zstring.split(evo_image, ",")
    --进化模板id
    local ship_evo = zstring.split(self._choose_ship.evolution_status, "|")
    -- local ship_evo = zstring.split(self._ship.evolution_status, "|")
    local evo_mould_id = smGetSkinEvoIdChange(self._choose_ship)
    -- local evo_mould_id = evo_info[dms.int(dms["ship_mould"], self._choose_ship.ship_template_id, ship_mould.captain_name)]
    local temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
    local camp_preference = dms.int(dms["ship_mould"], tonumber(self._choose_ship.ship_template_id), ship_mould.camp_preference)
    Panel_icon:setBackGroundImage(string.format("images/ui/icon/sm_type_bar_%d.png", camp_preference))

    local animation_name = ""
    if camp_preference == 1 then            --攻击
        animation_name = "type_1"
    elseif camp_preference == 2 then        --防御
        animation_name = "type_2"
    elseif camp_preference == 3 then        --技能
        animation_name = "type_3"
    end
    local jsonFile = "sprite/spirte_type_di.json"
    local atlasFile = "sprite/spirte_type_di.atlas"
    local animation2 = sp.spine(jsonFile, atlasFile, 1, 0, animation_name, true, nil)
    animation2:setPosition(cc.p(Panel_head:getContentSize().width/2,0))
    Panel_head:addChild(animation2)

    -- draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), Panel_head, nil, nil, cc.p(0.5, 0))
    app.load("client.battle.fight.FightEnum")
    local hero_animation = sp.spine_sprite(Panel_head, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
    hero_animation.animationNameList = spineAnimations
    sp.initArmature(hero_animation, true)

    local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
    local word_info = dms.element(dms["word_mould"], name_mould_id)
    local getPersonName = word_info[3]
    local quality = shipOrEquipSetColour(tonumber(self._choose_ship.Order))
    if getShipNameOrder(tonumber(self._choose_ship.Order)) > 0 then
        getPersonName = getPersonName.." +"..getShipNameOrder(tonumber(self._choose_ship.Order))
    end
    Text_name:setString(getPersonName)
    Text_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1], tipStringInfo_quality_color_Type[quality][2], tipStringInfo_quality_color_Type[quality][3]))
end

function SmRoleInfomationRebirth:init(params)
    self._choose_ship = params[1]
	self:onInit()
    return self
end

function SmRoleInfomationRebirth:onInit()
    local csbItem = csb.createNode("packs/HeroStorage/generals_rebirth.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_fanhui_lwj"), nil, 
    {
        terminal_name = "sm_role_infomation_rebirth_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_use"), nil, 
    {
        terminal_name = "sm_role_infomation_rebirth_choose_ship_or_equip", 
        terminal_state = 0, 
        touch_black = true,
        index = 1,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_buy"), nil, 
    {
        terminal_name = "sm_role_infomation_rebirth_choose_ship_or_equip", 
        terminal_state = 0, 
        touch_black = true,
        index = 2,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_choice"), nil, 
    {
        terminal_name = "sm_role_infomation_rebirth_change_ship",
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_help"), nil, 
    {
        terminal_name = "sm_role_infomation_rebirth_help_open",
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    local buttons = {
        ccui.Helper:seekWidgetByName(root,"Button_jshy"),
        ccui.Helper:seekWidgetByName(root,"Button_jnhy"),
        ccui.Helper:seekWidgetByName(root,"Button_dhhy"),
        ccui.Helper:seekWidgetByName(root,"Button_jyhy"),
        ccui.Helper:seekWidgetByName(root,"Button_zbpzhy"),
        ccui.Helper:seekWidgetByName(root,"Button_hzhy"),
        ccui.Helper:seekWidgetByName(root,"Button_zhhy"),
        ccui.Helper:seekWidgetByName(root,"Button_zbjxhy"),
    }
    for k,v in pairs(buttons) do
        fwin:addTouchEventListener(v, nil, 
        {
            terminal_name = "sm_role_infomation_rebirth_choose_rebirth", 
            terminal_state = 0,
            touch_black = true,
            index = k,
        }, nil, 3)
    end
    
    self:onUpdateDraw()
    self:updateHeroInfo()
end

function SmRoleInfomationRebirth:onEnterTransitionFinish()
end

function SmRoleInfomationRebirth:onExit()
    state_machine.remove("sm_role_infomation_rebirth_success_update")
    state_machine.remove("sm_role_infomation_rebirth_update_ship")
    state_machine.remove("sm_role_infomation_rebirth_change_ship")
    state_machine.remove("sm_role_infomation_rebirth_choose_ship_or_equip")
    state_machine.remove("sm_role_infomation_rebirth_choose_rebirth")
end
