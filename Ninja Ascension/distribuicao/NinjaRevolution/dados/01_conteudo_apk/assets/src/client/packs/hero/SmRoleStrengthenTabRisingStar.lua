-- ----------------------------------------------------------------------------------------------------
-- 说明：角色升星
-------------------------------------------------------------------------------------------------------
SmRoleStrengthenTabRisingStar = class("SmRoleStrengthenTabRisingStarClass", Window)

local sm_role_strengthen_tab_rising_star_open_terminal = {
    _name = "sm_role_strengthen_tab_rising_star_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _homeWindow = fwin:find("SmRoleStrengthenTabRisingStarClass")
        if nil == _homeWindow then
            local panel = SmRoleStrengthenTabRisingStar:new():init(params)
            fwin:open(panel)
        else
            fwin:close(fwin:find("SmRoleStrengthenTabRisingStarClass"))
            local panel = SmRoleStrengthenTabRisingStar:new():init(params)
            fwin:open(panel)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_role_strengthen_tab_rising_star_close_terminal = {
    _name = "sm_role_strengthen_tab_rising_star_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _homeWindow = fwin:find("SmRoleStrengthenTabRisingStarClass")
        if nil ~= _homeWindow then
            fwin:close(fwin:find("SmRoleStrengthenTabRisingStarClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_role_strengthen_tab_rising_star_open_terminal)
state_machine.add(sm_role_strengthen_tab_rising_star_close_terminal)
state_machine.init()
    
function SmRoleStrengthenTabRisingStar:ctor()
    self.super:ctor()
    self.roots = {}
    self.currentCount = 0
    self.prop_scrap_mould_id = 0

    app.load("client.cells.equip.equip_icon_new_cell")
    app.load("client.cells.ship.ship_head_new_cell")
    app.load("client.cells.prop.prop_icon_new_cell")
    local function init_sm_role_strengthen_tab_rising_star_terminal()
        -- 显示界面
        local sm_role_strengthen_tab_rising_star_display_terminal = {
            _name = "sm_role_strengthen_tab_rising_star_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmRoleStrengthenTabRisingStarWindow = fwin:find("SmRoleStrengthenTabRisingStarClass")
                if SmRoleStrengthenTabRisingStarWindow ~= nil then
                    SmRoleStrengthenTabRisingStarWindow:setVisible(true)
                    instance:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_role_strengthen_tab_rising_star_hide_terminal = {
            _name = "sm_role_strengthen_tab_rising_star_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmRoleStrengthenTabRisingStarWindow = fwin:find("SmRoleStrengthenTabRisingStarClass")
                if SmRoleStrengthenTabRisingStarWindow ~= nil then
                    SmRoleStrengthenTabRisingStarWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新
        local sm_role_strengthen_tab_rising_star_update_draw_terminal = {
            _name = "sm_role_strengthen_tab_rising_star_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 改变id
        local sm_role_strengthen_tab_rising_star_change_ship_terminal = {
            _name = "sm_role_strengthen_tab_rising_star_change_ship",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.ship_id = params
                state_machine.excute("notification_center_update",0,"push_notification_center_hero_strength_up_grade_button")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 点击潜能
        local on_click_Button_role_up_star_add_terminal = {
            _name = "on_click_Button_role_up_star_add",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local root = instance.roots[1]
                if root then
                    local Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star")
                    Panel_star:setVisible(false)

                    local Panel_star_add = ccui.Helper:seekWidgetByName(root, "Panel_star_add")
                    Panel_star_add:setVisible(true)

                    instance:updateQianNengMoney()

                    instance:hideMaterial(false)
                    instance:hideMoney(true)

                    -- 打开潜能时隐藏战力
                    state_machine.excute("formation_showOrHide_Text_role_fight", 0, {_datas = {isHide = true}})

                end
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 点击潜能返回
        local on_click_Button_role_up_star_back_terminal = {
            _name = "on_click_Button_role_up_star_back",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local root = instance.roots[1]
                if root then
                    local Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star")
                    Panel_star:setVisible(true)

                    local Panel_star_add = ccui.Helper:seekWidgetByName(root, "Panel_star_add")
                    Panel_star_add:setVisible(false)

                    instance:hideMaterial(true)
                    self:onUpdateDraw()

                    state_machine.excute("formation_showOrHide_Text_role_fight", 0, {_datas = {isHide = false}})

                end
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 点击潜能技能图标
        local on_click_Panel_skill_icon_terminal = {
            _name = "on_click_Panel_skill_icon",
            _init = function (terminal) 
                app.load("client.packs.hero.QianNengSkillDescription")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                state_machine.excute("qianNengSkillDescription_open", 0, {params._datas.skillGrade, params._datas.index})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 点击潜能技能升级
        local on_click_Button_lvup_terminal = {
            _name = "on_click_Button_lvup",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local root = instance.roots[1]
                local function callback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node and response.node.roots[1] then

                            response.node:onUpdateDraw()
                            smFightingChange()

                            if fwin:find("FormationTigerGateClass") ~= nil then
                                state_machine.excute("sm_role_formation_strengthen_tab_play_control_effect",0,"")
                            end

                            if fwin:find("HeroDevelopClass") ~= nil then
                                local ship_id = instance.ship_id
                                state_machine.excute("sm_role_strengthen_tab_update_ship_info", 0, {ship_id})
                            end
                        end
                    end
                end

                protocol_command.ship_potential_up.param_list = params._datas.shipId .. "\r\n" .. params._datas.index
                NetworkManager:register(protocol_command.ship_potential_up.code, nil, nil, nil, self, callback, false, nil)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 请求升星
        local sm_role_strengthen_tab_rising_star_request_terminal = {
            _name = "sm_role_strengthen_tab_rising_star_request",
            _init = function (terminal) 
                app.load("client.packs.hero.GeneralsStarUpSuccessWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("sm_role_strengthen_tab_rising_star_request")
                local ship_id = instance.ship_id
                if tonumber(instance.currentCount) < tonumber(instance.demandCount) then
                    local material = dms.searchs(dms["prop_mould"], prop_mould.use_of_ship, tonumber(_ED.user_ship[ship_id].ship_template_id))
                    if material ~= nil then
                        for i=1, #material do
                            if tonumber(material[i][9]) == 1 then
                                if __lua_project_id == __lua_project_l_pokemon and zstring.tonumber(_ED.server_review) == 1 then
                                    TipDlg.drawTextDailog(_new_interface_text[27])
                                else
                                local prop = material[i][1] --道具模板id
                                app.load("client.packs.hero.HeroPatchInformationPageGetWay")
                                local cell = HeroPatchInformationPageGetWay:createCell()
                                cell:init(prop,5)
                                fwin:open(cell, fwin._windows)
                                state_machine.unlock("sm_role_strengthen_tab_rising_star_request")
                                end
                                return
                            end
                        end
                    end
                    return
                end
                local currShip = getShipByTalent(_ED.user_ship[ship_id])
                local oldshipInfo = {
                    Order = currShip.Order,
                    hero_fight = currShip.hero_fight,
                    StarRating = currShip.StarRating,
                    ship_template_id = currShip.ship_template_id,
                    evolution_status = currShip.evolution_status,
                    ship_wisdom = currShip.ship_wisdom,
                }
                local function responseWearCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                                then
                                setShipPushData(ship_id,3,-1)
                            end
                            response.node:onUpdateDraw()
                            local currShip = getShipByTalent(_ED.user_ship[ship_id])
                            local StarRating = tonumber(currShip.StarRating)
                            local Image_star = ccui.Helper:seekWidgetByName(instance.roots[1], "Image_star_"..StarRating)
                            Image_star:setVisible(false)
                            
                            state_machine.excute("generals_star_up_success_window_open",0,{oldshipInfo,currShip,2})
                            if fwin:find("HeroDevelopClass") ~= nil then
                                state_machine.excute("sm_role_strengthen_tab_update_ship_info",0,{ship_id})
                                state_machine.excute("hero_develop_page_strength_to_update_all_icon",0,currShip)
                            else
                                state_machine.excute("hero_icon_listview_update_all_icon",0,currShip)
                            end

                            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                                then
                                state_machine.excute("sm_role_strengthen_tab_skill_update_draw") -- 刷新技能解锁情况
                                -- state_machine.excute("sm_role_strengthen_tab_play_control_effect", 0, 0)
                                state_machine.excute("notification_center_update",0,"push_notification_center_formation_ship_evo")
                            end
                        end
                        state_machine.excute("user_info_hero_storage_update", 0, "user_info_hero_storage_update.") -- 刷新顶部信息
                        state_machine.unlock("formation_back_to_home_activity", 0, "")
                    else
                        state_machine.unlock("formation_back_to_home_activity", 0, "")
                        state_machine.unlock("sm_role_strengthen_tab_rising_star_request")
                    end
                end
                state_machine.lock("formation_back_to_home_activity", 0, "")
                protocol_command.ship_awaken.param_list = ship_id
                NetworkManager:register(protocol_command.ship_awaken.code, nil, nil, nil, instance, responseWearCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 万能碎片兑换
        local sm_role_strengthen_tab_rising_star_all_exchange_terminal = {
            _name = "sm_role_strengthen_tab_rising_star_all_exchange",
            _init = function (terminal) 
                app.load("client.packs.hero.SmRoleStrengthenUniversal")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.prop_scrap_mould_id == 0 then
                    return
                end
                local needCount = 0 
                if tonumber(instance.demandCount) > 0 and tonumber(instance.currentCount) < tonumber(instance.demandCount) then 
                    needCount = instance.demandCount - instance.currentCount
                end
                state_machine.excute("sm_role_strengthen_tab_universal_open" , 0 , { instance.prop_scrap_mould_id, instance.currentCount,instance.debrisType, needCount})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 升星的星星下落动画
        local sm_role_strengthen_tab_rising_the_stars_fall_terminal = {
            _name = "sm_role_strengthen_tab_rising_the_stars_fall",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local StarRating = tonumber(_ED.user_ship[instance.ship_id].StarRating)
                local Image_star = ccui.Helper:seekWidgetByName(instance.roots[1], "Image_star_"..StarRating)
                Image_star:setVisible(true)
                Image_star:setScale(4)
                Image_star:setRotation(270)
                function blinkOutCallback(sender)
                    state_machine.unlock("sm_role_strengthen_tab_rising_star_request")
                    if fwin:find("HeroDevelopClass") ~= nil then
                    else
                        for i, v in pairs(_ED.user_formetion_status) do
                            if tonumber(v) == tonumber(instance.ship_id) then
                                state_machine.excute("formation_set_ship",0,getShipByTalent(_ED.user_ship[instance.ship_id]))
                                break
                            end
                        end
                    end
                end
                local seq = cc.Sequence:create(
                    cc.Spawn:create({cc.ScaleTo:create(0.25, 1),
                        cc.RotateBy:create(0.25, 90)
                        }))

                Image_star:runAction(seq)
                Image_star:runAction(cc.Sequence:create(
                        cc.DelayTime:create(0.25),
                        cc.CallFunc:create(blinkOutCallback)
                         ))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新金币显示
        local sm_role_strengthen_tab_rising_stars_update_golds_terminal = {
            _name = "sm_role_strengthen_tab_rising_stars_update_golds",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:showGolds()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --碎片追踪
        local sm_role_strengthen_tab_rising_stars_material_tracking_terminal = {
            _name = "sm_role_strengthen_tab_rising_stars_material_tracking",
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
                            if __lua_project_id == __lua_project_l_pokemon and zstring.tonumber(_ED.server_review) == 1 then
                                if instance.materialEnough == false then
                                    TipDlg.drawTextDailog(_new_interface_text[27])
                                end
                            else
                            local prop = material[i][1] --道具模板id
                            app.load("client.packs.hero.HeroPatchInformationPageGetWay")
                            local cell = HeroPatchInformationPageGetWay:createCell()
                            cell:init(prop,5)
                            fwin:open(cell, fwin._windows)
                            end
                            return
                        end
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 組合卡碎片兑换
        local on_click_Button_combinate_change_terminal = {
            _name = "on_click_Button_combinate_change",
            _init = function (terminal) 
                app.load("client.l_digital.cultivate.combinationCard.CombinationCardTabWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    state_machine.excute("combination_card_tab_window_open",0,{_ED.user_ship[self.ship_id].ship_template_id})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_role_strengthen_tab_rising_star_display_terminal)
        state_machine.add(sm_role_strengthen_tab_rising_star_hide_terminal)
        state_machine.add(sm_role_strengthen_tab_rising_star_update_draw_terminal)
        state_machine.add(sm_role_strengthen_tab_rising_star_change_ship_terminal)
        state_machine.add(sm_role_strengthen_tab_rising_star_request_terminal)
        state_machine.add(sm_role_strengthen_tab_rising_star_all_exchange_terminal)
        state_machine.add(sm_role_strengthen_tab_rising_the_stars_fall_terminal)
        state_machine.add(sm_role_strengthen_tab_rising_stars_update_golds_terminal)
        state_machine.add(sm_role_strengthen_tab_rising_stars_material_tracking_terminal)
        state_machine.add(on_click_Button_role_up_star_add_terminal)
        state_machine.add(on_click_Button_role_up_star_back_terminal)
        state_machine.add(on_click_Panel_skill_icon_terminal)
        state_machine.add(on_click_Button_lvup_terminal)
        state_machine.add(on_click_Button_combinate_change_terminal)
        
        state_machine.init()
    end
    init_sm_role_strengthen_tab_rising_star_terminal()
end

function SmRoleStrengthenTabRisingStar:showGolds()
    local root = self.roots[1]
    local StarRating = tonumber(_ED.user_ship[self.ship_id].StarRating)
    local awakenData = dms.int(dms["awaken_requirement"], StarRating, awaken_requirement.need_silver)
    local Text_role_up_star_gold_n = ccui.Helper:seekWidgetByName(root, "Text_role_up_star_gold_n")
    if tonumber(_ED.user_ship[self.ship_id].ship_grade) < dms.int(dms["awaken_requirement"], StarRating, awaken_requirement.ship_level_limit) then
        Text_role_up_star_gold_n:setString(string.format(_new_interface_text[6],dms.int(dms["awaken_requirement"], StarRating, awaken_requirement.ship_level_limit)))
        -- DSC重塑
        if __lua_project_id == __lua_project_l_digital and tipStringInfo_color_type_assemble then
            Text_role_up_star_gold_n:setColor(cc.c3b(tipStringInfo_color_type_assemble[7][1], tipStringInfo_color_type_assemble[7][2], tipStringInfo_color_type_assemble[7][3]))
        else
            Text_role_up_star_gold_n:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
        end
        ccui.Helper:seekWidgetByName(root, "Image_gold_icon"):setVisible(false)
    else
        Text_role_up_star_gold_n:setString(awakenData)
        ccui.Helper:seekWidgetByName(root, "Image_gold_icon"):setVisible(true)
        if awakenData > tonumber(_ED.user_info.user_silver) then
            -- DSC重塑
            if __lua_project_id == __lua_project_l_digital and tipStringInfo_color_type_assemble then
                Text_role_up_star_gold_n:setColor(cc.c3b(tipStringInfo_color_type_assemble[7][1], tipStringInfo_color_type_assemble[7][2], tipStringInfo_color_type_assemble[7][3]))
            else
                Text_role_up_star_gold_n:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
            end
        else
            -- DSC重塑
            if __lua_project_id == __lua_project_l_digital and tipStringInfo_color_type_assemble then
                Text_role_up_star_gold_n:setColor(cc.c3b(tipStringInfo_color_type_assemble[3][1], tipStringInfo_color_type_assemble[3][2], tipStringInfo_color_type_assemble[3][3]))
            else
                Text_role_up_star_gold_n:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
            end
        end
    end
    if tonumber(awakenData) == -1 then
        ccui.Helper:seekWidgetByName(root, "Image_gold_icon"):setVisible(false)
        Text_role_up_star_gold_n:setString("")
    end
end

function SmRoleStrengthenTabRisingStar:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end

    self:onUpdateDrawQianNeng()

    local ship = _ED.user_ship[self.ship_id]
    
    for i=1, 7 do
        ccui.Helper:seekWidgetByName(root, "Image_star_"..i):setVisible(false)
    end
    local StarRating = tonumber(_ED.user_ship[self.ship_id].StarRating)
    if StarRating >= 7 then
        ccui.Helper:seekWidgetByName(self.roots[1],"Button_role_up_star"):setBright(false)
        ccui.Helper:seekWidgetByName(self.roots[1],"Button_role_up_star"):setTouchEnabled(false)

        ccui.Helper:seekWidgetByName(self.roots[1],"Button_role_up_star_add"):setVisible(true)

        self:hideMoney(false)
    else
        ccui.Helper:seekWidgetByName(self.roots[1],"Button_role_up_star"):setBright(true)
        ccui.Helper:seekWidgetByName(self.roots[1],"Button_role_up_star"):setTouchEnabled(true)

        ccui.Helper:seekWidgetByName(self.roots[1],"Button_role_up_star_add"):setVisible(false)
        ccui.Helper:seekWidgetByName(self.roots[1],"Button_role_up_star"):setVisible(true)

        local Panel_star_add = ccui.Helper:seekWidgetByName(root, "Panel_star_add")
        Panel_star_add:setVisible(false)

        local Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star")
        Panel_star:setVisible(true)

        self:hideMaterial(true)
        self:hideMoney(true)
    end
    if StarRating > 0 and StarRating <= 7 then
        for i=1, StarRating do
            local Image_star = ccui.Helper:seekWidgetByName(root, "Image_star_"..i)
            Image_star:setVisible(true)
        end
    end
    self.prop_scrap_mould_id = dms.int(dms["ship_mould"], tonumber(_ED.user_ship[self.ship_id].ship_template_id), ship_mould.fitSkillOne)
    local base_mould2 = dms.int(dms["ship_mould"], tonumber(_ED.user_ship[self.ship_id].ship_template_id), ship_mould.base_mould2)
    --当前碎片
    local info = dms.searchs(dms["awaken_requirement"], awaken_requirement.group_id, base_mould2, awaken_requirement.awake_level, StarRating)
    self.currentCount = 0
    self.demandCount = info[1][awaken_requirement.need_same_card_count]
    for i, prop in pairs(_ED.user_prop) do
        if zstring.tonumber(prop.user_prop_id) > 0 then
            local propData = dms.element(dms["prop_mould"], prop.user_prop_template)
            if dms.atoi(propData, prop_mould.storage_page_index) == 18 then
                if dms.atoi(propData, prop_mould.use_of_ship) == tonumber(_ED.user_ship[self.ship_id].ship_template_id) then
                    self.currentCount = zstring.tonumber(getPropAllCountByMouldId(prop.user_prop_template))
                end
            end
        end
    end 
    self.Button_role_up_all:setVisible(true)
    local debris = dms.int(dms["ship_mould"], tonumber(_ED.user_ship[self.ship_id].ship_template_id), ship_mould.universal_debris)
    self.debrisType =  debris
    local Text_1 = ccui.Helper:seekWidgetByName(self.Button_role_up_all,"Text_1")
    local Text_2 = ccui.Helper:seekWidgetByName(self.Button_role_up_all,"Text_2")
    if debris == -1 then --不能用
        self.Button_role_up_all:setVisible(false)
    elseif debris == 1 then --普通万能碎片
        Text_1:setVisible(true)
        Text_2:setVisible(false)
    else --高级万能碎片
        Text_1:setVisible(false)
        Text_2:setVisible(true)
    end
    

    self:showGolds()   
    if fwin:find("SmRoleStrengthenTabClass") ~= nil then
        state_machine.excute("sm_role_strengthen_tab_update_Loading",0,{ self.currentCount,self.demandCount,3})
    end
    if fwin:find("SmRoleStrengthenTabSpecialAttributesClass") ~= nil then
        state_machine.excute("sm_role_strengthen_tab_special_attributes_update_Loading",0,{ self.currentCount,self.demandCount,3})
    end

    
    local Text_role_up_lv_num_1 = ccui.Helper:seekWidgetByName(self.roots[1],"Text_role_up_lv_num_1")
    if Text_role_up_lv_num_1 ~= nil then
        if tonumber(self.demandCount) > 0 then
            Text_role_up_lv_num_1:setString(self.currentCount.."/"..self.demandCount)
        else
            Text_role_up_lv_num_1:setString(self.currentCount)
        end
    end

    -- 组合卡
    if self.Button_zuhekaduihuan then
        self.Button_zuhekaduihuan:setVisible(false)
        app.load("client.l_digital.cultivate.combinationCard.CombinationCardHandle")
        for k,v in pairs(CombinationCardHandle.getCardList()) do
            if tonumber(v) == tonumber(_ED.user_ship[""..self.ship_id].ship_template_id) then
                ccui.Helper:seekWidgetByName(self.roots[1],"Button_role_up_all"):setVisible(false)
                self.Button_zuhekaduihuan:setVisible(true)
                 --点击组合卡碎片兑换返回
                fwin:addTouchEventListener(self.Button_zuhekaduihuan, nil, 
                {
                    terminal_name = "on_click_Button_combinate_change", 
                    terminal_state = 0,
                    isPressedActionEnabled = true
                }, 
                nil, 0)
            end
        end
    end

    -- 如果潜能界面是显示的，则每次onUpdateDraw时也会刷新updateQianNengMoney
    local Panel_star_add = ccui.Helper:seekWidgetByName(root, "Panel_star_add")
    if Panel_star_add:isVisible() == true then
        self:updateQianNengMoney()    
    end

    local material = dms.searchs(dms["prop_mould"], prop_mould.use_of_ship, tonumber(_ED.user_ship[self.ship_id].ship_template_id))
    if material ~= nil then
        for i=1, #material do
            if tonumber(material[i][9]) == 1 then
                local prop = material[i][1] --道具模板id
                local Panel_role_up_lv_icon_1 = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_role_up_lv_icon_1")
                if Panel_role_up_lv_icon_1 ~= nil then
                    Panel_role_up_lv_icon_1:removeAllChildren(true)
                    local cellUp = PropIconNewCell:createCell()
                    cellUp:init(cellUp.enum_type._SHOW_PROP_GETWAY_INFORMATION, prop)
                    Panel_role_up_lv_icon_1:addChild(cellUp)
                end
                return
            end
        end
    end
end

function SmRoleStrengthenTabRisingStar:getQianNengConfigIndex(grade)
    local configQianNeng = self.configQianNeng
    local index = #configQianNeng
    for i, v in ipairs(configQianNeng) do
        local configArr = zstring.split(configQianNeng[i], ",")
        local gradeRange = zstring.split(configArr[1], "-")

        if grade >= tonumber(gradeRange[1]) and grade <= tonumber(gradeRange[2]) then
            index = i
            break
        end
    end
    return index
end

function SmRoleStrengthenTabRisingStar:updateQianNengMoney()
    self:hideMoney(true)
    -- 消耗金币的显示
    local root = self.roots[1]
    local configArr = zstring.split(self.configQianNeng[1], ",")
    local Text_role_up_star_gold_n = ccui.Helper:seekWidgetByName(root, "Text_role_up_star_gold_n")
    Text_role_up_star_gold_n:setString(configArr[3])
    if tonumber(configArr[3]) > tonumber(_ED.user_info.user_silver) then

        -- DSC重塑
        if __lua_project_id == __lua_project_l_digital and tipStringInfo_color_type_assemble then
            Text_role_up_star_gold_n:setColor(cc.c3b(tipStringInfo_color_type_assemble[7][1], tipStringInfo_color_type_assemble[7][2], tipStringInfo_color_type_assemble[7][3]))
        else
            Text_role_up_star_gold_n:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
        end
    else
        -- DSC重塑
        if __lua_project_id == __lua_project_l_digital and tipStringInfo_color_type_assemble then
            Text_role_up_star_gold_n:setColor(cc.c3b(tipStringInfo_color_type_assemble[3][1], tipStringInfo_color_type_assemble[3][2], tipStringInfo_color_type_assemble[3][3]))
        else
            Text_role_up_star_gold_n:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
        end
    end
end

function SmRoleStrengthenTabRisingStar:hideMaterial(isTrue)
    ccui.Helper:seekWidgetByName(self.roots[1], "Panel_role_up_lv_icon_1"):setVisible(isTrue)
    -- ccui.Helper:seekWidgetByName(self.roots[1], "Button_role_up_all"):setVisible(isTrue)
    ccui.Helper:seekWidgetByName(self.roots[1], "Image_props_bg_1"):setVisible(isTrue)
    ccui.Helper:seekWidgetByName(self.roots[1], "Text_role_up_lv_num_1"):setVisible(isTrue)
    ccui.Helper:seekWidgetByName(self.roots[1], "Image_role_up_lv_add_1"):setVisible(isTrue)
end

function SmRoleStrengthenTabRisingStar:hideMoney(isTrue)
    ccui.Helper:seekWidgetByName(self.roots[1], "Text_role_up_star_gold_n"):setVisible(isTrue)
    ccui.Helper:seekWidgetByName(self.roots[1], "Panel_role_up_lv_icon_2"):setVisible(isTrue)
    ccui.Helper:seekWidgetByName(self.roots[1], "Image_props_bg_2"):setVisible(isTrue)
    ccui.Helper:seekWidgetByName(self.roots[1], "Panel_role_up_lv_box_2"):setVisible(isTrue)
end

-- 初始化潜能ui
function SmRoleStrengthenTabRisingStar:onUpdateDrawQianNeng()

    local configQianNeng = zstring.split(dms.string(dms["ship_config"], 33, 4), "|")
    self.configQianNeng = configQianNeng
    local roleQianNengs = zstring.split(_ED.user_ship[self.ship_id].qianNeng, ",")

    for i = 1, 3 do
        local grade = tonumber(roleQianNengs[i]) or 1
        local index = self:getQianNengConfigIndex(grade)
        local configStr = configQianNeng[index]
        local configArr = zstring.split(configStr, ",")

        local Panel_skiil = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_skiil_" .. i)
        local Text_lvup_gold_n = ccui.Helper:seekWidgetByName(self.roots[1], "Text_lvup_gold_n_" .. i)
        Text_lvup_gold_n:setString(configArr[2])

        local Text_skill_lv = ccui.Helper:seekWidgetByName(Panel_skiil, "Text_skill_lv_1")
        if Text_skill_lv then Text_skill_lv:setString(grade) end

        -- 点击item
        local Image_skill_bg = ccui.Helper:seekWidgetByName(self.roots[1], "Image_skill_bg_" .. i)
        Image_skill_bg:setTouchEnabled(true)
        fwin:addTouchEventListener(Image_skill_bg, nil, 
        {
            terminal_name = "on_click_Button_lvup", 
            terminal_state = 0,
            isPressedActionEnabled = true,
            index = i,
            shipId = self.ship_id,
        }, 
        nil, 0)

        -- 点击加号
        local Button_lvup = ccui.Helper:seekWidgetByName(self.roots[1], "Button_lvup_" .. i)
        fwin:addTouchEventListener(Button_lvup, nil, 
        {
            terminal_name = "on_click_Button_lvup", 
            terminal_state = 0,
            isPressedActionEnabled = true,
            index = i,
            shipId = self.ship_id,
        }, 
        nil, 0)

        -- 点击图标
        local Panel_skill_icon = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_skill_icon_" .. i)
        fwin:addTouchEventListener(Panel_skill_icon, nil, 
        {
            terminal_name = "on_click_Panel_skill_icon", 
            terminal_state = 0,
            isPressedActionEnabled = true,
            index = i,
            skillGrade = grade,
        }, 
        nil, 0)

        -- 显示图标
        local config_potential_attribute = dms.element(dms["potential_attribute"], i, true)
        local pic = config_potential_attribute[2]
        local Image_skill_icon_bg = ccui.Helper:seekWidgetByName(self.roots[1], "Image_skill_icon_bg_" .. i)
        local head = ccui.ImageView:create("images/ui/skills/skills_" .. pic .. ".png")
        head:setPosition(cc.p(Image_skill_icon_bg:getContentSize().width / 2, Image_skill_icon_bg:getContentSize().height / 2))
        Image_skill_icon_bg:addChild(head)

        -- 名称
        local Text_skill_name = ccui.Helper:seekWidgetByName(self.roots[1], "Text_skill_name_" .. i)
        local name = config_potential_attribute[3]
        local strName = dms.string(dms["word_mould"], name, 3)
        Text_skill_name:setString(strName)

    end

end

function SmRoleStrengthenTabRisingStar:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow    
    self.ship_id = params[2]
    self:onInit()
    return self
end

function SmRoleStrengthenTabRisingStar:onInit()
    local csbSmRoleStrengthenTabRisingStar = csb.createNode("packs/HeroStorage/sm_role_strengthen_tab_cell_3.csb")
    local root = csbSmRoleStrengthenTabRisingStar:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmRoleStrengthenTabRisingStar)

    local Panel_dh = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_dh")
    Panel_dh:removeAllChildren(true)
    local jsonFile = "sprite/spirte_shengxing.json"
    local atlasFile = "sprite/spirte_shengxing.atlas"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
    -- animation:setPosition(cc.p(Panel_dh:getContentSize().width/2,Panel_dh:getContentSize().height/2))
    Panel_dh:addChild(animation)


    --升星请求
    if tonumber(_ED.user_ship[self.ship_id].StarRating) >= 7 then
        ccui.Helper:seekWidgetByName(self.roots[1],"Button_role_up_star"):setBright(false)
        ccui.Helper:seekWidgetByName(self.roots[1],"Button_role_up_star"):setTouchEnabled(false)
        ccui.Helper:seekWidgetByName(self.roots[1],"Button_role_up_star"):setVisible(false)

        ccui.Helper:seekWidgetByName(self.roots[1],"Button_role_up_star_add"):setVisible(true)

    else
        ccui.Helper:seekWidgetByName(self.roots[1],"Button_role_up_star"):setBright(true)
        ccui.Helper:seekWidgetByName(self.roots[1],"Button_role_up_star"):setTouchEnabled(true)
    end
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1],"Button_role_up_star"), nil, 
    {
        terminal_name = "sm_role_strengthen_tab_rising_star_request", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_hero_strength_up_grade_button",
        _widget = ccui.Helper:seekWidgetByName(self.roots[1], "Button_role_up_star"),
        _invoke = nil,
        _interval = 0.5,})
    --万能碎片
    self.Button_role_up_all = ccui.Helper:seekWidgetByName(self.roots[1],"Button_role_up_all");
    self.Button_role_up_all:setVisible(true)
    fwin:addTouchEventListener(self.Button_role_up_all, nil, 
    {
        terminal_name = "sm_role_strengthen_tab_rising_star_all_exchange", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    local ship_template_id = _ED.user_ship[self.ship_id].ship_template_id
    if __lua_project_id == __lua_project_l_digital then
        if tonumber(ship_template_id) == 60 then
            ccui.Helper:seekWidgetByName(self.roots[1], "Button_role_up_all"):setVisible(false)
        end
    end

    -- 点击潜能
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_role_up_star_add"), nil, 
    {
        terminal_name = "on_click_Button_role_up_star_add", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    --点击潜能返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_role_up_star_back"), nil, 
    {
        terminal_name = "on_click_Button_role_up_star_back", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 组合卡碎片兑换
    self.Button_zuhekaduihuan = ccui.Helper:seekWidgetByName(self.roots[1], "Button_zuhekaduihuan")
    if self.Button_zuhekaduihuan then
        self.Button_zuhekaduihuan:setVisible(false)
    end
    
    self:onUpdateDraw()
end

function SmRoleStrengthenTabRisingStar:onExit()
    state_machine.remove("sm_role_strengthen_tab_rising_star_display")
    state_machine.remove("sm_role_strengthen_tab_rising_star_hide")
    state_machine.remove("sm_role_strengthen_tab_rising_star_change_ship")
    state_machine.remove("sm_role_strengthen_tab_rising_star_update_draw")
    state_machine.remove("sm_role_strengthen_tab_rising_star_request")
    state_machine.remove("sm_role_strengthen_tab_rising_star_all_exchange")
    state_machine.remove("sm_role_strengthen_tab_rising_stars_update_golds")
    state_machine.remove("on_click_Button_role_up_star_add")
    state_machine.remove("on_click_Button_role_up_star_back")
    state_machine.remove("on_click_Panel_skill_icon")
    state_machine.remove("on_click_Button_lvup")
    state_machine.remove("on_click_Button_combinate_change")
end