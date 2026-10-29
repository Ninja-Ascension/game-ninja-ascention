-- ----------------------------------------------------------------------------------------------------
-- 说明：角色信息界面
-------------------------------------------------------------------------------------------------------
SmRoleInformation = class("SmRoleInformationClass", Window)

local sm_role_information_open_terminal = {
    _name = "sm_role_information_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmRoleInformationClass")
        if nil == _homeWindow then
            local panel = SmRoleInformation:new():init(params)
            fwin:open(panel,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_role_information_close_terminal = {
    _name = "sm_role_information_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmRoleInformationClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmRoleInformationClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_role_information_open_terminal)
state_machine.add(sm_role_information_close_terminal)
state_machine.init()
    
function SmRoleInformation:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.ship_id = 0
    self.action_number = 0
    self.zOrder = nil                   -- 层级显示
    app.load("client.shop.recruit.SmGeneralsCard")
    app.load("client.packs.hero.SmRoleInformationControlsOne")
    app.load("client.packs.hero.SmRoleInformationControlsTwo")
    app.load("client.packs.hero.SmRoleInformationControlsThree")
    app.load("client.packs.hero.SmRoleInformationControlsFour")
    app.load("client.packs.hero.SmRoleInformationControlsFives")
    app.load("client.packs.hero.SmRoleInformationControlsSix")
    app.load("client.packs.hero.SmRoleInformationTip")
    local function init_sm_role_information_terminal()
        -- 显示界面
        local sm_role_information_display_terminal = {
            _name = "sm_role_information_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmRoleInformationWindow = fwin:find("SmRoleInformationClass")
                if SmRoleInformationWindow ~= nil then
                    SmRoleInformationWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_role_information_hide_terminal = {
            _name = "sm_role_information_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmRoleInformationWindow = fwin:find("SmRoleInformationClass")
                if SmRoleInformationWindow ~= nil then
                    SmRoleInformationWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 播放动画
        local sm_role_information_action_terminal = {
            _name = "sm_role_information_action",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.action_number == 0 then
                    instance.actions[1]:play("turn_to_b", false)
                    instance.action_number = 1
                    state_machine.excute("sm_role_information_controls_one_set_button_name",0,instance.action_number)
                else
                    instance.actions[1]:play("turn_to_f", false)
                    instance.action_number = 0
                    state_machine.excute("sm_role_information_controls_one_set_button_name",0,instance.action_number)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 关闭界面，显示之前的界面
        local sm_role_information_close_and_show_terminal = {
            _name = "sm_role_information_close_and_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.m_type ~= nil and tonumber(instance.m_type) == 1 then
                    -- if fwin:find("HeroIconListViewClass") ~= nil then
                    --     fwin:find("HeroIconListViewClass"):setVisible(true)
                    -- end
                end
                state_machine.excute("sm_role_information_close",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 向左刷新
        local sm_role_information_update_show_left_terminal = {
            _name = "sm_role_information_update_show_left",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if zstring.tonumber(instance._chooseIndex) > 0 then
                    instance.ship_id, instance._chooseIndex = state_machine.excute("hero_list_view_get_next_ship_info", 0, instance._chooseIndex - 1)
                    if instance.ship_id > 0 then
                        if instance.action_number == 1 then
                            state_machine.excute("sm_role_information_action",0,"")
                        end
                        instance:onUpdateDraw()
                    end
                else
                    --先判断有
                    if instance.formetion_status ~= nil and instance.formetion_status[1] ~= nil then
                        local index = 0
                        --再判断是哪个
                        for i, v in pairs(instance.formetion_status) do
                            if tonumber(instance.shipData.ship_id) == tonumber(v) then
                                index = i
                                break
                            end
                        end
                        if index - 1 <=0 then
                            index = #instance.formetion_status
                        else
                            index = index - 1  
                        end
                        instance.ship_id = _ED.user_ship[""..instance.formetion_status[index]].ship_template_id
                        if instance.action_number == 1 then
                            state_machine.excute("sm_role_information_action",0,"")
                        end
                        instance:onUpdateDraw()
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 向右刷新
        local sm_role_information_update_show_right_terminal = {
            _name = "sm_role_information_update_show_right",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if zstring.tonumber(instance._chooseIndex) > 0 then
                    instance.ship_id, instance._chooseIndex = state_machine.excute("hero_list_view_get_next_ship_info", 0, instance._chooseIndex + 1)
                    if instance.ship_id > 0 then
                        if instance.action_number == 1 then
                            state_machine.excute("sm_role_information_action",0,"")
                        end
                        instance:onUpdateDraw()
                    end
                else
                    --先判断有
                    if instance.formetion_status ~= nil and instance.formetion_status[1] ~= nil then
                        local index = 0
                        --再判断是哪个
                        for i, v in pairs(instance.formetion_status) do
                            if tonumber(instance.shipData.ship_id) == tonumber(v) then
                                index = i
                                break
                            end
                        end
                        if index + 1 > #instance.formetion_status then
                            index = 1
                        else
                            index = index + 1  
                        end
                        instance.ship_id = _ED.user_ship[""..instance.formetion_status[index]].ship_template_id
                        if instance.action_number == 1 then
                            state_machine.excute("sm_role_information_action",0,"")
                        end
                        instance:onUpdateDraw()
                    end 
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

         --facebook分享
        local share_click_on_terminal = {
            _name = "share_click_on",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_l_naruto then
                    if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
                        handlePlatformRequest(0, CC_SHARE_REQUEST, _web_page_share[2])
                    else
                        handlePlatformRequest(0, CC_SHARE_REQUEST, _web_page_share[1])
                    end
                end

                if __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 then
                    if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
                        handlePlatformRequest(0, CC_SHARE_REQUEST, _web_page_lz_share[2])
                    else
                        handlePlatformRequest(0, CC_SHARE_REQUEST, _web_page_lz_share[1])
                    end
                end

                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and app.configJson.ReleaseLanguage == "en" then
                    if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
                        handlePlatformRequest(0, CC_SHARE_REQUEST, _web_page_share[2])
                    else
                        handlePlatformRequest(0, CC_SHARE_REQUEST, _web_page_share[1])
                    end
                end
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_role_information_display_terminal)
        state_machine.add(sm_role_information_hide_terminal)
        state_machine.add(sm_role_information_action_terminal)
        state_machine.add(sm_role_information_close_and_show_terminal)
        state_machine.add(sm_role_information_update_show_left_terminal)
        state_machine.add(sm_role_information_update_show_right_terminal)
        state_machine.add(share_click_on_terminal)
        state_machine.init()
    end
    init_sm_role_information_terminal()
end

function SmRoleInformation:otherOnUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    isMould = false
    --贴卡牌
    local Panel_digimon_card = ccui.Helper:seekWidgetByName(root, "Panel_digimon_card")
    Panel_digimon_card:removeAllChildren(true)

    self.shipData = _ED.other_user_ship
    state_machine.excute("sm_generals_card_open",0,{Panel_digimon_card,false,false,self.shipData,isMould,self.m_type})

    --滚动信息
    local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_digimon_info")
    local Panel_cell = ccui.Helper:seekWidgetByName(root, "Panel_cell")
    local Image_cell = ccui.Helper:seekWidgetByName(root, "Image_cell")

    local H_height = 0
    local C_height = 0
    for i= 1, 6 do
        local cell = nil
        if i == 1 then
            cell = state_machine.excute("sm_role_information_controls_one_open",0,{self.shipData,isMould,self.m_type})
            cell.zOrder = self.zOrder
        elseif i == 2 then
            cell = state_machine.excute("sm_role_information_controls_two_open",0,{self.shipData,isMould,self.m_type})
        elseif i == 3 then
            cell = state_machine.excute("sm_role_information_controls_three_open",0,{self.shipData,isMould,self.m_type})
        elseif i == 4 then
            cell = state_machine.excute("sm_role_information_controls_four_open",0,{self.shipData,isMould,self.m_type})
        elseif i== 5 then
            cell = state_machine.excute("sm_role_information_controls_six_open",0,{self.shipData,isMould,self.m_type})
        elseif i == 6 then
            cell = state_machine.excute("sm_role_information_controls_fives_open",0,{self.shipData,isMould,self.m_type})
        end
        
        H_height = H_height + cell.roots[1]:getContentSize().height
        if H_height > Panel_cell:getContentSize().height then
            Panel_cell:setContentSize(cc.size(Panel_cell:getContentSize().width, H_height))
            if Image_cell ~= nil then
                Image_cell:setContentSize(cc.size(Image_cell:getContentSize().width, H_height))
            end
        end
        if Panel_cell:getChildByTag(5000+i) ~= nil then
            Panel_cell:removeChildByTag(5000+i)
        end

        cell:setTag(5000+i)
        Panel_cell:addChild(cell)

        -- C_height = C_height + cell.roots[1]:getContentSize().height
        -- cell:setPositionY(layer:getContentSize().height-C_height)
    end
    for i = 1, 6 do
        local cell = Panel_cell:getChildByTag(5000+i)
        C_height = C_height + cell.roots[1]:getContentSize().height
        cell:setPositionY(Panel_cell:getContentSize().height-C_height)
    end

    m_ScrollView:setInnerContainerSize(cc.size(m_ScrollView:getContentSize().width, Panel_cell:getContentSize().height))
    --m_ScrollView:jumpToTop()
    local currShip = self.shipData--getShipByTalent(self.shipData)
    local x = 1
    local Text_gj_0 = ccui.Helper:seekWidgetByName(root, "Text_gj_0")   --攻
    Text_gj_0:setString(currShip.ship_courage)
    local Text_fy_0 = ccui.Helper:seekWidgetByName(root, "Text_fy_0")   --防
    Text_fy_0:setString(currShip.ship_intellect)
    local Text_sm_0 = ccui.Helper:seekWidgetByName(root, "Text_sm_0")   --血
    Text_sm_0:setString(currShip.ship_health)
    local Text_bj_0 = ccui.Helper:seekWidgetByName(root, "Text_bj_0")   --暴击率
    local initial_critical = 0--dms.string(dms["ship_mould"], self.shipData.ship_template_id, ship_mould.initial_critical)
    Text_bj_0:setString((tonumber(initial_critical)*100 + currShip.crit_add).."%")
    local Text_bsjc_0 = ccui.Helper:seekWidgetByName(root, "Text_bsjc_0")--暴击加成
    local initial_jink = 0--dms.string(dms["ship_mould"], self.shipData.ship_template_id, ship_mould.initial_jink)
    Text_bsjc_0:setString((tonumber(initial_jink)*100 + currShip.crit_hurt_add).."%")
    local Text_kbl_0 = ccui.Helper:seekWidgetByName(root, "Text_kbl_0") --抗暴率
    local initial_critical_resist = 0--dms.string(dms["ship_mould"], self.shipData.ship_template_id, ship_mould.initial_critical_resist)
    Text_kbl_0:setString((tonumber(initial_critical_resist)*100 + currShip.uncrit_add).."%")
    local Text_gdl_0 = ccui.Helper:seekWidgetByName(root, "Text_gdl_0") --格挡率
    local initial_retain = 0--dms.string(dms["ship_mould"], self.shipData.ship_template_id, ship_mould.initial_retain)
    Text_gdl_0:setString((tonumber(initial_retain)*100 + currShip.parry_add).."%")
    local Text_gdjc_0 = ccui.Helper:seekWidgetByName(root, "Text_gdjc_0")--格挡加成
    local initial_accuracy = 0--dms.string(dms["ship_mould"], self.shipData.ship_template_id, ship_mould.initial_accuracy)
    Text_gdjc_0:setString((tonumber(initial_accuracy)*100 + currShip.parry_unhurt_add).."%")
    local Text_pgdl_0 = ccui.Helper:seekWidgetByName(root, "Text_pgdl_0")--破格挡率
    local initial_retain_break = 0--dms.string(dms["ship_mould"], self.shipData.ship_template_id, ship_mould.initial_retain_break)
    Text_pgdl_0:setString(((tonumber(initial_retain_break)*100 + currShip.unparry_add)).."%")
    local Text_shjc_0 = ccui.Helper:seekWidgetByName(root, "Text_shjc_0")--伤害加成
    local leader = 0--dms.string(dms["ship_mould"], self.shipData.ship_template_id, ship_mould.leader)
    Text_shjc_0:setString((tonumber(leader)*100 + currShip.hurt_add).."%")
    local Text_shjm_0 = ccui.Helper:seekWidgetByName(root, "Text_shjm_0")--伤害减免
    local force = 0--dms.string(dms["ship_mould"], self.shipData.ship_template_id, ship_mould.force)
    Text_shjm_0:setString((tonumber(force)*100 + currShip.unhurt_add).."%")

    if ccui.Helper:seekWidgetByName(root, "Button_5") ~= nil then
        if zstring.tonumber(_ED.server_review) ~= 1 then  -- 1评审, 其他非
            if tonumber(self.m_RoleId) == tonumber(_ED.user_info.user_id) then
                ccui.Helper:seekWidgetByName(root, "Button_5"):setVisible(true)
            else
                ccui.Helper:seekWidgetByName(root, "Button_5"):setVisible(false)
            end
        else
            ccui.Helper:seekWidgetByName(root, "Button_5"):setVisible(false)
        end
    end
end

function SmRoleInformation:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    --ccui.Helper:seekWidgetByName(root, "Button_5"):setVisible(false)
    --贴卡牌
    local Panel_digimon_card = ccui.Helper:seekWidgetByName(root, "Panel_digimon_card")
    Panel_digimon_card:removeAllChildren(true)
    self.shipData = nil
    for i, v in pairs(_ED.user_ship) do
        if tonumber(v.ship_template_id) == tonumber(self.ship_id) then
            self.shipData = v
            break
        end
    end
    if self.shipData and self.shipData.ship_template_id then
        local evo_image = dms.string(dms["ship_mould"], self.shipData.ship_template_id, ship_mould.fitSkillTwo)
        local evo_info = zstring.split(evo_image, ",")
        local evo_mould_id = evo_info[dms.int(dms["ship_mould"], self.shipData.ship_template_id, ship_mould.captain_name)]
        --local FB_share = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.Kill_feature)
        if ccui.Helper:seekWidgetByName(root, "Button_5") ~= nil then
            if zstring.tonumber(_ED.server_review) ~= 1 then  -- 1评审, 其他非
                -- if FB_share == 1 then
                --     ccui.Helper:seekWidgetByName(root, "Button_5"):setVisible(true)
                -- else
                --     ccui.Helper:seekWidgetByName(root, "Button_5"):setVisible(false)
                -- end
                ccui.Helper:seekWidgetByName(root, "Button_5"):setVisible(true)
            else
                ccui.Helper:seekWidgetByName(root, "Button_5"):setVisible(false)
            end
        end
    end
    --nil表示是没有获得的武将
    local isMould = false
    if self.shipData ~= nil then
        state_machine.excute("sm_generals_card_open",0,{Panel_digimon_card,false,false,self.shipData.ship_id,isMould})
    else
        isMould = true
        state_machine.excute("sm_generals_card_open",0,{Panel_digimon_card,true,false,self.ship_id,isMould})
    end

    --滚动信息
    local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_digimon_info")
    local Panel_cell = ccui.Helper:seekWidgetByName(root, "Panel_cell")
    local Image_cell = ccui.Helper:seekWidgetByName(root, "Image_cell")
    -- Image_cell:setVisible(false)

    local H_height = 0
    local C_height = 10
    for i= 1, 6 do
        local cell = nil
        if i == 1 then
            cell = state_machine.excute("sm_role_information_controls_one_open",0,{self.ship_id,isMould})
        elseif i == 2 then
            cell = state_machine.excute("sm_role_information_controls_two_open",0,{self.ship_id,isMould})
        elseif i == 3 then
            cell = state_machine.excute("sm_role_information_controls_three_open",0,{self.ship_id,isMould})
        elseif i == 4 then
            cell = state_machine.excute("sm_role_information_controls_four_open",0,{self.ship_id,isMould})
        elseif i == 5 then
            cell = state_machine.excute("sm_role_information_controls_six_open",0,{self.ship_id,isMould})
        elseif i == 6 then
            cell = state_machine.excute("sm_role_information_controls_fives_open",0,{self.ship_id,isMould})
        end
        
        H_height = H_height + cell.roots[1]:getContentSize().height
        if H_height > Panel_cell:getContentSize().height then
            Panel_cell:setContentSize(cc.size(Panel_cell:getContentSize().width, H_height))
            if Image_cell ~= nil then
                Image_cell:setContentSize(cc.size(Image_cell:getContentSize().width, H_height))
            end
        end
        if Panel_cell:getChildByTag(5000+i) ~= nil then
            Panel_cell:removeChildByTag(5000+i)
        end

        cell:setTag(5000+i)
        Panel_cell:addChild(cell)

        -- C_height = C_height + cell.roots[1]:getContentSize().height
        -- cell:setPositionY(layer:getContentSize().height-C_height)
    end
    for i = 1, 6 do
        local cell = Panel_cell:getChildByTag(5000+i)
        C_height = C_height + cell.roots[1]:getContentSize().height
        cell:setPositionY(Panel_cell:getContentSize().height-C_height)
    end

    m_ScrollView:setInnerContainerSize(cc.size(m_ScrollView:getContentSize().width, Panel_cell:getContentSize().height))
    --m_ScrollView:jumpToTop()

    local currShip = nil
    local Text_gj_0 = ccui.Helper:seekWidgetByName(root, "Text_gj_0")   --攻
    if self.shipData == nil then
        local initial_courage = dms.string(dms["ship_mould"], self.ship_id, ship_mould.initial_courage)
        Text_gj_0:setString(initial_courage)
    else
        currShip = getShipByTalent(self.shipData) 
        Text_gj_0:setString(currShip.ship_courage)
    end
    local Text_fy_0 = ccui.Helper:seekWidgetByName(root, "Text_fy_0")   --防
    if self.shipData == nil then
        local initial_intellect = dms.string(dms["ship_mould"], self.ship_id, ship_mould.initial_intellect)
        Text_fy_0:setString(initial_intellect)
    else
        Text_fy_0:setString(currShip.ship_intellect)
    end
    local Text_sm_0 = ccui.Helper:seekWidgetByName(root, "Text_sm_0")   --血
    if self.shipData == nil then
        local initial_power = dms.string(dms["ship_mould"], self.ship_id, ship_mould.initial_power)
        Text_sm_0:setString(initial_power)
    else
        Text_sm_0:setString(currShip.ship_health)
    end
    local Text_bj_0 = ccui.Helper:seekWidgetByName(root, "Text_bj_0")   --暴击率
    local initial_critical = 0--dms.string(dms["ship_mould"], self.ship_id, ship_mould.initial_critical)
    if self.shipData == nil then
        initial_critical = dms.string(dms["ship_mould"], self.ship_id, ship_mould.initial_critical)
        Text_bj_0:setString((tonumber(initial_critical)*100).."%")
    else
        Text_bj_0:setString((tonumber(initial_critical)*100 + currShip.crit_add).."%")
    end
    local Text_bsjc_0 = ccui.Helper:seekWidgetByName(root, "Text_bsjc_0")--暴击加成
    local initial_jink = 0--dms.string(dms["ship_mould"], self.ship_id, ship_mould.initial_jink)
    if self.shipData == nil then
        initial_jink = dms.string(dms["ship_mould"], self.ship_id, ship_mould.initial_jink)
        Text_bsjc_0:setString((tonumber(initial_jink)*100).."%")
    else
        Text_bsjc_0:setString((tonumber(initial_jink)*100 + currShip.crit_hurt_add).."%")
    end
    local Text_kbl_0 = ccui.Helper:seekWidgetByName(root, "Text_kbl_0") --抗暴率
    local initial_critical_resist = 0--dms.string(dms["ship_mould"], self.ship_id, ship_mould.initial_critical_resist)
    if self.shipData == nil then
        initial_critical_resist = dms.string(dms["ship_mould"], self.ship_id, ship_mould.initial_critical_resist)
        Text_kbl_0:setString((tonumber(initial_critical_resist)*100).."%")
    else
        Text_kbl_0:setString((tonumber(initial_critical_resist*100) + currShip.uncrit_add).."%")
    end
    local Text_gdl_0 = ccui.Helper:seekWidgetByName(root, "Text_gdl_0") --格挡率
    local initial_retain = 0--dms.string(dms["ship_mould"], self.ship_id, ship_mould.initial_retain)
    if self.shipData == nil then
        initial_retain = dms.string(dms["ship_mould"], self.ship_id, ship_mould.initial_retain)
        Text_gdl_0:setString((tonumber(initial_retain)*100).."%")
    else
        Text_gdl_0:setString((tonumber(initial_retain)*100 + currShip.parry_add).."%")
    end
    local Text_gdjc_0 = ccui.Helper:seekWidgetByName(root, "Text_gdjc_0")--格挡加成
    local initial_accuracy = 0--dms.string(dms["ship_mould"], self.ship_id, ship_mould.initial_accuracy)
    if self.shipData == nil then
        initial_accuracy = dms.string(dms["ship_mould"], self.ship_id, ship_mould.initial_accuracy)
        Text_gdjc_0:setString((tonumber(initial_accuracy)*100).."%")
    else
        Text_gdjc_0:setString((tonumber(initial_accuracy)*100 + currShip.parry_unhurt_add).."%")
    end
    local Text_pgdl_0 = ccui.Helper:seekWidgetByName(root, "Text_pgdl_0")--破格挡率
    local initial_retain_break = 0--dms.string(dms["ship_mould"], self.ship_id, ship_mould.initial_retain_break)
    if self.shipData == nil then
        initial_retain_break = dms.string(dms["ship_mould"], self.ship_id, ship_mould.initial_retain_break)
        Text_pgdl_0:setString((tonumber(initial_retain_break)*100).."%")
    else
        Text_pgdl_0:setString((tonumber(initial_retain_break)*100 + currShip.unparry_add).."%")
    end
    local Text_shjc_0 = ccui.Helper:seekWidgetByName(root, "Text_shjc_0")--伤害加成
    local leader = 0--dms.string(dms["ship_mould"],  self.ship_id, ship_mould.leader)
    if self.shipData == nil then
        leader = dms.string(dms["ship_mould"],  self.ship_id, ship_mould.leader)
        Text_shjc_0:setString((tonumber(leader)*100).."%")
    else
        Text_shjc_0:setString((tonumber(leader)*100 + currShip.hurt_add).."%")
    end
    local Text_shjm_0 = ccui.Helper:seekWidgetByName(root, "Text_shjm_0")--伤害减免
    local force = 0--dms.string(dms["ship_mould"],  self.ship_id, ship_mould.force)
    if self.shipData == nil then
        force = dms.string(dms["ship_mould"],  self.ship_id, ship_mould.force)
        Text_shjm_0:setString((tonumber(force)*100).."%")
    else
        Text_shjm_0:setString((tonumber(force)*100 + currShip.unhurt_add).."%")
    end

end

function SmRoleInformation:init(params)
    --模板id
    self.ship_id = params[1]
    self.m_type = params[2] or nil
    self._chooseIndex = params[3] or 0

    self.m_RoleId = params[4] or 0

    self:onInit()
    return self
end

function SmRoleInformation:onInit()
    local csbSmRoleInformation = csb.createNode("packs/HeroStorage/generals_information_1.csb")
    local root = csbSmRoleInformation:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmRoleInformation)
    local action = csb.createTimeline("packs/HeroStorage/generals_information_1.csb")
    table.insert(self.actions, action)
    csbSmRoleInformation:runAction(action)
	if zstring.tonumber(self.m_type) == -1 then
        self:otherOnUpdateDraw()
    else
        self:onUpdateDraw()
    end
    
    local Panel_21 = ccui.Helper:seekWidgetByName(root,"Panel_21")
    local PageView_1 = ccui.Helper:seekWidgetByName(root,"PageView_1")
    Panel_21:setSwallowTouches(false)
    PageView_1:setSwallowTouches(false)
    if self.m_type ~= nil and tonumber(self.m_type) == 1 then
        if zstring.tonumber(self._chooseIndex) > 0 then
            ccui.Helper:seekWidgetByName(root,"Button_arrow_l"):setVisible(true)
            ccui.Helper:seekWidgetByName(root,"Button_arrow_r"):setVisible(true)
            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_arrow_l"), nil, 
            {
                terminal_name = "sm_role_information_update_show_left",
                terminal_state = 0,
                touch_black = true,
            },
            nil,0)
            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_arrow_r"), nil, 
            {
                terminal_name = "sm_role_information_update_show_right",
                terminal_state = 0,
                touch_black = true,
            },
            nil,0)
        else
            local index = 0
            self.formetion_status = {}
            for i, v in pairs(_ED.user_formetion_status) do
                if zstring.tonumber(v) > 0 then
                    index = index + 1
                    table.insert(self.formetion_status, v)
                end
            end
            if index > 1 then
                ccui.Helper:seekWidgetByName(root,"Button_arrow_l"):setVisible(true)
                ccui.Helper:seekWidgetByName(root,"Button_arrow_r"):setVisible(true)
                fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_arrow_l"), nil, 
                {
                    terminal_name = "sm_role_information_update_show_left",
                    terminal_state = 0,
                    touch_black = true,
                },
                nil,0)
                fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_arrow_r"), nil, 
                {
                    terminal_name = "sm_role_information_update_show_right",
                    terminal_state = 0,
                    touch_black = true,
                },
                nil,0)
            end
        end
    else
        ccui.Helper:seekWidgetByName(root,"Button_arrow_l"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Button_arrow_r"):setVisible(false)
    end

    --属性提示
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_tip"), nil, 
    {
        terminal_name = "sm_role_information_tip_open",
        terminal_state = 0,
        touch_black = true,
    },
    nil,0)
    -- self:showImageAnimation()
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_1077"), nil, 
    {
        terminal_name = "sm_role_information_close_and_show",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_1077"), nil, 
    {
        terminal_name = "sm_role_information_close_and_show",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)

    if ccui.Helper:seekWidgetByName(root, "Button_5") ~= nil then
        ccui.Helper:seekWidgetByName(self.roots[1], "Button_5"):setTouchEnabled(true)
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_5"), nil, {
            terminal_name = "share_click_on", 
            terminal_state = 0
            }, nil, 3)
    end

    -- if ccui.Helper:seekWidgetByName(root, "Button_5") ~= nil then
    --     if zstring.tonumber(_ED.server_review) ~= 1 then  -- 1评审, 其他非
    --         ccui.Helper:seekWidgetByName(root, "Button_5"):setVisible(true)
    --     else
    --         ccui.Helper:seekWidgetByName(root, "Button_5"):setVisible(false)
    --     end
    -- end
end

function SmRoleInformation:onExit()
    state_machine.remove("sm_role_information_display")
    state_machine.remove("sm_role_information_hide")
end