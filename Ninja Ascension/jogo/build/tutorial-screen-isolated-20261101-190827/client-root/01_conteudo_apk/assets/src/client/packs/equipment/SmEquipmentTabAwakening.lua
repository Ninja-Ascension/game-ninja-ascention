-- ----------------------------------------------------------------------------------------------------
-- 说明：装备觉醒
-------------------------------------------------------------------------------------------------------
SmEquipmentTabAwakening = class("SmEquipmentTabAwakeningClass", Window)

local sm_equipment_tab_awakening_open_terminal = {
    _name = "sm_equipment_tab_awakening_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmEquipmentTabAwakeningClass")
        if nil == _homeWindow then
            local panel = SmEquipmentTabAwakening:new():init(params)
            fwin:open(panel)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_equipment_tab_awakening_close_terminal = {
    _name = "sm_equipment_tab_awakening_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmEquipmentTabAwakeningClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmEquipmentTabAwakeningClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_equipment_tab_awakening_open_terminal)
state_machine.add(sm_equipment_tab_awakening_close_terminal)
state_machine.init()
    
function SmEquipmentTabAwakening:ctor()
    self.super:ctor()
    self.roots = {}
    self.equip = nil
    self.materialEnough = true
    self.isFetters = 0
    app.load("client.cells.prop.prop_icon_new_cell")
    app.load("client.packs.equipment.SmEquipStarUpSuccessWindow")
    app.load("client.cells.equip.equip_icon_cell")

    local function init_sm_equipment_tab_awakening_terminal()
        -- 显示界面
        local sm_equipment_tab_awakening_display_terminal = {
            _name = "sm_equipment_tab_awakening_display",
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

        -- 隐藏界面
        local sm_equipment_tab_awakening_hide_terminal = {
            _name = "sm_equipment_tab_awakening_hide",
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

        -- 刷新
        local sm_equipment_tab_awakening_update_draw_terminal = {
            _name = "sm_equipment_tab_awakening_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDraw()
                instance:drawWretchedAwakening()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 改变id
        local sm_equipment_tab_awakening_change_ship_terminal = {
            _name = "sm_equipment_tab_awakening_change_ship",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.equip = params
                state_machine.excute("sm_equipment_tab_awakening_update_draw",0,"")
                state_machine.excute("notification_center_update",0,"push_notification_center_formation_equipment_awakening")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --觉醒
        local sm_equipment_tab_awakening_treasure_upgrade_terminal = {
            _name = "sm_equipment_tab_awakening_treasure_upgrade",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.materialEnough == false then
                    TipDlg.drawTextDailog(_new_interface_text[27])
                    return
                end
                state_machine.lock("sm_equipment_tab_awakening_treasure_upgrade")
                local old_template = instance.equip.user_equiment_template
                local function responseEquipmentEscalateCallback(response)
                    local equipData = _ED.user_ship[""..instance.equip.ship_id].equipInfo
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            setShipPushData(instance.equip.ship_id,9,instance.equip.m_index)
                            if dms.int(dms["equipment_mould"], instance.equip.user_equiment_template, equipment_mould.equipment_seat) ~= -1 then
                                instance.equip.user_equiment_template = dms.int(dms["equipment_mould"], instance.equip.user_equiment_template, equipment_mould.equipment_seat)
                            else
                                instance.equip.user_equiment_template = instance.equip.user_equiment_template
                            end
                            response.node:onUpdateDraw()
                            response.node:drawWretchedAwakening()
                            local newEquip = instance.equip
                            newEquip.quipInfo = _ED.user_ship[""..instance.equip.ship_id].equipInfo
                            newEquip.equipInfo = equipData
                            newEquip.old_template = old_template
                            state_machine.excute("equip_star_up_success_window_open",0,{newEquip,2})
                            state_machine.excute("sm_equipment_qianghua_to_update_equip_icon",0,"")
                            if fwin:find("HeroDevelopClass") ~= nil then
                                -- state_machine.excute("hero_develop_page_strength_to_update_ship", 0, _ED.user_ship[""..instance.equip.ship_id])
                                -- state_machine.excute("sm_equipment_qianghua_update_ship", 0, _ED.user_ship[""..ship_id])
                                -- state_machine.excute("sm_equipment_qianghua_update_ship_info", 0, nil)
                                -- state_machine.excute("sm_equipment_tab_up_product_update_draw", 0, nil)
                                state_machine.excute("hero_develop_back_to_update_specific_equip",0,instance.equip.m_index)
                                state_machine.excute("hero_develop_page_updata_hero_icon_push",0,".")
                            else
                                if fwin:find("SmEquipmentQianghuaClass") == nil or fwin:find("FormationTigerGateClass") then
                                    for i, v in pairs(_ED.user_formetion_status) do
                                        if tonumber(v) == tonumber(instance.equip.ship_id) then
                                            state_machine.excute("formation_set_ship",0,_ED.user_ship[""..instance.equip.ship_id])
                                            break
                                        end
                                    end
                                end

                            end
                        end
                        state_machine.excute("notification_center_update",0,"push_notification_center_formation_equipment_awakening")
                        state_machine.excute("notification_center_update",0,"push_notification_center_formation_equipment_awakening_page_tips")
                        state_machine.excute("formation_update_equip_icon_push",0,"formation_update_equip_icon_push.")
                        state_machine.excute("hero_icon_listview_icon_push_updata",0,"")
                        state_machine.unlock("equip_icon_cell_change_ship_equip")
                        state_machine.unlock("formation_back_to_home_activity", 0, "")
                        -- 装备淬炼更新红点
                        state_machine.excute("notification_center_update",0,"push_notification_center_formation_equipment_harden_page_tips") 
                    else
                        state_machine.unlock("equip_icon_cell_change_ship_equip")
                        state_machine.unlock("formation_back_to_home_activity", 0, "")
                    end
                end
                state_machine.lock("equip_icon_cell_change_ship_equip")
                state_machine.lock("formation_back_to_home_activity", 0, "")
                protocol_command.equipment_up_star.param_list = instance.equip.ship_id .. "\r\n" ..instance.equip.m_index.. "\r\n"
                NetworkManager:register(protocol_command.equipment_up_star.code, nil, nil, nil, instance, responseEquipmentEscalateCallback,false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --降星
        local sm_equipment_tab_awakening_treasure_less_terminal = {
            _name = "sm_equipment_tab_awakening_treasure_less",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local ship_id = instance.equip.ship_id
                local function responseCallBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            local shipData = _ED.user_ship[""..ship_id]
                            local shipEquip = zstring.split(shipData.equipInfo, "|")
                            local starInfos = zstring.split(shipEquip[4], ",")
                            if tonumber(starInfos[response.node.equip.m_index]) < 1 then
                                response.node.equip.user_equiment_template = tonumber(zstring.split(dms.string(dms["ship_mould"], shipData.ship_template_id, ship_mould.treasureSkill), ",")[response.node.equip.m_index])
                            end
                            state_machine.excute("sm_equipment_qianghua_to_update_equip_icon",0,"")
                            if fwin:find("HeroDevelopClass") ~= nil then
                                -- state_machine.excute("hero_develop_page_strength_to_update_ship", 0, _ED.user_ship[""..ship_id])
                                -- state_machine.excute("sm_equipment_qianghua_update_ship", 0, _ED.user_ship[""..ship_id])
                                -- state_machine.excute("sm_equipment_qianghua_update_ship_info", 0, nil)
                                -- state_machine.excute("sm_equipment_tab_up_product_update_draw", 0, nil)
                                state_machine.excute("hero_develop_back_to_update_specific_equip",0,response.node.equip.m_index)
                            else
                                for i, v in pairs(_ED.user_formetion_status) do
                                    if tonumber(v) == tonumber(response.node.equip.ship_id) then
                                        state_machine.excute("formation_set_ship",0,_ED.user_ship[""..response.node.equip.ship_id])
                                        break
                                    end
                                end
                            end
                            for i,v in pairs(_ED.user_ship) do
                                for k=1,6 do
                                    setShipPushData(v.ship_id, 9, k)
                                end
                            end
                            state_machine.excute("sm_equipment_tab_awakening_update_draw",0,"")
                            state_machine.excute("formation_update_equip_icon_push",0,"formation_update_equip_icon_push.")
                            state_machine.excute("hero_icon_listview_icon_push_updata",0,"")
                            state_machine.excute("notification_center_update",0,"push_notification_center_formation_equipment_awakening")
                            state_machine.excute("notification_center_update",0,"push_notification_center_formation_equipment_awakening_page_tips")
                            -- 装备淬炼更新红点
                            state_machine.excute("notification_center_update",0,"push_notification_center_formation_equipment_harden_page_tips") 
                        end
                        app.load("client.reward.DrawRareReward")
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(7)
                        fwin:open(getRewardWnd, fwin._ui)
                    end
                end
                protocol_command.equipment_rebirth.param_list = ship_id.."\r\n4\r\n0\r\n"..instance.equip.m_index
                NetworkManager:register(protocol_command.equipment_rebirth.code, nil, nil, nil, instance, responseCallBack, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --降星tips
        local sm_equipment_tab_awakening_treasure_less_tip_terminal = {
            _name = "sm_equipment_tab_awakening_treasure_less_tip",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                app.load("client.utils.ResourceUpdateTips")
                local tip = ResourceUpdateTips:new()
                tip:init(3,_new_interface_text[282],"")
                fwin:open(tip,fwin._border)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_equipment_tab_awakening_display_terminal)
        state_machine.add(sm_equipment_tab_awakening_hide_terminal)
        state_machine.add(sm_equipment_tab_awakening_update_draw_terminal)
        state_machine.add(sm_equipment_tab_awakening_change_ship_terminal)
        state_machine.add(sm_equipment_tab_awakening_treasure_upgrade_terminal)
        state_machine.add(sm_equipment_tab_awakening_treasure_less_terminal)
        state_machine.add(sm_equipment_tab_awakening_treasure_less_tip_terminal)
        state_machine.init()
    end
    init_sm_equipment_tab_awakening_terminal()
end

function SmEquipmentTabAwakening:onHide()
    self:setVisible(false)
end

function SmEquipmentTabAwakening:onShow()
    self:setVisible(true)
end


function SmEquipmentTabAwakening:createEquipHead(objectType,ship)
    local cell = EquipIconCell:createCell()
    cell:init(objectType,ship)
    return cell
end

--羁绊的觉醒绘制
function SmEquipmentTabAwakening:drawWretchedAwakening()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    if self.equip == nil then
        return
    end
    self.isFetters = 0
    --无羁绊描述
    local Text_jx_juexing_info = ccui.Helper:seekWidgetByName(root, "Text_jx_juexing_info")
    --羁绊名称
    local Text_jx_skill_name = ccui.Helper:seekWidgetByName(root, "Text_jx_skill_name")
    --羁绊描述
    local Text_jx_skill_info = ccui.Helper:seekWidgetByName(root, "Text_jx_skill_info")

    --找到对应的装备是可以激活羁绊的
    local fetters_id = nil    --天赋id
    local ship_id = self.equip.ship_id
    local shipData = _ED.user_ship[""..ship_id]
    local myRelatioInfo = zstring.zsplit(dms.string(dms["ship_mould"], shipData.ship_template_id, ship_mould.relationship_id), ",")
    local ship_list = {}
    local activation_list = {}
    for i, v in pairs(myRelatioInfo) do
        self.isFetters = 0
        local ship_list = {}
        local activation_list = {}
        for j=1, 6 do
            local needId = dms.int(dms["fate_relationship_mould"], v, j+4+(j-1)*2-j)
            if needId > 0 then
                if self.isFetters == 0 then
                    local needType = dms.int(dms["fate_relationship_mould"], v, j+4+(j-1)*2-j+1)
                    if needType == 1 then
                        local isSame = false
                        self.isFetters = 0
                        if needId == tonumber(self.equip.user_equiment_template) then
                            --已经激活了
                            self.isFetters = 2 
                            fetters_id = v
                            isSame = true
                        end
                        if self.isFetters ~= 2 then
                            if dms.int(dms["equipment_mould"], self.equip.user_equiment_template, equipment_mould.equipment_seat) == needId then
                                --还没激活
                                self.isFetters = 1
                                fetters_id = v
                                isSame = false
                            end
                        end
                        if self.isFetters > 0 then
                            local nameindex = dms.int(dms["equipment_mould"], needId, equipment_mould.equipment_name)
                            local word_info = dms.element(dms["word_mould"], nameindex)
                            if isSame == true then
                                table.insert(ship_list, "%|3|"..word_info[3].."%")
                                table.insert(activation_list, 1)
                            else
                                table.insert(ship_list, "%|2|"..word_info[3].."%")
                            end
                            break
                        end
                    end
                end
            end
        end

        local waken_count = 0
        if self.isFetters > 0 then
            for j = 1, 6 do
                local needId = dms.int(dms["fate_relationship_mould"], v, j+4+(j-1)*2-j)
                if needId > 0 then
                    waken_count = waken_count + 1
                end
            end
        end

        if self.isFetters > 0 and waken_count == 1 then
            for j=1,2 do
                if dms.int(dms["fate_relationship_mould"], v, 15+j) > 0 then
                    local addition = dms.int(dms["fate_relationship_mould"], v, 15+j)
                    table.insert(ship_list, addition.."%")
                    table.insert(activation_list, 1)
                end
            end
            local describe = dms.string(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_describe)
            local strs = zstring.split(describe, "|")
            describe = ""
            if #strs > 1 then
                for j, v in pairs(strs) do
                    if zstring.tonumber(v) ~= nil then
                        local word_info = dms.element(dms["word_mould"], zstring.tonumber(v))
                        describe = describe .. word_info[3]
                    else
                        describe = describe .. v
                    end
                end
            else
                if zstring.tonumber(strs[1]) ~= nil then
                    local word_info = dms.element(dms["word_mould"], zstring.tonumber(strs[1]))
                    describe = word_info[3] 
                else
                    describe = strs[1]
                end
            end
            if #ship_list == 1 then
                describe = string.format(describe, ship_list[1])
            elseif #ship_list == 2 then
                describe = string.format(describe, ship_list[1],ship_list[2])
            elseif #ship_list == 3 then
                describe = string.format(describe, ship_list[1],ship_list[2],ship_list[3])
            elseif #ship_list == 4 then
                describe = string.format(describe, ship_list[1],ship_list[2],ship_list[3],ship_list[4])
            elseif #ship_list == 5 then
                describe = string.format(describe, ship_list[1],ship_list[2],ship_list[3],ship_list[4],ship_list[5])
            elseif #ship_list == 6 then
                describe = string.format(describe, ship_list[1],ship_list[2],ship_list[3],ship_list[4],ship_list[5],ship_list[6])
            elseif #ship_list == 7 then
                describe = string.format(describe, ship_list[1],ship_list[2],ship_list[3],ship_list[4],ship_list[5],ship_list[6],ship_list[7])
            end
            Text_jx_skill_info:removeAllChildren(true)
            local _richText2 = ccui.RichText:create()
            _richText2:ignoreContentAdaptWithSize(false)

            local richTextWidth = Text_jx_skill_info:getContentSize().width
            if richTextWidth == 0 then
                richTextWidth = Text_jx_skill_info:getFontSize() * 6
            end
                
            _richText2:setContentSize(cc.size(richTextWidth,Text_jx_skill_info:getContentSize().height))
            _richText2:setAnchorPoint(cc.p(0, 0))

            if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                color_Type_1 = cc.c3b(71,71,71)
                color_Type_2 = cc.c3b(71,71,71)
            else
                color_Type_1 = cc.c3b(255,255,255)
                color_Type_2 = cc.c3b(255,255,255)
            end

            local char_str = describe
            
            local rt, count, text = draw.richTextCollectionMethod(_richText2, 
                char_str, 
                color_Type_1,
                color_Type_2,
                0, 
                0, 
                Text_jx_skill_info:getFontName(), 
                Text_jx_skill_info:getFontSize(),
                the_color_of_the_fetters)
            _richText2:formatTextExt()
            local rsize = _richText2:getContentSize()
            _richText2:setPosition(cc.p(0,0))
            Text_jx_skill_info:addChild(_richText2)

            local colors = nil
            if #ship_list == 0 then
                    colors = the_color_of_the_fetters[3]
            else
                if #ship_list == #activation_list then
                    colors = the_color_of_the_fetters[4]
                else
                    colors = the_color_of_the_fetters[3]
                end
            end
            if fetters_id ~= nil then
                local name = dms.string(dms["fate_relationship_mould"], fetters_id, fate_relationship_mould.relation_name)
                local name_datas = dms.element(dms["word_mould"], zstring.tonumber(name))
                name = name_datas[3]
                Text_jx_skill_name:setString(name)
                Text_jx_skill_name:setColor(colors)
            end
            
            break
        end
    end
    for i=1, 3 do
        local Image_juexing_tip = ccui.Helper:seekWidgetByName(self.roots[1], "Image_juexing_tip_"..i)
        if i == self.isFetters + 1 then
            Image_juexing_tip:setVisible(true)
        else
            Image_juexing_tip:setVisible(false)
        end
    end

    if self.isFetters == 0 then
        --没有天赋
        Text_jx_juexing_info:setVisible(true)
        Text_jx_skill_name:setVisible(false)
        Text_jx_skill_info:setVisible(false)
    elseif self.isFetters == 1 then
        --没有激活
        Text_jx_juexing_info:setVisible(false)
        Text_jx_skill_name:setVisible(true)
        Text_jx_skill_info:setVisible(true)
    elseif self.isFetters == 2 then
        --已经激活
        Text_jx_juexing_info:setVisible(false)
        Text_jx_skill_name:setVisible(true)
        Text_jx_skill_info:setVisible(true)
    end
end

function SmEquipmentTabAwakening:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    if self.equip == nil then
        return
    end

    local ship_id = self.equip.ship_id
    local shipData = _ED.user_ship[""..ship_id]

    --武将装备数据（等级|品质|经验|星级|觉醒后模板ID）
    local shipEquip = zstring.split(shipData.equipInfo, "|")

    --装备位
    local e_index = self.equip.m_index

    local newEquip = {}
    --装备模板id
    if dms.int(dms["equipment_mould"], self.equip.user_equiment_template, equipment_mould.equipment_seat) ~= -1 then
        newEquip.user_equiment_template = dms.int(dms["equipment_mould"], self.equip.user_equiment_template, equipment_mould.equipment_seat)
    else
        newEquip.user_equiment_template = self.equip.user_equiment_template
    end

    --装备等级
    newEquip.user_equiment_grade = self.equip.user_equiment_grade
    --所属战船
    newEquip.ship_id = self.equip.ship_id
    --所属编号
    newEquip.m_index = self.equip.m_index

    local newGrade = zstring.split(shipEquip[2], ",")

    local newStar = zstring.split(shipEquip[4], ",")

    local levels = zstring.split(shipEquip[1], ",")

    for j=1,4 do
        ccui.Helper:seekWidgetByName(self.roots[1], "Text_equ_attribute_"..j):setVisible(false)
        ccui.Helper:seekWidgetByName(self.roots[1], "Text_equ_attribute_n_"..j):setVisible(false)
    end
        
    for i=1,2 do
        --图标
        local Panel_equ_up_quality_box = ccui.Helper:seekWidgetByName(root,"Panel_equ_up_quality_box_"..i)
        Panel_equ_up_quality_box:removeAllChildren(true)
        local cell = nil
        if i == 2 then
            cell = self:createEquipHead(2,newEquip)
        else
            self.equip.isShowLv = nil
            cell = self:createEquipHead(2,self.equip)
        end
        Panel_equ_up_quality_box:addChild(cell)
        if i == 2 then
            local star_number = tonumber(newStar[tonumber(e_index)])+1
            if star_number >= dms.int(dms["equipment_config"],7,equipment_config.param) then
                star_number = dms.int(dms["equipment_config"],7,equipment_config.param)
            end
            neWshowShipStar(ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_star"), star_number)
        else
            neWshowShipStar(ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_star"), tonumber(newStar[tonumber(e_index)]))
        end

        --名称
        local Text_equ_name = ccui.Helper:seekWidgetByName(root,"Text_equ_name_"..i)

        --获取装备名称索引
        local nameindex = 0
        if i == 2 then
            nameindex = dms.int(dms["equipment_mould"], newEquip.user_equiment_template, equipment_mould.equipment_name)
        else
            nameindex = dms.int(dms["equipment_mould"], self.equip.user_equiment_template, equipment_mould.equipment_name)
        end
        --通过索引找到word_mould
        local word_info = dms.element(dms["word_mould"], nameindex)
        local name = word_info[3]

        if getShipNameOrder(tonumber(newGrade[tonumber(e_index)])) > 0 then
            name = name.."+"..getShipNameOrder(tonumber(newGrade[tonumber(e_index)]))
        end
        Text_equ_name:setString(name)
        local quality = 1
        quality = shipOrEquipSetColour(tonumber(newGrade[tonumber(e_index)]))
        local color_R = tipStringInfo_quality_color_Type[quality][1]
        local color_G = tipStringInfo_quality_color_Type[quality][2]
        local color_B = tipStringInfo_quality_color_Type[quality][3]
        Text_equ_name:setColor(cc.c3b(color_R, color_G, color_B))

        local baseValue = nil
        local index = 0
        local equipAttributes = nil
        if i == 2 then
            index = 2
            baseValue = dms.string(dms["equipment_mould"], newEquip.user_equiment_template, equipment_mould.initial_value)
            local stars = tonumber(newStar[tonumber(e_index)])+1
            if stars >= dms.int(dms["equipment_config"],7,equipment_config.param) then
                stars = dms.int(dms["equipment_config"],7,equipment_config.param)
            end
            equipAttributes = equipmentPropertyCalculationFormula(newEquip.user_equiment_template,tonumber(newGrade[tonumber(e_index)]),stars,tonumber(levels[tonumber(e_index)]))
        else
            index = 0
            baseValue = dms.string(dms["equipment_mould"], self.equip.user_equiment_template, equipment_mould.initial_value)
            equipAttributes = equipmentPropertyCalculationFormula(self.equip.user_equiment_template,tonumber(newGrade[tonumber(e_index)]),tonumber(newStar[tonumber(e_index)]),tonumber(levels[tonumber(e_index)]))
        end
        
        local valueList = zstring.split(baseValue, "|")
        for j, v in pairs(valueList) do
            index = index + 1
            local Text_equ_attribute_n = ccui.Helper:seekWidgetByName(self.roots[1], "Text_equ_attribute_n_"..index)
            local Text_equ_attribute = ccui.Helper:seekWidgetByName(self.roots[1], "Text_equ_attribute_"..index)
            Text_equ_attribute_n:setVisible(true)
            Text_equ_attribute:setVisible(true)

            local attributeList = zstring.split(v, ",")
            local typeIndex = tonumber(attributeList[1]) + 1
            --判断是否追加百分比符号---------------------------------------------------------------------------
            local addPercent = ""   
            if typeIndex >= 5 and typeIndex <= 18 then
                addPercent = "%"
            elseif typeIndex >= 34 and typeIndex <= 35 then
                addPercent = "%"
            end
            Text_equ_attribute:setString(string_equiprety_name[typeIndex])
            -- Text_equ_attribute_n:setString(attributeList[2])
            Text_equ_attribute_n:setString("+"..equipAttributes[j]..addPercent)
        end

    end


    --觉醒需求
    local AkDemand = dms.int(dms["equipment_mould"], self.equip.user_equiment_template, equipment_mould.skill_mould)
    --找对应的库组

    local needResources = dms.searchs(dms["equipment_star"], equipment_star.group_id, AkDemand)
    local need_data = nil
    for i, v in pairs(needResources) do
        if tonumber(v[3]) == tonumber(newStar[tonumber(e_index)]) then
            need_data = v[6]
            break
        end
    end
    local need_info = zstring.split(need_data, "|")
    local numbers = 0
    local m_position = 0
    for i, v in pairs(need_info) do
        local needs = zstring.split(v, ",")
        if tonumber(needs[2]) ~= -1 then
            numbers = numbers + 1
            if m_position == 0 then
                m_position = i
            end
        end
    end
    self.materialEnough = true
    for i=1,2 do
        local Image_props_bg = ccui.Helper:seekWidgetByName(root,"Image_props_bg_"..i)
        local Panel_role_up_quality_box = ccui.Helper:seekWidgetByName(root,"Panel_role_up_quality_box_"..i)
        local Panel_role_up_quality_icon = ccui.Helper:seekWidgetByName(root,"Panel_role_up_quality_icon_"..i)
        local Image_role_up_quality_add = ccui.Helper:seekWidgetByName(root,"Image_role_up_quality_add_"..i)
        local Text_role_up_quality_num = ccui.Helper:seekWidgetByName(root,"Text_role_up_quality_num_"..i)
        Panel_role_up_quality_box:removeAllChildren(true)
        Image_props_bg:setVisible(false)
        if i > numbers then
            Panel_role_up_quality_box:setVisible(false)
            Panel_role_up_quality_icon:setVisible(false)
            Image_role_up_quality_add:setVisible(false)
            Text_role_up_quality_num:setVisible(false)
        else
            Image_props_bg:setVisible(true)
            Panel_role_up_quality_box:setVisible(true)
            Panel_role_up_quality_icon:setVisible(true)
            Image_role_up_quality_add:setVisible(true)
            Text_role_up_quality_num:setVisible(true)

            --绘制内容
            local needs = zstring.split(need_info[m_position+i-1], ",")
            if tonumber(needs[1]) == 6 then
                --道具
                local propMould = tonumber(needs[2])
                local propNumber = tonumber(needs[3])
                local existNumber = tonumber(getPropAllCountByMouldId(propMould))
                local cell = PropIconNewCell:createCell()
                if existNumber >= propNumber then
                    Image_role_up_quality_add:setVisible(false)
                    Panel_role_up_quality_icon:setVisible(false)
                    if __lua_project_id == __lua_project_l_digital and tipStringInfo_color_type_assemble then 
                        Text_role_up_quality_num:setColor(cc.c3b(tipStringInfo_color_type_assemble[8][1], tipStringInfo_color_type_assemble[8][2], tipStringInfo_color_type_assemble[8][3]))
                    else
                        Text_role_up_quality_num:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
                    end

                    cell:init(cell.enum_type._SHOW_PROP_GETWAY_INFORMATION, propMould)
                else
                    self.materialEnough = false
                    Image_role_up_quality_add:setVisible(true)
                    Panel_role_up_quality_icon:setVisible(true)
                    if __lua_project_id == __lua_project_l_digital and tipStringInfo_color_type_assemble then 
                        Text_role_up_quality_num:setColor(cc.c3b(tipStringInfo_color_type_assemble[7][1], tipStringInfo_color_type_assemble[7][2], tipStringInfo_color_type_assemble[7][3]))
                    else
                        Text_role_up_quality_num:setColor(cc.c3b(color_Type[5][1], color_Type[5][2], color_Type[5][3]))
                    end
                    cell:init(cell.enum_type._SHOW_PROP_GETWAY_INFORMATION, propMould,false,true)
                end
                Text_role_up_quality_num:setString(existNumber.."/"..propNumber)
                Panel_role_up_quality_box:addChild(cell)
            elseif tonumber(needs[1]) == 7 then
                --装备
                --道具
                local equipMould = tonumber(needs[2])
                local equipNumber = tonumber(needs[3])
                local existNumber = 0
                for i, v in pairs(_ED.user_equiment) do
                    if tonumber(v.user_equiment_template) == equipMould then
                        existNumber = existNumber + 1
                    end
                end
                local ShredMouldid = dms.int(dms["equipment_mould"], equipMould , equipment_mould.equipment_gem_numbers)
                local cell = EquipIconCell:createCell()
                local show_type = 0
                if ShredMouldid == -1 then
                    show_type = cell.enum_type._SHOW_EMBOITEMENT_GETWAY
                else
                    show_type = cell.enum_type._SHRED_INFO
                end
                if existNumber >= equipNumber then
                    Image_role_up_quality_add:setVisible(false)
                    Panel_role_up_quality_icon:setVisible(false)
                    if __lua_project_id == __lua_project_l_digital and tipStringInfo_color_type_assemble then 
                        Text_role_up_quality_num:setColor(cc.c3b(tipStringInfo_color_type_assemble[8][1], tipStringInfo_color_type_assemble[8][2], tipStringInfo_color_type_assemble[8][3]))
                    else
                        Text_role_up_quality_num:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
                    end
                    cell:init(show_type, nil, equipMould, nil)
                else
                    Image_props_bg:setVisible(false)
                    self.materialEnough = false
                    Image_role_up_quality_add:setVisible(true)
                    Panel_role_up_quality_icon:setVisible(false)
                    if __lua_project_id == __lua_project_l_digital and tipStringInfo_color_type_assemble then 
                        Text_role_up_quality_num:setColor(cc.c3b(tipStringInfo_color_type_assemble[7][1], tipStringInfo_color_type_assemble[7][2], tipStringInfo_color_type_assemble[7][3]))
                    else
                        Text_role_up_quality_num:setColor(cc.c3b(color_Type[5][1], color_Type[5][2], color_Type[5][3]))
                    end
                    cell:init(show_type, nil, equipMould, nil , nil , nil , true)
                end
                Text_role_up_quality_num:setString(existNumber.."/"..equipNumber)
                Panel_role_up_quality_box:addChild(cell)
            end
        end
    end

    local Button_equ_up_sp = ccui.Helper:seekWidgetByName(root,"Button_equ_up_sp")
    Button_equ_up_sp._data = self.equip
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_formation_equipment_awakening",
    _widget = Button_equ_up_sp,
    _invoke = nil,
    _interval = 0.5,})


    
    local Panel_btn_gx = ccui.Helper:seekWidgetByName(root,"Panel_btn_gx")
    Panel_btn_gx:removeAllChildren(true)

    local jsonFile = "sprite/sprite_faguang_btn.json"
    local atlasFile = "sprite/sprite_faguang_btn.atlas"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
    Panel_btn_gx:addChild(animation)

    local Panel_n_2 = ccui.Helper:seekWidgetByName(root,"Panel_n_2")
    local Text_juexing_lv_max = ccui.Helper:seekWidgetByName(root,"Text_juexing_lv_max")
    if tonumber(newStar[tonumber(e_index)]) >= dms.int(dms["equipment_config"],7,equipment_config.param) then
        Panel_n_2:setVisible(false)
        Text_juexing_lv_max:setVisible(true)
    else
        Panel_n_2:setVisible(true)
        Text_juexing_lv_max:setVisible(false)
    end

    local starInfos = zstring.split(shipEquip[4], ",")
    local Button_equ_up_sp_0 = ccui.Helper:seekWidgetByName(root, "Button_equ_up_sp_0")
    if Button_equ_up_sp_0 ~= nil then
        if tonumber(starInfos[e_index]) < 1 then
            Button_equ_up_sp_0:setVisible(false)
        else
            Button_equ_up_sp_0:setVisible(true)
        end
    end
end

function SmEquipmentTabAwakening:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow     
    self:onInit()
    return self
end

function SmEquipmentTabAwakening:onInit()
    local csbSmEquipmentTabAwakening = csb.createNode("packs/EquipStorage/sm_equipment_qianghua_tab_2.csb")
    local root = csbSmEquipmentTabAwakening:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmEquipmentTabAwakening)

    

    --觉醒请求
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1],"Button_equ_up_sp"), nil, 
    {
        terminal_name = "sm_equipment_tab_awakening_treasure_upgrade", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1],"Button_equ_up_sp_0"), nil, 
    {
        terminal_name = "sm_equipment_tab_awakening_treasure_less_tip", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1],"Button_equ_up_kssj"), nil, 
    -- {
    --     terminal_name = "sm_equipment_tab_awakening_treasure_upgrade", 
    --     terminal_state = 0,
    --     isPressedActionEnabled = true
    -- }, 
    -- nil, 0)

    
    
	
    self:onUpdateDraw()
    self:drawWretchedAwakening()
end

function SmEquipmentTabAwakening:onExit()
    state_machine.remove("sm_equipment_tab_awakening_display")
    state_machine.remove("sm_equipment_tab_awakening_hide")
    state_machine.remove("sm_equipment_tab_awakening_update_draw")
    state_machine.remove("sm_equipment_tab_awakening_change_ship")
    state_machine.remove("sm_equipment_tab_awakening_equip_upgrade")
    state_machine.remove("sm_equipment_tab_awakening_request")
	state_machine.remove("sm_equipment_tab_awakening_treasure_upgrade")
    state_machine.remove("sm_equipment_tab_awakening_treasure_less")
end