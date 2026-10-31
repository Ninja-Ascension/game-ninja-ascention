-- ----------------------------------------------------------------------------------------------------
-- 说明: 
-------------------------------------------------------------------------------------------------------

RechargeDialog = class("RechargeDialogClass", Window)
local recharge_dialog_window_open_terminal = {
    _name = "recharge_dialog_window_open",
    _init = function (terminal) 

    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
            or __lua_project_id == __lua_project_l_pokemon 
            or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
            then
            if funOpenDrawTip(181) == true then
                return
            end
        else
        	if funOpenDrawTip(60) == true then
                return
            end
        end
        if __lua_project_id == __lua_project_red_alert_time 
            or __lua_project_id == __lua_project_pacific_rim 
            then
            fwin:open(RechargeDialog:new():setMonthType(params), fwin._ui)
        else
            fwin:open(RechargeDialog:new():setMonthType(params), fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(recharge_dialog_window_open_terminal)	
state_machine.init()
function RechargeDialog:ctor()
    self.super:ctor()
	app.load("client.cells.recharge.recharge_list_cell")

	if __lua_project_id == __lua_project_red_alert_time 
        or __lua_project_id == __lua_project_pacific_rim 
        then
		app.load("client.red_alert_time.cells.shop.shop_chongzhi_frist_cell")
	end
	self.roots = {}
	
	self._showVip = false
	self._vip_privilege_panel = nil

	self.nextSceneID = 0
	self.nextTypes = nil
	self._UpGrade = {}
	self.uiCell = nil

	self._choose_month_type = nil

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		self.VipMaxGrade = 18 -- vip等级上限
	else
		self.VipMaxGrade = 12 -- vip等级上限
	end
	-- Initialize recharge_dialog_close page state machine.
    local function init_recharge_dialog_close_terminal()
		
		local recharge_dialog_close_terminal = {
            _name = "recharge_dialog_close",
            _init = function (terminal) 
                -- app.load("client.shop.recharge.RechargeDialog")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance.nextTypes == 1 then
					state_machine.excute("show_vip_privilege", 0, "event show_vip_privilege.")
				end
				if instance.nextTypes == 100 then 
					--限时优惠 新活动关闭后弹出提示 ActivityRechargeSale 中使用
					state_machine.excute("activity_recharge_sale_goto_recharge_close_tip", 0, 0)
				end
				instance:setVisible(false)
				-- if instance.nextSceneID == 1 then
					-- state_machine.excute("shop_ship_recruit", 0, "event shop_ship_recruit.")
				-- elseif instance.nextSceneID == 2 then
					-- state_machine.excute("shop_prop_buy", 0, "event shop_prop_buy.")
				-- elseif instance.nextSceneID == 3 then
					-- state_machine.excute("shop_vip_buy", 0, "event shop_vip_buy.")
				-- elseif instance.nextSceneID == 4 then
				-- if instance.nextSceneID == 4 then
					-- fwin:cleanView(fwin._view)
					fwin:close(instance)
					fwin:close(fwin:find("RechargeDialogClass"))

                    if fwin:find("UserInformationShopClass") ~= nil then
                        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                            if fwin:find("ShopClass") ~= nil then

                            else
                                -- fwin:close(fwin:find("UserInformationShopClass"))
                            end
                        else
                            fwin:close(fwin:find("UserInformationShopClass"))
                        end
                    end
                    if fwin:find("SmVipPrivilegeDialogClass") ~= nil then
                        fwin:close(fwin:find("SmVipPrivilegeDialogClass"))
                    end

					if __lua_project_id == __lua_project_red_alert 
						then
						if fwin:find("WonderfulOpenClass") ~= nil then
							state_machine.excute("topup_reward_set_positiony", 0, "")
							state_machine.excute("nowday_topup_reward_set_positiony", 0, "")
						end
						if fwin:find("WonderfulClass") ~= nil then
							state_machine.excute("one_recharge_set_positiony", 0, "")
							state_machine.excute("accumulated_topup_set_positiony", 0, "")
							state_machine.excute("luxury_sign_set_positiony", 0, "")
							state_machine.excute("monthly_topup_reward_set_positiony", 0, "")
						end
					elseif __lua_project_id == __lua_project_red_alert_time 
                        or __lua_project_id == __lua_project_pacific_rim 
                        then
						state_machine.excute("main_window_update_gold_info", 0, nil)
                        state_machine.excute("build_up_make_factory_production_update_draw", 0, nil)
                        state_machine.excute("props_shop_packs_update_draw", 0, nil)
                        state_machine.excute("props_batch_buy_update_draw", 0, nil)
                        state_machine.excute("player_info_build_update_VIP_info", 0, nil)
                    	state_machine.excute("red_alert_time_privilege_chest_buy_time", 0, nil)
                        state_machine.excute("red_alert_time_recharge_bonus_update_draw", 0, nil)
				        state_machine.excute("red_alert_time_leveling_vip_update_draw", 0, nil)
                        state_machine.excute("red_alert_time_seven_day_recruit_update_draw", 0, nil)
                        state_machine.excute("world_battle_event_info_march_update_state", 0, 0)
                        state_machine.excute("armor_production_update_gold_info", 0, nil)
                        state_machine.excute("red_alert_time_rank_activity_request_update",0, nil)
                        state_machine.excute("red_alert_time_discount_store_reward_update_gold_info", 0, "")
                        state_machine.excute("red_alert_time_rebate_turntable_update_draw", 0, "")
                        -- 校验开启教学事件
				        state_machine.excute("main_window_check_mission", 0, 0)
                    elseif __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                        then
                        state_machine.excute("sm_smoked_eggs_window_update_draw", 0, "")
                        state_machine.excute("sm_limited_time_equip_box_update_draw", 0, "")
					end
					-- app.load("client.home.Home")
					-- fwin:open(Home:new(), fwin._view)
				-- else
					-- state_machine.excute("shop_ship_recruit", 0, "event shop_ship_recruit.")
				-- end
				NetworkManager:register(protocol_command.keep_alive.code, nil, nil, nil, nil, nil, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local show_vip_privilege_terminal = {
            _name = "show_vip_privilege",
            _init = function (terminal) 
                app.load("client.shop.recharge.VipPrivilegeDialog")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
            		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
            		then
            		app.load("client.l_digital.shop.recharge.SmVipPrivilegeDialog")
            		local Panel_vip_tab = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_vip_tab")
            		local ScrollView_1 = ccui.Helper:seekWidgetByName(instance.roots[1], "ScrollView_1")
            		local Button_2 = ccui.Helper:seekWidgetByName(instance.roots[1], "Button_2")
            		local _windows = fwin:find("SmVipPrivilegeDialogClass")
            		if _windows ~= nil then
            			_windows.page_index = tonumber(_ED.vip_grade) - 1
						_windows.page_index = math.max(0 , _windows.page_index)
                        if params ~= nil and params.isShowNextVip == true then
                            _windows.page_index = tonumber(_ED.vip_grade)
                        end
                        _windows.page_index = math.min(_windows.page_index, 17)
						_windows.PageView:scrollToPage(_windows.page_index)
						_windows:updateButton()
            			ScrollView_1:setVisible(false)
            			Button_2:setVisible(false)
            			_windows:setVisible(true)
            		else
	            		local function responseVIPShopViewCallBack(response)
							if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
								if response.node ~= nil and response.node.initListViews ~= nil then
				            		local page = state_machine.excute("sm_vip_PrivilegeDialog_open",0,Panel_vip_tab)
				            		ScrollView_1:setVisible(false)
				            		Button_2:setVisible(false)
                                    if params ~= nil and params.isShowNextVip == true then
                                        page.page_index = tonumber(_ED.vip_grade)
                                        page.page_index = math.min(page.page_index, 17)
                                        page.PageView:scrollToPage(page.page_index)
                                    end
								end
							end
						end
	            		if _ED.return_vip_prop == nil or _ED.return_vip_prop[1] == nil then
		            		protocol_command.shop_view.param_list = "1"
							NetworkManager:register(protocol_command.shop_view.code, nil, nil, nil, self, responseVIPShopViewCallBack, false, nil)
						else
							local page = state_machine.excute("sm_vip_PrivilegeDialog_open",0,Panel_vip_tab)
				            ScrollView_1:setVisible(false)
				            Button_2:setVisible(false)
                            if params ~= nil and type(params) ~= "number" and params.isShowNextVip == true then
                                page.page_index = tonumber(_ED.vip_grade)
                                page.page_index = math.min(page.page_index, 17)
                                page.PageView:scrollToPage(page.page_index)
                            end
						end
					end
            	else 
	            	if __lua_project_id == __lua_project_red_alert
                        or __lua_project_id == __lua_project_red_alert_time 
                        or __lua_project_id == __lua_project_pacific_rim
                        then
	            		if funOpenDrawTip(98) == true then
	            			return
	            		end
	            	end
					fwin:open(VipPrivilegeDialog:new(), fwin._windows)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local refresh_privilege_button_terminal = {
            _name = "refresh_privilege_button",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				if fwin:find("RechargeDialogClass") ~= nil then
					instance:refreshDraw()
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local tw_pay_button_terminal = {
            _name = "tw_pay_button",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local rechargeIndex = "1"
				m_reqcharge_info.rechargeIndex = rechargeIndex
				local function responseGetServerListCallback(response)
					fwin:close(fwin:find("ConnectingViewClass"))
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_WINDOWS 
						and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_LINUX 
						and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_MAC then
							state_machine.excute("platform_request_for_payment", 0, "platform_request_for_payment.")
							return
						end
					end
				end
				protocol_command.request_top_up_order_number.param_list = ""..rechargeIndex.."\r\n"..m_sPayMould
				NetworkManager:register(protocol_command.request_top_up_order_number.code, nil, nil, nil, params, responseGetServerListCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		local recharge_update_all_list_cell_terminal = {
            _name = "recharge_update_all_list_cell",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	if __lua_project_id == __lua_project_gragon_tiger_gate 
                    or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
            		or __lua_project_id == __lua_project_red_alert 
            		or __lua_project_id == __lua_project_red_alert_time 
                    or __lua_project_id == __lua_project_pacific_rim
            		or __lua_project_id == __lua_project_digimon_adventure 
            		or __lua_project_id == __lua_project_naruto 
            		or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge 
            		or __lua_project_id == __lua_project_yugioh 
            		or __lua_project_id == __lua_project_warship_girl_b 
            		then
            		if instance ~= nil and instance.onupdateAllCell ~= nil then
            			instance:onupdateAllCell()
            		end
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --魔兽的VIP特权
        local show_vip_privilege_red_alert_terminal = {
            _name = "show_vip_privilege_red_alert",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
        		if funOpenDrawTip(98) == true then
        			return
        		end
        		app.load("client.red_alert.recharge.VipPrivilegeRedAlert")
        		if instance._vip_privilege_panel == nil then
	        		local Panel_vip_privileges = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_vip_privileges")
					instance._vip_privilege_panel = state_machine.excute("vip_privilege_red_alert_window_open", 0, {Panel_vip_privileges})
				else
	                state_machine.excute("vip_privilege_red_alert_refresh", 0, nil)
				end
				ccui.Helper:seekWidgetByName(instance.roots[1], "Button_charge"):setHighlighted(false)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Button_2"):setHighlighted(true)
				ccui.Helper:seekWidgetByName(instance.roots[1], "ListView_1"):setVisible(false)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_vip_privileges"):setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --魔兽的VIP充值
        local show_vip_buy_red_alert_terminal = {
            _name = "show_vip_buy_red_alert",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
        		if funOpenDrawTip(98) == true then
        			return
        		end
        		ccui.Helper:seekWidgetByName(instance.roots[1], "Button_charge"):setHighlighted(true)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Button_2"):setHighlighted(false)
				ccui.Helper:seekWidgetByName(instance.roots[1], "ListView_1"):setVisible(true)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_vip_privileges"):setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		--红警的VIP特权
        local show_vip_privilege_red_alert_time_terminal = {
            _name = "show_vip_privilege_red_alert_time",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
        		app.load("client.red_alert_time.recharge.VipPrivilegeRedAlert")
        		local Panel_vip_privileges = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_vip_privileges")
        		local Button_recharge = ccui.Helper:seekWidgetByName(instance.roots[1], "Button_recharge")
        		local ListView_1 = ccui.Helper:seekWidgetByName(instance.roots[1], "ListView_1")
        		instance._showVip = not instance._showVip
        		if instance._showVip == false then
        			ListView_1:setVisible(true)
					Panel_vip_privileges:setVisible(false)
                    if Button_recharge ~= nil then
					   Button_recharge:setTitleText(activity_str_tip[55]..activity_str_tip[57])
                    end
        		else
	        		if instance._vip_privilege_panel == nil then
						instance._vip_privilege_panel = state_machine.excute("vip_privilege_red_alert_window_open", 0, {Panel_vip_privileges})
					end
					state_machine.excute("vip_privilege_red_alert_change_vip_title", 0, nil)
					ListView_1:setVisible(false)
					Panel_vip_privileges:setVisible(true)
                    if Button_recharge ~= nil then
					   Button_recharge:setTitleText(red_alert_time_str[30])
                    end
        		end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		--删除
        local recharge_dialog_window_cleared_first_red_terminal = {
            _name = "recharge_dialog_window_cleared_first_red",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if RechargeDialog.cacheListView:getChildByTag(998) ~= nil then
                	RechargeDialog.cacheListView:removeItem(0)
                end
                RechargeDialog.cacheListView:requestRefreshView()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --显示
        local recharge_dialog_window_show_terminal = {
            _name = "recharge_dialog_window_show",
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

        --隐藏
        local recharge_dialog_window_hide_terminal = {
            _name = "recharge_dialog_window_hide",
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
        --移除只充一次的
        local recharge_dialog_remove_just_recharge_once_terminal = {
            _name = "recharge_dialog_remove_just_recharge_once",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if dms.int(dms["top_up_goods"], tonumber(_ED.recharge_result_cheak.recharge_id), top_up_goods.picture_index) == 4 then
                    local items = RechargeDialog.cacheListView:getItems()
                    for i ,v in pairs(items) do
                        if tonumber(v.example[1]) == tonumber(_ED.recharge_result_cheak.recharge_id) then
                            RechargeDialog.cacheListView:removeItem(i - 1)
                            break
                        end
                    end
                    RechargeDialog.cacheListView:requestRefreshView()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --机甲VIP特权充值页面
        local recharge_dialog_window_change_show_vip_terminal = {
            _name = "recharge_dialog_window_change_show_vip",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local root = instance.roots[1]
                local Button_chongzhi_1 = ccui.Helper:seekWidgetByName(root, "Button_chongzhi_1")
                local Button_chongzhi_2 = ccui.Helper:seekWidgetByName(root, "Button_chongzhi_2")
                local is_show = params._datas.is_show
                if is_show == true then
                    Button_chongzhi_1:setHighlighted(false)
                    Button_chongzhi_2:setHighlighted(true)
                else
                    Button_chongzhi_1:setHighlighted(true)
                    Button_chongzhi_2:setHighlighted(false)
                end
                if instance._showVip ~= is_show then
                    app.load("client.red_alert_time.recharge.VipPrivilegePacificRim")
                    local Panel_vip_privileges = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_vip_privileges")
                    local Button_recharge = ccui.Helper:seekWidgetByName(instance.roots[1], "Button_recharge")
                    local ListView_1 = ccui.Helper:seekWidgetByName(instance.roots[1], "ListView_1")
                    instance._showVip = is_show
                    if instance._showVip == false then
                        ListView_1:setVisible(true)
                        Panel_vip_privileges:setVisible(false)
                        if Button_recharge ~= nil then
                            Button_recharge:setTitleText(activity_str_tip[55]..activity_str_tip[57])
                        end
                    else
                        if instance._vip_privilege_panel == nil then
                            instance._vip_privilege_panel = state_machine.excute("vip_privilege_pacific_rim_window_open", 0, {Panel_vip_privileges, _ED.vip_grade})
                        end
                        state_machine.excute("vip_privilege_red_alert_change_vip_title", 0, nil)
                        ListView_1:setVisible(false)
                        Panel_vip_privileges:setVisible(true)
                        if Button_recharge ~= nil then
                            Button_recharge:setTitleText(red_alert_time_str[30])
                        end
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --
        local recharge_dialog_url_jump_terminal = {
            _name = "recharge_dialog_url_jump",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                handlePlatformRequest(0, CC_OPEN_URL, _web_page_jump[5])
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }

         --
        local recharge_dialog_open_rechaege_repair_tips_terminal = {
            _name = "recharge_dialog_open_rechaege_repair_tips",
            _init = function (terminal)
                app.load("client.shop.recharge.RechargeRepairTip")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("recharge_repair_tip_window_open", 0, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }

		 -- 移动充值到最小档位
		 local recharge_dialog_open_move_recharge_min_terminal = {
            _name = "recharge_dialog_open_move_recharge_min",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then 
					instance:moveScrollMin()
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }

        state_machine.add(recharge_dialog_remove_just_recharge_once_terminal)
        state_machine.add(refresh_privilege_button_terminal)
		state_machine.add(recharge_dialog_close_terminal)
		state_machine.add(show_vip_privilege_terminal)
		state_machine.add(tw_pay_button_terminal)
		state_machine.add(recharge_update_all_list_cell_terminal)
		state_machine.add(show_vip_privilege_red_alert_terminal)
		state_machine.add(show_vip_buy_red_alert_terminal)
		state_machine.add(show_vip_privilege_red_alert_time_terminal)
		state_machine.add(recharge_dialog_window_show_terminal)
		state_machine.add(recharge_dialog_window_hide_terminal)
		state_machine.add(recharge_dialog_window_cleared_first_red_terminal)
        state_machine.add(recharge_dialog_window_change_show_vip_terminal)
        state_machine.add(recharge_dialog_url_jump_terminal)
        state_machine.add(recharge_dialog_open_rechaege_repair_tips_terminal)
		state_machine.add(recharge_dialog_open_move_recharge_min_terminal)

        state_machine.init()
    end
    
    -- call func init recharge_dialog state machine.
    init_recharge_dialog_close_terminal()
end

function RechargeDialog:onShow( )
    self:setVisible(true)
end

function RechargeDialog:onHide( )
    self:setVisible(false)
end

function RechargeDialog:onupdateAllCell( ... )
	local root = self.roots[1]
	local myListView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	if __lua_project_id == __lua_project_digimon_adventure 
		or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_red_alert_time 
        or __lua_project_id == __lua_project_pacific_rim 
		then 
		for i,v in pairs(myListView:getItems()) do
            if v ~= nil and v.upDataDraw ~= nil then
    			v:upDataDraw()
            end
		end
	elseif __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		local ScrollView_1 = ccui.Helper:seekWidgetByName(root, "ScrollView_1")
		for i, v in pairs(ScrollView_1:getChildren()) do
			v:upDataDraw()
		end
	else
		for i,v in pairs(myListView:getItems()) do
			if v.child1 ~= nil and v.child1.refreshDraw ~= nil then
				v.child1:upDataDraw()
			end
			if v.child2 ~= nil and v.child2.refreshDraw ~= nil then
				v.child2:upDataDraw()
			end		
		end	
	end
end

-- 返回某一个等级所需的总Energy数
function RechargeDialog:retGradeNeedEng(grade)
	if(grade == 0) then return 0 end
	if(grade>self.VipMaxGrade) then grade = self.VipMaxGrade end
	local sum = 0
	--[[
	for i = 1,grade do
		sum = sum + self._UpGrade[i]
	end
	--]]
	return self._UpGrade[grade]
end
--获得VIP等级
function RechargeDialog:getGrade()
	if(tonumber(_ED.vip_grade)>self.VipMaxGrade) then _ED.vip_grade = self.VipMaxGrade end
	return tonumber(_ED.vip_grade)
end
--返回下一级等级以及所需要的Energy
function RechargeDialog:retNextUpgradeAndNeedEnergy()
	local nextUpgrade = self:getGrade() >= self.VipMaxGrade and self.VipMaxGrade or self:getGrade() + 1
	local index = 0
	--local sumEng = 0
	for i = 1,self.VipMaxGrade do
		if(i <= self:getGrade()) then
		else
			index = i
			break
		end
	end
	local needEng = self:retGradeNeedEng(index)
	if(self:getGrade() == self.VipMaxGrade) then 
		needEng = self:retGradeNeedEng(self:getGrade()) 
	end
	return nextUpgrade , needEng
end


function RechargeDialog:getNowEnergy()
	return _ED.recharge_precious_number
end


--[[
	充值完了之后刷新上面的信息
	refreshDraw()方法里面
--]]

function RechargeDialog:retGradeNeedEngRefresh(grade)
	if(grade == 0) then return 0 end
	if(grade>self.VipMaxGrade) then grade = self.VipMaxGrade end
	local sum = 0
	--[[
	for i = 1,grade do
		sum = sum + self._UpGrade[i]
	end
	--]]
	return self._UpGrade[grade]
end
--获得VIP等级
function RechargeDialog:getGradeRefresh()
	if(tonumber(_ED.vip_grade)>self.VipMaxGrade) then _ED.vip_grade = self.VipMaxGrade end
	return tonumber(_ED.vip_grade)
end
	
function RechargeDialog:retNextUpgradeAndNeedEnergyRefresh()
	local nextUpgrade = self:getGradeRefresh() >= self.VipMaxGrade and self.VipMaxGrade or self:getGradeRefresh() + 1
	local index = 0
	--local sumEng = 0
	for i = 1,self.VipMaxGrade do
		if(i <= self:getGradeRefresh()) then
		else
			index = i
			break
		end
	end
	local needEng = self:retGradeNeedEngRefresh(index)
	if(self:getGradeRefresh() == self.VipMaxGrade) then 
		needEng = self:retGradeNeedEngRefresh(self:getGradeRefresh()) 
	end
	return nextUpgrade , needEng
end

function RechargeDialog:refreshDraw()
	local root = self.roots[1]

	local vipGrade = ccui.Helper:seekWidgetByName(root, "AtlasLabel_vip_1")
	local nowText = ccui.Helper:seekWidgetByName(root, "Text_chongzhi_3")
	local nextText = ccui.Helper:seekWidgetByName(root, "Text_vip_1")
	local loadingBarText = ccui.Helper:seekWidgetByName(root, "Text_6")
	local loadingBar = ccui.Helper:seekWidgetByName(root, "LoadingBar_vip")
	local Text_vip_tips = ccui.Helper:seekWidgetByName(root, "Text_vip_tips")
	
	local nowEnergy = _ED.recharge_precious_number			--充值总宝石数
	local GradeVip = _ED.vip_grade--VIP等级
	vipGrade:setString(GradeVip)
	nextText:setString(_string_piece_info[228]..tonumber(GradeVip)+1)
	for i = 1, self.VipMaxGrade do
		local nextNeedStr = dms.string(dms["base_consume"],8,(tonumber(base_consume.vip_0_value)+i-1))
		self._UpGrade[i] = nextNeedStr
	end
	nextUpgrade,needEng = self:retNextUpgradeAndNeedEnergyRefresh()
	loadingBarText:setString(nowEnergy.."/"..needEng) -- 进度条上数字

	local need = self:retGradeNeedEng(self:getGradeRefresh()+1) - nowEnergy
    if nowText ~= nil then
	   nowText:setString(need)
    end
					
	local enduranceCount = 0
	enduranceCount = tonumber(nowEnergy)/tonumber(needEng)*100
	if enduranceCount >100 then
		enduranceCount = 100
	end
	if enduranceCount < 0 then
		enduranceCount = 0
	end
	loadingBar:setPercent(enduranceCount)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		if tonumber(GradeVip) == self.VipMaxGrade then
			local Panel_2 = ccui.Helper:seekWidgetByName(root, "Panel_2")
			local vip_lv_di = Panel_2:getChildByName("vip_lv_di")
			local AtlasLabel_vip_1 = ccui.Helper:seekWidgetByName(root, "AtlasLabel_vip_1")
			local Panel_vip_top = ccui.Helper:seekWidgetByName(root, "Panel_vip_top")
			local LoadingBar_vip = ccui.Helper:seekWidgetByName(root, "LoadingBar_vip")
			Panel_vip_top:setVisible(false)
			vip_lv_di:setPositionX(LoadingBar_vip:getPositionX() - vip_lv_di:getContentSize().width)
			AtlasLabel_vip_1:setPositionX(vip_lv_di:getPositionX() + vip_lv_di:getContentSize().width / 2)
		end
	elseif __lua_project_id == __lua_project_gragon_tiger_gate
        or __lua_project_id == __lua_project_red_alert 
        or __lua_project_id == __lua_project_red_alert_time 
        or __lua_project_id == __lua_project_pacific_rim
        then    
        if Text_vip_tips ~= nil then
            Text_vip_tips:removeAllChildren(true)
            local vip_desc = _string_piece_info[228].."1"
            if tonumber(GradeVip) > 0 then
                vip_desc = string.format(red_alert_time_str[97], math.min(tonumber(GradeVip) + 1, self.VipMaxGrade))
            end
            local _richText = ccui.RichText:create()
            _richText:ignoreContentAdaptWithSize(false)       
            local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, red_alert_time_str[96], "fonts/simhei.ttf",20)
            _richText:pushBackElement(re1)  
            local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[5][1],color_Type[5][2],color_Type[5][3]),255, vip_desc, "fonts/simhei.ttf",20)
            _richText:pushBackElement(re2)
            local re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, red_alert_time_str[98], "fonts/simhei.ttf",20)
            _richText:pushBackElement(re3)
            _richText:setPosition(cc.p(Text_vip_tips:getContentSize().width/2,Text_vip_tips:getContentSize().height/2))
            _richText:setContentSize(cc.size(Text_vip_tips:getContentSize().width,20))
            Text_vip_tips:addChild(_richText)
        end	
		--print("GradeVip",GradeVip)
		if tonumber(GradeVip) == self.VipMaxGrade then
			local Text_2_1 = ccui.Helper:seekWidgetByName(root, "Text_2_1")
			local Panel_2 = ccui.Helper:seekWidgetByName(root, "Panel_2")
			local image1 = Panel_2:getChildByName("baoshi_1_0")
			--print("image1...",image1:getName())
			local Text_chongzhi_3 = ccui.Helper:seekWidgetByName(root, "Text_chongzhi_3")
			local Text_2 = ccui.Helper:seekWidgetByName(root, "Text_2")
			local Text_vip_1 = ccui.Helper:seekWidgetByName(root, "Text_vip_1")
			Text_2_1:setVisible(false)
            if image1 ~= nil then
                image1:setVisible(false)
            end
            if Text_chongzhi_3 ~= nil then
                Text_chongzhi_3:setVisible(false)
            end
            if Text_2 ~= nil then
                Text_2:setVisible(false)
            end
			Text_vip_1:setVisible(false)
			
			loadingBar:setPercent(100)
			loadingBarText:setString(nowEnergy.."/"..self._UpGrade[self.VipMaxGrade])
		end
    end
    if __lua_project_id == __lua_project_pacific_rim then
        local Text_vip_1 = ccui.Helper:seekWidgetByName(root, "Text_vip_1")
        local Text_2_1 = ccui.Helper:seekWidgetByName(root, "Text_2_1")
        if tonumber(GradeVip) == self.VipMaxGrade then
            Text_vip_1:setVisible(false)
            Text_2_1:setVisible(false)
        else
            Text_vip_1:setString(string.format(tipString_info_project_pacific_rim[4], GradeVip + 1))
            Text_2_1:setString(""..need.." "..tipString_info_project_pacific_rim[5])
        end
        state_machine.excute("vip_privilege_pacific_rim_update_shop_info", 0, "")
	end
	-- TODO:老用户回归消耗
	if _ED.active_activity[165] ~= nil then
		state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 164)
		app.load("client.activity.user_return.UserReturnMainTab2")
		state_machine.excute("user_return_main_tab2_refresh",0,"")
	end
end


function RechargeDialog:onUpdateDraw()
	local root = self.roots[1]
	local vipGrade = ccui.Helper:seekWidgetByName(root, "AtlasLabel_vip_1")
	local nowText = ccui.Helper:seekWidgetByName(root, "Text_chongzhi_3")
	local nextText = ccui.Helper:seekWidgetByName(root, "Text_vip_1")
	local loadingBarText = ccui.Helper:seekWidgetByName(root, "Text_6")
	local loadingBar = ccui.Helper:seekWidgetByName(root, "LoadingBar_vip")
	local Text_vip_tips = ccui.Helper:seekWidgetByName(root, "Text_vip_tips")
	
	local nowEnergy = _ED.recharge_precious_number			--充值总宝石数
	local GradeVip = _ED.vip_grade--VIP等级
	vipGrade:setString(GradeVip)
	nextText:setString(_string_piece_info[228]..tonumber(GradeVip)+1)
	for i = 1, self.VipMaxGrade do
		local nextNeedStr = dms.string(dms["base_consume"],8,(tonumber(base_consume.vip_0_value)+i-1))
		self._UpGrade[i] = nextNeedStr
	end
	nextUpgrade,needEng = self:retNextUpgradeAndNeedEnergy()
	loadingBarText:setString(nowEnergy.."/"..needEng) -- 进度条上数字
	
	local need = self:retGradeNeedEng(self:getGrade()+1) - self:getNowEnergy()
    if nowText ~= nil then
        nowText:setString(need)
    end
					
	local enduranceCount = 0
	enduranceCount = tonumber(nowEnergy)/tonumber(needEng)*100
	if enduranceCount >100 then
		enduranceCount = 100
	end
	if enduranceCount < 0 then
		enduranceCount = 0
	end
	loadingBar:setPercent(enduranceCount)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then 
		if tonumber(GradeVip) == self.VipMaxGrade then
			local Panel_2 = ccui.Helper:seekWidgetByName(root, "Panel_2")
			local vip_lv_di = Panel_2:getChildByName("vip_lv_di")
			local AtlasLabel_vip_1 = ccui.Helper:seekWidgetByName(root, "AtlasLabel_vip_1")
			local Panel_vip_top = ccui.Helper:seekWidgetByName(root, "Panel_vip_top")
			local LoadingBar_vip = ccui.Helper:seekWidgetByName(root, "LoadingBar_vip")
			Panel_vip_top:setVisible(false)
			vip_lv_di:setPositionX(LoadingBar_vip:getPositionX() - vip_lv_di:getContentSize().width)
			AtlasLabel_vip_1:setPositionX(vip_lv_di:getPositionX() + vip_lv_di:getContentSize().width / 2)
		end
	elseif __lua_project_id == __lua_project_gragon_tiger_gate 
        or __lua_project_id == __lua_project_red_alert 
        or __lua_project_id == __lua_project_red_alert_time 
        or __lua_project_id == __lua_project_pacific_rim
        then
        if Text_vip_tips ~= nil then
            Text_vip_tips:removeAllChildren(true)
            local vip_desc = _string_piece_info[228].."1"
            if tonumber(GradeVip) > 0 then
                vip_desc = string.format(red_alert_time_str[97], math.min(tonumber(GradeVip) + 1, self.VipMaxGrade))
            end
            local _richText = ccui.RichText:create()
            _richText:ignoreContentAdaptWithSize(false)       
            local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, red_alert_time_str[96], "fonts/simhei.ttf",20)
            _richText:pushBackElement(re1)  
            local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[5][1],color_Type[5][2],color_Type[5][3]),255, vip_desc, "fonts/simhei.ttf",20)
            _richText:pushBackElement(re2)
            local re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, red_alert_time_str[98], "fonts/simhei.ttf",20)
            _richText:pushBackElement(re3)
            _richText:setPosition(cc.p(Text_vip_tips:getContentSize().width/2,Text_vip_tips:getContentSize().height/2))
            _richText:setContentSize(cc.size(Text_vip_tips:getContentSize().width,20))
            Text_vip_tips:addChild(_richText)
        end
		if tonumber(GradeVip) == self.VipMaxGrade then
			local Text_2_1 = ccui.Helper:seekWidgetByName(root, "Text_2_1")
			local Panel_2 = ccui.Helper:seekWidgetByName(root, "Panel_2")
			local image1 = Panel_2:getChildByName("baoshi_1_0")
			--print("image1...",image1:getName())
			local Text_chongzhi_3 = ccui.Helper:seekWidgetByName(root, "Text_chongzhi_3")
			local Text_2 = ccui.Helper:seekWidgetByName(root, "Text_2")
			local Text_vip_1 = ccui.Helper:seekWidgetByName(root, "Text_vip_1")
			Text_2_1:setVisible(false)
            if image1 ~= nil then
                image1:setVisible(false)
            end
            if Text_chongzhi_3 ~= nil then
                Text_chongzhi_3:setVisible(false)
            end
			Text_2:setVisible(false)
			Text_vip_1:setVisible(false)
			
			loadingBar:setPercent(100)
			loadingBarText:setString(nowEnergy.."/"..self._UpGrade[self.VipMaxGrade])
		end
	end
    if __lua_project_id == __lua_project_pacific_rim then
        local Text_vip_1 = ccui.Helper:seekWidgetByName(root, "Text_vip_1")
        local Text_2_1 = ccui.Helper:seekWidgetByName(root, "Text_2_1")
        if tonumber(GradeVip) == self.VipMaxGrade then
            Text_vip_1:setVisible(false)
            Text_2_1:setVisible(false)
        else
            Text_vip_1:setString(string.format(tipString_info_project_pacific_rim[4], GradeVip + 1))
            Text_2_1:setString(""..need.." "..tipString_info_project_pacific_rim[5])
        end
    end
end

function RechargeDialog:loading_month()
	if RechargeDialog.cacheListView == nil then
		return 
	end
	
	if RechargeDialog.drawMonth[RechargeDialog.monthIndex] ~= nil then
		local rechargeList = RechargeListCell:createCell()
		rechargeList:init(1,RechargeDialog.drawMonth[RechargeDialog.monthIndex],self.nextSceneID,self._choose_month_type)
		RechargeDialog.cacheListView:addChild(rechargeList)
		RechargeDialog.cacheListView:requestRefreshView()
	end	
	RechargeDialog.monthIndex = RechargeDialog.monthIndex + 1
end

function RechargeDialog:loading_recharge()
	if RechargeDialog.cacheListView == nil then
		return 
	end
	local rechargeType = zstring.split(_ED.user_sufficient_type ,",")
    local isload = true
    if RechargeDialog.drawTypes[RechargeDialog.rechargeIndex] ~= nil then
        local top_up_goods_id = tonumber(RechargeDialog.drawTypes[RechargeDialog.rechargeIndex][1])
        if __lua_project_id == __lua_project_red_alert_time 
            or __lua_project_id == __lua_project_pacific_rim
            then
            if tonumber(RechargeDialog.drawTypes[RechargeDialog.rechargeIndex][17]) == 4 
                and (tonumber(rechargeType[top_up_goods_id]) == 1 or zstring.tonumber(_ED.server_review) == 1) then
                isload = false
            end
        end
        if isload == true then
            local rechargeList = RechargeListCell:createCell()
            rechargeList:init(2,RechargeDialog.drawTypes[RechargeDialog.rechargeIndex],self.nextSceneID,self._choose_month_type)
            RechargeDialog.cacheListView:addChild(rechargeList)
            RechargeDialog.cacheListView:requestRefreshView()
        end
	end	
	RechargeDialog.rechargeIndex = RechargeDialog.rechargeIndex + 1
end

function RechargeDialog:onEnterTransitionFinish()
	local csbRechargeDialog = csb.createNode("shop/shop_chongzhi.csb")
	-- if action:getDuration() > 0 then
		-- action:gotoFrameAndPlay(0, action:getDuration(), false)
		-- csbRechargeDialog:runAction(action)
	-- end
	if __lua_project_id == __lua_project_gragon_tiger_gate 
        or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_red_alert_time 
        or __lua_project_id == __lua_project_pacific_rim
		then
		self.VipMaxGrade = tonumber(_vip_max_grade[1])
	end

	local root = csbRechargeDialog:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbRechargeDialog)
	
	if __lua_project_id == __lua_project_gragon_tiger_gate 
        or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_red_alert_time 
        or __lua_project_id == __lua_project_pacific_rim
		then
	else
		local action = csb.createTimeline("shop/shop_chongzhi.csb")
		csbRechargeDialog:runAction(action)
		action:play("Button_2_ing", true)
	end
	
	self:onUpdateDraw()
	local myListView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	local _drawMonth = dms.searchs(dms["top_up_goods"], top_up_goods.goods_type, 1)
	local _drawTypes = dms.searchs(dms["top_up_goods"], top_up_goods.goods_type, 0)
    if __lua_project_id == __lua_project_red_alert_time 
        or __lua_project_id == __lua_project_pacific_rim 
        then
        local function sortTable( a, b )
            return tonumber(a[19]) < tonumber(b[19])
        end
        table.sort(_drawTypes,sortTable)
    end
    -- NARUTO (precios 2026-09, como Fury): el escalon 13 (13000) va en la
    -- ULTIMA linea de `top_up_goods.txt` (la tabla se indexa por numero de
    -- linea) y sin esto saldria detras del de 0,99. Se ordena por precio,
    -- de mayor a menor, que es el orden que ya tenian los siete de siempre.
    if __lua_project_id == __lua_project_l_naruto then
        table.sort(_drawTypes, function(a, b)
            local pa, pb = tonumber(a[4]) or 0, tonumber(b[4]) or 0
            if pa ~= pb then
                return pa > pb
            end
            return (tonumber(a[1]) or 0) < (tonumber(b[1]) or 0)
        end)
    end
	local rechargeCount = table.getn(_drawTypes)
	local monthCount = 0
	if _drawMonth ~= nil then
		monthCount = table.getn(_drawMonth)
	end
	if #myListView:getItems() > 0 then
		myListView:removeAllItems()
	end
    --红警充值不载入月卡
    -- Y FURY TAMPOCO: por decision de Victor la recarga vende solo los
    -- siete escalones de gemas (0.99 a 99.99). El portal de pago ya
    -- filtra por `goods_type == 0`, asi que si aqui siguiera saliendo el
    -- pase mensual el jugador tocaria un boton que lleva a una pagina
    -- que no lo vende. Se apaga por el mismo camino que ya usaban las
    -- otras dos variantes, sin tocar `top_up_goods.txt` -esa tabla se
    -- indexa por NUMERO DE LINEA y tiene que seguir siendo byte a byte
    -- la del servidor-.
    if __lua_project_id == __lua_project_red_alert_time 
        or __lua_project_id == __lua_project_pacific_rim
        or __lua_project_id == __lua_project_l_dragonball
        or __lua_project_id == __lua_project_l_naruto
        then
        monthCount = 0
    end
	cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	RechargeDialog.monthIndex = 1
	RechargeDialog.rechargeIndex = 1
	RechargeDialog.cacheListView = myListView
	RechargeDialog.drawMonth = _drawMonth
	RechargeDialog.drawTypes = _drawTypes
	local MylistViewCell = nil
	local preMultipleCell = nil
	local ScrollView_1 = nil
	if  __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		ScrollView_1 = ccui.Helper:seekWidgetByName(root, "ScrollView_1")
		-- if fwin:find("UserInformationShopClass") ~= nil then
		-- 	fwin:close(fwin:find("UserInformationShopClass"))
		-- end
		app.load("client.player.UserInformationShop") 					--顶部用户信息
		local userinfo = UserInformationShop:new()
        userinfo._rootWindows = self
		fwin:open(userinfo,fwin._windows)
	elseif __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_red_alert 
		then
		if monthCount ~= 0 then
			for i = 1 , monthCount do
				app.load("client.cells.utils.multiple_list_view_cell")

				local rechargeList = RechargeListCell:createCell()
				

				rechargeList:init(1,_drawMonth[i],self.nextSceneID,self._choose_month_type == i)
				if MylistViewCell == nil then
					MylistViewCell = MultipleListViewCell:createCell()
					MylistViewCell:init(RechargeDialog.cacheListView,rechargeList:getContentSize())
					RechargeDialog.cacheListView:addChild(MylistViewCell)
					MylistViewCell.prev = preMultipleCell
					if preMultipleCell ~= nil then
						preMultipleCell.next = MylistViewCell
					end
				end
				MylistViewCell:addNode(rechargeList)
				if MylistViewCell.child2 ~= nil then
					preMultipleCell = MylistViewCell
					MylistViewCell = nil
				end	
				RechargeDialog.cacheListView:requestRefreshView()	
			end
		end		
	else
		if monthCount ~= 0 then
			for i = 1 , monthCount do
				-- local rechargeList = RechargeListCell:createCell()
				-- rechargeList:init(1,_drawMonth[i],self.nextSceneID)
				-- myListView:addChild(rechargeList)
				cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_month, self)	
			end
		end
	end
	local cell_size = nil
	local heigt_n = nil
    -- if  (__lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto) and zstring.tonumber(_ED.server_review) == 1 then
    --     heigt_n = math.ceil(rechargeCount / 4)
    -- else
        heigt_n = math.ceil(rechargeCount / 3)
    -- end
	if rechargeCount ~= 0 then
		if __lua_project_id == __lua_project_red_alert_time 
            or __lua_project_id == __lua_project_pacific_rim 
            then
			local sufficientStr = zstring.split(_ED.user_sufficient_type ,",")
			local isFirstRecharge = false
			for k,v in pairs(sufficientStr) do
				local index = 1
				if  zstring.tonumber(v) >= 1 then 
					--已经首充过了
					isFirstRecharge = true
					break
				end
			end
			if isFirstRecharge == false 
                and _ED.activity_info["2"] ~= nil
                then
				local cell = state_machine.excute("shop_chongzhi_frist_cell",0, 0)
				cell:setTag(998)
				RechargeDialog.cacheListView:addChild(cell)
			end
		end
		for i = 1 , rechargeCount do
			-- local rechargeList = RechargeListCell:createCell()
			-- rechargeList:init(2,_drawTypes[i],self.nextSceneID)
			-- myListView:addChild(rechargeList)
			if  __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then 
				local rechargeData = RechargeDialog.drawTypes[i]
				local rechargeList = RechargeListCell:createCell()
				rechargeList:init(2,rechargeData,self.nextSceneID)
				if cell_size == nil then
					cell_size = rechargeList:getContentSize()         
				end
                if  __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) then
                    rechargeList:setPosition(cc.p(((i - 1)) * cell_size.width , 0))
                else
    				rechargeList:setPosition(cc.p(((i - 1) % 3) * cell_size.width , (heigt_n - math.ceil( i / 3)) * cell_size.height))
                end
                -- if  (__lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto) and zstring.tonumber(_ED.server_review) == 1 then
                --     rechargeList:setPosition(cc.p(((i - 1) % 4) * cell_size.width , (heigt_n - math.ceil( i / 4)) * cell_size.height))
                -- end
				ScrollView_1:addChild(rechargeList)
			elseif __lua_project_id == __lua_project_gragon_tiger_gate
				or __lua_project_id == __lua_project_red_alert 
				then
				app.load("client.cells.utils.multiple_list_view_cell")
				local rechargeData = RechargeDialog.drawTypes[rechargeCount-i +1]
				local isShow = false
				if app.configJson.OperatorName == "gamedreamer" then
					if zstring.tonumber(rechargeData[18]) == nil or zstring.tonumber(rechargeData[18]) == 1 then
						isShow = true
					end
				else
					isShow = true
				end
				if isShow == true then
    				local function onUpdateRechargeCount()
    					local rechargeList = RechargeListCell:createCell()
    					rechargeList:init(2,rechargeData,self.nextSceneID,self._choose_month_type)
    					if MylistViewCell == nil then
    						MylistViewCell = MultipleListViewCell:createCell()
    						MylistViewCell:init(RechargeDialog.cacheListView,rechargeList:getContentSize())
    						RechargeDialog.cacheListView:addChild(MylistViewCell)
    						MylistViewCell.prev = preMultipleCell
    						if preMultipleCell ~= nil then
    							preMultipleCell.next = MylistViewCell
    						end
    					end
    					MylistViewCell:addNode(rechargeList)
    					if MylistViewCell.child2 ~= nil then
    						preMultipleCell = MylistViewCell
    						MylistViewCell = nil
    					end	
    					RechargeDialog.cacheListView:requestRefreshView()
    				end	
                    if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
                        local run_action = cc.Sequence:create(cc.DelayTime:create(i/10),cc.CallFunc:create(onUpdateRechargeCount))
                        self:runAction(run_action)
                    else
                        onUpdateRechargeCount()
                    end
                end
			else
				cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_recharge, self)	
			end
		end
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then 
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) then
                -- FURY (precios 2026-09): el interior de `ScrollView_1` mide
                -- 1610 de ancho en `shop_chongzhi.csb`, justo SIETE celdas de
                -- 230. La octava (13000 diamantes) quedaba fuera y no se podia
                -- desplazar hasta ella: se ensancha, nunca se encoge.
                if __lua_project_id == __lua_project_l_dragonball and cell_size ~= nil then
                    local inner = ScrollView_1:getInnerContainerSize()
                    local needed = cell_size.width * rechargeCount
                    if needed > inner.width then
                        ScrollView_1:setInnerContainerSize(cc.size(needed, inner.height))
                    end
                end
            else
    			ScrollView_1:getInnerContainer():setContentSize(cc.size(ScrollView_1:getContentSize().width , cell_size.height * heigt_n))
    			ScrollView_1:getInnerContainer():setPositionY(ScrollView_1:getContentSize().height - cell_size.height * heigt_n)
            end
		end
	end
	
	if __lua_project_id == __lua_project_red_alert_time 
        or __lua_project_id == __lua_project_pacific_rim 
        then
		self.__check_covers = true
        self.__cwindow = self
    	Animations_PlayOpenMainUI({self}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN, 0)
    	
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), 	nil, 
		{
			terminal_name = "recharge_dialog_close", 	
			next_terminal_name = "recharge_dialog_close", 	
			current_button_name = "Button_1",		
			but_image = "close",	
			terminal_state = 0, 
			touch_black = true,
		}, 
		nil, 3)
	else
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), 	nil, 
		{
			terminal_name = "recharge_dialog_close", 	
			next_terminal_name = "recharge_dialog_close", 	
			current_button_name = "Button_1",		
			but_image = "close",	
			terminal_state = 0, 
			isPressedActionEnabled = true
		}, 
		nil, 3)
	end
		
	
	if __lua_project_id == __lua_project_red_alert then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), 	nil, 
		{
			terminal_name = "show_vip_privilege_red_alert", 	
			current_button_name = "Button_2",		
			but_image = "vip",	
			terminal_state = 0, 
			-- isPressedActionEnabled = true
		}, 
		nil, 0)
		state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_home_button_activity_VIP",
	    _widget = ccui.Helper:seekWidgetByName(root, "Button_2"),
	    _invoke = nil,
	    _interval = 0.1,})

		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_charge"), 	nil, 
		{
			terminal_name = "show_vip_buy_red_alert", 	
			current_button_name = "Button_charge",		
			but_image = "vip",	
			terminal_state = 0, 
			-- isPressedActionEnabled = true
		}, 
		nil, 0)
		app.load("client.red_alert.recharge.ShopHelp")
		-- 帮助
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_help"), nil, 
	    {
	        terminal_name = "shop_help_window_open", 
	        terminal_state = 0, 
	        touch_scale = true,
	        touch_scale_xy = 0.95, 
	    }, nil, 0)
	    if __lua_project_id == __lua_project_red_alert then
			ccui.Helper:seekWidgetByName(root, "Button_charge"):setHighlighted(true)
		end
		ccui.Helper:seekWidgetByName(root, "Button_2"):setHighlighted(false)
	elseif __lua_project_id == __lua_project_red_alert_time 
        or __lua_project_id == __lua_project_pacific_rim 
        then
		local Button_recharge = ccui.Helper:seekWidgetByName(root, "Button_recharge")
        if Button_recharge ~= nil then
            fwin:addTouchEventListener(Button_recharge,   nil, 
            {
                terminal_name = "show_vip_privilege_red_alert_time",
                terminal_state = 0,
                touch_scale = true,
                touch_scale_xy = 0.95,  
            }, 
            nil, 0)
    		if self._showVip == false then
    			Button_recharge:setTitleText(red_alert_time_str[31])
    		else
    			Button_recharge:setTitleText(red_alert_time_str[30])
    		end
        end

        local Button_chongzhi_1 = ccui.Helper:seekWidgetByName(root, "Button_chongzhi_1")
        local Button_chongzhi_2 = ccui.Helper:seekWidgetByName(root, "Button_chongzhi_2")
        if Button_chongzhi_1 ~= nil then
            fwin:addTouchEventListener(Button_chongzhi_1, nil, 
            {
                terminal_name = "recharge_dialog_window_change_show_vip",
                terminal_state = 0,
                touch_scale = true,
                touch_scale_xy = 0.95,  
                is_show = false,
            }, 
            nil, 0)
            if self._showVip == false then
                Button_chongzhi_1:setHighlighted(true)
            else
                Button_chongzhi_1:setHighlighted(false)
            end
        end

        if Button_chongzhi_2 ~= nil then
            fwin:addTouchEventListener(Button_chongzhi_2, nil, 
            {
                terminal_name = "recharge_dialog_window_change_show_vip",
                terminal_state = 0,
                touch_scale = true,
                touch_scale_xy = 0.95,  
                is_show = true,
            }, 
            nil, 0)
            state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_privilege_packs_internal",
                _widget = Button_chongzhi_2,
                _m_type = 0,
                _invoke = nil,
                _interval = 0.2,})

            if self._showVip == false then
                Button_chongzhi_2:setHighlighted(false)
            else
                Button_chongzhi_2:setHighlighted(true)
            end
        end
	else
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), 	nil, 
		{
			terminal_name = "show_vip_privilege", 	
			next_terminal_name = "show_vip_privilege", 	
			current_button_name = "Button_2",		
			but_image = "vip",	
			terminal_state = 0, 
			isPressedActionEnabled = true
		}, 
		nil, 0)
	end
	
	local twpayButton = ccui.Helper:seekWidgetByName(root, "Button_chongzhi_4")
	if twpayButton~=nil then
		fwin:addTouchEventListener(twpayButton, nil, 
			{
				terminal_name = "tw_pay_button", 
				terminal_state = 0, 
				isPressedActionEnabled = true
			},
			nil,0)
	end
    local Button_wy = ccui.Helper:seekWidgetByName(root, "Button_wy")
    if Button_wy ~= nil then
        fwin:addTouchEventListener(Button_wy, nil, 
        {
            terminal_name = "recharge_dialog_url_jump", 
            terminal_state = 0, 
            isPressedActionEnabled = true
        },
        nil,0)
    end
	
	if (__lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto) 
		and app.configJson.OperatorName == "gamedreamer" 
		then
		state_machine.excute("tw_pay_button", 0, "tw_pay_button.")
		fwin:close(self)
		fwin:close(fwin:find("RechargeDialogClass"))
	end

    local Button_wy = ccui.Helper:seekWidgetByName(root, "Button_wy")
    if Button_wy and zstring.tonumber(_ED.server_review) == 1 then  -- 1评审, 其他非
        Button_wy:setVisible(false)
    end

    -- 充值修复小贴士按钮
    local Button_repair = ccui.Helper:seekWidgetByName(root, "Button_repair")
	if Button_repair then
		if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPHONE or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPAD then
			Button_repair:setVisible(false)
		else
			local minPackageVersion = tonumber(dms.string(dms["user_config"], 20, user_config.param))
			local nowPackageVersion = tonumber(app.configJson.version)
			local isShow = nowPackageVersion >= minPackageVersion
			Button_repair:setVisible(isShow)

			if isShow then
				fwin:addTouchEventListener(Button_repair, nil, 
				{
					terminal_name = "recharge_dialog_open_rechaege_repair_tips", 
					terminal_state = 0, 
					isPressedActionEnabled = true
				},
				nil, 0)
			end
		end
    end
