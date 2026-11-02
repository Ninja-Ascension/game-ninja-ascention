----------------------------------------------------------------------------------------------------
-- 说明：
----------------------------------------------------------------------------------------------------
PropListCell = class("PropListCellClass", Window)
PropListCell.__size = nil

function PropListCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.actions = {}
	self.prop = nil		-- 当前要绘制的道具实例数据对对象
	self.drawIndex = 0  -- 绘图的索引
	self.inited = false
	self._duration = 0
	self._elapsed = 0
	self.user_count = "1"
	self.enum_type = {

	}

	app.load("client.cells.prop.prop_icon_new_cell")
	app.load("client.utils.ConfirmTip")

	
	-- 初始化道具小图标事件响应需要使用的状态机
	local function init_prop_list_cell_terminal()
		--使用按钮的点击
		local prop_list_cellprop_use_manager_terminal = {
            _name = "prop_list_cell_prop_use_manager",
            _init = function (terminal) 
                -- app.load("client.cells.prop.prop_list_cell")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local prop_list_cellprop_to_hero_storage_terminal = {
            _name = "prop_list_cellprop_to_hero_storage",
            _init = function (terminal) 
                -- app.load("client.cells.prop.prop_list_cell")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:cleanView(fwin._view) 
				fwin:close(instance)				
				state_machine.excute("menu_clean_page_state", 0,"") 
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					if fwin:find("HeroStorageClass") ~= nil then
						fwin:close(fwin:find("HeroStorageClass"))
					end
				end				
				fwin:open(HeroStorage:new(), fwin._view) 
				state_machine.excute("hero_storage_manager", 0, 
					{
						_datas = {
							terminal_name = "hero_storage_manager", 	
							next_terminal_name = "hero_storage_show_hero_storage_list",	
							current_button_name = "Button_equipment",  	
							but_image = "", 	
							terminal_state = 0, 
							isPressedActionEnabled = false
						}
					}
				)
				
				state_machine.excute("menu_change_button_state", 0,
					{
						_datas = {
							buttonName = "Button_home"
						}
					}
				) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local prop_list_cellprop_to_equip_storage_terminal = {
            _name = "prop_list_cellprop_to_equip_storage",
            _init = function (terminal) 
                -- app.load("client.cells.prop.prop_list_cell")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					state_machine.excute("prop_storage_manager",0,
					{
					_datas = {
								terminal_name = "prop_storage_manager", 	
								next_terminal_name = "prop_equip_show_list", 			
								current_button_name = "Button_zhuangbei",
								but_image = "",         
								terminal_state = 0, 
								isPressedActionEnabled = false								
							 }
					}
					)
				else
					fwin:cleanView(fwin._view) 
					fwin:close(instance)				
					state_machine.excute("menu_clean_page_state", 0,"") 
					fwin:open(EquipStorage:new(), fwin._view)
					
					state_machine.excute("menu_change_button_state", 0,
						{
							_datas = {
								buttonName = "Button_home"
							}
						}
					) 
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local prop_list_cellprop_to_treasure_storage_terminal = {
            _name = "prop_list_cellprop_to_treasure_storage",
            _init = function (terminal) 
                -- app.load("client.cells.prop.prop_list_cell")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 

				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					state_machine.excute("prop_storage_manager",0,
					{
					_datas = {
								terminal_name = "prop_storage_manager", 	
								next_terminal_name = "prop_treasure_show_list", 			
								current_button_name = "Button_xinfa",
								but_image = "",         
								terminal_state = 0, 
								isPressedActionEnabled = false
						     }
					}
					)
				else
					fwin:cleanView(fwin._view) 
					fwin:close(instance)				
					state_machine.excute("menu_clean_page_state", 0,"") 
					fwin:open(TreasureStorage:new(), fwin._view) 
					state_machine.excute("menu_change_button_state", 0,
						{
							_datas = {
								buttonName = "Button_home"
							}
						}
					) 
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local prop_list_cellprop_to_mingxing_terminal = {
            _name = "prop_list_cellprop_to_mingxing",
            _init = function (terminal) 
                app.load("client.destiny.DestinySystem")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					state_machine.excute("home_goto_destiny_system", 0, {_datas = {
						next_terminal_name = "menu_change_button_state",
						cell = params._datas._cell,
						next_params = {
							_datas = {
								buttonName = "Button_home"
							}
						}
					}})					
				else
					state_machine.excute("home_goto_destiny_system", 0, {_datas = {
						next_terminal_name = "menu_change_button_state",
						next_params = {
							_datas = {
								buttonName = "Button_home"
							}
						}
					}})
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local prop_list_cellprop_to_factroy_terminal = {
            _name = "prop_list_cellprop_to_factroy",
            _init = function (terminal) 
                app.load("client.destiny.DestinySystem")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
           		if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh) then
           		else
					fwin:cleanView(fwin._view) 
					fwin:close(instance)				
           		end
				local function recruitCallBack(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							state_machine.excute("menu_change_button_state", 0,
								{
									_datas = {
										buttonName = "Button_home"
									}
								}
							) 
							app.load("client.shop.hero.HeroShop")
							state_machine.excute("menu_clean_page_state", 0,"") 
							if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
								or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh) then
								fwin:cleanView(fwin._view) 
								fwin:close(instance)				
			           		end
							fwin:open(HeroShop:new(), fwin._view) 
						end
					end
				
					protocol_command.secret_shop_init.param_list = "".._ED.user_info.user_id
					NetworkManager:register(protocol_command.secret_shop_init.code, nil, nil, nil, nil, recruitCallBack, false, nil) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local prop_list_cellprop_to_zhaojiang_terminal = {
            _name = "prop_list_cellprop_to_zhaojiang",
            _init = function (terminal) 
                app.load("client.destiny.DestinySystem")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				fwin:cleanView(fwin._view) 
				state_machine.excute("menu_clean_page_state", 0,"") 
				fwin:close(instance)
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					local _shop = Shop:new()
					_shop:init(1)
					fwin:open(_shop, fwin._view)
					state_machine.excute("shop_manager", 0, 
						{
							_datas = {
								terminal_name = "shop_manager", 	
								next_terminal_name = "shop_ship_recruit",
								current_button_name = "Button_tavern", 	
								but_image = "recruit", 		
								terminal_state = 0, 
								shop_type = "zhaomu",
								isPressedActionEnabled = true
							}
						}
					)
				else			
					fwin:open(Shop:new(), fwin._view)
					state_machine.excute("shop_manager", 0, 
						{
							_datas = {
								terminal_name = "shop_manager", 	
								next_terminal_name = "shop_ship_recruit",
								current_button_name = "Button_tavern", 	
								but_image = "recruit", 		
								terminal_state = 0, 
								isPressedActionEnabled = true
							}
						}
					)
				end
				state_machine.excute("menu_change_button_state", 0,
					{
						_datas = {
							buttonName = "Button_shop"
						}
					}
				) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local prop_list_cellprop_update_num_terminal = {
            _name = "prop_list_cellprop_update_num",
            _init = function (terminal) 
                -- app.load("client.cells.prop.prop_list_cell")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				params[2]:updateDrawCount2(params[1])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		local prop_list_cell_request_prop_use_checkup_terminal = {
            _name = "prop_list_cell_request_prop_use_checkup",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local tempCell = params._datas._cell
				
				if tempCell~=nil and tempCell.roots ~= nil then
					tempCell:checkup()
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
			
		local prop_list_cell_request_prop_use_clean_terminal = {
            _name = "prop_list_cell_request_prop_use_clean",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local tempCell = params._datas._cell
				if nil == tempCell then
					return 
				end
				
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					state_machine.excute("prop_page_reload_list_view_cell", 0, "prop_page_reload_list_view_cell.")
				else
					if zstring.tonumber(tempCell.prop.prop_number) <= 0 then
						state_machine.excute("prop_page_remove_list_view_cell", 0, {_datas = {_id = tempCell.prop.user_prop_template}})
					else
						tempCell:updateDrawCount()
					end
					state_machine.excute("prop_page_check_list_view_num_cell", 0, "prop_page_check_list_view_num_cell.") 
					state_machine.excute("prop_page_add_list_view_cell", 0, "prop_page_add_list_view_cell.")
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		local prop_list_cell_request_prop_use_terminal = {
            _name = "prop_list_cell_request_prop_use",
            _init = function (terminal) 
                -- app.load("client.cells.prop.prop_list_cell")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local tempCell = params._datas._cell
				local prop_type = tempCell.prop.prop_type
				local user_prop_template = tempCell.prop.user_prop_template
				local function responseUsePropCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then  --网络连接判断
						if response.node == nil or response.node.roots == nil then 
							return
						end
						local prop_type = zstring.tonumber(prop_type)
						--debug.print_r(_ED.show_reward_list_group)
						local rewardList = getSceneReward(4)--获取奖励物品实例
						--print("rewardList", rewardList)

						-- 解析出当前获得物品 凡是模板id 为 -1 的都提示文字信息,否则提示获得物品图片
						
						local rlen = #rewardList.show_reward_list
						local isConsume = false -- 弹药/燃料/出击令/免战大小
						
						-- 弹药/燃料/出击令/免战大小
						--local dy = getRewardItemWithType(rewardList, 12)
						
						-- 检查是否消耗品
						if rlen == 1 then
							isConsume = true
							local config = zstring.split(dms.string(dms["pirates_config"], 273, pirates_config.param), ",")
							local bigAvoidTemplateId =  tonumber(config[12]) -- 大免
							local smallAvoidTemplateId =  tonumber(config[11]) -- 小免
							local toAttackTemplateId =  tonumber(config[17]) -- 出击令
							local fuelTemplateId =  tonumber(config[15]) -- 燃料 体力丹
							local ammoTemplateId =  tonumber(config[16]) -- 弹药 ,耐力丹
							local shendanId = tonumber(config[18])
							local propName = dms.string(dms["prop_mould"], user_prop_template, prop_mould.prop_name)
							if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
						        propName = setThePropsIcon(user_prop_template)[2]
						    end
							local propMsg = dms.string(dms["prop_mould"], user_prop_template, prop_mould.remarks)
							if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
								propMsg = drawPropsDescription(user_prop_template)
							end
							--local propremark = dms.string(dms["prop_mould"],tempCell.prop.user_prop_template, prop_mould.remarks)
							local useTipStr = string.format(tipStringInfo_prop_buy_tip[3], propName)
							if smallAvoidTemplateId == tonumber(user_prop_template) or
								bigAvoidTemplateId == tonumber(user_prop_template) then
								local str = string.format(tipStringInfo_prop_buy_tip[3], propName)
								if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
									TipDlg.drawTextDailog(useTipStr)
								else
									TipDlg.drawTextDailog(propMsg)
								end
							elseif toAttackTemplateId == tonumber(user_prop_template) then
								TipDlg.drawTextDailog(tipStringInfo_prop_buy[17][2])
							elseif fuelTemplateId == tonumber(user_prop_template) then
								if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
									TipDlg.drawTextDailog(useTipStr)
								else
									TipDlg.drawTextDailog(propMsg)
								end
							elseif ammoTemplateId == tonumber(user_prop_template) then
								if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
									TipDlg.drawTextDailog(useTipStr)
								else
									TipDlg.drawTextDailog(propMsg)
								end
							elseif shendanId == tonumber(user_prop_template) then
								if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
									TipDlg.drawTextDailog(useTipStr)
								end
							else
								--TipDlg.drawTextDailog(_string_piece_info[149])
								isConsume = false
							end
						end
						
						if isConsume == false then
							local text = ""									--提示信息
							if rewardList ~= nil then
								-- if tonumber(prop_type) == 2 or prop_type == 3 or prop_type == 4 then
									-- for i, v in pairs(rewardType.show_reward_list) do
										-- local rewardPropType = tonumber(v.prop_type)		--获取物品类型
										-- if   rewardPropType == 1 
											-- or rewardPropType == 2 
											-- or rewardPropType == 3 
											-- or rewardPropType == 4 
											-- or rewardPropType == 6 
											-- or rewardPropType == 7 
											-- or rewardPropType == 9
											-- or rewardPropType == 10
											-- or rewardPropType == 11
											-- or rewardPropType == 12
											-- or rewardPropType == 13
											-- then
											-- app.load( "client.packs.prop.PropuseInformation")
											-- local propuseInformationWindow = PropuseInformation:new()
											-- propuseInformationWindow:init(rewardType)
											-- fwin:open(propuseInformationWindow, fwin._view)
										-- end
									-- end
									app.load("client.reward.DrawRareReward")
									local getRewardWnd = DrawRareReward:new()
									getRewardWnd:init(nil, rewardList)
									fwin:open(getRewardWnd,fwin._ui)
								-- else
									-- for i, v in pairs(rewardType.show_reward_list) do
										-- local rewardPropType = tonumber(v.prop_type)		--获取物品类型
										-- if rewardPropType == 1 then				-- 物品1类型(1:资金 2:水晶 3:声望 4:钢魂 5:秘银 8:经验 9:燃料 10:功能点 11:上阵人数 12:能量
											-- text = text.."\r\n"
											-- text = _string_piece_info[148]..v.item_value.._All_tip_string_info._fundName
											-- TipDlg.drawTextDailog(text)
										-- elseif 	rewardPropType == 2 then	
											-- text = text.."\r\n"
											-- text = _string_piece_info[148]..v.item_value.._All_tip_string_info._crystalName
											-- TipDlg.drawTextDailog(text)
										-- elseif 	rewardPropType == 3 then	
											-- text = text.."\r\n"
											-- text = _string_piece_info[148]..v.item_value.._All_tip_string_info._reputation
											-- TipDlg.drawTextDailog(text)
										-- elseif 	rewardPropType == 4 then	
											-- text = text.."\r\n"
											-- text = _string_piece_info[148]..v.item_value.._All_tip_string_info._steelSoulName
											-- TipDlg.drawTextDailog(text)
										-- elseif 	rewardPropType == 5 then	
											-- text = text.."\r\n"
											-- text = _string_piece_info[148]..v.item_value.._All_tip_string_info._soulJadeName
											-- TipDlg.drawTextDailog(text)					
										-- elseif 	rewardPropType == 8 then	
											-- text = text.."\r\n"
											-- text = _string_piece_info[148]..v.item_value.._All_tip_string_info._expName
											-- TipDlg.drawTextDailog(text)
										-- elseif 	rewardPropType == 9 then	
											-- text = text.."\r\n"
											-- text = _string_piece_info[148]..v.item_value.._string_piece_info[156].._All_tip_string_info._fuelName
											-- TipDlg.drawTextDailog(text)
										-- elseif 	rewardPropType == 10 then	
											-- text = text.."\r\n"
											-- text = _string_piece_info[154]
											-- TipDlg.drawTextDailog(text)
										-- elseif 	rewardPropType == 11 then	
											-- text = text.."\r\n"
											-- text = _string_piece_info[155]
											-- TipDlg.drawTextDailog(text)	
										-- elseif 	rewardPropType == 12 then	
											-- text = text.."\r\n"
											-- text = _string_piece_info[148]..v.item_value.._string_piece_info[156].._All_tip_string_info._energyName
											-- TipDlg.drawTextDailog(text)		
										-- end
									-- end
								-- end
							else
								
								
					
								
							end	
							
						end
						

						if zstring.tonumber(response.node.prop.prop_number) <= 0 then
							if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
								state_machine.excute("prop_page_reload_list_view_cell", 0, "prop_page_reload_list_view_cell.")
							else
								state_machine.excute("prop_page_remove_list_view_cell", 0, {_datas = {_id = response.node.prop.user_prop_template}})
							end
						else
							response.node:updateDrawCount()
						end
						
						state_machine.excute("prop_page_check_list_view_num_cell", 0, "prop_page_check_list_view_num_cell.") 
						state_machine.excute("prop_page_add_list_view_cell", 0, "prop_page_add_list_view_cell.")

						if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
							for i,v in pairs(can_get_some_equip_patch) do
								if tonumber(user_prop_template) == v then
									state_machine.excute("equip_patch_onupdate_all",0,"")
									break
								end
							end
						end
					end
				end
				--向服务器发送请求
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					if TipDlg.drawStorageTipo() == true then
						return
					end
				end
				protocol_command.prop_use.param_list = tempCell.prop.user_prop_id.."\r\n" .. tempCell.user_count
				NetworkManager:register(protocol_command.prop_use.code, nil, nil, nil, tempCell, responseUsePropCallback,false, nil)
				
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --单个刷新
		local prop_list_cell_request_prop_update_count_terminal = {
            _name = "prop_list_cell_request_prop_update_count",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local tempCell = params
				if nil == tempCell then
					return 
				end
				if zstring.tonumber(tempCell.prop.prop_number) <= 0 then
					state_machine.excute("prop_page_reload_list_view_cell", 0, "prop_page_reload_list_view_cell.")
				else
					tempCell:updateDrawCount()
				end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        --分解
		local prop_list_cellprop_to_resolve_terminal = {
            _name = "prop_list_cellprop_to_resolve",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local tempCell = params._datas._cell

				if nil == tempCell then
					return 
				end
				app.load("client.packs.hero.AwakenResolvePropTip")
				local windows = AwakenResolvePropTip:createCell()
				windows:init(tempCell.prop.user_prop_id,tempCell.prop.user_prop_template,tempCell)
				fwin:open(windows, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --分解刷新
		local awaken_list_cell_request_resolve_clean_terminal = {
            _name = "awaken_list_cell_request_resolve_clean",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas._cell
            	if cell ~= nil then 
            		cell:updateDrawCount3()
            	else
            	end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --宠物仓库
		local prop_list_cellprop_to_pet_list_terminal = {
            _name = "prop_list_cellprop_to_pet_list",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local level = dms.int(dms["fun_open_condition"],54,fun_open_condition.level)
            	if level > tonumber(_ED.user_info.user_grade) then 
            		local text = dms.string(dms["fun_open_condition"],54, fun_open_condition.tip_info)
                	TipDlg.drawTextDailog(text)
            		return
            	end
            	fwin:cleanView(fwin._view) 
				fwin:close(instance)				
				state_machine.excute("menu_clean_page_state", 0,"") 
				app.load("client.packs.pet.PetStorage")     
				fwin:open(PetStorage:new(), fwin._view) 
				state_machine.excute("pet_storage_manager", 0, 
                {
                    _datas = {
                        terminal_name = "pet_storage_manager",     
                        next_terminal_name = "pet_storage_show_pet_list", 
                        current_button_name = "Button_zhanchong",   
                        but_image = "",     
                        terminal_state = 0, 
                        isPressedActionEnabled = false
                    }
                })
				
				state_machine.excute("menu_change_button_state", 0,
					{
						_datas = {
							buttonName = "Button_home"
						}
					}
				) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(prop_list_cell_request_prop_use_clean_terminal)
		state_machine.add(prop_list_cell_request_prop_use_checkup_terminal)
		state_machine.add(prop_list_cellprop_use_manager_terminal)
		state_machine.add(prop_list_cellprop_to_hero_storage_terminal)
		state_machine.add(prop_list_cellprop_to_equip_storage_terminal)
		state_machine.add(prop_list_cellprop_to_treasure_storage_terminal)
		state_machine.add(prop_list_cellprop_update_num_terminal)
		state_machine.add(prop_list_cellprop_to_mingxing_terminal)
		state_machine.add(prop_list_cellprop_to_zhaojiang_terminal)
		state_machine.add(prop_list_cellprop_to_factroy_terminal)
		state_machine.add(prop_list_cell_request_prop_use_terminal)
		state_machine.add(prop_list_cell_request_prop_update_count_terminal)	
		state_machine.add(prop_list_cellprop_to_resolve_terminal)
		state_machine.add(awaken_list_cell_request_resolve_clean_terminal)
		state_machine.add(prop_list_cellprop_to_pet_list_terminal)
        state_machine.init()
	end
	init_prop_list_cell_terminal()
end

function PropListCell:updateDrawCount()
	local root = self.roots[1]
	if root == nil then
		return
	end
	--道具数量
	local Text_2 = ccui.Helper:seekWidgetByName(root, "Text_2")
	Text_2:setString(_string_piece_info[4]..":"..self.prop.prop_number)
end

function PropListCell:updateDrawCount2(prop_number)
	local root = self.roots[1]
	if root == nil then
		return
	end
	--道具数量
	local Text_2 = ccui.Helper:seekWidgetByName(root, "Text_2")
	Text_2:setString(_string_piece_info[4]..":"..prop_number)
end

function PropListCell:updateDrawCount3()
	local root = self.roots[1]
	if root == nil then
		return
	end
	--道具数量
	local propNumber = nil
	for i, v in pairs(_ED.user_prop) do
		if tonumber(v.user_prop_template) == tonumber(self.prop.user_prop_template) then
			propNumber = v.prop_number
			break
		end
	end
	if propNumber == nil then 
		--没有了要删除
		state_machine.excute("awaken_page_remove_list_view_cell", 0, {_datas = {_id = self.prop.user_prop_template}})
	else
		local Text_2 = ccui.Helper:seekWidgetByName(root, "Text_2")
		Text_2:setString(_string_piece_info[4]..":"..propNumber)
	end
	
end

function PropListCell:updateDrawCountMID()
	
	self:updateDrawCount2(getPropAllCountByMouldId(self.prop.user_prop_template))

end

function PropListCell:onUpdateDraw()
	local root = self.roots[1]
	local iconCell = PropIconNewCell:createCell()
	iconCell:init(self.current_type, self.prop)
	-- 道具头像
	local iconPanel = ccui.Helper:seekWidgetByName(root, "Panel_props")
	iconPanel:removeAllChildren(true)
	iconPanel:addChild(iconCell)

	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "ImageView_bg_1"), nil, 
		{
			terminal_name = "prop_new_head_manager", 
			terminal_state = 0, 
			_prop = self.prop
		}, 
		nil, 0)
	end
	
	--道具数量
	self:updateDrawCount()
	
	 --道具名称
	local prop_name = ccui.Helper:seekWidgetByName(root, "Label_717_0")
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        prop_name:setString(setThePropsIcon(self.prop.user_prop_template)[2])
    else
    	prop_name:setString(dms.string(dms["prop_mould"], self.prop.user_prop_template, prop_mould.prop_name))
    end
	local colortype = dms.string(dms["prop_mould"],self.prop.user_prop_template,prop_mould.prop_quality)
	prop_name:setColor(cc.c3b(color_Type[colortype+1][1],color_Type[colortype+1][2],color_Type[colortype+1][3]))
	
	--道具描述
	local prop_content= ccui.Helper:seekWidgetByName(root, "Label_property")
	local propremark = dms.string(dms["prop_mould"],self.prop.user_prop_template,prop_mould.remarks)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		propremark = drawPropsDescription(self.prop.user_prop_template)
	end
	prop_content:setString(propremark)
end

-- 返回格式化时间,参数是秒
function PropListCell:formatTime(second)
	local timeTabel = {}
	local day = 0
	local hour = math.floor(tonumber(second)/3600)
	local minute = math.floor((tonumber(second)%3600)/60)
	local second = math.ceil(tonumber(second)%60)
	if second == 60 then
		second = 0
		minute = minute + 1
	end
	if minute == 60 then
		minute = 0
		hour = hour + 1
	end
	
	if hour < 10 then
		hour = "0"..hour
	end
	
	if minute < 10 then
		minute = "0"..minute
	end
	
	if second < 10 then
		second = "0"..second
	end
	local str = hour..":"..minute..":"..second
	return str
end

function PropListCell:showConfirmTip(n)
	if n == 0 then
		-- yes
		state_machine.excute("prop_list_cell_request_prop_use", 0, {_datas ={_cell = self}})
	else
		-- no
	end
end

function PropListCell:checkup()
	local config = zstring.split(dms.string(dms["pirates_config"], 273, pirates_config.param), ",")
	local bigAvoidTemplateId =  tonumber(config[12])
	local smallAvoidTemplateId =  tonumber(config[11])
	if smallAvoidTemplateId == tonumber(self.prop.user_prop_template) or bigAvoidTemplateId == tonumber(self.prop.user_prop_template) then
		local timer = getAvoidFightTime()
		if timer > 0 then
			local tip = ConfirmTip:new()
			tip:init(self, self.showConfirmTip, string.format(tipStringInfo_plunder[8], self:formatTime(timer/1000)))
			fwin:open(tip,fwin._ui)
			return
		end
	end
	if dms.int(dms["prop_mould"], self.prop.user_prop_template, prop_mould.props_type) == 7 then
		app.load("client.reward.BigBoxRewad")
		local win = BigBoxRewad:new()
		win:init(self.prop.user_prop_template, self)
		fwin:open(win, fwin._windows)
		return
	end
	
	self:showConfirmTip(0)
end

function PropListCell:onEnterTransitionFinish()

end

function PropListCell:onUpdate(dt)
	self._elapsed = self._elapsed + dt
	if self._elapsed >= self._duration then
		-- self:onInit()

		if self.actions[1] ~= nil then
			local action = self.actions[1]
			action:play("list_view_cell_open", false)
		end

		self:unregisterOnNoteUpdate(self)
	end
end

function PropListCell:onInit()
	-- if self.inited == true then
	-- 	return
	-- end
	-- self.inited = true
	-- local csbItem = csb.createNode("list/list_property_1.csb")
	-- local root = csbItem:getChildByName("root")
	-- root:removeFromParent(false)
	-- self:addChild(root)
	-- table.insert(self.roots, root)

	local root = cacher.createUIRef("list/list_property_1.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)
	
	-- 列表控件动画播放
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	else
		local action = csb.createTimeline("list/list_property_1.csb")
	    root:runAction(action)
	    action:play("list_view_cell_open", false)
	end

	if PropListCell.__size == nil then
		local Panel_generals_equipment = ccui.Helper:seekWidgetByName(root, "Panel_generals_equipment")
		local Panel_generals_equipmentSize = Panel_generals_equipment:getContentSize()
		-- self:setContentSize(Panel_generals_equipmentSize)
		PropListCell.__size = Panel_generals_equipmentSize -- cc.size(Panel_generals_equipmentSize.width, Panel_generals_equipmentSize.height)
	end
	
	--使用按钮的点击
	
	-- 使用类型（客户端判断）
	-- 使用后：
	-- 0直接消耗   Panel_button_3 
	-- 1跳转到【三国志】(去命星)
	-- 2跳转到【武将】(使用,天命)
	-- 3跳转到【武将】(去觉醒)	  Panel_button_11
	-- 4跳转到【武将】(去培养)    Panel_button_6
	-- 5跳转到【武将】(去突破)	  Panel_button_7
	-- 6跳转到【宝物】(宝物精炼)  Panel_button_4
	-- 7跳转到【装备】(去精炼)    Panel_button_5
	-- 8跳转到【战将招募】(去招将) Panel_button_12
	-- 9跳转到【神将招募】(去招将)
	-- 10跳转到【神将商店】(神将商店)
	-- 11道具 觉醒道具
	-- 12公会贡献
	-- 13 宠物列表
	-- 14 宠物强化
	-- 15 宠物去驯养
	ccui.Helper:seekWidgetByName(root, "Panel_button_3"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Panel_button_9"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Panel_button_3"):setVisible(false)  
	ccui.Helper:seekWidgetByName(root, "Panel_button_11"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Panel_button_6"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Panel_button_7"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Panel_button_4"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Panel_button_5"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Panel_button_12"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Panel_button_13"):setVisible(false)
	local Panel_button_14 = ccui.Helper:seekWidgetByName(root, "Panel_button_14")
	local Panel_button_15 = ccui.Helper:seekWidgetByName(root, "Panel_button_15")
	local Panel_button_16 = ccui.Helper:seekWidgetByName(root, "Panel_button_16")
	local Panel_button_17 = ccui.Helper:seekWidgetByName(root, "Panel_button_17")
	if Panel_button_14 ~= nil then 
		Panel_button_14:setVisible(false)
	end
	if Panel_button_15 ~= nil then 
		Panel_button_15:setVisible(false)
	end
	if Panel_button_16 ~= nil then 
		Panel_button_16:setVisible(false)
	end
	if Panel_button_17 ~= nil then 
		Panel_button_17:setVisible(false)
	end

	--Panel_button_8 去抽卡
	--道具按钮显示
	local bEnable = dms.int(dms["prop_mould"], self.prop.user_prop_template, prop_mould.use_type)
	if bEnable == 0 then

		
		ccui.Helper:seekWidgetByName(root, "Panel_button_3"):setVisible(true)
		-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_use"), nil, 
		-- {
			-- terminal_name = "prop_list_cell_request_prop_use", 	
			-- next_terminal_name = "prop_list_cell_request_prop_use", 			
			-- current_button_name = "Button_use", 		
			-- but_image = "", 	
			-- _cell = self,
			-- terminal_state = 0, 
			-- isPressedActionEnabled = true
		-- }, 
		-- nil, 0)
		
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_use"), nil, 
		{
			terminal_name = "prop_list_cell_request_prop_use_checkup", 	
			next_terminal_name = "prop_list_cell_request_prop_use_checkup", 			
			current_button_name = "Button_use", 		
			but_image = "", 	
			_cell = self,
			terminal_state = 0, 
			isPressedActionEnabled = true
		}, 
		nil, 0)
		
	elseif bEnable == 1 then
		ccui.Helper:seekWidgetByName(root, "Panel_button_9"):setVisible(true)
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_mingxing"), nil, 
			{
				terminal_name ="prop_list_cellprop_to_mingxing",
				_cell = self,
				isPressedActionEnabled = true
			}, nil, 0)
		else
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_mingxing"), nil, 
			{
				func_string = [[state_machine.excute("prop_list_cellprop_to_mingxing", 0, "prop_list_cellprop_to_mingxing.'")]],
				isPressedActionEnabled = true
			}, nil, 0)
		end
	elseif bEnable == 2 then
		ccui.Helper:seekWidgetByName(root, "Panel_button_3"):setVisible(true)  
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_use"), nil, 
		{
			func_string = [[state_machine.excute("prop_list_cellprop_to_hero_storage", 0, "prop_list_cellprop_to_hero_storage.'")]],
			isPressedActionEnabled = true
		}, nil, 0)
	elseif bEnable == 3 then
		ccui.Helper:seekWidgetByName(root, "Panel_button_11"):setVisible(true)
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_juexing"), nil, 
		{
			func_string = [[state_machine.excute("prop_list_cellprop_to_hero_storage", 0, "prop_list_cellprop_to_hero_storage.'")]],
			isPressedActionEnabled = true
		}, nil, 0)
	elseif bEnable == 4 then
		ccui.Helper:seekWidgetByName(root, "Panel_button_6"):setVisible(true)
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cultivate"), nil, 
		{
			func_string = [[state_machine.excute("prop_list_cellprop_to_hero_storage", 0, "prop_list_cellprop_to_hero_storage.'")]],
			isPressedActionEnabled = true
		}, nil, 0)
	elseif bEnable == 5 then
		ccui.Helper:seekWidgetByName(root, "Panel_button_7"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Panel_button_6"):setVisible(true)
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_break_through"), nil, 
		{
			func_string = [[state_machine.excute("prop_list_cellprop_to_hero_storage", 0, "prop_list_cellprop_to_hero_storage.'")]],
			isPressedActionEnabled = true
		}, nil, 0)
	elseif bEnable == 6 then
		ccui.Helper:seekWidgetByName(root, "Panel_button_4"):setVisible(true)
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_treasure"), nil, 
		{
			func_string = [[state_machine.excute("prop_list_cellprop_to_treasure_storage", 0, "prop_list_cellprop_to_treasure_storage.'")]],
			isPressedActionEnabled = true
		}, nil, 0)
	elseif bEnable == 7 then
		ccui.Helper:seekWidgetByName(root, "Panel_button_5"):setVisible(true)
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_refine"), nil, 
		{
			func_string = [[state_machine.excute("prop_list_cellprop_to_equip_storage", 0, "prop_list_cellprop_to_equip_storage.'")]],
			isPressedActionEnabled = true
		}, nil, 0)
	elseif bEnable == 8 then
		ccui.Helper:seekWidgetByName(root, "Panel_button_12"):setVisible(true)
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zhaojiang"), nil, 
		{
			func_string = [[state_machine.excute("prop_list_cellprop_to_zhaojiang", 0, "prop_list_cellprop_to_zhaojiang.'")]],
			isPressedActionEnabled = true
		}, nil, 0)
	elseif bEnable == 9 then
		ccui.Helper:seekWidgetByName(root, "Panel_button_12"):setVisible(true)
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zhaojiang"), nil, 
		{
			func_string = [[state_machine.excute("prop_list_cellprop_to_zhaojiang", 0, "prop_list_cellprop_to_zhaojiang.'")]],
			isPressedActionEnabled = true
		}, nil, 0)
	elseif bEnable == 10 then
		ccui.Helper:seekWidgetByName(root, "Panel_button_13"):setVisible(true)
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sjsd001"), nil, 
		{
			func_string = [[state_machine.excute("prop_list_cellprop_to_factroy", 0, "prop_list_cellprop_to_factroy.'")]],
			isPressedActionEnabled = true
		}, nil, 0)
	elseif bEnable == 11 then
		
		local Panel_button_14 = ccui.Helper:seekWidgetByName(root, "Panel_button_14") 
		local fj001Button = ccui.Helper:seekWidgetByName(root, "Button_fj001")
		if Panel_button_14 ~= nil and fj001Button ~= nil then 
			Panel_button_14:setVisible(true)
			fwin:addTouchEventListener(fj001Button, nil, 
			{
				terminal_name = "prop_list_cellprop_to_resolve",
				_cell = self,
				terminal_state = 0, 
				isPressedActionEnabled = true
			}, nil, 0)
			
		end
	elseif bEnable == 12 then 
		if _ED.union.union_info ~= nil and zstring.tonumber(_ED.union.union_info.union_id) > 0 then 
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_use"), nil, 
			{
				terminal_name = "prop_list_cell_request_prop_use_checkup", 	
				next_terminal_name = "prop_list_cell_request_prop_use_checkup", 			
				current_button_name = "Button_use", 		
				but_image = "", 	
				_cell = self,
				terminal_state = 0, 
				isPressedActionEnabled = true
			}, 
			nil, 0)
		else
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_use"), nil, 
			{
				func_string = [[TipDlg.drawTextDailog(tipStringInfo_union_str[72])]],
				terminal_state = 0, 
				isPressedActionEnabled = true
			}, 
			nil, 0)
		end
		ccui.Helper:seekWidgetByName(root, "Panel_button_3"):setVisible(true)
	elseif bEnable == 13 then 
		local Panel_button_15 = ccui.Helper:seekWidgetByName(root, "Panel_button_15") 
		local qsxButton = ccui.Helper:seekWidgetByName(root, "Button_qsx")
		if Panel_button_15 ~= nil and qsxButton ~= nil then 
			Panel_button_15:setVisible(true)
			fwin:addTouchEventListener(qsxButton, nil, 
			{
				terminal_name = "prop_list_cellprop_to_pet_list",
				_cell = self,
				terminal_state = 0, 
				isPressedActionEnabled = true
			}, nil, 0)
			
		end
	elseif bEnable == 14 then
		local Panel_button_16 = ccui.Helper:seekWidgetByName(root, "Panel_button_16") 
		local Button_qqh = ccui.Helper:seekWidgetByName(root, "Button_qqh")
		if Panel_button_16 ~= nil and Button_qqh ~= nil then 
			Panel_button_16:setVisible(true)
			fwin:addTouchEventListener(Button_qqh, nil, 
			{
				terminal_name = "prop_list_cellprop_to_pet_list",
				_cell = self,
				terminal_state = 0, 
				isPressedActionEnabled = true
			}, nil, 0)
			
		end
	elseif bEnable == 15 then
		local Panel_button_17 = ccui.Helper:seekWidgetByName(root, "Panel_button_17") 
		local qxlButton = ccui.Helper:seekWidgetByName(root, "Button_qxl")
		if Panel_button_17 ~= nil and qxlButton ~= nil then 
			Panel_button_17:setVisible(true)
			fwin:addTouchEventListener(qxlButton, nil, 
			{
				terminal_name = "prop_list_cellprop_to_pet_list",
				_cell = self,
				terminal_state = 0, 
				isPressedActionEnabled = true
			}, nil, 0)
			
		end
	end
	
	self:onUpdateDraw()
end

function PropListCell:close( ... )
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
        or __lua_project_id == __lua_project_red_alert 
        or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
        or __lua_project_id == __lua_project_yugioh
        or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
        or __lua_project_id == __lua_project_warship_girl_b 
        then
		local iconPanel = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_props")
		iconPanel:removeAllChildren(true)
	end
end

function PropListCell:onExit()
	-- -- state_machine.remove("prop_list_cell_request_prop_use")
	-- state_machine.remove("prop_list_cellprop_to_hero_storage")
	-- state_machine.remove("prop_list_cellprop_to_equip_storage")
	-- state_machine.remove("prop_list_cellprop_to_treasure_storage")
	-- state_machine.remove("prop_list_cellprop_to_mingxing")
	-- state_machine.remove("prop_list_cell_prop_use_manager")
	-- state_machine.remove("prop_list_cellprop_to_zhaojiang")
	-- state_machine.remove("prop_list_cellprop_to_factroy")
	-- state_machine.remove("prop_list_cellprop_update_num")
	local root = self.roots[1]
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		local iconPanel = ccui.Helper:seekWidgetByName(root, "Panel_props")
		iconPanel:removeAllChildren(true)
	end
	cacher.freeRef("list/list_property_1.csb", self.roots[1])
end

function PropListCell:init(interfaceType, prop, drawIndex)
	self.current_type = interfaceType
	self.prop = prop
	self.drawIndex = drawIndex

	-- -- if PropListCell.__size ~= nil and drawIndex > 5 then
	-- -- 	self:setContentSize(PropListCell.__size)
	-- -- 	self._duration = 0.01 + (drawIndex - 1) * 0.12
	-- -- 	self:registerOnNoteUpdate(self, self._duration)
	-- -- else
	-- -- 	self:onInit()
	-- -- 	self:setContentSize(PropListCell.__size)
	-- -- end
	-- self:onInit()
	-- self:setContentSize(PropListCell.__size)

	-- local root = self.roots[1]
	
	-- -- 列表控件动画播放
	-- local action = csb.createTimeline("list/list_property_1.csb")
	-- table.insert(self.actions, action)
 --    root:runAction(action)
	-- if drawIndex == nil or drawIndex > 5 then
	--     action:play("list_view_cell_open", false)
	-- else
	-- 	self._duration = 0.0001 + (drawIndex - 1) * 0.07
	-- 	self:registerOnNoteUpdate(self, self._duration)
	-- end

	-- return self

	if drawIndex ~= nil and drawIndex < 8 then
		self:onInit()
	end

	self:setContentSize(PropListCell.__size)
	return self
end

function PropListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function PropListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		local iconPanel = ccui.Helper:seekWidgetByName(root, "Panel_props")
		iconPanel:removeAllChildren(true)
	end
	cacher.freeRef("list/list_property_1.csb", root)
	-- local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_ls_1")
	-- ListViewDraw:removeAllItems()
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function PropListCell:createCell()
	local cell = PropListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

