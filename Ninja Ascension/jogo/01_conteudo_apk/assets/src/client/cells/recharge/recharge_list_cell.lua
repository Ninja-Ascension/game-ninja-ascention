-- ----------------------------------------------------------------------------------------------------
-- 说明：充值list
-- 创建时间2014-03-02 22:07
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

RechargeListCell = class("RechargeListCellClass", Window)

function RechargeListCell:ctor()
    self.super:ctor()
	self.roots = {}
	if __lua_project_id == __lua_project_adventure then
		app.load("client.adventure.cells.prop.adventure_new_prop_icon_cell")
	end
	app.load("client.cells.utils.resources_icon_cell")
	self.example = nil
	self.index = 0
	self.vip_grade = _ED.vip_grade
	_ED.last_vip_level = _ED.vip_grade
	self._bSupplyFirestRecharge = true
	self._choose_month_state = nil
	if __lua_project_id == __lua_project_red_alert_time 
		or __lua_project_id == __lua_project_pacific_rim 
		then
		self._choose_month_state = nil
	else
		self._choose_month_state = false
	end
	
	
	local appstore_recharge_data = dms.int(dms["pirates_config"], 286, pirates_config.param)
	
	if app.configJson.PayOperatorName == "app" and appstore_recharge_data == 1 then
		self._bSupplyFirestRecharge = false
	end
	
    local function init_RechargeListCell_terminal()
		--充值
		local recharge_list_button_terminal = {
            _name = "recharge_list_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	-- if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
            	-- 	TipDlg.drawTextDailog(tipStringInfo_diamond_recharge_tips[1])
            	-- else 
				state_machine.lock("recharge_list_button")
				
				local function rechargeCallback()
					if params == nil or params._datas == nil then
						state_machine.unlock("recharge_list_button")
						return
					end

					local rechargeCell = params._datas._cell
					local rechargeIndex = params._datas.listIndex
					local _isMonthCard = params._datas.isMonthCard
					local _gradeMonthCard = params._datas.gradeMonthCard
					local _nameMonthCard = params._datas.nameMonthCard
					local _extra = params._datas.extra
					local _additional = params._datas.additional
					if __lua_project_id == __lua_project_red_alert_time 
						or __lua_project_id == __lua_project_pacific_rim 
						then
						local cell = params._datas._cell
						_additional = cell.example[6]
						_gradeMonthCard = cell.example[4]
						if dms.int(dms["top_up_goods"], tonumber(rechargeIndex), top_up_goods.picture_index) == 4 then
							local crossPiece = dms.searchs(dms["top_up_goods"], top_up_goods.money, _gradeMonthCard)
							m_reqcharge_info.rechargeIndex = crossPiece[1][1]
						else
							m_reqcharge_info.rechargeIndex = rechargeIndex
						end
					elseif __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
						or __lua_project_id == __lua_project_l_naruto
						then
						local cell = params._datas._cell
						_additional = cell.example[6]
						m_reqcharge_info.rechargeIndex = rechargeIndex
					else
						m_reqcharge_info.rechargeIndex = rechargeIndex
					end
					m_reqcharge_info.isMonthCard = _isMonthCard
					m_reqcharge_info.gradeMonthCard = _gradeMonthCard
					m_reqcharge_info.extra = _extra
					m_reqcharge_info.additional = _additional
					m_reqcharge_info.nameMonthCard = _nameMonthCard
					local sufficientStr = zstring.split(_ED.user_sufficient_type ,",")
					local value = sufficientStr[zstring.tonumber(rechargeIndex)]
					local function responseGetServerListCallback(response)
						fwin:close(fwin:find("ConnectingViewClass"))
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if __lua_project_id == __lua_project_red_alert_time 
								or __lua_project_id == __lua_project_pacific_rim 
								then
								_ED.recharge_result.recharge_id = _ED.recharge_result.recharge_id.."_"..rechargeIndex
							end

							if cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_WINDOWS 
							and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_LINUX 
							and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_MAC then
								if OperatorNameConfig[app.configJson.OperatorName] == "t4" then
									state_machine.excute("platform_request_for_payment", 0, "0")
								else
									state_machine.excute("platform_request_for_payment", 0, response.node)
								end
								state_machine.unlock("recharge_list_button")
								return
							end
							state_machine.unlock("recharge_list_button")
							state_machine.excute("check_the_order_to_refresh_the_list", 0, response.node)
						end
					end

					-- dsc web充值/pmc web充值
					if RechargeTypeConfig[app.configJson.PackageName] == 1 and (__lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_pokemon) then
						local function changeRechargeCallback(pay_type)
							fwin:open(ConnectingView:new(), fwin._windows)
							cc.UserDefault:getInstance():setStringForKey("paySpecialpid", "-1")
							cc.UserDefault:getInstance():flush()

							protocol_command.request_top_up_order_number.param_list = ""..rechargeIndex.."\r\n"..pay_type
							-- 设置充值类型
							_ED.curRechargeType = pay_type
							NetworkManager:register(protocol_command.request_top_up_order_number.code, nil, nil, nil, params, responseGetServerListCallback, false, nil)
						end
						app.load("client.shop.recharge.RechargeSelectWindow")
						state_machine.excute("recharge_select_window_open", 0, changeRechargeCallback)
						return
					end

					-- dsc 原生充值和web充值共存
					local isAndroid = cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID
					if RechargeTypeConfig[app.configJson.PackageName] == 2 and (__lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_pokemon) and isAndroid == true then
						local function changeRechargeCallback(pay_type)
							fwin:open(ConnectingView:new(), fwin._windows)
							cc.UserDefault:getInstance():setStringForKey("paySpecialpid", "-1")
							cc.UserDefault:getInstance():flush()

							protocol_command.request_top_up_order_number.param_list = ""..rechargeIndex.."\r\n"..pay_type
							-- 设置充值类型
							_ED.curRechargeType = pay_type
							NetworkManager:register(protocol_command.request_top_up_order_number.code, nil, nil, nil, params, responseGetServerListCallback, false, nil)
						end
						app.load("client.shop.recharge.RechargeSelectWindow2")
						state_machine.excute("recharge_select_window2_open", 0, changeRechargeCallback)
						return
					end


					-- 官方安卓充值校验
					if RechargeTypeConfig[app.configJson.PackageName] == 0 and cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
						if app.configJson.OperatorName == "huawei" or (app.configJson.OperatorName == "t4" and SdkNameConfig and SdkNameConfig[app.configJson.OperatorName] == "t4-quick") then
							--
						else
							local platform_purchase_info = readKey("platform_purchase_info")
							if platform_purchase_info and platform_purchase_info ~= "" then
								CheckOrderToRechargeServer()
								return true
							end
						end
					end
					
					fwin:open(ConnectingView:new(), fwin._windows)
					cc.UserDefault:getInstance():setStringForKey("paySpecialpid", "-1")
					cc.UserDefault:getInstance():flush()
					protocol_command.request_top_up_order_number.param_list = ""..rechargeIndex.."\r\n"..m_sPayMould

					-- 设置充值类型
					_ED.curRechargeType = m_sPayMould

					NetworkManager:register(protocol_command.request_top_up_order_number.code, nil, nil, nil, params, responseGetServerListCallback, false, nil)
				end

				-- 获取充值状态回调
		        local function responseCallback(response)
		            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
		            	UpdateSevenRechargeActivity(rechargeCallback)
		            else
		            	state_machine.unlock("recharge_list_button")
		            end
		        end

				local packageName = app.configJson.PackageName or " "
		        protocol_command.get_web_recharge_state.param_list = "" .. packageName
		        NetworkManager:register(protocol_command.get_web_recharge_state.code, app.configJson.url, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--领取月卡
		local get_month_card_list_button_terminal = {
            _name = "get_month_card_list_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local rechargeCell = params._datas._cell
				local rechargeIndex = params._datas.listIndex
				local _jewel = params._datas.jewel
				local goodsInfo = rechargeCell.goodsInfo
				local param = params._datas
				local function responseGetServerListCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						response.node._cell:refreshDraw(response.node.listIndex)
						local infoText = ""
						if __lua_project_id == __lua_project_yugioh then 
							if zstring.tonumber(_game_platform_version_type) == 2 or zstring.tonumber(_game_platform_version_type) == 3 then 
								infoText = string.format(_month_card_tip[4], _jewel)
							else
								infoText = string.format(_month_card_tip[4], _jewel, goodsInfo)
							end
						else
							infoText = string.format(_month_card_tip[4], _jewel, goodsInfo)
						end
						if __lua_project_id == __lua_project_red_alert then
							state_machine.excute("reward_obtain_window_open",0,{1001})
						else
							TipDlg.drawTextDailog(infoText)
						end
						if __lua_project_id == __lua_project_adventure then 
						else
							state_machine.excute("activity_window_refresh_button", 0, "activity_window_refresh_button.")--刷新活动
						end	
					end
				end
				protocol_command.draw_month_card_reward.param_list = ""..rechargeIndex
				NetworkManager:register(protocol_command.draw_month_card_reward.code, nil, nil, nil, param, responseGetServerListCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--请求效验订单刷新列表
		local check_the_order_to_refresh_the_list_terminal = {
            _name = "check_the_order_to_refresh_the_list",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local function responseGetServerListCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil and response.node.refreshDraw ~= nil then
							response.node:refreshDraw(m_reqcharge_info.rechargeIndex)
							if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon
								or __lua_project_id == __lua_project_rouge
								then 
								if zstring.tonumber(_game_platform_version_type) == 2 then 
									--新马泰版本
									state_machine.excute("recharge_update_all_list_cell", 0,0)--刷新首充
								end
							end
							if __lua_project_id == __lua_project_yugioh then 
								if zstring.tonumber(_game_platform_version_type) == 3 then 
									--新马泰版本
									state_machine.excute("recharge_update_all_list_cell", 0,0)--刷新首充
								end
							end
						end
						if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
							state_machine.excute("activity_first_recharge_button", 0, "activity_first_recharge_button.")--刷新首充
						end
					else
						if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
							state_machine.excute("recharge_update_all_list_cell", 0,0)--刷新首充
						end
						state_machine.excute("activity_window_refresh_button", 0, "activity_window_refresh_button.")--刷新活动
					end
				end
				if app.configJson.UserAccountPlatformName ~= "jar-world" then
					if m_play_pay_type~= nil and m_play_pay_type~="" then
						protocol_command.vali_top_up_order_number.param_list =  "".._ED.user_info.user_id.."\r\n".._ED.recharge_result.recharge_id..m_play_pay_type
					else
						protocol_command.vali_top_up_order_number.param_list =  "".._ED.user_info.user_id.."\r\n".._ED.recharge_result.recharge_id
					end
				else
					if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_WINDOWS 
						or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_LINUX 
						or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_MAC then
						-- develop test plotform recharge
						protocol_command.vali_top_up_order_number.param_list =  "".._ED.user_info.user_id.."\r\n".._ED.recharge_result.recharge_id.."\r\n".."win32"
					else
						protocol_command.vali_top_up_order_number.param_list =  "".._ED.user_info.user_id.."\r\n".._ED.recharge_result.recharge_id.."\r\n"..getPlatform()
					end
				end

				local rechargeCell = nil
				if nil ~= params and nil ~= params._datas then
					rechargeCell = params._datas._cell
				end
				if rechargeCell~=nil then
					NetworkManager:register(protocol_command.vali_top_up_order_number.code, nil, nil, nil, rechargeCell, responseGetServerListCallback, false, nil)
				else
					NetworkManager:register(protocol_command.vali_top_up_order_number.code, nil, nil, nil, nil, responseGetServerListCallback, false, nil)
				end
				NetworkManager:register(protocol_command.keep_alive.code, nil, nil, nil, nil, nil, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--平台请求效验订单刷新列表
		local platform_check_the_order_to_refresh_the_list_terminal = {
            _name = "platform_check_the_order_to_refresh_the_list",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local rechargeCell = nil
        		if terminal == nil or  terminal.platformParams == nil or terminal.platformParams._datas  == nil then
        		else
        			rechargeCell = terminal.platformParams._datas._cell		
        		end
				local function responseGetServerListCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						state_machine.excute("refresh_single_recharge_interface_list", 0, {_rechargeCell = response.node})
					end
				end
				if cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_WINDOWS 
				and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_LINUX 
				and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_MAC then
					if app.configJson.OperatorName == "jar-world" or (app.configJson.OperatorName == "play800" and app.configJson.PayOperatorName == "app") 
					or (app.configJson.OperatorName == "play800-2" and app.configJson.PayOperatorName == "app") 
					or (app.configJson.OperatorName == "88box" and app.configJson.PayOperatorName == "app") 
					or OperatorNameConfig[app.configJson.OperatorName] == "t4" or app.configJson.OperatorName == "move" 
					or app.configJson.OperatorName == "cayenne" 
					then
						state_machine.excute("platform_the_success_of_payment_app", 0, {_rechargeCell = rechargeCell})
					else
						if m_play_pay_type~= nil and m_play_pay_type~="" then
							protocol_command.vali_top_up_order_number.param_list =  "".._ED.user_info.user_id.."\r\n".._ED.recharge_result.recharge_id..m_play_pay_type
						else
							protocol_command.vali_top_up_order_number.param_list =  "".._ED.user_info.user_id.."\r\n".._ED.recharge_result.recharge_id
						end
						if rechargeCell~=nil then
							NetworkManager:register(protocol_command.vali_top_up_order_number.code, nil, nil, nil, rechargeCell, responseGetServerListCallback, false, nil)
						else
							NetworkManager:register(protocol_command.vali_top_up_order_number.code, nil, nil, nil, rechargeCell, responseGetServerListCallback, false, nil)
						end
						NetworkManager:register(protocol_command.keep_alive.code, nil, nil, nil, nil, nil, false, nil)
					end
				else
					protocol_command.vali_top_up_order_number.param_list =  "".._ED.user_info.user_id.."\r\n".._ED.recharge_result.recharge_id.."\r\n".."win32"
					if rechargeCell~=nil then
						NetworkManager:register(protocol_command.vali_top_up_order_number.code, nil, nil, nil, rechargeCell, responseGetServerListCallback, false, nil)
					else
						NetworkManager:register(protocol_command.vali_top_up_order_number.code, nil, nil, nil, rechargeCell, responseGetServerListCallback, false, nil)
					end
					NetworkManager:register(protocol_command.keep_alive.code, nil, nil, nil, nil, nil, false, nil)
				end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--刷新单个的充值界面列表
		local refresh_single_recharge_interface_list_terminal = {
            _name = "refresh_single_recharge_interface_list",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("recharge_update_all_list_cell",0,"")
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					local m_isVisible = false
					for i,v in pairs(_ED.month_card) do
						if tonumber(v.surplus_month_card_time) == 0 then
							m_isVisible = true
						end
					end
					if m_isVisible == false then
						state_machine.excute("home_update_first_recharge", 0,nil)
					end
				end
				state_machine.excute("activity_window_refresh_button", 0, "activity_window_refresh_button.")--刷新活动
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--刷新充值界面
		local refresh_recharge_interface_terminal = {
            _name = "refresh_recharge_interface",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if self.vip_grade ~= _ED.vip_grade then
					self.vip_grade = _ED.vip_grade
					state_machine.excute("shop_vip_prop_buy_list_update", 0, "")
					if __lua_project_id == __lua_project_red_alert_time 
						or __lua_project_id == __lua_project_pacific_rim 
						then
						checkEffectLevelUp()
					end
				end
				local activity = _ED.active_activity[39]
				if (activity ~= nil and tonumber(activity.activity_login_Max_day) ~= nil ) then
					activity.activity_Info[zstring.tonumber(activity.activity_login_Max_day)].activityInfo_is_reach = 1
				end
				local vipGradeString = ""
				if __lua_project_id == __lua_project_red_alert_time 
					or __lua_project_id == __lua_project_pacific_rim 
					then
					vipGradeString = string.format(_string_piece_info[429],zstring.tonumber(_ED.recharge_result_cheak.recharge_allGame))
				end
				if m_reqcharge_info.rechargeIndex == nil or m_reqcharge_info.rechargeIndex == "" then
					if app.configJson.OperatorName == "gamedreamer" then
						if tonumber(_ED.recharge_result_cheak.recharge_id) == -1 then
							local getGold = zstring.tonumber(_ED.recharge_result_cheak.recharge_allShuijing) - zstring.tonumber(_ED.user_info.user_gold)
							TipDlg.drawTextDailog(_string_piece_info[245]..getGold.._string_piece_info[222])
							_ED.recharge_rmb_number = _ED.recharge_result_cheak.recharge_RMB
							_ED.user_info.user_gold = zstring.tonumber(_ED.recharge_result_cheak.recharge_allShuijing)
							state_machine.excute("refresh_privilege_button", 0, "refresh_privilege_button.")
							return
						end
					end
					if dms.int(dms["top_up_goods"], tonumber(_ED.recharge_result_cheak.recharge_id), top_up_goods.goods_type) == 1 then
						if app.configJson.OperatorName == "gamedreamer" then
							local tipWindows = fwin:find("GameTipDialogClass")
							if tipWindows ~= nil  then 
								fwin:close(tipWindows)
							end
							local tipStr = string.format(pay_success_tip_info[1], dms.string(dms["top_up_goods"], tonumber(_ED.recharge_result_cheak.recharge_id), top_up_goods.goods_name))
							TipDlg.drawTextDailog(tipStr)
						else
							_ED.user_info.user_gold = zstring.tonumber(_ED.recharge_result_cheak.recharge_allShuijing)
							TipDlg.drawTextDailog(_string_piece_info[239]..dms.string(dms["top_up_goods"], tonumber(_ED.recharge_result_cheak.recharge_id), top_up_goods.money).._string_piece_info[240])
						end
						if _ED.recharge_result_cheak ~= nil and _ED.recharge_result_cheak.recharge_RMB ~= nil then
							_ED.recharge_rmb_number = _ED.recharge_result_cheak.recharge_RMB
						end
					else
						if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
							or __lua_project_id == __lua_project_rouge
							or __lua_project_id == __lua_project_yugioh)
							and ___is_open_firstCharge_double == true 
							then
							local getGold = zstring.tonumber(_ED.recharge_result_cheak.recharge_allShuijing) - zstring.tonumber(_ED.user_info.user_gold)
							TipDlg.drawTextDailog(_string_piece_info[245]..getGold.._string_piece_info[222])
							_ED.recharge_rmb_number = _ED.recharge_result_cheak.recharge_RMB
							_ED.user_info.user_gold = zstring.tonumber(_ED.recharge_result_cheak.recharge_allShuijing)
						elseif __lua_project_id == __lua_project_red_alert 
                            or __lua_project_id == __lua_project_red_alert_time 
                            or __lua_project_id == __lua_project_pacific_rim
                            then
                            local gift = zstring.tonumber(_ED.recharge_result_cheak.recharge_all_number) - zstring.tonumber(_ED.recharge_result_cheak.recharge_count)
                            if gift == 0 then
                                TipDlg.drawTextDailog(_string_piece_info[245].._ED.recharge_result_cheak.recharge_count.._string_piece_info[246]..vipGradeString)
                            else
                                TipDlg.drawTextDailog(_string_piece_info[245].._ED.recharge_result_cheak.recharge_count.._string_piece_info[243]..gift.._string_piece_info[244]..vipGradeString)
                            end
                        else
							if app.configJson.OperatorName == "gamedreamer" then
								local getGold = zstring.tonumber(_ED.recharge_result_cheak.recharge_allShuijing) - zstring.tonumber(_ED.user_info.user_gold)
								TipDlg.drawTextDailog(_string_piece_info[245]..getGold.._string_piece_info[222])
								_ED.recharge_rmb_number = _ED.recharge_result_cheak.recharge_RMB
								_ED.user_info.user_gold = zstring.tonumber(_ED.recharge_result_cheak.recharge_allShuijing)
							else
								--自由充值
								local getGold = zstring.tonumber(_ED.recharge_result_cheak.recharge_allShuijing) - zstring.tonumber(_ED.user_info.user_gold)
								TipDlg.drawTextDailog(_string_piece_info[245]..getGold.._string_piece_info[246])
								_ED.recharge_rmb_number = _ED.recharge_result_cheak.recharge_RMB
								_ED.user_info.user_gold = zstring.tonumber(_ED.recharge_result_cheak.recharge_allShuijing)
							end
						end
						state_machine.excute("refresh_privilege_button", 0, "refresh_privilege_button.")
					end
				else
					if zstring.tonumber(m_reqcharge_info.isMonthCard) == 1 then
						if app.configJson.OperatorName == "gamedreamer" then
							local tipStr = string.format(pay_success_tip_info[1], dms.string(dms["top_up_goods"], tonumber(_ED.recharge_result_cheak.recharge_id), top_up_goods.goods_name))
							TipDlg.drawTextDailog(tipStr)
						else
							_ED.user_info.user_gold = zstring.tonumber(_ED.recharge_result_cheak.recharge_allShuijing)
							if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
								or __lua_project_id == __lua_project_rouge
								then 
								if zstring.tonumber(_game_platform_version_type) == 2 then 
									local tipString = string.format(_month_card_tip[3], dms.string(dms["top_up_goods"], m_reqcharge_info.rechargeIndex, top_up_goods.goods_name))
									TipDlg.drawTextDailog( tipString)	
								else
									TipDlg.drawTextDailog( string.format(_month_card_tip[3], m_reqcharge_info.gradeMonthCard))
								end
							elseif __lua_project_id == __lua_project_yugioh then 
								if zstring.tonumber(_game_platform_version_type) == 3 then 
									--新马直接显示名称
									TipDlg.drawTextDailog( string.format(_month_card_tip[3], m_reqcharge_info.nameMonthCard))
								else
									TipDlg.drawTextDailog( string.format(_month_card_tip[3], m_reqcharge_info.gradeMonthCard))
								end
							elseif __lua_project_id == __lua_project_red_alert 
								or __lua_project_id == __lua_project_red_alert_time 
								or __lua_project_id == __lua_project_pacific_rim
								then 
								if tonumber(m_reqcharge_info.gradeMonthCard) == 25 then
									TipDlg.drawTextDailog(_month_card_tip[3])
								else
									TipDlg.drawTextDailog(_month_card_tip[5])
								end
							else
								TipDlg.drawTextDailog( string.format(_month_card_tip[3], m_reqcharge_info.gradeMonthCard))
							end
						end
						
						if _ED.recharge_result_cheak ~= nil and _ED.recharge_result_cheak.recharge_RMB ~= nil then
							_ED.recharge_rmb_number = _ED.recharge_result_cheak.recharge_RMB
						end
						m_reqcharge_info = {}
					else
						local sufficientStr = zstring.split(_ED.user_sufficient_type ,",")
						if  __lua_project_id == __lua_project_pacific_rim then
							-- local sufficientStr = zstring.split(_ED.user_sufficient_type ,",")
							local isFirstRecharge = false
							for k,v in pairs(sufficientStr) do
								local index = 1
								if  zstring.tonumber(v) >= 1 then 
									--已经首充过了
									isFirstRecharge = true
									break
								end
							end
							if isFirstRecharge == true then
								_ED.user_sufficient_type = ""
								for k,v in pairs(sufficientStr) do
									if k == #sufficientStr then
										_ED.user_sufficient_type = _ED.user_sufficient_type.."1"
									else
										_ED.user_sufficient_type = _ED.user_sufficient_type.."1,"
									end
								end
							end
							sufficientStr = zstring.split(_ED.user_sufficient_type ,",")
						end
						-- if zstring.tonumber(_ED.recharge_rmb_number) > 0 then
							if zstring.tonumber("".._ED.server_review) ~= 0 then
								if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
									or __lua_project_id == __lua_project_rouge
									or __lua_project_id == __lua_project_yugioh)
									and ___is_open_firstCharge_double == true 
									then
									local getGold = zstring.tonumber(_ED.recharge_result_cheak.recharge_allShuijing) - zstring.tonumber(_ED.user_info.user_gold)
									TipDlg.drawTextDailog(_string_piece_info[245]..getGold.._string_piece_info[222])
									_ED.recharge_rmb_number = _ED.recharge_result_cheak.recharge_RMB
									_ED.user_info.user_gold = zstring.tonumber(_ED.recharge_result_cheak.recharge_allShuijing)
								else
									if app.configJson.OperatorName == "gamedreamer" then
										local getGold = zstring.tonumber(_ED.recharge_result_cheak.recharge_allShuijing) - zstring.tonumber(_ED.user_info.user_gold)
										TipDlg.drawTextDailog(_string_piece_info[245]..getGold.._string_piece_info[222])
										_ED.recharge_rmb_number = _ED.recharge_result_cheak.recharge_RMB
										_ED.user_info.user_gold = zstring.tonumber(_ED.recharge_result_cheak.recharge_allShuijing)
									else
										local getGold = zstring.tonumber(_ED.recharge_result_cheak.recharge_allShuijing) - zstring.tonumber(_ED.user_info.user_gold)
										TipDlg.drawTextDailog(_string_piece_info[245]..getGold.._string_piece_info[244])
										_ED.recharge_rmb_number = _ED.recharge_result_cheak.recharge_RMB
										_ED.user_info.user_gold = zstring.tonumber(_ED.recharge_result_cheak.recharge_allShuijing)

									end	
								end
								if (__lua_project_id == __lua_project_warship_girl_a 
									or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
									or __lua_project_id == __lua_project_rouge
									or __lua_project_id == __lua_project_yugioh) and __game_data_record_open == true 
							  		then
							  		jttd.trackingGiftGodVirtualMoney(zstring.tonumber(m_reqcharge_info.extra),tipStringInfo_game_data_record[51])
							  	end
							else
								if zstring.tonumber(sufficientStr[zstring.tonumber(m_reqcharge_info.rechargeIndex)]) ~= 0 then	
									if zstring.tonumber(m_reqcharge_info.extra) == 0 then
										if __lua_project_id == __lua_project_adventure then 
											local add_recharge_count = tonumber(_ED.recharge_result_cheak.recharge_allShuijing) - tonumber(_ED.user_info.user_gold)
											TipDlg.drawTextDailog(_string_piece_info[245]..add_recharge_count.._string_piece_info[246])
											_ED.user_info.user_gold = zstring.tonumber(_ED.recharge_result_cheak.recharge_allShuijing)
										else	
											if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
												or __lua_project_id == __lua_project_rouge
												or __lua_project_id == __lua_project_yugioh)
												and ___is_open_firstCharge_double == true 
												then
												local getGold = zstring.tonumber(_ED.recharge_result_cheak.recharge_allShuijing) - zstring.tonumber(_ED.user_info.user_gold)
												TipDlg.drawTextDailog(_string_piece_info[245]..getGold.._string_piece_info[222])
												_ED.user_info.user_gold = zstring.tonumber(_ED.recharge_result_cheak.recharge_allShuijing)
											elseif __lua_project_id == __lua_project_red_alert 
													or __lua_project_id == __lua_project_red_alert_time 
													or __lua_project_id == __lua_project_pacific_rim
													then
													local gift = zstring.tonumber(_ED.recharge_result_cheak.recharge_all_number) - zstring.tonumber(_ED.recharge_result_cheak.recharge_count)
													if gift == 0 then
														TipDlg.drawTextDailog(_string_piece_info[245].._ED.recharge_result_cheak.recharge_count.._string_piece_info[246]..vipGradeString)
													else
														TipDlg.drawTextDailog(_string_piece_info[245].._ED.recharge_result_cheak.recharge_count.._string_piece_info[243]..gift.._string_piece_info[244]..vipGradeString)
													end
											else
												if app.configJson.OperatorName == "gamedreamer" then
													local getGold = zstring.tonumber(_ED.recharge_result_cheak.recharge_allShuijing) - zstring.tonumber(_ED.user_info.user_gold)
													TipDlg.drawTextDailog(_string_piece_info[245]..getGold.._string_piece_info[222])
													_ED.recharge_rmb_number = _ED.recharge_result_cheak.recharge_RMB
													_ED.user_info.user_gold = zstring.tonumber(_ED.recharge_result_cheak.recharge_allShuijing)
												else
													local getGold = zstring.tonumber(_ED.recharge_result_cheak.recharge_allShuijing) - zstring.tonumber(_ED.user_info.user_gold)
													-- local gift = dms.string(dms["top_up_goods"], tonumber(_ED.recharge_result_cheak.recharge_id)
													TipDlg.drawTextDailog(_string_piece_info[245]..getGold.._string_piece_info[246])
													_ED.user_info.user_gold = zstring.tonumber(_ED.recharge_result_cheak.recharge_allShuijing)

												end
											end
										end
								
										_ED.recharge_rmb_number = _ED.recharge_result_cheak.recharge_RMB
										
									else
										if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
											or __lua_project_id == __lua_project_rouge
											or __lua_project_id == __lua_project_yugioh)
											and ___is_open_firstCharge_double == true 
											then
											local getGold = zstring.tonumber(_ED.recharge_result_cheak.recharge_allShuijing) - zstring.tonumber(_ED.user_info.user_gold)
											TipDlg.drawTextDailog(_string_piece_info[245]..getGold.._string_piece_info[222])
											_ED.recharge_rmb_number = _ED.recharge_result_cheak.recharge_RMB
											_ED.user_info.user_gold = zstring.tonumber(_ED.recharge_result_cheak.recharge_allShuijing)
										else
											if app.configJson.OperatorName == "gamedreamer" then
												local getGold = zstring.tonumber(_ED.recharge_result_cheak.recharge_allShuijing) - zstring.tonumber(_ED.user_info.user_gold)
												TipDlg.drawTextDailog(_string_piece_info[245]..getGold.._string_piece_info[222])
												_ED.recharge_rmb_number = _ED.recharge_result_cheak.recharge_RMB
												_ED.user_info.user_gold = zstring.tonumber(_ED.recharge_result_cheak.recharge_allShuijing)
											else
												if __lua_project_id == __lua_project_red_alert 
													or __lua_project_id == __lua_project_red_alert_time 
													or __lua_project_id == __lua_project_pacific_rim
													then
													local gift = zstring.tonumber(_ED.recharge_result_cheak.recharge_all_number) - zstring.tonumber(_ED.recharge_result_cheak.recharge_count)
													if gift == 0 then
														TipDlg.drawTextDailog(_string_piece_info[245].._ED.recharge_result_cheak.recharge_count.._string_piece_info[246]..vipGradeString)
													else
														TipDlg.drawTextDailog(_string_piece_info[245].._ED.recharge_result_cheak.recharge_count.._string_piece_info[243]..gift.._string_piece_info[244]..vipGradeString)
													end
												else
													local getGold = zstring.tonumber(_ED.recharge_result_cheak.recharge_allShuijing) - zstring.tonumber(_ED.user_info.user_gold)
													TipDlg.drawTextDailog(_string_piece_info[245]..getGold.._string_piece_info[222])
												end
												_ED.recharge_rmb_number = _ED.recharge_result_cheak.recharge_RMB
												_ED.user_info.user_gold = zstring.tonumber(_ED.recharge_result_cheak.recharge_allShuijing)
											end
										end
										if (__lua_project_id == __lua_project_warship_girl_a 
											or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
											or __lua_project_id == __lua_project_rouge
											or __lua_project_id == __lua_project_yugioh) and __game_data_record_open == true 
									  		then
									  		jttd.trackingGiftGodVirtualMoney(zstring.tonumber(m_reqcharge_info.extra),tipStringInfo_game_data_record[51])
									  	end
									end
								else
									if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
										or __lua_project_id == __lua_project_rouge
										or __lua_project_id == __lua_project_yugioh)
										and ___is_open_firstCharge_double == true 
										then
										local getGold = zstring.tonumber(_ED.recharge_result_cheak.recharge_allShuijing) - zstring.tonumber(_ED.user_info.user_gold)
										TipDlg.drawTextDailog(_string_piece_info[221]..getGold.._string_piece_info[222])
										_ED.recharge_rmb_number = _ED.recharge_result_cheak.recharge_RMB
										_ED.user_info.user_gold = zstring.tonumber(_ED.recharge_result_cheak.recharge_allShuijing)
									else
										if app.configJson.OperatorName == "gamedreamer" then
											local getGold = zstring.tonumber(_ED.recharge_result_cheak.recharge_allShuijing) - zstring.tonumber(_ED.user_info.user_gold)
											TipDlg.drawTextDailog(_string_piece_info[245]..getGold.._string_piece_info[222])
											_ED.recharge_rmb_number = _ED.recharge_result_cheak.recharge_RMB
											_ED.user_info.user_gold = zstring.tonumber(_ED.recharge_result_cheak.recharge_allShuijing)
										else
											-- TipDlg.drawTextDailog(_string_piece_info[245].._ED.recharge_result_cheak.recharge_count+zstring.tonumber(_extra).._string_piece_info[246])
											-- _ED.user_info.user_gold = zstring.tonumber(_ED.user_info.user_gold) + zstring.tonumber(_ED.recharge_result_cheak.recharge_allGame) + zstring.tonumber(_extra)
											if __lua_project_id == __lua_project_red_alert_time 
												or __lua_project_id == __lua_project_pacific_rim 
												then
												--暂时不要首充提示
                                                local gift = zstring.tonumber(_ED.recharge_result_cheak.recharge_all_number) - zstring.tonumber(_ED.recharge_result_cheak.recharge_count)
												if gift == 0 then
													TipDlg.drawTextDailog(_string_piece_info[245].._ED.recharge_result_cheak.recharge_count.._string_piece_info[246]..vipGradeString)
												else
													TipDlg.drawTextDailog(_string_piece_info[245].._ED.recharge_result_cheak.recharge_count.._string_piece_info[243]..gift.._string_piece_info[244]..vipGradeString)
												end
												-- local total = zstring.tonumber(_ED.recharge_result_cheak.recharge_allGame) + zstring.tonumber(m_reqcharge_info.additional)
												-- TipDlg.drawTextDailog(_string_piece_info[221]..total.._string_piece_info[243]..zstring.tonumber(m_reqcharge_info.extra).._string_piece_info[244])
											elseif __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball
												or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
												or __lua_project_id == __lua_project_l_naruto
												then
												-- local gift = zstring.tonumber(_ED.recharge_result_cheak.recharge_all_number) - zstring.tonumber(_ED.recharge_result_cheak.recharge_count)
												-- if zstring.tonumber(m_reqcharge_info.additional) == 0 then
												-- 	TipDlg.drawTextDailog(_string_piece_info[245]..gift.._string_piece_info[246])
												-- else
												-- 	local getGold = zstring.tonumber(_ED.recharge_result_cheak.recharge_allShuijing) - zstring.tonumber(_ED.user_info.user_gold)
												-- 	TipDlg.drawTextDailog(_string_piece_info[245]..getGold.._string_piece_info[222])
												-- end
												local getGold = zstring.tonumber(_ED.recharge_result_cheak.recharge_allShuijing) - zstring.tonumber(_ED.user_info.user_gold)
												TipDlg.drawTextDailog(_string_piece_info[245]..getGold.._string_piece_info[222])
											else
												local getGold = zstring.tonumber(_ED.recharge_result_cheak.recharge_allShuijing) - zstring.tonumber(_ED.user_info.user_gold)
												TipDlg.drawTextDailog(_string_piece_info[245]..getGold.._string_piece_info[222])
											end
											_ED.recharge_rmb_number = _ED.recharge_result_cheak.recharge_RMB
											_ED.user_info.user_gold = zstring.tonumber(_ED.recharge_result_cheak.recharge_allShuijing)
										end
									end

									if (__lua_project_id == __lua_project_warship_girl_a 
										or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
										or __lua_project_id == __lua_project_rouge
										or __lua_project_id == __lua_project_yugioh) and __game_data_record_open == true 
								  		then
								  		jttd.trackingGiftGodVirtualMoney(zstring.tonumber(m_reqcharge_info.additional),tipStringInfo_game_data_record[51])
								  	end
								end
							end
						-- else
							-- TipDlg.drawTextDailog(_string_piece_info[221]..zstring.tonumber(_ED.recharge_result_cheak.recharge_allGame).._string_piece_info[243]..zstring.tonumber(_additional).._string_piece_info[244])
							-- _ED.recharge_rmb_number = _ED.recharge_result_cheak.recharge_RMB
							-- _ED.user_info.user_gold = zstring.tonumber(_ED.user_info.user_gold) + (zstring.tonumber(_ED.recharge_result_cheak.recharge_count)+zstring.tonumber(_additional))
						
						-- end
						m_reqcharge_info = {}
						state_machine.excute("refresh_privilege_button", 0, "refresh_privilege_button.")
					end
				end
				state_machine.excute("refresh_privilege_button", 0, "refresh_privilege_button.")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(recharge_list_button_terminal)
		state_machine.add(get_month_card_list_button_terminal)
		state_machine.add(check_the_order_to_refresh_the_list_terminal)
		state_machine.add(refresh_recharge_interface_terminal)
		state_machine.add(platform_check_the_order_to_refresh_the_list_terminal)
		state_machine.add(refresh_single_recharge_interface_list_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_RechargeListCell_terminal()
end

function RechargeListCell:refreshDraw(rechargeIndex)
	local root = self.roots[1]
	local textIntroduce = ccui.Helper:seekWidgetByName(root, "Text_czl_2") --充值介绍
	local ImageFirst = ccui.Helper:seekWidgetByName(root, "Image_czl_7") --首冲图片
	local Image_198 = ccui.Helper:seekWidgetByName(root, "Image_198")
	local Image_198_0 = ccui.Helper:seekWidgetByName(root, "Image_198_0")
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	else
		self:upDataDraw()
	end
	if self.index == 1 then	--月卡
		local month_card_time = 0
		local month_card_state = 0
		if _ED.month_card ~= nil and _ED.month_card ~= "" and _ED.month_card[rechargeIndex] ~= nil then
			month_card_time = _ED.month_card[rechargeIndex].surplus_month_card_time
			month_card_state = _ED.month_card[rechargeIndex].draw_month_card_state
		end
		if zstring.tonumber(month_card_time) > 0 then
			if zstring.tonumber(month_card_state) == 0 then
				if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge
					then 
					if zstring.tonumber(_game_platform_version_type) == 2 then 
						local goodsInfo = getMonthCardString(self.example)
						local infoText = string.format(_month_card_tip[2], self.example[14], goodsInfo, month_card_time)
						textIntroduce:setString(infoText)
					else
						textIntroduce:setString(_string_piece_info[229]..self.example[14].._string_piece_info[230]..month_card_time.._string_piece_info[231])	
					end
				elseif __lua_project_id == __lua_project_red_alert 
					or __lua_project_id == __lua_project_red_alert_time 
					or __lua_project_id == __lua_project_pacific_rim
					then
					textIntroduce:setString(string.format(_month_card_tip[2], self.example[14], month_card_time))
				else
					textIntroduce:setString(_string_piece_info[229]..self.example[14].._string_piece_info[230]..month_card_time.._string_piece_info[231])	
				end
			
				Image_198:setVisible(true)
				Image_198_0:setVisible(false)
				if __lua_project_id == __lua_project_adventure then 
					Image_198:setTouchEnabled(true)
					ccui.Helper:seekWidgetByName(root, "Text_czl_3"):setString("")
					ccui.Helper:seekWidgetByName(root, "Button_rmb"):setVisible(false)
					fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_198"), nil, 
					{
						terminal_name = "get_month_card_list_button", 
						terminal_state = 0, 
						_cell = self, 
						jewel = self.example[14],
						listIndex = rechargeIndex, 
						isPressedActionEnabled = true
					},
					nil,0)
				else
					fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3"), nil, 
					{
						terminal_name = "get_month_card_list_button", 
						terminal_state = 0, 
						_cell = self, 
						jewel = self.example[14],
						listIndex = rechargeIndex, 
						isPressedActionEnabled = true
					},
					nil,0)
				end
				fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3"), nil, 
				{
					terminal_name = "get_month_card_list_button", 
					terminal_state = 0, 
					_cell = self, 
					jewel = self.example[14],
					listIndex = rechargeIndex, 
					isPressedActionEnabled = true
				},
				nil,0)
			else
				if __lua_project_id == __lua_project_red_alert then
					textIntroduce:setString(string.format(_month_card_tip[2], self.example[14], month_card_time))
					if zstring.tonumber(month_card_time) < 90 then
						Image_198:setVisible(false)
						Image_198_0:setVisible(false)
						fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3"), nil, 
						{
							terminal_name = "recharge_list_button", 
							terminal_state = 0, 
							_cell = self, 
							listIndex = self.example[1], 
							isMonthCard = self.example[13], 
							gradeMonthCard = self.example[4], 
							nameMonthCard = self.example[3], 
							goodsInfo = goodsInfo,
							isPressedActionEnabled = true
						},
						nil,0)
					else
						Image_198:setVisible(false)
						Image_198_0:setVisible(true)
					end
				else
					textIntroduce:setString(_string_piece_info[247]..month_card_time.._string_piece_info[231])
					Image_198:setVisible(false)
					Image_198_0:setVisible(true)
				end
			end
		end
	else	--非月卡
		-- local sufficientStr = zstring.split(_ED.user_sufficient_type ,",")
		-- for i ,v in pairs(sufficientStr) do
			-- if zstring.tonumber(i) == zstring.tonumber(self.example[1]) then
				-- if zstring.tonumber(v) == 1 then
					-- textIntroduce:setString(_string_piece_info[220])
					-- ImageFirst:setVisible(false)
				-- end
			-- end
			
		-- end
		local sufficientStr = zstring.split(_ED.user_sufficient_type ,",")
		local recharge_state = zstring.tonumber(sufficientStr[zstring.tonumber(self.example[1])])
		if __lua_project_id == __lua_project_adventure and zstring.tonumber("".._ED.server_review) ~= 0 then 
			--评审状态 ,ios平台的时候不能显示首充
			local targetPlatform = cc.Application:getInstance():getTargetPlatform()
			
	        if cc.PLATFORM_OS_IPHONE == targetPlatform
				or cc.PLATFORM_OS_MAC == targetPlatform
				or cc.PLATFORM_OS_IPAD == targetPlatform
				then
				recharge_state = 1
			end
		end
		if recharge_state == 0 then
			if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon
			or __lua_project_id == __lua_project_rouge 
			then 
				if zstring.tonumber(_game_platform_version_type) == 2 then 
					textIntroduce:setString(_string_piece_info[380].._string_piece_info[219])
				else
					textIntroduce:setString(_string_piece_info[218]..self.example[14].._string_piece_info[219])
				end
			elseif __lua_project_id == __lua_project_yugioh then 
				--游戏王新马渠道
				if zstring.tonumber(_game_platform_version_type) == 3 then 
					textIntroduce:setString(_string_piece_info[380].._string_piece_info[219])
				else
					textIntroduce:setString(_string_piece_info[218]..self.example[14].._string_piece_info[219])
				end
			elseif __lua_project_id == __lua_project_red_alert_time 
				or __lua_project_id == __lua_project_pacific_rim 
				then
			elseif __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				if tonumber(self.example[6]) > 0 then
					textIntroduce:setString(string.format(_new_interface_text[83], self.example[6]))
				elseif tonumber(self.example[7]) > 0 then
					textIntroduce:setString(string.format(_new_interface_text[307], self.example[7]))
				else
					textIntroduce:setString("")
				end
			else
				textIntroduce:setString(_string_piece_info[218]..self.example[14].._string_piece_info[219])
			end
			
		else
			if __lua_project_id == __lua_project_adventure then
			elseif __lua_project_id == __lua_project_red_alert_time 
				or __lua_project_id == __lua_project_pacific_rim 
				then
			else
				if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge
					then 
					if zstring.tonumber(_game_platform_version_type) == 2 then 
						textIntroduce:setString(_string_piece_info[380])
					else
						textIntroduce:setString(_string_piece_info[220]..self.example[7].._string_piece_info[222])	
					end
				elseif __lua_project_id == __lua_project_yugioh then 
					if zstring.tonumber(_game_platform_version_type) == 3 then 
						--游戏王新马渠道
						textIntroduce:setString(_string_piece_info[380])
					else
						textIntroduce:setString(_string_piece_info[220]..self.example[7].._string_piece_info[222])	
					end
				elseif __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					if tonumber(self.example[7]) > 0 then
						textIntroduce:setString(string.format(_new_interface_text[307], self.example[7]))
					else
						textIntroduce:setString("")	
					end
				else
					if __lua_project_id == __lua_project_red_alert 
						or __lua_project_id == __lua_project_red_alert_time 
						or __lua_project_id == __lua_project_pacific_rim
						then
						textIntroduce:setString(string.format(_string_piece_info[428],self.example[3]))
					else
						textIntroduce:setString(_string_piece_info[220]..self.example[7].._string_piece_info[222])
					end
				end
				
			end
			ImageFirst:setVisible(false)
		end
	end
	
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		ImageFirst:setVisible(false)
		if tonumber(self.example[18]) == 2 then
			ImageFirst:setVisible(true)
		end
	end
	
	if __lua_project_id == __lua_project_red_alert_time 
		or __lua_project_id == __lua_project_pacific_rim 
		then
		if dms.int(dms["top_up_goods"], tonumber(self.example[1]), top_up_goods.picture_index) == 0 then
			ImageFirst:setVisible(false)
		else
			ImageFirst:setVisible(true)
			ImageFirst:loadTexture(string.format("images/ui/shop/recharge_list_tab_%d.png", dms.int(dms["top_up_goods"], tonumber(self.example[1]), top_up_goods.picture_index)))
		end
	end
end
function RechargeListCell:upDataDraw()
	local root = self.roots[1]
	
	local TextName = ccui.Helper:seekWidgetByName(root, "Text_czl_1")
	local textPrice = ccui.Helper:seekWidgetByName(root, "Text_czl_3")
	local ImageFirst = ccui.Helper:seekWidgetByName(root, "Image_czl_7") --首冲图片
	local textIntroduce = ccui.Helper:seekWidgetByName(root, "Text_czl_2") --充值介绍
	local PanelPicture = ccui.Helper:seekWidgetByName(root, "Panel_cz_list_1") --充值介绍
	local Text_charge_n = ccui.Helper:seekWidgetByName(root, "Text_charge_n")	--充值数量
	local Text_give_n = ccui.Helper:seekWidgetByName(root, "Text_give_n")		--赠送数量
	PanelPicture:removeAllChildren(true)
	local Panel_buy = ccui.Helper:seekWidgetByName(root, "Panel_buy")
	if Panel_buy ~= nil then
		Panel_buy:setVisible(false)
	end
	local Panel_recharge_title = ccui.Helper:seekWidgetByName(root, "Panel_recharge_title")
	if Panel_recharge_title ~= nil then
		Panel_recharge_title:setBackGroundImage(string.format("images/ui/text/sm_hd/num%s.png", tonumber(self.example[1])))
		-- if tonumber(self.example[5]) == 6480 then
		-- 	Panel_recharge_title:setBackGroundImage("images/ui/text/sm_hd/num1.png")
		-- elseif tonumber(self.example[5]) == 3280 then
		-- 	Panel_recharge_title:setBackGroundImage("images/ui/text/sm_hd/num2.png")
		-- elseif tonumber(self.example[5]) == 1980 then
		-- 	Panel_recharge_title:setBackGroundImage("images/ui/text/sm_hd/num3.png")
		-- elseif tonumber(self.example[5]) == 980 then
		-- 	Panel_recharge_title:setBackGroundImage("images/ui/text/sm_hd/num4.png")
		-- elseif tonumber(self.example[5]) == 600 then
		-- 	Panel_recharge_title:setBackGroundImage("images/ui/text/sm_hd/num5.png")
		-- elseif tonumber(self.example[5]) == 300 then
		-- 	Panel_recharge_title:setBackGroundImage("images/ui/text/sm_hd/num6.png")
		-- else
		-- 	Panel_recharge_title:setBackGroundImage("images/ui/text/sm_hd/num7.png")
		-- end
	end
	PanelPicture:removeAllChildren(true)
	if self.index == 1 then	--月卡
		local Button_3 = ccui.Helper:seekWidgetByName(root, "Button_3")
		local Image_198 = ccui.Helper:seekWidgetByName(root, "Image_198")
		local Image_198_0 = ccui.Helper:seekWidgetByName(root, "Image_198_0")

		if self._choose_month_state == true then
			if Panel_buy ~= nil then
				Panel_buy:setVisible(true)
			end
		end

		-- 取出月卡奖励物品信息
		local goodsInfo = getMonthCardString(self.example)
		
		self.goodsInfo = goodsInfo
		if Button_3 ~= nil then
			Button_3:setVisible(true)
		end
		ImageFirst:setVisible(false)
		if TextName ~= nil then
			TextName:setString(self.example[3])
		end
		if __lua_project_id == __lua_project_yugioh 
			or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
			or __lua_project_id == __lua_project_warship_girl_b
			or __lua_project_id == __lua_project_pokemon
			or __lua_project_id == __lua_project_rouge
			then 
			if _string_piece_info[217] == "$" then 
				--美元符在前面
				textPrice:setString(_string_piece_info[217]..self.example[4])
			else
				textPrice:setString(self.example[4].._string_piece_info[217])
			end
		elseif __lua_project_id == __lua_project_red_alert_time 
			or __lua_project_id == __lua_project_pacific_rim 
			then
			if _string_piece_info[217] == "$" then
				textPrice:setString(_string_piece_info[217]..self.example[4])
			else
				textPrice:setString(self.example[4])
			end
			Text_charge_n:setString(self.example[5].._string_piece_info[433])
			if Text_give_n ~= nil then
				Text_give_n:setString(self.example[7])
			end
		else
			textPrice:setString(self.example[4].._string_piece_info[217])
		end
		
		-- PanelPicture:setBackGroundImage(string.format("images/ui/props/props_%d.png", self.example[17]))
		if __lua_project_id == __lua_project_adventure then 
			local cell = adventureNewPropIconCell:createCell()
			cell:init(0, {resource_type = 23}, "", 0,true)
			PanelPicture:addChild(cell)
			Image_198:setTouchEnabled(false)
		elseif __lua_project_id == __lua_project_red_alert_time 
			or __lua_project_id == __lua_project_pacific_rim 
			then
		else
			local cell = ResourcesIconCell:createCell()
			cell:init(cell.enum_type.RECHARGE_SHOP_INFORMATION, nil, self.example[17], nil,true)
			PanelPicture:addChild(cell)
		end
		
		local month_card_time = 0
		local month_card_state = 0
		if _ED.month_card ~= nil and _ED.month_card ~= "" and _ED.month_card[self.example[1]] ~= nil then
			month_card_time = _ED.month_card[self.example[1]].surplus_month_card_time
			month_card_state = _ED.month_card[self.example[1]].draw_month_card_state
		end
		if zstring.tonumber(month_card_time) > 0 then
			if zstring.tonumber(month_card_state) == 0 then
				local infoText = ""
				if __lua_project_id == __lua_project_yugioh then 
					--游戏王需求
					if zstring.tonumber(_game_platform_version_type) == 2 or zstring.tonumber(_game_platform_version_type) == 3 then 
						infoText = string.format(_month_card_tip[2], self.example[14], month_card_time)
					else
						infoText = string.format(_month_card_tip[2], self.example[14], goodsInfo, month_card_time)
					end
				elseif __lua_project_id == __lua_project_red_alert 
					or __lua_project_id == __lua_project_red_alert_time 
					or __lua_project_id == __lua_project_pacific_rim
					then
					infoText = string.format(_month_card_tip[2], self.example[14], month_card_time)
				else
					infoText = string.format(_month_card_tip[2], self.example[14], goodsInfo, month_card_time)
				end
				
				textIntroduce:setString(infoText)
				
				Image_198:setVisible(true)
				Image_198_0:setVisible(false)
			else
				if __lua_project_id == __lua_project_red_alert then
					textIntroduce:setString(string.format(_month_card_tip[2], self.example[14], month_card_time))
					if zstring.tonumber(month_card_time) < 90 then 
						Image_198:setVisible(false)
						Image_198_0:setVisible(false)
						fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3"), nil, 
						{
							terminal_name = "recharge_list_button", 
							terminal_state = 0, 
							_cell = self, 
							listIndex = self.example[1], 
							isMonthCard = self.example[13], 
							gradeMonthCard = self.example[4], 
							nameMonthCard = self.example[3], 
							goodsInfo = goodsInfo,
							isPressedActionEnabled = true
						},
						nil,0)
					else
						Image_198:setVisible(false)
						Image_198_0:setVisible(true)
					end
				else
					textIntroduce:setString(_string_piece_info[247]..month_card_time.._string_piece_info[231])
					Image_198:setVisible(false)
					Image_198_0:setVisible(true)
				end
			end
		else
			local infoText = ""
			if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge
				then 
				local sufficientStr = zstring.split(_ED.user_sufficient_type ,",")
				local recharge_state = zstring.tonumber(sufficientStr[zstring.tonumber(self.example[1])])

				if recharge_state == 0 then --首充
					local money = zstring.tonumber(self.example[5]) + zstring.tonumber(self.example[6])
					infoText = string.format(_month_card_tip[1], money,self.example[15], self.example[14], goodsInfo)	
				else
					local money = zstring.tonumber(self.example[5]) +   zstring.tonumber(self.example[7])
					infoText = string.format(_month_card_tip[1], money,self.example[15], self.example[14], goodsInfo)	
				end
			elseif __lua_project_id == __lua_project_yugioh then 
				--游戏王需求
				if zstring.tonumber(_game_platform_version_type) == 2 or zstring.tonumber(_game_platform_version_type) == 3 then 
					infoText = string.format(_month_card_tip[1], self.example[15], self.example[14])	
				else	
					infoText = string.format(_month_card_tip[1], self.example[5],self.example[15], self.example[14], goodsInfo)
				end
			elseif __lua_project_id == __lua_project_red_alert 
				or __lua_project_id == __lua_project_red_alert_time 
				or __lua_project_id == __lua_project_pacific_rim
				then
				infoText = string.format(_month_card_tip[1], self.example[14],self.example[15])
			else
				infoText = string.format(_month_card_tip[1], self.example[5],self.example[15], self.example[14], goodsInfo)
			end
			
			textIntroduce:setString(infoText)
		end
		
		if zstring.tonumber(month_card_time) > 0  then--领取月卡
			if __lua_project_id == __lua_project_adventure then 
				ccui.Helper:seekWidgetByName(root, "Button_rmb"):setVisible(false)
				textPrice:setString("")
				Image_198:setTouchEnabled(true)
				
				fwin:addTouchEventListener(Image_198, nil, 
				{
					terminal_name = "get_month_card_list_button", 
					terminal_state = 0, 
					_cell = self, 
					jewel = self.example[14],
					listIndex = self.example[1], 
					goodsInfo = goodsInfo,
					isPressedActionEnabled = true
				},
				nil,0)
			else
				if __lua_project_id == __lua_project_red_alert then 
					if zstring.tonumber(month_card_time) < 90 and zstring.tonumber(month_card_state) ~= 0 then 
						fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3"), nil, 
						{
							terminal_name = "recharge_list_button", 
							terminal_state = 0, 
							_cell = self, 
							listIndex = self.example[1], 
							isMonthCard = self.example[13], 
							gradeMonthCard = self.example[4], 
							nameMonthCard = self.example[3], 
							goodsInfo = goodsInfo,
							isPressedActionEnabled = true
						},
						nil,0)
					else
						fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3"), nil, 
						{
							terminal_name = "get_month_card_list_button", 
							terminal_state = 0, 
							_cell = self, 
							jewel = self.example[14],
							listIndex = self.example[1], 
							goodsInfo = goodsInfo,
							isPressedActionEnabled = true
						},
						nil,0)
					end
				else
					fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3"), nil, 
					{
						terminal_name = "get_month_card_list_button", 
						terminal_state = 0, 
						_cell = self, 
						jewel = self.example[14],
						listIndex = self.example[1], 
						goodsInfo = goodsInfo,
						isPressedActionEnabled = true
					},
					nil,0)
				end
			end
		else
			--购买月卡
			if __lua_project_id == __lua_project_adventure then 
					ccui.Helper:seekWidgetByName(root, "Button_rmb"):setVisible(true)
					textPrice:setString(self.example[4])
					fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rmb"), nil, 
					{
						terminal_name = "recharge_list_button", 
						terminal_state = 0, 
						_cell = self, 
						listIndex = self.example[1], 
						isMonthCard = self.example[13], 
						gradeMonthCard = self.example[4], 
						goodsInfo = goodsInfo,
						isPressedActionEnabled = true
					},
					nil,0)
				else
					fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3"), nil, 
					{
						terminal_name = "recharge_list_button", 
						terminal_state = 0, 
						_cell = self, 
						listIndex = self.example[1], 
						isMonthCard = self.example[13], 
						gradeMonthCard = self.example[4], 
						nameMonthCard = self.example[3], 
						goodsInfo = goodsInfo,
						isPressedActionEnabled = true
					},
					nil,0)
			end
			
		end
		
	else	--非月卡
		local Button_7 = ccui.Helper:seekWidgetByName(root, "Button_7")
		if Button_7 ~= nil then
			Button_7:setVisible(true)
		end
		if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge
			or __lua_project_id == __lua_project_yugioh)
			and ___is_open_firstCharge_double == true 
			then
			ImageFirst:setVisible(false)
		else
			ImageFirst:setVisible(true)
		end
		if TextName ~= nil then
			TextName:setString(self.example[3])
		end	
		
		-- PanelPicture:setBackGroundImage(string.format("images/ui/props/props_%d.png", self.example[17]))
		if __lua_project_id == __lua_project_adventure then
			textPrice:setString(self.example[4])
			local cell = adventureNewPropIconCell:createCell()
			cell:init(0, {mould_id = 1}, self.example[5], 1,true)
			PanelPicture:addChild(cell)
	
			-- local cell = adventurePropIconCell:createCell()
			-- cell:init(cell.enum_type.SHOP_RECHARGE_ITEM, nil, self.example[5], nil,true)
			-- PanelPicture:addChild(cell)
		elseif __lua_project_id == __lua_project_red_alert_time 
			or __lua_project_id == __lua_project_pacific_rim 
			then
			if _string_piece_info[217] == "$" then
				textPrice:setString(_string_piece_info[217]..self.example[4])
			else
				textPrice:setString(self.example[4])
			end
			Text_charge_n:setString(self.example[5].._string_piece_info[433])
			local sufficientStr = zstring.split(_ED.user_sufficient_type ,",")
			local recharge_state = zstring.tonumber(sufficientStr[zstring.tonumber(self.example[1])])
			if Text_give_n ~= nil then
				if recharge_state == 0 then
					Text_give_n:setString(self.example[6])
				else
					Text_give_n:setString(self.example[7])
				end
			end
		else
			if __lua_project_id == __lua_project_yugioh 
				or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
				or __lua_project_id == __lua_project_warship_girl_b
				or __lua_project_id == __lua_project_pokemon
				or __lua_project_id == __lua_project_rouge
				or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then 
				if _string_piece_info[217] == "$" then 
					--美元符在前面显示
					textPrice:setString(_string_piece_info[217]..self.example[4])
				else
					textPrice:setString(self.example[4].._string_piece_info[217])
				end
			else
				textPrice:setString(self.example[4].._string_piece_info[217])
			end
			local cell = ResourcesIconCell:createCell()
			cell:init(cell.enum_type.RECHARGE_SHOP_INFORMATION, nil, self.example[17], nil,true)
			
			PanelPicture:addChild(cell)
		end
		local sufficientStr = zstring.split(_ED.user_sufficient_type ,",")
		local recharge_state = zstring.tonumber(sufficientStr[zstring.tonumber(self.example[1])])
		if __lua_project_id == __lua_project_adventure and zstring.tonumber("".._ED.server_review) ~= 0 then 
			--评审状态 ,ios平台的时候不能显示首充
			local targetPlatform = cc.Application:getInstance():getTargetPlatform()
			
	        if cc.PLATFORM_OS_IPHONE == targetPlatform
				or cc.PLATFORM_OS_MAC == targetPlatform
				or cc.PLATFORM_OS_IPAD == targetPlatform
				then
				recharge_state = 1
			end
		end
		if recharge_state == 0 and self._bSupplyFirestRecharge == true then
			
			if __lua_project_id == __lua_project_adventure then
				textIntroduce:setString(_string_piece_info[218]..self.example[6].._string_piece_info[219])
			elseif __lua_project_id == __lua_project_red_alert_time 
				or __lua_project_id == __lua_project_pacific_rim
				then
			else
				if __lua_project_id == __lua_project_digimon_adventure 
					or __lua_project_id == __lua_project_naruto 
					or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge
					then 
					if zstring.tonumber(_game_platform_version_type) == 2 then 
						--首充只会显示一次
						local _drawTypes = dms.searchs(dms["top_up_goods"], top_up_goods.goods_type, 0)
						local monthCount = 0
						local isFirstRecharge = false
						if _drawTypes ~= nil then
							
							local sufficientStr = zstring.split(_ED.user_sufficient_type ,",")
							for k,v in pairs(_drawTypes) do
								local index = 1
								if  zstring.tonumber( sufficientStr[zstring.tonumber(v[2])]) >= 1 then 
									--已经首充过了
									isFirstRecharge = true
									break
								end
							end

						end
						
						if isFirstRecharge == true then 
							textIntroduce:setString(_string_piece_info[380])
						else
							textIntroduce:setString(_string_piece_info[380].._string_piece_info[219])
						end
					else
						textIntroduce:setString(_string_piece_info[218]..self.example[14].._string_piece_info[219])
					end
				elseif __lua_project_id == __lua_project_yugioh then
					if zstring.tonumber(_game_platform_version_type) == 3 then  
						--游戏王新马渠道
						--首充只会显示一次
						local _drawTypes = dms.searchs(dms["top_up_goods"], top_up_goods.goods_type, 0)
						local monthCount = 0
						local isFirstRecharge = false
						if _drawTypes ~= nil then
							
							local sufficientStr = zstring.split(_ED.user_sufficient_type ,",")
							for k,v in pairs(_drawTypes) do
								local index = 1
								if  zstring.tonumber( sufficientStr[zstring.tonumber(v[2])]) >= 1 then 
									--已经首充过了
									isFirstRecharge = true
									break
								end
							end

						end
						
						if isFirstRecharge == true then 
							textIntroduce:setString(_string_piece_info[380])
						else
							textIntroduce:setString(_string_piece_info[380].._string_piece_info[219])
						end	
					else
						textIntroduce:setString(_string_piece_info[218]..self.example[14].._string_piece_info[219])
					end
				elseif __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
					if tonumber(self.example[6]) > 0 then
						textIntroduce:setString(string.format(_new_interface_text[83], self.example[6]))
					elseif tonumber(self.example[7]) > 0 then
						textIntroduce:setString(string.format(_new_interface_text[307], self.example[7]))
					else
						textIntroduce:setString("")
					end
				else
					textIntroduce:setString(_string_piece_info[218]..self.example[14].._string_piece_info[219])
				end
			end
		else
			if __lua_project_id == __lua_project_adventure then
			elseif __lua_project_id == __lua_project_red_alert_time 
				or __lua_project_id == __lua_project_pacific_rim
				then
			else
				if __lua_project_id == __lua_project_digimon_adventure 
					or __lua_project_id == __lua_project_naruto 
					or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge
					then 
					if zstring.tonumber(_game_platform_version_type) == 2 then 
						textIntroduce:setString(_string_piece_info[380])
					else
						textIntroduce:setString(_string_piece_info[220]..self.example[7].._string_piece_info[222])
					end
				elseif __lua_project_id == __lua_project_yugioh then 
					if zstring.tonumber(_game_platform_version_type) == 3 then 
						--游戏王新马渠道
						textIntroduce:setString(_string_piece_info[380])
					else
						textIntroduce:setString(_string_piece_info[220]..self.example[7].._string_piece_info[222])
					end
				elseif __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball 
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					then
					if tonumber(self.example[7]) > 0 then
						textIntroduce:setString(string.format(_new_interface_text[307], self.example[7]))
					else
						textIntroduce:setString("") 
					end
				else
					if __lua_project_id == __lua_project_red_alert 
						or __lua_project_id == __lua_project_red_alert_time 
						or __lua_project_id == __lua_project_pacific_rim
						then
						textIntroduce:setString(string.format(_string_piece_info[428],self.example[3]))
					else
						textIntroduce:setString(_string_piece_info[220]..self.example[7].._string_piece_info[222])
					end
				end
			end
			ImageFirst:setVisible(false)
		end
		-- local sufficientStr = zstring.split(_ED.user_sufficient_type ,",")
		-- for i ,v in pairs(sufficientStr) do
			-- if zstring.tonumber(i) == zstring.tonumber(self.example[1]) then
				-- if zstring.tonumber(v) == 1 then
					-- textIntroduce:setString(_string_piece_info[220])
					-- ImageFirst:setVisible(false)
				-- end
			-- end
		-- end
		if __lua_project_id == __lua_project_pacific_rim then
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
			if isFirstRecharge == true then
				_ED.user_sufficient_type = ""
				for k,v in pairs(sufficientStr) do
					if k == #sufficientStr then
						_ED.user_sufficient_type = _ED.user_sufficient_type.."1"
					else
						_ED.user_sufficient_type = _ED.user_sufficient_type.."1,"
					end
				end
			end
		end
		--非月卡充值
		if __lua_project_id == __lua_project_adventure then
			ccui.Helper:seekWidgetByName(root, "Button_rmb"):setVisible(true)
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rmb"), nil, 
			{
				terminal_name = "recharge_list_button", 
				terminal_state = 0, 
				_cell = self, 
				listIndex = self.example[1], 
				isMonthCard = self.example[13], 
				extra = self.example[7],
				additional = self.example[14],
				isPressedActionEnabled = true
			},
			nil,0)
		elseif __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
			local m_scale = 0
			local m_isScale = false
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
				m_scale = 1
				m_isScale = false
			else
				m_scale = 0.9
				m_isScale = true
			end
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_7"), nil, 
				{
					terminal_name = "recharge_list_button", 
					terminal_state = 0, 
					_cell = self, 
					listIndex = self.example[1], 
					isMonthCard = self.example[13], 
					extra = self.example[7],
					additional = self.example[14],
					touch_scale = m_isScale,
					touch_scale_xy = m_scale, 
				},
				nil,0)
			ImageFirst:setVisible(false)
			if tonumber(self.example[18]) == 2 then
				ImageFirst:setVisible(true)
			end
		else	
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_7"), nil, 
				{
					terminal_name = "recharge_list_button", 
					terminal_state = 0, 
					_cell = self, 
					listIndex = self.example[1], 
					isMonthCard = self.example[13], 
					extra = self.example[7],
					additional = self.example[14],
					isPressedActionEnabled = true
				},
				nil,0)
		end
		
	end
	if __lua_project_id == __lua_project_red_alert_time 
		or __lua_project_id == __lua_project_pacific_rim 
		then
		if dms.int(dms["top_up_goods"], tonumber(self.example[1]), top_up_goods.picture_index) == 0 then
			ImageFirst:setVisible(false)
		else
			ImageFirst:setVisible(true)
			ImageFirst:loadTexture(string.format("images/ui/shop/recharge_list_tab_%d.png", dms.int(dms["top_up_goods"], tonumber(self.example[1]), top_up_goods.picture_index)))
		end
		PanelPicture:removeAllChildren(true)
		PanelPicture:setBackGroundImage(string.format(config_res.images.ui.props.props, tonumber(self.example[20])))
		textIntroduce:removeAllChildren(true)
		textIntroduce:setString("")
		local sufficientStr = zstring.split(_ED.user_sufficient_type ,",")
		local extra_gold = 0
		if tonumber(sufficientStr[tonumber(self.example[1])]) == 1 then
			extra_gold = tonumber(self.example[7])
		else
			extra_gold = tonumber(self.example[6]) + tonumber(self.example[7])
		end
		local _richText1 = ccui.RichText:create()
	    _richText1:ignoreContentAdaptWithSize(false)
	    local fontSize = textIntroduce:getFontSize() 
	    local str1 = string.format(_string_piece_info[431],tonumber(self.example[5]),tonumber(self.example[5]))    
	    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, str1, config_res.font.font_name,fontSize)
	    _richText1:pushBackElement(re1)   
	    local str2 = string.format(_string_piece_info[432],extra_gold)       
	    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[8][1],color_Type[8][2],color_Type[8][3]),255, str2, config_res.font.font_name,fontSize)
	    _richText1:pushBackElement(re2)   
	    _richText1:setContentSize(cc.size(textIntroduce:getContentSize().width,fontSize))
	    _richText1:formatTextExt()
	    _richText1:setPosition(cc.p(textIntroduce:getContentSize().width/2 + _richText1:getContentSize().width/2,textIntroduce:getContentSize().height))
	    textIntroduce:addChild(_richText1)
	end
	
	if ccui.Helper:seekWidgetByName(root, "Button_28") ~= nil then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_28"), nil, 
			{
				terminal_name = "recharge_list_button", 
				terminal_state = 0, 
				_cell = self, 
				listIndex = self.example[1], 
				isMonthCard = self.example[13], 
				extra = self.example[7],
				additional = self.example[14],
				isPressedActionEnabled = true
			},
			nil,0)
	end
	if __lua_project_id == __lua_project_red_alert_time 
		or __lua_project_id == __lua_project_pacific_rim 
		then
		if self._choose_month_state ~= nil 
			and type(self._choose_month_state) == "userdata"
			and self._choose_month_state._datas ~= nil 
			and self._choose_month_state._datas._index ~= nil 
			and tonumber(self._choose_month_state._datas._index) == tonumber(self.example[2]) then
			state_machine.excute("recharge_list_button" , 0 , {
				_datas = 
				{ 
					_cell = self,
					listIndex = self.example[1],
					isMonthCard = self.example[13],
					extra = self.example[7],
					additional = self.example[14]
				}
			})
			self._choose_month_state = nil
		end
	end

