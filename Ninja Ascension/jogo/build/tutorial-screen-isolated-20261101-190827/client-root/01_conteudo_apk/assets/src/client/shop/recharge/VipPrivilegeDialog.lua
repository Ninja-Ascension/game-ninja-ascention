-- ----------------------------------------------------------------------------------------------------
-- 说明：VIP权限查看界面
-- 创建时间2015-05-05
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
VipPrivilegeDialog = class("VipPrivilegeDialogClass", Window)

function VipPrivilegeDialog:ctor()
    self.super:ctor()
    self.roots = {}
	self.nowGrade = 0
	self.isSureBuy = false
	app.load("client.shop.recharge.VipPrivilegeListOne")
	app.load("client.shop.recharge.VipPrivilegeListTwo")
	app.load("client.shop.recharge.VipPrivilegeListThree")
    -- Initialize VipPrilige page state machine.
    local function init_VipPrilige_terminal()
		--关掉VIP界面
		local vip_privilege_return_recharge_terminal = {
            _name = "vip_privilege_return_recharge",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		--返回充值界面
		local vip_privilege_show_recharge_terminal = {
            _name = "vip_privilege_show_recharge",
            _init = function (terminal) 
                app.load("client.shop.recharge.RechargeDialog")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
	            	or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
	            	or __lua_project_id == __lua_project_l_naruto 
	            	then
		            if funOpenDrawTip(181) == true then
		                return
		            end
		        end
				fwin:close(instance)
				if fwin:find("RechargeDialogClass") == nil then
					local rechargeDialogWindow = RechargeDialog:new()
					rechargeDialogWindow:init(nil,1)
					fwin:open(rechargeDialogWindow, fwin._windows)
				else
					fwin:find("RechargeDialogClass"):setVisible(true)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--左
		local vip_privilege_to_left_terminal = {
            _name = "vip_privilege_to_left",
            _init = function (terminal) 
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				self.nowGrade = self.nowGrade - 1
				instance:onUpdateDraw2()
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
					or __lua_project_id == __lua_project_red_alert 
					or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
					then
					state_machine.excute("vip_privilege_to_update_buy_button",0,"")	
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--右
		local vip_privilege_to_right_terminal = {
            _name = "vip_privilege_to_right",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				self.nowGrade = self.nowGrade + 1
				instance:onUpdateDraw2()
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
					or __lua_project_id == __lua_project_red_alert 
					or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
					then
					state_machine.excute("vip_privilege_to_update_buy_button",0,"")	
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--前往商城礼包
		local vip_privilege_show_recharge_vip_shop_terminal = {
            _name = "vip_privilege_show_recharge_vip_shop",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
            		or __lua_project_id == __lua_project_red_alert 
            		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
            		then
            		if tonumber(_ED.vip_grade) < instance.nowGrade then
            			TipDlg.drawTextDailog(string.format(_string_piece_info[352],instance.nowGrade))
            			return
            		end
            		app.load("client.utils.ConfirmPrompted")
            		if instance.isSureBuy == false then
            			local _sale_price = _ED.return_vip_prop[instance.nowGrade+1].sale_price
            			local _ConfirmPrompted = ConfirmPrompted:new()
            			_ConfirmPrompted:init(instance,instance.sureToBuy,_sale_price,_ED.return_vip_prop[instance.nowGrade+1])
            			fwin:open(_ConfirmPrompted,fwin._windows)
            			return
            		end
            		instance.isSureBuy = false
            		local pack_id = 0
					for i, v in pairs(_ED.return_vip_prop) do
						if tonumber(v.prop_type) == 0 and tonumber(v.VIP_can_buy) <= tonumber(_ED.vip_grade) + 2 then
							if tonumber(v.VIP_can_buy) == instance.nowGrade then
								pack_id = v.shop_prop_instance
							end
						end
					end

					local function responseBuyVipPackCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							local function responseVIPShopViewCallBack()
								if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
									TipDlg.drawTextDailog(_string_piece_info[76])
									if response.node ~= nil and response.node.updateBuyButton ~= nil then
										response.node:updateBuyButton()
									end
								end
							end
							protocol_command.shop_view.param_list = "1"
							NetworkManager:register(protocol_command.shop_view.code, nil, nil, nil, response.node, responseVIPShopViewCallBack, false, nil)
						end
					end
					protocol_command.prop_purchase.param_list = pack_id .. "\r\n" .. 1 .. "\r\n" .. 1
					NetworkManager:register(protocol_command.prop_purchase.code, nil, nil, nil, instance, responseBuyVipPackCallback, false, nil)
            	else
					fwin:close(instance)
					fwin:close( fwin:find("RechargeDialogClass") )
					
					state_machine.excute("menu_manager", 0, 
					{
						_datas = {
							terminal_name = "menu_manager", 	
							next_terminal_name = "menu_show_shop", 			
							current_button_name = "Button_shop", 		
							but_image = "Image_shop", 		
							terminal_state = 0, 
							isPressedActionEnabled = true
						}
					}
					)
					state_machine.excute("shop_manager", 0, 
						{
							_datas = {
								terminal_name = "shop_manager",     
								next_terminal_name = "shop_vip_buy",
								current_button_name = "Button_packs",  
								but_image = "vip",      
								terminal_state = 0, 
								isPressedActionEnabled = true
							}
						}
					)
				end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
				--刷新按钮状态
		local vip_privilege_to_update_buy_button_terminal = {
            _name = "vip_privilege_to_update_buy_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:updateBuyButton()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(vip_privilege_show_recharge_vip_shop_terminal)	
		state_machine.add(vip_privilege_return_recharge_terminal)
		state_machine.add(vip_privilege_show_recharge_terminal)
		state_machine.add(vip_privilege_to_left_terminal)
		state_machine.add(vip_privilege_to_right_terminal)
		state_machine.add(vip_privilege_to_update_buy_button_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_VipPrilige_terminal()
end
function VipPrivilegeDialog:updateBuyButton()
	local root = self.roots[1]
	local Button_qianwang = ccui.Helper:seekWidgetByName(root, "Button_qianwang")
	Button_qianwang:setTouchEnabled(true)
	Button_qianwang:setBright(true)
	for i, v in pairs(_ED.return_vip_prop) do
		if tonumber(v.prop_type) == 0 and tonumber(v.VIP_can_buy) <= tonumber(_ED.vip_grade) + 2 then
			if tonumber(v.VIP_can_buy) == self.nowGrade then
				if tonumber(v.VIP_buy_times) - tonumber(v.buy_times) <= 0 then
					Button_qianwang:setTouchEnabled(false)
					Button_qianwang:setBright(false)
				end
				break
			end
		end
	end
end
function VipPrivilegeDialog:sureToBuy(sure_number)
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
		then
		if sure_number == 0 then
			self.isSureBuy = true
			state_machine.excute("vip_privilege_show_recharge_vip_shop",0,{_datas = 
			{
				terminal_name = "vip_privilege_show_recharge_vip_shop",      
				terminal_state = 0, 
				cell = self,
				isPressedActionEnabled = true
			}
			})

		end
	end
end
function VipPrivilegeDialog:onUpdateDraw2()
	local root = self.roots[1]
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_13")
	listView:removeAllItems()
	listView:requestRefreshView()
	local vipGradeThis = ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_1")
	vipGradeThis:setString(self.nowGrade)
	
	for i = 1 , 3 do
		if i == 1 then
			local cell = VipPrivilegeListOne:createCell()
			cell:init(self.nowGrade)
			listView:addChild(cell)
		elseif i == 2 then
			local cell = VipPrivilegeListTwo:createCell()
			cell:init(self.nowGrade)
			listView:addChild(cell)
		elseif i == 3 then
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
				or __lua_project_id == __lua_project_red_alert 
				or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
				or __lua_project_id == __lua_project_legendary_game 
				then	
			else
				if dms.searchs(dms["daily_instance_mould"], daily_instance_mould.need_viplevel, self.nowGrade) ~= nil then
					local cell = VipPrivilegeListThree:createCell()
					cell:init(self.nowGrade)
					listView:addChild(cell)
				end
			end
		end
	end
	listView:requestRefreshView()
	
	local  VipMaxGrade = 12
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
		then
		VipMaxGrade= tonumber(_vip_max_grade[1])
	end
	if self.nowGrade == 0 then
		ccui.Helper:seekWidgetByName(root, "Button_72860"):setBright(false)
		ccui.Helper:seekWidgetByName(root, "Button_72860"):setTouchEnabled(false)

		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
			or __lua_project_id == __lua_project_red_alert 
			or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
			or __lua_project_id == __lua_project_legendary_game 
			then	
			ccui.Helper:seekWidgetByName(root, "Panel_50_page_1"):setVisible(false)
		end
	elseif self.nowGrade == VipMaxGrade then
		ccui.Helper:seekWidgetByName(root, "Button_72861"):setBright(false)
		ccui.Helper:seekWidgetByName(root, "Button_72861"):setTouchEnabled(false)

		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
			or __lua_project_id == __lua_project_red_alert 
			or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
			or __lua_project_id == __lua_project_legendary_game 
			then	
			ccui.Helper:seekWidgetByName(root, "Panel_50_page_2"):setVisible(false)
		end
	else
		ccui.Helper:seekWidgetByName(root, "Button_72860"):setBright(true)
		ccui.Helper:seekWidgetByName(root, "Button_72861"):setBright(true)
		ccui.Helper:seekWidgetByName(root, "Button_72861"):setTouchEnabled(true)
		ccui.Helper:seekWidgetByName(root, "Button_72860"):setTouchEnabled(true)

		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
			or __lua_project_id == __lua_project_red_alert 
			or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
			or __lua_project_id == __lua_project_legendary_game 
			then	
			ccui.Helper:seekWidgetByName(root, "Panel_50_page_1"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Panel_50_page_2"):setVisible(true)
		end
	end
end

function VipPrivilegeDialog:onUpdateDraw()
	local root = self.roots[1]
	local vipGradeLabel = ccui.Helper:seekWidgetByName(root, "AtlasLabel_vip_01")
	local vipGradeThis = ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_1")
	local loadingBar = ccui.Helper:seekWidgetByName(root, "LoadingBar_1735")
	local loadingBarNum = ccui.Helper:seekWidgetByName(root, "Label_27019_1*")
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_13")
	local butLeft = ccui.Helper:seekWidgetByName(root, "Button_72860")
	local butrught = ccui.Helper:seekWidgetByName(root, "Button_72861")
	local label = ccui.Helper:seekWidgetByName(root, "Label_5")				--充值多少
	local labelTwo = ccui.Helper:seekWidgetByName(root, "Label_5_0")				--充值多少成为什么
	
	local VipGrade = _ED.vip_grade
	vipGradeLabel:setString(VipGrade)
	
	local _requestCount = {}
	for i=1,12 do
		_requestCount[i] = dms.int(dms["base_consume"], 8, (tonumber(base_consume.vip_0_value)+i-1))
		-- _requestCount[i] = dms.int(dms["base_consume"], 8, i+3)
	end
	
	local infor= ""
	if VipGrade == nil then
		infor = _ED.vip_grade
	else
		infor = VipGrade
	end
		
	-- 进度条
	local nowPress = tonumber(_ED.recharge_precious_number)
	local targetPress = ""
	if tonumber(infor) == 0 then
		targetPress = _requestCount[2]
	elseif tonumber(infor) == 1 then
		targetPress = _requestCount[3]
	elseif tonumber(infor) == 2 then
		targetPress = _requestCount[4]
	elseif tonumber(infor) == 3 then
		targetPress = _requestCount[5]
	elseif tonumber(infor) == 4 then
		targetPress = _requestCount[6]
	elseif tonumber(infor) == 5 then
		targetPress = _requestCount[7]
	elseif tonumber(infor) == 6 then
		targetPress = _requestCount[8]
	elseif tonumber(infor) == 7 then
		targetPress = _requestCount[9]
	elseif tonumber(infor) == 8 then
		targetPress = _requestCount[10]
	elseif tonumber(infor) == 9 then
		targetPress = _requestCount[11]
	elseif tonumber(infor) == 10 then
		targetPress = _requestCount[12]
	elseif tonumber(infor) == 11 then
		targetPress = _requestCount[13]
	elseif tonumber(infor) == 12 then
		targetPress = _requestCount[14]
	elseif tonumber(infor) == 13 then
		targetPress = _requestCount[15]
	elseif tonumber(infor) == 14 then
		targetPress = _requestCount[16]
	end
	
	local  VipMaxGrade = 12
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
		then
		VipMaxGrade= tonumber(_vip_max_grade[1])
	end

	if tonumber(infor) == VipMaxGrade then
		targetPress = _requestCount[tonumber(infor)]
	else
		targetPress = _requestCount[tonumber(infor)+1]
	end
	local enduranceCount = tonumber(nowPress)/tonumber(targetPress)*100
	if enduranceCount >100 then
		enduranceCount = 100
	end
	if enduranceCount < 0 then
		enduranceCount = 0
	end
	loadingBar:setPercent(enduranceCount)
	loadingBarNum:setString(nowPress.."/"..targetPress)
	
	
	if tonumber(VipGrade) == VipMaxGrade then
		label:setString(0)
		labelTwo:setString(_string_piece_info[228] .. "12")
		ccui.Helper:seekWidgetByName(root, "Label_recharge"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Image_2"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Label_recharge_0"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Label_5"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Label_5_0"):setVisible(false)
		loadingBar:setPercent(100)
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
			or __lua_project_id == __lua_project_red_alert 
			or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
			then
			loadingBarNum:setString(nowPress.."/"..targetPress)
		else
			loadingBarNum:setString(targetPress.."/"..targetPress)
		end
	else
		label:setString(tonumber(targetPress) - tonumber(nowPress))
		labelTwo:setString(_string_piece_info[228] .. tonumber(VipGrade)+1)
	end
	self.nowGrade = tonumber(_ED.vip_grade)
	vipGradeThis:setString(self.nowGrade)
	
	
	for i = 1 , 3 do
		if i == 1 then
			local cell = VipPrivilegeListOne:createCell()
			cell:init(self.nowGrade)
			listView:addChild(cell)
		elseif i == 2 then
			local cell = VipPrivilegeListTwo:createCell()
			cell:init(self.nowGrade)
			listView:addChild(cell)
		elseif i == 3 then
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
				or __lua_project_id == __lua_project_red_alert 
				or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
				or __lua_project_id == __lua_project_legendary_game 
				then	
			else
				if dms.searchs(dms["daily_instance_mould"], daily_instance_mould.need_viplevel, self.nowGrade) ~= nil then
					local cell = VipPrivilegeListThree:createCell()
					cell:init(self.nowGrade)
					listView:addChild(cell)
				end
			end
		end
	end
	listView:requestRefreshView()
	

	if self.nowGrade == 0 then
		ccui.Helper:seekWidgetByName(root, "Button_72860"):setBright(false)
		ccui.Helper:seekWidgetByName(root, "Button_72860"):setTouchEnabled(false)

		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
			or __lua_project_id == __lua_project_red_alert 
			or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
			or __lua_project_id == __lua_project_legendary_game 
			then	
			ccui.Helper:seekWidgetByName(root, "Panel_50_page_1"):setVisible(false)
		end
	elseif self.nowGrade == VipMaxGrade then
		ccui.Helper:seekWidgetByName(root, "Button_72861"):setBright(false)
		ccui.Helper:seekWidgetByName(root, "Button_72861"):setTouchEnabled(false)

		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
			or __lua_project_id == __lua_project_red_alert 
			or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
			or __lua_project_id == __lua_project_legendary_game 
			then	
			ccui.Helper:seekWidgetByName(root, "Panel_50_page_2"):setVisible(false)
		end
	else
		ccui.Helper:seekWidgetByName(root, "Button_72860"):setBright(true)
		ccui.Helper:seekWidgetByName(root, "Button_72861"):setBright(true)
		ccui.Helper:seekWidgetByName(root, "Button_72861"):setTouchEnabled(true)
		ccui.Helper:seekWidgetByName(root, "Button_72860"):setTouchEnabled(true)
		
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
			or __lua_project_id == __lua_project_red_alert 
			or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
			or __lua_project_id == __lua_project_legendary_game 
			then	
			ccui.Helper:seekWidgetByName(root, "Panel_50_page_1"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Panel_50_page_2"):setVisible(true)
		end
	end
end

function VipPrivilegeDialog:onEnterTransitionFinish()
	local csbVipPrilige = csb.createNode("player/vip_privileges.csb")
    self:addChild(csbVipPrilige)
	local action = csb.createTimeline("player/vip_privileges.csb")
    csbVipPrilige:runAction(action)
	action:play("window_open", false)
	
	local root = csbVipPrilige:getChildByName("root")
	table.insert(self.roots, root)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, {func_string = [[state_machine.excute("vip_privilege_return_recharge", 0, "click vip_privilege_return_recharge.'")]],isPressedActionEnabled = true}, nil, 2)

	local chongzhi = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, {func_string = [[state_machine.excute("vip_privilege_show_recharge", 0, "click vip_privilege_show_recharge.'")]],isPressedActionEnabled = true}, nil, 0)
	local left = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_72860"), nil, {func_string = [[state_machine.excute("vip_privilege_to_left", 0, "click vip_privilege_to_left.'")]],isPressedActionEnabled = true}, nil, 0)
	local right = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_72861"), nil, {func_string = [[state_machine.excute("vip_privilege_to_right", 0, "click vip_privilege_to_right.'")]],isPressedActionEnabled = true}, nil, 0)
	self:onUpdateDraw()
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
		then
		-- 前往的事件响应
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_qianwang"),       nil, 
		{
			terminal_name = "vip_privilege_show_recharge_vip_shop",      
			terminal_state = 0, 
			cell = self,
			isPressedActionEnabled = true
		}, 
		nil, 0)
		self:updateBuyButton()
	end
end

function VipPrivilegeDialog:onExit()
	state_machine.remove("vip_privilege_show_recharge_vip_shop")	
	state_machine.remove("vip_privilege_return_recharge")
	state_machine.remove("vip_privilege_show_recharge")
	state_machine.remove("vip_privilege_to_right")
	state_machine.remove("vip_privilege_to_left")
	state_machine.remove("vip_privilege_to_update_buy_button")
end