end

-- 充值列表移动到最小档位
function RechargeDialog:moveScrollMin()
	local ScrollView_1 = ccui.Helper:seekWidgetByName(self.roots[1], "ScrollView_1")
	fwin:addService({
		callback = function ( params )
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) then
				ScrollView_1:scrollToPercentHorizontal(100, 0.1, false)
			else
				ScrollView_1:getInnerContainer():setPositionY(0)
			end
		end,
		delay = 0.01,
		params = self
	})
end

function RechargeDialog:init(value,types)
	self.nextSceneID = value
	self.nextTypes = types
end

function RechargeDialog:setMonthType( ntype )
	if ntype ~= nil then
		self._choose_month_type = ntype
	end
	return self
end

function RechargeDialog:onExit()
	RechargeDialog.monthIndex = 1
	RechargeDialog.rechargeIndex = 1
	RechargeDialog.cacheListView = nil
	RechargeDialog.drawMonth = nil
	RechargeDialog.drawTypes = nil

	state_machine.remove("recharge_dialog_open_move_recharge_min")
    state_machine.remove("recharge_dialog_open_rechaege_repair_tips")
	state_machine.remove("recharge_dialog_close")
	state_machine.remove("show_vip_privilege")
	state_machine.remove("recharge_update_all_list_cell")
	state_machine.remove("show_vip_privilege_red_alert")
	state_machine.remove("show_vip_privilege_red_alert_time")
	state_machine.remove("recharge_dialog_window_show")
	state_machine.remove("recharge_dialog_window_hide")
	state_machine.remove("show_vip_buy_red_alert")
    state_machine.remove("recharge_dialog_remove_just_recharge_once")
    state_machine.remove("refresh_privilege_button")
    state_machine.remove("recharge_dialog_window_change_show_vip")
	state_machine.excute("on_card_update", 0, nil)
	cc.Director:getInstance():getTextureCache():unbindAllImageAsync()
end
