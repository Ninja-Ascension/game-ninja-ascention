-----------------------------
-- 仓库主界面
-----------------------------
SmPropWarehouse = class("SmPropWarehouseClass", Window)

--打开界面
local prop_warehouse_window_open_terminal = {
	_name = "prop_warehouse_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("SmPropWarehouseClass") == nil then
			fwin:open(SmPropWarehouse:new():init(params), fwin._background)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local prop_warehouse_window_close_terminal = {
	_name = "prop_warehouse_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("UserTopInfoAClass"))
        state_machine.excute("menu_back_home_page", 0, "") 
		fwin:close(fwin:find("SmPropWarehouseClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(prop_warehouse_window_open_terminal)
state_machine.add(prop_warehouse_window_close_terminal)
state_machine.init()

function SmPropWarehouse:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}

    self._current_page = 0
    self._all = nil
    self._equip = nil
    self._material = nil
    self._debris = nil
    self._consumables= nil
    self._skilBags = nil
    self._signet = nil

    self.propType = 0

    -- 消耗后弹出提示的道具列表
    self._popTipPropList = {}
    -- 活动限时道具类型枚举
    self.limitPropEnum = {
        COMMANDWORLD = 1
    }

    app.load("client.packs.prop.SmAllWarehouse")
    app.load("client.packs.prop.SmConsumablesWarehouse")
    app.load("client.packs.prop.SmDebrisWarehouse")
    app.load("client.packs.prop.SmEquipWarehouse")
    app.load("client.packs.prop.SmMaterialWarehouse")
    app.load("client.cells.prop.sm_packs_cell")
    app.load("client.packs.prop.SmPropWarehouseBatchUse")
    app.load("client.packs.prop.SmPropWarehouseBatchSell")
    app.load("client.packs.prop.SmPropWarehouseSellTip")
    app.load("client.packs.prop.SmPropWarehouseSellAll")
    app.load("client.packs.prop.SmSilkBagWarehouse")
    app.load("client.packs.prop.SmSignetWarehouse")
    app.load("client.l_digital.cultivate.silkbag.silk_bags")
    app.load("client.shop.recharge.RechargeVoucher")

    local function init_prop_warehouse_terminal()
        local prop_warehouse_change_page_terminal = {
            _name = "prop_warehouse_change_page",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:changeSelectPage(params._datas._page)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local prop_warehouse_update_data_info_terminal = {
            _name = "prop_warehouse_update_data_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance.prop = params[1]
                    instance.propType = params[2]
                    instance:drawPageDataUpdate(instance.prop , instance.propType)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --显示信息界面
        local prop_warehouse_show_data_interface_terminal = {
            _name = "prop_warehouse_show_data_interface",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_28"):setVisible(true)
                ccui.Helper:seekWidgetByName(instance.roots[1], "Text_packs_props_info_0"):setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --隐藏信息界面
        local prop_warehouse_hide_data_interface_terminal = {
            _name = "prop_warehouse_hide_data_interface",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_28"):setVisible(false)
                ccui.Helper:seekWidgetByName(instance.roots[1], "Text_packs_props_info_0"):setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --出售道具
        local prop_warehouse_sell_prop_terminal = {
            _name = "prop_warehouse_sell_prop",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:propSellUpdate()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --使用道具
        local prop_warehouse_use_prop_terminal = {
            _name = "prop_warehouse_use_prop",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:propUseOrJump()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --使用道具
        local prop_warehouse_use_prop_update_terminal = {
            _name = "prop_warehouse_use_prop_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:propUseRequest(tonumber(params))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --出售道具
        local prop_warehouse_sell_prop_update_terminal = {
            _name = "prop_warehouse_sell_prop_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:propSellRequest(tonumber(params))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新界面
        local prop_warehouse_update_draw_page_terminal = {
            _name = "prop_warehouse_update_draw_page",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._current_page == 1 then
                    state_machine.excute("sm_all_warehouse_update_draw",0,"")
                elseif instance._current_page == 2 then
                    state_machine.excute("sm_equip_warehouse_update_draw",0,"")
                elseif instance._current_page == 3 then
                    state_machine.excute("sm_material_warehouse_update_draw",0,"")
                elseif instance._current_page == 4 then
                    state_machine.excute("sm_debris_warehouse_update_draw",0,"")
                elseif instance._current_page == 5 then
                    state_machine.excute("sm_consumables_warehouse_update_draw",0,"")
                elseif instance._current_page == 6 then
                    state_machine.excute("sm_silkbags_warehouse_update_draw",0,"")
                elseif instance._current_page == 7 then
                    state_machine.excute("sm_signet_warehouse_update_draw",0,"")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --打开排序选择
        local prop_warehouse_sort_rule_open_terminal = {
            _name = "prop_warehouse_sort_rule_open",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.actions[1]:play("paiWindow_open", false)
                ccui.Helper:seekWidgetByName(instance.roots[1], "Butto_paiLieGuiZe"):setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --关闭排序选择
        local prop_warehouse_sort_rule_close_terminal = {
            _name = "prop_warehouse_sort_rule_close",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.actions[1]:play("paiWindow_close", false)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(prop_warehouse_change_page_terminal)
        state_machine.add(prop_warehouse_update_data_info_terminal)
        state_machine.add(prop_warehouse_show_data_interface_terminal)
        state_machine.add(prop_warehouse_hide_data_interface_terminal)
        state_machine.add(prop_warehouse_sell_prop_terminal)
        state_machine.add(prop_warehouse_use_prop_terminal)
        state_machine.add(prop_warehouse_use_prop_update_terminal)
        state_machine.add(prop_warehouse_sell_prop_update_terminal)
        state_machine.add(prop_warehouse_update_draw_page_terminal)
        state_machine.add(prop_warehouse_sort_rule_open_terminal)
        state_machine.add(prop_warehouse_sort_rule_close_terminal)
        state_machine.init()
    end
    init_prop_warehouse_terminal()
end

function SmPropWarehouse:propSellUpdate()
    if self.propType == 74 then 
        local function wareHouseVoucherallback()
            if self._current_page == 1 then
                state_machine.excute("sm_all_warehouse_update_draw",0,"")
            elseif self._current_page == 5 then
                state_machine.excute("sm_consumables_warehouse_update_draw",0,"")
            end
        end
        RechargeVoucher.goSellVouchers(self.prop,wareHouseVoucherallback)
    else
        local propMouldId = self.prop.user_prop_template
        if tonumber(self.prop.prop_number) > 1 then
            state_machine.excute("prop_warehouse_batch_sell_open",0,self.prop)
        else
            -- self:propSellRequest(1)
            state_machine.excute("prop_warehouse_sell_tip_open",0,self.prop)
        end
    end
end

function SmPropWarehouse:propSellRequest(number)
    local function responseSellMagicCardCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then  --网络连接判断
            if response.node == nil or response.node.roots == nil then 
                return
            end
            if fwin:find("SmPropWarehouseBatchSellClass")~= nil then
                state_machine.excute("prop_warehouse_batch_sell_close",0,"")
            end
            if fwin:find("SmPropWarehouseSellTipClass")~= nil then
                state_machine.excute("prop_warehouse_sell_tip_close",0,"")
            end
            TipDlg.drawTextDailog(_new_interface_text[11])
            if self._current_page == 1 then
                state_machine.excute("sm_all_warehouse_update_draw",0,"")
            elseif self._current_page == 2 then
                state_machine.excute("sm_equip_warehouse_update_draw",0,"")
            elseif self._current_page == 3 then
                state_machine.excute("sm_material_warehouse_update_draw",0,"")
            elseif self._current_page == 4 then
                state_machine.excute("sm_debris_warehouse_update_draw",0,"")
            elseif self._current_page == 5 then
                state_machine.excute("sm_consumables_warehouse_update_draw",0,"")
            elseif self._current_page == 6 then
                state_machine.excute("sm_silkbags_warehouse_update_draw",0,"")
            elseif self._current_page == 7 then
                state_machine.excute("sm_signet_warehouse_update_draw",0,"")
            end
        end
    end
    protocol_command.prop_sell.param_list = self.prop.user_prop_id.."\r\n" .. number
    NetworkManager:register(protocol_command.prop_sell.code, nil, nil, nil, self, responseSellMagicCardCallback, false, nil)
end

function SmPropWarehouse:propUseOrJump()
    local propMouldId = 1
    local use_type = 0
    if tonumber(self.propType) == 7 then
        propMouldId = tonumber(self.prop.user_equiment_template)
        local equipment_type = dms.int(dms["equipment_mould"], propMouldId, equipment_mould.equipment_type)
        local equipIndex = 1
        if equipment_type == 4 then
            equipIndex = 5
        elseif equipment_type == 5 then
            equipIndex = 6
        end
        if tonumber(equipIndex) > 4 then
            if funOpenDrawTip(159) == true then
                return
            end
        else
            if funOpenDrawTip(96) == true then
                return
            end
        end
        self:openEquipDevelop(equipIndex)
        return
    elseif tonumber(self.propType) == 71 then
        if true == funOpenDrawTip(120+72) then
            return
        end
        propMouldId = self.prop.silkBagMouldId
        state_machine.excute("silk_bag_window_open", 0, "")
        return
    elseif tonumber(self.propType) == 74 then
        local function wareHouseVoucherallback()
            if self._current_page == 1 then
                state_machine.excute("sm_all_warehouse_update_draw",0,"")
            elseif self._current_page == 5 then
                state_machine.excute("sm_consumables_warehouse_update_draw",0,"")
            end
        end
        RechargeVoucher.goUseVouchers(self.prop,wareHouseVoucherallback)
        return
    else
        propMouldId = self.prop.user_prop_template
        use_type = dms.int(dms["prop_mould"], propMouldId, prop_mould.use_type)
    end
    if use_type == 3 
        or use_type == 4 
        or use_type == 5 
        or use_type == 7 
        or use_type == 9 
        or use_type == 11 
        or use_type == 12 
        or use_type == 14 
        or use_type == 15
        or use_type == 16
        or use_type == 18
        or use_type == 19
        or use_type == 20
        or use_type == 21
        or use_type == 22
        or use_type == 23
        or use_type == 24
        or use_type == 25
        or use_type == 26
        then
        --跳转
        if use_type == 3 then
            --跳升星
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                if funOpenDrawTip(102) == true then
                    return
                end
                local shipMouldId = dms.int(dms["prop_mould"], propMouldId, prop_mould.use_of_ship)
                if shipMouldId == 0 or fundShipWidthTemplateId(shipMouldId) == nil then
                    state_machine.excute("home_click_generals",0,"home_click_generals.")
                else
                    self:openHeroDevelop()
                    -- state_machine.excute("hero_develop_page_open_train_page",0,"")
                    state_machine.excute("hero_develop_page_manager",0,{_datas = {
                        next_terminal_name = "hero_develop_page_open_train_page",           
                        current_button_name = "Button_peiyang",     
                        but_image = "",     
                        shipId = self.shipId,
                        terminal_state = 0, 
                        openWinId = 3,
                        isPressedActionEnabled = tempIsPressedActionEnabled
                    }})
                end
            else
                self:openHeroDevelop()
                -- state_machine.excute("hero_develop_page_open_train_page",0,"")
                state_machine.excute("hero_develop_page_manager",0,{_datas = {
                    next_terminal_name = "hero_develop_page_open_train_page",           
                    current_button_name = "Button_peiyang",     
                    but_image = "",     
                    shipId = self.shipId,
                    terminal_state = 0, 
                    openWinId = 3,
                    isPressedActionEnabled = tempIsPressedActionEnabled
                }})
            end
        elseif use_type == 4 then
            if funOpenDrawTip(101) == true then
                return
            end
            --跳升级
            self:openHeroDevelop()
            -- state_machine.excute("hero_develop_page_open_advanced",0,"")
            state_machine.excute("hero_develop_page_manager",0,{_datas = {
                next_terminal_name = "hero_develop_page_open_advanced",             
                current_button_name = "Button_tupo",    
                but_image = "",     
                shipId = self.shipId,
                terminal_state = 0, 
                openWinId = 34,
                isPressedActionEnabled = tempIsPressedActionEnabled
            }})
        elseif use_type == 5 then
            --跳升品
            self:openHeroDevelop()
            -- state_machine.excute("hero_develop_page_open_strengthen_page",0,"")
            state_machine.excute("hero_develop_page_manager",0,{_datas = {
                next_terminal_name = "hero_develop_page_open_strengthen_page",          
                current_button_name = "Button_shengji",     
                but_image = "",     
                shipId = self.shipId,
                terminal_state = 0, 
                openWinId = 33,
                isPressedActionEnabled = tempIsPressedActionEnabled
            }})
        elseif use_type == 7 then
            --跳装备强化
            if funOpenDrawTip(96) == true then
                return
            end
            self:openEquipDevelop()
        elseif use_type == 9 then    
            --跳转招募
            -- state_machine.excute("menu_show_shop", 0, {_datas = {shop_type = "zhaomu"}})
            local trace_id = 22
            state_machine.excute("shortcut_function_trace", 0, {trace_function_id = nil, _datas = {traceId = trace_id}})
        elseif use_type == 11 then
            --跳转装备宝箱
            state_machine.excute("menu_show_shop", 0, {_datas = {shop_type = "shop"}})
        elseif use_type == 12 then
            --跳转数码精神
            app.load("client.l_digital.cultivate.SmCultivateSpiritWindow")
            state_machine.excute("sm_cultivate_spirit_window_open", 0, "")
        elseif use_type == 14 then
            app.load("client.l_digital.campaign.arena.Arena")
            state_machine.excute("arena_window_open", 0, "")
        elseif use_type == 15 then
            if funOpenDrawTip(104) == true then
                return
            end
            self:openHeroDevelop()
            -- state_machine.excute("hero_develop_page_open_train_page",0,"")
            state_machine.excute("hero_develop_page_manager",0,{_datas = {
                next_terminal_name = "hero_develop_page_open_fighting_spirit",           
                current_button_name = "Button_douhun",     
                but_image = "",     
                shipId = self.shipId,
                terminal_state = 0, 
                openWinId = 104,
                isPressedActionEnabled = tempIsPressedActionEnabled
            }})
        elseif use_type == 16 then
            --跳转神器
            app.load("client.l_digital.cultivate.artifact.SmCultivateArtifactWindow")
            state_machine.excute("sm_cultivate_artifact_window_open", 0, "")
        elseif use_type == 18 then
            -- 跳转合金
            if true == funOpenDrawTip(126) then
                return
            end
            state_machine.excute("prop_warehouse_window_close", 0, "")
            state_machine.excute("sm_cultivate_window_open",0,"")
            app.load("client.l_digital.cultivate.matrix.AlloyMatrixWindow")
            state_machine.excute("alloy_matrix_window_open",0,"")
        elseif use_type == 19 then
            -- 跳转限时精灵
            if _ED.active_activity[89] ~= nil then
                if funOpenDrawTip(164) == true then
                    return
                end
                state_machine.excute("prop_warehouse_window_close", 0, "")
                app.load("client.l_digital.activity.wonderful.SmLimitedTimeEquipBox")
                state_machine.excute("sm_limited_time_equip_box_open", 0, {89})
            else      
                local word_info = dms.element(dms["word_mould"], 65101)
                TipDlg.drawTextDailog(word_info[3])
            end
        elseif use_type == 20 then
            -- 跳转神兽来袭
            if _ED.active_activity[114] ~= nil then
                local activity_info = _ED.active_activity[114]
                local info = zstring.split(zstring.split(activity_info.need_recharge_count, "@")[4], ",")
                if zstring.tonumber(_ED.vip_grade) >= tonumber(info[2]) then
                    state_machine.excute("prop_warehouse_window_close", 0, "")
                    app.load("client.l_digital.activity.wonderful.SmOtherRecruitActivity")
                    state_machine.excute("sm_other_recruit_activity_open", 0, {})
                else
                    TipDlg.drawTextDailog(_string_piece_info[274])
                end
            else
                local word_info = dms.element(dms["word_mould"], 65101)
                TipDlg.drawTextDailog(word_info[3])
            end
        elseif use_type == 21 then
            -- 跳转武器扭蛋
            if _ED.active_activity[154] ~= nil then
                state_machine.excute("prop_warehouse_window_close", 0, "")
                app.load("client.activity.egg_machine.EggMachineWindow")
                state_machine.excute("egg_machine_window_open", 0, "")
            else
                local word_info = dms.element(dms["word_mould"], 65101)
                TipDlg.drawTextDailog(word_info[3])
            end
        elseif use_type == 22 then
            -- 跳转忍列传
            if true == funOpenDrawTip(199) then
                return
            end
            -- app.load("client.l_digital.cultivate.roleBiography.RoleBiographyChapter")
            local function responseCallback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    state_machine.excute("prop_warehouse_window_close", 0, "")
                    state_machine.excute("sm_cultivate_window_open",0,"")
                    state_machine.excute("role_biography_chapter_window_open", 0, nil)
                end
            end
            NetworkManager:register(protocol_command.biographies_init.code, nil, nil, nil, nil, responseCallback, false, nil)
        elseif use_type == 23 then
            -- 跳转神兽主界面
            if true == funOpenDrawTip(200) then
                return
            end
            -- app.load("client.l_digital.cultivate.roleBiography.RoleBiographyChapter")
            local function responseCallback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    state_machine.excute("prop_warehouse_window_close", 0, "")
                    state_machine.excute("sm_cultivate_window_open",0,"")
                    state_machine.excute("mythical_animals_main_ui_window_open", 0, nil)
                    state_machine.excute("mythical_animals_main_ui_change_page", 0, {_datas = {_page = 3}})
                end
            end
            NetworkManager:register(protocol_command.magical_animals_init.code, nil, nil, nil, nil, responseCallback, false, nil)
        elseif use_type == 24 then
            -- 跳转限时祈福
            if _ED.active_activity[180] ~= nil then
                local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						app.load("client.activity.pray.PrayActivityWindow")
						state_machine.excute("pray_activity_window_open", 0, nil)
					end
				end
				NetworkManager:register(protocol_command.limit_blessing_init.code, nil, nil, nil, cell, responseCallback, false, nil)
            else
                local word_info = dms.element(dms["word_mould"], 65101)
                TipDlg.drawTextDailog(word_info[3])
            end
        elseif use_type == 25 then
            -- 跳转圣诞奇缘
            if _ED.active_activity[181] ~= nil then
                local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						app.load("client.activity.christmas_romance.ChristmasRomance")
						state_machine.excute("christmas_romance_window_open", 0, nil)
					end
				end
				NetworkManager:register(protocol_command.lucky_turntable_init.code, nil, nil, nil, nil, responseCallback, false, nil)
            else
                local word_info = dms.element(dms["word_mould"], 65101)
                TipDlg.drawTextDailog(word_info[3])
            end
        elseif use_type == 26 then
            -- 跳转月卡重塑
            if _ED.active_activity[192] ~= nil then
                state_machine.excute("activity_window_open", 0, {"client.activity.open_server.OpenServerActivity", "MonthCard"})
                state_machine.excute("activity_window_open_page_activity",0,{"MonthCard"})
            else
                TipDlg.drawTextDailog(tipStringInfo_monthly_card_tip[4])
            end
        end
    elseif use_type == 0 then
        --使用
        local props_type = dms.int(dms["prop_mould"], propMouldId, prop_mould.props_type)
        if props_type == 7 then
            app.load("client.packs.prop.SmPropChoose")
            state_machine.excute("sm_prop_choose_window_open",0,self.prop)
        elseif tonumber(self.prop.prop_number) > 1 then
            --批量使用的界面
            if dms.int(dms["prop_mould"], self.prop.user_prop_template, prop_mould.is_batch_use) == -1 then
                self:propUseRequest(1)
            elseif dms.int(dms["prop_mould"], self.prop.user_prop_template, prop_mould.is_batch_use) == 1 then
                state_machine.excute("prop_warehouse_batch_use_open",0,self.prop)
            end
        else
            --直接使用
            self:propUseRequest(1)
        end

    -- 合成
    elseif use_type == 17 then
        self:compoundUseRequest()
    end

end

function SmPropWarehouse:propUseRequest(number, chooseCount)
    local propMouldId = self.prop.user_prop_template

    local function responseUsePropCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then  --网络连接判断
            if response.node == nil or response.node.roots == nil then 
                return
            end
            if fwin:find("SmPropWarehouseBatchUseClass")~= nil then
                state_machine.excute("prop_warehouse_batch_use_close",0,"")
            end
            -- 使用之后
            local popTipIndex = self:getPopPropTipIndex(propMouldId)
            if popTipIndex ~= nil then
                local description = drawPropsDescription(propMouldId)
                TipDlg.drawTextDailog(description)

                writeKey("propPopTipEndTime"..popTipIndex, os.time() + 60 * 60)
            else
                local rewardList = getSceneReward(4)--获取奖励物品实例
                app.load("client.reward.DrawRareReward")
                local getRewardWnd = DrawRareReward:new()
                getRewardWnd:init(nil, rewardList)
                fwin:open(getRewardWnd,fwin._ui)
            end

            if self._current_page == 1 then
                state_machine.excute("sm_all_warehouse_update_draw",0,"")
            elseif self._current_page == 2 then
                state_machine.excute("sm_equip_warehouse_update_draw",0,"")
            elseif self._current_page == 3 then
                state_machine.excute("sm_material_warehouse_update_draw",0,"")
            elseif self._current_page == 4 then
                state_machine.excute("sm_debris_warehouse_update_draw",0,"")
            elseif self._current_page == 5 then
                state_machine.excute("sm_consumables_warehouse_update_draw",0,"")
            elseif self._current_page == 6 then
                state_machine.excute("sm_silkbags_warehouse_update_draw",0,"")
            elseif self._current_page == 7 then
                state_machine.excute("sm_signet_warehouse_update_draw",0,"")
            end
        end
    end
    protocol_command.prop_use.param_list = self.prop.user_prop_id.."\r\n" .. number.."\r\n"..zstring.tonumber(chooseCount)
    NetworkManager:register(protocol_command.prop_use.code, nil, nil, nil, self, responseUsePropCallback,false, nil)
end

function SmPropWarehouse:compoundUseRequest(number, chooseCount)
    local function callback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then  --网络连接判断
            if response.node == nil or response.node.roots == nil then 
                return
            end
            if fwin:find("SmPropWarehouseBatchUseClass")~= nil then
                state_machine.excute("prop_warehouse_batch_use_close",0,"")
            end

            local getRewardWnd = DrawRareReward:new()
            local reworldInfo = {}
            reworldInfo.show_reward_item_count = 1
            reworldInfo.show_reward_list = {}
            reworldInfo.show_reward_list[1] = {}
            reworldInfo.show_reward_list[1].item_value = 1
            reworldInfo.show_reward_list[1].prop_type = 7

            local equipmentId = dms.int(dms["prop_mould"], self.prop.user_prop_template, prop_mould.change_of_equipment)
            reworldInfo.show_reward_list[1].prop_item = equipmentId

            if equipmentId == 0 then
                local propId = dms.int(dms["prop_mould"], self.prop.user_prop_template, prop_mould.change_of_prop)
                reworldInfo.show_reward_list[1].prop_type = 6
                reworldInfo.show_reward_list[1].prop_item = propId
            end
            
            getRewardWnd:init(0, reworldInfo)
            fwin:open(getRewardWnd, fwin._ui)

            if self._current_page == 1 then
                state_machine.excute("sm_all_warehouse_update_draw",0,"")
            elseif self._current_page == 2 then
                state_machine.excute("sm_equip_warehouse_update_draw",0,"")
            elseif self._current_page == 3 then
                state_machine.excute("sm_material_warehouse_update_draw",0,"")
            elseif self._current_page == 4 then
                state_machine.excute("sm_debris_warehouse_update_draw",0,"")
            elseif self._current_page == 5 then
                state_machine.excute("sm_consumables_warehouse_update_draw",0,"")
            elseif self._current_page == 6 then
                state_machine.excute("sm_silkbags_warehouse_update_draw",0,"")
            elseif self._current_page == 7 then
                state_machine.excute("sm_signet_warehouse_update_draw",0,"")
            end
        end
    end
    protocol_command.prop_compound.param_list = "" .. self.prop.user_prop_id .. "\r\n" .. "0" .. "\r\n" .. "1"
    NetworkManager:register(protocol_command.prop_compound.code, nil, nil, nil, self, callback, false, nil)
end

function SmPropWarehouse:openEquipDevelop( m_index )
    local index = 0
    for i=1, #_ED.user_formetion_status do
        if tonumber(_ED.user_formetion_status[i]) > 0 then
            index = i
            break
        end
    end
    local ship = _ED.user_ship[_ED.user_formetion_status[index]]
    if fwin:find("HeroIconListViewClass") ~= nil then
        app.load("client.packs.hero.HeroIconListView")
        state_machine.excute("hero_icon_listview_open",0,ship)
        fwin:find("HeroIconListViewClass"):setVisible(false)
    end
    local _index = 1
    if m_index ~= nil then
        _index = m_index
    end

    --武将装备数据(等级|品质|经验|星级|模板)
    local shipEquip = zstring.split(ship.equipInfo, "|")
    local equipData = zstring.split(shipEquip[5], ",")
    local equipStar = zstring.split(shipEquip[4], ",")
    local equipMouldId = equipData[_index]
    local equip = {}
    --装备模板id
    --初始装备
    local equipAll = dms.string(dms["ship_mould"], ship.ship_template_id, ship_mould.treasureSkill)
    if tonumber(equipStar[_index]) == 0 then
        local equipMouldData = zstring.split(equipAll, ",")
        equip.user_equiment_template = equipMouldData[1]
    else
        equip.user_equiment_template = equipMouldId
    end
    --装备等级
    local equipLevelData = zstring.split(shipEquip[1], ",")
    equip.user_equiment_grade = equipLevelData[_index]
    --所属战船
    equip.ship_id = ship.ship_id
    equip.m_index = _index

    app.load("client.packs.equipment.SmEquipmentQianghua")
    state_machine.excute("sm_equipment_qianghua_open",0,equip)
end

function SmPropWarehouse:openHeroDevelop()
    local index = 0
    for i=1, #_ED.user_formetion_status do
        if tonumber(_ED.user_formetion_status[i]) > 0 then
            index = i
            break
        end
    end
    local ship = _ED.user_ship[_ED.user_formetion_status[index]]
    enter_type = "learn"
    if fwin:find("HeroIconListViewClass") ~= nil then
        app.load("client.packs.hero.HeroIconListView")
        state_machine.excute("hero_icon_listview_open",0,ship)
        fwin:find("HeroIconListViewClass"):setVisible(false)
    end
    app.load("client.packs.hero.HeroDevelop")
    if fwin:find("HeroDevelopClass") ~= nil then
        for i, v in pairs(_ED.user_formetion_status) do
            if tonumber(v) == tonumber(ship.ship_id) then
                 state_machine.excute("formation_set_ship",0,ship)
                break
            end
        end
        return
        -- fwin:close(fwin:find("HeroDevelopClass"))
    end
    local heroDevelopWindow = HeroDevelop:new()
    if __lua_project_id == __lua_project_gragon_tiger_gate 
        or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then
        ship.shengming = zstring.tonumber(ship.ship_health)
        ship.gongji = zstring.tonumber(ship.ship_courage)
        ship.waigong = zstring.tonumber(ship.ship_intellect)
        ship.neigong = zstring.tonumber(ship.ship_quick)
    end
    -- print("=======11=====",enter_type)
    if enter_type ~= "learn" and enter_type ~= "pack" then
        enter_type = "formation"
    end
    for i,v in pairs(_ED.user_formetion_status) do
        if zstring.tonumber(v) == tonumber(ship.ship_id) then
            enter_type = "formation"
        end
    end
    heroDevelopWindow:init(ship.ship_id, enter_type)
    fwin:open(heroDevelopWindow, fwin._viewdialog)
end

function SmPropWarehouse:drawPageDataUpdate(prop , _type)
    local root = self.roots[1]
    --图标
    _type = tonumber(_type)
    local Panel_packs_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_packs_props_icon")
    Panel_packs_props_icon:removeAllChildren(true)
    local cell = state_machine.excute("sm_packs_cell",0,{prop,1,nil,_type})
    Panel_packs_props_icon:addChild(cell)
    --名称
    local propMouldId = 1
    if _type == 7 then
        propMouldId = tonumber(prop.user_equiment_template)
    elseif _type == 71 then
        propMouldId = tonumber(prop.silkBagMouldId)
    elseif _type == 74 then
        propMouldId = tonumber(prop.vouchers_mould_id)
    else
        propMouldId = tonumber(prop.user_prop_template)
    end
    local Text_packs_props_name = ccui.Helper:seekWidgetByName(root, "Text_packs_props_name")
    local Text_packs_have = ccui.Helper:seekWidgetByName(root, "Text_packs_have")
    local Text_packs_have_n = ccui.Helper:seekWidgetByName(root, "Text_packs_have_n")
    local Text_packs_props_info =  ccui.Helper:seekWidgetByName(root, "Text_packs_props_info")
    local Text_attribute_info = ccui.Helper:seekWidgetByName(root, "Text_attribute_info")
    local Panel_skill_bag = ccui.Helper:seekWidgetByName(root, "Panel_skill_bag")
    local ScrollView_1 = ccui.Helper:seekWidgetByName(root, "ScrollView_1")
    local Text_jinengmiaoshu = ccui.Helper:seekWidgetByName(root, "Text_jinengmiaoshu") -- 锦囊天赋展示

    local name = ""
    local quality = 0
    local propNumber = 0
    local description = ""

    local basePropertyList = {}
    local extraPropertyList = {}
    local excluseSkillDescribe = ""

    if _type == 7 then
        name = smEquipWordlFundByIndex(propMouldId,1)
        quality = dms.int(dms["equipment_mould"], propMouldId, equipment_mould.trace_npc_index)+1
        for i , v in pairs(_ED.user_equiment) do
            if tonumber(v.user_equiment_template) == propMouldId then
                propNumber = propNumber + 1
            end
        end
        description = smEquipWordlFundByIndex(propMouldId,2)
    elseif _type == 71 then
        local silkbag_name_id = dms.int(dms["ship_silk_bag_mould"], propMouldId, ship_silk_bag_mould.silkbag_name)
        local silkbag_name_word = dms.element(dms["word_mould"], silkbag_name_id)
        name = silkbag_name_word[3]

        quality = dms.int(dms["ship_silk_bag_mould"], propMouldId, ship_silk_bag_mould.quality_level) + 1

        local silkBagInfo = prop.info
        propNumber = silkBagInfo.level

        description, basePropertyList, extraPropertyList, excluseSkillDescribe = smSilkBagWordlFundByIndex(propMouldId, silkBagInfo)
    elseif _type == 74 then
        local vouchers_name_id = dms.int(dms["vouchers_mould"], propMouldId, warehouse_vouchers_mould.name_id)
        local vouchers_name_word = dms.element(dms["word_mould"], vouchers_name_id)
        name = vouchers_name_word[3]

        quality = dms.int(dms["vouchers_mould"], propMouldId, warehouse_vouchers_mould.quality_level) + 1

        local describeId = dms.int(dms["vouchers_mould"], propMouldId, warehouse_vouchers_mould.describe_id)
		local describe_info = dms.element(dms["word_mould"], describeId)
        description = describe_info[3]

        propNumber = 1
        
    else 
        name = setThePropsIcon(prop.user_prop_template)[2]
        quality = dms.int(dms["prop_mould"], prop.user_prop_template, prop_mould.prop_quality)+1
        propNumber = prop.prop_number
        description = dms.string(dms["prop_mould"], prop.user_prop_template, prop_mould.remarks)
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            description = drawPropsDescription(prop.user_prop_template)
        end
    end
    Text_packs_props_name:setString(name)
    Text_packs_props_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
    --数量
    if _type == 71 then
        Text_packs_have:setVisible(false)
        Text_packs_props_info:setVisible(false)
        Panel_skill_bag:setVisible(true)
    else
        Text_packs_have:setVisible(true)
        Text_packs_props_info:setVisible(true)
        Panel_skill_bag:setVisible(false)
    end
    -- 锦囊天赋属性
    if Text_jinengmiaoshu and ScrollView_1 then 
        Text_jinengmiaoshu:setVisible(false)
        ScrollView_1:setVisible(false)
    end
        
    Text_packs_have_n:setString(propNumber)
    --描述
    -- Text_packs_props_info:setString(description)
    Text_packs_props_info:removeAllChildren(true)
    
    if _type ~= 71 then
        local _richText2 = ccui.RichText:create()
        _richText2:ignoreContentAdaptWithSize(false)

        local richTextWidth = Text_packs_props_info:getContentSize().width
        if richTextWidth == 0 then
            richTextWidth = Text_packs_props_info:getFontSize() * 6
        end
                    
        _richText2:setContentSize(cc.size(richTextWidth, 0))
        _richText2:setAnchorPoint(cc.p(0, 0))

        if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
            color_Type_1 = cc.c3b(71,71,71)
            color_Type_2 = cc.c3b(71,71,71)
        elseif __lua_project_id ==  __lua_project_l_digital then 
            -- DSC重塑
            color_Type_1 = Text_attribute_info:getColor()
            color_Type_2 = Text_attribute_info:getColor()
        else
            color_Type_1 = cc.c3b(255,255,255)
            color_Type_2 = cc.c3b(255,255,255)
        end

        local rt, count, text = draw.richTextCollectionMethod(_richText2, 
        description, 
        color_Type_1,
        color_Type_2,
        0, 
        0, 
        Text_packs_props_info:getFontName(), 
        Text_packs_props_info:getFontSize(),
        chat_rich_text_color)

        _richText2:formatTextExt()
        local rsize = _richText2:getContentSize()

        Text_packs_props_info:setContentSize(cc.size(Text_packs_props_info:getContentSize().width, rsize.height))
        _richText2:setPositionY(Text_packs_props_info:getContentSize().height)
        _richText2:setPositionX(0)
        Text_packs_props_info:addChild(_richText2)
        
        local ListView_packs_props_info1 = ccui.Helper:seekWidgetByName(root, "ListView_packs_props_info1")
        if ListView_packs_props_info1 ~= nil then
            ListView_packs_props_info1:jumpToTop()
            ListView_packs_props_info1:requestRefreshView()
        end
    else
        Text_attribute_info:setString(description)
        
        for i = 1, 3 do
            local Text_attribute = ccui.Helper:seekWidgetByName(root, "Text_attribute_n_" .. i)
            if basePropertyList[i] then
                Text_attribute:setVisible(true)
                Text_attribute:setString(basePropertyList[i].prop_name .. basePropertyList[i].property_value)
            else
                Text_attribute:setVisible(false)
            end
        end

        local Text_attribute_t_4 = ccui.Helper:seekWidgetByName(root, "Text_attribute_t_4")
        local Text_attribute_t_6 = ccui.Helper:seekWidgetByName(root, "Text_attribute_t_6")
        Text_attribute_t_4:setVisible(false)
        Text_attribute_t_6:setVisible(false)

        for i = 1, 2 do
            local Text_attribute = ccui.Helper:seekWidgetByName(root, "Text_attribute_n_" .. i + 3)
            Text_attribute:setVisible(false)
        end

        local Text_attribute_n_6 = ccui.Helper:seekWidgetByName(root, "Text_attribute_n_6")
        Text_attribute_n_6:setVisible(false)

        if #extraPropertyList > 0 then
            Text_attribute_t_4:setVisible(true)
            for i = 1, 2 do
                local Text_attribute = ccui.Helper:seekWidgetByName(root, "Text_attribute_n_" .. i + 3)
                if extraPropertyList[i] then
                    Text_attribute:setVisible(true)
                    Text_attribute:setString(extraPropertyList[i].prop_name .. extraPropertyList[i].property_value)
                end
            end
        elseif excluseSkillDescribe then
            -- 锦囊护佑属性
            if Text_jinengmiaoshu and ScrollView_1 then 
                Text_attribute_n_6:setVisible(false)
                if excluseSkillDescribe then 
                    Text_attribute_t_6:setVisible(true)
                    Text_jinengmiaoshu:setVisible(true)
                    Text_jinengmiaoshu:setString(excluseSkillDescribe)
                    ScrollView_1:setVisible(true)
                end
            else
                Text_attribute_t_6:setVisible(true)
                Text_attribute_n_6:setVisible(true)
                Text_attribute_n_6:setString(excluseSkillDescribe)
            end
        end
    end

    --出售价格
    if _type == 7 or _type == 71 then
        ccui.Helper:seekWidgetByName(root,"Button_use"):setVisible(true)
        ccui.Helper:seekWidgetByName(root,"Button_open"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Button_use"):setBright(true)
        ccui.Helper:seekWidgetByName(root,"Button_use"):setTouchEnabled(true)

        ccui.Helper:seekWidgetByName(root,"Button_sell"):setBright(false)
        ccui.Helper:seekWidgetByName(root,"Button_sell"):setTouchEnabled(false)
        ccui.Helper:seekWidgetByName(root,"Panel_sell_price"):setVisible(false)
    elseif _type == 74 then 
        ccui.Helper:seekWidgetByName(root,"Button_use"):setBright(false)
        ccui.Helper:seekWidgetByName(root,"Button_use"):setTouchEnabled(false)
        ccui.Helper:seekWidgetByName(root,"Button_sell"):setBright(false)
        ccui.Helper:seekWidgetByName(root,"Button_sell"):setTouchEnabled(false)
        ccui.Helper:seekWidgetByName(root,"Button_open"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Panel_sell_price"):setVisible(false)

        local time_info = prop.end_time
        if time_info then 
            local surplus_time = difftime(time_info)
            local hour = surplus_time / 3600000
            if hour <= 0 then
                ccui.Helper:seekWidgetByName(root,"Button_sell"):setBright(true)
                ccui.Helper:seekWidgetByName(root,"Button_sell"):setTouchEnabled(true)
            else
                ccui.Helper:seekWidgetByName(root,"Button_use"):setVisible(true)
                ccui.Helper:seekWidgetByName(root,"Button_use"):setBright(true)
                ccui.Helper:seekWidgetByName(root,"Button_use"):setTouchEnabled(true)                
            end
        end
    else
        if dms.int(dms["prop_mould"], prop.user_prop_template, prop_mould.silver_price) == 0 then
            ccui.Helper:seekWidgetByName(root,"Button_sell"):setBright(false)
            ccui.Helper:seekWidgetByName(root,"Button_sell"):setTouchEnabled(false)
            ccui.Helper:seekWidgetByName(root,"Panel_sell_price"):setVisible(false)
        else
            ccui.Helper:seekWidgetByName(root,"Button_sell"):setBright(true)
            ccui.Helper:seekWidgetByName(root,"Button_sell"):setTouchEnabled(true)
            ccui.Helper:seekWidgetByName(root,"Panel_sell_price"):setVisible(true)
        end
        local price = dms.int(dms["prop_mould"], prop.user_prop_template, prop_mould.silver_price)
        ccui.Helper:seekWidgetByName(root,"Text_packs_sell_price_n"):setString(price)

        --能否使用
        local use_type = dms.int(dms["prop_mould"], prop.user_prop_template, prop_mould.use_type)
        if use_type == 0 
            or use_type == 3 
            or use_type == 4 
            or use_type == 5 
            or use_type == 7 
            or use_type == 9 
            or use_type == 11 
            or use_type == 12 
            or use_type == 14 
            or use_type == 15 
            or use_type == 17
            or use_type == 18
            or use_type == 19
            or use_type == 20
            or use_type == 21
            or use_type == 22
            or use_type == 23
            or use_type == 24
            or use_type == 25
            or use_type == 26
            then
            ccui.Helper:seekWidgetByName(root,"Button_use"):setBright(true)
            ccui.Helper:seekWidgetByName(root,"Button_use"):setTouchEnabled(true)
            ccui.Helper:seekWidgetByName(root,"Button_open"):setBright(true)
            ccui.Helper:seekWidgetByName(root,"Button_open"):setTouchEnabled(true)
        elseif use_type == 16 then
            if not funOpenDrawTip(123, false) then
                ccui.Helper:seekWidgetByName(root,"Button_use"):setBright(true)
                ccui.Helper:seekWidgetByName(root,"Button_use"):setTouchEnabled(true)
                ccui.Helper:seekWidgetByName(root,"Button_open"):setBright(true)
                ccui.Helper:seekWidgetByName(root,"Button_open"):setTouchEnabled(true)
            else
                ccui.Helper:seekWidgetByName(root,"Button_use"):setBright(false)
                ccui.Helper:seekWidgetByName(root,"Button_use"):setTouchEnabled(false)
                ccui.Helper:seekWidgetByName(root,"Button_open"):setBright(false)
                ccui.Helper:seekWidgetByName(root,"Button_open"):setTouchEnabled(false)
            end
        else
            ccui.Helper:seekWidgetByName(root,"Button_use"):setBright(false)
            ccui.Helper:seekWidgetByName(root,"Button_use"):setTouchEnabled(false)
            ccui.Helper:seekWidgetByName(root,"Button_open"):setBright(false)
            ccui.Helper:seekWidgetByName(root,"Button_open"):setTouchEnabled(false)
        end

        --是否宝箱
        local props_type = dms.int(dms["prop_mould"], prop.user_prop_template, prop_mould.props_type)
        if props_type == 3 
            or props_type == 4 
            or props_type == 7 
            or props_type == 17 
            then
            ccui.Helper:seekWidgetByName(root,"Button_use"):setVisible(false)
            ccui.Helper:seekWidgetByName(root,"Button_open"):setVisible(true)
        else
            ccui.Helper:seekWidgetByName(root,"Button_use"):setVisible(true)
            ccui.Helper:seekWidgetByName(root,"Button_open"):setVisible(false)
        end

        if use_type == 12 then
            if true == funOpenDrawTip(122,false) then
                ccui.Helper:seekWidgetByName(root,"Button_use"):setBright(false)
                ccui.Helper:seekWidgetByName(root,"Button_use"):setTouchEnabled(false)
                ccui.Helper:seekWidgetByName(root,"Button_open"):setBright(false)
                ccui.Helper:seekWidgetByName(root,"Button_open"):setTouchEnabled(false)
            end
        end
    end

    self:updateLimitUIState(prop, _type) 
end

-- 设置限时道具的信息
function SmPropWarehouse:setAllLimitPropInfo()
    local limitPropInfoList = {}
    -- 号令忍界
    local commandWorldProps = zstring.splits(dms.string(dms["activity_config"], 80, activity_config.param), "|", ",")
    for _, v in pairs(commandWorldProps) do
        table.insert(limitPropInfoList, {limitType = self.limitPropEnum.COMMANDWORLD, prop = v})
    end

    self.limitPropInfoList = limitPropInfoList
end

function SmPropWarehouse:updateLimitUIState(prop, _type)
    local root = self.roots[1]
    local Image_zhong = ccui.Helper:seekWidgetByName(root,"Image_zhong")
    local Text_clock = ccui.Helper:seekWidgetByName(root,"Text_clock")
        
    if Image_zhong == nil or Text_clock == nil then
        return
    end

    Image_zhong:setVisible(false)
    Text_clock:setVisible(false)

    if _type == 74 then
        local time_info = prop.end_time
        if time_info then 
            Text_clock:setVisible(true)
            Image_zhong:setVisible(true)

            Text_clock:setString(self:getVouchersClockStr(time_info))
        end
    else
        local clockStr = ""

        local limitPropType = nil
        for _, v in pairs(self.limitPropInfoList) do
            local limitProp = v.prop
            if tonumber(limitProp[1]) == _type and tonumber(limitProp[2]) == tonumber(prop.user_prop_template) then
                limitPropType = v.limitType
                break
            end
        end

        if limitPropType == self.limitPropEnum.COMMANDWORLD then
            clockStr = self:getCommandWorldLimitUIStateInfo(clockStr)
        end

        if clockStr ~= "" then
            Image_zhong:setVisible(true)
            Text_clock:setVisible(true)
            Text_clock:setString(clockStr)
        end
    end
end

function SmPropWarehouse:getVouchersClockStr(time_info)
    local timeStr = ""
    local surplus_time = difftime(time_info)
    local hour = surplus_time / 3600000
    if hour <= 0 then
        timeStr = tipStringInfo_vouchers_tips[2]
    else
        local showTimeTex = 0
        if hour < 1 then 
            local mins = math.floor(hour * 60)
            if mins <=0 then 
                mins = 1
            end
            showTimeTex = string.format(tipStringInfo_vouchers_tips[5],mins)
        elseif hour < 10 and hour >= 1 then 
            hour = math.floor(hour)
            showTimeTex = string.format( "%s",string.format(tipStringInfo_vouchers_tips[1],hour.."") )
        else
            hour = math.floor(hour)
            showTimeTex = string.format(tipStringInfo_vouchers_tips[1],hour.."")
        end
        timeStr = showTimeTex
    end
    return timeStr
end

-- 获得号令忍界的倒计时文本
function SmPropWarehouse:getCommandWorldLimitUIStateInfo(clockStr)
    if _ED.active_activity[174] ~= nil then
        local time_info = _ED.active_activity[174].serverEndTime
        if time_info ~= nil then
            local _localEndTime = time_info.localEndTime
            local _crossServerEndTime = time_info.crossEndTime
            if _crossServerEndTime ~= nil and _localEndTime ~= nil then
                if difftime(_localEndTime) < 0 and difftime(_crossServerEndTime) < 43200000 then
                    clockStr = tipStringInfo_command_world[18]
                end
            end
        end
    end
    return clockStr
end

function SmPropWarehouse:changeSelectPage( page )
    local root = self.roots[1]

    local Panel_packs_props = ccui.Helper:seekWidgetByName(root, "Panel_packs_props")
    local Button_daoju_0 = ccui.Helper:seekWidgetByName(root, "Button_daoju_0")
    local Button_zhuangbei = ccui.Helper:seekWidgetByName(root, "Button_zhuangbei")
    local Button_xinfa = ccui.Helper:seekWidgetByName(root, "Button_xinfa")
    local Button_zhuangbeisuipin = ccui.Helper:seekWidgetByName(root, "Button_zhuangbeisuipin")
    local Button_daoju = ccui.Helper:seekWidgetByName(root, "Button_daoju")
    local Button_renjv = ccui.Helper:seekWidgetByName(root, "Button_renjv")
    local Button_yinji = ccui.Helper:seekWidgetByName(root, "Button_yinji")

    -- DSC重塑
    local textTable = {}
    if __lua_project_id == __lua_project_l_digital then
        local Text_daoju_0_1 = ccui.Helper:seekWidgetByName(root, "Text_daoju_0_1")
        local Text_zhuangbei_1 = ccui.Helper:seekWidgetByName(root, "Text_zhuangbei_1")
        local Text_xinfa_1 = ccui.Helper:seekWidgetByName(root, "Text_xinfa_1")
        local Text_zhuangbeisuipin_1 = ccui.Helper:seekWidgetByName(root, "Text_zhuangbeisuipin_1")
        local Text_daoju_1 = ccui.Helper:seekWidgetByName(root, "Text_daoju_1")
        local Text_renjv_1 = ccui.Helper:seekWidgetByName(root, "Text_renjv_1")
        local Text_yinji_1 = ccui.Helper:seekWidgetByName(root, "Text_yinji_1")

        table.insert(textTable, Text_daoju_0_1)
        table.insert(textTable, Text_zhuangbei_1)
        table.insert(textTable, Text_xinfa_1)
        table.insert(textTable, Text_zhuangbeisuipin_1)
        table.insert(textTable, Text_daoju_1)
        table.insert(textTable, Text_renjv_1)
        table.insert(textTable, Text_yinji_1)
        
        for i, v in ipairs(textTable) do
            if v ~= nil then
                v:setVisible(false)
            end
        end
    end

    if page == self._current_page then
        if page == 1 then
            Button_daoju_0:setHighlighted(true)
        elseif page == 2 then
            Button_zhuangbei:setHighlighted(true)
        elseif page == 3 then
            Button_xinfa:setHighlighted(true)
        elseif page == 4 then
            Button_zhuangbeisuipin:setHighlighted(true)
        elseif page == 5 then    
            Button_daoju:setHighlighted(true)
        elseif page == 6 then    
            Button_renjv:setHighlighted(true)
        elseif page == 7 then    
            Button_yinji:setHighlighted(true)
        end
        -- DSC重塑
        if __lua_project_id == __lua_project_l_digital and textTable[page] ~= nil then
            textTable[page]:setVisible(true)
        end
        return
    end
    self._current_page = page
    Button_daoju_0:setHighlighted(false)
    Button_zhuangbei:setHighlighted(false)
    Button_xinfa:setHighlighted(false)
    Button_zhuangbeisuipin:setHighlighted(false)
    Button_daoju:setHighlighted(false)
    Button_renjv:setHighlighted(false)
    Button_yinji:setHighlighted(false)

    state_machine.excute("sm_all_warehouse_hide", 0, nil)
    state_machine.excute("sm_equip_warehouse_hide", 0, nil)
    state_machine.excute("sm_material_warehouse_hide", 0, nil)
    state_machine.excute("sm_debris_warehouse_hide", 0, nil)
    state_machine.excute("sm_consumables_warehouse_hide", 0, nil)
    state_machine.excute("sm_silkbags_warehouse_hide", 0, nil)
    state_machine.excute("sm_signet_warehouse_hide", 0, nil)
    
    if page == 1 then
        Button_daoju_0:setHighlighted(true)
        if self._all == nil then
            self._all = state_machine.excute("sm_all_warehouse_window_open", 0, {Panel_packs_props})
        else
            state_machine.excute("sm_all_warehouse_show", 0, nil)
        end
	elseif page == 2 then
		Button_zhuangbei:setHighlighted(true)
		if self._equip == nil then
            self._equip = state_machine.excute("sm_equip_warehouse_window_open", 0, {Panel_packs_props})
        else
            state_machine.excute("sm_equip_warehouse_show", 0, nil)
        end
	elseif page == 3 then
		Button_xinfa:setHighlighted(true)
		if self._material == nil then
            self._material = state_machine.excute("sm_material_warehouse_window_open", 0, {Panel_packs_props})
        else
            state_machine.excute("sm_material_warehouse_show", 0, nil)
        end
    elseif page == 4 then
		Button_zhuangbeisuipin:setHighlighted(true)
        if self._debris == nil then
            self._debris = state_machine.excute("sm_debris_warehouse_window_open", 0, {Panel_packs_props})
        else
            state_machine.excute("sm_debris_warehouse_show", 0, nil)
        end
    elseif page == 5 then
        Button_daoju:setHighlighted(true)
        if self._consumables == nil then
            self._consumables = state_machine.excute("sm_consumables_warehouse_window_open", 0, {Panel_packs_props})
        else
            state_machine.excute("sm_consumables_warehouse_show", 0, nil)
        end   
    elseif page == 6 then
        Button_renjv:setHighlighted(true)
        if self._skilBags == nil then
            self._skilBags = state_machine.excute("sm_silkbags_warehouse_window_open", 0, {Panel_packs_props})
        else
            state_machine.excute("sm_silkbags_warehouse_show", 0, nil)
        end
    else
        Button_yinji:setHighlighted(true)
        if self._signet == nil then
            self._signet = state_machine.excute("sm_signet_warehouse_window_open", 0, {Panel_packs_props})
        else
            state_machine.excute("sm_signet_warehouse_show", 0, nil)
        end
	end

    -- DSC重塑
    if __lua_project_id == __lua_project_l_digital then
        if textTable[page] ~= nil then
            
            textTable[page]:setVisible(true)
        end
    end

    -- DB2重塑,锦囊和印记的显示处理
    if __lua_project_id == __lua_project_l_dragonball2 then
        self:showAppointBtn()
    end
end

-- 检查该道具是否是弹出提示的道具
function SmPropWarehouse:getPopPropTipIndex(propId)
    local index = nil
    for i, v in pairs(self._popTipPropList) do
        if tonumber(v[2]) == tonumber(propId) then
            index = i
            break
        end
    end
    return index
end

function SmPropWarehouse:init(params)
    self:setTouchEnabled(true)
	self:onInit(params)
    return self
end

function SmPropWarehouse:onInit(params)
    local csbItem = csb.createNode("packs/warehouse_list.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    local action = csb.createTimeline("packs/warehouse_list.csb")
    table.insert(self.actions, action)
    csbItem:runAction(action)

    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "paiWindow_close_over" then
            ccui.Helper:seekWidgetByName(self.roots[1], "Butto_paiLieGuiZe"):setVisible(true)
        end
    end)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_daoju_back"), nil, 
    {
        terminal_name = "prop_warehouse_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    --全部
   	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_daoju_0"), nil, 
    {
        terminal_name = "prop_warehouse_change_page", 
        terminal_state = 0, 
        _page = 1,
    }, nil, 1)
	
    --装备
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_zhuangbei"), nil, 
    {
        terminal_name = "prop_warehouse_change_page", 
        terminal_state = 0, 
        _page = 2,
    }, nil, 1)

    --材料
   	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_xinfa"), nil, 
    {
        terminal_name = "prop_warehouse_change_page", 
        terminal_state = 0, 
        _page = 3,
    }, nil, 1)

    --碎片
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_zhuangbeisuipin"), nil, 
    {
        terminal_name = "prop_warehouse_change_page", 
        terminal_state = 0, 
        _page = 4,
    }, nil, 1)

    --消耗品
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_daoju"), nil, 
    {
        terminal_name = "prop_warehouse_change_page", 
        terminal_state = 0, 
        _page = 5,
    }, nil, 1)

    --忍具
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_renjv"), nil, 
    {
        terminal_name = "prop_warehouse_change_page", 
        terminal_state = 0, 
        _page = 6,
    }, nil, 1)

    --忍列传印记
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_yinji"), nil, 
    {
        terminal_name = "prop_warehouse_change_page", 
        terminal_state = 0, 
        _page = 7,
    }, nil, 1)

    --出售
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_sell"), nil, 
    {
        terminal_name = "prop_warehouse_sell_prop", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

    --使用
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_use"), nil, 
    {
        terminal_name = "prop_warehouse_use_prop", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

    --打开
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_open"), nil, 
    {
        terminal_name = "prop_warehouse_use_prop", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

    --打开排序选择
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Butto_paiLieGuiZe"), nil, 
    {
        terminal_name = "prop_warehouse_sort_rule_open", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

    --关闭排序选择
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Butto_paiLieGuize_1"), nil, 
    {
        terminal_name = "prop_warehouse_sort_rule_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

    local jumpType = params and params or 1
    self:setAllLimitPropInfo()
    self:changeSelectPage(jumpType)

    local sellPropList = {}
    for i, prop in pairs(_ED.user_prop) do
        if dms.int(dms["prop_mould"], prop.user_prop_template, prop_mould.silver_price) > 0 then
            table.insert(sellPropList, prop)
        end
    end
    if #sellPropList > 0 then
        self:runAction(cc.Sequence:create({cc.DelayTime:create(0.1), cc.CallFunc:create(function ( sender )
            state_machine.excute("prop_warehouse_sell_all_open", 0, sellPropList)
        end)}))
    end

    self:drawUserTopInfo()

    local Panel_effec = ccui.Helper:seekWidgetByName(root, "Panel_effec")
    if Panel_effec ~= nil then
        Panel_effec:removeAllChildren(true)
        local jsonFile = "images/ui/effice/effect_chixu/effect_chixu.json"
        local atlasFile = "images/ui/effice/effect_chixu/effect_chixu.atlas"
        local animation2 = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
        animation2:setPosition(cc.p(Panel_effec:getContentSize().width/2,0))
        Panel_effec:addChild(animation2)
    end

    -- 刷新一下home界面号令忍界限时道具图标
	state_machine.excute("home_update_back_pack_clock_pic", 0, nil)

    local popTipPropAllList = zstring.split(dms.string(dms["activity_config"], 82, activity_config.param), "|")
    self._popTipPropList = {}
    for i,v in ipairs(popTipPropAllList) do
        local tmp = zstring.split(v, "!")
        table.insert(self._popTipPropList, zstring.split(tmp[1], ","))
    end

    local function onOpenTouchEvent(sender, eventType)
        if eventType == ccui.TouchEventType.began then
        elseif eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
            self:updateSelectSortType(sender.types)
        end
    end

    local index = zstring.tonumber(readKey("sm_prop_ware_house_sort_index"))
    self:updateSelectSortType(index ~= 0 and index or 1)
    ccui.Helper:seekWidgetByName(root, "CheckBox_1").types = 1
    ccui.Helper:seekWidgetByName(root, "CheckBox_2").types = 2
    ccui.Helper:seekWidgetByName(root, "CheckBox_3").types = 3
    ccui.Helper:seekWidgetByName(root, "CheckBox_4").types = 4
    ccui.Helper:seekWidgetByName(root, "CheckBox_1"):addTouchEventListener(onOpenTouchEvent)
    ccui.Helper:seekWidgetByName(root, "CheckBox_2"):addTouchEventListener(onOpenTouchEvent)
    ccui.Helper:seekWidgetByName(root, "CheckBox_3"):addTouchEventListener(onOpenTouchEvent)
    ccui.Helper:seekWidgetByName(root, "CheckBox_4"):addTouchEventListener(onOpenTouchEvent)
end

-- DB2重塑,锦囊和印记的显示处理
function SmPropWarehouse:showAppointBtn()
    local root = self.roots[1]
    local userLevel = tonumber(_ED.user_info.user_grade)
    local skilOpen = userLevel >= dms.int(dms["fun_open_condition"], 192, fun_open_condition.level) 
    local signetOpen = userLevel >= dms.int(dms["fun_open_condition"], 199, fun_open_condition.level) 
    ccui.Helper:seekWidgetByName(root, "Button_renjv"):setVisible(skilOpen)
    ccui.Helper:seekWidgetByName(root, "Button_yinji"):setVisible(signetOpen)
end

function SmPropWarehouse:drawUserTopInfo()
    local userinfo = UserTopInfoA:new()
    userinfo._rootWindows = self
    fwin:open(userinfo, fwin._view)
end

--排序
--1类型排序升序
--2类型排序降序
--3时间排序升序
--4时间排序降序
function SmPropWarehouse:updateSelectSortType(indexs)
    local root = self.roots[1]
    self.sortType = indexs
    writeKey("sm_prop_ware_house_sort_index", indexs)
    if indexs == 1 then
        ccui.Helper:seekWidgetByName(root, "CheckBox_1"):setTouchEnabled(false)
        ccui.Helper:seekWidgetByName(root, "CheckBox_2"):setTouchEnabled(true)
        ccui.Helper:seekWidgetByName(root, "CheckBox_3"):setTouchEnabled(true)
        ccui.Helper:seekWidgetByName(root, "CheckBox_4"):setTouchEnabled(true)
        ccui.Helper:seekWidgetByName(root, "CheckBox_2"):setSelected(false)
        ccui.Helper:seekWidgetByName(root, "CheckBox_3"):setSelected(false)
        ccui.Helper:seekWidgetByName(root, "CheckBox_4"):setSelected(false)
    elseif indexs == 2 then
        ccui.Helper:seekWidgetByName(root, "CheckBox_2"):setTouchEnabled(false)
        ccui.Helper:seekWidgetByName(root, "CheckBox_1"):setTouchEnabled(true)
        ccui.Helper:seekWidgetByName(root, "CheckBox_3"):setTouchEnabled(true)
        ccui.Helper:seekWidgetByName(root, "CheckBox_4"):setTouchEnabled(true)
        ccui.Helper:seekWidgetByName(root, "CheckBox_1"):setSelected(false)
        ccui.Helper:seekWidgetByName(root, "CheckBox_3"):setSelected(false)
        ccui.Helper:seekWidgetByName(root, "CheckBox_4"):setSelected(false)
    elseif indexs == 3 then
        ccui.Helper:seekWidgetByName(root, "CheckBox_3"):setTouchEnabled(false)
        ccui.Helper:seekWidgetByName(root, "CheckBox_1"):setTouchEnabled(true)
        ccui.Helper:seekWidgetByName(root, "CheckBox_2"):setTouchEnabled(true)
        ccui.Helper:seekWidgetByName(root, "CheckBox_4"):setTouchEnabled(true)
        ccui.Helper:seekWidgetByName(root, "CheckBox_1"):setSelected(false)
        ccui.Helper:seekWidgetByName(root, "CheckBox_2"):setSelected(false)
        ccui.Helper:seekWidgetByName(root, "CheckBox_4"):setSelected(false)
    elseif indexs == 4 then
        ccui.Helper:seekWidgetByName(root, "CheckBox_4"):setTouchEnabled(false)
        ccui.Helper:seekWidgetByName(root, "CheckBox_1"):setTouchEnabled(true)
        ccui.Helper:seekWidgetByName(root, "CheckBox_2"):setTouchEnabled(true)
        ccui.Helper:seekWidgetByName(root, "CheckBox_3"):setTouchEnabled(true)
        ccui.Helper:seekWidgetByName(root, "CheckBox_1"):setSelected(false)
        ccui.Helper:seekWidgetByName(root, "CheckBox_2"):setSelected(false)
        ccui.Helper:seekWidgetByName(root, "CheckBox_3"):setSelected(false)
    end
    state_machine.excute("prop_warehouse_update_draw_page", 0, nil)
end

function SmPropWarehouse:onEnterTransitionFinish()
    
end

function SmPropWarehouse:close( ... )
    local Panel_effec = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_effec")
    if Panel_effec ~= nil then
        Panel_effec:removeAllChildren(true)
    end
end

function SmPropWarehouse:onExit()
    state_machine.remove("prop_warehouse_change_page")
    state_machine.remove("prop_warehouse_update_data_info")
    state_machine.remove("prop_warehouse_show_data_interface")
    state_machine.remove("prop_warehouse_hide_data_interface")
    state_machine.remove("prop_warehouse_sell_prop")
    state_machine.remove("prop_warehouse_use_prop")
    state_machine.remove("prop_warehouse_use_prop_update")
    state_machine.remove("prop_warehouse_sell_prop_update")
    state_machine.remove("prop_warehouse_update_draw_page")
end

