-- ----------------------------------------------------------------------------------------------------
-- 说明：角色升级
-------------------------------------------------------------------------------------------------------
SmRoleStrengthenTabUpgrade = class("SmRoleStrengthenTabUpgradeClass", Window)

local sm_role_strengthen_tab_up_grade_open_terminal = {
    _name = "sm_role_strengthen_tab_up_grade_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmRoleStrengthenTabUpgradeClass")
        if nil == _homeWindow then
            local panel = SmRoleStrengthenTabUpgrade:new():init(params)
            fwin:open(panel)
        else
            fwin:close(fwin:find("SmRoleStrengthenTabUpgradeClass"))
            local panel = SmRoleStrengthenTabUpgrade:new():init(params)
            fwin:open(panel)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_role_strengthen_tab_up_grade_close_terminal = {
    _name = "sm_role_strengthen_tab_up_grade_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmRoleStrengthenTabUpgradeClass")
        if nil ~= _homeWindow then
            -- ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("images/ui/effice/effice_skill_qh/effice_skill_qh.ExportJson")
    		fwin:close(fwin:find("SmRoleStrengthenTabUpgradeClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_role_strengthen_tab_up_grade_open_terminal)
state_machine.add(sm_role_strengthen_tab_up_grade_close_terminal)
state_machine.init()
    
function SmRoleStrengthenTabUpgrade:ctor()
    self.super:ctor()
    self.roots = {}
    self.propMouldIdArry = {}
    app.load("client.cells.prop.prop_icon_new_cell")
    self.prop_dec = {}
    self.user_exp_number = 0
    local function init_sm_role_strengthen_tab_up_grade_terminal()
        -- 显示界面
        local sm_role_strengthen_tab_up_grade_display_terminal = {
            _name = "sm_role_strengthen_tab_up_grade_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmRoleStrengthenTabUpgradeWindow = fwin:find("SmRoleStrengthenTabUpgradeClass")
                if SmRoleStrengthenTabUpgradeWindow ~= nil then
                    SmRoleStrengthenTabUpgradeWindow:setVisible(true)
                    instance:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_role_strengthen_tab_up_grade_hide_terminal = {
            _name = "sm_role_strengthen_tab_up_grade_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmRoleStrengthenTabUpgradeWindow = fwin:find("SmRoleStrengthenTabUpgradeClass")
                if SmRoleStrengthenTabUpgradeWindow ~= nil then
                    SmRoleStrengthenTabUpgradeWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 强化经验
        local sm_role_strengthen_tab_up_grade_strengthen_exp_terminal = {
            _name = "sm_role_strengthen_tab_up_grade_strengthen_exp",
            _init = function (terminal) 
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cells = params
                --处理不能使用道具的情况
                local can_upgrade = false
                if tonumber(_ED.user_ship[""..instance.ship_id].ship_grade) < tonumber(_ED.user_info.user_grade) then
                    can_upgrade = true
                elseif tonumber(_ED.user_ship[""..instance.ship_id].exprience) < tonumber(_ED.user_ship[""..instance.ship_id].grade_need_exprience) then
                    can_upgrade = true
                end

                if can_upgrade == false then
                    -- state_machine.excute("sm_role_strengthen_tab_up_exp_loading",0,{_ED.user_ship[""..instance.ship_id].exprience,_ED.user_ship[""..instance.ship_id].grade_need_exprience,2})
                    state_machine.excute("sm_role_strengthen_tab_show_prop_number",0,"0")
                    cells.one = false
                    if cells ~= nil or cells.iscounts ~= nil then
                        cells.iscounts = 0
                    end
                    instance.user_exp_number = 0
                    TipDlg.drawTextDailog(_new_interface_text[32])
                    state_machine.unlock("sm_role_strengthen_tab_up_grade_strengthen_exp")
                    state_machine.unlock("formation_back_to_home_activity", 0, "")
                    state_machine.unlock("hero_listview_set_index", 0, "")
                    state_machine.unlock("hero_icon_list_cell_set_index", 0, "")
                    state_machine.unlock("sm_role_strengthen_tab_open_auto_upgrade", 0, "")
                    return
                end
                local function prop_buy(propMouldId)
                    local mouldId = tonumber(propMouldId)
                    local index = 0
                    for i ,v in pairs(instance.propMouldIdArry) do
                        if tonumber(v) == mouldId then
                            index = i
                            break
                        end
                    end
                    if funOpenDrawTip( index + 131) == false then
                        if zstring.tonumber(instance.user_exp_number) ~= 1 then
                            cells.one = false
                            app.load("client.shop.SmShopBuyExpProps")
                            state_machine.excute("sm_shop_buy_exp_props_open",0,{mouldId , instance.prop_dec[index]})
                            -- state_machine.unlock("sm_role_strengthen_tab_up_grade_strengthen_exp")
                        end
                    else
                        state_machine.unlock("sm_role_strengthen_tab_up_grade_strengthen_exp")
                        state_machine.unlock("formation_back_to_home_activity", 0, "")
                        state_machine.unlock("hero_listview_set_index", 0, "")
                        state_machine.unlock("hero_icon_list_cell_set_index", 0, "")
                        state_machine.unlock("sm_role_strengthen_tab_open_auto_upgrade", 0, "")
                    end
                    if cells ~= nil or cells.iscounts ~= nil then
                        cells.iscounts = 0
                    end 
                    instance.user_exp_number = 0
                end
                if cells.user_props == nil then
                    cells.one = false
                    prop_buy(cells.prop)
                    state_machine.unlock("sm_role_strengthen_tab_up_grade_strengthen_exp")
                    state_machine.unlock("formation_back_to_home_activity", 0, "")
                    state_machine.unlock("hero_listview_set_index", 0, "")
                    state_machine.unlock("hero_icon_list_cell_set_index", 0, "")
                    state_machine.unlock("sm_role_strengthen_tab_open_auto_upgrade", 0, "")
                    return
                end
                local propInfo = cells.user_props.user_prop_id
                if tonumber(cells.user_props.prop_number) <= 0 then
                    state_machine.excute("sm_role_strengthen_tab_show_prop_number",0,"0")
                    cells.one = false
                    prop_buy(cells.prop)
                    state_machine.unlock("sm_role_strengthen_tab_up_grade_strengthen_exp")
                    state_machine.unlock("formation_back_to_home_activity", 0, "")
                    state_machine.unlock("hero_listview_set_index", 0, "")
                    state_machine.unlock("hero_icon_list_cell_set_index", 0, "")
                    state_machine.unlock("sm_role_strengthen_tab_open_auto_upgrade", 0, "")
                    return
                end

                cells.ship_id = instance.ship_id
                local propInfo = cells.user_props.user_prop_id
                local buyMould = cells.prop
                local oldLv = _ED.user_ship[instance.ship_id].ship_grade
                local useProp = ""
                local function responseShipEscalateCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            -- cells.iscounts = zstring.tonumber(cells.iscounts) + 1
                            -- if cells.one == false then
                                response.node.user_exp_number = 0
                            -- end
                            
                            if cells == nil or cells.prop == nil or fundPropWidthId(cells.prop) == nil then
                                --不打开购买界面
                                state_machine.excute("sm_role_strengthen_tab_up_grade_update_draw",0,"")
                                -- prop_buy(buyMould) 
                                state_machine.unlock("sm_role_strengthen_tab_up_grade_strengthen_exp")
                                state_machine.unlock("formation_back_to_home_activity", 0, "")
                                state_machine.unlock("hero_listview_set_index", 0, "")
                                state_machine.unlock("hero_icon_list_cell_set_index", 0, "")
                                state_machine.unlock("sm_role_strengthen_tab_open_auto_upgrade", 0, "")
                                --等级提升后的刷新
                                if tonumber(_ED.user_ship[instance.ship_id].ship_grade) > tonumber(oldLv) then
                                    oldLv = _ED.user_ship[instance.ship_id].ship_grade
                                    smFightingChange()
                                    if fwin:find("FormationTigerGateClass") ~= nil then
                                        state_machine.excute("sm_role_formation_strengthen_tab_play_control_effect",0,"")
                                    end
                                    if fwin:find("SmRoleStrengthenTabClass") ~= nil then
                                        state_machine.excute("sm_role_strengthen_tab_play_control_effect", 0, 0)
                                        state_machine.excute("hero_develop_page_strength_to_update_all_icon",0,_ED.user_ship[response.node.ship_id])
                                    end
                                    state_machine.excute("sm_role_strengthen_tab_up_stop_update",0,"")
                                    --推送数据的写入
                                    setShipPushData(instance.ship_id,-1,-1)
                                end
                            else
                                ccui.Helper:seekWidgetByName(cells.roots[1], "Label_l-order_level"):setString(zstring.tonumber(fundPropWidthId(cells.prop).prop_number))
                                --卡牌强化界面的进度条刷新
                                if fwin:find("SmRoleStrengthenTabClass") ~= nil then
                                    state_machine.excute("sm_role_strengthen_tab_up_exp_loading",0,{zstring.tonumber(_ED.user_ship[instance.ship_id].exprience),_ED.user_ship[instance.ship_id].grade_need_exprience,2})
                                end
                                --阵容界面的进度条刷新
                                if fwin:find("SmRoleStrengthenTabSpecialAttributesClass") ~= nil then
                                    state_machine.excute("sm_role_strengthen_tab_special_attributes_up_exp_loading",0,{zstring.tonumber(_ED.user_ship[instance.ship_id].exprience),_ED.user_ship[instance.ship_id].grade_need_exprience,2})
                                end
                                --等级提升后的刷新
                                if tonumber(_ED.user_ship[instance.ship_id].ship_grade) > tonumber(oldLv) then
                                    oldLv = _ED.user_ship[instance.ship_id].ship_grade
                                    smFightingChange()
                                    if fwin:find("FormationTigerGateClass") ~= nil then
                                        state_machine.excute("sm_role_formation_strengthen_tab_play_control_effect",0,"")
                                    end
                                    if fwin:find("SmRoleStrengthenTabClass") ~= nil then
                                        state_machine.excute("sm_role_strengthen_tab_play_control_effect", 0, 0)
                                        state_machine.excute("hero_develop_page_strength_to_update_all_icon",0,_ED.user_ship[response.node.ship_id])
                                    end
                                    state_machine.excute("sm_role_strengthen_tab_up_stop_update",0,"")
                                    --推送数据的写入
                                    setShipPushData(instance.ship_id,-1,-1)
                                end
                                --解锁
                                state_machine.unlock("sm_role_strengthen_tab_up_grade_strengthen_exp")
                                state_machine.unlock("formation_back_to_home_activity", 0, "")
                                state_machine.unlock("hero_listview_set_index", 0, "")
                                state_machine.unlock("hero_icon_list_cell_set_index", 0, "")
                                state_machine.unlock("sm_role_strengthen_tab_open_auto_upgrade", 0, "")
                            end
                        else
                            --解锁
                            state_machine.unlock("sm_role_strengthen_tab_up_grade_strengthen_exp")
                            state_machine.unlock("formation_back_to_home_activity", 0, "")
                            state_machine.unlock("hero_listview_set_index", 0, "")
                            state_machine.unlock("hero_icon_list_cell_set_index", 0, "")
                            state_machine.unlock("sm_role_strengthen_tab_open_auto_upgrade", 0, "")
                        end
                    else
                        --解锁
                        state_machine.unlock("sm_role_strengthen_tab_up_grade_strengthen_exp")
                        state_machine.unlock("formation_back_to_home_activity", 0, "")
                        state_machine.unlock("hero_listview_set_index", 0, "")
                        state_machine.unlock("hero_icon_list_cell_set_index", 0, "")
                        state_machine.unlock("sm_role_strengthen_tab_open_auto_upgrade", 0, "")
                    end
                end
                instance._f_cell = cells
                --先判断是否放开按钮
                if cells.one == false then
                    --放开了
                    if tonumber(instance.user_exp_number) == 0 then
                        instance.user_exp_number = 1
                        playEffect(formatMusicFile("effect", 9993))
                        local Panel_usedh_x = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_usedh_" .. instance._f_cell.__p_index)
                        if Panel_usedh_x ~= nil then
                            -- draw.createEffect("effice_skill_qh", "images/ui/effice/effice_skill_qh/effice_skill_qh.ExportJson", Panel_usedh_x, 1, 100)
                            Panel_usedh_x:removeAllChildren(true)
                            local effice_skill_qh = ccs.Armature:create("effice_skill_qh")
                            effice_skill_qh:removeFromParent(true)
                            effice_skill_qh:getAnimation():playWithIndex(0)
                            Panel_usedh_x:addChild(effice_skill_qh)
                            effice_skill_qh:setPosition(cc.p((Panel_usedh_x:getContentSize().width - effice_skill_qh:getContentSize().width)/2+effice_skill_qh:getContentSize().width/2, (Panel_usedh_x:getContentSize().height - effice_skill_qh:getContentSize().height)/2+effice_skill_qh:getContentSize().height/2))
                        end
                    end
                    useProp = propInfo..":"..instance.user_exp_number
                    state_machine.lock("sm_role_strengthen_tab_up_grade_strengthen_exp")
                    state_machine.lock("formation_back_to_home_activity", 0, "")
                    state_machine.lock("hero_listview_set_index", 0, "")
                    state_machine.lock("hero_icon_list_cell_set_index", 0, "")
                    state_machine.lock("sm_role_strengthen_tab_open_auto_upgrade", 0, "")
                    state_machine.lock("sm_role_strengthen_tab_open_auto_upgrade", 0, "")
                    protocol_command.ship_escalate.param_list = "0" .. "\r\n" .. instance.ship_id .. "\r\n" .. useProp .. "\r\n" 
                    NetworkManager:register(protocol_command.ship_escalate.code, nil, nil, nil, instance, responseShipEscalateCallBack, false, nil)
                elseif cells.one == true then
                    state_machine.lock("sm_role_strengthen_tab_up_grade_strengthen_exp")
                    state_machine.lock("formation_back_to_home_activity", 0, "")
                    state_machine.lock("hero_listview_set_index", 0, "")
                    state_machine.lock("hero_icon_list_cell_set_index", 0, "")
                    state_machine.lock("sm_role_strengthen_tab_open_auto_upgrade", 0, "")
                    --没放开
                    if zstring.tonumber(cells.iscounts) > 2 and zstring.tonumber(cells.iscounts) <= 10 then
                        -- state_machine.lock("sm_role_strengthen_tab_up_grade_strengthen_exp")
                        fwin:addService({callback = function ( params )
                                params.user_exp_number = params.user_exp_number + 1
                                local isOver, number = params:calculationExpUp(cells,params.user_exp_number)
                                if isOver == false then
                                    state_machine.lock("sm_role_strengthen_tab_up_grade_strengthen_exp")
                                    state_machine.lock("formation_back_to_home_activity", 0, "")
                                    state_machine.lock("hero_listview_set_index", 0, "")
                                    state_machine.lock("hero_icon_list_cell_set_index", 0, "")
                                    state_machine.lock("sm_role_strengthen_tab_open_auto_upgrade", 0, "")
                                    useProp = propInfo..":"..number
                                    protocol_command.ship_escalate.param_list = "0" .. "\r\n" .. params.ship_id .. "\r\n" .. useProp .. "\r\n" 
                                    NetworkManager:register(protocol_command.ship_escalate.code, nil, nil, nil, params, responseShipEscalateCallBack, false, nil)
                                end
                            end,
                            delay = 0.2,
                            params = instance
                        })
                    elseif zstring.tonumber(cells.iscounts) > 10 then
                        -- state_machine.lock("sm_role_strengthen_tab_up_grade_strengthen_exp")
                        instance.user_exp_number = instance.user_exp_number + 1
                        local isOver, number = instance:calculationExpUp(cells,instance.user_exp_number)
                        if isOver == false then
                            state_machine.lock("sm_role_strengthen_tab_up_grade_strengthen_exp")
                            state_machine.lock("formation_back_to_home_activity", 0, "")
                            state_machine.lock("hero_listview_set_index", 0, "")
                            state_machine.lock("hero_icon_list_cell_set_index", 0, "")
                            state_machine.lock("sm_role_strengthen_tab_open_auto_upgrade", 0, "")
                            useProp = propInfo..":"..number
                            protocol_command.ship_escalate.param_list = "0" .. "\r\n" .. instance.ship_id .. "\r\n" .. useProp .. "\r\n" 
                            NetworkManager:register(protocol_command.ship_escalate.code, nil, nil, nil, instance, responseShipEscalateCallBack, false, nil)
                        end
                    else
                        -- state_machine.lock("sm_role_strengthen_tab_up_grade_strengthen_exp")
                        fwin:addService({callback = function ( params )
                                params.user_exp_number = params.user_exp_number + 1
                                local isOver, number = params:calculationExpUp(cells,params.user_exp_number)
                                if isOver == false then
                                    state_machine.lock("sm_role_strengthen_tab_up_grade_strengthen_exp")
                                    state_machine.lock("formation_back_to_home_activity", 0, "")
                                    state_machine.lock("hero_listview_set_index", 0, "")
                                    state_machine.lock("hero_icon_list_cell_set_index", 0, "")
                                    state_machine.lock("sm_role_strengthen_tab_open_auto_upgrade", 0, "")
                                    useProp = propInfo..":"..number
                                    protocol_command.ship_escalate.param_list = "0" .. "\r\n" .. params.ship_id .. "\r\n" .. useProp .. "\r\n" 
                                    NetworkManager:register(protocol_command.ship_escalate.code, nil, nil, nil, params, responseShipEscalateCallBack, false, nil)
                                end
                            end,
                            delay = 0.5,
                            params = instance
                        })
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新
        local sm_role_strengthen_tab_up_grade_update_draw_terminal = {
            _name = "sm_role_strengthen_tab_up_grade_update_draw",
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
        local sm_role_strengthen_tab_up_grade_change_ship_terminal = {
            _name = "sm_role_strengthen_tab_up_grade_change_ship",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.ship_id = params ~= nil and "" .. params or nil -- Fury 4-oct: clave de texto
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 升级停止后的刷新
        local sm_role_strengthen_tab_up_stop_update_terminal = {
            _name = "sm_role_strengthen_tab_up_stop_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- state_machine.excute("sm_role_strengthen_tab_update_ship_info",0,{instance.ship_id})
                if fwin:find("HeroDevelopClass") ~= nil then
                else
                    state_machine.excute("hero_icon_listview_update_all_icon",0,_ED.user_ship[instance.ship_id])
                    state_machine.excute("sm_role_strengthen_tab_special_attributes_update_draw",0,"")

                    -- for i, v in pairs(_ED.user_formetion_status) do
                    --     if tonumber(v) == tonumber(instance.ship_id) then
                    --         state_machine.excute("formation_set_ship",0,_ED.user_ship[instance.ship_id])
                    --         break
                    --     end
                    -- end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_role_strengthen_tab_open_auto_upgrade_terminal = {
            _name = "sm_role_strengthen_tab_open_auto_upgrade",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if tonumber(_ED.user_ship[instance.ship_id].ship_grade) >= tonumber(_ED.user_info.user_grade) then
                    TipDlg.drawTextDailog(_new_interface_text[244])
                    return
                end
                app.load("client.packs.hero.SmAutoUpgrade")
                state_machine.excute("sm_auto_upgrade_window_open", 0, _ED.user_ship[instance.ship_id])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_role_strengthen_tab_up_grade_display_terminal)
        state_machine.add(sm_role_strengthen_tab_up_grade_hide_terminal)
        state_machine.add(sm_role_strengthen_tab_up_grade_terminal)
        state_machine.add(sm_role_strengthen_tab_up_grade_strengthen_exp_terminal)
        state_machine.add(sm_role_strengthen_tab_up_grade_update_draw_terminal)
        state_machine.add(sm_role_strengthen_tab_up_grade_change_ship_terminal)
        state_machine.add(sm_role_strengthen_tab_up_stop_update_terminal)
        state_machine.add(sm_role_strengthen_tab_open_auto_upgrade_terminal)
        state_machine.init()
    end
    init_sm_role_strengthen_tab_up_grade_terminal()
end

-- LA VENTANA DE COMPRAR POCIONES cuando se acaban en mitad de la pulsacion
-- larga. `calculationExpUp` llamaba a `prop_buy` como GLOBAL, pero solo existe
-- como `local function` dentro del terminal de subida y mas abajo en la propia
-- funcion: «attempt to call global 'prop_buy' (a nil value)», 6 cierres en
-- produccion de Fury (3-oct). Mismo cuerpo que el `prop_buy` local de abajo.
local function calculation_exp_prop_buy(self, cells, propMouldId)
    local mouldId = tonumber(propMouldId)
    local index = 0
    for i ,v in pairs(self.propMouldIdArry) do
        if tonumber(v) == mouldId then
            index = i
            break
        end
    end
    if funOpenDrawTip( index + 131) == false then
        if zstring.tonumber(self.user_exp_number) ~= 1 then
            cells.one = false
            app.load("client.shop.SmShopBuyExpProps")
            state_machine.excute("sm_shop_buy_exp_props_open",0,{mouldId , self.prop_dec[index]})
        end
    end
    if cells ~= nil or cells.iscounts ~= nil then
        cells.iscounts = 0
    end
    self.user_exp_number = 0
end

function SmRoleStrengthenTabUpgrade:calculationExpUp(cells,number)
    local root = self.roots[1]
    if root == nil then 
        return
    end

    if cells.user_props == nil then
        cells.one = false
        calculation_exp_prop_buy(self, cells, cells.prop)
        state_machine.unlock("sm_role_strengthen_tab_up_grade_strengthen_exp")
        state_machine.unlock("formation_back_to_home_activity", 0, "")
        state_machine.unlock("hero_listview_set_index", 0, "")
        state_machine.unlock("hero_icon_list_cell_set_index", 0, "")
        state_machine.unlock("sm_role_strengthen_tab_open_auto_upgrade", 0, "")
        return false,number-1
    end
        
    local propInfo = cells.user_props.user_prop_id
    --选得到当前卡牌的等级和经验
    local ship_grade = tonumber(_ED.user_ship[""..self.ship_id].ship_grade)
    local exprience = tonumber(_ED.user_ship[""..self.ship_id].exprience)
    --找到当前卡牌等级升级到下一级的经验
    local exp_str_table  = dms.searchs(dms["ship_experience_param"],ship_experience_param.level,ship_grade+1)
    local ability = dms.int(dms["ship_mould"], tonumber(_ED.user_ship[""..self.ship_id].ship_template_id), ship_mould.ability)
    --当前升级需要的经验
    local needExps = tonumber(exp_str_table[1][ability-10]) - exprience

    --开始+道具提供的经验
    --通过道具模板表的use_of_ship找到对应的战船
    local prop = fundUserPropWidthId(propInfo)
    local expShip = dms.string(dms["prop_mould"], prop.user_prop_template, prop_mould.use_of_ship)
    --找到对应卡牌可提供的经验
    local expProvide = dms.int(dms["ship_mould"], expShip, ship_mould.initial_experience_supply)
    if expProvide*number >= needExps then
        playEffect(formatMusicFile("effect", 9993))   
        cells.iscounts = zstring.tonumber(cells.iscounts) + 1
        ccui.Helper:seekWidgetByName(cells.roots[1], "Label_l-order_level"):setString(zstring.tonumber(prop.prop_number))
        state_machine.excute("sm_role_strengthen_tab_up_exp_loading",0,{zstring.tonumber(_ED.user_ship[self.ship_id].exprience),_ED.user_ship[self.ship_id].grade_need_exprience,2})
        if fwin:find("SmRoleStrengthenTabSpecialAttributesClass") ~= nil then
            state_machine.excute("sm_role_strengthen_tab_special_attributes_up_exp_loading",0,{zstring.tonumber(_ED.user_ship[self.ship_id].exprience),_ED.user_ship[self.ship_id].grade_need_exprience,2})
        end
        if zstring.tonumber(cells.iscounts) > 3 then
            state_machine.excute("sm_role_strengthen_tab_show_prop_number",0,cells.iscounts)
        end
        
        -- local Panel_usedh_x = ccui.Helper:seekWidgetByName(root, "Panel_usedh_" .. self._f_cell.__p_index)
        -- Panel_usedh_x:removeAllChildren(true)
        -- local effice_skill_qh = ccs.Armature:create("effice_skill_qh")
        -- effice_skill_qh:removeFromParent(true)
        -- effice_skill_qh:getAnimation():playWithIndex(0)
        -- Panel_usedh_x:addChild(effice_skill_qh)
        -- effice_skill_qh:setPosition(cc.p((Panel_usedh_x:getContentSize().width - effice_skill_qh:getContentSize().width)/2+effice_skill_qh:getContentSize().width/2, (Panel_usedh_x:getContentSize().height - effice_skill_qh:getContentSize().height)/2+effice_skill_qh:getContentSize().height/2))
        -- -- draw.createEffect("effice_skill_qh", "images/ui/effice/effice_skill_qh/effice_skill_qh.ExportJson", Panel_usedh_x, 1, 100)
        --升级
        return false,number
    else
        --没升级
        --处理不能使用道具的情况
        local can_upgrade = false
        if tonumber(_ED.user_ship[""..self.ship_id].ship_grade) < tonumber(_ED.user_info.user_grade) then
            can_upgrade = true
        elseif tonumber(_ED.user_ship[""..self.ship_id].exprience) < tonumber(_ED.user_ship[""..self.ship_id].grade_need_exprience) then
            can_upgrade = true
        end

        if can_upgrade == false then
            -- state_machine.excute("sm_role_strengthen_tab_up_exp_loading",0,{_ED.user_ship[""..self.ship_id].exprience,_ED.user_ship[""..self.ship_id].grade_need_exprience,2})
            state_machine.excute("sm_role_strengthen_tab_show_prop_number",0,"0")
            cells.one = false
            if cells ~= nil or cells.iscounts ~= nil then
                cells.iscounts = 0
            end
            self.user_exp_number = 0
            TipDlg.drawTextDailog(_new_interface_text[32])
            state_machine.unlock("sm_role_strengthen_tab_up_grade_strengthen_exp")
            state_machine.unlock("formation_back_to_home_activity", 0, "")
            state_machine.unlock("hero_listview_set_index", 0, "")
            state_machine.unlock("hero_icon_list_cell_set_index", 0, "")
            state_machine.unlock("sm_role_strengthen_tab_open_auto_upgrade", 0, "")
            return false,number-1
        end
        local function prop_buy(propMouldId)
            local mouldId = tonumber(propMouldId)
            local index = 0
            for i ,v in pairs(self.propMouldIdArry) do
                if tonumber(v) == mouldId then
                    index = i
                    break
                end
            end
            if funOpenDrawTip( index + 131) == false then
                if zstring.tonumber(self.user_exp_number) ~= 1 then
                    cells.one = false
                    app.load("client.shop.SmShopBuyExpProps")
                    state_machine.excute("sm_shop_buy_exp_props_open",0,{mouldId , self.prop_dec[index]})
                    -- state_machine.unlock("sm_role_strengthen_tab_up_grade_strengthen_exp")
                end
            else
                -- state_machine.unlock("sm_role_strengthen_tab_up_grade_strengthen_exp")
            end
            if cells ~= nil or cells.iscounts ~= nil then
                cells.iscounts = 0
            end 
            self.user_exp_number = 0
        end
        local propInfo = cells.user_props.user_prop_id
        if tonumber(cells.user_props.prop_number) <= 0 or tonumber(cells.user_props.prop_number) - number <= 0 then
            state_machine.excute("sm_role_strengthen_tab_show_prop_number",0,"0")
            cells.one = false
            prop_buy(cells.prop)
            state_machine.unlock("sm_role_strengthen_tab_up_grade_strengthen_exp")
            state_machine.unlock("formation_back_to_home_activity", 0, "")
            state_machine.unlock("hero_listview_set_index", 0, "")
            state_machine.unlock("hero_icon_list_cell_set_index", 0, "")
            state_machine.unlock("sm_role_strengthen_tab_open_auto_upgrade", 0, "")
            return false,number
        end
        playEffect(formatMusicFile("effect", 9993))
        cells.iscounts = zstring.tonumber(cells.iscounts) + 1
        ccui.Helper:seekWidgetByName(cells.roots[1], "Label_l-order_level"):setString(zstring.tonumber(prop.prop_number)-number)
        state_machine.excute("sm_role_strengthen_tab_up_exp_loading",0,{zstring.tonumber(_ED.user_ship[self.ship_id].exprience)+expProvide*number,_ED.user_ship[self.ship_id].grade_need_exprience,2})
        if fwin:find("SmRoleStrengthenTabSpecialAttributesClass") ~= nil then
            state_machine.excute("sm_role_strengthen_tab_special_attributes_up_exp_loading",0,{zstring.tonumber(_ED.user_ship[self.ship_id].exprience)+expProvide*number,_ED.user_ship[self.ship_id].grade_need_exprience,2})
        end
        if zstring.tonumber(cells.iscounts) > 3 then
            state_machine.excute("sm_role_strengthen_tab_show_prop_number",0,cells.iscounts)
        end
        
        -- local Panel_usedh_x = ccui.Helper:seekWidgetByName(root, "Panel_usedh_" .. self._f_cell.__p_index)
        -- Panel_usedh_x:removeAllChildren(true)
        -- local effice_skill_qh = ccs.Armature:create("effice_skill_qh")
        -- effice_skill_qh:removeFromParent(true)
        -- effice_skill_qh:getAnimation():playWithIndex(0)
        -- Panel_usedh_x:addChild(effice_skill_qh)
        -- effice_skill_qh:setPosition(cc.p((Panel_usedh_x:getContentSize().width - effice_skill_qh:getContentSize().width)/2+effice_skill_qh:getContentSize().width/2, (Panel_usedh_x:getContentSize().height - effice_skill_qh:getContentSize().height)/2+effice_skill_qh:getContentSize().height/2))
        -- -- draw.createEffect("effice_skill_qh", "images/ui/effice/effice_skill_qh/effice_skill_qh.ExportJson", Panel_usedh_x, 1, 100)
    end 
    state_machine.unlock("sm_role_strengthen_tab_up_grade_strengthen_exp")
    state_machine.unlock("formation_back_to_home_activity", 0, "")
    state_machine.unlock("hero_listview_set_index", 0, "")
    state_machine.unlock("hero_icon_list_cell_set_index", 0, "")
    state_machine.unlock("sm_role_strengthen_tab_open_auto_upgrade", 0, "")

    return true,number
end

function SmRoleStrengthenTabUpgrade:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local up_grade_consumption = dms.string(dms["ship_config"], 1, ship_config.param)
    local consumption_data = zstring.split(up_grade_consumption, ",")
    self.propMouldIdArry = consumption_data
    --道具
    for i=1, 6 do
        local Panel_role_up_lv_box = ccui.Helper:seekWidgetByName(root, "Panel_role_up_lv_box_"..i)
        local Panel_role_up_lv_icon = ccui.Helper:seekWidgetByName(root, "Panel_role_up_lv_icon_"..i)
        local Image_role_up_lv_add = ccui.Helper:seekWidgetByName(root, "Image_role_up_lv_add_"..i)
        local Text_role_up_lv_num = ccui.Helper:seekWidgetByName(root, "Text_role_up_lv_num_"..i)
        Panel_role_up_lv_box:removeAllChildren(true)

        local cell = PropIconNewCell:createCell()
        
        --道具数
        local existNumber = tonumber(getPropAllCountByMouldId(consumption_data[i]))
        if existNumber > 0 then
            Panel_role_up_lv_icon:setVisible(false)
            Image_role_up_lv_add:setVisible(false)
            cell:init(cell.enum_type._USE_CONSUMPTION, consumption_data[i])
        else
            Panel_role_up_lv_icon:setVisible(false)
            Image_role_up_lv_add:setVisible(true)
            cell:init(cell.enum_type._USE_CONSUMPTION, consumption_data[i],false,true)
        end
        Panel_role_up_lv_box:addChild(cell)
        cell.__p_index = i
        --道具提供的经验
        --通过道具模板表的use_of_ship找到对应的战船
        local expShip = dms.string(dms["prop_mould"], consumption_data[i], prop_mould.use_of_ship)
        --找打对应战场可提供的经验
        local expProvide = dms.string(dms["ship_mould"], expShip, ship_mould.initial_experience_supply)
        self.prop_dec[i] = string.format(_new_interface_text[8],zstring.tonumber(expProvide))
        Text_role_up_lv_num:setString(self.prop_dec[i])
        Text_role_up_lv_num:setColor(cc.c3b(tipStringInfo_quality_color_Type[2][1], tipStringInfo_quality_color_Type[2][2], tipStringInfo_quality_color_Type[2][3]))

    end
    --当前经验和升级的经验
    if tonumber(_ED.user_ship[""..self.ship_id].ship_grade) > tonumber(_ED.user_info.user_grade) then
        if fwin:find("SmRoleStrengthenTabClass") ~= nil then
            state_machine.excute("sm_role_strengthen_tab_update_Loading",0,{_ED.user_ship[self.ship_id].grade_need_exprience,_ED.user_ship[self.ship_id].grade_need_exprience,2})
        end
        if fwin:find("SmRoleStrengthenTabSpecialAttributesClass") ~= nil then
            state_machine.excute("sm_role_strengthen_tab_special_attributes_update_Loading",0,{_ED.user_ship[self.ship_id].grade_need_exprience,_ED.user_ship[self.ship_id].grade_need_exprience,2})
        end
    else
        if fwin:find("SmRoleStrengthenTabClass") ~= nil then
            state_machine.excute("sm_role_strengthen_tab_update_Loading",0,{_ED.user_ship[self.ship_id].exprience,_ED.user_ship[self.ship_id].grade_need_exprience,2})
        end
        if fwin:find("SmRoleStrengthenTabSpecialAttributesClass") ~= nil then
            state_machine.excute("sm_role_strengthen_tab_special_attributes_update_Loading",0,{_ED.user_ship[self.ship_id].exprience,_ED.user_ship[self.ship_id].grade_need_exprience,2})
        end
    end
    
    if funOpenDrawTip(170, false) == true then
        ccui.Helper:seekWidgetByName(root, "Button_yjsj"):setVisible(false)
    else
        ccui.Helper:seekWidgetByName(root, "Button_yjsj"):setVisible(true)
    end
end

function SmRoleStrengthenTabUpgrade:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow     
    -- Fury 4-oct (:690): _ED.user_ship va por clave de texto; con el id en numero
    -- _ED.user_ship[self.ship_id] es nil aunque [""..self.ship_id] exista.
    self.ship_id = params[2] ~= nil and "" .. params[2] or nil
    self:onInit()
    return self
end

function SmRoleStrengthenTabUpgrade:onInit()
    local csbSmRoleStrengthenTabUpgrade = csb.createNode("packs/HeroStorage/sm_role_strengthen_tab_cell_2.csb")
    local root = csbSmRoleStrengthenTabUpgrade:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmRoleStrengthenTabUpgrade)
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effice_skill_qh/effice_skill_qh.ExportJson")
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_yjsj"), nil, 
    {
        terminal_name = "sm_role_strengthen_tab_open_auto_upgrade", 
        terminal_state = 0, 
        isPressedActionEnabled = true,
    }, nil, 1)
	
    self:onUpdateDraw()

end

function SmRoleStrengthenTabUpgrade:onExit()
    state_machine.remove("sm_role_strengthen_tab_up_grade_display")
    state_machine.remove("sm_role_strengthen_tab_up_grade_hide")
    state_machine.remove("sm_role_strengthen_tab_up_grade_strengthen_exp")
    state_machine.remove("sm_role_strengthen_tab_up_grade_update_draw")
	state_machine.remove("sm_role_strengthen_tab_up_grade_change_ship")
    state_machine.remove("sm_role_strengthen_tab_open_auto_upgrade")
end