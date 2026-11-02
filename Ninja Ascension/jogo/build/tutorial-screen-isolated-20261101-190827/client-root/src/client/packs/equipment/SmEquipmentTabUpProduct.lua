-- ----------------------------------------------------------------------------------------------------
-- 说明：装备升品强化
-------------------------------------------------------------------------------------------------------
SmEquipmentTabUpProduct = class("SmEquipmentTabUpProductClass", Window)

local sm_equipment_tab_up_product_open_terminal = {
    _name = "sm_equipment_tab_up_product_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmEquipmentTabUpProductClass")
        if nil == _homeWindow then
            local panel = SmEquipmentTabUpProduct:new():init(params)
            fwin:open(panel)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_equipment_tab_up_product_close_terminal = {
    _name = "sm_equipment_tab_up_product_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
            state_machine.unlock("formation_switch_paging_information", 0, "")
        end
		local _homeWindow = fwin:find("SmEquipmentTabUpProductClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmEquipmentTabUpProductClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_equipment_tab_up_product_open_terminal)
state_machine.add(sm_equipment_tab_up_product_close_terminal)
state_machine.init()
    
function SmEquipmentTabUpProduct:ctor()
    self.super:ctor()
    self.roots = {}
    self.equip = nil
    self.swallow_the_array = {"0","0","0","0"}
    self.swallow_the_array_instanceId = {"0", "0", "0", "0"}
    self.swallow_number = {"0","0","0","0"}
    self.upTreasure = false
    self.needGolds1 = 0 --升级所需金币
    self.needGolds2 = 0 --升品所需金币
    self.materialEnough = true

    self.need_honour = 0    -- 升品所需荣誉币
    self.need_glories = 0   -- 升品所需试炼币

    self.actionOver = true
    app.load("client.cells.prop.prop_icon_new_cell")
    app.load("client.packs.equipment.SmEquipmentQianghuaAdd")
    app.load("client.packs.equipment.SmEquipStarUpSuccessWindow")
    app.load("client.utils.SmBuySilverCoins")
    app.load("client.packs.hero.HeroPatchInformationPageGetWay")

    local function init_sm_equipment_tab_up_product_terminal()
        -- 显示界面
        local sm_equipment_tab_up_product_display_terminal = {
            _name = "sm_equipment_tab_up_product_display",
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
        local sm_equipment_tab_up_product_hide_terminal = {
            _name = "sm_equipment_tab_up_product_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                    state_machine.unlock("formation_switch_paging_information", 0, "")
                end
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:onHide()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 请求升品
        local sm_equipment_tab_up_product_request_terminal = {
            _name = "sm_equipment_tab_up_product_request",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("sm_equipment_tab_up_product_request", 0, "")
                if instance.needGolds2 > tonumber(_ED.user_info.user_silver) then
                    --TipDlg.drawTextDailog(_new_interface_text[28])
                    --state_machine.excute("shortcut_function_silver_to_get_open",0,1)
                    -- state_machine.excute("sm_buy_silver_coinsopen", 0, 0)
                    if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and zstring.tonumber(_ED.server_review) == 1 then
                        TipDlg.drawTextDailog(_string_piece_info[127])
                    else
                        local fightWindow = HeroPatchInformationPageGetWay:new()
                        fightWindow:init(0,6)
                        fwin:open(fightWindow, fwin._windows)
                    end
                    state_machine.unlock("sm_equipment_tab_up_product_request", 0, "")
                    return
                end
                if instance.need_honour > tonumber(_ED.user_info.user_honour) then
                    if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and zstring.tonumber(_ED.server_review) == 1 then
                       TipDlg.drawTextDailog(_string_piece_info[127])
                    else 
                        local fightWindow = HeroPatchInformationPageGetWay:new()
                        fightWindow:init(0,7)
                        fwin:open(fightWindow, fwin._windows)
                    end
                    state_machine.unlock("sm_equipment_tab_up_product_request", 0, "")
                    return
                end

                if instance.need_glories > tonumber(_ED.user_info.all_glories) then
                    if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and zstring.tonumber(_ED.server_review) == 1 then
                       TipDlg.drawTextDailog(_string_piece_info[127])
                    else 
                        local fightWindow = HeroPatchInformationPageGetWay:new()
                        fightWindow:init(0,8)
                        fwin:open(fightWindow, fwin._windows)
                    end
                    state_machine.unlock("sm_equipment_tab_up_product_request", 0, "")
                    return
                end
                -- if instance.materialEnough == false then
                --     TipDlg.drawTextDailog(_new_interface_text[27])
                --     return
                -- end
                local equipData = _ED.user_ship[""..instance.equip.ship_id].equipInfo
                local old_template = instance.equip.user_equiment_template
                local function responseEquipmentEscalateCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node.needGolds2 = 0
                            local newEquip = instance.equip
                            newEquip.quipInfo = _ED.user_ship[""..instance.equip.ship_id].equipInfo
                            newEquip.equipInfo = equipData
                            newEquip.user_equiment_grade = instance.Elvs
                            newEquip.old_template = old_template
                            state_machine.excute("equip_star_up_success_window_open",0,{newEquip,1})
                            
                            for i,v in pairs(_ED.user_ship) do
                                setShipPushData(v.ship_id,7,-1)
                                setShipPushData(v.ship_id,8,-1)
                            end
                                -- state_machine.excute("sm_role_strengthen_tab_play_control_effect", 0, 0)
                            response.node:onUpdateDraw()
                            state_machine.excute("sm_equipment_qianghua_to_update_equip_icon",0,"")
                            -- state_machine.excute("hero_icon_listview_icon_push_updata",0,"")
                            state_machine.excute("sm_equipment_tab_up_product_update_draw", 0, nil)
                            if fwin:find("HeroDevelopClass") ~= nil then
                                -- state_machine.excute("hero_develop_page_strength_to_update_ship", 0, _ED.user_ship[""..instance.equip.ship_id])
                                -- state_machine.excute("sm_equipment_qianghua_update_ship", 0, _ED.user_ship[""..ship_id])
                                -- state_machine.excute("sm_equipment_qianghua_update_ship_info", 0, nil)
                                
                                state_machine.excute("hero_develop_back_to_update_specific_equip",0,instance.equip.m_index)
                                state_machine.excute("hero_develop_page_updata_hero_icon_push",0,".")
                            else
                                if fwin:find("SmEquipmentQianghuaClass") == nil then
                                    for i, v in pairs(_ED.user_formetion_status) do
                                        if tonumber(v) == tonumber(instance.equip.ship_id) then
                                            state_machine.excute("formation_set_ship",0,_ED.user_ship[""..instance.equip.ship_id])
                                            break
                                        end
                                    end
                                end
                            end
                        end
                        state_machine.unlock("formation_back_to_home_activity", 0, "")
                        state_machine.unlock("sm_equipment_tab_up_product_request", 0, "")
                        state_machine.unlock("hero_develop_back_to_home_activity", 0, "")
                    else
                        state_machine.unlock("formation_back_to_home_activity", 0, "")
                        state_machine.unlock("sm_equipment_tab_up_product_request", 0, "")
                        state_machine.unlock("hero_develop_back_to_home_activity", 0, "")
                    end
                end
                state_machine.lock("formation_back_to_home_activity", 0, "")
                state_machine.lock("hero_develop_back_to_home_activity", 0, "")
                if tonumber(instance.equip.m_index) > 4 then
                    protocol_command.treasure_escalate.param_list = instance.equip.ship_id .. "\r\n" .. "0" .."\r\n" ..instance.equip.m_index.. "\r\n"
                    NetworkManager:register(protocol_command.treasure_escalate.code, nil, nil, nil, instance, responseEquipmentEscalateCallback,false)
                else
                    protocol_command.equipment_escalate.param_list = instance.equip.ship_id .. "\r\n" .. "0"  .."\r\n" ..instance.equip.m_index.. "\r\n".."0".."\r\n-1"
                    NetworkManager:register(protocol_command.equipment_escalate.code, nil, nil, nil, instance, responseEquipmentEscalateCallback,false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新
        local sm_equipment_tab_up_product_update_draw_terminal = {
            _name = "sm_equipment_tab_up_product_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    if instance.schedulerID ~= nil then 
                        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(instance.schedulerID)
                    end
                    state_machine.unlock("formation_switch_paging_information", 0, "")
                    state_machine.unlock("hero_listview_set_index", 0, "")
                    state_machine.unlock("hero_icon_list_cell_set_index", 0, "")
                    state_machine.unlock("sm_equipment_qianghua_to_select", 0, "")
                    state_machine.unlock("sm_equipment_tab_up_product_treasure_upgrade", 0, "")
                    state_machine.unlock("formation_back_to_home_page", 0, "")
                    state_machine.unlock("formation_back_to_home_activity", 0, "")
                    state_machine.unlock("sm_equipment_tab_up_product_request", 0, "")
                    state_machine.unlock("equip_icon_cell_change_ship_equip", 0, "")
                    state_machine.unlock("sm_equipment_tab_up_product_equip_upgrade", 0, "")  
                    state_machine.unlock("hero_develop_back_to_home_activity", 0, "")
                    instance:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新等级
        local sm_equipment_tab_up_product_update_lv_terminal = {
            _name = "sm_equipment_tab_up_product_update_lv",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local Text_equ_lv_n = ccui.Helper:seekWidgetByName(instance.roots[1], "Text_equ_lv_n")
                Text_equ_lv_n:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
                instance:textActiveion(Text_equ_lv_n,1)
                local strs = Text_equ_lv_n:getString()
                local data = zstring.split(strs, "/")
                Text_equ_lv_n:setString(params.."/"..data[2])
                instance.Elvs = params

                --所属战船
                local ship_id = instance.equip.ship_id
                local shipData = _ED.user_ship[""..ship_id]
                --武将装备数据（等级|品质|经验|星级）
                local shipEquip = zstring.split(shipData.equipInfo, "|")
                --装备位
                local e_index = instance.equip.m_index

                local levels = zstring.split(shipEquip[1], ",")

                local newStar = zstring.split(shipEquip[4], ",")
                --判断最高可以升到多少级
                local newGrade = zstring.split(shipEquip[2], ",")

                --属性1
                local Text_equ_attribute_n_1 = ccui.Helper:seekWidgetByName(instance.roots[1], "Text_equ_attribute_n_1")
                local Text_equ_attribute_1 = ccui.Helper:seekWidgetByName(instance.roots[1], "Text_equ_attribute_1")
                local Image_15_0_1 = ccui.Helper:seekWidgetByName(instance.roots[1], "Image_15_0_1")
                --属性2
                local Text_equ_attribute_n_2 = ccui.Helper:seekWidgetByName(instance.roots[1], "Text_equ_attribute_n_2")
                local Text_equ_attribute_2 = ccui.Helper:seekWidgetByName(instance.roots[1], "Text_equ_attribute_2")
                local Image_15_0 = ccui.Helper:seekWidgetByName(instance.roots[1], "Image_15_0")
                for i=1,2 do
                    local Text_equ_attribute_n = ccui.Helper:seekWidgetByName(instance.roots[1], "Text_equ_attribute_n_"..i)
                    local Text_equ_attribute = ccui.Helper:seekWidgetByName(instance.roots[1], "Text_equ_attribute_"..i)
                    Text_equ_attribute_n:setVisible(false)
                    Text_equ_attribute:setVisible(false)
                    if Image_15_0_1 ~= nil then
                        Image_15_0_1:setVisible(false)
                    end
                    if Image_15_0 ~= nil then
                        Image_15_0:setVisible(false)
                    end
                end
                local baseValue = dms.string(dms["equipment_mould"], self.equip.user_equiment_template, equipment_mould.initial_value)
                local equipAttributes = equipmentPropertyCalculationFormula(self.equip.user_equiment_template,tonumber(newGrade[tonumber(e_index)]),tonumber(newStar[tonumber(e_index)]),tonumber(instance.Elvs))
                local valueList = zstring.split(baseValue, "|")
                local index = 0
                for i, v in pairs(valueList) do
                    index = index + 1
                    local Text_equ_attribute_n = ccui.Helper:seekWidgetByName(instance.roots[1], "Text_equ_attribute_n_"..index)
                    local Text_equ_attribute = ccui.Helper:seekWidgetByName(self.roots[1], "Text_equ_attribute_"..index)
                    Text_equ_attribute_n:setVisible(true)
                    Text_equ_attribute:setVisible(true)
                    if i==1 then
                        if Image_15_0_1 ~= nil then
                            Image_15_0_1:setVisible(true)
                        end
                    elseif i == 2 then
                        if Image_15_0 ~= nil then
                            Image_15_0:setVisible(true)
                        end    
                    end


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
                    Text_equ_attribute_n:setString("+"..equipAttributes[i]..addPercent)
                    Text_equ_attribute_n:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
                    instance:textActiveion(Text_equ_attribute_n,1)
                end

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 改变id
        local sm_equipment_tab_up_product_change_ship_terminal = {
            _name = "sm_equipment_tab_up_product_change_ship",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.equip = params
                state_machine.excute("sm_equipment_tab_up_product_update_draw",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --装备升级
        local sm_equipment_tab_up_product_equip_upgrade_terminal = {
            _name = "sm_equipment_tab_up_product_equip_upgrade",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if tonumber(instance.equip.m_index) <= 4 then
                    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                        state_machine.lock("sm_equipment_tab_up_product_equip_upgrade", 0, "")
                        state_machine.lock("equip_icon_cell_change_ship_equip")
                    end    
                end
                local m_type = tonumber(params._datas.m_type)
                local shipEquip = zstring.split(_ED.user_ship[""..instance.equip.ship_id].equipInfo, "|")
                local levels = zstring.split(shipEquip[1], ",")
                local oldLv = tonumber(levels[tonumber(instance.equip.m_index)])
                local function responseEquipmentEscalateCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then  
                            response.node.needGolds1 = 0
                            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                                then
                                for i,v in pairs(_ED.user_ship) do
                                    setShipPushData(v.ship_id,7,-1)
                                    setShipPushData(v.ship_id,8,-1)
                                end
                                -- state_machine.excute("sm_role_strengthen_tab_play_control_effect", 0, 0)
                                -- state_machine.excute("hero_icon_listview_icon_push_updata",0,"hero_icon_listview_icon_push_updata.")
                            end             
                            local shipEquip = zstring.split(_ED.user_ship[""..response.node.equip.ship_id].equipInfo, "|")
                            local levels = zstring.split(shipEquip[1], ",")
                            local newLv = tonumber(levels[tonumber(response.node.equip.m_index)])
                            state_machine.excute("sm_equipment_qianghua_to_update_equip_icon",0,response.node.equip.m_index)
                            -- state_machine.excute("sm_equipment_tab_up_product_update_draw", 0, nil)
                            if fwin:find("HeroDevelopClass") ~= nil then
                                -- state_machine.excute("hero_develop_page_strength_to_update_ship", 0, _ED.user_ship[""..response.node.equip.ship_id])
                                -- state_machine.excute("sm_equipment_qianghua_update_ship", 0, _ED.user_ship[""..ship_id])
                                -- state_machine.excute("sm_equipment_qianghua_update_ship_info", 0, nil)
                                
                                state_machine.excute("hero_develop_back_to_update_specific_equip",0,response.node.equip.m_index)
                                state_machine.excute("hero_develop_page_updata_hero_icon_push",0,".")
                            else
                                for i, v in pairs(_ED.user_formetion_status) do
                                    if tonumber(v) == tonumber(response.node.equip.ship_id) then
                                        state_machine.excute("formation_set_ship",0,_ED.user_ship[""..response.node.equip.ship_id])
                                        break
                                    end
                                end
                            end
                            
                            
                            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                                then
                                local Panel_sjdh = ccui.Helper:seekWidgetByName(response.node.roots[1], "Panel_sjdh")
                                -- draw.createEffect("effice_equ_qh", "images/ui/effice/effice_equ_qh/effice_equ_qh.ExportJson", Panel_sjdh, 1, 100)
                                local index = newLv - oldLv
                                local function showUp()
                                    if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                        if index > 0 then
                                            playEffect(formatMusicFile("effect", 9991))
                                            index = index - 1
                                            state_machine.excute("sm_equipment_tab_up_product_update_lv",0,tonumber(newLv - index))
                                            state_machine.excute("sm_equipment_qianghua_to_update_lv",0,{response.node.equip.m_index,tonumber(newLv - index)})
                                            ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effice_equ_qh/effice_equ_qh.ExportJson")
                                            local armature = ccs.Armature:create("effice_equ_qh")
                                            armature:getAnimation():playWithIndex(0)
                                            armature:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc)
                                            armature:setPosition(cc.p(Panel_sjdh:getContentSize().width/2,Panel_sjdh:getContentSize().height/2))
                                            Panel_sjdh:addChild(armature)
                                            armature._invoke = function(armatureBack)
                                                response.node:deleteEffectFile(armatureBack)
                                            end
                                        else
                                            if response.node ~= nil then
                                                response.node:onUpdateDraw(false)
                                                smFightingChange()
                                                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(response.node.schedulerID) 
                                            end
                                            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                                                state_machine.unlock("formation_switch_paging_information", 0, "")
                                                state_machine.unlock("hero_listview_set_index", 0, "")
                                                state_machine.unlock("hero_icon_list_cell_set_index", 0, "")
                                                state_machine.unlock("sm_equipment_qianghua_to_select", 0, "")
                                                state_machine.unlock("sm_equipment_tab_up_product_equip_upgrade", 0, "")
                                                state_machine.unlock("formation_back_to_home_page", 0, "")
                                                state_machine.unlock("formation_back_to_home_activity", 0, "")
                                                state_machine.unlock("equip_icon_cell_change_ship_equip", 0, "")
                                                state_machine.unlock("hero_develop_back_to_home_activity", 0, "")
                                            end
                                        end
                                    end
                                end
                                if index > 0 then
                                    local function anticlockwiseUpdate(sender)
                                        showUp()
                                    end
                                    local scheduler = cc.Director:getInstance():getScheduler()
                                    if response.node.schedulerID ~= nil then 
                                        scheduler:unscheduleScriptEntry(response.node.schedulerID)      
                                    end
                                    fwin:addService({
                                            callback = function ( params )
                                                response.node.schedulerID = scheduler:scheduleScriptFunc(anticlockwiseUpdate,0.1,false)
                                                anticlockwiseUpdate()
                                            end,
                                            delay = 0.1
                                        })
                                    
                                    fwin:addService({
                                            callback = function ( params )
                                                anticlockwiseUpdate()
                                            end,
                                            delay = 0
                                        })
                                else
                                    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                                        state_machine.unlock("formation_switch_paging_information", 0, "")
                                        state_machine.unlock("hero_listview_set_index", 0, "")
                                        state_machine.unlock("hero_icon_list_cell_set_index", 0, "")
                                        state_machine.unlock("sm_equipment_qianghua_to_select", 0, "")
                                        state_machine.unlock("sm_equipment_tab_up_product_equip_upgrade", 0, "")
                                        state_machine.unlock("formation_back_to_home_page", 0, "")
                                        state_machine.unlock("formation_back_to_home_activity", 0, "")
                                        state_machine.unlock("equip_icon_cell_change_ship_equip", 0, "")
                                        state_machine.unlock("hero_develop_back_to_home_activity", 0, "")
                                    end
                                end
                            end
                        end
                    else
                        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                            state_machine.unlock("formation_switch_paging_information", 0, "")
                            state_machine.unlock("hero_listview_set_index", 0, "")
                            state_machine.unlock("hero_icon_list_cell_set_index", 0, "")
                            state_machine.unlock("sm_equipment_qianghua_to_select", 0, "")
                            state_machine.unlock("sm_equipment_tab_up_product_equip_upgrade", 0, "")
                            state_machine.unlock("equip_icon_cell_change_ship_equip", 0, "")
                            state_machine.unlock("formation_back_to_home_page", 0, "")
                            state_machine.unlock("formation_back_to_home_activity", 0, "")
                            state_machine.unlock("hero_develop_back_to_home_activity", 0, "")
                        end    
                    end
                end
                if tonumber(instance.equip.m_index) > 4 then
                    
                    if params._datas.button_name == "Button_equ_up_yj" then
                        --添加道具
                        instance.upTreasure = true
                        instance:addProps()
                    else
                        --升级
                        local isUp = false
                        for j=1, #instance.swallow_the_array do
                            if tonumber(instance.swallow_the_array[j]) ~= 0 then
                                isUp = true
                            end
                        end
                        if isUp == false then
                            TipDlg.drawTextDailog(_new_interface_text[31])
                            return
                        end
                        state_machine.excute("sm_equipment_tab_up_product_treasure_upgrade",0,"")
                    end
                else
                    if instance.needGolds1 > tonumber(_ED.user_info.user_silver) then
                        --TipDlg.drawTextDailog(_new_interface_text[28])
                        --state_machine.excute("shortcut_function_silver_to_get_open",0,1)
                        -- state_machine.excute("sm_buy_silver_coinsopen", 0, 0)
                        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and zstring.tonumber(_ED.server_review) == 1 then
                            TipDlg.drawTextDailog(_new_interface_text[28])
                        else
                            local fightWindow = HeroPatchInformationPageGetWay:new()
                            fightWindow:init(0,6)
                            fwin:open(fightWindow, fwin._windows)
                        end
                        state_machine.unlock("sm_equipment_tab_up_product_equip_upgrade")
                        state_machine.unlock("equip_icon_cell_change_ship_equip")
                        return
                    end
                    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                        then         
                        state_machine.lock("formation_switch_paging_information", 0, "")
                        state_machine.lock("hero_listview_set_index", 0, "")
                        state_machine.lock("hero_icon_list_cell_set_index", 0, "")
                        state_machine.lock("sm_equipment_qianghua_to_select", 0, "")
                        state_machine.lock("formation_back_to_home_page", 0, "")
                        state_machine.lock("formation_back_to_home_activity", 0, "")
                        state_machine.lock("hero_develop_back_to_home_activity", 0, "")
                    end
                    protocol_command.equipment_escalate.param_list = instance.equip.ship_id .. "\r\n" .. "0"  .."\r\n" ..instance.equip.m_index.. "\r\n"..m_type.."\r\n-1"
                    NetworkManager:register(protocol_command.equipment_escalate.code, nil, nil, nil, instance, responseEquipmentEscalateCallback,false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --宝物升级
        local sm_equipment_tab_up_product_treasure_upgrade_terminal = {
            _name = "sm_equipment_tab_up_product_treasure_upgrade",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    then
                    state_machine.lock("sm_equipment_tab_up_product_equip_upgrade", 0, "")
                    state_machine.lock("sm_equipment_tab_up_product_treasure_upgrade", 0, "")
                    state_machine.lock("equip_icon_cell_change_ship_equip")
                end
                if instance.needGolds1 > tonumber(_ED.user_info.user_silver) then
                    --TipDlg.drawTextDailog(_new_interface_text[28])
                    --state_machine.excute("shortcut_function_silver_to_get_open",0,1)
                    -- state_machine.excute("sm_buy_silver_coinsopen", 0, 0)
                    if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and zstring.tonumber(_ED.server_review) == 1 then
                        TipDlg.drawTextDailog(_new_interface_text[28])
                    else
                        local fightWindow = HeroPatchInformationPageGetWay:new()
                        fightWindow:init(0,6)
                        fwin:open(fightWindow, fwin._windows)
                    end
                    state_machine.unlock("sm_equipment_tab_up_product_equip_upgrade", 0, "")
                    state_machine.unlock("sm_equipment_tab_up_product_treasure_upgrade", 0, "")
                    state_machine.unlock("equip_icon_cell_change_ship_equip", 0, "")
                    return
                end
                --local m_type = tonumber(params._datas.m_type)
                local shipEquip = zstring.split(_ED.user_ship[""..instance.equip.ship_id].equipInfo, "|")
                local levels = zstring.split(shipEquip[1], ",")
                local oldLv = tonumber(levels[tonumber(instance.equip.m_index)])
                local function responseEquipmentEscalateCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots[1] ~= nil then
                            smFightingChange()
                            response.node.needGolds1 = 0
                            self.swallow_the_array = {"0","0","0","0"}
                            self.swallow_the_array_instanceId = {"0", "0", "0", "0"}
                            self.swallow_number = {"0","0","0","0"}
                            for i,v in pairs(_ED.user_ship) do
                                setShipPushData(v.ship_id,7,response.node.equip.m_index)
                                setShipPushData(v.ship_id,8,response.node.equip.m_index)
                            end
                            local shipEquip = zstring.split(_ED.user_ship[""..instance.equip.ship_id].equipInfo, "|")
                            local levels = zstring.split(shipEquip[1], ",")
                            local newLv = tonumber(levels[tonumber(self.equip.m_index)])
                            response.node:onUpdateDraw(false)
                            state_machine.excute("sm_equipment_qianghua_to_update_equip_icon",0,instance.equip.m_index)
                            state_machine.excute("sm_equipment_tab_up_product_update_draw", 0, nil)
                            if fwin:find("HeroDevelopClass") ~= nil then
                                state_machine.excute("hero_develop_back_to_update_specific_equip",0,instance.equip.m_index)
                            else
                                for i, v in pairs(_ED.user_formetion_status) do
                                    if tonumber(v) == tonumber(instance.equip.ship_id) then
                                        state_machine.excute("formation_set_ship",0,_ED.user_ship[""..instance.equip.ship_id])
                                        break
                                    end
                                end

                            end
                            instance.upTreasure = false
                            local Panel_sjdh = ccui.Helper:seekWidgetByName(response.node.roots[1], "Panel_sjdh")
                                -- draw.createEffect("effice_equ_qh", "images/ui/effice/effice_equ_qh/effice_equ_qh.ExportJson", Panel_sjdh, 1, 100)
                            local index = newLv - oldLv
                            -- Fury: el id del temporizador va en una local. onExit no lo para y,
                            -- destruida la ventana, el nodo ya no tiene ni roots ni schedulerID:
                            -- :273 indexaba roots nil y :668 desprogramaba un id nil.
                            local upEntry = nil
                            local function showUp()
                                if upEntry ~= nil and (response.node == nil or response.node.roots == nil) then
                                    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(upEntry)
                                    upEntry = nil
                                    return
                                end
                                if index > 0 then
                                    playEffect(formatMusicFile("effect", 9991))
                                    index = index - 1
                                    state_machine.excute("sm_equipment_tab_up_product_update_lv",0,tonumber(newLv - index))
                                    state_machine.excute("sm_equipment_qianghua_to_update_lv",0,{instance.equip.m_index,tonumber(newLv - index)})
                                    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effice_equ_qh/effice_equ_qh.ExportJson")
                                    local armature = ccs.Armature:create("effice_equ_qh")
                                    armature:getAnimation():playWithIndex(0)
                                    armature:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc)
                                    armature:setPosition(cc.p(Panel_sjdh:getContentSize().width/2,Panel_sjdh:getContentSize().height/2))
                                    Panel_sjdh:addChild(armature)
                                    armature._invoke = function(armatureBack)
                                        instance:deleteEffectFile(armatureBack)
                                    end
                                else
                                    if upEntry ~= nil then
                                        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(upEntry)
                                        upEntry = nil
                                    end
                                    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                                        state_machine.unlock("formation_switch_paging_information", 0, "")
                                        state_machine.unlock("hero_listview_set_index", 0, "")
                                        state_machine.unlock("hero_icon_list_cell_set_index", 0, "")
                                        state_machine.unlock("sm_equipment_qianghua_to_select", 0, "")
                                        state_machine.unlock("sm_equipment_tab_up_product_treasure_upgrade", 0, "")
                                        state_machine.unlock("formation_back_to_home_page", 0, "")
                                        state_machine.unlock("formation_back_to_home_activity", 0, "")
                                        state_machine.unlock("sm_equipment_tab_up_product_request", 0, "")
                                        state_machine.unlock("equip_icon_cell_change_ship_equip", 0, "")
                                        state_machine.unlock("sm_equipment_tab_up_product_equip_upgrade", 0, "")
                                        state_machine.unlock("hero_develop_back_to_home_activity", 0, "")
                                    end
                                end
                            end
                            if index > 0 then
                                local function anticlockwiseUpdate()
                                    showUp()
                                end
                                local scheduler = cc.Director:getInstance():getScheduler()
                                if instance.schedulerID ~= nil then 
                                    scheduler:unscheduleScriptEntry(instance.schedulerID)      
                                end
                                upEntry = scheduler:scheduleScriptFunc(anticlockwiseUpdate,0.1,false)
                                instance.schedulerID = upEntry
                                anticlockwiseUpdate()
                            else
                                playEffect(formatMusicFile("effect", 9991))  
                                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                                    state_machine.unlock("formation_switch_paging_information", 0, "")
                                    state_machine.unlock("hero_listview_set_index", 0, "")
                                    state_machine.unlock("hero_icon_list_cell_set_index", 0, "")
                                    state_machine.unlock("sm_equipment_qianghua_to_select", 0, "")
                                    state_machine.unlock("sm_equipment_tab_up_product_treasure_upgrade", 0, "")
                                    state_machine.unlock("formation_back_to_home_page", 0, "")
                                    state_machine.unlock("formation_back_to_home_activity", 0, "")
                                    state_machine.unlock("sm_equipment_tab_up_product_request", 0, "")
                                    state_machine.unlock("equip_icon_cell_change_ship_equip", 0, "")
                                    state_machine.unlock("sm_equipment_tab_up_product_equip_upgrade", 0, "")
                                    state_machine.unlock("hero_develop_back_to_home_activity", 0, "")
                                end
                            end
                            instance:drawTreasureUpLv()
                        end
                    else
                        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                            state_machine.unlock("formation_switch_paging_information", 0, "")
                            state_machine.unlock("hero_listview_set_index", 0, "")
                            state_machine.unlock("hero_icon_list_cell_set_index", 0, "")
                            state_machine.unlock("sm_equipment_qianghua_to_select", 0, "")
                            state_machine.unlock("sm_equipment_tab_up_product_treasure_upgrade", 0, "")
                            state_machine.unlock("formation_back_to_home_page", 0, "")
                            state_machine.unlock("formation_back_to_home_activity", 0, "")
                            state_machine.unlock("sm_equipment_tab_up_product_request", 0, "")
                            state_machine.unlock("equip_icon_cell_change_ship_equip", 0, "")
                            state_machine.unlock("sm_equipment_tab_up_product_equip_upgrade", 0, "")
                            state_machine.unlock("hero_develop_back_to_home_activity", 0, "")
                        end    
                    end
                end
                local swallow_the_array = ""
                local isUse = {}
                for i=1,#instance.swallow_the_array do
                    if tonumber(instance.swallow_the_array[i]) ~= 0 then
                        for j, equip in pairs(_ED.user_equiment) do
                            if isUse[j] ~= 1 then
                                if tonumber(equip.user_equiment_template) == tonumber(instance.swallow_the_array[i]) then
                                    isUse[j] = 1 
                                    if swallow_the_array == "" then
                                        swallow_the_array = equip.user_equiment_id
                                    else
                                        swallow_the_array = swallow_the_array .. "," ..equip.user_equiment_id
                                    end
                                    break
                                end
                            end
                        end
                    end
                end
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    then            
                    state_machine.lock("formation_switch_paging_information", 0, "")
                    state_machine.lock("hero_listview_set_index", 0, "")
                    state_machine.lock("hero_icon_list_cell_set_index", 0, "")
                    state_machine.lock("sm_equipment_qianghua_to_select", 0, "")
                    state_machine.lock("sm_equipment_tab_up_product_treasure_upgrade", 0, "")
                    state_machine.lock("formation_back_to_home_page", 0, "")
                    state_machine.lock("formation_back_to_home_activity", 0, "")
                    state_machine.lock("sm_equipment_tab_up_product_equip_upgrade", 0, "")
                    state_machine.lock("hero_develop_back_to_home_activity", 0, "")
                end
                protocol_command.treasure_escalate.param_list = instance.equip.ship_id .. "\r\n" .. swallow_the_array  .."\r\n" ..instance.equip.m_index.. "\r\n"
                NetworkManager:register(protocol_command.treasure_escalate.code, nil, nil, nil, instance, responseEquipmentEscalateCallback,false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --进入吞噬装备选择
        local sm_equipment_tab_up_product_open_swallowed_terminal = {
            _name = "sm_equipment_tab_up_product_open_swallowed",
            _init = function (terminal) 
                app.load("client.packs.hero.HeroPatchInformationPageGetWay")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local e_index = instance.equip.m_index
                local have = false
                if tonumber(e_index) == 5 or tonumber(e_index) == 6 then
                    local _type = 4
                    if tonumber(e_index) == 6 then
                        _type = 5
                    end
                    for i, equip in pairs(_ED.user_equiment) do
                        if tonumber(equip.equipment_type) == _type then
                            local giveExp = dms.int(dms["equipment_mould"] ,tonumber(equip.user_equiment_template) ,equipment_mould.initial_supply_escalate_exp)
                            if giveExp > 1 then
                                have = true
                            end
                        end
                    end
                    local dataArray = dms.searchs(dms["equipment_mould"], equipment_mould.equipment_type,"".._type)
                    local mouldId = 1
                    for i , v in pairs(dataArray) do
                        if tonumber(v[equipment_mould.initial_supply_escalate_exp]) > 0 then
                            mouldId = v[1]
                            break
                        end
                    end
                    if have == false then
                        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and zstring.tonumber(_ED.server_review) == 1 then
                            TipDlg.drawTextDailog(_new_interface_text[28])
                        else
                            local cell = HeroPatchInformationPageGetWay:createCell()
                            cell:init(mouldId,1)
                            fwin:open(cell, fwin._windows)
                        end
                        return
                    end
                end
                instance.equip.maxLv = instance.maxLv
                state_machine.excute("sm_equipment_qianghua_add_open",0,{instance.equip,instance.swallow_the_array,instance.swallow_number, instance.swallow_the_array_instanceId})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --设置吞噬列表内容
        local sm_equipment_tab_up_product_set_swallowed_list_terminal = {
            _name = "sm_equipment_tab_up_product_set_swallowed_list",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.swallow_the_array = params[1]
                instance.swallow_number = params[2]
                instance.equip.useExp = params[3]
                instance:drawTreasureUpLvUpdate()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_equipment_tab_up_product_open_auto_upgrade_terminal = {
            _name = "sm_equipment_tab_up_product_open_auto_upgrade",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                app.load("client.packs.equipment.SmEquipmentAutoUpgrade")
                state_machine.excute("sm_equipment_auto_upgrade_window_open", 0, {_ED.user_ship[instance.equip.ship_id], instance.equip})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_equipment_tab_up_product_display_terminal)
        state_machine.add(sm_equipment_tab_up_product_hide_terminal)
        state_machine.add(sm_equipment_tab_up_product_request_terminal)
        state_machine.add(sm_equipment_tab_up_product_update_draw_terminal)
        state_machine.add(sm_equipment_tab_up_product_change_ship_terminal)
        state_machine.add(sm_equipment_tab_up_product_equip_upgrade_terminal)
        state_machine.add(sm_equipment_tab_up_product_treasure_upgrade_terminal)
        state_machine.add(sm_equipment_tab_up_product_open_swallowed_terminal)
        state_machine.add(sm_equipment_tab_up_product_set_swallowed_list_terminal)
        state_machine.add(sm_equipment_tab_up_product_update_lv_terminal)
        state_machine.add(sm_equipment_tab_up_product_open_auto_upgrade_terminal)
        state_machine.init()
    end
    init_sm_equipment_tab_up_product_terminal()
end

function SmEquipmentTabUpProduct:deleteEffectFile(armatureBack)
    -- 删除光效
    armatureBack._LastsCountTurns = armatureBack._LastsCountTurns == nil and 0 or armatureBack._LastsCountTurns
    if armatureBack._LastsCountTurns <= 0 then
        local fileName = armatureBack._fileName
        if armatureBack.getParent ~= nil then
            if armatureBack:getParent() ~= nil then
                if armatureBack.removeFromParent ~= nil then
                    armatureBack:removeFromParent(true)
                end
            end
        end
    end
end

function SmEquipmentTabUpProduct:onHide()
    self:setVisible(false)
end

function SmEquipmentTabUpProduct:onShow()
    self:setVisible(true)
end

--添加宝物升级道具
function SmEquipmentTabUpProduct:addProps()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    --装备位
    local e_index = self.equip.m_index

    self.swallow_the_array = {"0","0","0","0"}
    self.swallow_the_array_instanceId = {"0", "0", "0", "0"}
    self.swallow_number = {"0","0","0","0"}
    --这里添加宝物升级用的道具，然后把对应的道具模板id放在self.swallow_the_array对应的位置
    --2个不同的位置获取不同的道具
    local exp_equipment_table = {}
    for i, equip in pairs(_ED.user_equiment) do
        if (tonumber(e_index) == 5 and tonumber(equip.equipment_type) == 4)
            or (tonumber(e_index) == 6 and tonumber(equip.equipment_type) == 5)
            then
            local giveExp = dms.int(dms["equipment_mould"] ,tonumber(equip.user_equiment_template) ,equipment_mould.initial_supply_escalate_exp)
            if giveExp > 1 then
                local info = {}
                info.user_equiment_template = equip.user_equiment_template
                info.giveExp = giveExp
                info.user_equiment_id = equip.user_equiment_id
                table.insert(exp_equipment_table, info)
            end
        end
    end

    local function sortFunction(a, b)
        return a.giveExp < b.giveExp
    end
    table.sort(exp_equipment_table, sortFunction)

    local add_success = false
    for k, v in pairs(exp_equipment_table) do
        for w=1, #self.swallow_the_array do
            if tonumber(self.swallow_the_array[w]) == 0 then
                self.swallow_the_array[w] = v.user_equiment_template
                self.swallow_the_array_instanceId[w] = tonumber(v.user_equiment_id)
                break
            end
        end
        add_success = true
    end

    -- if add_success == false then
    --     TipDlg.drawTextDailog(_new_interface_text[27])
    -- end
    --给self.swallow_the_array赋值之后刷新界面
    self:drawTreasureUpLv()
end

function SmEquipmentTabUpProduct:createEquipHead(objectType,ship)
    local cell = EquipIconCell:createCell()
    cell:init(objectType,ship)
    return cell
end

--从装备选择界面回来刷新界面
function SmEquipmentTabUpProduct:drawTreasureUpLvUpdate()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    -- self.swallow_the_array = {}
    local ship_id = self.equip.ship_id
    local shipData = _ED.user_ship[""..ship_id]
    --武将装备数据（等级|品质|经验|星级）
    local shipEquip = zstring.split(shipData.equipInfo, "|")
    --装备位
    local e_index = self.equip.m_index
    local levels = zstring.split(shipEquip[1], ",")
    local picAll = zstring.split(shipEquip[2], ",")
    local pic = picAll[tonumber(e_index)]
    local expAll = zstring.split(shipEquip[3], ",")
    local oldExp = expAll[tonumber(e_index)]
    --知道品质了去换算颜色
    local picIndex = 1--shipOrEquipSetColour(tonumber(pic))

    --计算需要多少经验
    local demandMaxExp = 0
    --通过当前等级和可以升的最大等级计算需要的总经验
    for i = tonumber(levels[tonumber(e_index)]) ,self.maxLv-1 do
        demandMaxExp = demandMaxExp + dms.int(dms["equipment_refining_experience_param"], i, picIndex+2)
    end
    --算出需要的总经验
    demandMaxExp = demandMaxExp - tonumber(oldExp)

    --可以用的经验
    for i=1,4 do
        local Panel_role_up_quality_box = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_role_up_quality_box_"..i)
        Panel_role_up_quality_box:removeAllChildren(true)
        local Panel_role_up_quality_icon = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_role_up_quality_icon_"..i)
        local Image_role_up_quality_add = ccui.Helper:seekWidgetByName(self.roots[1], "Image_role_up_quality_add_"..i)
        local Text_role_up_quality_num = ccui.Helper:seekWidgetByName(self.roots[1], "Text_role_up_quality_num_"..i)
        local Image_props_bg = ccui.Helper:seekWidgetByName(self.roots[1], "Image_props_bg_"..i)
        Panel_role_up_quality_box:setVisible(true)
        Panel_role_up_quality_icon:setVisible(true)
        Image_role_up_quality_add:setVisible(true)
        Text_role_up_quality_num:setVisible(true)
        Image_props_bg:setVisible(true)
        local propshow = self.swallow_the_array[i]
        if zstring.tonumber(propshow) == 0 then
            Text_role_up_quality_num:setVisible(true)
            Text_role_up_quality_num:setString("")
        else
            Text_role_up_quality_num:setVisible(true)
            Panel_role_up_quality_icon:setVisible(true)
            Image_role_up_quality_add:setVisible(true)
            Text_role_up_quality_num:setString("")
            Panel_role_up_quality_box:removeAllChildren(true)
            if tonumber(self.swallow_number[i]) > 0 then
                local cell = self:createEquipHead(16,fundEquipWidthId(propshow))
                Panel_role_up_quality_box:addChild(cell)
                cell:setPosition(cell:getPositionX(),cell:getPositionY())
                Panel_role_up_quality_icon:setVisible(false)
                Image_role_up_quality_add:setVisible(false)
                Text_role_up_quality_num:setString("")
            end
        end
    end

    --经验条
    local LoadingBar_equ_exp = ccui.Helper:seekWidgetByName(self.roots[1], "LoadingBar_equ_exp")

    local Text_exp_n = ccui.Helper:seekWidgetByName(self.roots[1], "Text_exp_n")
    --找到这一级需要的经验
    local needExp = dms.int(dms["equipment_refining_experience_param"], levels[tonumber(e_index)], picIndex+2)
    self.equip.useExp = zstring.tonumber(self.equip.useExp)
    if tonumber(self.equip.useExp) > 0 then
        local all_Exp = tonumber(self.equip.useExp) + tonumber(oldExp)
        LoadingBar_equ_exp:setPercent(tonumber(all_Exp)/needExp*100)
        Text_exp_n:setString(all_Exp.."/"..needExp)
    else
        LoadingBar_equ_exp:setPercent(tonumber(oldExp)/needExp*100)
        Text_exp_n:setString(oldExp.."/"..needExp)
    end

    --计算可升级到的等级
    -- local copyEXp = self.equip.useExp
    local copyEXp = tonumber(self.equip.useExp) + tonumber(oldExp)
    local m_upLevels = tonumber(levels[tonumber(e_index)])
    for i = tonumber(levels[tonumber(e_index)]) ,self.maxLv-1 do
        local needExp = dms.int(dms["equipment_refining_experience_param"], i, picIndex+2)
        if copyEXp > needExp then
            m_upLevels = m_upLevels + 1
            copyEXp = copyEXp - needExp
        end
    end
    --刷新界面
    if m_upLevels > tonumber(levels[tonumber(e_index)]) then
        self:updateDrawTreasureUpInfo(m_upLevels)
    else
        self:updateDrawTreasureUpInfo(m_upLevels,1)
    end

    self:drawUpgradeCostGold()
end

--宝物升级
function SmEquipmentTabUpProduct:drawTreasureUpLv()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    -- self.swallow_the_array = {}
    local ship_id = self.equip.ship_id
    local shipData = _ED.user_ship[""..ship_id]
    --武将装备数据（等级|品质|经验|星级）
    local shipEquip = zstring.split(shipData.equipInfo, "|")
    --装备位
    local e_index = self.equip.m_index
    local levels = zstring.split(shipEquip[1], ",")
    local picAll = zstring.split(shipEquip[2], ",")
    local pic = picAll[tonumber(e_index)]
    local expAll = zstring.split(shipEquip[3], ",")
    local oldExp = expAll[tonumber(e_index)]
    --知道品质了去换算颜色
    local picIndex = 1--shipOrEquipSetColour(tonumber(pic))

    --计算需要多少经验
    local demandMaxExp = 0
    --通过当前等级和可以升的最大等级计算需要的总经验
    for i = tonumber(levels[tonumber(e_index)]) ,self.maxLv-1 do
        demandMaxExp = demandMaxExp + dms.int(dms["equipment_refining_experience_param"], i, picIndex+2)
    end
    --算出需要的总经验
    demandMaxExp = demandMaxExp - tonumber(oldExp)

    --可以用的经验
    local useExp = 0
    for i=1,4 do
        local Panel_role_up_quality_box = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_role_up_quality_box_"..i)
        Panel_role_up_quality_box:removeAllChildren(true)
        local Panel_role_up_quality_icon = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_role_up_quality_icon_"..i)
        local Image_role_up_quality_add = ccui.Helper:seekWidgetByName(self.roots[1], "Image_role_up_quality_add_"..i)
        local Text_role_up_quality_num = ccui.Helper:seekWidgetByName(self.roots[1], "Text_role_up_quality_num_"..i)
        local Image_props_bg = ccui.Helper:seekWidgetByName(self.roots[1], "Image_props_bg_"..i)
        Panel_role_up_quality_box:setVisible(true)
        Panel_role_up_quality_icon:setVisible(true)
        Image_role_up_quality_add:setVisible(true)
        Text_role_up_quality_num:setVisible(true)
        Image_props_bg:setVisible(true)
        local propshow = self.swallow_the_array[i]
        if zstring.tonumber(propshow) == 0 then
            Text_role_up_quality_num:setVisible(true)
            Text_role_up_quality_num:setString("")
        else
            Text_role_up_quality_num:setVisible(true)
            Panel_role_up_quality_icon:setVisible(true)
            Image_role_up_quality_add:setVisible(true)
            -- Text_role_up_quality_num:setString("")
            Panel_role_up_quality_box:removeAllChildren(true)
            for j, equip in pairs(_ED.user_equiment) do
                --print(equip.user_equiment_template,propshow,useExp,demandMaxExp)
                if tonumber(equip.user_equiment_template) == tonumber(propshow) and useExp < demandMaxExp then
                    --找到了装备后，就不继续添加cell
                    if tonumber(self.swallow_number[i]) == 0 then
                        local cell = self:createEquipHead(16,equip)
                        Panel_role_up_quality_box:addChild(cell)
                        cell:setPosition(cell:getPositionX(),cell:getPositionY())
                        Panel_role_up_quality_icon:setVisible(false)
                        Image_role_up_quality_add:setVisible(false)
                        --找到了装备，计算需要用到多少个
                        useExp = useExp + dms.int(dms["equipment_mould"], propshow, equipment_mould.initial_supply_escalate_exp)
                        self.swallow_number[i] = zstring.tonumber(self.swallow_number[i]) + 1
                        Text_role_up_quality_num:setString("")
                    end
                end
            end
        end
    end

    for i,v in pairs(self.swallow_number) do
        if tonumber(v) <= 0 then
            self.swallow_the_array[i] = "0"
            self.swallow_the_array_instanceId[i] = "0"
        end
    end

    self.equip.useExp = useExp
    --经验条
    local LoadingBar_equ_exp = ccui.Helper:seekWidgetByName(self.roots[1], "LoadingBar_equ_exp")

    local Text_exp_n = ccui.Helper:seekWidgetByName(self.roots[1], "Text_exp_n")
    --找到这一级需要的经验
    local needExp = dms.int(dms["equipment_refining_experience_param"], levels[tonumber(e_index)], picIndex+2)

    if useExp > 0 then
        useExp = tonumber(oldExp) + tonumber(useExp)
        LoadingBar_equ_exp:setPercent(useExp/needExp*100)
        Text_exp_n:setString(useExp.."/"..needExp)
    else
        LoadingBar_equ_exp:setPercent(tonumber(oldExp)/needExp*100)
        Text_exp_n:setString(oldExp.."/"..needExp)
    end

    --计算可升级到的等级
    -- local copyEXp = self.equip.useExp
    local copyEXp = self.equip.useExp + tonumber(oldExp)
    local m_upLevels = tonumber(levels[tonumber(e_index)])
    for i = tonumber(levels[tonumber(e_index)]) ,self.maxLv-1 do
        local needExp = dms.int(dms["equipment_refining_experience_param"], i, picIndex+2)
        if copyEXp > needExp then
            m_upLevels = m_upLevels + 1
            copyEXp = copyEXp - needExp
        end
    end
    --刷新界面
    if m_upLevels > tonumber(levels[tonumber(e_index)]) then
        self:updateDrawTreasureUpInfo(m_upLevels)
    end

    self:drawUpgradeCostGold()
end 


function SmEquipmentTabUpProduct:textActiveion(text,m_type)
    text:stopAllActions()
    local function executeOneFunc()
    end
    local function executeTwoFunc()
    end
    local function executeThreeFunc()
        if m_type == nil then
            self:textActiveion(text)
        end
    end
    if m_type ~= nil then
        text:runAction(cc.Sequence:create(
            cc.FadeTo:create(0.001, 255)
            ))
    else
        text:runAction(cc.Sequence:create(
            cc.FadeTo:create(0.4, 0),
            cc.FadeTo:create(0.1, 255),
            cc.DelayTime:create(0.2),
            cc.CallFunc:create(executeThreeFunc)
            ))
    end
end
function SmEquipmentTabUpProduct:updateDrawTreasureUpInfo(m_upLevels,m_type)
    local root = self.roots[1]
    local Text_equ_lv_n = ccui.Helper:seekWidgetByName(root, "Text_equ_lv_n")
    if m_type ~= nil then
        Text_equ_lv_n:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
    else
        Text_equ_lv_n:setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))
    end
    self:textActiveion(Text_equ_lv_n,m_type)
    
    local strs = Text_equ_lv_n:getString()
    local data = zstring.split(strs, "/")
    Text_equ_lv_n:setString(m_upLevels.."/"..data[2])

    --所属战船
    local ship_id = self.equip.ship_id
    local shipData = _ED.user_ship[""..ship_id]
    --武将装备数据（等级|品质|经验|星级）
    local shipEquip = zstring.split(shipData.equipInfo, "|")
    --装备位
    local e_index = self.equip.m_index

    local levels = zstring.split(shipEquip[1], ",")

    local newStar = zstring.split(shipEquip[4], ",")
    --判断最高可以升到多少级
    local newGrade = zstring.split(shipEquip[2], ",")

    --属性1
    local Text_equ_attribute_n_1 = ccui.Helper:seekWidgetByName(root, "Text_equ_attribute_n_1")
    local Text_equ_attribute_1 = ccui.Helper:seekWidgetByName(root, "Text_equ_attribute_1")
    local Image_15_0_1 = ccui.Helper:seekWidgetByName(root, "Image_15_0_1")
    --属性2
    local Text_equ_attribute_n_2 = ccui.Helper:seekWidgetByName(root, "Text_equ_attribute_n_2")
    local Text_equ_attribute_2 = ccui.Helper:seekWidgetByName(root, "Text_equ_attribute_2")
    local Image_15_0 = ccui.Helper:seekWidgetByName(root, "Image_15_0")
    for i=1,2 do
        local Text_equ_attribute_n = ccui.Helper:seekWidgetByName(root, "Text_equ_attribute_n_"..i)
        local Text_equ_attribute = ccui.Helper:seekWidgetByName(root, "Text_equ_attribute_"..i)
        Text_equ_attribute_n:setVisible(false)
        Text_equ_attribute:setVisible(false)
        if Image_15_0_1 ~= nil then
            Image_15_0_1:setVisible(false)
        end
        if Image_15_0 ~= nil then
            Image_15_0:setVisible(false)
        end
    end
    local baseValue = dms.string(dms["equipment_mould"], self.equip.user_equiment_template, equipment_mould.initial_value)
    local equipAttributes = equipmentPropertyCalculationFormula(self.equip.user_equiment_template,tonumber(newGrade[tonumber(e_index)]),tonumber(newStar[tonumber(e_index)]),tonumber(m_upLevels))
    local valueList = zstring.split(baseValue, "|")
    local index = 0
    for i, v in pairs(valueList) do
        index = index + 1
        local Text_equ_attribute_n = ccui.Helper:seekWidgetByName(root, "Text_equ_attribute_n_"..index)
        local Text_equ_attribute = ccui.Helper:seekWidgetByName(root, "Text_equ_attribute_"..index)
        Text_equ_attribute_n:setVisible(true)
        Text_equ_attribute:setVisible(true)
        if i==1 then
            if Image_15_0_1 ~= nil then
                Image_15_0_1:setVisible(true)
            end
        elseif i == 2 then
            if Image_15_0 ~= nil then
                Image_15_0:setVisible(true)
            end    
        end

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
        Text_equ_attribute_n:setString("+"..equipAttributes[i]..addPercent)
        if m_type ~= nil then
            Text_equ_attribute_n:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
        else
            Text_equ_attribute_n:setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))
        end
        self:textActiveion(Text_equ_attribute_n,m_type)
    end
end

-- 刷新宝物升级金币消耗
function SmEquipmentTabUpProduct:drawUpgradeCostGold()
    local root = self.roots[1]
    if tonumber(self.equip.m_index) > 4 then
        local Text_equ_up_gold_n_2 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_equ_up_gold_n_2")
        local gold_factor = dms.int(dms["equipment_config"], 6, equipment_config.param)
        local up_lv_gold = gold_factor * tonumber(self.equip.useExp)

        Text_equ_up_gold_n_2:setString(up_lv_gold)
        if tonumber(up_lv_gold) <= tonumber(_ED.user_info.user_silver) then
            -- DSC重塑
            if __lua_project_id == __lua_project_l_digital and tipStringInfo_color_type_assemble then
                Text_equ_up_gold_n_2:setColor(cc.c3b(tipStringInfo_color_type_assemble[3][1], tipStringInfo_color_type_assemble[3][2], tipStringInfo_color_type_assemble[3][3]))
            else
                Text_equ_up_gold_n_2:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
            end
        else
            -- DSC重塑
            if __lua_project_id == __lua_project_l_digital and tipStringInfo_color_type_assemble then
                Text_equ_up_gold_n_2:setColor(cc.c3b(tipStringInfo_color_type_assemble[7][1], tipStringInfo_color_type_assemble[7][2], tipStringInfo_color_type_assemble[7][3]))
            else
                Text_equ_up_gold_n_2:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
            end
        end
        
        self.needGolds1 = tonumber(up_lv_gold)
    end
end

--前4个装备升品德需求绘制
function SmEquipmentTabUpProduct:drawUpProductDemand(newLv, library_group)
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local maxLvData = dms.searchs(dms["equipment_level_param"], equipment_level_param.equip_level, newLv)
    self.materialEnough = true
    for i=1,4 do
        local index = 4+i+i-1
        local Panel_role_up_quality_box = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_role_up_quality_box_"..i)
        Panel_role_up_quality_box:removeAllChildren(true)
        local Panel_role_up_quality_icon = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_role_up_quality_icon_"..i)
        local Image_role_up_quality_add = ccui.Helper:seekWidgetByName(self.roots[1], "Image_role_up_quality_add_"..i)
        local Text_role_up_quality_num = ccui.Helper:seekWidgetByName(self.roots[1], "Text_role_up_quality_num_"..i)
        local Image_props_bg = ccui.Helper:seekWidgetByName(self.roots[1], "Image_props_bg_"..i)
        if tonumber(maxLvData[library_group][index]) ~= 0 then
            Panel_role_up_quality_box:setVisible(true)
            Panel_role_up_quality_icon:setVisible(false)
            Image_role_up_quality_add:setVisible(true)
            Text_role_up_quality_num:setVisible(true)
            Image_props_bg:setVisible(true)
            --道具数
            local existNumber = tonumber(getPropAllCountByMouldId(tonumber(maxLvData[library_group][index-1])))
            local cell = PropIconNewCell:createCell()
            if existNumber >= tonumber(maxLvData[library_group][index]) then
                cell:init(cell.enum_type._SHOW_PROP_GETWAY_INFORMATION, tonumber(maxLvData[library_group][index-1]))
                Text_role_up_quality_num:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
                Image_role_up_quality_add:setVisible(false)
            else
                self.materialEnough = false
                cell:init(cell.enum_type._SHOW_PROP_GETWAY_INFORMATION, tonumber(maxLvData[library_group][index-1]),false,true)
                Text_role_up_quality_num:setColor(cc.c3b(color_Type[5][1], color_Type[5][2], color_Type[5][3]))
                Image_role_up_quality_add:setVisible(true)
            end
            cell.existNumber = existNumber
            cell.totalNumber = tonumber(maxLvData[library_group][index])
            Panel_role_up_quality_box:addChild(cell)

            Text_role_up_quality_num:setString(existNumber.."/"..tonumber(maxLvData[library_group][index]))
        else
            Panel_role_up_quality_box:setVisible(false)
            Panel_role_up_quality_icon:setVisible(false)
            Image_role_up_quality_add:setVisible(false)
            Text_role_up_quality_num:setVisible(false)
            Image_props_bg:setVisible(false)
        end
    end
end

function SmEquipmentTabUpProduct:onUpdateDraw(isUp)
    local root = self.roots[1]
    if root == nil then 
        return
    end
    if self.equip == nil then
        return
    end
    self.swallow_the_array = {"0","0","0","0"}
    self.swallow_number = {"0","0","0","0"}
    self.swallow_the_array_instanceId = {"0", "0", "0", "0"}

    --装备基础数据
        --模板id
    local equip_moudl_id = self.equip.user_equiment_template
        --所属战船
    local ship_id = self.equip.ship_id
    local shipData = _ED.user_ship[""..ship_id]
    --装备位
    local e_index = self.equip.m_index

    --武将装备数据（等级|品质|经验|星级）
    local shipEquip = zstring.split(shipData.equipInfo, "|")
    --形象
    local Panel_equ_icon = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_equ_icon")
    Panel_equ_icon:removeBackGroundImage()
    picIndex = dms.int(dms["equipment_mould"], equip_moudl_id, equipment_mould.pic_index)
    Panel_equ_icon:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
    --名称
    local Text_equ_name = ccui.Helper:seekWidgetByName(self.roots[1], "Text_equ_name")
    --获取装备名称索引
    local nameindex = dms.int(dms["equipment_mould"], equip_moudl_id, equipment_mould.equipment_name)
    --通过索引找到word_mould
    local word_info = dms.element(dms["word_mould"], nameindex)
    local name = word_info[3]
    --优化的写法，等有时间再换
    -- local word_info = dms.string(dms["word_mould"], tonumber(nameindex), word_mould.text_info)
    -- local name = word_info
    --装备升品的库组
    local library_group = dms.string(dms["ship_mould"], _ED.user_ship[""..self.equip.ship_id].ship_template_id, ship_mould.max_rank_level)
    local groupdatas = zstring.split(library_group, ",")
    library_group = tonumber(groupdatas[tonumber(e_index)])
    --通过库组找到对应的数据
    local UpProductMould = nil
    if tonumber(e_index) > 4 then
        UpProductMould = dms.searchs(dms["equipment_rank_link"], equipment_rank_link.library_group, library_group)
    else
        UpProductMould = dms.searchs(dms["equipment_level_param"], equipment_level_param.library_group, library_group)
    end

    --等级
    local Text_equ_lv_n = ccui.Helper:seekWidgetByName(self.roots[1], "Text_equ_lv_n")
    Text_equ_lv_n:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
    self:textActiveion(Text_equ_lv_n,1)
    local levels = zstring.split(shipEquip[1], ",")

    local newStar = zstring.split(shipEquip[4], ",")
    --判断最高可以升到多少级
    local newGrade = zstring.split(shipEquip[2], ",")
    local correspond_grade = 0
    local upMould = nil
    if tonumber(e_index) > 4 then
        for i, v in pairs(UpProductMould) do
            if tonumber(v[2]) == tonumber(levels[tonumber(e_index)]) then
                upMould = v
                correspond_grade = tonumber(v[15])
                break
            end
        end
    else
        for i, v in pairs(UpProductMould) do
            if tonumber(v[2]) == tonumber(levels[tonumber(e_index)]) then
                upMould = v
                correspond_grade = tonumber(v[13])
                break
            end
        end
    end
    self.maxLv = 0
    local maxLvData = {}
    if tonumber(e_index) > 4 then
        local addPix = 19     
        if library_group ~= 1 then 
            local groupOne = dms.searchs(dms["equipment_rank_link"], equipment_rank_link.library_group, 1)
            addPix = #groupOne
        end
        -- maxLvData = dms.searchs(dms["equipment_rank_link"], equipment_rank_link.id, tonumber(newGrade[tonumber(e_index)])+1)
        for i, v in pairs(UpProductMould) do
            local needs = 0
            if library_group == 1 then
                needs = tonumber(newGrade[tonumber(e_index)])+1
            else
                needs = tonumber(newGrade[tonumber(e_index)])+1 + addPix
            end
            if tonumber(v[1]) == needs then
                table.insert(maxLvData, v)
            end
        end
    else
        -- maxLvData = dms.searchs(dms["equipment_level_param"], equipment_level_param.is_up_product, 1)
        for i, v in pairs(UpProductMould) do
            if tonumber(v[12]) == 1 then
                table.insert(maxLvData, v)
            end
        end
    end
    if isUp == nil then
        self.Elvs = levels[tonumber(e_index)]
    end
    for i=1, #maxLvData do
        if tonumber(e_index) > 4 then
            if tonumber(levels[tonumber(e_index)]) <= tonumber(maxLvData[i][2]) then
                Text_equ_lv_n:setString(self.Elvs.."/"..maxLvData[i][2])
                self.maxLv = tonumber(maxLvData[i][2])
                break
            end
        else
            if tonumber(levels[tonumber(e_index)]) <= tonumber(maxLvData[i][2]) and tonumber(newGrade[tonumber(e_index)]) <= tonumber(maxLvData[i][13]) then
                Text_equ_lv_n:setString(self.Elvs.."/"..maxLvData[i][2])
                self.maxLv = tonumber(maxLvData[i][2])
                break
            end
        end
    end
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
    --属性1
    local Text_equ_attribute_n_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_equ_attribute_n_1")
    local Text_equ_attribute_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_equ_attribute_1")
    local Image_15_0_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Image_15_0_1")
    --属性2
    local Text_equ_attribute_n_2 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_equ_attribute_n_2")
    local Text_equ_attribute_2 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_equ_attribute_2")
    local Image_15_0 = ccui.Helper:seekWidgetByName(self.roots[1], "Image_15_0")
    for i=1,2 do
        local Text_equ_attribute_n = ccui.Helper:seekWidgetByName(self.roots[1], "Text_equ_attribute_n_"..i)
        local Text_equ_attribute = ccui.Helper:seekWidgetByName(self.roots[1], "Text_equ_attribute_"..i)
        Text_equ_attribute_n:setVisible(false)
        Text_equ_attribute:setVisible(false)
        if Image_15_0_1 ~= nil then
            Image_15_0_1:setVisible(false)
        end
        if Image_15_0 ~= nil then
            Image_15_0:setVisible(false)
        end
    end
    local baseValue = dms.string(dms["equipment_mould"], equip_moudl_id, equipment_mould.initial_value)
    local equipAttributes = equipmentPropertyCalculationFormula(equip_moudl_id,tonumber(newGrade[tonumber(e_index)]),tonumber(newStar[tonumber(e_index)]),tonumber(levels[tonumber(e_index)]))
    local valueList = zstring.split(baseValue, "|")
    local index = 0
    for i, v in pairs(valueList) do
        index = index + 1
        local Text_equ_attribute_n = ccui.Helper:seekWidgetByName(self.roots[1], "Text_equ_attribute_n_"..index)
        local Text_equ_attribute = ccui.Helper:seekWidgetByName(self.roots[1], "Text_equ_attribute_"..index)
        Text_equ_attribute_n:setVisible(true)
        Text_equ_attribute:setVisible(true)
        if i==1 then
            if Image_15_0_1 ~= nil then
                Image_15_0_1:setVisible(true)
            end
        elseif i == 2 then
            if Image_15_0 ~= nil then
                Image_15_0:setVisible(true)
            end    
        end

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
        Text_equ_attribute_n:setString("+"..equipAttributes[i]..addPercent)
        Text_equ_attribute_n:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
        self:textActiveion(Text_equ_attribute_n,1)
    end

    local Text_equ_lv = ccui.Helper:seekWidgetByName(self.roots[1], "Text_equ_lv")
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        Text_equ_lv:setString(_new_interface_text[116])
    end
    --星级
    for i=1, 5 do
        local equ_star = ccui.Helper:seekWidgetByName(self.roots[1], "equ_star_"..i)
        local equData = zstring.split(shipEquip[4], ",")
        if tonumber(equData[tonumber(e_index)]) >= i then
            equ_star:setVisible(true)
        else
            equ_star:setVisible(false)
        end
    end
    --前4个装备的升品或者后2个装备的升级
    local Panel_props_add = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_props_add")
    --前4个装备不需要升品的时候
    local Panel_equ_up_tips = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_equ_up_tips")
    --后2个装备的升品
    local Panel_equ_up_coin = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_equ_up_coin")
    --后2个装备升级用的经验条
    local Panel_exp = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_exp")
    --升级的按钮
    local Panel_button = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_button")
    --升品的按钮
    local Button_equ_up_sp = ccui.Helper:seekWidgetByName(self.roots[1], "Button_equ_up_sp")
    --升级的消耗（金钱）
    local Image_gold_icon_2 = ccui.Helper:seekWidgetByName(self.roots[1], "Image_gold_icon_2")
    local Text_equ_up_gold_n_2 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_equ_up_gold_n_2")
    local up_lv_gold = 0
    if tonumber(e_index) <= 4 then
        up_lv_gold = UpProductMould[tonumber(levels[tonumber(e_index)])][equipment_level_param.up_lv_gold]
        Text_equ_up_gold_n_2:setString(up_lv_gold)
    end
    if tonumber(up_lv_gold) <= tonumber(_ED.user_info.user_silver) then
        -- DSC重塑
        if __lua_project_id == __lua_project_l_digital and tipStringInfo_color_type_assemble then
            Text_equ_up_gold_n_2:setColor(cc.c3b(tipStringInfo_color_type_assemble[3][1], tipStringInfo_color_type_assemble[3][2], tipStringInfo_color_type_assemble[3][3]))
        else
            Text_equ_up_gold_n_2:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
        end
    else
        -- DSC重塑
        if __lua_project_id == __lua_project_l_digital and tipStringInfo_color_type_assemble then
            Text_equ_up_gold_n_2:setColor(cc.c3b(tipStringInfo_color_type_assemble[7][1], tipStringInfo_color_type_assemble[7][2], tipStringInfo_color_type_assemble[7][3]))
        else
            Text_equ_up_gold_n_2:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
        end
    end
    
    self.needGolds1 = tonumber(up_lv_gold)

    --升品的消耗（金钱）
    local Image_gold_icon_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Image_gold_icon_1")
    local Text_equ_up_gold_n_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_equ_up_gold_n_1")
    
    --DSC重塑
    if __lua_project_id == __lua_project_l_digital and tipStringInfo_color_type_assemble then
        Text_equ_up_gold_n_1:setColor(cc.c3b(tipStringInfo_color_type_assemble[3][1], tipStringInfo_color_type_assemble[3][2], tipStringInfo_color_type_assemble[3][3]))
    else
        Text_equ_up_gold_n_1:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
    end

        --拥有的竞技币和试炼币
    local Text_equ_up_slb_n = ccui.Helper:seekWidgetByName(root,"Text_equ_up_slb_n")
    
    --消耗的经济币和试炼比
    local Text_equ_up_slb_n2 = ccui.Helper:seekWidgetByName(root,"Text_equ_up_slb_n2")
    -- DSC重塑
    if __lua_project_id == __lua_project_l_digital and tipStringInfo_color_type_assemble then
        Text_equ_up_slb_n2:setColor(cc.c3b(tipStringInfo_color_type_assemble[1][1], tipStringInfo_color_type_assemble[1][2], tipStringInfo_color_type_assemble[1][3]))
    else
        Text_equ_up_slb_n2:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
    end
    --升品德等级需求
    local Text_lv_tip = ccui.Helper:seekWidgetByName(root,"Text_lv_tip")
    local Text_equ_up_slb_tip = ccui.Helper:seekWidgetByName(root,"Text_equ_up_slb_tip")
    -- DSC重塑
    if __lua_project_id == __lua_project_l_digital and tipStringInfo_color_type_assemble then
        Text_lv_tip:setColor(cc.c3b(tipStringInfo_color_type_assemble[7][1], tipStringInfo_color_type_assemble[7][2], tipStringInfo_color_type_assemble[7][3]))
    end
    Text_lv_tip:setString("")
    self.need_honour = 0 
    self.need_glories = 0
    if tonumber(e_index) > 4 then
        if upMould ~= nil then
            local rankLinkData = zstring.split(upMould[16], ",")
            if tonumber(upMould[14]) > tonumber(_ED.user_info.user_silver) then
                if __lua_project_id == __lua_project_l_digital and tipStringInfo_color_type_assemble then
                    Text_equ_up_gold_n_1:setColor(cc.c3b(tipStringInfo_color_type_assemble[7][1], tipStringInfo_color_type_assemble[7][2], tipStringInfo_color_type_assemble[7][3]))
                else
                    Text_equ_up_gold_n_1:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
                end
            end
            Text_equ_up_gold_n_1:setString(upMould[14])
            self.needGolds2 = tonumber(upMould[14])
            Text_equ_up_slb_n2:setString(rankLinkData[3])
            local Panel_coin_icon_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_coin_icon_1")
            local Panel_coin_icon_2 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_coin_icon_2")
            if tonumber(rankLinkData[2]) == 3 then
                --竞技币
                Text_equ_up_slb_n:setString(zstring.tonumber(_ED.user_info.user_honour))
                Panel_coin_icon_1:setBackGroundImage("images/ui/icon/qh_pic_jjb.png")
                Panel_coin_icon_2:setBackGroundImage("images/ui/icon/qh_pic_jjb.png")
                Text_equ_up_slb_tip:setString(_new_interface_text[176])
                self.need_honour = tonumber(rankLinkData[3])
                if tonumber(rankLinkData[3]) > zstring.tonumber(_ED.user_info.user_honour) then
                    --DSC重塑
                    if __lua_project_id == __lua_project_l_digital and tipStringInfo_color_type_assemble then
                        Text_equ_up_slb_n2:setColor(cc.c3b(tipStringInfo_color_type_assemble[7][1], tipStringInfo_color_type_assemble[7][2], tipStringInfo_color_type_assemble[7][3]))
                    else
                        Text_equ_up_slb_n2:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
                    end
                end
            elseif tonumber(rankLinkData[2]) == 18 then
                --试炼币
                Text_equ_up_slb_n:setString(zstring.tonumber(_ED.user_info.all_glories))
                Panel_coin_icon_1:setBackGroundImage("images/ui/icon/slb.png")
                Panel_coin_icon_2:setBackGroundImage("images/ui/icon/slb.png")
                Text_equ_up_slb_tip:setString(_new_interface_text[177])
                self.need_glories = tonumber(rankLinkData[3])
                if tonumber(rankLinkData[3]) > zstring.tonumber(_ED.user_info.all_glories) then
                    --DSC重塑
                    if __lua_project_id == __lua_project_l_digital and tipStringInfo_color_type_assemble then
                        Text_equ_up_slb_n2:setColor(cc.c3b(tipStringInfo_color_type_assemble[7][1], tipStringInfo_color_type_assemble[7][2], tipStringInfo_color_type_assemble[7][3]))
                    else
                        Text_equ_up_slb_n2:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
                    end
                end
            end
        end
    else
        if tonumber(upMould[14]) > tonumber(_ED.user_info.user_silver) then
            --DSC重塑
            if __lua_project_id == __lua_project_l_digital and tipStringInfo_color_type_assemble then
                Text_equ_up_gold_n_1:setColor(cc.c3b(tipStringInfo_color_type_assemble[7][1], tipStringInfo_color_type_assemble[7][2], tipStringInfo_color_type_assemble[7][3]))
            else
                Text_equ_up_gold_n_1:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
            end
        end
        Text_equ_up_gold_n_1:setString(upMould[14])
        self.needGolds2 = tonumber(upMould[14])
    end

    local Button_equ_up_kssj_0 = ccui.Helper:seekWidgetByName(self.roots[1], "Button_equ_up_kssj_0")
    if funOpenDrawTip(171, false) == true then
        Button_equ_up_kssj_0:setVisible(false)
    else
        Button_equ_up_kssj_0:setVisible(true)
    end
    -- DSC重塑
    local Text_yj = ccui.Helper:seekWidgetByName(self.roots[1], "Text_yj")
    if __lua_project_id == __lua_project_l_digital and Text_yj then
        Text_yj:setVisible(false)
    end
    --判断是否需要升品
    if self.maxLv > tonumber(levels[tonumber(e_index)]) and correspond_grade <= tonumber(newGrade[tonumber(e_index)]) then
        --升级
        if tonumber(e_index) > 4 then
            self:drawTreasureUpLv()
            Panel_props_add:setVisible(true)
            Panel_equ_up_tips:setVisible(false)
            Panel_equ_up_coin:setVisible(false)
            Panel_exp:setVisible(true)
            if __lua_project_id == __lua_project_l_digital and Text_yj then 
                Text_yj:setVisible(true)
                Text_yj:setString(equip_tips_text[1])
            elseif __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 then
				ccui.Helper:seekWidgetByName(self.roots[1], "Button_equ_up_yj"):setTitleText(equip_tips_text[1])
			elseif __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                ccui.Helper:seekWidgetByName(self.roots[1], "Image_up_quality_kstj"):setVisible(true)
                ccui.Helper:seekWidgetByName(self.roots[1], "Image_up_quality_yjsj"):setVisible(false)
            else
				ccui.Helper:seekWidgetByName(self.roots[1], "Text_eq_up_yj"):setString(equip_tips_text[1])
			end
        else
            Panel_props_add:setVisible(false)
            Panel_equ_up_tips:setVisible(true)
            Panel_equ_up_coin:setVisible(false)
            Panel_exp:setVisible(false)
            if __lua_project_id == __lua_project_l_digital and Text_yj then 
                Text_yj:setVisible(true)
                Text_yj:setString(equip_tips_text[2])
            elseif __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 then
				ccui.Helper:seekWidgetByName(self.roots[1], "Button_equ_up_yj"):setTitleText(equip_tips_text[2])
			elseif __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                ccui.Helper:seekWidgetByName(self.roots[1], "Image_up_quality_kstj"):setVisible(false)
                ccui.Helper:seekWidgetByName(self.roots[1], "Image_up_quality_yjsj"):setVisible(true)
            else
				ccui.Helper:seekWidgetByName(self.roots[1], "Text_eq_up_yj"):setString(equip_tips_text[2])
			end
        end
        Panel_button:setVisible(true)
        Button_equ_up_sp:setVisible(false)
        Image_gold_icon_1:setVisible(false)
        Text_equ_up_gold_n_1:setVisible(false)
        Image_gold_icon_2:setVisible(true)
        Text_equ_up_gold_n_2:setVisible(true)
    else
        --升品
        Button_equ_up_kssj_0:setVisible(false)
        Panel_button:setVisible(false)
        Button_equ_up_sp:setVisible(true)
        Image_gold_icon_1:setVisible(true)
        Text_equ_up_gold_n_1:setVisible(true)
        Image_gold_icon_2:setVisible(false)
        Text_equ_up_gold_n_2:setVisible(false)
        if tonumber(e_index) > 4 then
            Panel_props_add:setVisible(false)
            Panel_equ_up_tips:setVisible(false)
            Panel_equ_up_coin:setVisible(true)
            Panel_exp:setVisible(true)
            if __lua_project_id == __lua_project_l_digital and Text_yj then
                Text_yj:setVisible(true)
                Text_yj:setString(equip_tips_text[1])
            elseif __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 then
				ccui.Helper:seekWidgetByName(self.roots[1], "Button_equ_up_yj"):setTitleText(equip_tips_text[1])
			elseif __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                ccui.Helper:seekWidgetByName(self.roots[1], "Image_up_quality_kstj"):setVisible(true)
                ccui.Helper:seekWidgetByName(self.roots[1], "Image_up_quality_yjsj"):setVisible(false)
            else
				ccui.Helper:seekWidgetByName(self.roots[1], "Text_eq_up_yj"):setString(equip_tips_text[1])
			end
            if upMould ~= nil then
                if upMould[18] ~= "-1" then
                    local need_user_lv = zstring.split(upMould[18], ",")
                    if tonumber(_ED.user_info.user_grade) < tonumber(need_user_lv[tonumber(e_index)-4]) then
                        Text_lv_tip:setString(string.format(_new_interface_text[163],zstring.tonumber(need_user_lv[tonumber(e_index)-4])))
                        Button_equ_up_sp:setTouchEnabled(false)
                        Panel_equ_up_coin:setVisible(false)
                        Text_equ_up_gold_n_1:setVisible(false)
                        Image_gold_icon_1:setVisible(false)
                    else
                        Text_lv_tip:setString("")
                        Button_equ_up_sp:setTouchEnabled(true)
                        Panel_equ_up_coin:setVisible(true)
                        Text_equ_up_gold_n_1:setVisible(true)
                        Image_gold_icon_1:setVisible(true)
                    end
                else
                    Text_lv_tip:setString("")
                    Button_equ_up_sp:setTouchEnabled(true)
                    Panel_equ_up_coin:setVisible(true)
                    Text_equ_up_gold_n_1:setVisible(true)
                    Image_gold_icon_1:setVisible(true)
                end
            end
        else
            self:drawUpProductDemand(tonumber(levels[tonumber(e_index)]), tonumber(library_group))
            Panel_props_add:setVisible(true)
            Panel_equ_up_tips:setVisible(false)
            Panel_equ_up_coin:setVisible(false)
            Panel_exp:setVisible(false)
			if __lua_project_id == __lua_project_l_digital and Text_yj then
                Text_yj:setVisible(true)
                Text_yj:setString(equip_tips_text[2])
            elseif __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 then
				ccui.Helper:seekWidgetByName(self.roots[1], "Button_equ_up_yj"):setTitleText(equip_tips_text[2])
			elseif __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                ccui.Helper:seekWidgetByName(self.roots[1], "Image_up_quality_kstj"):setVisible(false)
                ccui.Helper:seekWidgetByName(self.roots[1], "Image_up_quality_yjsj"):setVisible(true)
            else
				ccui.Helper:seekWidgetByName(self.roots[1], "Text_eq_up_yj"):setString(equip_tips_text[2])
			end
            if upMould ~= nil then
                if upMould[16] ~= nil and upMould[16] ~= "-1" then
                    local need_user_lv = zstring.split(upMould[16], ",")
                    if tonumber(_ED.user_info.user_grade) < tonumber(need_user_lv[tonumber(e_index)]) then
                        Text_lv_tip:setString(string.format(_new_interface_text[163],zstring.tonumber(need_user_lv[tonumber(e_index)])))
                        Button_equ_up_sp:setTouchEnabled(false)
                        Text_equ_up_gold_n_1:setVisible(false)
                        Image_gold_icon_1:setVisible(false)
                    else
                        Text_lv_tip:setString("")
                        Button_equ_up_sp:setTouchEnabled(true)
                        Text_equ_up_gold_n_1:setVisible(true)
                        Image_gold_icon_1:setVisible(true)
                    end
                else
                    Text_lv_tip:setString("")
                    Button_equ_up_sp:setTouchEnabled(true)
                    Text_equ_up_gold_n_1:setVisible(true)
                    Image_gold_icon_1:setVisible(true)
                end
            end
        end
    end

    Button_equ_up_sp._data = self.equip
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_formation_equipment_up_grade",
    _widget = Button_equ_up_sp,
    _invoke = nil,
    _interval = 0.5,})
    state_machine.excute("notification_center_update",0,"push_notification_center_formation_equipment_up_grade")

    --等级上限控制
    local equipMaxLv = tonumber(UpProductMould[#UpProductMould][2])
    local Panel_n_1 = ccui.Helper:seekWidgetByName(root,"Panel_n_1")
    local Text_qianghua_lv_max = ccui.Helper:seekWidgetByName(root,"Text_qianghua_lv_max")
    Text_qianghua_lv_max:setVisible(false)
    Panel_n_1:setVisible(true)
    if tonumber(levels[tonumber(e_index)]) >= equipMaxLv then
        Panel_n_1:setVisible(false)
        Text_qianghua_lv_max:setVisible(true)
    end

    local picAll = zstring.split(shipEquip[2], ",")
    local pic = picAll[tonumber(e_index)]
    --知道品质了去换算颜色
    local picIndex = 1--shipOrEquipSetColour(tonumber(pic))

    --经验条
    local LoadingBar_equ_exp = ccui.Helper:seekWidgetByName(self.roots[1], "LoadingBar_equ_exp")

    local Text_exp_n = ccui.Helper:seekWidgetByName(self.roots[1], "Text_exp_n")
    --找到这一级需要的经验
    local needExp = dms.int(dms["equipment_refining_experience_param"], levels[tonumber(e_index)], picIndex+2)
    local expAll = zstring.split(shipEquip[3], ",")
    local oldExp = expAll[tonumber(e_index)]

    if zstring.tonumber(self.equip.useExp) > 0 then
        local all_Exp = tonumber(self.equip.useExp) + tonumber(oldExp)
        LoadingBar_equ_exp:setPercent(tonumber(all_Exp)/needExp*100)
        Text_exp_n:setString(all_Exp.."/"..needExp)
    else
        LoadingBar_equ_exp:setPercent(tonumber(oldExp)/needExp*100)
        Text_exp_n:setString(oldExp.."/"..needExp)
    end
end

function SmEquipmentTabUpProduct:onUpdate(dt)
    if self.actionOver == true then
        self.actionOver = false
        local function executeMoveFunc()
            local function executeMoveHeroOverFunc()
                self.actionOver = true
            end
            if self.roots[1] ~= nil then
                ccui.Helper:seekWidgetByName(self.roots[1], "Panel_equ_icon"):runAction(cc.Sequence:create(
                    cc.MoveTo:create(1, cc.p(ccui.Helper:seekWidgetByName(self.roots[1], "Panel_equ_icon"):getPositionX() , ccui.Helper:seekWidgetByName(self.roots[1], "Panel_equ_icon"):getPositionY() - 10)),
                    cc.CallFunc:create(executeMoveHeroOverFunc)
                ))
            end
        end
        if self.roots[1] ~= nil then
            ccui.Helper:seekWidgetByName(self.roots[1], "Panel_equ_icon"):runAction(cc.Sequence:create(
                cc.MoveTo:create(1, cc.p(ccui.Helper:seekWidgetByName(self.roots[1], "Panel_equ_icon"):getPositionX() , ccui.Helper:seekWidgetByName(self.roots[1], "Panel_equ_icon"):getPositionY() + 10)),
                cc.CallFunc:create(executeMoveFunc)
            ))
        end
    end
end


function SmEquipmentTabUpProduct:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow     
    self:onInit()
    return self
end

function SmEquipmentTabUpProduct:onInit()
    local csbSmEquipmentTabUpProduct = csb.createNode("packs/EquipStorage/sm_equipment_qianghua_tab_1.csb")
    local root = csbSmEquipmentTabUpProduct:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmEquipmentTabUpProduct)

    --升级请求
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1],"Button_equ_up_sj"), nil, 
    {
        terminal_name = "sm_equipment_tab_up_product_equip_upgrade", 
        terminal_state = 0,
        m_type = 0,
        button_name = "Button_equ_up_sj",
        isPressedActionEnabled = true
    }, 
    nil, 0)

    --快速升级请求或者快速添加
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1],"Button_equ_up_yj"), nil, 
    {
        terminal_name = "sm_equipment_tab_up_product_equip_upgrade", 
        terminal_state = 0,
        m_type = 1,
        button_name = "Button_equ_up_yj",
        isPressedActionEnabled = true
    }, 
    nil, 0)

    --升品请求
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1],"Button_equ_up_sp"), nil, 
    {
        terminal_name = "sm_equipment_tab_up_product_request", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_equ_up_kssj_0"), nil, 
    {
        terminal_name = "sm_equipment_tab_up_product_open_auto_upgrade", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    --宝物吞噬进入
    for i=1, 4 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1],"Panel_role_up_quality_box_"..i), nil, 
        {
            terminal_name = "sm_equipment_tab_up_product_open_swallowed", 
            terminal_state = 0,
            isPressedActionEnabled = true
        }, 
        nil, 0)
    end

    local Panel_cxdh = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_cxdh")
    Panel_cxdh:removeAllChildren(true)

    local jsonFile = "sprite/sprite_zhuangbei_qh.json"
    local atlasFile = "sprite/sprite_zhuangbei_qh.atlas"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
    Panel_cxdh:addChild(animation)

    -- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1],"Button_equ_up_kssj"), nil, 
    -- {
    --     terminal_name = "sm_equipment_tab_up_product_treasure_upgrade", 
    --     terminal_state = 0,
    --     isPressedActionEnabled = true
    -- }, 
    -- nil, 0)

    
    
	
    self:onUpdateDraw()
