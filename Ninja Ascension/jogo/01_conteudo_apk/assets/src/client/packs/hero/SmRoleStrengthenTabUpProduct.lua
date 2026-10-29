-- ----------------------------------------------------------------------------------------------------
-- 说明：角色升品
-------------------------------------------------------------------------------------------------------
SmRoleStrengthenTabUpProduct = class("SmRoleStrengthenTabUpProductClass", Window)

local sm_role_strengthen_tab_up_product_open_terminal = {
    _name = "sm_role_strengthen_tab_up_product_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmRoleStrengthenTabUpProductClass")
        if nil == _homeWindow then
            local panel = SmRoleStrengthenTabUpProduct:new():init(params)
            fwin:open(panel)
        else
            fwin:close(fwin:find("SmRoleStrengthenTabUpProductClass"))
            local panel = SmRoleStrengthenTabUpProduct:new():init(params)
            fwin:open(panel)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_role_strengthen_tab_up_product_close_terminal = {
    _name = "sm_role_strengthen_tab_up_product_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmRoleStrengthenTabUpProductClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmRoleStrengthenTabUpProductClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_role_strengthen_tab_up_product_open_terminal)
state_machine.add(sm_role_strengthen_tab_up_product_close_terminal)
state_machine.init()
    
function SmRoleStrengthenTabUpProduct:ctor()
    self.super:ctor()
    self.roots = {}
    self.ship_id = 0
    app.load("client.cells.prop.prop_icon_new_cell")
    self.materialEnough = true
    self.goodsEnough = true
    self.levelEnough = true


    local function init_sm_role_strengthen_tab_up_product_terminal()
        -- 显示界面
        local sm_role_strengthen_tab_up_product_display_terminal = {
            _name = "sm_role_strengthen_tab_up_product_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmRoleStrengthenTabUpProductWindow = fwin:find("SmRoleStrengthenTabUpProductClass")
                if SmRoleStrengthenTabUpProductWindow ~= nil then
                    SmRoleStrengthenTabUpProductWindow:setVisible(true)
                    instance:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_role_strengthen_tab_up_product_hide_terminal = {
            _name = "sm_role_strengthen_tab_up_product_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmRoleStrengthenTabUpProductWindow = fwin:find("SmRoleStrengthenTabUpProductClass")
                if SmRoleStrengthenTabUpProductWindow ~= nil then
                    SmRoleStrengthenTabUpProductWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 请求升品
        local sm_role_strengthen_tab_up_product_request_terminal = {
            _name = "sm_role_strengthen_tab_up_product_request",
            _init = function (terminal) 
                app.load("client.packs.hero.GeneralsStarUpSuccessWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("sm_role_strengthen_tab_up_product_request", 0, "")
                local ship_id = instance.ship_id
                local currShip = getShipByTalent(_ED.user_ship[ship_id])
                local oldshipInfo = {
                    Order = currShip.Order,
                    hero_fight = currShip.hero_fight,
                    StarRating = currShip.StarRating,
                    ship_template_id = currShip.ship_template_id,
                    evolution_status = currShip.evolution_status,
                    ship_wisdom = currShip.ship_wisdom,
                    ship_skin_info = currShip.ship_skin_info,
                }
                if instance.materialEnough == false then
                    TipDlg.drawTextDailog(_new_interface_text[27])
                    state_machine.unlock("sm_role_strengthen_tab_up_product_request", 0, "")
                    return
                end
                if instance.goodsEnough == false then
                    TipDlg.drawTextDailog(_new_interface_text[28])
                    state_machine.unlock("sm_role_strengthen_tab_up_product_request", 0, "")
                    return
                end
                if instance.levelEnough == false then
                    TipDlg.drawTextDailog(_new_interface_text[29])
                    state_machine.unlock("sm_role_strengthen_tab_up_product_request", 0, "")
                    return
                end
                local function responseAdvenceHeroCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:onUpdateDraw()
                            local currShip = getShipByTalent(_ED.user_ship[ship_id])
                            setShipPushData(ship_id,2,-1)
                            
                            state_machine.excute("generals_star_up_success_window_open",0,{oldshipInfo,currShip,1})
                            
                            if fwin:find("HeroDevelopClass") ~= nil then
                                state_machine.excute("sm_role_strengthen_tab_update_ship_info",0,{ship_id})
                                state_machine.excute("hero_develop_page_strength_to_update_all_icon",0,currShip)
                            else
                                -- state_machine.excute("hero_icon_listview_icon_push_updata",0,"hero_icon_listview_icon_push_updata.")
                                for i, v in pairs(_ED.user_formetion_status) do
                                    if tonumber(v) == tonumber(ship_id) then
                                        state_machine.excute("formation_set_ship",0,currShip)
                                        break
                                    end
                                end
                                state_machine.excute("hero_icon_listview_update_all_icon",0,currShip)
                            end
                        end
                        state_machine.unlock("formation_back_to_home_activity", 0, "")
                        state_machine.unlock("sm_role_strengthen_tab_up_product_request", 0, "")
                    else
                        state_machine.unlock("formation_back_to_home_activity", 0, "")
                        state_machine.unlock("sm_role_strengthen_tab_up_product_request", 0, "")
                    end
                end
                local props = zstring.split(self.prop_consumption, ",")
                if #props < 4 then
                    state_machine.unlock("sm_role_strengthen_tab_up_product_request", 0, "")
                    return
                end
                state_machine.lock("formation_back_to_home_activity", 0, "")
                
                protocol_command.ship_grow_up.param_list = ""..ship_id.."\r\n".." ".."\r\n"..self.prop_consumption.."\r\n".." ".."\r\n1"
                NetworkManager:register(protocol_command.ship_grow_up.code, nil, nil, nil, instance, responseAdvenceHeroCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新
        local sm_role_strengthen_tab_up_product_update_draw_terminal = {
            _name = "sm_role_strengthen_tab_up_product_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 改变id
        local sm_role_strengthen_tab_up_product_change_ship_terminal = {
            _name = "sm_role_strengthen_tab_up_product_change_ship",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.ship_id = params
                state_machine.excute("notification_center_update",0,"push_notification_center_hero_strength_evolution_button")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_role_strengthen_tab_open_auto_up_product_terminal = {
            _name = "sm_role_strengthen_tab_open_auto_up_product",
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
                if instance.goodsEnough == false then
                    TipDlg.drawTextDailog(_new_interface_text[28])
                    return
                end
                if instance.levelEnough == false then
                    TipDlg.drawTextDailog(_new_interface_text[29])
                    return
                end
                app.load("client.packs.hero.SmAutoUpProduct")
                state_machine.excute("sm_auto_up_product_window_open", 0, _ED.user_ship[instance.ship_id])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_role_strengthen_tab_up_product_display_terminal)
        state_machine.add(sm_role_strengthen_tab_up_product_hide_terminal)
        state_machine.add(sm_role_strengthen_tab_up_product_terminal)
        state_machine.add(sm_role_strengthen_tab_up_product_terminal)
        state_machine.add(sm_role_strengthen_tab_up_product_request_terminal)
        state_machine.add(sm_role_strengthen_tab_up_product_update_draw_terminal)
        state_machine.add(sm_role_strengthen_tab_up_product_change_ship_terminal)
        state_machine.add(sm_role_strengthen_tab_open_auto_up_product_terminal)
        
        state_machine.init()
    end
    init_sm_role_strengthen_tab_up_product_terminal()
end

--El COSTE del siguiente escalon: los cuatro materiales y la plata.
--Con el heroe en el TOPE no hay fila que leer (`ship_grow_requirement` se
--acaba en el escalon 24, que es donde corta `hero_advance:requirement/2`),
--asi que la maqueta se quedaba con su texto de relleno: los cuatro "1111"
--de `Text_role_up_quality_num_N` y el "123123" de
--`Text_role_up_quality_gold_n`, tal cual vienen dentro del .csb.
--Se esconde el coste y se apaga el boton, que es lo que YA hace la pestana
--de estrellas en su tope (`SmRoleStrengthenTabRisingStar.lua:561-567` y su
--`hideMoney`). No se inventa ningun numero ni ningun texto.
function SmRoleStrengthenTabUpProduct:showCost(isTrue)
    local root = self.roots[1]
    ccui.Helper:seekWidgetByName(root, "Text_role_up_quality_gold_n"):setVisible(isTrue)
    ccui.Helper:seekWidgetByName(root, "Image_gold_icon"):setVisible(isTrue)
    for i = 1, 4 do
        ccui.Helper:seekWidgetByName(root, "Image_props_bg_"..i):setVisible(isTrue)
        ccui.Helper:seekWidgetByName(root, "Panel_role_up_quality_box_"..i):setVisible(isTrue)
        ccui.Helper:seekWidgetByName(root, "Panel_role_up_quality_icon_"..i):setVisible(isTrue)
        ccui.Helper:seekWidgetByName(root, "Image_role_up_quality_add_"..i):setVisible(isTrue)
        ccui.Helper:seekWidgetByName(root, "Text_role_up_quality_num_"..i):setVisible(isTrue)
    end
    local Button_role_up_quality = ccui.Helper:seekWidgetByName(root, "Button_role_up_quality")
    Button_role_up_quality:setBright(isTrue)
    Button_role_up_quality:setTouchEnabled(isTrue)
end

function SmRoleStrengthenTabUpProduct:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    if zstring.tonumber(self.ship_id) == 0 then
        return
    end
    self.prop_consumption = ""
    local existCount = 0
    local propCount = 0
    local update_group_id = dms.int(dms["ship_mould"], _ED.user_ship[self.ship_id].ship_template_id, ship_mould.required_material_id)
    local update_group = dms.searchs(dms["ship_grow_requirement"], ship_grow_requirement.need_iron, update_group_id)

    self.materialEnough = true
    self.goodsEnough = true
    self.levelEnough = true
    local Image_gold_icon = ccui.Helper:seekWidgetByName(root, "Image_gold_icon")
    self.maxed = tonumber(_ED.user_ship[self.ship_id].Order) >= #update_group
    self:showCost(not self.maxed)
    if self.maxed and cc.Application:getInstance():getTargetPlatform()==cc.PLATFORM_OS_WINDOWS then
        -- Display the actual completed Advance steps, never the empty cost 0/0.
        existCount=#update_group
        propCount=#update_group
    end
    if not self.maxed then
        local needData = update_group[tonumber(_ED.user_ship[self.ship_id].Order) + 1]
        local requirement = dms.atoi(needData , ship_grow_requirement.need_silver)
        --金钱
        local Text_role_up_quality_gold_n = ccui.Helper:seekWidgetByName(root, "Text_role_up_quality_gold_n")
        local need_level = dms.atoi(needData , ship_grow_requirement.need_level)
        local enoughColor = cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3])
        local notEnoughColor = cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3])
        if __lua_project_id == __lua_project_l_digital and tipStringInfo_color_type_assemble then 
            -- DSC重塑
            enoughColor = cc.c3b(tipStringInfo_color_type_assemble[1][1], tipStringInfo_color_type_assemble[1][2], tipStringInfo_color_type_assemble[1][3])
            notEnoughColor = cc.c3b(tipStringInfo_color_type_assemble[2][1], tipStringInfo_color_type_assemble[2][2], tipStringInfo_color_type_assemble[2][3])
        end
        if tonumber(_ED.user_ship[self.ship_id].ship_grade) < need_level then
            self.levelEnough = false
            Text_role_up_quality_gold_n:setString(string.format(_new_interface_text[6],need_level))
            Text_role_up_quality_gold_n:setColor(notEnoughColor)
            Text_role_up_quality_gold_n:setPositionX(Image_gold_icon:getPositionX() - Image_gold_icon:getContentSize().width / 2 + 5)
            Image_gold_icon:setVisible(false)
        else
            Text_role_up_quality_gold_n:setString(requirement)
            Text_role_up_quality_gold_n:setPositionX(Image_gold_icon:getPositionX() + Image_gold_icon:getContentSize().width / 2)
            if requirement > tonumber(_ED.user_info.user_silver) then
                self.goodsEnough = false
                Text_role_up_quality_gold_n:setColor(notEnoughColor)
            else
                Text_role_up_quality_gold_n:setColor(enoughColor)
            end
            Image_gold_icon:setVisible(true)
        end

        --道具
        for i=1, 4 do
            local Panel_role_up_quality_box = ccui.Helper:seekWidgetByName(root, "Panel_role_up_quality_box_"..i)
            local Panel_role_up_quality_icon = ccui.Helper:seekWidgetByName(root, "Panel_role_up_quality_icon_"..i)
            local Image_role_up_quality_add = ccui.Helper:seekWidgetByName(root, "Image_role_up_quality_add_"..i)
            local Text_role_up_quality_num = ccui.Helper:seekWidgetByName(root, "Text_role_up_quality_num_"..i)
            Panel_role_up_quality_box:removeAllChildren(true)
            local propMould = dms.atoi(needData , ship_grow_requirement.need_prop1 + (i - 1) * 2)
            local propNumber = dms.atoi(needData , ship_grow_requirement.need_prop1_count + (i - 1) * 2)
            local existNumber = tonumber(getPropAllCountByMouldId(propMould))            
            if existNumber > 0 then
                if i == 4 then
                    self.prop_consumption = self.prop_consumption..fundPropWidthId(propMould).user_prop_id
                else
                    self.prop_consumption = self.prop_consumption..fundPropWidthId(propMould).user_prop_id..","
                end
                
            end
            Text_role_up_quality_num:setString(existNumber.."/"..propNumber)
            local cell = PropIconNewCell:createCell()
            if existNumber >= propNumber then
                Image_role_up_quality_add:setVisible(false)
                Panel_role_up_quality_icon:setVisible(false)
                Text_role_up_quality_num:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
                cell.existNumber = existNumber
                cell.totalNumber = propNumber
                cell:init(cell.enum_type._SHOW_PROP_GETWAY_INFORMATION, propMould)
                
            else
                self.materialEnough = false
                Image_role_up_quality_add:setVisible(true)
                Panel_role_up_quality_icon:setVisible(true)
                Text_role_up_quality_num:setColor(cc.c3b(color_Type[5][1], color_Type[5][2], color_Type[5][3]))
                cell.existNumber = existNumber
                cell.totalNumber = propNumber
                cell:init(cell.enum_type._SHOW_PROP_GETWAY_INFORMATION, propMould,false,true)
            end
            
            if existNumber >= propNumber then
                existNumber = propNumber
            end
            existCount = existCount + existNumber
            propCount = propCount + propNumber 

            -- local cell = self:getItemCell(propMould)
            Panel_role_up_quality_box:addChild(cell)
        end
    end
    if fwin:find("SmRoleStrengthenTabClass") ~= nil then
        state_machine.excute("sm_role_strengthen_tab_update_Loading",0,{existCount,propCount,1})
    end
    if fwin:find("SmRoleStrengthenTabSpecialAttributesClass") ~= nil then
        state_machine.excute("sm_role_strengthen_tab_special_attributes_update_Loading",0,{existCount,propCount,1})
    end

    if funOpenDrawTip(169, false) == true or self.maxed then
        ccui.Helper:seekWidgetByName(self.roots[1],"Button_role_up_quality_quick"):setVisible(false)
    else
        ccui.Helper:seekWidgetByName(self.roots[1],"Button_role_up_quality_quick"):setVisible(true)
    end
end

function SmRoleStrengthenTabUpProduct:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow     
    self.ship_id = params[2]
    self:onInit()
    return self
end

function SmRoleStrengthenTabUpProduct:onInit()
    local csbSmRoleStrengthenTabUpProduct = csb.createNode("packs/HeroStorage/sm_role_strengthen_tab_cell_1.csb")
    local root = csbSmRoleStrengthenTabUpProduct:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmRoleStrengthenTabUpProduct)

    --进化请求
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1],"Button_role_up_quality"), nil, 
    {
        terminal_name = "sm_role_strengthen_tab_up_product_request", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_hero_strength_evolution_button",
        _widget = ccui.Helper:seekWidgetByName(self.roots[1], "Button_role_up_quality"),
        _invoke = nil,
        _interval = 0.5,})
	
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1],"Button_role_up_quality_quick"), nil, 
    {
        terminal_name = "sm_role_strengthen_tab_open_auto_up_product", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    self:onUpdateDraw()
end

function SmRoleStrengthenTabUpProduct:onExit()
    state_machine.remove("sm_role_strengthen_tab_up_product_display")
    state_machine.remove("sm_role_strengthen_tab_up_product_hide")
    state_machine.remove("sm_role_strengthen_tab_up_product_update_draw")
	state_machine.remove("sm_role_strengthen_tab_up_product_change_ship")
    state_machine.remove("sm_role_strengthen_tab_open_auto_up_product")
end