end
function RechargeListCell:onEnterTransitionFinish()

end

function RechargeListCell:onInit()
	local csbRechargeListCell = csb.createNode("shop/shop_chongzhi_list.csb")
	local root = csbRechargeListCell:getChildByName("root")
    table.insert(self.roots, root)
	root:removeFromParent(false)
    self:addChild(root)
    	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		self:setContentSize(root:getContentSize())
	else
		if __lua_project_id == __lua_project_red_alert 
			or __lua_project_id == __lua_project_red_alert_time 
			or __lua_project_id == __lua_project_pacific_rim
			then
			self:setContentSize(root:getChildByName("Panel_20"):getContentSize())
		else
			self:setContentSize(root:getChildByName("Panel_2"):getContentSize())
		end
		-- 列表控件动画播放
		local action = csb.createTimeline("shop/shop_chongzhi_list.csb")
	    root:runAction(action)
	    action:play("list_view_cell_open", false)
	end
	self:upDataDraw()
	
end

function RechargeListCell:init(index,example,uiIndex,choose_month_state)
	self.index = index
	self.example = example
	self._choose_month_state = choose_month_state or nil
	self:onInit()
	if __lua_project_id == __lua_project_gragon_tiger_gate then
		self:setContentSize(cc.size(446,158))
	end
end


function RechargeListCell:createCell()
	local cell = RechargeListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function RechargeListCell:onExit()
end