end

function SmEquipmentTabUpProduct:onExit()
    state_machine.remove("sm_equipment_tab_up_product_display")
    state_machine.remove("sm_equipment_tab_up_product_hide")
    state_machine.remove("sm_equipment_tab_up_product_update_draw")
    state_machine.remove("sm_equipment_tab_up_product_change_ship")
    state_machine.remove("sm_equipment_tab_up_product_equip_upgrade")
    state_machine.remove("sm_equipment_tab_up_product_request")
	state_machine.remove("sm_equipment_tab_up_product_treasure_upgrade")
    state_machine.remove("sm_equipment_tab_up_product_open_auto_upgrade")

    -- FURY/NARUTO: Naruto (27) tampoco puede quedarse con los cerrojos puestos.
    -- La subida (Button_equ_up_sj / _yj) bloquea el boton de volver de la
    -- Formacion (formation_back_to_home_page), sus pestanas, la lista de
    -- heroes y los huecos de equipo, y solo los suelta el callback o el final
    -- de la animacion de niveles; si la ventana se cierra antes, los dos se
    -- saltan la suelta (response.node.roots ya es nil) y la Formacion queda
    -- congelada. Los otros cinco proyectos los sueltan aqui; Naruto faltaba.
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        state_machine.unlock("formation_switch_paging_information", 0, "")
        state_machine.unlock("hero_listview_set_index", 0, "")
        state_machine.unlock("hero_icon_list_cell_set_index", 0, "")
        state_machine.unlock("sm_equipment_qianghua_to_select", 0, "")
        state_machine.unlock("sm_equipment_tab_up_product_equip_upgrade", 0, "")
        state_machine.unlock("formation_back_to_home_page", 0, "")
        state_machine.unlock("formation_back_to_home_activity", 0, "")
        state_machine.unlock("hero_develop_back_to_home_activity", 0, "")
        -- Y el toque en los huecos de equipo de la Formacion, que la subida
        -- tambien bloquea (equip_upgrade, arriba).
        state_machine.unlock("equip_icon_cell_change_ship_equip", 0, "")
    end   
end