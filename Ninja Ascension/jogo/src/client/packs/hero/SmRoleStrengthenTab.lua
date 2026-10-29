-- ----------------------------------------------------------------------------------------------------
-- 说明：角色强化界面
-------------------------------------------------------------------------------------------------------
SmRoleStrengthenTab = class("SmRoleStrengthenTabClass", Window)

local sm_role_strengthen_tab_open_terminal = {
    _name = "sm_role_strengthen_tab_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmRoleStrengthenTabClass")
        if nil == _homeWindow then
            local panel = SmRoleStrengthenTab:new():init(params)
            fwin:open(panel)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_role_strengthen_tab_close_terminal = {
    _name = "sm_role_strengthen_tab_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmRoleStrengthenTabClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmRoleStrengthenTabClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_role_strengthen_tab_open_terminal)
state_machine.add(sm_role_strengthen_tab_close_terminal)
state_machine.init()
    
function SmRoleStrengthenTab:ctor()
    self.super:ctor()
    self.roots = {}
    self.ship_id = 0

    local function init_sm_role_strengthen_tab_terminal()
        -- 显示界面
        local sm_role_strengthen_tab_display_terminal = {
            _name = "sm_role_strengthen_tab_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmRoleStrengthenTabWindow = fwin:find("SmRoleStrengthenTabClass")
                if SmRoleStrengthenTabWindow ~= nil then
                    SmRoleStrengthenTabWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_role_strengthen_tab_hide_terminal = {
            _name = "sm_role_strengthen_tab_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmRoleStrengthenTabWindow = fwin:find("SmRoleStrengthenTabClass")
                if SmRoleStrengthenTabWindow ~= nil then
                    SmRoleStrengthenTabWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 打开升品
        local sm_role_strengthen_tab_open_up_product_terminal = {
            _name = "sm_role_strengthen_tab_open_up_product",
            _init = function (terminal) 
                app.load("client.packs.hero.SmRoleStrengthenTabUpProduct")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local Panel_strengthen_tab = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_strengthen_tab")
                Panel_strengthen_tab:removeAllChildren(true)
                state_machine.excute("sm_role_strengthen_tab_up_product_open",0,{Panel_strengthen_tab,instance.ship_id})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 打开升级
        local sm_role_strengthen_tab_open_up_grade_terminal = {
            _name = "sm_role_strengthen_tab_open_up_grade",
            _init = function (terminal) 
                app.load("client.packs.hero.SmRoleStrengthenTabUpgrade")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local Panel_strengthen_tab = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_strengthen_tab")
                Panel_strengthen_tab:removeAllChildren(true)
                state_machine.excute("sm_role_strengthen_tab_up_grade_open",0,{Panel_strengthen_tab,instance.ship_id})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 打开升星
        local sm_role_strengthen_tab_open_rising_star_terminal = {
            _name = "sm_role_strengthen_tab_open_rising_star",
            _init = function (terminal) 
                app.load("client.packs.hero.SmRoleStrengthenTabRisingStar")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local Panel_strengthen_tab = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_strengthen_tab")
                Panel_strengthen_tab:removeAllChildren(true)
                state_machine.excute("sm_role_strengthen_tab_rising_star_open",0,{Panel_strengthen_tab,instance.ship_id})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 打开技能
        local sm_role_strengthen_tab_open_rising_skill_terminal = {
            _name = "sm_role_strengthen_tab_open_rising_skill",
            _init = function (terminal) 
                app.load("client.packs.hero.SmRoleStrengthenTabSkill")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local Panel_strengthen_tab = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_strengthen_tab")
                Panel_strengthen_tab:removeAllChildren(true)
                state_machine.excute("sm_role_strengthen_tab_skill_open",0,{Panel_strengthen_tab,instance.ship_id})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 打开斗魂
        local sm_role_strengthen_tab_open_rising_fighting_spirit_terminal = {
            _name = "sm_role_strengthen_tab_open_rising_fighting_spirit",
            _init = function (terminal) 
                app.load("client.packs.hero.SmRoleStrengthenTabFightingSpirit")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local Panel_strengthen_tab = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_strengthen_tab")
                Panel_strengthen_tab:removeAllChildren(true)
                state_machine.excute("sm_role_strengthen_tab_fighting_spirit_open",0,{Panel_strengthen_tab,instance.ship_id})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 打开装备强化
        local sm_role_strengthen_tab_open_equip_up_terminal = {
            _name = "sm_role_strengthen_tab_open_equip_up",
            _init = function (terminal) 
                app.load("client.packs.equipment.SmEquipmentTabUpProduct")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local Panel_strengthen_tab = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_strengthen_tab")
                Panel_strengthen_tab:removeAllChildren(true)
                state_machine.excute("sm_equipment_tab_up_product_open",0,{Panel_strengthen_tab,instance.ship_id})
                state_machine.excute("sm_equipment_tab_up_product_change_ship",0,params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 打开装备觉醒
        local sm_role_strengthen_tab_open_equip_awakening_terminal = {
            _name = "sm_role_strengthen_tab_open_equip_awakening",
            _init = function (terminal) 
                app.load("client.packs.equipment.SmEquipmentTabAwakening")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local Panel_strengthen_tab = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_strengthen_tab")
                Panel_strengthen_tab:removeAllChildren(true)
                state_machine.excute("sm_equipment_tab_awakening_open",0,{Panel_strengthen_tab,instance.ship_id})
                state_machine.excute("sm_equipment_tab_awakening_change_ship",0,params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 打开装备淬炼
        local sm_role_strengthen_tab_open_equip_harden_terminal = {
            _name = "sm_role_strengthen_tab_open_equip_harden",
            _init = function (terminal) 
                app.load("client.packs.EquipStorage.SmEquipmentQunenchingHandle")
                app.load("client.packs.EquipStorage.SmEquipmentQianghuaTab3Window1")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local Panel_strengthen_tab = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_strengthen_tab")
                Panel_strengthen_tab:removeAllChildren(true)
                state_machine.excute("sm_equipment_qianghua_tab3_window1_window_open",0,{Panel_strengthen_tab,instance.ship_id})
                state_machine.excute("sm_equipment_qianghua_tab3_window1_change_ship",0,params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 打开战魂
        local sm_role_strengthen_tab_open_fight_spirit_terminal = {
            _name = "sm_role_strengthen_tab_open_fight_spirit",
            _init = function (terminal) 
                app.load("client.packs.hero.SmRoleStrengthenTabFightSpirit")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local Panel_strengthen_tab = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_strengthen_tab")
                Panel_strengthen_tab:removeAllChildren(true)
                state_machine.excute("sm_role_strengthen_tab_fight_spirit_open",0,{Panel_strengthen_tab,instance.ship_id,params.types})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新
        local sm_role_strengthen_tab_update_ship_info_terminal = {
            _name = "sm_role_strengthen_tab_update_ship_info",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.ship_id = params[1]
                if fwin:find("SmRoleStrengthenTabUpProductClass") ~= nil then
                    state_machine.excute("sm_role_strengthen_tab_up_product_change_ship",0,instance.ship_id)
                end
                if fwin:find("SmRoleStrengthenTabUpgradeClass") ~= nil then
                    state_machine.excute("sm_role_strengthen_tab_up_grade_change_ship",0,instance.ship_id)
                end
                if fwin:find("SmRoleStrengthenTabRisingStarClass") ~= nil then
                    state_machine.excute("sm_role_strengthen_tab_rising_star_change_ship",0,instance.ship_id)
                end
                if fwin:find("SmRoleStrengthenTabFightSpiritClass") ~= nil then
                    state_machine.excute("sm_role_strengthen_tab_fight_spirit_change_ship",0,instance.ship_id)
                end
                instance:onUpdateDraw()
                local m_type = tonumber(params[2])
                if m_type ~= nil then
                    if m_type == 1 then
                        state_machine.excute("sm_role_strengthen_tab_up_product_update_draw",0,"")
                    elseif m_type == 2 then
                        state_machine.excute("sm_role_strengthen_tab_up_grade_update_draw",0,"")
                    elseif m_type == 3 then
                        state_machine.excute("sm_role_strengthen_tab_rising_star_update_draw",0,"")
                    elseif m_type == 10 then
                        state_machine.excute("sm_role_strengthen_tab_fight_spirit_update_draw",0,"")
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新Loading
        local sm_role_strengthen_tab_update_Loading_terminal = {
            _name = "sm_role_strengthen_tab_update_Loading",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
                    instance:UpdateShowLoading(params[1],params[2],params[3])
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_role_strengthen_tab_up_exp_loading_terminal = {
            _name = "sm_role_strengthen_tab_up_exp_loading",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
                    --进度条
                    local LoadingBar_strengthen_ = ccui.Helper:seekWidgetByName(instance.roots[1], "LoadingBar_strengthen_")
                    --没数据暂时写0
                    LoadingBar_strengthen_:setPercent(tonumber(params[1])/tonumber(params[2])*100)
                    local Text_number = ccui.Helper:seekWidgetByName(instance.roots[1], "Text_number")
                    if tonumber(params[3]) == 1 then
                        if tonumber(params[1]) > tonumber(params[2]) then
                            params[1] = params[2]
                        end 
                    end
                    if tonumber(params[2]) == -1 then
                        Text_number:setString(params[1])
                        LoadingBar_strengthen_:setPercent(100)
                    else
                        Text_number:setString(params[1].."/"..params[2])
                    end

                    local Text_lv = ccui.Helper:seekWidgetByName(instance.roots[1], "Text_lv")
                    if tonumber(params[3]) ~= nil then
                        if tonumber(params[3]) == 2 then
                            Text_lv:setString(string.format(_new_interface_text[5],zstring.tonumber(_ED.user_ship[""..instance.ship_id].ship_grade)))
                        else
                            Text_lv:setString("")
                        end
                    end

                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --碎片追踪
        local sm_role_strengthen_tab_material_tracking_terminal = {
            _name = "sm_role_strengthen_tab_material_tracking",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local material = dms.searchs(dms["prop_mould"], prop_mould.use_of_ship, tonumber(_ED.user_ship[instance.ship_id].ship_template_id))
                if material ~= nil then
                    for i=1, #material do
                        if tonumber(material[i][9]) == 1 then
                            local prop = material[i][1] --道具模板id
                            app.load("client.packs.hero.HeroPatchInformationPageGetWay")
                            local cell = HeroPatchInformationPageGetWay:createCell()
                            cell:init(prop,5)
                            fwin:open(cell, fwin._windows)
                            return
                        end
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --绘制操作成功后的特效
        local sm_role_strengthen_tab_play_control_effect_terminal = {
            _name = "sm_role_strengthen_tab_play_control_effect",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                    state_machine.excute("hero_develop_back_to_play_control_effect",0,"")
                else
                    if instance._effice_digimon_qh == nil then
                        local Panel_sjdh_2 = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_sjdh_2")
                        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effice_digimon_qh/effice_digimon_qh.ExportJson")
                        instance._effice_digimon_qh = ccs.Armature:create("effice_digimon_qh")
                        Panel_sjdh_2:addChild(instance._effice_digimon_qh)
                        instance._effice_digimon_qh:setPosition(cc.p(Panel_sjdh_2:getContentSize().width / 2, Panel_sjdh_2:getContentSize().height / 2))
                    end
                    local function changeActionCallback( armatureBack ) 
                        if armatureBack ~= nil and armatureBack:getParent() ~= nil then
                            armatureBack:setVisible(false)
                        end
                    end
                    instance._effice_digimon_qh:setVisible(true)
                    instance._effice_digimon_qh._invoke = changeActionCallback
                    instance._effice_digimon_qh._actionIndex = 0
                    instance._effice_digimon_qh:getAnimation():playWithIndex(0)
                end
                
                local shipInfo = _ED.user_ship[""..instance.ship_id]
                if shipInfo == nil then
                    return
                end
                shipInfo = getShipByTalent(shipInfo)
                --战力
                local Text_role_strengthen_fight_n = ccui.Helper:seekWidgetByName(instance.roots[1], "Text_role_strengthen_fight_n")
                Text_role_strengthen_fight_n:setString(shipInfo.hero_fight)
                --攻击
                local Text_role_strengthen_attack_n = ccui.Helper:seekWidgetByName(instance.roots[1], "Text_role_strengthen_attack_n")
                Text_role_strengthen_attack_n:setString(shipInfo.ship_courage)
                --生命
                local Text_410_1 = ccui.Helper:seekWidgetByName(instance.roots[1], "Text_410_1")
                Text_410_1:setString(shipInfo.ship_health)
                --防御
                local Text_role_strengthen_defense_n = ccui.Helper:seekWidgetByName(instance.roots[1], "Text_role_strengthen_defense_n")
                Text_role_strengthen_defense_n:setString(shipInfo.ship_intellect)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --进化
        local sm_role_strengthen_tab_evolution_terminal = {
            _name = "sm_role_strengthen_tab_evolution",
            _init = function (terminal)
                app.load("client.packs.hero.GeneralsEvoChainWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                _ED.previous_ship_evo_window = "SmRoleStrengthenTabClass"
                if fwin:find("HeroIconListViewClass") ~= nil then
                    fwin:find("HeroIconListViewClass"):setVisible(false)
                end
                state_machine.excute("generals_evo_chain_window_open",0,{_ED.user_ship[""..instance.ship_id]})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_role_strengthen_tab_open_rebrith_terminal = {
            _name = "sm_role_strengthen_tab_open_rebrith",
            _init = function (terminal)
                app.load("client.packs.hero.SmRoleInfomationRebirth")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("sm_role_infomation_rebirth_window_open",0,{_ED.user_ship[""..instance.ship_id]})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_role_strengthen_tab_open_fashion_terminal = {
            _name = "sm_role_strengthen_tab_open_fashion",
            _init = function (terminal)
                app.load("client.packs.hero.SmRoleFashion")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- if true then
                --     TipDlg.drawTextDailog(_wait_open_tip)
                --     return
                -- end
                state_machine.excute("sm_role_fashion_window_open", 0, {_ED.user_ship[""..instance.ship_id]})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_role_strengthen_tab_open_matrix_terminal = {
            _name = "sm_role_strengthen_tab_open_matrix",
            _init = function (terminal)
                app.load("client.l_digital.cultivate.matrix.AlloyMatrixWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- if true then
                --     TipDlg.drawTextDailog(_wait_open_tip)
                --     return
                -- end
                state_machine.excute("alloy_matrix_window_open", 0, {_ED.user_ship[""..instance.ship_id]})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
	-- 打开究极潜力
        local formation_go_to_open_energy_terminal = {
            _name = "sm_role_strengthen_tab_open_energy",
            _init = function (terminal)
                app.load("client.packs.hero.SmRoleEnergy")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local ship = _ED.user_ship["" .. instance.ship_id]
                local evo_image = dms.string(dms["ship_mould"], ship.ship_template_id, ship_mould.fitSkillTwo)
                local evo_info = zstring.split(evo_image, ",")
                local ship_evo = zstring.split(ship.evolution_status, "|")
                local evolutionLevel = tonumber(ship_evo[1])
                local evo_mould_id = evo_info[evolutionLevel]
                
                local ship_evo_mould_field12 = dms.string(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.field12)
                if ship_evo_mould_field12 ~= nil and ship_evo_mould_field12 ~= "-1" then
                    local ship_evo_mould_field12_talentInfos = zstring.split(ship_evo_mould_field12, ",")
                    state_machine.excute("sm_role_energy_window_open", 0, {ship_evo_mould_field12_talentInfos})
                end

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 绘制强化使用数量
        local sm_role_strengthen_tab_show_prop_number_terminal = {
            _name = "sm_role_strengthen_tab_show_prop_number",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
                    if zstring.tonumber(params) > 0 then
                        ccui.Helper:seekWidgetByName(instance.roots[1], "Text_use_number"):setString("x"..params)
                    else
                        ccui.Helper:seekWidgetByName(instance.roots[1], "Text_use_number"):setString("")
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 绘制强化使用数量
        local sm_role_strengthen_tab_hide_the_display_terminal = {
            _name = "sm_role_strengthen_tab_hide_the_display",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_39") ~= nil then
                    ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_39"):setVisible(params)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_role_strengthen_tab_display_terminal)
        state_machine.add(sm_role_strengthen_tab_hide_terminal)
        state_machine.add(sm_role_strengthen_tab_open_up_product_terminal)
        state_machine.add(sm_role_strengthen_tab_open_up_grade_terminal)
        state_machine.add(sm_role_strengthen_tab_open_rising_star_terminal)
        state_machine.add(sm_role_strengthen_tab_update_ship_info_terminal)
        state_machine.add(sm_role_strengthen_tab_open_fight_spirit_terminal)
        state_machine.add(sm_role_strengthen_tab_update_Loading_terminal)
        state_machine.add(sm_role_strengthen_tab_material_tracking_terminal)
        state_machine.add(sm_role_strengthen_tab_play_control_effect_terminal)
        state_machine.add(sm_role_strengthen_tab_evolution_terminal)
        state_machine.add(sm_role_strengthen_tab_show_prop_number_terminal)
        state_machine.add(sm_role_strengthen_tab_up_exp_loading_terminal)
        state_machine.add(sm_role_strengthen_tab_hide_the_display_terminal)
        state_machine.add(sm_role_strengthen_tab_open_rising_skill_terminal)
        state_machine.add(sm_role_strengthen_tab_open_rising_fighting_spirit_terminal)
        state_machine.add(sm_role_strengthen_tab_open_equip_up_terminal)
        state_machine.add(sm_role_strengthen_tab_open_equip_awakening_terminal)
        state_machine.add(sm_role_strengthen_tab_open_rebrith_terminal)
        state_machine.add(sm_role_strengthen_tab_open_fashion_terminal)
        state_machine.add(sm_role_strengthen_tab_open_matrix_terminal)
        state_machine.add(sm_role_strengthen_tab_open_equip_harden_terminal)
	state_machine.add(formation_go_to_open_energy_terminal)

        state_machine.init()
    end
    init_sm_role_strengthen_tab_terminal()
end

function SmRoleStrengthenTab:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local shipInfo = _ED.user_ship[""..self.ship_id]
    if shipInfo == nil then
        return
    end
    shipInfo = getShipByTalent(shipInfo)
    --名称
    local Text_41 = ccui.Helper:seekWidgetByName(root, "Text_41")
    local name = nil
    --进化形象
    local evo_image = dms.string(dms["ship_mould"], shipInfo.ship_template_id, ship_mould.fitSkillTwo)
    local evo_info = zstring.split(evo_image, ",")
    --进化模板id
    local ship_evo = zstring.split(shipInfo.evolution_status, "|")

    -- 显示隐藏究极潜力
    local evolutionLevel = tonumber(ship_evo[1])
    local Button_energy = ccui.Helper:seekWidgetByName(root, "Button_energy")
    if evolutionLevel == 4 then
        Button_energy:setVisible(true)
    else
        Button_energy:setVisible(false)             
    end

    local evo_mould_id = smGetSkinEvoIdChange(shipInfo)
    local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
    local word_info = dms.element(dms["word_mould"], name_mould_id)
    name = word_info[3]
    if getShipNameOrder(tonumber(_ED.user_ship[shipInfo.ship_id].Order)) > 0 then
        name = name.." +"..getShipNameOrder(tonumber(_ED.user_ship[shipInfo.ship_id].Order))
    end
    local quality = 1
    quality = shipOrEquipSetColour(tonumber(_ED.user_ship[shipInfo.ship_id].Order))
    Text_41:setString(name)
    local color_R = tipStringInfo_quality_color_Type[quality][1]
    local color_G = tipStringInfo_quality_color_Type[quality][2]
    local color_B = tipStringInfo_quality_color_Type[quality][3]
    Text_41:setColor(cc.c3b(color_R, color_G, color_B))

    local Panel_strengthen_stye = ccui.Helper:seekWidgetByName(root, "Panel_strengthen_stye")
    Panel_strengthen_stye:removeBackGroundImage()
    local camp_preference = dms.int(dms["ship_mould"], shipInfo.ship_template_id, ship_mould.camp_preference)
    if camp_preference> 0 and camp_preference <=3 then
        Panel_strengthen_stye:setBackGroundImage(string.format("images/ui/icon/type_icon_%d.png", camp_preference))
    end

    local Panel_constellation_star_icon = ccui.Helper:seekWidgetByName(root, "Panel_constellation_star_icon")
    if Panel_constellation_star_icon ~= nil then
        Panel_constellation_star_icon:removeBackGroundImage()
        local constellation_type = dms.int(dms["ship_mould"], shipInfo.ship_template_id, ship_mould.hero_gender)
        if tonumber(constellation_type) and tonumber(constellation_type) ~= 0 then
            if Panel_constellation_star_icon ~= nil then
                Panel_constellation_star_icon:setBackGroundImage(string.format("images/ui/text/TF_res/galaxy/xz_sx_icon_%d.png", tonumber(constellation_type)))
            end
        end
    end

    --战力
    local Text_role_strengthen_fight_n = ccui.Helper:seekWidgetByName(root, "Text_role_strengthen_fight_n")
    Text_role_strengthen_fight_n:setString(shipInfo.hero_fight)
    --攻击
    local Text_role_strengthen_attack_n = ccui.Helper:seekWidgetByName(root, "Text_role_strengthen_attack_n")
    Text_role_strengthen_attack_n:setString(shipInfo.ship_courage)
    --生命
    local Text_410_1 = ccui.Helper:seekWidgetByName(root, "Text_410_1")
    Text_410_1:setString(shipInfo.ship_health)
    --防御
    local Text_role_strengthen_defense_n = ccui.Helper:seekWidgetByName(root, "Text_role_strengthen_defense_n")
    Text_role_strengthen_defense_n:setString(shipInfo.ship_intellect)

    for i=1,7 do
        local Image_star = ccui.Helper:seekWidgetByName(self.roots[1], "Image_star_"..i)
        Image_star:setVisible(false)
    end
    local StarRating = tonumber(shipInfo.StarRating)
    if StarRating > 0 and StarRating <= 7 then
        for i=1, StarRating do
            local Image_star = ccui.Helper:seekWidgetByName(root, "Image_star_"..i)
            Image_star:setVisible(true)
        end
    end

    local Panel_strengthen_role_up_text = ccui.Helper:seekWidgetByName(root, "Panel_strengthen_role_up_text")
    Panel_strengthen_role_up_text:removeBackGroundImage()
    local level_groun_icon = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.level_groun_icon)
    Panel_strengthen_role_up_text:setBackGroundImage(string.format("images/ui/text/sm_role_up_%d.png", level_groun_icon))
    -- Fury: botones de los sistemas nuevos del heroe (marco FuryHeroExtras.lua, sistema E).
    pcall(function() app.load("client.packs.hero.FuryHeroExtras") FuryHeroExtras.attach(self) end)
end

function SmRoleStrengthenTab:UpdateShowLoading(number1,number2,m_type)
    local root = self.roots[1]
    if root == nil then 
        return
    end
    --进度条
    local LoadingBar_strengthen_ = ccui.Helper:seekWidgetByName(root, "LoadingBar_strengthen_")
    --没数据暂时写0
    LoadingBar_strengthen_:setPercent(number1/number2*100)
    local Text_number = ccui.Helper:seekWidgetByName(root, "Text_number")
    if tonumber(m_type) == 1 then
        if tonumber(number1) > tonumber(number2) then
            number1 = number2
        end 
    end
    if tonumber(number2) == -1 then
        Text_number:setString(number1)
        LoadingBar_strengthen_:setPercent(100)
    else
        Text_number:setString(number1.."/"..number2)
    end

    local Panel_type_icon = ccui.Helper:seekWidgetByName(root, "Panel_type_icon")
    local Text_lv = ccui.Helper:seekWidgetByName(root, "Text_lv")
    local Button_add = ccui.Helper:seekWidgetByName(root, "Button_add")
    if m_type ~= nil then
        if tonumber(m_type) == 2 then
            Text_lv:setString(string.format(_new_interface_text[5],zstring.tonumber(_ED.user_ship[""..self.ship_id].ship_grade)))
            Panel_type_icon:setVisible(false)
            Button_add:setVisible(false)
        else
            Text_lv:setString("")
            Panel_type_icon:setVisible(true)
            if tonumber(m_type) == 1 then
                Panel_type_icon:setBackGroundImage("images/ui/icon/spicon.png")
                Button_add:setVisible(false)
            elseif tonumber(m_type) == 3 then
                Panel_type_icon:setBackGroundImage("images/ui/icon/icon_300.png")
                Button_add:setVisible(true)
            end
        end
    end
end
-- function SmRoleStrengthenTab:showImageAnimation()
--     local root = self.roots[1]
--     if root == nil then 
--         return
--     end
--     local shipInfo = _ED.user_ship[""..self.ship_id]
--     if shipInfo == nil then
--         return
--     end

-- end

function SmRoleStrengthenTab:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow     
    self.ship_id = params[2]
    self:onInit()
    return self
end

function SmRoleStrengthenTab:onInit()
    local csbSmRoleStrengthenTab = csb.createNode("packs/HeroStorage/sm_role_strengthen_tab.csb")
    local root = csbSmRoleStrengthenTab:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmRoleStrengthenTab)

    -- 究极潜力
    local Button_energy = ccui.Helper:seekWidgetByName(root, "Button_energy")
    if Button_energy then
        Button_energy:setVisible(false)
        fwin:addTouchEventListener(Button_energy, nil, 
        {
            terminal_name = "sm_role_strengthen_tab_open_energy",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil, 0)
    end
	
    self:onUpdateDraw()
    -- self:showImageAnimation()
	-- 关闭
    -- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_res_infor_close"), nil, 
    -- {
        -- terminal_name = "red_alert_time_mine_help_info_close",
        -- terminal_state = 0,
        -- touch_black = true,
    -- },
    -- nil,3)
    --碎片追踪
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_add"), nil, 
    {
        terminal_name = "sm_role_strengthen_tab_material_tracking",
        terminal_state = 0,
    },
    nil,0)

    
    --进化
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_evo"), nil, 
    {
        terminal_name = "sm_role_strengthen_tab_evolution",
        terminal_state = 0,
    },
    nil,0)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_hero_develop_ship_evo",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_evo"),
        _invoke = nil,
        _interval = 0.5,})

    local Button_rebirth = ccui.Helper:seekWidgetByName(root,"Button_rebirth")
    local Button_fashion = ccui.Helper:seekWidgetByName(root,"Button_fashion")
    local Button_matrix = ccui.Helper:seekWidgetByName(root,"Button_matrix")
    if Button_rebirth ~= nil then
        if funOpenDrawTip(175, false) == false then
            Button_rebirth:setVisible(true)
        else
            Button_rebirth:setVisible(false)
        end
        fwin:addTouchEventListener(Button_rebirth, nil, 
        {
            terminal_name = "sm_role_strengthen_tab_open_rebrith",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,0)
    end
    if Button_fashion ~= nil then
        if funOpenDrawTip(176, false) == false then
            Button_fashion:setVisible(true)
        else
            Button_fashion:setVisible(false)
        end
        fwin:addTouchEventListener(Button_fashion, nil, 
        {
            terminal_name = "sm_role_strengthen_tab_open_fashion",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,0)
    end

    if Button_matrix ~= nil then
        if funOpenDrawTip(126, false) == false then
            Button_matrix:setVisible(true)
        else
            Button_matrix:setVisible(false)
        end
        fwin:addTouchEventListener(Button_matrix, nil, 
        {
            terminal_name = "sm_role_strengthen_tab_open_matrix",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,0)
    end
    -- Fury: botones de los sistemas nuevos del heroe (marco FuryHeroExtras.lua, sistema E).
    pcall(function() app.load("client.packs.hero.FuryHeroExtras") FuryHeroExtras.attach(self) end)
end

function SmRoleStrengthenTab:onExit()
    state_machine.remove("sm_role_strengthen_tab_display")
    state_machine.remove("sm_role_strengthen_tab_hide")
    state_machine.remove("sm_role_strengthen_tab_open_up_product")
    state_machine.remove("sm_role_strengthen_tab_open_up_grade")
    state_machine.remove("sm_role_strengthen_tab_open_rising_star")
    state_machine.remove("sm_role_strengthen_tab_open_rising_skill")
    state_machine.remove("sm_role_strengthen_tab_open_rising_fighting_spirit")
    state_machine.remove("sm_role_strengthen_tab_open_fight_spirit")
	state_machine.remove("sm_role_strengthen_tab_update_ship_info")
    state_machine.remove("sm_role_strengthen_tab_update_Loading")
    state_machine.remove("sm_role_strengthen_tab_up_exp_loading")
    state_machine.remove("sm_role_strengthen_tab_material_tracking")
    state_machine.remove("sm_role_strengthen_tab_play_control_effect")
    state_machine.remove("sm_role_strengthen_tab_evolution")
    state_machine.remove("sm_role_strengthen_tab_show_prop_number")
    state_machine.remove("sm_role_strengthen_tab_hide_the_display")
    state_machine.remove("sm_role_strengthen_tab_open_rebrith")
    state_machine.remove("sm_role_strengthen_tab_open_fashion")
    state_machine.remove("sm_role_strengthen_tab_open_matrix")
    state_machine.remove("sm_role_strengthen_tab_open_energy")
end